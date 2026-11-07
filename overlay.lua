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
    ["rbxassetid://137637490639925"] = {name = "Royal Mistletroll", prices = {["default"] = 1397.57, ["Ride"] = 1312.5, ["Fly|Ride"] = 2095.29, ["Neon"] = 9187.5, ["Neon|Fly|Ride"] = 3921.75, ["Mega|Fly|Ride"] = 25146.42}},
    ["rbxassetid://140355753768438"] = {name = "Moonbeam Peacock", prices = {["default"] = 459.27, ["Fly"] = 622.58, ["Ride"] = 457.68, ["Fly|Ride"] = 524.87, ["Neon"] = 2095.29, ["Neon|Fly|Ride"] = 2072.43, ["Mega|Fly|Ride"] = 9006.62}},
    ["rbxassetid://18117855573"] = {name = "Balloon Unicorn", prices = {["default"] = 4724.99, ["Ride"] = 4545.95, ["Fly|Ride"] = 4592.44, ["Neon|Fly|Ride"] = 15749.99, ["Mega|Fly|Ride"] = 68873.94}},
    ["rbxassetid://75782719698946"] = {name = "Red Dutch Guinea Pig", prices = {["default"] = 128.63, ["Ride"] = 175.88, ["Fly|Ride"] = 276.59, ["Neon"] = 831.85, ["Neon|Ride"] = 821.63, ["Neon|Fly|Ride"] = 786.59, ["Mega"] = 4051.72, ["Mega|Fly|Ride"] = 2887.5}},
    ["rbxassetid://5067924142"] = {name = "Albino Monkey", prices = {["default"] = 555.51, ["Fly"] = 656.88, ["Ride"] = 539.44, ["Fly|Ride"] = 531.57, ["Neon|Ride"] = 1837.5, ["Neon|Fly|Ride"] = 1534.32, ["Mega|Fly|Ride"] = 6300}},
    ["rbxassetid://108312620331321"] = {name = "Villain Gibbon", prices = {["default"] = 10.49, ["Ride"] = 35.63, ["Fly|Ride"] = 140.39, ["Neon"] = 65.63, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 279.78, ["Mega"] = 275.13, ["Mega|Ride"] = 470.38, ["Mega|Fly|Ride"] = 471.72}},
    ["rbxassetid://17255958862"] = {name = "Alicorn", prices = {["default"] = 5.2, ["Fly"] = 34.37, ["Ride"] = 32.66, ["Fly|Ride"] = 59.05, ["Neon"] = 34.94, ["Neon|Fly"] = 110.01, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 72.19, ["Mega"] = 338.46, ["Mega|Fly"] = 273.6, ["Mega|Ride"] = 245.19, ["Mega|Fly|Ride"] = 279.78}},
    ["rbxassetid://90170598608675"] = {name = "Moonbeam Butterfly", prices = {["default"] = 96.48, ["Fly"] = 195.92, ["Ride"] = 111.06, ["Fly|Ride"] = 182.44, ["Neon"] = 521.06, ["Neon|Ride"] = 552.13, ["Neon|Fly|Ride"] = 525, ["Mega"] = 1886.83, ["Mega|Fly|Ride"] = 2305.1}},
    ["rbxassetid://7126722445"] = {name = "Goldhorn", prices = {["default"] = 31.48, ["Fly"] = 140.33, ["Ride"] = 41.89, ["Fly|Ride"] = 59.07, ["Neon"] = 336.59, ["Neon|Ride"] = 204.75, ["Neon|Fly|Ride"] = 277.09, ["Mega"] = 1397.74, ["Mega|Ride"] = 1061.36, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://13186021971"] = {name = "Cuddly Candle", prices = {["default"] = 30.09, ["Fly"] = 29.7, ["Ride"] = 36.74, ["Fly|Ride"] = 78.74, ["Neon"] = 140.39, ["Neon|Ride"] = 165.38, ["Neon|Fly|Ride"] = 229.68, ["Mega|Fly|Ride"] = 626.07}},
    ["rbxassetid://14146196672"] = {name = "Gargoyle", prices = {["default"] = 42.86, ["Fly"] = 124.68, ["Ride"] = 61.69, ["Fly|Ride"] = 117.92, ["Neon"] = 314.84, ["Neon|Ride"] = 235.83, ["Neon|Fly|Ride"] = 262.5, ["Mega|Fly|Ride"] = 1494.13}},
    ["rbxassetid://129762233626342"] = {name = "Royal Moon Egg", prices = {["default"] = 68.24}},
    ["rbxassetid://89693546199400"] = {name = "Cupid Dragon", prices = {["default"] = 379.21, ["Fly"] = 399, ["Ride"] = 351.75, ["Fly|Ride"] = 401.63, ["Neon|Ride"] = 1415.13, ["Neon|Fly|Ride"] = 1171.09, ["Mega|Fly|Ride"] = 4659.38}},
    ["rbxassetid://8665606875"] = {name = "Dancing Dragon", prices = {["default"] = 105, ["Fly"] = 131.25, ["Ride"] = 111.57, ["Fly|Ride"] = 140.51, ["Neon|Ride"] = 564.38, ["Neon|Fly|Ride"] = 483, ["Mega|Fly|Ride"] = 2626.77}},
    ["rbxassetid://110411427278536"] = {name = "Huntsman Robin", prices = {["default"] = 3.29, ["Fly"] = 115.91, ["Ride"] = 49.97, ["Fly|Ride"] = 209.54, ["Neon"] = 24.91, ["Neon|Ride"] = 65.63, ["Mega"] = 141.7, ["Mega|Ride"] = 189, ["Mega|Fly|Ride"] = 349.97}},
    ["rbxassetid://10925517718"] = {name = "Lava Dragon", prices = {["default"] = 140.4, ["Fly"] = 196.88, ["Ride"] = 157.5, ["Fly|Ride"] = 194.25, ["Neon|Ride"] = 459.38, ["Neon|Fly|Ride"] = 591.94, ["Mega|Fly|Ride"] = 1903.13}},
    ["rbxassetid://4797806482"] = {name = "Diamond Griffin", prices = {["default"] = 3.81, ["Fly"] = 27.13, ["Ride"] = 13.13, ["Fly|Ride"] = 34.2, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 262.5, ["Mega|Ride"] = 326.82, ["Mega|Fly|Ride"] = 305.82}},
    ["rbxassetid://122648024705835"] = {name = "Scarebear", prices = {["default"] = 72.19, ["Fly"] = 262.5, ["Ride"] = 87.28, ["Fly|Ride"] = 167.64, ["Neon"] = 249.37, ["Neon|Ride"] = 264.27, ["Neon|Fly|Ride"] = 448.32, ["Mega"] = 1385.95, ["Mega|Ride"] = 940.91, ["Mega|Fly|Ride"] = 1041.24}},
    ["rbxassetid://13104102169"] = {name = "Danger Egg", prices = {["default"] = 46.11}},
    ["rbxassetid://133163961974577"] = {name = "2D Doggy", prices = {["default"] = 76.13, ["Ride"] = 131.25, ["Fly|Ride"] = 218.12, ["Neon"] = 838.13, ["Neon|Fly|Ride"] = 2362.5}},
    ["rbxassetid://126071806166898"] = {name = "Evil Chick", prices = {["default"] = 11.82, ["Fly"] = 393.75, ["Ride"] = 32.36, ["Fly|Ride"] = 78.75, ["Neon"] = 144.38, ["Neon|Ride"] = 343.98, ["Neon|Fly|Ride"] = 192.8, ["Mega"] = 698.87, ["Mega|Ride"] = 564.38, ["Mega|Fly|Ride"] = 1676.45}},
    ["rbxassetid://5721843247"] = {name = "Dodo", prices = {["default"] = 30.14, ["Fly"] = 64.31, ["Ride"] = 49.87, ["Fly|Ride"] = 125.97, ["Neon"] = 235.83, ["Neon|Fly"] = 312.21, ["Neon|Ride"] = 221.81, ["Neon|Fly|Ride"] = 236.15, ["Mega"] = 1650.97, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://119640582603552"] = {name = "Violet Butterfly", prices = {["default"] = 38.59, ["Fly"] = 413.83, ["Ride"] = 189, ["Fly|Ride"] = 138.3, ["Neon"] = 204.75, ["Neon|Fly"] = 391.48, ["Neon|Ride"] = 186.17, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 823.56, ["Mega|Ride"] = 1253.14, ["Mega|Fly|Ride"] = 1101.44}},
    ["rbxassetid://16088264958"] = {name = "Volcanic Rhino", prices = {["default"] = 41.92, ["Ride"] = 56.49, ["Fly|Ride"] = 129.29, ["Neon"] = 141.5, ["Neon|Ride"] = 291.25, ["Neon|Fly|Ride"] = 287.07, ["Mega"] = 1207.92, ["Mega|Ride"] = 2093.45, ["Mega|Fly|Ride"] = 1240.57}},
    ["rbxassetid://75251818654427"] = {name = "Apple Owl", prices = {["default"] = 53.27, ["Fly"] = 593.6, ["Ride"] = 78.6, ["Fly|Ride"] = 158.02, ["Neon|Ride"] = 309.74, ["Mega|Ride"] = 974.58, ["Mega|Fly|Ride"] = 943.69}},
    ["rbxassetid://3181727433"] = {name = "Dragon", prices = {["default"] = 6.48, ["Fly"] = 31.5, ["Ride"] = 18.38, ["Fly|Ride"] = 40.68, ["Neon"] = 31.06, ["Neon|Fly"] = 57.74, ["Neon|Ride"] = 44.63, ["Neon|Fly|Ride"] = 86.61, ["Mega"] = 159.5, ["Mega|Fly"] = 223.13, ["Mega|Ride"] = 140.42, ["Mega|Fly|Ride"] = 242.82}},
    ["rbxassetid://121496682360324"] = {name = "Sugar Axolotl", prices = {["default"] = 341.01, ["Ride"] = 352.87, ["Fly|Ride"] = 306.46, ["Neon"] = 1853.28, ["Neon|Ride"] = 1689.18, ["Neon|Fly|Ride"] = 1666.88, ["Mega"] = 12573.22, ["Mega|Fly|Ride"] = 7332.94}},
    ["rbxassetid://11694854226"] = {name = "Shetland Pony Light Brown", prices = {["default"] = 14.44, ["Ride"] = 34.32, ["Fly|Ride"] = 105.18, ["Neon"] = 251.45, ["Neon|Ride"] = 406.5, ["Neon|Fly|Ride"] = 427.5, ["Mega|Fly|Ride"] = 895.85}},
    ["rbxassetid://4797806957"] = {name = "Golden Unicorn", prices = {["default"] = 7.6, ["Fly"] = 39.47, ["Ride"] = 19.49, ["Fly|Ride"] = 59.05, ["Neon"] = 28.3, ["Neon|Ride"] = 72.19, ["Neon|Fly|Ride"] = 90.93, ["Mega|Ride"] = 619.5, ["Mega|Fly|Ride"] = 380.63}},
    ["rbxassetid://110822620060051"] = {name = "Frost Phoenix", prices = {["default"] = 110.63, ["Fly"] = 125.73, ["Ride"] = 102.68, ["Fly|Ride"] = 141.5, ["Neon|Ride"] = 728.44, ["Neon|Fly|Ride"] = 434.84, ["Mega"] = 1957.25, ["Mega|Ride"] = 7290.94, ["Mega|Fly|Ride"] = 1886.83}},
    ["rbxassetid://13894724323"] = {name = "Billy Goat", prices = {["default"] = 14.01, ["Fly"] = 32.49, ["Ride"] = 28.28, ["Fly|Ride"] = 115.5, ["Neon"] = 189, ["Neon|Ride"] = 126.18, ["Neon|Fly|Ride"] = 159.81, ["Mega"] = 707.57, ["Mega|Ride"] = 639.15, ["Mega|Fly|Ride"] = 483}},
    ["rbxassetid://123037843357105"] = {name = "Glormy Leo", prices = {["default"] = 182.44, ["Fly"] = 354.12, ["Ride"] = 208.49, ["Fly|Ride"] = 245.17, ["Neon"] = 943.3, ["Neon|Ride"] = 838.13, ["Neon|Fly|Ride"] = 773.07, ["Mega"] = 6286.62, ["Mega|Ride"] = 2887.5, ["Mega|Fly|Ride"] = 2858.63}},
    ["rbxassetid://12479078933"] = {name = "Southeast Asia Egg", prices = {["default"] = 28.3}},
    ["rbxassetid://122739780018633"] = {name = "Quetzalcoatl", prices = {["default"] = 3.94, ["Fly"] = 33.8, ["Ride"] = 24.11, ["Fly|Ride"] = 72.96, ["Neon"] = 23.63, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 55.13, ["Neon|Fly|Ride"] = 154.5, ["Mega"] = 131.25, ["Mega|Fly"] = 282.99, ["Mega|Ride"] = 235.96, ["Mega|Fly|Ride"] = 235.87}},
    ["rbxassetid://70953296065239"] = {name = "Frostbite Bear", prices = {["default"] = 1454.23, ["Fly"] = 5676.57, ["Ride"] = 1575, ["Fly|Ride"] = 1609.97, ["Neon"] = 7021.88, ["Neon|Ride"] = 5906.25, ["Neon|Fly|Ride"] = 6562.5, ["Mega|Ride"] = 53066.72, ["Mega|Fly|Ride"] = 26403.75}},
    ["rbxassetid://14978701948"] = {name = "Scarecrow Crow", prices = {["default"] = 9.18, ["Fly"] = 69.13, ["Ride"] = 34.13, ["Fly|Ride"] = 90.12, ["Neon"] = 104.42, ["Neon|Ride"] = 140.39, ["Neon|Fly|Ride"] = 141.52, ["Mega"] = 511.88, ["Mega|Ride"] = 623.44, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://11191341630"] = {name = "Jousting Horse", prices = {["default"] = 104.89, ["Ride"] = 146.21, ["Fly|Ride"] = 249.38, ["Neon"] = 721.88, ["Neon|Ride"] = 689.07, ["Neon|Fly|Ride"] = 993.29, ["Mega|Ride"] = 2723.16, ["Mega|Fly|Ride"] = 2749.36}},
    ["rbxassetid://76801905892592"] = {name = "Royal Aztec Egg", prices = {["default"] = 40.69}},
    ["rbxassetid://98801943598121"] = {name = "Priceless Shrimp", prices = {["default"] = 18.89, ["Fly"] = 68.85, ["Ride"] = 56.59, ["Fly|Ride"] = 140.34, ["Neon"] = 257.07, ["Neon|Ride"] = 206.07, ["Neon|Fly|Ride"] = 472.5, ["Mega"] = 689.87, ["Mega|Fly|Ride"] = 707.57}},
    ["rbxassetid://95214789806437"] = {name = "Aztec Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://18515755354"] = {name = "Cheetah", prices = {["default"] = 118.13, ["Ride"] = 209.54, ["Fly|Ride"] = 205.65, ["Neon"] = 525, ["Neon|Ride"] = 614.98, ["Neon|Fly|Ride"] = 656.96, ["Mega"] = 2794.4, ["Mega|Fly|Ride"] = 2202.87}},
    ["rbxassetid://18117855114"] = {name = "Corn Doggo", prices = {["default"] = 123.38, ["Ride"] = 170.63, ["Fly|Ride"] = 236.25, ["Neon"] = 448.41, ["Neon|Ride"] = 366.19, ["Neon|Fly|Ride"] = 640.5, ["Mega"] = 1575, ["Mega|Ride"] = 1509.38, ["Mega|Fly|Ride"] = 1730}},
    ["rbxassetid://8972175010"] = {name = "Woodland Egg", prices = {["default"] = 39.38}},
    ["rbxassetid://3710823011"] = {name = "Golden Penguin", prices = {["default"] = 65.5, ["Fly"] = 98.44, ["Ride"] = 63.7, ["Fly|Ride"] = 65.61, ["Neon"] = 601.36, ["Neon|Ride"] = 400.96, ["Neon|Fly|Ride"] = 262.48, ["Mega"] = 4191.09, ["Mega|Fly|Ride"] = 1509.37}},
    ["rbxassetid://136490701345923"] = {name = "Glormy Crab", prices = {["default"] = 7.3, ["Ride"] = 39.38, ["Fly|Ride"] = 158.21, ["Neon"] = 37.7, ["Neon|Ride"] = 67.06, ["Neon|Fly|Ride"] = 233.67, ["Mega"] = 140.42, ["Mega|Fly"] = 267.75, ["Mega|Ride"] = 187.69, ["Mega|Fly|Ride"] = 398.06}},
    ["rbxassetid://14782580581"] = {name = "Vampire Dragon", prices = {["default"] = 380.62, ["Fly"] = 400.32, ["Ride"] = 406.88, ["Fly|Ride"] = 433.12, ["Neon|Ride"] = 1568.73, ["Neon|Fly|Ride"] = 1181.24, ["Mega|Fly|Ride"] = 6116.25}},
    ["rbxassetid://88405494856204"] = {name = "Solaris", prices = {["default"] = 78.75, ["Fly"] = 99.75, ["Ride"] = 91.88, ["Fly|Ride"] = 140.39, ["Neon"] = 413.82, ["Neon|Ride"] = 393.84, ["Neon|Fly|Ride"] = 393.74, ["Mega|Ride"] = 1885.99, ["Mega|Fly|Ride"] = 1953.06}},
    ["rbxassetid://84468510887759"] = {name = "Orchid Butterfly", prices = {["default"] = 3184.13, ["Fly"] = 3543.75, ["Ride"] = 3433.5, ["Fly|Ride"] = 3018.74, ["Neon|Fly|Ride"] = 14667.71}},
    ["rbxassetid://11109286837"] = {name = "Lava Wolf", prices = {["default"] = 28.88, ["Fly"] = 112.11, ["Ride"] = 57.75, ["Fly|Ride"] = 103.73, ["Neon"] = 392.44, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 314.25, ["Mega|Ride"] = 1628.25, ["Mega|Fly|Ride"] = 1440.69}},
    ["rbxassetid://12403863809"] = {name = "Albino Gorilla", prices = {["default"] = 78.75, ["Ride"] = 57.74, ["Fly|Ride"] = 199.06, ["Neon"] = 656.25, ["Neon|Ride"] = 326.88, ["Neon|Fly|Ride"] = 559.53, ["Mega"] = 6286.62, ["Mega|Fly|Ride"] = 1662.83}},
    ["rbxassetid://6060988121"] = {name = "Snow Owl", prices = {["default"] = 35.44, ["Fly"] = 86.63, ["Ride"] = 62.29, ["Fly|Ride"] = 140.19, ["Neon"] = 211.84, ["Neon|Ride"] = 167.66, ["Neon|Fly|Ride"] = 209.57, ["Mega"] = 2598.75, ["Mega|Ride"] = 680.74, ["Mega|Fly|Ride"] = 831.94}},
    ["rbxassetid://112630556645658"] = {name = "Moon Egg", prices = {["default"] = 7.88}},
    ["rbxassetid://10357473556"] = {name = "Golden Chow-Chow", prices = {["default"] = 37.82, ["Ride"] = 56.39, ["Fly|Ride"] = 72.18, ["Neon"] = 328.13, ["Neon|Ride"] = 480.95, ["Neon|Fly|Ride"] = 502.94, ["Mega|Fly|Ride"] = 1554.91}},
    ["rbxassetid://5721843384"] = {name = "Fossil Egg", prices = {["default"] = 34.46}},
    ["rbxassetid://92775688228060"] = {name = "Papa Moose", prices = {["default"] = 293.35, ["Ride"] = 784.69, ["Fly|Ride"] = 320.59, ["Neon|Ride"] = 1397.57, ["Neon|Fly|Ride"] = 1951.66}},
    ["rbxassetid://12479991588"] = {name = "Frost Unicorn", prices = {["default"] = 918.74, ["Ride"] = 955.5, ["Fly|Ride"] = 945, ["Neon|Fly|Ride"] = 3806.24, ["Mega|Fly|Ride"] = 15716.52}},
    ["rbxassetid://9661880325"] = {name = "Zodiac Minion Egg", prices = {["default"] = 5.41}},
    ["rbxassetid://7126719832"] = {name = "Phoenix", prices = {["default"] = 29.26, ["Fly"] = 52.46, ["Ride"] = 35.62, ["Fly|Ride"] = 64.3, ["Neon"] = 162.75, ["Neon|Fly"] = 209.54, ["Neon|Ride"] = 144.38, ["Neon|Fly|Ride"] = 195.96, ["Mega|Ride"] = 866.16, ["Mega|Fly|Ride"] = 765.19}},
    ["rbxassetid://119386690822810"] = {name = "Royal Fairytale Egg", prices = {["default"] = 11.17}},
    ["rbxassetid://4440866299"] = {name = "Crow", prices = {["default"] = 5063.26, ["Ride"] = 4462.5, ["Fly|Ride"] = 4591.13, ["Neon|Fly|Ride"] = 10827.6, ["Mega|Fly|Ride"] = 35220.98}},
    ["rbxassetid://4797806531"] = {name = "Diamond Unicorn", prices = {["default"] = 10.5, ["Fly"] = 74.65, ["Ride"] = 24.08, ["Fly|Ride"] = 52.49, ["Neon"] = 70.2, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 101.07, ["Mega"] = 525, ["Mega|Ride"] = 629.74, ["Mega|Fly|Ride"] = 582.75}},
    ["rbxassetid://88817325500927"] = {name = "Kraken", prices = {["default"] = 11.73, ["Fly"] = 191.66, ["Ride"] = 33.34, ["Fly|Ride"] = 116.75, ["Neon"] = 131.25, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 178.14, ["Mega"] = 1047.78, ["Mega|Ride"] = 601.43, ["Mega|Fly|Ride"] = 939.87}},
    ["rbxassetid://9490243442"] = {name = "Diamond King Penguin", prices = {["default"] = 110.85, ["Fly"] = 173.93, ["Ride"] = 124.68, ["Fly|Ride"] = 98.1, ["Neon"] = 1397.57, ["Neon|Fly|Ride"] = 459.38, ["Mega"] = 4191.09}},
    ["rbxassetid://107787284008278"] = {name = "Primal Kaijunior", prices = {["default"] = 14.16, ["Ride"] = 28.87, ["Fly|Ride"] = 139.65, ["Neon"] = 55.41, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 501.36, ["Mega"] = 364.64, ["Mega|Ride"] = 419.12, ["Mega|Fly|Ride"] = 559.53}},
    ["rbxassetid://4506837037"] = {name = "Arctic Reindeer", prices = {["default"] = 1968.65, ["Fly"] = 2463.02, ["Ride"] = 1968.75, ["Fly|Ride"] = 1901.81, ["Neon|Fly|Ride"] = 6810.5, ["Mega|Fly|Ride"] = 15080.63}},
    ["rbxassetid://4184878149"] = {name = "Bat Dragon", prices = {["default"] = 30732.51, ["Fly"] = 35216.69, ["Ride"] = 34922.02, ["Fly|Ride"] = 23231.25, ["Neon|Ride"] = 65625, ["Neon|Fly|Ride"] = 64611.75, ["Mega"] = 210000, ["Mega|Fly|Ride"] = 212110.01}},
    ["rbxassetid://118641789458122"] = {name = "Gilded Snake", prices = {["default"] = 14.44, ["Fly"] = 37.73, ["Ride"] = 42, ["Fly|Ride"] = 125.73, ["Neon"] = 249.38, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 257.6, ["Mega"] = 838.13, ["Mega|Ride"] = 1141.88, ["Mega|Fly|Ride"] = 1470}},
    ["rbxassetid://71844856693163"] = {name = "Purrowl", prices = {["default"] = 2.63, ["Fly"] = 59.84, ["Ride"] = 39.38, ["Fly|Ride"] = 70.2, ["Neon"] = 17.46, ["Neon|Fly"] = 98.49, ["Neon|Ride"] = 52.49, ["Neon|Fly|Ride"] = 157.49, ["Mega"] = 169.32, ["Mega|Ride"] = 182.44, ["Mega|Fly|Ride"] = 334.26}},
    ["rbxassetid://7195311687"] = {name = "Mythic Egg", prices = {["default"] = 23.63}},
    ["rbxassetid://102330087609546"] = {name = "Fire Mare", prices = {["default"] = 6.49, ["Ride"] = 52.49, ["Fly|Ride"] = 111.57, ["Neon"] = 32.82, ["Neon|Ride"] = 105.25, ["Neon|Fly|Ride"] = 463.21, ["Mega"] = 415.75, ["Mega|Ride"] = 305.81, ["Mega|Fly|Ride"] = 544.04}},
    ["rbxassetid://16659215347"] = {name = "Candyfloss Chick", prices = {["default"] = 787.5, ["Ride"] = 648.38, ["Fly|Ride"] = 719.25, ["Neon|Ride"] = 2625, ["Neon|Fly|Ride"] = 2625, ["Mega|Fly|Ride"] = 11007.23}},
    ["rbxassetid://9281950769"] = {name = "Sugar Glider", prices = {["default"] = 997.49, ["Fly"] = 900.38, ["Ride"] = 787.5, ["Fly|Ride"] = 959.25, ["Neon"] = 4190.57, ["Neon|Ride"] = 3003.59, ["Neon|Fly|Ride"] = 2778.66, ["Mega|Fly|Ride"] = 11315.91}},
    ["rbxassetid://15485137935"] = {name = "Fleur De Ice", prices = {["default"] = 23.62, ["Fly"] = 117.92, ["Ride"] = 50.71, ["Fly|Ride"] = 85.32, ["Neon"] = 140.39, ["Neon|Ride"] = 274.32, ["Neon|Fly|Ride"] = 220.5, ["Mega"] = 835.11, ["Mega|Ride"] = 682.5, ["Mega|Fly|Ride"] = 810.99}},
    ["rbxassetid://6498256269"] = {name = "Ocean Egg", prices = {["default"] = 19.68}},
    ["rbxassetid://8704877940"] = {name = "Lavender Dragon", prices = {["default"] = 78.54, ["Fly"] = 111.56, ["Ride"] = 74.82, ["Fly|Ride"] = 132.57, ["Neon|Ride"] = 355.6, ["Neon|Fly|Ride"] = 410.82, ["Mega|Fly|Ride"] = 1800.08}},
    ["rbxassetid://13685038182"] = {name = "Leviathan", prices = {["default"] = 54.33, ["Ride"] = 114.85, ["Fly|Ride"] = 188.67, ["Neon"] = 450.19, ["Neon|Ride"] = 629.66, ["Neon|Fly|Ride"] = 553.88, ["Mega"] = 1758.17, ["Mega|Fly|Ride"] = 1695.15}},
    ["rbxassetid://4797806358"] = {name = "Diamond Dragon", prices = {["default"] = 3.72, ["Fly"] = 32.8, ["Ride"] = 21.24, ["Fly|Ride"] = 56.44, ["Neon"] = 28.13, ["Neon|Fly"] = 314.84, ["Neon|Ride"] = 77.44, ["Neon|Fly|Ride"] = 140.42, ["Mega"] = 157.5, ["Mega|Ride"] = 398.18, ["Mega|Fly|Ride"] = 362.25}},
    ["rbxassetid://5862774327"] = {name = "Cerberus", prices = {["default"] = 74.81, ["Fly"] = 85.31, ["Ride"] = 107.73, ["Fly|Ride"] = 140.51, ["Neon"] = 810.9, ["Neon|Ride"] = 314.99, ["Neon|Fly|Ride"] = 314.99, ["Mega|Fly|Ride"] = 1200.04}},
    ["rbxassetid://74012786571707"] = {name = "Three Blind Mice", prices = {["default"] = 3.89, ["Ride"] = 44.01, ["Fly|Ride"] = 98.44, ["Neon"] = 23.63, ["Neon|Ride"] = 112.87, ["Neon|Fly|Ride"] = 183.74, ["Mega"] = 229.91, ["Mega|Ride"] = 210, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://15931348363"] = {name = "Criosphinx", prices = {["default"] = 17.06, ["Fly"] = 40.28, ["Ride"] = 32.82, ["Fly|Ride"] = 65.62, ["Neon"] = 91.88, ["Neon|Fly"] = 126.18, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 204.33, ["Mega"] = 740.79, ["Mega|Fly|Ride"] = 698.87}},
    ["rbxassetid://118278167134251"] = {name = "Influencer Gibbon", prices = {["default"] = 25.71, ["Ride"] = 63.7, ["Fly|Ride"] = 156.19, ["Neon"] = 237.57, ["Neon|Ride"] = 349.04, ["Mega"] = 694.25, ["Mega|Ride"] = 550.73, ["Mega|Fly|Ride"] = 871.68}},
    ["rbxassetid://17059982206"] = {name = "Dimorphodon", prices = {["default"] = 17.06, ["Fly"] = 83.83, ["Ride"] = 31.02, ["Fly|Ride"] = 82.69, ["Neon"] = 103.69, ["Neon|Fly"] = 559.46, ["Neon|Ride"] = 123.63, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 1047.78, ["Mega|Ride"] = 934.63, ["Mega|Fly|Ride"] = 947.63}},
    ["rbxassetid://119212313534429"] = {name = "Giant Panda", prices = {["default"] = 5118.75, ["Ride"] = 7074.72, ["Fly|Ride"] = 5683.13, ["Neon"] = 34921.69, ["Neon|Fly|Ride"] = 27802.51}},
    ["rbxassetid://6060998707"] = {name = "Frost Fury", prices = {["default"] = 215.25, ["Fly"] = 210, ["Ride"] = 223.13, ["Fly|Ride"] = 295.32, ["Neon"] = 681.55, ["Neon|Ride"] = 551.24, ["Neon|Fly|Ride"] = 502.38, ["Mega|Fly|Ride"] = 1860.98}},
    ["rbxassetid://88882779021298"] = {name = "Kitty Bat", prices = {["default"] = 28.3, ["Fly"] = 125.73, ["Ride"] = 63.7, ["Fly|Ride"] = 128.64, ["Neon"] = 88.45, ["Neon|Fly"] = 140.39, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 196.87, ["Mega"] = 335.69, ["Mega|Fly"] = 559.53, ["Mega|Ride"] = 339.66, ["Mega|Fly|Ride"] = 417.56}},
    ["rbxassetid://16441372760"] = {name = "Diamond Mahi Mahi", prices = {["default"] = 3.94, ["Ride"] = 24.05, ["Fly|Ride"] = 98.49, ["Neon"] = 28.88, ["Neon|Ride"] = 56.59, ["Neon|Fly|Ride"] = 94.35, ["Mega"] = 173.95, ["Mega|Ride"] = 170.63}},
    ["rbxassetid://3199974169"] = {name = "Royal Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://84714602656867"] = {name = "Slimingo", prices = {["default"] = 35.44, ["Fly"] = 5285.81, ["Ride"] = 101.4, ["Fly|Ride"] = 173.71, ["Neon"] = 116.82, ["Neon|Fly"] = 324.78, ["Neon|Ride"] = 126.18, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 435.74, ["Mega|Ride"] = 449.07, ["Mega|Fly|Ride"] = 582.63}},
    ["rbxassetid://3409443710"] = {name = "Giraffe", prices = {["default"] = 12810, ["Ride"] = 10290, ["Fly|Ride"] = 10847.82, ["Neon|Fly|Ride"] = 23625, ["Mega|Fly|Ride"] = 90806.85}},
    ["rbxassetid://121215031043780"] = {name = "Velocirooster", prices = {["default"] = 177.9, ["Ride"] = 223.13, ["Fly|Ride"] = 288.11, ["Neon"] = 1313.75, ["Neon|Ride"] = 1537.09, ["Neon|Fly|Ride"] = 943.69, ["Mega|Fly|Ride"] = 4680.39}},
    ["rbxassetid://5067925034"] = {name = "Ninja Monkey", prices = {["default"] = 69.04, ["Fly"] = 158.02, ["Ride"] = 69.08, ["Fly|Ride"] = 65.63, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 372.91, ["Mega|Fly|Ride"] = 2044.85}},
    ["rbxassetid://10618035564"] = {name = "Baku", prices = {["default"] = 10.49, ["Fly"] = 44.82, ["Ride"] = 22.32, ["Fly|Ride"] = 54.88, ["Neon"] = 62.87, ["Neon|Ride"] = 78.74, ["Neon|Fly|Ride"] = 118.12, ["Mega"] = 2514.65, ["Mega|Ride"] = 349.97, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://13665641282"] = {name = "Shark Puppy", prices = {["default"] = 353.62, ["Fly"] = 838.13, ["Ride"] = 417.38, ["Fly|Ride"] = 469.63, ["Neon"] = 1639.31, ["Neon|Ride"] = 1311.19, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Ride"] = 4724.98, ["Mega|Fly|Ride"] = 4935}},
    ["rbxassetid://119447343321908"] = {name = "Tealwood Monster", prices = {["default"] = 6.26, ["Fly"] = 65.63, ["Ride"] = 31.5, ["Fly|Ride"] = 163.45, ["Neon"] = 28.09, ["Neon|Ride"] = 64.32, ["Neon|Fly|Ride"] = 315, ["Mega"] = 188.69, ["Mega|Ride"] = 629.74, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://85568505745239"] = {name = "Latte Kitsune", prices = {["default"] = 205.15, ["Fly"] = 299.51, ["Ride"] = 229.69, ["Fly|Ride"] = 315, ["Neon"] = 787.5, ["Neon|Ride"] = 940.79, ["Neon|Fly|Ride"] = 978.63, ["Mega|Fly|Ride"] = 3129.7}},
    ["rbxassetid://3181727727"] = {name = "Griffin", prices = {["default"] = 11.66, ["Fly"] = 19.92, ["Ride"] = 22.42, ["Fly|Ride"] = 39.37, ["Neon|Ride"] = 196.87, ["Neon|Fly|Ride"] = 101.6, ["Mega"] = 2514.65, ["Mega|Fly|Ride"] = 682.5}},
    ["rbxassetid://4822753215"] = {name = "Golden Egg", prices = {["default"] = 9.19}},
    ["rbxassetid://116463571924920"] = {name = "Prismatic Butterfly", prices = {["default"] = 61.67, ["Ride"] = 167.64, ["Fly|Ride"] = 158.02, ["Neon"] = 367.5, ["Neon|Fly"] = 1676.24, ["Neon|Ride"] = 418.02, ["Neon|Fly|Ride"] = 786.59, ["Mega|Ride"] = 1257.33, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://8596153183"] = {name = "Chameleon", prices = {["default"] = 14.44, ["Ride"] = 39.38, ["Fly|Ride"] = 86.51, ["Neon"] = 74.41, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 501.89, ["Mega|Ride"] = 498.75, ["Mega|Fly|Ride"] = 616.1}},
    ["rbxassetid://110774856122162"] = {name = "Gemstone Egg", prices = {["default"] = 17.72}},
    ["rbxassetid://14892649590"] = {name = "Dire Stag", prices = {["default"] = 30.19, ["Fly"] = 111.57, ["Ride"] = 76.59, ["Fly|Ride"] = 105, ["Neon"] = 194.87, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 313.29, ["Mega"] = 775.36, ["Mega|Ride"] = 907.38, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://106744890070136"] = {name = "Oakee Wizard", prices = {["default"] = 3.55, ["Fly|Ride"] = 131.25, ["Neon"] = 28.29, ["Neon|Ride"] = 106.14, ["Neon|Fly|Ride"] = 132.04, ["Mega"] = 131.25, ["Mega|Fly|Ride"] = 635.92}},
    ["rbxassetid://9938967576"] = {name = "Chocolate Chow-Chow", prices = {["default"] = 17.7, ["Fly"] = 70.2, ["Ride"] = 31.5, ["Fly|Ride"] = 60.38, ["Neon|Ride"] = 129.94, ["Neon|Fly|Ride"] = 224.24, ["Mega|Ride"] = 489.33, ["Mega|Fly|Ride"] = 817.27}},
    ["rbxassetid://9174893483"] = {name = "Mechapup", prices = {["default"] = 350.43, ["Ride"] = 380.38, ["Fly|Ride"] = 522.79, ["Neon|Fly|Ride"] = 2655.06, ["Mega|Fly|Ride"] = 8067.83}},
    ["rbxassetid://15292843858"] = {name = "Mecha Meow", prices = {["default"] = 131.24, ["Fly"] = 104.78, ["Ride"] = 77.3, ["Fly|Ride"] = 87.93, ["Neon"] = 349.88, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 296, ["Mega"] = 718.86, ["Mega|Ride"] = 681.45, ["Mega|Fly|Ride"] = 733.46}},
    ["rbxassetid://15931200262"] = {name = "Cactus Friend", prices = {["default"] = 48.03, ["Fly"] = 91.14, ["Ride"] = 66.22, ["Neon"] = 188.67, ["Neon|Ride"] = 212.25, ["Neon|Fly|Ride"] = 339.94, ["Mega|Ride"] = 1050, ["Mega|Fly|Ride"] = 1246.86}},
    ["rbxassetid://127221459636244"] = {name = "Strawberry Shortcake Ducky", prices = {["default"] = 32.46, ["Ride"] = 78.74, ["Fly|Ride"] = 148.58, ["Neon"] = 100.83, ["Neon|Ride"] = 165.55, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 393.75, ["Mega|Ride"] = 405.57, ["Mega|Fly|Ride"] = 511.88}},
    ["rbxassetid://4470748644"] = {name = "Frost Dragon", prices = {["default"] = 11287.5, ["Fly"] = 9948.75, ["Ride"] = 9995.9, ["Fly|Ride"] = 7871.07, ["Neon|Fly|Ride"] = 14306.25, ["Mega|Fly|Ride"] = 39372.9}},
    ["rbxassetid://15365667976"] = {name = "Chocolate Chip Bat Dragon", prices = {["default"] = 1968.65, ["Ride"] = 1740.38, ["Fly|Ride"] = 1509.33, ["Neon"] = 6131.42, ["Neon|Ride"] = 5727.46, ["Neon|Fly|Ride"] = 5346.78}},
    ["rbxassetid://16898343164"] = {name = "Pirate Ghost Capuchin Monkey", prices = {["default"] = 392.43, ["Ride"] = 464.16, ["Fly|Ride"] = 489.26, ["Neon"] = 2095.29, ["Neon|Fly|Ride"] = 2069.36, ["Mega"] = 11792.61, ["Mega|Fly|Ride"] = 6762.3}},
    ["rbxassetid://6404812772"] = {name = "Golden Ladybug", prices = {["default"] = 15.72, ["Fly"] = 30.09, ["Ride"] = 20.99, ["Fly|Ride"] = 45.82, ["Neon"] = 111.57, ["Neon|Ride"] = 91.17, ["Neon|Fly|Ride"] = 137.82, ["Mega|Fly|Ride"] = 419.12}},
    ["rbxassetid://95029455226760"] = {name = "Easter Bunny", prices = {["default"] = 4.74, ["Fly"] = 31.5, ["Ride"] = 150.04, ["Fly|Ride"] = 124.67, ["Neon"] = 24.93, ["Neon|Ride"] = 69.17, ["Neon|Fly|Ride"] = 157.47, ["Mega"] = 166.04, ["Mega|Ride"] = 189.08, ["Mega|Fly|Ride"] = 270.9}},
    ["rbxassetid://5307473113"] = {name = "Kitsune", prices = {["default"] = 39.33, ["Fly"] = 40.69, ["Ride"] = 40.69, ["Fly|Ride"] = 90.15, ["Neon|Ride"] = 151.47, ["Neon|Fly|Ride"] = 158.04, ["Mega"] = 628.67, ["Mega|Fly|Ride"] = 511.88}},
    ["rbxassetid://4797806780"] = {name = "Golden Dragon", prices = {["default"] = 3.59, ["Fly"] = 20.79, ["Ride"] = 13.13, ["Fly|Ride"] = 31.5, ["Neon"] = 25.11, ["Neon|Fly"] = 63.7, ["Neon|Ride"] = 54.49, ["Neon|Fly|Ride"] = 95.63, ["Mega"] = 152.99, ["Mega|Ride"] = 206.07, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://135649428081307"] = {name = "Sakura Spirit", prices = {["default"] = 291.89, ["Fly"] = 320.25, ["Ride"] = 294.08, ["Fly|Ride"] = 372.75, ["Neon|Ride"] = 1856.16, ["Neon|Fly|Ride"] = 1250.03, ["Mega|Fly|Ride"] = 6286.62}},
    ["rbxassetid://11109110190"] = {name = "White Amazon", prices = {["default"] = 26.25, ["Fly"] = 53.41, ["Ride"] = 37.89, ["Fly|Ride"] = 59.07, ["Neon"] = 125.73, ["Neon|Fly"] = 167.64, ["Neon|Ride"] = 156.96, ["Neon|Fly|Ride"] = 196.88, ["Mega|Ride"] = 582.75, ["Mega|Fly|Ride"] = 597.91}},
    ["rbxassetid://9475753542"] = {name = "Golden Albatross", prices = {["default"] = 11.66, ["Fly"] = 23.59, ["Ride"] = 25.96, ["Fly|Ride"] = 47.16, ["Neon"] = 52.5, ["Neon|Fly"] = 134.44, ["Neon|Ride"] = 81.38, ["Neon|Fly|Ride"] = 115.77, ["Mega"] = 1575, ["Mega|Ride"] = 618.19, ["Mega|Fly|Ride"] = 426.57}},
    ["rbxassetid://12778628831"] = {name = "Emperor Gorilla", prices = {["default"] = 392.43, ["Fly"] = 787.5, ["Ride"] = 393.75, ["Fly|Ride"] = 712.41, ["Neon|Ride"] = 2723.87, ["Mega|Fly|Ride"] = 8619.19}},
    ["rbxassetid://13672542902"] = {name = "Hot Doggo", prices = {["default"] = 1128.65, ["Fly"] = 1397.57, ["Ride"] = 1252.12, ["Fly|Ride"] = 1570.43, ["Neon|Fly|Ride"] = 3570, ["Mega|Fly|Ride"] = 18859.82}},
    ["rbxassetid://8070897995"] = {name = "Ice Golem", prices = {["default"] = 83.06, ["Fly"] = 125.73, ["Ride"] = 90.45, ["Fly|Ride"] = 120.75, ["Neon"] = 971.25, ["Neon|Ride"] = 559.25, ["Neon|Fly|Ride"] = 494.57, ["Mega|Fly|Ride"] = 2572.28}},
    ["rbxassetid://128225904426926"] = {name = "Rose Dragon", prices = {["default"] = 137.24, ["Fly"] = 176.65, ["Ride"] = 152.25, ["Fly|Ride"] = 209.46, ["Neon"] = 556.5, ["Neon|Ride"] = 668.66, ["Neon|Fly|Ride"] = 560.44, ["Mega"] = 5588.8, ["Mega|Ride"] = 8596.88, ["Mega|Fly|Ride"] = 2625}},
    ["rbxassetid://13883274830"] = {name = "Pirate Hermit Crab", prices = {["default"] = 22.32, ["Fly"] = 131.25, ["Ride"] = 47.25, ["Fly|Ride"] = 279.74, ["Neon"] = 180.53, ["Neon|Fly"] = 419.07, ["Neon|Ride"] = 272.99, ["Neon|Fly|Ride"] = 363.59, ["Mega|Ride"] = 838.23, ["Mega|Fly|Ride"] = 1045.69}},
    ["rbxassetid://95213400890066"] = {name = "Diamond Hummingbird", prices = {["default"] = 180.21, ["Ride"] = 208.49, ["Fly|Ride"] = 597.19, ["Neon|Fly|Ride"] = 1320.79, ["Mega|Fly|Ride"] = 2978.82}},
    ["rbxassetid://10453528102"] = {name = "Diamond Butterfly", prices = {["default"] = 2052.74, ["Fly"] = 1990.52, ["Ride"] = 2240.34, ["Fly|Ride"] = 2654.73, ["Neon|Fly|Ride"] = 7122.74, ["Mega|Fly|Ride"] = 48197.3}},
    ["rbxassetid://12778628650"] = {name = "Astronaut Gorilla", prices = {["default"] = 67.06, ["Ride"] = 52.4, ["Fly|Ride"] = 196.87, ["Neon"] = 313.26, ["Neon|Fly"] = 314.31, ["Neon|Ride"] = 559.46, ["Neon|Fly|Ride"] = 237.86, ["Mega"] = 2089.26, ["Mega|Ride"] = 2305.1, ["Mega|Fly|Ride"] = 1886.83}},
    ["rbxassetid://4708551306"] = {name = "Kangaroo", prices = {["default"] = 549.94, ["Fly"] = 733.09, ["Ride"] = 567, ["Fly|Ride"] = 629.99, ["Neon|Ride"] = 1337.14, ["Neon|Fly|Ride"] = 1099.88, ["Mega|Fly|Ride"] = 3094.88}},
    ["rbxassetid://9542440966"] = {name = "Capricorn", prices = {["default"] = 39.38, ["Fly"] = 51.89, ["Ride"] = 59.73, ["Fly|Ride"] = 103.38, ["Neon"] = 196.88, ["Neon|Ride"] = 203.44, ["Neon|Fly|Ride"] = 192.43, ["Mega|Fly|Ride"] = 1038.94}},
    ["rbxassetid://9678195673"] = {name = "Ancient Dragon", prices = {["default"] = 3.41, ["Fly"] = 32.49, ["Ride"] = 19.67, ["Fly|Ride"] = 38.07, ["Neon"] = 31.39, ["Neon|Fly"] = 158.02, ["Neon|Ride"] = 36.73, ["Neon|Fly|Ride"] = 87.94, ["Mega"] = 161.41, ["Mega|Fly"] = 249.38, ["Mega|Ride"] = 181.12, ["Mega|Fly|Ride"] = 234.94}},
    ["rbxassetid://132388343771587"] = {name = "Kelp Captain", prices = {["default"] = 43.64, ["Ride"] = 105, ["Fly|Ride"] = 252, ["Neon"] = 259.87, ["Neon|Ride"] = 262.71, ["Neon|Fly|Ride"] = 559.53, ["Mega|Ride"] = 1397.74, ["Mega|Fly|Ride"] = 824.2}},
    ["rbxassetid://15148532648"] = {name = "Werewolf", prices = {["default"] = 615.57, ["Fly"] = 652.7, ["Ride"] = 622.13, ["Fly|Ride"] = 670.68, ["Neon"] = 2430.53, ["Neon|Ride"] = 1990.52, ["Neon|Fly|Ride"] = 1548.74, ["Mega|Fly|Ride"] = 6636.57}},
    ["rbxassetid://86323568215409"] = {name = "Tortoiseshell Guinea Pig", prices = {["default"] = 511.88, ["Ride"] = 577.5, ["Fly|Ride"] = 698.79, ["Neon"] = 5238.2, ["Neon|Fly|Ride"] = 2625, ["Mega|Fly|Ride"] = 12579.19}},
    ["rbxassetid://5973019152"] = {name = "Robo Dog", prices = {["default"] = 18.38, ["Fly"] = 26.17, ["Ride"] = 23.59, ["Fly|Ride"] = 38.67, ["Neon"] = 209.54, ["Neon|Ride"] = 108.41, ["Neon|Fly|Ride"] = 118.13, ["Mega|Fly|Ride"] = 629.74}},
    ["rbxassetid://7734928470"] = {name = "Halloween Golden Mummy Cat", prices = {["default"] = 6.26, ["Ride"] = 23.59, ["Fly|Ride"] = 62.87, ["Neon"] = 78.75, ["Neon|Ride"] = 56.59, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 1676.45, ["Mega|Ride"] = 349.97, ["Mega|Fly|Ride"] = 378.67}},
    ["rbxassetid://137429532189183"] = {name = "Fire Stallion", prices = {["default"] = 3.9, ["Ride"] = 28.3, ["Fly|Ride"] = 111.44, ["Neon"] = 20.56, ["Neon|Fly"] = 79.01, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 126.19, ["Mega"] = 220.54, ["Mega|Fly"] = 456.39, ["Mega|Ride"] = 220.49, ["Mega|Fly|Ride"] = 330.75}},
    ["rbxassetid://7215324578"] = {name = "Axolotl", prices = {["default"] = 29.3, ["Fly"] = 62.87, ["Ride"] = 49.54, ["Fly|Ride"] = 96.6, ["Neon"] = 183.96, ["Neon|Ride"] = 208.95, ["Neon|Fly|Ride"] = 196.86, ["Mega|Fly|Ride"] = 917.44}},
    ["rbxassetid://111805565268081"] = {name = "Black Widow", prices = {["default"] = 48.36, ["Ride"] = 111.57, ["Fly|Ride"] = 450.19, ["Neon"] = 276.17, ["Neon|Ride"] = 405.45, ["Neon|Fly|Ride"] = 695.63, ["Mega"] = 1569.57, ["Mega|Ride"] = 1571.67, ["Mega|Fly|Ride"] = 1258.28}},
    ["rbxassetid://103653773461193"] = {name = "Sunglider", prices = {["default"] = 14.97, ["Fly"] = 65.63, ["Ride"] = 27.25, ["Fly|Ride"] = 83.99, ["Neon"] = 112.34, ["Neon|Fly"] = 150.94, ["Neon|Ride"] = 94.73, ["Neon|Fly|Ride"] = 183.75, ["Mega|Ride"] = 406.88, ["Mega|Fly|Ride"] = 446.25}},
    ["rbxassetid://6498256069"] = {name = "Shark", prices = {["default"] = 28.49, ["Fly"] = 65.05, ["Ride"] = 39.38, ["Fly|Ride"] = 93.41, ["Neon"] = 209.54, ["Neon|Ride"] = 222.12, ["Neon|Fly|Ride"] = 174.19, ["Mega"] = 2100, ["Mega|Fly|Ride"] = 1179.28}},
    ["rbxassetid://8663440945"] = {name = "Lunar Gold Tiger", prices = {["default"] = 3.94, ["Fly"] = 23.59, ["Ride"] = 19.41, ["Fly|Ride"] = 39.38, ["Neon"] = 32.54, ["Neon|Ride"] = 36.68, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 525, ["Mega|Ride"] = 278.73, ["Mega|Fly|Ride"] = 320.63}},
    ["rbxassetid://94185217299816"] = {name = "Dracula Parrot", prices = {["default"] = 3.94, ["Fly"] = 26.25, ["Ride"] = 27.38, ["Fly|Ride"] = 67.24, ["Neon"] = 27.46, ["Neon|Fly"] = 158.02, ["Neon|Ride"] = 60.74, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 261.95, ["Mega|Fly"] = 475.71, ["Mega|Ride"] = 285.87, ["Mega|Fly|Ride"] = 523.89}},
    ["rbxassetid://4621220431"] = {name = "Golden Rat", prices = {["default"] = 52.4, ["Fly"] = 60.38, ["Ride"] = 64.23, ["Fly|Ride"] = 73.4, ["Neon"] = 409.17, ["Neon|Ride"] = 279.34, ["Neon|Fly|Ride"] = 273, ["Mega|Fly|Ride"] = 919.09}},
    ["rbxassetid://11506045996"] = {name = "Strawberry Shortcake Bat Dragon", prices = {["default"] = 1706.24, ["Fly"] = 2362.5, ["Ride"] = 1828.32, ["Fly|Ride"] = 1819.13, ["Neon|Fly"] = 4952.31, ["Neon|Ride"] = 5232.97, ["Neon|Fly|Ride"] = 3806.24, ["Mega|Fly|Ride"] = 17176.69}},
    ["rbxassetid://11758583912"] = {name = "Winged Tiger", prices = {["default"] = 467.99, ["Fly"] = 559.46, ["Ride"] = 459.37, ["Fly|Ride"] = 513.28, ["Neon"] = 3144.71, ["Neon|Ride"] = 3073.79, ["Neon|Fly|Ride"] = 2362.5, ["Mega|Fly|Ride"] = 9747.4}},
    ["rbxassetid://101160794933271"] = {name = "Matcha Cat", prices = {["default"] = 242.06, ["Ride"] = 259.88, ["Fly|Ride"] = 472.5, ["Neon"] = 1202.53, ["Neon|Ride"] = 1181.25, ["Neon|Fly|Ride"] = 1443.75, ["Mega"] = 7334.39, ["Mega|Fly|Ride"] = 6825}},
    ["rbxassetid://13892790514"] = {name = "Urban Egg", prices = {["default"] = 42.86}},
    ["rbxassetid://13104109574"] = {name = "Spinosaurus", prices = {["default"] = 23.59, ["Ride"] = 51.86, ["Fly|Ride"] = 110.25, ["Neon"] = 266.12, ["Neon|Ride"] = 274.05, ["Neon|Fly|Ride"] = 441.06, ["Mega|Ride"] = 832.99, ["Mega|Fly|Ride"] = 1254.75}},
    ["rbxassetid://4115248712"] = {name = "Shadow Dragon", prices = {["default"] = 33524.46, ["Fly"] = 23625, ["Ride"] = 34781.25, ["Fly|Ride"] = 16232.6, ["Neon|Fly|Ride"] = 38062.5, ["Mega|Fly|Ride"] = 89250}},
    ["rbxassetid://71457697470071"] = {name = "Arctic Dusk Dragon", prices = {["default"] = 419.07, ["Fly"] = 504.68, ["Ride"] = 416.88, ["Fly|Ride"] = 394.67, ["Neon"] = 1424.8, ["Neon|Ride"] = 1502.82, ["Neon|Fly|Ride"] = 1312.5, ["Mega"] = 6286.62, ["Mega|Fly|Ride"] = 4269.43}},
    ["rbxassetid://8566683457"] = {name = "Giant Gold Scarab", prices = {["default"] = 258.24, ["Fly"] = 140.39, ["Ride"] = 136.49, ["Fly|Ride"] = 167.64, ["Neon|Fly|Ride"] = 559.53, ["Mega|Fly|Ride"] = 4191.09}},
    ["rbxassetid://16116063171"] = {name = "Rainbow Dragon", prices = {["default"] = 104.98, ["Fly"] = 279.74, ["Ride"] = 125.02, ["Fly|Ride"] = 207.38, ["Neon"] = 705.13, ["Neon|Ride"] = 484.32, ["Neon|Fly|Ride"] = 796.32, ["Mega"] = 13970.94, ["Mega|Fly|Ride"] = 5238.84}},
    ["rbxassetid://9938967130"] = {name = "Black Chow-Chow", prices = {["default"] = 18.78, ["Fly"] = 69.17, ["Ride"] = 28.31, ["Fly|Ride"] = 126, ["Neon"] = 274.3, ["Neon|Ride"] = 135.19, ["Neon|Fly|Ride"] = 194.86, ["Mega"] = 1968.75, ["Mega|Fly|Ride"] = 626.2}},
    ["rbxassetid://116467943923352"] = {name = "Haetae", prices = {["default"] = 4646.33, ["Ride"] = 4750.02, ["Fly|Ride"] = 3937.37, ["Neon|Fly|Ride"] = 18162}},
    ["rbxassetid://6531232495"] = {name = "Peacock", prices = {["default"] = 32.49, ["Fly"] = 49.69, ["Ride"] = 30.19, ["Fly|Ride"] = 65.63, ["Neon"] = 337.32, ["Neon|Ride"] = 207.44, ["Neon|Fly|Ride"] = 179.82, ["Mega"] = 1047.78, ["Mega|Fly|Ride"] = 761.78}},
    ["rbxassetid://12557346746"] = {name = "Naga Dragon", prices = {["default"] = 36.45, ["Fly"] = 114.63, ["Ride"] = 44.61, ["Fly|Ride"] = 112.11, ["Neon"] = 228.76, ["Neon|Fly"] = 1397.57, ["Neon|Ride"] = 276.59, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 1573.16, ["Mega|Fly|Ride"] = 1151.51}},
    ["rbxassetid://127697654557674"] = {name = "Candicorn", prices = {["default"] = 577.49, ["Fly"] = 908.32, ["Ride"] = 578.78, ["Fly|Ride"] = 643.13, ["Neon"] = 1706.25, ["Neon|Ride"] = 1706.25, ["Neon|Fly|Ride"] = 1561.88, ["Mega|Ride"] = 5943.48, ["Mega|Fly|Ride"] = 4724.99}},
    ["rbxassetid://4281674580"] = {name = "King Bee", prices = {["default"] = 12.69, ["Fly"] = 32.49, ["Ride"] = 26.17, ["Fly|Ride"] = 41.94, ["Neon"] = 104.99, ["Neon|Fly"] = 158.02, ["Neon|Ride"] = 107.63, ["Neon|Fly|Ride"] = 139.83, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://17822543288"] = {name = "Blue Betta Fish", prices = {["default"] = 11.82, ["Fly"] = 74.41, ["Ride"] = 77.55, ["Neon"] = 80.07, ["Neon|Ride"] = 192.21, ["Neon|Fly|Ride"] = 249.38, ["Mega|Ride"] = 566.06}},
    ["rbxassetid://102300026415493"] = {name = "Moose Calf", prices = {["default"] = 102.38, ["Ride"] = 131.25, ["Fly|Ride"] = 245.44, ["Neon"] = 523.84, ["Neon|Ride"] = 523.69, ["Neon|Fly|Ride"] = 695.73, ["Mega|Fly|Ride"] = 2824.8}},
    ["rbxassetid://78419574214060"] = {name = "Christmas Spirit", prices = {["default"] = 22.07, ["Fly"] = 106.14, ["Ride"] = 93.85, ["Fly|Ride"] = 166.59, ["Neon"] = 103.69, ["Neon|Fly"] = 188.58, ["Neon|Ride"] = 167.64, ["Neon|Fly|Ride"] = 209.99, ["Mega"] = 312.63, ["Mega|Ride"] = 356.94, ["Mega|Fly|Ride"] = 511.27}},
    ["rbxassetid://130642623661179"] = {name = "Cryptid", prices = {["default"] = 3543.75, ["Ride"] = 3478.13, ["Fly|Ride"] = 3411.19, ["Neon|Ride"] = 17809.87, ["Neon|Fly|Ride"] = 8531.25, ["Mega"] = 43820.78, ["Mega|Fly|Ride"] = 34277.58}},
    ["rbxassetid://101130894252942"] = {name = "Peach Owl", prices = {["default"] = 42, ["Ride"] = 59.07, ["Fly|Ride"] = 119.22, ["Neon"] = 131.25, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 412.76, ["Mega|Ride"] = 879.1, ["Mega|Fly|Ride"] = 892.5}},
    ["rbxassetid://4440866649"] = {name = "Owl", prices = {["default"] = 7218.75, ["Fly"] = 7702.26, ["Ride"] = 7644.97, ["Fly|Ride"] = 6037.5, ["Neon|Fly|Ride"] = 17718.75, ["Mega|Fly|Ride"] = 64682.86}},
    ["rbxassetid://6836687169"] = {name = "Golden Griffin", prices = {["default"] = 3.34, ["Fly"] = 23.61, ["Ride"] = 17.07, ["Fly|Ride"] = 39.35, ["Neon"] = 28.3, ["Neon|Fly"] = 62.62, ["Neon|Ride"] = 43.32, ["Neon|Fly|Ride"] = 86.18, ["Mega"] = 419.12, ["Mega|Fly|Ride"] = 259.88}},
    ["rbxassetid://76198828333546"] = {name = "Hippogriff", prices = {["default"] = 24.11, ["Fly"] = 25.16, ["Ride"] = 31.85, ["Fly|Ride"] = 60.75, ["Neon"] = 195.92, ["Neon|Ride"] = 559.46, ["Neon|Fly|Ride"] = 155.09, ["Mega|Ride"] = 1444.42, ["Mega|Fly|Ride"] = 943.43}},
    ["rbxassetid://112567270488274"] = {name = "Crystal Egg", prices = {["default"] = 3.92}},
    ["rbxassetid://10695038557"] = {name = "Maneki-Neko", prices = {["default"] = 12.7, ["Ride"] = 40.11, ["Fly|Ride"] = 122.84, ["Neon"] = 158.02, ["Neon|Ride"] = 140.39, ["Neon|Fly|Ride"] = 182.33, ["Mega"] = 837.18, ["Mega|Ride"] = 978.63, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://16911441596"] = {name = "Royal Capuchin Monkey", prices = {["default"] = 22.28, ["Fly"] = 262.5, ["Ride"] = 45.94, ["Fly|Ride"] = 140.39, ["Neon"] = 182.43, ["Neon|Ride"] = 158.82, ["Neon|Fly|Ride"] = 126.32, ["Mega"] = 840, ["Mega|Fly|Ride"] = 853.13}},
    ["rbxassetid://6963387165"] = {name = "Cobra", prices = {["default"] = 9.09, ["Fly"] = 27.71, ["Ride"] = 21.95, ["Fly|Ride"] = 41.92, ["Neon|Ride"] = 97.62, ["Neon|Fly|Ride"] = 195.82, ["Mega"] = 656.25, ["Mega|Ride"] = 588.46, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://3409444171"] = {name = "Safari Egg", prices = {["default"] = 8344.88}},
    ["rbxassetid://3743740864"] = {name = "Jungle Egg", prices = {["default"] = 2657.82}},
    ["rbxassetid://10321884333"] = {name = "Japan Egg", prices = {["default"] = 21}},
    ["rbxassetid://11109117895"] = {name = "Diamond Amazon", prices = {["default"] = 152.02, ["Fly"] = 174.57, ["Ride"] = 174.57, ["Fly|Ride"] = 209.54, ["Mega|Fly|Ride"] = 5503.62}},
    ["rbxassetid://102144672439627"] = {name = "Berry Cool Cube", prices = {["default"] = 18.19, ["Fly"] = 132.01, ["Ride"] = 42, ["Fly|Ride"] = 105, ["Neon"] = 124.68, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 276.63, ["Mega"] = 698.87, ["Mega|Ride"] = 896.25, ["Mega|Fly|Ride"] = 708.75}},
    ["rbxassetid://17183502626"] = {name = "Garden Egg", prices = {["default"] = 10.39}},
    ["rbxassetid://16722909609"] = {name = "Striped Eggy", prices = {["default"] = 6.2, ["Ride"] = 26.25, ["Neon"] = 54.49, ["Neon|Ride"] = 83.83, ["Neon|Fly|Ride"] = 125.74, ["Mega|Fly|Ride"] = 465.94}},
    ["rbxassetid://4440866155"] = {name = "Farm Egg", prices = {["default"] = 2546.24}},
    ["rbxassetid://88361277330582"] = {name = "Naughty Mistletroll", prices = {["default"] = 157.5, ["Fly"] = 209.54, ["Ride"] = 209.54, ["Fly|Ride"] = 416.97, ["Neon"] = 701.37, ["Neon|Ride"] = 593.66, ["Mega|Ride"] = 3479.65, ["Mega|Fly|Ride"] = 3479.65}},
    ["rbxassetid://12778919221"] = {name = "Yule Log Dog", prices = {["default"] = 132.06, ["Ride"] = 237.57, ["Fly|Ride"] = 485.63, ["Neon"] = 628.6, ["Neon|Fly|Ride"] = 787.5, ["Mega"] = 2493.75, ["Mega|Ride"] = 2778.57, ["Mega|Fly|Ride"] = 2387.44}},
    ["rbxassetid://13104112588"] = {name = "Owlbear", prices = {["default"] = 150.94, ["Fly"] = 237.83, ["Ride"] = 170.46, ["Fly|Ride"] = 250.1, ["Neon"] = 799.32, ["Neon|Ride"] = 840, ["Neon|Fly|Ride"] = 890.49, ["Mega"] = 3018.75, ["Mega|Fly|Ride"] = 3451.35}},
    ["rbxassetid://11192035130"] = {name = "Undead Jousting Horse", prices = {["default"] = 1507.95, ["Fly"] = 2514.36, ["Ride"] = 1312.48, ["Fly|Ride"] = 1390.94, ["Neon"] = 5031.3, ["Neon|Ride"] = 6146.52, ["Neon|Fly|Ride"] = 4331.25, ["Mega|Fly|Ride"] = 26822.84}},
    ["rbxassetid://106575933009346"] = {name = "Fairytale Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://96044273915258"] = {name = "Endangered Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://129993159377616"] = {name = "Peahen", prices = {["default"] = 19.45, ["Fly"] = 81.3, ["Ride"] = 39.38, ["Fly|Ride"] = 86.62, ["Neon"] = 127.3, ["Neon|Ride"] = 140.39, ["Neon|Fly|Ride"] = 314.88, ["Mega"] = 837.18, ["Mega|Ride"] = 622.39, ["Mega|Fly|Ride"] = 1047.78}},
    ["rbxassetid://12732812236"] = {name = "Tio De Nadal", prices = {["default"] = 582.75, ["Fly"] = 2100, ["Ride"] = 740.71, ["Fly|Ride"] = 1050, ["Neon|Fly|Ride"] = 3142.28}},
    ["rbxassetid://13936755787"] = {name = "Wrapped Doll", prices = {["default"] = 72.19}},
    ["rbxassetid://136441478335419"] = {name = "Emberlight", prices = {["default"] = 15.59, ["Ride"] = 26.25, ["Fly|Ride"] = 681.8, ["Neon"] = 79.35, ["Neon|Ride"] = 158.02, ["Neon|Fly|Ride"] = 158.04, ["Mega"] = 393.63, ["Mega|Ride"] = 441.79, ["Mega|Fly|Ride"] = 522.85}},
    ["rbxassetid://17120184484"] = {name = "Rosy Maple Moth", prices = {["default"] = 7.48, ["Fly"] = 83.83, ["Ride"] = 28.3, ["Fly|Ride"] = 94.5, ["Neon"] = 39.38, ["Neon|Ride"] = 88.02, ["Neon|Fly|Ride"] = 210, ["Mega"] = 158.04, ["Mega|Ride"] = 488.28, ["Mega|Fly|Ride"] = 619.5}},
    ["rbxassetid://15932251755"] = {name = "Royal Desert Egg", prices = {["default"] = 45.94}},
    ["rbxassetid://8143039289"] = {name = "Golden Walrus", prices = {["default"] = 17.05, ["Ride"] = 31.24, ["Fly|Ride"] = 76.13, ["Neon"] = 196.88, ["Neon|Ride"] = 209.57, ["Mega"] = 656.25, ["Mega|Fly|Ride"] = 1387.72}},
    ["rbxassetid://12187391973"] = {name = "Firefly", prices = {["default"] = 32.82, ["Fly"] = 56.59, ["Ride"] = 39.37, ["Fly|Ride"] = 63.7, ["Neon|Ride"] = 279.74, ["Neon|Fly|Ride"] = 274.32, ["Mega"] = 951.67, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://3743647944"] = {name = "Parrot", prices = {["default"] = 6237, ["Fly"] = 10500, ["Ride"] = 5495.44, ["Fly|Ride"] = 5092.5, ["Neon|Ride"] = 17461.01, ["Neon|Fly|Ride"] = 9954.57, ["Mega|Fly|Ride"] = 35437.5}},
    ["rbxassetid://128454622445076"] = {name = "Dimension Drifter", prices = {["default"] = 9.49, ["Fly"] = 79.64, ["Ride"] = 32.7, ["Fly|Ride"] = 79.02, ["Neon"] = 47.23, ["Neon|Ride"] = 77.44, ["Neon|Fly|Ride"] = 559.53, ["Mega"] = 528.32, ["Mega|Ride"] = 544.69, ["Mega|Fly|Ride"] = 418.66}},
    ["rbxassetid://15931761708"] = {name = "Desert Egg", prices = {["default"] = 22.3}},
    ["rbxassetid://17747001377"] = {name = "Majestic Pony", prices = {["default"] = 108.94, ["Fly"] = 370.89, ["Ride"] = 131.25, ["Fly|Ride"] = 196.88, ["Neon"] = 418.69, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 517.61, ["Mega|Ride"] = 4191.09, ["Mega|Fly|Ride"] = 1850.37}},
    ["rbxassetid://94487786469241"] = {name = "Vanilla Penguin", prices = {["default"] = 137.82, ["Fly"] = 141.5, ["Ride"] = 129.94, ["Fly|Ride"] = 158.19, ["Neon"] = 327.6, ["Neon|Fly"] = 362.5, ["Neon|Ride"] = 362.5, ["Neon|Fly|Ride"] = 301.88, ["Mega"] = 2358.54, ["Mega|Ride"] = 2828.99, ["Mega|Fly|Ride"] = 1391.25}},
    ["rbxassetid://6498256211"] = {name = "Octopus", prices = {["default"] = 17.7, ["Fly"] = 70.44, ["Ride"] = 32.69, ["Fly|Ride"] = 62.87, ["Neon"] = 137.25, ["Neon|Ride"] = 145.69, ["Neon|Fly|Ride"] = 132.57, ["Mega|Ride"] = 677.93, ["Mega|Fly|Ride"] = 656.22}},
    ["rbxassetid://110654583245787"] = {name = "Sea Turtle", prices = {["default"] = 4.87, ["Fly"] = 79.22, ["Ride"] = 31.53, ["Fly|Ride"] = 78.74, ["Neon"] = 24.94, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 79.64, ["Neon|Fly|Ride"] = 167.66, ["Mega"] = 142.95, ["Mega|Fly"] = 6982.05, ["Mega|Ride"] = 213.88, ["Mega|Fly|Ride"] = 271.68}},
    ["rbxassetid://8596147681"] = {name = "Squid", prices = {["default"] = 12.98, ["Fly"] = 79.02, ["Ride"] = 33.34, ["Fly|Ride"] = 68.88, ["Neon"] = 90.09, ["Neon|Ride"] = 85.22, ["Neon|Fly|Ride"] = 276.63, ["Mega"] = 437.98, ["Mega|Ride"] = 410.82, ["Mega|Fly|Ride"] = 559.53}},
    ["rbxassetid://9226723356"] = {name = "Winged Horse", prices = {["default"] = 19.28, ["Fly"] = 28.88, ["Ride"] = 27.57, ["Fly|Ride"] = 45.35, ["Neon"] = 208.71, ["Neon|Ride"] = 140.39, ["Neon|Fly|Ride"] = 104.89, ["Mega|Fly|Ride"] = 695.63}},
    ["rbxassetid://4733386633"] = {name = "Aussie Egg", prices = {["default"] = 210.12}},
    ["rbxassetid://121951206021245"] = {name = "Kiwi Kiwi", prices = {["default"] = 22.32, ["Ride"] = 129.94, ["Neon"] = 177.19, ["Mega"] = 1117.98, ["Mega|Ride"] = 918.75, ["Mega|Fly|Ride"] = 1676.45}},
    ["rbxassetid://9602676771"] = {name = "Diamond Albatross", prices = {["default"] = 118.68, ["Ride"] = 140.39, ["Fly|Ride"] = 262.5, ["Neon"] = 559.46, ["Neon|Ride"] = 820.32, ["Neon|Fly|Ride"] = 559.53}},
    ["rbxassetid://79965389436178"] = {name = "Sushi Penguin", prices = {["default"] = 41.92, ["Fly"] = 212.01, ["Ride"] = 104.99, ["Fly|Ride"] = 209.46, ["Neon"] = 559.46, ["Neon|Ride"] = 385.88, ["Neon|Fly|Ride"] = 420, ["Mega"] = 1050, ["Mega|Ride"] = 1104.36, ["Mega|Fly|Ride"] = 1152.56}},
    ["rbxassetid://126930507653265"] = {name = "Grim Dragon", prices = {["default"] = 856.96, ["Fly"] = 990.47, ["Ride"] = 727.08, ["Fly|Ride"] = 734.89, ["Neon|Fly"] = 2829.89, ["Neon|Ride"] = 3281.25, ["Neon|Fly|Ride"] = 2231.24, ["Mega|Fly|Ride"] = 9778.13}},
    ["rbxassetid://87328715505907"] = {name = "Silverback Gorilla", prices = {["default"] = 206.07, ["Fly"] = 417.42, ["Ride"] = 218.67, ["Fly|Ride"] = 275.63, ["Neon"] = 1181.25, ["Neon|Ride"] = 1816.62, ["Neon|Fly|Ride"] = 1327.53, ["Mega"] = 8277.38, ["Mega|Fly|Ride"] = 5025.11}},
    ["rbxassetid://12733311267"] = {name = "Fool Egg", prices = {["default"] = 95.82}},
    ["rbxassetid://139472202653768"] = {name = "Admin Abuse Egg", prices = {["default"] = 4.22}},
    ["rbxassetid://8938702589"] = {name = "Hawk", prices = {["default"] = 12.98, ["Fly"] = 28.48, ["Ride"] = 26.21, ["Fly|Ride"] = 52.5, ["Neon"] = 78.73, ["Neon|Fly"] = 230.99, ["Neon|Ride"] = 104.78, ["Neon|Fly|Ride"] = 140.42, ["Mega"] = 437.26, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 502.94}},
    ["rbxassetid://8938703243"] = {name = "Fallow Deer", prices = {["default"] = 287.41, ["Fly"] = 1035.07, ["Ride"] = 346.5, ["Fly|Ride"] = 355.69, ["Neon"] = 1020.42, ["Neon|Ride"] = 866.24, ["Neon|Fly|Ride"] = 1023.75, ["Mega|Fly|Ride"] = 3510.29}},
    ["rbxassetid://4822753124"] = {name = "Diamond Egg", prices = {["default"] = 16.57}},
    ["rbxassetid://114823420678686"] = {name = "Dragonfruit Fox", prices = {["default"] = 126, ["Fly"] = 228.76, ["Ride"] = 196.88, ["Fly|Ride"] = 278.24, ["Neon"] = 523.69, ["Neon|Fly"] = 1676.24, ["Neon|Ride"] = 518.49, ["Neon|Fly|Ride"] = 670.59, ["Mega"] = 2520, ["Mega|Ride"] = 2235.95, ["Mega|Fly|Ride"] = 2078.65}},
    ["rbxassetid://102844319137806"] = {name = "Pineapple Owl", prices = {["default"] = 117.92, ["Ride"] = 137.71, ["Fly|Ride"] = 196.88, ["Neon"] = 1117.85, ["Neon|Ride"] = 983.75, ["Neon|Fly|Ride"] = 1046.73}},
    ["rbxassetid://82296650763619"] = {name = "Angus Bull", prices = {["default"] = 5.25, ["Ride"] = 28.3, ["Fly|Ride"] = 209.54, ["Neon"] = 39.38, ["Neon|Ride"] = 85.29, ["Neon|Fly|Ride"] = 226.33, ["Mega"] = 210, ["Mega|Ride"] = 363.59, ["Mega|Fly|Ride"] = 654.94}},
    ["rbxassetid://12917347755"] = {name = "Sunrise Duckling", prices = {["default"] = 11.51, ["Fly"] = 63, ["Ride"] = 31.5, ["Fly|Ride"] = 76.13, ["Neon"] = 103.07, ["Neon|Ride"] = 157.99, ["Neon|Fly|Ride"] = 262.5, ["Mega|Ride"] = 498.75, ["Mega|Fly|Ride"] = 577.31}},
    ["rbxassetid://139217275750567"] = {name = "Winter Buck", prices = {["default"] = 23.62, ["Fly"] = 102.32, ["Ride"] = 72.19, ["Fly|Ride"] = 128.82, ["Neon"] = 99.75, ["Neon|Ride"] = 174.98, ["Neon|Fly|Ride"] = 235.18, ["Mega"] = 469.42, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 1033.6}},
    ["rbxassetid://114331718573822"] = {name = "Mochi Meow", prices = {["default"] = 5.24, ["Fly"] = 116.3, ["Ride"] = 39.38, ["Fly|Ride"] = 123.38, ["Neon"] = 25.55, ["Neon|Fly"] = 93.17, ["Neon|Ride"] = 55.1, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 121.04, ["Mega|Fly"] = 164.59, ["Mega|Ride"] = 177.18, ["Mega|Fly|Ride"] = 274.21}},
    ["rbxassetid://112560568221286"] = {name = "Strawberry Penguin", prices = {["default"] = 262.5, ["Fly"] = 918.75, ["Ride"] = 341.25, ["Fly|Ride"] = 334.69, ["Neon"] = 1536.9, ["Neon|Ride"] = 1214.07, ["Neon|Fly|Ride"] = 1376.42}},
    ["rbxassetid://116818749091454"] = {name = "Dango Penguins", prices = {["default"] = 102.92, ["Fly"] = 1050, ["Ride"] = 125.73, ["Fly|Ride"] = 264.02, ["Neon"] = 460.69, ["Neon|Ride"] = 559.46, ["Neon|Fly|Ride"] = 698.87, ["Mega"] = 1903.12, ["Mega|Ride"] = 1990.61, ["Mega|Fly|Ride"] = 1769.25}},
    ["rbxassetid://12480100169"] = {name = "Tree Kangaroo", prices = {["default"] = 72.19, ["Fly"] = 167.45, ["Ride"] = 87.94, ["Fly|Ride"] = 128.63, ["Neon"] = 360.94, ["Neon|Ride"] = 389.12, ["Neon|Fly|Ride"] = 471.09, ["Mega|Fly|Ride"] = 1967.02}},
    ["rbxassetid://75106733244906"] = {name = "Golden Hummingbird", prices = {["default"] = 23.97, ["Fly"] = 145.69, ["Ride"] = 57.75, ["Fly|Ride"] = 251.45, ["Neon|Ride"] = 599, ["Neon|Fly|Ride"] = 486.19, ["Mega|Fly|Ride"] = 1662.83}},
    ["rbxassetid://76354526914534"] = {name = "Frostclaw", prices = {["default"] = 19.68, ["Fly"] = 75.62, ["Ride"] = 39.38, ["Fly|Ride"] = 187.5, ["Neon"] = 91.88, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 698.24, ["Mega|Fly"] = 525, ["Mega|Ride"] = 471.72, ["Mega|Fly|Ride"] = 444.38}},
    ["rbxassetid://121712578077668"] = {name = "Blue Whale", prices = {["default"] = 3.83, ["Fly"] = 45.84, ["Ride"] = 24.75, ["Fly|Ride"] = 59.07, ["Neon"] = 20.98, ["Neon|Fly"] = 91.88, ["Neon|Ride"] = 39.81, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 110.94, ["Mega|Fly"] = 158.04, ["Mega|Ride"] = 223.13, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://76035105070441"] = {name = "Fairy Bat Dragon", prices = {["default"] = 944.75, ["Fly"] = 1084.32, ["Ride"] = 920.07, ["Fly|Ride"] = 1004.07, ["Neon"] = 3006.75, ["Neon|Ride"] = 2598.75, ["Neon|Fly|Ride"] = 2493.72, ["Mega|Fly|Ride"] = 10618.09}},
    ["rbxassetid://105346917979221"] = {name = "Aurora Fox", prices = {["default"] = 409.63, ["Ride"] = 422.62, ["Fly|Ride"] = 485.62, ["Neon"] = 1792.28, ["Neon|Ride"] = 1680, ["Neon|Fly|Ride"] = 2359.59, ["Mega"] = 10477.68, ["Mega|Fly|Ride"] = 6705.72}},
    ["rbxassetid://120475294381736"] = {name = "Glormy Hound", prices = {["default"] = 73.5, ["Fly"] = 140.39, ["Ride"] = 99.54, ["Fly|Ride"] = 174.53, ["Neon"] = 765.19, ["Neon|Ride"] = 305.82, ["Neon|Fly|Ride"] = 349.8, ["Mega|Ride"] = 1444.89, ["Mega|Fly|Ride"] = 1475.28}},
    ["rbxassetid://15570696642"] = {name = "Glacier Kitsune", prices = {["default"] = 271.69, ["Ride"] = 301.88, ["Fly|Ride"] = 315, ["Neon|Ride"] = 1414.95, ["Neon|Fly|Ride"] = 1117.98, ["Mega"] = 10477.68, ["Mega|Fly|Ride"] = 5098.45}},
    ["rbxassetid://16548792521"] = {name = "Golden Hamster", prices = {["default"] = 31.28, ["Fly"] = 140.39, ["Ride"] = 28.3, ["Fly|Ride"] = 67.04, ["Neon"] = 138.3, ["Neon|Ride"] = 126.18, ["Neon|Fly|Ride"] = 158.5, ["Mega|Ride"] = 665.34, ["Mega|Fly|Ride"] = 644.4}},
    ["rbxassetid://12935498875"] = {name = "Field Mouse", prices = {["default"] = 217.88, ["Ride"] = 277.93, ["Fly|Ride"] = 471.65, ["Neon"] = 1419.05, ["Neon|Ride"] = 1729.77, ["Neon|Fly|Ride"] = 1226.45, ["Mega"] = 4170.42, ["Mega|Fly|Ride"] = 4113.32}},
    ["rbxassetid://16548793509"] = {name = "Diamond Hamster", prices = {["default"] = 57.17, ["Fly"] = 126, ["Ride"] = 64.97, ["Fly|Ride"] = 83.83, ["Neon|Ride"] = 500.78, ["Neon|Fly|Ride"] = 559.53, ["Mega|Fly|Ride"] = 1397.74}},
    ["rbxassetid://78823655016197"] = {name = "Jekyll Hydra", prices = {["default"] = 1640.63, ["Ride"] = 1413.32, ["Fly|Ride"] = 1377.72, ["Neon|Fly|Ride"] = 3932.85, ["Mega"] = 50292.83, ["Mega|Fly|Ride"] = 24308.22}},
    ["rbxassetid://96735424372947"] = {name = "Glormy Dolphin", prices = {["default"] = 12.84, ["Fly"] = 57.75, ["Ride"] = 38.98, ["Fly|Ride"] = 92.21, ["Neon"] = 61.53, ["Neon|Fly"] = 41.92, ["Neon|Ride"] = 77.87, ["Neon|Fly|Ride"] = 177.19, ["Mega"] = 262.47, ["Mega|Ride"] = 261.19, ["Mega|Fly|Ride"] = 392.43}},
    ["rbxassetid://16898331554"] = {name = "Princess Capuchin Monkey", prices = {["default"] = 49.11, ["Fly"] = 78.75, ["Ride"] = 59.07, ["Fly|Ride"] = 159.48, ["Neon"] = 309.07, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 266.14, ["Mega|Ride"] = 1462.71, ["Mega|Fly|Ride"] = 1458.19}},
    ["rbxassetid://4315743450"] = {name = "Queen Bee", prices = {["default"] = 76.13, ["Fly"] = 70.2, ["Ride"] = 63, ["Fly|Ride"] = 65.61, ["Neon|Ride"] = 410.82, ["Neon|Fly|Ride"] = 393.75, ["Mega|Fly|Ride"] = 1358.11}},
    ["rbxassetid://5067924789"] = {name = "Monkey King", prices = {["default"] = 3771.51, ["Ride"] = 1226.3, ["Fly|Ride"] = 1113, ["Neon|Fly|Ride"] = 3281.25, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://10284283561"] = {name = "Black-Chested Pheasant", prices = {["default"] = 469.25, ["Fly"] = 836.04, ["Ride"] = 522.79, ["Fly|Ride"] = 534.19, ["Neon|Fly|Ride"] = 2752.41, ["Mega|Fly|Ride"] = 14151.14}},
    ["rbxassetid://15504845135"] = {name = "Candy Hare", prices = {["default"] = 104.98, ["Fly"] = 314.84, ["Ride"] = 135.19, ["Fly|Ride"] = 105, ["Neon"] = 445.6, ["Neon|Fly"] = 559.46, ["Neon|Ride"] = 472.5, ["Neon|Fly|Ride"] = 545.4, ["Mega"] = 4190.03, ["Mega|Ride"] = 2655.06, ["Mega|Fly|Ride"] = 2202.87}},
    ["rbxassetid://11758575657"] = {name = "Lunar Moon Bear", prices = {["default"] = 8.81, ["Fly"] = 39.37, ["Ride"] = 23.55, ["Fly|Ride"] = 69.57, ["Neon"] = 87.94, ["Neon|Ride"] = 99.75, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 656.25, ["Mega|Ride"] = 740.06, ["Mega|Fly|Ride"] = 1045.69}},
    ["rbxassetid://10318105392"] = {name = "Green Butterfly", prices = {["default"] = 39.38, ["Fly"] = 83.83, ["Ride"] = 47.12, ["Fly|Ride"] = 103.79, ["Neon"] = 204.75, ["Neon|Fly"] = 418.02, ["Neon|Ride"] = 209.54, ["Neon|Fly|Ride"] = 276.63, ["Mega"] = 1816.84, ["Mega|Ride"] = 1069.6, ["Mega|Fly|Ride"] = 879.38}},
    ["rbxassetid://84813815094145"] = {name = "Mermicorn", prices = {["default"] = 759.42, ["Ride"] = 874.13, ["Fly|Ride"] = 826.88, ["Neon|Ride"] = 2828.44, ["Neon|Fly|Ride"] = 3281.25, ["Mega|Fly|Ride"] = 16066.47}},
    ["rbxassetid://4507163112"] = {name = "Christmas Egg", prices = {["default"] = 787.47}},
    ["rbxassetid://14689005829"] = {name = "Blazing Lion", prices = {["default"] = 4921.88, ["Ride"] = 5446.69, ["Fly|Ride"] = 3845.63, ["Neon"] = 42000, ["Neon|Ride"] = 30026.4, ["Neon|Fly|Ride"] = 21927.94, ["Mega|Fly|Ride"] = 89410.17}},
    ["rbxassetid://123647431892215"] = {name = "Hero Gibbon", prices = {["default"] = 179.82, ["Fly"] = 276.17, ["Ride"] = 272.4, ["Neon"] = 1297.05, ["Neon|Ride"] = 1258.13, ["Neon|Fly|Ride"] = 1397.74, ["Mega"] = 5866.47, ["Mega|Fly|Ride"] = 6007.92}},
    ["rbxassetid://106457467498193"] = {name = "Scorching Kaijunior", prices = {["default"] = 81.38, ["Fly"] = 279.74, ["Ride"] = 78.74, ["Fly|Ride"] = 336, ["Neon"] = 349.13, ["Neon|Ride"] = 483.12, ["Neon|Fly|Ride"] = 978.63, ["Mega|Fly|Ride"] = 2099.99}},
    ["rbxassetid://10926054030"] = {name = "Chimera", prices = {["default"] = 13.02, ["Fly"] = 131.24, ["Ride"] = 26.23, ["Fly|Ride"] = 105, ["Neon"] = 274.32, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 698.87, ["Mega|Ride"] = 628.67, ["Mega|Fly|Ride"] = 603.75}},
    ["rbxassetid://9490242683"] = {name = "Golden King Penguin", prices = {["default"] = 18.74, ["Fly"] = 31.82, ["Ride"] = 30.19, ["Fly|Ride"] = 48, ["Neon|Fly"] = 279.74, ["Neon|Ride"] = 279.74, ["Neon|Fly|Ride"] = 177.18, ["Mega"] = 1312.5, ["Mega|Fly|Ride"] = 2221.28}},
    ["rbxassetid://17119623510"] = {name = "Mushroom Friend", prices = {["default"] = 9.45, ["Fly"] = 131.25, ["Ride"] = 42, ["Fly|Ride"] = 110.25, ["Neon"] = 154.88, ["Neon|Ride"] = 116.82, ["Neon|Fly|Ride"] = 231, ["Mega"] = 549.94, ["Mega|Ride"] = 573.15, ["Mega|Fly|Ride"] = 577.5}},
    ["rbxassetid://17174656536"] = {name = "Golden Tortoise Beetle", prices = {["default"] = 5.25, ["Fly"] = 56.59, ["Ride"] = 22.32, ["Fly|Ride"] = 39.38, ["Neon"] = 40.87, ["Neon|Fly"] = 345.74, ["Neon|Ride"] = 40.42, ["Neon|Fly|Ride"] = 126.86, ["Mega"] = 176.72, ["Mega|Ride"] = 194.9, ["Mega|Fly|Ride"] = 309.1}},
    ["rbxassetid://84310117840681"] = {name = "Super Saru", prices = {["default"] = 31.44, ["Fly|Ride"] = 183.74, ["Neon"] = 163.45, ["Neon|Fly"] = 838.13, ["Neon|Ride"] = 141.5, ["Neon|Fly|Ride"] = 245.93, ["Mega"] = 691.55, ["Mega|Ride"] = 739.41}},
    ["rbxassetid://77177643028234"] = {name = "Phantom Dragon", prices = {["default"] = 307.98, ["Fly"] = 365.54, ["Ride"] = 300.47, ["Fly|Ride"] = 353.91, ["Neon"] = 978.51, ["Neon|Ride"] = 973.25, ["Neon|Fly|Ride"] = 892.71, ["Mega"] = 6562.5, ["Mega|Ride"] = 3632.63, ["Mega|Fly|Ride"] = 3281.25}},
    ["rbxassetid://6245080265"] = {name = "Metal Ox", prices = {["default"] = 2.6, ["Fly"] = 22.97, ["Ride"] = 17.07, ["Fly|Ride"] = 36.68, ["Neon"] = 18.36, ["Neon|Ride"] = 31.53, ["Neon|Fly|Ride"] = 70.34, ["Mega"] = 836.13, ["Mega|Ride"] = 220.54, ["Mega|Fly|Ride"] = 261.19}},
    ["rbxassetid://3181728194"] = {name = "Unicorn", prices = {["default"] = 45.92, ["Fly"] = 85.31, ["Ride"] = 65.61, ["Fly|Ride"] = 101.85, ["Neon"] = 125.85, ["Neon|Fly"] = 393.84, ["Neon|Ride"] = 184.66, ["Neon|Fly|Ride"] = 249.52, ["Mega"] = 614.15, ["Mega|Fly"] = 838.23, ["Mega|Ride"] = 506.7, ["Mega|Fly|Ride"] = 551.25}},
    ["rbxassetid://4708551322"] = {name = "Turtle", prices = {["default"] = 721.87, ["Fly"] = 895.75, ["Ride"] = 754.69, ["Fly|Ride"] = 715.32, ["Neon|Ride"] = 1575, ["Neon|Fly|Ride"] = 1565.82, ["Mega|Fly|Ride"] = 5106.83}},
    ["rbxassetid://5721844281"] = {name = "T-Rex", prices = {["default"] = 27.01, ["Fly"] = 91.88, ["Ride"] = 44.54, ["Fly|Ride"] = 65.63, ["Neon"] = 195.92, ["Neon|Fly"] = 471.65, ["Neon|Ride"] = 181.13, ["Neon|Fly|Ride"] = 272.44, ["Mega"] = 1575, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 741.4}},
    ["rbxassetid://16127039676"] = {name = "Midnight Dragon", prices = {["default"] = 308.7, ["Fly"] = 261.19, ["Ride"] = 260.98, ["Fly|Ride"] = 339.86, ["Neon"] = 942.88, ["Neon|Ride"] = 1256.14, ["Neon|Fly|Ride"] = 1021.12, ["Mega"] = 6290.19, ["Mega|Fly|Ride"] = 6217.46}},
    ["rbxassetid://7734925172"] = {name = "Halloween White Ghost Dragon", prices = {["default"] = 131.24, ["Fly"] = 139.02, ["Ride"] = 129.94, ["Fly|Ride"] = 170.63, ["Neon|Ride"] = 577.26, ["Neon|Fly|Ride"] = 562.41, ["Mega|Fly|Ride"] = 2358.23}},
    ["rbxassetid://18508016126"] = {name = "Bush Elephant", prices = {["default"] = 754.31, ["Ride"] = 590.63, ["Fly|Ride"] = 674.43, ["Neon|Ride"] = 2572.5, ["Neon|Fly|Ride"] = 2240.61, ["Mega|Fly|Ride"] = 7611.19}},
    ["rbxassetid://78218981883168"] = {name = "Coconut Friend", prices = {["default"] = 19.13, ["Ride"] = 46.75, ["Neon"] = 86.99, ["Neon|Fly"] = 283, ["Neon|Ride"] = 103.73, ["Neon|Fly|Ride"] = 188.69, ["Mega"] = 262.48, ["Mega|Ride"] = 360.45, ["Mega|Fly|Ride"] = 375.02}},
    ["rbxassetid://4184878050"] = {name = "Evil Unicorn", prices = {["default"] = 4001.94, ["Fly"] = 3403.42, ["Ride"] = 3770.46, ["Fly|Ride"] = 2858.63, ["Neon|Fly|Ride"] = 6562.5, ["Mega|Fly|Ride"] = 25058.25}},
    ["rbxassetid://103896000727935"] = {name = "Aestus", prices = {["default"] = 101.07, ["Fly"] = 123.63, ["Ride"] = 91.88, ["Fly|Ride"] = 141.6, ["Neon"] = 419.07, ["Neon|Ride"] = 459.87, ["Neon|Fly|Ride"] = 477.71, ["Mega|Fly|Ride"] = 1575}},
    ["rbxassetid://9922229151"] = {name = "Dragonfly", prices = {["default"] = 3.92, ["Fly"] = 19.92, ["Ride"] = 20.9, ["Fly|Ride"] = 140.39, ["Neon"] = 23.61, ["Neon|Fly"] = 83.83, ["Neon|Ride"] = 37.73, ["Neon|Fly|Ride"] = 111.57, ["Mega"] = 139.12, ["Mega|Fly"] = 452.82, ["Mega|Ride"] = 233.89, ["Mega|Fly|Ride"] = 235.91}},
    ["rbxassetid://82820245821381"] = {name = "Temple Friend", prices = {["default"] = 3.94, ["Ride"] = 26.25, ["Neon"] = 23.63, ["Neon|Fly"] = 157.5, ["Neon|Ride"] = 47.25, ["Neon|Fly|Ride"] = 158.04, ["Mega"] = 140.42, ["Mega|Ride"] = 199.48, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://6404812861"] = {name = "Diamond Ladybug", prices = {["default"] = 54.25, ["Fly"] = 82.86, ["Ride"] = 54.49, ["Fly|Ride"] = 59.07, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 257.76, ["Mega|Fly|Ride"] = 1049.99}},
    ["rbxassetid://107535752953647"] = {name = "Strawberry Tortle", prices = {["default"] = 939.75, ["Ride"] = 1173.38, ["Fly|Ride"] = 1295.43, ["Neon"] = 5720.13}},
    ["rbxassetid://95844539868957"] = {name = "Amethyst Penguin", prices = {["default"] = 5184.37, ["Ride"] = 5895.6, ["Fly|Ride"] = 5249.99}},
    ["rbxassetid://6240249282"] = {name = "Guardian Lion", prices = {["default"] = 19.43, ["Fly"] = 31.44, ["Ride"] = 23.63, ["Fly|Ride"] = 49.25, ["Neon|Ride"] = 158.02, ["Neon|Fly|Ride"] = 140.42, ["Mega"] = 2428.13, ["Mega|Fly|Ride"] = 607.72}},
    ["rbxassetid://11496077150"] = {name = "Ice Moth Dragon", prices = {["default"] = 17.07, ["Fly"] = 51.14, ["Ride"] = 32.82, ["Fly|Ride"] = 102.68, ["Neon"] = 56.59, ["Neon|Ride"] = 89.43, ["Neon|Fly|Ride"] = 129.94, ["Mega"] = 933.52, ["Mega|Ride"] = 564.87, ["Mega|Fly|Ride"] = 577.5}},
    ["rbxassetid://5862774166"] = {name = "Skele-Rex", prices = {["default"] = 55.12, ["Fly"] = 157.5, ["Ride"] = 65.6, ["Fly|Ride"] = 72.19, ["Neon"] = 328.12, ["Neon|Ride"] = 279.74, ["Neon|Fly|Ride"] = 305.82, ["Mega"] = 1127.42, ["Mega|Ride"] = 1150.47, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://11773429123"] = {name = "Nessie", prices = {["default"] = 232.31, ["Fly"] = 314.84, ["Ride"] = 216.57, ["Fly|Ride"] = 249.38, ["Neon|Fly"] = 922.99, ["Neon|Ride"] = 976.5, ["Neon|Fly|Ride"] = 850.04, ["Mega"] = 10477.68, ["Mega|Fly|Ride"] = 3365.62}},
    ["rbxassetid://121782270350526"] = {name = "Dark Choccybunny", prices = {["default"] = 3.93, ["Ride"] = 32.47, ["Fly|Ride"] = 86.63, ["Neon"] = 27.57, ["Neon|Fly"] = 656.25, ["Neon|Ride"] = 83.83, ["Mega"] = 131.24, ["Mega|Ride"] = 279.46, ["Mega|Fly|Ride"] = 419.12}},
    ["rbxassetid://129591977577854"] = {name = "Ballet Swan", prices = {["default"] = 189, ["Fly"] = 254.7, ["Ride"] = 215.63, ["Fly|Ride"] = 236.25, ["Neon"] = 698.79, ["Neon|Ride"] = 872.57, ["Neon|Fly|Ride"] = 928.09, ["Mega|Fly|Ride"] = 3703.87}},
    ["rbxassetid://9669227320"] = {name = "Zodiac Minion Chick", prices = {["default"] = 2.59, ["Fly"] = 20.65, ["Ride"] = 19.29, ["Fly|Ride"] = 39.37, ["Neon"] = 19.56, ["Neon|Fly"] = 123.03, ["Neon|Ride"] = 39.36, ["Neon|Fly|Ride"] = 82.68, ["Mega"] = 275.96, ["Mega|Ride"] = 177.18, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://13462536955"] = {name = "Caelum Cervi", prices = {["default"] = 225.75, ["Fly"] = 268.82, ["Ride"] = 253.32, ["Fly|Ride"] = 251.45, ["Neon|Ride"] = 824.51, ["Neon|Fly|Ride"] = 884.45, ["Mega"] = 10476.64, ["Mega|Ride"] = 4191.09, ["Mega|Fly|Ride"] = 3913.42}},
    ["rbxassetid://10137833794"] = {name = "Green-Chested Pheasant", prices = {["default"] = 12.8, ["Fly"] = 45.94, ["Ride"] = 27.08, ["Fly|Ride"] = 56.27, ["Neon"] = 91.17, ["Neon|Fly"] = 299.51, ["Neon|Ride"] = 99.54, ["Neon|Fly|Ride"] = 272.36, ["Mega"] = 522.42, ["Mega|Ride"] = 559.53, ["Mega|Fly|Ride"] = 498.75}},
    ["rbxassetid://16994954002"] = {name = "Brachiosaurus", prices = {["default"] = 2.1, ["Ride"] = 22.23, ["Fly|Ride"] = 59.07, ["Neon"] = 9.5, ["Neon|Fly"] = 170.45, ["Neon|Ride"] = 61.16, ["Neon|Fly|Ride"] = 135.47, ["Mega"] = 84.96, ["Mega|Ride"] = 119.44, ["Mega|Fly|Ride"] = 251.56}},
    ["rbxassetid://121938982134212"] = {name = "Gecko Ducky", prices = {["default"] = 2.1, ["Neon"] = 4.6, ["Neon|Ride"] = 70.22, ["Mega"] = 41.92, ["Mega|Ride"] = 139.17}},
    ["rbxassetid://17649624018"] = {name = "Kid Goat", prices = {["default"] = 3.48, ["Ride"] = 28.88, ["Fly|Ride"] = 206.57, ["Neon"] = 19.59, ["Neon|Ride"] = 20.97, ["Neon|Fly|Ride"] = 111.57, ["Mega"] = 170.63, ["Mega|Fly"] = 157235.49, ["Mega|Ride"] = 95.81, ["Mega|Fly|Ride"] = 168}},
    ["rbxassetid://4440867127"] = {name = "Chicken", prices = {["default"] = 51.1, ["Fly"] = 136.83, ["Ride"] = 111.83, ["Fly|Ride"] = 213.94, ["Neon"] = 279.74, ["Neon|Ride"] = 261.19, ["Neon|Fly|Ride"] = 355.47, ["Mega|Fly|Ride"] = 1250.32}},
    ["rbxassetid://5721844165"] = {name = "Tasmanian Tiger", prices = {["default"] = 2.1, ["Fly"] = 33.71, ["Ride"] = 17.07, ["Neon"] = 15.1, ["Neon|Ride"] = 31.27, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 106.37, ["Mega|Ride"] = 98.51, ["Mega|Fly|Ride"] = 209.57}},
    ["rbxassetid://14146063876"] = {name = "Cockroach", prices = {["default"] = 12.96, ["Ride"] = 111.45, ["Fly|Ride"] = 186.32, ["Neon"] = 74.82, ["Neon|Ride"] = 111.57, ["Mega"] = 328.13, ["Mega|Ride"] = 622.22}},
    ["rbxassetid://135555287601448"] = {name = "Rubber Ducky", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 38.69, ["Mega"] = 15.73, ["Mega|Ride"] = 50.31, ["Mega|Fly|Ride"] = 154.25}},
    ["rbxassetid://9664487060"] = {name = "Ant", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 15.73, ["Fly|Ride"] = 26.17, ["Neon"] = 2.1, ["Neon|Fly"] = 35.39, ["Neon|Ride"] = 11.54, ["Neon|Fly|Ride"] = 34.05, ["Mega"] = 17.07, ["Mega|Fly"] = 30.19, ["Mega|Ride"] = 18.87, ["Mega|Fly|Ride"] = 59.76}},
    ["rbxassetid://3293758505"] = {name = "Otter", prices = {["default"] = 2.1, ["Fly"] = 131.25, ["Ride"] = 15.73, ["Fly|Ride"] = 26.17, ["Neon"] = 4.19, ["Neon|Fly"] = 14.36, ["Neon|Ride"] = 13.64, ["Neon|Fly|Ride"] = 47.12, ["Mega"] = 24.94, ["Mega|Fly"] = 63.7, ["Mega|Ride"] = 79.02, ["Mega|Fly|Ride"] = 94.48}},
    ["rbxassetid://79698905581979"] = {name = "Ms. Muffet", prices = {["default"] = 2.1, ["Ride"] = 31.5, ["Fly|Ride"] = 125.73, ["Neon"] = 2.1, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 58.97, ["Mega"] = 15.62, ["Mega|Ride"] = 147, ["Mega|Fly|Ride"] = 209.63}},
    ["rbxassetid://13620861015"] = {name = "Flying Fish", prices = {["default"] = 2.1, ["Fly"] = 118.12, ["Ride"] = 16.56, ["Fly|Ride"] = 107.62, ["Neon"] = 3.45, ["Neon|Fly"] = 135.08, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 71.06, ["Mega"] = 41.41, ["Mega|Fly"] = 83.84, ["Mega|Ride"] = 53.48, ["Mega|Fly|Ride"] = 96.41}},
    ["rbxassetid://100439668574210"] = {name = "Jiggly Jerboa", prices = {["default"] = 2.1, ["Ride"] = 15.75, ["Neon"] = 3.97, ["Neon|Fly|Ride"] = 204.75, ["Mega"] = 21.95, ["Mega|Fly"] = 100.61, ["Mega|Ride"] = 91.04}},
    ["rbxassetid://14815828879"] = {name = "Ghost", prices = {["default"] = 3.93, ["Fly"] = 54.47, ["Ride"] = 17.05, ["Fly|Ride"] = 48.4, ["Neon"] = 6.12, ["Neon|Fly"] = 52.31, ["Neon|Ride"] = 16.96, ["Neon|Fly|Ride"] = 66.94, ["Mega"] = 57.64, ["Mega|Fly"] = 140.42, ["Mega|Ride"] = 76.55, ["Mega|Fly|Ride"] = 122.06}},
    ["rbxassetid://140565380261180"] = {name = "Galapagos Sea Lion", prices = {["default"] = 2.1, ["Ride"] = 43.29, ["Neon"] = 2.1, ["Neon|Ride"] = 26.24, ["Neon|Fly|Ride"] = 157.37, ["Mega"] = 15.42, ["Mega|Fly"] = 98.44, ["Mega|Ride"] = 63.7, ["Mega|Fly|Ride"] = 127.32}},
    ["rbxassetid://14146188240"] = {name = "Bluebottle Fly", prices = {["default"] = 2.1, ["Fly|Ride"] = 524.99, ["Neon"] = 17.7, ["Mega"] = 313.29, ["Mega|Fly"] = 314.99, ["Mega|Ride"] = 344.97}},
    ["rbxassetid://15930540035"] = {name = "Sandfish", prices = {["default"] = 2.1, ["Ride"] = 27.57, ["Neon"] = 22.32, ["Mega"] = 103.69, ["Mega|Fly|Ride"] = 377.21}},
    ["rbxassetid://74774507671765"] = {name = "Island Tarsier", prices = {["default"] = 2.1, ["Ride"] = 32.82, ["Neon"] = 5.16, ["Neon|Ride"] = 37.73, ["Neon|Fly|Ride"] = 98.51, ["Mega"] = 31.85, ["Mega|Ride"] = 59.73, ["Mega|Fly|Ride"] = 131.14}},
    ["rbxassetid://9678196095"] = {name = "Mouse", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 15.73, ["Fly|Ride"] = 30.14, ["Neon"] = 2.1, ["Neon|Fly"] = 27.25, ["Neon|Ride"] = 15.73, ["Neon|Fly|Ride"] = 36.75, ["Mega"] = 14.44, ["Mega|Fly"] = 39.2, ["Mega|Ride"] = 28.03, ["Mega|Fly|Ride"] = 62.89}},
    ["rbxassetid://100695038890951"] = {name = "Basic Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13104111122"] = {name = "Piranha", prices = {["default"] = 2.1, ["Fly"] = 72.19, ["Ride"] = 26.25, ["Fly|Ride"] = 104.98, ["Neon"] = 32.82, ["Neon|Ride"] = 39.82, ["Mega"] = 266.14, ["Mega|Ride"] = 274.54}},
    ["rbxassetid://110856597065248"] = {name = "Bakeneko", prices = {["default"] = 2.1, ["Ride"] = 17.93, ["Fly|Ride"] = 78.73, ["Neon"] = 4.54, ["Neon|Ride"] = 39.29, ["Neon|Fly|Ride"] = 59.07, ["Mega"] = 32.69, ["Mega|Ride"] = 139.13, ["Mega|Fly|Ride"] = 137.82}},
    ["rbxassetid://128979941112615"] = {name = "Dirty Ducky", prices = {["default"] = 2.93, ["Neon"] = 8.97, ["Neon|Fly|Ride"] = 140.42, ["Mega"] = 87.94, ["Mega|Ride"] = 118.13}},
    ["rbxassetid://12479656052"] = {name = "Maleo Bird", prices = {["default"] = 2.59, ["Fly"] = 131.25, ["Ride"] = 32.81, ["Fly|Ride"] = 43.32, ["Neon"] = 12.79, ["Neon|Ride"] = 70.2, ["Neon|Fly|Ride"] = 140.42, ["Mega"] = 103.84, ["Mega|Ride"] = 85.31, ["Mega|Fly|Ride"] = 106.88}},
    ["rbxassetid://3200646599"] = {name = "Cat", prices = {["default"] = 2.1, ["Fly"] = 39.32, ["Ride"] = 12.59, ["Fly|Ride"] = 33.5, ["Neon"] = 2.1, ["Neon|Fly"] = 13.9, ["Neon|Ride"] = 13.55, ["Neon|Fly|Ride"] = 31.39, ["Mega"] = 14.68, ["Mega|Fly"] = 24.94, ["Mega|Ride"] = 17.07, ["Mega|Fly|Ride"] = 52.4}},
    ["rbxassetid://12479810452"] = {name = "Bali Starling", prices = {["default"] = 2.63, ["Fly"] = 24.45, ["Ride"] = 18.86, ["Fly|Ride"] = 80.2, ["Neon"] = 15.65, ["Neon|Ride"] = 113.23, ["Neon|Fly|Ride"] = 83.84, ["Mega"] = 78.75, ["Mega|Ride"] = 152.6, ["Mega|Fly|Ride"] = 196.77}},
    ["rbxassetid://9982819219"] = {name = "Dugong", prices = {["default"] = 3.29, ["Fly"] = 41.91, ["Ride"] = 24.11, ["Fly|Ride"] = 140.51, ["Neon"] = 31.5, ["Neon|Ride"] = 112.11, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 279.55, ["Mega|Ride"] = 278.07, ["Mega|Fly|Ride"] = 387.85}},
    ["rbxassetid://3181727229"] = {name = "Buffalo", prices = {["default"] = 2.1, ["Fly"] = 15.1, ["Ride"] = 12.99, ["Fly|Ride"] = 26.16, ["Neon"] = 2.5, ["Neon|Fly"] = 20.24, ["Neon|Ride"] = 15.73, ["Neon|Fly|Ride"] = 44.02, ["Mega"] = 15.23, ["Mega|Fly"] = 156.19, ["Mega|Fly|Ride"] = 92.29}},
    ["rbxassetid://99694153348188"] = {name = "Urchin", prices = {["default"] = 2.63, ["Fly"] = 174.98, ["Ride"] = 56.79, ["Neon"] = 4.5, ["Neon|Fly"] = 77.49, ["Neon|Ride"] = 40.68, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 39.26, ["Mega|Fly"] = 167.66, ["Mega|Ride"] = 82.57}},
    ["rbxassetid://84089584046947"] = {name = "Blue Butterfly", prices = {["default"] = 2.62, ["Ride"] = 24.95, ["Neon"] = 6.57, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 156.13, ["Neon|Fly|Ride"] = 137.71, ["Mega"] = 32.82, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://124485808787576"] = {name = "Tegu", prices = {["default"] = 2.1, ["Fly"] = 44.01, ["Ride"] = 16.73, ["Neon"] = 2.1, ["Neon|Fly"] = 41.92, ["Neon|Ride"] = 20.87, ["Neon|Fly|Ride"] = 83.74, ["Mega"] = 14.01, ["Mega|Ride"] = 39.38, ["Mega|Fly|Ride"] = 125.63}},
    ["rbxassetid://8938703774"] = {name = "Bullfrog", prices = {["default"] = 2.1, ["Fly"] = 98.49, ["Ride"] = 17.05, ["Fly|Ride"] = 42.02, ["Neon"] = 6.27, ["Neon|Fly"] = 45.59, ["Neon|Ride"] = 23.61, ["Neon|Fly|Ride"] = 73.5, ["Mega"] = 70.22, ["Mega|Ride"] = 138.32, ["Mega|Fly|Ride"] = 263}},
    ["rbxassetid://102746202827395"] = {name = "Hopbop", prices = {["default"] = 2.1, ["Ride"] = 97.56, ["Neon"] = 5.97, ["Neon|Ride"] = 42.42, ["Neon|Fly|Ride"] = 94.35, ["Mega"] = 51.91, ["Mega|Fly|Ride"] = 335.3}},
    ["rbxassetid://6498255997"] = {name = "Stingray", prices = {["default"] = 2.1, ["Fly"] = 28.73, ["Ride"] = 13.19, ["Fly|Ride"] = 140.39, ["Neon"] = 4.52, ["Neon|Fly"] = 69.86, ["Neon|Ride"] = 25.08, ["Neon|Fly|Ride"] = 46.01, ["Mega"] = 83.58, ["Mega|Ride"] = 90.46, ["Mega|Fly|Ride"] = 157.39}},
    ["rbxassetid://13104106555"] = {name = "Mosquito", prices = {["default"] = 3.55, ["Ride"] = 82.69, ["Neon"] = 56.59, ["Mega"] = 209.96, ["Mega|Fly|Ride"] = 837.81}},
    ["rbxassetid://5721843483"] = {name = "Ground Sloth", prices = {["default"] = 2.1, ["Fly|Ride"] = 5423.96, ["Neon"] = 12.91, ["Neon|Fly"] = 140.39, ["Neon|Ride"] = 31.49, ["Neon|Fly|Ride"] = 59.07, ["Mega"] = 157.5, ["Mega|Ride"] = 59.07, ["Mega|Fly|Ride"] = 471.72}},
    ["rbxassetid://4506925908"] = {name = "Robin", prices = {["default"] = 2.1, ["Fly"] = 20.9, ["Ride"] = 30.56, ["Fly|Ride"] = 196.88, ["Neon"] = 14.2, ["Neon|Fly"] = 61.8, ["Neon|Ride"] = 38.88, ["Neon|Fly|Ride"] = 111.07, ["Mega"] = 209.57, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://10382786163"] = {name = "Sado Mole", prices = {["default"] = 2.1, ["Fly"] = 87.05, ["Fly|Ride"] = 106.14, ["Neon"] = 19.69, ["Mega"] = 200.17, ["Mega|Ride"] = 406.87}},
    ["rbxassetid://14471275373"] = {name = "Ash Zebra", prices = {["default"] = 13.13, ["Ride"] = 131.24, ["Neon"] = 140.39, ["Neon|Ride"] = 235.87, ["Mega"] = 937.77, ["Mega|Ride"] = 875.96, ["Mega|Fly|Ride"] = 794.07}},
    ["rbxassetid://15923574361"] = {name = "Armadillo", prices = {["default"] = 11.71, ["Ride"] = 49.25, ["Neon"] = 38.66, ["Neon|Ride"] = 52.5, ["Mega"] = 157.5, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 512.54}},
    ["rbxassetid://15921927876"] = {name = "Coyote", prices = {["default"] = 105, ["Ride"] = 43.32, ["Fly|Ride"] = 139.13, ["Neon"] = 74.41, ["Neon|Ride"] = 62.87, ["Neon|Fly|Ride"] = 82.57, ["Mega"] = 289.2, ["Mega|Ride"] = 255.94, ["Mega|Fly|Ride"] = 417.03}},
    ["rbxassetid://74353184935672"] = {name = "Sheepdog Ducky", prices = {["default"] = 2.24, ["Neon"] = 3.91, ["Neon|Ride"] = 64.98, ["Mega"] = 24.11, ["Mega|Ride"] = 139.13, ["Mega|Fly|Ride"] = 148.31}},
    ["rbxassetid://4748889845"] = {name = "Easter 2020 Egg", prices = {["default"] = 53.82}},
    ["rbxassetid://4752655872"] = {name = "Chick", prices = {["default"] = 3.94, ["Fly"] = 27.25, ["Ride"] = 20.79, ["Fly|Ride"] = 65.54, ["Neon"] = 37.17, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 47.12, ["Neon|Fly|Ride"] = 52.4, ["Mega"] = 283.5, ["Mega|Fly"] = 293.4, ["Mega|Ride"] = 275.82, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://17174085645"] = {name = "Garden Snake", prices = {["default"] = 2.1, ["Fly"] = 70.88, ["Ride"] = 18.37, ["Fly|Ride"] = 65.62, ["Neon"] = 2.1, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 30.19, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://17661844380"] = {name = "Show Pony", prices = {["default"] = 2.1, ["Ride"] = 36.66, ["Fly|Ride"] = 393.84, ["Neon"] = 6.56, ["Neon|Ride"] = 36.7, ["Neon|Fly|Ride"] = 402.59, ["Mega"] = 57.54, ["Mega|Ride"] = 69.49, ["Mega|Fly|Ride"] = 83.84}},
    ["rbxassetid://8077196440"] = {name = "Walrus", prices = {["default"] = 2.1, ["Fly"] = 45.93, ["Ride"] = 18.31, ["Fly|Ride"] = 55.65, ["Neon"] = 14.1, ["Neon|Ride"] = 31.36, ["Neon|Fly|Ride"] = 81.35, ["Mega"] = 148.6, ["Mega|Ride"] = 157.5}},
    ["rbxassetid://13104118499"] = {name = "Liger", prices = {["default"] = 5.04, ["Ride"] = 23, ["Neon"] = 58.97, ["Neon|Ride"] = 70.2, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 229.47, ["Mega|Ride"] = 315.73, ["Mega|Fly|Ride"] = 418.07}},
    ["rbxassetid://120937667166493"] = {name = "Aye Aye", prices = {["default"] = 2.1, ["Neon"] = 2.61, ["Neon|Ride"] = 49.2, ["Neon|Fly|Ride"] = 79.03, ["Mega"] = 32.82, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 53.45, ["Mega|Fly|Ride"] = 208.52}},
    ["rbxassetid://3199974297"] = {name = "Cracked Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15348350458"] = {name = "Beluga Whale", prices = {["default"] = 2.1, ["Fly"] = 16.78, ["Ride"] = 17.07, ["Fly|Ride"] = 279370.79, ["Neon"] = 5.2, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 20.97, ["Neon|Fly|Ride"] = 69.45, ["Mega"] = 48.56, ["Mega|Fly"] = 143.15, ["Mega|Ride"] = 52.49, ["Mega|Fly|Ride"] = 124.66}},
    ["rbxassetid://7126719464"] = {name = "Wolpertinger", prices = {["default"] = 2.1, ["Fly"] = 17.95, ["Ride"] = 17.05, ["Fly|Ride"] = 32.66, ["Neon"] = 7.74, ["Neon|Fly"] = 70.2, ["Neon|Ride"] = 23.62, ["Neon|Fly|Ride"] = 81.38, ["Mega"] = 60.16, ["Mega|Ride"] = 51.32, ["Mega|Fly|Ride"] = 158.29}},
    ["rbxassetid://125112456358906"] = {name = "Frankenfeline", prices = {["default"] = 2.1, ["Fly"] = 131.25, ["Ride"] = 36.73, ["Fly|Ride"] = 77.83, ["Neon"] = 3.94, ["Neon|Ride"] = 27.02, ["Neon|Fly|Ride"] = 107.29, ["Mega"] = 24.65, ["Mega|Ride"] = 38.75, ["Mega|Fly|Ride"] = 129.92}},
    ["rbxassetid://80556114592490"] = {name = "Japanese Snow Fairy", prices = {["default"] = 2.1, ["Neon"] = 3.94, ["Neon|Ride"] = 162.75, ["Neon|Fly|Ride"] = 138.32, ["Mega"] = 24.15, ["Mega|Fly"] = 104.99, ["Mega|Ride"] = 86.63, ["Mega|Fly|Ride"] = 203.28}},
    ["rbxassetid://124671555129102"] = {name = "Ratatoskr", prices = {["default"] = 2.1, ["Fly"] = 27.09, ["Ride"] = 18.87, ["Fly|Ride"] = 77.44, ["Neon"] = 5.25, ["Neon|Fly"] = 26.25, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 62.89, ["Mega"] = 32.82, ["Mega|Ride"] = 62.99, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://116184296449988"] = {name = "Pinkypillar", prices = {["default"] = 2.1, ["Ride"] = 19.69, ["Neon"] = 2.1, ["Neon|Ride"] = 59.07, ["Mega"] = 18.38, ["Mega|Ride"] = 126.19, ["Mega|Fly|Ride"] = 205.42}},
    ["rbxassetid://74353532164157"] = {name = "Red Panda Ducky", prices = {["default"] = 2.1, ["Neon"] = 6.02, ["Neon|Ride"] = 158.02, ["Mega"] = 28.3, ["Mega|Fly"] = 117.95, ["Mega|Ride"] = 120.5, ["Mega|Fly|Ride"] = 349.97}},
    ["rbxassetid://4708551264"] = {name = "Bandicoot", prices = {["default"] = 2.1, ["Fly"] = 28.3, ["Ride"] = 25.5, ["Fly|Ride"] = 69.57, ["Neon"] = 2.67, ["Neon|Ride"] = 20.55, ["Neon|Fly|Ride"] = 124.64, ["Mega"] = 41.92, ["Mega|Fly|Ride"] = 160.13}},
    ["rbxassetid://12480314681"] = {name = "Malaysian Tapir", prices = {["default"] = 15.75, ["Ride"] = 105, ["Neon"] = 131.24, ["Neon|Ride"] = 235.83, ["Mega"] = 436.46, ["Mega|Ride"] = 629.74, ["Mega|Fly|Ride"] = 622.39}},
    ["rbxassetid://17482380743"] = {name = "Classic Teapot", prices = {["default"] = 3.94, ["Fly"] = 6562.5, ["Ride"] = 68.24, ["Neon"] = 41.25, ["Neon|Ride"] = 207.44, ["Mega"] = 208.52, ["Mega|Ride"] = 344.54}},
    ["rbxassetid://14146142724"] = {name = "Mongoose", prices = {["default"] = 3.88, ["Ride"] = 26.24, ["Fly|Ride"] = 45.94, ["Neon"] = 13.13, ["Mega"] = 274.32, ["Mega|Ride"] = 178.14, ["Mega|Fly|Ride"] = 324.75}},
    ["rbxassetid://3181727351"] = {name = "Dog", prices = {["default"] = 2.1, ["Fly"] = 17.7, ["Ride"] = 13.12, ["Fly|Ride"] = 28.3, ["Neon"] = 2.1, ["Neon|Fly"] = 17.74, ["Neon|Ride"] = 13.88, ["Neon|Fly|Ride"] = 27.99, ["Mega"] = 13.9, ["Mega|Fly"] = 22.32, ["Mega|Ride"] = 20.99, ["Mega|Fly|Ride"] = 35.44}},
    ["rbxassetid://14267322852"] = {name = "Angelfish", prices = {["default"] = 4.22, ["Fly"] = 118.12, ["Ride"] = 55.12, ["Fly|Ride"] = 70.2, ["Neon"] = 10.4, ["Neon|Fly"] = 83.83, ["Neon|Ride"] = 28.3, ["Neon|Fly|Ride"] = 698.87, ["Mega"] = 70.22, ["Mega|Ride"] = 112.12, ["Mega|Fly|Ride"] = 119.45}},
    ["rbxassetid://110130591707207"] = {name = "California Condor", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Fly"] = 25.03, ["Neon|Ride"] = 18.31, ["Neon|Fly|Ride"] = 78.54, ["Mega"] = 12.9, ["Mega|Fly"] = 57.74, ["Mega|Ride"] = 52.41, ["Mega|Fly|Ride"] = 99.9}},
    ["rbxassetid://123567499475377"] = {name = "Forest Sprite", prices = {["default"] = 2.1, ["Neon"] = 3.81, ["Neon|Fly"] = 60.9, ["Neon|Ride"] = 91.88, ["Mega"] = 20.25, ["Mega|Ride"] = 106.88, ["Mega|Fly|Ride"] = 150.93}},
    ["rbxassetid://8663441035"] = {name = "Lunar White Tiger", prices = {["default"] = 2.1, ["Fly"] = 20.75, ["Ride"] = 15.75, ["Fly|Ride"] = 54.49, ["Neon"] = 15.71, ["Neon|Fly"] = 140.39, ["Neon|Ride"] = 30.15, ["Neon|Fly|Ride"] = 85.45, ["Mega"] = 143.14, ["Mega|Ride"] = 249.27, ["Mega|Fly|Ride"] = 323.13}},
    ["rbxassetid://16000498338"] = {name = "Groundhog", prices = {["default"] = 150.66, ["Ride"] = 163.38, ["Fly|Ride"] = 262.5, ["Neon"] = 1020.42, ["Neon|Fly|Ride"] = 1102.26, ["Mega"] = 8382.14, ["Mega|Fly|Ride"] = 3339.26}},
    ["rbxassetid://73268582142443"] = {name = "Kelp Raider", prices = {["default"] = 2.1, ["Neon"] = 6.18, ["Neon|Fly"] = 56.59, ["Neon|Ride"] = 68.25, ["Mega"] = 87.93, ["Mega|Ride"] = 94.35, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://16369178617"] = {name = "Ornate Horned Frog", prices = {["default"] = 94.5, ["Fly"] = 103.68, ["Ride"] = 25.97, ["Fly|Ride"] = 140.39, ["Neon"] = 59.07, ["Neon|Ride"] = 164.29, ["Neon|Fly|Ride"] = 158.23, ["Mega"] = 419.12, ["Mega|Ride"] = 564.38, ["Mega|Fly|Ride"] = 1047.78}},
    ["rbxassetid://6245080170"] = {name = "Lunar Ox", prices = {["default"] = 2.1, ["Fly"] = 13.17, ["Ride"] = 16.82, ["Fly|Ride"] = 36.66, ["Neon"] = 5.25, ["Neon|Fly"] = 43.32, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 57.75, ["Mega|Ride"] = 59.98, ["Mega|Fly|Ride"] = 140.35}},
    ["rbxassetid://92652981666929"] = {name = "Starmite", prices = {["default"] = 2.1, ["Fly"] = 28.3, ["Ride"] = 17.07, ["Fly|Ride"] = 120.89, ["Neon"] = 20.97, ["Neon|Ride"] = 103.18, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 95.7, ["Mega|Ride"] = 136.5}},
    ["rbxassetid://9482496753"] = {name = "King Penguin", prices = {["default"] = 3.73, ["Fly"] = 26.24, ["Ride"] = 17.97, ["Fly|Ride"] = 39.36, ["Neon"] = 30.4, ["Neon|Ride"] = 45.86, ["Neon|Fly|Ride"] = 91.88, ["Mega|Ride"] = 279.78, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://10489161125"] = {name = "Tanuki", prices = {["default"] = 3.67, ["Fly"] = 28.04, ["Ride"] = 41.92, ["Fly|Ride"] = 249.58, ["Neon"] = 44.54, ["Neon|Ride"] = 127.32, ["Neon|Fly|Ride"] = 622.39, ["Mega"] = 327.48, ["Mega|Ride"] = 354.16, ["Mega|Fly|Ride"] = 399}},
    ["rbxassetid://7126720060"] = {name = "Wyvern", prices = {["default"] = 2.1, ["Fly"] = 17.07, ["Ride"] = 17.55, ["Fly|Ride"] = 38.85, ["Neon"] = 43.77, ["Neon|Fly"] = 56.59, ["Neon|Ride"] = 27.25, ["Neon|Fly|Ride"] = 60.63, ["Mega"] = 133.07, ["Mega|Fly"] = 243.1, ["Mega|Ride"] = 698.87, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://4506925800"] = {name = "Swan", prices = {["default"] = 63.67, ["Fly"] = 120.49, ["Ride"] = 83.58, ["Fly|Ride"] = 131.23, ["Neon"] = 328.13, ["Neon|Fly"] = 406.88, ["Neon|Ride"] = 387.18, ["Neon|Fly|Ride"] = 471.52, ["Mega|Fly|Ride"] = 1644.57}},
    ["rbxassetid://13621428133"] = {name = "Tortuga de la Isla", prices = {["default"] = 216.57, ["Fly"] = 322.18, ["Ride"] = 233.76, ["Fly|Ride"] = 279.74, ["Neon"] = 907.94, ["Neon|Ride"] = 1466.71, ["Neon|Fly|Ride"] = 1397.74, ["Mega"] = 10477.68, ["Mega|Fly|Ride"] = 10220.66}},
    ["rbxassetid://6684832189"] = {name = "Lamb", prices = {["default"] = 78.75, ["Fly"] = 140.39, ["Ride"] = 77.44, ["Fly|Ride"] = 131.25, ["Neon"] = 379.25, ["Neon|Ride"] = 277.56, ["Neon|Fly|Ride"] = 375.38, ["Mega|Ride"] = 1397.74, ["Mega|Fly|Ride"] = 1246.87}},
    ["rbxassetid://122365328950491"] = {name = "Blossom Snake", prices = {["default"] = 4.31, ["Fly"] = 83.83, ["Ride"] = 30.4, ["Neon"] = 27.67, ["Neon|Ride"] = 52.11, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 188.69, ["Mega|Ride"] = 193.6, ["Mega|Fly|Ride"] = 331.1}},
    ["rbxassetid://14360919997"] = {name = "Toasty Red Panda", prices = {["default"] = 12.66, ["Fly"] = 68.16, ["Ride"] = 35.44, ["Fly|Ride"] = 70.2, ["Neon"] = 167.64, ["Neon|Ride"] = 97.09, ["Mega"] = 351.75, ["Mega|Ride"] = 451.5, ["Mega|Fly|Ride"] = 551.14}},
    ["rbxassetid://3181727278"] = {name = "Rabbit", prices = {["default"] = 2.1, ["Fly"] = 18.08, ["Ride"] = 23.06, ["Fly|Ride"] = 30.4, ["Neon"] = 4.72, ["Neon|Fly"] = 23.46, ["Neon|Ride"] = 20.73, ["Neon|Fly|Ride"] = 69.57, ["Mega"] = 49.58, ["Mega|Fly"] = 209.92, ["Mega|Ride"] = 111.05, ["Mega|Fly|Ride"] = 129.93}},
    ["rbxassetid://14782579567"] = {name = "Nightmare Owl", prices = {["default"] = 4.82, ["Fly"] = 72.1, ["Ride"] = 20.57, ["Fly|Ride"] = 139.83, ["Neon"] = 43.47, ["Neon|Ride"] = 158.02, ["Neon|Fly|Ride"] = 141.51, ["Mega"] = 796.32, ["Mega|Ride"] = 628.67, ["Mega|Fly|Ride"] = 559.53}},
    ["rbxassetid://6498256342"] = {name = "Narwhal", prices = {["default"] = 2.1, ["Fly"] = 30.53, ["Ride"] = 14.44, ["Fly|Ride"] = 56.59, ["Neon"] = 18.38, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 94.58, ["Mega"] = 131.25, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 179.82}},
    ["rbxassetid://9227407648"] = {name = "Ibex", prices = {["default"] = 2.63, ["Ride"] = 28.14, ["Fly|Ride"] = 328.13, ["Neon"] = 41.92, ["Neon|Ride"] = 55.44, ["Neon|Fly|Ride"] = 235.87, ["Mega"] = 207.37, ["Mega|Ride"] = 208.52, ["Mega|Fly|Ride"] = 337.84}},
    ["rbxassetid://16440727263"] = {name = "Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 28.88, ["Ride"] = 131.24, ["Neon"] = 2.1, ["Neon|Ride"] = 18.47, ["Neon|Fly|Ride"] = 47.38, ["Mega"] = 15.75, ["Mega|Ride"] = 26.25, ["Mega|Fly|Ride"] = 223.01}},
    ["rbxassetid://10318106327"] = {name = "Yellow Butterfly", prices = {["default"] = 2.1, ["Fly"] = 45.93, ["Ride"] = 20.91, ["Fly|Ride"] = 45.94, ["Neon"] = 11.82, ["Neon|Fly"] = 104.78, ["Neon|Ride"] = 41.92, ["Neon|Fly|Ride"] = 63.8, ["Mega"] = 108.94, ["Mega|Ride"] = 98.51, ["Mega|Fly|Ride"] = 190.32}},
    ["rbxassetid://13894169749"] = {name = "Black Kite", prices = {["default"] = 3.86, ["Fly"] = 24.92, ["Ride"] = 18.26, ["Fly|Ride"] = 45.75, ["Neon"] = 63.7, ["Neon|Fly"] = 140.39, ["Neon|Ride"] = 47.25, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 283.5, ["Mega|Ride"] = 140.42, ["Mega|Fly|Ride"] = 233.67}},
    ["rbxassetid://4506925595"] = {name = "Polar Bear", prices = {["default"] = 170.63, ["Fly"] = 224.21, ["Ride"] = 224.21, ["Fly|Ride"] = 280.88, ["Neon"] = 700.87, ["Neon|Ride"] = 629.66, ["Neon|Fly|Ride"] = 656.25, ["Mega|Ride"] = 3478.13, ["Mega|Fly|Ride"] = 2625}},
    ["rbxassetid://14639006189"] = {name = "Canada Goose", prices = {["default"] = 8.99, ["Ride"] = 240.91, ["Fly|Ride"] = 204.3, ["Neon"] = 38.07, ["Neon|Ride"] = 160.13, ["Neon|Fly|Ride"] = 156.19, ["Mega"] = 313.74, ["Mega|Ride"] = 371.48, ["Mega|Fly|Ride"] = 328.12}},
    ["rbxassetid://5721844402"] = {name = "Triceratops", prices = {["default"] = 2.1, ["Ride"] = 16.78, ["Fly|Ride"] = 40.11, ["Neon"] = 22.79, ["Neon|Ride"] = 40.69, ["Neon|Fly|Ride"] = 64.97, ["Mega"] = 279.78, ["Mega|Ride"] = 170.63, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://83805820117149"] = {name = "Golden Jaguar", prices = {["default"] = 59.07, ["Ride"] = 36.98, ["Fly|Ride"] = 178.5, ["Neon"] = 103.11, ["Neon|Ride"] = 124.69, ["Neon|Fly|Ride"] = 294.54, ["Mega"] = 509.4, ["Mega|Ride"] = 469.88, ["Mega|Fly|Ride"] = 597.91}},
    ["rbxassetid://13936754497"] = {name = "Pinocchio", prices = {["default"] = 2.1}},
    ["rbxassetid://17059776562"] = {name = "Ankylosaurus", prices = {["default"] = 3.88, ["Ride"] = 33.47, ["Neon"] = 28.24, ["Neon|Ride"] = 151.52, ["Neon|Fly|Ride"] = 628.67, ["Mega"] = 236.25, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 556.38}},
    ["rbxassetid://3181727813"] = {name = "Horse", prices = {["default"] = 22.29, ["Fly"] = 39.38, ["Ride"] = 27.57, ["Fly|Ride"] = 39.38, ["Neon|Fly"] = 101818.18, ["Neon|Ride"] = 198.98, ["Neon|Fly|Ride"] = 181.61, ["Mega"] = 523.89, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://101098195340953"] = {name = "Mexican Wolf", prices = {["default"] = 2.1, ["Ride"] = 39.38, ["Fly|Ride"] = 78.74, ["Neon"] = 3.93, ["Neon|Ride"] = 53.17, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 25.73, ["Mega|Fly"] = 413.88, ["Mega|Ride"] = 65.61, ["Mega|Fly|Ride"] = 140.42}},
    ["rbxassetid://13894408663"] = {name = "Seagull", prices = {["default"] = 3.94, ["Fly"] = 26.99, ["Ride"] = 28.3, ["Fly|Ride"] = 112.54, ["Neon"] = 83.83, ["Neon|Ride"] = 235.83, ["Mega"] = 182.33, ["Mega|Fly"] = 393.88, ["Mega|Ride"] = 147, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://6998403532"] = {name = "Sasquatch", prices = {["default"] = 2.1, ["Fly"] = 45.06, ["Ride"] = 16.71, ["Fly|Ride"] = 45.65, ["Neon"] = 15.75, ["Neon|Fly"] = 186.9, ["Neon|Ride"] = 32.81, ["Neon|Fly|Ride"] = 78.66, ["Mega"] = 124.69, ["Mega|Ride"] = 140.4, ["Mega|Fly|Ride"] = 224.88}},
    ["rbxassetid://108348392849720"] = {name = "Water Opossum", prices = {["default"] = 2.1, ["Ride"] = 22.99, ["Neon"] = 3.85, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 31.42, ["Neon|Fly|Ride"] = 158.04, ["Mega"] = 31.49, ["Mega|Ride"] = 70.22, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://11758575705"] = {name = "Moon Rabbit", prices = {["default"] = 27.15, ["Ride"] = 56.59, ["Neon"] = 170.63, ["Neon|Fly|Ride"] = 581.63, ["Mega"] = 931.47, ["Mega|Ride"] = 951.39, ["Mega|Fly|Ride"] = 878.63}},
    ["rbxassetid://15922874831"] = {name = "Roadrunner", prices = {["default"] = 3.28, ["Ride"] = 26.25, ["Neon"] = 80.07, ["Neon|Ride"] = 75.45, ["Neon|Fly|Ride"] = 209.57, ["Mega"] = 278.73, ["Mega|Ride"] = 524.99, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://6060988175"] = {name = "Snowman", prices = {["default"] = 12.59, ["Fly"] = 139.53, ["Ride"] = 38.05, ["Fly|Ride"] = 140.39, ["Neon"] = 87.66, ["Neon|Fly"] = 314.99, ["Neon|Ride"] = 224.21, ["Neon|Fly|Ride"] = 415.8, ["Mega|Fly|Ride"] = 522.85}},
    ["rbxassetid://12720029414"] = {name = "Wood Pigeon", prices = {["default"] = 54.5, ["Fly"] = 98.49, ["Ride"] = 103.69, ["Fly|Ride"] = 262.44, ["Neon"] = 278.69, ["Neon|Ride"] = 349.93, ["Neon|Fly|Ride"] = 622.39, ["Mega|Ride"] = 1968.75, ["Mega|Fly|Ride"] = 1311.19}},
    ["rbxassetid://136340738568203"] = {name = "Mr Whiskerpips", prices = {["default"] = 11.69, ["Fly"] = 39.38, ["Ride"] = 27.03, ["Fly|Ride"] = 55.59, ["Neon"] = 63, ["Neon|Ride"] = 70.01, ["Neon|Fly|Ride"] = 125.74, ["Mega"] = 236.25, ["Mega|Ride"] = 299.54, ["Mega|Fly|Ride"] = 504.74}},
    ["rbxassetid://127204329704553"] = {name = "German Shepherd", prices = {["default"] = 85.31, ["Fly"] = 145.69, ["Ride"] = 111.83, ["Fly|Ride"] = 212.25, ["Neon"] = 203.43, ["Neon|Ride"] = 278.13, ["Neon|Fly|Ride"] = 279.78, ["Mega"] = 2043.68, ["Mega|Fly"] = 1022.43, ["Mega|Ride"] = 975.49, ["Mega|Fly|Ride"] = 812.44}},
    ["rbxassetid://99868640713300"] = {name = "Puptune", prices = {["default"] = 19.69, ["Ride"] = 66.92, ["Fly|Ride"] = 173.25, ["Neon"] = 86.62, ["Neon|Ride"] = 125.31, ["Neon|Fly|Ride"] = 838.23, ["Mega"] = 370.93, ["Mega|Ride"] = 304.5, ["Mega|Fly|Ride"] = 450.19}},
    ["rbxassetid://9993276067"] = {name = "2022 Uplift Butterfly", prices = {["default"] = 2.1, ["Fly"] = 69.51, ["Ride"] = 19.69, ["Fly|Ride"] = 45.94, ["Neon"] = 82.68, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 125.74, ["Mega"] = 625.19, ["Mega|Ride"] = 1047.78, ["Mega|Fly|Ride"] = 400.96}},
    ["rbxassetid://136574776317301"] = {name = "Sweetheart Rat", prices = {["default"] = 20.99, ["Ride"] = 94.34, ["Fly|Ride"] = 107.97, ["Neon"] = 78.74, ["Neon|Ride"] = 158.02, ["Neon|Fly|Ride"] = 278.5, ["Mega"] = 455.79, ["Mega|Ride"] = 346.5, ["Mega|Fly|Ride"] = 475.13}},
    ["rbxassetid://17649489402"] = {name = "Cow Calf", prices = {["default"] = 9.96, ["Ride"] = 34.13, ["Fly|Ride"] = 135.61, ["Neon"] = 43.22, ["Neon|Ride"] = 89.25, ["Neon|Fly|Ride"] = 125.74, ["Mega"] = 262.5, ["Mega|Ride"] = 301.88, ["Mega|Fly|Ride"] = 483}},
    ["rbxassetid://77869404304609"] = {name = "Budgie Witch", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Fly"] = 54.49, ["Neon|Ride"] = 56.25, ["Neon|Fly|Ride"] = 99.56, ["Mega"] = 18, ["Mega|Fly"] = 140.42, ["Mega|Fly|Ride"] = 182.44}},
    ["rbxassetid://111676861947081"] = {name = "The Black Dog", prices = {["default"] = 3.24, ["Ride"] = 22.32, ["Fly|Ride"] = 434.78, ["Neon"] = 19.67, ["Neon|Fly"] = 125.73, ["Neon|Ride"] = 83.84, ["Mega"] = 105, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 471.72}},
    ["rbxassetid://13104122472"] = {name = "Borhyaena Gigantica", prices = {["default"] = 3.94, ["Ride"] = 37.73, ["Neon"] = 22.64, ["Neon|Ride"] = 103.73, ["Mega"] = 383.92, ["Mega|Ride"] = 188.61, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://105232492496005"] = {name = "Firefighter Gibbon", prices = {["default"] = 5.14, ["Ride"] = 31.5, ["Fly|Ride"] = 116.75, ["Neon"] = 15.75, ["Neon|Ride"] = 82.95, ["Neon|Fly|Ride"] = 272.44, ["Mega"] = 123.37, ["Mega|Ride"] = 155.06, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://3409443514"] = {name = "Elephant", prices = {["default"] = 530.25, ["Ride"] = 529.94, ["Fly|Ride"] = 586.28, ["Neon|Ride"] = 1443.75, ["Neon|Fly|Ride"] = 1312.49, ["Mega|Fly|Ride"] = 5840.63}},
    ["rbxassetid://10137833682"] = {name = "Brown-Chested Pheasant", prices = {["default"] = 7.04, ["Fly"] = 27.75, ["Ride"] = 25.16, ["Fly|Ride"] = 52.84, ["Neon"] = 52.5, ["Neon|Ride"] = 70.12, ["Neon|Fly|Ride"] = 210, ["Mega|Ride"] = 278.25}},
    ["rbxassetid://12490691849"] = {name = "Gecko", prices = {["default"] = 11.76, ["Fly"] = 39.38, ["Ride"] = 19.68, ["Fly|Ride"] = 52.5, ["Neon"] = 57.75, ["Neon|Ride"] = 104.78, ["Mega"] = 371.97, ["Mega|Ride"] = 275.63, ["Mega|Fly|Ride"] = 328.12}},
    ["rbxassetid://9913459163"] = {name = "Trapdoor Snail", prices = {["default"] = 3.92, ["Fly"] = 28.3, ["Ride"] = 20.97, ["Fly|Ride"] = 314.31, ["Neon|Ride"] = 196.87, ["Neon|Fly|Ride"] = 126.19, ["Mega"] = 203.44, ["Mega|Ride"] = 629.74, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://124413732651376"] = {name = "Gumball Caterpillar", prices = {["default"] = 2.1, ["Fly"] = 54.12, ["Ride"] = 29.54, ["Fly|Ride"] = 90.57, ["Neon"] = 7.17, ["Neon|Ride"] = 28.31, ["Neon|Fly|Ride"] = 118.41, ["Mega"] = 61.74, ["Mega|Ride"] = 97.68, ["Mega|Fly|Ride"] = 213.76}},
    ["rbxassetid://96107383056013"] = {name = "Gummy Guana", prices = {["default"] = 2.1, ["Fly"] = 70.2, ["Ride"] = 27.25, ["Neon"] = 3.89, ["Neon|Ride"] = 31.82, ["Mega"] = 25.73, ["Mega|Ride"] = 54.76, ["Mega|Fly|Ride"] = 150.94}},
    ["rbxassetid://3261465951"] = {name = "Blue Egg", prices = {["default"] = 1545.48}},
    ["rbxassetid://11245006051"] = {name = "Therapy Dog", prices = {["default"] = 11.54, ["Ride"] = 28.3, ["Fly|Ride"] = 68.81, ["Neon"] = 79.02, ["Neon|Fly"] = 140.39, ["Neon|Ride"] = 83.74, ["Mega|Ride"] = 326.82, ["Mega|Fly|Ride"] = 796.32}},
    ["rbxassetid://76323474173289"] = {name = "Kelp Crewmate", prices = {["default"] = 2.1, ["Ride"] = 23.76, ["Neon"] = 5.08, ["Neon|Ride"] = 40.69, ["Mega"] = 55.13, ["Mega|Ride"] = 101.07, ["Mega|Fly|Ride"] = 166.69}},
    ["rbxassetid://14978701264"] = {name = "Scarecrow Horse", prices = {["default"] = 2.1, ["Fly"] = 98.49, ["Ride"] = 20.95, ["Fly|Ride"] = 574.38, ["Neon"] = 14.43, ["Neon|Fly"] = 125.73, ["Neon|Ride"] = 62.87, ["Neon|Fly|Ride"] = 133.88, ["Mega"] = 125.74, ["Mega|Ride"] = 241.5, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://3409443801"] = {name = "Lion", prices = {["default"] = 393.75, ["Ride"] = 418.69, ["Fly|Ride"] = 490.94, ["Neon|Ride"] = 1534.32, ["Neon|Fly|Ride"] = 1536.05, ["Mega|Fly|Ride"] = 6562.5}},
    ["rbxassetid://13979014954"] = {name = "Fossa", prices = {["default"] = 7.08, ["Fly"] = 196.88, ["Ride"] = 72.19, ["Neon"] = 82.42, ["Neon|Ride"] = 131.25, ["Mega"] = 328.12, ["Mega|Ride"] = 448.13}},
    ["rbxassetid://137886461285917"] = {name = "Angus Cow", prices = {["default"] = 2.1, ["Ride"] = 40.87, ["Fly|Ride"] = 48.21, ["Neon"] = 6.56, ["Neon|Ride"] = 35.44, ["Neon|Fly|Ride"] = 419.12, ["Mega"] = 49.88, ["Mega|Fly"] = 189, ["Mega|Ride"] = 108.84, ["Mega|Fly|Ride"] = 207.25}},
    ["rbxassetid://128343324254978"] = {name = "Blue Cat", prices = {["default"] = 2.1, ["Ride"] = 21, ["Neon"] = 5.19, ["Neon|Ride"] = 47.19, ["Neon|Fly|Ride"] = 266.14, ["Mega"] = 23.24, ["Mega|Ride"] = 146.71, ["Mega|Fly|Ride"] = 217.88}},
    ["rbxassetid://79274485636628"] = {name = "Indian Flying Fox", prices = {["default"] = 7.88, ["Fly"] = 56.27, ["Ride"] = 66.08, ["Fly|Ride"] = 167.64, ["Neon"] = 65.62, ["Neon|Ride"] = 104.78, ["Neon|Fly|Ride"] = 279.66, ["Mega"] = 301.88, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 372.75}},
    ["rbxassetid://96039704958671"] = {name = "Singularity Pisces", prices = {["default"] = 11.81, ["Ride"] = 98.49, ["Neon"] = 89.63, ["Neon|Ride"] = 123.25, ["Neon|Fly|Ride"] = 834.75, ["Mega"] = 393.75, ["Mega|Ride"] = 349.79, ["Mega|Fly|Ride"] = 1076.93}},
    ["rbxassetid://12489494348"] = {name = "Komodo Dragon", prices = {["default"] = 5.23, ["Ride"] = 31.5, ["Fly|Ride"] = 382.22, ["Neon"] = 105, ["Neon|Ride"] = 200.82, ["Mega"] = 419.12, ["Mega|Ride"] = 557.19, ["Mega|Fly|Ride"] = 1246.88}},
    ["rbxassetid://14360919129"] = {name = "Flaming Zebra", prices = {["default"] = 28.3, ["Ride"] = 65.63, ["Neon"] = 237.83, ["Neon|Ride"] = 180.06, ["Neon|Fly|Ride"] = 511.87, ["Mega"] = 459.38, ["Mega|Ride"] = 572.1, ["Mega|Fly|Ride"] = 665.44}},
    ["rbxassetid://108242367048842"] = {name = "Honey Badger", prices = {["default"] = 262.5, ["Ride"] = 261.19, ["Fly|Ride"] = 616.88, ["Neon"] = 1786.37, ["Neon|Fly"] = 1195.64, ["Neon|Ride"] = 1424.8, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Ride"] = 3494.32, ["Mega|Fly|Ride"] = 3465}},
    ["rbxassetid://11119262646"] = {name = "Evil Chickatrice", prices = {["default"] = 3.66, ["Fly"] = 69.65, ["Ride"] = 22.43, ["Fly|Ride"] = 140.39, ["Neon"] = 94.55, ["Neon|Ride"] = 140.39, ["Neon|Fly|Ride"] = 137.65, ["Mega"] = 559.53, ["Mega|Ride"] = 282.19, ["Mega|Fly|Ride"] = 561.75}},
    ["rbxassetid://120631772928905"] = {name = "Subzero Scorpion", prices = {["default"] = 28.07, ["Mega"] = 1257.33, ["Mega|Fly|Ride"] = 1676.45}},
    ["rbxassetid://70394243440806"] = {name = "Ghostly Cat", prices = {["default"] = 12.33, ["Ride"] = 61.14, ["Fly|Ride"] = 217.93, ["Neon"] = 47.25, ["Neon|Ride"] = 77.44, ["Neon|Fly|Ride"] = 140.42, ["Mega"] = 226.48, ["Mega|Fly"] = 279.78, ["Mega|Ride"] = 223.79, ["Mega|Fly|Ride"] = 328.76}},
    ["rbxassetid://108186720416551"] = {name = "Storm Condor", prices = {["default"] = 2.1, ["Ride"] = 41.99, ["Fly|Ride"] = 116.3, ["Neon"] = 15.69, ["Neon|Fly"] = 15.73, ["Neon|Ride"] = 49.25, ["Neon|Fly|Ride"] = 208.52, ["Mega"] = 44.62, ["Mega|Fly"] = 78.75, ["Mega|Ride"] = 70.22, ["Mega|Fly|Ride"] = 137.82}},
    ["rbxassetid://11181152874"] = {name = "Mule", prices = {["default"] = 48.86, ["Ride"] = 131.24, ["Neon"] = 250.4, ["Neon|Ride"] = 235.51, ["Neon|Fly|Ride"] = 471.52, ["Mega"] = 1814.75, ["Mega|Ride"] = 1337.3, ["Mega|Fly|Ride"] = 1255.24}},
    ["rbxassetid://94781392732758"] = {name = "Onza", prices = {["default"] = 2.1, ["Fly"] = 55.13, ["Ride"] = 181.21, ["Fly|Ride"] = 56.59, ["Neon"] = 11.79, ["Neon|Fly"] = 156.96, ["Neon|Ride"] = 47.17, ["Neon|Fly|Ride"] = 112.12, ["Mega"] = 86.63, ["Mega|Ride"] = 98.44, ["Mega|Fly|Ride"] = 228.8}},
    ["rbxassetid://102763887893057"] = {name = "Cherub Chipmunk", prices = {["default"] = 2.1, ["Fly"] = 35.84, ["Ride"] = 28.3, ["Fly|Ride"] = 65.63, ["Neon"] = 6.24, ["Neon|Fly"] = 67.24, ["Neon|Ride"] = 51.19, ["Neon|Fly|Ride"] = 140.42, ["Mega"] = 51.18, ["Mega|Fly"] = 55.04, ["Mega|Ride"] = 97.89, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://104845330408668"] = {name = "Icy Porcupine", prices = {["default"] = 4.22, ["Ride"] = 167.64, ["Fly|Ride"] = 111.51, ["Neon"] = 92.92, ["Neon|Fly|Ride"] = 698.87, ["Mega"] = 377.37, ["Mega|Ride"] = 140.42, ["Mega|Fly|Ride"] = 636.57}},
    ["rbxassetid://12597275903"] = {name = "White Sand Dollar", prices = {["default"] = 60.78, ["Ride"] = 65.63, ["Fly|Ride"] = 314.84, ["Neon"] = 485.63, ["Neon|Ride"] = 509.25, ["Neon|Fly|Ride"] = 627.63, ["Mega|Fly|Ride"] = 1394.58}},
    ["rbxassetid://9901393350"] = {name = "Irish Water Spaniel", prices = {["default"] = 249.37, ["Ride"] = 290.41, ["Fly|Ride"] = 337.32, ["Neon|Ride"] = 918.75, ["Neon|Fly|Ride"] = 984.38, ["Mega"] = 5867.51, ["Mega|Fly|Ride"] = 4331.25}},
    ["rbxassetid://128640048014369"] = {name = "River Otter", prices = {["default"] = 11.82, ["Fly|Ride"] = 77.44, ["Neon"] = 25.87, ["Mega"] = 87.94, ["Mega|Fly"] = 279.78, ["Mega|Ride"] = 205.38, ["Mega|Fly|Ride"] = 540.11}},
    ["rbxassetid://138984599254588"] = {name = "Tree Sasquatch", prices = {["default"] = 3.94, ["Neon"] = 45.91, ["Neon|Ride"] = 51.09, ["Mega"] = 102.92, ["Mega|Ride"] = 112.19, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://15870220155"] = {name = "Vulture", prices = {["default"] = 3.92, ["Fly"] = 155.57, ["Ride"] = 19.69, ["Fly|Ride"] = 177.7, ["Neon"] = 36.75, ["Mega"] = 519.1, ["Mega|Ride"] = 337.84, ["Mega|Fly|Ride"] = 346.5}},
    ["rbxassetid://7734902490"] = {name = "Halloween Black Mummy Cat", prices = {["default"] = 2.1, ["Fly"] = 28.3, ["Ride"] = 28.3, ["Fly|Ride"] = 83.83, ["Neon"] = 7.69, ["Neon|Ride"] = 28.3, ["Neon|Fly|Ride"] = 137.91, ["Mega"] = 42, ["Mega|Ride"] = 65.54, ["Mega|Fly|Ride"] = 236.23}},
    ["rbxassetid://116677376014234"] = {name = "Sunflower Friend", prices = {["default"] = 2.1, ["Ride"] = 33.54, ["Fly|Ride"] = 279.74, ["Neon"] = 8.27, ["Mega"] = 52.48, ["Mega|Ride"] = 204.33, ["Mega|Fly|Ride"] = 275.58}},
    ["rbxassetid://13186022212"] = {name = "Grinmoire", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Ride"] = 17.05, ["Fly|Ride"] = 41.95, ["Neon"] = 5.2, ["Neon|Fly"] = 47.17, ["Neon|Ride"] = 32.49, ["Neon|Fly|Ride"] = 41.92, ["Mega"] = 42, ["Mega|Ride"] = 95.37, ["Mega|Fly|Ride"] = 108.91}},
    ["rbxassetid://11119263014"] = {name = "Chickatrice", prices = {["default"] = 2.1, ["Fly"] = 90.36, ["Ride"] = 14.44, ["Fly|Ride"] = 62.87, ["Neon"] = 7.61, ["Neon|Fly"] = 70.2, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 91.18, ["Mega"] = 170.63, ["Mega|Ride"] = 209.57, ["Mega|Fly|Ride"] = 279.78}},
    ["rbxassetid://13104110160"] = {name = "Blue Ringed Octopus", prices = {["default"] = 28.88, ["Ride"] = 41.28, ["Fly|Ride"] = 83.74, ["Mega"] = 420, ["Mega|Fly"] = 525, ["Mega|Ride"] = 446.25, ["Mega|Fly|Ride"] = 616.88}},
    ["rbxassetid://16088265753"] = {name = "Flaming Fox", prices = {["default"] = 85.99, ["Fly"] = 582.75, ["Ride"] = 102.67, ["Fly|Ride"] = 209.54, ["Neon"] = 329.91, ["Neon|Ride"] = 400, ["Neon|Fly|Ride"] = 703.06, ["Mega"] = 1470, ["Mega|Ride"] = 2232.81, ["Mega|Fly|Ride"] = 1957.25}},
    ["rbxassetid://84105347355723"] = {name = "Gibbon", prices = {["default"] = 2.1, ["Fly"] = 35.43, ["Ride"] = 17.7, ["Fly|Ride"] = 131.25, ["Neon"] = 3.92, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 27.57, ["Mega"] = 63.7, ["Mega|Ride"] = 91.35, ["Mega|Fly|Ride"] = 167.66}},
    ["rbxassetid://9543194411"] = {name = "Swordfish", prices = {["default"] = 2.1, ["Fly"] = 16.78, ["Ride"] = 15.73, ["Fly|Ride"] = 35.41, ["Neon"] = 3.93, ["Neon|Fly"] = 28.37, ["Neon|Ride"] = 24.11, ["Neon|Fly|Ride"] = 69.79, ["Mega"] = 45.85, ["Mega|Fly"] = 131.2, ["Mega|Ride"] = 66.03, ["Mega|Fly|Ride"] = 124.69}},
    ["rbxassetid://11706157391"] = {name = "Steppe Lion", prices = {["default"] = 2.1, ["Ride"] = 27.25, ["Fly|Ride"] = 140.39, ["Neon"] = 251.45, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 278.73, ["Mega"] = 626.82, ["Mega|Ride"] = 347.88, ["Mega|Fly|Ride"] = 472.38}},
    ["rbxassetid://18119064023"] = {name = "Bald Eagle", prices = {["default"] = 349.93, ["Fly"] = 393.74, ["Ride"] = 349.93, ["Fly|Ride"] = 497.64, ["Neon|Ride"] = 6562.5, ["Neon|Fly|Ride"] = 1570.62, ["Mega"] = 7862.14, ["Mega|Fly|Ride"] = 5588.8}},
    ["rbxassetid://6060991172"] = {name = "Lynx", prices = {["default"] = 36.02, ["Fly"] = 140.39, ["Ride"] = 59.06, ["Fly|Ride"] = 104.9, ["Neon"] = 246.88, ["Neon|Ride"] = 262.4, ["Neon|Fly|Ride"] = 303.86, ["Mega"] = 1075.03, ["Mega|Ride"] = 1183.26, ["Mega|Fly|Ride"] = 1040.53}},
    ["rbxassetid://10614198346"] = {name = "Pomeranian", prices = {["default"] = 2.1, ["Fly"] = 28.3, ["Ride"] = 36.75, ["Fly|Ride"] = 139.64, ["Neon"] = 11.42, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 98.51, ["Mega"] = 78.75, ["Mega|Ride"] = 105.15, ["Mega|Fly|Ride"] = 182.33}},
    ["rbxassetid://13663102008"] = {name = "Angler Fish", prices = {["default"] = 2.1, ["Fly"] = 209.54, ["Ride"] = 28.87, ["Fly|Ride"] = 142.7, ["Neon"] = 71.25, ["Neon|Fly"] = 419.07, ["Neon|Ride"] = 200.15, ["Neon|Fly|Ride"] = 112.12, ["Mega"] = 481.99, ["Mega|Fly|Ride"] = 559.53}},
    ["rbxassetid://5067925193"] = {name = "Toy Monkey", prices = {["default"] = 23.6, ["Fly"] = 255.63, ["Ride"] = 39.38, ["Fly|Ride"] = 65.62, ["Neon|Ride"] = 314.2, ["Neon|Fly|Ride"] = 455.79, ["Mega"] = 2514.65, ["Mega|Ride"] = 1050, ["Mega|Fly|Ride"] = 1101.44}},
    ["rbxassetid://15698960105"] = {name = "Kookaburra", prices = {["default"] = 119.44, ["Ride"] = 98.74, ["Fly|Ride"] = 140.21, ["Neon"] = 419.07, ["Neon|Ride"] = 469.35, ["Neon|Fly|Ride"] = 479.07, ["Mega"] = 3074.16, ["Mega|Fly|Ride"] = 1575}},
    ["rbxassetid://14266900917"] = {name = "Ring-tailed Lemur", prices = {["default"] = 172.94, ["Fly"] = 277.11, ["Ride"] = 249.38, ["Fly|Ride"] = 278.23, ["Neon|Ride"] = 872.82, ["Neon|Fly|Ride"] = 834.04, ["Mega|Fly|Ride"] = 3195.71}},
    ["rbxassetid://10467419131"] = {name = "Leopard Cat", prices = {["default"] = 10.49, ["Fly"] = 69.17, ["Ride"] = 32.7, ["Fly|Ride"] = 213.73, ["Neon"] = 101.04, ["Neon|Ride"] = 179.17, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 388.5, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 493.5}},
    ["rbxassetid://6498256485"] = {name = "Crab", prices = {["default"] = 2.1, ["Fly"] = 28.3, ["Ride"] = 15.75, ["Fly|Ride"] = 40.04, ["Neon"] = 8.21, ["Neon|Ride"] = 23.13, ["Neon|Fly|Ride"] = 88.03, ["Mega"] = 90.57, ["Mega|Ride"] = 104.99, ["Mega|Fly|Ride"] = 189}},
    ["rbxassetid://5721843587"] = {name = "Glyptodon", prices = {["default"] = 2.1, ["Fly"] = 30.31, ["Ride"] = 20.34, ["Fly|Ride"] = 639.68, ["Neon"] = 39.38, ["Neon|Fly"] = 146.69, ["Neon|Ride"] = 44.09, ["Neon|Fly|Ride"] = 99.56, ["Mega"] = 283, ["Mega|Ride"] = 249.38, ["Mega|Fly|Ride"] = 392.7}},
    ["rbxassetid://13979141397"] = {name = "Giant Anteater", prices = {["default"] = 288.75, ["Ride"] = 328.13, ["Fly|Ride"] = 406.88, ["Neon"] = 1376.61, ["Neon|Ride"] = 1029.11, ["Neon|Fly|Ride"] = 1779.12, ["Mega|Fly|Ride"] = 4610.2}},
    ["rbxassetid://109730629255705"] = {name = "Ruddy Duck", prices = {["default"] = 2.1, ["Ride"] = 60.74, ["Neon"] = 7.45, ["Neon|Fly|Ride"] = 118125, ["Mega"] = 54.36, ["Mega|Ride"] = 178.49, ["Mega|Fly|Ride"] = 417.03}},
    ["rbxassetid://6498259006"] = {name = "Clownfish", prices = {["default"] = 3.6, ["Ride"] = 18.38, ["Fly|Ride"] = 62.65, ["Neon"] = 41.64, ["Neon|Ride"] = 35.63, ["Neon|Fly|Ride"] = 97.13, ["Mega"] = 171.94, ["Mega|Fly"] = 204.9, ["Mega|Ride"] = 158.99, ["Mega|Fly|Ride"] = 249.36}},
    ["rbxassetid://11758569695"] = {name = "Amami Rabbit", prices = {["default"] = 21.76, ["Ride"] = 98.44, ["Neon"] = 148.79, ["Neon|Ride"] = 170.61, ["Neon|Fly|Ride"] = 279.78, ["Mega"] = 465.94, ["Mega|Ride"] = 496.55, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://11505509482"] = {name = "Ice Wolf", prices = {["default"] = 158.8, ["Fly"] = 278.69, ["Ride"] = 136.17, ["Fly|Ride"] = 188.58, ["Neon|Ride"] = 740.71, ["Neon|Fly|Ride"] = 616.88, ["Mega|Fly|Ride"] = 2010.75}},
    ["rbxassetid://9994480266"] = {name = "Royal Palace Spaniel", prices = {["default"] = 28.03, ["Fly"] = 45.93, ["Ride"] = 26.24, ["Fly|Ride"] = 54.53, ["Neon"] = 91.88, ["Neon|Ride"] = 98.51, ["Neon|Fly|Ride"] = 152.99, ["Mega"] = 418.07, ["Mega|Ride"] = 405.5, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://100897154120273"] = {name = "Clumpty", prices = {["default"] = 2.1, ["Ride"] = 41.2, ["Neon"] = 3.93, ["Neon|Ride"] = 30.19, ["Neon|Fly|Ride"] = 698.87, ["Mega"] = 20.58, ["Mega|Ride"] = 103.74, ["Mega|Fly|Ride"] = 209.99}},
    ["rbxassetid://11108831285"] = {name = "Ocelot", prices = {["default"] = 2.1, ["Ride"] = 22.32, ["Fly|Ride"] = 52.5, ["Neon"] = 2.1, ["Neon|Fly"] = 158.02, ["Neon|Ride"] = 23.59, ["Neon|Fly|Ride"] = 69.88, ["Mega"] = 27.75, ["Mega|Fly"] = 140.35, ["Mega|Ride"] = 45.94, ["Mega|Fly|Ride"] = 92.99}},
    ["rbxassetid://99323773370664"] = {name = "Dire Wolf", prices = {["default"] = 9.1, ["Fly"] = 419.07, ["Ride"] = 65.63, ["Fly|Ride"] = 124.8, ["Neon"] = 27.26, ["Neon|Ride"] = 81.37, ["Neon|Fly|Ride"] = 153.57, ["Mega"] = 149.43, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 255.94}},
    ["rbxassetid://17649307413"] = {name = "Mini Pig", prices = {["default"] = 1168.13, ["Ride"] = 1181.25, ["Fly|Ride"] = 1337.43, ["Neon|Ride"] = 6985.49, ["Neon|Fly|Ride"] = 4885.75, ["Mega|Fly|Ride"] = 12600}},
    ["rbxassetid://12720029753"] = {name = "Border Collie", prices = {["default"] = 408.19, ["Ride"] = 379.31, ["Fly|Ride"] = 485.63, ["Neon"] = 2740.2, ["Neon|Ride"] = 1575, ["Neon|Fly|Ride"] = 1697.39, ["Mega"] = 16764.28, ["Mega|Fly|Ride"] = 7084.87}},
    ["rbxassetid://4440866760"] = {name = "Pig", prices = {["default"] = 295.32, ["Fly"] = 376.69, ["Ride"] = 328.13, ["Fly|Ride"] = 406.87, ["Neon"] = 735, ["Neon|Fly"] = 1258.13, ["Neon|Ride"] = 623.44, ["Neon|Fly|Ride"] = 734.99, ["Mega|Fly|Ride"] = 3066.09}},
    ["rbxassetid://4506925854"] = {name = "Arctic Fox", prices = {["default"] = 332.69, ["Ride"] = 383.45, ["Fly|Ride"] = 446.24, ["Neon"] = 1113.66, ["Neon|Fly"] = 1117.85, ["Neon|Ride"] = 1226.3, ["Neon|Fly|Ride"] = 1177.32, ["Mega|Fly|Ride"] = 4253.94}},
    ["rbxassetid://11758575618"] = {name = "Black Moon Bear", prices = {["default"] = 2.1, ["Fly"] = 57.74, ["Ride"] = 18.11, ["Fly|Ride"] = 44.63, ["Neon"] = 5.5, ["Neon|Ride"] = 17.82, ["Neon|Fly|Ride"] = 42, ["Mega"] = 60.02, ["Mega|Ride"] = 103.69, ["Mega|Fly|Ride"] = 144.38}},
    ["rbxassetid://15547272520"] = {name = "Christmas Pudding Pup", prices = {["default"] = 392.44, ["Ride"] = 483, ["Fly|Ride"] = 813.61, ["Neon"] = 1312.5, ["Neon|Ride"] = 1312.5, ["Neon|Fly|Ride"] = 1575, ["Mega"] = 13097.1, ["Mega|Fly|Ride"] = 5538.75}},
    ["rbxassetid://78519945248690"] = {name = "Zombie Chick", prices = {["default"] = 2.1, ["Fly"] = 183.75, ["Ride"] = 36.66, ["Fly|Ride"] = 63.39, ["Neon"] = 6.57, ["Neon|Ride"] = 56.4, ["Neon|Fly|Ride"] = 209.54, ["Mega"] = 72.28, ["Mega|Ride"] = 104.99, ["Mega|Fly|Ride"] = 209.32}},
    ["rbxassetid://10357178561"] = {name = "Ibis", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 16.93, ["Fly|Ride"] = 39.38, ["Neon"] = 16.69, ["Neon|Ride"] = 49, ["Neon|Fly|Ride"] = 67.92, ["Mega"] = 91.77, ["Mega|Ride"] = 192.93, ["Mega|Fly|Ride"] = 314.88}},
    ["rbxassetid://96759122303055"] = {name = "Clubtail Dragonfly", prices = {["default"] = 2.1, ["Ride"] = 19.69, ["Neon"] = 3.94, ["Neon|Fly"] = 79.02, ["Neon|Ride"] = 39.37, ["Mega"] = 24.93, ["Mega|Fly"] = 167.66, ["Mega|Ride"] = 59.73, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://12778628897"] = {name = "Karate Gorilla", prices = {["default"] = 31.44, ["Ride"] = 65.63, ["Fly|Ride"] = 459.38, ["Neon"] = 244.13, ["Neon|Ride"] = 161.36, ["Mega"] = 2095.55, ["Mega|Fly|Ride"] = 1010.63}},
    ["rbxassetid://13104121371"] = {name = "Poison Dart Frog", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Ride"] = 17.07, ["Fly|Ride"] = 60.44, ["Neon"] = 106.14, ["Mega"] = 328.13, ["Mega|Ride"] = 233.89}},
    ["rbxassetid://71881209536633"] = {name = "Humbug", prices = {["default"] = 2.1, ["Ride"] = 55.12, ["Neon"] = 3.92, ["Neon|Fly"] = 118.02, ["Neon|Ride"] = 53.43, ["Neon|Fly|Ride"] = 95.82, ["Mega"] = 35.41, ["Mega|Fly"] = 698.87, ["Mega|Ride"] = 110.61, ["Mega|Fly|Ride"] = 314.88}},
    ["rbxassetid://11109314958"] = {name = "Ghost Wolf", prices = {["default"] = 2.1, ["Fly"] = 32.45, ["Ride"] = 23.98, ["Fly|Ride"] = 41.92, ["Neon"] = 8.4, ["Neon|Fly"] = 52.49, ["Neon|Ride"] = 35.39, ["Neon|Fly|Ride"] = 56.21, ["Mega"] = 61.67, ["Mega|Fly"] = 174.99, ["Mega|Ride"] = 94.32, ["Mega|Fly|Ride"] = 167.08}},
    ["rbxassetid://16088267136"] = {name = "Wildfire Hawk", prices = {["default"] = 6.24, ["Fly"] = 47.17, ["Ride"] = 21.24, ["Fly|Ride"] = 56.59, ["Neon"] = 155.07, ["Neon|Fly"] = 141.5, ["Neon|Ride"] = 140.39, ["Neon|Fly|Ride"] = 128.61, ["Mega"] = 237.57, ["Mega|Ride"] = 300.51, ["Mega|Fly|Ride"] = 279.78}},
    ["rbxassetid://16898328648"] = {name = "Preppy Capuchin Monkey", prices = {["default"] = 18.37, ["Ride"] = 52.5, ["Neon"] = 56.43, ["Neon|Ride"] = 279.74, ["Neon|Fly|Ride"] = 311.34, ["Mega"] = 393.88, ["Mega|Ride"] = 448.46, ["Mega|Fly|Ride"] = 349.97}},
    ["rbxassetid://15921713413"] = {name = "Thorny Devil", prices = {["default"] = 4.2, ["Ride"] = 27.2, ["Fly|Ride"] = 70.2, ["Neon"] = 47.17, ["Neon|Ride"] = 98.49, ["Neon|Fly|Ride"] = 279.78, ["Mega|Ride"] = 525}},
    ["rbxassetid://16441364976"] = {name = "Gold Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 34.78, ["Ride"] = 19.69, ["Fly|Ride"] = 55.43, ["Neon"] = 5.25, ["Neon|Fly"] = 28.3, ["Neon|Ride"] = 28.27, ["Mega"] = 43.32, ["Mega|Ride"] = 83.84, ["Mega|Fly|Ride"] = 314.34}},
    ["rbxassetid://8077189117"] = {name = "Puffin", prices = {["default"] = 230.5, ["Fly"] = 279.74, ["Ride"] = 258.57, ["Fly|Ride"] = 353.64, ["Neon"] = 698.79, ["Neon|Ride"] = 2619.43, ["Neon|Fly|Ride"] = 1101.19, ["Mega"] = 8382.14, ["Mega|Fly|Ride"] = 5188.76}},
    ["rbxassetid://8663441120"] = {name = "Lunar Tiger", prices = {["default"] = 2.1, ["Fly"] = 19.2, ["Ride"] = 15.75, ["Fly|Ride"] = 37.73, ["Neon"] = 5.22, ["Neon|Fly"] = 25.1, ["Neon|Ride"] = 17.07, ["Neon|Fly|Ride"] = 45.9, ["Mega"] = 140.42, ["Mega|Ride"] = 82.79, ["Mega|Fly|Ride"] = 118.13}},
    ["rbxassetid://17174216294"] = {name = "Skunk", prices = {["default"] = 10.27, ["Ride"] = 94.47, ["Fly|Ride"] = 182.31, ["Neon"] = 52.5, ["Neon|Ride"] = 90.78, ["Mega"] = 405.5, ["Mega|Ride"] = 457.89, ["Mega|Fly|Ride"] = 698.87}},
    ["rbxassetid://13981141292"] = {name = "Kiwi", prices = {["default"] = 29.55, ["Fly"] = 210, ["Ride"] = 124.68, ["Fly|Ride"] = 170.63, ["Neon"] = 262.5, ["Neon|Ride"] = 313.66, ["Mega"] = 838.23, ["Mega|Ride"] = 825.49, ["Mega|Fly|Ride"] = 880.91}},
    ["rbxassetid://3409443617"] = {name = "Meerkat", prices = {["default"] = 187.94, ["Ride"] = 236.23, ["Fly|Ride"] = 333.38, ["Neon"] = 732.31, ["Neon|Ride"] = 651, ["Neon|Fly|Ride"] = 581.33, ["Mega|Ride"] = 3338.94, ["Mega|Fly|Ride"] = 2625}},
    ["rbxassetid://99042906016947"] = {name = "Seafoam Butterfly", prices = {["default"] = 23.06, ["Fly|Ride"] = 140.34, ["Neon"] = 82.69, ["Neon|Ride"] = 279.74, ["Mega"] = 285.48, ["Mega|Ride"] = 224.24, ["Mega|Fly|Ride"] = 698.87}},
    ["rbxassetid://15504847683"] = {name = "Gingerbread Hare", prices = {["default"] = 40.62, ["Ride"] = 112.11, ["Fly|Ride"] = 626.68, ["Neon"] = 628.6, ["Neon|Fly|Ride"] = 838.23, ["Mega"] = 787.5, ["Mega|Fly|Ride"] = 943.01}},
    ["rbxassetid://15302316802"] = {name = "Peppermint Penguin", prices = {["default"] = 1097.25, ["Ride"] = 1115.62, ["Fly|Ride"] = 1207.5, ["Neon|Ride"] = 5906.25, ["Neon|Fly|Ride"] = 4798.79, ["Mega|Fly|Ride"] = 17031.47}},
    ["rbxassetid://10318106124"] = {name = "Scarlet Butterfly", prices = {["default"] = 6.41, ["Fly"] = 27.25, ["Ride"] = 22.32, ["Fly|Ride"] = 53.44, ["Neon"] = 174.11, ["Neon|Fly"] = 75.06, ["Neon|Ride"] = 58.98, ["Neon|Fly|Ride"] = 200.82, ["Mega"] = 222.14, ["Mega|Ride"] = 237.86, ["Mega|Fly|Ride"] = 316.32}},
    ["rbxassetid://14145989411"] = {name = "Toy Poodle", prices = {["default"] = 3.86, ["Fly"] = 65.63, ["Ride"] = 33, ["Neon"] = 37.73, ["Neon|Ride"] = 48.21, ["Mega"] = 346.5, ["Mega|Ride"] = 183.8, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://82833859118891"] = {name = "Snowy Mammoth", prices = {["default"] = 7.35, ["Fly"] = 131.25, ["Ride"] = 70.2, ["Fly|Ride"] = 942.36, ["Neon"] = 91.1, ["Neon|Ride"] = 140.42, ["Mega"] = 542.07, ["Mega|Ride"] = 1050, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://12917346501"] = {name = "Happy Duckling", prices = {["default"] = 17.05, ["Fly"] = 698.79, ["Ride"] = 35.7, ["Fly|Ride"] = 73.5, ["Neon"] = 82.22, ["Neon|Ride"] = 89.25, ["Neon|Fly|Ride"] = 166.95, ["Mega"] = 367.45, ["Mega|Ride"] = 431.82, ["Mega|Fly|Ride"] = 691.55}},
    ["rbxassetid://7064993901"] = {name = "2021 Uplift Butterfly", prices = {["default"] = 2.1, ["Fly"] = 19.08, ["Ride"] = 17.1, ["Fly|Ride"] = 48.21, ["Neon"] = 22.26, ["Neon|Fly"] = 34.06, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 131.25, ["Mega|Ride"] = 362.25, ["Mega|Fly|Ride"] = 419.12}},
    ["rbxassetid://10926054144"] = {name = "Slug", prices = {["default"] = 2.1, ["Fly"] = 413.83, ["Ride"] = 12.59, ["Neon"] = 16.83, ["Neon|Fly"] = 13125, ["Neon|Ride"] = 59.26, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 85.31, ["Mega|Ride"] = 136.31, ["Mega|Fly|Ride"] = 355.21}},
    ["rbxassetid://11571113906"] = {name = "Glacier Moth", prices = {["default"] = 300.57, ["Ride"] = 348.91, ["Fly|Ride"] = 391.83, ["Neon"] = 1256.14, ["Neon|Ride"] = 1521.18, ["Neon|Fly|Ride"] = 1465.85, ["Mega|Ride"] = 5250, ["Mega|Fly|Ride"] = 4888.9}},
    ["rbxassetid://73641371341710"] = {name = "Ice Cube", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 28.01, ["Fly|Ride"] = 60.38, ["Neon"] = 13.12, ["Neon|Fly"] = 32.82, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 99.74, ["Mega|Ride"] = 111.48, ["Mega|Fly|Ride"] = 419.12}},
    ["rbxassetid://13077767764"] = {name = "Eel", prices = {["default"] = 11.8, ["Ride"] = 21.83, ["Neon"] = 131.24, ["Neon|Ride"] = 188.27, ["Mega"] = 276.63, ["Mega|Ride"] = 283.03}},
    ["rbxassetid://134995672989153"] = {name = "Hammerhead Shark", prices = {["default"] = 2.1, ["Fly"] = 64.03, ["Ride"] = 28.8, ["Neon"] = 15.75, ["Neon|Fly"] = 70.2, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 279.78, ["Mega"] = 98.56, ["Mega|Ride"] = 199.5, ["Mega|Fly|Ride"] = 352.42}},
    ["rbxassetid://15555939727"] = {name = "Snow Monkey", prices = {["default"] = 237.83, ["Fly"] = 354.9, ["Ride"] = 307.13, ["Fly|Ride"] = 544.79, ["Neon"] = 829.5, ["Neon|Ride"] = 853.12, ["Neon|Fly|Ride"] = 1047.78, ["Mega"] = 3032.26, ["Mega|Ride"] = 3143.32, ["Mega|Fly|Ride"] = 2362.5}},
    ["rbxassetid://11758575992"] = {name = "Water Rabbit", prices = {["default"] = 25.65, ["Fly"] = 55.48, ["Ride"] = 45.94, ["Fly|Ride"] = 63, ["Neon"] = 181.33, ["Neon|Ride"] = 167.64, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 559.53, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://90987982535884"] = {name = "Great Pyrenees", prices = {["default"] = 23.65, ["Ride"] = 36.58, ["Fly|Ride"] = 78.75, ["Neon"] = 97.94, ["Neon|Ride"] = 134.11, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 480.31, ["Mega|Ride"] = 427.88, ["Mega|Fly|Ride"] = 446.25}},
    ["rbxassetid://84560154336174"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Neon"] = 3.94, ["Neon|Ride"] = 36.28, ["Mega"] = 22.32, ["Mega|Ride"] = 140.4, ["Mega|Fly|Ride"] = 261.19}},
    ["rbxassetid://4506847061"] = {name = "Reindeer", prices = {["default"] = 73.47, ["Fly"] = 108.94, ["Ride"] = 102.38, ["Fly|Ride"] = 195.56, ["Neon"] = 347.82, ["Neon|Fly"] = 471.65, ["Neon|Ride"] = 380.63, ["Neon|Fly|Ride"] = 393.74, ["Mega|Fly|Ride"] = 1226.95}},
    ["rbxassetid://98687388677942"] = {name = "Moonpine", prices = {["default"] = 2.1, ["Ride"] = 18.06, ["Neon"] = 6.56, ["Neon|Ride"] = 56.59, ["Neon|Fly|Ride"] = 588, ["Mega"] = 39.6, ["Mega|Ride"] = 209.57, ["Mega|Fly|Ride"] = 393.99}},
    ["rbxassetid://11109032702"] = {name = "Green Amazon", prices = {["default"] = 19.46, ["Fly"] = 126.18, ["Ride"] = 25.16, ["Fly|Ride"] = 75.78, ["Neon"] = 63.74, ["Neon|Ride"] = 94.5, ["Neon|Fly|Ride"] = 140.42, ["Mega"] = 389.82, ["Mega|Ride"] = 301.88, ["Mega|Fly|Ride"] = 334.69}},
    ["rbxassetid://3743730108"] = {name = "Black Panther", prices = {["default"] = 44.18, ["Fly"] = 110.06, ["Ride"] = 106.32, ["Fly|Ride"] = 175.88, ["Neon"] = 229.76, ["Neon|Ride"] = 292.69, ["Neon|Fly|Ride"] = 346.99, ["Mega|Ride"] = 1258.28, ["Mega|Fly|Ride"] = 1134}},
    ["rbxassetid://3181727398"] = {name = "Chocolate Labrador", prices = {["default"] = 2.1, ["Fly"] = 20.95, ["Ride"] = 14.34, ["Fly|Ride"] = 32.82, ["Neon"] = 2.63, ["Neon|Fly"] = 27.74, ["Neon|Ride"] = 17.07, ["Neon|Fly|Ride"] = 45.07, ["Mega"] = 20.97, ["Mega|Fly"] = 55.13, ["Mega|Ride"] = 40.69, ["Mega|Fly|Ride"] = 82.03}},
    ["rbxassetid://134636987874448"] = {name = "Nebula Snake", prices = {["default"] = 3.7, ["Ride"] = 33.48, ["Fly|Ride"] = 1346.59, ["Neon"] = 14.44, ["Neon|Ride"] = 78.6, ["Neon|Fly|Ride"] = 112.88, ["Mega"] = 220.53, ["Mega|Ride"] = 270.8, ["Mega|Fly|Ride"] = 418.04}},
    ["rbxassetid://13104122150"] = {name = "Hippo", prices = {["default"] = 17.07, ["Fly"] = 42.47, ["Ride"] = 54.2, ["Neon"] = 125.73, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 629.74, ["Mega"] = 586.69, ["Mega|Ride"] = 448.27, ["Mega|Fly|Ride"] = 651}},
    ["rbxassetid://103821295208934"] = {name = "Black Rhino", prices = {["default"] = 2.1, ["Ride"] = 26.78, ["Neon"] = 2.1, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 136.23, ["Mega"] = 20.9, ["Mega|Ride"] = 136.4, ["Mega|Fly|Ride"] = 209.57}},
    ["rbxassetid://14782580070"] = {name = "Undead Elk", prices = {["default"] = 9.19, ["Ride"] = 55.5, ["Fly|Ride"] = 111.57, ["Neon"] = 80.85, ["Neon|Ride"] = 89.94, ["Neon|Fly|Ride"] = 313.29, ["Mega"] = 301.88, ["Mega|Fly"] = 787.5, ["Mega|Ride"] = 287.39, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://8566683782"] = {name = "Giant Blue Scarab", prices = {["default"] = 14.54, ["Fly"] = 28.22, ["Ride"] = 20.85, ["Fly|Ride"] = 82.79, ["Neon"] = 216.68, ["Neon|Ride"] = 67.24, ["Neon|Fly|Ride"] = 328.13, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://14850232913"] = {name = "Cute-A-Cabra", prices = {["default"] = 2.1, ["Ride"] = 41.92, ["Fly|Ride"] = 76.01, ["Neon"] = 25.71, ["Neon|Fly"] = 699.57, ["Neon|Ride"] = 77.44, ["Neon|Fly|Ride"] = 162.3, ["Mega"] = 124.69, ["Mega|Ride"] = 199.15, ["Mega|Fly|Ride"] = 272.44}},
    ["rbxassetid://15508248825"] = {name = "Eggnog Dog", prices = {["default"] = 24.28, ["Fly"] = 2095.29, ["Ride"] = 96.71, ["Neon"] = 105, ["Neon|Ride"] = 367.5, ["Neon|Fly|Ride"] = 6289.01, ["Mega|Ride"] = 502.04, ["Mega|Fly|Ride"] = 761.25}},
    ["rbxassetid://17822797244"] = {name = "Orange Betta Fish", prices = {["default"] = 3.73, ["Fly"] = 31.5, ["Ride"] = 128.16, ["Fly|Ride"] = 196.88, ["Neon"] = 5.91, ["Neon|Fly"] = 56.59, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 99.08, ["Mega"] = 65.35, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 125.74, ["Mega|Fly|Ride"] = 519.7}},
    ["rbxassetid://9922274393"] = {name = "Retired Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://103431939950304"] = {name = "Pink Dog", prices = {["default"] = 2.1, ["Ride"] = 77.83, ["Fly|Ride"] = 47.17, ["Neon"] = 5.06, ["Mega"] = 28.88, ["Mega|Fly|Ride"] = 237.57}},
    ["rbxassetid://15227882502"] = {name = "Christmas Future Egg", prices = {["default"] = 37.67}},
    ["rbxassetid://12597276740"] = {name = "Red Sand Dollar", prices = {["default"] = 40.68, ["Fly"] = 102.38, ["Ride"] = 79.02, ["Fly|Ride"] = 90.04, ["Neon"] = 1050, ["Neon|Ride"] = 202.49, ["Neon|Fly|Ride"] = 559.53, ["Mega"] = 1243.71, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 780.93}},
    ["rbxassetid://136447612467002"] = {name = "Glyptodon Ducky", prices = {["default"] = 2.1, ["Ride"] = 84, ["Neon"] = 3.91, ["Mega"] = 22.08, ["Mega|Fly"] = 137.82, ["Mega|Ride"] = 140.42, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://101033810950061"] = {name = "Sea Slug", prices = {["default"] = 507.65, ["Fly"] = 796.22, ["Ride"] = 577.5, ["Fly|Ride"] = 544.79, ["Neon"] = 2035.58, ["Neon|Fly|Ride"] = 2044.92, ["Mega"] = 16764.28, ["Mega|Ride"] = 15702.89, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://14353536658"] = {name = "Birthday Butterfly 2023", prices = {["default"] = 6.3, ["Fly"] = 26.17, ["Ride"] = 22.74, ["Fly|Ride"] = 88.02, ["Neon"] = 12.99, ["Neon|Fly"] = 698.79, ["Neon|Ride"] = 278.69, ["Neon|Fly|Ride"] = 129.94, ["Mega"] = 111.07, ["Mega|Ride"] = 112.12, ["Mega|Fly|Ride"] = 559.53}},
    ["rbxassetid://9938967851"] = {name = "Tan Chow-Chow", prices = {["default"] = 2.69, ["Fly"] = 158.02, ["Ride"] = 17.82, ["Fly|Ride"] = 59.05, ["Neon"] = 19.69, ["Neon|Ride"] = 38.07, ["Neon|Fly|Ride"] = 76.51, ["Mega"] = 393.75, ["Mega|Ride"] = 283.03, ["Mega|Fly|Ride"] = 278.25}},
    ["rbxassetid://14448124117"] = {name = "Chipmunk", prices = {["default"] = 11.46, ["Ride"] = 76.13, ["Fly|Ride"] = 523.63, ["Neon"] = 78.74, ["Neon|Ride"] = 181.6, ["Mega"] = 514.46, ["Mega|Ride"] = 510.27, ["Mega|Fly|Ride"] = 629.74}},
    ["rbxassetid://13104108894"] = {name = "Lammergeier", prices = {["default"] = 2.38, ["Fly"] = 131.25, ["Ride"] = 31.83, ["Fly|Ride"] = 140.39, ["Neon"] = 36.68, ["Mega"] = 223.13}},
    ["rbxassetid://14446659851"] = {name = "Raccoon", prices = {["default"] = 19.92, ["Fly"] = 43.14, ["Ride"] = 65.62, ["Fly|Ride"] = 145.29, ["Neon"] = 94.49, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 358.32, ["Mega|Ride"] = 523.04, ["Mega|Fly|Ride"] = 893.17}},
    ["rbxassetid://84477079324217"] = {name = "Peachick", prices = {["default"] = 7.33, ["Fly"] = 104.99, ["Ride"] = 56.59, ["Neon"] = 75.48, ["Neon|Ride"] = 97.99, ["Neon|Fly|Ride"] = 140.42, ["Mega"] = 189, ["Mega|Fly"] = 484.09, ["Mega|Ride"] = 208.69, ["Mega|Fly|Ride"] = 377.37}},
    ["rbxassetid://9718162456"] = {name = "Donkey", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 15.65, ["Fly|Ride"] = 56.57, ["Neon"] = 2.1, ["Neon|Ride"] = 20.9, ["Neon|Fly|Ride"] = 75.34, ["Mega"] = 18.87, ["Mega|Fly"] = 62.43, ["Mega|Ride"] = 31.49, ["Mega|Fly|Ride"] = 137.82}},
    ["rbxassetid://93800993117604"] = {name = "Love Bird", prices = {["default"] = 6.19, ["Ride"] = 27.56, ["Fly|Ride"] = 158.02, ["Neon"] = 28.13, ["Neon|Fly"] = 117.92, ["Neon|Ride"] = 70.21, ["Neon|Fly|Ride"] = 622.13, ["Mega"] = 194.25, ["Mega|Ride"] = 167.99, ["Mega|Fly|Ride"] = 418.69}},
    ["rbxassetid://13665143675"] = {name = "Lion Cub", prices = {["default"] = 246.86, ["Ride"] = 288.54, ["Fly|Ride"] = 343.64, ["Neon"] = 1480.5, ["Neon|Ride"] = 1148.47, ["Neon|Fly|Ride"] = 1313.71, ["Mega|Fly|Ride"] = 3912.21}},
    ["rbxassetid://13883284001"] = {name = "Ice Cream Hermit Crab", prices = {["default"] = 84, ["Ride"] = 140.39, ["Fly|Ride"] = 7682.35, ["Neon|Ride"] = 559.53, ["Neon|Fly|Ride"] = 623.44, ["Mega"] = 4191.09, ["Mega|Ride"] = 2095.55, ["Mega|Fly|Ride"] = 1603.88}},
    ["rbxassetid://8938701212"] = {name = "Woodpecker", prices = {["default"] = 2.1, ["Fly"] = 23.06, ["Ride"] = 17.7, ["Fly|Ride"] = 39.37, ["Neon"] = 23.06, ["Neon|Fly"] = 48.21, ["Neon|Ride"] = 24.11, ["Neon|Fly|Ride"] = 63, ["Mega|Fly"] = 208.52, ["Mega|Ride"] = 98.51, ["Mega|Fly|Ride"] = 153.08}},
    ["rbxassetid://4800190034"] = {name = "Toucan", prices = {["default"] = 2.1, ["Fly"] = 17.99, ["Ride"] = 17.07, ["Fly|Ride"] = 32.49, ["Neon"] = 7.59, ["Neon|Fly"] = 39.37, ["Neon|Ride"] = 23.52, ["Neon|Fly|Ride"] = 51.09, ["Mega"] = 70.3, ["Mega|Fly"] = 349.97, ["Mega|Ride"] = 120.5, ["Mega|Fly|Ride"] = 182.44}},
    ["rbxassetid://15886122789"] = {name = "Deathstalker Scorpion", prices = {["default"] = 2.1, ["Ride"] = 22.31, ["Fly|Ride"] = 98.44, ["Neon"] = 38.07, ["Neon|Fly|Ride"] = 419.12, ["Mega"] = 140.42, ["Mega|Fly|Ride"] = 140.42}},
    ["rbxassetid://12139402705"] = {name = "Sheeeeep", prices = {["default"] = 223.13, ["Ride"] = 237.57, ["Fly|Ride"] = 328.13, ["Neon|Ride"] = 944.99, ["Neon|Fly|Ride"] = 1230.09, ["Mega|Ride"] = 8382.14, ["Mega|Fly|Ride"] = 3675}},
    ["rbxassetid://7126720389"] = {name = "Hydra", prices = {["default"] = 2.1, ["Fly"] = 38.58, ["Ride"] = 15.73, ["Fly|Ride"] = 45.84, ["Neon"] = 33.54, ["Neon|Fly"] = 158.02, ["Neon|Ride"] = 40.22, ["Neon|Fly|Ride"] = 77.84, ["Mega"] = 300.72, ["Mega|Ride"] = 267.71, ["Mega|Fly|Ride"] = 302.35}},
    ["rbxassetid://17662289865"] = {name = "Punk Pony", prices = {["default"] = 6.57, ["Fly"] = 158.02, ["Ride"] = 96.48, ["Fly|Ride"] = 209.54, ["Neon"] = 22.32, ["Neon|Ride"] = 136.34, ["Mega"] = 208.85, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 301.88}},
    ["rbxassetid://84009422958505"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 2.1, ["Neon|Ride"] = 30.8, ["Mega"] = 47.16, ["Mega|Ride"] = 96.48, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://9473352533"] = {name = "Space Whale", prices = {["default"] = 13.82, ["Ride"] = 20.97, ["Fly|Ride"] = 67.06, ["Neon"] = 78.21, ["Neon|Ride"] = 106.14, ["Neon|Fly|Ride"] = 140.42, ["Mega"] = 728.34, ["Mega|Ride"] = 418.07, ["Mega|Fly|Ride"] = 417.03}},
    ["rbxassetid://71528203783155"] = {name = "Pupcake", prices = {["default"] = 49.88, ["Ride"] = 74.93, ["Fly|Ride"] = 209.9, ["Neon"] = 157.27, ["Neon|Fly"] = 393.75, ["Neon|Ride"] = 196.77, ["Neon|Fly|Ride"] = 316.44, ["Mega"] = 479.07, ["Mega|Fly"] = 2200.33, ["Mega|Ride"] = 579.03, ["Mega|Fly|Ride"] = 628.78}},
    ["rbxassetid://4440867010"] = {name = "Drake", prices = {["default"] = 24.94, ["Fly"] = 158.02, ["Ride"] = 44.62, ["Fly|Ride"] = 81.37, ["Neon"] = 127.82, ["Neon|Fly"] = 290.07, ["Neon|Ride"] = 127.35, ["Neon|Fly|Ride"] = 235.87, ["Mega"] = 796.32, ["Mega|Ride"] = 624.48, ["Mega|Fly|Ride"] = 698.87}},
    ["rbxassetid://9708962205"] = {name = "Parakeet", prices = {["default"] = 2.1, ["Fly"] = 17.7, ["Ride"] = 13.11, ["Fly|Ride"] = 41.92, ["Neon"] = 2.1, ["Neon|Fly"] = 27.62, ["Neon|Ride"] = 18.11, ["Neon|Fly|Ride"] = 61.83, ["Mega"] = 25.16, ["Mega|Fly"] = 412.51, ["Mega|Ride"] = 28.74, ["Mega|Fly|Ride"] = 114.35}},
    ["rbxassetid://4883302468"] = {name = "Shrew", prices = {["default"] = 227.07, ["Ride"] = 262.5, ["Fly|Ride"] = 349.13, ["Neon"] = 3110.85, ["Neon|Ride"] = 958.13, ["Neon|Fly|Ride"] = 1050, ["Mega|Fly|Ride"] = 4327.3}},
    ["rbxassetid://11507151679"] = {name = "Irish Elk", prices = {["default"] = 15.75, ["Fly"] = 61.61, ["Ride"] = 45.94, ["Fly|Ride"] = 133.06, ["Neon"] = 103.84, ["Neon|Ride"] = 92.25, ["Neon|Fly|Ride"] = 321.56, ["Mega|Fly|Ride"] = 589.32}},
    ["rbxassetid://17163957321"] = {name = "Blue Jay", prices = {["default"] = 2.1, ["Fly"] = 26.32, ["Ride"] = 18.37, ["Fly|Ride"] = 39.38, ["Neon"] = 5.25, ["Neon|Fly"] = 26.88, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 111.07, ["Mega"] = 59.15, ["Mega|Ride"] = 140.42, ["Mega|Fly|Ride"] = 299.54}},
    ["rbxassetid://8705079225"] = {name = "Abyssinian Cat", prices = {["default"] = 2.1, ["Fly"] = 28.3, ["Ride"] = 17.07, ["Fly|Ride"] = 55.47, ["Neon"] = 2.1, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 20.83, ["Neon|Fly|Ride"] = 101.2, ["Mega"] = 30.07, ["Mega|Fly"] = 141.52, ["Mega|Ride"] = 48.69, ["Mega|Fly|Ride"] = 139.13}},
    ["rbxassetid://17059483392"] = {name = "Velociraptor", prices = {["default"] = 2.1, ["Ride"] = 24.04, ["Fly|Ride"] = 69.27, ["Neon"] = 11.46, ["Neon|Ride"] = 60.16, ["Neon|Fly|Ride"] = 79.03, ["Mega"] = 94.12, ["Mega|Ride"] = 128.63, ["Mega|Fly|Ride"] = 385.64}},
    ["rbxassetid://16548686870"] = {name = "Hamster", prices = {["default"] = 12.74, ["Fly"] = 38.68, ["Ride"] = 24.94, ["Fly|Ride"] = 64.32, ["Neon"] = 58.25, ["Neon|Ride"] = 64.22, ["Neon|Fly|Ride"] = 123.38, ["Mega"] = 317.89, ["Mega|Fly"] = 786.59, ["Mega|Ride"] = 285.85, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://13883285383"] = {name = "Castle Hermit Crab", prices = {["default"] = 6.56, ["Ride"] = 26.22, ["Fly|Ride"] = 72.19, ["Neon"] = 55.01, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 275.63, ["Mega|Ride"] = 312.24, ["Mega|Fly|Ride"] = 389.79}},
    ["rbxassetid://82240382561696"] = {name = "Cocoadile", prices = {["default"] = 2.1, ["Neon"] = 7.08, ["Neon|Ride"] = 46.01, ["Mega"] = 31.86, ["Mega|Ride"] = 61.07}},
    ["rbxassetid://74702714943302"] = {name = "Grave Owl", prices = {["default"] = 10.34, ["Ride"] = 24.92, ["Fly|Ride"] = 83.83, ["Neon"] = 18.43, ["Neon|Fly"] = 47.17, ["Neon|Ride"] = 67.08, ["Neon|Fly|Ride"] = 87.54, ["Mega"] = 157.5, ["Mega|Ride"] = 259.86, ["Mega|Fly|Ride"] = 292.48}},
    ["rbxassetid://97556530589327"] = {name = "Bison", prices = {["default"] = 2.1, ["Ride"] = 125.73, ["Neon"] = 8.4, ["Neon|Fly"] = 98.49, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 158.04, ["Mega"] = 33.54, ["Mega|Ride"] = 91.34, ["Mega|Fly|Ride"] = 314.88}},
    ["rbxassetid://11694855214"] = {name = "Shetland Pony Dark Brown", prices = {["default"] = 2.1, ["Fly"] = 27.65, ["Ride"] = 12.59, ["Fly|Ride"] = 83.93, ["Neon"] = 7.07, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 60.46, ["Mega"] = 66.03, ["Mega|Ride"] = 78.66, ["Mega|Fly|Ride"] = 179.41}},
    ["rbxassetid://14398823196"] = {name = "Alpaca", prices = {["default"] = 629.98, ["Ride"] = 727.13, ["Fly|Ride"] = 721.88, ["Neon"] = 4172.77, ["Neon|Ride"] = 2625, ["Neon|Fly|Ride"] = 3150, ["Mega|Fly|Ride"] = 12462.16}},
    ["rbxassetid://5721843716"] = {name = "Pterodactyl", prices = {["default"] = 2.1, ["Fly"] = 19.59, ["Ride"] = 16.96, ["Fly|Ride"] = 31.49, ["Neon"] = 28.77, ["Neon|Fly"] = 50.3, ["Neon|Ride"] = 36.58, ["Neon|Fly|Ride"] = 104.79, ["Mega"] = 187.57, ["Mega|Fly|Ride"] = 209.57}},
    ["rbxassetid://82057257613990"] = {name = "Unicorn Ducky", prices = {["default"] = 3.94, ["Ride"] = 30.66, ["Fly|Ride"] = 164.72, ["Neon"] = 10.27, ["Neon|Fly"] = 838.13, ["Neon|Ride"] = 52.4, ["Neon|Fly|Ride"] = 341.25, ["Mega"] = 59.07, ["Mega|Fly"] = 158.04, ["Mega|Ride"] = 107.63, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://4708551366"] = {name = "Frog", prices = {["default"] = 7.69, ["Fly"] = 31.4, ["Ride"] = 21.02, ["Fly|Ride"] = 47.23, ["Neon"] = 37.58, ["Neon|Fly"] = 40.11, ["Neon|Ride"] = 53.42, ["Neon|Fly|Ride"] = 104.85, ["Mega"] = 309.1, ["Mega|Ride"] = 307.13, ["Mega|Fly|Ride"] = 336}},
    ["rbxassetid://4800189682"] = {name = "Starfish", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 15.73, ["Fly|Ride"] = 33.08, ["Neon"] = 4.86, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 23.52, ["Neon|Fly|Ride"] = 58.95, ["Mega"] = 103.69, ["Mega|Fly"] = 349.97, ["Mega|Ride"] = 99.75, ["Mega|Fly|Ride"] = 118.13}},
    ["rbxassetid://16736753854"] = {name = "Candy Cane Snail", prices = {["default"] = 61.82, ["Ride"] = 78.75, ["Fly|Ride"] = 208.49, ["Neon"] = 222.29, ["Neon|Ride"] = 341.25, ["Neon|Fly|Ride"] = 367.5, ["Mega"] = 887.48, ["Mega|Ride"] = 664.31, ["Mega|Fly|Ride"] = 743.93}},
    ["rbxassetid://10393730410"] = {name = "Orca", prices = {["default"] = 2.1, ["Ride"] = 19.69, ["Neon"] = 7.88, ["Neon|Fly"] = 134.44, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 157.49, ["Mega"] = 49.26, ["Mega|Ride"] = 158.04, ["Mega|Fly|Ride"] = 278.73}},
    ["rbxassetid://111642509798043"] = {name = "Toxic Kaijunior", prices = {["default"] = 2.1, ["Fly"] = 73.49, ["Ride"] = 23.59, ["Fly|Ride"] = 65.63, ["Neon"] = 11.55, ["Neon|Fly"] = 140.39, ["Neon|Ride"] = 46.28, ["Neon|Fly|Ride"] = 448.23, ["Mega"] = 98.44, ["Mega|Ride"] = 182.17, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://14146181621"] = {name = "Tawny Frogmouth", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Fly|Ride"] = 65.76, ["Neon"] = 15.73, ["Neon|Fly"] = 31.85, ["Neon|Ride"] = 110.85, ["Mega"] = 116.31, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://9474010501"] = {name = "Ribbon Seal", prices = {["default"] = 2.1, ["Ride"] = 20.74, ["Fly|Ride"] = 35.63, ["Neon"] = 3.94, ["Neon|Fly"] = 28.88, ["Neon|Ride"] = 25.92, ["Neon|Fly|Ride"] = 65.02, ["Mega"] = 44.29, ["Mega|Fly"] = 181.92, ["Mega|Ride"] = 59.06, ["Mega|Fly|Ride"] = 137.28}},
    ["rbxassetid://6776872152"] = {name = "Red Squirrel", prices = {["default"] = 22.42, ["Fly"] = 19.69, ["Ride"] = 18.38, ["Fly|Ride"] = 45.39, ["Neon"] = 103.69, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 116.82, ["Mega"] = 838.23, ["Mega|Ride"] = 401.31, ["Mega|Fly|Ride"] = 414.08}},
    ["rbxassetid://84140820920420"] = {name = "Siamese Cat", prices = {["default"] = 779.63, ["Ride"] = 780.65, ["Fly|Ride"] = 813.75, ["Neon"] = 1748.25, ["Neon|Fly"] = 2417.21, ["Neon|Ride"] = 1928.28, ["Neon|Fly|Ride"] = 1929.38, ["Mega|Ride"] = 6007.92, ["Mega|Fly|Ride"] = 4515}},
    ["rbxassetid://3181727773"] = {name = "Bunny", prices = {["default"] = 2.1, ["Fly"] = 18.9, ["Ride"] = 18.88, ["Fly|Ride"] = 56.59, ["Neon"] = 3.82, ["Neon|Fly"] = 139.19, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 60.32, ["Mega"] = 52.75, ["Mega|Fly"] = 65.63, ["Mega|Ride"] = 98.51}},
    ["rbxassetid://17120012859"] = {name = "Praying Mantis", prices = {["default"] = 6.56, ["Ride"] = 32.82, ["Fly|Ride"] = 92.21, ["Neon"] = 28.12, ["Neon|Fly"] = 140.39, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 258.36, ["Mega"] = 328.13, ["Mega|Ride"] = 351.75, ["Mega|Fly|Ride"] = 557.43}},
    ["rbxassetid://4440866528"] = {name = "Turkey", prices = {["default"] = 55.88, ["Fly"] = 126.18, ["Ride"] = 85.32, ["Fly|Ride"] = 144.38, ["Neon|Ride"] = 419.12, ["Neon|Fly|Ride"] = 448.88, ["Mega"] = 3150.32, ["Mega|Fly|Ride"] = 2332.32}},
    ["rbxassetid://9287841987"] = {name = "Black Springer Spaniel", prices = {["default"] = 27.28, ["Fly"] = 131.25, ["Ride"] = 48.88, ["Fly|Ride"] = 77.55, ["Neon"] = 39.38, ["Neon|Ride"] = 117.92, ["Neon|Fly|Ride"] = 347.88, ["Mega"] = 1957.25, ["Mega|Ride"] = 564.38, ["Mega|Fly|Ride"] = 943.01}},
    ["rbxassetid://87613898139280"] = {name = "Ranger Beaver", prices = {["default"] = 19.08, ["Ride"] = 43.31, ["Neon"] = 112.21, ["Neon|Ride"] = 122.03, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 305.12, ["Mega|Ride"] = 366.74, ["Mega|Fly|Ride"] = 456.75}},
    ["rbxassetid://88389663444803"] = {name = "Mirai Moth", prices = {["default"] = 140.39, ["Ride"] = 94.34, ["Neon"] = 72.19, ["Neon|Ride"] = 362, ["Mega"] = 274.54, ["Mega|Fly"] = 511.82, ["Mega|Ride"] = 360.87, ["Mega|Fly|Ride"] = 419.12}},
    ["rbxassetid://128469688002747"] = {name = "Moonlight Moth", prices = {["default"] = 19.69, ["Ride"] = 59.07, ["Fly|Ride"] = 83.83, ["Neon"] = 177.19, ["Neon|Ride"] = 304.77, ["Neon|Fly|Ride"] = 377.14, ["Mega"] = 924, ["Mega|Ride"] = 728.44}},
    ["rbxassetid://13936753561"] = {name = "Dylan", prices = {["default"] = 22.35}},
    ["rbxassetid://10606175827"] = {name = "Koi Carp", prices = {["default"] = 5.38, ["Ride"] = 32.49, ["Fly|Ride"] = 65.1, ["Neon"] = 25.73, ["Neon|Ride"] = 125.68, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 174.55, ["Mega|Fly"] = 519.75, ["Mega|Ride"] = 216.57, ["Mega|Fly|Ride"] = 303.86}},
    ["rbxassetid://84529929751558"] = {name = "Old King Coal", prices = {["default"] = 2.1, ["Ride"] = 36.68, ["Neon"] = 36.75, ["Neon|Ride"] = 39.82, ["Mega"] = 880.91}},
    ["rbxassetid://11706110842"] = {name = "Snowball Pet", prices = {["default"] = 71.46, ["Fly"] = 418.85, ["Ride"] = 83.83, ["Fly|Ride"] = 103.95, ["Neon"] = 331.07, ["Neon|Ride"] = 314.84, ["Neon|Fly|Ride"] = 943.43, ["Mega|Ride"] = 1151.51, ["Mega|Fly|Ride"] = 1048.69}},
    ["rbxassetid://6404812664"] = {name = "Ladybug", prices = {["default"] = 3.77, ["Fly"] = 28.3, ["Ride"] = 15.6, ["Fly|Ride"] = 39.29, ["Neon"] = 27.01, ["Neon|Fly"] = 68.67, ["Neon|Ride"] = 34.05, ["Neon|Fly|Ride"] = 81.36, ["Mega"] = 182.33, ["Mega|Fly"] = 418.07, ["Mega|Ride"] = 199.5, ["Mega|Fly|Ride"] = 418.69}},
    ["rbxassetid://95046891836017"] = {name = "Clover Cow", prices = {["default"] = 6.55, ["Fly"] = 83.83, ["Ride"] = 23.68, ["Fly|Ride"] = 77.44, ["Neon"] = 23.59, ["Neon|Ride"] = 83.69, ["Neon|Fly|Ride"] = 158.04, ["Mega"] = 145.17, ["Mega|Ride"] = 177.19, ["Mega|Fly|Ride"] = 267.75}},
    ["rbxassetid://123759251940984"] = {name = "Oakee Knight", prices = {["default"] = 2.1, ["Neon"] = 5.98, ["Neon|Ride"] = 45.94, ["Mega"] = 72.19, ["Mega|Ride"] = 96.6, ["Mega|Fly|Ride"] = 137.82}},
    ["rbxassetid://9287842106"] = {name = "Brown Springer Spaniel", prices = {["default"] = 32.44, ["Fly"] = 65.63, ["Ride"] = 48.38, ["Fly|Ride"] = 99.75, ["Neon"] = 223.13, ["Neon|Ride"] = 140.39, ["Neon|Fly|Ride"] = 250.41, ["Mega"] = 1117.98, ["Mega|Ride"] = 13970.94, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://83890934284839"] = {name = "Zeopod", prices = {["default"] = 2.1, ["Ride"] = 25.03, ["Neon"] = 12.98, ["Neon|Fly"] = 291.38, ["Neon|Ride"] = 85.93, ["Mega"] = 91.18, ["Mega|Ride"] = 114.53, ["Mega|Fly|Ride"] = 309.68}},
    ["rbxassetid://107096792267421"] = {name = "General Sheepdog", prices = {["default"] = 6.57, ["Ride"] = 73.5, ["Neon"] = 94.34, ["Neon|Ride"] = 146.76, ["Neon|Fly|Ride"] = 274.05, ["Mega"] = 349.97, ["Mega|Ride"] = 698.87, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://5721844511"] = {name = "Woolly Mammoth", prices = {["default"] = 2.1, ["Fly"] = 19.81, ["Ride"] = 14.44, ["Fly|Ride"] = 28.3, ["Neon"] = 21.24, ["Neon|Ride"] = 28.24, ["Neon|Fly|Ride"] = 123.53, ["Mega"] = 144.37, ["Mega|Ride"] = 257.92, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://8143039445"] = {name = "Summer Walrus", prices = {["default"] = 7.66, ["Fly"] = 52.49, ["Ride"] = 17.57, ["Fly|Ride"] = 47.38, ["Neon"] = 157.5, ["Neon|Ride"] = 410.78, ["Mega"] = 209.57, ["Mega|Ride"] = 279.78, ["Mega|Fly|Ride"] = 419.12}},
    ["rbxassetid://136696735147963"] = {name = "Chilling Spider", prices = {["default"] = 3.92, ["Ride"] = 37.29, ["Neon"] = 36.2, ["Neon|Ride"] = 110.85, ["Mega"] = 140.4, ["Mega|Ride"] = 836.73}},
    ["rbxassetid://133768672320906"] = {name = "Catte", prices = {["default"] = 33.1, ["Ride"] = 105, ["Neon"] = 157.5, ["Neon|Ride"] = 266.12, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 978.63, ["Mega|Ride"] = 1615.67, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://12139319231"] = {name = "Feesh", prices = {["default"] = 14.95, ["Ride"] = 78.48, ["Neon"] = 131.25, ["Mega"] = 410.17, ["Mega|Fly|Ride"] = 496.79}},
    ["rbxassetid://13685039170"] = {name = "Lobster", prices = {["default"] = 3.84, ["Ride"] = 104.9, ["Fly|Ride"] = 279.74, ["Neon"] = 140.2, ["Mega"] = 622.39, ["Mega|Ride"] = 984.92, ["Mega|Fly|Ride"] = 769.08}},
    ["rbxassetid://87668315398037"] = {name = "Mecha R4BBIT", prices = {["default"] = 20.99, ["Ride"] = 56.59, ["Fly|Ride"] = 529.44, ["Neon"] = 82.65, ["Neon|Ride"] = 111.38, ["Mega|Ride"] = 734.93, ["Mega|Fly|Ride"] = 1047.78}},
    ["rbxassetid://120262676323297"] = {name = "Kelp Hunter", prices = {["default"] = 6.4, ["Neon"] = 89.63, ["Mega"] = 111.57, ["Mega|Ride"] = 223.13, ["Mega|Fly|Ride"] = 314.88}},
    ["rbxassetid://12403864254"] = {name = "Gorilla", prices = {["default"] = 2.1, ["Fly"] = 26.24, ["Ride"] = 16.21, ["Fly|Ride"] = 41.92, ["Neon"] = 3.93, ["Neon|Fly"] = 43.02, ["Neon|Ride"] = 31.85, ["Neon|Fly|Ride"] = 73.37, ["Mega"] = 62.89, ["Mega|Ride"] = 89.24, ["Mega|Fly|Ride"] = 117.2}},
    ["rbxassetid://124908510040897"] = {name = "Mistletroll", prices = {["default"] = 8.3, ["Ride"] = 51.96, ["Fly|Ride"] = 328.13, ["Neon"] = 65.63, ["Neon|Ride"] = 115.25, ["Neon|Fly|Ride"] = 134.46, ["Mega|Fly|Ride"] = 397.69}},
    ["rbxassetid://11189235896"] = {name = "Persian Cat", prices = {["default"] = 2.1, ["Fly"] = 29.69, ["Ride"] = 28.29, ["Fly|Ride"] = 55.95, ["Neon"] = 5, ["Neon|Ride"] = 28.04, ["Neon|Fly|Ride"] = 68.04, ["Mega"] = 65.63, ["Mega|Ride"] = 81.27, ["Mega|Fly|Ride"] = 196.35}},
    ["rbxassetid://14457148635"] = {name = "Magma Snail", prices = {["default"] = 3.29, ["Fly"] = 131.25, ["Ride"] = 47.14, ["Fly|Ride"] = 110.35, ["Neon"] = 48.21, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 112.12, ["Mega"] = 249.38, ["Mega|Ride"] = 170.63, ["Mega|Fly|Ride"] = 471.72}},
    ["rbxassetid://11694853423"] = {name = "Shetland Pony White", prices = {["default"] = 3.94, ["Ride"] = 33.78, ["Fly|Ride"] = 70.2, ["Neon"] = 33.36, ["Neon|Fly"] = 471.65, ["Neon|Ride"] = 96.41, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 381.4, ["Mega|Ride"] = 419.12, ["Mega|Fly|Ride"] = 1047.78}},
    ["rbxassetid://4621220568"] = {name = "Rat", prices = {["default"] = 2.1, ["Fly"] = 131.25, ["Ride"] = 22.28, ["Fly|Ride"] = 42, ["Neon"] = 21, ["Neon|Fly"] = 104.78, ["Neon|Ride"] = 41.15, ["Neon|Fly|Ride"] = 108.94, ["Mega|Ride"] = 249.48, ["Mega|Fly|Ride"] = 357.67}},
    ["rbxassetid://8938702150"] = {name = "Pine Marten", prices = {["default"] = 2.1, ["Fly"] = 34.41, ["Ride"] = 17.06, ["Fly|Ride"] = 39.38, ["Neon"] = 21.24, ["Neon|Fly"] = 83.83, ["Neon|Ride"] = 70.2, ["Neon|Fly|Ride"] = 104.79, ["Mega"] = 164.66, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 285.41}},
    ["rbxassetid://120359009390464"] = {name = "Turtle Doves", prices = {["default"] = 6.57, ["Fly"] = 301.88, ["Ride"] = 42, ["Fly|Ride"] = 179.82, ["Neon"] = 24.97, ["Neon|Fly"] = 123.63, ["Neon|Ride"] = 81.38, ["Neon|Fly|Ride"] = 203.28, ["Mega"] = 155.09, ["Mega|Ride"] = 157.18, ["Mega|Fly|Ride"] = 419.12}},
    ["rbxassetid://71032455578324"] = {name = "Chihuahua", prices = {["default"] = 15.74, ["Fly"] = 139.55, ["Ride"] = 91.88, ["Fly|Ride"] = 261.19, ["Neon"] = 85.32, ["Neon|Ride"] = 216.77, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 385.88, ["Mega|Fly"] = 669.38, ["Mega|Ride"] = 447.23, ["Mega|Fly|Ride"] = 585.65}},
    ["rbxassetid://11505487641"] = {name = "Ram", prices = {["default"] = 77.06, ["Ride"] = 108.94, ["Fly|Ride"] = 164.07, ["Neon"] = 249.38, ["Neon|Fly"] = 333.16, ["Neon|Ride"] = 263.81, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 1536.05, ["Mega|Ride"] = 996.02, ["Mega|Fly|Ride"] = 1060.11}},
    ["rbxassetid://117821626163847"] = {name = "Chanekeh", prices = {["default"] = 2.1, ["Fly"] = 50.91, ["Ride"] = 21.83, ["Fly|Ride"] = 65.54, ["Neon"] = 2.1, ["Neon|Ride"] = 38.45, ["Neon|Fly|Ride"] = 60.78, ["Mega"] = 28.3, ["Mega|Ride"] = 60.38, ["Mega|Fly|Ride"] = 124.69}},
    ["rbxassetid://14266737982"] = {name = "Cassowary", prices = {["default"] = 18.38, ["Neon"] = 126.46, ["Neon|Ride"] = 199.31, ["Mega"] = 911.54, ["Mega|Ride"] = 589.64, ["Mega|Fly|Ride"] = 1257.33}},
    ["rbxassetid://13693650831"] = {name = "Leopard Shark", prices = {["default"] = 36.28, ["Ride"] = 94.34, ["Neon"] = 276.73, ["Neon|Ride"] = 299.5, ["Neon|Fly|Ride"] = 522.85, ["Mega"] = 1085.51, ["Mega|Ride"] = 1108.55, ["Mega|Fly|Ride"] = 983.07}},
    ["rbxassetid://100909868233186"] = {name = "Kappakid", prices = {["default"] = 9.19, ["Fly"] = 190.32, ["Ride"] = 44.63, ["Fly|Ride"] = 125.99, ["Neon"] = 52.4, ["Neon|Ride"] = 52.5, ["Mega"] = 231.57, ["Mega|Ride"] = 235.87, ["Mega|Fly|Ride"] = 449.54}},
    ["rbxassetid://127061844219486"] = {name = "Patchy Bear", prices = {["default"] = 2.1, ["Fly"] = 78.75, ["Ride"] = 78.22, ["Fly|Ride"] = 136.92, ["Neon"] = 5.98, ["Neon|Fly"] = 40.19, ["Neon|Ride"] = 35.63, ["Mega"] = 34.09, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 62.21, ["Mega|Fly|Ride"] = 118.13}},
    ["rbxassetid://6998402749"] = {name = "Merhorse", prices = {["default"] = 2.1, ["Fly"] = 18.71, ["Ride"] = 18.36, ["Fly|Ride"] = 49.25, ["Neon"] = 15.66, ["Neon|Ride"] = 27.71, ["Neon|Fly|Ride"] = 82.41, ["Mega"] = 182.33, ["Mega|Fly"] = 349.97, ["Mega|Ride"] = 313.69, ["Mega|Fly|Ride"] = 220.87}},
    ["rbxassetid://3181727196"] = {name = "Beaver", prices = {["default"] = 2.1, ["Fly"] = 15.73, ["Ride"] = 18.87, ["Fly|Ride"] = 35.44, ["Neon"] = 2.63, ["Neon|Fly"] = 21, ["Neon|Ride"] = 22.32, ["Neon|Fly|Ride"] = 49, ["Mega"] = 34.13, ["Mega|Ride"] = 82.79, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://10377935981"] = {name = "Badger", prices = {["default"] = 2.1, ["Fly"] = 41.92, ["Ride"] = 19.69, ["Fly|Ride"] = 65.72, ["Neon"] = 3.93, ["Neon|Ride"] = 36.58, ["Neon|Fly|Ride"] = 83.84, ["Mega"] = 44.6, ["Mega|Fly"] = 168, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://118143096743818"] = {name = "Granny Wolf", prices = {["default"] = 2.1, ["Ride"] = 19.69, ["Fly|Ride"] = 158.02, ["Neon"] = 2.63, ["Neon|Ride"] = 123.24, ["Mega"] = 21, ["Mega|Fly|Ride"] = 275.63}},
    ["rbxassetid://18819382634"] = {name = "Singularity Beetle", prices = {["default"] = 4.87, ["Ride"] = 31.42, ["Fly|Ride"] = 262.5, ["Neon"] = 40.69, ["Neon|Fly|Ride"] = 207.47, ["Mega"] = 188.69, ["Mega|Ride"] = 231, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://13664716167"] = {name = "Ostrich", prices = {["default"] = 7.09, ["Ride"] = 32.49, ["Fly|Ride"] = 83.83, ["Neon"] = 53.81, ["Neon|Ride"] = 98.49, ["Neon|Fly|Ride"] = 234.69, ["Mega"] = 360.94, ["Mega|Ride"] = 304.5, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://3710822879"] = {name = "Penguin", prices = {["default"] = 6.3, ["Fly"] = 32.49, ["Ride"] = 20.85, ["Fly|Ride"] = 48.21, ["Neon"] = 43.98, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 55.48, ["Neon|Fly|Ride"] = 86.61, ["Mega"] = 393.75, ["Mega|Ride"] = 335.74, ["Mega|Fly|Ride"] = 325.5}},
    ["rbxassetid://12778628745"] = {name = "Chef Gorilla", prices = {["default"] = 49.87, ["Ride"] = 78.75, ["Fly|Ride"] = 262.5, ["Neon"] = 349.93, ["Neon|Ride"] = 597.19, ["Neon|Fly|Ride"] = 414.93}},
    ["rbxassetid://138841259551372"] = {name = "Vermilion Butterfly", prices = {["default"] = 26.25, ["Fly"] = 72.44, ["Ride"] = 65.63, ["Fly|Ride"] = 79.02, ["Neon"] = 103.69, ["Mega"] = 629.74, ["Mega|Ride"] = 697.6, ["Mega|Fly|Ride"] = 1181.93}},
    ["rbxassetid://3181727125"] = {name = "Snow Puma", prices = {["default"] = 2.1, ["Fly"] = 18.87, ["Ride"] = 18.78, ["Fly|Ride"] = 40.04, ["Neon"] = 3.94, ["Neon|Fly"] = 28.3, ["Neon|Ride"] = 23.59, ["Neon|Fly|Ride"] = 47.25, ["Mega"] = 36.69, ["Mega|Ride"] = 51.91, ["Mega|Fly|Ride"] = 129.94}},
    ["rbxassetid://3181728160"] = {name = "Shiba Inu", prices = {["default"] = 2.1, ["Fly"] = 17.7, ["Ride"] = 17.69, ["Fly|Ride"] = 32.97, ["Neon"] = 3.78, ["Neon|Fly"] = 26.17, ["Neon|Ride"] = 22.89, ["Neon|Fly|Ride"] = 41.92, ["Mega"] = 69.21, ["Mega|Ride"] = 66.03, ["Mega|Fly|Ride"] = 101.06}},
    ["rbxassetid://3261465893"] = {name = "Blue Dog", prices = {["default"] = 383.28, ["Ride"] = 438.38, ["Fly|Ride"] = 446.25, ["Neon|Ride"] = 1365, ["Neon|Fly|Ride"] = 1509.37}},
    ["rbxassetid://15504846154"] = {name = "Eggnog Hare", prices = {["default"] = 19.67, ["Ride"] = 59.07, ["Fly|Ride"] = 242.26, ["Neon"] = 157.5, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 1257.33, ["Mega|Fly|Ride"] = 1676.45}},
    ["rbxassetid://4708551244"] = {name = "Dingo", prices = {["default"] = 2.1, ["Fly"] = 33.8, ["Ride"] = 13.54, ["Fly|Ride"] = 32.49, ["Neon"] = 3.89, ["Neon|Fly"] = 70.2, ["Neon|Ride"] = 20.85, ["Neon|Fly|Ride"] = 40.69, ["Mega"] = 38.97, ["Mega|Ride"] = 74.82, ["Mega|Fly|Ride"] = 95.4}},
    ["rbxassetid://140434791311540"] = {name = "French Bulldog", prices = {["default"] = 69.17, ["Fly|Ride"] = 196.88, ["Neon"] = 236.87, ["Neon|Ride"] = 295.44, ["Neon|Fly|Ride"] = 523.89, ["Mega"] = 737.62, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 1284.57}},
    ["rbxassetid://5067924710"] = {name = "Monkey", prices = {["default"] = 2.1, ["Fly"] = 16.88, ["Ride"] = 20.97, ["Fly|Ride"] = 35.63, ["Neon"] = 9.07, ["Neon|Fly"] = 36.75, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 54.6, ["Mega"] = 77.57, ["Mega|Fly"] = 112.12, ["Mega|Ride"] = 96.36, ["Mega|Fly|Ride"] = 158.81}},
    ["rbxassetid://73677246948616"] = {name = "Black Tiger", prices = {["default"] = 2.1, ["Fly"] = 70.2, ["Ride"] = 34.13, ["Fly|Ride"] = 1312.5, ["Neon"] = 2.1, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 27.55, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 19.29, ["Mega|Fly"] = 195.96, ["Mega|Ride"] = 65.23, ["Mega|Fly|Ride"] = 208.15}},
    ["rbxassetid://17662893972"] = {name = "Pretty Pony", prices = {["default"] = 140.39, ["Fly"] = 140.39, ["Ride"] = 85.71, ["Fly|Ride"] = 111.57, ["Neon"] = 245.17, ["Neon|Ride"] = 320.63, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 656.25, ["Mega|Ride"] = 629.94, ["Mega|Fly|Ride"] = 1327.53}},
    ["rbxassetid://16722908853"] = {name = "Dotted Eggy", prices = {["default"] = 2.1, ["Ride"] = 15.85, ["Fly|Ride"] = 52.5, ["Neon"] = 7.42, ["Neon|Ride"] = 41.28, ["Mega"] = 121.55, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://3409443896"] = {name = "Wild Boar", prices = {["default"] = 39.38, ["Ride"] = 73.18, ["Fly|Ride"] = 67.24, ["Neon"] = 153.56, ["Neon|Ride"] = 215.82, ["Neon|Fly|Ride"] = 448.46, ["Mega"] = 1654.44, ["Mega|Ride"] = 1676.45, ["Mega|Fly|Ride"] = 903}},
    ["rbxassetid://12432807176"] = {name = "Possum", prices = {["default"] = 3.93, ["Ride"] = 45.94, ["Neon"] = 15.2, ["Neon|Ride"] = 299.77, ["Neon|Fly|Ride"] = 419.12, ["Mega"] = 175.88, ["Mega|Ride"] = 158.82, ["Mega|Fly|Ride"] = 470.54}},
    ["rbxassetid://94550121082603"] = {name = "Lionfish", prices = {["default"] = 3.94, ["Fly"] = 70.2, ["Ride"] = 18.83, ["Fly|Ride"] = 65.63, ["Neon"] = 12.89, ["Neon|Fly"] = 78.54, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 406.88, ["Mega"] = 82.69, ["Mega|Ride"] = 728.43, ["Mega|Fly|Ride"] = 559.53}},
    ["rbxassetid://15096097714"] = {name = "Evil Rock", prices = {["default"] = 32.78, ["Ride"] = 50.34, ["Fly|Ride"] = 118.13, ["Neon"] = 146.23, ["Neon|Ride"] = 262.49, ["Neon|Fly|Ride"] = 393.75, ["Mega|Ride"] = 2598.75}},
    ["rbxassetid://117664495619345"] = {name = "Fire Foal", prices = {["default"] = 2.1, ["Fly"] = 144.83, ["Ride"] = 65.63, ["Fly|Ride"] = 908.98, ["Neon"] = 6.46, ["Neon|Ride"] = 68.86, ["Neon|Fly|Ride"] = 161.37, ["Mega"] = 63.69, ["Mega|Fly"] = 173.67, ["Mega|Ride"] = 96.48, ["Mega|Fly|Ride"] = 259.86}},
    ["rbxassetid://8938701683"] = {name = "Red Cardinal", prices = {["default"] = 2.1, ["Fly"] = 56.59, ["Ride"] = 17.07, ["Fly|Ride"] = 102.86, ["Neon"] = 7.1, ["Neon|Fly"] = 41.1, ["Neon|Ride"] = 63, ["Neon|Fly|Ride"] = 126.19, ["Mega"] = 167.66, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://12489700965"] = {name = "Tarsier", prices = {["default"] = 9.16, ["Fly"] = 35.6, ["Ride"] = 39.37, ["Fly|Ride"] = 73.36, ["Neon"] = 32.05, ["Neon|Ride"] = 141.52, ["Mega"] = 279.78, ["Mega|Ride"] = 272.87, ["Mega|Fly|Ride"] = 388.49}},
    ["rbxassetid://11765322595"] = {name = "Gingerbread Reindeer", prices = {["default"] = 35.44, ["Fly"] = 52.4, ["Ride"] = 116.81, ["Fly|Ride"] = 112.11, ["Neon"] = 418.38, ["Neon|Ride"] = 350.44, ["Neon|Fly|Ride"] = 262.5, ["Mega|Ride"] = 1181.25, ["Mega|Fly|Ride"] = 853.13}},
    ["rbxassetid://16382424275"] = {name = "Nautilus", prices = {["default"] = 28.88, ["Fly"] = 50.15, ["Ride"] = 35.44, ["Fly|Ride"] = 82.79, ["Neon"] = 92.21, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 157.18, ["Mega"] = 620.57, ["Mega|Ride"] = 349.97, ["Mega|Fly|Ride"] = 409.22}},
    ["rbxassetid://93997399823425"] = {name = "Chocolate Dutch Guinea Pig", prices = {["default"] = 70.88, ["Ride"] = 78.75, ["Fly|Ride"] = 196.87, ["Neon"] = 315, ["Neon|Ride"] = 413.44, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 1312.5, ["Mega|Ride"] = 1107.32, ["Mega|Fly|Ride"] = 1312.38}},
    ["rbxassetid://75866760046580"] = {name = "Skelebat", prices = {["default"] = 4.11, ["Ride"] = 35.44, ["Neon"] = 17.7, ["Neon|Ride"] = 62.87, ["Neon|Fly|Ride"] = 305.81, ["Mega"] = 201.41, ["Mega|Ride"] = 323.13, ["Mega|Fly|Ride"] = 329.02}},
    ["rbxassetid://111661922676557"] = {name = "Momma Moose", prices = {["default"] = 4.62, ["Ride"] = 26.16, ["Fly|Ride"] = 78.74, ["Neon"] = 26.25, ["Neon|Ride"] = 49.88, ["Neon|Fly|Ride"] = 140.42, ["Mega"] = 203.44, ["Mega|Ride"] = 203.28, ["Mega|Fly|Ride"] = 275.63}},
    ["rbxassetid://17059860310"] = {name = "Elasmosaurus", prices = {["default"] = 9.18, ["Fly"] = 65.62, ["Ride"] = 44.01, ["Fly|Ride"] = 157.5, ["Neon"] = 49.58, ["Neon|Ride"] = 137.55, ["Neon|Fly|Ride"] = 301.88, ["Mega"] = 405.5, ["Mega|Ride"] = 370.93, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://10306934599"] = {name = "Camel", prices = {["default"] = 2.1, ["Fly"] = 15.65, ["Ride"] = 11.54, ["Fly|Ride"] = 33.54, ["Neon"] = 2.1, ["Neon|Fly"] = 17.07, ["Neon|Ride"] = 14.83, ["Neon|Fly|Ride"] = 51.91, ["Mega"] = 15.72, ["Mega|Fly"] = 79.03, ["Mega|Ride"] = 26.17, ["Mega|Fly|Ride"] = 83.78}},
    ["rbxassetid://13104107016"] = {name = "Puffer Fish", prices = {["default"] = 72.75, ["Fly"] = 220.5, ["Ride"] = 91.74, ["Fly|Ride"] = 272.29, ["Neon"] = 211.63, ["Neon|Fly"] = 2375.02, ["Neon|Ride"] = 283, ["Neon|Fly|Ride"] = 471.72, ["Mega"] = 1186.08, ["Mega|Ride"] = 946.15, ["Mega|Fly|Ride"] = 853.13}},
    ["rbxassetid://17183022910"] = {name = "Mole", prices = {["default"] = 2.1, ["Ride"] = 94.31, ["Fly|Ride"] = 108.97, ["Neon"] = 6.45, ["Neon|Ride"] = 38.07, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 55.44, ["Mega|Ride"] = 51.27, ["Mega|Fly|Ride"] = 311.85}},
    ["rbxassetid://5721844051"] = {name = "Stegosaurus", prices = {["default"] = 2.1, ["Fly"] = 26.67, ["Ride"] = 15.75, ["Fly|Ride"] = 32.82, ["Neon"] = 11.8, ["Neon|Fly"] = 25.16, ["Neon|Ride"] = 32.49, ["Neon|Fly|Ride"] = 54.63, ["Mega"] = 118.13, ["Mega|Ride"] = 212.28, ["Mega|Fly|Ride"] = 518.31}},
    ["rbxassetid://114921997566126"] = {name = "S'mores Raccoon", prices = {["default"] = 83.6, ["Ride"] = 121.94, ["Fly|Ride"] = 260.6, ["Neon"] = 328.13, ["Neon|Ride"] = 354.38, ["Neon|Fly|Ride"] = 349.97, ["Mega"] = 1022.44, ["Mega|Ride"] = 1351.88, ["Mega|Fly|Ride"] = 1233.75}},
    ["rbxassetid://93038040448121"] = {name = "Nurse Shark", prices = {["default"] = 2.1, ["Ride"] = 72.18, ["Neon"] = 5.56, ["Neon|Ride"] = 52.4, ["Mega"] = 64.2, ["Mega|Ride"] = 116.31, ["Mega|Fly|Ride"] = 283.97}},
    ["rbxassetid://13936750528"] = {name = "River", prices = {["default"] = 26.25}},
    ["rbxassetid://103142927308458"] = {name = "Black-Footed Ferret", prices = {["default"] = 2.1, ["Ride"] = 62.87, ["Neon"] = 11.54, ["Neon|Ride"] = 69.17, ["Neon|Fly|Ride"] = 139.78, ["Mega"] = 46.11, ["Mega|Ride"] = 140.32, ["Mega|Fly|Ride"] = 437.07}},
    ["rbxassetid://3199974219"] = {name = "Pet Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13803784751"] = {name = "Happy Clam", prices = {["default"] = 140.39, ["Ride"] = 176.02, ["Fly|Ride"] = 236.25, ["Neon"] = 538.13, ["Neon|Ride"] = 733.36, ["Neon|Fly|Ride"] = 708.75, ["Mega"] = 3616.81, ["Mega|Ride"] = 2191.88, ["Mega|Fly|Ride"] = 2625}},
    ["rbxassetid://13665210525"] = {name = "Warthog", prices = {["default"] = 8.39, ["Ride"] = 26.17, ["Neon"] = 29.73, ["Neon|Ride"] = 61.69, ["Neon|Fly|Ride"] = 134.13, ["Mega"] = 139.33, ["Mega|Ride"] = 182.33, ["Mega|Fly|Ride"] = 443.42}},
    ["rbxassetid://18515939072"] = {name = "Black Marlin", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Neon"] = 3.59, ["Neon|Ride"] = 20.4, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 31.85, ["Mega|Ride"] = 137.6, ["Mega|Fly|Ride"] = 122.07}},
    ["rbxassetid://16075008092"] = {name = "Fanghorn Tortoise", prices = {["default"] = 4.88, ["Ride"] = 22.42, ["Neon"] = 38.75, ["Neon|Ride"] = 112.11, ["Mega|Ride"] = 548.65, ["Mega|Fly|Ride"] = 454.53}},
    ["rbxassetid://8566684181"] = {name = "Giant Black Scarab", prices = {["default"] = 9, ["Fly"] = 42, ["Ride"] = 26.64, ["Fly|Ride"] = 140.35, ["Neon"] = 74.74, ["Neon|Ride"] = 94.74, ["Neon|Fly|Ride"] = 98.51, ["Mega"] = 250.04, ["Mega|Ride"] = 223.13, ["Mega|Fly|Ride"] = 342.64}},
    ["rbxassetid://118691035196137"] = {name = "Shiver Wolf", prices = {["default"] = 128.25, ["Ride"] = 161.36, ["Neon"] = 471.65, ["Neon|Ride"] = 228.38, ["Neon|Fly|Ride"] = 583.69, ["Mega"] = 943.01, ["Mega|Ride"] = 943.01}},
    ["rbxassetid://3743735223"] = {name = "Brown Bear", prices = {["default"] = 140.39, ["Fly"] = 167.42, ["Ride"] = 155.57, ["Fly|Ride"] = 225.75, ["Neon"] = 551.15, ["Neon|Fly"] = 627.55, ["Neon|Ride"] = 473, ["Neon|Fly|Ride"] = 519.64, ["Mega|Fly|Ride"] = 2159.07}},
    ["rbxassetid://3934251801"] = {name = "Sloth", prices = {["default"] = 10.8, ["Fly"] = 23.62, ["Ride"] = 26.17, ["Fly|Ride"] = 43.31, ["Neon"] = 173.91, ["Neon|Ride"] = 104.99, ["Neon|Fly|Ride"] = 110.2, ["Mega|Ride"] = 628.67, ["Mega|Fly|Ride"] = 511.88}},
    ["rbxassetid://12139338880"] = {name = "Frogspawn", prices = {["default"] = 2.1, ["Fly"] = 131.23, ["Ride"] = 31.26, ["Fly|Ride"] = 83.83, ["Neon"] = 14.78, ["Neon|Fly"] = 59.07, ["Neon|Ride"] = 87.84, ["Neon|Fly|Ride"] = 194.91, ["Mega"] = 99.74, ["Mega|Fly"] = 167.66, ["Mega|Ride"] = 181.33, ["Mega|Fly|Ride"] = 349.97}},
    ["rbxassetid://8070926551"] = {name = "Snow Leopard", prices = {["default"] = 8.9, ["Fly"] = 98.49, ["Ride"] = 140.51, ["Neon"] = 120.49, ["Neon|Ride"] = 111.06, ["Mega"] = 415.14, ["Mega|Ride"] = 417.03, ["Mega|Fly|Ride"] = 446.25}},
    ["rbxassetid://76712147705770"] = {name = "Tuxedo Cat", prices = {["default"] = 42, ["Ride"] = 74.85, ["Fly|Ride"] = 137.82, ["Neon"] = 236.78, ["Neon|Ride"] = 245.44, ["Neon|Fly|Ride"] = 367.5, ["Mega"] = 851.82, ["Mega|Ride"] = 931.88, ["Mega|Fly|Ride"] = 912.76}},
    ["rbxassetid://15685468962"] = {name = "Tasmanian Devil", prices = {["default"] = 19.89, ["Ride"] = 82.69, ["Fly|Ride"] = 279.74, ["Neon"] = 158.02, ["Neon|Ride"] = 158.05, ["Mega"] = 577.5, ["Mega|Ride"] = 749.17, ["Mega|Fly|Ride"] = 733.46}},
    ["rbxassetid://123288277753363"] = {name = "Tri-horned Treehopper", prices = {["default"] = 320.25, ["Ride"] = 360.94, ["Neon"] = 1047.65, ["Neon|Ride"] = 1089.56, ["Neon|Fly|Ride"] = 1465.85, ["Mega"] = 4673.06, ["Mega|Fly|Ride"] = 4673.06}},
    ["rbxassetid://6060987821"] = {name = "Yeti", prices = {["default"] = 32.48, ["Ride"] = 47.19, ["Fly|Ride"] = 95.82, ["Neon"] = 178.5, ["Neon|Ride"] = 295.86, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 992.24, ["Mega|Ride"] = 891.19, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://9549841158"] = {name = "Zebra", prices = {["default"] = 2.1, ["Fly"] = 19.68, ["Ride"] = 15.64, ["Fly|Ride"] = 68.38, ["Neon"] = 2.1, ["Neon|Ride"] = 19.68, ["Neon|Fly|Ride"] = 60.36, ["Mega"] = 39.38, ["Mega|Fly"] = 104.76, ["Mega|Ride"] = 49.26, ["Mega|Fly|Ride"] = 136.23}},
    ["rbxassetid://13883282884"] = {name = "Hermit Crab", prices = {["default"] = 3.94, ["Ride"] = 279.62, ["Neon"] = 18.89, ["Neon|Ride"] = 45.85, ["Neon|Fly|Ride"] = 104.75, ["Mega"] = 157.18, ["Mega|Ride"] = 141.52, ["Mega|Fly|Ride"] = 370.93}},
    ["rbxassetid://92626539723202"] = {name = "Sea Angel", prices = {["default"] = 3.15, ["Fly|Ride"] = 144.16, ["Neon"] = 14.44, ["Neon|Ride"] = 139.51, ["Neon|Fly|Ride"] = 158.04, ["Mega"] = 122.07, ["Mega|Fly"] = 544.86, ["Mega|Ride"] = 155.09, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://15848329383"] = {name = "Jellyfish", prices = {["default"] = 372.75, ["Fly"] = 629.66, ["Ride"] = 377.98, ["Fly|Ride"] = 437.07, ["Neon"] = 1536.9, ["Neon|Ride"] = 1257.19, ["Neon|Fly|Ride"] = 1565.73, ["Mega|Ride"] = 6150.41, ["Mega|Fly|Ride"] = 5033.44}},
    ["rbxassetid://5721843846"] = {name = "Sabertooth", prices = {["default"] = 4.22, ["Fly"] = 44.77, ["Ride"] = 19.47, ["Fly|Ride"] = 52.49, ["Neon"] = 19.68, ["Neon|Ride"] = 42.47, ["Neon|Fly|Ride"] = 78.35, ["Mega"] = 126.19, ["Mega|Ride"] = 270.93}},
    ["rbxassetid://9475753090"] = {name = "Albatross", prices = {["default"] = 5.25, ["Fly"] = 22.31, ["Ride"] = 23.06, ["Fly|Ride"] = 39.38, ["Neon|Fly"] = 157.5, ["Neon|Fly|Ride"] = 139.13, ["Mega|Ride"] = 698.87, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://96894173636082"] = {name = "Clementine Owl", prices = {["default"] = 3.51, ["Fly"] = 44.71, ["Ride"] = 26.25, ["Fly|Ride"] = 117.92, ["Neon"] = 17.07, ["Neon|Fly"] = 94.5, ["Neon|Ride"] = 48.21, ["Neon|Fly|Ride"] = 86.62, ["Mega"] = 118.41, ["Mega|Ride"] = 231.57, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://10318105683"] = {name = "Orange Butterfly", prices = {["default"] = 41.92, ["Fly"] = 140.25, ["Ride"] = 83.83, ["Fly|Ride"] = 61.69, ["Neon"] = 104.9, ["Neon|Fly|Ride"] = 210, ["Mega"] = 943.01, ["Mega|Ride"] = 838.23, ["Mega|Fly|Ride"] = 643.12}},
    ["rbxassetid://15937689999"] = {name = "Rattlesnake", prices = {["default"] = 2.1, ["Fly"] = 31.42, ["Ride"] = 39.58, ["Fly|Ride"] = 61.82, ["Neon"] = 18.86, ["Neon|Ride"] = 35.63, ["Mega"] = 157.25, ["Mega|Ride"] = 396.06, ["Mega|Fly|Ride"] = 952.23}},
    ["rbxassetid://10971808447"] = {name = "Evil Basilisk", prices = {["default"] = 4.59, ["Fly"] = 104.71, ["Ride"] = 31.44, ["Fly|Ride"] = 70.2, ["Neon"] = 81.13, ["Neon|Ride"] = 140.39, ["Mega|Fly|Ride"] = 732.41}},
    ["rbxassetid://99104623628550"] = {name = "Snorgle", prices = {["default"] = 2.1, ["Ride"] = 19.04, ["Neon"] = 6.57, ["Neon|Fly"] = 38.07, ["Neon|Ride"] = 40.87, ["Mega"] = 37.97, ["Mega|Ride"] = 125.74, ["Mega|Fly|Ride"] = 291.38}},
    ["rbxassetid://136705425555561"] = {name = "Emperor Shrimp", prices = {["default"] = 5.73, ["Ride"] = 78.75, ["Neon"] = 36.75, ["Neon|Ride"] = 103.18, ["Mega"] = 416.75, ["Mega|Ride"] = 283.5}},
    ["rbxassetid://14398819258"] = {name = "Longhorn Cow", prices = {["default"] = 9.19, ["Ride"] = 28.3, ["Neon"] = 68.61, ["Neon|Ride"] = 102.38, ["Mega"] = 309.1, ["Mega|Ride"] = 559.53, ["Mega|Fly|Ride"] = 492.47}},
    ["rbxassetid://4708551284"] = {name = "Koala", prices = {["default"] = 11.68, ["Fly"] = 26.17, ["Ride"] = 27.57, ["Fly|Ride"] = 58.68, ["Neon"] = 47.16, ["Neon|Fly"] = 65.54, ["Neon|Ride"] = 44.1, ["Neon|Fly|Ride"] = 121.54, ["Mega"] = 373.02, ["Mega|Ride"] = 375.38, ["Mega|Fly|Ride"] = 393.79}},
    ["rbxassetid://4115249264"] = {name = "Zombie Buffalo", prices = {["default"] = 193.39, ["Fly"] = 196.88, ["Ride"] = 210, ["Fly|Ride"] = 262.5, ["Neon"] = 804.13, ["Neon|Ride"] = 905.63, ["Neon|Fly|Ride"] = 954.53, ["Mega|Fly|Ride"] = 3074.16}},
    ["rbxassetid://8939633862"] = {name = "Salamander", prices = {["default"] = 2.1, ["Ride"] = 18.38, ["Fly|Ride"] = 56.77, ["Neon"] = 14.55, ["Neon|Fly"] = 79.02, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 140.42, ["Mega"] = 220.5, ["Mega|Ride"] = 166.61, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://7734902431"] = {name = "Halloween White Mummy Cat", prices = {["default"] = 4.46, ["Fly"] = 41.92, ["Ride"] = 25.16, ["Fly|Ride"] = 104.91, ["Neon"] = 27.2, ["Neon|Ride"] = 32.32, ["Neon|Fly|Ride"] = 158.04, ["Mega"] = 277.23, ["Mega|Ride"] = 271.87, ["Mega|Fly|Ride"] = 410.82}},
    ["rbxassetid://115869632070663"] = {name = "Snowball Pug", prices = {["default"] = 50.68, ["Ride"] = 259.87, ["Fly|Ride"] = 111.06, ["Neon"] = 150.93, ["Neon|Ride"] = 210, ["Neon|Fly|Ride"] = 556.5, ["Mega"] = 550.73, ["Mega|Ride"] = 559.53, ["Mega|Fly|Ride"] = 864.72}},
    ["rbxassetid://8077189379"] = {name = "Husky", prices = {["default"] = 111.56, ["Fly"] = 279.74, ["Ride"] = 188.58, ["Fly|Ride"] = 262.5, ["Neon"] = 557.36, ["Neon|Ride"] = 485.63, ["Neon|Fly|Ride"] = 1101.44, ["Mega"] = 2095.55, ["Mega|Ride"] = 1791.57, ["Mega|Fly|Ride"] = 1882.13}},
    ["rbxassetid://98003529163435"] = {name = "Maine Coon", prices = {["default"] = 20.6, ["Ride"] = 95.36, ["Fly|Ride"] = 319.91, ["Neon"] = 96.47, ["Neon|Ride"] = 112.08, ["Neon|Fly|Ride"] = 279.78, ["Mega"] = 314.45, ["Mega|Ride"] = 329.31, ["Mega|Fly|Ride"] = 477.75}},
    ["rbxassetid://12488273089"] = {name = "Yellow-lipped Sea Krait", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 16.26, ["Fly|Ride"] = 47.16, ["Neon"] = 15.65, ["Neon|Fly|Ride"] = 59.07, ["Mega"] = 51.02, ["Mega|Ride"] = 190.71, ["Mega|Fly|Ride"] = 174.57}},
    ["rbxassetid://96760582519875"] = {name = "Cozy Mistletroll", prices = {["default"] = 23.06, ["Ride"] = 57.75, ["Neon"] = 37.57, ["Neon|Ride"] = 221.69, ["Neon|Fly|Ride"] = 201.94, ["Mega"] = 223.93, ["Mega|Ride"] = 521.73, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://85229142142232"] = {name = "Bunny Swirl", prices = {["default"] = 81.18, ["Fly"] = 190.32, ["Ride"] = 118.13, ["Fly|Ride"] = 210, ["Neon"] = 236.12, ["Neon|Ride"] = 231.62, ["Neon|Fly|Ride"] = 838.23, ["Mega"] = 826.88, ["Mega|Ride"] = 556.5, ["Mega|Fly|Ride"] = 853.13}},
    ["rbxassetid://121192022038625"] = {name = "Stygian Owl", prices = {["default"] = 2.63, ["Fly"] = 118.13, ["Ride"] = 102.38, ["Neon"] = 10.39, ["Neon|Ride"] = 104.72, ["Neon|Fly|Ride"] = 141.88, ["Mega"] = 52.5, ["Mega|Fly"] = 161.37, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 137.82}},
    ["rbxassetid://83732262844708"] = {name = "Pain au Chat", prices = {["default"] = 15.58, ["Ride"] = 380.87, ["Neon"] = 84, ["Neon|Ride"] = 626.45, ["Mega"] = 380.39, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://12792506715"] = {name = "Goose", prices = {["default"] = 977.82, ["Fly"] = 1336.91, ["Ride"] = 1015.87, ["Fly|Ride"] = 1047.44, ["Neon"] = 2847.65, ["Neon|Ride"] = 3459.54, ["Neon|Fly|Ride"] = 2559.38, ["Mega|Fly|Ride"] = 10883.17}},
    ["rbxassetid://12779257292"] = {name = "Pudding Cat", prices = {["default"] = 38.95, ["Fly"] = 116.59, ["Ride"] = 119.43, ["Fly|Ride"] = 187.69, ["Neon"] = 235.83, ["Neon|Fly"] = 892.5, ["Neon|Ride"] = 235.74, ["Neon|Fly|Ride"] = 314.88, ["Mega"] = 943.01, ["Mega|Ride"] = 579.03}},
    ["rbxassetid://83376259738301"] = {name = "Mrs. Whiskerpips", prices = {["default"] = 2.1, ["Fly"] = 49.2, ["Ride"] = 26.48, ["Fly|Ride"] = 80.89, ["Neon"] = 14.44, ["Neon|Fly"] = 174.98, ["Neon|Ride"] = 37.7, ["Neon|Fly|Ride"] = 113.16, ["Mega"] = 70.88, ["Mega|Ride"] = 140.42, ["Mega|Fly|Ride"] = 209.57}},
    ["rbxassetid://110894046614323"] = {name = "Partridge", prices = {["default"] = 23.39, ["Ride"] = 131.22, ["Neon"] = 113.22, ["Neon|Fly|Ride"] = 140.42, ["Mega"] = 335.3, ["Mega|Ride"] = 358.35, ["Mega|Fly|Ride"] = 924}},
    ["rbxassetid://114034119324343"] = {name = "Muskrat", prices = {["default"] = 2.1, ["Ride"] = 30.4, ["Fly|Ride"] = 419.07, ["Neon"] = 2.1, ["Neon|Ride"] = 30.61, ["Neon|Fly|Ride"] = 94.35, ["Mega"] = 26.25, ["Mega|Ride"] = 278.73, ["Mega|Fly|Ride"] = 557.43}},
    ["rbxassetid://15547904644"] = {name = "Harp Seal", prices = {["default"] = 90.5, ["Ride"] = 397.69, ["Neon"] = 328.22, ["Neon|Ride"] = 392.44, ["Neon|Fly|Ride"] = 460.94, ["Mega"] = 1100.15, ["Mega|Ride"] = 1050, ["Mega|Fly|Ride"] = 1443.75}},
    ["rbxassetid://14978702254"] = {name = "Scarecrow Cat", prices = {["default"] = 4.73, ["Fly"] = 174.57, ["Ride"] = 37.74, ["Fly|Ride"] = 47.24, ["Neon"] = 39.38, ["Neon|Ride"] = 47.17, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 414.93, ["Mega|Ride"] = 259.86, ["Mega|Fly|Ride"] = 380.63}},
    ["rbxassetid://95871612352029"] = {name = "Cold Cube", prices = {["default"] = 3.49, ["Ride"] = 26.25, ["Neon"] = 15.58, ["Neon|Ride"] = 91.17, ["Mega"] = 158.04, ["Mega|Ride"] = 258.03, ["Mega|Fly|Ride"] = 335.3}},
    ["rbxassetid://114456035353449"] = {name = "Bauble Buddies", prices = {["default"] = 56.16, ["Ride"] = 81.85, ["Fly|Ride"] = 196.88, ["Neon"] = 177.19, ["Neon|Fly"] = 278.69, ["Neon|Ride"] = 190.32, ["Neon|Fly|Ride"] = 409.22, ["Mega"] = 531.24, ["Mega|Ride"] = 698.87, ["Mega|Fly|Ride"] = 583.22}},
    ["rbxassetid://15383967605"] = {name = "Gingerbread Mouse", prices = {["default"] = 18.88, ["Ride"] = 91.87, ["Fly|Ride"] = 209.54, ["Neon"] = 117.92, ["Neon|Ride"] = 245.17, ["Mega"] = 976.54, ["Mega|Fly|Ride"] = 698.87}},
    ["rbxassetid://11767069383"] = {name = "Woolly Rhino", prices = {["default"] = 58.47, ["Neon"] = 335.26, ["Neon|Ride"] = 692.16, ["Neon|Fly|Ride"] = 1313.18, ["Mega"] = 1230.09, ["Mega|Ride"] = 2358.54, ["Mega|Fly|Ride"] = 1579.03}},
    ["rbxassetid://95133623103638"] = {name = "Samoyed", prices = {["default"] = 6.18, ["Ride"] = 62.98, ["Neon"] = 27.15, ["Neon|Ride"] = 120.29, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 129.6, ["Mega|Ride"] = 172.11, ["Mega|Fly|Ride"] = 263.81}},
    ["rbxassetid://8071236757"] = {name = "St Bernard", prices = {["default"] = 5.25, ["Ride"] = 22.32, ["Fly|Ride"] = 52.5, ["Neon"] = 53.44, ["Neon|Ride"] = 69.57, ["Neon|Fly|Ride"] = 125.34, ["Mega"] = 399, ["Mega|Ride"] = 391.88, ["Mega|Fly|Ride"] = 456.39}},
    ["rbxassetid://14276930615"] = {name = "Alley Cat", prices = {["default"] = 124.68, ["Ride"] = 188.58, ["Fly|Ride"] = 248.54, ["Neon"] = 440.5, ["Neon|Ride"] = 459.38, ["Neon|Fly|Ride"] = 525, ["Mega"] = 2358.54, ["Mega|Ride"] = 2335.15, ["Mega|Fly|Ride"] = 1989.41}},
    ["rbxassetid://6498256417"] = {name = "Dolphin", prices = {["default"] = 2.1, ["Fly"] = 32.81, ["Ride"] = 18.15, ["Fly|Ride"] = 45.32, ["Neon"] = 9.18, ["Neon|Fly"] = 64.31, ["Neon|Ride"] = 28.23, ["Neon|Fly|Ride"] = 62.48, ["Mega"] = 124.69, ["Mega|Ride"] = 145.06, ["Mega|Fly|Ride"] = 214.65}},
    ["rbxassetid://7734900468"] = {name = "Halloween White Skeleton Dog", prices = {["default"] = 6.3, ["Fly"] = 35.63, ["Ride"] = 30.05, ["Fly|Ride"] = 65.63, ["Neon"] = 45.93, ["Neon|Fly"] = 158.02, ["Neon|Ride"] = 64.37, ["Neon|Fly|Ride"] = 140.42, ["Mega"] = 235.76, ["Mega|Ride"] = 235.76, ["Mega|Fly|Ride"] = 326.55}},
    ["rbxassetid://9982202041"] = {name = "Poodle", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 15.73, ["Fly|Ride"] = 39.16, ["Neon"] = 2.1, ["Neon|Fly"] = 24.88, ["Neon|Ride"] = 20.9, ["Neon|Fly|Ride"] = 41.69, ["Mega"] = 20.97, ["Mega|Ride"] = 45.94, ["Mega|Fly|Ride"] = 79.25}},
    ["rbxassetid://73671766703168"] = {name = "Pilot Gull", prices = {["default"] = 2.1, ["Ride"] = 54.46, ["Neon"] = 3.93, ["Neon|Ride"] = 39.83, ["Mega"] = 21.17, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 64.32, ["Mega|Fly|Ride"] = 139.64}},
    ["rbxassetid://14146127209"] = {name = "Indian Leopard", prices = {["default"] = 2.5, ["Fly"] = 131.25, ["Ride"] = 27.25, ["Fly|Ride"] = 45.94, ["Neon"] = 38.06, ["Neon|Ride"] = 37.73, ["Mega"] = 91.88, ["Mega|Fly|Ride"] = 293.4}},
    ["rbxassetid://113558592714438"] = {name = "Seabed Creeper", prices = {["default"] = 40.66, ["Ride"] = 84, ["Neon"] = 522.38, ["Neon|Ride"] = 371.94, ["Neon|Fly|Ride"] = 630, ["Mega"] = 559.53, ["Mega|Ride"] = 628.67}},
    ["rbxassetid://4281674713"] = {name = "Bee", prices = {["default"] = 3.29, ["Fly"] = 17.07, ["Ride"] = 17.07, ["Fly|Ride"] = 36.68, ["Neon"] = 8.38, ["Neon|Fly"] = 27.57, ["Neon|Ride"] = 24.91, ["Neon|Fly|Ride"] = 66.93, ["Mega"] = 102.63, ["Mega|Fly"] = 170.6, ["Mega|Ride"] = 129.94, ["Mega|Fly|Ride"] = 164.06}},
    ["rbxassetid://5862774392"] = {name = "Bat", prices = {["default"] = 3.45, ["Fly"] = 24.94, ["Ride"] = 27.14, ["Fly|Ride"] = 64.97, ["Neon"] = 12.83, ["Neon|Fly"] = 36.61, ["Neon|Ride"] = 30.66, ["Neon|Fly|Ride"] = 70.22, ["Mega"] = 157.5, ["Mega|Fly"] = 305.96, ["Mega|Ride"] = 137.25, ["Mega|Fly|Ride"] = 191.61}},
    ["rbxassetid://18223359092"] = {name = "Birthday Butterfly 2024", prices = {["default"] = 2.1, ["Fly"] = 19.19, ["Ride"] = 18.09, ["Fly|Ride"] = 115.71, ["Neon"] = 9.06, ["Neon|Fly"] = 98.44, ["Neon|Ride"] = 28.25, ["Neon|Fly|Ride"] = 65.62, ["Mega"] = 56.59, ["Mega|Fly"] = 158.04, ["Mega|Ride"] = 120.5, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://17822765706"] = {name = "Pink Betta Fish", prices = {["default"] = 11.44, ["Fly"] = 279.74, ["Ride"] = 26.16, ["Neon"] = 38.88, ["Neon|Fly"] = 140.39, ["Neon|Ride"] = 59.04, ["Neon|Fly|Ride"] = 268.82, ["Mega"] = 207.81, ["Mega|Fly"] = 400.32, ["Mega|Ride"] = 207.4, ["Mega|Fly|Ride"] = 381.4}},
    ["rbxassetid://14146174264"] = {name = "Rock Pigeon", prices = {["default"] = 6.55, ["Fly"] = 162.35, ["Ride"] = 115.5, ["Neon"] = 74.84, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 279.78, ["Mega"] = 656.25, ["Mega|Ride"] = 419.12, ["Mega|Fly|Ride"] = 1047.78}},
    ["rbxassetid://11758575946"] = {name = "Water Moon Bear", prices = {["default"] = 5.25, ["Fly"] = 48.57, ["Ride"] = 20.97, ["Fly|Ride"] = 63, ["Neon"] = 27.46, ["Neon|Fly"] = 196.66, ["Neon|Ride"] = 38.75, ["Neon|Fly|Ride"] = 105, ["Mega"] = 314.88, ["Mega|Ride"] = 213.93, ["Mega|Fly|Ride"] = 320.63}},
    ["rbxassetid://6498256132"] = {name = "Seahorse", prices = {["default"] = 2.1, ["Fly"] = 20.88, ["Ride"] = 18.36, ["Fly|Ride"] = 52.49, ["Neon"] = 15.75, ["Neon|Fly"] = 66.95, ["Neon|Ride"] = 20.74, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 360.94, ["Mega|Ride"] = 234.69, ["Mega|Fly|Ride"] = 203.41}},
    ["rbxassetid://13664973582"] = {name = "Many Mackerel", prices = {["default"] = 188.51, ["Fly"] = 393.75, ["Ride"] = 224.21, ["Fly|Ride"] = 365.54, ["Neon"] = 978.51, ["Neon|Ride"] = 698.79, ["Neon|Fly|Ride"] = 1179.94, ["Mega"] = 3937.5, ["Mega|Ride"] = 3494.32, ["Mega|Fly|Ride"] = 3773.65}},
    ["rbxassetid://114806716799554"] = {name = "Ringmaster Gibbon", prices = {["default"] = 3.76, ["Ride"] = 39.12, ["Neon"] = 14.44, ["Neon|Fly|Ride"] = 279.78, ["Mega"] = 116.94, ["Mega|Ride"] = 262.5}},
    ["rbxassetid://14360917588"] = {name = "Magma Moose", prices = {["default"] = 3.21, ["Ride"] = 19.68, ["Fly|Ride"] = 56.31, ["Neon"] = 22.32, ["Neon|Fly"] = 209.54, ["Neon|Ride"] = 36.78, ["Neon|Fly|Ride"] = 140.42, ["Mega"] = 187.11, ["Mega|Ride"] = 271.39, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://18957942216"] = {name = "Starhopper", prices = {["default"] = 6.53, ["Ride"] = 24.94, ["Neon"] = 50.3, ["Neon|Ride"] = 213.44, ["Neon|Fly|Ride"] = 628.67, ["Mega"] = 461.77, ["Mega|Ride"] = 656.25, ["Mega|Fly|Ride"] = 429.85}},
    ["rbxassetid://3181727071"] = {name = "Puma", prices = {["default"] = 2.1, ["Fly"] = 9.19, ["Ride"] = 15.73, ["Fly|Ride"] = 30.35, ["Neon"] = 2.63, ["Neon|Fly"] = 20.89, ["Neon|Ride"] = 15.74, ["Neon|Fly|Ride"] = 41.97, ["Mega"] = 18.38, ["Mega|Fly"] = 162.75, ["Mega|Ride"] = 59.73, ["Mega|Fly|Ride"] = 91.88}},
    ["rbxassetid://4841039508"] = {name = "Rock", prices = {["default"] = 2.1, ["Fly"] = 56.47, ["Ride"] = 26.04, ["Fly|Ride"] = 59.07, ["Neon"] = 18.79, ["Neon|Ride"] = 31.17, ["Neon|Fly|Ride"] = 48.15, ["Mega"] = 119.44, ["Mega|Ride"] = 114.54, ["Mega|Fly|Ride"] = 224.44}},
    ["rbxassetid://94235745630523"] = {name = "Rainbow Trout", prices = {["default"] = 5.25, ["Ride"] = 56.59, ["Neon"] = 15.49, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 58.94, ["Mega|Ride"] = 187.69, ["Mega|Fly|Ride"] = 293.4}},
    ["rbxassetid://4440867249"] = {name = "Llama", prices = {["default"] = 72.18, ["Fly"] = 105, ["Ride"] = 95.82, ["Fly|Ride"] = 144.38, ["Neon"] = 520.01, ["Neon|Ride"] = 406.88, ["Neon|Fly|Ride"] = 414.05, ["Mega|Ride"] = 3494.32, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://11571113805"] = {name = "Bloodhound", prices = {["default"] = 3.14, ["Fly"] = 85.32, ["Ride"] = 33.54, ["Fly|Ride"] = 65.63, ["Neon"] = 26.25, ["Neon|Ride"] = 79.01, ["Neon|Fly|Ride"] = 112.12, ["Mega"] = 209.41, ["Mega|Ride"] = 259.86, ["Mega|Fly|Ride"] = 471.72}},
    ["rbxassetid://78423968285099"] = {name = "Wren", prices = {["default"] = 2.1, ["Fly"] = 31.44, ["Ride"] = 45.04, ["Fly|Ride"] = 118.13, ["Neon"] = 11.8, ["Neon|Ride"] = 125.73, ["Neon|Fly|Ride"] = 167.66, ["Mega"] = 45.94, ["Mega|Fly"] = 313.69, ["Mega|Ride"] = 103.74, ["Mega|Fly|Ride"] = 209.57}},
    ["rbxassetid://110871792705214"] = {name = "Burger Bear", prices = {["default"] = 62.61, ["Fly"] = 210, ["Ride"] = 94.5, ["Fly|Ride"] = 190.32, ["Neon"] = 157.5, ["Neon|Ride"] = 209.99, ["Neon|Fly|Ride"] = 275.63, ["Mega"] = 451.5, ["Mega|Ride"] = 531.24, ["Mega|Fly|Ride"] = 630}},
    ["rbxassetid://3181727637"] = {name = "Fennec Fox", prices = {["default"] = 2.1, ["Fly"] = 15.73, ["Ride"] = 15.73, ["Fly|Ride"] = 26.25, ["Neon"] = 2.1, ["Neon|Fly"] = 24.11, ["Neon|Ride"] = 15.73, ["Neon|Fly|Ride"] = 38.96, ["Mega"] = 27.46, ["Mega|Fly"] = 43.25, ["Mega|Ride"] = 56.59, ["Mega|Fly|Ride"] = 81.38}},
    ["rbxassetid://115530716039589"] = {name = "Milk Choccybunny", prices = {["default"] = 2.1, ["Ride"] = 52.5, ["Neon"] = 4.18, ["Neon|Ride"] = 68.88, ["Neon|Fly|Ride"] = 77.94, ["Mega"] = 47.73, ["Mega|Ride"] = 62.92, ["Mega|Fly|Ride"] = 279.74}},
    ["rbxassetid://83001092186817"] = {name = "White Choccybunny", prices = {["default"] = 2.62, ["Ride"] = 107.63, ["Fly|Ride"] = 137.82, ["Neon"] = 11.57, ["Neon|Ride"] = 90.96, ["Neon|Fly|Ride"] = 187.57, ["Mega"] = 114.1}},
    ["rbxassetid://103795616446776"] = {name = "Waffle Wyrm", prices = {["default"] = 7.41, ["Fly"] = 98.49, ["Ride"] = 59.07, ["Fly|Ride"] = 137.63, ["Neon"] = 32.7, ["Neon|Fly"] = 136.5, ["Neon|Ride"] = 93.7, ["Neon|Fly|Ride"] = 196.87, ["Mega"] = 108.94, ["Mega|Fly"] = 183.75, ["Mega|Ride"] = 210, ["Mega|Fly|Ride"] = 313.69}},
    ["rbxassetid://9982358951"] = {name = "Orangutan", prices = {["default"] = 2.1, ["Fly"] = 15.73, ["Ride"] = 15.65, ["Fly|Ride"] = 28.88, ["Neon"] = 2.1, ["Neon|Fly"] = 22.43, ["Neon|Ride"] = 25.99, ["Neon|Fly|Ride"] = 69.58, ["Mega"] = 26.17, ["Mega|Ride"] = 31.49, ["Mega|Fly|Ride"] = 140.42}},
    ["rbxassetid://129021417712364"] = {name = "Kage Crow", prices = {["default"] = 12.83, ["Ride"] = 40.11, ["Neon"] = 118.13, ["Neon|Ride"] = 183.74, ["Neon|Fly|Ride"] = 219.85, ["Mega"] = 485.14, ["Mega|Ride"] = 438.38, ["Mega|Fly|Ride"] = 670.5}},
    ["rbxassetid://4849941238"] = {name = "Hedgehog", prices = {["default"] = 2624.99, ["Fly"] = 3150, ["Ride"] = 2738.74, ["Fly|Ride"] = 2703.75, ["Neon|Ride"] = 9778.69, ["Neon|Fly|Ride"] = 9434.1, ["Mega|Fly|Ride"] = 43482.35}},
    ["rbxassetid://4800190144"] = {name = "Ginger Cat", prices = {["default"] = 2.1, ["Fly"] = 23.97, ["Ride"] = 17.05, ["Fly|Ride"] = 45.94, ["Neon"] = 10.29, ["Neon|Fly"] = 69.17, ["Neon|Ride"] = 20.97, ["Neon|Fly|Ride"] = 66.92, ["Mega"] = 57.75, ["Mega|Fly"] = 467.33, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 179.86}},
    ["rbxassetid://18119333909"] = {name = "Rodeo Bull", prices = {["default"] = 2.1, ["Neon"] = 11.82, ["Mega"] = 126, ["Mega|Fly"] = 441, ["Mega|Ride"] = 437.07, ["Mega|Fly|Ride"] = 628.67}},
    ["rbxassetid://11837080223"] = {name = "Highland Cow", prices = {["default"] = 20.76, ["Ride"] = 31.5, ["Fly|Ride"] = 122.27, ["Neon"] = 94.5, ["Neon|Ride"] = 279.74, ["Neon|Fly|Ride"] = 216.09, ["Mega"] = 328.13, ["Mega|Ride"] = 383.24, ["Mega|Fly|Ride"] = 498.75}},
    ["rbxassetid://14398816006"] = {name = "Rooster", prices = {["default"] = 39.35, ["Ride"] = 98.44, ["Neon"] = 155.04, ["Neon|Ride"] = 279.74, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 540.75, ["Mega|Ride"] = 522.85, ["Mega|Fly|Ride"] = 818.42}},
    ["rbxassetid://3409444089"] = {name = "Hyena", prices = {["default"] = 161.11, ["Fly"] = 1397.57, ["Ride"] = 189, ["Fly|Ride"] = 272.4, ["Neon"] = 1312.5, ["Neon|Fly"] = 656.25, ["Neon|Ride"] = 698.79, ["Neon|Fly|Ride"] = 656.25, ["Mega"] = 6286.62, ["Mega|Fly|Ride"] = 2514.75}},
    ["rbxassetid://127067345833475"] = {name = "Hummingbird", prices = {["default"] = 7.61, ["Fly"] = 26.25, ["Ride"] = 52.5, ["Fly|Ride"] = 675.94, ["Neon"] = 52.5, ["Neon|Ride"] = 82.37, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 112.12, ["Mega|Fly"] = 13125, ["Mega|Ride"] = 129.94, ["Mega|Fly|Ride"] = 582.75}},
    ["rbxassetid://130497948875084"] = {name = "Marabou Stork", prices = {["default"] = 2.1, ["Ride"] = 62.87, ["Neon"] = 15.03, ["Neon|Fly"] = 98.49, ["Neon|Fly|Ride"] = 523.89, ["Mega"] = 136.5, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 838.47}},
    ["rbxassetid://127017727552531"] = {name = "Angus Calf", prices = {["default"] = 2.1, ["Fly"] = 101.98, ["Ride"] = 40.16, ["Fly|Ride"] = 131.25, ["Neon"] = 11.8, ["Neon|Ride"] = 42, ["Mega"] = 99.27, ["Mega|Ride"] = 125.7, ["Mega|Fly|Ride"] = 245.31}},
    ["rbxassetid://12779130089"] = {name = "Sprout Snail", prices = {["default"] = 11.82, ["Ride"] = 98.44, ["Fly|Ride"] = 656.25, ["Neon"] = 162.4, ["Neon|Ride"] = 1165.81, ["Neon|Fly|Ride"] = 293.4, ["Mega"] = 374.06, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 685.79}},
    ["rbxassetid://117824155556510"] = {name = "Princess Mare", prices = {["default"] = 2.1, ["Ride"] = 70.2, ["Neon"] = 2.63, ["Neon|Ride"] = 28.25, ["Mega"] = 19.69, ["Mega|Ride"] = 133.88}},
    ["rbxassetid://122766274014139"] = {name = "Gaelic Fae", prices = {["default"] = 82.69, ["Fly"] = 209.54, ["Ride"] = 78.74, ["Fly|Ride"] = 143.07, ["Neon"] = 410.84, ["Neon|Fly"] = 502.88, ["Neon|Ride"] = 410.69, ["Neon|Fly|Ride"] = 520.01, ["Mega"] = 1365, ["Mega|Fly|Ride"] = 1668.07}},
    ["rbxassetid://17255807019"] = {name = "Weevil", prices = {["default"] = 2.1, ["Ride"] = 32.82, ["Neon"] = 6.42, ["Neon|Ride"] = 137.67, ["Mega"] = 52.5, ["Mega|Ride"] = 141.1}},
    ["rbxassetid://3743720235"] = {name = "Capybara", prices = {["default"] = 49.54, ["Fly"] = 220.52, ["Ride"] = 72.19, ["Fly|Ride"] = 140.39, ["Neon"] = 283, ["Neon|Ride"] = 275.63, ["Neon|Fly|Ride"] = 437.06, ["Mega"] = 2625, ["Mega|Ride"] = 2673.4, ["Mega|Fly|Ride"] = 1311.19}},
    ["rbxassetid://106815320234576"] = {name = "Ehecatl", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 24.11, ["Fly|Ride"] = 69.72, ["Neon"] = 5.21, ["Neon|Fly"] = 120.49, ["Neon|Ride"] = 41.92, ["Neon|Fly|Ride"] = 83.99, ["Mega"] = 52.49, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 117.88}},
    ["rbxassetid://110449571836616"] = {name = "Irish Setter", prices = {["default"] = 2.1, ["Neon"] = 15.43, ["Neon|Ride"] = 118.13, ["Mega"] = 98.42, ["Mega|Fly|Ride"] = 555.19}},
    ["rbxassetid://93751644677101"] = {name = "Winter Doe", prices = {["default"] = 13.12, ["Ride"] = 53.55, ["Fly|Ride"] = 208.49, ["Neon"] = 52.5, ["Neon|Ride"] = 314.88, ["Mega"] = 229.69, ["Mega|Ride"] = 288.75, ["Mega|Fly|Ride"] = 892.5}},
    ["rbxassetid://90667836208550"] = {name = "Munchkin Cat", prices = {["default"] = 348.6, ["Fly"] = 559.46, ["Ride"] = 426.57, ["Fly|Ride"] = 529.6, ["Neon"] = 1279.69, ["Neon|Ride"] = 1312.5, ["Neon|Fly|Ride"] = 1299.79, ["Mega"] = 4230.24, ["Mega|Ride"] = 4587.15, ["Mega|Fly|Ride"] = 4289.24}},
    ["rbxassetid://3743734696"] = {name = "Rhino", prices = {["default"] = 38.06, ["Ride"] = 51.19, ["Fly|Ride"] = 88.81, ["Neon"] = 177.19, ["Neon|Fly"] = 314.84, ["Neon|Ride"] = 173.75, ["Neon|Fly|Ride"] = 295.32, ["Mega|Ride"] = 831.94, ["Mega|Fly|Ride"] = 984.38}},
    ["rbxassetid://7734928397"] = {name = "Halloween Blue Scorpion", prices = {["default"] = 2.1, ["Fly"] = 47.38, ["Ride"] = 16.95, ["Fly|Ride"] = 91.88, ["Neon"] = 7.09, ["Neon|Fly"] = 85.32, ["Neon|Ride"] = 20.97, ["Neon|Fly|Ride"] = 56.59, ["Mega"] = 59.07, ["Mega|Ride"] = 83.79, ["Mega|Fly|Ride"] = 629.74}},
    ["rbxassetid://116859365721104"] = {name = "Shadow Dragon Ducky", prices = {["default"] = 14.67, ["Fly"] = 364.62, ["Ride"] = 38.57, ["Fly|Ride"] = 140.44, ["Neon"] = 53.49, ["Neon|Fly"] = 188.14, ["Neon|Ride"] = 125.73, ["Neon|Fly|Ride"] = 181.32, ["Mega"] = 216.57, ["Mega|Fly"] = 388.16, ["Mega|Ride"] = 254.43, ["Mega|Fly|Ride"] = 360.72}},
    ["rbxassetid://6060991084"] = {name = "Musk Ox", prices = {["default"] = 8.84, ["Ride"] = 22.64, ["Fly|Ride"] = 265.13, ["Neon"] = 126, ["Neon|Ride"] = 65.63, ["Mega|Ride"] = 446.36, ["Mega|Fly|Ride"] = 471.52}},
    ["rbxassetid://119284351481681"] = {name = "Violet Friend", prices = {["default"] = 3.94, ["Neon"] = 15.5, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 59.05, ["Mega|Ride"] = 150.22, ["Mega|Fly|Ride"] = 406.88}},
    ["rbxassetid://10971808356"] = {name = "Basilisk", prices = {["default"] = 2.1, ["Fly"] = 86.62, ["Ride"] = 22.32, ["Fly|Ride"] = 51.9, ["Neon"] = 26.25, ["Neon|Ride"] = 32.79, ["Neon|Fly|Ride"] = 210.08, ["Mega"] = 550.73, ["Mega|Ride"] = 486.94, ["Mega|Fly|Ride"] = 489.33}},
    ["rbxassetid://3744706727"] = {name = "Platypus", prices = {["default"] = 119.99, ["Ride"] = 118.12, ["Fly|Ride"] = 175.88, ["Neon"] = 628.6, ["Neon|Ride"] = 615.56, ["Neon|Fly|Ride"] = 853.12, ["Mega|Ride"] = 2933.77, ["Mega|Fly|Ride"] = 3490.13}},
    ["rbxassetid://12480556316"] = {name = "Black Macaque", prices = {["default"] = 26.25, ["Fly"] = 95.82, ["Ride"] = 104.78, ["Fly|Ride"] = 157.97, ["Neon"] = 192.94, ["Neon|Ride"] = 192.14, ["Mega"] = 837.18, ["Mega|Ride"] = 786.19, ["Mega|Fly|Ride"] = 775.98}},
    ["rbxassetid://4849941000"] = {name = "Dalmatian", prices = {["default"] = 2152.5, ["Fly"] = 2349.37, ["Ride"] = 2100, ["Fly|Ride"] = 2362.47, ["Neon"] = 11175.18, ["Neon|Fly|Ride"] = 7743.75, ["Mega|Fly|Ride"] = 26250}},
    ["rbxassetid://139319822015938"] = {name = "Sea Skeleton Panda", prices = {["default"] = 2.1, ["Fly"] = 65625, ["Ride"] = 41.92, ["Fly|Ride"] = 170.63, ["Neon"] = 13.92, ["Neon|Ride"] = 109.48, ["Neon|Fly|Ride"] = 195.96, ["Mega"] = 125.97, ["Mega|Ride"] = 167.35, ["Mega|Fly|Ride"] = 419.12}},
    ["rbxassetid://104838807480936"] = {name = "Winter Fawn", prices = {["default"] = 72.19, ["Ride"] = 77.83, ["Neon"] = 656.25, ["Neon|Fly|Ride"] = 253.32, ["Mega"] = 275.63, ["Mega|Ride"] = 291.38, ["Mega|Fly|Ride"] = 565.81}},
    ["rbxassetid://100705885132301"] = {name = "Cabbit", prices = {["default"] = 862.68, ["Fly"] = 1453.09, ["Ride"] = 853.12, ["Fly|Ride"] = 1000.13, ["Neon"] = 2232.76, ["Neon|Ride"] = 3144.71, ["Neon|Fly|Ride"] = 2428.13, ["Mega|Fly|Ride"] = 11315.91}},
    ["rbxassetid://12480406935"] = {name = "Binturong", prices = {["default"] = 36.74, ["Ride"] = 61.82, ["Neon"] = 237.59, ["Neon|Ride"] = 279.72, ["Mega"] = 727.16, ["Mega|Ride"] = 616.88, ["Mega|Fly|Ride"] = 717.94}},
    ["rbxassetid://73245262062822"] = {name = "Prism Snake", prices = {["default"] = 4.11, ["Ride"] = 22.91, ["Neon"] = 15.73, ["Neon|Ride"] = 140.39, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 182.33, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://113717425344888"] = {name = "Magpie", prices = {["default"] = 2.1, ["Fly"] = 111.56, ["Ride"] = 19.69, ["Neon"] = 7.08, ["Neon|Ride"] = 24.81, ["Mega"] = 31.45, ["Mega|Ride"] = 106.32, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://10318105900"] = {name = "Purple Butterfly", prices = {["default"] = 82.68, ["Ride"] = 126, ["Fly|Ride"] = 314.84, ["Neon"] = 459.38, ["Neon|Fly|Ride"] = 628.67, ["Mega"] = 2235.95, ["Mega|Fly|Ride"] = 2673.4}},
    ["rbxassetid://95049698731940"] = {name = "Throwback Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15503941919"] = {name = "Arctic Hare", prices = {["default"] = 6.55, ["Neon"] = 70.2, ["Neon|Ride"] = 84.38}},
    ["rbxassetid://10274421272"] = {name = "Royal Corgi", prices = {["default"] = 76.12, ["Ride"] = 97.63, ["Neon"] = 341.25, ["Neon|Ride"] = 315.28, ["Mega|Fly|Ride"] = 1785.18}},
    ["rbxassetid://13978968837"] = {name = "Bird of Paradise", prices = {["default"] = 3.94, ["Fly"] = 104.98, ["Neon"] = 33.16, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 136.23, ["Mega|Ride"] = 144.38}},
    ["rbxassetid://3261465850"] = {name = "Pink Cat", prices = {["default"] = 249.38, ["Fly"] = 300.69, ["Ride"] = 262.5, ["Fly|Ride"] = 345.07, ["Neon"] = 1101.31, ["Neon|Ride"] = 1035.07, ["Neon|Fly|Ride"] = 782.21, ["Mega|Fly|Ride"] = 4155.46}},
    ["rbxassetid://8969010905"] = {name = "Red Fox", prices = {["default"] = 3.13, ["Fly"] = 87.3, ["Ride"] = 27.25, ["Fly|Ride"] = 54.49, ["Neon"] = 41.92, ["Neon|Ride"] = 64.26, ["Neon|Fly|Ride"] = 104.99, ["Mega"] = 306.62, ["Mega|Ride"] = 287.44, ["Mega|Fly|Ride"] = 698.87}},
    ["rbxassetid://3181728128"] = {name = "Red Panda", prices = {["default"] = 2.1, ["Fly"] = 17.7, ["Ride"] = 18.38, ["Fly|Ride"] = 39.36, ["Neon"] = 6.48, ["Neon|Fly"] = 19.92, ["Neon|Ride"] = 28.3, ["Neon|Fly|Ride"] = 42.8, ["Mega"] = 62.35, ["Mega|Fly"] = 120.5, ["Mega|Ride"] = 60.36, ["Mega|Fly|Ride"] = 139.97}},
    ["rbxassetid://13077769577"] = {name = "Pelican", prices = {["default"] = 896.32, ["Fly"] = 1047.65, ["Ride"] = 903, ["Neon|Ride"] = 7683.4, ["Neon|Fly|Ride"] = 4743.38, ["Mega"] = 26544.14, ["Mega|Fly|Ride"] = 27940.82}},
    ["rbxassetid://115281603518501"] = {name = "DJ Snooze", prices = {["default"] = 7.06, ["Fly"] = 978.51, ["Ride"] = 210, ["Neon"] = 41.5, ["Neon|Ride"] = 69.84, ["Mega"] = 179.54, ["Mega|Ride"] = 267.71, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://111847888001946"] = {name = "Choco Penguin", prices = {["default"] = 6.33, ["Fly"] = 70.2, ["Ride"] = 35.63, ["Fly|Ride"] = 119.44, ["Neon"] = 35.44, ["Neon|Fly"] = 77.68, ["Neon|Ride"] = 59.04, ["Neon|Fly|Ride"] = 112.12, ["Mega"] = 178.5, ["Mega|Ride"] = 202.26, ["Mega|Fly|Ride"] = 313.69}},
    ["rbxassetid://4621220487"] = {name = "Panda", prices = {["default"] = 29.89, ["Fly"] = 44.62, ["Ride"] = 27.25, ["Fly|Ride"] = 69.21, ["Neon|Ride"] = 157.49, ["Neon|Fly|Ride"] = 170.62, ["Mega"] = 2095.55, ["Mega|Fly|Ride"] = 861}},
    ["rbxassetid://12917347184"] = {name = "Flower Power Duckling", prices = {["default"] = 16.71, ["Fly"] = 72.19, ["Ride"] = 31.5, ["Fly|Ride"] = 85.32, ["Neon"] = 59.2, ["Neon|Ride"] = 102.69, ["Neon|Fly|Ride"] = 176.17, ["Mega"] = 364.88, ["Mega|Fly"] = 315, ["Mega|Ride"] = 376.69, ["Mega|Fly|Ride"] = 448.46}},
    ["rbxassetid://93775555430694"] = {name = "Pumpkin Friend", prices = {["default"] = 23.82, ["Ride"] = 262.5, ["Fly|Ride"] = 70.2, ["Neon"] = 87.94, ["Neon|Ride"] = 183.1, ["Neon|Fly|Ride"] = 456.39, ["Mega"] = 486.19, ["Mega|Ride"] = 536.48, ["Mega|Fly|Ride"] = 685.26}},
    ["rbxassetid://83317902236850"] = {name = "Kakapo", prices = {["default"] = 2.1, ["Ride"] = 116.59, ["Fly|Ride"] = 235.83, ["Neon"] = 2.62, ["Neon|Ride"] = 28.13, ["Neon|Fly|Ride"] = 59.07, ["Mega"] = 19.72, ["Mega|Fly"] = 84.92, ["Mega|Ride"] = 41.62, ["Mega|Fly|Ride"] = 89.07}},
    ["rbxassetid://5862774043"] = {name = "Ghost Bunny", prices = {["default"] = 37.26, ["Fly"] = 87.93, ["Ride"] = 48.57, ["Fly|Ride"] = 103.73, ["Neon"] = 262.98, ["Neon|Fly"] = 283, ["Neon|Ride"] = 267.02, ["Neon|Fly|Ride"] = 261.18, ["Mega"] = 3352.88, ["Mega|Fly|Ride"] = 1051.66}},
    ["rbxassetid://10639131895"] = {name = "Spider Crab", prices = {["default"] = 2.1, ["Fly"] = 27.25, ["Ride"] = 28.3, ["Fly|Ride"] = 70.88, ["Neon"] = 31.4, ["Neon|Ride"] = 140.42, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 773.07, ["Mega|Ride"] = 279.78, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://10193736072"] = {name = "Red Crowned Crane", prices = {["default"] = 2.1, ["Fly"] = 28.03, ["Ride"] = 20.86, ["Fly|Ride"] = 50.71, ["Neon"] = 15.75, ["Neon|Ride"] = 49, ["Neon|Fly|Ride"] = 131.24, ["Mega|Ride"] = 263.23, ["Mega|Fly|Ride"] = 203.44}},
    ["rbxassetid://13804047294"] = {name = "Arctic Tern", prices = {["default"] = 7.88, ["Ride"] = 103.69, ["Neon"] = 104.9, ["Neon|Ride"] = 838.13, ["Neon|Fly|Ride"] = 184.33, ["Mega"] = 293.4, ["Mega|Fly|Ride"] = 471.72}},
    ["rbxassetid://14883937353"] = {name = "Ghost Dog", prices = {["default"] = 21, ["Fly"] = 262.39, ["Ride"] = 87.28, ["Fly|Ride"] = 236.25, ["Neon"] = 124.68, ["Neon|Fly"] = 309.07, ["Neon|Ride"] = 188.69, ["Neon|Fly|Ride"] = 255.67, ["Mega"] = 723.39, ["Mega|Ride"] = 771.25, ["Mega|Fly|Ride"] = 661.5}},
    ["rbxassetid://103241919688695"] = {name = "2025 Birthday Butterfly", prices = {["default"] = 7.22, ["Ride"] = 131.25, ["Neon"] = 20.89, ["Neon|Ride"] = 72.96, ["Neon|Fly|Ride"] = 127.85, ["Mega"] = 59.07, ["Mega|Fly"] = 698.87, ["Mega|Ride"] = 112.12, ["Mega|Fly|Ride"] = 314.88}},
    ["rbxassetid://86594144838863"] = {name = "Tree Frog", prices = {["default"] = 2.1, ["Ride"] = 27.85, ["Neon"] = 2.1, ["Neon|Ride"] = 41.92, ["Neon|Fly|Ride"] = 39.29, ["Mega"] = 17.06, ["Mega|Ride"] = 47.4, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://99048375832409"] = {name = "Shih Tzu", prices = {["default"] = 2.1, ["Fly"] = 70.2, ["Ride"] = 20.97, ["Fly|Ride"] = 81.99, ["Neon"] = 2.63, ["Neon|Ride"] = 32.34, ["Mega"] = 20.14, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 106.32}},
    ["rbxassetid://6998403122"] = {name = "Kirin", prices = {["default"] = 2.1, ["Fly"] = 25.9, ["Ride"] = 24.08, ["Fly|Ride"] = 51.14, ["Neon"] = 9.44, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 52.4, ["Mega"] = 92.19, ["Mega|Fly|Ride"] = 148.32}},
    ["rbxassetid://15930472964"] = {name = "Gila Monster", prices = {["default"] = 2.1, ["Ride"] = 27.74, ["Fly|Ride"] = 5306.04, ["Neon"] = 15.73, ["Neon|Ride"] = 1312.5, ["Mega"] = 98.44, ["Mega|Ride"] = 106.3, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://5721843144"] = {name = "Dilophosaurus", prices = {["default"] = 2.1, ["Fly"] = 26.24, ["Ride"] = 17.05, ["Fly|Ride"] = 41.85, ["Neon"] = 13.81, ["Neon|Fly"] = 52.4, ["Neon|Ride"] = 31.34, ["Neon|Fly|Ride"] = 77.17, ["Mega"] = 283.03, ["Mega|Ride"] = 276.29, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://109520235810036"] = {name = "Mini Schnauzer", prices = {["default"] = 105, ["Ride"] = 204.3, ["Fly|Ride"] = 559.46, ["Neon"] = 245.17, ["Neon|Ride"] = 299.51, ["Neon|Fly|Ride"] = 1047.78, ["Mega"] = 824.61, ["Mega|Ride"] = 786.59, ["Mega|Fly|Ride"] = 1110.64}},
    ["rbxassetid://3181728229"] = {name = "Snow Cat", prices = {["default"] = 2.1, ["Fly"] = 18.38, ["Ride"] = 18.87, ["Fly|Ride"] = 39.82, ["Neon"] = 2.1, ["Neon|Fly"] = 20.93, ["Neon|Ride"] = 20.97, ["Neon|Fly|Ride"] = 46.16, ["Mega"] = 27.46, ["Mega|Ride"] = 69.17, ["Mega|Fly|Ride"] = 91.65}},
    ["rbxassetid://4506925747"] = {name = "Wolf", prices = {["default"] = 9.44, ["Fly"] = 62.87, ["Ride"] = 25.16, ["Fly|Ride"] = 77.01, ["Neon"] = 46.76, ["Neon|Fly"] = 91.71, ["Neon|Ride"] = 62.91, ["Neon|Fly|Ride"] = 98.49, ["Mega"] = 838.23, ["Mega|Ride"] = 239.09, ["Mega|Fly|Ride"] = 304.5}},
    ["rbxassetid://5862774473"] = {name = "Albino Bat", prices = {["default"] = 15.73, ["Fly"] = 38.85, ["Ride"] = 25.19, ["Fly|Ride"] = 98.44, ["Neon"] = 99.75, ["Neon|Fly"] = 139.63, ["Neon|Ride"] = 93.95, ["Neon|Fly|Ride"] = 156.84, ["Mega"] = 1131.61, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 444.34}},
    ["rbxassetid://14978701751"] = {name = "Scarecrow", prices = {["default"] = 3.67, ["Fly"] = 140.39, ["Ride"] = 47.17, ["Neon"] = 35.44, ["Neon|Ride"] = 70.2, ["Mega"] = 131.25, ["Mega|Ride"] = 183.75}},
    ["rbxassetid://10235589000"] = {name = "Corgi", prices = {["default"] = 2.1, ["Fly"] = 17.7, ["Ride"] = 14.44, ["Fly|Ride"] = 39.82, ["Neon"] = 3.8, ["Neon|Fly"] = 40.87, ["Neon|Ride"] = 17.7, ["Neon|Fly|Ride"] = 64.32, ["Mega"] = 46.5, ["Mega|Fly"] = 105, ["Mega|Ride"] = 61.69, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://103710623311342"] = {name = "Ghost Chick", prices = {["default"] = 3.81, ["Fly"] = 70.17, ["Ride"] = 28.3, ["Neon"] = 14.16, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 96.52, ["Mega"] = 126, ["Mega|Fly"] = 735, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 278.73}},
    ["rbxassetid://4440866423"] = {name = "Cow", prices = {["default"] = 969.93, ["Fly"] = 1229.94, ["Ride"] = 1010.62, ["Fly|Ride"] = 1018.5, ["Neon"] = 2827.59, ["Neon|Ride"] = 2777.31, ["Neon|Fly|Ride"] = 2079, ["Mega|Fly|Ride"] = 6692.44}},
    ["rbxassetid://15093139154"] = {name = "Slime", prices = {["default"] = 67.02, ["Fly"] = 158.02, ["Ride"] = 114.93, ["Fly|Ride"] = 196.88, ["Neon"] = 315, ["Neon|Ride"] = 349.93, ["Neon|Fly|Ride"] = 495.3, ["Mega"] = 1672.26, ["Mega|Ride"] = 1662.83, ["Mega|Fly|Ride"] = 1326.94}},
    ["rbxassetid://82170828935980"] = {name = "Dracula Fish", prices = {["default"] = 2.1, ["Ride"] = 68.49, ["Neon"] = 7.88, ["Neon|Ride"] = 70.22, ["Neon|Fly|Ride"] = 209.57, ["Mega"] = 65.54, ["Mega|Ride"] = 95.27, ["Mega|Fly|Ride"] = 182.33}},
    ["rbxassetid://11109302289"] = {name = "Zombie Wolf", prices = {["default"] = 45.3, ["Ride"] = 85.03, ["Fly|Ride"] = 157.5, ["Neon"] = 203.25, ["Neon|Ride"] = 229.45, ["Neon|Fly|Ride"] = 308.44, ["Mega"] = 1023.75, ["Mega|Ride"] = 937.43, ["Mega|Fly|Ride"] = 836.07}},
    ["rbxassetid://15369729071"] = {name = "Nutcracker Squirrel", prices = {["default"] = 6, ["Ride"] = 64.32, ["Fly|Ride"] = 156.19, ["Neon"] = 119.81, ["Neon|Ride"] = 279.74, ["Neon|Fly|Ride"] = 278.73, ["Mega"] = 274.32, ["Mega|Ride"] = 314.88, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://9800792849"] = {name = "Goat", prices = {["default"] = 209.98, ["Fly"] = 419.07, ["Ride"] = 262.49, ["Fly|Ride"] = 308.95, ["Neon"] = 900.38, ["Neon|Ride"] = 1112.62, ["Neon|Fly|Ride"] = 944.99, ["Mega|Fly|Ride"] = 4579.8}},
    ["rbxassetid://12509687499"] = {name = "Banded Palm Civet", prices = {["default"] = 2.1, ["Fly"] = 90.69, ["Ride"] = 15.58, ["Fly|Ride"] = 131.25, ["Neon"] = 19.69, ["Neon|Ride"] = 54, ["Mega"] = 401.31, ["Mega|Fly"] = 279.78, ["Mega|Ride"] = 65.62}},
    ["rbxassetid://10381386150"] = {name = "Rhino Beetle", prices = {["default"] = 2.1, ["Neon"] = 19.69, ["Neon|Ride"] = 83.84, ["Mega"] = 335.3}},
    ["rbxassetid://130734656883878"] = {name = "Merry Mistletroll", prices = {["default"] = 64.2, ["Ride"] = 102.38, ["Fly|Ride"] = 279.74, ["Neon"] = 354.38, ["Neon|Ride"] = 410.82, ["Mega"] = 590.63, ["Mega|Ride"] = 557.43, ["Mega|Fly|Ride"] = 796.32}},
    ["rbxassetid://15923337068"] = {name = "Oryx", prices = {["default"] = 2.1, ["Fly"] = 10.5, ["Ride"] = 48.54, ["Fly|Ride"] = 112.11, ["Neon"] = 14.44, ["Neon|Ride"] = 35.63, ["Mega"] = 279.78, ["Mega|Ride"] = 223.13, ["Mega|Fly|Ride"] = 131.15}},
    ["rbxassetid://6245080365"] = {name = "Ox", prices = {["default"] = 2.1, ["Fly"] = 18.38, ["Ride"] = 15.63, ["Fly|Ride"] = 32.81, ["Neon"] = 2.1, ["Neon|Fly"] = 31.29, ["Neon|Ride"] = 27.25, ["Neon|Fly|Ride"] = 45.94, ["Mega"] = 42.47, ["Mega|Fly"] = 70.22, ["Mega|Ride"] = 39.37, ["Mega|Fly|Ride"] = 101.4}},
    ["rbxassetid://13810870050"] = {name = "African Wild Dog", prices = {["default"] = 4329.94, ["Ride"] = 4331.25, ["Fly|Ride"] = 4349.63, ["Neon"] = 27937.41, ["Neon|Fly|Ride"] = 22013.27, ["Mega|Fly|Ride"] = 62866.04}},
    ["rbxassetid://12596400214"] = {name = "Goldfish", prices = {["default"] = 13.63, ["Ride"] = 56.43, ["Neon"] = 107.63, ["Neon|Ride"] = 106.32, ["Mega|Fly|Ride"] = 523.69}},
    ["rbxassetid://4736656915"] = {name = "Australian Kelpie", prices = {["default"] = 2.1, ["Fly"] = 17.71, ["Ride"] = 20.81, ["Fly|Ride"] = 60.38, ["Neon"] = 12.99, ["Neon|Fly"] = 32.82, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 70.35, ["Mega"] = 229.53, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 419.12}},
    ["rbxassetid://3743711305"] = {name = "Crocodile", prices = {["default"] = 433.12, ["Fly"] = 527.63, ["Ride"] = 485.63, ["Fly|Ride"] = 538.13, ["Neon"] = 1365, ["Neon|Ride"] = 1382.9, ["Neon|Fly|Ride"] = 1181.25, ["Mega|Fly|Ride"] = 3674.99}},
    ["rbxassetid://74373220330198"] = {name = "Officer Gibbon", prices = {["default"] = 4.94, ["Ride"] = 28.3, ["Neon"] = 15.73, ["Neon|Ride"] = 145.68, ["Mega"] = 127.34, ["Mega|Fly|Ride"] = 338.46}},
    ["rbxassetid://18508184138"] = {name = "Peregrine Falcon", prices = {["default"] = 7.08, ["Fly"] = 65.63, ["Ride"] = 35.44, ["Neon"] = 19.92, ["Neon|Ride"] = 279.74, ["Neon|Fly|Ride"] = 279.78, ["Mega"] = 415.42, ["Mega|Ride"] = 401.63, ["Mega|Fly|Ride"] = 559.53}},
    ["rbxassetid://92389214029179"] = {name = "Kaijunior", prices = {["default"] = 2.1, ["Fly"] = 52.33, ["Ride"] = 18.38, ["Fly|Ride"] = 82.56, ["Neon"] = 5.96, ["Neon|Fly"] = 124.68, ["Neon|Ride"] = 101.07, ["Neon|Fly|Ride"] = 72.19, ["Mega"] = 38.85, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 181.13}},
    ["rbxassetid://3409443986"] = {name = "Flamingo", prices = {["default"] = 669.37, ["Fly"] = 824.51, ["Ride"] = 636.55, ["Fly|Ride"] = 630, ["Neon"] = 2100, ["Neon|Fly|Ride"] = 1968.75}},
    ["rbxassetid://126933432685319"] = {name = "Cattuccino", prices = {["default"] = 7.71, ["Ride"] = 63.78, ["Fly|Ride"] = 85.32, ["Neon"] = 23.39, ["Neon|Ride"] = 65.62, ["Neon|Fly|Ride"] = 140.34, ["Mega"] = 118.02, ["Mega|Ride"] = 170.43, ["Mega|Fly|Ride"] = 349.97}},
    ["rbxassetid://11631390464"] = {name = "Ermine", prices = {["default"] = 40.69, ["Fly"] = 236.15, ["Ride"] = 123.38, ["Neon"] = 84.95, ["Neon|Fly"] = 140.39, ["Neon|Ride"] = 143.07, ["Neon|Fly|Ride"] = 151.59, ["Mega"] = 252.37, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://4708551221"] = {name = "Emu", prices = {["default"] = 2.1, ["Fly"] = 14.44, ["Ride"] = 23.59, ["Fly|Ride"] = 47.25, ["Neon"] = 11.23, ["Neon|Fly"] = 46.11, ["Neon|Ride"] = 17.7, ["Neon|Fly|Ride"] = 56.59, ["Mega"] = 207.5, ["Mega|Fly"] = 140.42, ["Mega|Fly|Ride"] = 208.69}},
    ["rbxassetid://16088266364"] = {name = "Burning Bunny", prices = {["default"] = 140.39, ["Ride"] = 63.7, ["Neon"] = 103.69, ["Neon|Fly"] = 170.63, ["Neon|Fly|Ride"] = 314.88, ["Mega"] = 518.65, ["Mega|Ride"] = 452.82, ["Mega|Fly|Ride"] = 616.88}},
    ["rbxassetid://80832101513100"] = {name = "2026 Birthday Butterfly", prices = {["default"] = 2.1, ["Neon"] = 3.94, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 208.69, ["Mega"] = 37.43, ["Mega|Ride"] = 87.29, ["Mega|Fly|Ride"] = 250.4}},
    ["rbxassetid://14639007389"] = {name = "Caterpillar", prices = {["default"] = 393.75, ["Ride"] = 433.13, ["Fly|Ride"] = 550.67, ["Neon"] = 2516.25, ["Neon|Ride"] = 2416.92, ["Neon|Fly|Ride"] = 1793.39, ["Mega"] = 8333.84, ["Mega|Fly|Ride"] = 7862.14}},
    ["rbxassetid://82920146813845"] = {name = "Little Lamb", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Fly|Ride"] = 331.07, ["Neon"] = 12.98, ["Neon|Ride"] = 57.18, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 52.5, ["Mega|Ride"] = 160.13, ["Mega|Fly|Ride"] = 398.02}},
    ["rbxassetid://96424154406922"] = {name = "Crimson Cape", prices = {["default"] = 2.1, ["Ride"] = 52.49, ["Neon"] = 5.2, ["Neon|Fly"] = 140.39, ["Neon|Ride"] = 209.86, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 39.38, ["Mega|Fly"] = 98.51, ["Mega|Ride"] = 98.51, ["Mega|Fly|Ride"] = 209.57}},
    ["rbxassetid://109008428989602"] = {name = "Pangolin", prices = {["default"] = 2.1, ["Ride"] = 21.58, ["Neon"] = 3.9, ["Neon|Ride"] = 41.3, ["Neon|Fly|Ride"] = 140.42, ["Mega"] = 53.45, ["Mega|Fly"] = 155.09, ["Mega|Ride"] = 72.19}},
    ["rbxassetid://16722909218"] = {name = "Floral Eggy", prices = {["default"] = 3.82, ["Ride"] = 131.25, ["Neon"] = 18.48, ["Neon|Ride"] = 47.17, ["Mega"] = 105, ["Mega|Ride"] = 328.13}},
    ["rbxassetid://76735046136809"] = {name = "Frostbite Cub", prices = {["default"] = 98.49, ["Ride"] = 140.39, ["Fly|Ride"] = 498.73, ["Neon"] = 392.44, ["Neon|Ride"] = 363.56, ["Neon|Fly|Ride"] = 2358.54, ["Mega"] = 1595.55, ["Mega|Ride"] = 2055.34, ["Mega|Fly|Ride"] = 1299.38}},
    ["rbxassetid://15684947715"] = {name = "Quokka", prices = {["default"] = 26.21, ["Fly"] = 69.47, ["Ride"] = 74.34, ["Fly|Ride"] = 125.73, ["Neon"] = 98.44, ["Neon|Ride"] = 139.36, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 463.31, ["Mega|Ride"] = 385.88, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://5721843001"] = {name = "Deinonychus", prices = {["default"] = 2.1, ["Fly"] = 31.5, ["Ride"] = 16.78, ["Fly|Ride"] = 49.25, ["Neon"] = 27.13, ["Neon|Ride"] = 35.44, ["Neon|Fly|Ride"] = 69.17, ["Mega"] = 155.09, ["Mega|Ride"] = 259.86, ["Mega|Fly|Ride"] = 190.32}},
    ["rbxassetid://16999461770"] = {name = "Inmate Capuchin Monkey", prices = {["default"] = 10.45, ["Ride"] = 64.31, ["Fly|Ride"] = 99.54, ["Neon"] = 279.74, ["Neon|Fly|Ride"] = 235.87, ["Mega"] = 331.1, ["Mega|Ride"] = 224.24, ["Mega|Fly|Ride"] = 559.53}},
    ["rbxassetid://119664699815373"] = {name = "Frozen Penguin", prices = {["default"] = 2.63, ["Fly"] = 179.03, ["Ride"] = 36.68, ["Fly|Ride"] = 83.83, ["Neon"] = 81.38, ["Neon|Ride"] = 188.58, ["Mega"] = 419.12, ["Mega|Ride"] = 504.74, ["Mega|Fly|Ride"] = 279.78}},
    ["rbxassetid://5067924307"] = {name = "Business Monkey", prices = {["default"] = 19.45, ["Fly"] = 69.17, ["Ride"] = 30.16, ["Fly|Ride"] = 56.25, ["Neon"] = 249.36, ["Neon|Ride"] = 209.9, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 941.96, ["Mega|Ride"] = 943.43, ["Mega|Fly|Ride"] = 769.08}},
    ["rbxassetid://126192643157832"] = {name = "Manta Ray", prices = {["default"] = 31.5, ["Fly"] = 874.13, ["Neon"] = 153.3, ["Neon|Ride"] = 550.67, ["Mega|Ride"] = 279.78}},
    ["rbxassetid://4440866911"] = {name = "Silly Duck", prices = {["default"] = 47.25, ["Fly"] = 115.5, ["Ride"] = 87.94, ["Fly|Ride"] = 131.25, ["Neon"] = 267.57, ["Neon|Fly"] = 349.93, ["Neon|Ride"] = 276.93, ["Neon|Fly|Ride"] = 341.25, ["Mega|Ride"] = 1337.3, ["Mega|Fly|Ride"] = 997.5}},
    ["rbxassetid://110544962124445"] = {name = "Cake Friend", prices = {["default"] = 53.8, ["Fly"] = 92.78, ["Ride"] = 115.5, ["Neon"] = 156.15, ["Neon|Ride"] = 223.13, ["Neon|Fly|Ride"] = 266.14, ["Mega"] = 559.53, ["Mega|Ride"] = 670.59, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://16127157068"] = {name = "Rice Cake Rabbit", prices = {["default"] = 27.57, ["Ride"] = 68.25, ["Neon"] = 135.19, ["Mega"] = 628.67, ["Mega|Ride"] = 471.72, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://7734900613"] = {name = "Halloween Evil Dachshund", prices = {["default"] = 5.25, ["Fly"] = 32.45, ["Ride"] = 41.47, ["Fly|Ride"] = 83.9, ["Neon"] = 58.46, ["Neon|Ride"] = 91.85, ["Neon|Fly|Ride"] = 118.65, ["Mega"] = 349.49, ["Mega|Ride"] = 391.88, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://9664282145"] = {name = "Robot", prices = {["default"] = 2.1, ["Fly"] = 17.73, ["Ride"] = 14.39, ["Fly|Ride"] = 41.92, ["Neon"] = 3.94, ["Neon|Fly"] = 25.14, ["Neon|Ride"] = 21.86, ["Neon|Fly|Ride"] = 62.89, ["Mega"] = 63.73, ["Mega|Fly"] = 209.57, ["Mega|Ride"] = 52.49, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://3261465791"] = {name = "Pink Egg", prices = {["default"] = 1458.19}},
    ["rbxassetid://126725051633301"] = {name = "Headless Horse", prices = {["default"] = 18.61, ["Ride"] = 56.44, ["Fly|Ride"] = 140.39, ["Neon"] = 129.94, ["Neon|Fly"] = 249.36, ["Neon|Ride"] = 140.39, ["Neon|Fly|Ride"] = 457.89, ["Mega"] = 489.33, ["Mega|Ride"] = 559.53, ["Mega|Fly|Ride"] = 473.96}},
    ["rbxassetid://88554799028713"] = {name = "Sneak Weasel", prices = {["default"] = 2.1, ["Ride"] = 56.59, ["Neon"] = 3.93, ["Neon|Ride"] = 40.87, ["Neon|Fly|Ride"] = 293.4, ["Mega"] = 46.11, ["Mega|Ride"] = 140.42}},
    ["rbxassetid://14639008203"] = {name = "English Sheepdog", prices = {["default"] = 38.78, ["Fly"] = 110.85, ["Ride"] = 62.98, ["Neon"] = 139.11, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 262.85, ["Mega"] = 711.38, ["Mega|Ride"] = 974.09, ["Mega|Fly|Ride"] = 1046.07}},
    ["rbxassetid://133131190079833"] = {name = "Oakee", prices = {["default"] = 2.1, ["Neon"] = 3.93, ["Neon|Ride"] = 105, ["Mega"] = 32.38}},
    ["rbxassetid://79856043024325"] = {name = "Chestnut Glyptodon", prices = {["default"] = 2.1, ["Neon"] = 6.19, ["Neon|Ride"] = 47.17, ["Mega"] = 25.97, ["Mega|Fly"] = 140.42, ["Mega|Ride"] = 134.46, ["Mega|Fly|Ride"] = 273}},
    ["rbxassetid://12720028898"] = {name = "Hare", prices = {["default"] = 112.87, ["Neon"] = 426.57, ["Neon|Ride"] = 452.82, ["Neon|Fly|Ride"] = 501.73, ["Mega|Ride"] = 6485.95, ["Mega|Fly|Ride"] = 1968.74}},
    ["rbxassetid://16897788024"] = {name = "Capuchin Monkey", prices = {["default"] = 2.1, ["Fly"] = 26.24, ["Ride"] = 26.25, ["Fly|Ride"] = 70.75, ["Neon"] = 10.23, ["Neon|Fly"] = 56.59, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 68.25, ["Mega"] = 90.15, ["Mega|Ride"] = 197.01, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://121639546210522"] = {name = "Amber Butterfly", prices = {["default"] = 2.1, ["Fly"] = 38.07, ["Ride"] = 131.24, ["Fly|Ride"] = 86.63, ["Neon"] = 4.77, ["Neon|Fly"] = 62.87, ["Neon|Ride"] = 34.13, ["Neon|Fly|Ride"] = 98.51, ["Mega"] = 38.06, ["Mega|Ride"] = 116.76, ["Mega|Fly|Ride"] = 164.07}},
    ["rbxassetid://79005166120532"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Neon"] = 3.94, ["Neon|Ride"] = 36.28, ["Mega"] = 22.32, ["Mega|Ride"] = 140.4, ["Mega|Fly|Ride"] = 261.19}},
    ["rbxassetid://138741319376538"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 2.1, ["Neon|Ride"] = 30.8, ["Mega"] = 47.16, ["Mega|Ride"] = 96.48, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://133558151150234"] = {name = "Black Widow", prices = {["default"] = 48.36, ["Ride"] = 111.57, ["Fly|Ride"] = 450.19, ["Neon"] = 276.17, ["Neon|Ride"] = 405.45, ["Neon|Fly|Ride"] = 695.63, ["Mega"] = 1569.57, ["Mega|Ride"] = 1571.67, ["Mega|Fly|Ride"] = 1258.28}},
    ["rbxassetid://122945704087152"] = {name = "Chilling Spider", prices = {["default"] = 3.92, ["Ride"] = 37.29, ["Neon"] = 36.2, ["Neon|Ride"] = 110.85, ["Mega"] = 140.4, ["Mega|Ride"] = 836.73}},
    ["rbxassetid://1373237029"] = {name = "Big Head Potion", prices = {["default"] = 2.05}},
    ["rbxassetid://2657668946"] = {name = "Cure All Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://1373237971"] = {name = "Grow Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4315743582"] = {name = "Honey Badger", prices = {["default"] = 262.5, ["Ride"] = 261.19, ["Fly|Ride"] = 616.88, ["Neon"] = 1786.37, ["Neon|Fly"] = 1195.64, ["Neon|Ride"] = 1424.8, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Ride"] = 3494.32, ["Mega|Fly|Ride"] = 3465}},
    ["rbxassetid://1373208271"] = {name = "Hyperspeed Potion", prices = {["default"] = 1.84}},
    ["rbxassetid://4047157976"] = {name = "Fly Potion", prices = {["default"] = 77.44}},
    ["rbxassetid://3342628435"] = {name = "Ride Potion", prices = {["default"] = 43.31}},
    ["rbxassetid://1509389697"] = {name = "Adopt Me Boy Scooter", prices = {["default"] = 19.93}},
    ["rbxassetid://1509384540"] = {name = "Adopt Me Girl Scooter", prices = {["default"] = 28.31}},
    ["rbxassetid://1256627798"] = {name = "Adopt Me Snowboard 1", prices = {["default"] = 45.25}},
    ["rbxassetid://1256627585"] = {name = "Adopt Me Snowboard 2", prices = {["default"] = 48.25}},
    ["rbxassetid://2782643682"] = {name = "Axel", prices = {["default"] = 14.12}},
    ["rbxassetid://3009779146"] = {name = "Banana Car", prices = {["default"] = 7.27}},
    ["rbxassetid://1306904296"] = {name = "Bathtub", prices = {["default"] = 240.18}},
    ["rbxassetid://1307341557"] = {name = "Bethink Skateboard", prices = {["default"] = 25.44}},
    ["rbxassetid://908269395"] = {name = "Bike", prices = {["default"] = 1.84}},
    ["rbxassetid://1509319125"] = {name = "Black Scooter", prices = {["default"] = 126}},
    ["rbxassetid://1306898658"] = {name = "Black Skateboard", prices = {["default"] = 5.69}},
    ["rbxassetid://1256625297"] = {name = "Black Snowboard", prices = {["default"] = 11.82}},
    ["rbxassetid://1266478264"] = {name = "Blue Neon Snowboard", prices = {["default"] = 217.93}},
    ["rbxassetid://4800244517"] = {name = "Blue Rider", prices = {["default"] = 2.1}},
    ["rbxassetid://1509318734"] = {name = "Blue Scooter", prices = {["default"] = 3.94}},
    ["rbxassetid://1306898360"] = {name = "Blue Skateboard", prices = {["default"] = 10.03}},
    ["rbxassetid://1256625905"] = {name = "Blue Snowboard", prices = {["default"] = 6.34}},
    ["rbxassetid://7165481985"] = {name = "Bubble Car", prices = {["default"] = 6.24}},
    ["rbxassetid://12115176522"] = {name = "Toxic Barrel", prices = {["default"] = 7.88}},
    ["rbxassetid://2657667116"] = {name = "Bunny Carriage", prices = {["default"] = 370.47}},
    ["rbxassetid://6475610034"] = {name = "Butterfly Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264167"] = {name = "Camper Van", prices = {["default"] = 2.1}},
    ["rbxassetid://2758237053"] = {name = "Car", prices = {["default"] = 2.1}},
    ["rbxassetid://14465252948"] = {name = "Super Jetpack", prices = {["default"] = 695.03}},
    ["rbxassetid://4754697599"] = {name = "Choo Choo Train", prices = {["default"] = 9.1}},
    ["rbxassetid://2408035766"] = {name = "Cloud", prices = {["default"] = 1500.19}},
    ["rbxassetid://5057099424"] = {name = "Clown Car", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099515"] = {name = "Clown Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2860616529"] = {name = "Convertible", prices = {["default"] = 559.46}},
    ["rbxassetid://4470750671"] = {name = "Cookie Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8203695278"] = {name = "Snowmobile", prices = {["default"] = 6.34}},
    ["rbxassetid://8243269978"] = {name = "Zamboni", prices = {["default"] = 2.1}},
    ["rbxassetid://1509385561"] = {name = "Cupcake Scooter", prices = {["default"] = 17.07}},
    ["rbxassetid://4822522305"] = {name = "Daisy Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8517689681"] = {name = "Landsailer", prices = {["default"] = 2.1}},
    ["rbxassetid://8566306089"] = {name = "Trireme", prices = {["default"] = 2.1}},
    ["rbxassetid://6504033614"] = {name = "Dino Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://1512774745"] = {name = "Doge Scooter", prices = {["default"] = 14.44}},
    ["rbxassetid://1307341942"] = {name = "Doge Skateboard", prices = {["default"] = 5171.25}},
    ["rbxassetid://3486906742"] = {name = "Dogmobile", prices = {["default"] = 43.31}},
    ["rbxassetid://2880427418"] = {name = "Donut Cycle", prices = {["default"] = 18.35}},
    ["rbxassetid://3486907843"] = {name = "Donut Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2782643731"] = {name = "Douglas", prices = {["default"] = 10.48}},
    ["rbxassetid://1509391407"] = {name = "Duck Scooter", prices = {["default"] = 18.38}},
    ["rbxassetid://9291032374"] = {name = "Egg Delivery Machine", prices = {["default"] = 5.8}},
    ["rbxassetid://1509377123"] = {name = "Emoji Scooter", prices = {["default"] = 19.92}},
    ["rbxassetid://9973767611"] = {name = "Harvest Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://9973768669"] = {name = "Tractor", prices = {["default"] = 4.68}},
    ["rbxassetid://1307341332"] = {name = "Fidget Skateboard", prices = {["default"] = 61.68}},
    ["rbxassetid://4823285384"] = {name = "Flower Wagon", prices = {["default"] = 34.86}},
    ["rbxassetid://7475653998"] = {name = "Fossil Paw Helicopter", prices = {["default"] = 3.91}},
    ["rbxassetid://9406027381"] = {name = "Starter Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://6475609765"] = {name = "Futuristic Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291832"] = {name = "Ghost Vehicle", prices = {["default"] = 1783.69}},
    ["rbxassetid://10905638416"] = {name = "Ancient Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760422"] = {name = "Bat Face Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://10919870588"] = {name = "Dapper Friend Carrier", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760559"] = {name = "Dirt Bike Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10967588257"] = {name = "Hot Tub Muscle Car", prices = {["default"] = 25.65}},
    ["rbxassetid://10905207734"] = {name = "Soapy Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9037078630"] = {name = "Horse And Carriage", prices = {["default"] = 299.24}},
    ["rbxassetid://10913434990"] = {name = "Unstable Triangle Car", prices = {["default"] = 8.11}},
    ["rbxassetid://8979306571"] = {name = "Wizard Caravan", prices = {["default"] = 3.94}},
    ["rbxassetid://1512770654"] = {name = "Glass Scooter", prices = {["default"] = 10.5}},
    ["rbxassetid://1306903971"] = {name = "Glass Skateboard", prices = {["default"] = 7.87}},
    ["rbxassetid://1256627375"] = {name = "Glass Snowboard", prices = {["default"] = 35.44}},
    ["rbxassetid://1064481531"] = {name = "GoKart", prices = {["default"] = 157.48}},
    ["rbxassetid://1509326491"] = {name = "Gold Scooter", prices = {["default"] = 9.19}},
    ["rbxassetid://1306902802"] = {name = "Gold Skateboard", prices = {["default"] = 14.34}},
    ["rbxassetid://12519249137"] = {name = "Bumper Car", prices = {["default"] = 2.63}},
    ["rbxassetid://12519249424"] = {name = "Circus Ball Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265134428"] = {name = "Green Neon Snowboard", prices = {["default"] = 10124.63}},
    ["rbxassetid://7839195952"] = {name = "Halloween Black Ponycycle", prices = {["default"] = 16.69}},
    ["rbxassetid://11119263404"] = {name = "Headless Horseman's Biplane", prices = {["default"] = 3.84}},
    ["rbxassetid://10920073281"] = {name = "Throwing Knife Target", prices = {["default"] = 2.1}},
    ["rbxassetid://10920073157"] = {name = "Shadow Rider", prices = {["default"] = 21}},
    ["rbxassetid://11125166616"] = {name = "Unicorn Zombie Ponycycle", prices = {["default"] = 7.63}},
    ["rbxassetid://2848331544"] = {name = "Heart Hoverboard", prices = {["default"] = 3.93}},
    ["rbxassetid://2657670919"] = {name = "Horse Cycle", prices = {["default"] = 157.17}},
    ["rbxassetid://3163531592"] = {name = "Traveling House", prices = {["default"] = 22.32}},
    ["rbxassetid://4382798606"] = {name = "Hoverboard", prices = {["default"] = 7.88}},
    ["rbxassetid://6475613264"] = {name = "Hovercar", prices = {["default"] = 2.1}},
    ["rbxassetid://4797807001"] = {name = "Human Bubble", prices = {["default"] = 2.1}},
    ["rbxassetid://4588192578"] = {name = "Ice Cream Truck", prices = {["default"] = 15.74}},
    ["rbxassetid://4470749585"] = {name = "Ice Queen Sleigh", prices = {["default"] = 2.1}},
    ["rbxassetid://1509333762"] = {name = "Ice Scooter", prices = {["default"] = 11.34}},
    ["rbxassetid://1265129203"] = {name = "Ice Snowboard", prices = {["default"] = 315.79}},
    ["rbxassetid://6504033516"] = {name = "Imagination Box", prices = {["default"] = 5.19}},
    ["rbxassetid://10619155042"] = {name = "Street Racer", prices = {["default"] = 39.38}},
    ["rbxassetid://2749267159"] = {name = "Limo", prices = {["default"] = 2.1}},
    ["rbxassetid://8665606953"] = {name = "Dragon Train", prices = {["default"] = 136.52}},
    ["rbxassetid://11758583286"] = {name = "Crescent Moon Car", prices = {["default"] = 183.75}},
    ["rbxassetid://6276452323"] = {name = "Lunar Muscle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://7165482478"] = {name = "Magical Girl Car", prices = {["default"] = 15.73}},
    ["rbxassetid://7368045552"] = {name = "Magical Princess Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1306902978"] = {name = "Melon Skateboard", prices = {["default"] = 32.8}},
    ["rbxassetid://3009779540"] = {name = "Monocycle", prices = {["default"] = 21}},
    ["rbxassetid://1512742703"] = {name = "Mono-Moped", prices = {["default"] = 54.83}},
    ["rbxassetid://2758236960"] = {name = "Moped", prices = {["default"] = 102.36}},
    ["rbxassetid://2758237011"] = {name = "Motorcycle", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264226"] = {name = "Muscle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://1509342852"] = {name = "Neon Black Scooter", prices = {["default"] = 22459.82}},
    ["rbxassetid://1306911569"] = {name = "Neon Black Skateboard", prices = {["default"] = 208.68}},
    ["rbxassetid://1509338320"] = {name = "Neon Blue Scooter", prices = {["default"] = 31.5}},
    ["rbxassetid://1306907175"] = {name = "Neon Blue Skateboard", prices = {["default"] = 61.69}},
    ["rbxassetid://1509342200"] = {name = "Neon Green Scooter", prices = {["default"] = 35.44}},
    ["rbxassetid://1306907671"] = {name = "Neon Green Skateboard", prices = {["default"] = 86.63}},
    ["rbxassetid://1509338451"] = {name = "Neon Orange Scooter", prices = {["default"] = 63}},
    ["rbxassetid://1306907450"] = {name = "Neon Orange Skateboard", prices = {["default"] = 99.75}},
    ["rbxassetid://1509339156"] = {name = "Neon Pink Scooter", prices = {["default"] = 76.13}},
    ["rbxassetid://1306911771"] = {name = "Neon Pink Skateboard", prices = {["default"] = 86.99}},
    ["rbxassetid://1509341495"] = {name = "Neon Red Scooter", prices = {["default"] = 32.81}},
    ["rbxassetid://1256625563"] = {name = "Orange Neon Snowboard", prices = {["default"] = 41.95}},
    ["rbxassetid://1509340494"] = {name = "Neon White Scooter", prices = {["default"] = 65.57}},
    ["rbxassetid://1309919907"] = {name = "Neon White Skateboard", prices = {["default"] = 81.22}},
    ["rbxassetid://2860616613"] = {name = "Offroader", prices = {["default"] = 2.1}},
    ["rbxassetid://1265130049"] = {name = "Pink Neon Snowboard", prices = {["default"] = 10895.47}},
    ["rbxassetid://1509329807"] = {name = "Pink Scooter", prices = {["default"] = 9.18}},
    ["rbxassetid://1306898507"] = {name = "Pink Skateboard", prices = {["default"] = 8.88}},
    ["rbxassetid://4361545125"] = {name = "Pizza Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://7368040075"] = {name = "Plant Powered Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9837424665"] = {name = "Rainbow Trail Magic Carpet", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601262"] = {name = "Prince Carriage", prices = {["default"] = 24.43}},
    ["rbxassetid://2854601314"] = {name = "Princess Carriage", prices = {["default"] = 19.69}},
    ["rbxassetid://4115248893"] = {name = "Pumpkin Carriage", prices = {["default"] = 52.74}},
    ["rbxassetid://7475654312"] = {name = "Racing Monoplane", prices = {["default"] = 3.89}},
    ["rbxassetid://10967874847"] = {name = "Galleon", prices = {["default"] = 3.25}},
    ["rbxassetid://10967808228"] = {name = "Old Sail Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992442"] = {name = "RGB Monster Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992324"] = {name = "RGB UFO", prices = {["default"] = 2.58}},
    ["rbxassetid://5882026006"] = {name = "Ribcage Carriage", prices = {["default"] = 7.92}},
    ["rbxassetid://1265128894"] = {name = "Roblox Snowboard", prices = {["default"] = 267.75}},
    ["rbxassetid://4797807111"] = {name = "Rocket Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://7368052482"] = {name = "Rocket Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://1257419042"] = {name = "Rocket Sled", prices = {["default"] = 1101.31}},
    ["rbxassetid://4564588042"] = {name = "Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601162"] = {name = "Royal Carriage", prices = {["default"] = 6.01}},
    ["rbxassetid://13741294258"] = {name = "Giant Cheetah Mount", prices = {["default"] = 577.5}},
    ["rbxassetid://4470749525"] = {name = "Santa's Sleigh", prices = {["default"] = 31.19}},
    ["rbxassetid://4470749209"] = {name = "Sled", prices = {["default"] = 2.1}},
    ["rbxassetid://9342853829"] = {name = "Snow Plow", prices = {["default"] = 2.1}},
    ["rbxassetid://9343367876"] = {name = "Tundra Exploration Machine", prices = {["default"] = 2.1}},
    ["rbxassetid://7165482648"] = {name = "Speedboat", prices = {["default"] = 2.1}},
    ["rbxassetid://12719600101"] = {name = "Daisymobile", prices = {["default"] = 48.55}},
    ["rbxassetid://12792507038"] = {name = "Flower Truck", prices = {["default"] = 78.75}},
    ["rbxassetid://12996592162"] = {name = "Lavender Teapot Carriage", prices = {["default"] = 28.88}},
    ["rbxassetid://12917527253"] = {name = "Rabbit Helicopter", prices = {["default"] = 50.26}},
    ["rbxassetid://12996592079"] = {name = "Rose Petal Carriage", prices = {["default"] = 57.25}},
    ["rbxassetid://12996592010"] = {name = "Royal Crown Carriage", prices = {["default"] = 20.06}},
    ["rbxassetid://6504033423"] = {name = "Squirrel Car", prices = {["default"] = 3.9}},
    ["rbxassetid://6798176757"] = {name = "Standard Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://6797010981"] = {name = "Standard Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10224002323"] = {name = "Emperor's Chariot", prices = {["default"] = 15.74}},
    ["rbxassetid://10202931873"] = {name = "Orchid Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://10202932215"] = {name = "Hovercraft", prices = {["default"] = 2.1}},
    ["rbxassetid://10224209770"] = {name = "Planetary Core Car", prices = {["default"] = 2.1}},
    ["rbxassetid://10203332627"] = {name = "Medieval Wagon", prices = {["default"] = 3.77}},
    ["rbxassetid://13607580379"] = {name = "Beach Buggy", prices = {["default"] = 4.57}},
    ["rbxassetid://13683681091"] = {name = "Beachgoer", prices = {["default"] = 10.05}},
    ["rbxassetid://13683679951"] = {name = "Crabby Cruiser", prices = {["default"] = 21}},
    ["rbxassetid://3579315827"] = {name = "Surfboard", prices = {["default"] = 2.1}},
    ["rbxassetid://3186425945"] = {name = "SUV", prices = {["default"] = 5.13}},
    ["rbxassetid://1614139188"] = {name = "Multi-Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8727492188"] = {name = "Black Cab", prices = {["default"] = 2.1}},
    ["rbxassetid://8727477150"] = {name = "Yellow Taxi Cab", prices = {["default"] = 8.39}},
    ["rbxassetid://2783002443"] = {name = "Tiffany", prices = {["default"] = 18.38}},
    ["rbxassetid://3206264796"] = {name = "Tiny Convertible", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671636"] = {name = "Unicorn Cycle", prices = {["default"] = 169.32}},
    ["rbxassetid://3142180107"] = {name = "Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231299"] = {name = "Bicycle", prices = {["default"] = 1.84}},
    ["rbxassetid://9108506670"] = {name = "Family Car", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231666"] = {name = "Classic Helicopter", prices = {["default"] = 2.1}},
    ["rbxassetid://8860682054"] = {name = "Classic Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231811"] = {name = "Motorbike", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506795"] = {name = "Off-Road Car", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506884"] = {name = "Open Top Speeder", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231943"] = {name = "Classic Airplane", prices = {["default"] = 2.1}},
    ["rbxassetid://9108507006"] = {name = "Sports Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8859232022"] = {name = "Tandem Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265135075"] = {name = "White Neon Snowboard", prices = {["default"] = 1046.61}},
    ["rbxassetid://1509328859"] = {name = "White Scooter", prices = {["default"] = 7.39}},
    ["rbxassetid://1306898856"] = {name = "White Skateboard", prices = {["default"] = 7.88}},
    ["rbxassetid://1256624956"] = {name = "White Snowboard", prices = {["default"] = 4.86}},
    ["rbxassetid://7165482807"] = {name = "Wing Trunk Car", prices = {["default"] = 18.24}},
    ["rbxassetid://8080952782"] = {name = "Festive Deliveries Present Truck", prices = {["default"] = 88.72}},
    ["rbxassetid://8190703270"] = {name = "Festive Deliveries Sleigh", prices = {["default"] = 12.59}},
    ["rbxassetid://7975097837"] = {name = "Festive Ice Skates", prices = {["default"] = 2.63}},
    ["rbxassetid://8190703329"] = {name = "Toy Rescue Helicopter", prices = {["default"] = 10.13}},
    ["rbxassetid://11697121962"] = {name = "Candy Snowmobile", prices = {["default"] = 14.68}},
    ["rbxassetid://11574949668"] = {name = "Giant Snowball", prices = {["default"] = 35.44}},
    ["rbxassetid://11764928443"] = {name = "Gingerbread Sleigh", prices = {["default"] = 87.9}},
    ["rbxassetid://11706055135"] = {name = "Husky Sled", prices = {["default"] = 34.13}},
    ["rbxassetid://11466900358"] = {name = "Icebreaker Ship", prices = {["default"] = 2.1}},
    ["rbxassetid://11768005537"] = {name = "Ice Plane", prices = {["default"] = 3.52}},
    ["rbxassetid://11706157454"] = {name = "Snowblower Toboggan", prices = {["default"] = 7.88}},
    ["rbxassetid://11582939967"] = {name = "Strawberry Shortcake Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://11582928541"] = {name = "Strawberry Shortcake Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://4797807321"] = {name = "Witch's Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1509321524"] = {name = "Wood Scooter", prices = {["default"] = 41.92}},
    ["rbxassetid://1306899055"] = {name = "Wood Skateboard", prices = {["default"] = 70.67}},
    ["rbxassetid://4361544852"] = {name = "Airplane Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4797806115"] = {name = "Angelic Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671618"] = {name = "Anna Rattle", prices = {["default"] = 4.92}},
    ["rbxassetid://4712355837"] = {name = "Astro Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4115251996"] = {name = "Axe Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2657667102"] = {name = "Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779116"] = {name = "Balloons", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779170"] = {name = "Banana Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779233"] = {name = "Banana Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248143"] = {name = "Banjo", prices = {["default"] = 7.84}},
    ["rbxassetid://4470749845"] = {name = "Bauble Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468615"] = {name = "Briefcase Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907018"] = {name = "Bubblegum Machine Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046064"] = {name = "Bunny Plush", prices = {["default"] = 2.37}},
    ["rbxassetid://4470749083"] = {name = "Candle", prices = {["default"] = 2.1}},
    ["rbxassetid://6710107927"] = {name = "Candy Cannon", prices = {["default"] = 5730.24}},
    ["rbxassetid://3082046250"] = {name = "Carrot Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408035756"] = {name = "Cat Plush", prices = {["default"] = 31.5}},
    ["rbxassetid://3009779289"] = {name = "Caticorn Rattle", prices = {["default"] = 3.46}},
    ["rbxassetid://3082046215"] = {name = "Chocolate Bunny Balloon", prices = {["default"] = 4.73}},
    ["rbxassetid://1257271764"] = {name = "Christmas Cat Rattle", prices = {["default"] = 4.79}},
    ["rbxassetid://1257273388"] = {name = "Christmas Doge Rattle", prices = {["default"] = 18.38}},
    ["rbxassetid://4470749153"] = {name = "Cookie Dough Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://10979219546"] = {name = "Cotton Candy Stand", prices = {["default"] = 9.08}},
    ["rbxassetid://4115248463"] = {name = "Creepy Balloon", prices = {["default"] = 4.91}},
    ["rbxassetid://2408035767"] = {name = "Croc Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248599"] = {name = "Crossbow Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468734"] = {name = "Cymbal Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://4822522594"] = {name = "Dandelion Propeller", prices = {["default"] = 15.63}},
    ["rbxassetid://4797806584"] = {name = "Didgeridoo", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779323"] = {name = "Donut Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3454109877"] = {name = "Donut Throw Toy", prices = {["default"] = 118.13}},
    ["rbxassetid://3486907555"] = {name = "Dragon Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779349"] = {name = "Duck Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046102"] = {name = "Easter Bunny Plush", prices = {["default"] = 33.88}},
    ["rbxassetid://1555803323"] = {name = "Egg Rattle", prices = {["default"] = 2.43}},
    ["rbxassetid://2408051109"] = {name = "Elephant Plush", prices = {["default"] = 4.87}},
    ["rbxassetid://4470750254"] = {name = "Elf Plush", prices = {["default"] = 18.59}},
    ["rbxassetid://2657668953"] = {name = "Elf Rattle", prices = {["default"] = 7.86}},
    ["rbxassetid://5882028408"] = {name = "Eyeball Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408035763"] = {name = "Fancy Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052395"] = {name = "Fancy Umbrella", prices = {["default"] = 3.68}},
    ["rbxassetid://3009779377"] = {name = "Flower Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291815"] = {name = "Flying Broomstick", prices = {["default"] = 2612.82}},
    ["rbxassetid://3454109803"] = {name = "Football Throw Toy", prices = {["default"] = 6.19}},
    ["rbxassetid://7368042855"] = {name = "Galaxy Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749638"] = {name = "Gift Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://1310513344"] = {name = "Glider", prices = {["default"] = 42}},
    ["rbxassetid://6936627177"] = {name = "Golden Maned Unicorn Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3142180004"] = {name = "Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907282"] = {name = "Griffin Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://1419098937"] = {name = "Heart Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://1419099271"] = {name = "Heart Plushie", prices = {["default"] = 7.47}},
    ["rbxassetid://2848331436"] = {name = "Heart Rattle", prices = {["default"] = 81.37}},
    ["rbxassetid://2657670910"] = {name = "Horse Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://3818347838"] = {name = "Hotdog Stand", prices = {["default"] = 4.8}},
    ["rbxassetid://1555807694"] = {name = "Hugging Egg", prices = {["default"] = 92.3}},
    ["rbxassetid://4470749277"] = {name = "Ice Club Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779419"] = {name = "Ice Cream Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4361546643"] = {name = "Ice Cream Rattle", prices = {["default"] = 2.05}},
    ["rbxassetid://4470749342"] = {name = "Ice Pick Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052390"] = {name = "Inflatable Sword", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051119"] = {name = "Jackhammer", prices = {["default"] = 2.1}},
    ["rbxassetid://3486908136"] = {name = "Kangaroo Pogo", prices = {["default"] = 5.25}},
    ["rbxassetid://4822522509"] = {name = "Lavender Bundle", prices = {["default"] = 2.1}},
    ["rbxassetid://3523677453"] = {name = "Lemonade Stand", prices = {["default"] = 3.29}},
    ["rbxassetid://6475613071"] = {name = "Lime Slice Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051107"] = {name = "Llama Plush", prices = {["default"] = 11.82}},
    ["rbxassetid://4661940658"] = {name = "Magic House Door", prices = {["default"] = 28.02}},
    ["rbxassetid://3009779472"] = {name = "Marsh Balloon", prices = {["default"] = 2.63}},
    ["rbxassetid://3009779496"] = {name = "Marsh Plush", prices = {["default"] = 3.56}},
    ["rbxassetid://5057099190"] = {name = "Monkey Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099046"] = {name = "Monkey Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670913"] = {name = "Noob Balloon", prices = {["default"] = 3.94}},
    ["rbxassetid://3009779607"] = {name = "Octopus Plush", prices = {["default"] = 2.62}},
    ["rbxassetid://4470749788"] = {name = "Ornament Throw Toy", prices = {["default"] = 2.63}},
    ["rbxassetid://2657670921"] = {name = "Phoenix Plush", prices = {["default"] = 13.13}},
    ["rbxassetid://7368034465"] = {name = "Pink Cat Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544972"] = {name = "Plunger Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051114"] = {name = "Puppy Plush", prices = {["default"] = 10.48}},
    ["rbxassetid://3082046011"] = {name = "Rabbit Rattle", prices = {["default"] = 2.36}},
    ["rbxassetid://2408055079"] = {name = "Rainbow Wand", prices = {["default"] = 7.86}},
    ["rbxassetid://4470749750"] = {name = "Reindeer Leash", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779583"] = {name = "Rocket Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749474"] = {name = "Santa Leash", prices = {["default"] = 2.59}},
    ["rbxassetid://4470750189"] = {name = "Santa Rattle", prices = {["default"] = 6.56}},
    ["rbxassetid://5061468835"] = {name = "Scroll Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://6475612857"] = {name = "Shuttle Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5882028350"] = {name = "Skull Drum", prices = {["default"] = 5.23}},
    ["rbxassetid://4470749413"] = {name = "Sleigh Bells Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://6059308940"] = {name = "Snowball Launcher", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671626"] = {name = "Snowman Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749691"] = {name = "Snowman Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750120"] = {name = "Sock Chew Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052387"] = {name = "Squid Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468930"] = {name = "Staff Ingredient", prices = {["default"] = 17.07}},
    ["rbxassetid://6768659222"] = {name = "Standard Grappling Hook", prices = {["default"] = 2.63}},
    ["rbxassetid://2408055085"] = {name = "Starpower Wand", prices = {["default"] = 586.7}},
    ["rbxassetid://3009779638"] = {name = "Telescope Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4710374217"] = {name = "Tennis Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4464390422"] = {name = "Turkey Plush", prices = {["default"] = 2.63}},
    ["rbxassetid://3977264097"] = {name = "Unicorn Leash", prices = {["default"] = 10.31}},
    ["rbxassetid://3570154347"] = {name = "Unicorn Plush", prices = {["default"] = 101.07}},
    ["rbxassetid://2408055086"] = {name = "Wooden Pogo", prices = {["default"] = 3.46}},
    ["rbxassetid://4155284126"] = {name = "Zombie Buffalo Plush", prices = {["default"] = 94.61}},
    ["rbxassetid://4880426741"] = {name = "Adventurer's Hood", prices = {["default"] = 3.57}},
    ["rbxassetid://4880426585"] = {name = "Adventurer's Sword", prices = {["default"] = 24.92}},
    ["rbxassetid://5726048254"] = {name = "Amber Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973461"] = {name = "Angel Wings", prices = {["default"] = 984.38}},
    ["rbxassetid://6380734633"] = {name = "Antenna", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972567"] = {name = "Aviators", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973554"] = {name = "Bat Wings", prices = {["default"] = 7.8}},
    ["rbxassetid://6380843886"] = {name = "Bee Hive", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734557"] = {name = "Bee Wings", prices = {["default"] = 4.7}},
    ["rbxassetid://4849973352"] = {name = "Beret", prices = {["default"] = 2.1}},
    ["rbxassetid://5881347869"] = {name = "Bewitched Hat", prices = {["default"] = 3.94}},
    ["rbxassetid://5415514537"] = {name = "Black 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415514707"] = {name = "Black Boots", prices = {["default"] = 27.44}},
    ["rbxassetid://5415514845"] = {name = "Black Cozy Hood", prices = {["default"] = 3.94}},
    ["rbxassetid://5415515017"] = {name = "Black Designer Backpack", prices = {["default"] = 22.35}},
    ["rbxassetid://4849975075"] = {name = "Black Fedora", prices = {["default"] = 2.1}},
    ["rbxassetid://5415515284"] = {name = "Black Hightops", prices = {["default"] = 14.16}},
    ["rbxassetid://5415515507"] = {name = "Black Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426690"] = {name = "Black Scarf", prices = {["default"] = 11.81}},
    ["rbxassetid://5415515653"] = {name = "Black Sneakers", prices = {["default"] = 7.88}},
    ["rbxassetid://5444594385"] = {name = "Blue Butterfly Wings", prices = {["default"] = 23.39}},
    ["rbxassetid://4849980085"] = {name = "Blue Cat Ear Headphones", prices = {["default"] = 22.62}},
    ["rbxassetid://5415515800"] = {name = "Blue Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048365"] = {name = "Bone Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426624"] = {name = "Briefcase", prices = {["default"] = 2.1}},
    ["rbxassetid://6706595341"] = {name = "Bunny Ear Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975457"] = {name = "Buttoned Ushanka", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978837"] = {name = "Buzz Off! Skateboard", prices = {["default"] = 3.72}},
    ["rbxassetid://5415516304"] = {name = "Cassette", prices = {["default"] = 3.94}},
    ["rbxassetid://4849975557"] = {name = "Chef Hat", prices = {["default"] = 10.5}},
    ["rbxassetid://6380734302"] = {name = "Cherry Earrings", prices = {["default"] = 14.26}},
    ["rbxassetid://6706591422"] = {name = "Chick Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://6706592723"] = {name = "Chick Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975633"] = {name = "Chicken Hat", prices = {["default"] = 33.38}},
    ["rbxassetid://4849972658"] = {name = "Clout Goggles", prices = {["default"] = 3.47}},
    ["rbxassetid://4849975702"] = {name = "Conductor Hat", prices = {["default"] = 73.25}},
    ["rbxassetid://4936545219"] = {name = "Cutlass", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972740"] = {name = "Cyborg Shades", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037745"] = {name = "Daisy Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7601648534"] = {name = "Eco Blue Reusable Bottle Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542826699"] = {name = "Eco Blue Solar Panel Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810947"] = {name = "Eco Brown Branch Headphones", prices = {["default"] = 10.5}},
    ["rbxassetid://7542815049"] = {name = "Eco Brown Hiking Backpack", prices = {["default"] = 70.2}},
    ["rbxassetid://7542816175"] = {name = "Eco Green Leaf Afro", prices = {["default"] = 2.63}},
    ["rbxassetid://7542816369"] = {name = "Eco Green Leaf Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810810"] = {name = "Eco Orange Leaf Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542820583"] = {name = "Eco Orange Maple Cape", prices = {["default"] = 11.54}},
    ["rbxassetid://7542810709"] = {name = "Eco Orange Maple Earrings", prices = {["default"] = 3.13}},
    ["rbxassetid://7542817978"] = {name = "Eco Orange Maple Leaf Scarf", prices = {["default"] = 2.19}},
    ["rbxassetid://7542823324"] = {name = "Eco Orange Pumpkin Eyepatch", prices = {["default"] = 5.14}},
    ["rbxassetid://7542813412"] = {name = "Eco Red Cranberry Branch Wings", prices = {["default"] = 25.74}},
    ["rbxassetid://7542821672"] = {name = "Eco Red Mushroom Hood", prices = {["default"] = 3.94}},
    ["rbxassetid://6706593596"] = {name = "Egg Barrette", prices = {["default"] = 2.1}},
    ["rbxassetid://6706594347"] = {name = "Egg Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4850383048"] = {name = "Elf Hat", prices = {["default"] = 231}},
    ["rbxassetid://4849976006"] = {name = "Explorer Hat", prices = {["default"] = 3.13}},
    ["rbxassetid://4933495463"] = {name = "Eyepatch", prices = {["default"] = 16.68}},
    ["rbxassetid://6060998776"] = {name = "Festive Tree Hat", prices = {["default"] = 7.64}},
    ["rbxassetid://4853278462"] = {name = "Firey Aura", prices = {["default"] = 3.93}},
    ["rbxassetid://4849979365"] = {name = "First Aid Bag", prices = {["default"] = 2.6}},
    ["rbxassetid://4849976218"] = {name = "Flamenco Hat", prices = {["default"] = 13.11}},
    ["rbxassetid://6437127230"] = {name = "Flower Collar", prices = {["default"] = 11.54}},
    ["rbxassetid://6380734218"] = {name = "Flower Crown", prices = {["default"] = 6.24}},
    ["rbxassetid://5415517076"] = {name = "Flowery Hair Bow", prices = {["default"] = 3.45}},
    ["rbxassetid://5726048455"] = {name = "Forgotten Flower", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734014"] = {name = "Froggy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://6060998635"] = {name = "Fur Boots", prices = {["default"] = 13.13}},
    ["rbxassetid://5415517473"] = {name = "Gold Chain", prices = {["default"] = 82.79}},
    ["rbxassetid://5415517604"] = {name = "Gold Circle Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://5415517745"] = {name = "Gold Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979471"] = {name = "Golden Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730894"] = {name = "Goth Shoes", prices = {["default"] = 105}},
    ["rbxassetid://4849976420"] = {name = "Green Lotus", prices = {["default"] = 5.16}},
    ["rbxassetid://7368039312"] = {name = "Growing Flower Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4489907389"] = {name = "Halo", prices = {["default"] = 1127.44}},
    ["rbxassetid://5444594659"] = {name = "Handheld", prices = {["default"] = 166.59}},
    ["rbxassetid://4849976512"] = {name = "Head Chef", prices = {["default"] = 190.32}},
    ["rbxassetid://5067924536"] = {name = "Head Tie", prices = {["default"] = 17.39}},
    ["rbxassetid://6404037642"] = {name = "Headband", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979572"] = {name = "Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521592"] = {name = "Hoop Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991420"] = {name = "Ice Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991330"] = {name = "Ice Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991245"] = {name = "Ice Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973617"] = {name = "Jade Moth Wings", prices = {["default"] = 18.71}},
    ["rbxassetid://4849979214"] = {name = "Jeff's Nametag", prices = {["default"] = 52.41}},
    ["rbxassetid://5415517859"] = {name = "Jetpack", prices = {["default"] = 2.63}},
    ["rbxassetid://5067924626"] = {name = "Kitsune Mask", prices = {["default"] = 6.21}},
    ["rbxassetid://4849973992"] = {name = "Lavender Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730364"] = {name = "Leaf Wings", prices = {["default"] = 7.85}},
    ["rbxassetid://6380730271"] = {name = "Leprechaun Hat", prices = {["default"] = 2.63}},
    ["rbxassetid://4853278902"] = {name = "Luggage", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924890"] = {name = "Monkey King Crown", prices = {["default"] = 138.3}},
    ["rbxassetid://4849977086"] = {name = "Monocle", prices = {["default"] = 8.39}},
    ["rbxassetid://4849979887"] = {name = "Moon Tome", prices = {["default"] = 3.21}},
    ["rbxassetid://4849976759"] = {name = "Morion", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048545"] = {name = "Nautilus Shell Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976912"] = {name = "Ninja Headband", prices = {["default"] = 2.63}},
    ["rbxassetid://6404037449"] = {name = "Orange Backpack", prices = {["default"] = 6.3}},
    ["rbxassetid://6380727237"] = {name = "Orange Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977244"] = {name = "Party Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://5415523249"] = {name = "Pearl Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727177"] = {name = "Picnic Basket", prices = {["default"] = 3.88}},
    ["rbxassetid://5415518324"] = {name = "Pink 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518474"] = {name = "Pink Boots", prices = {["default"] = 11.81}},
    ["rbxassetid://5444594884"] = {name = "Pink Butterfly Wings", prices = {["default"] = 3.06}},
    ["rbxassetid://4849979637"] = {name = "Pink Cat Ear Headphones", prices = {["default"] = 53.27}},
    ["rbxassetid://5415518613"] = {name = "Pink Designer Backpack", prices = {["default"] = 2.97}},
    ["rbxassetid://4849972826"] = {name = "Pink Heart Glasses", prices = {["default"] = 58.48}},
    ["rbxassetid://5457768184"] = {name = "Pink Hightops", prices = {["default"] = 2.46}},
    ["rbxassetid://5415518811"] = {name = "Pink Instant Camera", prices = {["default"] = 2.98}},
    ["rbxassetid://4849977427"] = {name = "Pink Lotus", prices = {["default"] = 2.1}},
    ["rbxassetid://5415520296"] = {name = "Pink Sneakers", prices = {["default"] = 8.32}},
    ["rbxassetid://4849977514"] = {name = "Pirate Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://5444711861"] = {name = "Platinum Tiara", prices = {["default"] = 30}},
    ["rbxassetid://4849977607"] = {name = "Propeller Hat", prices = {["default"] = 90.95}},
    ["rbxassetid://4849972928"] = {name = "Purple Heart Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727007"] = {name = "Purple Masquerade Mask", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977695"] = {name = "Purple Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037362"] = {name = "Rain Boots", prices = {["default"] = 65.63}},
    ["rbxassetid://5415520831"] = {name = "Rain Hat", prices = {["default"] = 3.93}},
    ["rbxassetid://7498079214"] = {name = "RB Battles Trophy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977830"] = {name = "Red Beanie", prices = {["default"] = 2.1}},
    ["rbxassetid://6380847814"] = {name = "Red Masquerade Mask", prices = {["default"] = 2.1}},
    ["rbxassetid://5415520972"] = {name = "Red Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521183"] = {name = "Red Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495361"] = {name = "Respectful Mustache", prices = {["default"] = 98.42}},
    ["rbxassetid://8151013513"] = {name = "RGB Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978102"] = {name = "Rose", prices = {["default"] = 2.63}},
    ["rbxassetid://4933495425"] = {name = "Ruff", prices = {["default"] = 67.47}},
    ["rbxassetid://4849978200"] = {name = "Sailor Cap", prices = {["default"] = 175.11}},
    ["rbxassetid://4850382817"] = {name = "Santa Hat", prices = {["default"] = 362.21}},
    ["rbxassetid://5881348094"] = {name = "Scythe", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278537"] = {name = "Shadow Aura", prices = {["default"] = 104.68}},
    ["rbxassetid://4849980009"] = {name = "Shadow Shuriken", prices = {["default"] = 2.63}},
    ["rbxassetid://4849973681"] = {name = "Shadow Wings", prices = {["default"] = 125.73}},
    ["rbxassetid://4849972466"] = {name = "Shark Fin", prices = {["default"] = 3.81}},
    ["rbxassetid://4849973100"] = {name = "Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521379"] = {name = "Silver Chain", prices = {["default"] = 2.56}},
    ["rbxassetid://4849974099"] = {name = "Skeleton Shell", prices = {["default"] = 2.1}},
    ["rbxassetid://4849974434"] = {name = "Spike Collar", prices = {["default"] = 22.32}},
    ["rbxassetid://6380723429"] = {name = "Strawberry Hat", prices = {["default"] = 39.77}},
    ["rbxassetid://4849975162"] = {name = "Sun Tome", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976090"] = {name = "Sushi Skateboard", prices = {["default"] = 41.1}},
    ["rbxassetid://4849976985"] = {name = "Turtle Shell", prices = {["default"] = 3.15}},
    ["rbxassetid://4849978035"] = {name = "Watermelon Backpack", prices = {["default"] = 10.77}},
    ["rbxassetid://5415522308"] = {name = "White Designer Backpack", prices = {["default"] = 10.06}},
    ["rbxassetid://5415522533"] = {name = "White Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979019"] = {name = "Windup Key", prices = {["default"] = 27.57}},
    ["rbxassetid://4849977314"] = {name = "Witch Hat", prices = {["default"] = 14.84}},
    ["rbxassetid://4849978608"] = {name = "Wizard Hat", prices = {["default"] = 9.47}},
    ["rbxassetid://5415522859"] = {name = "Yellow Designer Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5415522973"] = {name = "Yellow Instant Camera", prices = {["default"] = 2.63}},
    ["rbxassetid://5415523115"] = {name = "Yellow Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277758"] = {name = "Airplane Stroller", prices = {["default"] = 78.75}},
    ["rbxassetid://2657667120"] = {name = "Baby Basket Stroller", prices = {["default"] = 47.57}},
    ["rbxassetid://2761277454"] = {name = "Balloon Stroller", prices = {["default"] = 3.93}},
    ["rbxassetid://3009779202"] = {name = "Banana Stroller", prices = {["default"] = 6.57}},
    ["rbxassetid://3082046286"] = {name = "Bunny Stroller", prices = {["default"] = 37.91}},
    ["rbxassetid://3009779260"] = {name = "Cannon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3269748269"] = {name = "Car Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6475616233"] = {name = "Catapult Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248341"] = {name = "Cauldron Stroller", prices = {["default"] = 6.57}},
    ["rbxassetid://2408051111"] = {name = "Cradle Stroller", prices = {["default"] = 59.15}},
    ["rbxassetid://4361544460"] = {name = "Crate Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3486905775"] = {name = "Dog House Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1408016951"] = {name = "Double Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1406692267"] = {name = "Droplet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277656"] = {name = "Duck Stroller", prices = {["default"] = 34.54}},
    ["rbxassetid://3082046174"] = {name = "Easter Egg Stroller", prices = {["default"] = 18.38}},
    ["rbxassetid://2761277703"] = {name = "Egg Stroller", prices = {["default"] = 1227.19}},
    ["rbxassetid://4822522123"] = {name = "Flower Stroller", prices = {["default"] = 5.79}},
    ["rbxassetid://3009779395"] = {name = "French Fries Stroller", prices = {["default"] = 6.69}},
    ["rbxassetid://3082046130"] = {name = "Half Egg Stroller", prices = {["default"] = 35.44}},
    ["rbxassetid://3486906113"] = {name = "Hatched Egg Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2848462165"] = {name = "Heart Stroller", prices = {["default"] = 324.19}},
    ["rbxassetid://6475613319"] = {name = "High Heel Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6967530077"] = {name = "Hover Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670917"] = {name = "Ice Cream Stroller", prices = {["default"] = 15.39}},
    ["rbxassetid://3486906383"] = {name = "Kangaroo Stroller", prices = {["default"] = 7.88}},
    ["rbxassetid://7368046225"] = {name = "Lunar Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936630605"] = {name = "Magic Carpet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936629525"] = {name = "Magic Moon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6309085791"] = {name = "Palanquin Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936631399"] = {name = "Pelican Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670918"] = {name = "Pizza Stroller", prices = {["default"] = 10.19}},
    ["rbxassetid://3009779443"] = {name = "Popsicle Stroller", prices = {["default"] = 6.45}},
    ["rbxassetid://6936628317"] = {name = "Princess Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://5882036757"] = {name = "Pumpkin Stroller", prices = {["default"] = 3.92}},
    ["rbxassetid://2408052388"] = {name = "Quad Stroller", prices = {["default"] = 196.27}},
    ["rbxassetid://2408035750"] = {name = "Race Car Stroller", prices = {["default"] = 36.75}},
    ["rbxassetid://6710108407"] = {name = "Rainbow Stroller", prices = {["default"] = 53.8}},
    ["rbxassetid://4470748252"] = {name = "Reindeer Stroller", prices = {["default"] = 7.68}},
    ["rbxassetid://8526099597"] = {name = "RGB Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2981204560"] = {name = "Rocket Ship Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://13986982302"] = {name = "Shopping Cart Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936628967"] = {name = "Teacup Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2982964426"] = {name = "Throne Stroller", prices = {["default"] = 2.63}},
    ["rbxassetid://2657671637"] = {name = "Trike Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544584"] = {name = "Triple Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277803"] = {name = "Unicorn Stroller", prices = {["default"] = 64.99}},
    ["rbxassetid://2466291803"] = {name = "Vampire Stroller", prices = {["default"] = 102.38}},
    ["rbxassetid://3066606234"] = {name = "Wheelbarrow Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://113061955717247"] = {name = "Admin Abuse Box", prices = {["default"] = 2.1}},
    ["rbxassetid://5888839551"] = {name = "Bat Box", prices = {["default"] = 64.97}},
    ["rbxassetid://4510471983"] = {name = "Golden Gift", prices = {["default"] = 917.44}},
    ["rbxassetid://5057100696"] = {name = "Monkey Box", prices = {["default"] = 131.25}},
    ["rbxassetid://6240246974"] = {name = "Ox Box", prices = {["default"] = 9.19}},
    ["rbxassetid://5067925110"] = {name = "Premium Monkey Box", prices = {["default"] = 1665.76}},
    ["rbxassetid://4621220017"] = {name = "Rat Box", prices = {["default"] = 420}},
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