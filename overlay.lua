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
    ["rbxassetid://137637490639925"] = {name = "Royal Mistletroll", prices = {["default"] = 781.79, ["Ride"] = 1027.16, ["Fly|Ride"] = 1181.25, ["Neon|Fly|Ride"] = 4200, ["Mega|Fly|Ride"] = 20002.18}},
    ["rbxassetid://140355753768438"] = {name = "Moonbeam Peacock", prices = {["default"] = 459.38, ["Ride"] = 564.38, ["Fly|Ride"] = 613.27, ["Neon|Ride"] = 1968.75, ["Neon|Fly|Ride"] = 2408.47, ["Mega"] = 10257.53}},
    ["rbxassetid://18117855573"] = {name = "Balloon Unicorn", prices = {["default"] = 4948.13, ["Ride"] = 5250, ["Fly|Ride"] = 4593.75, ["Neon|Fly|Ride"] = 21199.23, ["Mega|Fly|Ride"] = 68383.82}},
    ["rbxassetid://75782719698946"] = {name = "Red Dutch Guinea Pig", prices = {["default"] = 165.38, ["Ride"] = 183.75, ["Fly|Ride"] = 339.45, ["Neon"] = 820.41, ["Neon|Ride"] = 821.63, ["Neon|Fly|Ride"] = 1189.9, ["Mega"] = 4103.03, ["Mega|Fly|Ride"] = 3825.94}},
    ["rbxassetid://5067924142"] = {name = "Albino Monkey", prices = {["default"] = 632.63, ["Ride"] = 611.63, ["Fly|Ride"] = 656.25, ["Neon|Fly|Ride"] = 1519.88, ["Mega|Fly|Ride"] = 6562.4}},
    ["rbxassetid://108312620331321"] = {name = "Villain Gibbon", prices = {["default"] = 10.4, ["Ride"] = 27.68, ["Fly|Ride"] = 155.76, ["Neon"] = 56.44, ["Neon|Fly"] = 273.82, ["Neon|Ride"] = 120.74, ["Neon|Fly|Ride"] = 404.25, ["Mega"] = 324.84, ["Mega|Ride"] = 262.49, ["Mega|Fly|Ride"] = 582.75}},
    ["rbxassetid://17255958862"] = {name = "Alicorn", prices = {["default"] = 3.93, ["Fly"] = 41.99, ["Ride"] = 26.25, ["Fly|Ride"] = 63.59, ["Neon"] = 23.66, ["Neon|Fly"] = 102.56, ["Neon|Ride"] = 50.23, ["Neon|Fly|Ride"] = 109.74, ["Mega"] = 149.21, ["Mega|Fly"] = 388.23, ["Mega|Ride"] = 213.94, ["Mega|Fly|Ride"] = 276.24}},
    ["rbxassetid://90170598608675"] = {name = "Moonbeam Butterfly", prices = {["default"] = 118.13, ["Ride"] = 185.07, ["Fly|Ride"] = 240.19, ["Neon"] = 547.63, ["Neon|Ride"] = 492.19, ["Neon|Fly|Ride"] = 677, ["Mega|Fly|Ride"] = 2678.26}},
    ["rbxassetid://7126722445"] = {name = "Goldhorn", prices = {["default"] = 46.62, ["Fly"] = 97.67, ["Ride"] = 51.28, ["Fly|Ride"] = 77.84, ["Neon"] = 252, ["Neon|Ride"] = 237.93, ["Neon|Fly|Ride"] = 319.73, ["Mega"] = 2100, ["Mega|Ride"] = 1394.81, ["Mega|Fly|Ride"] = 1048.69}},
    ["rbxassetid://13186021971"] = {name = "Cuddly Candle", prices = {["default"] = 21, ["Fly"] = 58.47, ["Ride"] = 40.69, ["Fly|Ride"] = 66.94, ["Neon|Ride"] = 243.43, ["Neon|Fly|Ride"] = 282.19, ["Mega|Fly|Ride"] = 749.84}},
    ["rbxassetid://14146196672"] = {name = "Gargoyle", prices = {["default"] = 75.51, ["Fly"] = 108.72, ["Ride"] = 77.89, ["Fly|Ride"] = 177.19, ["Neon"] = 402.8, ["Neon|Ride"] = 301.88, ["Neon|Fly|Ride"] = 306.87, ["Mega|Fly|Ride"] = 1128.75}},
    ["rbxassetid://129762233626342"] = {name = "Royal Moon Egg", prices = {["default"] = 65.77}},
    ["rbxassetid://89693546199400"] = {name = "Cupid Dragon", prices = {["default"] = 313.49, ["Fly"] = 339.94, ["Ride"] = 283.5, ["Fly|Ride"] = 349.53, ["Neon"] = 1333.16, ["Neon|Ride"] = 1023.75, ["Neon|Fly|Ride"] = 1115.63, ["Mega|Fly|Ride"] = 4845.67}},
    ["rbxassetid://8665606875"] = {name = "Dancing Dragon", prices = {["default"] = 140.44, ["Fly"] = 173.15, ["Ride"] = 114.35, ["Fly|Ride"] = 149.63, ["Neon|Fly"] = 674.07, ["Neon|Fly|Ride"] = 650.34, ["Mega|Fly|Ride"] = 3007.52}},
    ["rbxassetid://110411427278536"] = {name = "Huntsman Robin", prices = {["default"] = 2.1, ["Ride"] = 53.43, ["Fly|Ride"] = 205.11, ["Neon"] = 20.52, ["Neon|Fly"] = 96.42, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 189, ["Mega"] = 124.69, ["Mega|Fly"] = 393.75, ["Mega|Ride"] = 272.87, ["Mega|Fly|Ride"] = 384.75}},
    ["rbxassetid://10925517718"] = {name = "Lava Dragon", prices = {["default"] = 189.95, ["Fly"] = 216.99, ["Ride"] = 212.52, ["Fly|Ride"] = 230.51, ["Neon|Ride"] = 711.71, ["Neon|Fly|Ride"] = 725.22, ["Mega"] = 3556.3, ["Mega|Fly|Ride"] = 2231.25}},
    ["rbxassetid://4797806482"] = {name = "Diamond Griffin", prices = {["default"] = 3.9, ["Ride"] = 15.48, ["Fly|Ride"] = 41.04, ["Neon"] = 30.19, ["Neon|Ride"] = 93.98, ["Neon|Fly|Ride"] = 129.93, ["Mega"] = 205.16, ["Mega|Ride"] = 326.82, ["Mega|Fly|Ride"] = 380.63}},
    ["rbxassetid://122648024705835"] = {name = "Scarebear", prices = {["default"] = 88.64, ["Fly"] = 466.38, ["Ride"] = 136.5, ["Fly|Ride"] = 248.75, ["Neon"] = 342.53, ["Neon|Fly"] = 459.38, ["Neon|Ride"] = 373.86, ["Neon|Fly|Ride"] = 479.04, ["Mega"] = 1703.79, ["Mega|Ride"] = 1365.3, ["Mega|Fly|Ride"] = 1230.92}},
    ["rbxassetid://13104102169"] = {name = "Danger Egg", prices = {["default"] = 38.97}},
    ["rbxassetid://133163961974577"] = {name = "2D Doggy", prices = {["default"] = 61.53, ["Ride"] = 393.75, ["Fly|Ride"] = 210, ["Neon"] = 577.5, ["Neon|Fly|Ride"] = 787.5, ["Mega"] = 1368.38, ["Mega|Fly|Ride"] = 2558.25}},
    ["rbxassetid://126071806166898"] = {name = "Evil Chick", prices = {["default"] = 19.01, ["Fly"] = 41.04, ["Ride"] = 37.22, ["Fly|Ride"] = 109.75, ["Neon"] = 137.44, ["Neon|Ride"] = 209.99, ["Neon|Fly|Ride"] = 273.9, ["Mega|Ride"] = 956.01, ["Mega|Fly|Ride"] = 1641.22}},
    ["rbxassetid://5721843247"] = {name = "Dodo", prices = {["default"] = 51.44, ["Fly"] = 124.38, ["Ride"] = 60.38, ["Fly|Ride"] = 113.19, ["Neon"] = 246.14, ["Neon|Ride"] = 240.18, ["Neon|Fly|Ride"] = 310.36, ["Mega"] = 1627.28, ["Mega|Ride"] = 1368.38, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://119640582603552"] = {name = "Violet Butterfly", prices = {["default"] = 66.94, ["Fly"] = 67.7, ["Ride"] = 189, ["Fly|Ride"] = 136.5, ["Neon"] = 208.69, ["Neon|Fly"] = 385.91, ["Neon|Ride"] = 191.79, ["Neon|Fly|Ride"] = 363.56, ["Mega"] = 1157.06, ["Mega|Ride"] = 1299.64, ["Mega|Fly|Ride"] = 1245.28}},
    ["rbxassetid://16088264958"] = {name = "Volcanic Rhino", prices = {["default"] = 22.32, ["Ride"] = 41.04, ["Fly|Ride"] = 84, ["Neon"] = 179.48, ["Neon|Ride"] = 137.44, ["Neon|Fly|Ride"] = 292.92, ["Mega"] = 818.56, ["Mega|Ride"] = 2051.52, ["Mega|Fly|Ride"] = 1023.75}},
    ["rbxassetid://75251818654427"] = {name = "Apple Owl", prices = {["default"] = 40.58, ["Fly"] = 629.67, ["Ride"] = 57.75, ["Fly|Ride"] = 123.08, ["Neon"] = 232.47, ["Neon|Ride"] = 183.75, ["Neon|Fly|Ride"] = 322.88, ["Mega|Ride"] = 1124.82, ["Mega|Fly|Ride"] = 903.42}},
    ["rbxassetid://3181727433"] = {name = "Dragon", prices = {["default"] = 6.23, ["Fly"] = 30, ["Ride"] = 19.43, ["Fly|Ride"] = 69.91, ["Neon"] = 41.03, ["Neon|Ride"] = 49.87, ["Neon|Fly|Ride"] = 99.73, ["Mega"] = 156.19, ["Mega|Fly"] = 302.6, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 329.65}},
    ["rbxassetid://121496682360324"] = {name = "Sugar Axolotl", prices = {["default"] = 417.56, ["Ride"] = 459.14, ["Fly|Ride"] = 480.11, ["Neon|Ride"] = 1689.18, ["Neon|Fly|Ride"] = 1964.82, ["Mega|Fly|Ride"] = 6825.37}},
    ["rbxassetid://11694854226"] = {name = "Shetland Pony Light Brown", prices = {["default"] = 12.13, ["Ride"] = 32.32, ["Fly|Ride"] = 105.18, ["Neon"] = 200.2, ["Neon|Ride"] = 137.44, ["Neon|Fly|Ride"] = 137.47, ["Mega|Fly|Ride"] = 671.66}},
    ["rbxassetid://4797806957"] = {name = "Golden Unicorn", prices = {["default"] = 6.57, ["Fly"] = 41.04, ["Ride"] = 20.78, ["Fly|Ride"] = 38.99, ["Neon"] = 73.5, ["Neon|Ride"] = 69.75, ["Neon|Fly|Ride"] = 119.44, ["Mega|Ride"] = 287.22, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://110822620060051"] = {name = "Frost Phoenix", prices = {["default"] = 75.5, ["Fly"] = 100.88, ["Ride"] = 97.54, ["Fly|Ride"] = 113.48, ["Neon"] = 410.21, ["Neon|Fly"] = 376.38, ["Neon|Ride"] = 385.75, ["Neon|Fly|Ride"] = 426.14, ["Mega"] = 3282.42, ["Mega|Ride"] = 7290.94, ["Mega|Fly|Ride"] = 1596.08}},
    ["rbxassetid://13894724323"] = {name = "Billy Goat", prices = {["default"] = 13.12, ["Ride"] = 24.63, ["Fly|Ride"] = 118.13, ["Neon"] = 96.42, ["Neon|Ride"] = 151.79, ["Neon|Fly|Ride"] = 164.07, ["Mega"] = 479.16, ["Mega|Ride"] = 781.64, ["Mega|Fly|Ride"] = 574.44}},
    ["rbxassetid://123037843357105"] = {name = "Glormy Leo", prices = {["default"] = 183.75, ["Fly"] = 342.53, ["Ride"] = 229.45, ["Fly|Ride"] = 315.38, ["Neon|Ride"] = 735, ["Neon|Fly|Ride"] = 964.22, ["Mega"] = 6154.53, ["Mega|Ride"] = 2887.5, ["Mega|Fly|Ride"] = 2939.75}},
    ["rbxassetid://12479078933"] = {name = "Southeast Asia Egg", prices = {["default"] = 62.14}},
    ["rbxassetid://122739780018633"] = {name = "Quetzalcoatl", prices = {["default"] = 3.2, ["Fly"] = 273.82, ["Ride"] = 22.58, ["Fly|Ride"] = 55.21, ["Neon"] = 27.71, ["Neon|Fly"] = 5127.49, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 140.6, ["Mega"] = 153.5, ["Mega|Fly"] = 508.46, ["Mega|Ride"] = 182.44, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://70953296065239"] = {name = "Frostbite Bear", prices = {["default"] = 905.63, ["Fly"] = 2625, ["Ride"] = 979.12, ["Fly|Ride"] = 1102.2, ["Neon"] = 4102, ["Neon|Ride"] = 6016.6, ["Neon|Fly|Ride"] = 4068.75, ["Mega|Ride"] = 52305.02, ["Mega|Fly|Ride"] = 15093.75}},
    ["rbxassetid://14978701948"] = {name = "Scarecrow Crow", prices = {["default"] = 10.5, ["Fly"] = 68.73, ["Ride"] = 29.4, ["Fly|Ride"] = 105.78, ["Neon"] = 137.44, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 137.47, ["Mega"] = 787.5, ["Mega|Ride"] = 818.56, ["Mega|Fly|Ride"] = 820.31}},
    ["rbxassetid://11191341630"] = {name = "Jousting Horse", prices = {["default"] = 184.51, ["Ride"] = 229.69, ["Fly|Ride"] = 273.82, ["Neon"] = 1025.52, ["Neon|Ride"] = 865.81, ["Neon|Fly|Ride"] = 801.94, ["Mega|Ride"] = 3943.01, ["Mega|Fly|Ride"] = 3150}},
    ["rbxassetid://76801905892592"] = {name = "Royal Aztec Egg", prices = {["default"] = 42.46}},
    ["rbxassetid://98801943598121"] = {name = "Priceless Shrimp", prices = {["default"] = 27.69, ["Fly"] = 273465.94, ["Ride"] = 65.54, ["Fly|Ride"] = 137.44, ["Neon"] = 104.36, ["Neon|Ride"] = 206.07, ["Neon|Fly|Ride"] = 195.93, ["Mega"] = 684.53, ["Mega|Ride"] = 1081.79, ["Mega|Fly|Ride"] = 761.25}},
    ["rbxassetid://95214789806437"] = {name = "Aztec Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://18515755354"] = {name = "Cheetah", prices = {["default"] = 139.13, ["Ride"] = 137.44, ["Fly|Ride"] = 263.86, ["Neon|Ride"] = 547.63, ["Neon|Fly|Ride"] = 684.2, ["Mega|Fly|Ride"] = 2355.94}},
    ["rbxassetid://18117855114"] = {name = "Corn Doggo", prices = {["default"] = 315, ["Ride"] = 198.19, ["Fly|Ride"] = 273.82, ["Neon"] = 388.23, ["Neon|Fly"] = 547.63, ["Neon|Ride"] = 334.69, ["Neon|Fly|Ride"] = 590.63, ["Mega|Ride"] = 1509.38, ["Mega|Fly|Ride"] = 1948.94}},
    ["rbxassetid://8972175010"] = {name = "Woodland Egg", prices = {["default"] = 36.75}},
    ["rbxassetid://3710823011"] = {name = "Golden Penguin", prices = {["default"] = 62.63, ["Fly"] = 61.35, ["Ride"] = 61.09, ["Fly|Ride"] = 85.71, ["Neon|Ride"] = 355.86, ["Neon|Fly|Ride"] = 365.14, ["Mega"] = 4103.03, ["Mega|Fly|Ride"] = 1639.17}},
    ["rbxassetid://136490701345923"] = {name = "Glormy Crab", prices = {["default"] = 8.13, ["Ride"] = 26.17, ["Fly|Ride"] = 131.25, ["Neon"] = 51.3, ["Neon|Ride"] = 137.44, ["Neon|Fly|Ride"] = 230.82, ["Mega"] = 195.93, ["Mega|Fly"] = 267.75, ["Mega|Ride"] = 324.9, ["Mega|Fly|Ride"] = 598.5}},
    ["rbxassetid://14782580581"] = {name = "Vampire Dragon", prices = {["default"] = 507.57, ["Fly"] = 590.63, ["Ride"] = 465.51, ["Fly|Ride"] = 511.87, ["Neon|Ride"] = 3697.79, ["Neon|Fly|Ride"] = 1573.51, ["Mega|Fly|Ride"] = 7376.25}},
    ["rbxassetid://88405494856204"] = {name = "Solaris", prices = {["default"] = 103.84, ["Fly"] = 162.04, ["Ride"] = 115.49, ["Fly|Ride"] = 194.13, ["Neon"] = 459.38, ["Neon|Fly"] = 820.41, ["Neon|Ride"] = 684.03, ["Neon|Fly|Ride"] = 616.88, ["Mega|Ride"] = 2460.8, ["Mega|Fly|Ride"] = 2317.34}},
    ["rbxassetid://84468510887759"] = {name = "Orchid Butterfly", prices = {["Ride"] = 3596.25, ["Fly|Ride"] = 3675, ["Neon|Fly|Ride"] = 14359.51}},
    ["rbxassetid://11109286837"] = {name = "Lava Wolf", prices = {["default"] = 34.72, ["Fly"] = 112.1, ["Ride"] = 41.04, ["Fly|Ride"] = 128.43, ["Neon|Ride"] = 582.65, ["Neon|Fly|Ride"] = 403.35, ["Mega"] = 1299.64, ["Mega|Ride"] = 1710.97, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://12403863809"] = {name = "Albino Gorilla", prices = {["default"] = 155.75, ["Ride"] = 78.75, ["Fly|Ride"] = 136.99, ["Neon"] = 410.21, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 525, ["Mega"] = 2735.7, ["Mega|Ride"] = 2599.27, ["Mega|Fly|Ride"] = 2973.41}},
    ["rbxassetid://6060988121"] = {name = "Snow Owl", prices = {["default"] = 40.57, ["Fly"] = 69.48, ["Ride"] = 58.09, ["Fly|Ride"] = 101.07, ["Neon"] = 262.5, ["Neon|Fly"] = 294.34, ["Neon|Ride"] = 182.56, ["Neon|Fly|Ride"] = 209.98, ["Mega"] = 2625, ["Mega|Ride"] = 725.22, ["Mega|Fly|Ride"] = 655.46}},
    ["rbxassetid://112630556645658"] = {name = "Moon Egg", prices = {["default"] = 9.45}},
    ["rbxassetid://10357473556"] = {name = "Golden Chow-Chow", prices = {["default"] = 47.23, ["Ride"] = 61.55, ["Fly|Ride"] = 64.94, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 547.77, ["Mega|Fly|Ride"] = 1859.75}},
    ["rbxassetid://5721843384"] = {name = "Fossil Egg", prices = {["default"] = 45.54}},
    ["rbxassetid://92775688228060"] = {name = "Papa Moose", prices = {["default"] = 230.13, ["Ride"] = 223.13, ["Fly|Ride"] = 313.82, ["Neon|Ride"] = 1085.48, ["Neon|Fly|Ride"] = 1368.38}},
    ["rbxassetid://12479991588"] = {name = "Frost Unicorn", prices = {["default"] = 1469.04, ["Ride"] = 957.84, ["Fly|Ride"] = 1372.12, ["Neon"] = 2887.5, ["Neon|Fly|Ride"] = 3018.75, ["Mega|Fly|Ride"] = 13677.39}},
    ["rbxassetid://9661880325"] = {name = "Zodiac Minion Egg", prices = {["default"] = 7.49}},
    ["rbxassetid://7126719832"] = {name = "Phoenix", prices = {["default"] = 31.5, ["Fly"] = 102.56, ["Ride"] = 45.92, ["Fly|Ride"] = 64.11, ["Neon"] = 160.78, ["Neon|Ride"] = 166.68, ["Neon|Fly|Ride"] = 223.13, ["Mega|Ride"] = 891.66, ["Mega|Fly|Ride"] = 971.25}},
    ["rbxassetid://119386690822810"] = {name = "Royal Fairytale Egg", prices = {["default"] = 14.96}},
    ["rbxassetid://4440866299"] = {name = "Crow", prices = {["default"] = 7520.06, ["Ride"] = 6456.54, ["Fly|Ride"] = 4608.19, ["Neon|Fly|Ride"] = 10827.6, ["Mega|Fly|Ride"] = 37194.68}},
    ["rbxassetid://4797806531"] = {name = "Diamond Unicorn", prices = {["default"] = 12.86, ["Fly"] = 52.4, ["Ride"] = 23.38, ["Fly|Ride"] = 63.79, ["Neon"] = 102.55, ["Neon|Ride"] = 120.75, ["Neon|Fly|Ride"] = 219.19, ["Mega"] = 787.5, ["Mega|Ride"] = 508.79, ["Mega|Fly|Ride"] = 588.8}},
    ["rbxassetid://88817325500927"] = {name = "Kraken", prices = {["default"] = 13.61, ["Fly"] = 190.76, ["Ride"] = 41.04, ["Fly|Ride"] = 273.82, ["Neon"] = 68.73, ["Neon|Ride"] = 122.07, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 721.88, ["Mega|Ride"] = 519.75, ["Mega|Fly|Ride"] = 1022.69}},
    ["rbxassetid://9490243442"] = {name = "Diamond King Penguin", prices = {["default"] = 116.91, ["Ride"] = 91.88, ["Fly|Ride"] = 133.2, ["Neon|Ride"] = 380.47, ["Neon|Fly|Ride"] = 480.96, ["Mega"] = 4103.03}},
    ["rbxassetid://107787284008278"] = {name = "Primal Kaijunior", prices = {["default"] = 12.56, ["Ride"] = 30.41, ["Fly|Ride"] = 78.75, ["Neon"] = 77.18, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 137.47, ["Mega|Ride"] = 731.08, ["Mega|Fly|Ride"] = 813.75}},
    ["rbxassetid://4506837037"] = {name = "Arctic Reindeer", prices = {["default"] = 2563.43, ["Fly"] = 2221.23, ["Ride"] = 1785, ["Fly|Ride"] = 1876.87, ["Neon|Fly|Ride"] = 3530.63, ["Mega|Fly|Ride"] = 12468.75}},
    ["rbxassetid://4184878149"] = {name = "Bat Dragon", prices = {["default"] = 33221.93, ["Fly|Ride"] = 26117.44, ["Neon|Ride"] = 65625, ["Neon|Fly|Ride"] = 77489.3, ["Mega"] = 210000, ["Mega|Fly|Ride"] = 183750}},
    ["rbxassetid://118641789458122"] = {name = "Gilded Snake", prices = {["default"] = 16.95, ["Fly"] = 393.74, ["Ride"] = 55.13, ["Fly|Ride"] = 124.69, ["Neon"] = 266.65, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 273.9, ["Mega"] = 958.07, ["Mega|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 816.51}},
    ["rbxassetid://71844856693163"] = {name = "Purrowl", prices = {["default"] = 3.1, ["Fly"] = 65.63, ["Ride"] = 41.04, ["Fly|Ride"] = 158.9, ["Neon"] = 20.9, ["Neon|Fly"] = 96.57, ["Neon|Ride"] = 63, ["Neon|Fly|Ride"] = 120.02, ["Mega"] = 132.3, ["Mega|Ride"] = 253.32, ["Mega|Fly|Ride"] = 356.49}},
    ["rbxassetid://7195311687"] = {name = "Mythic Egg", prices = {["default"] = 20.52}},
    ["rbxassetid://102330087609546"] = {name = "Fire Mare", prices = {["default"] = 7.77, ["Fly|Ride"] = 125.25, ["Neon"] = 61.55, ["Neon|Ride"] = 137.44, ["Neon|Fly|Ride"] = 273.9, ["Mega"] = 342.61, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 545.58}},
    ["rbxassetid://16659215347"] = {name = "Candyfloss Chick", prices = {["default"] = 708.75, ["Ride"] = 735, ["Fly|Ride"] = 918.75, ["Neon"] = 2324.67, ["Neon|Fly|Ride"] = 2564.39, ["Mega|Fly|Ride"] = 8662.5}},
    ["rbxassetid://9281950769"] = {name = "Sugar Glider", prices = {["default"] = 905.61, ["Fly"] = 975.19, ["Ride"] = 918.65, ["Fly|Ride"] = 1040.82, ["Neon|Ride"] = 3145.21, ["Neon|Fly|Ride"] = 3109.31, ["Mega|Fly|Ride"] = 12088.28}},
    ["rbxassetid://15485137935"] = {name = "Fleur De Ice", prices = {["default"] = 17.07, ["Fly"] = 116.24, ["Ride"] = 32.48, ["Fly|Ride"] = 85.32, ["Neon"] = 137.44, ["Neon|Ride"] = 119.9, ["Neon|Fly|Ride"] = 205.16, ["Mega"] = 1204.13, ["Mega|Ride"] = 685.13, ["Mega|Fly|Ride"] = 594.96}},
    ["rbxassetid://6498256269"] = {name = "Ocean Egg", prices = {["default"] = 28.88}},
    ["rbxassetid://8704877940"] = {name = "Lavender Dragon", prices = {["default"] = 78.54, ["Fly"] = 111.57, ["Ride"] = 75.51, ["Fly|Ride"] = 104.9, ["Neon"] = 460.46, ["Neon|Ride"] = 403.59, ["Neon|Fly|Ride"] = 410.31, ["Mega|Ride"] = 2008.43, ["Mega|Fly|Ride"] = 1664.25}},
    ["rbxassetid://13685038182"] = {name = "Leviathan", prices = {["default"] = 65.77, ["Ride"] = 78.75, ["Fly|Ride"] = 228.38, ["Neon"] = 450.19, ["Neon|Ride"] = 278.74, ["Neon|Fly|Ride"] = 547.77, ["Mega"] = 1334.91, ["Mega|Fly|Ride"] = 1758.75}},
    ["rbxassetid://4797806358"] = {name = "Diamond Dragon", prices = {["default"] = 5.99, ["Fly"] = 44.88, ["Ride"] = 17.21, ["Fly|Ride"] = 59.04, ["Neon"] = 55.4, ["Neon|Fly"] = 524.98, ["Neon|Ride"] = 93.19, ["Neon|Fly|Ride"] = 130.29, ["Mega"] = 288.75, ["Mega|Ride"] = 295.32, ["Mega|Fly|Ride"] = 498.75}},
    ["rbxassetid://5862774327"] = {name = "Cerberus", prices = {["default"] = 133.84, ["Fly"] = 173.25, ["Ride"] = 144.38, ["Fly|Ride"] = 209.31, ["Neon"] = 464.94, ["Neon|Ride"] = 498.75, ["Neon|Fly|Ride"] = 498.75, ["Mega|Fly|Ride"] = 1569.75}},
    ["rbxassetid://74012786571707"] = {name = "Three Blind Mice", prices = {["default"] = 9.31, ["Ride"] = 45.93, ["Fly|Ride"] = 262.49, ["Neon"] = 51.1, ["Neon|Ride"] = 127.32, ["Neon|Fly|Ride"] = 478.01, ["Mega"] = 248.07, ["Mega|Ride"] = 918.75, ["Mega|Fly|Ride"] = 539.56}},
    ["rbxassetid://15931348363"] = {name = "Criosphinx", prices = {["default"] = 12.04, ["Fly"] = 41.22, ["Ride"] = 32.69, ["Fly|Ride"] = 79.31, ["Neon"] = 85.32, ["Neon|Ride"] = 100.51, ["Neon|Fly|Ride"] = 205.16, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://118278167134251"] = {name = "Influencer Gibbon", prices = {["default"] = 32.71, ["Ride"] = 55.4, ["Fly|Ride"] = 156.19, ["Neon"] = 260.49, ["Neon|Ride"] = 328.17, ["Neon|Fly|Ride"] = 410.31, ["Mega"] = 918.74, ["Mega|Ride"] = 775.29, ["Mega|Fly|Ride"] = 1014.85}},
    ["rbxassetid://17059982206"] = {name = "Dimorphodon", prices = {["default"] = 11.71, ["Fly"] = 169.81, ["Ride"] = 36.75, ["Fly|Ride"] = 70.88, ["Neon"] = 91.88, ["Neon|Ride"] = 109.27, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 886.27, ["Mega|Fly|Ride"] = 947.63}},
    ["rbxassetid://119212313534429"] = {name = "Giant Panda", prices = {["Ride"] = 7141.32, ["Fly|Ride"] = 5494.13, ["Neon"] = 30764.89, ["Neon|Fly|Ride"] = 27202.95, ["Mega|Fly|Ride"] = 92986.68}},
    ["rbxassetid://6060998707"] = {name = "Frost Fury", prices = {["default"] = 233.63, ["Fly"] = 315, ["Ride"] = 260.34, ["Fly|Ride"] = 273.77, ["Neon|Fly|Ride"] = 640.97, ["Mega|Fly|Ride"] = 2063.25}},
    ["rbxassetid://88882779021298"] = {name = "Kitty Bat", prices = {["default"] = 40.68, ["Fly"] = 315, ["Ride"] = 85.3, ["Fly|Ride"] = 162.86, ["Neon"] = 121.95, ["Neon|Fly"] = 306.65, ["Neon|Ride"] = 166.98, ["Neon|Fly|Ride"] = 265.13, ["Mega"] = 392.44, ["Mega|Fly"] = 573.42, ["Mega|Ride"] = 433.62, ["Mega|Fly|Ride"] = 500.06}},
    ["rbxassetid://16441372760"] = {name = "Diamond Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 86.03, ["Ride"] = 23.26, ["Fly|Ride"] = 105.78, ["Neon"] = 25.38, ["Neon|Fly"] = 49.24, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 186.71, ["Mega"] = 330.75, ["Mega|Ride"] = 187.69}},
    ["rbxassetid://3199974169"] = {name = "Royal Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://84714602656867"] = {name = "Slimingo", prices = {["default"] = 55.38, ["Fly"] = 5268.85, ["Ride"] = 68.73, ["Fly|Ride"] = 199.87, ["Neon"] = 211.87, ["Neon|Fly"] = 379.45, ["Neon|Ride"] = 233.87, ["Neon|Fly|Ride"] = 311.56, ["Mega"] = 369.26, ["Mega|Ride"] = 568.99, ["Mega|Fly|Ride"] = 622.95}},
    ["rbxassetid://3409443710"] = {name = "Giraffe", prices = {["default"] = 15585.61, ["Ride"] = 11943.75, ["Fly|Ride"] = 11811.19, ["Neon|Fly|Ride"] = 22312.5}},
    ["rbxassetid://121215031043780"] = {name = "Velocirooster", prices = {["default"] = 204.06, ["Ride"] = 295.54, ["Fly|Ride"] = 343.08, ["Neon"] = 1503.39, ["Neon|Fly|Ride"] = 1538.64, ["Mega"] = 5471.38, ["Mega|Fly|Ride"] = 5826.29}},
    ["rbxassetid://5067925034"] = {name = "Ninja Monkey", prices = {["default"] = 62.91, ["Fly"] = 74.82, ["Ride"] = 77.35, ["Fly|Ride"] = 101.58, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 393.75, ["Mega|Fly|Ride"] = 2735.7}},
    ["rbxassetid://10618035564"] = {name = "Baku", prices = {["default"] = 12.06, ["Fly"] = 44.18, ["Ride"] = 23.27, ["Fly|Ride"] = 72.1, ["Neon"] = 140.44, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 149.63, ["Mega"] = 295.32, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://13665641282"] = {name = "Shark Puppy", prices = {["default"] = 452.82, ["Ride"] = 472.5, ["Fly|Ride"] = 484.31, ["Neon"] = 1736.54, ["Neon|Ride"] = 1394.94, ["Neon|Fly|Ride"] = 1719.38, ["Mega|Fly|Ride"] = 5011.13}},
    ["rbxassetid://119447343321908"] = {name = "Tealwood Monster", prices = {["default"] = 5.25, ["Fly"] = 101.54, ["Ride"] = 37.68, ["Fly|Ride"] = 84.96, ["Neon"] = 26.25, ["Neon|Ride"] = 124.37, ["Neon|Fly|Ride"] = 178.5, ["Mega"] = 132.43, ["Mega|Ride"] = 187.69, ["Mega|Fly|Ride"] = 728.44}},
    ["rbxassetid://85568505745239"] = {name = "Latte Kitsune", prices = {["default"] = 130.76, ["Fly"] = 272, ["Ride"] = 129.94, ["Fly|Ride"] = 233.52, ["Neon"] = 449.18, ["Neon|Ride"] = 524.88, ["Neon|Fly|Ride"] = 545.71, ["Mega|Fly|Ride"] = 2051.52}},
    ["rbxassetid://3181727727"] = {name = "Griffin", prices = {["default"] = 9.19, ["Fly"] = 18.08, ["Ride"] = 17.85, ["Fly|Ride"] = 41.25, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 135.42, ["Mega"] = 874.13, ["Mega|Fly|Ride"] = 958.07}},
    ["rbxassetid://4822753215"] = {name = "Golden Egg", prices = {["default"] = 9.18}},
    ["rbxassetid://116463571924920"] = {name = "Prismatic Butterfly", prices = {["default"] = 74.82, ["Fly"] = 137.44, ["Ride"] = 91.88, ["Fly|Ride"] = 196.88, ["Neon"] = 421.32, ["Neon|Fly"] = 547.63, ["Neon|Ride"] = 524.99, ["Neon|Fly|Ride"] = 446.25, ["Mega|Ride"] = 1181.25, ["Mega|Fly|Ride"] = 1778.67}},
    ["rbxassetid://8596153183"] = {name = "Chameleon", prices = {["default"] = 15.74, ["Fly"] = 101.54, ["Ride"] = 48.83, ["Fly|Ride"] = 89.25, ["Neon"] = 123.08, ["Neon|Ride"] = 144.38, ["Neon|Fly|Ride"] = 245.44, ["Mega|Fly|Ride"] = 682.5}},
    ["rbxassetid://110774856122162"] = {name = "Gemstone Egg", prices = {["default"] = 23.63}},
    ["rbxassetid://14892649590"] = {name = "Dire Stag", prices = {["default"] = 47.16, ["Fly"] = 210, ["Ride"] = 91.88, ["Fly|Ride"] = 249.38, ["Neon"] = 137.44, ["Neon|Ride"] = 260.46, ["Neon|Fly|Ride"] = 410.31, ["Mega"] = 1538.64, ["Mega|Ride"] = 1321.19, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://106744890070136"] = {name = "Oakee Wizard", prices = {["default"] = 4.79, ["Ride"] = 29.23, ["Neon"] = 27.71, ["Neon|Ride"] = 101.13, ["Neon|Fly|Ride"] = 273.9, ["Mega"] = 135.19, ["Mega|Fly|Ride"] = 196.87}},
    ["rbxassetid://9938967576"] = {name = "Chocolate Chow-Chow", prices = {["default"] = 15.03, ["Fly"] = 47.25, ["Ride"] = 30.19, ["Fly|Ride"] = 96.42, ["Neon|Ride"] = 137.44, ["Neon|Fly|Ride"] = 211.01, ["Mega|Ride"] = 615.47, ["Mega|Fly|Ride"] = 590.28}},
    ["rbxassetid://9174893483"] = {name = "Mechapup", prices = {["default"] = 507.57, ["Ride"] = 452.61, ["Fly|Ride"] = 541.66, ["Neon|Fly|Ride"] = 2728.51, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://15292843858"] = {name = "Mecha Meow", prices = {["default"] = 39.87, ["Ride"] = 55.11, ["Fly|Ride"] = 72.19, ["Neon"] = 234.67, ["Neon|Ride"] = 242.15, ["Neon|Fly|Ride"] = 314.92, ["Mega"] = 1007.75, ["Mega|Ride"] = 681.45, ["Mega|Fly|Ride"] = 1365}},
    ["rbxassetid://15931200262"] = {name = "Cactus Friend", prices = {["default"] = 53.55, ["Fly"] = 117.49, ["Ride"] = 80, ["Fly|Ride"] = 131.15, ["Neon"] = 273.82, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 437.07, ["Mega|Ride"] = 820.61, ["Mega|Fly|Ride"] = 1115.63}},
    ["rbxassetid://127221459636244"] = {name = "Strawberry Shortcake Ducky", prices = {["default"] = 139.55, ["Fly"] = 96.64, ["Ride"] = 70.88, ["Fly|Ride"] = 137.44, ["Neon"] = 96.42, ["Neon|Fly"] = 257.41, ["Neon|Ride"] = 205.11, ["Neon|Fly|Ride"] = 320.04, ["Mega"] = 437.07, ["Mega|Ride"] = 420, ["Mega|Fly|Ride"] = 644.43}},
    ["rbxassetid://4470748644"] = {name = "Frost Dragon", prices = {["default"] = 13125, ["Fly"] = 8400, ["Ride"] = 13328.44, ["Fly|Ride"] = 8268.75, ["Neon|Fly|Ride"] = 16300.6, ["Mega|Fly|Ride"] = 38850}},
    ["rbxassetid://15365667976"] = {name = "Chocolate Chip Bat Dragon", prices = {["default"] = 1509.38, ["Ride"] = 1391.24, ["Fly|Ride"] = 1606.5, ["Neon|Ride"] = 5119.29, ["Neon|Fly|Ride"] = 4960.15, ["Mega|Fly|Ride"] = 17683.98}},
    ["rbxassetid://16898343164"] = {name = "Pirate Ghost Capuchin Monkey", prices = {["default"] = 711.62, ["Ride"] = 560.38, ["Fly|Ride"] = 656.25, ["Neon"] = 4338.65, ["Neon|Fly|Ride"] = 2062.55, ["Mega|Fly|Ride"] = 6825.37}},
    ["rbxassetid://6404812772"] = {name = "Golden Ladybug", prices = {["default"] = 12.08, ["Fly"] = 20.9, ["Ride"] = 21.61, ["Fly|Ride"] = 52.37, ["Neon"] = 110.25, ["Neon|Ride"] = 72.19, ["Neon|Fly|Ride"] = 96.44, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://95029455226760"] = {name = "Easter Bunny", prices = {["default"] = 6.99, ["Fly"] = 78.74, ["Ride"] = 26.25, ["Fly|Ride"] = 88.2, ["Neon"] = 27.57, ["Neon|Ride"] = 76.93, ["Neon|Fly|Ride"] = 205.16, ["Mega"] = 143.54, ["Mega|Ride"] = 189.25, ["Mega|Fly|Ride"] = 257.27}},
    ["rbxassetid://5307473113"] = {name = "Kitsune", prices = {["default"] = 47.19, ["Ride"] = 48.29, ["Fly|Ride"] = 101.12, ["Neon"] = 523.06, ["Neon|Ride"] = 194.25, ["Neon|Fly|Ride"] = 189.84, ["Mega|Fly|Ride"] = 551.15}},
    ["rbxassetid://4797806780"] = {name = "Golden Dragon", prices = {["default"] = 3.84, ["Fly"] = 28.48, ["Ride"] = 18.38, ["Fly|Ride"] = 39.26, ["Neon"] = 29.91, ["Neon|Fly"] = 41.04, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 137.47, ["Mega|Ride"] = 205.16}},
    ["rbxassetid://135649428081307"] = {name = "Sakura Spirit", prices = {["default"] = 393.75, ["Fly"] = 369.49, ["Ride"] = 341.2, ["Fly|Ride"] = 405.06, ["Neon|Fly|Ride"] = 1230.92, ["Mega|Fly|Ride"] = 4650.78}},
    ["rbxassetid://11109110190"] = {name = "White Amazon", prices = {["default"] = 23.61, ["Fly"] = 91.88, ["Ride"] = 33.5, ["Fly|Ride"] = 88.2, ["Neon"] = 91.88, ["Neon|Fly"] = 410.21, ["Neon|Ride"] = 141.7, ["Neon|Fly|Ride"] = 191.83, ["Mega"] = 599.05, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://9475753542"] = {name = "Golden Albatross", prices = {["default"] = 10.5, ["Fly"] = 18.38, ["Ride"] = 19.69, ["Fly|Ride"] = 43.09, ["Neon"] = 137.44, ["Neon|Fly"] = 123.08, ["Neon|Ride"] = 80.56, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 1575, ["Mega|Ride"] = 618.19, ["Mega|Fly|Ride"] = 426.57}},
    ["rbxassetid://12778628831"] = {name = "Emperor Gorilla", prices = {["default"] = 478.87, ["Ride"] = 446.25, ["Fly|Ride"] = 684.03, ["Neon|Fly|Ride"] = 2789.61, ["Mega|Fly|Ride"] = 8619.21}},
    ["rbxassetid://13672542902"] = {name = "Hot Doggo", prices = {["default"] = 1406.82, ["Ride"] = 1154.9, ["Fly|Ride"] = 1312.5, ["Neon"] = 4786.01, ["Neon|Fly|Ride"] = 3570, ["Mega|Fly|Ride"] = 13782.3}},
    ["rbxassetid://8070897995"] = {name = "Ice Golem", prices = {["default"] = 115.88, ["Ride"] = 103.69, ["Fly|Ride"] = 133.88, ["Neon"] = 971.25, ["Neon|Ride"] = 585.46, ["Neon|Fly|Ride"] = 498.75, ["Mega|Fly|Ride"] = 3564.89}},
    ["rbxassetid://128225904426926"] = {name = "Rose Dragon", prices = {["default"] = 184.57, ["Fly"] = 212.13, ["Ride"] = 169.32, ["Fly|Ride"] = 242.82, ["Neon"] = 577.5, ["Neon|Ride"] = 793.07, ["Neon|Fly|Ride"] = 762.57, ["Mega|Ride"] = 8603.44, ["Mega|Fly|Ride"] = 2673.57}},
    ["rbxassetid://13883274830"] = {name = "Pirate Hermit Crab", prices = {["default"] = 26.16, ["Ride"] = 53.82, ["Fly|Ride"] = 118.58, ["Neon"] = 262.64, ["Neon|Ride"] = 272.99, ["Neon|Fly|Ride"] = 410.31, ["Mega|Ride"] = 2051.52, ["Mega|Fly|Ride"] = 877.03}},
    ["rbxassetid://95213400890066"] = {name = "Diamond Hummingbird", prices = {["default"] = 215.75, ["Ride"] = 315, ["Fly|Ride"] = 547.63, ["Neon|Fly"] = 929.88, ["Neon|Fly|Ride"] = 1301.83, ["Mega|Fly|Ride"] = 3692.73}},
    ["rbxassetid://10453528102"] = {name = "Diamond Butterfly", prices = {["default"] = 2229.17, ["Ride"] = 2483.25, ["Fly|Ride"] = 2188.43, ["Neon|Fly|Ride"] = 10257.53, ["Mega|Fly|Ride"] = 27896.02}},
    ["rbxassetid://12778628650"] = {name = "Astronaut Gorilla", prices = {["default"] = 78.75, ["Ride"] = 83.53, ["Fly|Ride"] = 196.88, ["Neon"] = 511.88, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 343.87, ["Mega|Ride"] = 2256.68, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://4708551306"] = {name = "Kangaroo", prices = {["default"] = 656.25, ["Ride"] = 643.02, ["Fly|Ride"] = 691.69, ["Neon|Ride"] = 1627.04, ["Neon|Fly|Ride"] = 1305.93, ["Mega|Fly|Ride"] = 3358.64}},
    ["rbxassetid://9542440966"] = {name = "Capricorn", prices = {["default"] = 44.61, ["Fly"] = 59.07, ["Ride"] = 61.04, ["Fly|Ride"] = 97.12, ["Neon|Ride"] = 360.29, ["Neon|Fly|Ride"] = 303.19, ["Mega|Fly|Ride"] = 1181.24}},
    ["rbxassetid://9678195673"] = {name = "Ancient Dragon", prices = {["default"] = 2.62, ["Fly"] = 46.03, ["Ride"] = 22.4, ["Fly|Ride"] = 52.27, ["Neon"] = 19.31, ["Neon|Fly"] = 120.75, ["Neon|Ride"] = 45.13, ["Neon|Fly|Ride"] = 107.62, ["Mega"] = 148.84, ["Mega|Fly"] = 248.98, ["Mega|Ride"] = 155.76, ["Mega|Fly|Ride"] = 307.13}},
    ["rbxassetid://132388343771587"] = {name = "Kelp Captain", prices = {["default"] = 52.03, ["Ride"] = 164.07, ["Fly|Ride"] = 253.32, ["Neon"] = 338.42, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 684.2, ["Mega"] = 1499.67, ["Mega|Ride"] = 1641.22, ["Mega|Fly|Ride"] = 1429.16}},
    ["rbxassetid://15148532648"] = {name = "Werewolf", prices = {["default"] = 851.82, ["Ride"] = 834.75, ["Fly|Ride"] = 905.63, ["Neon|Ride"] = 2572.77, ["Neon|Fly|Ride"] = 2362.5, ["Mega|Fly|Ride"] = 9631.13}},
    ["rbxassetid://86323568215409"] = {name = "Tortoiseshell Guinea Pig", prices = {["default"] = 656.25, ["Ride"] = 881.06, ["Fly|Ride"] = 883.38, ["Neon|Fly|Ride"] = 4048.66, ["Mega|Fly|Ride"] = 14770.84}},
    ["rbxassetid://5973019152"] = {name = "Robo Dog", prices = {["default"] = 13.13, ["Fly"] = 39.38, ["Ride"] = 26.25, ["Fly|Ride"] = 39.37, ["Neon|Ride"] = 101.82, ["Neon|Fly|Ride"] = 196.77, ["Mega"] = 786.19, ["Mega|Ride"] = 684.2, ["Mega|Fly|Ride"] = 681.29}},
    ["rbxassetid://7734928470"] = {name = "Halloween Golden Mummy Cat", prices = {["default"] = 11.32, ["Ride"] = 30.78, ["Fly|Ride"] = 59.06, ["Neon"] = 89.77, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 178.5, ["Mega"] = 374.07, ["Mega|Ride"] = 410.31, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://137429532189183"] = {name = "Fire Stallion", prices = {["default"] = 6.24, ["Ride"] = 24.92, ["Fly|Ride"] = 111.56, ["Neon"] = 21.19, ["Neon|Fly"] = 315.25, ["Neon|Ride"] = 54.46, ["Neon|Fly|Ride"] = 244.11, ["Mega"] = 137.47, ["Mega|Fly"] = 527.71, ["Mega|Ride"] = 244.02, ["Mega|Fly|Ride"] = 334.69}},
    ["rbxassetid://7215324578"] = {name = "Axolotl", prices = {["default"] = 63.67, ["Fly"] = 53.82, ["Ride"] = 64.62, ["Fly|Ride"] = 111.57, ["Neon"] = 229.69, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 262.5, ["Mega|Fly|Ride"] = 953.01}},
    ["rbxassetid://111805565268081"] = {name = "Black Widow", prices = {["default"] = 65.63, ["Ride"] = 133.84, ["Fly|Ride"] = 449.61, ["Neon"] = 419.83, ["Neon|Ride"] = 511.73, ["Neon|Fly|Ride"] = 695.63, ["Mega"] = 1504.79, ["Mega|Ride"] = 1538.64, ["Mega|Fly|Ride"] = 1495.56}},
    ["rbxassetid://103653773461193"] = {name = "Sunglider", prices = {["default"] = 16.41, ["Fly"] = 65.63, ["Ride"] = 34.8, ["Fly|Ride"] = 99.98, ["Neon"] = 82.7, ["Neon|Fly"] = 155.74, ["Neon|Ride"] = 117.85, ["Neon|Fly|Ride"] = 205.16, ["Mega"] = 408.27, ["Mega|Ride"] = 352.96, ["Mega|Fly|Ride"] = 463.32}},
    ["rbxassetid://6498256069"] = {name = "Shark", prices = {["default"] = 36.38, ["Ride"] = 45.73, ["Fly|Ride"] = 88.76, ["Neon"] = 547.63, ["Neon|Ride"] = 205.11, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 2100, ["Mega|Ride"] = 958.07, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://8663440945"] = {name = "Lunar Gold Tiger", prices = {["default"] = 3.64, ["Fly"] = 28.19, ["Ride"] = 17.61, ["Fly|Ride"] = 48, ["Neon"] = 24.03, ["Neon|Ride"] = 45.93, ["Neon|Fly|Ride"] = 72.19, ["Mega"] = 525, ["Mega|Ride"] = 464.94, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://94185217299816"] = {name = "Dracula Parrot", prices = {["default"] = 5.99, ["Fly"] = 40.63, ["Ride"] = 31.39, ["Fly|Ride"] = 1312.5, ["Neon"] = 25.99, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 151.82, ["Mega"] = 246.2, ["Mega|Ride"] = 308.44, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://4621220431"] = {name = "Golden Rat", prices = {["default"] = 58.44, ["Fly"] = 101.14, ["Ride"] = 62.23, ["Fly|Ride"] = 94.5, ["Neon"] = 403.34, ["Neon|Ride"] = 279.34, ["Neon|Fly|Ride"] = 272.54, ["Mega|Fly|Ride"] = 1070.35}},
    ["rbxassetid://11506045996"] = {name = "Strawberry Shortcake Bat Dragon", prices = {["default"] = 1575, ["Fly"] = 1909.72, ["Ride"] = 1650.54, ["Fly|Ride"] = 1569.75, ["Neon|Fly|Ride"] = 3804.94, ["Mega|Fly|Ride"] = 13480.61}},
    ["rbxassetid://11758583912"] = {name = "Winged Tiger", prices = {["default"] = 393.75, ["Fly"] = 627.66, ["Ride"] = 393.65, ["Fly|Ride"] = 598.91, ["Neon|Fly|Ride"] = 3009.57, ["Mega|Fly|Ride"] = 9574.39}},
    ["rbxassetid://101160794933271"] = {name = "Matcha Cat", prices = {["default"] = 249.37, ["Ride"] = 325.26, ["Fly|Ride"] = 392.44, ["Neon"] = 1500.32, ["Neon|Ride"] = 1476.74, ["Neon|Fly|Ride"] = 1586.86, ["Mega|Fly|Ride"] = 7199.76}},
    ["rbxassetid://13892790514"] = {name = "Urban Egg", prices = {["default"] = 48.57}},
    ["rbxassetid://13104109574"] = {name = "Spinosaurus", prices = {["default"] = 29.18, ["Ride"] = 47.14, ["Fly|Ride"] = 98.44, ["Neon|Ride"] = 205.11, ["Neon|Fly|Ride"] = 464.94, ["Mega|Ride"] = 1368.38, ["Mega|Fly|Ride"] = 1038.19}},
    ["rbxassetid://4115248712"] = {name = "Shadow Dragon", prices = {["default"] = 71092.88, ["Fly|Ride"] = 17979.93, ["Neon|Fly|Ride"] = 38062.5, ["Mega|Fly|Ride"] = 89250}},
    ["rbxassetid://71457697470071"] = {name = "Arctic Dusk Dragon", prices = {["default"] = 336.53, ["Fly"] = 446.11, ["Ride"] = 342.53, ["Fly|Ride"] = 410.21, ["Neon"] = 1365.98, ["Neon|Fly"] = 1240.04, ["Neon|Ride"] = 919.88, ["Neon|Fly|Ride"] = 1128.35, ["Mega"] = 6154.53, ["Mega|Fly|Ride"] = 3850.97}},
    ["rbxassetid://8566683457"] = {name = "Giant Gold Scarab", prices = {["default"] = 159.49, ["Fly"] = 525, ["Ride"] = 165.38, ["Fly|Ride"] = 203.44, ["Mega|Fly|Ride"] = 4103.03}},
    ["rbxassetid://16116063171"] = {name = "Rainbow Dragon", prices = {["default"] = 157.5, ["Fly"] = 262.49, ["Ride"] = 124.69, ["Fly|Ride"] = 200.82, ["Neon|Ride"] = 547.56, ["Neon|Fly|Ride"] = 464.94, ["Mega|Fly|Ride"] = 2461.82}},
    ["rbxassetid://9938967130"] = {name = "Black Chow-Chow", prices = {["default"] = 14.54, ["Fly"] = 94.5, ["Ride"] = 33.67, ["Fly|Ride"] = 108.94, ["Neon"] = 393.75, ["Neon|Ride"] = 140.44, ["Neon|Fly|Ride"] = 272.87, ["Mega"] = 695.09, ["Mega|Fly|Ride"] = 629.83}},
    ["rbxassetid://116467943923352"] = {name = "Haetae", prices = {["default"] = 5019.19, ["Ride"] = 5019.81, ["Fly|Ride"] = 5047.77, ["Neon"] = 20509.93, ["Neon|Fly|Ride"] = 27353.73, ["Mega|Fly|Ride"] = 61991.91}},
    ["rbxassetid://6531232495"] = {name = "Peacock", prices = {["default"] = 24.68, ["Fly"] = 278.55, ["Ride"] = 34, ["Fly|Ride"] = 58.73, ["Neon"] = 337.32, ["Neon|Ride"] = 343.88, ["Neon|Fly|Ride"] = 263.86, ["Mega|Fly|Ride"] = 819.59}},
    ["rbxassetid://12557346746"] = {name = "Naga Dragon", prices = {["default"] = 43.31, ["Ride"] = 56.26, ["Fly|Ride"] = 115.5, ["Neon"] = 403.96, ["Neon|Ride"] = 205.11, ["Neon|Fly|Ride"] = 389.81, ["Mega|Fly|Ride"] = 1372.88}},
    ["rbxassetid://127697654557674"] = {name = "Candicorn", prices = {["default"] = 720.57, ["Fly"] = 918.75, ["Ride"] = 732.38, ["Fly|Ride"] = 886.05, ["Neon|Fly|Ride"] = 2411.56, ["Mega"] = 7445.95, ["Mega|Fly"] = 7445.95, ["Mega|Fly|Ride"] = 7445.95}},
    ["rbxassetid://4281674580"] = {name = "King Bee", prices = {["default"] = 12.88, ["Fly"] = 34.89, ["Ride"] = 25.73, ["Fly|Ride"] = 47.77, ["Neon"] = 131.25, ["Neon|Ride"] = 129.94, ["Neon|Fly|Ride"] = 137.47, ["Mega|Fly|Ride"] = 853.17}},
    ["rbxassetid://17822543288"] = {name = "Blue Betta Fish", prices = {["default"] = 15.4, ["Ride"] = 19.69, ["Fly|Ride"] = 77.89, ["Neon"] = 80, ["Neon|Ride"] = 116.82, ["Neon|Fly|Ride"] = 178.5, ["Mega"] = 406.21}},
    ["rbxassetid://102300026415493"] = {name = "Moose Calf", prices = {["default"] = 94.49, ["Ride"] = 115.89, ["Fly|Ride"] = 137.44, ["Neon"] = 615.32, ["Neon|Ride"] = 752.73, ["Neon|Fly|Ride"] = 594.96, ["Mega|Fly|Ride"] = 2597.22}},
    ["rbxassetid://78419574214060"] = {name = "Christmas Spirit", prices = {["default"] = 26.73, ["Fly"] = 137.44, ["Ride"] = 55.4, ["Fly|Ride"] = 164.9, ["Neon"] = 101.06, ["Neon|Fly"] = 102.75, ["Neon|Ride"] = 118.26, ["Neon|Fly|Ride"] = 223.13, ["Mega"] = 254.63, ["Mega|Fly"] = 738.09, ["Mega|Ride"] = 276.28, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://130642623661179"] = {name = "Cryptid", prices = {["default"] = 5035.59, ["Ride"] = 3883.64, ["Fly|Ride"] = 4000.5, ["Neon|Ride"] = 12199.31, ["Neon|Fly|Ride"] = 9581.25, ["Mega"] = 61544.11, ["Mega|Fly|Ride"] = 35334.95}},
    ["rbxassetid://101130894252942"] = {name = "Peach Owl", prices = {["default"] = 77.44, ["Ride"] = 78.75, ["Fly|Ride"] = 193.66, ["Neon"] = 393.32, ["Neon|Ride"] = 246.14, ["Neon|Fly|Ride"] = 410.31, ["Mega|Ride"] = 1017.56, ["Mega|Fly|Ride"] = 1813.25}},
    ["rbxassetid://4440866649"] = {name = "Owl", prices = {["default"] = 7612.5, ["Ride"] = 6857.82, ["Fly|Ride"] = 6339.37, ["Neon|Ride"] = 18869.15, ["Neon|Fly|Ride"] = 17061.19, ["Mega|Fly|Ride"] = 76931.4}},
    ["rbxassetid://6836687169"] = {name = "Golden Griffin", prices = {["default"] = 2.62, ["Fly"] = 16.27, ["Ride"] = 16.94, ["Fly|Ride"] = 41.99, ["Neon"] = 24.63, ["Neon|Fly"] = 62.62, ["Neon|Ride"] = 49.98, ["Neon|Fly|Ride"] = 84.18, ["Mega"] = 449.84, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://76198828333546"] = {name = "Hippogriff", prices = {["default"] = 13.97, ["Fly"] = 26.17, ["Ride"] = 26.25, ["Fly|Ride"] = 49.69, ["Neon"] = 135.38, ["Neon|Fly"] = 226.65, ["Neon|Ride"] = 190.76, ["Neon|Fly|Ride"] = 167.99, ["Mega|Ride"] = 1247.55, ["Mega|Fly|Ride"] = 708.81}},
    ["rbxassetid://112567270488274"] = {name = "Crystal Egg", prices = {["default"] = 3.56}},
    ["rbxassetid://10695038557"] = {name = "Maneki-Neko", prices = {["default"] = 12.99, ["Ride"] = 33.24, ["Fly|Ride"] = 116.01, ["Neon"] = 271.23, ["Neon|Ride"] = 137.44, ["Neon|Fly|Ride"] = 191.83, ["Mega"] = 1049.9, ["Mega|Ride"] = 958.07, ["Mega|Fly|Ride"] = 771.83}},
    ["rbxassetid://16911441596"] = {name = "Royal Capuchin Monkey", prices = {["default"] = 28.88, ["Fly"] = 262.5, ["Ride"] = 43.09, ["Fly|Ride"] = 99.73, ["Neon"] = 201.01, ["Neon|Ride"] = 210, ["Neon|Fly|Ride"] = 310.36, ["Mega"] = 945, ["Mega|Fly|Ride"] = 1099.88}},
    ["rbxassetid://6963387165"] = {name = "Cobra", prices = {["default"] = 10.61, ["Fly"] = 19.69, ["Ride"] = 19.69, ["Fly|Ride"] = 37.88, ["Neon|Ride"] = 113.85, ["Neon|Fly|Ride"] = 175.18, ["Mega"] = 654.94, ["Mega|Ride"] = 580.02, ["Mega|Fly|Ride"] = 507.41}},
    ["rbxassetid://3409444171"] = {name = "Safari Egg", prices = {["default"] = 8305.49}},
    ["rbxassetid://3743740864"] = {name = "Jungle Egg", prices = {["default"] = 2624.96}},
    ["rbxassetid://10321884333"] = {name = "Japan Egg", prices = {["default"] = 27.9}},
    ["rbxassetid://11109117895"] = {name = "Diamond Amazon", prices = {["default"] = 177.09, ["Ride"] = 196.88, ["Fly|Ride"] = 183.75, ["Neon|Fly|Ride"] = 1025.77, ["Mega|Fly|Ride"] = 5539.08}},
    ["rbxassetid://102144672439627"] = {name = "Berry Cool Cube", prices = {["default"] = 13.13, ["Fly"] = 129.23, ["Ride"] = 40.07, ["Fly|Ride"] = 105, ["Neon"] = 139.5, ["Neon|Ride"] = 114.47, ["Neon|Fly|Ride"] = 265.13, ["Mega|Ride"] = 929.88, ["Mega|Fly|Ride"] = 954.99}},
    ["rbxassetid://17183502626"] = {name = "Garden Egg", prices = {["default"] = 15.4}},
    ["rbxassetid://16722909609"] = {name = "Striped Eggy", prices = {["default"] = 4.87, ["Ride"] = 29.22, ["Fly|Ride"] = 80, ["Neon"] = 81.03, ["Neon|Ride"] = 94.37, ["Neon|Fly|Ride"] = 140.24, ["Mega|Fly|Ride"] = 820.61}},
    ["rbxassetid://4440866155"] = {name = "Farm Egg", prices = {["default"] = 3051.63}},
    ["rbxassetid://88361277330582"] = {name = "Naughty Mistletroll", prices = {["default"] = 179.18, ["Fly"] = 410.21, ["Ride"] = 204.09, ["Fly|Ride"] = 301.88, ["Neon"] = 701.37, ["Neon|Ride"] = 918.75, ["Mega|Ride"] = 3145.99, ["Mega|Fly|Ride"] = 3420.89}},
    ["rbxassetid://12778919221"] = {name = "Yule Log Dog", prices = {["default"] = 73.48, ["Ride"] = 140.44, ["Fly|Ride"] = 211.32, ["Neon"] = 684.03, ["Neon|Ride"] = 410.21, ["Neon|Fly|Ride"] = 1435.35, ["Mega|Fly|Ride"] = 2188.96}},
    ["rbxassetid://13104112588"] = {name = "Owlbear", prices = {["default"] = 183.73, ["Fly"] = 265.49, ["Ride"] = 207.38, ["Fly|Ride"] = 255.59, ["Neon"] = 897.75, ["Neon|Ride"] = 842.63, ["Neon|Fly|Ride"] = 849.79, ["Mega|Fly|Ride"] = 3719.48}},
    ["rbxassetid://11192035130"] = {name = "Undead Jousting Horse", prices = {["default"] = 1967.44, ["Fly"] = 2461.2, ["Ride"] = 1968.75, ["Fly|Ride"] = 1836.4, ["Neon"] = 8136.32, ["Neon|Fly|Ride"] = 6028.32, ["Mega|Fly|Ride"] = 24481.64}},
    ["rbxassetid://106575933009346"] = {name = "Fairytale Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://96044273915258"] = {name = "Endangered Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://129993159377616"] = {name = "Peahen", prices = {["default"] = 17.04, ["Ride"] = 56.8, ["Fly|Ride"] = 69.02, ["Neon"] = 170.24, ["Neon|Ride"] = 202.23, ["Neon|Fly|Ride"] = 260.55, ["Mega"] = 922.17, ["Mega|Ride"] = 853.17, ["Mega|Fly|Ride"] = 682.5}},
    ["rbxassetid://12732812236"] = {name = "Tio De Nadal", prices = {["default"] = 1367.85, ["Ride"] = 924.06, ["Fly|Ride"] = 922.97, ["Neon|Fly|Ride"] = 4029.82}},
    ["rbxassetid://13936755787"] = {name = "Wrapped Doll", prices = {["default"] = 52.32}},
    ["rbxassetid://136441478335419"] = {name = "Emberlight", prices = {["default"] = 14.97, ["Ride"] = 39.38, ["Fly|Ride"] = 680.94, ["Neon"] = 101.06, ["Neon|Ride"] = 117.95, ["Neon|Fly|Ride"] = 302.6, ["Mega"] = 480.27, ["Mega|Ride"] = 464.94, ["Mega|Fly|Ride"] = 700.88}},
    ["rbxassetid://17120184484"] = {name = "Rosy Maple Moth", prices = {["default"] = 4.11, ["Fly"] = 162.24, ["Ride"] = 27.56, ["Fly|Ride"] = 94.83, ["Neon"] = 62.77, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 273.9, ["Mega"] = 918.75, ["Mega|Ride"] = 355.95, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://15932251755"] = {name = "Royal Desert Egg", prices = {["default"] = 72.19}},
    ["rbxassetid://8143039289"] = {name = "Golden Walrus", prices = {["default"] = 14.55, ["Ride"] = 22.32, ["Fly|Ride"] = 80, ["Neon"] = 191.79, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 170.63, ["Mega|Ride"] = 820.61, ["Mega|Fly|Ride"] = 1506.86}},
    ["rbxassetid://12187391973"] = {name = "Firefly", prices = {["default"] = 21.49, ["Fly"] = 75.9, ["Ride"] = 41.04, ["Fly|Ride"] = 67.33, ["Neon"] = 232.8, ["Neon|Ride"] = 294.34, ["Neon|Fly|Ride"] = 410.31, ["Mega"] = 877.03, ["Mega|Ride"] = 1743.52, ["Mega|Fly|Ride"] = 958.07}},
    ["rbxassetid://3743647944"] = {name = "Parrot", prices = {["default"] = 7748.44, ["Fly"] = 10938.98, ["Ride"] = 5250, ["Fly|Ride"] = 5145, ["Neon|Fly|Ride"] = 11550, ["Mega|Fly|Ride"] = 35437.5}},
    ["rbxassetid://128454622445076"] = {name = "Dimension Drifter", prices = {["default"] = 11.61, ["Fly"] = 57.29, ["Ride"] = 34.13, ["Fly|Ride"] = 105, ["Neon"] = 83.42, ["Neon|Ride"] = 62.77, ["Neon|Fly|Ride"] = 191.83, ["Mega"] = 520.74, ["Mega|Ride"] = 582.75, ["Mega|Fly|Ride"] = 456.75}},
    ["rbxassetid://15931761708"] = {name = "Desert Egg", prices = {["default"] = 21.17}},
    ["rbxassetid://17747001377"] = {name = "Majestic Pony", prices = {["default"] = 94.64, ["Fly"] = 363.04, ["Ride"] = 135.19, ["Fly|Ride"] = 210, ["Neon"] = 525, ["Neon|Ride"] = 378, ["Neon|Fly|Ride"] = 733.44, ["Mega"] = 2879.59, ["Mega|Ride"] = 2051.52, ["Mega|Fly|Ride"] = 1926.64}},
    ["rbxassetid://94487786469241"] = {name = "Vanilla Penguin", prices = {["default"] = 46.5, ["Fly"] = 124.31, ["Ride"] = 108.72, ["Fly|Ride"] = 273.82, ["Neon"] = 262.5, ["Neon|Ride"] = 272.37, ["Neon|Fly|Ride"] = 396.99, ["Mega"] = 2324.67, ["Mega|Ride"] = 2769.55, ["Mega|Fly|Ride"] = 1650.53}},
    ["rbxassetid://6498256211"] = {name = "Octopus", prices = {["default"] = 19.32, ["Fly"] = 70.47, ["Ride"] = 31.4, ["Fly|Ride"] = 65.63, ["Neon"] = 128.77, ["Neon|Ride"] = 187.74, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 1016.21, ["Mega|Ride"] = 835.99, ["Mega|Fly|Ride"] = 656.23}},
    ["rbxassetid://110654583245787"] = {name = "Sea Turtle", prices = {["default"] = 3.94, ["Fly"] = 65.63, ["Ride"] = 27.71, ["Fly|Ride"] = 91.84, ["Neon"] = 33.1, ["Neon|Ride"] = 62.87, ["Neon|Fly|Ride"] = 178.5, ["Mega"] = 171, ["Mega|Fly"] = 254.63, ["Mega|Ride"] = 220.52, ["Mega|Fly|Ride"] = 307.51}},
    ["rbxassetid://8596147681"] = {name = "Squid", prices = {["default"] = 13.65, ["Ride"] = 31.5, ["Fly|Ride"] = 65.63, ["Neon"] = 115.89, ["Neon|Ride"] = 120.75, ["Neon|Fly|Ride"] = 219.52, ["Mega"] = 720.66, ["Mega|Ride"] = 422.63, ["Mega|Fly|Ride"] = 643.16}},
    ["rbxassetid://9226723356"] = {name = "Winged Horse", prices = {["default"] = 18.8, ["Fly"] = 31.5, ["Ride"] = 30.78, ["Fly|Ride"] = 52.5, ["Neon"] = 208.71, ["Neon|Ride"] = 164.1, ["Neon|Fly|Ride"] = 177.19, ["Mega|Fly|Ride"] = 707.79}},
    ["rbxassetid://4733386633"] = {name = "Aussie Egg", prices = {["default"] = 223.12}},
    ["rbxassetid://121951206021245"] = {name = "Kiwi Kiwi", prices = {["default"] = 29.4, ["Ride"] = 291.38, ["Fly|Ride"] = 273.78, ["Neon"] = 147.62, ["Neon|Ride"] = 820.41, ["Mega"] = 820.61, ["Mega|Fly|Ride"] = 786.19}},
    ["rbxassetid://9602676771"] = {name = "Diamond Albatross", prices = {["default"] = 223.33, ["Fly|Ride"] = 1550.56}},
    ["rbxassetid://79965389436178"] = {name = "Sushi Penguin", prices = {["default"] = 45.83, ["Fly"] = 212.02, ["Ride"] = 122.06, ["Fly|Ride"] = 235.89, ["Neon"] = 259.86, ["Neon|Ride"] = 295.32, ["Neon|Fly|Ride"] = 525, ["Mega"] = 905.62, ["Mega|Ride"] = 1020.64, ["Mega|Fly|Ride"] = 1208.36}},
    ["rbxassetid://126930507653265"] = {name = "Grim Dragon", prices = {["default"] = 984.38, ["Fly"] = 1334.47, ["Ride"] = 985.85, ["Fly|Ride"] = 1029, ["Neon|Fly"] = 4021.67, ["Neon|Ride"] = 3145.21, ["Neon|Fly|Ride"] = 2625, ["Mega|Fly|Ride"] = 12500.86}},
    ["rbxassetid://87328715505907"] = {name = "Silverback Gorilla", prices = {["default"] = 446.25, ["Fly"] = 684.03, ["Ride"] = 433.13, ["Fly|Ride"] = 486.94, ["Neon"] = 2871.41, ["Neon|Ride"] = 2051.01, ["Neon|Fly|Ride"] = 1916.12, ["Mega|Fly|Ride"] = 7217.44}},
    ["rbxassetid://12733311267"] = {name = "Fool Egg", prices = {["default"] = 71.16}},
    ["rbxassetid://139472202653768"] = {name = "Admin Abuse Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://8938702589"] = {name = "Hawk", prices = {["default"] = 14.44, ["Fly"] = 55.4, ["Ride"] = 25.73, ["Fly|Ride"] = 50.16, ["Neon"] = 78.73, ["Neon|Fly"] = 145.69, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 157.4, ["Mega"] = 437.26, ["Mega|Ride"] = 684.2, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://8938703243"] = {name = "Fallow Deer", prices = {["default"] = 311.07, ["Fly"] = 410.21, ["Ride"] = 337.32, ["Fly|Ride"] = 436.87, ["Neon"] = 1086.01, ["Neon|Ride"] = 918.75, ["Neon|Fly|Ride"] = 1115, ["Mega|Fly|Ride"] = 2756.25}},
    ["rbxassetid://4822753124"] = {name = "Diamond Egg", prices = {["default"] = 19.49}},
    ["rbxassetid://114823420678686"] = {name = "Dragonfruit Fox", prices = {["default"] = 150.94, ["Ride"] = 183.23, ["Fly|Ride"] = 304.49, ["Neon"] = 1340.33, ["Neon|Ride"] = 971.25, ["Neon|Fly|Ride"] = 1739.07, ["Mega"] = 3009.57, ["Mega|Ride"] = 11668.96, ["Mega|Fly|Ride"] = 2999.32}},
    ["rbxassetid://102844319137806"] = {name = "Pineapple Owl", prices = {["default"] = 127.32, ["Ride"] = 125.89, ["Fly|Ride"] = 205.11, ["Neon"] = 684.03, ["Neon|Ride"] = 1005.38, ["Neon|Fly|Ride"] = 913.5, ["Mega|Ride"] = 3420.89, ["Mega|Fly|Ride"] = 2408.47}},
    ["rbxassetid://82296650763619"] = {name = "Angus Bull", prices = {["default"] = 4.98, ["Ride"] = 29.75, ["Fly|Ride"] = 167.18, ["Neon"] = 26.69, ["Neon|Ride"] = 85.31, ["Neon|Fly|Ride"] = 226.71, ["Mega"] = 302.6, ["Mega|Ride"] = 510.27, ["Mega|Fly|Ride"] = 818.56}},
    ["rbxassetid://12917347755"] = {name = "Sunrise Duckling", prices = {["default"] = 18.47, ["Fly"] = 63.03, ["Ride"] = 26.64, ["Fly|Ride"] = 71.77, ["Neon"] = 177.19, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 310.36, ["Mega|Ride"] = 799.08, ["Mega|Fly|Ride"] = 615.47}},
    ["rbxassetid://139217275750567"] = {name = "Winter Buck", prices = {["default"] = 18.37, ["Fly"] = 131.25, ["Ride"] = 44.63, ["Fly|Ride"] = 116.92, ["Neon"] = 105, ["Neon|Ride"] = 101.54, ["Neon|Fly|Ride"] = 255.94, ["Mega"] = 498.65, ["Mega|Ride"] = 504, ["Mega|Fly|Ride"] = 488.28}},
    ["rbxassetid://114331718573822"] = {name = "Mochi Meow", prices = {["default"] = 3.94, ["Fly"] = 157.5, ["Ride"] = 52.5, ["Fly|Ride"] = 170.63, ["Neon"] = 29.42, ["Neon|Fly"] = 232.47, ["Neon|Ride"] = 61.69, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 164.07, ["Mega|Fly"] = 192.86, ["Mega|Ride"] = 178.49, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://112560568221286"] = {name = "Strawberry Penguin", prices = {["default"] = 316.94, ["Ride"] = 342.53, ["Fly|Ride"] = 377.52, ["Neon"] = 1610.04, ["Neon|Ride"] = 1475.71, ["Neon|Fly|Ride"] = 1424.07, ["Mega|Fly|Ride"] = 5197.5}},
    ["rbxassetid://116818749091454"] = {name = "Dango Penguins", prices = {["default"] = 177.08, ["Ride"] = 237.62, ["Fly|Ride"] = 263.82, ["Neon"] = 1665.78, ["Neon|Ride"] = 721.87, ["Neon|Fly|Ride"] = 705.59, ["Mega"] = 9847.23, ["Mega|Ride"] = 3281.25, ["Mega|Fly|Ride"] = 3884.53}},
    ["rbxassetid://12480100169"] = {name = "Tree Kangaroo", prices = {["default"] = 134.92, ["Ride"] = 107.63, ["Fly|Ride"] = 185.99, ["Neon|Ride"] = 575.29, ["Neon|Fly|Ride"] = 498.75, ["Mega|Fly|Ride"] = 1801.11}},
    ["rbxassetid://75106733244906"] = {name = "Golden Hummingbird", prices = {["default"] = 11.82, ["Ride"] = 58.24, ["Fly|Ride"] = 273.82, ["Neon|Ride"] = 590.39, ["Neon|Fly|Ride"] = 479.04, ["Mega|Ride"] = 615.47, ["Mega|Fly|Ride"] = 1846.38}},
    ["rbxassetid://76354526914534"] = {name = "Frostclaw", prices = {["default"] = 15.65, ["Fly"] = 75.63, ["Ride"] = 48.21, ["Fly|Ride"] = 100.51, ["Neon"] = 77.39, ["Neon|Ride"] = 102.55, ["Neon|Fly|Ride"] = 157.99, ["Mega"] = 410.31, ["Mega|Fly"] = 525, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://121712578077668"] = {name = "Blue Whale", prices = {["default"] = 2.1, ["Fly"] = 52.45, ["Ride"] = 22.89, ["Fly|Ride"] = 82.06, ["Neon"] = 19.59, ["Neon|Ride"] = 35.25, ["Neon|Fly|Ride"] = 132.18, ["Mega"] = 112.79, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 314.9}},
    ["rbxassetid://76035105070441"] = {name = "Fairy Bat Dragon", prices = {["default"] = 787.5, ["Fly"] = 1080.9, ["Ride"] = 982.8, ["Fly|Ride"] = 1053.94, ["Neon|Fly"] = 3409.81, ["Neon|Ride"] = 3281.61, ["Neon|Fly|Ride"] = 2428.13, ["Mega|Fly|Ride"] = 9710.81}},
    ["rbxassetid://105346917979221"] = {name = "Aurora Fox", prices = {["Ride"] = 597.19, ["Fly|Ride"] = 547.63, ["Neon|Ride"] = 1534.16, ["Neon|Fly|Ride"] = 1612.49, ["Mega"] = 10256.51, ["Mega|Fly|Ride"] = 6271.42}},
    ["rbxassetid://120475294381736"] = {name = "Glormy Hound", prices = {["default"] = 82.43, ["Fly"] = 137.44, ["Ride"] = 128.86, ["Fly|Ride"] = 205.11, ["Neon"] = 342.53, ["Neon|Ride"] = 304.5, ["Neon|Fly|Ride"] = 460.58, ["Mega|Fly|Ride"] = 1901.76}},
    ["rbxassetid://15570696642"] = {name = "Glacier Kitsune", prices = {["default"] = 335.31, ["Fly|Ride"] = 383.55, ["Neon|Fly|Ride"] = 2051.52, ["Mega"] = 10257.53, ["Mega|Fly|Ride"] = 5471.38}},
    ["rbxassetid://16548792521"] = {name = "Golden Hamster", prices = {["default"] = 20.67, ["Fly"] = 72.82, ["Ride"] = 32.82, ["Fly|Ride"] = 71.48, ["Neon"] = 169.32, ["Neon|Ride"] = 216.18, ["Neon|Fly|Ride"] = 236.25, ["Mega|Fly|Ride"] = 774.13}},
    ["rbxassetid://12935498875"] = {name = "Field Mouse", prices = {["default"] = 236.25, ["Ride"] = 310.36, ["Fly|Ride"] = 472.4, ["Neon"] = 758.33, ["Neon|Ride"] = 942.38, ["Neon|Fly|Ride"] = 929.88, ["Mega"] = 4082.79, ["Mega|Ride"] = 4240.47, ["Mega|Fly|Ride"] = 3818.31}},
    ["rbxassetid://16548793509"] = {name = "Diamond Hamster", prices = {["default"] = 53.71, ["Fly"] = 125.98, ["Ride"] = 72.14, ["Fly|Ride"] = 132.53, ["Neon|Ride"] = 449.77, ["Neon|Fly|Ride"] = 273.9, ["Mega|Fly|Ride"] = 1368.38}},
    ["rbxassetid://78823655016197"] = {name = "Jekyll Hydra", prices = {["default"] = 2139.96, ["Ride"] = 2231.25, ["Fly|Ride"] = 1947.9, ["Neon|Ride"] = 10847.65, ["Neon|Fly|Ride"] = 6359.69, ["Mega"] = 49236.11, ["Mega|Fly|Ride"] = 23250.73}},
    ["rbxassetid://96735424372947"] = {name = "Glormy Dolphin", prices = {["default"] = 14.68, ["Fly"] = 82.17, ["Ride"] = 91.87, ["Fly|Ride"] = 115.76, ["Neon"] = 60.38, ["Neon|Fly"] = 230.53, ["Neon|Ride"] = 103.69, ["Neon|Fly|Ride"] = 227.85, ["Mega"] = 322.67, ["Mega|Fly"] = 561.75, ["Mega|Ride"] = 326.82, ["Mega|Fly|Ride"] = 462.77}},
    ["rbxassetid://16898331554"] = {name = "Princess Capuchin Monkey", prices = {["default"] = 50.04, ["Ride"] = 81.03, ["Fly|Ride"] = 102.38, ["Neon"] = 277.5, ["Neon|Ride"] = 305.62, ["Neon|Fly|Ride"] = 304.5, ["Mega"] = 1022.69, ["Mega|Fly|Ride"] = 1024.74}},
    ["rbxassetid://4315743450"] = {name = "Queen Bee", prices = {["default"] = 74.82, ["Fly"] = 91.85, ["Ride"] = 85.29, ["Fly|Ride"] = 97.01, ["Neon|Ride"] = 452.25, ["Neon|Fly|Ride"] = 465.71, ["Mega|Fly|Ride"] = 1823.95}},
    ["rbxassetid://5067924789"] = {name = "Monkey King", prices = {["default"] = 3416.55, ["Fly|Ride"] = 1170.44}},
    ["rbxassetid://10284283561"] = {name = "Black-Chested Pheasant", prices = {["default"] = 428.44, ["Fly"] = 818.35, ["Ride"] = 670.69, ["Fly|Ride"] = 656.25, ["Neon|Fly|Ride"] = 2789.61}},
    ["rbxassetid://15504845135"] = {name = "Candy Hare", prices = {["default"] = 78.75, ["Fly"] = 202.27, ["Ride"] = 137.82, ["Fly|Ride"] = 196.88, ["Neon"] = 446.8, ["Neon|Fly"] = 615.32, ["Neon|Ride"] = 472.5, ["Neon|Fly|Ride"] = 612.8, ["Mega"] = 4103.03, ["Mega|Ride"] = 4103.03, ["Mega|Fly|Ride"] = 2709.26}},
    ["rbxassetid://11758575657"] = {name = "Lunar Moon Bear", prices = {["default"] = 8.35, ["Ride"] = 26.25, ["Fly|Ride"] = 78.66, ["Neon"] = 87.94, ["Neon|Fly"] = 137.44, ["Neon|Ride"] = 101.13, ["Neon|Fly|Ride"] = 196.88, ["Mega|Ride"] = 762.72, ["Mega|Fly|Ride"] = 1368.38}},
    ["rbxassetid://10318105392"] = {name = "Green Butterfly", prices = {["default"] = 41.03, ["Fly"] = 54.53, ["Ride"] = 48.56, ["Fly|Ride"] = 104.67, ["Neon"] = 196.88, ["Neon|Fly"] = 410.21, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 288.75, ["Mega|Ride"] = 1189.9, ["Mega|Fly|Ride"] = 1010.63}},
    ["rbxassetid://84813815094145"] = {name = "Mermicorn", prices = {["default"] = 748.13, ["Ride"] = 874.13, ["Fly|Ride"] = 892.5, ["Neon"] = 3008.82, ["Neon|Ride"] = 2362.5, ["Neon|Fly|Ride"] = 2139.37, ["Mega|Fly|Ride"] = 9723}},
    ["rbxassetid://4507163112"] = {name = "Christmas Egg", prices = {["default"] = 682.4}},
    ["rbxassetid://14689005829"] = {name = "Blazing Lion", prices = {["default"] = 6015.84, ["Ride"] = 4987.5, ["Fly|Ride"] = 4984.88, ["Neon"] = 42000, ["Neon|Ride"] = 29391.75, ["Neon|Fly|Ride"] = 23934.9, ["Mega|Fly|Ride"] = 87531.53}},
    ["rbxassetid://123647431892215"] = {name = "Hero Gibbon", prices = {["default"] = 341.16, ["Fly"] = 496.13, ["Ride"] = 393.75, ["Neon"] = 1640.81, ["Neon|Ride"] = 2051.01, ["Neon|Fly|Ride"] = 2051.52, ["Mega"] = 6153.5, ["Mega|Fly|Ride"] = 6154.53}},
    ["rbxassetid://106457467498193"] = {name = "Scorching Kaijunior", prices = {["default"] = 83.6, ["Ride"] = 96.42, ["Fly|Ride"] = 336, ["Neon"] = 420, ["Neon|Ride"] = 647.11, ["Neon|Fly|Ride"] = 547.77, ["Mega|Fly|Ride"] = 2119.51}},
    ["rbxassetid://10926054030"] = {name = "Chimera", prices = {["default"] = 19.1, ["Fly"] = 92.31, ["Ride"] = 37.69, ["Fly|Ride"] = 102.27, ["Neon"] = 113.3, ["Neon|Fly"] = 1240.04, ["Neon|Ride"] = 89.25, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 655.48, ["Mega|Ride"] = 820.61, ["Mega|Fly|Ride"] = 630}},
    ["rbxassetid://9490242683"] = {name = "Golden King Penguin", prices = {["default"] = 11.82, ["Fly"] = 39.38, ["Ride"] = 21, ["Fly|Ride"] = 44.35, ["Neon"] = 205.11, ["Neon|Ride"] = 315.32, ["Neon|Fly|Ride"] = 177.19, ["Mega"] = 1312.5, ["Mega|Fly|Ride"] = 2174.61}},
    ["rbxassetid://17119623510"] = {name = "Mushroom Friend", prices = {["default"] = 18.65, ["Ride"] = 40.06, ["Fly|Ride"] = 140.44, ["Neon"] = 115.5, ["Neon|Ride"] = 124.69, ["Neon|Fly|Ride"] = 211.32, ["Mega"] = 645.75, ["Mega|Ride"] = 615.47, ["Mega|Fly|Ride"] = 603.75}},
    ["rbxassetid://17174656536"] = {name = "Golden Tortoise Beetle", prices = {["default"] = 4.19, ["Fly"] = 55.4, ["Ride"] = 21.93, ["Fly|Ride"] = 48.57, ["Neon"] = 31.38, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 136.5, ["Mega"] = 273.9, ["Mega|Ride"] = 234.94, ["Mega|Fly|Ride"] = 357}},
    ["rbxassetid://84310117840681"] = {name = "Super Saru", prices = {["default"] = 29.4, ["Fly"] = 90.57, ["Ride"] = 39.38, ["Fly|Ride"] = 183.58, ["Neon"] = 172.05, ["Neon|Fly"] = 820.41, ["Neon|Ride"] = 164.07, ["Neon|Fly|Ride"] = 364.16, ["Mega"] = 820.61, ["Mega|Ride"] = 670.86, ["Mega|Fly|Ride"] = 820.61}},
    ["rbxassetid://77177643028234"] = {name = "Phantom Dragon", prices = {["default"] = 426.57, ["Fly"] = 464.94, ["Ride"] = 405.57, ["Fly|Ride"] = 471.19, ["Neon"] = 1361.88, ["Neon|Ride"] = 1368.02, ["Neon|Fly|Ride"] = 1312.5, ["Mega"] = 7875, ["Mega|Fly"] = 5050.81, ["Mega|Fly|Ride"] = 5050.81}},
    ["rbxassetid://6245080265"] = {name = "Metal Ox", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 15.06, ["Fly|Ride"] = 45.13, ["Neon"] = 18.38, ["Neon|Ride"] = 32.68, ["Neon|Fly|Ride"] = 86.44, ["Mega"] = 820.61, ["Mega|Ride"] = 616.35, ["Mega|Fly|Ride"] = 243.77}},
    ["rbxassetid://3181728194"] = {name = "Unicorn", prices = {["default"] = 52.5, ["Fly"] = 138.46, ["Ride"] = 83.32, ["Fly|Ride"] = 150.61, ["Neon"] = 231, ["Neon|Fly"] = 285.1, ["Neon|Ride"] = 190.31, ["Neon|Fly|Ride"] = 249.38, ["Mega"] = 649.69, ["Mega|Ride"] = 582.64, ["Mega|Fly|Ride"] = 575.88}},
    ["rbxassetid://4708551322"] = {name = "Turtle", prices = {["default"] = 954.63, ["Fly"] = 999.62, ["Ride"] = 885.94, ["Fly|Ride"] = 819, ["Neon|Ride"] = 1603.88, ["Neon|Fly|Ride"] = 1561.88, ["Mega|Fly|Ride"] = 3806.25}},
    ["rbxassetid://5721844281"] = {name = "T-Rex", prices = {["default"] = 34.01, ["Fly"] = 91.88, ["Ride"] = 47.67, ["Fly|Ride"] = 75.9, ["Neon"] = 137.44, ["Neon|Ride"] = 216.57, ["Neon|Fly|Ride"] = 257.25, ["Mega"] = 1575, ["Mega|Fly|Ride"] = 767.82}},
    ["rbxassetid://16127039676"] = {name = "Midnight Dragon", prices = {["default"] = 262.5, ["Fly"] = 339.71, ["Ride"] = 314.01, ["Fly|Ride"] = 288.72, ["Neon|Ride"] = 1778.22, ["Neon|Fly|Ride"] = 1312.49}},
    ["rbxassetid://7734925172"] = {name = "Halloween White Ghost Dragon", prices = {["default"] = 196.88, ["Ride"] = 157.4, ["Fly|Ride"] = 236.24, ["Neon|Ride"] = 807.19, ["Neon|Fly|Ride"] = 772.16, ["Mega|Fly|Ride"] = 3473.01}},
    ["rbxassetid://18508016126"] = {name = "Bush Elephant", prices = {["default"] = 720.3, ["Ride"] = 830.82, ["Fly|Ride"] = 787.5, ["Neon|Ride"] = 3145.21, ["Neon|Fly|Ride"] = 2981.87, ["Mega|Fly|Ride"] = 7611.19}},
    ["rbxassetid://78218981883168"] = {name = "Coconut Friend", prices = {["default"] = 23.37, ["Ride"] = 43.21, ["Fly|Ride"] = 110.25, ["Neon"] = 78.08, ["Neon|Fly"] = 278.93, ["Neon|Ride"] = 106.66, ["Neon|Fly|Ride"] = 269.68, ["Mega"] = 354.38, ["Mega|Ride"] = 362.6, ["Mega|Fly|Ride"] = 519.75}},
    ["rbxassetid://4184878050"] = {name = "Evil Unicorn", prices = {["default"] = 3465, ["Fly"] = 3543.75, ["Ride"] = 3924.38, ["Fly|Ride"] = 3377.06, ["Neon"] = 13673.98, ["Neon|Fly|Ride"] = 6825, ["Mega|Fly|Ride"] = 24832.07}},
    ["rbxassetid://103896000727935"] = {name = "Aestus", prices = {["default"] = 126, ["Fly"] = 178.5, ["Ride"] = 129.94, ["Fly|Ride"] = 161.34, ["Neon"] = 550.97, ["Neon|Ride"] = 547.63, ["Neon|Fly|Ride"] = 577.5, ["Mega|Fly|Ride"] = 2231.25}},
    ["rbxassetid://9922229151"] = {name = "Dragonfly", prices = {["default"] = 2.1, ["Fly"] = 27.33, ["Ride"] = 19.69, ["Fly|Ride"] = 44.1, ["Neon"] = 19.5, ["Neon|Fly"] = 86.02, ["Neon|Ride"] = 30.78, ["Neon|Fly|Ride"] = 105, ["Mega|Fly"] = 446.25, ["Mega|Ride"] = 275.63, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://82820245821381"] = {name = "Temple Friend", prices = {["default"] = 3.94, ["Ride"] = 22.6, ["Fly|Ride"] = 58.12, ["Neon"] = 21, ["Neon|Ride"] = 55.4, ["Neon|Fly|Ride"] = 266.44, ["Mega"] = 161.49, ["Mega|Ride"] = 199.5, ["Mega|Fly|Ride"] = 325.5}},
    ["rbxassetid://6404812861"] = {name = "Diamond Ladybug", prices = {["default"] = 55.38, ["Ride"] = 35.27, ["Fly|Ride"] = 62.63, ["Neon|Ride"] = 376.38, ["Neon|Fly|Ride"] = 410.31, ["Mega|Fly|Ride"] = 1143.19}},
    ["rbxassetid://107535752953647"] = {name = "Strawberry Tortle", prices = {["Ride"] = 957.84, ["Fly|Ride"] = 1260, ["Neon|Fly|Ride"] = 4237.4}},
    ["rbxassetid://95844539868957"] = {name = "Amethyst Penguin", prices = {["default"] = 6562.5, ["Fly|Ride"] = 7315.9}},
    ["rbxassetid://6240249282"] = {name = "Guardian Lion", prices = {["default"] = 17.07, ["Fly"] = 35.35, ["Ride"] = 27.57, ["Fly|Ride"] = 55.1, ["Neon"] = 452.13, ["Neon|Ride"] = 178.45, ["Neon|Fly|Ride"] = 185.99, ["Mega"] = 2493.75, ["Mega|Ride"] = 956.01, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://11496077150"] = {name = "Ice Moth Dragon", prices = {["default"] = 17.73, ["Fly"] = 58.84, ["Ride"] = 28.65, ["Fly|Ride"] = 65.62, ["Neon"] = 89.24, ["Neon|Ride"] = 92.98, ["Neon|Fly|Ride"] = 178.5, ["Mega"] = 655.54, ["Mega|Ride"] = 663.68, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://5862774166"] = {name = "Skele-Rex", prices = {["default"] = 70, ["Fly"] = 157.5, ["Ride"] = 70.72, ["Fly|Ride"] = 118.13, ["Neon"] = 459.38, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 439.34, ["Mega|Fly|Ride"] = 1373.49}},
    ["rbxassetid://11773429123"] = {name = "Nessie", prices = {["default"] = 257.25, ["Ride"] = 264.29, ["Fly|Ride"] = 373.3, ["Neon|Ride"] = 977.79, ["Neon|Fly|Ride"] = 1083.31, ["Mega"] = 10257.53, ["Mega|Fly|Ride"] = 4322.53}},
    ["rbxassetid://121782270350526"] = {name = "Dark Choccybunny", prices = {["default"] = 5.18, ["Ride"] = 32.69, ["Fly|Ride"] = 86.52, ["Neon"] = 22.57, ["Neon|Fly"] = 656.25, ["Neon|Ride"] = 55.4, ["Mega"] = 160.02, ["Mega|Ride"] = 186.71, ["Mega|Fly|Ride"] = 302.6}},
    ["rbxassetid://129591977577854"] = {name = "Ballet Swan", prices = {["default"] = 183.74, ["Fly"] = 307.67, ["Ride"] = 236.25, ["Fly|Ride"] = 282.19, ["Neon"] = 725.89, ["Neon|Ride"] = 876.81, ["Neon|Fly|Ride"] = 843.94, ["Mega|Fly|Ride"] = 5315.63}},
    ["rbxassetid://9669227320"] = {name = "Zodiac Minion Chick", prices = {["default"] = 3.24, ["Fly"] = 77.89, ["Ride"] = 17.06, ["Fly|Ride"] = 39.35, ["Neon"] = 22.32, ["Neon|Fly"] = 123.04, ["Neon|Ride"] = 51.15, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 464.94, ["Mega|Ride"] = 223.12, ["Mega|Fly|Ride"] = 303.71}},
    ["rbxassetid://13462536955"] = {name = "Caelum Cervi", prices = {["default"] = 217.34, ["Ride"] = 249.38, ["Fly|Ride"] = 262.5, ["Neon|Fly|Ride"] = 1115.63, ["Mega"] = 10257.53, ["Mega|Ride"] = 4103.03, ["Mega|Fly|Ride"] = 4103.03}},
    ["rbxassetid://10137833794"] = {name = "Green-Chested Pheasant", prices = {["default"] = 13.85, ["Fly"] = 79.48, ["Ride"] = 27.71, ["Fly|Ride"] = 68.25, ["Neon"] = 72.76, ["Neon|Fly"] = 295.24, ["Neon|Ride"] = 97.44, ["Neon|Fly|Ride"] = 155.76, ["Mega|Ride"] = 615.47, ["Mega|Fly|Ride"] = 449.5}},
    ["rbxassetid://16994954002"] = {name = "Brachiosaurus", prices = {["default"] = 2.1, ["Fly"] = 68.73, ["Ride"] = 19.74, ["Fly|Ride"] = 59.07, ["Neon"] = 7.33, ["Neon|Fly"] = 170.45, ["Neon|Ride"] = 36.66, ["Neon|Fly|Ride"] = 176.88, ["Mega"] = 67.38, ["Mega|Ride"] = 100.7, ["Mega|Fly|Ride"] = 195.46}},
    ["rbxassetid://121938982134212"] = {name = "Gecko Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.86, ["Neon|Ride"] = 41.04, ["Mega"] = 18.36, ["Mega|Ride"] = 137.47, ["Mega|Fly|Ride"] = 410.31}},
    ["rbxassetid://17649624018"] = {name = "Kid Goat", prices = {["default"] = 2.1, ["Fly"] = 52.49, ["Ride"] = 23.84, ["Fly|Ride"] = 108.18, ["Neon"] = 5.24, ["Neon|Ride"] = 43.32, ["Neon|Fly|Ride"] = 109.94, ["Mega"] = 71.5, ["Mega|Fly"] = 154978.59, ["Mega|Ride"] = 93.84, ["Mega|Fly|Ride"] = 164.04}},
    ["rbxassetid://4440867127"] = {name = "Chicken", prices = {["default"] = 70.26, ["Fly"] = 139.5, ["Ride"] = 120.16, ["Fly|Ride"] = 176.98, ["Neon"] = 347.17, ["Neon|Fly"] = 389.7, ["Neon|Ride"] = 384.57, ["Neon|Fly|Ride"] = 373.13, ["Mega|Ride"] = 1333.48, ["Mega|Fly|Ride"] = 1128.75}},
    ["rbxassetid://5721844165"] = {name = "Tasmanian Tiger", prices = {["default"] = 2.1, ["Fly"] = 33.72, ["Ride"] = 15.73, ["Fly|Ride"] = 108.92, ["Neon"] = 5.25, ["Neon|Ride"] = 18.38, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 109.28, ["Mega|Ride"] = 139.84, ["Mega|Fly|Ride"] = 257.24}},
    ["rbxassetid://14146063876"] = {name = "Cockroach", prices = {["default"] = 12.31, ["Ride"] = 101.07, ["Neon"] = 51.79, ["Neon|Ride"] = 259.62}},
    ["rbxassetid://135555287601448"] = {name = "Rubber Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.65, ["Neon|Ride"] = 48.76, ["Mega"] = 17.07, ["Mega|Ride"] = 48, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://9664487060"] = {name = "Ant", prices = {["default"] = 2.1, ["Fly"] = 39.84, ["Ride"] = 15.1, ["Fly|Ride"] = 33.45, ["Neon"] = 2.1, ["Neon|Fly"] = 14.44, ["Neon|Ride"] = 11.71, ["Neon|Fly|Ride"] = 31.85, ["Mega"] = 14.42, ["Mega|Fly"] = 31.38, ["Mega|Ride"] = 19.27, ["Mega|Fly|Ride"] = 50.65}},
    ["rbxassetid://3293758505"] = {name = "Otter", prices = {["default"] = 2.1, ["Fly"] = 52.32, ["Ride"] = 12.49, ["Fly|Ride"] = 66.8, ["Neon"] = 3.76, ["Neon|Fly"] = 22.51, ["Neon|Ride"] = 14.34, ["Neon|Fly|Ride"] = 45.14, ["Mega"] = 30.33, ["Mega|Ride"] = 921.06}},
    ["rbxassetid://79698905581979"] = {name = "Ms. Muffet", prices = {["default"] = 2.1, ["Neon"] = 2.62, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 62.39, ["Mega"] = 18.19, ["Mega|Ride"] = 121.85}},
    ["rbxassetid://13620861015"] = {name = "Flying Fish", prices = {["default"] = 2.1, ["Fly"] = 91.84, ["Ride"] = 19.69, ["Fly|Ride"] = 107.63, ["Neon"] = 5.16, ["Neon|Fly"] = 167.95, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 41.5, ["Mega|Fly"] = 91.88, ["Mega|Ride"] = 139.55, ["Mega|Fly|Ride"] = 116.95}},
    ["rbxassetid://100439668574210"] = {name = "Jiggly Jerboa", prices = {["default"] = 2.1, ["Neon"] = 2.63, ["Neon|Fly|Ride"] = 205.16, ["Mega"] = 15.65, ["Mega|Fly|Ride"] = 205.16}},
    ["rbxassetid://14815828879"] = {name = "Ghost", prices = {["default"] = 2.1, ["Fly"] = 68.73, ["Ride"] = 17.31, ["Fly|Ride"] = 70.03, ["Neon"] = 13, ["Neon|Fly"] = 68.73, ["Neon|Ride"] = 32.78, ["Neon|Fly|Ride"] = 78.56, ["Mega"] = 114.26, ["Mega|Fly"] = 273.9, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 183.62}},
    ["rbxassetid://140565380261180"] = {name = "Galapagos Sea Lion", prices = {["default"] = 2.1, ["Ride"] = 50.94, ["Neon"] = 2.1, ["Neon|Ride"] = 78.74, ["Neon|Fly|Ride"] = 157.39, ["Mega"] = 16.4, ["Mega|Ride"] = 38.36, ["Mega|Fly|Ride"] = 184.65}},
    ["rbxassetid://14146188240"] = {name = "Bluebottle Fly", prices = {["default"] = 2.1, ["Fly|Ride"] = 524.99, ["Neon"] = 16.21, ["Mega|Fly"] = 314.99, ["Mega|Ride"] = 342.61}},
    ["rbxassetid://15930540035"] = {name = "Sandfish", prices = {["default"] = 3.94, ["Ride"] = 27.57, ["Neon"] = 15.18, ["Mega"] = 105, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 537.62}},
    ["rbxassetid://74774507671765"] = {name = "Island Tarsier", prices = {["default"] = 2.1, ["Ride"] = 24.94, ["Neon"] = 3.29, ["Neon|Ride"] = 26.67, ["Neon|Fly|Ride"] = 137.47, ["Mega"] = 21.8, ["Mega|Ride"] = 50.02, ["Mega|Fly|Ride"] = 131.06}},
    ["rbxassetid://9678196095"] = {name = "Mouse", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 15.4, ["Fly|Ride"] = 30.14, ["Neon"] = 2.1, ["Neon|Fly"] = 11.82, ["Neon|Ride"] = 12.24, ["Neon|Fly|Ride"] = 31.05, ["Mega"] = 12.26, ["Mega|Fly"] = 39, ["Mega|Ride"] = 19.25, ["Mega|Fly|Ride"] = 45.85}},
    ["rbxassetid://100695038890951"] = {name = "Basic Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13104111122"] = {name = "Piranha", prices = {["default"] = 2.1, ["Fly"] = 72.19, ["Ride"] = 229.68, ["Fly|Ride"] = 104.98, ["Neon"] = 36.75, ["Neon|Ride"] = 140.94, ["Mega|Ride"] = 240.19}},
    ["rbxassetid://110856597065248"] = {name = "Bakeneko", prices = {["default"] = 2.1, ["Ride"] = 38.07, ["Neon"] = 3.94, ["Neon|Ride"] = 51.3, ["Neon|Fly|Ride"] = 105, ["Mega"] = 24.86, ["Mega|Fly"] = 78.75, ["Mega|Ride"] = 54.02, ["Mega|Fly|Ride"] = 114.19}},
    ["rbxassetid://128979941112615"] = {name = "Dirty Ducky", prices = {["default"] = 2.25, ["Neon"] = 10.13, ["Neon|Fly|Ride"] = 137.47, ["Mega"] = 98.05, ["Mega|Ride"] = 160.5, ["Mega|Fly|Ride"] = 238.87}},
    ["rbxassetid://12479656052"] = {name = "Maleo Bird", prices = {["default"] = 2.1, ["Fly"] = 656.25, ["Ride"] = 34.54, ["Fly|Ride"] = 43.32, ["Neon"] = 21.2, ["Neon|Fly|Ride"] = 105, ["Mega"] = 210, ["Mega|Ride"] = 140.19, ["Mega|Fly|Ride"] = 167.2}},
    ["rbxassetid://3200646599"] = {name = "Cat", prices = {["default"] = 2.1, ["Fly"] = 11.71, ["Ride"] = 11.46, ["Fly|Ride"] = 18.8, ["Neon"] = 2.1, ["Neon|Fly"] = 11.71, ["Neon|Ride"] = 11.97, ["Neon|Fly|Ride"] = 26.25, ["Mega"] = 15.63, ["Mega|Fly"] = 28.18, ["Mega|Ride"] = 22.23, ["Mega|Fly|Ride"] = 45.93}},
    ["rbxassetid://12479810452"] = {name = "Bali Starling", prices = {["default"] = 2.1, ["Fly"] = 27.57, ["Ride"] = 20.52, ["Fly|Ride"] = 137.44, ["Neon"] = 12.08, ["Neon|Ride"] = 102.56, ["Neon|Fly|Ride"] = 123.05, ["Mega"] = 91.77, ["Mega|Ride"] = 157.95, ["Mega|Fly|Ride"] = 314.9}},
    ["rbxassetid://9982819219"] = {name = "Dugong", prices = {["default"] = 2.1, ["Fly"] = 112.03, ["Ride"] = 19.09, ["Fly|Ride"] = 59.06, ["Neon"] = 77.24, ["Neon|Ride"] = 67.48, ["Neon|Fly|Ride"] = 262.48, ["Mega"] = 227.07, ["Mega|Ride"] = 288.46, ["Mega|Fly|Ride"] = 399.67}},
    ["rbxassetid://3181727229"] = {name = "Buffalo", prices = {["default"] = 2.1, ["Fly"] = 15.4, ["Ride"] = 13, ["Fly|Ride"] = 36.81, ["Neon"] = 2.1, ["Neon|Fly"] = 23.62, ["Neon|Ride"] = 11.82, ["Neon|Fly|Ride"] = 34.48, ["Mega"] = 20.89, ["Mega|Ride"] = 35.44, ["Mega|Fly|Ride"] = 97.84}},
    ["rbxassetid://99694153348188"] = {name = "Urchin", prices = {["default"] = 2.37, ["Fly"] = 171.27, ["Ride"] = 30.23, ["Neon"] = 4.45, ["Neon|Ride"] = 26.64, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 81.81, ["Mega|Fly"] = 164.13, ["Mega|Ride"] = 116.82, ["Mega|Fly|Ride"] = 262.47}},
    ["rbxassetid://84089584046947"] = {name = "Blue Butterfly", prices = {["default"] = 2.1, ["Ride"] = 35.33, ["Fly|Ride"] = 65.63, ["Neon"] = 5.24, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 137.47, ["Mega"] = 33.5, ["Mega|Fly"] = 137.47, ["Mega|Ride"] = 133.37, ["Mega|Fly|Ride"] = 302.6}},
    ["rbxassetid://124485808787576"] = {name = "Tegu", prices = {["default"] = 2.1, ["Fly"] = 32.66, ["Ride"] = 27.57, ["Neon"] = 2.39, ["Neon|Fly"] = 41.03, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 100.96, ["Mega"] = 15.49, ["Mega|Ride"] = 40.69, ["Mega|Fly|Ride"] = 160.13}},
    ["rbxassetid://8938703774"] = {name = "Bullfrog", prices = {["default"] = 2.1, ["Fly"] = 96.42, ["Ride"] = 22.58, ["Fly|Ride"] = 41.91, ["Neon"] = 4.66, ["Neon|Fly"] = 55.4, ["Neon|Ride"] = 20.52, ["Neon|Fly|Ride"] = 78.66, ["Mega"] = 65.01, ["Mega|Ride"] = 62.78, ["Mega|Fly|Ride"] = 205.16}},
    ["rbxassetid://102746202827395"] = {name = "Hopbop", prices = {["default"] = 2.1, ["Ride"] = 68.25, ["Neon"] = 5.24, ["Neon|Ride"] = 36.01, ["Mega"] = 35.6, ["Mega|Fly|Ride"] = 249.37}},
    ["rbxassetid://6498255997"] = {name = "Stingray", prices = {["default"] = 2.1, ["Fly"] = 30.78, ["Ride"] = 12.32, ["Fly|Ride"] = 47.25, ["Neon"] = 7.66, ["Neon|Fly"] = 79.97, ["Neon|Ride"] = 25.14, ["Neon|Fly|Ride"] = 84, ["Mega"] = 91.88, ["Mega|Ride"] = 90.57, ["Mega|Fly|Ride"] = 365.18}},
    ["rbxassetid://13104106555"] = {name = "Mosquito", prices = {["default"] = 7.35, ["Fly"] = 41.16, ["Ride"] = 39.38, ["Neon"] = 38.99, ["Neon|Ride"] = 73.85, ["Mega"] = 98.18, ["Mega|Fly|Ride"] = 820.61}},
    ["rbxassetid://5721843483"] = {name = "Ground Sloth", prices = {["default"] = 2.1, ["Fly"] = 25.77, ["Ride"] = 18.38, ["Fly|Ride"] = 137.44, ["Neon"] = 18.38, ["Neon|Fly"] = 104.64, ["Neon|Ride"] = 32.23, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 202.27, ["Mega|Fly"] = 420, ["Mega|Ride"] = 124.69}},
    ["rbxassetid://4506925908"] = {name = "Robin", prices = {["default"] = 3.71, ["Fly"] = 22.58, ["Ride"] = 12.27, ["Fly|Ride"] = 40.69, ["Neon"] = 18.69, ["Neon|Fly"] = 32.85, ["Neon|Ride"] = 38.75, ["Neon|Fly|Ride"] = 65.4, ["Mega"] = 278.44, ["Mega|Ride"] = 410.82, ["Mega|Fly|Ride"] = 232.47}},
    ["rbxassetid://10382786163"] = {name = "Sado Mole", prices = {["default"] = 2.1, ["Fly"] = 110.93, ["Fly|Ride"] = 137.44, ["Neon"] = 23.35, ["Mega"] = 215.92, ["Mega|Ride"] = 236.24}},
    ["rbxassetid://14471275373"] = {name = "Ash Zebra", prices = {["default"] = 11.3, ["Ride"] = 56.44, ["Neon"] = 139.55, ["Neon|Ride"] = 232.45, ["Mega"] = 547.77, ["Mega|Ride"] = 656.25, ["Mega|Fly|Ride"] = 794.07}},
    ["rbxassetid://15923574361"] = {name = "Armadillo", prices = {["default"] = 3.94, ["Ride"] = 54.65, ["Fly|Ride"] = 104.71, ["Neon"] = 38.66, ["Neon|Ride"] = 125.71, ["Neon|Fly|Ride"] = 273.9, ["Mega"] = 253.32, ["Mega|Ride"] = 306.48}},
    ["rbxassetid://15921927876"] = {name = "Coyote", prices = {["default"] = 3.81, ["Ride"] = 29.7, ["Fly|Ride"] = 120.75, ["Neon"] = 41.25, ["Neon|Ride"] = 101.54, ["Neon|Fly|Ride"] = 181.55, ["Mega"] = 287.22, ["Mega|Ride"] = 281.07, ["Mega|Fly|Ride"] = 358.98}},
    ["rbxassetid://74353184935672"] = {name = "Sheepdog Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.93, ["Neon|Ride"] = 64.99, ["Mega"] = 15.94, ["Mega|Fly"] = 123.11, ["Mega|Ride"] = 123.11, ["Mega|Fly|Ride"] = 121.05}},
    ["rbxassetid://4748889845"] = {name = "Easter 2020 Egg", prices = {["default"] = 48.57}},
    ["rbxassetid://4752655872"] = {name = "Chick", prices = {["default"] = 7.3, ["Fly"] = 23.29, ["Ride"] = 19.5, ["Fly|Ride"] = 54.6, ["Neon"] = 45.85, ["Neon|Fly"] = 188.48, ["Neon|Ride"] = 40.46, ["Neon|Fly|Ride"] = 78.66, ["Mega"] = 374.32, ["Mega|Ride"] = 348.59, ["Mega|Fly|Ride"] = 812.84}},
    ["rbxassetid://17174085645"] = {name = "Garden Snake", prices = {["default"] = 2.1, ["Ride"] = 19.56, ["Neon"] = 2.63, ["Neon|Fly"] = 31.39, ["Neon|Ride"] = 26.72, ["Mega"] = 27.71, ["Mega|Fly"] = 137.47, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 129.94}},
    ["rbxassetid://17661844380"] = {name = "Show Pony", prices = {["default"] = 2.1, ["Ride"] = 32.83, ["Neon"] = 3.91, ["Neon|Ride"] = 31.57, ["Neon|Fly|Ride"] = 98, ["Mega"] = 77.43, ["Mega|Ride"] = 73.68, ["Mega|Fly|Ride"] = 133.88}},
    ["rbxassetid://8077196440"] = {name = "Walrus", prices = {["default"] = 2.1, ["Fly"] = 51.47, ["Ride"] = 15.69, ["Fly|Ride"] = 55.13, ["Neon"] = 3.94, ["Neon|Ride"] = 55.4, ["Neon|Fly|Ride"] = 124.38, ["Mega"] = 125.23, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 161.65}},
    ["rbxassetid://13104118499"] = {name = "Liger", prices = {["default"] = 4.89, ["Ride"] = 49.24, ["Fly|Ride"] = 62.77, ["Neon"] = 35.05, ["Neon|Ride"] = 41.04, ["Neon|Fly|Ride"] = 216.57, ["Mega"] = 328.13, ["Mega|Ride"] = 275.45, ["Mega|Fly|Ride"] = 410.31}},
    ["rbxassetid://120937667166493"] = {name = "Aye Aye", prices = {["default"] = 2.1, ["Ride"] = 32.81, ["Neon"] = 2.6, ["Mega"] = 19.38, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 56.74, ["Mega|Fly|Ride"] = 328.26}},
    ["rbxassetid://3199974297"] = {name = "Cracked Egg", prices = {["default"] = 2.05}},
    ["rbxassetid://15348350458"] = {name = "Beluga Whale", prices = {["default"] = 2.1, ["Fly"] = 21.67, ["Ride"] = 15.94, ["Fly|Ride"] = 273465.94, ["Neon"] = 6.45, ["Neon|Fly"] = 19.69, ["Neon|Ride"] = 27.71, ["Neon|Fly|Ride"] = 99.74, ["Mega"] = 24.43, ["Mega|Fly"] = 143.16, ["Mega|Ride"] = 72.72, ["Mega|Fly|Ride"] = 124.58}},
    ["rbxassetid://7126719464"] = {name = "Wolpertinger", prices = {["default"] = 2.1, ["Fly"] = 27.83, ["Ride"] = 16.42, ["Fly|Ride"] = 68.73, ["Neon"] = 9.32, ["Neon|Fly"] = 26.69, ["Neon|Ride"] = 17.31, ["Neon|Fly|Ride"] = 52.49, ["Mega"] = 47.95, ["Mega|Ride"] = 56.35, ["Mega|Fly|Ride"] = 158.29}},
    ["rbxassetid://125112456358906"] = {name = "Frankenfeline", prices = {["default"] = 2.1, ["Fly"] = 27.71, ["Ride"] = 32.16, ["Fly|Ride"] = 147.62, ["Neon"] = 3.93, ["Neon|Ride"] = 26.48, ["Neon|Fly|Ride"] = 110.88, ["Mega"] = 27.2, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 220.5}},
    ["rbxassetid://80556114592490"] = {name = "Japanese Snow Fairy", prices = {["default"] = 2.1, ["Neon"] = 3.76, ["Neon|Ride"] = 164.42, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 20.69, ["Mega|Fly"] = 106.45, ["Mega|Ride"] = 104.37, ["Mega|Fly|Ride"] = 149.21}},
    ["rbxassetid://124671555129102"] = {name = "Ratatoskr", prices = {["default"] = 2.1, ["Fly"] = 35.44, ["Ride"] = 20.52, ["Fly|Ride"] = 45.94, ["Neon"] = 3.8, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 27.46, ["Neon|Fly|Ride"] = 83.7, ["Mega"] = 19.36, ["Mega|Fly"] = 45.94, ["Mega|Ride"] = 40.69, ["Mega|Fly|Ride"] = 127.05}},
    ["rbxassetid://116184296449988"] = {name = "Pinkypillar", prices = {["default"] = 2.1, ["Ride"] = 48.21, ["Neon"] = 2.1, ["Mega"] = 41.04, ["Mega|Ride"] = 228.46}},
    ["rbxassetid://74353532164157"] = {name = "Red Panda Ducky", prices = {["default"] = 2.39, ["Neon"] = 4.97, ["Neon|Ride"] = 155.74, ["Neon|Fly|Ride"] = 420, ["Mega"] = 23.1, ["Mega|Ride"] = 158.22, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://4708551264"] = {name = "Bandicoot", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 16.16, ["Fly|Ride"] = 41.04, ["Neon"] = 12.78, ["Neon|Fly"] = 55.4, ["Neon|Ride"] = 17.05, ["Neon|Fly|Ride"] = 136.49, ["Mega"] = 91.76, ["Mega|Ride"] = 95.49, ["Mega|Fly|Ride"] = 82.56}},
    ["rbxassetid://12480314681"] = {name = "Malaysian Tapir", prices = {["default"] = 8.31, ["Ride"] = 139.53, ["Neon"] = 137.69, ["Mega"] = 1025.77, ["Mega|Ride"] = 545.71, ["Mega|Fly|Ride"] = 547.77}},
    ["rbxassetid://17482380743"] = {name = "Classic Teapot", prices = {["default"] = 2.1, ["Ride"] = 56.24, ["Neon"] = 40.69, ["Neon|Ride"] = 203.06, ["Mega"] = 1641.22, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://14146142724"] = {name = "Mongoose", prices = {["default"] = 2.1, ["Ride"] = 30.19, ["Fly|Ride"] = 410.17, ["Neon"] = 38.99, ["Neon|Fly|Ride"] = 260.55, ["Mega"] = 295.24, ["Mega|Ride"] = 350.82, ["Mega|Fly|Ride"] = 402.1}},
    ["rbxassetid://3181727351"] = {name = "Dog", prices = {["default"] = 2.1, ["Fly"] = 12.43, ["Ride"] = 11.68, ["Fly|Ride"] = 22.72, ["Neon"] = 2.1, ["Neon|Fly"] = 14.58, ["Neon|Ride"] = 11.82, ["Neon|Fly|Ride"] = 31.5, ["Mega"] = 14.44, ["Mega|Fly"] = 104.99, ["Mega|Ride"] = 20.22, ["Mega|Fly|Ride"] = 131.24}},
    ["rbxassetid://14267322852"] = {name = "Angelfish", prices = {["default"] = 2.1, ["Fly"] = 118.12, ["Ride"] = 57.44, ["Fly|Ride"] = 109.75, ["Neon"] = 8.22, ["Neon|Fly"] = 67.76, ["Neon|Ride"] = 31.8, ["Neon|Fly|Ride"] = 684.2, ["Mega"] = 45.94, ["Mega|Ride"] = 118.02}},
    ["rbxassetid://110130591707207"] = {name = "California Condor", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Fly"] = 30.78, ["Neon|Ride"] = 21.47, ["Neon|Fly|Ride"] = 68.83, ["Mega"] = 14.21, ["Mega|Fly"] = 88.36, ["Mega|Ride"] = 71.6, ["Mega|Fly|Ride"] = 118.89}},
    ["rbxassetid://123567499475377"] = {name = "Forest Sprite", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Fly"] = 60.9, ["Neon|Ride"] = 123.08, ["Mega"] = 16.42, ["Mega|Ride"] = 102.59, ["Mega|Fly|Ride"] = 162.08}},
    ["rbxassetid://8663441035"] = {name = "Lunar White Tiger", prices = {["default"] = 2.1, ["Fly"] = 38.52, ["Ride"] = 15.66, ["Fly|Ride"] = 42.69, ["Neon"] = 8.81, ["Neon|Ride"] = 40.69, ["Neon|Fly|Ride"] = 90.97, ["Mega"] = 208.85, ["Mega|Ride"] = 205.16, ["Mega|Fly|Ride"] = 294}},
    ["rbxassetid://16000498338"] = {name = "Groundhog", prices = {["default"] = 191.76, ["Ride"] = 205.11, ["Fly|Ride"] = 177.19, ["Neon|Ride"] = 1640.81, ["Neon|Fly|Ride"] = 1094.48, ["Mega"] = 8206.04, ["Mega|Fly|Ride"] = 3552.2}},
    ["rbxassetid://73268582142443"] = {name = "Kelp Raider", prices = {["default"] = 2.1, ["Ride"] = 19.5, ["Neon"] = 6.57, ["Neon|Ride"] = 82.06, ["Mega"] = 90.96, ["Mega|Ride"] = 124.38, ["Mega|Fly|Ride"] = 820.61}},
    ["rbxassetid://16369178617"] = {name = "Ornate Horned Frog", prices = {["default"] = 2.1, ["Fly"] = 103.68, ["Ride"] = 25.57, ["Fly|Ride"] = 59.07, ["Neon"] = 31.8, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 137.47, ["Mega"] = 360.94, ["Mega|Fly|Ride"] = 406.21}},
    ["rbxassetid://6245080170"] = {name = "Lunar Ox", prices = {["default"] = 2.1, ["Fly"] = 15.01, ["Ride"] = 14.38, ["Fly|Ride"] = 32.13, ["Neon"] = 6.18, ["Neon|Fly"] = 31.5, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 39.38, ["Mega"] = 49.68, ["Mega|Ride"] = 80.56, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://92652981666929"] = {name = "Starmite", prices = {["default"] = 2.1, ["Fly"] = 51.19, ["Ride"] = 19.68, ["Fly|Ride"] = 92.57, ["Neon"] = 6.13, ["Neon|Ride"] = 78.47, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 69.47, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 419.99}},
    ["rbxassetid://9482496753"] = {name = "King Penguin", prices = {["default"] = 2.1, ["Fly"] = 19.05, ["Ride"] = 15.75, ["Fly|Ride"] = 36, ["Neon"] = 34.04, ["Neon|Fly"] = 98.85, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 74.81, ["Mega|Ride"] = 269.79, ["Mega|Fly|Ride"] = 294}},
    ["rbxassetid://10489161125"] = {name = "Tanuki", prices = {["default"] = 3.6, ["Ride"] = 34.32, ["Fly|Ride"] = 249.58, ["Neon"] = 55.18, ["Neon|Ride"] = 137.44, ["Neon|Fly|Ride"] = 609.31, ["Mega"] = 512.9, ["Mega|Ride"] = 255.64, ["Mega|Fly|Ride"] = 387.18}},
    ["rbxassetid://7126720060"] = {name = "Wyvern", prices = {["default"] = 2.1, ["Fly"] = 16.42, ["Ride"] = 15.43, ["Fly|Ride"] = 29.75, ["Neon"] = 17.75, ["Neon|Fly"] = 75.9, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 157.5, ["Mega|Ride"] = 232.86, ["Mega|Fly|Ride"] = 273.9}},
    ["rbxassetid://4506925800"] = {name = "Swan", prices = {["default"] = 70.25, ["Fly"] = 178.5, ["Ride"] = 114.18, ["Fly|Ride"] = 162.75, ["Neon"] = 356.85, ["Neon|Fly"] = 437.07, ["Neon|Ride"] = 341.25, ["Neon|Fly|Ride"] = 381.94}},
    ["rbxassetid://13621428133"] = {name = "Tortuga de la Isla", prices = {["default"] = 254.3, ["Fly"] = 328.17, ["Ride"] = 248.79, ["Fly|Ride"] = 314.84, ["Neon|Ride"] = 2563.75, ["Neon|Fly|Ride"] = 1232.65, ["Mega"] = 10257.53, ["Mega|Fly|Ride"] = 4647.7}},
    ["rbxassetid://6684832189"] = {name = "Lamb", prices = {["default"] = 55.17, ["Fly"] = 137.67, ["Ride"] = 75.9, ["Fly|Ride"] = 111.56, ["Neon"] = 701.38, ["Neon|Ride"] = 328.11, ["Neon|Fly|Ride"] = 410.31, ["Mega|Fly|Ride"] = 1358.36}},
    ["rbxassetid://122365328950491"] = {name = "Blossom Snake", prices = {["default"] = 24.34, ["Fly"] = 26.25, ["Ride"] = 30.66, ["Fly|Ride"] = 137.44, ["Neon"] = 26.2, ["Neon|Ride"] = 85.32, ["Neon|Fly|Ride"] = 179.81, ["Mega"] = 262.5, ["Mega|Ride"] = 376.69, ["Mega|Fly|Ride"] = 414.1}},
    ["rbxassetid://14360919997"] = {name = "Toasty Red Panda", prices = {["default"] = 15.4, ["Fly"] = 68.73, ["Ride"] = 28.84, ["Fly|Ride"] = 90.26, ["Neon"] = 52.41, ["Neon|Fly"] = 20.52, ["Neon|Ride"] = 123.08, ["Mega"] = 353.07, ["Mega|Ride"] = 383.34, ["Mega|Fly|Ride"] = 1094.48}},
    ["rbxassetid://3181727278"] = {name = "Rabbit", prices = {["default"] = 2.1, ["Fly"] = 14.11, ["Ride"] = 14.63, ["Fly|Ride"] = 34.93, ["Neon"] = 2.1, ["Neon|Fly"] = 25.58, ["Neon|Ride"] = 20.78, ["Neon|Fly|Ride"] = 58.83, ["Mega"] = 114.6, ["Mega|Fly"] = 52.5, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 175.43}},
    ["rbxassetid://14782579567"] = {name = "Nightmare Owl", prices = {["default"] = 5.25, ["Fly"] = 72.12, ["Ride"] = 20.9, ["Fly|Ride"] = 312.16, ["Neon"] = 99.83, ["Neon|Ride"] = 157.94, ["Neon|Fly|Ride"] = 136.29, ["Mega"] = 413.44, ["Mega|Ride"] = 616.88, ["Mega|Fly|Ride"] = 604.43}},
    ["rbxassetid://6498256342"] = {name = "Narwhal", prices = {["default"] = 2.1, ["Fly"] = 41.91, ["Ride"] = 16.42, ["Fly|Ride"] = 36.11, ["Neon"] = 19.68, ["Neon|Fly"] = 145.69, ["Neon|Ride"] = 28.65, ["Neon|Fly|Ride"] = 113.88, ["Mega|Ride"] = 206.96, ["Mega|Fly|Ride"] = 171.52}},
    ["rbxassetid://9227407648"] = {name = "Ibex", prices = {["default"] = 4.58, ["Ride"] = 20.46, ["Fly|Ride"] = 328.13, ["Neon"] = 19.68, ["Neon|Ride"] = 61.53, ["Mega"] = 207.37, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 480.68}},
    ["rbxassetid://16440727263"] = {name = "Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 15.4, ["Ride"] = 19.34, ["Neon"] = 2.1, ["Neon|Ride"] = 19.65, ["Neon|Fly|Ride"] = 53.36, ["Mega"] = 15, ["Mega|Ride"] = 27.71, ["Mega|Fly|Ride"] = 209.99}},
    ["rbxassetid://10318106327"] = {name = "Yellow Butterfly", prices = {["default"] = 2.63, ["Fly"] = 18.71, ["Ride"] = 18.05, ["Fly|Ride"] = 31.39, ["Neon"] = 14.22, ["Neon|Fly"] = 34.13, ["Neon|Ride"] = 32.81, ["Neon|Fly|Ride"] = 147, ["Mega"] = 84, ["Mega|Ride"] = 101.88, ["Mega|Fly|Ride"] = 209.34}},
    ["rbxassetid://13894169749"] = {name = "Black Kite", prices = {["default"] = 3.89, ["Fly"] = 24.94, ["Ride"] = 18.5, ["Fly|Ride"] = 60.8, ["Neon"] = 34.89, ["Neon|Ride"] = 47.25, ["Neon|Fly|Ride"] = 547.77, ["Mega"] = 260.55, ["Mega|Ride"] = 191.83, ["Mega|Fly|Ride"] = 272.99}},
    ["rbxassetid://4506925595"] = {name = "Polar Bear", prices = {["default"] = 196.88, ["Fly"] = 273.82, ["Ride"] = 169.51, ["Fly|Ride"] = 213.7, ["Neon"] = 685.21, ["Neon|Ride"] = 749.36, ["Neon|Fly|Ride"] = 793.95, ["Mega"] = 4103.03, ["Mega|Fly|Ride"] = 2735.7}},
    ["rbxassetid://14639006189"] = {name = "Canada Goose", prices = {["default"] = 7.45, ["Ride"] = 31.8, ["Fly|Ride"] = 124.38, ["Neon"] = 53.82, ["Neon|Ride"] = 160.13, ["Neon|Fly|Ride"] = 376.56, ["Mega"] = 405.19, ["Mega|Ride"] = 296.63, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://5721844402"] = {name = "Triceratops", prices = {["default"] = 2.1, ["Fly"] = 17.64, ["Ride"] = 14.1, ["Fly|Ride"] = 45.35, ["Neon"] = 22.98, ["Neon|Ride"] = 25.91, ["Neon|Fly|Ride"] = 104.64, ["Mega"] = 308.44, ["Mega|Ride"] = 244.83, ["Mega|Fly|Ride"] = 273.9}},
    ["rbxassetid://83805820117149"] = {name = "Golden Jaguar", prices = {["default"] = 24.66, ["Ride"] = 41.32, ["Fly|Ride"] = 170.63, ["Neon"] = 105, ["Neon|Ride"] = 295.24, ["Neon|Fly|Ride"] = 464.03, ["Mega"] = 511.29, ["Mega|Fly"] = 820.61, ["Mega|Ride"] = 522.38, ["Mega|Fly|Ride"] = 1025.77}},
    ["rbxassetid://13936754497"] = {name = "Pinocchio", prices = {["default"] = 5.1}},
    ["rbxassetid://17059776562"] = {name = "Ankylosaurus", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 28.5, ["Neon"] = 23.63, ["Neon|Ride"] = 273.82, ["Neon|Fly|Ride"] = 342.61, ["Mega"] = 342.61, ["Mega|Ride"] = 347.82, ["Mega|Fly|Ride"] = 889.34}},
    ["rbxassetid://3181727813"] = {name = "Horse", prices = {["default"] = 34.04, ["Fly"] = 35.49, ["Ride"] = 28.88, ["Fly|Ride"] = 55.13, ["Neon|Fly"] = 101818.18, ["Neon|Ride"] = 162.63, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 2051.52, ["Mega|Fly|Ride"] = 1916.12}},
    ["rbxassetid://101098195340953"] = {name = "Mexican Wolf", prices = {["default"] = 2.1, ["Ride"] = 17.54, ["Fly|Ride"] = 102.56, ["Neon"] = 2.1, ["Neon|Fly"] = 65.62, ["Neon|Ride"] = 55.13, ["Neon|Fly|Ride"] = 106.25, ["Mega"] = 30.79, ["Mega|Fly"] = 273.9, ["Mega|Ride"] = 72.19, ["Mega|Fly|Ride"] = 227.21}},
    ["rbxassetid://13894408663"] = {name = "Seagull", prices = {["default"] = 2.1, ["Fly"] = 28.41, ["Ride"] = 15.4, ["Fly|Ride"] = 61.55, ["Neon"] = 45.66, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 232.45, ["Mega"] = 233.21, ["Mega|Fly"] = 388.23, ["Mega|Ride"] = 203.44, ["Mega|Fly|Ride"] = 340.56}},
    ["rbxassetid://6998403532"] = {name = "Sasquatch", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 14.89, ["Fly|Ride"] = 40.69, ["Neon"] = 15.39, ["Neon|Fly"] = 186.9, ["Neon|Ride"] = 30.38, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 174.89, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 209.79}},
    ["rbxassetid://108348392849720"] = {name = "Water Opossum", prices = {["default"] = 2.1, ["Ride"] = 35.9, ["Fly|Ride"] = 78.75, ["Neon"] = 6.08, ["Neon|Ride"] = 22.43, ["Neon|Fly|Ride"] = 410.31, ["Mega"] = 26.79, ["Mega|Ride"] = 53.76, ["Mega|Fly|Ride"] = 184.65}},
    ["rbxassetid://11758575705"] = {name = "Moon Rabbit", prices = {["default"] = 34.86, ["Ride"] = 78.66, ["Fly|Ride"] = 525, ["Neon"] = 313.07, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 802.03, ["Mega"] = 799.99, ["Mega|Ride"] = 954.99, ["Mega|Fly|Ride"] = 840}},
    ["rbxassetid://15922874831"] = {name = "Roadrunner", prices = {["default"] = 3.93, ["Ride"] = 45.94, ["Fly|Ride"] = 210, ["Neon"] = 85.95, ["Mega|Ride"] = 524.99}},
    ["rbxassetid://6060988175"] = {name = "Snowman", prices = {["default"] = 4.6, ["Fly"] = 210, ["Ride"] = 21.15, ["Fly|Ride"] = 69.11, ["Neon"] = 22.3, ["Neon|Fly"] = 315, ["Neon|Ride"] = 39.29, ["Neon|Fly|Ride"] = 107.63, ["Mega"] = 342.61, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://12720029414"] = {name = "Wood Pigeon", prices = {["default"] = 86.52, ["Ride"] = 385.86, ["Fly|Ride"] = 262.45, ["Neon"] = 328.13, ["Neon|Ride"] = 533.28, ["Mega|Ride"] = 2100, ["Mega|Fly|Ride"] = 1836.18}},
    ["rbxassetid://136340738568203"] = {name = "Mr Whiskerpips", prices = {["default"] = 27.28, ["Fly"] = 26.17, ["Ride"] = 28.87, ["Fly|Ride"] = 64.62, ["Neon"] = 39.37, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 139.86, ["Mega"] = 216.57, ["Mega|Ride"] = 275.63, ["Mega|Fly|Ride"] = 514.99}},
    ["rbxassetid://127204329704553"] = {name = "German Shepherd", prices = {["default"] = 72.1, ["Fly"] = 186.38, ["Ride"] = 113.29, ["Neon"] = 261.19, ["Neon|Ride"] = 261.19, ["Neon|Fly|Ride"] = 396.99, ["Mega"] = 1049.36, ["Mega|Ride"] = 1013.46, ["Mega|Fly|Ride"] = 953.84}},
    ["rbxassetid://99868640713300"] = {name = "Puptune", prices = {["default"] = 23.89, ["Ride"] = 52.49, ["Fly|Ride"] = 172.3, ["Neon"] = 87.39, ["Neon|Ride"] = 137.44, ["Neon|Fly|Ride"] = 196.86, ["Mega"] = 471.86, ["Mega|Ride"] = 313.69, ["Mega|Fly|Ride"] = 456.1}},
    ["rbxassetid://9993276067"] = {name = "2022 Uplift Butterfly", prices = {["default"] = 21, ["Ride"] = 27.55, ["Fly|Ride"] = 68.73, ["Neon"] = 70.37, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 248.75, ["Mega"] = 416.96, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://136574776317301"] = {name = "Sweetheart Rat", prices = {["default"] = 18.38, ["Ride"] = 47.16, ["Fly|Ride"] = 273.82, ["Neon"] = 64.31, ["Neon|Ride"] = 178.45, ["Neon|Fly|Ride"] = 305.69, ["Mega"] = 269.62, ["Mega|Ride"] = 262.4, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://17649489402"] = {name = "Cow Calf", prices = {["default"] = 4.87, ["Ride"] = 28.88, ["Fly|Ride"] = 55.73, ["Neon"] = 47.9, ["Neon|Ride"] = 70.88, ["Neon|Fly|Ride"] = 150.94, ["Mega"] = 236.25, ["Mega|Ride"] = 273.9, ["Mega|Fly|Ride"] = 396.99}},
    ["rbxassetid://77869404304609"] = {name = "Budgie Witch", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 57.2, ["Mega"] = 19.51, ["Mega|Ride"] = 123.11, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://111676861947081"] = {name = "The Black Dog", prices = {["default"] = 2.1, ["Ride"] = 28.25, ["Neon"] = 18.11, ["Neon|Fly"] = 123.08, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 202.78, ["Mega"] = 101.36, ["Mega|Ride"] = 246.2, ["Mega|Fly|Ride"] = 467.28}},
    ["rbxassetid://13104122472"] = {name = "Borhyaena Gigantica", prices = {["default"] = 2.1, ["Neon"] = 25.83, ["Mega"] = 196.88, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://105232492496005"] = {name = "Firefighter Gibbon", prices = {["default"] = 6.17, ["Ride"] = 32.79, ["Fly|Ride"] = 116.24, ["Neon"] = 27.04, ["Neon|Ride"] = 82.95, ["Mega"] = 199, ["Mega|Ride"] = 274.32, ["Mega|Fly|Ride"] = 348.5}},
    ["rbxassetid://3409443514"] = {name = "Elephant", prices = {["default"] = 541.14, ["Ride"] = 624.75, ["Fly|Ride"] = 700.88, ["Neon"] = 1778.22, ["Neon|Ride"] = 1784.04, ["Neon|Fly|Ride"] = 1778.67, ["Mega|Fly|Ride"] = 5880}},
    ["rbxassetid://10137833682"] = {name = "Brown-Chested Pheasant", prices = {["default"] = 7.7, ["Ride"] = 19.69, ["Fly|Ride"] = 62.77, ["Neon"] = 35.9, ["Neon|Ride"] = 96.42, ["Neon|Fly|Ride"] = 341.25, ["Mega"] = 155.76, ["Mega|Ride"] = 355.72, ["Mega|Fly|Ride"] = 464.94}},
    ["rbxassetid://12490691849"] = {name = "Gecko", prices = {["Fly"] = 524.69, ["Ride"] = 25.01, ["Fly|Ride"] = 51.35, ["Neon"] = 57.75, ["Neon|Fly"] = 315, ["Neon|Ride"] = 102.56, ["Neon|Fly|Ride"] = 156.4, ["Mega"] = 330.75, ["Mega|Ride"] = 278.55, ["Mega|Fly|Ride"] = 341.24}},
    ["rbxassetid://9913459163"] = {name = "Trapdoor Snail", prices = {["default"] = 3.92, ["Ride"] = 19.41, ["Fly|Ride"] = 307.67, ["Neon|Ride"] = 196.88, ["Mega"] = 263.86, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://124413732651376"] = {name = "Gumball Caterpillar", prices = {["default"] = 2.1, ["Fly"] = 86.16, ["Ride"] = 21, ["Fly|Ride"] = 88.75, ["Neon"] = 7.53, ["Neon|Ride"] = 34.04, ["Neon|Fly|Ride"] = 94.98, ["Mega"] = 59.07, ["Mega|Fly"] = 211.78, ["Mega|Ride"] = 112.87, ["Mega|Fly|Ride"] = 254.63}},
    ["rbxassetid://96107383056013"] = {name = "Gummy Guana", prices = {["default"] = 2.1, ["Fly"] = 68.73, ["Ride"] = 19.69, ["Neon"] = 2.1, ["Neon|Ride"] = 23.58, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 91.88, ["Mega|Ride"] = 65.35, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://3261465951"] = {name = "Blue Egg", prices = {["default"] = 1109.05}},
    ["rbxassetid://11245006051"] = {name = "Therapy Dog", prices = {["default"] = 10.5, ["Ride"] = 36.75, ["Fly|Ride"] = 323.65, ["Neon"] = 83.7, ["Neon|Ride"] = 89.25, ["Neon|Fly|Ride"] = 273.9, ["Mega|Ride"] = 544.69, ["Mega|Fly|Ride"] = 446.25}},
    ["rbxassetid://76323474173289"] = {name = "Kelp Crewmate", prices = {["default"] = 2.1, ["Ride"] = 28.26, ["Neon"] = 5.25, ["Neon|Ride"] = 73.85, ["Neon|Fly|Ride"] = 982.1, ["Mega"] = 39.26, ["Mega|Ride"] = 164.13, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://14978701264"] = {name = "Scarecrow Horse", prices = {["default"] = 2.1, ["Fly"] = 41.66, ["Neon"] = 15.4, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 55.4, ["Mega"] = 183.73, ["Mega|Ride"] = 359.63, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://3409443801"] = {name = "Lion", prices = {["default"] = 465.94, ["Ride"] = 547.63, ["Fly|Ride"] = 607.1, ["Neon|Ride"] = 1902.58, ["Neon|Fly|Ride"] = 1575, ["Mega|Fly|Ride"] = 6562.5}},
    ["rbxassetid://13979014954"] = {name = "Fossa", prices = {["default"] = 4.87, ["Fly"] = 196.88, ["Ride"] = 59.07, ["Fly|Ride"] = 410.21, ["Neon"] = 68.73, ["Neon|Ride"] = 77.17, ["Neon|Fly|Ride"] = 185.99, ["Mega"] = 479.04, ["Mega|Ride"] = 441.7}},
    ["rbxassetid://137886461285917"] = {name = "Angus Cow", prices = {["default"] = 2.1, ["Fly"] = 83.64, ["Fly|Ride"] = 162.04, ["Neon"] = 2.1, ["Neon|Ride"] = 25.87, ["Neon|Fly|Ride"] = 155.76, ["Mega"] = 45.85, ["Mega|Ride"] = 76.12, ["Mega|Fly|Ride"] = 177.08}},
    ["rbxassetid://128343324254978"] = {name = "Blue Cat", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 273.9, ["Mega"] = 26.25, ["Mega|Ride"] = 134.78, ["Mega|Fly|Ride"] = 287.22}},
    ["rbxassetid://79274485636628"] = {name = "Indian Flying Fox", prices = {["default"] = 14.44, ["Fly"] = 107.63, ["Ride"] = 68.84, ["Fly|Ride"] = 97.44, ["Neon"] = 120.7, ["Neon|Ride"] = 98.44, ["Neon|Fly|Ride"] = 185.99, ["Mega"] = 425.71, ["Mega|Ride"] = 544.69, ["Mega|Fly|Ride"] = 595.88}},
    ["rbxassetid://96039704958671"] = {name = "Singularity Pisces", prices = {["default"] = 5.55, ["Neon"] = 80.22, ["Neon|Ride"] = 123.08, ["Neon|Fly|Ride"] = 820.61, ["Mega"] = 533.42, ["Mega|Ride"] = 479.73, ["Mega|Fly|Ride"] = 1094.48}},
    ["rbxassetid://12489494348"] = {name = "Komodo Dragon", prices = {["default"] = 3.93, ["Ride"] = 44.79, ["Fly|Ride"] = 131.25, ["Neon"] = 310.36, ["Neon|Ride"] = 175.51, ["Mega"] = 644.69, ["Mega|Ride"] = 1053.47, ["Mega|Fly|Ride"] = 684.2}},
    ["rbxassetid://14360919129"] = {name = "Flaming Zebra", prices = {["default"] = 18.83, ["Ride"] = 23.15, ["Fly|Ride"] = 262.5, ["Neon"] = 656.25, ["Neon|Ride"] = 182.43, ["Neon|Fly|Ride"] = 199, ["Mega"] = 610.32, ["Mega|Ride"] = 646.42, ["Mega|Fly|Ride"] = 665.44}},
    ["rbxassetid://108242367048842"] = {name = "Honey Badger", prices = {["default"] = 426.57, ["Ride"] = 409.6, ["Fly|Ride"] = 748.55, ["Neon"] = 1025.52, ["Neon|Ride"] = 1085.48, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 3966.6}},
    ["rbxassetid://11119262646"] = {name = "Evil Chickatrice", prices = {["default"] = 5.14, ["Fly"] = 78.74, ["Ride"] = 22.58, ["Fly|Ride"] = 236.25, ["Neon"] = 119.67, ["Neon|Ride"] = 164.06, ["Neon|Fly|Ride"] = 193.23, ["Mega|Ride"] = 547.77, ["Mega|Fly|Ride"] = 844.2}},
    ["rbxassetid://120631772928905"] = {name = "Subzero Scorpion", prices = {["default"] = 2.1, ["Fly|Ride"] = 127.32, ["Neon"] = 39.26, ["Neon|Ride"] = 105, ["Mega"] = 217.48, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 787.49}},
    ["rbxassetid://70394243440806"] = {name = "Ghostly Cat", prices = {["default"] = 21, ["Ride"] = 70.88, ["Fly|Ride"] = 256.9, ["Neon"] = 85.32, ["Neon|Ride"] = 120.75, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 272.35, ["Mega|Fly"] = 684.2, ["Mega|Ride"] = 273, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://108186720416551"] = {name = "Storm Condor", prices = {["default"] = 2.1, ["Ride"] = 52.5, ["Fly|Ride"] = 137.44, ["Neon"] = 6.57, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 205.16, ["Mega"] = 47.79, ["Mega|Ride"] = 102.54, ["Mega|Fly|Ride"] = 303.19}},
    ["rbxassetid://11181152874"] = {name = "Mule", prices = {["default"] = 32.82, ["Ride"] = 102.68, ["Neon"] = 313.82, ["Neon|Ride"] = 348.69, ["Mega"] = 1504.79, ["Mega|Ride"] = 1354, ["Mega|Fly|Ride"] = 1089.38}},
    ["rbxassetid://94781392732758"] = {name = "Onza", prices = {["default"] = 2.1, ["Ride"] = 25.16, ["Fly|Ride"] = 60.36, ["Neon"] = 9.19, ["Neon|Fly"] = 178.45, ["Neon|Ride"] = 63.59, ["Neon|Fly|Ride"] = 118.12, ["Mega"] = 73.87, ["Mega|Ride"] = 108.11, ["Mega|Fly|Ride"] = 208.69}},
    ["rbxassetid://102763887893057"] = {name = "Cherub Chipmunk", prices = {["default"] = 2.1, ["Fly"] = 36.05, ["Ride"] = 27.97, ["Fly|Ride"] = 26.25, ["Neon"] = 5.03, ["Neon|Fly"] = 49.38, ["Neon|Ride"] = 42.79, ["Neon|Fly|Ride"] = 133.37, ["Mega"] = 32.72, ["Mega|Fly"] = 112.88, ["Mega|Ride"] = 73.4, ["Mega|Fly|Ride"] = 170.36}},
    ["rbxassetid://104845330408668"] = {name = "Icy Porcupine", prices = {["default"] = 2.1, ["Ride"] = 31.39, ["Fly|Ride"] = 125.09, ["Neon"] = 15.4, ["Neon|Ride"] = 60.45, ["Neon|Fly|Ride"] = 177.19, ["Mega"] = 81.38, ["Mega|Fly"] = 459.38, ["Mega|Ride"] = 111.03, ["Mega|Fly|Ride"] = 275.63}},
    ["rbxassetid://12597275903"] = {name = "White Sand Dollar", prices = {["default"] = 97.59, ["Fly"] = 93, ["Ride"] = 65.63, ["Fly|Ride"] = 194.13, ["Neon"] = 291.38, ["Neon|Ride"] = 294.38, ["Neon|Fly|Ride"] = 412.56, ["Mega|Fly|Ride"] = 1048.69}},
    ["rbxassetid://9901393350"] = {name = "Irish Water Spaniel", prices = {["default"] = 258.25, ["Ride"] = 271.53, ["Fly|Ride"] = 411.76, ["Neon"] = 1425.45, ["Neon|Ride"] = 1139.14, ["Neon|Fly|Ride"] = 1278.58, ["Mega"] = 6154.53, ["Mega|Fly|Ride"] = 4045.13}},
    ["rbxassetid://128640048014369"] = {name = "River Otter", prices = {["default"] = 52.29, ["Neon"] = 40.07, ["Mega"] = 98.44, ["Mega|Ride"] = 294.41}},
    ["rbxassetid://138984599254588"] = {name = "Tree Sasquatch", prices = {["default"] = 2.1, ["Ride"] = 27.57, ["Neon"] = 7.66, ["Neon|Ride"] = 43.89, ["Neon|Fly|Ride"] = 191.83, ["Mega"] = 58.82, ["Mega|Fly"] = 210, ["Mega|Ride"] = 102.38, ["Mega|Fly|Ride"] = 343.64}},
    ["rbxassetid://15870220155"] = {name = "Vulture", prices = {["default"] = 5.24, ["Fly"] = 155.57, ["Ride"] = 27.56, ["Neon"] = 32.81, ["Neon|Ride"] = 68.73, ["Mega"] = 206.73, ["Mega|Ride"] = 348.23, ["Mega|Fly|Ride"] = 388.23}},
    ["rbxassetid://7734902490"] = {name = "Halloween Black Mummy Cat", prices = {["default"] = 2.1, ["Fly"] = 67.91, ["Ride"] = 63.59, ["Fly|Ride"] = 70.35, ["Neon"] = 10.5, ["Neon|Ride"] = 35.4, ["Neon|Fly|Ride"] = 139.55, ["Mega"] = 114.18, ["Mega|Ride"] = 125.9, ["Mega|Fly|Ride"] = 236.24}},
    ["rbxassetid://116677376014234"] = {name = "Sunflower Friend", prices = {["default"] = 2.24, ["Ride"] = 90.26, ["Neon"] = 7.58, ["Mega"] = 39.29, ["Mega|Fly|Ride"] = 270.82}},
    ["rbxassetid://13186022212"] = {name = "Grinmoire", prices = {["default"] = 2.1, ["Fly"] = 65.54, ["Ride"] = 16.71, ["Fly|Ride"] = 49.88, ["Neon"] = 3.81, ["Neon|Ride"] = 27.71, ["Neon|Fly|Ride"] = 410.31, ["Mega"] = 39.3, ["Mega|Ride"] = 99.98, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://11119263014"] = {name = "Chickatrice", prices = {["default"] = 2.1, ["Fly"] = 137.61, ["Ride"] = 17.27, ["Fly|Ride"] = 59.77, ["Neon"] = 16.54, ["Neon|Fly"] = 64.32, ["Neon|Ride"] = 27.71, ["Neon|Fly|Ride"] = 93.28, ["Mega"] = 113.88, ["Mega|Ride"] = 231.83, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://13104110160"] = {name = "Blue Ringed Octopus", prices = {["default"] = 140.89, ["Ride"] = 42.63, ["Fly|Ride"] = 77.15, ["Neon"] = 137.69, ["Neon|Ride"] = 151.79, ["Mega"] = 1128.35, ["Mega|Ride"] = 525}},
    ["rbxassetid://16088265753"] = {name = "Flaming Fox", prices = {["default"] = 73.32, ["Ride"] = 100.51, ["Fly|Ride"] = 119.87, ["Neon"] = 439.69, ["Neon|Fly"] = 430.64, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 456.71, ["Mega"] = 1470, ["Mega|Ride"] = 3254.99, ["Mega|Fly|Ride"] = 1470}},
    ["rbxassetid://84105347355723"] = {name = "Gibbon", prices = {["default"] = 2.1, ["Ride"] = 23.24, ["Fly|Ride"] = 131.25, ["Neon"] = 3.49, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 27.56, ["Neon|Fly|Ride"] = 128.47, ["Mega"] = 50.02, ["Mega|Fly"] = 82.07, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://9543194411"] = {name = "Swordfish", prices = {["default"] = 2.1, ["Fly"] = 32.83, ["Ride"] = 15.75, ["Fly|Ride"] = 39.37, ["Neon"] = 3.94, ["Neon|Fly"] = 28.37, ["Neon|Ride"] = 23.75, ["Neon|Fly|Ride"] = 51.19, ["Mega"] = 61.43, ["Mega|Fly"] = 131.2, ["Mega|Ride"] = 65.62, ["Mega|Fly|Ride"] = 124.69}},
    ["rbxassetid://11706157391"] = {name = "Steppe Lion", prices = {["default"] = 6.48, ["Ride"] = 73.48, ["Neon"] = 51.16, ["Neon|Ride"] = 69.75, ["Neon|Fly|Ride"] = 273.9, ["Mega"] = 527.63, ["Mega|Ride"] = 479.04, ["Mega|Fly|Ride"] = 636.57}},
    ["rbxassetid://18119064023"] = {name = "Bald Eagle", prices = {["default"] = 507.57, ["Ride"] = 472.5, ["Fly|Ride"] = 492.19, ["Neon"] = 4102, ["Neon|Ride"] = 1915.65, ["Mega|Fly|Ride"] = 7180.27}},
    ["rbxassetid://6060991172"] = {name = "Lynx", prices = {["default"] = 23.24, ["Fly"] = 137.82, ["Ride"] = 41.1, ["Fly|Ride"] = 84.72, ["Neon"] = 191.79, ["Neon|Ride"] = 198.8, ["Neon|Fly|Ride"] = 291.38, ["Mega|Ride"] = 1132.13, ["Mega|Fly|Ride"] = 959.1}},
    ["rbxassetid://10614198346"] = {name = "Pomeranian", prices = {["default"] = 2.1, ["Ride"] = 34.89, ["Fly|Ride"] = 281.29, ["Neon"] = 9.19, ["Neon|Ride"] = 47.39, ["Neon|Fly|Ride"] = 169.31, ["Mega"] = 98.44, ["Mega|Ride"] = 126.99, ["Mega|Fly|Ride"] = 273}},
    ["rbxassetid://13663102008"] = {name = "Angler Fish", prices = {["default"] = 3.19, ["Fly"] = 205.11, ["Ride"] = 26.25, ["Fly|Ride"] = 142.7, ["Neon"] = 16.31, ["Mega|Ride"] = 396.99}},
    ["rbxassetid://5067925193"] = {name = "Toy Monkey", prices = {["default"] = 39.18, ["Fly"] = 162.6, ["Ride"] = 43.5, ["Fly|Ride"] = 102.56, ["Neon|Ride"] = 347.82, ["Neon|Fly|Ride"] = 264.99, ["Mega"] = 2461.82, ["Mega|Ride"] = 1050, ["Mega|Fly|Ride"] = 1348.89}},
    ["rbxassetid://15698960105"] = {name = "Kookaburra", prices = {["default"] = 75.93, ["Ride"] = 101.88, ["Fly|Ride"] = 179.48, ["Neon"] = 434.43, ["Neon|Fly|Ride"] = 464.94, ["Mega"] = 8206.04, ["Mega|Fly|Ride"] = 2045.37}},
    ["rbxassetid://14266900917"] = {name = "Ring-tailed Lemur", prices = {["default"] = 196.86, ["Fly"] = 278.98, ["Ride"] = 196.87, ["Fly|Ride"] = 701.46, ["Neon"] = 1050, ["Neon|Ride"] = 889.11, ["Neon|Fly|Ride"] = 929.88, ["Mega|Fly|Ride"] = 4725}},
    ["rbxassetid://10467419131"] = {name = "Leopard Cat", prices = {["default"] = 10.83, ["Ride"] = 43.8, ["Fly|Ride"] = 150.94, ["Neon"] = 82.69, ["Neon|Ride"] = 118.02, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 388.49, ["Mega|Ride"] = 400.32, ["Mega|Fly|Ride"] = 334.46}},
    ["rbxassetid://6498256485"] = {name = "Crab", prices = {["default"] = 2.1, ["Fly"] = 28.09, ["Ride"] = 18.38, ["Fly|Ride"] = 41.9, ["Neon"] = 15.4, ["Neon|Ride"] = 22.87, ["Neon|Fly|Ride"] = 91.11, ["Mega"] = 93, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 131.15}},
    ["rbxassetid://5721843587"] = {name = "Glyptodon", prices = {["default"] = 6.17, ["Fly"] = 38.53, ["Ride"] = 18.47, ["Fly|Ride"] = 42.37, ["Neon"] = 31.5, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 92.99, ["Mega"] = 359.02, ["Mega|Ride"] = 328.26, ["Mega|Fly|Ride"] = 379.54}},
    ["rbxassetid://13979141397"] = {name = "Giant Anteater", prices = {["default"] = 317.94, ["Ride"] = 301.88, ["Fly|Ride"] = 588.66, ["Neon|Ride"] = 2150.35, ["Neon|Fly|Ride"] = 1710.97, ["Mega"] = 9847.23, ["Mega|Fly|Ride"] = 5081.32}},
    ["rbxassetid://109730629255705"] = {name = "Ruddy Duck", prices = {["default"] = 2.1, ["Neon"] = 10.17, ["Neon|Ride"] = 68.73, ["Neon|Fly|Ride"] = 122.08, ["Mega"] = 55.41, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 447.99}},
    ["rbxassetid://6498259006"] = {name = "Clownfish", prices = {["default"] = 3.94, ["Ride"] = 15.75, ["Fly|Ride"] = 40.92, ["Neon"] = 26.24, ["Neon|Fly"] = 71.79, ["Neon|Ride"] = 31.81, ["Neon|Fly|Ride"] = 78.74, ["Mega"] = 204.14, ["Mega|Fly"] = 196.88, ["Mega|Ride"] = 170.63, ["Mega|Fly|Ride"] = 244.14}},
    ["rbxassetid://11758569695"] = {name = "Amami Rabbit", prices = {["default"] = 15.52, ["Ride"] = 137.07, ["Neon"] = 278.55, ["Neon|Fly"] = 410.21, ["Neon|Ride"] = 236.24, ["Neon|Fly|Ride"] = 295.24, ["Mega"] = 527.69, ["Mega|Ride"] = 609.31, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://11505509482"] = {name = "Ice Wolf", prices = {["default"] = 119.44, ["Fly"] = 273.82, ["Ride"] = 109.71, ["Fly|Ride"] = 127.32, ["Neon"] = 634.79, ["Neon|Ride"] = 697.32, ["Neon|Fly|Ride"] = 656.25, ["Mega|Fly|Ride"] = 2378.25}},
    ["rbxassetid://9994480266"] = {name = "Royal Palace Spaniel", prices = {["default"] = 23.63, ["Fly"] = 47.19, ["Ride"] = 27.71, ["Fly|Ride"] = 63.38, ["Neon"] = 96.42, ["Neon|Ride"] = 104.99, ["Neon|Fly|Ride"] = 151.82, ["Mega"] = 683.17, ["Mega|Ride"] = 507.66, ["Mega|Fly|Ride"] = 531.96}},
    ["rbxassetid://100897154120273"] = {name = "Clumpty", prices = {["default"] = 2.1, ["Ride"] = 28.88, ["Neon"] = 2.1, ["Neon|Ride"] = 63, ["Neon|Fly|Ride"] = 684.2, ["Mega"] = 20.48, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://11108831285"] = {name = "Ocelot", prices = {["default"] = 2.1, ["Fly"] = 39.37, ["Ride"] = 19.69, ["Fly|Ride"] = 72.19, ["Neon"] = 2.1, ["Neon|Ride"] = 19.5, ["Neon|Fly|Ride"] = 72.76, ["Mega"] = 23.91, ["Mega|Fly"] = 83.25, ["Mega|Ride"] = 48.09, ["Mega|Fly|Ride"] = 123.11}},
    ["rbxassetid://99323773370664"] = {name = "Dire Wolf", prices = {["default"] = 13.1, ["Fly"] = 410.21, ["Ride"] = 89.23, ["Fly|Ride"] = 96.42, ["Neon"] = 37.43, ["Neon|Ride"] = 63.93, ["Neon|Fly|Ride"] = 185.99, ["Mega"] = 154.88, ["Mega|Ride"] = 216.57, ["Mega|Fly|Ride"] = 315.27}},
    ["rbxassetid://17649307413"] = {name = "Mini Pig", prices = {["default"] = 1508.07, ["Ride"] = 1271.82, ["Fly|Ride"] = 1365, ["Neon"] = 4200, ["Neon|Ride"] = 3609.38, ["Neon|Fly|Ride"] = 3609.38, ["Mega|Fly|Ride"] = 12475.32}},
    ["rbxassetid://12720029753"] = {name = "Border Collie", prices = {["default"] = 446.24, ["Ride"] = 555.08, ["Fly|Ride"] = 616.32, ["Neon"] = 2407.89, ["Neon|Ride"] = 2005.4, ["Neon|Fly|Ride"] = 2051.52, ["Mega"] = 16412.05, ["Mega|Fly|Ride"] = 8206.04}},
    ["rbxassetid://4440866760"] = {name = "Pig", prices = {["default"] = 346.5, ["Ride"] = 383.24, ["Fly|Ride"] = 488.51, ["Neon"] = 976.37, ["Neon|Ride"] = 791, ["Neon|Fly|Ride"] = 786.19, ["Mega|Fly|Ride"] = 2362.4}},
    ["rbxassetid://4506925854"] = {name = "Arctic Fox", prices = {["default"] = 369.6, ["Fly"] = 410.86, ["Ride"] = 410.82, ["Fly|Ride"] = 453.5, ["Neon"] = 925.32, ["Neon|Fly"] = 2051.01, ["Neon|Ride"] = 1368.02, ["Neon|Fly|Ride"] = 1137.94, ["Mega|Fly|Ride"] = 4780.01}},
    ["rbxassetid://11758575618"] = {name = "Black Moon Bear", prices = {["default"] = 2.1, ["Fly"] = 64.31, ["Ride"] = 14.39, ["Fly|Ride"] = 33.68, ["Neon"] = 5.87, ["Neon|Ride"] = 48.57, ["Neon|Fly|Ride"] = 137.47, ["Mega"] = 92.33, ["Mega|Ride"] = 137.78, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://15547272520"] = {name = "Christmas Pudding Pup", prices = {["default"] = 380.29, ["Fly"] = 1368.02, ["Ride"] = 426.62, ["Fly|Ride"] = 549.94, ["Neon"] = 1368.02, ["Neon|Ride"] = 1365, ["Neon|Fly|Ride"] = 1381.7, ["Mega|Ride"] = 6564.83, ["Mega|Fly|Ride"] = 4796.49}},
    ["rbxassetid://78519945248690"] = {name = "Zombie Chick", prices = {["default"] = 2.52, ["Neon"] = 15.12, ["Neon|Ride"] = 48.29, ["Neon|Fly|Ride"] = 205.43, ["Mega"] = 83.91, ["Mega|Ride"] = 183.35, ["Mega|Fly|Ride"] = 369.29}},
    ["rbxassetid://10357178561"] = {name = "Ibis", prices = {["default"] = 2.1, ["Fly"] = 24.7, ["Ride"] = 17.36, ["Fly|Ride"] = 31.01, ["Neon"] = 7.87, ["Neon|Ride"] = 27.72, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 104.81, ["Mega|Ride"] = 192.93}},
    ["rbxassetid://96759122303055"] = {name = "Clubtail Dragonfly", prices = {["default"] = 2.1, ["Fly"] = 57.75, ["Neon"] = 3.94, ["Neon|Ride"] = 39.38, ["Mega"] = 28.86, ["Mega|Ride"] = 173.78}},
    ["rbxassetid://12778628897"] = {name = "Karate Gorilla", prices = {["default"] = 37.2, ["Fly|Ride"] = 459.38, ["Neon"] = 244.13, ["Neon|Ride"] = 351.29, ["Mega"] = 656.25, ["Mega|Ride"] = 929.88, ["Mega|Fly|Ride"] = 773.07}},
    ["rbxassetid://13104121371"] = {name = "Poison Dart Frog", prices = {["default"] = 2.1, ["Ride"] = 23.22, ["Fly|Ride"] = 68.25, ["Neon"] = 38.99, ["Mega"] = 328.13, ["Mega|Ride"] = 423.1, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://71881209536633"] = {name = "Humbug", prices = {["default"] = 2.1, ["Ride"] = 55.12, ["Neon"] = 3.05, ["Neon|Ride"] = 38.91, ["Neon|Fly|Ride"] = 116.95, ["Mega"] = 20.52, ["Mega|Ride"] = 90.19, ["Mega|Fly|Ride"] = 123.05}},
    ["rbxassetid://11109314958"] = {name = "Ghost Wolf", prices = {["default"] = 3.84, ["Fly"] = 36.01, ["Ride"] = 20.52, ["Fly|Ride"] = 67.4, ["Neon"] = 8.58, ["Neon|Fly"] = 96.42, ["Neon|Ride"] = 40.57, ["Neon|Fly|Ride"] = 82.69, ["Mega"] = 110.97, ["Mega|Fly"] = 171.32, ["Mega|Ride"] = 113.88, ["Mega|Fly|Ride"] = 184.71}},
    ["rbxassetid://16088267136"] = {name = "Wildfire Hawk", prices = {["default"] = 3.82, ["Fly"] = 91.88, ["Ride"] = 15.4, ["Fly|Ride"] = 51.97, ["Neon"] = 19.69, ["Neon|Fly"] = 116.92, ["Neon|Ride"] = 155.74, ["Neon|Fly|Ride"] = 131.24, ["Mega"] = 237.57, ["Mega|Ride"] = 300.51, ["Mega|Fly|Ride"] = 326.21}},
    ["rbxassetid://16898328648"] = {name = "Preppy Capuchin Monkey", prices = {["default"] = 8.91, ["Ride"] = 27.71, ["Neon"] = 62.77, ["Mega"] = 504.47, ["Mega|Ride"] = 768.31, ["Mega|Fly|Ride"] = 426.57}},
    ["rbxassetid://15921713413"] = {name = "Thorny Devil", prices = {["default"] = 2.1, ["Fly"] = 6199.89, ["Ride"] = 41.04, ["Neon"] = 37.79, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 273.9, ["Mega"] = 441.35, ["Mega|Ride"] = 714, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://16441364976"] = {name = "Gold Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 98.47, ["Ride"] = 18.38, ["Fly|Ride"] = 45.94, ["Neon"] = 6.16, ["Neon|Fly"] = 82.48, ["Neon|Ride"] = 23.94, ["Neon|Fly|Ride"] = 59.52, ["Mega"] = 58.49, ["Mega|Ride"] = 126, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://8077189117"] = {name = "Puffin", prices = {["default"] = 152.4, ["Ride"] = 178.5, ["Fly|Ride"] = 209.99, ["Neon"] = 1686.78, ["Neon|Ride"] = 946.01, ["Neon|Fly|Ride"] = 1007.75, ["Mega"] = 8206.04, ["Mega|Ride"] = 4103.03, ["Mega|Fly|Ride"] = 4103.03}},
    ["rbxassetid://8663441120"] = {name = "Lunar Tiger", prices = {["default"] = 2.1, ["Fly"] = 15.87, ["Ride"] = 14.94, ["Fly|Ride"] = 34.96, ["Neon"] = 2.1, ["Neon|Fly"] = 31.4, ["Neon|Ride"] = 17.63, ["Neon|Fly|Ride"] = 53.8, ["Mega"] = 36.94, ["Mega|Ride"] = 52.64, ["Mega|Fly|Ride"] = 121.79}},
    ["rbxassetid://17174216294"] = {name = "Skunk", prices = {["default"] = 234.61, ["Fly"] = 137.44, ["Ride"] = 69.57, ["Fly|Ride"] = 160.12, ["Neon"] = 164.1, ["Neon|Ride"] = 151.79, ["Mega"] = 312.38, ["Mega|Ride"] = 464.94, ["Mega|Fly|Ride"] = 515.97}},
    ["rbxassetid://13981141292"] = {name = "Kiwi", prices = {["default"] = 26.25, ["Ride"] = 205.11, ["Fly|Ride"] = 170.63, ["Neon"] = 155.66, ["Neon|Ride"] = 410.21, ["Mega"] = 786.19, ["Mega|Ride"] = 906.64, ["Mega|Fly|Ride"] = 944.99}},
    ["rbxassetid://3409443617"] = {name = "Meerkat", prices = {["default"] = 145.69, ["Ride"] = 253.21, ["Fly|Ride"] = 309.54, ["Neon"] = 708.74, ["Neon|Ride"] = 840.93, ["Neon|Fly|Ride"] = 895.79, ["Mega|Fly|Ride"] = 3337.82}},
    ["rbxassetid://99042906016947"] = {name = "Seafoam Butterfly", prices = {["default"] = 15.74, ["Fly"] = 168.88, ["Fly|Ride"] = 139.5, ["Neon"] = 155.76, ["Neon|Ride"] = 145.34, ["Mega"] = 287.44, ["Mega|Ride"] = 406.88, ["Mega|Fly|Ride"] = 1230.92}},
    ["rbxassetid://15504847683"] = {name = "Gingerbread Hare", prices = {["default"] = 11.82, ["Ride"] = 137.44, ["Fly|Ride"] = 615.32, ["Neon"] = 89.23, ["Neon|Ride"] = 199.5, ["Mega"] = 771.75, ["Mega|Ride"] = 615.47, ["Mega|Fly|Ride"] = 2051.52}},
    ["rbxassetid://15302316802"] = {name = "Peppermint Penguin", prices = {["default"] = 1050, ["Ride"] = 1043.44, ["Fly|Ride"] = 1154.99, ["Neon"] = 4649.6, ["Neon|Ride"] = 4790.63, ["Neon|Fly|Ride"] = 4615.9, ["Mega|Fly|Ride"] = 17882.97}},
    ["rbxassetid://10318106124"] = {name = "Scarlet Butterfly", prices = {["default"] = 7.11, ["Fly"] = 19.58, ["Ride"] = 19.5, ["Fly|Ride"] = 43.32, ["Neon"] = 26.24, ["Neon|Fly"] = 84.06, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 82.07, ["Mega"] = 232.47, ["Mega|Fly|Ride"] = 345.19}},
    ["rbxassetid://14145989411"] = {name = "Toy Poodle", prices = {["default"] = 5.16, ["Ride"] = 35.44, ["Fly|Ride"] = 135.19, ["Neon"] = 96.42, ["Mega"] = 244.62, ["Mega|Fly"] = 1260, ["Mega|Ride"] = 242.05, ["Mega|Fly|Ride"] = 594.96}},
    ["rbxassetid://82833859118891"] = {name = "Snowy Mammoth", prices = {["default"] = 2.1, ["Fly"] = 90.2, ["Ride"] = 27.3, ["Fly|Ride"] = 69.57, ["Neon"] = 15.4, ["Neon|Ride"] = 28.28, ["Neon|Fly|Ride"] = 205.16, ["Mega"] = 91.88, ["Mega|Ride"] = 189.57, ["Mega|Fly|Ride"] = 275.63}},
    ["rbxassetid://12917346501"] = {name = "Happy Duckling", prices = {["default"] = 15.45, ["Fly"] = 34.89, ["Ride"] = 31.39, ["Fly|Ride"] = 80.27, ["Neon"] = 69.57, ["Neon|Ride"] = 77.04, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 342.69, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 456.74}},
    ["rbxassetid://7064993901"] = {name = "2021 Uplift Butterfly", prices = {["default"] = 2.5, ["Fly"] = 20.52, ["Ride"] = 17.75, ["Fly|Ride"] = 40.85, ["Neon"] = 25.58, ["Neon|Fly"] = 43.32, ["Neon|Ride"] = 36.93, ["Neon|Fly|Ride"] = 93.18, ["Mega"] = 130.29, ["Mega|Ride"] = 310.36, ["Mega|Fly|Ride"] = 254.41}},
    ["rbxassetid://10926054144"] = {name = "Slug", prices = {["default"] = 2.1, ["Neon"] = 13.13, ["Neon|Fly"] = 13125, ["Neon|Ride"] = 56.25, ["Neon|Fly|Ride"] = 205.16, ["Mega"] = 131.15, ["Mega|Ride"] = 170.63, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://11571113906"] = {name = "Glacier Moth", prices = {["default"] = 205.09, ["Ride"] = 229.69, ["Fly|Ride"] = 342.53, ["Neon|Fly"] = 1025.52, ["Neon|Fly|Ride"] = 984.38}},
    ["rbxassetid://73641371341710"] = {name = "Ice Cube", prices = {["default"] = 2.1, ["Fly"] = 32.71, ["Ride"] = 27.71, ["Fly|Ride"] = 72.19, ["Neon"] = 7.87, ["Neon|Fly"] = 82.06, ["Neon|Ride"] = 27.09, ["Neon|Fly|Ride"] = 119.83, ["Mega"] = 81.38, ["Mega|Fly"] = 410.31, ["Mega|Ride"] = 96.44, ["Mega|Fly|Ride"] = 258.5}},
    ["rbxassetid://13077767764"] = {name = "Eel", prices = {["default"] = 2.1, ["Ride"] = 81.79, ["Fly|Ride"] = 88.86, ["Neon"] = 52.5, ["Neon|Fly"] = 196.88, ["Neon|Ride"] = 188.27, ["Mega|Ride"] = 244.14, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://134995672989153"] = {name = "Hammerhead Shark", prices = {["default"] = 2.88, ["Ride"] = 26.25, ["Neon"] = 12.75, ["Neon|Ride"] = 1368.02, ["Mega"] = 94.5, ["Mega|Fly"] = 137.47, ["Mega|Ride"] = 141.75, ["Mega|Fly|Ride"] = 410.01}},
    ["rbxassetid://15555939727"] = {name = "Snow Monkey", prices = {["default"] = 393.75, ["Ride"] = 655.98, ["Fly|Ride"] = 697.41, ["Neon"] = 1085.62, ["Neon|Fly"] = 1230.6, ["Neon|Ride"] = 1230.6, ["Mega"] = 4649.34, ["Mega|Ride"] = 3410.3, ["Mega|Fly|Ride"] = 2875.69}},
    ["rbxassetid://11758575992"] = {name = "Water Rabbit", prices = {["default"] = 23.41, ["Fly"] = 123.08, ["Ride"] = 147.69, ["Fly|Ride"] = 187.68, ["Neon"] = 144.38, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 620.7, ["Mega|Ride"] = 735, ["Mega|Fly|Ride"] = 840}},
    ["rbxassetid://90987982535884"] = {name = "Great Pyrenees", prices = {["default"] = 18.26, ["Fly"] = 74.41, ["Ride"] = 36.66, ["Fly|Ride"] = 98.44, ["Neon"] = 97.67, ["Neon|Ride"] = 142.42, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 548.02, ["Mega|Ride"] = 421.23, ["Mega|Fly|Ride"] = 670.86}},
    ["rbxassetid://84560154336174"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Ride"] = 82.06, ["Neon"] = 3.59, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 131.25, ["Mega"] = 45.94, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 235.94}},
    ["rbxassetid://4506847061"] = {name = "Reindeer", prices = {["default"] = 108.84, ["Ride"] = 118.13, ["Fly|Ride"] = 170.63, ["Neon"] = 203.44, ["Neon|Fly"] = 245.85, ["Neon|Ride"] = 287.15, ["Neon|Fly|Ride"] = 360.51, ["Mega|Fly|Ride"] = 1011.71}},
    ["rbxassetid://98687388677942"] = {name = "Moonpine", prices = {["default"] = 2.1, ["Ride"] = 19.03, ["Fly|Ride"] = 52.5, ["Neon"] = 6.46, ["Neon|Ride"] = 55.4, ["Neon|Fly|Ride"] = 122.08, ["Mega"] = 52.5, ["Mega|Fly|Ride"] = 410.31}},
    ["rbxassetid://11109032702"] = {name = "Green Amazon", prices = {["default"] = 419.99, ["Fly"] = 102.56, ["Ride"] = 28.09, ["Fly|Ride"] = 84, ["Neon"] = 101.14, ["Neon|Ride"] = 155.67, ["Neon|Fly|Ride"] = 137.47, ["Mega"] = 389.82, ["Mega|Fly"] = 971.25, ["Mega|Ride"] = 409.29, ["Mega|Fly|Ride"] = 418.69}},
    ["rbxassetid://3743730108"] = {name = "Black Panther", prices = {["default"] = 44.27, ["Fly"] = 82.06, ["Ride"] = 79.95, ["Fly|Ride"] = 159.84, ["Neon"] = 313.82, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 356.85, ["Mega"] = 1230.92, ["Mega|Ride"] = 3420.89, ["Mega|Fly|Ride"] = 1169.44}},
    ["rbxassetid://3181727398"] = {name = "Chocolate Labrador", prices = {["default"] = 2.1, ["Fly"] = 15.65, ["Ride"] = 13.84, ["Fly|Ride"] = 30.54, ["Neon"] = 2.1, ["Neon|Fly"] = 23.96, ["Neon|Ride"] = 17.47, ["Neon|Fly|Ride"] = 30.19, ["Mega"] = 14.99, ["Mega|Fly"] = 116.24, ["Mega|Ride"] = 31.06, ["Mega|Fly|Ride"] = 82.6}},
    ["rbxassetid://134636987874448"] = {name = "Nebula Snake", prices = {["default"] = 2.21, ["Fly"] = 32.82, ["Ride"] = 39.29, ["Fly|Ride"] = 131.25, ["Neon"] = 16.96, ["Neon|Ride"] = 55.4, ["Neon|Fly|Ride"] = 410.31, ["Mega"] = 129.94, ["Mega|Ride"] = 272.08, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://13104122150"] = {name = "Hippo", prices = {["default"] = 15.12, ["Ride"] = 56.44, ["Fly|Ride"] = 112.88, ["Neon"] = 102.56, ["Neon|Ride"] = 137.44, ["Mega"] = 1025.77, ["Mega|Ride"] = 559.81}},
    ["rbxassetid://103821295208934"] = {name = "Black Rhino", prices = {["default"] = 2.1, ["Ride"] = 13.08, ["Neon"] = 2.1, ["Neon|Ride"] = 28.88, ["Neon|Fly|Ride"] = 95.81, ["Mega"] = 19.74, ["Mega|Ride"] = 79.23, ["Mega|Fly|Ride"] = 212.82}},
    ["rbxassetid://14782580070"] = {name = "Undead Elk", prices = {["default"] = 12.99, ["Fly"] = 182.01, ["Ride"] = 58.96, ["Fly|Ride"] = 164.07, ["Neon"] = 65.41, ["Neon|Ride"] = 109.27, ["Neon|Fly|Ride"] = 143.07, ["Mega"] = 503.66, ["Mega|Fly"] = 787.5, ["Mega|Ride"] = 330.65, ["Mega|Fly|Ride"] = 609.31}},
    ["rbxassetid://8566683782"] = {name = "Giant Blue Scarab", prices = {["default"] = 10.84, ["Fly"] = 103.69, ["Ride"] = 26.5, ["Fly|Ride"] = 98.44, ["Neon"] = 430.5, ["Neon|Ride"] = 64.32, ["Neon|Fly|Ride"] = 172.05, ["Mega|Ride"] = 354.38, ["Mega|Fly|Ride"] = 547.77}},
    ["rbxassetid://14850232913"] = {name = "Cute-A-Cabra", prices = {["default"] = 3.9, ["Ride"] = 18.86, ["Neon"] = 26.17, ["Neon|Fly"] = 699.57, ["Neon|Ride"] = 77.44, ["Mega"] = 231, ["Mega|Ride"] = 218.35, ["Mega|Fly|Ride"] = 469.88}},
    ["rbxassetid://15508248825"] = {name = "Eggnog Dog", prices = {["default"] = 105, ["Fly"] = 2051.01, ["Fly|Ride"] = 248.49, ["Neon"] = 143.99, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 6198.73, ["Mega|Ride"] = 577.5, ["Mega|Fly|Ride"] = 473.75}},
    ["rbxassetid://17822797244"] = {name = "Orange Betta Fish", prices = {["default"] = 2.1, ["Ride"] = 145.68, ["Fly|Ride"] = 196.88, ["Neon"] = 12.48, ["Neon|Fly"] = 55.4, ["Neon|Ride"] = 32.43, ["Mega"] = 68.16, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 151.82}},
    ["rbxassetid://9922274393"] = {name = "Retired Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://103431939950304"] = {name = "Pink Dog", prices = {["default"] = 2.1, ["Ride"] = 55.53, ["Neon"] = 3.89, ["Neon|Ride"] = 101.54, ["Mega"] = 26.24, ["Mega|Ride"] = 137.47, ["Mega|Fly|Ride"] = 273.9}},
    ["rbxassetid://15227882502"] = {name = "Christmas Future Egg", prices = {["default"] = 78.75}},
    ["rbxassetid://12597276740"] = {name = "Red Sand Dollar", prices = {["default"] = 45.93, ["Fly"] = 78.75, ["Ride"] = 39.38, ["Neon|Ride"] = 266.38, ["Neon|Fly|Ride"] = 313.68, ["Mega"] = 1230.92, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 889.88}},
    ["rbxassetid://136447612467002"] = {name = "Glyptodon Ducky", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 28.39, ["Neon|Fly|Ride"] = 123.11, ["Mega"] = 30.19, ["Mega|Ride"] = 273.9, ["Mega|Fly|Ride"] = 307.74}},
    ["rbxassetid://101033810950061"] = {name = "Sea Slug", prices = {["default"] = 472.5, ["Ride"] = 577.5, ["Fly|Ride"] = 641.82, ["Neon"] = 2046.91, ["Neon|Ride"] = 1778.22, ["Mega"] = 16412.05, ["Mega|Fly|Ride"] = 10500}},
    ["rbxassetid://14353536658"] = {name = "Birthday Butterfly 2023", prices = {["default"] = 2.1, ["Fly"] = 26.17, ["Ride"] = 23.45, ["Fly|Ride"] = 66.26, ["Neon"] = 27.71, ["Neon|Ride"] = 273.82, ["Neon|Fly|Ride"] = 129.94, ["Mega"] = 87.71, ["Mega|Fly"] = 153.88, ["Mega|Ride"] = 144.37, ["Mega|Fly|Ride"] = 547.77}},
    ["rbxassetid://9938967851"] = {name = "Tan Chow-Chow", prices = {["default"] = 2.1, ["Fly"] = 95.55, ["Ride"] = 19.69, ["Fly|Ride"] = 69.21, ["Neon"] = 18.41, ["Neon|Ride"] = 35.91, ["Neon|Fly|Ride"] = 99.65, ["Mega"] = 345.19, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 227.26}},
    ["rbxassetid://14448124117"] = {name = "Chipmunk", prices = {["default"] = 18.38, ["Fly"] = 76.93, ["Ride"] = 65.63, ["Fly|Ride"] = 106.32, ["Neon"] = 126, ["Neon|Ride"] = 171.27, ["Neon|Fly|Ride"] = 313.69, ["Mega"] = 820.61, ["Mega|Ride"] = 879.38, ["Mega|Fly|Ride"] = 820.61}},
    ["rbxassetid://13104108894"] = {name = "Lammergeier", prices = {["default"] = 4.19, ["Fly"] = 410.21, ["Ride"] = 39.38, ["Fly|Ride"] = 721.88, ["Neon"] = 30.38, ["Mega"] = 258.57}},
    ["rbxassetid://14446659851"] = {name = "Raccoon", prices = {["default"] = 6.45, ["Fly"] = 139.53, ["Ride"] = 137.44, ["Fly|Ride"] = 157.5, ["Neon"] = 104.36, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 359.28, ["Mega"] = 384.04, ["Mega|Ride"] = 388.23, ["Mega|Fly|Ride"] = 684.2}},
    ["rbxassetid://84477079324217"] = {name = "Peachick", prices = {["default"] = 5.98, ["Fly"] = 105, ["Ride"] = 32.82, ["Fly|Ride"] = 133.88, ["Neon"] = 32.9, ["Neon|Ride"] = 155.74, ["Neon|Fly|Ride"] = 204.75, ["Mega"] = 216.57, ["Mega|Fly"] = 547.77, ["Mega|Ride"] = 301.88, ["Mega|Fly|Ride"] = 340.83}},
    ["rbxassetid://9718162456"] = {name = "Donkey", prices = {["default"] = 2.1, ["Fly"] = 46.51, ["Ride"] = 12.03, ["Fly|Ride"] = 68.73, ["Neon"] = 2.1, ["Neon|Fly"] = 41.99, ["Neon|Ride"] = 13.79, ["Neon|Fly|Ride"] = 32.82, ["Mega"] = 14.86, ["Mega|Fly"] = 32.21, ["Mega|Ride"] = 24.63, ["Mega|Fly|Ride"] = 110.96}},
    ["rbxassetid://93800993117604"] = {name = "Love Bird", prices = {["default"] = 27.69, ["Fly"] = 109.75, ["Ride"] = 65.63, ["Fly|Ride"] = 102.56, ["Neon"] = 22.34, ["Neon|Fly"] = 116.23, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 102.59, ["Mega"] = 183.75, ["Mega|Ride"] = 217.88, ["Mega|Fly|Ride"] = 714.67}},
    ["rbxassetid://13665143675"] = {name = "Lion Cub", prices = {["default"] = 294.83, ["Ride"] = 350.44, ["Fly|Ride"] = 421.32, ["Neon"] = 1240.22, ["Neon|Ride"] = 1368.02, ["Neon|Fly|Ride"] = 1252.12, ["Mega"] = 4374.57, ["Mega|Ride"] = 5026.21, ["Mega|Fly|Ride"] = 4513.31}},
    ["rbxassetid://13883284001"] = {name = "Ice Cream Hermit Crab", prices = {["default"] = 81.24, ["Ride"] = 113.85, ["Fly|Ride"] = 295.24, ["Neon"] = 315, ["Neon|Ride"] = 308.44, ["Neon|Fly|Ride"] = 543.55, ["Mega"] = 2188.96, ["Mega|Ride"] = 1509.38, ["Mega|Fly|Ride"] = 1514.63}},
    ["rbxassetid://8938701212"] = {name = "Woodpecker", prices = {["default"] = 2.1, ["Fly"] = 17.06, ["Ride"] = 14.44, ["Fly|Ride"] = 40.84, ["Neon"] = 7.88, ["Neon|Fly"] = 68.73, ["Neon|Ride"] = 34.89, ["Neon|Fly|Ride"] = 63.31, ["Mega|Fly"] = 204.14, ["Mega|Ride"] = 76.95, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://4800190034"] = {name = "Toucan", prices = {["default"] = 2.1, ["Fly"] = 18.04, ["Ride"] = 15.4, ["Fly|Ride"] = 32.8, ["Neon"] = 6.45, ["Neon|Fly"] = 52.11, ["Neon|Ride"] = 19.5, ["Neon|Fly|Ride"] = 62.27, ["Mega"] = 64.63, ["Mega|Fly"] = 344.03, ["Mega|Ride"] = 116.82, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://15886122789"] = {name = "Deathstalker Scorpion", prices = {["default"] = 2.1, ["Ride"] = 21, ["Fly|Ride"] = 98.44, ["Neon"] = 39.38, ["Mega"] = 205.16, ["Mega|Ride"] = 410.31, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://12139402705"] = {name = "Sheeeeep", prices = {["default"] = 236.23, ["Ride"] = 249.38, ["Fly|Ride"] = 375.38, ["Neon"] = 1333.16, ["Neon|Ride"] = 984.5, ["Neon|Fly|Ride"] = 1983.82, ["Mega|Ride"] = 8206.04, ["Mega|Fly|Ride"] = 3675}},
    ["rbxassetid://7126720389"] = {name = "Hydra", prices = {["default"] = 2.1, ["Ride"] = 13.65, ["Fly|Ride"] = 32.67, ["Neon"] = 18.47, ["Neon|Fly"] = 104.97, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 124.38, ["Mega"] = 255.93, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 380.63}},
    ["rbxassetid://17662289865"] = {name = "Punk Pony", prices = {["default"] = 5.75, ["Ride"] = 83.42, ["Fly|Ride"] = 205.11, ["Neon"] = 54.17, ["Neon|Ride"] = 410.21, ["Neon|Fly|Ride"] = 273.9, ["Mega"] = 253.32, ["Mega|Ride"] = 287.43, ["Mega|Fly|Ride"] = 413.22}},
    ["rbxassetid://84009422958505"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 28.13, ["Neon"] = 5.09, ["Neon|Ride"] = 155.6, ["Mega"] = 65.54, ["Mega|Ride"] = 204.14}},
    ["rbxassetid://9473352533"] = {name = "Space Whale", prices = {["default"] = 13.13, ["Fly"] = 58.47, ["Ride"] = 20.52, ["Fly|Ride"] = 74.8, ["Neon"] = 79.71, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 137.47, ["Mega"] = 575.19, ["Mega|Ride"] = 438.38, ["Mega|Fly|Ride"] = 656.15}},
    ["rbxassetid://71528203783155"] = {name = "Pupcake", prices = {["default"] = 43.32, ["Ride"] = 107.63, ["Fly|Ride"] = 209.99, ["Neon"] = 196.88, ["Neon|Fly"] = 393.75, ["Neon|Ride"] = 257.25, ["Neon|Fly|Ride"] = 514.95, ["Mega"] = 684.2, ["Mega|Fly"] = 2154.09, ["Mega|Ride"] = 689.07, ["Mega|Fly|Ride"] = 834.98}},
    ["rbxassetid://4440867010"] = {name = "Drake", prices = {["default"] = 23.36, ["Ride"] = 40.14, ["Fly|Ride"] = 113.85, ["Neon"] = 155.89, ["Neon|Fly"] = 290.07, ["Neon|Ride"] = 201.01, ["Neon|Fly|Ride"] = 203.44, ["Mega|Ride"] = 840.16, ["Mega|Fly|Ride"] = 745.74}},
    ["rbxassetid://9708962205"] = {name = "Parakeet", prices = {["default"] = 2.1, ["Fly"] = 20.52, ["Ride"] = 14.6, ["Fly|Ride"] = 34.89, ["Neon"] = 2.1, ["Neon|Fly"] = 23.72, ["Neon|Ride"] = 18.13, ["Neon|Fly|Ride"] = 45.66, ["Mega"] = 20.52, ["Mega|Fly"] = 34.9, ["Mega|Ride"] = 39.69, ["Mega|Fly|Ride"] = 94.5}},
    ["rbxassetid://4883302468"] = {name = "Shrew", prices = {["default"] = 244.13, ["Ride"] = 270.12, ["Fly|Ride"] = 317.52, ["Neon"] = 721.88, ["Neon|Ride"] = 1085.48, ["Neon|Fly|Ride"] = 1085.26, ["Mega|Fly|Ride"] = 4240.47}},
    ["rbxassetid://11507151679"] = {name = "Irish Elk", prices = {["default"] = 104.99, ["Fly"] = 101.2, ["Ride"] = 47.25, ["Fly|Ride"] = 105, ["Neon"] = 127.86, ["Neon|Fly|Ride"] = 328.13}},
    ["rbxassetid://17163957321"] = {name = "Blue Jay", prices = {["default"] = 2.1, ["Fly"] = 34, ["Ride"] = 15.61, ["Fly|Ride"] = 44.18, ["Neon"] = 5.91, ["Neon|Fly"] = 34.61, ["Neon|Ride"] = 26.75, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 54.65, ["Mega|Fly"] = 273.9, ["Mega|Ride"] = 62.78, ["Mega|Fly|Ride"] = 291.77}},
    ["rbxassetid://8705079225"] = {name = "Abyssinian Cat", prices = {["default"] = 2.1, ["Fly"] = 30.78, ["Ride"] = 19.5, ["Fly|Ride"] = 39.5, ["Neon"] = 2.1, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 24.93, ["Neon|Fly|Ride"] = 129.31, ["Mega"] = 28.88, ["Mega|Fly"] = 137.47, ["Mega|Ride"] = 63, ["Mega|Fly|Ride"] = 154.91}},
    ["rbxassetid://17059483392"] = {name = "Velociraptor", prices = {["default"] = 2.1, ["Ride"] = 28.74, ["Fly|Ride"] = 69.29, ["Neon"] = 11.3, ["Neon|Fly"] = 697.41, ["Neon|Ride"] = 55.04, ["Neon|Fly|Ride"] = 99.75, ["Mega"] = 127.98, ["Mega|Ride"] = 194.09, ["Mega|Fly|Ride"] = 354.38}},
    ["rbxassetid://16548686870"] = {name = "Hamster", prices = {["default"] = 15.63, ["Fly"] = 38.07, ["Ride"] = 28.19, ["Fly|Ride"] = 64.14, ["Neon"] = 56.96, ["Neon|Fly"] = 260.49, ["Neon|Ride"] = 56.47, ["Neon|Fly|Ride"] = 105, ["Mega"] = 304.5, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 373.9}},
    ["rbxassetid://13883285383"] = {name = "Castle Hermit Crab", prices = {["default"] = 9.18, ["Ride"] = 55.1, ["Neon"] = 59.3, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 275.63, ["Mega|Ride"] = 414.75, ["Mega|Fly|Ride"] = 463.65}},
    ["rbxassetid://82240382561696"] = {name = "Cocoadile", prices = {["default"] = 2.24, ["Ride"] = 43.3, ["Fly|Ride"] = 273.82, ["Neon"] = 2.1, ["Neon|Ride"] = 31.38, ["Neon|Fly|Ride"] = 100.64, ["Mega"] = 30.65, ["Mega|Ride"] = 70.26, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://74702714943302"] = {name = "Grave Owl", prices = {["default"] = 6.47, ["Fly"] = 96.42, ["Ride"] = 24.75, ["Fly|Ride"] = 131.25, ["Neon"] = 18.62, ["Neon|Fly"] = 102.8, ["Neon|Ride"] = 72.62, ["Neon|Fly|Ride"] = 154.63, ["Mega"] = 199.37, ["Mega|Ride"] = 158.24, ["Mega|Fly|Ride"] = 269.79}},
    ["rbxassetid://97556530589327"] = {name = "Bison", prices = {["default"] = 2.1, ["Fly"] = 68.73, ["Ride"] = 191.79, ["Neon"] = 3.93, ["Neon|Fly"] = 109.75, ["Neon|Ride"] = 45.78, ["Neon|Fly|Ride"] = 102.3, ["Mega"] = 24.44, ["Mega|Ride"] = 91.35, ["Mega|Fly|Ride"] = 123.11}},
    ["rbxassetid://11694855214"] = {name = "Shetland Pony Dark Brown", prices = {["default"] = 2.1, ["Fly"] = 39.63, ["Ride"] = 15.65, ["Fly|Ride"] = 68.62, ["Neon"] = 4.92, ["Neon|Ride"] = 20.26, ["Neon|Fly|Ride"] = 107.63, ["Mega"] = 52.41, ["Mega|Ride"] = 85.79, ["Mega|Fly|Ride"] = 236.15}},
    ["rbxassetid://14398823196"] = {name = "Alpaca", prices = {["default"] = 721.86, ["Ride"] = 689.07, ["Fly|Ride"] = 825.57, ["Neon|Ride"] = 3150, ["Neon|Fly|Ride"] = 3248.38, ["Mega|Fly|Ride"] = 17780.4}},
    ["rbxassetid://5721843716"] = {name = "Pterodactyl", prices = {["default"] = 2.1, ["Fly"] = 18.69, ["Ride"] = 13.68, ["Fly|Ride"] = 27.6, ["Neon"] = 11.46, ["Neon|Fly"] = 123.08, ["Neon|Ride"] = 27.88, ["Neon|Fly|Ride"] = 45.93, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://82057257613990"] = {name = "Unicorn Ducky", prices = {["default"] = 2.1, ["Ride"] = 81.03, ["Fly|Ride"] = 210, ["Neon"] = 8.9, ["Neon|Ride"] = 87.94, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 96.47, ["Mega|Ride"] = 118.02, ["Mega|Fly|Ride"] = 328.14}},
    ["rbxassetid://4708551366"] = {name = "Frog", prices = {["default"] = 9.19, ["Fly"] = 30.23, ["Ride"] = 22.32, ["Fly|Ride"] = 55.13, ["Neon"] = 65.52, ["Neon|Fly"] = 189.38, ["Neon|Ride"] = 68.73, ["Neon|Fly|Ride"] = 128.63, ["Mega"] = 684.2, ["Mega|Ride"] = 309.75, ["Mega|Fly|Ride"] = 273.9}},
    ["rbxassetid://4800189682"] = {name = "Starfish", prices = {["default"] = 2.1, ["Fly"] = 17.58, ["Ride"] = 14.98, ["Fly|Ride"] = 35.42, ["Neon"] = 6.51, ["Neon|Fly"] = 137.13, ["Neon|Ride"] = 22.32, ["Neon|Fly|Ride"] = 63.36, ["Mega"] = 65.01, ["Mega|Ride"] = 83.73, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://16736753854"] = {name = "Candy Cane Snail", prices = {["default"] = 104.98, ["Ride"] = 47.2, ["Fly|Ride"] = 272.79, ["Neon"] = 116.82, ["Neon|Ride"] = 256.38, ["Mega"] = 918.74, ["Mega|Fly|Ride"] = 1163.22}},
    ["rbxassetid://10393730410"] = {name = "Orca", prices = {["default"] = 2.1, ["Ride"] = 18.8, ["Fly|Ride"] = 63.95, ["Neon"] = 9.32, ["Neon|Fly"] = 132.53, ["Neon|Ride"] = 31.2, ["Neon|Fly|Ride"] = 104.52, ["Mega"] = 117.11, ["Mega|Ride"] = 114.84, ["Mega|Fly|Ride"] = 279.57}},
    ["rbxassetid://111642509798043"] = {name = "Toxic Kaijunior", prices = {["default"] = 2.1, ["Fly"] = 73.62, ["Ride"] = 19.36, ["Fly|Ride"] = 65.63, ["Neon"] = 15.32, ["Neon|Ride"] = 41.89, ["Neon|Fly|Ride"] = 111.57, ["Mega"] = 262.5, ["Mega|Ride"] = 198.58, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://14146181621"] = {name = "Tawny Frogmouth", prices = {["default"] = 2.1, ["Fly|Ride"] = 59.07, ["Neon"] = 15.37, ["Mega"] = 91.84, ["Mega|Ride"] = 172.05, ["Mega|Fly|Ride"] = 523.69}},
    ["rbxassetid://9474010501"] = {name = "Ribbon Seal", prices = {["default"] = 2.1, ["Fly"] = 42, ["Ride"] = 15.73, ["Neon"] = 3.81, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 97.55, ["Mega"] = 44.01, ["Mega|Fly"] = 287.22, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 184.65}},
    ["rbxassetid://6776872152"] = {name = "Red Squirrel", prices = {["default"] = 15.63, ["Fly"] = 19.47, ["Ride"] = 20.52, ["Fly|Ride"] = 38.99, ["Neon"] = 309.74, ["Neon|Ride"] = 80.85, ["Neon|Fly|Ride"] = 98.43, ["Mega"] = 820.61, ["Mega|Ride"] = 464.94}},
    ["rbxassetid://84140820920420"] = {name = "Siamese Cat", prices = {["default"] = 957.71, ["Ride"] = 820.41, ["Fly|Ride"] = 1126.01, ["Neon"] = 2106.39, ["Neon|Ride"] = 1811.25, ["Neon|Fly|Ride"] = 2095.42, ["Mega"] = 4654.5, ["Mega|Fly|Ride"] = 7112.58}},
    ["rbxassetid://3181727773"] = {name = "Bunny", prices = {["default"] = 2.1, ["Fly"] = 18.38, ["Ride"] = 14.89, ["Fly|Ride"] = 32.75, ["Neon"] = 3.85, ["Neon|Fly"] = 23.22, ["Neon|Ride"] = 20.52, ["Neon|Fly|Ride"] = 68.19, ["Mega|Ride"] = 68.61, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://17120012859"] = {name = "Praying Mantis", prices = {["default"] = 102.55, ["Ride"] = 137.44, ["Fly|Ride"] = 116.24, ["Neon"] = 39.32, ["Neon|Ride"] = 112.51, ["Neon|Fly|Ride"] = 273.9, ["Mega"] = 383.64, ["Mega|Ride"] = 328.12, ["Mega|Fly|Ride"] = 479.04}},
    ["rbxassetid://4440866528"] = {name = "Turkey", prices = {["default"] = 64.32, ["Ride"] = 85.32, ["Fly|Ride"] = 113.28, ["Neon"] = 459.44, ["Neon|Ride"] = 389.82, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 3150.32, ["Mega|Fly|Ride"] = 2051.52}},
    ["rbxassetid://9287841987"] = {name = "Black Springer Spaniel", prices = {["default"] = 27.45, ["Ride"] = 45.95, ["Fly|Ride"] = 102.79, ["Neon"] = 183.75, ["Neon|Ride"] = 188.71, ["Mega"] = 927.3, ["Mega|Ride"] = 669.38, ["Mega|Fly|Ride"] = 816.38}},
    ["rbxassetid://87613898139280"] = {name = "Ranger Beaver", prices = {["default"] = 8.59, ["Ride"] = 26.23, ["Fly|Ride"] = 139.71, ["Neon"] = 56.36, ["Neon|Ride"] = 115.77, ["Neon|Fly|Ride"] = 121.47, ["Mega"] = 410.31, ["Mega|Ride"] = 547.77, ["Mega|Fly|Ride"] = 541.61}},
    ["rbxassetid://88389663444803"] = {name = "Mirai Moth", prices = {["default"] = 22.31, ["Ride"] = 63.51, ["Neon"] = 105, ["Neon|Ride"] = 78.75, ["Mega"] = 278.98, ["Mega|Fly"] = 504.47, ["Mega|Ride"] = 342.61, ["Mega|Fly|Ride"] = 508.6}},
    ["rbxassetid://128469688002747"] = {name = "Moonlight Moth", prices = {["default"] = 15.28, ["Fly"] = 126.89, ["Ride"] = 28.61, ["Neon"] = 274.36, ["Neon|Ride"] = 306.65, ["Neon|Fly|Ride"] = 525, ["Mega"] = 924, ["Mega|Ride"] = 728.44, ["Mega|Fly|Ride"] = 557.81}},
    ["rbxassetid://13936753561"] = {name = "Dylan", prices = {["default"] = 7.29}},
    ["rbxassetid://10606175827"] = {name = "Koi Carp", prices = {["default"] = 13.02, ["Ride"] = 26.69, ["Fly|Ride"] = 78.75, ["Neon"] = 32.82, ["Neon|Ride"] = 72.93, ["Neon|Fly|Ride"] = 168.24, ["Mega"] = 134.39, ["Mega|Fly"] = 463.87, ["Mega|Ride"] = 205.16, ["Mega|Fly|Ride"] = 547.77}},
    ["rbxassetid://84529929751558"] = {name = "Old King Coal", prices = {["default"] = 2.1, ["Neon"] = 11.81, ["Mega"] = 868.27}},
    ["rbxassetid://11706110842"] = {name = "Snowball Pet", prices = {["default"] = 656.25, ["Fly"] = 417.33, ["Ride"] = 105, ["Fly|Ride"] = 111.6, ["Neon"] = 250.24, ["Neon|Ride"] = 328.17, ["Neon|Fly|Ride"] = 278.98, ["Mega|Ride"] = 820.61, ["Mega|Fly|Ride"] = 788.82}},
    ["rbxassetid://6404812664"] = {name = "Ladybug", prices = {["default"] = 3.77, ["Fly"] = 20.35, ["Ride"] = 15.05, ["Fly|Ride"] = 45.13, ["Neon"] = 27.34, ["Neon|Fly"] = 63, ["Neon|Ride"] = 35.51, ["Neon|Fly|Ride"] = 71.96, ["Mega|Fly"] = 409.29, ["Mega|Ride"] = 199.4, ["Mega|Fly|Ride"] = 203.44}},
    ["rbxassetid://95046891836017"] = {name = "Clover Cow", prices = {["default"] = 4.97, ["Ride"] = 34.89, ["Fly|Ride"] = 196.92, ["Neon"] = 23.35, ["Neon|Ride"] = 55.4, ["Neon|Fly|Ride"] = 128.63, ["Mega"] = 129.93, ["Mega|Ride"] = 168, ["Mega|Fly|Ride"] = 259.85}},
    ["rbxassetid://123759251940984"] = {name = "Oakee Knight", prices = {["default"] = 2.1, ["Neon"] = 4.99, ["Mega"] = 48.56, ["Mega|Ride"] = 137.47, ["Mega|Fly|Ride"] = 150.94}},
    ["rbxassetid://9287842106"] = {name = "Brown Springer Spaniel", prices = {["default"] = 35.42, ["Fly"] = 65.63, ["Ride"] = 61.55, ["Fly|Ride"] = 120.75, ["Neon"] = 196.88, ["Neon|Ride"] = 183.75, ["Neon|Fly|Ride"] = 302.6, ["Mega"] = 1094.48, ["Mega|Ride"] = 820.61, ["Mega|Fly|Ride"] = 777}},
    ["rbxassetid://83890934284839"] = {name = "Zeopod", prices = {["default"] = 2.1, ["Ride"] = 37.41, ["Fly|Ride"] = 65.54, ["Neon"] = 3.89, ["Neon|Fly"] = 291.38, ["Neon|Ride"] = 66.27, ["Mega"] = 74.72, ["Mega|Ride"] = 118.11, ["Mega|Fly|Ride"] = 462.2}},
    ["rbxassetid://107096792267421"] = {name = "General Sheepdog", prices = {["default"] = 9.18, ["Ride"] = 60.8, ["Fly|Ride"] = 272.79, ["Neon"] = 145.69, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 656.25, ["Mega|Ride"] = 616.88, ["Mega|Fly|Ride"] = 670.86}},
    ["rbxassetid://5721844511"] = {name = "Woolly Mammoth", prices = {["default"] = 2.1, ["Fly"] = 45.88, ["Ride"] = 15.74, ["Fly|Ride"] = 40.11, ["Neon"] = 12.5, ["Neon|Ride"] = 27.44, ["Neon|Fly|Ride"] = 65.62, ["Mega"] = 183.75, ["Mega|Ride"] = 208.04, ["Mega|Fly|Ride"] = 209.99}},
    ["rbxassetid://8143039445"] = {name = "Summer Walrus", prices = {["default"] = 2.9, ["Ride"] = 18.13, ["Fly|Ride"] = 77.06, ["Neon"] = 35.44, ["Neon|Ride"] = 410.21, ["Mega"] = 383.64, ["Mega|Ride"] = 396.99, ["Mega|Fly|Ride"] = 410.17}},
    ["rbxassetid://136696735147963"] = {name = "Chilling Spider", prices = {["default"] = 3.5, ["Ride"] = 62.77, ["Neon"] = 38.95, ["Neon|Ride"] = 157.55, ["Mega"] = 383.5, ["Mega|Ride"] = 853.79}},
    ["rbxassetid://133768672320906"] = {name = "Catte", prices = {["default"] = 39.38, ["Ride"] = 132.23, ["Neon"] = 269.07, ["Neon|Fly|Ride"] = 643.16, ["Mega"] = 1487.36, ["Mega|Fly|Ride"] = 1443.75}},
    ["rbxassetid://12139319231"] = {name = "Feesh", prices = {["default"] = 17.42, ["Ride"] = 109.75, ["Neon"] = 99.02, ["Neon|Ride"] = 410.21, ["Mega"] = 415.33, ["Mega|Ride"] = 355.95, ["Mega|Fly|Ride"] = 498.75}},
    ["rbxassetid://13685039170"] = {name = "Lobster", prices = {["default"] = 8.02, ["Ride"] = 105, ["Neon"] = 162.74, ["Neon|Fly"] = 205.11, ["Mega"] = 273.9, ["Mega|Ride"] = 1551.74}},
    ["rbxassetid://87668315398037"] = {name = "Mecha R4BBIT", prices = {["default"] = 21, ["Ride"] = 105, ["Fly|Ride"] = 367.46, ["Neon"] = 130.2, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 814.47, ["Mega|Fly|Ride"] = 1091.82}},
    ["rbxassetid://120262676323297"] = {name = "Kelp Hunter", prices = {["default"] = 5.85, ["Neon"] = 20.52, ["Neon|Ride"] = 273.82, ["Mega"] = 118.13, ["Mega|Fly|Ride"] = 310.36}},
    ["rbxassetid://12403864254"] = {name = "Gorilla", prices = {["default"] = 2.1, ["Fly"] = 128.41, ["Ride"] = 17.91, ["Fly|Ride"] = 60.61, ["Neon"] = 2.1, ["Neon|Fly"] = 43.02, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 82.69, ["Mega"] = 79.05, ["Mega|Ride"] = 86.03, ["Mega|Fly|Ride"] = 199}},
    ["rbxassetid://124908510040897"] = {name = "Mistletroll", prices = {["default"] = 5.44, ["Fly"] = 50.19, ["Ride"] = 288.64, ["Fly|Ride"] = 77.9, ["Neon"] = 17.67, ["Neon|Ride"] = 41.55, ["Neon|Fly|Ride"] = 163.96, ["Mega"] = 109.33, ["Mega|Fly|Ride"] = 388.23}},
    ["rbxassetid://11189235896"] = {name = "Persian Cat", prices = {["default"] = 2.1, ["Fly"] = 31.5, ["Ride"] = 16.71, ["Fly|Ride"] = 55.95, ["Neon"] = 5.15, ["Neon|Fly"] = 31.39, ["Neon|Ride"] = 22.79, ["Neon|Fly|Ride"] = 66.99, ["Mega"] = 45.94, ["Mega|Ride"] = 74.11, ["Mega|Fly|Ride"] = 280.1}},
    ["rbxassetid://14457148635"] = {name = "Magma Snail", prices = {["default"] = 2.1, ["Fly"] = 45.94, ["Ride"] = 26.69, ["Fly|Ride"] = 118.13, ["Neon"] = 32.81, ["Neon|Ride"] = 96.42, ["Neon|Fly|Ride"] = 254.41, ["Mega"] = 250.37, ["Mega|Ride"] = 307.13, ["Mega|Fly|Ride"] = 259.88}},
    ["rbxassetid://11694853423"] = {name = "Shetland Pony White", prices = {["default"] = 4.08, ["Fly"] = 65.63, ["Ride"] = 26.25, ["Fly|Ride"] = 103.69, ["Neon"] = 27.71, ["Neon|Fly"] = 464.88, ["Neon|Ride"] = 82.06, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 302.45, ["Mega|Ride"] = 273.9, ["Mega|Fly|Ride"] = 1230.92}},
    ["rbxassetid://4621220568"] = {name = "Rat", prices = {["default"] = 3.84, ["Ride"] = 22.46, ["Fly|Ride"] = 45.68, ["Neon"] = 26.23, ["Neon|Fly"] = 54.64, ["Neon|Ride"] = 32.79, ["Neon|Fly|Ride"] = 109.28, ["Mega"] = 209.09, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 385.23}},
    ["rbxassetid://8938702150"] = {name = "Pine Marten", prices = {["default"] = 2.1, ["Fly"] = 35.49, ["Ride"] = 15.64, ["Fly|Ride"] = 45.8, ["Neon|Fly"] = 82.06, ["Neon|Ride"] = 55.8, ["Neon|Fly|Ride"] = 183.62, ["Mega"] = 210, ["Mega|Ride"] = 205.16, ["Mega|Fly|Ride"] = 246.2}},
    ["rbxassetid://120359009390464"] = {name = "Turtle Doves", prices = {["default"] = 3.94, ["Fly"] = 57.66, ["Ride"] = 31.39, ["Neon"] = 14.89, ["Neon|Fly"] = 410.21, ["Neon|Ride"] = 94.5, ["Neon|Fly|Ride"] = 142.21, ["Mega"] = 95.82, ["Mega|Fly"] = 176.5, ["Mega|Ride"] = 129.94, ["Mega|Fly|Ride"] = 261.66}},
    ["rbxassetid://71032455578324"] = {name = "Chihuahua", prices = {["default"] = 96.41, ["Ride"] = 98.43, ["Fly|Ride"] = 286.13, ["Neon"] = 98.42, ["Neon|Ride"] = 223.13, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 525, ["Mega|Fly"] = 752.92, ["Mega|Ride"] = 522.38, ["Mega|Fly|Ride"] = 733.09}},
    ["rbxassetid://11505487641"] = {name = "Ram", prices = {["default"] = 102.55, ["Ride"] = 104.62, ["Fly|Ride"] = 245.44, ["Neon"] = 291.38, ["Neon|Ride"] = 314.84, ["Neon|Fly|Ride"] = 341.25, ["Mega"] = 1312.5, ["Mega|Ride"] = 1116.94, ["Mega|Fly|Ride"] = 1212.8}},
    ["rbxassetid://117821626163847"] = {name = "Chanekeh", prices = {["default"] = 2.1, ["Fly"] = 51.1, ["Ride"] = 19.5, ["Fly|Ride"] = 54.45, ["Neon"] = 2.1, ["Neon|Ride"] = 39.63, ["Mega"] = 26.17, ["Mega|Ride"] = 69.82, ["Mega|Fly|Ride"] = 165.27}},
    ["rbxassetid://14266737982"] = {name = "Cassowary", prices = {["default"] = 27.65, ["Mega|Fly|Ride"] = 1230.92}},
    ["rbxassetid://13693650831"] = {name = "Leopard Shark", prices = {["default"] = 61.68, ["Ride"] = 97.13, ["Neon"] = 246.14, ["Neon|Ride"] = 302.54, ["Mega|Ride"] = 1210.4, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://100909868233186"] = {name = "Kappakid", prices = {["default"] = 6.35, ["Ride"] = 33.39, ["Fly|Ride"] = 126, ["Neon"] = 40.69, ["Neon|Ride"] = 82.06, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 168.16, ["Mega|Ride"] = 242.82, ["Mega|Fly|Ride"] = 383.92}},
    ["rbxassetid://127061844219486"] = {name = "Patchy Bear", prices = {["default"] = 3.93, ["Ride"] = 123.08, ["Fly|Ride"] = 139.76, ["Neon"] = 8.21, ["Neon|Ride"] = 65.62, ["Mega"] = 64.85, ["Mega|Fly"] = 341.25, ["Mega|Ride"] = 94.4, ["Mega|Fly|Ride"] = 320.22}},
    ["rbxassetid://6998402749"] = {name = "Merhorse", prices = {["default"] = 2.1, ["Fly"] = 27.3, ["Ride"] = 15.56, ["Fly|Ride"] = 47.25, ["Neon"] = 13.13, ["Neon|Ride"] = 27.26, ["Neon|Fly|Ride"] = 105.67, ["Mega"] = 169.32, ["Mega|Fly"] = 342.61, ["Mega|Ride"] = 308.44, ["Mega|Fly|Ride"] = 219.18}},
    ["rbxassetid://3181727196"] = {name = "Beaver", prices = {["default"] = 2.1, ["Fly"] = 16.74, ["Ride"] = 15.66, ["Fly|Ride"] = 40.74, ["Neon"] = 2.1, ["Neon|Fly"] = 17.77, ["Neon|Ride"] = 23.25, ["Neon|Fly|Ride"] = 40.69, ["Mega"] = 23.44, ["Mega|Ride"] = 69.56, ["Mega|Fly|Ride"] = 147}},
    ["rbxassetid://10377935981"] = {name = "Badger", prices = {["default"] = 2.1, ["Ride"] = 15.75, ["Fly|Ride"] = 83.87, ["Neon"] = 5.16, ["Neon|Ride"] = 27.76, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 45.94, ["Mega|Fly"] = 168, ["Mega|Ride"] = 67.09, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://118143096743818"] = {name = "Granny Wolf", prices = {["default"] = 2.1, ["Ride"] = 75.9, ["Neon"] = 2.1, ["Neon|Ride"] = 145.08, ["Mega"] = 19.69, ["Mega|Ride"] = 547.77, ["Mega|Fly|Ride"] = 310.82}},
    ["rbxassetid://18819382634"] = {name = "Singularity Beetle", prices = {["default"] = 6.76, ["Ride"] = 104.98, ["Neon"] = 27.57, ["Neon|Ride"] = 155.74, ["Neon|Fly|Ride"] = 615.47, ["Mega"] = 213.94, ["Mega|Ride"] = 269.07, ["Mega|Fly|Ride"] = 191.02}},
    ["rbxassetid://13664716167"] = {name = "Ostrich", prices = {["default"] = 15.25, ["Ride"] = 30.18, ["Fly|Ride"] = 202.98, ["Neon"] = 41.67, ["Neon|Ride"] = 203.44, ["Neon|Fly|Ride"] = 137.47, ["Mega|Ride"] = 310.36, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://3710822879"] = {name = "Penguin", prices = {["default"] = 5.95, ["Fly"] = 22.8, ["Ride"] = 20.52, ["Fly|Ride"] = 41.09, ["Neon"] = 39.29, ["Neon|Fly"] = 69.83, ["Neon|Ride"] = 38.16, ["Neon|Fly|Ride"] = 91.88, ["Mega|Ride"] = 547.77, ["Mega|Fly|Ride"] = 332.5}},
    ["rbxassetid://12778628745"] = {name = "Chef Gorilla", prices = {["default"] = 61.57, ["Fly|Ride"] = 262.5, ["Neon|Ride"] = 597.19, ["Mega|Fly|Ride"] = 1783.04}},
    ["rbxassetid://138841259551372"] = {name = "Vermilion Butterfly", prices = {["default"] = 24.42, ["Fly"] = 82.66, ["Ride"] = 65.63, ["Neon"] = 282.19, ["Neon|Fly|Ride"] = 630, ["Mega"] = 950.92, ["Mega|Ride"] = 827.54, ["Mega|Fly|Ride"] = 889.34}},
    ["rbxassetid://3181727125"] = {name = "Snow Puma", prices = {["default"] = 2.1, ["Fly"] = 24.94, ["Ride"] = 16.37, ["Fly|Ride"] = 38, ["Neon"] = 2.35, ["Neon|Fly"] = 41.04, ["Neon|Ride"] = 16.96, ["Neon|Fly|Ride"] = 41.66, ["Mega"] = 82.07, ["Mega|Ride"] = 127.32, ["Mega|Fly|Ride"] = 188.97}},
    ["rbxassetid://3181728160"] = {name = "Shiba Inu", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 15.25, ["Fly|Ride"] = 38.99, ["Neon"] = 3.68, ["Neon|Fly"] = 22.47, ["Neon|Ride"] = 20.52, ["Neon|Fly|Ride"] = 45.94, ["Mega"] = 44.63, ["Mega|Fly"] = 82.07, ["Mega|Ride"] = 56.44, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://3261465893"] = {name = "Blue Dog", prices = {["default"] = 402.8, ["Ride"] = 534.18, ["Fly|Ride"] = 549.94, ["Neon|Fly|Ride"] = 1884.09}},
    ["rbxassetid://15504846154"] = {name = "Eggnog Hare", prices = {["Ride"] = 65.63, ["Neon"] = 41.04, ["Neon|Ride"] = 137.44, ["Neon|Fly|Ride"] = 159.92, ["Mega"] = 364.88, ["Mega|Ride"] = 388.23, ["Mega|Fly|Ride"] = 996.19}},
    ["rbxassetid://4708551244"] = {name = "Dingo", prices = {["default"] = 2.1, ["Ride"] = 15.27, ["Fly|Ride"] = 34.13, ["Neon"] = 3.94, ["Neon|Fly"] = 26.69, ["Neon|Ride"] = 15.75, ["Neon|Fly|Ride"] = 44.63, ["Mega"] = 140.76, ["Mega|Ride"] = 62.78, ["Mega|Fly|Ride"] = 105.44}},
    ["rbxassetid://140434791311540"] = {name = "French Bulldog", prices = {["default"] = 101.26, ["Ride"] = 93.19, ["Fly|Ride"] = 342.53, ["Neon"] = 260.78, ["Neon|Ride"] = 263.82, ["Neon|Fly|Ride"] = 449.3, ["Mega"] = 737.62, ["Mega|Ride"] = 721.87}},
    ["rbxassetid://5067924710"] = {name = "Monkey", prices = {["default"] = 2.1, ["Fly"] = 36.98, ["Ride"] = 18.47, ["Fly|Ride"] = 41.04, ["Neon"] = 8.78, ["Neon|Fly"] = 48.11, ["Neon|Ride"] = 23.61, ["Neon|Fly|Ride"] = 66.78, ["Mega"] = 91.88, ["Mega|Ride"] = 123.11, ["Mega|Fly|Ride"] = 236.12}},
    ["rbxassetid://73677246948616"] = {name = "Black Tiger", prices = {["default"] = 2.1, ["Fly"] = 69.57, ["Ride"] = 42.84, ["Neon"] = 2.1, ["Neon|Ride"] = 31.86, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 18.52, ["Mega|Ride"] = 64.54, ["Mega|Fly|Ride"] = 190.76}},
    ["rbxassetid://17662893972"] = {name = "Pretty Pony", prices = {["default"] = 55.13, ["Fly"] = 195.09, ["Ride"] = 82.06, ["Fly|Ride"] = 164.07, ["Neon"] = 169.32, ["Neon|Ride"] = 191.26, ["Neon|Fly|Ride"] = 328.26, ["Mega"] = 787.5, ["Mega|Ride"] = 630, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://16722908853"] = {name = "Dotted Eggy", prices = {["default"] = 2.1, ["Ride"] = 17.75, ["Fly|Ride"] = 52.5, ["Neon"] = 6.79, ["Neon|Ride"] = 40.45, ["Neon|Fly|Ride"] = 63, ["Mega"] = 40.85, ["Mega|Ride"] = 179.9, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://3409443896"] = {name = "Wild Boar", prices = {["default"] = 55.38, ["Ride"] = 80.07, ["Fly|Ride"] = 137.44, ["Neon"] = 233.19, ["Neon|Ride"] = 256.48, ["Neon|Fly|Ride"] = 359.63, ["Mega"] = 1620.7, ["Mega|Ride"] = 1641.22, ["Mega|Fly|Ride"] = 1228.49}},
    ["rbxassetid://12432807176"] = {name = "Possum", prices = {["default"] = 3.65, ["Ride"] = 156.33, ["Fly|Ride"] = 155.89, ["Neon"] = 16.49, ["Neon|Ride"] = 278.25, ["Neon|Fly|Ride"] = 479.04, ["Mega"] = 104.99, ["Mega|Ride"] = 603.75, ["Mega|Fly|Ride"] = 584.73}},
    ["rbxassetid://94550121082603"] = {name = "Lionfish", prices = {["default"] = 3.94, ["Fly"] = 68.73, ["Ride"] = 26.25, ["Fly|Ride"] = 65.65, ["Neon"] = 10.19, ["Neon|Ride"] = 41.04, ["Neon|Fly|Ride"] = 406.88, ["Mega"] = 121.05, ["Mega|Ride"] = 137.47, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://15096097714"] = {name = "Evil Rock", prices = {["default"] = 34.12, ["Ride"] = 410.21, ["Fly|Ride"] = 213.63, ["Neon"] = 138.46, ["Neon|Fly|Ride"] = 328.13, ["Mega|Ride"] = 2598.75, ["Mega|Fly|Ride"] = 1368.38}},
    ["rbxassetid://117664495619345"] = {name = "Fire Foal", prices = {["default"] = 2.1, ["Fly"] = 242.24, ["Ride"] = 32.82, ["Fly|Ride"] = 908.98, ["Neon"] = 4.95, ["Neon|Ride"] = 137.07, ["Neon|Fly|Ride"] = 152.28, ["Mega"] = 59.49, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 137.47, ["Mega|Fly|Ride"] = 181.92}},
    ["rbxassetid://8938701683"] = {name = "Red Cardinal", prices = {["default"] = 2.1, ["Ride"] = 22.32, ["Fly|Ride"] = 141.5, ["Neon"] = 10.5, ["Neon|Fly"] = 47.77, ["Neon|Ride"] = 23.61, ["Neon|Fly|Ride"] = 116.24, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://12489700965"] = {name = "Tarsier", prices = {["default"] = 11.12, ["Fly"] = 51.3, ["Ride"] = 32.24, ["Fly|Ride"] = 77.89, ["Neon"] = 77.89, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 137.47, ["Mega"] = 430.5, ["Mega|Ride"] = 403.35, ["Mega|Fly|Ride"] = 393.73}},
    ["rbxassetid://11765322595"] = {name = "Gingerbread Reindeer", prices = {["default"] = 41.79, ["Ride"] = 137.41, ["Fly|Ride"] = 82.05, ["Neon"] = 98.44, ["Neon|Ride"] = 139.55, ["Neon|Fly|Ride"] = 233.89, ["Mega"] = 897.54, ["Mega|Ride"] = 415.17, ["Mega|Fly|Ride"] = 2051.52}},
    ["rbxassetid://16382424275"] = {name = "Nautilus", prices = {["default"] = 22.71, ["Fly"] = 51.18, ["Ride"] = 28.25, ["Fly|Ride"] = 68.73, ["Neon"] = 82.06, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 123.11, ["Mega"] = 548.03, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 422.62}},
    ["rbxassetid://93997399823425"] = {name = "Chocolate Dutch Guinea Pig", prices = {["default"] = 68.25, ["Fly"] = 135.19, ["Ride"] = 164.07, ["Fly|Ride"] = 223.13, ["Neon"] = 262.49, ["Neon|Ride"] = 465.59, ["Neon|Fly|Ride"] = 539.44, ["Mega|Ride"] = 1441.31, ["Mega|Fly|Ride"] = 1141.88}},
    ["rbxassetid://75866760046580"] = {name = "Skelebat", prices = {["default"] = 3.94, ["Fly"] = 137.44, ["Ride"] = 50.74, ["Fly|Ride"] = 307.67, ["Neon"] = 23.62, ["Neon|Ride"] = 109.27, ["Neon|Fly|Ride"] = 305.82, ["Mega"] = 223.13, ["Mega|Ride"] = 342.61, ["Mega|Fly|Ride"] = 367.23}},
    ["rbxassetid://111661922676557"] = {name = "Momma Moose", prices = {["default"] = 5.24, ["Ride"] = 26.57, ["Fly|Ride"] = 137.44, ["Neon"] = 21.17, ["Neon|Ride"] = 55.4, ["Neon|Fly|Ride"] = 137.45, ["Mega"] = 185.07, ["Mega|Ride"] = 205.16, ["Mega|Fly|Ride"] = 246.62}},
    ["rbxassetid://17059860310"] = {name = "Elasmosaurus", prices = {["default"] = 35.39, ["Ride"] = 30.78, ["Fly|Ride"] = 160.13, ["Neon"] = 64.32, ["Neon|Ride"] = 410.21, ["Mega"] = 426.57, ["Mega|Ride"] = 479.04, ["Mega|Fly|Ride"] = 547.77}},
    ["rbxassetid://10306934599"] = {name = "Camel", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 15.4, ["Fly|Ride"] = 25.89, ["Neon"] = 2.1, ["Neon|Fly"] = 26.25, ["Neon|Ride"] = 12.98, ["Neon|Fly|Ride"] = 37.68, ["Mega"] = 14.36, ["Mega|Fly"] = 65.66, ["Mega|Ride"] = 25.2, ["Mega|Fly|Ride"] = 91.94}},
    ["rbxassetid://13104107016"] = {name = "Puffer Fish", prices = {["default"] = 49.53, ["Ride"] = 137.44, ["Fly|Ride"] = 273.82, ["Neon"] = 362.55, ["Neon|Fly"] = 2324.81, ["Neon|Ride"] = 291.06, ["Neon|Fly|Ride"] = 488.15, ["Mega"] = 1258.61, ["Mega|Ride"] = 945, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://17183022910"] = {name = "Mole", prices = {["default"] = 2.1, ["Ride"] = 75.9, ["Fly|Ride"] = 112.22, ["Neon"] = 3.5, ["Neon|Ride"] = 27.44, ["Neon|Fly|Ride"] = 129.93, ["Mega"] = 44.01, ["Mega|Ride"] = 76.13, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://5721844051"] = {name = "Stegosaurus", prices = {["default"] = 2.1, ["Fly"] = 27.8, ["Ride"] = 14.44, ["Fly|Ride"] = 45.94, ["Neon"] = 11.71, ["Neon|Fly"] = 137.44, ["Neon|Ride"] = 26.17, ["Neon|Fly|Ride"] = 96.44, ["Mega"] = 260.55, ["Mega|Ride"] = 128.52, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://114921997566126"] = {name = "S'mores Raccoon", prices = {["default"] = 111.58, ["Ride"] = 148.31, ["Fly|Ride"] = 273.82, ["Neon"] = 303.74, ["Neon|Ride"] = 420, ["Neon|Fly|Ride"] = 511.88, ["Mega"] = 1053.47, ["Mega|Ride"] = 1368.38, ["Mega|Fly|Ride"] = 1233.75}},
    ["rbxassetid://93038040448121"] = {name = "Nurse Shark", prices = {["default"] = 2.1, ["Ride"] = 23.67, ["Neon"] = 6.45, ["Neon|Ride"] = 59.49, ["Mega"] = 64.32, ["Mega|Ride"] = 109.92, ["Mega|Fly|Ride"] = 234.94}},
    ["rbxassetid://13936750528"] = {name = "River", prices = {["default"] = 2.42}},
    ["rbxassetid://103142927308458"] = {name = "Black-Footed Ferret", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Fly|Ride"] = 291.25, ["Neon"] = 6.18, ["Neon|Ride"] = 50.04, ["Neon|Fly|Ride"] = 116.25, ["Mega"] = 51.31, ["Mega|Ride"] = 112.02, ["Mega|Fly|Ride"] = 437.07}},
    ["rbxassetid://3199974219"] = {name = "Pet Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13803784751"] = {name = "Happy Clam", prices = {["default"] = 145.57, ["Ride"] = 182.56, ["Fly|Ride"] = 262.5, ["Neon"] = 576.22, ["Neon|Ride"] = 643, ["Neon|Fly|Ride"] = 787.5, ["Mega|Ride"] = 2231.25, ["Mega|Fly|Ride"] = 2517.21}},
    ["rbxassetid://13665210525"] = {name = "Warthog", prices = {["default"] = 3.12, ["Ride"] = 41.04, ["Neon"] = 19.58, ["Neon|Ride"] = 55.79, ["Neon|Fly|Ride"] = 219.43, ["Mega"] = 183.44, ["Mega|Ride"] = 202.85, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://18515939072"] = {name = "Black Marlin", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Neon"] = 2.1, ["Neon|Ride"] = 25.2, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 32.8, ["Mega|Ride"] = 68.74, ["Mega|Fly|Ride"] = 137.47}},
    ["rbxassetid://16075008092"] = {name = "Fanghorn Tortoise", prices = {["default"] = 3.94, ["Ride"] = 27.71, ["Neon"] = 47.01, ["Neon|Ride"] = 109.75, ["Neon|Fly|Ride"] = 164.07, ["Mega"] = 410.31, ["Mega|Ride"] = 410.31, ["Mega|Fly|Ride"] = 614.76}},
    ["rbxassetid://8566684181"] = {name = "Giant Black Scarab", prices = {["default"] = 13.13, ["Fly"] = 25.47, ["Ride"] = 27.71, ["Fly|Ride"] = 54.66, ["Neon"] = 92.14, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 305.82, ["Mega"] = 597.19, ["Mega|Ride"] = 498.75, ["Mega|Fly|Ride"] = 481.69}},
    ["rbxassetid://118691035196137"] = {name = "Shiver Wolf", prices = {["default"] = 21.72, ["Ride"] = 60.29, ["Fly|Ride"] = 109.75, ["Neon"] = 170.63, ["Neon|Ride"] = 155.74, ["Neon|Fly|Ride"] = 1575, ["Mega|Ride"] = 667.19, ["Mega|Fly|Ride"] = 564.38}},
    ["rbxassetid://3743735223"] = {name = "Brown Bear", prices = {["default"] = 196.88, ["Fly"] = 210.98, ["Ride"] = 160.01, ["Fly|Ride"] = 257.08, ["Neon"] = 591.45, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 636.69, ["Mega|Fly|Ride"] = 2623.69}},
    ["rbxassetid://3934251801"] = {name = "Sloth", prices = {["default"] = 19.67, ["Fly"] = 130.76, ["Ride"] = 52.5, ["Fly|Ride"] = 68.16, ["Neon"] = 341.21, ["Neon|Fly"] = 6152.99, ["Neon|Ride"] = 144.27, ["Neon|Fly|Ride"] = 190.32, ["Mega"] = 903.7, ["Mega|Ride"] = 877.03, ["Mega|Fly|Ride"] = 826.88}},
    ["rbxassetid://12139338880"] = {name = "Frogspawn", prices = {["default"] = 2.1, ["Fly"] = 131.23, ["Ride"] = 19.27, ["Fly|Ride"] = 65.63, ["Neon"] = 11.27, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 137.82, ["Mega|Ride"] = 258.5, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://8070926551"] = {name = "Snow Leopard", prices = {["default"] = 24.07, ["Fly"] = 232.47, ["Ride"] = 32.45, ["Fly|Ride"] = 123.04, ["Neon"] = 131.25, ["Neon|Fly"] = 137.44, ["Neon|Ride"] = 114.14, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 379.31, ["Mega|Ride"] = 431.82, ["Mega|Fly|Ride"] = 393.74}},
    ["rbxassetid://76712147705770"] = {name = "Tuxedo Cat", prices = {["default"] = 57.44, ["Fly"] = 139.5, ["Ride"] = 103.69, ["Fly|Ride"] = 133.58, ["Neon"] = 320.25, ["Neon|Ride"] = 245.44, ["Neon|Fly|Ride"] = 408.02, ["Mega"] = 942.62, ["Mega|Ride"] = 1081.16, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://15685468962"] = {name = "Tasmanian Devil", prices = {["default"] = 17.16, ["Ride"] = 128.64, ["Neon"] = 137.44, ["Neon|Ride"] = 246.14, ["Neon|Fly|Ride"] = 452.38, ["Mega"] = 683.82, ["Mega|Ride"] = 813.65, ["Mega|Fly|Ride"] = 918.06}},
    ["rbxassetid://123288277753363"] = {name = "Tri-horned Treehopper", prices = {["default"] = 327.39, ["Ride"] = 362.88, ["Neon|Ride"] = 3099.51, ["Neon|Fly|Ride"] = 2051.52}},
    ["rbxassetid://6060987821"] = {name = "Yeti", prices = {["default"] = 27.15, ["Ride"] = 35.9, ["Fly|Ride"] = 74.92, ["Neon"] = 224.25, ["Neon|Ride"] = 227.39, ["Neon|Fly|Ride"] = 291.38, ["Mega"] = 1034.25, ["Mega|Ride"] = 922.62, ["Mega|Fly|Ride"] = 955.48}},
    ["rbxassetid://9549841158"] = {name = "Zebra", prices = {["default"] = 2.1, ["Fly"] = 37.27, ["Ride"] = 15.4, ["Fly|Ride"] = 28.88, ["Neon"] = 2.1, ["Neon|Ride"] = 13.9, ["Neon|Fly|Ride"] = 68.74, ["Mega"] = 27.55, ["Mega|Fly"] = 102.74, ["Mega|Ride"] = 48.22, ["Mega|Fly|Ride"] = 112.87}},
    ["rbxassetid://13883282884"] = {name = "Hermit Crab", prices = {["default"] = 26.25, ["Neon"] = 18.2, ["Neon|Ride"] = 69.47, ["Neon|Fly|Ride"] = 259.9, ["Mega"] = 143.83, ["Mega|Ride"] = 278.25, ["Mega|Fly|Ride"] = 272.87}},
    ["rbxassetid://92626539723202"] = {name = "Sea Angel", prices = {["default"] = 3.13, ["Ride"] = 29.75, ["Fly|Ride"] = 144.18, ["Neon"] = 16.7, ["Neon|Ride"] = 122.06, ["Neon|Fly|Ride"] = 958.07, ["Mega"] = 107.62, ["Mega|Fly"] = 498.61, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 334.69}},
    ["rbxassetid://15848329383"] = {name = "Jellyfish", prices = {["default"] = 445.03, ["Ride"] = 458.07, ["Fly|Ride"] = 616.88, ["Neon"] = 1394.8, ["Neon|Ride"] = 1435.71, ["Neon|Fly|Ride"] = 1431.88, ["Mega|Fly|Ride"] = 4862.82}},
    ["rbxassetid://5721843846"] = {name = "Sabertooth", prices = {["default"] = 5.03, ["Fly"] = 63.74, ["Ride"] = 15.65, ["Fly|Ride"] = 52.7, ["Neon"] = 36.94, ["Neon|Ride"] = 66.4, ["Neon|Fly|Ride"] = 86.52, ["Mega"] = 168, ["Mega|Ride"] = 272.76, ["Mega|Fly|Ride"] = 376.47}},
    ["rbxassetid://9475753090"] = {name = "Albatross", prices = {["default"] = 6.27, ["Fly"] = 21.29, ["Ride"] = 16.36, ["Fly|Ride"] = 44.63, ["Neon"] = 26.71, ["Neon|Fly"] = 156.45, ["Neon|Ride"] = 410.21, ["Neon|Fly|Ride"] = 118.13, ["Mega|Ride"] = 684.2, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://96894173636082"] = {name = "Clementine Owl", prices = {["default"] = 2.71, ["Fly"] = 32.71, ["Ride"] = 27.71, ["Neon"] = 12.5, ["Neon|Fly"] = 94.5, ["Neon|Ride"] = 54.94, ["Neon|Fly|Ride"] = 155.76, ["Mega"] = 116.95, ["Mega|Ride"] = 269.07, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://10318105683"] = {name = "Orange Butterfly", prices = {["default"] = 30.19, ["Fly"] = 34.93, ["Ride"] = 40.2, ["Fly|Ride"] = 98, ["Neon"] = 140.44, ["Neon|Ride"] = 205.06, ["Neon|Fly|Ride"] = 210, ["Mega|Ride"] = 819.59, ["Mega|Fly|Ride"] = 643.13}},
    ["rbxassetid://15937689999"] = {name = "Rattlesnake", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 27.71, ["Fly|Ride"] = 50.3, ["Neon"] = 6.24, ["Neon|Ride"] = 38.07, ["Neon|Fly|Ride"] = 210, ["Mega"] = 162.09, ["Mega|Ride"] = 448.27, ["Mega|Fly|Ride"] = 985.04}},
    ["rbxassetid://10971808447"] = {name = "Evil Basilisk", prices = {["default"] = 5.3, ["Fly"] = 65.63, ["Ride"] = 25.46, ["Fly|Ride"] = 85.63, ["Neon"] = 141.72, ["Neon|Ride"] = 164.34, ["Neon|Fly|Ride"] = 155.76, ["Mega|Ride"] = 738.55, ["Mega|Fly|Ride"] = 547.77}},
    ["rbxassetid://99104623628550"] = {name = "Snorgle", prices = {["default"] = 2.1, ["Ride"] = 19.17, ["Neon"] = 3.94, ["Neon|Ride"] = 27.69, ["Mega"] = 52.41, ["Mega|Ride"] = 102.59, ["Mega|Fly|Ride"] = 232.86}},
    ["rbxassetid://136705425555561"] = {name = "Emperor Shrimp", prices = {["Ride"] = 137.44, ["Neon"] = 109.75, ["Mega"] = 547.77}},
    ["rbxassetid://14398819258"] = {name = "Longhorn Cow", prices = {["default"] = 35.9, ["Neon"] = 76.56, ["Neon|Ride"] = 137.44, ["Mega"] = 302.6, ["Mega|Ride"] = 464.57, ["Mega|Fly|Ride"] = 544.69}},
    ["rbxassetid://4708551284"] = {name = "Koala", prices = {["default"] = 7.87, ["Fly"] = 28.69, ["Ride"] = 30.19, ["Fly|Ride"] = 68.73, ["Neon"] = 51.16, ["Neon|Fly"] = 69.14, ["Neon|Ride"] = 55.13, ["Neon|Fly|Ride"] = 119.44, ["Mega"] = 576.5, ["Mega|Ride"] = 313.69, ["Mega|Fly|Ride"] = 416.07}},
    ["rbxassetid://4115249264"] = {name = "Zombie Buffalo", prices = {["default"] = 321.56, ["Fly"] = 479.75, ["Ride"] = 328.13, ["Fly|Ride"] = 367.5, ["Neon"] = 1240.22, ["Neon|Ride"] = 1340.33, ["Neon|Fly|Ride"] = 1395.03, ["Mega|Fly|Ride"] = 5197.5}},
    ["rbxassetid://8939633862"] = {name = "Salamander", prices = {["default"] = 2.1, ["Fly"] = 31.8, ["Ride"] = 15.4, ["Fly|Ride"] = 39.38, ["Neon"] = 11.71, ["Neon|Fly"] = 77.88, ["Neon|Ride"] = 32.28, ["Neon|Fly|Ride"] = 130.6, ["Mega"] = 219.52, ["Mega|Ride"] = 155.76, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://7734902431"] = {name = "Halloween White Mummy Cat", prices = {["default"] = 30.19, ["Fly"] = 109.75, ["Ride"] = 45.92, ["Fly|Ride"] = 77.89, ["Neon"] = 41.66, ["Neon|Ride"] = 146.47, ["Neon|Fly|Ride"] = 406.88, ["Mega"] = 287.03, ["Mega|Ride"] = 360.05}},
    ["rbxassetid://115869632070663"] = {name = "Snowball Pug", prices = {["default"] = 16.42, ["Ride"] = 164.07, ["Fly|Ride"] = 183.75, ["Neon"] = 144.27, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 658.54, ["Mega"] = 328.13, ["Mega|Ride"] = 374.51, ["Mega|Fly|Ride"] = 547.77}},
    ["rbxassetid://8077189379"] = {name = "Husky", prices = {["default"] = 121.96, ["Ride"] = 124.59, ["Fly|Ride"] = 443.58, ["Neon"] = 903.48, ["Neon|Ride"] = 1230.6, ["Neon|Fly|Ride"] = 1436.07, ["Mega"] = 3099.96, ["Mega|Ride"] = 7749.3, ["Mega|Fly|Ride"] = 3542.96}},
    ["rbxassetid://98003529163435"] = {name = "Maine Coon", prices = {["default"] = 26.67, ["Fly"] = 91.88, ["Ride"] = 124.38, ["Fly|Ride"] = 142.63, ["Neon"] = 110.15, ["Neon|Ride"] = 122.09, ["Neon|Fly|Ride"] = 188, ["Mega"] = 328.13, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 414.75}},
    ["rbxassetid://12488273089"] = {name = "Yellow-lipped Sea Krait", prices = {["default"] = 2.1, ["Fly"] = 13.13, ["Ride"] = 16.95, ["Fly|Ride"] = 58.35, ["Neon"] = 10.5, ["Neon|Fly|Ride"] = 69.47, ["Mega"] = 65.58, ["Mega|Ride"] = 151.82, ["Mega|Fly|Ride"] = 155.76}},
    ["rbxassetid://96760582519875"] = {name = "Cozy Mistletroll", prices = {["default"] = 4.87, ["Ride"] = 40.01, ["Neon"] = 26.24, ["Neon|Ride"] = 94.26, ["Neon|Fly|Ride"] = 174.57, ["Mega"] = 169.32, ["Mega|Fly|Ride"] = 306.99}},
    ["rbxassetid://85229142142232"] = {name = "Bunny Swirl", prices = {["default"] = 92.86, ["Fly"] = 196.88, ["Ride"] = 137.44, ["Fly|Ride"] = 202.63, ["Neon"] = 178.45, ["Neon|Ride"] = 182.48, ["Neon|Fly|Ride"] = 304.5, ["Mega"] = 483.14, ["Mega|Ride"] = 684.2, ["Mega|Fly|Ride"] = 619.4}},
    ["rbxassetid://121192022038625"] = {name = "Stygian Owl", prices = {["default"] = 2.63, ["Ride"] = 131.25, ["Fly|Ride"] = 123.08, ["Neon"] = 6.46, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 190.31, ["Mega"] = 63.79, ["Mega|Ride"] = 163.31, ["Mega|Fly|Ride"] = 156.19}},
    ["rbxassetid://83732262844708"] = {name = "Pain au Chat", prices = {["default"] = 23.63, ["Neon"] = 114.19, ["Neon|Ride"] = 306.65, ["Mega"] = 684.2, ["Mega|Fly|Ride"] = 811.39}},
    ["rbxassetid://12792506715"] = {name = "Goose", prices = {["default"] = 1023.75, ["Fly"] = 2051.01, ["Ride"] = 1150.21, ["Fly|Ride"] = 1076.24, ["Neon"] = 3555.41, ["Neon|Ride"] = 3875.83, ["Neon|Fly|Ride"] = 2887.5, ["Mega|Fly|Ride"] = 11625.89}},
    ["rbxassetid://12779257292"] = {name = "Pudding Cat", prices = {["default"] = 25.73, ["Fly"] = 76.61, ["Ride"] = 166.85, ["Fly|Ride"] = 191.63, ["Neon"] = 112.88, ["Neon|Fly"] = 273.82, ["Neon|Ride"] = 205.11, ["Mega|Fly|Ride"] = 649.69}},
    ["rbxassetid://83376259738301"] = {name = "Mrs. Whiskerpips", prices = {["default"] = 2.1, ["Fly"] = 49.26, ["Ride"] = 25.88, ["Fly|Ride"] = 80.89, ["Neon"] = 15.31, ["Neon|Fly"] = 79.83, ["Neon|Ride"] = 32.83, ["Neon|Fly|Ride"] = 91.47, ["Mega"] = 81.04, ["Mega|Ride"] = 108.74, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://110894046614323"] = {name = "Partridge", prices = {["default"] = 8.91, ["Ride"] = 47.25, ["Fly|Ride"] = 137.44, ["Neon"] = 202.14, ["Neon|Fly|Ride"] = 393.73, ["Mega"] = 410.31, ["Mega|Ride"] = 421.71, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://114034119324343"] = {name = "Muskrat", prices = {["default"] = 2.1, ["Ride"] = 18.62, ["Fly|Ride"] = 59.49, ["Neon"] = 3.67, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 18.01, ["Mega|Fly"] = 123.11, ["Mega|Ride"] = 48.22, ["Mega|Fly|Ride"] = 155.28}},
    ["rbxassetid://15547904644"] = {name = "Harp Seal", prices = {["default"] = 73.84, ["Ride"] = 117.95, ["Fly|Ride"] = 135.38, ["Neon"] = 820.41, ["Neon|Ride"] = 393.75, ["Mega"] = 1062.09, ["Mega|Ride"] = 1042.13, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://14978702254"] = {name = "Scarecrow Cat", prices = {["default"] = 8.52, ["Ride"] = 44.1, ["Fly|Ride"] = 124.69, ["Neon"] = 62.11, ["Neon|Ride"] = 223.12, ["Neon|Fly|Ride"] = 256.9, ["Mega"] = 669.38, ["Mega|Ride"] = 544.69, ["Mega|Fly|Ride"] = 553.88}},
    ["rbxassetid://95871612352029"] = {name = "Cold Cube", prices = {["default"] = 2.1, ["Ride"] = 26.69, ["Neon"] = 11.82, ["Neon|Ride"] = 46.5, ["Mega"] = 137.47, ["Mega|Ride"] = 157.49, ["Mega|Fly|Ride"] = 547.77}},
    ["rbxassetid://114456035353449"] = {name = "Bauble Buddies", prices = {["default"] = 157.5, ["Fly"] = 52.49, ["Ride"] = 109.75, ["Fly|Ride"] = 111.74, ["Neon"] = 278.25, ["Neon|Ride"] = 109.75, ["Neon|Fly|Ride"] = 342.61, ["Mega"] = 684.36, ["Mega|Ride"] = 1025.77, ["Mega|Fly|Ride"] = 1069.36}},
    ["rbxassetid://15383967605"] = {name = "Gingerbread Mouse", prices = {["default"] = 12.55, ["Ride"] = 35.9, ["Fly|Ride"] = 98.32, ["Neon"] = 41.75, ["Neon|Ride"] = 174.18, ["Neon|Fly|Ride"] = 315, ["Mega"] = 465.71, ["Mega|Ride"] = 512.9, ["Mega|Fly|Ride"] = 410.31}},
    ["rbxassetid://11767069383"] = {name = "Woolly Rhino", prices = {["default"] = 39.37, ["Ride"] = 84, ["Neon"] = 388.23, ["Neon|Ride"] = 721.88, ["Neon|Fly|Ride"] = 210, ["Mega"] = 1860.73, ["Mega|Ride"] = 2324.67, ["Mega|Fly|Ride"] = 1579.68}},
    ["rbxassetid://95133623103638"] = {name = "Samoyed", prices = {["default"] = 6.46, ["Ride"] = 59.49, ["Fly|Ride"] = 78.75, ["Neon"] = 30.23, ["Neon|Ride"] = 86.2, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 104.9, ["Mega|Ride"] = 226.94, ["Mega|Fly|Ride"] = 288.15}},
    ["rbxassetid://8071236757"] = {name = "St Bernard", prices = {["default"] = 6.56, ["Ride"] = 20.45, ["Fly|Ride"] = 78.75, ["Neon"] = 63.47, ["Neon|Ride"] = 135.38, ["Neon|Fly|Ride"] = 124.38, ["Mega"] = 464.63, ["Mega|Ride"] = 402.94, ["Mega|Fly|Ride"] = 545.35}},
    ["rbxassetid://14276930615"] = {name = "Alley Cat", prices = {["default"] = 124.69, ["Fly"] = 177.59, ["Ride"] = 177.18, ["Fly|Ride"] = 295.24, ["Neon"] = 552.74, ["Neon|Ride"] = 577.75, ["Neon|Fly|Ride"] = 636.57, ["Mega|Ride"] = 2335.15, ["Mega|Fly|Ride"] = 1903.13}},
    ["rbxassetid://6498256417"] = {name = "Dolphin", prices = {["default"] = 2.1, ["Fly"] = 29.86, ["Ride"] = 16.17, ["Fly|Ride"] = 37.8, ["Neon"] = 13.01, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 30.33, ["Neon|Fly|Ride"] = 68.24, ["Mega"] = 124.69, ["Mega|Ride"] = 232.47, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://7734900468"] = {name = "Halloween White Skeleton Dog", prices = {["default"] = 11.45, ["Fly"] = 99.75, ["Ride"] = 27.05, ["Fly|Ride"] = 62.77, ["Neon"] = 74.69, ["Neon|Fly"] = 232.45, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 137.47, ["Mega"] = 393.75, ["Mega|Ride"] = 427.75, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://9982202041"] = {name = "Poodle", prices = {["default"] = 2.1, ["Fly"] = 16.34, ["Ride"] = 14.37, ["Fly|Ride"] = 43.31, ["Neon"] = 2.1, ["Neon|Fly"] = 25.55, ["Neon|Ride"] = 14.85, ["Neon|Fly|Ride"] = 39.29, ["Mega"] = 15.1, ["Mega|Fly"] = 48.83, ["Mega|Ride"] = 33.74, ["Mega|Fly|Ride"] = 104.64}},
    ["rbxassetid://73671766703168"] = {name = "Pilot Gull", prices = {["default"] = 2.1, ["Ride"] = 131.15, ["Fly|Ride"] = 39.38, ["Neon"] = 2.52, ["Neon|Ride"] = 41.04, ["Mega"] = 18, ["Mega|Fly"] = 104.99, ["Mega|Ride"] = 63.03, ["Mega|Fly|Ride"] = 125.99}},
    ["rbxassetid://14146127209"] = {name = "Indian Leopard", prices = {["default"] = 2.1, ["Fly"] = 34.89, ["Ride"] = 18.38, ["Fly|Ride"] = 85.8, ["Neon"] = 26.25, ["Neon|Ride"] = 64.98, ["Mega"] = 262.5, ["Mega|Ride"] = 116.17, ["Mega|Fly|Ride"] = 242.82}},
    ["rbxassetid://113558592714438"] = {name = "Seabed Creeper", prices = {["default"] = 37.52, ["Ride"] = 52.47, ["Fly|Ride"] = 131.25, ["Neon"] = 114.09, ["Neon|Ride"] = 348.67, ["Neon|Fly|Ride"] = 433.13, ["Mega"] = 423.01, ["Mega|Ride"] = 523.69, ["Mega|Fly|Ride"] = 664.71}},
    ["rbxassetid://4281674713"] = {name = "Bee", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 16.26, ["Fly|Ride"] = 36.93, ["Neon"] = 14.43, ["Neon|Fly"] = 27.71, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 65.43, ["Mega"] = 118.13, ["Mega|Fly"] = 170.61, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 188.99}},
    ["rbxassetid://5862774392"] = {name = "Bat", prices = {["default"] = 3.71, ["Fly"] = 39.38, ["Ride"] = 19.69, ["Fly|Ride"] = 66.89, ["Neon"] = 27.93, ["Neon|Fly"] = 55.4, ["Neon|Ride"] = 31.18, ["Neon|Fly|Ride"] = 105, ["Mega"] = 204, ["Mega|Fly"] = 410.31, ["Mega|Ride"] = 192.75, ["Mega|Fly|Ride"] = 257.27}},
    ["rbxassetid://18223359092"] = {name = "Birthday Butterfly 2024", prices = {["default"] = 2.1, ["Fly"] = 21.42, ["Ride"] = 15.99, ["Fly|Ride"] = 82.06, ["Neon"] = 7.24, ["Neon|Fly"] = 98.43, ["Neon|Ride"] = 20.06, ["Neon|Fly|Ride"] = 89.22, ["Mega"] = 103.2, ["Mega|Fly"] = 220.5, ["Mega|Ride"] = 204.74, ["Mega|Fly|Ride"] = 129.93}},
    ["rbxassetid://17822765706"] = {name = "Pink Betta Fish", prices = {["default"] = 8.5, ["Ride"] = 23.43, ["Neon"] = 27.53, ["Neon|Ride"] = 85.29, ["Neon|Fly|Ride"] = 273.9, ["Mega"] = 232.15, ["Mega|Fly"] = 400.32, ["Mega|Ride"] = 321.57}},
    ["rbxassetid://14146174264"] = {name = "Rock Pigeon", prices = {["default"] = 11.95, ["Fly"] = 127.46, ["Ride"] = 122.75, ["Fly|Ride"] = 157.5, ["Neon"] = 65.62, ["Neon|Ride"] = 262.39, ["Mega"] = 547.77, ["Mega|Fly|Ride"] = 643.13}},
    ["rbxassetid://11758575946"] = {name = "Water Moon Bear", prices = {["default"] = 2.1, ["Fly"] = 42.21, ["Ride"] = 27.71, ["Fly|Ride"] = 44.35, ["Neon"] = 22.26, ["Neon|Fly"] = 196.67, ["Neon|Ride"] = 41.91, ["Neon|Fly|Ride"] = 109.4, ["Mega"] = 328.26, ["Mega|Ride"] = 297.94, ["Mega|Fly|Ride"] = 418.28}},
    ["rbxassetid://6498256132"] = {name = "Seahorse", prices = {["default"] = 2.1, ["Fly"] = 21.28, ["Ride"] = 15.42, ["Fly|Ride"] = 34.83, ["Neon"] = 13.85, ["Neon|Fly"] = 46.51, ["Neon|Ride"] = 21.36, ["Neon|Fly|Ride"] = 72.19, ["Mega"] = 209.9, ["Mega|Ride"] = 232.47, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://13664973582"] = {name = "Many Mackerel", prices = {["default"] = 183.75, ["Fly"] = 393.75, ["Ride"] = 306.87, ["Fly|Ride"] = 392.43, ["Neon"] = 1096.09, ["Neon|Ride"] = 1359.75, ["Neon|Fly|Ride"] = 1094.48, ["Mega|Fly|Ride"] = 3740.63}},
    ["rbxassetid://114806716799554"] = {name = "Ringmaster Gibbon", prices = {["default"] = 8.91, ["Ride"] = 63.67, ["Neon"] = 42.94, ["Neon|Ride"] = 55.4, ["Neon|Fly|Ride"] = 410.31, ["Mega"] = 118.13, ["Mega|Ride"] = 420.6, ["Mega|Fly|Ride"] = 472.49}},
    ["rbxassetid://14360917588"] = {name = "Magma Moose", prices = {["default"] = 2.1, ["Fly"] = 102.56, ["Ride"] = 21.84, ["Fly|Ride"] = 79.07, ["Neon"] = 20.48, ["Neon|Ride"] = 41.04, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 203.23, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 273.9}},
    ["rbxassetid://18957942216"] = {name = "Starhopper", prices = {["default"] = 6.57, ["Ride"] = 41.04, ["Neon"] = 60.9, ["Neon|Ride"] = 213.45, ["Neon|Fly|Ride"] = 603.74, ["Mega"] = 603.74, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 549.29}},
    ["rbxassetid://3181727071"] = {name = "Puma", prices = {["default"] = 2.1, ["Fly"] = 15.41, ["Ride"] = 11.82, ["Fly|Ride"] = 26.03, ["Neon"] = 2.1, ["Neon|Fly"] = 28.66, ["Neon|Ride"] = 15.27, ["Neon|Fly|Ride"] = 27.76, ["Mega"] = 18.38, ["Mega|Fly"] = 68.74, ["Mega|Ride"] = 41.04, ["Mega|Fly|Ride"] = 96.46}},
    ["rbxassetid://4841039508"] = {name = "Rock", prices = {["default"] = 2.1, ["Fly"] = 24.93, ["Ride"] = 18.94, ["Fly|Ride"] = 61.36, ["Neon"] = 12.63, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 96.76, ["Mega"] = 85.32, ["Mega|Ride"] = 211.11, ["Mega|Fly|Ride"] = 208.69}},
    ["rbxassetid://94235745630523"] = {name = "Rainbow Trout", prices = {["default"] = 2.1, ["Ride"] = 144.38, ["Neon"] = 39.38, ["Neon|Ride"] = 273.82, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 110.62, ["Mega|Ride"] = 342.61, ["Mega|Fly|Ride"] = 328.12}},
    ["rbxassetid://4440867249"] = {name = "Llama", prices = {["default"] = 75.51, ["Fly"] = 162.74, ["Ride"] = 113.85, ["Fly|Ride"] = 173.25, ["Neon"] = 556.49, ["Neon|Ride"] = 367.5, ["Neon|Fly|Ride"] = 446.25, ["Mega"] = 2051.52, ["Mega|Ride"] = 3420.89, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://11571113805"] = {name = "Bloodhound", prices = {["default"] = 2.1, ["Fly"] = 81.29, ["Ride"] = 56.27, ["Fly|Ride"] = 65.63, ["Neon"] = 22.17, ["Neon|Ride"] = 111.6, ["Neon|Fly|Ride"] = 137.47, ["Mega"] = 213.68, ["Mega|Ride"] = 356.12, ["Mega|Fly|Ride"] = 410.31}},
    ["rbxassetid://78423968285099"] = {name = "Wren", prices = {["default"] = 2.1, ["Fly"] = 20.99, ["Ride"] = 48.99, ["Neon"] = 5.16, ["Neon|Ride"] = 177.06, ["Neon|Fly|Ride"] = 530.14, ["Mega"] = 52.5, ["Mega|Fly"] = 313.69, ["Mega|Ride"] = 126, ["Mega|Fly|Ride"] = 96.44}},
    ["rbxassetid://110871792705214"] = {name = "Burger Bear", prices = {["default"] = 72.82, ["Fly"] = 525, ["Ride"] = 94.39, ["Fly|Ride"] = 209.24, ["Neon"] = 115.75, ["Neon|Ride"] = 223.13, ["Neon|Fly|Ride"] = 273.9, ["Mega"] = 636.57, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 728.44}},
    ["rbxassetid://3181727637"] = {name = "Fennec Fox", prices = {["default"] = 2.1, ["Fly"] = 17.06, ["Ride"] = 14.13, ["Fly|Ride"] = 91.88, ["Neon"] = 2.62, ["Neon|Fly"] = 20.46, ["Neon|Ride"] = 15.58, ["Neon|Fly|Ride"] = 39, ["Mega"] = 17.64, ["Mega|Fly"] = 49.88, ["Mega|Ride"] = 35.44, ["Mega|Fly|Ride"] = 97.47}},
    ["rbxassetid://115530716039589"] = {name = "Milk Choccybunny", prices = {["default"] = 2.1, ["Neon"] = 4.92, ["Neon|Ride"] = 65.52, ["Neon|Fly|Ride"] = 209.34, ["Mega"] = 26.46, ["Mega|Ride"] = 87.3, ["Mega|Fly|Ride"] = 384.75}},
    ["rbxassetid://83001092186817"] = {name = "White Choccybunny", prices = {["default"] = 2.1, ["Ride"] = 107.63, ["Neon"] = 8.69, ["Neon|Ride"] = 130.1, ["Neon|Fly|Ride"] = 180.54, ["Mega"] = 78.75, ["Mega|Fly"] = 178.5, ["Mega|Ride"] = 116.94, ["Mega|Fly|Ride"] = 219.59}},
    ["rbxassetid://103795616446776"] = {name = "Waffle Wyrm", prices = {["default"] = 3.94, ["Fly"] = 77.17, ["Ride"] = 42, ["Fly|Ride"] = 205.09, ["Neon"] = 26.64, ["Neon|Fly"] = 137.44, ["Neon|Ride"] = 77.44, ["Neon|Fly|Ride"] = 217.48, ["Mega"] = 117.48, ["Mega|Fly"] = 220.5, ["Mega|Ride"] = 137.65, ["Mega|Fly|Ride"] = 254.42}},
    ["rbxassetid://9982358951"] = {name = "Orangutan", prices = {["default"] = 2.1, ["Fly"] = 15.65, ["Ride"] = 15.4, ["Fly|Ride"] = 35.9, ["Neon"] = 2.1, ["Neon|Ride"] = 15.75, ["Neon|Fly|Ride"] = 39.38, ["Mega"] = 18.04, ["Mega|Ride"] = 49.23, ["Mega|Fly|Ride"] = 118.13}},
    ["rbxassetid://129021417712364"] = {name = "Kage Crow", prices = {["default"] = 16.38, ["Fly"] = 131.25, ["Ride"] = 125.09, ["Neon"] = 109.12, ["Neon|Fly"] = 410.21, ["Neon|Ride"] = 183.74, ["Neon|Fly|Ride"] = 958.07, ["Mega"] = 513.64, ["Mega|Ride"] = 438.38, ["Mega|Fly|Ride"] = 410.31}},
    ["rbxassetid://4849941238"] = {name = "Hedgehog", prices = {["default"] = 2610.55, ["Ride"] = 2735.01, ["Fly|Ride"] = 2559.38, ["Neon|Fly|Ride"] = 9688.21, ["Mega|Fly|Ride"] = 35833.64}},
    ["rbxassetid://4800190144"] = {name = "Ginger Cat", prices = {["default"] = 2.1, ["Ride"] = 17.29, ["Fly|Ride"] = 40.01, ["Neon"] = 8.08, ["Neon|Fly"] = 63.7, ["Neon|Ride"] = 22.98, ["Neon|Fly|Ride"] = 69.83, ["Mega"] = 94.39, ["Mega|Fly"] = 457.5, ["Mega|Ride"] = 119.01, ["Mega|Fly|Ride"] = 175.98}},
    ["rbxassetid://18119333909"] = {name = "Rodeo Bull", prices = {["default"] = 2.1, ["Neon"] = 13.97, ["Mega"] = 140.37, ["Mega|Fly"] = 441, ["Mega|Ride"] = 158.82, ["Mega|Fly|Ride"] = 410.31}},
    ["rbxassetid://11837080223"] = {name = "Highland Cow", prices = {["default"] = 22.58, ["Fly"] = 109.75, ["Ride"] = 31.17, ["Fly|Ride"] = 105, ["Neon"] = 130.25, ["Neon|Ride"] = 107.72, ["Neon|Fly|Ride"] = 220.5, ["Mega"] = 459.38, ["Mega|Ride"] = 460.69, ["Mega|Fly|Ride"] = 383.94}},
    ["rbxassetid://14398816006"] = {name = "Rooster", prices = {["default"] = 38.07, ["Ride"] = 41.14, ["Neon"] = 187.67, ["Mega"] = 1252.02, ["Mega|Ride"] = 273.9, ["Mega|Fly|Ride"] = 773.43}},
    ["rbxassetid://3409444089"] = {name = "Hyena", prices = {["default"] = 153.56, ["Fly"] = 1368.02, ["Ride"] = 197.87, ["Fly|Ride"] = 369.2, ["Neon"] = 1312.5, ["Neon|Ride"] = 693.39, ["Neon|Fly|Ride"] = 971.41, ["Mega"] = 6154.53, ["Mega|Fly|Ride"] = 3478.13}},
    ["rbxassetid://127067345833475"] = {name = "Hummingbird", prices = {["default"] = 10.17, ["Ride"] = 65.54, ["Fly|Ride"] = 675.94, ["Neon"] = 20.13, ["Neon|Ride"] = 146.32, ["Mega"] = 156.19, ["Mega|Ride"] = 171.32, ["Mega|Fly|Ride"] = 582.75}},
    ["rbxassetid://130497948875084"] = {name = "Marabou Stork", prices = {["default"] = 2.1, ["Neon"] = 18.37, ["Neon|Ride"] = 114.85, ["Mega"] = 130.86, ["Mega|Ride"] = 333.27, ["Mega|Fly|Ride"] = 419.99}},
    ["rbxassetid://127017727552531"] = {name = "Angus Calf", prices = {["default"] = 2.1, ["Fly"] = 101.99, ["Fly|Ride"] = 131.25, ["Neon"] = 10.4, ["Neon|Ride"] = 43.11, ["Mega"] = 94.5, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://12779130089"] = {name = "Sprout Snail", prices = {["Neon"] = 145.69, ["Neon|Ride"] = 1165.82, ["Mega|Ride"] = 615.47, ["Mega|Fly|Ride"] = 786.77}},
    ["rbxassetid://117824155556510"] = {name = "Princess Mare", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 82.06, ["Mega"] = 18.48, ["Mega|Fly"] = 116.27, ["Mega|Ride"] = 82.07, ["Mega|Fly|Ride"] = 273.9}},
    ["rbxassetid://122766274014139"] = {name = "Gaelic Fae", prices = {["default"] = 97.89, ["Fly"] = 205.11, ["Ride"] = 113.93, ["Fly|Ride"] = 178.45, ["Neon"] = 410.21, ["Neon|Ride"] = 451.5, ["Neon|Fly|Ride"] = 512.6, ["Mega"] = 2086.88, ["Mega|Fly|Ride"] = 1733.53}},
    ["rbxassetid://17255807019"] = {name = "Weevil", prices = {["default"] = 2.1, ["Ride"] = 91.82, ["Neon"] = 10.31, ["Neon|Ride"] = 140.91, ["Neon|Fly|Ride"] = 205.16, ["Mega"] = 127.32, ["Mega|Ride"] = 272.87, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://3743720235"] = {name = "Capybara", prices = {["default"] = 45.94, ["Fly"] = 217.38, ["Ride"] = 90, ["Fly|Ride"] = 157.39, ["Neon"] = 266.68, ["Neon|Ride"] = 328.02, ["Mega"] = 1436.07, ["Mega|Fly|Ride"] = 1548.74}},
    ["rbxassetid://106815320234576"] = {name = "Ehecatl", prices = {["default"] = 2.1, ["Ride"] = 22.58, ["Fly|Ride"] = 53.03, ["Neon"] = 3.94, ["Neon|Fly"] = 87.44, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 83.99, ["Mega"] = 55.41, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 171.94}},
    ["rbxassetid://110449571836616"] = {name = "Irish Setter", prices = {["default"] = 6.57, ["Ride"] = 45.28, ["Neon"] = 19.68, ["Neon|Ride"] = 105, ["Mega"] = 87.94, ["Mega|Ride"] = 191.83, ["Mega|Fly|Ride"] = 626.14}},
    ["rbxassetid://93751644677101"] = {name = "Winter Doe", prices = {["default"] = 13.02, ["Neon"] = 30.75, ["Neon|Ride"] = 104.27, ["Mega"] = 232.79, ["Mega|Ride"] = 369.29, ["Mega|Fly|Ride"] = 620.7}},
    ["rbxassetid://90667836208550"] = {name = "Munchkin Cat", prices = {["default"] = 542.77, ["Ride"] = 453.14, ["Fly|Ride"] = 588.66, ["Neon"] = 1181.25, ["Neon|Ride"] = 1722.84, ["Neon|Fly|Ride"] = 1378.12, ["Mega|Ride"] = 4725, ["Mega|Fly|Ride"] = 4198.69}},
    ["rbxassetid://3743734696"] = {name = "Rhino", prices = {["default"] = 31.5, ["Ride"] = 63.53, ["Fly|Ride"] = 82.06, ["Neon"] = 278.67, ["Neon|Ride"] = 367.5, ["Neon|Fly|Ride"] = 355.95, ["Mega|Fly|Ride"] = 1995}},
    ["rbxassetid://7734928397"] = {name = "Halloween Blue Scorpion", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 17.69, ["Fly|Ride"] = 91.88, ["Neon"] = 7.79, ["Neon|Fly"] = 85.32, ["Neon|Ride"] = 21.87, ["Neon|Fly|Ride"] = 101.49, ["Mega"] = 65.63, ["Mega|Ride"] = 85.32, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://116859365721104"] = {name = "Shadow Dragon Ducky", prices = {["default"] = 23.28, ["Fly"] = 219.19, ["Ride"] = 49.87, ["Fly|Ride"] = 124.38, ["Neon"] = 65.61, ["Neon|Fly"] = 464.88, ["Neon|Ride"] = 115.5, ["Neon|Fly|Ride"] = 182.39, ["Mega"] = 262.48, ["Mega|Fly"] = 956.62, ["Mega|Ride"] = 279.57, ["Mega|Fly|Ride"] = 379.21}},
    ["rbxassetid://6060991084"] = {name = "Musk Ox", prices = {["default"] = 6.44, ["Ride"] = 20.69, ["Fly|Ride"] = 82.06, ["Neon"] = 140.59, ["Neon|Ride"] = 116.92, ["Neon|Fly|Ride"] = 263.86, ["Mega"] = 1094.48, ["Mega|Ride"] = 514.5, ["Mega|Fly|Ride"] = 412.84}},
    ["rbxassetid://119284351481681"] = {name = "Violet Friend", prices = {["default"] = 3.91, ["Neon"] = 14.4, ["Mega"] = 72.18, ["Mega|Ride"] = 91.88}},
    ["rbxassetid://10971808356"] = {name = "Basilisk", prices = {["default"] = 3.83, ["Fly"] = 70.88, ["Ride"] = 22.32, ["Fly|Ride"] = 55.4, ["Neon"] = 25.47, ["Neon|Ride"] = 31.8, ["Neon|Fly|Ride"] = 274.41, ["Mega"] = 137.47, ["Mega|Ride"] = 90.68, ["Mega|Fly|Ride"] = 1641.22}},
    ["rbxassetid://3744706727"] = {name = "Platypus", prices = {["default"] = 103.69, ["Fly"] = 342.53, ["Ride"] = 139.5, ["Fly|Ride"] = 235.62, ["Neon"] = 697.41, ["Neon|Ride"] = 616.88, ["Neon|Fly|Ride"] = 853.13, ["Mega|Fly|Ride"] = 2597.22}},
    ["rbxassetid://12480556316"] = {name = "Black Macaque", prices = {["default"] = 67.68, ["Ride"] = 69.83, ["Fly|Ride"] = 137.44, ["Neon"] = 178.45, ["Neon|Ride"] = 205.11, ["Neon|Fly|Ride"] = 273.9, ["Mega"] = 889.34, ["Mega|Ride"] = 800.09, ["Mega|Fly|Ride"] = 697.52}},
    ["rbxassetid://4849941000"] = {name = "Dalmatian", prices = {["default"] = 2218.12, ["Fly"] = 2432.5, ["Ride"] = 2324.81, ["Fly|Ride"] = 2165.62, ["Neon"] = 10938.98, ["Neon|Fly|Ride"] = 6424.69, ["Mega|Fly|Ride"] = 26250}},
    ["rbxassetid://139319822015938"] = {name = "Sea Skeleton Panda", prices = {["default"] = 2.63, ["Fly"] = 65625, ["Ride"] = 77.89, ["Neon"] = 12.5, ["Neon|Ride"] = 137.44, ["Neon|Fly|Ride"] = 103.69, ["Mega"] = 122.28, ["Mega|Fly"] = 786.19, ["Mega|Ride"] = 197.3, ["Mega|Fly|Ride"] = 410.31}},
    ["rbxassetid://104838807480936"] = {name = "Winter Fawn", prices = {["default"] = 8.92, ["Ride"] = 54.66, ["Neon"] = 34.68, ["Neon|Fly|Ride"] = 131.25, ["Mega|Ride"] = 547.77, ["Mega|Fly|Ride"] = 820.61}},
    ["rbxassetid://100705885132301"] = {name = "Cabbit", prices = {["default"] = 1092, ["Fly"] = 1160.02, ["Ride"] = 968.88, ["Fly|Ride"] = 918.75, ["Neon"] = 2778.57, ["Neon|Ride"] = 2611.87, ["Neon|Fly|Ride"] = 2782.49, ["Mega"] = 11078.13, ["Mega|Fly|Ride"] = 11156.25}},
    ["rbxassetid://12480406935"] = {name = "Binturong", prices = {["default"] = 28.87, ["Ride"] = 57.51, ["Fly|Ride"] = 173.35, ["Neon"] = 157.5, ["Neon|Ride"] = 297.18, ["Mega"] = 839.9, ["Mega|Ride"] = 804.56, ["Mega|Fly|Ride"] = 1368.38}},
    ["rbxassetid://73245262062822"] = {name = "Prism Snake", prices = {["default"] = 3.94, ["Ride"] = 23, ["Fly|Ride"] = 137.44, ["Neon"] = 9.38, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 247.42, ["Mega|Ride"] = 155.76, ["Mega|Fly|Ride"] = 547.77}},
    ["rbxassetid://113717425344888"] = {name = "Magpie", prices = {["default"] = 2.1, ["Fly"] = 111.09, ["Ride"] = 137.44, ["Neon"] = 3.94, ["Neon|Ride"] = 56.06, ["Mega"] = 19.51, ["Mega|Ride"] = 105.67, ["Mega|Fly|Ride"] = 246.2}},
    ["rbxassetid://10318105900"] = {name = "Purple Butterfly", prices = {["default"] = 84.93, ["Ride"] = 236.25, ["Fly|Ride"] = 170.63, ["Neon"] = 459.38, ["Neon|Fly|Ride"] = 551.25, ["Mega"] = 2599.27, ["Mega|Fly|Ride"] = 4103.03}},
    ["rbxassetid://95049698731940"] = {name = "Throwback Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15503941919"] = {name = "Arctic Hare", prices = {["default"] = 3.94, ["Neon"] = 15.75, ["Neon|Ride"] = 52.01, ["Mega"] = 196.88, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 263.71}},
    ["rbxassetid://10274421272"] = {name = "Royal Corgi", prices = {["default"] = 73.5, ["Ride"] = 151.79, ["Neon"] = 385.88, ["Neon|Ride"] = 533.28, ["Neon|Fly|Ride"] = 494.32}},
    ["rbxassetid://13978968837"] = {name = "Bird of Paradise", prices = {["default"] = 15.66, ["Fly"] = 105, ["Fly|Ride"] = 109.75, ["Neon"] = 26.2, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 153.4, ["Mega|Ride"] = 164.07, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://3261465850"] = {name = "Pink Cat", prices = {["default"] = 262.39, ["Ride"] = 330.75, ["Fly|Ride"] = 369.1, ["Neon"] = 1438.92, ["Neon|Ride"] = 836.06, ["Neon|Fly|Ride"] = 879.01, ["Mega|Fly|Ride"] = 3899.56}},
    ["rbxassetid://8969010905"] = {name = "Red Fox", prices = {["default"] = 7.24, ["Fly"] = 91.88, ["Ride"] = 19.3, ["Fly|Ride"] = 103.76, ["Neon"] = 40.85, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 114.18, ["Mega"] = 342.61, ["Mega|Ride"] = 272.87, ["Mega|Fly|Ride"] = 386.42}},
    ["rbxassetid://3181728128"] = {name = "Red Panda", prices = {["default"] = 2.1, ["Fly"] = 23.61, ["Ride"] = 15.74, ["Fly|Ride"] = 32.82, ["Neon"] = 3.94, ["Neon|Fly"] = 30.78, ["Neon|Ride"] = 20.52, ["Neon|Fly|Ride"] = 64.63, ["Mega"] = 78.75, ["Mega|Fly"] = 129.33, ["Mega|Ride"] = 115.49, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://13077769577"] = {name = "Pelican", prices = {["default"] = 918.65, ["Ride"] = 1050, ["Fly|Ride"] = 1194.38, ["Neon|Ride"] = 7521.01, ["Neon|Fly|Ride"] = 5471.38, ["Mega"] = 25986.41}},
    ["rbxassetid://115281603518501"] = {name = "DJ Snooze", prices = {["default"] = 10.49, ["Fly"] = 957.84, ["Ride"] = 72.19, ["Fly|Ride"] = 205.11, ["Neon"] = 42.75, ["Neon|Ride"] = 311.75, ["Mega"] = 269.07, ["Mega|Ride"] = 383.64, ["Mega|Fly|Ride"] = 551.55}},
    ["rbxassetid://111847888001946"] = {name = "Choco Penguin", prices = {["default"] = 7.88, ["Fly"] = 46.1, ["Ride"] = 42.69, ["Fly|Ride"] = 127.32, ["Neon"] = 26.25, ["Neon|Fly"] = 124.4, ["Neon|Ride"] = 57.75, ["Neon|Fly|Ride"] = 130.79, ["Mega"] = 656.25, ["Mega|Fly"] = 226.71, ["Mega|Ride"] = 198.09, ["Mega|Fly|Ride"] = 223.01}},
    ["rbxassetid://4621220487"] = {name = "Panda", prices = {["default"] = 28.81, ["Fly"] = 53.34, ["Ride"] = 47.23, ["Fly|Ride"] = 63, ["Neon|Ride"] = 195.46, ["Neon|Fly|Ride"] = 203.33, ["Mega"] = 2051.52, ["Mega|Ride"] = 1230.92, ["Mega|Fly|Ride"] = 1025.77}},
    ["rbxassetid://12917347184"] = {name = "Flower Power Duckling", prices = {["default"] = 17.47, ["Fly"] = 82.06, ["Ride"] = 27.45, ["Fly|Ride"] = 91.87, ["Neon"] = 72.86, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 88.3, ["Neon|Fly|Ride"] = 177.19, ["Mega"] = 355.95, ["Mega|Fly"] = 367.5, ["Mega|Ride"] = 376.69, ["Mega|Fly|Ride"] = 377.9}},
    ["rbxassetid://93775555430694"] = {name = "Pumpkin Friend", prices = {["default"] = 30.84, ["Fly|Ride"] = 399.96, ["Neon"] = 118.64, ["Neon|Ride"] = 273.82, ["Mega"] = 572.39, ["Mega|Ride"] = 572.39, ["Mega|Fly|Ride"] = 577.5}},
    ["rbxassetid://83317902236850"] = {name = "Kakapo", prices = {["default"] = 2.1, ["Fly|Ride"] = 273.82, ["Neon"] = 2.36, ["Neon|Fly"] = 55.49, ["Neon|Ride"] = 111.02, ["Neon|Fly|Ride"] = 310.36, ["Mega"] = 17.01, ["Mega|Ride"] = 89.1, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://5862774043"] = {name = "Ghost Bunny", prices = {["default"] = 52.49, ["Fly"] = 114.19, ["Ride"] = 92.18, ["Fly|Ride"] = 155.76, ["Neon"] = 393.75, ["Neon|Ride"] = 356.81, ["Neon|Fly|Ride"] = 440.08, ["Mega"] = 3282.42, ["Mega|Ride"] = 1688.4, ["Mega|Fly|Ride"] = 1234.77}},
    ["rbxassetid://10639131895"] = {name = "Spider Crab", prices = {["default"] = 2.1, ["Fly"] = 107.62, ["Ride"] = 23.15, ["Fly|Ride"] = 109.75, ["Neon"] = 51.19, ["Neon|Ride"] = 78.72, ["Mega"] = 773.07, ["Mega|Ride"] = 382.67, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://10193736072"] = {name = "Red Crowned Crane", prices = {["default"] = 2.1, ["Fly"] = 20.79, ["Ride"] = 20.52, ["Fly|Ride"] = 38.07, ["Neon"] = 15.64, ["Neon|Ride"] = 52.32, ["Neon|Fly|Ride"] = 122.84, ["Mega|Ride"] = 269.79, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://13804047294"] = {name = "Arctic Tern", prices = {["default"] = 2.1, ["Ride"] = 126, ["Neon"] = 15.75, ["Neon|Fly"] = 135.38, ["Neon|Fly|Ride"] = 183.62, ["Mega"] = 287.22, ["Mega|Fly|Ride"] = 488.28}},
    ["rbxassetid://14883937353"] = {name = "Ghost Dog", prices = {["default"] = 55.04, ["Ride"] = 96.42, ["Fly|Ride"] = 262.5, ["Neon"] = 262.48, ["Neon|Ride"] = 301.88, ["Neon|Fly|Ride"] = 369.29, ["Mega"] = 1459.66, ["Mega|Ride"] = 1076.25, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://103241919688695"] = {name = "2025 Birthday Butterfly", prices = {["default"] = 14.34, ["Neon"] = 28.77, ["Neon|Ride"] = 76.93, ["Mega"] = 104.89, ["Mega|Fly|Ride"] = 315.3}},
    ["rbxassetid://86594144838863"] = {name = "Tree Frog", prices = {["default"] = 2.1, ["Ride"] = 39.38, ["Neon"] = 2.28, ["Neon|Ride"] = 20.52, ["Mega"] = 15.65, ["Mega|Ride"] = 40.69, ["Mega|Fly|Ride"] = 393.65}},
    ["rbxassetid://99048375832409"] = {name = "Shih Tzu", prices = {["default"] = 2.1, ["Fly"] = 102.94, ["Ride"] = 31.65, ["Fly|Ride"] = 38.61, ["Neon"] = 2.62, ["Neon|Ride"] = 29.4, ["Neon|Fly|Ride"] = 118.12, ["Mega"] = 17.83, ["Mega|Ride"] = 44.91, ["Mega|Fly|Ride"] = 139.95}},
    ["rbxassetid://6998403122"] = {name = "Kirin", prices = {["default"] = 2.1, ["Fly"] = 24.57, ["Ride"] = 14.9, ["Fly|Ride"] = 52.46, ["Neon"] = 6.49, ["Neon|Ride"] = 26.81, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 123.11, ["Mega|Ride"] = 54.44, ["Mega|Fly|Ride"] = 139.55}},
    ["rbxassetid://15930472964"] = {name = "Gila Monster", prices = {["default"] = 2.1, ["Ride"] = 28.88, ["Fly|Ride"] = 65.63, ["Neon"] = 22.32, ["Mega"] = 118.09, ["Mega|Ride"] = 106.3, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://5721843144"] = {name = "Dilophosaurus", prices = {["default"] = 2.1, ["Fly"] = 38.05, ["Ride"] = 14.99, ["Fly|Ride"] = 47.25, ["Neon"] = 14.34, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 55.41, ["Mega"] = 231.67, ["Mega|Ride"] = 273.9, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://109520235810036"] = {name = "Mini Schnauzer", prices = {["default"] = 66.92, ["Ride"] = 101.73, ["Fly|Ride"] = 219.48, ["Neon"] = 196.76, ["Neon|Ride"] = 330.24, ["Neon|Fly|Ride"] = 1025.77, ["Mega"] = 1550.57, ["Mega|Fly"] = 999.09, ["Mega|Ride"] = 971.25, ["Mega|Fly|Ride"] = 1090.4}},
    ["rbxassetid://3181728229"] = {name = "Snow Cat", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Ride"] = 13.59, ["Fly|Ride"] = 35.34, ["Neon"] = 3.89, ["Neon|Fly"] = 41.75, ["Neon|Ride"] = 16.42, ["Neon|Fly|Ride"] = 59.07, ["Mega"] = 23.63, ["Mega|Fly|Ride"] = 129.74}},
    ["rbxassetid://4506925747"] = {name = "Wolf", prices = {["default"] = 52.41, ["Fly"] = 79.19, ["Ride"] = 23, ["Fly|Ride"] = 76, ["Neon"] = 42, ["Neon|Fly"] = 91.76, ["Neon|Ride"] = 52.49, ["Neon|Fly|Ride"] = 104.89, ["Mega"] = 362.09, ["Mega|Fly"] = 321.78, ["Mega|Ride"] = 267.65, ["Mega|Fly|Ride"] = 311.07}},
    ["rbxassetid://5862774473"] = {name = "Albino Bat", prices = {["default"] = 8.44, ["Fly"] = 47.25, ["Ride"] = 31.8, ["Fly|Ride"] = 95.5, ["Neon"] = 110.15, ["Neon|Ride"] = 141.75, ["Neon|Fly|Ride"] = 210, ["Mega"] = 787.5, ["Mega|Ride"] = 492.09, ["Mega|Fly|Ride"] = 697.41}},
    ["rbxassetid://14978701751"] = {name = "Scarecrow", prices = {["default"] = 3.66, ["Neon"] = 73.41, ["Mega"] = 287.22, ["Mega|Ride"] = 383.64, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://10235589000"] = {name = "Corgi", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 15.74, ["Fly|Ride"] = 34.89, ["Neon"] = 4.08, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 52.95, ["Mega"] = 39.38, ["Mega|Ride"] = 59.42, ["Mega|Fly|Ride"] = 121.96}},
    ["rbxassetid://103710623311342"] = {name = "Ghost Chick", prices = {["default"] = 5.19, ["Fly"] = 75.9, ["Ride"] = 38.07, ["Neon"] = 18.23, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 96.42, ["Mega"] = 137.47, ["Mega|Fly"] = 735, ["Mega|Ride"] = 155.81, ["Mega|Fly|Ride"] = 383.64}},
    ["rbxassetid://4440866423"] = {name = "Cow", prices = {["default"] = 1078.87, ["Ride"] = 1018.37, ["Fly|Ride"] = 1049.99, ["Neon|Ride"] = 2191.88, ["Neon|Fly|Ride"] = 2361.19, ["Mega|Fly|Ride"] = 6929.61}},
    ["rbxassetid://15093139154"] = {name = "Slime", prices = {["default"] = 101.67, ["Ride"] = 141.75, ["Fly|Ride"] = 131.25, ["Neon"] = 525, ["Neon|Ride"] = 569.63, ["Neon|Fly|Ride"] = 655.48, ["Mega"] = 2325.4, ["Mega|Ride"] = 2461.82, ["Mega|Fly|Ride"] = 2038.18}},
    ["rbxassetid://82170828935980"] = {name = "Dracula Fish", prices = {["default"] = 2.1, ["Ride"] = 39.38, ["Neon"] = 5.92, ["Neon|Ride"] = 52.41, ["Neon|Fly|Ride"] = 205.16, ["Mega"] = 80.01, ["Mega|Fly|Ride"] = 205.16}},
    ["rbxassetid://11109302289"] = {name = "Zombie Wolf", prices = {["default"] = 67.48, ["Ride"] = 116.92, ["Fly|Ride"] = 217.38, ["Neon"] = 367.5, ["Neon|Ride"] = 367.49, ["Neon|Fly|Ride"] = 459.38, ["Mega"] = 1312.5, ["Mega|Ride"] = 1504.79, ["Mega|Fly|Ride"] = 1492.72}},
    ["rbxassetid://15369729071"] = {name = "Nutcracker Squirrel", prices = {["default"] = 3.89, ["Ride"] = 47.16, ["Fly|Ride"] = 89.23, ["Neon"] = 21.51, ["Neon|Fly"] = 41.04, ["Neon|Ride"] = 47.79, ["Neon|Fly|Ride"] = 273.9, ["Mega"] = 274.02, ["Mega|Ride"] = 175.37, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://9800792849"] = {name = "Goat", prices = {["default"] = 297.08, ["Fly"] = 410.21, ["Ride"] = 328.13, ["Fly|Ride"] = 378, ["Neon|Ride"] = 1217.28, ["Neon|Fly|Ride"] = 1739.69, ["Mega|Fly|Ride"] = 4483.58}},
    ["rbxassetid://12509687499"] = {name = "Banded Palm Civet", prices = {["default"] = 2.1, ["Fly"] = 76.4, ["Ride"] = 35.44, ["Fly|Ride"] = 206.76, ["Neon"] = 31.37, ["Neon|Ride"] = 54.37, ["Mega"] = 354.93, ["Mega|Fly"] = 320.04}},
    ["rbxassetid://10381386150"] = {name = "Rhino Beetle", prices = {["default"] = 2.1, ["Neon"] = 16.42, ["Mega"] = 328.26}},
    ["rbxassetid://130734656883878"] = {name = "Merry Mistletroll", prices = {["default"] = 28.47, ["Fly|Ride"] = 153.82, ["Neon"] = 151.79, ["Neon|Ride"] = 273.82, ["Mega"] = 670.86, ["Mega|Ride"] = 721.88, ["Mega|Fly|Ride"] = 958.07}},
    ["rbxassetid://15923337068"] = {name = "Oryx", prices = {["default"] = 2.1, ["Ride"] = 49.66, ["Fly|Ride"] = 273.82, ["Neon"] = 20.52, ["Neon|Ride"] = 46.5, ["Mega"] = 240.19, ["Mega|Ride"] = 253.3, ["Mega|Fly|Ride"] = 461.67}},
    ["rbxassetid://6245080365"] = {name = "Ox", prices = {["default"] = 2.1, ["Fly"] = 13.36, ["Ride"] = 13.95, ["Fly|Ride"] = 34.78, ["Neon"] = 2.1, ["Neon|Fly"] = 31.39, ["Neon|Ride"] = 26.24, ["Neon|Fly|Ride"] = 34.49, ["Mega"] = 19.69, ["Mega|Ride"] = 43.1, ["Mega|Fly|Ride"] = 76.13}},
    ["rbxassetid://13810870050"] = {name = "African Wild Dog", prices = {["default"] = 5643.75, ["Ride"] = 4450.69, ["Fly|Ride"] = 4490.07, ["Neon"] = 30764.89, ["Neon|Fly|Ride"] = 19293.74, ["Mega|Fly|Ride"] = 128219}},
    ["rbxassetid://12596400214"] = {name = "Goldfish", prices = {["default"] = 20.16, ["Ride"] = 55.04, ["Neon"] = 52.41, ["Neon|Ride"] = 106.32, ["Mega"] = 205.16, ["Mega|Ride"] = 278.88, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://4736656915"] = {name = "Australian Kelpie", prices = {["default"] = 2.1, ["Fly"] = 24.69, ["Ride"] = 17.95, ["Fly|Ride"] = 41.75, ["Neon"] = 16.52, ["Neon|Fly"] = 45.9, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 68.74, ["Mega"] = 140.44, ["Mega|Ride"] = 155.93, ["Mega|Fly|Ride"] = 239.75}},
    ["rbxassetid://3743711305"] = {name = "Crocodile", prices = {["default"] = 495.47, ["Fly"] = 547.77, ["Ride"] = 506.99, ["Fly|Ride"] = 579.49, ["Neon"] = 1640.81, ["Neon|Ride"] = 1640.52, ["Neon|Fly|Ride"] = 1510.39, ["Mega|Fly|Ride"] = 5273.63}},
    ["rbxassetid://74373220330198"] = {name = "Officer Gibbon", prices = {["default"] = 6.29, ["Ride"] = 32.62, ["Neon"] = 18.69, ["Neon|Ride"] = 145.69, ["Mega"] = 140.51, ["Mega|Fly|Ride"] = 695.63}},
    ["rbxassetid://18508184138"] = {name = "Peregrine Falcon", prices = {["default"] = 9.19, ["Fly"] = 65.63, ["Ride"] = 7132.06, ["Neon"] = 28.64, ["Neon|Ride"] = 273.82, ["Neon|Fly|Ride"] = 273.9, ["Mega"] = 875.61, ["Mega|Ride"] = 401.63, ["Mega|Fly|Ride"] = 469.23}},
    ["rbxassetid://92389214029179"] = {name = "Kaijunior", prices = {["default"] = 2.1, ["Fly"] = 52.45, ["Ride"] = 17.07, ["Neon"] = 3.68, ["Neon|Fly"] = 124.69, ["Neon|Ride"] = 22.3, ["Neon|Fly|Ride"] = 91.75, ["Mega"] = 49.7, ["Mega|Ride"] = 76.12, ["Mega|Fly|Ride"] = 257.24}},
    ["rbxassetid://3409443986"] = {name = "Flamingo", prices = {["default"] = 918.75, ["Ride"] = 772.35, ["Fly|Ride"] = 845.03, ["Neon"] = 2362.5, ["Neon|Ride"] = 2480.07, ["Neon|Fly|Ride"] = 2362.4}},
    ["rbxassetid://126933432685319"] = {name = "Cattuccino", prices = {["default"] = 7.69, ["Fly"] = 288.27, ["Ride"] = 78.75, ["Neon"] = 31.84, ["Neon|Ride"] = 62.77, ["Neon|Fly|Ride"] = 217.48, ["Mega"] = 157.5, ["Mega|Ride"] = 216.03, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://11631390464"] = {name = "Ermine", prices = {["default"] = 15.75, ["Fly"] = 236.15, ["Ride"] = 47.02, ["Fly|Ride"] = 137.44, ["Neon"] = 25.07, ["Neon|Ride"] = 55.13, ["Neon|Fly|Ride"] = 188.75, ["Mega"] = 205.08, ["Mega|Ride"] = 220.5, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://4708551221"] = {name = "Emu", prices = {["default"] = 2.1, ["Fly"] = 34.11, ["Ride"] = 14.59, ["Neon"] = 14.34, ["Neon|Fly"] = 199.5, ["Neon|Ride"] = 31.06, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 272.87, ["Mega|Ride"] = 195.57, ["Mega|Fly|Ride"] = 208.85}},
    ["rbxassetid://16088266364"] = {name = "Burning Bunny", prices = {["default"] = 11.82, ["Ride"] = 69.83, ["Fly|Ride"] = 155.76, ["Neon"] = 117.59, ["Neon|Fly|Ride"] = 307.74, ["Mega"] = 547.77, ["Mega|Ride"] = 766.25, ["Mega|Fly|Ride"] = 738.55}},
    ["rbxassetid://80832101513100"] = {name = "2026 Birthday Butterfly", prices = {["default"] = 2.1, ["Fly|Ride"] = 410.21, ["Neon"] = 3.63, ["Neon|Fly"] = 27.71, ["Neon|Ride"] = 42.84, ["Neon|Fly|Ride"] = 186.38, ["Mega"] = 58.97, ["Mega|Ride"] = 104.89, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://14639007389"] = {name = "Caterpillar", prices = {["default"] = 478.8, ["Ride"] = 564.38, ["Fly|Ride"] = 787.5, ["Neon|Fly|Ride"] = 2492.69, ["Mega|Fly|Ride"] = 7861.88}},
    ["rbxassetid://82920146813845"] = {name = "Little Lamb", prices = {["default"] = 2.1, ["Ride"] = 72.18, ["Fly|Ride"] = 131.25, ["Neon"] = 14.44, ["Neon|Ride"] = 84.51, ["Neon|Fly|Ride"] = 525, ["Mega"] = 78.66, ["Mega|Ride"] = 205.16, ["Mega|Fly|Ride"] = 400.32}},
    ["rbxassetid://96424154406922"] = {name = "Crimson Cape", prices = {["default"] = 2.1, ["Ride"] = 52.39, ["Neon"] = 3.93, ["Neon|Fly"] = 232.8, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 64.97, ["Mega|Ride"] = 137.82, ["Mega|Fly|Ride"] = 273.9}},
    ["rbxassetid://109008428989602"] = {name = "Pangolin", prices = {["default"] = 2.1, ["Ride"] = 45.57, ["Neon"] = 7.88, ["Neon|Ride"] = 42.59, ["Neon|Fly|Ride"] = 137.47, ["Mega"] = 55.41, ["Mega|Fly"] = 151.82, ["Mega|Ride"] = 69.23, ["Mega|Fly|Ride"] = 145.69}},
    ["rbxassetid://16722909218"] = {name = "Floral Eggy", prices = {["default"] = 4.13, ["Ride"] = 27.48, ["Neon"] = 26.69, ["Mega"] = 205.16}},
    ["rbxassetid://76735046136809"] = {name = "Frostbite Cub", prices = {["default"] = 1025.38, ["Fly"] = 98.44, ["Ride"] = 113.45, ["Fly|Ride"] = 295.24, ["Neon"] = 121.95, ["Neon|Ride"] = 134.33, ["Neon|Fly|Ride"] = 272.87, ["Mega"] = 958.07, ["Mega|Ride"] = 681.19, ["Mega|Fly|Ride"] = 728.44}},
    ["rbxassetid://15684947715"] = {name = "Quokka", prices = {["default"] = 15.75, ["Ride"] = 58.01, ["Fly|Ride"] = 128.99, ["Neon"] = 93.09, ["Neon|Fly"] = 55.4, ["Neon|Ride"] = 141.75, ["Neon|Fly|Ride"] = 257.15, ["Mega"] = 464.68, ["Mega|Fly"] = 547.77, ["Mega|Ride"] = 451.8, ["Mega|Fly|Ride"] = 560.79}},
    ["rbxassetid://5721843001"] = {name = "Deinonychus", prices = {["default"] = 2.1, ["Fly"] = 19.46, ["Ride"] = 15.75, ["Fly|Ride"] = 31.49, ["Neon"] = 28.88, ["Neon|Ride"] = 34.77, ["Neon|Fly|Ride"] = 76.95, ["Mega"] = 299.92, ["Mega|Ride"] = 426.72, ["Mega|Fly|Ride"] = 263.86}},
    ["rbxassetid://16999461770"] = {name = "Inmate Capuchin Monkey", prices = {["default"] = 9, ["Ride"] = 64.32, ["Fly|Ride"] = 118.97, ["Neon"] = 117.95, ["Neon|Ride"] = 135.38, ["Mega|Ride"] = 287.22}},
    ["rbxassetid://119664699815373"] = {name = "Frozen Penguin", prices = {["default"] = 2.1, ["Fly"] = 131.25, ["Ride"] = 26.17, ["Fly|Ride"] = 111.56, ["Neon"] = 15.4, ["Neon|Ride"] = 61.55, ["Mega"] = 105, ["Mega|Ride"] = 155.76, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://5067924307"] = {name = "Business Monkey", prices = {["default"] = 21, ["Ride"] = 30.17, ["Fly|Ride"] = 131.25, ["Neon"] = 273.82, ["Neon|Ride"] = 512.76, ["Neon|Fly|Ride"] = 184.65, ["Mega"] = 922.17}},
    ["rbxassetid://126192643157832"] = {name = "Manta Ray", prices = {["Fly"] = 874.13, ["Neon"] = 144.38, ["Mega"] = 232.86, ["Mega|Fly|Ride"] = 958.07}},
    ["rbxassetid://4440866911"] = {name = "Silly Duck", prices = {["default"] = 54.58, ["Fly"] = 115.38, ["Ride"] = 76.26, ["Fly|Ride"] = 185.57, ["Neon"] = 294.96, ["Neon|Fly"] = 389.7, ["Neon|Ride"] = 313.69, ["Neon|Fly|Ride"] = 367.5, ["Mega|Ride"] = 1669.76, ["Mega|Fly|Ride"] = 1043.44}},
    ["rbxassetid://110544962124445"] = {name = "Cake Friend", prices = {["default"] = 115.5, ["Fly"] = 92.31, ["Ride"] = 75.8, ["Neon"] = 139.55, ["Neon|Ride"] = 155.74, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 589.83, ["Mega|Ride"] = 640.08, ["Mega|Fly|Ride"] = 620.82}},
    ["rbxassetid://16127157068"] = {name = "Rice Cake Rabbit", prices = {["default"] = 25.99, ["Ride"] = 56.44, ["Fly|Ride"] = 137.44, ["Neon"] = 144.38, ["Neon|Ride"] = 274.26, ["Mega"] = 590.63, ["Mega|Ride"] = 752.92, ["Mega|Fly|Ride"] = 1230.92}},
    ["rbxassetid://7734900613"] = {name = "Halloween Evil Dachshund", prices = {["default"] = 19.69, ["Fly"] = 428.28, ["Ride"] = 53.82, ["Fly|Ride"] = 192.94, ["Neon"] = 68.73, ["Neon|Fly"] = 420, ["Neon|Ride"] = 89.78, ["Neon|Fly|Ride"] = 252.13, ["Mega"] = 464.37, ["Mega|Ride"] = 507.27, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://9664282145"] = {name = "Robot", prices = {["default"] = 2.1, ["Fly"] = 17.74, ["Ride"] = 11.82, ["Fly|Ride"] = 26.5, ["Neon"] = 5.25, ["Neon|Fly"] = 25.94, ["Neon|Ride"] = 27.35, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 44.63, ["Mega|Fly"] = 155.76, ["Mega|Ride"] = 79.12, ["Mega|Fly|Ride"] = 103.69}},
    ["rbxassetid://3261465791"] = {name = "Pink Egg", prices = {["default"] = 1253.91}},
    ["rbxassetid://126725051633301"] = {name = "Headless Horse", prices = {["default"] = 47.38, ["Fly"] = 232.47, ["Ride"] = 126.93, ["Fly|Ride"] = 288.75, ["Neon"] = 294, ["Neon|Ride"] = 288.75, ["Neon|Fly|Ride"] = 538.13, ["Mega"] = 752.92, ["Mega|Ride"] = 1074.99, ["Mega|Fly|Ride"] = 987.96}},
    ["rbxassetid://88554799028713"] = {name = "Sneak Weasel", prices = {["default"] = 2.1, ["Neon"] = 3.71, ["Neon|Fly"] = 96.42, ["Neon|Ride"] = 43.18, ["Neon|Fly|Ride"] = 287.62, ["Mega"] = 27.71, ["Mega|Ride"] = 84.92, ["Mega|Fly|Ride"] = 164.13}},
    ["rbxassetid://14639008203"] = {name = "English Sheepdog", prices = {["default"] = 59.07, ["Ride"] = 75.9, ["Fly|Ride"] = 166.15, ["Neon"] = 124.69, ["Neon|Ride"] = 143.07, ["Neon|Fly|Ride"] = 544.69, ["Mega"] = 606.66, ["Mega|Ride"] = 588.91, ["Mega|Fly|Ride"] = 1229.9}},
    ["rbxassetid://133131190079833"] = {name = "Oakee", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Mega"] = 26.24}},
    ["rbxassetid://79856043024325"] = {name = "Chestnut Glyptodon", prices = {["default"] = 2.1, ["Neon"] = 5.25, ["Mega"] = 30.79, ["Mega|Ride"] = 90.68, ["Mega|Fly|Ride"] = 273}},
    ["rbxassetid://12720028898"] = {name = "Hare", prices = {["default"] = 104.89, ["Ride"] = 154.88, ["Fly|Ride"] = 246.14, ["Neon"] = 512.76, ["Neon|Ride"] = 587.99, ["Neon|Fly|Ride"] = 725.22, ["Mega|Ride"] = 2530.55, ["Mega|Fly|Ride"] = 1824.38}},
    ["rbxassetid://16897788024"] = {name = "Capuchin Monkey", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Ride"] = 34.89, ["Fly|Ride"] = 92.99, ["Neon"] = 6.57, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 99.74, ["Mega"] = 90.57, ["Mega|Ride"] = 109.81, ["Mega|Fly|Ride"] = 205.16}},
    ["rbxassetid://121639546210522"] = {name = "Amber Butterfly", prices = {["default"] = 2.1, ["Fly"] = 34.99, ["Fly|Ride"] = 86.63, ["Neon"] = 3.93, ["Neon|Ride"] = 40.63, ["Neon|Fly|Ride"] = 122.08, ["Mega"] = 32.81, ["Mega|Ride"] = 123.27, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://79005166120532"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Ride"] = 82.06, ["Neon"] = 3.59, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 131.25, ["Mega"] = 45.94, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 235.94}},
    ["rbxassetid://138741319376538"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 28.13, ["Neon"] = 5.09, ["Neon|Ride"] = 155.6, ["Mega"] = 65.54, ["Mega|Ride"] = 204.14}},
    ["rbxassetid://133558151150234"] = {name = "Black Widow", prices = {["default"] = 65.63, ["Ride"] = 133.84, ["Fly|Ride"] = 449.61, ["Neon"] = 419.83, ["Neon|Ride"] = 511.73, ["Neon|Fly|Ride"] = 695.63, ["Mega"] = 1504.79, ["Mega|Ride"] = 1538.64, ["Mega|Fly|Ride"] = 1495.56}},
    ["rbxassetid://122945704087152"] = {name = "Chilling Spider", prices = {["default"] = 3.5, ["Ride"] = 62.77, ["Neon"] = 38.95, ["Neon|Ride"] = 157.55, ["Mega"] = 383.5, ["Mega|Ride"] = 853.79}},
    ["rbxassetid://1373237029"] = {name = "Big Head Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://2657668946"] = {name = "Cure All Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://1373237971"] = {name = "Grow Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4315743582"] = {name = "Honey Badger", prices = {["default"] = 426.57, ["Ride"] = 409.6, ["Fly|Ride"] = 748.55, ["Neon"] = 1025.52, ["Neon|Ride"] = 1085.48, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 3966.6}},
    ["rbxassetid://1373208271"] = {name = "Hyperspeed Potion", prices = {["default"] = 2.05}},
    ["rbxassetid://4047157976"] = {name = "Fly Potion", prices = {["default"] = 93.19}},
    ["rbxassetid://3342628435"] = {name = "Ride Potion", prices = {["default"] = 45.94}},
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