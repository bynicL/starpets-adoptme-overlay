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
    ["rbxassetid://137637490639925"] = {name = "Royal Mistletroll", prices = {["default"] = 822.94, ["Ride"] = 1027.16, ["Fly|Ride"] = 1181.25, ["Neon|Fly|Ride"] = 3937.5, ["Mega|Fly|Ride"] = 20079.55}},
    ["rbxassetid://140355753768438"] = {name = "Moonbeam Peacock", prices = {["default"] = 459.38, ["Ride"] = 510.2, ["Fly|Ride"] = 549.82, ["Neon|Ride"] = 2100, ["Neon|Fly|Ride"] = 2388.96, ["Mega"] = 10297.21, ["Mega|Fly|Ride"] = 9588.68}},
    ["rbxassetid://18117855573"] = {name = "Balloon Unicorn", prices = {["Ride"] = 4571.04, ["Fly|Ride"] = 4959.68, ["Neon"] = 23194.61, ["Neon|Fly|Ride"] = 20105.25, ["Mega|Fly|Ride"] = 68648.34}},
    ["rbxassetid://75782719698946"] = {name = "Red Dutch Guinea Pig", prices = {["default"] = 171.05, ["Ride"] = 182.43, ["Fly|Ride"] = 410.83, ["Neon"] = 773.56, ["Neon|Ride"] = 821.63, ["Neon|Fly|Ride"] = 1233.47, ["Mega"] = 4118.89, ["Mega|Fly|Ride"] = 3556.67}},
    ["rbxassetid://5067924142"] = {name = "Albino Monkey", prices = {["default"] = 590.63, ["Fly"] = 823.7, ["Ride"] = 619.49, ["Fly|Ride"] = 630.1, ["Neon|Ride"] = 1976.83, ["Neon|Fly|Ride"] = 1519.87, ["Mega|Fly|Ride"] = 6562.4}},
    ["rbxassetid://108312620331321"] = {name = "Villain Gibbon", prices = {["default"] = 8.52, ["Ride"] = 27.68, ["Fly|Ride"] = 152.39, ["Neon"] = 56.44, ["Neon|Fly"] = 274.93, ["Neon|Ride"] = 109.04, ["Neon|Fly|Ride"] = 274.93, ["Mega"] = 301.63, ["Mega|Ride"] = 262.49, ["Mega|Fly|Ride"] = 575.63}},
    ["rbxassetid://17255958862"] = {name = "Alicorn", prices = {["default"] = 5.25, ["Fly"] = 41.56, ["Ride"] = 27.82, ["Fly|Ride"] = 72.19, ["Neon"] = 29.52, ["Neon|Fly"] = 46.41, ["Neon|Ride"] = 51.03, ["Neon|Fly|Ride"] = 92.8, ["Mega"] = 162.75, ["Mega|Fly"] = 223.13, ["Mega|Ride"] = 199.5, ["Mega|Fly|Ride"] = 276.24}},
    ["rbxassetid://90170598608675"] = {name = "Moonbeam Butterfly", prices = {["default"] = 116.94, ["Ride"] = 149.22, ["Fly|Ride"] = 233.73, ["Neon"] = 521.07, ["Neon|Ride"] = 616.74, ["Neon|Fly|Ride"] = 679.88, ["Mega|Ride"] = 2059.45, ["Mega|Fly|Ride"] = 2671.11}},
    ["rbxassetid://7126722445"] = {name = "Goldhorn", prices = {["default"] = 45.94, ["Fly"] = 81.2, ["Ride"] = 54.51, ["Fly|Ride"] = 106.07, ["Neon"] = 252, ["Neon|Ride"] = 205.94, ["Neon|Fly|Ride"] = 233.63, ["Mega"] = 2100, ["Mega|Ride"] = 1391.86, ["Mega|Fly|Ride"] = 1048.69}},
    ["rbxassetid://13186021971"] = {name = "Cuddly Candle", prices = {["default"] = 25.52, ["Fly"] = 56.7, ["Ride"] = 36.16, ["Fly|Ride"] = 61.85, ["Neon|Ride"] = 243.43, ["Neon|Fly|Ride"] = 288.75, ["Mega|Ride"] = 1337.62, ["Mega|Fly|Ride"] = 1019.82}},
    ["rbxassetid://14146196672"] = {name = "Gargoyle", prices = {["default"] = 65.54, ["Fly"] = 206.07, ["Ride"] = 77.23, ["Fly|Ride"] = 169.34, ["Neon"] = 411.86, ["Neon|Fly"] = 409.8, ["Neon|Ride"] = 288.3, ["Neon|Fly|Ride"] = 306.21, ["Mega|Fly|Ride"] = 2059.45}},
    ["rbxassetid://129762233626342"] = {name = "Royal Moon Egg", prices = {["default"] = 68.16}},
    ["rbxassetid://89693546199400"] = {name = "Cupid Dragon", prices = {["default"] = 313.49, ["Fly"] = 399, ["Ride"] = 353.99, ["Fly|Ride"] = 392.44, ["Neon"] = 1423, ["Neon|Ride"] = 1023.75, ["Neon|Fly|Ride"] = 1122.19, ["Mega|Fly|Ride"] = 4845.88}},
    ["rbxassetid://8665606875"] = {name = "Dancing Dragon", prices = {["default"] = 137.82, ["Fly"] = 170.23, ["Ride"] = 139.18, ["Fly|Ride"] = 183.74, ["Neon|Fly"] = 672.66, ["Neon|Fly|Ride"] = 549.82, ["Mega|Fly|Ride"] = 2977.41}},
    ["rbxassetid://110411427278536"] = {name = "Huntsman Robin", prices = {["default"] = 2.63, ["Ride"] = 53.44, ["Fly|Ride"] = 131.24, ["Neon"] = 22.15, ["Neon|Fly"] = 96.41, ["Neon|Fly|Ride"] = 189, ["Mega"] = 124.69, ["Mega|Fly"] = 393.75, ["Mega|Ride"] = 204.93, ["Mega|Fly|Ride"] = 383.94}},
    ["rbxassetid://10925517718"] = {name = "Lava Dragon", prices = {["default"] = 92.78, ["Fly"] = 210.53, ["Ride"] = 170.63, ["Fly|Ride"] = 243.54, ["Neon|Ride"] = 714.55, ["Neon|Fly|Ride"] = 712.14, ["Mega|Fly|Ride"] = 2229.94}},
    ["rbxassetid://4797806482"] = {name = "Diamond Griffin", prices = {["default"] = 3.29, ["Fly"] = 23.21, ["Ride"] = 17.41, ["Fly|Ride"] = 40.6, ["Neon"] = 26.78, ["Neon|Ride"] = 67.97, ["Neon|Fly|Ride"] = 131.25, ["Mega|Ride"] = 326.82, ["Mega|Fly|Ride"] = 295.32}},
    ["rbxassetid://122648024705835"] = {name = "Scarebear", prices = {["default"] = 105, ["Fly"] = 262.5, ["Ride"] = 157.1, ["Fly|Ride"] = 220.36, ["Neon"] = 247.11, ["Neon|Fly"] = 301.88, ["Neon|Ride"] = 373.85, ["Neon|Fly|Ride"] = 315, ["Mega"] = 1647.57, ["Mega|Ride"] = 1334.69, ["Mega|Fly|Ride"] = 1168.14}},
    ["rbxassetid://13104102169"] = {name = "Danger Egg", prices = {["default"] = 42}},
    ["rbxassetid://133163961974577"] = {name = "2D Doggy", prices = {["default"] = 62.63, ["Ride"] = 154.45, ["Fly|Ride"] = 294.67, ["Neon"] = 577.5, ["Neon|Fly|Ride"] = 787.5, ["Mega"] = 1373.66, ["Mega|Fly|Ride"] = 2057.4}},
    ["rbxassetid://126071806166898"] = {name = "Evil Chick", prices = {["default"] = 17.07, ["Fly"] = 393.75, ["Ride"] = 32.48, ["Fly|Ride"] = 110.18, ["Neon"] = 224.47, ["Neon|Ride"] = 209.99, ["Neon|Fly|Ride"] = 271.83, ["Mega|Ride"] = 579.74, ["Mega|Fly|Ride"] = 549.88}},
    ["rbxassetid://5721843247"] = {name = "Dodo", prices = {["default"] = 51.19, ["Fly"] = 55.61, ["Ride"] = 57.17, ["Fly|Ride"] = 112.05, ["Neon"] = 243.78, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 315, ["Mega"] = 1623.83, ["Mega|Fly|Ride"] = 826.88}},
    ["rbxassetid://119640582603552"] = {name = "Violet Butterfly", prices = {["default"] = 56.27, ["Fly"] = 72.18, ["Ride"] = 189, ["Fly|Ride"] = 136.5, ["Neon"] = 208.69, ["Neon|Fly"] = 385.05, ["Neon|Ride"] = 188.06, ["Neon|Fly|Ride"] = 370.71, ["Mega"] = 1161.54, ["Mega|Ride"] = 1235.68, ["Mega|Fly|Ride"] = 1250.1}},
    ["rbxassetid://16088264958"] = {name = "Volcanic Rhino", prices = {["default"] = 28.88, ["Ride"] = 41.1, ["Fly|Ride"] = 137.17, ["Neon"] = 343.89, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 292.28, ["Mega"] = 821.73, ["Mega|Ride"] = 2100, ["Mega|Fly|Ride"] = 1023.75}},
    ["rbxassetid://75251818654427"] = {name = "Apple Owl", prices = {["default"] = 39.15, ["Fly"] = 115.99, ["Ride"] = 123.56, ["Fly|Ride"] = 123.56, ["Neon"] = 227.55, ["Neon|Fly"] = 550.85, ["Neon|Ride"] = 181.91, ["Neon|Fly|Ride"] = 309.7, ["Mega|Ride"] = 1124.82, ["Mega|Fly|Ride"] = 903.42}},
    ["rbxassetid://3181727433"] = {name = "Dragon", prices = {["default"] = 11.82, ["Fly"] = 27.82, ["Ride"] = 23.63, ["Fly|Ride"] = 57.75, ["Neon"] = 34.93, ["Neon|Fly"] = 101.04, ["Neon|Ride"] = 41.15, ["Neon|Fly|Ride"] = 101.38, ["Mega"] = 154.87, ["Mega|Fly"] = 27493.53, ["Mega|Ride"] = 204.75, ["Mega|Fly|Ride"] = 267.75}},
    ["rbxassetid://121496682360324"] = {name = "Sugar Axolotl", prices = {["default"] = 357.69, ["Ride"] = 433.13, ["Fly|Ride"] = 480.11, ["Neon"] = 1853.28, ["Neon|Ride"] = 1689.18, ["Neon|Fly|Ride"] = 1964.82, ["Mega|Fly|Ride"] = 7191.22}},
    ["rbxassetid://11694854226"] = {name = "Shetland Pony Light Brown", prices = {["default"] = 15.75, ["Ride"] = 32.45, ["Neon"] = 219.18, ["Mega"] = 513.85, ["Mega|Fly|Ride"] = 671.66}},
    ["rbxassetid://4797806957"] = {name = "Golden Unicorn", prices = {["default"] = 5.84, ["Fly"] = 31.29, ["Ride"] = 20.61, ["Fly|Ride"] = 49.07, ["Neon"] = 102.98, ["Neon|Ride"] = 69.59, ["Neon|Fly|Ride"] = 119.44, ["Mega"] = 308.94, ["Mega|Ride"] = 273.92, ["Mega|Fly|Ride"] = 450.87}},
    ["rbxassetid://110822620060051"] = {name = "Frost Phoenix", prices = {["default"] = 78.75, ["Fly"] = 91.88, ["Ride"] = 102.98, ["Fly|Ride"] = 131.22, ["Neon"] = 364.17, ["Neon|Fly"] = 376.72, ["Neon|Ride"] = 385.75, ["Neon|Fly|Ride"] = 404.25, ["Mega"] = 3295.13, ["Mega|Ride"] = 7290.94, ["Mega|Fly|Ride"] = 1592.99}},
    ["rbxassetid://13894724323"] = {name = "Billy Goat", prices = {["default"] = 13.81, ["Ride"] = 26.78, ["Fly|Ride"] = 118.13, ["Neon"] = 155.42, ["Neon|Ride"] = 137.82, ["Neon|Fly|Ride"] = 162.42, ["Mega"] = 479.16, ["Mega|Ride"] = 785.7}},
    ["rbxassetid://123037843357105"] = {name = "Glormy Leo", prices = {["default"] = 203.44, ["Fly"] = 348.03, ["Ride"] = 271.37, ["Fly|Ride"] = 301.88, ["Neon"] = 769.13, ["Neon|Ride"] = 734.99, ["Neon|Fly|Ride"] = 752.45, ["Mega"] = 6178.33, ["Mega|Ride"] = 2887.5, ["Mega|Fly|Ride"] = 2932.65}},
    ["rbxassetid://12479078933"] = {name = "Southeast Asia Egg", prices = {["default"] = 36.75}},
    ["rbxassetid://122739780018633"] = {name = "Quetzalcoatl", prices = {["default"] = 3.91, ["Fly"] = 29.81, ["Ride"] = 22.66, ["Fly|Ride"] = 53.02, ["Neon"] = 24.94, ["Neon|Fly"] = 5147.97, ["Neon|Ride"] = 53.37, ["Neon|Fly|Ride"] = 164.75, ["Mega"] = 159.62, ["Mega|Fly"] = 508.46, ["Mega|Ride"] = 393.21, ["Mega|Fly|Ride"] = 308.94}},
    ["rbxassetid://70953296065239"] = {name = "Frostbite Bear", prices = {["default"] = 945.06, ["Fly"] = 2625, ["Ride"] = 990.94, ["Fly|Ride"] = 1083.12, ["Neon"] = 7158.38, ["Neon|Ride"] = 6040.62, ["Neon|Fly|Ride"] = 4003.13, ["Mega|Ride"] = 52194.29, ["Mega|Fly|Ride"] = 15093.75}},
    ["rbxassetid://14978701948"] = {name = "Scarecrow Crow", prices = {["default"] = 7.77, ["Fly"] = 68.99, ["Ride"] = 27.57, ["Fly|Ride"] = 92.78, ["Neon"] = 92.79, ["Neon|Ride"] = 118.09, ["Neon|Fly|Ride"] = 227.55, ["Mega"] = 543.72, ["Mega|Ride"] = 698.16, ["Mega|Fly|Ride"] = 820.31}},
    ["rbxassetid://11191341630"] = {name = "Jousting Horse", prices = {["default"] = 157.5, ["Ride"] = 229.69, ["Fly|Ride"] = 210, ["Neon"] = 872.08, ["Neon|Ride"] = 871.76, ["Neon|Fly|Ride"] = 801.94, ["Mega|Ride"] = 2783.71, ["Mega|Fly|Ride"] = 3021.21}},
    ["rbxassetid://76801905892592"] = {name = "Royal Aztec Egg", prices = {["default"] = 47.25}},
    ["rbxassetid://98801943598121"] = {name = "Priceless Shrimp", prices = {["default"] = 20.89, ["Ride"] = 52.31, ["Fly|Ride"] = 137.97, ["Neon"] = 82.39, ["Neon|Ride"] = 206.07, ["Neon|Fly|Ride"] = 196.66, ["Mega"] = 677.69, ["Mega|Ride"] = 1101.19, ["Mega|Fly|Ride"] = 727.26}},
    ["rbxassetid://95214789806437"] = {name = "Aztec Egg", prices = {["default"] = 2.63}},
    ["rbxassetid://18515755354"] = {name = "Cheetah", prices = {["default"] = 116.82, ["Ride"] = 205.94, ["Fly|Ride"] = 233.71, ["Neon"] = 589.16, ["Neon|Ride"] = 465.94, ["Mega|Fly|Ride"] = 2231.25}},
    ["rbxassetid://18117855114"] = {name = "Corn Doggo", prices = {["default"] = 131.25, ["Ride"] = 169.33, ["Fly|Ride"] = 282.77, ["Neon"] = 389.44, ["Neon|Fly"] = 584.53, ["Neon|Ride"] = 406.88, ["Neon|Fly|Ride"] = 590.62, ["Mega|Ride"] = 1417.5, ["Mega|Fly|Ride"] = 2676.45}},
    ["rbxassetid://8972175010"] = {name = "Woodland Egg", prices = {["default"] = 42.28}},
    ["rbxassetid://3710823011"] = {name = "Golden Penguin", prices = {["default"] = 56.49, ["Fly"] = 61.35, ["Ride"] = 58.03, ["Fly|Ride"] = 85.7, ["Neon|Ride"] = 371.16, ["Neon|Fly|Ride"] = 354.38, ["Mega"] = 4118.89, ["Mega|Fly|Ride"] = 1575}},
    ["rbxassetid://136490701345923"] = {name = "Glormy Crab", prices = {["default"] = 6.04, ["Fly"] = 55.61, ["Ride"] = 155.43, ["Fly|Ride"] = 131.25, ["Neon"] = 48.41, ["Neon|Fly"] = 223.13, ["Neon|Ride"] = 123.56, ["Neon|Fly|Ride"] = 231.67, ["Mega"] = 167.87, ["Mega|Fly"] = 267.75, ["Mega|Ride"] = 323.34, ["Mega|Fly|Ride"] = 480.89}},
    ["rbxassetid://14782580581"] = {name = "Vampire Dragon", prices = {["default"] = 473.82, ["Fly"] = 590.63, ["Ride"] = 465.63, ["Fly|Ride"] = 507.93, ["Neon|Ride"] = 1737.96, ["Neon|Fly|Ride"] = 1506.74, ["Mega|Fly|Ride"] = 6470.63}},
    ["rbxassetid://88405494856204"] = {name = "Solaris", prices = {["default"] = 90.46, ["Fly"] = 150.8, ["Ride"] = 117.35, ["Fly|Ride"] = 175.05, ["Neon"] = 446.25, ["Neon|Fly"] = 823.7, ["Neon|Ride"] = 575.28, ["Neon|Fly|Ride"] = 522.02, ["Mega|Ride"] = 2470.31, ["Mega|Fly|Ride"] = 2317.34}},
    ["rbxassetid://84468510887759"] = {name = "Orchid Butterfly", prices = {["default"] = 3710.61, ["Ride"] = 3706.55, ["Fly|Ride"] = 3675, ["Neon|Fly|Ride"] = 14413.27}},
    ["rbxassetid://11109286837"] = {name = "Lava Wolf", prices = {["default"] = 39.38, ["Fly"] = 110.35, ["Ride"] = 60.33, ["Fly|Ride"] = 128.42, ["Neon"] = 393.75, ["Neon|Ride"] = 582.64, ["Neon|Fly|Ride"] = 402.47, ["Mega|Ride"] = 1182.13, ["Mega|Fly|Ride"] = 1222.29}},
    ["rbxassetid://12403863809"] = {name = "Albino Gorilla", prices = {["default"] = 81.35, ["Ride"] = 78.74, ["Fly|Ride"] = 170.93, ["Neon"] = 410.42, ["Neon|Ride"] = 619.35, ["Neon|Fly|Ride"] = 472.5, ["Mega"] = 2746.28, ["Mega|Ride"] = 2609.32, ["Mega|Fly|Ride"] = 2783.71}},
    ["rbxassetid://6060988121"] = {name = "Snow Owl", prices = {["default"] = 44.63, ["Fly"] = 60.76, ["Ride"] = 60.76, ["Fly|Ride"] = 124.65, ["Neon"] = 170.63, ["Neon|Fly"] = 231.96, ["Neon|Ride"] = 166.69, ["Neon|Fly|Ride"] = 221.82, ["Mega"] = 2625, ["Mega|Ride"] = 728.02, ["Mega|Fly|Ride"] = 654.94}},
    ["rbxassetid://112630556645658"] = {name = "Moon Egg", prices = {["default"] = 8.26}},
    ["rbxassetid://10357473556"] = {name = "Golden Chow-Chow", prices = {["default"] = 46.4, ["Fly"] = 41.2, ["Ride"] = 61.79, ["Fly|Ride"] = 64.94, ["Neon"] = 262.5, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 406.88, ["Mega|Fly|Ride"] = 1373.66}},
    ["rbxassetid://5721843384"] = {name = "Fossil Egg", prices = {["default"] = 43.32}},
    ["rbxassetid://92775688228060"] = {name = "Papa Moose", prices = {["default"] = 199.76, ["Ride"] = 221.82, ["Fly|Ride"] = 249.38, ["Neon|Ride"] = 1373.49, ["Neon|Fly|Ride"] = 1373.49, ["Mega|Fly|Ride"] = 4949.19}},
    ["rbxassetid://12479991588"] = {name = "Frost Unicorn", prices = {["default"] = 1083.04, ["Fly|Ride"] = 1089.38, ["Neon"] = 2887.5, ["Neon|Ride"] = 4175.33, ["Neon|Fly|Ride"] = 3018.75, ["Mega|Fly|Ride"] = 13730.3}},
    ["rbxassetid://9661880325"] = {name = "Zodiac Minion Egg", prices = {["default"] = 6.55}},
    ["rbxassetid://7126719832"] = {name = "Phoenix", prices = {["default"] = 26.17, ["Fly"] = 76.44, ["Ride"] = 43.52, ["Fly|Ride"] = 63.84, ["Neon"] = 160.78, ["Neon|Ride"] = 148.32, ["Neon|Fly|Ride"] = 232.4, ["Mega|Ride"] = 787.19, ["Mega|Fly|Ride"] = 988.54}},
    ["rbxassetid://119386690822810"] = {name = "Royal Fairytale Egg", prices = {["default"] = 16.02}},
    ["rbxassetid://4440866299"] = {name = "Crow", prices = {["default"] = 5971.65, ["Ride"] = 5971.65, ["Fly|Ride"] = 4528.13, ["Neon|Fly|Ride"] = 10827.6, ["Mega|Fly|Ride"] = 40209.31}},
    ["rbxassetid://4797806531"] = {name = "Diamond Unicorn", prices = {["default"] = 11.82, ["Fly"] = 52.4, ["Ride"] = 21, ["Fly|Ride"] = 55.12, ["Neon"] = 117.39, ["Neon|Ride"] = 120.75, ["Neon|Fly|Ride"] = 219.19, ["Mega"] = 787.5, ["Mega|Ride"] = 588.08, ["Mega|Fly|Ride"] = 630}},
    ["rbxassetid://88817325500927"] = {name = "Kraken", prices = {["default"] = 12.47, ["Fly"] = 191.51, ["Ride"] = 32.96, ["Fly|Ride"] = 114.82, ["Neon"] = 68.99, ["Neon|Ride"] = 132.49, ["Neon|Fly|Ride"] = 247.11, ["Mega"] = 1032.3, ["Mega|Ride"] = 511.88, ["Mega|Fly|Ride"] = 1026.65}},
    ["rbxassetid://9490243442"] = {name = "Diamond King Penguin", prices = {["default"] = 96.79, ["Fly"] = 276.59, ["Ride"] = 91.86, ["Fly|Ride"] = 111.57, ["Neon|Ride"] = 381.99, ["Neon|Fly|Ride"] = 476.14, ["Mega"] = 4118.89}},
    ["rbxassetid://107787284008278"] = {name = "Primal Kaijunior", prices = {["default"] = 11.82, ["Fly"] = 150.93, ["Ride"] = 35.35, ["Fly|Ride"] = 78.75, ["Neon"] = 75.64, ["Neon|Ride"] = 66.94, ["Neon|Fly|Ride"] = 501.38, ["Mega|Ride"] = 549.88, ["Mega|Fly|Ride"] = 813.75}},
    ["rbxassetid://4506837037"] = {name = "Arctic Reindeer", prices = {["default"] = 1968.75, ["Fly"] = 2279.52, ["Ride"] = 2034.37, ["Fly|Ride"] = 1785, ["Neon|Fly|Ride"] = 3465, ["Mega|Fly|Ride"] = 13125}},
    ["rbxassetid://4184878149"] = {name = "Bat Dragon", prices = {["default"] = 29400, ["Ride"] = 52500, ["Fly|Ride"] = 26117.44, ["Neon|Ride"] = 65625, ["Neon|Fly|Ride"] = 70012.26, ["Mega"] = 210000, ["Mega|Fly|Ride"] = 183750}},
    ["rbxassetid://118641789458122"] = {name = "Gilded Snake", prices = {["default"] = 20.61, ["Fly"] = 393.74, ["Ride"] = 52.53, ["Fly|Ride"] = 124.69, ["Neon"] = 261.53, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 261.19, ["Mega"] = 962.8, ["Mega|Ride"] = 755.84, ["Mega|Fly|Ride"] = 819.68}},
    ["rbxassetid://71844856693163"] = {name = "Purrowl", prices = {["default"] = 3.93, ["Fly"] = 82.39, ["Ride"] = 41.2, ["Fly|Ride"] = 152.39, ["Neon"] = 19.69, ["Neon|Fly"] = 96.57, ["Neon|Ride"] = 62.28, ["Neon|Fly|Ride"] = 135.35, ["Mega"] = 126, ["Mega|Ride"] = 337.84, ["Mega|Fly|Ride"] = 311.07}},
    ["rbxassetid://7195311687"] = {name = "Mythic Egg", prices = {["default"] = 24.73}},
    ["rbxassetid://102330087609546"] = {name = "Fire Mare", prices = {["default"] = 7.88, ["Ride"] = 32, ["Fly|Ride"] = 125.25, ["Neon"] = 62.65, ["Neon|Ride"] = 129.88, ["Neon|Fly|Ride"] = 152.39, ["Mega"] = 270.24, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 545.57}},
    ["rbxassetid://16659215347"] = {name = "Candyfloss Chick", prices = {["default"] = 784.88, ["Ride"] = 721.88, ["Fly|Ride"] = 770.02, ["Neon|Fly|Ride"] = 2820.67, ["Mega|Fly|Ride"] = 8469.57}},
    ["rbxassetid://9281950769"] = {name = "Sugar Glider", prices = {["default"] = 925.34, ["Fly"] = 1076.25, ["Ride"] = 1029.61, ["Fly|Ride"] = 918.75, ["Neon|Ride"] = 3157.77, ["Neon|Fly|Ride"] = 3109.31, ["Mega|Fly|Ride"] = 10980.53}},
    ["rbxassetid://15485137935"] = {name = "Fleur De Ice", prices = {["default"] = 40.69, ["Fly"] = 115.99, ["Ride"] = 36.75, ["Fly|Ride"] = 90.46, ["Neon"] = 140.44, ["Neon|Ride"] = 137.97, ["Neon|Fly|Ride"] = 274.93, ["Mega"] = 1204.13, ["Mega|Ride"] = 685.13, ["Mega|Fly|Ride"] = 600.34}},
    ["rbxassetid://6498256269"] = {name = "Ocean Egg", prices = {["default"] = 27.38}},
    ["rbxassetid://8704877940"] = {name = "Lavender Dragon", prices = {["default"] = 63, ["Fly"] = 92.79, ["Ride"] = 62.65, ["Fly|Ride"] = 123.56, ["Neon"] = 462.3, ["Neon|Ride"] = 403.59, ["Neon|Fly|Ride"] = 455.34, ["Mega|Fly|Ride"] = 1664.25}},
    ["rbxassetid://13685038182"] = {name = "Leviathan", prices = {["default"] = 63.08, ["Fly"] = 137.97, ["Ride"] = 78.75, ["Fly|Ride"] = 228.38, ["Neon"] = 427.68, ["Neon|Ride"] = 278.74, ["Neon|Fly|Ride"] = 538.5, ["Mega"] = 2075.13, ["Mega|Fly|Ride"] = 1732.5}},
    ["rbxassetid://4797806358"] = {name = "Diamond Dragon", prices = {["default"] = 4.66, ["Fly"] = 27.82, ["Ride"] = 20.22, ["Fly|Ride"] = 55.42, ["Neon"] = 55.61, ["Neon|Fly"] = 524.98, ["Neon|Ride"] = 68.44, ["Neon|Fly|Ride"] = 220.38, ["Mega"] = 288.75, ["Mega|Ride"] = 295.32, ["Mega|Fly|Ride"] = 362.25}},
    ["rbxassetid://5862774327"] = {name = "Cerberus", prices = {["default"] = 133.7, ["Fly"] = 143.07, ["Ride"] = 144.38, ["Fly|Ride"] = 192.92, ["Neon|Ride"] = 454.78, ["Neon|Fly|Ride"] = 454.78, ["Mega|Fly|Ride"] = 1235.68}},
    ["rbxassetid://74012786571707"] = {name = "Three Blind Mice", prices = {["default"] = 8.26, ["Ride"] = 168, ["Fly|Ride"] = 231.95, ["Neon"] = 51.1, ["Neon|Ride"] = 127.32, ["Neon|Fly|Ride"] = 479.81, ["Mega"] = 236.25, ["Mega|Ride"] = 663.46, ["Mega|Fly|Ride"] = 611.67}},
    ["rbxassetid://15931348363"] = {name = "Criosphinx", prices = {["default"] = 17.41, ["Fly"] = 41.22, ["Ride"] = 32.71, ["Fly|Ride"] = 88.14, ["Neon"] = 68.99, ["Neon|Ride"] = 110.32, ["Neon|Fly|Ride"] = 164.77, ["Mega|Fly|Ride"] = 782.6}},
    ["rbxassetid://118278167134251"] = {name = "Influencer Gibbon", prices = {["default"] = 31.5, ["Ride"] = 55.61, ["Fly|Ride"] = 156.19, ["Neon"] = 262.56, ["Neon|Ride"] = 329.48, ["Neon|Fly|Ride"] = 343.89, ["Mega"] = 1237.6, ["Mega|Ride"] = 773.66, ["Mega|Fly|Ride"] = 961.77}},
    ["rbxassetid://17059982206"] = {name = "Dimorphodon", prices = {["default"] = 17.06, ["Fly"] = 189.06, ["Ride"] = 35.44, ["Fly|Ride"] = 69.56, ["Neon"] = 71.07, ["Neon|Ride"] = 109.04, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 889.69, ["Mega|Fly|Ride"] = 947.63}},
    ["rbxassetid://119212313534429"] = {name = "Giant Panda", prices = {["default"] = 6863.46, ["Ride"] = 6562.5, ["Fly|Ride"] = 6795.32, ["Neon"] = 30887.76, ["Neon|Fly|Ride"] = 27304.78}},
    ["rbxassetid://6060998707"] = {name = "Frost Fury", prices = {["default"] = 262.49, ["Fly"] = 274.93, ["Ride"] = 255.15, ["Fly|Ride"] = 245.44, ["Neon|Ride"] = 700.14, ["Neon|Fly|Ride"] = 590.63, ["Mega|Fly|Ride"] = 2063.25}},
    ["rbxassetid://88882779021298"] = {name = "Kitty Bat", prices = {["default"] = 40.69, ["Fly"] = 311.85, ["Ride"] = 77.44, ["Fly|Ride"] = 152.25, ["Neon"] = 89.63, ["Neon|Fly"] = 307.86, ["Neon|Ride"] = 115.5, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 392.34, ["Mega|Ride"] = 415.51, ["Mega|Fly|Ride"] = 454.13}},
    ["rbxassetid://16441372760"] = {name = "Diamond Mahi Mahi", prices = {["default"] = 2.63, ["Fly"] = 85.84, ["Ride"] = 20.89, ["Fly|Ride"] = 105.54, ["Neon"] = 24.92, ["Neon|Fly"] = 49.43, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 187.4, ["Mega"] = 330.75, ["Mega|Ride"] = 187.69}},
    ["rbxassetid://3199974169"] = {name = "Royal Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://84714602656867"] = {name = "Slimingo", prices = {["default"] = 52.5, ["Fly"] = 5257.33, ["Ride"] = 87.94, ["Fly|Ride"] = 231.65, ["Neon"] = 201.12, ["Neon|Fly"] = 357.29, ["Neon|Ride"] = 231.53, ["Neon|Fly|Ride"] = 329.34, ["Mega"] = 445.76, ["Mega|Ride"] = 545.2, ["Mega|Fly|Ride"] = 590.07}},
    ["rbxassetid://3409443710"] = {name = "Giraffe", prices = {["default"] = 15647.87, ["Ride"] = 13387.5, ["Fly|Ride"] = 12600, ["Neon|Fly|Ride"] = 26769.41}},
    ["rbxassetid://121215031043780"] = {name = "Velocirooster", prices = {["default"] = 179.82, ["Ride"] = 262.5, ["Fly|Ride"] = 371.44, ["Neon"] = 1235.52, ["Neon|Ride"] = 1510.42, ["Neon|Fly|Ride"] = 1502.19, ["Mega|Fly|Ride"] = 5217.6}},
    ["rbxassetid://5067925034"] = {name = "Ninja Monkey", prices = {["default"] = 63, ["Fly"] = 67.51, ["Ride"] = 75.51, ["Fly|Ride"] = 112.43, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 415.8, ["Mega|Fly|Ride"] = 2572.25}},
    ["rbxassetid://10618035564"] = {name = "Baku", prices = {["default"] = 11.39, ["Fly"] = 44.08, ["Ride"] = 23.21, ["Fly|Ride"] = 55.55, ["Neon"] = 86.5, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 229.69, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://13665641282"] = {name = "Shark Puppy", prices = {["default"] = 385.88, ["Ride"] = 472.5, ["Fly|Ride"] = 484.31, ["Neon"] = 2334.09, ["Neon|Ride"] = 1713.26, ["Neon|Fly|Ride"] = 1706.25, ["Mega|Fly|Ride"] = 5011.13}},
    ["rbxassetid://119447343321908"] = {name = "Tealwood Monster", prices = {["default"] = 6.3, ["Fly"] = 101.53, ["Ride"] = 34.8, ["Fly|Ride"] = 85.22, ["Neon"] = 27.82, ["Neon|Ride"] = 128.63, ["Neon|Fly|Ride"] = 205.94, ["Mega"] = 129.93, ["Mega|Ride"] = 177.19, ["Mega|Fly|Ride"] = 387.41}},
    ["rbxassetid://85568505745239"] = {name = "Latte Kitsune", prices = {["default"] = 130.6, ["Fly"] = 218.29, ["Ride"] = 153.08, ["Fly|Ride"] = 233.26, ["Neon"] = 546.73, ["Neon|Ride"] = 637.32, ["Neon|Fly|Ride"] = 525, ["Mega|Fly|Ride"] = 2572.48}},
    ["rbxassetid://3181727727"] = {name = "Griffin", prices = {["default"] = 13.13, ["Fly"] = 17.07, ["Ride"] = 18.38, ["Fly|Ride"] = 36.66, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 105, ["Mega"] = 874.13, ["Mega|Fly|Ride"] = 720.82}},
    ["rbxassetid://4822753215"] = {name = "Golden Egg", prices = {["default"] = 13.13}},
    ["rbxassetid://116463571924920"] = {name = "Prismatic Butterfly", prices = {["default"] = 74.82, ["Fly"] = 205.94, ["Ride"] = 86.63, ["Fly|Ride"] = 279.57, ["Neon"] = 421.32, ["Neon|Fly"] = 549.82, ["Neon|Ride"] = 411.86, ["Neon|Fly|Ride"] = 367.5, ["Mega|Ride"] = 1050, ["Mega|Fly|Ride"] = 1785.55}},
    ["rbxassetid://8596153183"] = {name = "Chameleon", prices = {["default"] = 19.38, ["Fly"] = 101.95, ["Ride"] = 38.55, ["Fly|Ride"] = 96.8, ["Neon"] = 164.75, ["Neon|Ride"] = 104.99, ["Neon|Fly|Ride"] = 245.44, ["Mega"] = 1027.68, ["Mega|Fly|Ride"] = 682.5}},
    ["rbxassetid://110774856122162"] = {name = "Gemstone Egg", prices = {["default"] = 23.63}},
    ["rbxassetid://14892649590"] = {name = "Dire Stag", prices = {["default"] = 44.16, ["Fly"] = 210, ["Ride"] = 81.38, ["Fly|Ride"] = 249.38, ["Neon"] = 208.69, ["Neon|Ride"] = 258.57, ["Neon|Fly|Ride"] = 341.25, ["Mega"] = 1098.72, ["Mega|Ride"] = 1067.1, ["Mega|Fly|Ride"] = 1153.3}},
    ["rbxassetid://106744890070136"] = {name = "Oakee Wizard", prices = {["default"] = 3.89, ["Ride"] = 29.23, ["Fly|Ride"] = 132.22, ["Neon"] = 19.69, ["Neon|Ride"] = 104.4, ["Neon|Fly|Ride"] = 271.83, ["Mega"] = 131.25, ["Mega|Fly|Ride"] = 412.79}},
    ["rbxassetid://9938967576"] = {name = "Chocolate Chow-Chow", prices = {["default"] = 15.45, ["Fly"] = 47.25, ["Ride"] = 35.74, ["Fly|Ride"] = 92.79, ["Neon"] = 119.44, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 180.91, ["Mega|Ride"] = 604.46, ["Mega|Fly|Ride"] = 590.28}},
    ["rbxassetid://9174893483"] = {name = "Mechapup", prices = {["default"] = 549.75, ["Ride"] = 457.19, ["Fly|Ride"] = 539.44, ["Neon|Fly|Ride"] = 2738.73, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://15292843858"] = {name = "Mecha Meow", prices = {["default"] = 39.25, ["Fly"] = 102.98, ["Ride"] = 55.1, ["Fly|Ride"] = 139.13, ["Neon"] = 233.73, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 208.8, ["Mega"] = 1061.66, ["Mega|Ride"] = 681.45, ["Mega|Fly|Ride"] = 961.77}},
    ["rbxassetid://15931200262"] = {name = "Cactus Friend", prices = {["default"] = 57.74, ["Fly"] = 117.49, ["Ride"] = 89.59, ["Fly|Ride"] = 131.25, ["Neon"] = 411.86, ["Neon|Ride"] = 210, ["Neon|Fly|Ride"] = 328.12, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://127221459636244"] = {name = "Strawberry Shortcake Ducky", prices = {["default"] = 26.25, ["Fly"] = 69.21, ["Ride"] = 65.63, ["Fly|Ride"] = 143.13, ["Neon"] = 105, ["Neon|Ride"] = 124.11, ["Neon|Fly|Ride"] = 308.88, ["Mega"] = 414.74, ["Mega|Ride"] = 409.5, ["Mega|Fly|Ride"] = 625.28}},
    ["rbxassetid://4470748644"] = {name = "Frost Dragon", prices = {["default"] = 11287.5, ["Fly"] = 8400, ["Ride"] = 13295.51, ["Fly|Ride"] = 8190, ["Neon|Fly|Ride"] = 14304.94, ["Mega|Fly|Ride"] = 39373.95}},
    ["rbxassetid://15365667976"] = {name = "Chocolate Chip Bat Dragon", prices = {["default"] = 1509.38, ["Ride"] = 1391.23, ["Fly|Ride"] = 1571.53, ["Neon"] = 5334.77, ["Neon|Fly|Ride"] = 4528.13, ["Mega|Fly|Ride"] = 15487.5}},
    ["rbxassetid://16898343164"] = {name = "Pirate Ghost Capuchin Monkey", prices = {["default"] = 686.66, ["Ride"] = 560.37, ["Fly|Ride"] = 525, ["Neon"] = 4338.65, ["Mega|Fly|Ride"] = 6728.19}},
    ["rbxassetid://6404812772"] = {name = "Golden Ladybug", prices = {["default"] = 11.82, ["Fly"] = 19.69, ["Ride"] = 22.04, ["Fly|Ride"] = 41.32, ["Neon"] = 110.25, ["Neon|Ride"] = 101.95, ["Neon|Fly|Ride"] = 137.97, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://95029455226760"] = {name = "Easter Bunny", prices = {["default"] = 7.88, ["Fly"] = 78.74, ["Ride"] = 37.13, ["Fly|Ride"] = 77.23, ["Neon"] = 28.62, ["Neon|Ride"] = 76.26, ["Neon|Fly|Ride"] = 213.94, ["Mega"] = 142.09, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://5307473113"] = {name = "Kitsune", prices = {["default"] = 36.45, ["Fly"] = 60.82, ["Ride"] = 57.73, ["Fly|Ride"] = 99.75, ["Neon"] = 521.89, ["Neon|Ride"] = 155.43, ["Neon|Fly|Ride"] = 183.26, ["Mega|Fly|Ride"] = 524.9}},
    ["rbxassetid://4797806780"] = {name = "Golden Dragon", prices = {["default"] = 3.94, ["Fly"] = 17.41, ["Ride"] = 17.41, ["Fly|Ride"] = 45.94, ["Neon"] = 27.82, ["Neon|Fly"] = 76.91, ["Neon|Ride"] = 52.49, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 262.5, ["Mega|Ride"] = 240.97}},
    ["rbxassetid://135649428081307"] = {name = "Sakura Spirit", prices = {["default"] = 329.44, ["Fly"] = 320.25, ["Ride"] = 301.88, ["Fly|Ride"] = 370.32, ["Neon"] = 1237.44, ["Neon|Ride"] = 1825.56, ["Neon|Fly|Ride"] = 1210.13}},
    ["rbxassetid://11109110190"] = {name = "White Amazon", prices = {["default"] = 19.69, ["Fly"] = 60.59, ["Ride"] = 31.5, ["Fly|Ride"] = 87.86, ["Neon"] = 91.88, ["Neon|Fly"] = 411.86, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 137.97, ["Mega"] = 535.47, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://9475753542"] = {name = "Golden Albatross", prices = {["default"] = 10.49, ["Fly"] = 18.38, ["Ride"] = 20.61, ["Fly|Ride"] = 44.29, ["Neon"] = 76.2, ["Neon|Fly"] = 132.23, ["Neon|Ride"] = 80.56, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 1575, ["Mega|Ride"] = 618.19, ["Mega|Fly|Ride"] = 426.57}},
    ["rbxassetid://12778628831"] = {name = "Emperor Gorilla", prices = {["default"] = 615.63, ["Fly"] = 787.5, ["Ride"] = 435.75, ["Fly|Ride"] = 755.73, ["Neon|Ride"] = 2882.86, ["Mega|Fly|Ride"] = 8619.21}},
    ["rbxassetid://13672542902"] = {name = "Hot Doggo", prices = {["default"] = 1304.46, ["Fly"] = 1391.76, ["Ride"] = 1154.99, ["Fly|Ride"] = 1312.5, ["Neon"] = 4805.12, ["Neon|Fly|Ride"] = 3570, ["Mega|Fly|Ride"] = 13782.3}},
    ["rbxassetid://8070897995"] = {name = "Ice Golem", prices = {["default"] = 96.79, ["Fly"] = 129.74, ["Ride"] = 103.69, ["Fly|Ride"] = 131.57, ["Neon"] = 971.25, ["Neon|Ride"] = 585.46, ["Neon|Fly|Ride"] = 493.5, ["Mega|Fly|Ride"] = 3557.34}},
    ["rbxassetid://128225904426926"] = {name = "Rose Dragon", prices = {["default"] = 154.44, ["Fly"] = 212.13, ["Ride"] = 156.19, ["Fly|Ride"] = 272.35, ["Neon"] = 577.5, ["Neon|Ride"] = 793.07, ["Neon|Fly|Ride"] = 762.57, ["Mega|Ride"] = 8603.44, ["Mega|Fly|Ride"] = 2629.45}},
    ["rbxassetid://13883274830"] = {name = "Pirate Hermit Crab", prices = {["default"] = 25.73, ["Ride"] = 72.09, ["Fly|Ride"] = 118.58, ["Neon"] = 252.27, ["Neon|Ride"] = 205.94, ["Neon|Fly|Ride"] = 385.08, ["Mega|Ride"] = 2059.45, ["Mega|Fly|Ride"] = 851.6}},
    ["rbxassetid://95213400890066"] = {name = "Diamond Hummingbird", prices = {["default"] = 150.94, ["Ride"] = 273, ["Fly|Ride"] = 145.69, ["Neon|Fly|Ride"] = 1299, ["Mega|Fly|Ride"] = 3707.01}},
    ["rbxassetid://10453528102"] = {name = "Diamond Butterfly", prices = {["default"] = 2233.33, ["Ride"] = 2609, ["Fly|Ride"] = 2162.15, ["Mega|Fly|Ride"] = 24744.74}},
    ["rbxassetid://12778628650"] = {name = "Astronaut Gorilla", prices = {["default"] = 77.7, ["Ride"] = 82.39, ["Fly|Ride"] = 196.88, ["Neon"] = 511.88, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 343.87, ["Mega|Ride"] = 2265.4, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://4708551306"] = {name = "Kangaroo", prices = {["default"] = 623.7, ["Fly"] = 616.88, ["Ride"] = 623.43, ["Fly|Ride"] = 669.37, ["Neon|Ride"] = 1517.04, ["Neon|Fly|Ride"] = 1234.38, ["Mega|Fly|Ride"] = 3267.92}},
    ["rbxassetid://9542440966"] = {name = "Capricorn", prices = {["default"] = 36.75, ["Fly"] = 64.22, ["Ride"] = 57.66, ["Fly|Ride"] = 107.09, ["Neon|Ride"] = 359.56, ["Neon|Fly|Ride"] = 236.25, ["Mega|Fly|Ride"] = 1181.24}},
    ["rbxassetid://9678195673"] = {name = "Ancient Dragon", prices = {["default"] = 3.94, ["Fly"] = 37.41, ["Ride"] = 23.7, ["Fly|Ride"] = 53.61, ["Neon"] = 26.25, ["Neon|Fly"] = 155.42, ["Neon|Ride"] = 44.42, ["Neon|Fly|Ride"] = 93.56, ["Mega"] = 144.33, ["Mega|Ride"] = 158.82, ["Mega|Fly|Ride"] = 254.63}},
    ["rbxassetid://132388343771587"] = {name = "Kelp Captain", prices = {["default"] = 51.93, ["Ride"] = 123.05, ["Fly|Ride"] = 252, ["Neon"] = 339.77, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 463.95, ["Mega"] = 1505.46, ["Mega|Ride"] = 1373.66, ["Mega|Fly|Ride"] = 1235.68}},
    ["rbxassetid://15148532648"] = {name = "Werewolf", prices = {["default"] = 830.68, ["Fly"] = 1014.83, ["Ride"] = 825.71, ["Fly|Ride"] = 903, ["Neon|Ride"] = 2572.77, ["Neon|Fly|Ride"] = 2334.94, ["Mega|Fly|Ride"] = 9336.49}},
    ["rbxassetid://86323568215409"] = {name = "Tortoiseshell Guinea Pig", prices = {["default"] = 588, ["Ride"] = 645.74, ["Fly|Ride"] = 796.92, ["Neon|Fly|Ride"] = 4109.12, ["Mega|Fly|Ride"] = 14827.98}},
    ["rbxassetid://5973019152"] = {name = "Robo Dog", prices = {["default"] = 15.45, ["Fly"] = 26.25, ["Ride"] = 24.94, ["Fly|Ride"] = 45.21, ["Neon"] = 185.34, ["Neon|Ride"] = 97.79, ["Neon|Fly|Ride"] = 179.17, ["Mega"] = 786.19, ["Mega|Ride"] = 686.83, ["Mega|Fly|Ride"] = 681.29}},
    ["rbxassetid://7734928470"] = {name = "Halloween Golden Mummy Cat", prices = {["default"] = 7.91, ["Ride"] = 23.15, ["Fly|Ride"] = 59.06, ["Neon"] = 72.02, ["Neon|Ride"] = 72.19, ["Neon|Fly|Ride"] = 173.25, ["Mega"] = 506.64, ["Mega|Ride"] = 506.64, ["Mega|Fly|Ride"] = 467.51}},
    ["rbxassetid://137429532189183"] = {name = "Fire Stallion", prices = {["default"] = 5.25, ["Ride"] = 24.93, ["Fly|Ride"] = 111.57, ["Neon"] = 22.31, ["Neon|Fly"] = 310.38, ["Neon|Ride"] = 53.7, ["Neon|Fly|Ride"] = 155.43, ["Mega"] = 155.44, ["Mega|Fly"] = 526.6, ["Mega|Ride"] = 241.4, ["Mega|Fly|Ride"] = 317.63}},
    ["rbxassetid://7215324578"] = {name = "Axolotl", prices = {["default"] = 46.4, ["Fly"] = 62.65, ["Ride"] = 52.31, ["Fly|Ride"] = 114.19, ["Neon"] = 153.09, ["Neon|Ride"] = 216.56, ["Neon|Fly|Ride"] = 246.75, ["Mega|Fly|Ride"] = 953.01}},
    ["rbxassetid://111805565268081"] = {name = "Black Widow", prices = {["default"] = 62.56, ["Ride"] = 118.13, ["Fly|Ride"] = 449.61, ["Neon"] = 361.4, ["Neon|Ride"] = 509.66, ["Neon|Fly|Ride"] = 695.63, ["Mega"] = 1235.68, ["Mega|Ride"] = 1544.6, ["Mega|Fly|Ride"] = 1495.17}},
    ["rbxassetid://103653773461193"] = {name = "Sunglider", prices = {["default"] = 15.65, ["Fly"] = 57.19, ["Ride"] = 34.79, ["Fly|Ride"] = 96.8, ["Neon"] = 93.71, ["Neon|Fly"] = 155.42, ["Neon|Ride"] = 116.82, ["Neon|Fly|Ride"] = 200.82, ["Mega"] = 343.94, ["Mega|Ride"] = 406.88, ["Mega|Fly|Ride"] = 463.32}},
    ["rbxassetid://6498256069"] = {name = "Shark", prices = {["default"] = 40.69, ["Fly"] = 56.01, ["Ride"] = 52.53, ["Fly|Ride"] = 89.25, ["Neon"] = 548.5, ["Neon|Ride"] = 216.9, ["Neon|Fly|Ride"] = 298.64, ["Mega"] = 2100, ["Mega|Ride"] = 963.11, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://8663440945"] = {name = "Lunar Gold Tiger", prices = {["default"] = 6.01, ["Fly"] = 27.82, ["Ride"] = 18.55, ["Fly|Ride"] = 36.75, ["Neon"] = 24.02, ["Neon|Ride"] = 45.92, ["Neon|Fly|Ride"] = 91.72, ["Mega"] = 525, ["Mega|Ride"] = 274.95, ["Mega|Fly|Ride"] = 411.9}},
    ["rbxassetid://94185217299816"] = {name = "Dracula Parrot", prices = {["default"] = 7.88, ["Fly"] = 37.44, ["Ride"] = 28.88, ["Fly|Ride"] = 119.44, ["Neon"] = 25.97, ["Neon|Fly"] = 139, ["Neon|Ride"] = 73.41, ["Neon|Fly|Ride"] = 164.75, ["Mega"] = 192.57, ["Mega|Ride"] = 305.36, ["Mega|Fly|Ride"] = 378}},
    ["rbxassetid://4621220431"] = {name = "Golden Rat", prices = {["default"] = 51.49, ["Fly"] = 65.62, ["Ride"] = 48.74, ["Fly|Ride"] = 105, ["Neon"] = 402.45, ["Neon|Ride"] = 222.41, ["Neon|Fly|Ride"] = 207.63, ["Mega|Fly|Ride"] = 1019.82}},
    ["rbxassetid://11506045996"] = {name = "Strawberry Shortcake Bat Dragon", prices = {["default"] = 1664.25, ["Fly"] = 1575, ["Ride"] = 1611.02, ["Fly|Ride"] = 1637.45, ["Neon|Fly"] = 4696.92, ["Neon|Fly|Ride"] = 3478.13, ["Mega|Fly|Ride"] = 13146.02}},
    ["rbxassetid://11758583912"] = {name = "Winged Tiger", prices = {["default"] = 420, ["Fly"] = 479.75, ["Ride"] = 459.38, ["Fly|Ride"] = 617.76, ["Neon|Ride"] = 3020.83, ["Neon|Fly|Ride"] = 3005.39, ["Mega|Fly|Ride"] = 9611.42}},
    ["rbxassetid://101160794933271"] = {name = "Matcha Cat", prices = {["default"] = 295.07, ["Ride"] = 318.78, ["Fly|Ride"] = 459.38, ["Neon"] = 1538.23, ["Neon|Ride"] = 1373.49, ["Neon|Fly|Ride"] = 1510.42, ["Mega|Fly|Ride"] = 7227.62}},
    ["rbxassetid://13892790514"] = {name = "Urban Egg", prices = {["default"] = 45.94}},
    ["rbxassetid://13104109574"] = {name = "Spinosaurus", prices = {["default"] = 27.57, ["Ride"] = 47.14, ["Fly|Ride"] = 96.8, ["Neon"] = 329.36, ["Neon|Fly"] = 411.86, ["Neon|Ride"] = 352.14, ["Neon|Fly|Ride"] = 343.89, ["Mega|Ride"] = 1097.7, ["Mega|Fly|Ride"] = 1038.19}},
    ["rbxassetid://4115248712"] = {name = "Shadow Dragon", prices = {["default"] = 41183.68, ["Fly"] = 65625, ["Ride"] = 34781.25, ["Fly|Ride"] = 17981.24, ["Neon|Fly|Ride"] = 38062.5, ["Mega|Fly|Ride"] = 89250}},
    ["rbxassetid://71457697470071"] = {name = "Arctic Dusk Dragon", prices = {["default"] = 454, ["Fly"] = 379.32, ["Ride"] = 334.76, ["Fly|Ride"] = 432.44, ["Neon"] = 1029.61, ["Neon|Fly"] = 1237.44, ["Neon|Ride"] = 1141.88, ["Neon|Fly|Ride"] = 1128.75, ["Mega"] = 6178.33, ["Mega|Fly|Ride"] = 3871.88}},
    ["rbxassetid://8566683457"] = {name = "Giant Gold Scarab", prices = {["default"] = 136.73, ["Fly"] = 525, ["Ride"] = 137.67, ["Fly|Ride"] = 201.79, ["Mega|Fly|Ride"] = 4118.89}},
    ["rbxassetid://16116063171"] = {name = "Rainbow Dragon", prices = {["default"] = 120.62, ["Fly"] = 262.49, ["Ride"] = 124.09, ["Fly|Ride"] = 137.97, ["Neon"] = 695.86, ["Neon|Ride"] = 547.56, ["Neon|Fly|Ride"] = 801.13, ["Mega|Fly|Ride"] = 2470.31}},
    ["rbxassetid://9938967130"] = {name = "Black Chow-Chow", prices = {["default"] = 15.6, ["Fly"] = 94.5, ["Ride"] = 39.38, ["Fly|Ride"] = 96.8, ["Neon"] = 392.44, ["Neon|Ride"] = 140.44, ["Neon|Fly|Ride"] = 273.89, ["Mega"] = 693.62, ["Mega|Ride"] = 603.15, ["Mega|Fly|Ride"] = 617.86}},
    ["rbxassetid://116467943923352"] = {name = "Haetae", prices = {["default"] = 4886.88, ["Ride"] = 4986.5, ["Fly|Ride"] = 4461.18, ["Neon"] = 20591.85, ["Neon|Fly|Ride"] = 27456.14, ["Mega|Fly|Ride"] = 61860.66}},
    ["rbxassetid://6531232495"] = {name = "Peacock", prices = {["default"] = 19.69, ["Fly"] = 48.57, ["Ride"] = 34.8, ["Fly|Ride"] = 59.07, ["Neon"] = 228.59, ["Neon|Ride"] = 220.38, ["Neon|Fly|Ride"] = 185.59, ["Mega|Fly|Ride"] = 859.69}},
    ["rbxassetid://12557346746"] = {name = "Naga Dragon", prices = {["default"] = 39.36, ["Fly"] = 131.25, ["Ride"] = 52.5, ["Fly|Ride"] = 106.05, ["Neon"] = 399.5, ["Neon|Ride"] = 256.34, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 1547.28, ["Mega|Fly|Ride"] = 1372.88}},
    ["rbxassetid://127697654557674"] = {name = "Candicorn", prices = {["default"] = 838, ["Fly"] = 883.4, ["Ride"] = 804.57, ["Fly|Ride"] = 954.44, ["Neon"] = 2729.47, ["Neon|Ride"] = 2609, ["Neon|Fly|Ride"] = 2362.49, ["Mega"] = 9060.52, ["Mega|Fly"] = 9060.52, ["Mega|Fly|Ride"] = 8662.5}},
    ["rbxassetid://4281674580"] = {name = "King Bee", prices = {["default"] = 17.41, ["Fly"] = 28.74, ["Ride"] = 27.57, ["Fly|Ride"] = 49.43, ["Neon"] = 131.25, ["Neon|Ride"] = 129.94, ["Neon|Fly|Ride"] = 157.68, ["Mega|Fly|Ride"] = 746.96}},
    ["rbxassetid://17822543288"] = {name = "Blue Betta Fish", prices = {["default"] = 13.71, ["Fly"] = 96.8, ["Ride"] = 30.96, ["Fly|Ride"] = 463.87, ["Neon"] = 80.07, ["Neon|Ride"] = 116.82, ["Neon|Fly|Ride"] = 129.94, ["Mega"] = 407.78, ["Mega|Ride"] = 411.9}},
    ["rbxassetid://102300026415493"] = {name = "Moose Calf", prices = {["default"] = 88.15, ["Ride"] = 128.63, ["Fly|Ride"] = 205.94, ["Neon"] = 472.5, ["Neon|Ride"] = 530.66, ["Neon|Fly|Ride"] = 576.59, ["Mega|Fly|Ride"] = 2540.33}},
    ["rbxassetid://78419574214060"] = {name = "Christmas Spirit", prices = {["default"] = 23.21, ["Fly"] = 137.97, ["Ride"] = 55.82, ["Fly|Ride"] = 143.07, ["Neon"] = 96.8, ["Neon|Ride"] = 127.7, ["Neon|Fly|Ride"] = 367.5, ["Mega"] = 223.13, ["Mega|Fly"] = 736.54, ["Mega|Ride"] = 299.92, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://130642623661179"] = {name = "Cryptid", prices = {["default"] = 3806.25, ["Ride"] = 4410, ["Fly|Ride"] = 3871.88, ["Neon|Ride"] = 12248.04, ["Neon|Fly|Ride"] = 9477.95, ["Mega"] = 61782.17, ["Mega|Fly|Ride"] = 32678.17}},
    ["rbxassetid://101130894252942"] = {name = "Peach Owl", prices = {["default"] = 51.49, ["Ride"] = 78.74, ["Fly|Ride"] = 135.93, ["Neon"] = 393.32, ["Neon|Ride"] = 250.49, ["Neon|Fly|Ride"] = 398.47, ["Mega|Ride"] = 1029.73, ["Mega|Fly|Ride"] = 1373.66}},
    ["rbxassetid://4440866649"] = {name = "Owl", prices = {["default"] = 6957.37, ["Ride"] = 6803.67, ["Fly|Ride"] = 6805.3, ["Neon|Ride"] = 16473.49, ["Neon|Fly|Ride"] = 15736.88, ["Mega|Fly|Ride"] = 69592.37}},
    ["rbxassetid://6836687169"] = {name = "Golden Griffin", prices = {["default"] = 3.05, ["Fly"] = 15.45, ["Ride"] = 16.17, ["Fly|Ride"] = 41.15, ["Neon"] = 23.06, ["Neon|Fly"] = 62.62, ["Neon|Ride"] = 45.48, ["Neon|Fly|Ride"] = 79.16, ["Mega"] = 448.89, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://76198828333546"] = {name = "Hippogriff", prices = {["default"] = 26.25, ["Fly"] = 26.15, ["Ride"] = 30.19, ["Fly|Ride"] = 54.52, ["Neon"] = 137.97, ["Neon|Ride"] = 191.51, ["Neon|Fly|Ride"] = 168, ["Mega|Ride"] = 1181.93, ["Mega|Fly|Ride"] = 935.82}},
    ["rbxassetid://112567270488274"] = {name = "Crystal Egg", prices = {["default"] = 3.94}},
    ["rbxassetid://10695038557"] = {name = "Maneki-Neko", prices = {["default"] = 15.74, ["Ride"] = 39.25, ["Fly|Ride"] = 116, ["Neon"] = 274.93, ["Neon|Ride"] = 157.68, ["Neon|Fly|Ride"] = 205.94, ["Mega"] = 775.24, ["Mega|Ride"] = 961.77, ["Mega|Fly|Ride"] = 756.46}},
    ["rbxassetid://16911441596"] = {name = "Royal Capuchin Monkey", prices = {["default"] = 26.25, ["Fly"] = 190.37, ["Ride"] = 55.61, ["Fly|Ride"] = 150.33, ["Neon"] = 195.64, ["Neon|Ride"] = 210, ["Neon|Fly|Ride"] = 294.39, ["Mega"] = 840, ["Mega|Fly|Ride"] = 1099.88}},
    ["rbxassetid://6963387165"] = {name = "Cobra", prices = {["default"] = 13.02, ["Fly"] = 23.55, ["Ride"] = 24.73, ["Fly|Ride"] = 40.43, ["Neon|Ride"] = 110.18, ["Neon|Fly|Ride"] = 175.18, ["Mega"] = 728.44, ["Mega|Ride"] = 578.79, ["Mega|Fly|Ride"] = 502.69}},
    ["rbxassetid://3409444171"] = {name = "Safari Egg", prices = {["default"] = 8338.66}},
    ["rbxassetid://3743740864"] = {name = "Jungle Egg", prices = {["default"] = 2624.96}},
    ["rbxassetid://10321884333"] = {name = "Japan Egg", prices = {["default"] = 22.13}},
    ["rbxassetid://11109117895"] = {name = "Diamond Amazon", prices = {["default"] = 157.5, ["Ride"] = 196.88, ["Fly|Ride"] = 183.75, ["Neon|Fly|Ride"] = 1029.61}},
    ["rbxassetid://102144672439627"] = {name = "Berry Cool Cube", prices = {["default"] = 14.85, ["Fly"] = 123.56, ["Ride"] = 48.41, ["Fly|Ride"] = 105, ["Neon"] = 139.18, ["Neon|Ride"] = 112.18, ["Neon|Fly|Ride"] = 204.91, ["Mega"] = 720.82, ["Mega|Ride"] = 927.91, ["Mega|Fly|Ride"] = 951.47}},
    ["rbxassetid://17183502626"] = {name = "Garden Egg", prices = {["default"] = 13.02}},
    ["rbxassetid://16722909609"] = {name = "Striped Eggy", prices = {["default"] = 6.57, ["Ride"] = 29.22, ["Fly|Ride"] = 68.99, ["Neon"] = 81.36, ["Neon|Ride"] = 94.74, ["Mega|Fly|Ride"] = 823.79}},
    ["rbxassetid://4440866155"] = {name = "Farm Egg", prices = {["default"] = 3051.63}},
    ["rbxassetid://88361277330582"] = {name = "Naughty Mistletroll", prices = {["default"] = 153.61, ["Fly"] = 411.86, ["Ride"] = 136.5, ["Fly|Ride"] = 262.5, ["Neon"] = 701.37, ["Neon|Ride"] = 858.27, ["Neon|Fly|Ride"] = 823.7, ["Mega|Ride"] = 3158.16, ["Mega|Fly|Ride"] = 3021.21}},
    ["rbxassetid://12778919221"] = {name = "Yule Log Dog", prices = {["default"] = 104.21, ["Ride"] = 135.19, ["Fly|Ride"] = 211.32, ["Neon"] = 613.49, ["Neon|Ride"] = 684.87, ["Neon|Fly|Ride"] = 1435.35, ["Mega|Ride"] = 3295.13, ["Mega|Fly|Ride"] = 3295.13}},
    ["rbxassetid://13104112588"] = {name = "Owlbear", prices = {["default"] = 167.99, ["Fly"] = 186.62, ["Ride"] = 189, ["Fly|Ride"] = 249.05, ["Neon"] = 897.75, ["Neon|Ride"] = 842.63, ["Neon|Fly|Ride"] = 1003.67, ["Mega|Fly|Ride"] = 4051.95}},
    ["rbxassetid://11192035130"] = {name = "Undead Jousting Horse", prices = {["default"] = 1966.13, ["Fly"] = 2471.03, ["Ride"] = 1575, ["Fly|Ride"] = 1785, ["Neon|Fly|Ride"] = 5250, ["Mega|Fly|Ride"] = 34024.88}},
    ["rbxassetid://106575933009346"] = {name = "Fairytale Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://96044273915258"] = {name = "Endangered Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://129993159377616"] = {name = "Peahen", prices = {["default"] = 15.44, ["Fly"] = 96.8, ["Ride"] = 39.44, ["Fly|Ride"] = 69.01, ["Neon"] = 156.52, ["Neon|Ride"] = 203.87, ["Neon|Fly|Ride"] = 322.88, ["Mega"] = 925.74, ["Mega|Ride"] = 895.86, ["Mega|Fly|Ride"] = 685.81}},
    ["rbxassetid://12732812236"] = {name = "Tio De Nadal", prices = {["default"] = 804.79, ["Fly"] = 2100, ["Ride"] = 727.65, ["Fly|Ride"] = 961.65, ["Neon|Ride"] = 2938.97, ["Neon|Fly|Ride"] = 4021.29}},
    ["rbxassetid://13936755787"] = {name = "Wrapped Doll", prices = {["default"] = 45.85}},
    ["rbxassetid://136441478335419"] = {name = "Emberlight", prices = {["default"] = 13.13, ["Ride"] = 48.57, ["Fly|Ride"] = 137.97, ["Neon"] = 99.75, ["Neon|Ride"] = 123.56, ["Neon|Fly|Ride"] = 274.95, ["Mega"] = 465.94, ["Mega|Ride"] = 462.58, ["Mega|Fly|Ride"] = 619.39}},
    ["rbxassetid://17120184484"] = {name = "Rosy Maple Moth", prices = {["default"] = 7.76, ["Fly"] = 48.41, ["Ride"] = 27.01, ["Fly|Ride"] = 70.87, ["Neon"] = 52.53, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 274.93, ["Mega"] = 918.75, ["Mega|Ride"] = 343.94, ["Mega|Fly|Ride"] = 356.1}},
    ["rbxassetid://15932251755"] = {name = "Royal Desert Egg", prices = {["default"] = 70.09}},
    ["rbxassetid://8143039289"] = {name = "Golden Walrus", prices = {["default"] = 30.9, ["Ride"] = 23.63, ["Fly|Ride"] = 67.97, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 918.75, ["Mega|Ride"] = 823.79, ["Mega|Fly|Ride"] = 1391.86}},
    ["rbxassetid://12187391973"] = {name = "Firefly", prices = {["default"] = 27.67, ["Fly"] = 51.5, ["Ride"] = 41.03, ["Fly|Ride"] = 57.7, ["Neon|Ride"] = 411.86, ["Neon|Fly|Ride"] = 411.86, ["Mega"] = 880.42, ["Mega|Ride"] = 1739.82, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://3743647944"] = {name = "Parrot", prices = {["default"] = 6300, ["Fly"] = 10982.67, ["Ride"] = 5250, ["Fly|Ride"] = 5053.02, ["Neon|Fly|Ride"] = 10926.2, ["Mega|Fly|Ride"] = 35437.5}},
    ["rbxassetid://128454622445076"] = {name = "Dimension Drifter", prices = {["default"] = 11.06, ["Fly"] = 56.14, ["Ride"] = 34.81, ["Fly|Ride"] = 105, ["Neon"] = 81.36, ["Neon|Ride"] = 78.61, ["Neon|Fly|Ride"] = 163.72, ["Mega"] = 519.63, ["Mega|Ride"] = 582.75, ["Mega|Fly|Ride"] = 456.75}},
    ["rbxassetid://15931761708"] = {name = "Desert Egg", prices = {["default"] = 26.25}},
    ["rbxassetid://17747001377"] = {name = "Majestic Pony", prices = {["default"] = 94.65, ["Fly"] = 364.49, ["Ride"] = 134.89, ["Fly|Ride"] = 196.88, ["Neon"] = 524.99, ["Neon|Ride"] = 378, ["Neon|Fly|Ride"] = 463.95, ["Mega"] = 2879.59, ["Mega|Fly|Ride"] = 1926.64}},
    ["rbxassetid://94487786469241"] = {name = "Vanilla Penguin", prices = {["default"] = 48.86, ["Fly"] = 109.04, ["Ride"] = 89.25, ["Fly|Ride"] = 203.87, ["Neon"] = 259.77, ["Neon|Ride"] = 272.37, ["Neon|Fly|Ride"] = 380.63, ["Mega"] = 2319.76, ["Mega|Ride"] = 2780.26, ["Mega|Fly|Ride"] = 1647.57}},
    ["rbxassetid://6498256211"] = {name = "Octopus", prices = {["default"] = 22.53, ["Fly"] = 70.46, ["Ride"] = 27.57, ["Fly|Ride"] = 79.75, ["Neon"] = 171.95, ["Neon|Ride"] = 138.43, ["Neon|Fly|Ride"] = 202.13, ["Mega"] = 1016.21, ["Mega|Ride"] = 839.24, ["Mega|Fly|Ride"] = 630}},
    ["rbxassetid://110654583245787"] = {name = "Sea Turtle", prices = {["default"] = 6.46, ["Fly"] = 68.99, ["Ride"] = 27.57, ["Fly|Ride"] = 59.07, ["Neon"] = 37.16, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 179.17, ["Mega"] = 157.5, ["Mega|Fly"] = 918.75, ["Mega|Ride"] = 251.81, ["Mega|Fly|Ride"] = 333.88}},
    ["rbxassetid://8596147681"] = {name = "Squid", prices = {["default"] = 11.82, ["Fly"] = 137.97, ["Ride"] = 26.25, ["Fly|Ride"] = 65.63, ["Neon"] = 102.98, ["Neon|Ride"] = 124.11, ["Neon|Fly|Ride"] = 160.13, ["Mega"] = 719.14, ["Mega|Ride"] = 422.63, ["Mega|Fly|Ride"] = 576.66}},
    ["rbxassetid://9226723356"] = {name = "Winged Horse", prices = {["default"] = 19.58, ["Fly"] = 30.09, ["Ride"] = 26.25, ["Fly|Ride"] = 55.08, ["Neon"] = 205.94, ["Neon|Ride"] = 259.41, ["Neon|Fly|Ride"] = 177.19, ["Mega|Fly|Ride"] = 755.84}},
    ["rbxassetid://4733386633"] = {name = "Aussie Egg", prices = {["default"] = 194.25}},
    ["rbxassetid://121951206021245"] = {name = "Kiwi Kiwi", prices = {["default"] = 10.31, ["Ride"] = 291.38, ["Fly|Ride"] = 273.78, ["Neon"] = 190.3, ["Neon|Ride"] = 205.94, ["Mega"] = 823.79, ["Mega|Fly|Ride"] = 686.83}},
    ["rbxassetid://9602676771"] = {name = "Diamond Albatross", prices = {["default"] = 192.54, ["Fly"] = 463.93, ["Ride"] = 443.63, ["Fly|Ride"] = 1546.99, ["Neon"] = 1235.52}},
    ["rbxassetid://79965389436178"] = {name = "Sushi Penguin", prices = {["default"] = 41.58, ["Fly"] = 212.02, ["Ride"] = 110.25, ["Fly|Ride"] = 201.81, ["Neon"] = 258.24, ["Neon|Fly|Ride"] = 463.95, ["Mega"] = 896.56, ["Mega|Ride"] = 2150.43, ["Mega|Fly|Ride"] = 1201.7}},
    ["rbxassetid://126930507653265"] = {name = "Grim Dragon", prices = {["default"] = 945, ["Fly"] = 1156.33, ["Ride"] = 931.88, ["Fly|Ride"] = 1018.5, ["Neon|Fly"] = 4012.67, ["Neon|Ride"] = 3129.97, ["Neon|Fly|Ride"] = 2625, ["Mega|Fly|Ride"] = 11733.75}},
    ["rbxassetid://87328715505907"] = {name = "Silverback Gorilla", prices = {["default"] = 385.03, ["Fly"] = 463.93, ["Ride"] = 378, ["Fly|Ride"] = 467.44, ["Neon"] = 2862.9, ["Neon|Ride"] = 1304.5, ["Neon|Fly|Ride"] = 1923.29, ["Mega"] = 8134.81, ["Mega|Fly|Ride"] = 6954.94}},
    ["rbxassetid://12733311267"] = {name = "Fool Egg", prices = {["default"] = 68.99}},
    ["rbxassetid://139472202653768"] = {name = "Admin Abuse Egg", prices = {["default"] = 3.94}},
    ["rbxassetid://8938702589"] = {name = "Hawk", prices = {["default"] = 12.48, ["Fly"] = 30.17, ["Ride"] = 24.73, ["Fly|Ride"] = 48.63, ["Neon"] = 78.75, ["Neon|Fly"] = 115.99, ["Neon|Ride"] = 155.43, ["Neon|Fly|Ride"] = 166.69, ["Mega|Ride"] = 685.81, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://8938703243"] = {name = "Fallow Deer", prices = {["default"] = 309.87, ["Fly"] = 411.86, ["Ride"] = 327.45, ["Fly|Ride"] = 428.73, ["Neon"] = 1049.18, ["Neon|Ride"] = 892.5, ["Neon|Fly|Ride"] = 1076.97, ["Mega|Fly|Ride"] = 2756.25}},
    ["rbxassetid://4822753124"] = {name = "Diamond Egg", prices = {["default"] = 19.2}},
    ["rbxassetid://114823420678686"] = {name = "Dragonfruit Fox", prices = {["default"] = 177.19, ["Ride"] = 205.94, ["Fly|Ride"] = 347.82, ["Neon"] = 755.73, ["Neon|Fly"] = 1717.37, ["Neon|Ride"] = 921.51, ["Neon|Fly|Ride"] = 787.5, ["Mega"] = 9885.32, ["Mega|Ride"] = 11714.11, ["Mega|Fly|Ride"] = 2939.13}},
    ["rbxassetid://102844319137806"] = {name = "Pineapple Owl", prices = {["default"] = 127.32, ["Ride"] = 125.89, ["Fly|Ride"] = 199.76, ["Neon"] = 673.37, ["Neon|Fly"] = 393.75, ["Neon|Ride"] = 1005.38, ["Neon|Fly|Ride"] = 913.5, ["Mega|Fly|Ride"] = 2417.8}},
    ["rbxassetid://82296650763619"] = {name = "Angus Bull", prices = {["default"] = 5.92, ["Ride"] = 29.3, ["Fly|Ride"] = 167.84, ["Neon"] = 26.78, ["Neon|Ride"] = 85.31, ["Neon|Fly|Ride"] = 227.55, ["Mega"] = 262.59, ["Mega|Ride"] = 508.04, ["Mega|Fly|Ride"] = 813.49}},
    ["rbxassetid://12917347755"] = {name = "Sunrise Duckling", prices = {["default"] = 13.11, ["Fly"] = 63.03, ["Ride"] = 32.71, ["Fly|Ride"] = 70.33, ["Neon"] = 177.19, ["Neon|Ride"] = 109.04, ["Neon|Fly|Ride"] = 341.25, ["Mega|Ride"] = 801.13, ["Mega|Fly|Ride"] = 619.9}},
    ["rbxassetid://139217275750567"] = {name = "Winter Buck", prices = {["default"] = 17.41, ["Fly"] = 102.33, ["Ride"] = 41.2, ["Fly|Ride"] = 101.95, ["Neon"] = 92.79, ["Neon|Ride"] = 130.77, ["Neon|Fly|Ride"] = 255.94, ["Mega"] = 498.75, ["Mega|Ride"] = 504, ["Mega|Fly|Ride"] = 685.81}},
    ["rbxassetid://114331718573822"] = {name = "Mochi Meow", prices = {["default"] = 10.31, ["Fly"] = 131.25, ["Ride"] = 55.34, ["Fly|Ride"] = 170.63, ["Neon"] = 24.94, ["Neon|Fly"] = 231.96, ["Neon|Ride"] = 67.54, ["Neon|Fly|Ride"] = 155.44, ["Mega"] = 153.46, ["Mega|Fly"] = 308.94, ["Mega|Ride"] = 178.49, ["Mega|Fly|Ride"] = 269.07}},
    ["rbxassetid://112560568221286"] = {name = "Strawberry Penguin", prices = {["default"] = 267.68, ["Ride"] = 323.91, ["Fly|Ride"] = 398.93, ["Neon"] = 1616.48, ["Neon|Ride"] = 1321.04, ["Neon|Fly|Ride"] = 1299.38, ["Mega|Fly|Ride"] = 5217.6}},
    ["rbxassetid://116818749091454"] = {name = "Dango Penguins", prices = {["default"] = 164.07, ["Fly"] = 203.87, ["Ride"] = 237.62, ["Fly|Ride"] = 262.5, ["Neon"] = 619.32, ["Neon|Ride"] = 3837.23, ["Neon|Fly|Ride"] = 864.87, ["Mega"] = 9885.32, ["Mega|Ride"] = 2887.5, ["Mega|Fly|Ride"] = 5147.58}},
    ["rbxassetid://12480100169"] = {name = "Tree Kangaroo", prices = {["default"] = 80.07, ["Fly"] = 167.45, ["Ride"] = 102.15, ["Fly|Ride"] = 185.55, ["Neon|Ride"] = 472.05, ["Neon|Fly|Ride"] = 498.75, ["Mega|Fly|Ride"] = 1647.57}},
    ["rbxassetid://75106733244906"] = {name = "Golden Hummingbird", prices = {["default"] = 11.82, ["Ride"] = 58.24, ["Fly|Ride"] = 274.93, ["Neon|Ride"] = 589.2, ["Neon|Fly|Ride"] = 480.83, ["Mega|Ride"] = 408.5, ["Mega|Fly|Ride"] = 1853.51}},
    ["rbxassetid://76354526914534"] = {name = "Frostclaw", prices = {["default"] = 15.45, ["Fly"] = 75.63, ["Ride"] = 41.2, ["Fly|Ride"] = 97.83, ["Neon"] = 77.39, ["Neon|Fly"] = 205.94, ["Neon|Ride"] = 100.92, ["Neon|Fly|Ride"] = 152.39, ["Mega"] = 342.18, ["Mega|Fly"] = 525, ["Mega|Ride"] = 308.44, ["Mega|Fly|Ride"] = 454.77}},
    ["rbxassetid://121712578077668"] = {name = "Blue Whale", prices = {["default"] = 3.88, ["Fly"] = 52.45, ["Ride"] = 25.52, ["Fly|Ride"] = 82.39, ["Neon"] = 19.68, ["Neon|Ride"] = 34.9, ["Neon|Fly|Ride"] = 133.86, ["Mega"] = 131.15, ["Mega|Ride"] = 181.12, ["Mega|Fly|Ride"] = 254.52}},
    ["rbxassetid://76035105070441"] = {name = "Fairy Bat Dragon", prices = {["default"] = 1001.22, ["Fly"] = 1082.72, ["Ride"] = 944.99, ["Fly|Ride"] = 1059.19, ["Neon"] = 3038.52, ["Neon|Fly"] = 3402.89, ["Neon|Ride"] = 3020.83, ["Neon|Fly|Ride"] = 2428.13, ["Mega|Fly|Ride"] = 9434.42}},
    ["rbxassetid://105346917979221"] = {name = "Aurora Fox", prices = {["default"] = 501.36, ["Ride"] = 453.04, ["Fly|Ride"] = 549.82, ["Neon"] = 1315.15, ["Neon|Fly"] = 1373.49, ["Neon|Ride"] = 1540.28, ["Neon|Fly|Ride"] = 1701.45, ["Mega"] = 10297.21, ["Mega|Fly|Ride"] = 6271.42}},
    ["rbxassetid://120475294381736"] = {name = "Glormy Hound", prices = {["default"] = 74.82, ["Ride"] = 91.88, ["Fly|Ride"] = 205.94, ["Neon"] = 339.94, ["Neon|Ride"] = 304.5, ["Neon|Fly|Ride"] = 462.3, ["Mega"] = 1577.44, ["Mega|Ride"] = 2166.66, ["Mega|Fly|Ride"] = 1576.31}},
    ["rbxassetid://15570696642"] = {name = "Glacier Kitsune", prices = {["default"] = 294.54, ["Fly"] = 378.91, ["Ride"] = 274.93, ["Fly|Ride"] = 343.89, ["Neon"] = 1098.59, ["Neon|Ride"] = 1391.79, ["Neon|Fly|Ride"] = 1382.51, ["Mega"] = 10297.21, ["Mega|Fly|Ride"] = 5492.54}},
    ["rbxassetid://16548792521"] = {name = "Golden Hamster", prices = {["default"] = 18.36, ["Fly"] = 137.97, ["Ride"] = 31.34, ["Fly|Ride"] = 71.02, ["Neon"] = 124.1, ["Neon|Ride"] = 215.74, ["Neon|Fly|Ride"] = 231.98, ["Mega|Fly|Ride"] = 765.53}},
    ["rbxassetid://12935498875"] = {name = "Field Mouse", prices = {["default"] = 223.13, ["Ride"] = 308.88, ["Fly|Ride"] = 489.57, ["Neon"] = 1419.05, ["Neon|Ride"] = 942.38, ["Neon|Fly|Ride"] = 927.87, ["Mega"] = 4105.61, ["Mega|Ride"] = 4256.88, ["Mega|Fly|Ride"] = 3818.31}},
    ["rbxassetid://16548793509"] = {name = "Diamond Hamster", prices = {["default"] = 57.75, ["Fly"] = 76.13, ["Ride"] = 62.62, ["Fly|Ride"] = 132.22, ["Neon|Ride"] = 448.86, ["Neon|Fly|Ride"] = 549.88, ["Mega|Fly|Ride"] = 1373.66}},
    ["rbxassetid://78823655016197"] = {name = "Jekyll Hydra", prices = {["default"] = 1785.11, ["Ride"] = 1785.32, ["Fly|Ride"] = 1779.75, ["Neon"] = 6556.67, ["Neon|Ride"] = 10825.67, ["Neon|Fly|Ride"] = 5903.69, ["Mega"] = 49426.56, ["Mega|Fly|Ride"] = 23340.68}},
    ["rbxassetid://96735424372947"] = {name = "Glormy Dolphin", prices = {["default"] = 13.13, ["Fly"] = 82.21, ["Ride"] = 45.31, ["Fly|Ride"] = 114.33, ["Neon"] = 68.25, ["Neon|Fly"] = 185.34, ["Neon|Ride"] = 103.24, ["Neon|Fly|Ride"] = 274.93, ["Mega"] = 317.09, ["Mega|Fly"] = 561.75, ["Mega|Ride"] = 335.58, ["Mega|Fly|Ride"] = 411.9}},
    ["rbxassetid://16898331554"] = {name = "Princess Capuchin Monkey", prices = {["default"] = 51.65, ["Fly"] = 119.1, ["Ride"] = 74.15, ["Fly|Ride"] = 105, ["Neon"] = 223.13, ["Neon|Ride"] = 292.42, ["Neon|Fly|Ride"] = 304.5, ["Mega"] = 1017.38, ["Mega|Ride"] = 1008.12, ["Mega|Fly|Ride"] = 959.72}},
    ["rbxassetid://4315743450"] = {name = "Queen Bee", prices = {["default"] = 78.75, ["Fly"] = 91.76, ["Ride"] = 78.11, ["Fly|Ride"] = 97.02, ["Neon"] = 411.86, ["Neon|Ride"] = 454.07, ["Neon|Fly|Ride"] = 393.74, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://5067924789"] = {name = "Monkey King", prices = {["default"] = 3430.19, ["Ride"] = 1038.01, ["Fly|Ride"] = 1171.96, ["Mega|Fly|Ride"] = 20723.47}},
    ["rbxassetid://10284283561"] = {name = "Black-Chested Pheasant", prices = {["default"] = 569.36, ["Fly"] = 821.63, ["Ride"] = 549.82, ["Fly|Ride"] = 670.29, ["Neon|Fly|Ride"] = 2783.55, ["Mega|Fly|Ride"] = 18557.98}},
    ["rbxassetid://15504845135"] = {name = "Candy Hare", prices = {["default"] = 94.5, ["Ride"] = 144.38, ["Fly|Ride"] = 196.88, ["Neon"] = 446.8, ["Neon|Fly"] = 617.76, ["Neon|Ride"] = 472.5, ["Neon|Fly|Ride"] = 535.4, ["Mega"] = 4118.89, ["Mega|Ride"] = 1391.86, ["Mega|Fly|Ride"] = 2471.34}},
    ["rbxassetid://11758575657"] = {name = "Lunar Moon Bear", prices = {["default"] = 10.28, ["Ride"] = 23.21, ["Fly|Ride"] = 92.92, ["Neon"] = 76.2, ["Neon|Fly"] = 137.97, ["Neon|Ride"] = 100.01, ["Neon|Fly|Ride"] = 196.88, ["Mega|Ride"] = 755.09, ["Mega|Fly|Ride"] = 823.79}},
    ["rbxassetid://10318105392"] = {name = "Green Butterfly", prices = {["default"] = 39.38, ["Fly"] = 102.08, ["Ride"] = 48.56, ["Fly|Ride"] = 102.98, ["Neon"] = 196.88, ["Neon|Fly"] = 411.86, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 288.75, ["Mega|Ride"] = 1194.5, ["Mega|Fly|Ride"] = 954.56}},
    ["rbxassetid://84813815094145"] = {name = "Mermicorn", prices = {["default"] = 729.75, ["Ride"] = 874.13, ["Fly|Ride"] = 918.75, ["Neon"] = 3018.79, ["Neon|Ride"] = 2362.5, ["Neon|Fly|Ride"] = 2139.38, ["Mega|Fly|Ride"] = 9723}},
    ["rbxassetid://4507163112"] = {name = "Christmas Egg", prices = {["default"] = 971.25}},
    ["rbxassetid://14689005829"] = {name = "Blazing Lion", prices = {["default"] = 6024.43, ["Ride"] = 4987.5, ["Fly|Ride"] = 5194.52, ["Neon"] = 42000, ["Neon|Ride"] = 29509.15, ["Neon|Fly|Ride"] = 24024.52, ["Mega|Fly|Ride"] = 87870.13}},
    ["rbxassetid://123647431892215"] = {name = "Hero Gibbon", prices = {["default"] = 274.88, ["Fly"] = 410.93, ["Ride"] = 294.57, ["Neon"] = 1647.37, ["Neon|Fly|Ride"] = 2059.19, ["Mega"] = 6177.3, ["Mega|Fly|Ride"] = 6178.33}},
    ["rbxassetid://106457467498193"] = {name = "Scorching Kaijunior", prices = {["default"] = 83.6, ["Fly"] = 274.93, ["Ride"] = 110.52, ["Fly|Ride"] = 336, ["Neon"] = 420, ["Neon|Ride"] = 522.02, ["Neon|Fly|Ride"] = 1647.37, ["Mega|Fly|Ride"] = 2119.51}},
    ["rbxassetid://10926054030"] = {name = "Chimera", prices = {["default"] = 16.49, ["Fly"] = 58.71, ["Ride"] = 30.9, ["Neon"] = 146, ["Neon|Fly"] = 1237.44, ["Neon|Ride"] = 92.8, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 658.01, ["Mega|Ride"] = 720.82, ["Mega|Fly|Ride"] = 630}},
    ["rbxassetid://9490242683"] = {name = "Golden King Penguin", prices = {["default"] = 11.82, ["Fly"] = 26.17, ["Ride"] = 19.59, ["Fly|Ride"] = 44.35, ["Neon"] = 205.94, ["Neon|Ride"] = 309.68, ["Neon|Fly|Ride"] = 137.97, ["Mega"] = 1312.5, ["Mega|Fly|Ride"] = 2183.03}},
    ["rbxassetid://17119623510"] = {name = "Mushroom Friend", prices = {["default"] = 14.44, ["Fly"] = 274.3, ["Ride"] = 37.13, ["Fly|Ride"] = 140.44, ["Neon"] = 137.97, ["Neon|Ride"] = 143.07, ["Neon|Fly|Ride"] = 200.02, ["Mega"] = 670.69, ["Mega|Ride"] = 612.69, ["Mega|Fly|Ride"] = 603.75}},
    ["rbxassetid://17174656536"] = {name = "Golden Tortoise Beetle", prices = {["default"] = 3.94, ["Fly"] = 21, ["Ride"] = 21, ["Fly|Ride"] = 57.75, ["Neon"] = 23, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 123.3, ["Mega"] = 274.95, ["Mega|Ride"] = 234.94, ["Mega|Fly|Ride"] = 309.7}},
    ["rbxassetid://84310117840681"] = {name = "Super Saru", prices = {["default"] = 29.61, ["Ride"] = 43.31, ["Fly|Ride"] = 96.8, ["Neon"] = 171.95, ["Neon|Fly"] = 823.7, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 329.53, ["Mega"] = 777.46, ["Mega|Ride"] = 673.45, ["Mega|Fly|Ride"] = 961.77}},
    ["rbxassetid://77177643028234"] = {name = "Phantom Dragon", prices = {["default"] = 375.76, ["Fly"] = 410.83, ["Ride"] = 398.47, ["Fly|Ride"] = 463.74, ["Neon"] = 1337.46, ["Neon|Fly"] = 1457.92, ["Neon|Ride"] = 1359.07, ["Neon|Fly|Ride"] = 1308.64, ["Mega"] = 7875, ["Mega|Fly"] = 4845.88, ["Mega|Fly|Ride"] = 4845.88}},
    ["rbxassetid://6245080265"] = {name = "Metal Ox", prices = {["default"] = 2.63, ["Fly"] = 15.64, ["Ride"] = 14.44, ["Fly|Ride"] = 38.85, ["Neon"] = 18.38, ["Neon|Ride"] = 32.67, ["Neon|Fly|Ride"] = 86.43, ["Mega"] = 463.39, ["Mega|Ride"] = 541.68, ["Mega|Fly|Ride"] = 243.77}},
    ["rbxassetid://3181728194"] = {name = "Unicorn", prices = {["default"] = 44.62, ["Fly"] = 95.23, ["Ride"] = 65.63, ["Fly|Ride"] = 144.16, ["Neon"] = 204.75, ["Neon|Fly"] = 288.3, ["Neon|Ride"] = 200.07, ["Neon|Fly|Ride"] = 263.66, ["Mega"] = 686.83, ["Mega|Fly"] = 823.79, ["Mega|Ride"] = 582.63, ["Mega|Fly|Ride"] = 551.25}},
    ["rbxassetid://4708551322"] = {name = "Turtle", prices = {["default"] = 947.13, ["Ride"] = 813.74, ["Fly|Ride"] = 876.64, ["Neon|Ride"] = 1603.88, ["Neon|Fly|Ride"] = 1509.38, ["Mega|Fly|Ride"] = 3780}},
    ["rbxassetid://5721844281"] = {name = "T-Rex", prices = {["default"] = 35.32, ["Fly"] = 91.88, ["Ride"] = 51.18, ["Fly|Ride"] = 78.75, ["Neon"] = 205.94, ["Neon|Ride"] = 216.57, ["Neon|Fly|Ride"] = 229.65, ["Mega"] = 1575, ["Mega|Fly|Ride"] = 756}},
    ["rbxassetid://16127039676"] = {name = "Midnight Dragon", prices = {["default"] = 321.57, ["Fly"] = 339.71, ["Ride"] = 336, ["Fly|Ride"] = 315, ["Neon|Ride"] = 1437.32, ["Neon|Fly|Ride"] = 1312.49, ["Mega|Fly|Ride"] = 13918.49}},
    ["rbxassetid://7734925172"] = {name = "Halloween White Ghost Dragon", prices = {["default"] = 183.75, ["Fly"] = 231.97, ["Ride"] = 190.32, ["Fly|Ride"] = 199.73, ["Neon"] = 633.63, ["Neon|Ride"] = 686.75, ["Neon|Fly|Ride"] = 750.08, ["Mega|Fly|Ride"] = 3473.01}},
    ["rbxassetid://18508016126"] = {name = "Bush Elephant", prices = {["default"] = 720.3, ["Ride"] = 630, ["Fly|Ride"] = 856.7, ["Neon|Ride"] = 2609, ["Neon|Fly|Ride"] = 2993.04, ["Mega|Fly|Ride"] = 6823.69}},
    ["rbxassetid://78218981883168"] = {name = "Coconut Friend", prices = {["default"] = 22.04, ["Ride"] = 43.21, ["Fly|Ride"] = 108.94, ["Neon"] = 78.08, ["Neon|Fly"] = 278.35, ["Neon|Ride"] = 108.05, ["Neon|Fly|Ride"] = 138.01, ["Mega"] = 274.95, ["Mega|Ride"] = 356.1, ["Mega|Fly|Ride"] = 513.85}},
    ["rbxassetid://4184878050"] = {name = "Evil Unicorn", prices = {["default"] = 3255, ["Fly"] = 3543.75, ["Ride"] = 3936.19, ["Fly|Ride"] = 3084.38, ["Neon"] = 13728.6, ["Neon|Fly|Ride"] = 6759.38, ["Mega|Fly|Ride"] = 25058.25}},
    ["rbxassetid://103896000727935"] = {name = "Aestus", prices = {["default"] = 94.5, ["Fly"] = 131.25, ["Ride"] = 122.2, ["Fly|Ride"] = 161.33, ["Neon"] = 550.97, ["Neon|Fly"] = 480.83, ["Neon|Ride"] = 549.82, ["Neon|Fly|Ride"] = 535.4, ["Mega|Fly|Ride"] = 2231.25}},
    ["rbxassetid://9922229151"] = {name = "Dragonfly", prices = {["default"] = 2.63, ["Fly"] = 26.77, ["Ride"] = 18.86, ["Fly|Ride"] = 52.5, ["Neon"] = 18.38, ["Neon|Fly"] = 63.51, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 148.38, ["Mega|Fly"] = 446.25, ["Mega|Ride"] = 272.87, ["Mega|Fly|Ride"] = 287.66}},
    ["rbxassetid://82820245821381"] = {name = "Temple Friend", prices = {["default"] = 3.93, ["Ride"] = 27.82, ["Fly|Ride"] = 57.99, ["Neon"] = 15.75, ["Neon|Ride"] = 55.61, ["Neon|Fly|Ride"] = 266.44, ["Mega"] = 161.44, ["Mega|Ride"] = 199.49, ["Mega|Fly|Ride"] = 308.44}},
    ["rbxassetid://6404812861"] = {name = "Diamond Ladybug", prices = {["default"] = 55.34, ["Ride"] = 35.27, ["Fly|Ride"] = 58.9, ["Neon"] = 278.35, ["Neon|Ride"] = 377.87, ["Neon|Fly|Ride"] = 342.16, ["Mega|Fly|Ride"] = 1098.72}},
    ["rbxassetid://107535752953647"] = {name = "Strawberry Tortle", prices = {["default"] = 901.83, ["Ride"] = 1159.66, ["Fly|Ride"] = 1247.4, ["Neon"] = 3706.55}},
    ["rbxassetid://95844539868957"] = {name = "Amethyst Penguin", prices = {["default"] = 6221.25, ["Ride"] = 7035.59, ["Fly|Ride"] = 6562.5}},
    ["rbxassetid://6240249282"] = {name = "Guardian Lion", prices = {["default"] = 19.69, ["Fly"] = 30.19, ["Ride"] = 26.25, ["Fly|Ride"] = 46.57, ["Neon"] = 666.17, ["Neon|Ride"] = 274.93, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 2428.13, ["Mega|Ride"] = 959.72, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://11496077150"] = {name = "Ice Moth Dragon", prices = {["default"] = 15.75, ["Fly"] = 39.38, ["Ride"] = 27.37, ["Fly|Ride"] = 85.22, ["Neon"] = 89.24, ["Neon|Ride"] = 98.04, ["Neon|Fly|Ride"] = 178.5, ["Mega"] = 648.98, ["Mega|Ride"] = 576.66, ["Mega|Fly|Ride"] = 342.18}},
    ["rbxassetid://5862774166"] = {name = "Skele-Rex", prices = {["default"] = 45.94, ["Fly"] = 157.49, ["Ride"] = 66.94, ["Fly|Ride"] = 118.13, ["Neon"] = 459.38, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 367.5, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://11773429123"] = {name = "Nessie", prices = {["default"] = 252, ["Fly"] = 295.51, ["Ride"] = 277.03, ["Fly|Ride"] = 323.31, ["Neon"] = 1002.84, ["Neon|Ride"] = 977.79, ["Neon|Fly|Ride"] = 1082.82, ["Mega"] = 10297.21, ["Mega|Fly|Ride"] = 3937.66}},
    ["rbxassetid://121782270350526"] = {name = "Dark Choccybunny", prices = {["default"] = 4.14, ["Ride"] = 32.69, ["Fly|Ride"] = 86.63, ["Neon"] = 24.94, ["Neon|Fly"] = 656.24, ["Neon|Ride"] = 68.25, ["Mega"] = 137.82, ["Mega|Ride"] = 188.9, ["Mega|Fly|Ride"] = 303.78}},
    ["rbxassetid://129591977577854"] = {name = "Ballet Swan", prices = {["default"] = 196.88, ["Fly"] = 308.88, ["Ride"] = 231.97, ["Fly|Ride"] = 301.63, ["Neon"] = 711.43, ["Neon|Ride"] = 925.55, ["Neon|Fly|Ride"] = 843.94, ["Mega|Fly|Ride"] = 5315.63}},
    ["rbxassetid://9669227320"] = {name = "Zodiac Minion Chick", prices = {["default"] = 2.63, ["Fly"] = 30.17, ["Ride"] = 15.51, ["Fly|Ride"] = 45.94, ["Neon"] = 26.92, ["Neon|Fly"] = 123.04, ["Neon|Ride"] = 58.95, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 294.62, ["Mega|Ride"] = 223.12, ["Mega|Fly|Ride"] = 287.57}},
    ["rbxassetid://13462536955"] = {name = "Caelum Cervi", prices = {["default"] = 195.61, ["Fly"] = 268.82, ["Ride"] = 205.94, ["Fly|Ride"] = 262.5, ["Neon|Fly|Ride"] = 1113.5, ["Mega"] = 10297.21, ["Mega|Ride"] = 4118.89, ["Mega|Fly|Ride"] = 4117.86}},
    ["rbxassetid://10137833794"] = {name = "Green-Chested Pheasant", prices = {["default"] = 13.13, ["Fly"] = 76.33, ["Ride"] = 26.78, ["Fly|Ride"] = 52.5, ["Neon"] = 70.17, ["Neon|Fly"] = 294.59, ["Neon|Ride"] = 92.8, ["Neon|Fly|Ride"] = 152.39, ["Mega|Ride"] = 617.86, ["Mega|Fly|Ride"] = 449.5}},
    ["rbxassetid://16994954002"] = {name = "Brachiosaurus", prices = {["default"] = 3.13, ["Fly"] = 68.99, ["Ride"] = 19.46, ["Fly|Ride"] = 59.06, ["Neon"] = 12.89, ["Neon|Fly"] = 170.45, ["Neon|Ride"] = 36.66, ["Neon|Fly|Ride"] = 176.88, ["Mega"] = 77.44, ["Mega|Ride"] = 99.75, ["Mega|Fly|Ride"] = 192.05}},
    ["rbxassetid://121938982134212"] = {name = "Gecko Ducky", prices = {["default"] = 2.1, ["Neon"] = 5.16, ["Neon|Ride"] = 41.2, ["Mega"] = 17.59, ["Mega|Ride"] = 136.88, ["Mega|Fly|Ride"] = 411.9}},
    ["rbxassetid://17649624018"] = {name = "Kid Goat", prices = {["default"] = 3.94, ["Fly"] = 52.48, ["Ride"] = 22.1, ["Fly|Ride"] = 152.39, ["Neon"] = 15.65, ["Neon|Ride"] = 43.3, ["Neon|Fly|Ride"] = 109.94, ["Mega"] = 69.96, ["Mega|Fly"] = 154650.46, ["Mega|Ride"] = 138.01, ["Mega|Fly|Ride"] = 161.7}},
    ["rbxassetid://4440867127"] = {name = "Chicken", prices = {["default"] = 84.74, ["Fly"] = 137.97, ["Ride"] = 112.4, ["Fly|Ride"] = 181.07, ["Neon"] = 347.17, ["Neon|Ride"] = 384.57, ["Neon|Fly|Ride"] = 376.99, ["Mega|Ride"] = 1338.66, ["Mega|Fly|Ride"] = 1101.02}},
    ["rbxassetid://5721844165"] = {name = "Tasmanian Tiger", prices = {["default"] = 2.1, ["Fly"] = 33.65, ["Ride"] = 15.73, ["Fly|Ride"] = 103.47, ["Neon"] = 4.79, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 129.94, ["Mega|Ride"] = 137.49, ["Mega|Fly|Ride"] = 257.24}},
    ["rbxassetid://14146063876"] = {name = "Cockroach", prices = {["default"] = 7.86, ["Ride"] = 101.07, ["Neon"] = 71.91, ["Neon|Ride"] = 210, ["Mega"] = 496.43}},
    ["rbxassetid://135555287601448"] = {name = "Rubber Ducky", prices = {["default"] = 2.1, ["Neon"] = 2.63, ["Neon|Ride"] = 46.61, ["Mega"] = 16.38, ["Mega|Ride"] = 76.21, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://9664487060"] = {name = "Ant", prices = {["default"] = 2.1, ["Fly"] = 39.51, ["Ride"] = 15.1, ["Fly|Ride"] = 33.44, ["Neon"] = 2.1, ["Neon|Fly"] = 14.43, ["Neon|Ride"] = 14.12, ["Neon|Fly|Ride"] = 31.83, ["Mega"] = 13.77, ["Mega|Fly"] = 52.5, ["Mega|Ride"] = 18.88, ["Mega|Fly|Ride"] = 48.9}},
    ["rbxassetid://3293758505"] = {name = "Otter", prices = {["default"] = 2.1, ["Fly"] = 27.82, ["Ride"] = 12.47, ["Fly|Ride"] = 39.26, ["Neon"] = 3.73, ["Neon|Fly"] = 16.44, ["Neon|Ride"] = 15.65, ["Neon|Fly|Ride"] = 69.01, ["Mega"] = 30.32, ["Mega|Fly"] = 155.44, ["Mega|Ride"] = 41.91, ["Mega|Fly|Ride"] = 109.05}},
    ["rbxassetid://79698905581979"] = {name = "Ms. Muffet", prices = {["default"] = 2.1, ["Ride"] = 15.45, ["Fly|Ride"] = 102.98, ["Neon"] = 2.1, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 102.98, ["Mega"] = 19.69, ["Mega|Ride"] = 121.85, ["Mega|Fly|Ride"] = 274.95}},
    ["rbxassetid://13620861015"] = {name = "Flying Fish", prices = {["default"] = 2.1, ["Fly"] = 91.84, ["Ride"] = 19.69, ["Fly|Ride"] = 107.63, ["Neon"] = 3.92, ["Neon|Fly"] = 167.95, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 37.1, ["Mega|Fly"] = 91.88, ["Mega|Ride"] = 138.01, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://100439668574210"] = {name = "Jiggly Jerboa", prices = {["default"] = 2.1, ["Neon"] = 3.59, ["Neon|Fly|Ride"] = 205.94, ["Mega"] = 18.38, ["Mega|Ride"] = 99.77, ["Mega|Fly|Ride"] = 102.99}},
    ["rbxassetid://14815828879"] = {name = "Ghost", prices = {["default"] = 3.84, ["Fly"] = 68.99, ["Ride"] = 17.2, ["Fly|Ride"] = 96.8, ["Neon"] = 8.99, ["Neon|Fly"] = 68.16, ["Neon|Ride"] = 31.34, ["Neon|Fly|Ride"] = 74.46, ["Mega"] = 102.38, ["Mega|Fly"] = 155.7, ["Mega|Ride"] = 117.39, ["Mega|Fly|Ride"] = 169.21}},
    ["rbxassetid://140565380261180"] = {name = "Galapagos Sea Lion", prices = {["default"] = 2.1, ["Ride"] = 50.94, ["Neon"] = 2.1, ["Neon|Ride"] = 78.66, ["Neon|Fly|Ride"] = 157.38, ["Mega"] = 15.27, ["Mega|Ride"] = 36.66, ["Mega|Fly|Ride"] = 185.36}},
    ["rbxassetid://14146188240"] = {name = "Bluebottle Fly", prices = {["default"] = 2.99, ["Fly|Ride"] = 524.99, ["Neon"] = 15.75, ["Mega|Fly"] = 314.99, ["Mega|Ride"] = 343.94, ["Mega|Fly|Ride"] = 418.69}},
    ["rbxassetid://15930540035"] = {name = "Sandfish", prices = {["default"] = 3.5, ["Ride"] = 27.56, ["Neon"] = 14.85, ["Mega"] = 105, ["Mega|Ride"] = 102.99, ["Mega|Fly|Ride"] = 537.62}},
    ["rbxassetid://74774507671765"] = {name = "Island Tarsier", prices = {["default"] = 2.1, ["Ride"] = 24.94, ["Neon"] = 3.1, ["Neon|Ride"] = 26.67, ["Neon|Fly|Ride"] = 137.97, ["Mega"] = 19.69, ["Mega|Ride"] = 49.26, ["Mega|Fly|Ride"] = 158.79}},
    ["rbxassetid://9678196095"] = {name = "Mouse", prices = {["default"] = 2.1, ["Fly"] = 19.68, ["Ride"] = 15.45, ["Fly|Ride"] = 30.14, ["Neon"] = 2.1, ["Neon|Fly"] = 19.59, ["Neon|Ride"] = 12.37, ["Neon|Fly|Ride"] = 31.04, ["Mega"] = 11.82, ["Mega|Fly"] = 39.15, ["Mega|Ride"] = 22.67, ["Mega|Fly|Ride"] = 51.35}},
    ["rbxassetid://100695038890951"] = {name = "Basic Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13104111122"] = {name = "Piranha", prices = {["default"] = 3.93, ["Fly"] = 72.19, ["Ride"] = 218.19, ["Fly|Ride"] = 104.98, ["Neon"] = 34.92, ["Neon|Ride"] = 140.95, ["Mega|Ride"] = 240.19}},
    ["rbxassetid://110856597065248"] = {name = "Bakeneko", prices = {["default"] = 2.1, ["Ride"] = 19.09, ["Neon"] = 5.25, ["Neon|Ride"] = 25.76, ["Neon|Fly|Ride"] = 105, ["Mega"] = 28.48, ["Mega|Fly"] = 78.75, ["Mega|Ride"] = 69.01, ["Mega|Fly|Ride"] = 160.08}},
    ["rbxassetid://128979941112615"] = {name = "Dirty Ducky", prices = {["default"] = 2.96, ["Ride"] = 27.82, ["Neon"] = 9.19, ["Neon|Fly|Ride"] = 138.01, ["Mega"] = 95.32, ["Mega|Ride"] = 155.72, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://12479656052"] = {name = "Maleo Bird", prices = {["default"] = 2.62, ["Fly"] = 262.49, ["Ride"] = 32.82, ["Fly|Ride"] = 43.32, ["Neon"] = 20.67, ["Neon|Fly|Ride"] = 105, ["Mega"] = 210, ["Mega|Ride"] = 143.06, ["Mega|Fly|Ride"] = 166.69}},
    ["rbxassetid://3200646599"] = {name = "Cat", prices = {["default"] = 2.1, ["Fly"] = 11.82, ["Ride"] = 15.31, ["Fly|Ride"] = 26.16, ["Neon"] = 2.1, ["Neon|Fly"] = 13.9, ["Neon|Ride"] = 11.46, ["Neon|Fly|Ride"] = 26.67, ["Mega"] = 15.21, ["Mega|Fly"] = 26.25, ["Mega|Ride"] = 17.07, ["Mega|Fly|Ride"] = 51.19}},
    ["rbxassetid://12479810452"] = {name = "Bali Starling", prices = {["default"] = 2.1, ["Fly"] = 27.46, ["Ride"] = 20.51, ["Fly|Ride"] = 137.97, ["Neon"] = 11.46, ["Neon|Ride"] = 114.83, ["Neon|Fly|Ride"] = 123.05, ["Mega"] = 91.77, ["Mega|Ride"] = 154.04}},
    ["rbxassetid://9982819219"] = {name = "Dugong", prices = {["default"] = 5.25, ["Fly"] = 112.03, ["Ride"] = 19.69, ["Fly|Ride"] = 59.06, ["Neon"] = 54.52, ["Neon|Ride"] = 67.37, ["Neon|Fly|Ride"] = 262.48, ["Mega"] = 138.01, ["Mega|Ride"] = 285.57, ["Mega|Fly|Ride"] = 395.67}},
    ["rbxassetid://3181727229"] = {name = "Buffalo", prices = {["default"] = 2.1, ["Fly"] = 15.45, ["Ride"] = 13, ["Fly|Ride"] = 32.71, ["Neon"] = 2.63, ["Neon|Fly"] = 23.62, ["Neon|Ride"] = 15.75, ["Neon|Fly|Ride"] = 40.62, ["Mega|Fly"] = 1312.5, ["Mega|Ride"] = 61.8, ["Mega|Fly|Ride"] = 98.14}},
    ["rbxassetid://99694153348188"] = {name = "Urchin", prices = {["default"] = 3.94, ["Fly"] = 171.95, ["Ride"] = 30.19, ["Neon"] = 3.82, ["Neon|Ride"] = 26.09, ["Neon|Fly|Ride"] = 131.76, ["Mega"] = 74.46, ["Mega|Fly"] = 164.77, ["Mega|Ride"] = 96.81, ["Mega|Fly|Ride"] = 262.47}},
    ["rbxassetid://84089584046947"] = {name = "Blue Butterfly", prices = {["default"] = 2.1, ["Ride"] = 27.82, ["Fly|Ride"] = 65.63, ["Neon"] = 5.07, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 137.97, ["Mega"] = 34.12, ["Mega|Fly"] = 138.01, ["Mega|Ride"] = 138.01, ["Mega|Fly|Ride"] = 303.78}},
    ["rbxassetid://124485808787576"] = {name = "Tegu", prices = {["default"] = 2.1, ["Fly"] = 30.19, ["Ride"] = 16.91, ["Neon"] = 2.1, ["Neon|Fly"] = 41.03, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 100.96, ["Mega"] = 14.44, ["Mega|Ride"] = 39.38, ["Mega|Fly|Ride"] = 158.59}},
    ["rbxassetid://8938703774"] = {name = "Bullfrog", prices = {["default"] = 2.1, ["Fly"] = 96.8, ["Ride"] = 19.59, ["Fly|Ride"] = 41.91, ["Neon"] = 5.16, ["Neon|Fly"] = 55.61, ["Neon|Ride"] = 18.55, ["Neon|Fly|Ride"] = 96.8, ["Mega"] = 65.01, ["Mega|Ride"] = 82.4, ["Mega|Fly|Ride"] = 205.96}},
    ["rbxassetid://102746202827395"] = {name = "Hopbop", prices = {["default"] = 2.1, ["Ride"] = 68.16, ["Neon"] = 3.84, ["Neon|Ride"] = 35.9, ["Neon|Fly|Ride"] = 274.93, ["Mega"] = 40.69, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 249.37}},
    ["rbxassetid://6498255997"] = {name = "Stingray", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 15.65, ["Fly|Ride"] = 44.88, ["Neon"] = 6.57, ["Neon|Fly"] = 79.97, ["Neon|Ride"] = 20.25, ["Neon|Fly|Ride"] = 83.99, ["Mega"] = 91.88, ["Mega|Ride"] = 90.57, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://13104106555"] = {name = "Mosquito", prices = {["default"] = 2.1, ["Ride"] = 67.99, ["Neon"] = 37.28, ["Neon|Ride"] = 74.15, ["Mega"] = 98.44, ["Mega|Ride"] = 205.96, ["Mega|Fly|Ride"] = 823.79}},
    ["rbxassetid://5721843483"] = {name = "Ground Sloth", prices = {["default"] = 2.63, ["Fly"] = 25.77, ["Ride"] = 17.28, ["Fly|Ride"] = 137.97, ["Neon"] = 19.46, ["Neon|Fly"] = 104.52, ["Neon|Ride"] = 30.19, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 315, ["Mega|Fly"] = 420}},
    ["rbxassetid://4506925908"] = {name = "Robin", prices = {["default"] = 14.43, ["Fly"] = 22.66, ["Ride"] = 19.59, ["Fly|Ride"] = 38.75, ["Neon"] = 19.59, ["Neon|Fly"] = 27.62, ["Neon|Ride"] = 31.4, ["Neon|Fly|Ride"] = 72.19, ["Mega"] = 274.95, ["Mega|Ride"] = 410.82, ["Mega|Fly|Ride"] = 229.69}},
    ["rbxassetid://10382786163"] = {name = "Sado Mole", prices = {["default"] = 7.56, ["Fly"] = 110.93, ["Fly|Ride"] = 137.82, ["Neon"] = 31.34, ["Neon|Ride"] = 32.82, ["Mega"] = 205.96, ["Mega|Ride"] = 236.24}},
    ["rbxassetid://14471275373"] = {name = "Ash Zebra", prices = {["default"] = 10.5, ["Ride"] = 56.44, ["Neon"] = 121.7, ["Neon|Ride"] = 205.94, ["Mega|Fly|Ride"] = 794.07}},
    ["rbxassetid://15923574361"] = {name = "Armadillo", prices = {["default"] = 2.24, ["Ride"] = 64.89, ["Neon"] = 39.1, ["Neon|Ride"] = 125.71, ["Mega"] = 253.32, ["Mega|Ride"] = 274.95}},
    ["rbxassetid://15921927876"] = {name = "Coyote", prices = {["default"] = 6.09, ["Ride"] = 30.09, ["Fly|Ride"] = 120.75, ["Neon"] = 53.44, ["Neon|Ride"] = 157.4, ["Neon|Fly|Ride"] = 179.41, ["Mega"] = 248.07, ["Mega|Ride"] = 248.06, ["Mega|Fly|Ride"] = 357.33}},
    ["rbxassetid://74353184935672"] = {name = "Sheepdog Ducky", prices = {["default"] = 2.1, ["Neon"] = 2.52, ["Neon|Ride"] = 64.99, ["Mega"] = 15.09, ["Mega|Fly"] = 123.59, ["Mega|Ride"] = 123.59, ["Mega|Fly|Ride"] = 148.29}},
    ["rbxassetid://4748889845"] = {name = "Easter 2020 Egg", prices = {["default"] = 45.94}},
    ["rbxassetid://4752655872"] = {name = "Chick", prices = {["default"] = 4.94, ["Fly"] = 22.91, ["Ride"] = 20.61, ["Fly|Ride"] = 45.94, ["Neon"] = 36.66, ["Neon|Fly"] = 188.48, ["Neon|Ride"] = 34.13, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 310.01, ["Mega|Fly"] = 329.53, ["Mega|Ride"] = 344.43, ["Mega|Fly|Ride"] = 302.7}},
    ["rbxassetid://17174085645"] = {name = "Garden Snake", prices = {["default"] = 2.1, ["Fly"] = 70.88, ["Ride"] = 19.56, ["Neon"] = 2.96, ["Neon|Ride"] = 26.61, ["Mega"] = 30.53, ["Mega|Fly"] = 138.01, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 129.94}},
    ["rbxassetid://17661844380"] = {name = "Show Pony", prices = {["default"] = 2.1, ["Fly"] = 13.13, ["Ride"] = 27.82, ["Neon"] = 5.15, ["Neon|Ride"] = 30.19, ["Neon|Fly|Ride"] = 408.98, ["Mega"] = 77.42, ["Mega|Ride"] = 72.94, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://8077196440"] = {name = "Walrus", prices = {["default"] = 2.1, ["Fly"] = 48.41, ["Ride"] = 15.68, ["Fly|Ride"] = 55.13, ["Neon"] = 6.45, ["Neon|Ride"] = 55.61, ["Neon|Fly|Ride"] = 120.65, ["Mega"] = 125.23, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 161.65}},
    ["rbxassetid://13104118499"] = {name = "Liger", prices = {["default"] = 4.38, ["Ride"] = 35.2, ["Fly|Ride"] = 62.63, ["Neon"] = 35.04, ["Neon|Ride"] = 210, ["Neon|Fly|Ride"] = 214.39, ["Mega"] = 325.41, ["Mega|Ride"] = 272.69, ["Mega|Fly|Ride"] = 411.9}},
    ["rbxassetid://120937667166493"] = {name = "Aye Aye", prices = {["default"] = 2.1, ["Fly"] = 19.59, ["Ride"] = 32.81, ["Neon"] = 3.94, ["Mega"] = 17.07, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 57.75, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://3199974297"] = {name = "Cracked Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15348350458"] = {name = "Beluga Whale", prices = {["default"] = 2.1, ["Fly"] = 21.55, ["Ride"] = 15.65, ["Fly|Ride"] = 274558.17, ["Neon"] = 3.92, ["Neon|Fly"] = 68.99, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 77.73, ["Mega"] = 27.44, ["Mega|Fly"] = 143.16, ["Mega|Ride"] = 46.41, ["Mega|Fly|Ride"] = 124.58}},
    ["rbxassetid://7126719464"] = {name = "Wolpertinger", prices = {["default"] = 2.1, ["Fly"] = 27.62, ["Ride"] = 14.38, ["Fly|Ride"] = 34.04, ["Neon"] = 4.92, ["Neon|Fly"] = 68.99, ["Neon|Ride"] = 16.49, ["Neon|Fly|Ride"] = 52.49, ["Mega"] = 47.94, ["Mega|Ride"] = 51.34, ["Mega|Fly|Ride"] = 109.05}},
    ["rbxassetid://125112456358906"] = {name = "Frankenfeline", prices = {["default"] = 2.1, ["Fly"] = 210, ["Ride"] = 26.25, ["Fly|Ride"] = 147.29, ["Neon"] = 3.71, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 110.56, ["Mega"] = 24.61, ["Mega|Fly"] = 124.11, ["Mega|Ride"] = 75.51, ["Mega|Fly|Ride"] = 160.65}},
    ["rbxassetid://80556114592490"] = {name = "Japanese Snow Fairy", prices = {["default"] = 2.1, ["Neon"] = 3.54, ["Neon|Ride"] = 164.42, ["Neon|Fly|Ride"] = 149390.45, ["Mega"] = 20.97, ["Mega|Fly"] = 106.45, ["Mega|Ride"] = 80.07, ["Mega|Fly|Ride"] = 146.22}},
    ["rbxassetid://124671555129102"] = {name = "Ratatoskr", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 20.2, ["Fly|Ride"] = 78.27, ["Neon"] = 3.92, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 22.68, ["Neon|Fly|Ride"] = 65, ["Mega"] = 19.69, ["Mega|Fly"] = 61.8, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 118.02}},
    ["rbxassetid://116184296449988"] = {name = "Pinkypillar", prices = {["default"] = 2.1, ["Neon"] = 2.63, ["Mega"] = 19.69, ["Mega|Ride"] = 224.13}},
    ["rbxassetid://74353532164157"] = {name = "Red Panda Ducky", prices = {["default"] = 2.39, ["Neon"] = 3.63, ["Neon|Ride"] = 155.43, ["Neon|Fly|Ride"] = 420, ["Mega"] = 21, ["Mega|Ride"] = 155.67}},
    ["rbxassetid://4708551264"] = {name = "Bandicoot", prices = {["default"] = 2.1, ["Fly"] = 27.57, ["Ride"] = 13.13, ["Fly|Ride"] = 41.11, ["Neon"] = 3.62, ["Neon|Fly"] = 55.61, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 136.49, ["Mega"] = 90.82, ["Mega|Ride"] = 92.64, ["Mega|Fly|Ride"] = 94.49}},
    ["rbxassetid://12480314681"] = {name = "Malaysian Tapir", prices = {["default"] = 12.95, ["Ride"] = 139.17, ["Neon"] = 123.56, ["Mega"] = 494.82, ["Mega|Ride"] = 647.07, ["Mega|Fly|Ride"] = 549.88}},
    ["rbxassetid://17482380743"] = {name = "Classic Teapot", prices = {["default"] = 2.5, ["Fly"] = 6562.5, ["Ride"] = 56.24, ["Neon"] = 54.76, ["Neon|Ride"] = 203.87, ["Mega"] = 1568.27, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://14146142724"] = {name = "Mongoose", prices = {["default"] = 7.86, ["Ride"] = 30.18, ["Fly|Ride"] = 410.17, ["Neon"] = 36.6, ["Neon|Fly|Ride"] = 261.53, ["Mega"] = 295.25, ["Mega|Ride"] = 352.17, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://3181727351"] = {name = "Dog", prices = {["default"] = 2.1, ["Fly"] = 11.33, ["Ride"] = 15.45, ["Fly|Ride"] = 24.24, ["Neon"] = 2.1, ["Neon|Fly"] = 11.71, ["Neon|Ride"] = 10.5, ["Neon|Fly|Ride"] = 27.81, ["Mega"] = 15.15, ["Mega|Fly"] = 32.34, ["Mega|Ride"] = 19.69, ["Mega|Fly|Ride"] = 46.88}},
    ["rbxassetid://14267322852"] = {name = "Angelfish", prices = {["default"] = 5.25, ["Fly"] = 118.12, ["Ride"] = 57.67, ["Fly|Ride"] = 110.18, ["Neon"] = 15.75, ["Neon|Fly"] = 89.87, ["Neon|Ride"] = 31.94, ["Neon|Fly|Ride"] = 686.75, ["Mega"] = 51.66, ["Mega|Ride"] = 118.02}},
    ["rbxassetid://110130591707207"] = {name = "California Condor", prices = {["default"] = 2.1, ["Ride"] = 31.5, ["Neon"] = 2.1, ["Neon|Fly"] = 30.78, ["Neon|Ride"] = 21.03, ["Neon|Fly|Ride"] = 55.61, ["Mega"] = 14.73, ["Mega|Fly"] = 85.72, ["Mega|Ride"] = 71.6, ["Mega|Fly|Ride"] = 98.44}},
    ["rbxassetid://123567499475377"] = {name = "Forest Sprite", prices = {["default"] = 2.1, ["Ride"] = 91.63, ["Neon"] = 2.52, ["Neon|Fly"] = 60.9, ["Neon|Ride"] = 110.18, ["Mega"] = 15.46, ["Mega|Ride"] = 102.99, ["Mega|Fly|Ride"] = 162.02}},
    ["rbxassetid://8663441035"] = {name = "Lunar White Tiger", prices = {["default"] = 2.63, ["Fly"] = 36.98, ["Ride"] = 20.58, ["Fly|Ride"] = 45.94, ["Neon"] = 10.4, ["Neon|Fly"] = 65.6, ["Neon|Ride"] = 31.37, ["Neon|Fly|Ride"] = 99.75, ["Mega"] = 208.95, ["Mega|Ride"] = 204.93, ["Mega|Fly|Ride"] = 294}},
    ["rbxassetid://16000498338"] = {name = "Groundhog", prices = {["default"] = 173.95, ["Ride"] = 196.88, ["Fly|Ride"] = 245.85, ["Neon|Ride"] = 757.32, ["Mega"] = 8237.77, ["Mega|Fly|Ride"] = 3556.67}},
    ["rbxassetid://73268582142443"] = {name = "Kelp Raider", prices = {["default"] = 2.1, ["Neon"] = 7.35, ["Neon|Ride"] = 82.39, ["Mega"] = 83.61, ["Mega|Ride"] = 124.11, ["Mega|Fly|Ride"] = 823.79}},
    ["rbxassetid://16369178617"] = {name = "Ornate Horned Frog", prices = {["default"] = 3.94, ["Fly"] = 63.67, ["Ride"] = 25.57, ["Fly|Ride"] = 62.63, ["Neon"] = 31.29, ["Neon|Ride"] = 92.8, ["Neon|Fly|Ride"] = 137.97, ["Mega"] = 357.33, ["Mega|Fly|Ride"] = 402.49}},
    ["rbxassetid://6245080170"] = {name = "Lunar Ox", prices = {["default"] = 2.1, ["Fly"] = 14.25, ["Ride"] = 14.38, ["Fly|Ride"] = 32.13, ["Neon"] = 4.75, ["Neon|Fly"] = 31.5, ["Neon|Ride"] = 29.76, ["Neon|Fly|Ride"] = 55.61, ["Mega"] = 49.68, ["Mega|Ride"] = 80.56, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://92652981666929"] = {name = "Starmite", prices = {["default"] = 2.1, ["Fly"] = 51.19, ["Ride"] = 27.57, ["Fly|Ride"] = 92.56, ["Neon"] = 6.13, ["Neon|Fly"] = 549.82, ["Neon|Ride"] = 78.47, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 96.87, ["Mega|Ride"] = 87.94, ["Mega|Fly|Ride"] = 419.99}},
    ["rbxassetid://9482496753"] = {name = "King Penguin", prices = {["default"] = 6.3, ["Fly"] = 18.19, ["Ride"] = 16.44, ["Fly|Ride"] = 35.44, ["Neon"] = 28.77, ["Neon|Fly"] = 98.85, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 74.8, ["Mega|Ride"] = 267.74, ["Mega|Fly|Ride"] = 411.9}},
    ["rbxassetid://10489161125"] = {name = "Tanuki", prices = {["default"] = 3.6, ["Ride"] = 34.21, ["Fly|Ride"] = 249.58, ["Neon"] = 54.34, ["Neon|Ride"] = 137.45, ["Neon|Fly|Ride"] = 611.6, ["Mega"] = 340.45, ["Mega|Ride"] = 255.64, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://7126720060"] = {name = "Wyvern", prices = {["default"] = 9.3, ["Fly"] = 19.59, ["Ride"] = 15.4, ["Fly|Ride"] = 41.2, ["Neon"] = 15.65, ["Neon|Fly"] = 68.99, ["Neon|Ride"] = 28.88, ["Neon|Fly|Ride"] = 75.29, ["Mega|Ride"] = 233.76, ["Mega|Fly|Ride"] = 231.81}},
    ["rbxassetid://4506925800"] = {name = "Swan", prices = {["default"] = 69.57, ["Fly"] = 170.93, ["Ride"] = 92.78, ["Fly|Ride"] = 157.4, ["Neon"] = 349.82, ["Neon|Fly"] = 437.07, ["Neon|Ride"] = 405.57, ["Neon|Fly|Ride"] = 366.87}},
    ["rbxassetid://13621428133"] = {name = "Tortuga de la Isla", prices = {["default"] = 236.25, ["Fly"] = 329.48, ["Ride"] = 231.25, ["Fly|Ride"] = 274.93, ["Neon|Ride"] = 1085.2, ["Neon|Fly|Ride"] = 1235.52, ["Mega"] = 10297.21, ["Mega|Fly|Ride"] = 4118.89}},
    ["rbxassetid://6684832189"] = {name = "Lamb", prices = {["default"] = 51.76, ["Fly"] = 110.18, ["Ride"] = 76.56, ["Fly|Ride"] = 125.9, ["Neon"] = 692.34, ["Neon|Ride"] = 328.11, ["Neon|Fly|Ride"] = 367.5, ["Mega|Ride"] = 1234.66, ["Mega|Fly|Ride"] = 1091.06}},
    ["rbxassetid://122365328950491"] = {name = "Blossom Snake", prices = {["default"] = 4.54, ["Fly"] = 26.17, ["Ride"] = 26.78, ["Fly|Ride"] = 137.97, ["Neon"] = 23.39, ["Neon|Ride"] = 72.09, ["Neon|Fly|Ride"] = 179.81, ["Mega"] = 155.5, ["Mega|Ride"] = 376.69, ["Mega|Fly|Ride"] = 263.3}},
    ["rbxassetid://14360919997"] = {name = "Toasty Red Panda", prices = {["default"] = 10.87, ["Fly"] = 68.99, ["Ride"] = 36.75, ["Fly|Ride"] = 89.59, ["Neon"] = 72.1, ["Neon|Ride"] = 96.8, ["Mega"] = 353.07, ["Mega|Ride"] = 379.5, ["Mega|Fly|Ride"] = 480.89}},
    ["rbxassetid://3181727278"] = {name = "Rabbit", prices = {["default"] = 2.1, ["Fly"] = 16.72, ["Ride"] = 17.82, ["Fly|Ride"] = 34.93, ["Neon"] = 5.25, ["Neon|Fly"] = 25.52, ["Neon|Ride"] = 20.78, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 114.6, ["Mega|Fly"] = 131.25, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 176.1}},
    ["rbxassetid://14782579567"] = {name = "Nightmare Owl", prices = {["default"] = 6.57, ["Fly"] = 27.82, ["Ride"] = 35.44, ["Fly|Ride"] = 302.87, ["Neon"] = 95.86, ["Neon|Fly"] = 343.89, ["Neon|Ride"] = 162.4, ["Neon|Fly|Ride"] = 136.29, ["Mega"] = 413.44, ["Mega|Ride"] = 616.88, ["Mega|Fly|Ride"] = 603.15}},
    ["rbxassetid://6498256342"] = {name = "Narwhal", prices = {["default"] = 2.63, ["Fly"] = 41.2, ["Ride"] = 15.89, ["Fly|Ride"] = 52.49, ["Neon"] = 15.75, ["Neon|Fly"] = 145.69, ["Neon|Ride"] = 28.65, ["Neon|Fly|Ride"] = 103.63, ["Mega|Fly"] = 87.01, ["Mega|Ride"] = 202.82, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://9227407648"] = {name = "Ibex", prices = {["default"] = 2.52, ["Ride"] = 20.46, ["Fly|Ride"] = 328.13, ["Neon"] = 25.52, ["Neon|Ride"] = 55.61, ["Mega"] = 207.37, ["Mega|Ride"] = 231.99, ["Mega|Fly|Ride"] = 421.87}},
    ["rbxassetid://16440727263"] = {name = "Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 15.45, ["Ride"] = 17.41, ["Neon"] = 2.1, ["Neon|Ride"] = 19.65, ["Neon|Fly|Ride"] = 47.38, ["Mega"] = 15, ["Mega|Fly"] = 41.21, ["Mega|Ride"] = 20.61, ["Mega|Fly|Ride"] = 209.99}},
    ["rbxassetid://10318106327"] = {name = "Yellow Butterfly", prices = {["default"] = 3.94, ["Fly"] = 17.9, ["Ride"] = 17.75, ["Fly|Ride"] = 55.61, ["Neon"] = 14.34, ["Neon|Fly"] = 34.13, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 97.91, ["Mega"] = 81.5, ["Mega|Ride"] = 99.83, ["Mega|Fly|Ride"] = 209.34}},
    ["rbxassetid://13894169749"] = {name = "Black Kite", prices = {["default"] = 2.52, ["Fly"] = 24.94, ["Ride"] = 18.41, ["Fly|Ride"] = 58.7, ["Neon"] = 24.73, ["Neon|Ride"] = 47.25, ["Neon|Fly|Ride"] = 549.82, ["Mega"] = 283.5, ["Mega|Ride"] = 191.55, ["Mega|Fly|Ride"] = 221.55}},
    ["rbxassetid://4506925595"] = {name = "Polar Bear", prices = {["default"] = 140.87, ["Fly"] = 274.93, ["Ride"] = 232.71, ["Fly|Ride"] = 301.88, ["Neon"] = 549.82, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 723.14, ["Mega|Fly|Ride"] = 2746.28}},
    ["rbxassetid://14639006189"] = {name = "Canada Goose", prices = {["default"] = 17.07, ["Ride"] = 31.8, ["Fly|Ride"] = 206.07, ["Neon"] = 66.94, ["Neon|Ride"] = 138.42, ["Neon|Fly|Ride"] = 376.56, ["Mega"] = 343.94, ["Mega|Ride"] = 296.63, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://5721844402"] = {name = "Triceratops", prices = {["default"] = 2.52, ["Fly"] = 15.65, ["Ride"] = 24.04, ["Fly|Ride"] = 45.29, ["Neon"] = 20.3, ["Neon|Ride"] = 25.55, ["Neon|Fly|Ride"] = 104.81, ["Mega"] = 308.44, ["Mega|Ride"] = 244.83, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://83805820117149"] = {name = "Golden Jaguar", prices = {["default"] = 23.63, ["Ride"] = 58.02, ["Fly|Ride"] = 170.63, ["Neon"] = 98.44, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 464.03, ["Mega"] = 491.12, ["Mega|Fly"] = 823.79, ["Mega|Ride"] = 472.5, ["Mega|Fly|Ride"] = 1029.73}},
    ["rbxassetid://13936754497"] = {name = "Pinocchio", prices = {["default"] = 5.25}},
    ["rbxassetid://17059776562"] = {name = "Ankylosaurus", prices = {["default"] = 15.75, ["Ride"] = 28.5, ["Neon"] = 23.63, ["Neon|Ride"] = 273.93, ["Neon|Fly|Ride"] = 617.76, ["Mega"] = 823.79, ["Mega|Ride"] = 308.94, ["Mega|Fly|Ride"] = 821.73}},
    ["rbxassetid://3181727813"] = {name = "Horse", prices = {["default"] = 24.83, ["Fly"] = 35.49, ["Ride"] = 30.84, ["Fly|Ride"] = 52.48, ["Neon|Fly"] = 101818.18, ["Neon|Ride"] = 161, ["Neon|Fly|Ride"] = 135.93, ["Mega"] = 2059.45, ["Mega|Fly|Ride"] = 1923.53}},
    ["rbxassetid://101098195340953"] = {name = "Mexican Wolf", prices = {["default"] = 2.1, ["Ride"] = 19.59, ["Fly|Ride"] = 102.98, ["Neon"] = 3.94, ["Neon|Ride"] = 49.89, ["Neon|Fly|Ride"] = 106.25, ["Mega"] = 32.17, ["Mega|Fly"] = 274.95, ["Mega|Ride"] = 131.82, ["Mega|Fly|Ride"] = 226.7}},
    ["rbxassetid://13894408663"] = {name = "Seagull", prices = {["default"] = 6.57, ["Fly"] = 28.09, ["Ride"] = 26.7, ["Fly|Ride"] = 61.79, ["Neon"] = 45.55, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 231.98, ["Mega"] = 231.99, ["Mega|Fly"] = 387.41, ["Mega|Ride"] = 203.44, ["Mega|Fly|Ride"] = 329.53}},
    ["rbxassetid://6998403532"] = {name = "Sasquatch", prices = {["default"] = 2.63, ["Fly"] = 32.82, ["Ride"] = 17.41, ["Fly|Ride"] = 46.1, ["Neon"] = 23.63, ["Neon|Fly"] = 186.9, ["Neon|Ride"] = 28.59, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 157.5, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 209.69}},
    ["rbxassetid://108348392849720"] = {name = "Water Opossum", prices = {["default"] = 2.1, ["Ride"] = 34.35, ["Fly|Ride"] = 205.94, ["Neon"] = 3.94, ["Neon|Ride"] = 22.43, ["Neon|Fly|Ride"] = 411.86, ["Mega"] = 35.44, ["Mega|Ride"] = 52.41, ["Mega|Fly|Ride"] = 193.72}},
    ["rbxassetid://11758575705"] = {name = "Moon Rabbit", prices = {["default"] = 34.97, ["Ride"] = 86.63, ["Fly|Ride"] = 525, ["Neon"] = 262.5, ["Neon|Ride"] = 229.69, ["Neon|Fly|Ride"] = 619.35, ["Mega"] = 799.99, ["Mega|Fly|Ride"] = 840}},
    ["rbxassetid://15922874831"] = {name = "Roadrunner", prices = {["default"] = 3.94, ["Ride"] = 32.82, ["Fly|Ride"] = 210, ["Neon"] = 81.94, ["Neon|Ride"] = 92.8, ["Mega|Ride"] = 524.99, ["Mega|Fly|Ride"] = 463.97}},
    ["rbxassetid://6060988175"] = {name = "Snowman", prices = {["default"] = 42, ["Fly"] = 209.99, ["Ride"] = 27.77, ["Fly|Ride"] = 61.52, ["Neon"] = 91.25, ["Neon|Fly"] = 463.91, ["Neon|Ride"] = 85.32, ["Neon|Fly|Ride"] = 85.32, ["Mega"] = 339.94, ["Mega|Ride"] = 308.94, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://12720029414"] = {name = "Wood Pigeon", prices = {["default"] = 72.19, ["Fly"] = 433.12, ["Ride"] = 179.17, ["Fly|Ride"] = 262.44, ["Neon"] = 315, ["Neon|Ride"] = 411.86, ["Mega|Ride"] = 2100, ["Mega|Fly|Ride"] = 1836.18}},
    ["rbxassetid://136340738568203"] = {name = "Mr Whiskerpips", prices = {["default"] = 15.45, ["Fly"] = 45.93, ["Ride"] = 30.9, ["Fly|Ride"] = 55.61, ["Neon"] = 48.07, ["Neon|Ride"] = 64.32, ["Neon|Fly|Ride"] = 129.74, ["Mega"] = 262.45, ["Mega|Ride"] = 261.19, ["Mega|Fly|Ride"] = 395.43}},
    ["rbxassetid://127204329704553"] = {name = "German Shepherd", prices = {["default"] = 89.58, ["Fly"] = 145.69, ["Ride"] = 109.04, ["Fly|Ride"] = 144.38, ["Neon"] = 241.5, ["Neon|Fly"] = 525, ["Neon|Ride"] = 228.38, ["Neon|Fly|Ride"] = 406.75, ["Mega"] = 1069.89, ["Mega|Ride"] = 1090.49, ["Mega|Fly|Ride"] = 1039.5}},
    ["rbxassetid://99868640713300"] = {name = "Puptune", prices = {["default"] = 52.5, ["Fly"] = 126.66, ["Ride"] = 74.82, ["Fly|Ride"] = 131.25, ["Neon"] = 85.22, ["Neon|Ride"] = 148.64, ["Neon|Fly|Ride"] = 823.7, ["Mega"] = 470.96, ["Mega|Ride"] = 309.75, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://9993276067"] = {name = "2022 Uplift Butterfly", prices = {["default"] = 8.33, ["Ride"] = 27.57, ["Fly|Ride"] = 67.28, ["Neon"] = 52.41, ["Neon|Ride"] = 77.73, ["Neon|Fly|Ride"] = 248.22, ["Mega"] = 416.96, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://136574776317301"] = {name = "Sweetheart Rat", prices = {["default"] = 16.67, ["Ride"] = 109.26, ["Fly|Ride"] = 161.13, ["Neon"] = 96.8, ["Neon|Ride"] = 144.38, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 256.14, ["Mega|Ride"] = 259.77, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://17649489402"] = {name = "Cow Calf", prices = {["default"] = 12.41, ["Ride"] = 35.02, ["Fly|Ride"] = 55.73, ["Neon"] = 41.76, ["Neon|Ride"] = 69.47, ["Neon|Fly|Ride"] = 155.43, ["Mega"] = 236.25, ["Mega|Ride"] = 261.57, ["Mega|Fly|Ride"] = 408.19}},
    ["rbxassetid://77869404304609"] = {name = "Budgie Witch", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Fly"] = 22.66, ["Neon|Ride"] = 57.1, ["Mega"] = 15.1, ["Mega|Ride"] = 102.99, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://111676861947081"] = {name = "The Black Dog", prices = {["default"] = 2.63, ["Ride"] = 28.25, ["Neon"] = 21.67, ["Neon|Fly"] = 123.56, ["Neon|Ride"] = 124.69, ["Neon|Fly|Ride"] = 202.78, ["Mega"] = 96.39, ["Mega|Ride"] = 203.89, ["Mega|Fly|Ride"] = 466.29}},
    ["rbxassetid://13104122472"] = {name = "Borhyaena Gigantica", prices = {["default"] = 2.63, ["Neon"] = 24.86, ["Mega"] = 196.88, ["Mega|Ride"] = 138.01, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://105232492496005"] = {name = "Firefighter Gibbon", prices = {["default"] = 3.94, ["Ride"] = 32.79, ["Fly|Ride"] = 115.98, ["Neon"] = 20.89, ["Neon|Ride"] = 82.39, ["Mega"] = 123.44, ["Mega|Ride"] = 205.96, ["Mega|Fly|Ride"] = 348.5}},
    ["rbxassetid://3409443514"] = {name = "Elephant", prices = {["default"] = 551.25, ["Ride"] = 544.88, ["Fly|Ride"] = 619.26, ["Neon"] = 1785.32, ["Neon|Ride"] = 1784.04, ["Neon|Fly|Ride"] = 1640.63, ["Mega|Fly|Ride"] = 5880}},
    ["rbxassetid://10137833682"] = {name = "Brown-Chested Pheasant", prices = {["default"] = 7.6, ["Fly"] = 27.82, ["Ride"] = 23.7, ["Fly|Ride"] = 62.63, ["Neon"] = 37.08, ["Neon|Ride"] = 96.8, ["Neon|Fly|Ride"] = 341.25, ["Mega"] = 155.44, ["Mega|Ride"] = 354.95, ["Mega|Fly|Ride"] = 482.52}},
    ["rbxassetid://12490691849"] = {name = "Gecko", prices = {["default"] = 19.69, ["Fly"] = 524.58, ["Ride"] = 27.89, ["Fly|Ride"] = 51.35, ["Neon"] = 56.27, ["Neon|Fly"] = 315, ["Neon|Ride"] = 96.8, ["Neon|Fly|Ride"] = 156.4, ["Mega"] = 303.78, ["Mega|Ride"] = 362.62, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://9913459163"] = {name = "Trapdoor Snail", prices = {["default"] = 2.63, ["Fly"] = 91.88, ["Ride"] = 16.44, ["Fly|Ride"] = 61.69, ["Neon"] = 16.49, ["Neon|Ride"] = 196.88, ["Mega"] = 263.3, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://124413732651376"] = {name = "Gumball Caterpillar", prices = {["default"] = 2.1, ["Fly"] = 65.58, ["Ride"] = 26.69, ["Fly|Ride"] = 90.57, ["Neon"] = 10.5, ["Neon|Ride"] = 37.76, ["Neon|Fly|Ride"] = 105.6, ["Mega"] = 57.78, ["Mega|Fly"] = 211.78, ["Mega|Ride"] = 145.09, ["Mega|Fly|Ride"] = 251.27}},
    ["rbxassetid://96107383056013"] = {name = "Gummy Guana", prices = {["default"] = 2.1, ["Fly"] = 68.99, ["Ride"] = 19.69, ["Neon"] = 3.94, ["Neon|Ride"] = 24.05, ["Neon|Fly|Ride"] = 89.14, ["Mega"] = 32.82, ["Mega|Fly"] = 192.57, ["Mega|Ride"] = 151.38, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://3261465951"] = {name = "Blue Egg", prices = {["default"] = 1107.75}},
    ["rbxassetid://11245006051"] = {name = "Therapy Dog", prices = {["default"] = 8.03, ["Ride"] = 48.2, ["Fly|Ride"] = 323.64, ["Neon"] = 65.63, ["Neon|Ride"] = 89.25, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 411.9}},
    ["rbxassetid://76323474173289"] = {name = "Kelp Crewmate", prices = {["default"] = 2.1, ["Ride"] = 24.05, ["Neon"] = 6.57, ["Neon|Ride"] = 74.15, ["Neon|Fly|Ride"] = 982.1, ["Mega"] = 41.21, ["Mega|Ride"] = 155.5, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://14978701264"] = {name = "Scarecrow Horse", prices = {["default"] = 5.25, ["Fly"] = 27.57, ["Ride"] = 20.61, ["Fly|Ride"] = 99.75, ["Neon"] = 13.02, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 137.47, ["Neon|Fly|Ride"] = 155.7, ["Mega"] = 183.73, ["Mega|Ride"] = 274.32, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://3409443801"] = {name = "Lion", prices = {["default"] = 461.51, ["Ride"] = 523.68, ["Fly|Ride"] = 556.07, ["Neon|Ride"] = 1785.32, ["Neon|Fly|Ride"] = 1509.38, ["Mega|Fly|Ride"] = 8100.83}},
    ["rbxassetid://13979014954"] = {name = "Fossa", prices = {["default"] = 10.4, ["Fly"] = 196.88, ["Ride"] = 109.15, ["Fly|Ride"] = 411.86, ["Neon"] = 123.56, ["Neon|Ride"] = 73.63, ["Neon|Fly|Ride"] = 185.99, ["Mega"] = 469.58, ["Mega|Ride"] = 393.75}},
    ["rbxassetid://137886461285917"] = {name = "Angus Cow", prices = {["default"] = 2.1, ["Fly"] = 80.32, ["Ride"] = 31.37, ["Fly|Ride"] = 162.69, ["Neon"] = 7.88, ["Neon|Ride"] = 27.82, ["Neon|Fly|Ride"] = 99.96, ["Mega"] = 53.82, ["Mega|Fly"] = 189, ["Mega|Ride"] = 102.08, ["Mega|Fly|Ride"] = 245.9}},
    ["rbxassetid://128343324254978"] = {name = "Blue Cat", prices = {["default"] = 2.1, ["Neon"] = 3.29, ["Neon|Ride"] = 127.32, ["Neon|Fly|Ride"] = 274.93, ["Mega"] = 30.19, ["Mega|Ride"] = 130.76, ["Mega|Fly|Ride"] = 220.38}},
    ["rbxassetid://79274485636628"] = {name = "Indian Flying Fox", prices = {["default"] = 15.28, ["Fly"] = 107.63, ["Ride"] = 68.83, ["Fly|Ride"] = 77.72, ["Neon"] = 117.5, ["Neon|Ride"] = 85.22, ["Neon|Fly|Ride"] = 343.89, ["Mega"] = 469.25, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 589.92}},
    ["rbxassetid://96039704958671"] = {name = "Singularity Pisces", prices = {["default"] = 7.88, ["Neon"] = 109.04, ["Neon|Ride"] = 123.56, ["Neon|Fly|Ride"] = 141.65, ["Mega"] = 422.2, ["Mega|Ride"] = 479.73, ["Mega|Fly|Ride"] = 1647.57}},
    ["rbxassetid://12489494348"] = {name = "Komodo Dragon", prices = {["default"] = 6.17, ["Ride"] = 44.29, ["Fly|Ride"] = 411.86, ["Neon"] = 309.66, ["Neon|Ride"] = 174.7, ["Mega"] = 634.47, ["Mega|Ride"] = 632.27, ["Mega|Fly|Ride"] = 1235.68}},
    ["rbxassetid://14360919129"] = {name = "Flaming Zebra", prices = {["default"] = 15.75, ["Ride"] = 22.67, ["Fly|Ride"] = 262.5, ["Neon"] = 274.93, ["Neon|Ride"] = 177.51, ["Neon|Fly|Ride"] = 199.29, ["Mega"] = 610.32, ["Mega|Ride"] = 647.73, ["Mega|Fly|Ride"] = 665.44}},
    ["rbxassetid://108242367048842"] = {name = "Honey Badger", prices = {["default"] = 328.12, ["Fly"] = 463.93, ["Ride"] = 467.44, ["Fly|Ride"] = 617.76, ["Neon"] = 1029.61, ["Neon|Ride"] = 1083.28, ["Neon|Fly|Ride"] = 1233.75, ["Mega|Fly|Ride"] = 4448.4}},
    ["rbxassetid://11119262646"] = {name = "Evil Chickatrice", prices = {["default"] = 5.13, ["Fly"] = 69.65, ["Ride"] = 22.66, ["Fly|Ride"] = 236.25, ["Neon"] = 114.95, ["Neon|Fly"] = 185.07, ["Neon|Ride"] = 164.06, ["Neon|Fly|Ride"] = 185.58, ["Mega|Ride"] = 543.72, ["Mega|Fly|Ride"] = 850.56}},
    ["rbxassetid://120631772928905"] = {name = "Subzero Scorpion", prices = {["default"] = 3.84, ["Fly|Ride"] = 127.32, ["Neon"] = 36.75, ["Neon|Ride"] = 221.82, ["Mega"] = 218.31, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 787.49}},
    ["rbxassetid://70394243440806"] = {name = "Ghostly Cat", prices = {["default"] = 17.07, ["Ride"] = 70.88, ["Fly|Ride"] = 256.3, ["Neon"] = 77.72, ["Neon|Ride"] = 120.75, ["Neon|Fly|Ride"] = 393.74, ["Mega"] = 272.35, ["Mega|Fly"] = 686.83, ["Mega|Ride"] = 275.61, ["Mega|Fly|Ride"] = 370.47}},
    ["rbxassetid://108186720416551"] = {name = "Storm Condor", prices = {["default"] = 2.63, ["Ride"] = 52.5, ["Fly|Ride"] = 137.97, ["Neon"] = 6.56, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 205.94, ["Mega"] = 44.63, ["Mega|Ride"] = 96.81, ["Mega|Fly|Ride"] = 303.19}},
    ["rbxassetid://11181152874"] = {name = "Mule", prices = {["default"] = 46.83, ["Ride"] = 57.67, ["Fly|Ride"] = 157.5, ["Neon"] = 274.93, ["Neon|Ride"] = 303.75, ["Mega"] = 1373.66, ["Mega|Ride"] = 1126.54, ["Mega|Fly|Ride"] = 1023.75}},
    ["rbxassetid://94781392732758"] = {name = "Onza", prices = {["default"] = 2.1, ["Fly"] = 579.91, ["Ride"] = 27.53, ["Neon"] = 6.46, ["Neon|Fly"] = 179.17, ["Neon|Ride"] = 63.66, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 66.27, ["Mega|Ride"] = 100.92, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://102763887893057"] = {name = "Cherub Chipmunk", prices = {["default"] = 2.1, ["Fly"] = 35.97, ["Ride"] = 27.57, ["Fly|Ride"] = 151.28, ["Neon"] = 6.46, ["Neon|Fly"] = 49.38, ["Neon|Ride"] = 40.84, ["Neon|Fly|Ride"] = 137.97, ["Mega"] = 155.44, ["Mega|Fly"] = 112.88, ["Mega|Ride"] = 73.4, ["Mega|Fly|Ride"] = 170.36}},
    ["rbxassetid://104845330408668"] = {name = "Icy Porcupine", prices = {["default"] = 2.1, ["Ride"] = 31.32, ["Fly|Ride"] = 122.93, ["Neon"] = 15.1, ["Neon|Ride"] = 55.61, ["Neon|Fly|Ride"] = 177.19, ["Mega"] = 81.38, ["Mega|Fly"] = 459.38, ["Mega|Ride"] = 108.94, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://12597275903"] = {name = "White Sand Dollar", prices = {["default"] = 49.88, ["Fly"] = 92.79, ["Ride"] = 78.66, ["Fly|Ride"] = 193.68, ["Neon"] = 291.38, ["Neon|Ride"] = 285.63, ["Neon|Fly|Ride"] = 412.56, ["Mega|Ride"] = 1029.73, ["Mega|Fly|Ride"] = 1048.69}},
    ["rbxassetid://9901393350"] = {name = "Irish Water Spaniel", prices = {["default"] = 255.94, ["Ride"] = 288.75, ["Fly|Ride"] = 418.69, ["Neon"] = 1431.15, ["Neon|Ride"] = 1139.14, ["Neon|Fly|Ride"] = 1237.6, ["Mega"] = 6178.33, ["Mega|Fly|Ride"] = 5258.88}},
    ["rbxassetid://128640048014369"] = {name = "River Otter", prices = {["default"] = 14.95, ["Neon"] = 34.13, ["Neon|Ride"] = 143.83, ["Mega"] = 103.83, ["Mega|Fly"] = 227.59, ["Mega|Ride"] = 210.3, ["Mega|Fly|Ride"] = 686.83}},
    ["rbxassetid://138984599254588"] = {name = "Tree Sasquatch", prices = {["default"] = 2.63, ["Fly"] = 68.99, ["Ride"] = 28.46, ["Fly|Ride"] = 155.4, ["Neon"] = 10.5, ["Neon|Ride"] = 43.89, ["Neon|Fly|Ride"] = 179.19, ["Mega"] = 76.13, ["Mega|Fly"] = 210, ["Mega|Ride"] = 102.38, ["Mega|Fly|Ride"] = 343.94}},
    ["rbxassetid://15870220155"] = {name = "Vulture", prices = {["default"] = 6.56, ["Fly"] = 30.17, ["Ride"] = 27.56, ["Fly|Ride"] = 175.05, ["Neon"] = 32.81, ["Neon|Ride"] = 68.99, ["Mega"] = 373.42, ["Mega|Ride"] = 344.74, ["Mega|Fly|Ride"] = 576.66}},
    ["rbxassetid://7734902490"] = {name = "Halloween Black Mummy Cat", prices = {["default"] = 2.3, ["Fly"] = 64.55, ["Ride"] = 63.86, ["Neon"] = 7.88, ["Neon|Ride"] = 34.55, ["Neon|Fly|Ride"] = 138.15, ["Mega"] = 91.88, ["Mega|Fly"] = 146.24, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 259.5}},
    ["rbxassetid://116677376014234"] = {name = "Sunflower Friend", prices = {["default"] = 2.63, ["Ride"] = 67.97, ["Neon"] = 8.93, ["Mega"] = 31.5, ["Mega|Ride"] = 205.96, ["Mega|Fly|Ride"] = 271.87}},
    ["rbxassetid://13186022212"] = {name = "Grinmoire", prices = {["default"] = 2.1, ["Fly"] = 65.54, ["Ride"] = 16.71, ["Fly|Ride"] = 42, ["Neon"] = 6.21, ["Neon|Ride"] = 22.66, ["Neon|Fly|Ride"] = 102.08, ["Mega"] = 105, ["Mega|Ride"] = 99.77, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://11119263014"] = {name = "Chickatrice", prices = {["default"] = 2.63, ["Fly"] = 137.61, ["Ride"] = 24.94, ["Fly|Ride"] = 58.57, ["Neon"] = 16.01, ["Neon|Fly"] = 63.67, ["Neon|Ride"] = 28.88, ["Neon|Fly|Ride"] = 85.32, ["Mega"] = 101.96, ["Mega|Ride"] = 232.73, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://13104110160"] = {name = "Blue Ringed Octopus", prices = {["default"] = 26.61, ["Ride"] = 52.53, ["Fly|Ride"] = 77.16, ["Neon"] = 131.25, ["Mega"] = 575.63, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://16088265753"] = {name = "Flaming Fox", prices = {["default"] = 63.95, ["Fly"] = 110.18, ["Ride"] = 102.98, ["Fly|Ride"] = 114.3, ["Neon"] = 439.69, ["Neon|Fly"] = 430.64, ["Neon|Ride"] = 454.07, ["Neon|Fly|Ride"] = 434.35, ["Mega"] = 1470, ["Mega|Ride"] = 3254.99, ["Mega|Fly|Ride"] = 1417.5}},
    ["rbxassetid://84105347355723"] = {name = "Gibbon", prices = {["default"] = 2.1, ["Ride"] = 17.85, ["Fly|Ride"] = 131.25, ["Neon"] = 5.67, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 27.56, ["Neon|Fly|Ride"] = 138.01, ["Mega"] = 49.26, ["Mega|Fly"] = 672, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://9543194411"] = {name = "Swordfish", prices = {["default"] = 2.1, ["Fly"] = 15.45, ["Ride"] = 15.73, ["Fly|Ride"] = 39.37, ["Neon"] = 4.66, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 49.88, ["Mega"] = 61.01, ["Mega|Fly"] = 131.2, ["Mega|Ride"] = 65.61, ["Mega|Fly|Ride"] = 124.69}},
    ["rbxassetid://11706157391"] = {name = "Steppe Lion", prices = {["default"] = 6.56, ["Fly"] = 35.02, ["Ride"] = 73.48, ["Neon"] = 35.44, ["Neon|Ride"] = 69.61, ["Neon|Fly|Ride"] = 273.89, ["Mega"] = 527.63, ["Mega|Ride"] = 541.68, ["Mega|Fly|Ride"] = 636.57}},
    ["rbxassetid://18119064023"] = {name = "Bald Eagle", prices = {["default"] = 388.63, ["Fly"] = 518.44, ["Ride"] = 578.39, ["Fly|Ride"] = 492.19, ["Neon"] = 4118.38, ["Neon|Ride"] = 1923.29, ["Mega|Fly|Ride"] = 7208.04}},
    ["rbxassetid://6060991172"] = {name = "Lynx", prices = {["default"] = 40.15, ["Fly"] = 96.8, ["Ride"] = 43.09, ["Fly|Ride"] = 91.88, ["Neon"] = 170.63, ["Neon|Ride"] = 162.69, ["Neon|Fly|Ride"] = 185.59, ["Mega|Ride"] = 1235.68, ["Mega|Fly|Ride"] = 985.91}},
    ["rbxassetid://10614198346"] = {name = "Pomeranian", prices = {["default"] = 2.1, ["Ride"] = 36.05, ["Fly|Ride"] = 281.29, ["Neon"] = 7.88, ["Neon|Ride"] = 42.58, ["Neon|Fly|Ride"] = 169.32, ["Mega"] = 86.71, ["Mega|Ride"] = 167.04, ["Mega|Fly|Ride"] = 272.99}},
    ["rbxassetid://13663102008"] = {name = "Angler Fish", prices = {["default"] = 2.63, ["Fly"] = 205.94, ["Ride"] = 65.61, ["Fly|Ride"] = 142.7, ["Neon"] = 17.2, ["Neon|Ride"] = 68.99}},
    ["rbxassetid://5067925193"] = {name = "Toy Monkey", prices = {["default"] = 25.52, ["Fly"] = 76.2, ["Ride"] = 35.02, ["Fly|Ride"] = 82.39, ["Neon|Ride"] = 301.88, ["Neon|Fly|Ride"] = 264.99, ["Mega"] = 2471.34, ["Mega|Ride"] = 1050, ["Mega|Fly|Ride"] = 1303.64}},
    ["rbxassetid://15698960105"] = {name = "Kookaburra", prices = {["default"] = 55.13, ["Fly"] = 117.39, ["Ride"] = 99.75, ["Fly|Ride"] = 123.56, ["Neon"] = 430.1, ["Neon|Ride"] = 467.44, ["Neon|Fly|Ride"] = 463.95, ["Mega"] = 8237.77, ["Mega|Fly|Ride"] = 2053.28}},
    ["rbxassetid://14266900917"] = {name = "Ring-tailed Lemur", prices = {["default"] = 223.12, ["Ride"] = 279.69, ["Fly|Ride"] = 509.25, ["Neon|Ride"] = 1365, ["Neon|Fly|Ride"] = 1256.73, ["Mega|Fly|Ride"] = 4462.5}},
    ["rbxassetid://10467419131"] = {name = "Leopard Cat", prices = {["default"] = 13.57, ["Fly"] = 51.19, ["Ride"] = 61.69, ["Fly|Ride"] = 150.94, ["Neon"] = 76.13, ["Neon|Ride"] = 96.8, ["Neon|Fly|Ride"] = 214.17, ["Mega"] = 402.73, ["Mega|Ride"] = 384.22, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://6498256485"] = {name = "Crab", prices = {["default"] = 2.1, ["Fly"] = 17.2, ["Ride"] = 17.36, ["Fly|Ride"] = 41.9, ["Neon"] = 9.49, ["Neon|Ride"] = 22.32, ["Neon|Fly|Ride"] = 91.11, ["Mega"] = 85.85, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 165.27}},
    ["rbxassetid://5721843587"] = {name = "Glyptodon", prices = {["default"] = 5.25, ["Fly"] = 15.75, ["Ride"] = 40.17, ["Fly|Ride"] = 41.42, ["Neon"] = 31.34, ["Neon|Ride"] = 38.07, ["Neon|Fly|Ride"] = 93, ["Mega"] = 343.94, ["Mega|Ride"] = 327.47, ["Mega|Fly|Ride"] = 350.13}},
    ["rbxassetid://13979141397"] = {name = "Giant Anteater", prices = {["default"] = 334.68, ["Fly"] = 480.83, ["Ride"] = 411.86, ["Fly|Ride"] = 609.53, ["Neon|Ride"] = 2150.35, ["Neon|Fly|Ride"] = 1781.07, ["Mega|Fly|Ride"] = 4832.26}},
    ["rbxassetid://109730629255705"] = {name = "Ruddy Duck", prices = {["default"] = 2.1, ["Ride"] = 59.73, ["Neon"] = 9.19, ["Neon|Ride"] = 68.99, ["Neon|Fly|Ride"] = 118125, ["Mega"] = 63, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 447.99}},
    ["rbxassetid://6498259006"] = {name = "Clownfish", prices = {["default"] = 7.87, ["Fly"] = 41.2, ["Ride"] = 15.45, ["Fly|Ride"] = 45.85, ["Neon"] = 49.88, ["Neon|Ride"] = 31.54, ["Neon|Fly|Ride"] = 78.74, ["Mega"] = 191.55, ["Mega|Fly"] = 204.93, ["Mega|Ride"] = 192.31, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://11758569695"] = {name = "Amami Rabbit", prices = {["default"] = 17.07, ["Ride"] = 117.39, ["Neon"] = 114.97, ["Neon|Fly"] = 411.86, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 433.78, ["Mega"] = 522.41, ["Mega|Ride"] = 611.67, ["Mega|Fly|Ride"] = 519.75}},
    ["rbxassetid://11505509482"] = {name = "Ice Wolf", prices = {["default"] = 115.97, ["Fly"] = 210.06, ["Ride"] = 102.38, ["Fly|Ride"] = 164.75, ["Neon"] = 637.32, ["Neon|Ride"] = 695.9, ["Neon|Fly|Ride"] = 393.74, ["Mega|Fly|Ride"] = 2378.25}},
    ["rbxassetid://9994480266"] = {name = "Royal Palace Spaniel", prices = {["default"] = 19.69, ["Fly"] = 35.02, ["Ride"] = 27.77, ["Fly|Ride"] = 61.79, ["Neon"] = 85.32, ["Neon|Ride"] = 103.69, ["Neon|Fly|Ride"] = 159.62, ["Mega"] = 632.27, ["Mega|Ride"] = 507.66, ["Mega|Fly|Ride"] = 526.32}},
    ["rbxassetid://100897154120273"] = {name = "Clumpty", prices = {["default"] = 2.1, ["Ride"] = 28.88, ["Neon"] = 2.63, ["Neon|Ride"] = 63, ["Neon|Fly|Ride"] = 686.75, ["Mega"] = 21.67, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://11108831285"] = {name = "Ocelot", prices = {["default"] = 2.1, ["Fly"] = 39.37, ["Ride"] = 15.75, ["Fly|Ride"] = 72.19, ["Neon"] = 3.89, ["Neon|Ride"] = 20.61, ["Neon|Fly|Ride"] = 70.88, ["Mega"] = 25.39, ["Mega|Fly"] = 97.12, ["Mega|Ride"] = 46.18, ["Mega|Fly|Ride"] = 96.81}},
    ["rbxassetid://99323773370664"] = {name = "Dire Wolf", prices = {["default"] = 10.5, ["Fly"] = 411.86, ["Ride"] = 82.39, ["Fly|Ride"] = 97.83, ["Neon"] = 38.85, ["Neon|Ride"] = 80.34, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 153.22, ["Mega|Ride"] = 212.22, ["Mega|Fly|Ride"] = 387.19}},
    ["rbxassetid://17649307413"] = {name = "Mini Pig", prices = {["default"] = 1389.7, ["Fly"] = 1530.94, ["Ride"] = 1271.82, ["Fly|Ride"] = 1332.53, ["Neon"] = 4200, ["Neon|Ride"] = 3609.38, ["Neon|Fly|Ride"] = 3609.38, ["Mega|Fly|Ride"] = 11517.19}},
    ["rbxassetid://12720029753"] = {name = "Border Collie", prices = {["default"] = 492.19, ["Ride"] = 522.96, ["Fly|Ride"] = 590.63, ["Neon"] = 2417.49, ["Neon|Ride"] = 1031.08, ["Neon|Fly|Ride"] = 2055.2, ["Mega"] = 16475.52, ["Mega|Fly|Ride"] = 9336.49}},
    ["rbxassetid://4440866760"] = {name = "Pig", prices = {["default"] = 353.07, ["Ride"] = 375.69, ["Fly|Ride"] = 459.38, ["Neon"] = 736.44, ["Neon|Fly"] = 1237.44, ["Neon|Ride"] = 761.04, ["Neon|Fly|Ride"] = 786.19, ["Mega|Fly|Ride"] = 2915.64}},
    ["rbxassetid://4506925854"] = {name = "Arctic Fox", prices = {["default"] = 320.66, ["Fly"] = 411.86, ["Ride"] = 350.81, ["Fly|Ride"] = 385.08, ["Neon"] = 925.32, ["Neon|Fly"] = 1373.49, ["Neon|Ride"] = 1044.03, ["Neon|Fly|Ride"] = 1093.43, ["Mega|Fly|Ride"] = 4633.76}},
    ["rbxassetid://11758575618"] = {name = "Black Moon Bear", prices = {["default"] = 2.1, ["Fly"] = 57.75, ["Ride"] = 16.9, ["Fly|Ride"] = 38.07, ["Neon"] = 5.75, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 105, ["Mega"] = 77.73, ["Mega|Ride"] = 114.19, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://15547272520"] = {name = "Christmas Pudding Pup", prices = {["default"] = 354.38, ["Fly"] = 1373.49, ["Ride"] = 438.36, ["Fly|Ride"] = 556.85, ["Neon"] = 1680, ["Neon|Ride"] = 1365, ["Neon|Fly|Ride"] = 1383.76, ["Mega|Ride"] = 6590.21, ["Mega|Fly|Ride"] = 4462.5}},
    ["rbxassetid://78519945248690"] = {name = "Zombie Chick", prices = {["default"] = 3.94, ["Fly"] = 157.5, ["Ride"] = 27.57, ["Fly|Ride"] = 62.63, ["Neon"] = 13.12, ["Neon|Ride"] = 48.57, ["Neon|Fly|Ride"] = 205.94, ["Mega"] = 81.29, ["Mega|Ride"] = 183.35, ["Mega|Fly|Ride"] = 365.57}},
    ["rbxassetid://10357178561"] = {name = "Ibis", prices = {["default"] = 2.1, ["Fly"] = 20.46, ["Ride"] = 13.13, ["Fly|Ride"] = 39.38, ["Neon"] = 7.88, ["Neon|Ride"] = 27.72, ["Neon|Fly|Ride"] = 110.42, ["Mega"] = 104.9, ["Mega|Ride"] = 192.93}},
    ["rbxassetid://96759122303055"] = {name = "Clubtail Dragonfly", prices = {["default"] = 2.1, ["Neon"] = 3.94, ["Neon|Ride"] = 39.37, ["Neon|Fly|Ride"] = 155.43, ["Mega"] = 24.94, ["Mega|Ride"] = 196.77}},
    ["rbxassetid://12778628897"] = {name = "Karate Gorilla", prices = {["default"] = 37.11, ["Fly|Ride"] = 459.38, ["Neon"] = 210, ["Neon|Ride"] = 351.29, ["Mega|Ride"] = 927.91, ["Mega|Fly|Ride"] = 773.07}},
    ["rbxassetid://13104121371"] = {name = "Poison Dart Frog", prices = {["default"] = 2.1, ["Fly"] = 7732.32, ["Ride"] = 25.2, ["Fly|Ride"] = 65.55, ["Neon"] = 31.5, ["Neon|Ride"] = 77.73, ["Mega|Ride"] = 308.94, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://71881209536633"] = {name = "Humbug", prices = {["default"] = 2.1, ["Ride"] = 55.12, ["Neon"] = 3.94, ["Neon|Fly"] = 118.41, ["Neon|Ride"] = 38.31, ["Neon|Fly|Ride"] = 117.06, ["Mega"] = 19.48, ["Mega|Ride"] = 90.19, ["Mega|Fly|Ride"] = 122.07}},
    ["rbxassetid://11109314958"] = {name = "Ghost Wolf", prices = {["default"] = 2.1, ["Fly"] = 36.01, ["Ride"] = 17.07, ["Fly|Ride"] = 66.78, ["Neon"] = 13.01, ["Neon|Fly"] = 96.8, ["Neon|Ride"] = 32.48, ["Neon|Fly|Ride"] = 82.69, ["Mega"] = 102.08, ["Mega|Fly"] = 171.98, ["Mega|Ride"] = 117.76, ["Mega|Fly|Ride"] = 155.44}},
    ["rbxassetid://16088267136"] = {name = "Wildfire Hawk", prices = {["default"] = 3.82, ["Fly"] = 91.88, ["Ride"] = 27.84, ["Fly|Ride"] = 51.97, ["Neon"] = 27.57, ["Neon|Fly"] = 110.18, ["Neon|Ride"] = 137.97, ["Neon|Fly|Ride"] = 246.08, ["Mega"] = 237.57, ["Mega|Ride"] = 1470, ["Mega|Fly|Ride"] = 309.7}},
    ["rbxassetid://16898328648"] = {name = "Preppy Capuchin Monkey", prices = {["default"] = 12.74, ["Fly"] = 196.88, ["Ride"] = 46.4, ["Neon"] = 62.75, ["Neon|Fly|Ride"] = 263.3, ["Mega"] = 411.9, ["Mega|Ride"] = 413.44, ["Mega|Fly|Ride"] = 426.57}},
    ["rbxassetid://15921713413"] = {name = "Thorny Devil", prices = {["default"] = 2.1, ["Fly"] = 6186.32, ["Ride"] = 27.2, ["Neon"] = 36.75, ["Neon|Ride"] = 138.15, ["Neon|Fly|Ride"] = 274.93, ["Mega"] = 439.03, ["Mega|Ride"] = 714, ["Mega|Fly|Ride"] = 564.38}},
    ["rbxassetid://16441364976"] = {name = "Gold Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 98.15, ["Ride"] = 18.38, ["Fly|Ride"] = 45.94, ["Neon"] = 4.66, ["Neon|Fly"] = 82.48, ["Neon|Ride"] = 23.84, ["Neon|Fly|Ride"] = 59.73, ["Mega"] = 59.07, ["Mega|Ride"] = 126, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://8077189117"] = {name = "Puffin", prices = {["default"] = 144.38, ["Ride"] = 178.5, ["Fly|Ride"] = 209.99, ["Neon"] = 1686.78, ["Neon|Ride"] = 958.57, ["Neon|Fly|Ride"] = 1029.61, ["Mega"] = 8237.77, ["Mega|Ride"] = 4118.89, ["Mega|Fly|Ride"] = 4105.5}},
    ["rbxassetid://8663441120"] = {name = "Lunar Tiger", prices = {["default"] = 2.1, ["Fly"] = 15.49, ["Ride"] = 15.45, ["Fly|Ride"] = 35.06, ["Neon"] = 3.94, ["Neon|Ride"] = 23.55, ["Neon|Fly|Ride"] = 52.81, ["Mega"] = 39.38, ["Mega|Ride"] = 52.5, ["Mega|Fly|Ride"] = 160.65}},
    ["rbxassetid://17174216294"] = {name = "Skunk", prices = {["default"] = 14.44, ["Fly"] = 137.97, ["Ride"] = 48.09, ["Fly|Ride"] = 160.12, ["Neon"] = 81.38, ["Neon|Ride"] = 110.18, ["Mega"] = 393.75, ["Mega|Fly|Ride"] = 1029.73}},
    ["rbxassetid://13981141292"] = {name = "Kiwi", prices = {["default"] = 40.85, ["Ride"] = 93.19, ["Fly|Ride"] = 170.63, ["Neon"] = 155.66, ["Neon|Ride"] = 274.93, ["Mega"] = 786.19, ["Mega|Ride"] = 811.92, ["Mega|Fly|Ride"] = 1027.68}},
    ["rbxassetid://3409443617"] = {name = "Meerkat", prices = {["default"] = 196.26, ["Ride"] = 249.38, ["Fly|Ride"] = 318.63, ["Neon"] = 708.74, ["Neon|Fly"] = 1159.74, ["Neon|Ride"] = 823.7, ["Neon|Fly|Ride"] = 872.82, ["Mega|Fly|Ride"] = 3247.65}},
    ["rbxassetid://99042906016947"] = {name = "Seafoam Butterfly", prices = {["default"] = 17.07, ["Fly|Ride"] = 139.17, ["Neon"] = 124.1, ["Neon|Ride"] = 145.34, ["Mega"] = 284.57, ["Mega|Ride"] = 406.88, ["Mega|Fly|Ride"] = 1235.68}},
    ["rbxassetid://15504847683"] = {name = "Gingerbread Hare", prices = {["default"] = 125.99, ["Ride"] = 137.97, ["Fly|Ride"] = 617.76, ["Neon"] = 96.8, ["Neon|Fly"] = 155.42, ["Neon|Ride"] = 199.49, ["Mega"] = 1647.37, ["Mega|Ride"] = 617.86, ["Mega|Fly|Ride"] = 959.72}},
    ["rbxassetid://15302316802"] = {name = "Peppermint Penguin", prices = {["default"] = 1115.63, ["Fly"] = 1444.53, ["Ride"] = 1111.22, ["Fly|Ride"] = 1149.75, ["Neon"] = 4668.18, ["Neon|Ride"] = 4790.63, ["Neon|Fly|Ride"] = 5250, ["Mega|Fly|Ride"] = 17834.76}},
    ["rbxassetid://10318106124"] = {name = "Scarlet Butterfly", prices = {["default"] = 10.31, ["Fly"] = 30.17, ["Ride"] = 19.69, ["Fly|Ride"] = 52.5, ["Neon"] = 26.25, ["Neon|Fly"] = 84.06, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 185.34, ["Mega"] = 231.99, ["Mega|Ride"] = 233.76, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://14145989411"] = {name = "Toy Poodle", prices = {["default"] = 7.88, ["Ride"] = 35.44, ["Fly|Ride"] = 135.19, ["Neon"] = 32.82, ["Neon|Ride"] = 110.18, ["Mega"] = 246.01, ["Mega|Fly"] = 1260, ["Mega|Ride"] = 240.85, ["Mega|Fly|Ride"] = 549.88}},
    ["rbxassetid://82833859118891"] = {name = "Snowy Mammoth", prices = {["default"] = 2.1, ["Fly"] = 81.36, ["Ride"] = 27.41, ["Fly|Ride"] = 69.57, ["Neon"] = 15.45, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 37.13, ["Neon|Fly|Ride"] = 205.96, ["Mega"] = 93.52, ["Mega|Ride"] = 182.09, ["Mega|Fly|Ride"] = 733.69}},
    ["rbxassetid://12917346501"] = {name = "Happy Duckling", prices = {["default"] = 27.46, ["Ride"] = 32.82, ["Fly|Ride"] = 91.63, ["Neon"] = 65.62, ["Neon|Ride"] = 76.27, ["Neon|Fly|Ride"] = 179.34, ["Mega"] = 342.57, ["Mega|Ride"] = 353.07, ["Mega|Fly|Ride"] = 456.74}},
    ["rbxassetid://7064993901"] = {name = "2021 Uplift Butterfly", prices = {["default"] = 5.25, ["Fly"] = 20.61, ["Ride"] = 16.53, ["Fly|Ride"] = 39.19, ["Neon"] = 19.65, ["Neon|Fly"] = 41.2, ["Neon|Ride"] = 32.96, ["Neon|Fly|Ride"] = 93.17, ["Mega|Ride"] = 158.59, ["Mega|Fly|Ride"] = 410.87}},
    ["rbxassetid://10926054144"] = {name = "Slug", prices = {["default"] = 2.63, ["Ride"] = 21.97, ["Neon"] = 189.52, ["Neon|Fly"] = 13125, ["Neon|Ride"] = 54.32, ["Neon|Fly|Ride"] = 205.94, ["Mega"] = 118.13, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 327.47}},
    ["rbxassetid://11571113906"] = {name = "Glacier Moth", prices = {["default"] = 229.69, ["Fly"] = 261.53, ["Ride"] = 229.69, ["Fly|Ride"] = 366.47, ["Neon|Fly|Ride"] = 984.38}},
    ["rbxassetid://73641371341710"] = {name = "Ice Cube", prices = {["default"] = 2.1, ["Fly"] = 32.69, ["Ride"] = 22.7, ["Fly|Ride"] = 72.19, ["Neon"] = 9.19, ["Neon|Ride"] = 32.12, ["Neon|Fly|Ride"] = 119.84, ["Mega"] = 82.4, ["Mega|Fly"] = 411.9, ["Mega|Ride"] = 114.64}},
    ["rbxassetid://13077767764"] = {name = "Eel", prices = {["default"] = 5.25, ["Fly|Ride"] = 88.86, ["Neon"] = 52.5, ["Neon|Fly"] = 196.88, ["Neon|Ride"] = 188.27, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://134995672989153"] = {name = "Hammerhead Shark", prices = {["default"] = 4.2, ["Fly"] = 95.01, ["Ride"] = 26.23, ["Fly|Ride"] = 105, ["Neon"] = 11.71, ["Neon|Ride"] = 1373.49, ["Mega"] = 84, ["Mega|Fly"] = 138.01, ["Mega|Ride"] = 141.75, ["Mega|Fly|Ride"] = 371.27}},
    ["rbxassetid://15555939727"] = {name = "Snow Monkey", prices = {["default"] = 206.07, ["Ride"] = 408.99, ["Fly|Ride"] = 686.75, ["Neon"] = 918.75, ["Neon|Fly"] = 1029.61, ["Neon|Ride"] = 892.66, ["Mega"] = 3089.17, ["Mega|Ride"] = 4942.67, ["Mega|Fly|Ride"] = 2756.25}},
    ["rbxassetid://11758575992"] = {name = "Water Rabbit", prices = {["default"] = 28.88, ["Fly"] = 60.76, ["Ride"] = 46.4, ["Fly|Ride"] = 163.72, ["Neon"] = 124.68, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 769.21, ["Mega|Ride"] = 994.72, ["Mega|Fly|Ride"] = 794.07}},
    ["rbxassetid://90987982535884"] = {name = "Great Pyrenees", prices = {["default"] = 18.14, ["Ride"] = 41.51, ["Fly|Ride"] = 89.25, ["Neon"] = 95.82, ["Neon|Ride"] = 138.42, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 511.24, ["Mega|Ride"] = 556.06, ["Mega|Fly|Ride"] = 679.63}},
    ["rbxassetid://84560154336174"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Ride"] = 82.39, ["Neon"] = 3.46, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 127.34, ["Mega"] = 36.72, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 236.85}},
    ["rbxassetid://4506847061"] = {name = "Reindeer", prices = {["default"] = 91.77, ["Fly"] = 137.97, ["Ride"] = 137.97, ["Fly|Ride"] = 205.94, ["Neon"] = 262.48, ["Neon|Fly"] = 343.89, ["Neon|Ride"] = 294.16, ["Neon|Fly|Ride"] = 378.52, ["Mega|Ride"] = 823.79, ["Mega|Fly|Ride"] = 1155.62}},
    ["rbxassetid://98687388677942"] = {name = "Moonpine", prices = {["default"] = 2.1, ["Ride"] = 19.03, ["Neon"] = 5.25, ["Neon|Ride"] = 55.61, ["Neon|Fly|Ride"] = 122.54, ["Mega"] = 52.41, ["Mega|Fly|Ride"] = 411.9}},
    ["rbxassetid://11109032702"] = {name = "Green Amazon", prices = {["default"] = 15.75, ["Fly"] = 97.44, ["Ride"] = 28.61, ["Fly|Ride"] = 79.78, ["Neon"] = 96.8, ["Neon|Ride"] = 122.96, ["Neon|Fly|Ride"] = 137.97, ["Mega"] = 385.91, ["Mega|Fly"] = 971.25, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 418.69}},
    ["rbxassetid://3743730108"] = {name = "Black Panther", prices = {["default"] = 53.27, ["Fly"] = 110.06, ["Ride"] = 79.95, ["Fly|Ride"] = 153.11, ["Neon"] = 250.64, ["Neon|Ride"] = 309.68, ["Neon|Fly|Ride"] = 275.63, ["Mega"] = 1235.68, ["Mega|Ride"] = 3434.12, ["Mega|Fly|Ride"] = 1169.44}},
    ["rbxassetid://3181727398"] = {name = "Chocolate Labrador", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 15.45, ["Fly|Ride"] = 30.54, ["Neon"] = 2.1, ["Neon|Fly"] = 23.96, ["Neon|Ride"] = 15.69, ["Neon|Fly|Ride"] = 41.2, ["Mega"] = 17.07, ["Mega|Fly"] = 116, ["Mega|Ride"] = 32.37, ["Mega|Fly|Ride"] = 86.5}},
    ["rbxassetid://134636987874448"] = {name = "Nebula Snake", prices = {["default"] = 3.94, ["Fly"] = 32.82, ["Ride"] = 39.29, ["Fly|Ride"] = 129.74, ["Neon"] = 15.75, ["Neon|Ride"] = 59.73, ["Neon|Fly|Ride"] = 136.5, ["Mega"] = 129.94, ["Mega|Ride"] = 272.08, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://13104122150"] = {name = "Hippo", prices = {["default"] = 19.49, ["Ride"] = 64.87, ["Fly|Ride"] = 201.81, ["Neon"] = 133.47, ["Neon|Ride"] = 98.44, ["Neon|Fly|Ride"] = 274.93, ["Mega"] = 511.52, ["Mega|Ride"] = 546.96, ["Mega|Fly|Ride"] = 773.66}},
    ["rbxassetid://103821295208934"] = {name = "Black Rhino", prices = {["default"] = 2.1, ["Ride"] = 26.78, ["Neon"] = 2.63, ["Neon|Ride"] = 27.82, ["Neon|Fly|Ride"] = 95.81, ["Mega"] = 19.49, ["Mega|Ride"] = 81.41, ["Mega|Fly|Ride"] = 210.08}},
    ["rbxassetid://14782580070"] = {name = "Undead Elk", prices = {["default"] = 14.3, ["Fly"] = 178.38, ["Ride"] = 58.59, ["Fly|Ride"] = 147, ["Neon"] = 65.63, ["Neon|Ride"] = 87.47, ["Neon|Fly|Ride"] = 143.07, ["Mega"] = 617.86, ["Mega|Fly"] = 787.5, ["Mega|Ride"] = 391.02, ["Mega|Fly|Ride"] = 549.88}},
    ["rbxassetid://8566683782"] = {name = "Giant Blue Scarab", prices = {["default"] = 9.19, ["Fly"] = 101.6, ["Ride"] = 26.5, ["Fly|Ride"] = 46.41, ["Neon"] = 408.98, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 179.43, ["Mega|Fly|Ride"] = 433.8}},
    ["rbxassetid://14850232913"] = {name = "Cute-A-Cabra", prices = {["default"] = 3.46, ["Ride"] = 52.5, ["Neon"] = 42.95, ["Neon|Fly"] = 699.57, ["Neon|Ride"] = 77.44, ["Mega"] = 223.13, ["Mega|Ride"] = 216.57, ["Mega|Fly|Ride"] = 433.8}},
    ["rbxassetid://15508248825"] = {name = "Eggnog Dog", prices = {["default"] = 13.02, ["Fly"] = 2059.19, ["Ride"] = 85.12, ["Fly|Ride"] = 196.85, ["Neon"] = 55.23, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 6185.62, ["Mega"] = 324.78, ["Mega|Ride"] = 505.32, ["Mega|Fly|Ride"] = 826.88}},
    ["rbxassetid://17822797244"] = {name = "Orange Betta Fish", prices = {["default"] = 2.1, ["Fly"] = 41.2, ["Ride"] = 18.57, ["Fly|Ride"] = 196.88, ["Neon"] = 11.82, ["Neon|Fly"] = 55.61, ["Neon|Ride"] = 49.88, ["Neon|Fly|Ride"] = 102.98, ["Mega"] = 68.06, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 152.41}},
    ["rbxassetid://9922274393"] = {name = "Retired Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://103431939950304"] = {name = "Pink Dog", prices = {["default"] = 2.1, ["Ride"] = 76.56, ["Neon"] = 3.94, ["Neon|Ride"] = 97.83, ["Mega"] = 30.76, ["Mega|Ride"] = 123.59, ["Mega|Fly|Ride"] = 267.74}},
    ["rbxassetid://15227882502"] = {name = "Christmas Future Egg", prices = {["default"] = 45.75}},
    ["rbxassetid://12597276740"] = {name = "Red Sand Dollar", prices = {["default"] = 43.25, ["Fly"] = 78.75, ["Ride"] = 53.37, ["Fly|Ride"] = 137.97, ["Neon"] = 234.76, ["Neon|Ride"] = 204.53, ["Neon|Fly|Ride"] = 313.68, ["Mega"] = 1227.44, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 889.88}},
    ["rbxassetid://136447612467002"] = {name = "Glyptodon Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.65, ["Mega"] = 26.25, ["Mega|Ride"] = 119.7, ["Mega|Fly|Ride"] = 308.94}},
    ["rbxassetid://101033810950061"] = {name = "Sea Slug", prices = {["default"] = 393.75, ["Fly"] = 562.17, ["Ride"] = 549.82, ["Fly|Ride"] = 641.82, ["Neon"] = 4118.38, ["Neon|Fly|Ride"] = 2273.82, ["Mega"] = 16475.52, ["Mega|Fly|Ride"] = 10500}},
    ["rbxassetid://14353536658"] = {name = "Birthday Butterfly 2023", prices = {["default"] = 5.25, ["Fly"] = 25.91, ["Ride"] = 22.97, ["Fly|Ride"] = 66.26, ["Neon"] = 26.17, ["Neon|Ride"] = 274.93, ["Neon|Fly|Ride"] = 129.94, ["Mega"] = 85.1, ["Mega|Fly"] = 154.47, ["Mega|Ride"] = 144.37, ["Mega|Fly|Ride"] = 549.88}},
    ["rbxassetid://9938967851"] = {name = "Tan Chow-Chow", prices = {["default"] = 2.63, ["Fly"] = 95.55, ["Ride"] = 21.67, ["Fly|Ride"] = 65.62, ["Neon"] = 18.4, ["Neon|Ride"] = 34.48, ["Neon|Fly|Ride"] = 99.65, ["Mega"] = 164.07, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 309.7}},
    ["rbxassetid://14448124117"] = {name = "Chipmunk", prices = {["default"] = 11.82, ["Fly"] = 77.23, ["Ride"] = 64.87, ["Fly|Ride"] = 67.49, ["Neon"] = 94.5, ["Neon|Ride"] = 171.95, ["Neon|Fly|Ride"] = 287.44, ["Mega"] = 782.6, ["Mega|Ride"] = 603.15, ["Mega|Fly|Ride"] = 719.79}},
    ["rbxassetid://13104108894"] = {name = "Lammergeier", prices = {["default"] = 3.94, ["Fly"] = 316.1, ["Ride"] = 32.82, ["Fly|Ride"] = 686.75, ["Neon"] = 30.38, ["Mega"] = 258.57}},
    ["rbxassetid://14446659851"] = {name = "Raccoon", prices = {["default"] = 15.6, ["Fly"] = 139.53, ["Ride"] = 137.97, ["Fly|Ride"] = 157.5, ["Neon"] = 110.18, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 358.89, ["Mega"] = 378.35, ["Mega|Ride"] = 402.49, ["Mega|Fly|Ride"] = 685.81}},
    ["rbxassetid://84477079324217"] = {name = "Peachick", prices = {["default"] = 11.62, ["Fly"] = 105, ["Ride"] = 32.82, ["Fly|Ride"] = 133.88, ["Neon"] = 27.82, ["Neon|Ride"] = 155.43, ["Neon|Fly|Ride"] = 137.97, ["Mega"] = 217.88, ["Mega|Fly"] = 549.88, ["Mega|Ride"] = 301.88, ["Mega|Fly|Ride"] = 402.49}},
    ["rbxassetid://9718162456"] = {name = "Donkey", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 12.13, ["Fly|Ride"] = 66.94, ["Neon"] = 2.1, ["Neon|Fly"] = 41.99, ["Neon|Ride"] = 14.3, ["Neon|Fly|Ride"] = 134.19, ["Mega"] = 14.58, ["Mega|Ride"] = 24.94, ["Mega|Fly|Ride"] = 110.15}},
    ["rbxassetid://93800993117604"] = {name = "Love Bird", prices = {["default"] = 7.88, ["Fly"] = 275.84, ["Ride"] = 27.82, ["Fly|Ride"] = 102.98, ["Neon"] = 40.32, ["Neon|Fly"] = 116, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 82.39, ["Mega"] = 196.86, ["Mega|Ride"] = 217.88, ["Mega|Fly|Ride"] = 714.67}},
    ["rbxassetid://13665143675"] = {name = "Lion Cub", prices = {["default"] = 316.32, ["Fly"] = 405.95, ["Ride"] = 336, ["Fly|Ride"] = 421.32, ["Neon"] = 1453.8, ["Neon|Ride"] = 1373.49, ["Neon|Fly|Ride"] = 1252.12, ["Mega|Ride"] = 4324.84, ["Mega|Fly|Ride"] = 4380.45}},
    ["rbxassetid://13883284001"] = {name = "Ice Cream Hermit Crab", prices = {["default"] = 92.94, ["Ride"] = 136.85, ["Fly|Ride"] = 294.57, ["Neon"] = 315, ["Neon|Ride"] = 341.25, ["Neon|Fly|Ride"] = 543.55, ["Mega"] = 4118.89, ["Mega|Ride"] = 1509.38, ["Mega|Fly|Ride"] = 1647.57}},
    ["rbxassetid://8938701212"] = {name = "Woodpecker", prices = {["default"] = 2.1, ["Fly"] = 17.05, ["Ride"] = 14.44, ["Fly|Ride"] = 29.59, ["Neon"] = 55.61, ["Neon|Fly"] = 68.99, ["Neon|Ride"] = 31.34, ["Neon|Fly|Ride"] = 63.31, ["Mega"] = 152.41, ["Mega|Fly"] = 204.93, ["Mega|Ride"] = 155.44, ["Mega|Fly|Ride"] = 207.9}},
    ["rbxassetid://4800190034"] = {name = "Toucan", prices = {["default"] = 2.1, ["Fly"] = 18.04, ["Ride"] = 14.6, ["Fly|Ride"] = 31.32, ["Neon"] = 7.88, ["Neon|Fly"] = 39.15, ["Neon|Ride"] = 25.52, ["Neon|Fly|Ride"] = 59.12, ["Mega"] = 70.77, ["Mega|Fly"] = 344.03, ["Mega|Ride"] = 110.19, ["Mega|Fly|Ride"] = 173.25}},
    ["rbxassetid://15886122789"] = {name = "Deathstalker Scorpion", prices = {["default"] = 3.7, ["Fly"] = 96.8, ["Ride"] = 20.99, ["Fly|Ride"] = 98.44, ["Neon"] = 39.38, ["Mega"] = 138.01, ["Mega|Ride"] = 410.87, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://12139402705"] = {name = "Sheeeeep", prices = {["default"] = 306.13, ["Fly"] = 420, ["Ride"] = 303.75, ["Fly|Ride"] = 375.38, ["Neon|Ride"] = 961.65, ["Neon|Fly|Ride"] = 1432.17, ["Mega|Ride"] = 8237.77, ["Mega|Fly|Ride"] = 3675}},
    ["rbxassetid://7126720389"] = {name = "Hydra", prices = {["default"] = 2.77, ["Fly"] = 20.89, ["Ride"] = 16.49, ["Fly|Ride"] = 40.35, ["Neon"] = 18.38, ["Neon|Fly"] = 104.97, ["Neon|Ride"] = 40.31, ["Neon|Fly|Ride"] = 109.04, ["Mega"] = 196.88, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 523.11}},
    ["rbxassetid://17662289865"] = {name = "Punk Pony", prices = {["default"] = 5.1, ["Fly"] = 309.68, ["Ride"] = 82.46, ["Fly|Ride"] = 205.94, ["Neon"] = 45.31, ["Neon|Ride"] = 137.97, ["Neon|Fly|Ride"] = 274.93, ["Mega"] = 253.32, ["Mega|Ride"] = 287.43, ["Mega|Fly|Ride"] = 354.38}},
    ["rbxassetid://84009422958505"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 27.57, ["Neon"] = 3.94, ["Neon|Ride"] = 156.19, ["Mega"] = 62.9, ["Mega|Ride"] = 201.84}},
    ["rbxassetid://9473352533"] = {name = "Space Whale", prices = {["default"] = 14.44, ["Fly"] = 59.07, ["Ride"] = 26.69, ["Fly|Ride"] = 74.79, ["Neon"] = 79.49, ["Neon|Ride"] = 108.07, ["Neon|Fly|Ride"] = 247.15, ["Mega"] = 728.44, ["Mega|Ride"] = 438.38, ["Mega|Fly|Ride"] = 616.65}},
    ["rbxassetid://71528203783155"] = {name = "Pupcake", prices = {["default"] = 55.6, ["Fly"] = 155.43, ["Ride"] = 107.63, ["Fly|Ride"] = 209.9, ["Neon"] = 129.94, ["Neon|Fly"] = 393.75, ["Neon|Ride"] = 206.58, ["Neon|Fly|Ride"] = 424.1, ["Mega"] = 533.97, ["Mega|Fly"] = 2162.43, ["Mega|Ride"] = 549.88, ["Mega|Fly|Ride"] = 728.02}},
    ["rbxassetid://4440867010"] = {name = "Drake", prices = {["default"] = 25.87, ["Ride"] = 55.61, ["Fly|Ride"] = 85.32, ["Neon"] = 262.5, ["Neon|Fly"] = 290.07, ["Neon|Ride"] = 274.93, ["Neon|Fly|Ride"] = 203.43, ["Mega|Ride"] = 1098.72, ["Mega|Fly|Ride"] = 866.25}},
    ["rbxassetid://9708962205"] = {name = "Parakeet", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 14.7, ["Fly|Ride"] = 35.1, ["Neon"] = 2.52, ["Neon|Fly"] = 23.72, ["Neon|Ride"] = 18.11, ["Neon|Fly|Ride"] = 42, ["Mega"] = 21.45, ["Mega|Fly"] = 412.51, ["Mega|Ride"] = 57.66, ["Mega|Fly|Ride"] = 115.5}},
    ["rbxassetid://4883302468"] = {name = "Shrew", prices = {["default"] = 262.49, ["Ride"] = 288.75, ["Fly|Ride"] = 318.94, ["Neon"] = 3247.26, ["Neon|Fly|Ride"] = 1098.72}},
    ["rbxassetid://11507151679"] = {name = "Irish Elk", prices = {["default"] = 15.75, ["Fly"] = 101.18, ["Ride"] = 44.63, ["Fly|Ride"] = 105, ["Neon"] = 127.21, ["Neon|Ride"] = 155.49, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 513.85, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 758.58}},
    ["rbxassetid://17163957321"] = {name = "Blue Jay", prices = {["default"] = 2.1, ["Fly"] = 32.3, ["Ride"] = 15.61, ["Fly|Ride"] = 44.08, ["Neon"] = 5.25, ["Neon|Fly"] = 33.92, ["Neon|Ride"] = 25.54, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 59.16, ["Mega|Fly"] = 274.95, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 139.2}},
    ["rbxassetid://8705079225"] = {name = "Abyssinian Cat", prices = {["default"] = 2.1, ["Fly"] = 30.9, ["Ride"] = 19.59, ["Fly|Ride"] = 37.92, ["Neon"] = 2.63, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 24.93, ["Neon|Fly|Ride"] = 124.3, ["Mega"] = 27.82, ["Mega|Fly"] = 138.01, ["Mega|Ride"] = 46.27, ["Mega|Fly|Ride"] = 155.5}},
    ["rbxassetid://17059483392"] = {name = "Velociraptor", prices = {["default"] = 2.1, ["Ride"] = 28.73, ["Fly|Ride"] = 69.29, ["Neon"] = 12.2, ["Neon|Fly"] = 695.86, ["Neon|Ride"] = 34.8, ["Neon|Fly|Ride"] = 89.25, ["Mega"] = 109.05, ["Mega|Ride"] = 128.84, ["Mega|Fly|Ride"] = 301.88}},
    ["rbxassetid://16548686870"] = {name = "Hamster", prices = {["default"] = 14.43, ["Fly"] = 32.71, ["Ride"] = 24.69, ["Fly|Ride"] = 81.19, ["Neon"] = 53.72, ["Neon|Fly"] = 261.53, ["Neon|Ride"] = 56.46, ["Neon|Fly|Ride"] = 123.38, ["Mega"] = 347.94, ["Mega|Ride"] = 318.34, ["Mega|Fly|Ride"] = 354.37}},
    ["rbxassetid://13883285383"] = {name = "Castle Hermit Crab", prices = {["default"] = 7.28, ["Ride"] = 55.09, ["Neon"] = 59.07, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 274.95, ["Mega|Ride"] = 323.61, ["Mega|Fly|Ride"] = 465.45}},
    ["rbxassetid://82240382561696"] = {name = "Cocoadile", prices = {["default"] = 2.1, ["Ride"] = 43.3, ["Fly|Ride"] = 274.93, ["Neon"] = 3.94, ["Neon|Ride"] = 30.43, ["Neon|Fly|Ride"] = 99.65, ["Mega"] = 22.32, ["Mega|Ride"] = 68.16, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://74702714943302"] = {name = "Grave Owl", prices = {["default"] = 7.77, ["Fly"] = 96.8, ["Ride"] = 31.5, ["Fly|Ride"] = 131.25, ["Neon"] = 31.4, ["Neon|Fly"] = 102.8, ["Neon|Ride"] = 69.74, ["Neon|Fly|Ride"] = 137.97, ["Mega"] = 191.29, ["Mega|Ride"] = 185.59, ["Mega|Fly|Ride"] = 289.98}},
    ["rbxassetid://97556530589327"] = {name = "Bison", prices = {["default"] = 2.1, ["Fly"] = 68.99, ["Ride"] = 121.41, ["Neon"] = 3.94, ["Neon|Fly"] = 110.18, ["Neon|Ride"] = 131.24, ["Neon|Fly|Ride"] = 102.29, ["Mega"] = 23.68, ["Mega|Ride"] = 91.35, ["Mega|Fly|Ride"] = 102.99}},
    ["rbxassetid://11694855214"] = {name = "Shetland Pony Dark Brown", prices = {["default"] = 2.1, ["Fly"] = 38.45, ["Ride"] = 22.61, ["Fly|Ride"] = 42, ["Neon"] = 3.94, ["Neon|Ride"] = 20.89, ["Neon|Fly|Ride"] = 94.69, ["Mega"] = 49.6, ["Mega|Ride"] = 82.37, ["Mega|Fly|Ride"] = 228.5}},
    ["rbxassetid://14398823196"] = {name = "Alpaca", prices = {["default"] = 714.62, ["Ride"] = 758.63, ["Fly|Ride"] = 825.57, ["Neon|Ride"] = 3150, ["Neon|Fly|Ride"] = 3248.38, ["Mega|Fly|Ride"] = 17574.24}},
    ["rbxassetid://5721843716"] = {name = "Pterodactyl", prices = {["default"] = 2.1, ["Fly"] = 17.56, ["Ride"] = 15.45, ["Fly|Ride"] = 27.82, ["Neon"] = 10.5, ["Neon|Fly"] = 123.05, ["Neon|Ride"] = 27.88, ["Neon|Fly|Ride"] = 43.64, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://82057257613990"] = {name = "Unicorn Ducky", prices = {["default"] = 3.84, ["Ride"] = 44.27, ["Fly|Ride"] = 81.36, ["Neon"] = 15.45, ["Neon|Ride"] = 87.84, ["Neon|Fly|Ride"] = 393.74, ["Mega"] = 65.63, ["Mega|Fly"] = 315, ["Mega|Ride"] = 89.65, ["Mega|Fly|Ride"] = 324.85}},
    ["rbxassetid://4708551366"] = {name = "Frog", prices = {["default"] = 12.48, ["Fly"] = 47.38, ["Ride"] = 26.76, ["Fly|Ride"] = 57.66, ["Neon"] = 53.82, ["Neon|Fly"] = 67.97, ["Neon|Ride"] = 54.53, ["Neon|Fly|Ride"] = 127.32, ["Mega"] = 480.89, ["Mega|Ride"] = 309.74, ["Mega|Fly|Ride"] = 371.69}},
    ["rbxassetid://4800189682"] = {name = "Starfish", prices = {["default"] = 2.1, ["Fly"] = 20.11, ["Ride"] = 14.77, ["Fly|Ride"] = 33.63, ["Neon"] = 7.35, ["Neon|Fly"] = 137.13, ["Neon|Ride"] = 23.55, ["Neon|Fly|Ride"] = 61.63, ["Mega"] = 65.62, ["Mega|Ride"] = 99.74, ["Mega|Fly|Ride"] = 167.61}},
    ["rbxassetid://16736753854"] = {name = "Candy Cane Snail", prices = {["default"] = 33.66, ["Ride"] = 84, ["Fly|Ride"] = 273.89, ["Neon"] = 255.84, ["Neon|Ride"] = 257.44, ["Mega"] = 909.57}},
    ["rbxassetid://10393730410"] = {name = "Orca", prices = {["default"] = 2.1, ["Fly"] = 137.97, ["Ride"] = 18.38, ["Fly|Ride"] = 63.74, ["Neon"] = 5.25, ["Neon|Fly"] = 132.23, ["Neon|Ride"] = 36.66, ["Neon|Fly|Ride"] = 104.52, ["Mega"] = 69.01, ["Mega|Ride"] = 114.75, ["Mega|Fly|Ride"] = 274.95}},
    ["rbxassetid://111642509798043"] = {name = "Toxic Kaijunior", prices = {["default"] = 2.1, ["Fly"] = 68.99, ["Ride"] = 22.98, ["Fly|Ride"] = 60.76, ["Neon"] = 31.34, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 262.5, ["Mega|Ride"] = 198.58, ["Mega|Fly|Ride"] = 164.07}},
    ["rbxassetid://14146181621"] = {name = "Tawny Frogmouth", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Neon"] = 15.06, ["Mega"] = 93.5, ["Mega|Ride"] = 171.68, ["Mega|Fly|Ride"] = 511.88}},
    ["rbxassetid://9474010501"] = {name = "Ribbon Seal", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Ride"] = 14.76, ["Fly|Ride"] = 97.83, ["Neon"] = 5.25, ["Neon|Fly"] = 31.5, ["Neon|Ride"] = 23.7, ["Neon|Fly|Ride"] = 84.96, ["Mega"] = 42, ["Mega|Fly"] = 285.87, ["Mega|Ride"] = 65.62, ["Mega|Fly|Ride"] = 138.01}},
    ["rbxassetid://6776872152"] = {name = "Red Squirrel", prices = {["default"] = 15.6, ["Fly"] = 17.75, ["Ride"] = 21.23, ["Fly|Ride"] = 41.32, ["Neon"] = 309.74, ["Neon|Ride"] = 68.86, ["Neon|Fly|Ride"] = 98.43, ["Mega"] = 823.79, ["Mega|Fly|Ride"] = 534.43}},
    ["rbxassetid://84140820920420"] = {name = "Siamese Cat", prices = {["default"] = 721.88, ["Ride"] = 892.5, ["Fly|Ride"] = 984.38, ["Neon"] = 2059.19, ["Neon|Ride"] = 1811.25, ["Neon|Fly|Ride"] = 1968.75, ["Mega"] = 8237.77, ["Mega|Fly|Ride"] = 7578.62}},
    ["rbxassetid://3181727773"] = {name = "Bunny", prices = {["default"] = 2.1, ["Fly"] = 16.05, ["Ride"] = 15.45, ["Fly|Ride"] = 32.33, ["Neon"] = 4.73, ["Neon|Fly"] = 26.25, ["Neon|Ride"] = 19.59, ["Neon|Fly|Ride"] = 61.8, ["Mega"] = 55.69, ["Mega|Ride"] = 57.75, ["Mega|Fly|Ride"] = 143.07}},
    ["rbxassetid://17120012859"] = {name = "Praying Mantis", prices = {["default"] = 103.69, ["Ride"] = 36.91, ["Fly|Ride"] = 115.98, ["Neon"] = 59.73, ["Neon|Ride"] = 112.51, ["Neon|Fly|Ride"] = 273.92, ["Mega"] = 315, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 440.73}},
    ["rbxassetid://4440866528"] = {name = "Turkey", prices = {["default"] = 62.63, ["Ride"] = 80.33, ["Fly|Ride"] = 112.88, ["Neon|Ride"] = 387.39, ["Neon|Fly|Ride"] = 407.11, ["Mega"] = 3150.32, ["Mega|Fly|Ride"] = 1291.28}},
    ["rbxassetid://9287841987"] = {name = "Black Springer Spaniel", prices = {["default"] = 31.92, ["Ride"] = 45.31, ["Fly|Ride"] = 137.97, ["Neon"] = 105, ["Neon|Ride"] = 179.17, ["Mega"] = 930.88, ["Mega|Ride"] = 669.38, ["Mega|Fly|Ride"] = 816.38}},
    ["rbxassetid://87613898139280"] = {name = "Ranger Beaver", prices = {["default"] = 15.39, ["Ride"] = 26.23, ["Fly|Ride"] = 123.56, ["Neon"] = 59.07, ["Neon|Ride"] = 113.45, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 398.52, ["Mega|Ride"] = 463.97, ["Mega|Fly|Ride"] = 456.75}},
    ["rbxassetid://88389663444803"] = {name = "Mirai Moth", prices = {["default"] = 21.62, ["Ride"] = 63.51, ["Neon"] = 107.63, ["Neon|Ride"] = 135.93, ["Mega"] = 257.51, ["Mega|Fly"] = 503.41, ["Mega|Ride"] = 343.94, ["Mega|Fly|Ride"] = 508.6}},
    ["rbxassetid://128469688002747"] = {name = "Moonlight Moth", prices = {["default"] = 18.38, ["Fly"] = 126.89, ["Ride"] = 28.61, ["Neon"] = 224.47, ["Neon|Ride"] = 307, ["Neon|Fly|Ride"] = 485.63, ["Mega"] = 924, ["Mega|Ride"] = 695.94, ["Mega|Fly|Ride"] = 557.81}},
    ["rbxassetid://13936753561"] = {name = "Dylan", prices = {["default"] = 7.6}},
    ["rbxassetid://10606175827"] = {name = "Koi Carp", prices = {["default"] = 12.5, ["Fly"] = 131248.69, ["Ride"] = 26.78, ["Fly|Ride"] = 78.75, ["Neon"] = 38.07, ["Neon|Ride"] = 72.93, ["Neon|Fly|Ride"] = 220.36, ["Mega"] = 205.96, ["Mega|Fly"] = 459.23, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 411.9}},
    ["rbxassetid://84529929751558"] = {name = "Old King Coal", prices = {["default"] = 3.82, ["Ride"] = 131.25, ["Neon"] = 17.41, ["Mega"] = 866.44}},
    ["rbxassetid://11706110842"] = {name = "Snowball Pet", prices = {["default"] = 118.4, ["Fly"] = 412.55, ["Ride"] = 69.57, ["Fly|Ride"] = 111.6, ["Neon"] = 271.69, ["Neon|Ride"] = 284.19, ["Neon|Fly|Ride"] = 201.81, ["Mega|Ride"] = 897.77, ["Mega|Fly|Ride"] = 788.82}},
    ["rbxassetid://6404812664"] = {name = "Ladybug", prices = {["default"] = 9.14, ["Fly"] = 19.69, ["Ride"] = 17.07, ["Fly|Ride"] = 36.05, ["Neon"] = 22.32, ["Neon|Fly"] = 63, ["Neon|Ride"] = 35.49, ["Neon|Fly|Ride"] = 68.99, ["Mega|Ride"] = 195.57, ["Mega|Fly|Ride"] = 190.32}},
    ["rbxassetid://95046891836017"] = {name = "Clover Cow", prices = {["default"] = 9.3, ["Fly"] = 82.39, ["Ride"] = 31.32, ["Fly|Ride"] = 105, ["Neon"] = 22.89, ["Neon|Ride"] = 54.81, ["Neon|Fly|Ride"] = 123.56, ["Mega"] = 127.34, ["Mega|Ride"] = 168, ["Mega|Fly|Ride"] = 257.25}},
    ["rbxassetid://123759251940984"] = {name = "Oakee Knight", prices = {["default"] = 2.1, ["Neon"] = 4.77, ["Mega"] = 42, ["Mega|Ride"] = 96.81, ["Mega|Fly|Ride"] = 150.94}},
    ["rbxassetid://9287842106"] = {name = "Brown Springer Spaniel", prices = {["default"] = 35.13, ["Fly"] = 63.67, ["Ride"] = 61.79, ["Fly|Ride"] = 94.46, ["Neon"] = 196.88, ["Neon|Ride"] = 183.75, ["Neon|Fly|Ride"] = 387.41, ["Mega"] = 1098.72, ["Mega|Ride"] = 863.96, ["Mega|Fly|Ride"] = 816.66}},
    ["rbxassetid://83890934284839"] = {name = "Zeopod", prices = {["default"] = 2.1, ["Ride"] = 36.65, ["Fly|Ride"] = 65.54, ["Neon"] = 5.92, ["Neon|Fly"] = 291.38, ["Neon|Ride"] = 66.26, ["Mega"] = 74.82, ["Mega|Ride"] = 137.52, ["Mega|Fly|Ride"] = 310.27}},
    ["rbxassetid://107096792267421"] = {name = "General Sheepdog", prices = {["default"] = 13.7, ["Ride"] = 60.8, ["Fly|Ride"] = 273.89, ["Neon"] = 82.39, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 406.75, ["Mega|Ride"] = 616.88, ["Mega|Fly|Ride"] = 658.01}},
    ["rbxassetid://5721844511"] = {name = "Woolly Mammoth", prices = {["default"] = 2.1, ["Fly"] = 45.88, ["Ride"] = 13.13, ["Fly|Ride"] = 38.7, ["Neon"] = 18.5, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 63.65, ["Mega|Ride"] = 138.01, ["Mega|Fly|Ride"] = 257.25}},
    ["rbxassetid://8143039445"] = {name = "Summer Walrus", prices = {["default"] = 7.85, ["Fly"] = 52.49, ["Ride"] = 17.75, ["Fly|Ride"] = 73.12, ["Neon"] = 26.25, ["Neon|Ride"] = 410.93, ["Mega"] = 377.92, ["Mega|Ride"] = 389.25, ["Mega|Fly|Ride"] = 410.17}},
    ["rbxassetid://136696735147963"] = {name = "Chilling Spider", prices = {["default"] = 10.4, ["Ride"] = 61.76, ["Fly|Ride"] = 131.25, ["Neon"] = 53.37, ["Neon|Ride"] = 155.43, ["Mega"] = 379.65, ["Mega|Ride"] = 853.79}},
    ["rbxassetid://133768672320906"] = {name = "Catte", prices = {["default"] = 38.07, ["Ride"] = 126.77, ["Neon"] = 257.25, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 1235.68, ["Mega|Ride"] = 1634.18, ["Mega|Fly|Ride"] = 1246.88}},
    ["rbxassetid://12139319231"] = {name = "Feesh", prices = {["default"] = 15.74, ["Ride"] = 90.62, ["Neon"] = 107.63, ["Neon|Ride"] = 411.86, ["Mega"] = 411.9, ["Mega|Ride"] = 427.34, ["Mega|Fly|Ride"] = 498.75}},
    ["rbxassetid://13685039170"] = {name = "Lobster", prices = {["default"] = 7.25, ["Ride"] = 105, ["Neon"] = 82.39, ["Neon|Ride"] = 105, ["Mega|Ride"] = 1548.45, ["Mega|Fly|Ride"] = 1647.57}},
    ["rbxassetid://87668315398037"] = {name = "Mecha R4BBIT", prices = {["default"] = 28.87, ["Ride"] = 105, ["Fly|Ride"] = 367.46, ["Neon"] = 291.38, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 823.79, ["Mega|Ride"] = 879.27, ["Mega|Fly|Ride"] = 1441.62}},
    ["rbxassetid://120262676323297"] = {name = "Kelp Hunter", prices = {["default"] = 5.76, ["Neon"] = 105, ["Neon|Ride"] = 274.93, ["Mega"] = 118.13, ["Mega|Fly|Ride"] = 309.7}},
    ["rbxassetid://12403864254"] = {name = "Gorilla", prices = {["default"] = 2.1, ["Fly"] = 27.82, ["Ride"] = 17.8, ["Fly|Ride"] = 58.71, ["Neon"] = 5.2, ["Neon|Fly"] = 43.02, ["Neon|Ride"] = 26.24, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 88.57, ["Mega|Ride"] = 92.8, ["Mega|Fly|Ride"] = 243.48}},
    ["rbxassetid://124908510040897"] = {name = "Mistletroll", prices = {["default"] = 6.29, ["Fly"] = 50.18, ["Ride"] = 288.64, ["Fly|Ride"] = 77.89, ["Neon"] = 39.38, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 116, ["Mega|Ride"] = 129.94, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://11189235896"] = {name = "Persian Cat", prices = {["default"] = 2.1, ["Fly"] = 31.5, ["Ride"] = 19.69, ["Fly|Ride"] = 55.95, ["Neon"] = 5.25, ["Neon|Fly"] = 31.34, ["Neon|Ride"] = 27.82, ["Neon|Fly|Ride"] = 65.65, ["Mega"] = 47.25, ["Mega|Ride"] = 73.37, ["Mega|Fly|Ride"] = 202.51}},
    ["rbxassetid://14457148635"] = {name = "Magma Snail", prices = {["default"] = 3.93, ["Fly"] = 39.38, ["Ride"] = 19.69, ["Fly|Ride"] = 118.13, ["Neon"] = 47.38, ["Neon|Ride"] = 98.44, ["Neon|Fly|Ride"] = 138.01, ["Mega"] = 250.59, ["Mega|Ride"] = 189.53, ["Mega|Fly|Ride"] = 259.88}},
    ["rbxassetid://11694853423"] = {name = "Shetland Pony White", prices = {["default"] = 3.59, ["Fly"] = 65.63, ["Ride"] = 22.23, ["Fly|Ride"] = 103.69, ["Neon"] = 28.87, ["Neon|Fly"] = 463.91, ["Neon|Ride"] = 106.72, ["Neon|Fly|Ride"] = 196.88, ["Mega|Fly|Ride"] = 1208.91}},
    ["rbxassetid://4621220568"] = {name = "Rat", prices = {["default"] = 7.88, ["Fly"] = 26.18, ["Ride"] = 23.63, ["Fly|Ride"] = 55.68, ["Neon"] = 20.22, ["Neon|Fly"] = 54.53, ["Neon|Ride"] = 32.78, ["Neon|Fly|Ride"] = 89.97, ["Mega"] = 157.5, ["Mega|Ride"] = 257.24, ["Mega|Fly|Ride"] = 323.8}},
    ["rbxassetid://8938702150"] = {name = "Pine Marten", prices = {["default"] = 3.94, ["Fly"] = 35.49, ["Ride"] = 18.58, ["Fly|Ride"] = 51.69, ["Neon"] = 22.32, ["Neon|Fly"] = 82.39, ["Neon|Ride"] = 54.68, ["Neon|Fly|Ride"] = 184.31, ["Mega"] = 170.62, ["Mega|Ride"] = 309.7, ["Mega|Fly|Ride"] = 247.15}},
    ["rbxassetid://120359009390464"] = {name = "Turtle Doves", prices = {["default"] = 13.13, ["Fly"] = 39.38, ["Ride"] = 31.49, ["Neon"] = 14.54, ["Neon|Fly"] = 123.56, ["Neon|Ride"] = 130.77, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 138.41, ["Mega|Ride"] = 147.53, ["Mega|Fly|Ride"] = 280.37}},
    ["rbxassetid://71032455578324"] = {name = "Chihuahua", prices = {["default"] = 26.25, ["Fly"] = 205.94, ["Ride"] = 110.66, ["Fly|Ride"] = 242.82, ["Neon"] = 116.82, ["Neon|Ride"] = 210, ["Neon|Fly|Ride"] = 343.94, ["Mega"] = 484.32, ["Mega|Fly"] = 686.83, ["Mega|Ride"] = 603.49, ["Mega|Fly|Ride"] = 721.5}},
    ["rbxassetid://11505487641"] = {name = "Ram", prices = {["default"] = 59.07, ["Ride"] = 102.98, ["Fly|Ride"] = 229.69, ["Neon"] = 294.68, ["Neon|Ride"] = 294, ["Neon|Fly|Ride"] = 329.44, ["Mega"] = 1220.63, ["Mega|Ride"] = 1098.72, ["Mega|Fly|Ride"] = 1171.46}},
    ["rbxassetid://117821626163847"] = {name = "Chanekeh", prices = {["default"] = 2.1, ["Fly"] = 50.96, ["Ride"] = 19.51, ["Fly|Ride"] = 57.66, ["Neon"] = 3.64, ["Neon|Ride"] = 38.83, ["Mega"] = 26.25, ["Mega|Ride"] = 69.01, ["Mega|Fly|Ride"] = 165.27}},
    ["rbxassetid://14266737982"] = {name = "Cassowary", prices = {["default"] = 12.3, ["Neon"] = 155.42, ["Mega|Fly|Ride"] = 1235.68}},
    ["rbxassetid://13693650831"] = {name = "Leopard Shark", prices = {["default"] = 57.75, ["Ride"] = 78.75, ["Neon"] = 247.11, ["Neon|Ride"] = 274.93, ["Neon|Fly|Ride"] = 411.86, ["Mega|Ride"] = 1098.72, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://100909868233186"] = {name = "Kappakid", prices = {["default"] = 5.72, ["Fly"] = 190.32, ["Ride"] = 32.1, ["Fly|Ride"] = 126, ["Neon"] = 40.69, ["Neon|Ride"] = 104.9, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 155.44, ["Mega|Ride"] = 231.99, ["Mega|Fly|Ride"] = 383.92}},
    ["rbxassetid://127061844219486"] = {name = "Patchy Bear", prices = {["default"] = 5.25, ["Ride"] = 96.8, ["Fly|Ride"] = 137.82, ["Neon"] = 5.93, ["Neon|Ride"] = 63.21, ["Neon|Fly|Ride"] = 89.6, ["Mega"] = 62.37, ["Mega|Fly"] = 341.25, ["Mega|Ride"] = 97.46, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://6998402749"] = {name = "Merhorse", prices = {["default"] = 2.1, ["Fly"] = 686.75, ["Ride"] = 18.55, ["Fly|Ride"] = 45.94, ["Neon"] = 10.5, ["Neon|Ride"] = 27.82, ["Neon|Fly|Ride"] = 112.77, ["Mega"] = 164.07, ["Mega|Fly"] = 343.94, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 221.24}},
    ["rbxassetid://3181727196"] = {name = "Beaver", prices = {["default"] = 2.1, ["Fly"] = 16.68, ["Ride"] = 15.45, ["Fly|Ride"] = 38.66, ["Neon"] = 2.63, ["Neon|Ride"] = 31.4, ["Neon|Fly|Ride"] = 69.01, ["Mega"] = 31.34, ["Mega|Ride"] = 69.55, ["Mega|Fly|Ride"] = 147}},
    ["rbxassetid://10377935981"] = {name = "Badger", prices = {["default"] = 2.1, ["Ride"] = 18.38, ["Fly|Ride"] = 80.54, ["Neon"] = 4.73, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 102.98, ["Mega"] = 44.73, ["Mega|Fly"] = 168, ["Mega|Ride"] = 76.71, ["Mega|Fly|Ride"] = 173.25}},
    ["rbxassetid://118143096743818"] = {name = "Granny Wolf", prices = {["default"] = 2.1, ["Ride"] = 52.47, ["Neon"] = 2.47, ["Neon|Ride"] = 145.08, ["Mega"] = 24.62, ["Mega|Ride"] = 549.88, ["Mega|Fly|Ride"] = 308.94}},
    ["rbxassetid://18819382634"] = {name = "Singularity Beetle", prices = {["default"] = 7.26, ["Ride"] = 157.5, ["Neon"] = 30.19, ["Neon|Ride"] = 83.52, ["Neon|Fly|Ride"] = 617.76, ["Mega"] = 213.94, ["Mega|Ride"] = 269.07, ["Mega|Fly|Ride"] = 187.21}},
    ["rbxassetid://13664716167"] = {name = "Ostrich", prices = {["default"] = 10.23, ["Ride"] = 30.18, ["Fly|Ride"] = 202.98, ["Neon"] = 46.4, ["Neon|Ride"] = 102.98, ["Neon|Fly|Ride"] = 181.25, ["Mega"] = 216.91, ["Mega|Ride"] = 549.88, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://3710822879"] = {name = "Penguin", prices = {["default"] = 10.4, ["Fly"] = 22.37, ["Ride"] = 19.69, ["Fly|Ride"] = 45.35, ["Neon"] = 32.82, ["Neon|Fly"] = 68.99, ["Neon|Ride"] = 46.12, ["Neon|Fly|Ride"] = 91.85, ["Mega"] = 463.97, ["Mega|Ride"] = 346.34, ["Mega|Fly|Ride"] = 360.38}},
    ["rbxassetid://12778628745"] = {name = "Chef Gorilla", prices = {["default"] = 58.97, ["Ride"] = 62.63, ["Fly|Ride"] = 262.5, ["Neon|Ride"] = 597.19, ["Mega|Fly|Ride"] = 1779.26}},
    ["rbxassetid://138841259551372"] = {name = "Vermilion Butterfly", prices = {["default"] = 24.43, ["Fly"] = 81.83, ["Ride"] = 65.63, ["Fly|Ride"] = 150.33, ["Neon"] = 261.53, ["Neon|Fly|Ride"] = 630, ["Mega"] = 879.2, ["Mega|Ride"] = 827.54, ["Mega|Fly|Ride"] = 823.79}},
    ["rbxassetid://3181727125"] = {name = "Snow Puma", prices = {["default"] = 2.1, ["Fly"] = 20.89, ["Ride"] = 16.36, ["Fly|Ride"] = 41.2, ["Neon"] = 3.94, ["Neon|Fly"] = 41.11, ["Neon|Ride"] = 17.07, ["Neon|Fly|Ride"] = 53.55, ["Mega"] = 44.29, ["Mega|Ride"] = 127.32, ["Mega|Fly|Ride"] = 188.97}},
    ["rbxassetid://3181728160"] = {name = "Shiba Inu", prices = {["default"] = 2.1, ["Fly"] = 12.37, ["Ride"] = 13.13, ["Fly|Ride"] = 34.81, ["Neon"] = 5.4, ["Neon|Fly"] = 22.58, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 45.85, ["Mega"] = 44.28, ["Mega|Fly"] = 82.4, ["Mega|Ride"] = 56.44, ["Mega|Fly|Ride"] = 101.35}},
    ["rbxassetid://3261465893"] = {name = "Blue Dog", prices = {["default"] = 600.67, ["Ride"] = 534.18, ["Fly|Ride"] = 549.93, ["Neon|Fly|Ride"] = 1884.09}},
    ["rbxassetid://15504846154"] = {name = "Eggnog Hare", prices = {["default"] = 7.88, ["Ride"] = 90.6, ["Neon"] = 94.74, ["Neon|Ride"] = 117.39, ["Neon|Fly|Ride"] = 159.92, ["Mega"] = 364.88, ["Mega|Fly|Ride"] = 971.25}},
    ["rbxassetid://4708551244"] = {name = "Dingo", prices = {["default"] = 2.1, ["Ride"] = 15.27, ["Fly|Ride"] = 27.82, ["Neon"] = 3.86, ["Neon|Fly"] = 26.75, ["Neon|Ride"] = 15.45, ["Neon|Fly|Ride"] = 55.55, ["Mega"] = 52.5, ["Mega|Ride"] = 74.82, ["Mega|Fly|Ride"] = 104.37}},
    ["rbxassetid://140434791311540"] = {name = "French Bulldog", prices = {["default"] = 61.07, ["Ride"] = 164.07, ["Fly|Ride"] = 328.13, ["Neon"] = 260.69, ["Neon|Ride"] = 303.75, ["Neon|Fly|Ride"] = 450.98, ["Mega"] = 737.62, ["Mega|Ride"] = 917.44}},
    ["rbxassetid://5067924710"] = {name = "Monkey", prices = {["default"] = 3.94, ["Fly"] = 36.98, ["Ride"] = 18.38, ["Fly|Ride"] = 45.94, ["Neon"] = 14.69, ["Neon|Fly"] = 45.63, ["Neon|Ride"] = 30.9, ["Neon|Fly|Ride"] = 62.37, ["Mega"] = 85.32, ["Mega|Ride"] = 123.38, ["Mega|Fly|Ride"] = 236.24}},
    ["rbxassetid://73677246948616"] = {name = "Black Tiger", prices = {["default"] = 2.1, ["Fly"] = 68.99, ["Ride"] = 37.13, ["Fly|Ride"] = 1312.5, ["Neon"] = 5.25, ["Neon|Ride"] = 31.94, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 18.38, ["Mega|Ride"] = 69.57, ["Mega|Fly|Ride"] = 190.76}},
    ["rbxassetid://17662893972"] = {name = "Pretty Pony", prices = {["default"] = 49.38, ["Fly"] = 126.14, ["Ride"] = 105, ["Fly|Ride"] = 111.57, ["Neon"] = 169.31, ["Neon|Ride"] = 191.26, ["Neon|Fly|Ride"] = 411.86, ["Mega"] = 787.5, ["Mega|Ride"] = 623.7, ["Mega|Fly|Ride"] = 783.57}},
    ["rbxassetid://16722908853"] = {name = "Dotted Eggy", prices = {["default"] = 2.1, ["Ride"] = 15.65, ["Neon"] = 6.12, ["Neon|Ride"] = 39.99, ["Neon|Fly|Ride"] = 63, ["Mega"] = 41.03, ["Mega|Ride"] = 176.22, ["Mega|Fly|Ride"] = 223.12}},
    ["rbxassetid://3409443896"] = {name = "Wild Boar", prices = {["default"] = 31.66, ["Ride"] = 96.87, ["Fly|Ride"] = 137.97, ["Neon"] = 324.33, ["Neon|Ride"] = 256.48, ["Neon|Fly|Ride"] = 359.63, ["Mega"] = 1626.97, ["Mega|Ride"] = 1647.57, ["Mega|Fly|Ride"] = 1228.49}},
    ["rbxassetid://12432807176"] = {name = "Possum", prices = {["default"] = 2.9, ["Ride"] = 55.61, ["Fly|Ride"] = 156.52, ["Neon"] = 13.13, ["Neon|Ride"] = 275.35, ["Neon|Fly|Ride"] = 480.89, ["Mega"] = 104.99, ["Mega|Ride"] = 463.97, ["Mega|Fly|Ride"] = 584.73}},
    ["rbxassetid://94550121082603"] = {name = "Lionfish", prices = {["default"] = 3.84, ["Fly"] = 23.63, ["Ride"] = 26.25, ["Fly|Ride"] = 65.91, ["Neon"] = 7.88, ["Neon|Ride"] = 35.02, ["Neon|Fly|Ride"] = 406.88, ["Mega"] = 121.52, ["Mega|Ride"] = 138.01, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://15096097714"] = {name = "Evil Rock", prices = {["default"] = 40.3, ["Ride"] = 98.85, ["Fly|Ride"] = 514.82, ["Neon"] = 328.13, ["Neon|Ride"] = 700.88, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 2057.4, ["Mega|Ride"] = 2598.75, ["Mega|Fly|Ride"] = 1359.24}},
    ["rbxassetid://117664495619345"] = {name = "Fire Foal", prices = {["default"] = 2.1, ["Fly"] = 242.23, ["Ride"] = 30.16, ["Fly|Ride"] = 908.98, ["Neon"] = 5.24, ["Neon|Ride"] = 37.08, ["Neon|Fly|Ride"] = 151.96, ["Mega"] = 49.88, ["Mega|Fly"] = 257.28, ["Mega|Ride"] = 155.44, ["Mega|Fly|Ride"] = 218.31}},
    ["rbxassetid://8938701683"] = {name = "Red Cardinal", prices = {["default"] = 2.1, ["Fly"] = 13.49, ["Ride"] = 17.41, ["Fly|Ride"] = 102.88, ["Neon"] = 10.49, ["Neon|Fly"] = 47.77, ["Neon|Ride"] = 16.49, ["Neon|Fly|Ride"] = 116, ["Mega|Fly|Ride"] = 205.78}},
    ["rbxassetid://12489700965"] = {name = "Tarsier", prices = {["default"] = 9.59, ["Fly"] = 48.41, ["Ride"] = 28.88, ["Fly|Ride"] = 77.72, ["Neon"] = 77.6, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 147.31, ["Mega"] = 393.75, ["Mega|Ride"] = 484.65, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://11765322595"] = {name = "Gingerbread Reindeer", prices = {["default"] = 40.58, ["Fly"] = 57.11, ["Ride"] = 47.25, ["Fly|Ride"] = 88.55, ["Neon"] = 91.76, ["Neon|Ride"] = 103.69, ["Neon|Fly|Ride"] = 233.73, ["Mega"] = 864.97, ["Mega|Ride"] = 560.18, ["Mega|Fly|Ride"] = 617.86}},
    ["rbxassetid://16382424275"] = {name = "Nautilus", prices = {["default"] = 20.56, ["Fly"] = 39.38, ["Ride"] = 22.32, ["Fly|Ride"] = 64.87, ["Neon"] = 81.38, ["Neon|Ride"] = 109.04, ["Neon|Fly|Ride"] = 274.95, ["Mega"] = 542.55, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 688.98}},
    ["rbxassetid://93997399823425"] = {name = "Chocolate Dutch Guinea Pig", prices = {["default"] = 63, ["Ride"] = 116.82, ["Fly|Ride"] = 221.73, ["Neon"] = 299.25, ["Neon|Ride"] = 496.41, ["Neon|Fly|Ride"] = 509.25, ["Mega"] = 1647.57, ["Mega|Ride"] = 1490.02, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://75866760046580"] = {name = "Skelebat", prices = {["default"] = 7.88, ["Ride"] = 47.88, ["Fly|Ride"] = 308.88, ["Neon"] = 24.94, ["Neon|Ride"] = 109.04, ["Neon|Fly|Ride"] = 305.82, ["Mega"] = 214.39, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 343.94}},
    ["rbxassetid://111661922676557"] = {name = "Momma Moose", prices = {["default"] = 5.24, ["Ride"] = 26.57, ["Fly|Ride"] = 78.74, ["Neon"] = 22.04, ["Neon|Ride"] = 55.77, ["Neon|Fly|Ride"] = 138.15, ["Mega"] = 185.07, ["Mega|Ride"] = 191.63, ["Mega|Fly|Ride"] = 309.68}},
    ["rbxassetid://17059860310"] = {name = "Elasmosaurus", prices = {["default"] = 12.78, ["Ride"] = 37.08, ["Fly|Ride"] = 160.13, ["Neon"] = 52.53, ["Neon|Ride"] = 262.49, ["Neon|Fly|Ride"] = 231.98, ["Mega"] = 379.32, ["Mega|Ride"] = 453.09, ["Mega|Fly|Ride"] = 510.57}},
    ["rbxassetid://10306934599"] = {name = "Camel", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 12.16, ["Fly|Ride"] = 22.74, ["Neon"] = 2.1, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 13.13, ["Neon|Fly|Ride"] = 39.37, ["Mega"] = 13.95, ["Mega|Ride"] = 26.17, ["Mega|Fly|Ride"] = 89.2}},
    ["rbxassetid://13104107016"] = {name = "Puffer Fish", prices = {["default"] = 56.96, ["Fly"] = 218.29, ["Ride"] = 110.25, ["Fly|Ride"] = 274.93, ["Neon"] = 206.21, ["Neon|Fly"] = 2334.09, ["Neon|Ride"] = 227.39, ["Neon|Fly|Ride"] = 488.15, ["Mega"] = 1083.34, ["Mega|Ride"] = 1499.75, ["Mega|Fly|Ride"] = 1115.63}},
    ["rbxassetid://17183022910"] = {name = "Mole", prices = {["default"] = 2.1, ["Ride"] = 20.6, ["Fly|Ride"] = 112.22, ["Neon"] = 6.03, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 129.93, ["Mega"] = 46.41, ["Mega|Ride"] = 51.79, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://5721844051"] = {name = "Stegosaurus", prices = {["default"] = 2.1, ["Fly"] = 27.8, ["Ride"] = 14.11, ["Fly|Ride"] = 45.93, ["Neon"] = 11.61, ["Neon|Fly"] = 137.97, ["Neon|Ride"] = 23.45, ["Neon|Fly|Ride"] = 96.8, ["Mega"] = 110.19, ["Mega|Ride"] = 123.24, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://114921997566126"] = {name = "S'mores Raccoon", prices = {["default"] = 84, ["Ride"] = 152.39, ["Fly|Ride"] = 249.38, ["Neon"] = 334.69, ["Neon|Ride"] = 389.82, ["Neon|Fly|Ride"] = 683.66, ["Mega"] = 1260.39, ["Mega|Ride"] = 1098.72, ["Mega|Fly|Ride"] = 1227.19}},
    ["rbxassetid://93038040448121"] = {name = "Nurse Shark", prices = {["default"] = 2.1, ["Ride"] = 21.98, ["Neon"] = 7.79, ["Neon|Ride"] = 65.54, ["Mega"] = 90.95, ["Mega|Ride"] = 106.64, ["Mega|Fly|Ride"] = 231.99}},
    ["rbxassetid://13936750528"] = {name = "River", prices = {["default"] = 11.12}},
    ["rbxassetid://103142927308458"] = {name = "Black-Footed Ferret", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 33.65, ["Fly|Ride"] = 57.67, ["Neon"] = 8.29, ["Neon|Ride"] = 41.2, ["Neon|Fly|Ride"] = 116.25, ["Mega"] = 47.07, ["Mega|Ride"] = 109.6, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://3199974219"] = {name = "Pet Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13803784751"] = {name = "Happy Clam", prices = {["default"] = 137.96, ["Ride"] = 137.97, ["Fly|Ride"] = 262.5, ["Neon"] = 686.75, ["Neon|Ride"] = 674.4, ["Neon|Fly|Ride"] = 787.5, ["Mega"] = 3557.34, ["Mega|Ride"] = 2231.25, ["Mega|Fly|Ride"] = 2835}},
    ["rbxassetid://13665210525"] = {name = "Warthog", prices = {["default"] = 5.9, ["Ride"] = 41.2, ["Neon"] = 20.9, ["Neon|Ride"] = 55.79, ["Neon|Fly|Ride"] = 155.43, ["Mega"] = 173.15, ["Mega|Ride"] = 202.85, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://18515939072"] = {name = "Black Marlin", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 27.77, ["Neon"] = 6.18, ["Neon|Ride"] = 24.7, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 45.42, ["Mega|Ride"] = 100.08, ["Mega|Fly|Ride"] = 134.53}},
    ["rbxassetid://16075008092"] = {name = "Fanghorn Tortoise", prices = {["default"] = 5.81, ["Ride"] = 26.5, ["Neon"] = 45.87, ["Neon|Ride"] = 110.18, ["Neon|Fly|Ride"] = 164.07, ["Mega|Ride"] = 258.47, ["Mega|Fly|Ride"] = 614.75}},
    ["rbxassetid://8566684181"] = {name = "Giant Black Scarab", prices = {["default"] = 13.13, ["Fly"] = 25.47, ["Ride"] = 20.96, ["Fly|Ride"] = 54.52, ["Neon"] = 88.5, ["Neon|Ride"] = 117.91, ["Neon|Fly|Ride"] = 185.59, ["Mega"] = 597.19, ["Mega|Ride"] = 479.07, ["Mega|Fly|Ride"] = 481.69}},
    ["rbxassetid://118691035196137"] = {name = "Shiver Wolf", prices = {["default"] = 35.01, ["Ride"] = 60.38, ["Fly|Ride"] = 122.93, ["Neon"] = 155.56, ["Neon|Ride"] = 163.72, ["Neon|Fly|Ride"] = 315, ["Mega|Ride"] = 585.65, ["Mega|Fly|Ride"] = 704.17}},
    ["rbxassetid://3743735223"] = {name = "Brown Bear", prices = {["default"] = 171.93, ["Fly"] = 183.75, ["Ride"] = 195.56, ["Fly|Ride"] = 231.95, ["Neon"] = 402.59, ["Neon|Ride"] = 577.5, ["Neon|Fly|Ride"] = 630.23, ["Mega|Fly|Ride"] = 2493.75}},
    ["rbxassetid://3934251801"] = {name = "Sloth", prices = {["default"] = 24.75, ["Fly"] = 51.19, ["Ride"] = 41.2, ["Fly|Ride"] = 77.57, ["Neon"] = 177.94, ["Neon|Fly"] = 204.91, ["Neon|Ride"] = 127.21, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 549.88, ["Mega|Ride"] = 549.88, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://12139338880"] = {name = "Frogspawn", prices = {["default"] = 3.89, ["Fly"] = 131.23, ["Ride"] = 20.61, ["Fly|Ride"] = 65.62, ["Neon"] = 13.13, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 105, ["Mega"] = 135.19, ["Mega|Ride"] = 203.89, ["Mega|Fly|Ride"] = 254.68}},
    ["rbxassetid://8070926551"] = {name = "Snow Leopard", prices = {["default"] = 8.99, ["Fly"] = 231.97, ["Ride"] = 32.48, ["Fly|Ride"] = 117.39, ["Neon"] = 63.68, ["Neon|Fly"] = 137.97, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 376.82, ["Mega|Ride"] = 433.13, ["Mega|Fly|Ride"] = 393.74}},
    ["rbxassetid://76712147705770"] = {name = "Tuxedo Cat", prices = {["default"] = 43.71, ["Fly"] = 143.13, ["Ride"] = 77.44, ["Fly|Ride"] = 137.82, ["Neon"] = 247.11, ["Neon|Ride"] = 245.44, ["Neon|Fly|Ride"] = 406.88, ["Mega"] = 1544.6, ["Mega|Ride"] = 1029.73, ["Mega|Fly|Ride"] = 1093.83}},
    ["rbxassetid://15685468962"] = {name = "Tasmanian Devil", prices = {["default"] = 16.96, ["Ride"] = 122.54, ["Neon"] = 137.97, ["Neon|Ride"] = 243, ["Neon|Fly|Ride"] = 454.07, ["Mega"] = 683.82, ["Mega|Ride"] = 765.53, ["Mega|Fly|Ride"] = 823.79}},
    ["rbxassetid://123288277753363"] = {name = "Tri-horned Treehopper", prices = {["default"] = 327.39, ["Ride"] = 615.57, ["Neon|Ride"] = 3093.23}},
    ["rbxassetid://6060987821"] = {name = "Yeti", prices = {["default"] = 35.44, ["Fly"] = 69.51, ["Ride"] = 36.05, ["Fly|Ride"] = 74.92, ["Neon"] = 224.26, ["Neon|Ride"] = 227.07, ["Neon|Fly|Ride"] = 274.93, ["Mega"] = 1034.25, ["Mega|Ride"] = 909.57, ["Mega|Fly|Ride"] = 892.79}},
    ["rbxassetid://9549841158"] = {name = "Zebra", prices = {["default"] = 2.1, ["Fly"] = 37.27, ["Ride"] = 15.45, ["Fly|Ride"] = 102.55, ["Neon"] = 2.63, ["Neon|Ride"] = 16.27, ["Neon|Fly|Ride"] = 64.35, ["Mega"] = 22.01, ["Mega|Fly"] = 102.74, ["Mega|Ride"] = 123.59, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://13883282884"] = {name = "Hermit Crab", prices = {["default"] = 3.94, ["Ride"] = 19.69, ["Neon"] = 17.07, ["Neon|Ride"] = 69.21, ["Neon|Fly|Ride"] = 259.89, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 418.69}},
    ["rbxassetid://92626539723202"] = {name = "Sea Angel", prices = {["default"] = 28.67, ["Ride"] = 65.63, ["Fly|Ride"] = 144.18, ["Neon"] = 19.68, ["Neon|Ride"] = 80.32, ["Neon|Fly|Ride"] = 961.65, ["Mega"] = 119.13, ["Mega|Fly"] = 142.68, ["Mega|Ride"] = 259.5, ["Mega|Fly|Ride"] = 334.69}},
    ["rbxassetid://15848329383"] = {name = "Jellyfish", prices = {["default"] = 422.63, ["Ride"] = 458.07, ["Fly|Ride"] = 509.66, ["Neon"] = 1391.69, ["Neon|Ride"] = 1235.52, ["Neon|Fly|Ride"] = 1235.52, ["Mega|Fly|Ride"] = 4856.25}},
    ["rbxassetid://5721843846"] = {name = "Sabertooth", prices = {["default"] = 4.13, ["Fly"] = 61.2, ["Ride"] = 15.65, ["Fly|Ride"] = 52.49, ["Neon"] = 22.31, ["Neon|Ride"] = 49.43, ["Neon|Fly|Ride"] = 82.39, ["Mega"] = 168, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 410.92}},
    ["rbxassetid://9475753090"] = {name = "Albatross", prices = {["default"] = 7.62, ["Fly"] = 20.9, ["Ride"] = 17.07, ["Fly|Ride"] = 43.26, ["Neon"] = 39.38, ["Neon|Fly"] = 156.45, ["Neon|Ride"] = 411.86, ["Neon|Fly|Ride"] = 118.13, ["Mega|Ride"] = 686.83, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://96894173636082"] = {name = "Clementine Owl", prices = {["default"] = 5.23, ["Fly"] = 32.51, ["Ride"] = 27.57, ["Neon"] = 13.12, ["Neon|Fly"] = 94.5, ["Neon|Ride"] = 34.13, ["Neon|Fly|Ride"] = 111.36, ["Mega"] = 78.75, ["Mega|Ride"] = 242.82, ["Mega|Fly|Ride"] = 303.78}},
    ["rbxassetid://10318105683"] = {name = "Orange Butterfly", prices = {["default"] = 30.19, ["Fly"] = 34.92, ["Ride"] = 40.2, ["Fly|Ride"] = 82.39, ["Neon"] = 102.98, ["Neon|Ride"] = 205.06, ["Neon|Fly|Ride"] = 210, ["Mega|Ride"] = 822.76, ["Mega|Fly|Ride"] = 643.13}},
    ["rbxassetid://15937689999"] = {name = "Rattlesnake", prices = {["default"] = 2.1, ["Fly"] = 39.37, ["Ride"] = 27.2, ["Fly|Ride"] = 49.8, ["Neon"] = 12.57, ["Neon|Ride"] = 38.07, ["Neon|Fly|Ride"] = 210, ["Mega"] = 160.47, ["Mega|Ride"] = 440.73, ["Mega|Fly|Ride"] = 985.04}},
    ["rbxassetid://10971808447"] = {name = "Evil Basilisk", prices = {["default"] = 4.94, ["Fly"] = 64.26, ["Ride"] = 23.63, ["Fly|Ride"] = 91.88, ["Neon"] = 137.97, ["Neon|Ride"] = 164.34, ["Neon|Fly|Ride"] = 274.93, ["Mega|Ride"] = 741.41, ["Mega|Fly|Ride"] = 826.88}},
    ["rbxassetid://99104623628550"] = {name = "Snorgle", prices = {["default"] = 2.1, ["Ride"] = 19.17, ["Neon"] = 5.25, ["Neon|Ride"] = 27.57, ["Mega"] = 50.93, ["Mega|Ride"] = 138.01, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://136705425555561"] = {name = "Emperor Shrimp", prices = {["default"] = 54.86, ["Ride"] = 137.97, ["Neon"] = 90.62}},
    ["rbxassetid://14398819258"] = {name = "Longhorn Cow", prices = {["default"] = 9.77, ["Ride"] = 80.07, ["Neon"] = 74.46, ["Neon|Ride"] = 123.56, ["Neon|Fly|Ride"] = 411.86, ["Mega"] = 316.32, ["Mega|Ride"] = 272.9, ["Mega|Fly|Ride"] = 546.8}},
    ["rbxassetid://4708551284"] = {name = "Koala", prices = {["default"] = 15.75, ["Fly"] = 31.34, ["Ride"] = 30.9, ["Fly|Ride"] = 55.8, ["Neon"] = 51.16, ["Neon|Fly"] = 115.99, ["Neon|Ride"] = 62.65, ["Neon|Fly|Ride"] = 123.59, ["Mega"] = 578.71, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://4115249264"] = {name = "Zombie Buffalo", prices = {["default"] = 301.88, ["Fly"] = 411.74, ["Ride"] = 315, ["Fly|Ride"] = 393.74, ["Neon"] = 1468.21, ["Neon|Ride"] = 1312.5, ["Neon|Fly|Ride"] = 1291.13, ["Mega|Fly|Ride"] = 5143.46}},
    ["rbxassetid://8939633862"] = {name = "Salamander", prices = {["default"] = 2.1, ["Ride"] = 15.31, ["Fly|Ride"] = 56.8, ["Neon"] = 11.82, ["Neon|Fly"] = 77.72, ["Neon|Ride"] = 32.28, ["Neon|Fly|Ride"] = 158.17, ["Mega"] = 212.27, ["Mega|Ride"] = 155.44, ["Mega|Fly|Ride"] = 291.14}},
    ["rbxassetid://7734902431"] = {name = "Halloween White Mummy Cat", prices = {["default"] = 5.92, ["Fly"] = 27.77, ["Ride"] = 45.92, ["Fly|Ride"] = 77.72, ["Neon"] = 39.19, ["Neon|Ride"] = 132.23, ["Neon|Fly|Ride"] = 261.53, ["Mega"] = 278.11, ["Mega|Ride"] = 329.53}},
    ["rbxassetid://115869632070663"] = {name = "Snowball Pug", prices = {["default"] = 26.25, ["Ride"] = 393.65, ["Fly|Ride"] = 231.95, ["Neon"] = 118.13, ["Neon|Ride"] = 187.22, ["Neon|Fly|Ride"] = 275.63, ["Mega"] = 328.12, ["Mega|Ride"] = 363.57, ["Mega|Fly|Ride"] = 521.73}},
    ["rbxassetid://8077189379"] = {name = "Husky", prices = {["default"] = 94.5, ["Ride"] = 163.63, ["Fly|Ride"] = 192.91, ["Neon"] = 1098.59, ["Neon|Ride"] = 1466.16, ["Neon|Fly|Ride"] = 1317.89, ["Mega"] = 3093.4, ["Mega|Ride"] = 1794.19, ["Mega|Fly|Ride"] = 2690.92}},
    ["rbxassetid://98003529163435"] = {name = "Maine Coon", prices = {["default"] = 34.74, ["Fly"] = 102.38, ["Ride"] = 77.23, ["Fly|Ride"] = 139.17, ["Neon"] = 97.1, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 199.02, ["Mega"] = 242.82, ["Mega|Ride"] = 275.63, ["Mega|Fly|Ride"] = 392.44}},
    ["rbxassetid://12488273089"] = {name = "Yellow-lipped Sea Krait", prices = {["default"] = 2.1, ["Fly"] = 28.87, ["Ride"] = 16.94, ["Fly|Ride"] = 52.5, ["Neon"] = 10.28, ["Neon|Fly|Ride"] = 65.54, ["Mega"] = 52.5, ["Mega|Ride"] = 193.72, ["Mega|Fly|Ride"] = 155.44}},
    ["rbxassetid://96760582519875"] = {name = "Cozy Mistletroll", prices = {["default"] = 7.88, ["Ride"] = 38.48, ["Neon"] = 39.44, ["Neon|Ride"] = 94.25, ["Neon|Fly|Ride"] = 172.81, ["Mega"] = 136.5, ["Mega|Ride"] = 185.07, ["Mega|Fly|Ride"] = 306.99}},
    ["rbxassetid://85229142142232"] = {name = "Bunny Swirl", prices = {["default"] = 82.64, ["Fly"] = 196.88, ["Ride"] = 107.19, ["Fly|Ride"] = 216.57, ["Neon"] = 185.55, ["Neon|Ride"] = 177.19, ["Neon|Fly|Ride"] = 397.52, ["Mega"] = 467.78, ["Mega|Ride"] = 529.29, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://121192022038625"] = {name = "Stygian Owl", prices = {["default"] = 3.15, ["Ride"] = 131.25, ["Neon"] = 8.26, ["Neon|Fly"] = 82.39, ["Neon|Ride"] = 51.1, ["Neon|Fly|Ride"] = 190.3, ["Mega"] = 91.88, ["Mega|Ride"] = 154.21, ["Mega|Fly|Ride"] = 153.57}},
    ["rbxassetid://83732262844708"] = {name = "Pain au Chat", prices = {["default"] = 13.13, ["Fly|Ride"] = 274.93, ["Neon"] = 89.25, ["Neon|Ride"] = 401.03, ["Mega"] = 523.69, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 814.53}},
    ["rbxassetid://12792506715"] = {name = "Goose", prices = {["default"] = 1006.69, ["Fly"] = 1257.22, ["Ride"] = 1036.88, ["Fly|Ride"] = 1189.42, ["Neon"] = 3020.83, ["Neon|Ride"] = 3267.94, ["Neon|Fly|Ride"] = 2754.94, ["Mega|Fly|Ride"] = 14280.17}},
    ["rbxassetid://12779257292"] = {name = "Pudding Cat", prices = {["default"] = 18.38, ["Fly"] = 115.99, ["Ride"] = 120.81, ["Fly|Ride"] = 191.63, ["Neon"] = 129.94, ["Neon|Fly"] = 892.5, ["Neon|Ride"] = 192.54, ["Mega"] = 961.77, ["Mega|Ride"] = 686.83, ["Mega|Fly|Ride"] = 649.69}},
    ["rbxassetid://83376259738301"] = {name = "Mrs. Whiskerpips", prices = {["default"] = 3.94, ["Fly"] = 49.26, ["Ride"] = 20.61, ["Fly|Ride"] = 80.89, ["Neon"] = 12.5, ["Neon|Fly"] = 79.83, ["Neon|Ride"] = 30.19, ["Neon|Fly|Ride"] = 99.75, ["Mega"] = 82.37, ["Mega|Ride"] = 107.16, ["Mega|Fly|Ride"] = 181.92}},
    ["rbxassetid://110894046614323"] = {name = "Partridge", prices = {["default"] = 7.41, ["Ride"] = 47.25, ["Fly|Ride"] = 137.97, ["Neon"] = 59.07, ["Neon|Fly|Ride"] = 393.73, ["Mega"] = 261.57, ["Mega|Ride"] = 344.3, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://114034119324343"] = {name = "Muskrat", prices = {["default"] = 2.1, ["Ride"] = 18.48, ["Fly|Ride"] = 59.49, ["Neon"] = 3.15, ["Neon|Ride"] = 22.56, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 22.67, ["Mega|Fly"] = 123.59, ["Mega|Ride"] = 48.07, ["Mega|Fly|Ride"] = 155.44}},
    ["rbxassetid://15547904644"] = {name = "Harp Seal", prices = {["default"] = 64.31, ["Ride"] = 118.41, ["Fly|Ride"] = 228.38, ["Neon"] = 304.77, ["Neon|Ride"] = 393.74, ["Neon|Fly|Ride"] = 433.13, ["Mega"] = 1051.46, ["Mega|Ride"] = 1392.2, ["Mega|Fly|Ride"] = 2471.34}},
    ["rbxassetid://14978702254"] = {name = "Scarecrow Cat", prices = {["default"] = 11.71, ["Ride"] = 24.94, ["Fly|Ride"] = 124.68, ["Neon"] = 46.35, ["Neon|Ride"] = 223.12, ["Neon|Fly|Ride"] = 109.05, ["Mega"] = 588.08, ["Mega|Ride"] = 479.87, ["Mega|Fly|Ride"] = 538.13}},
    ["rbxassetid://95871612352029"] = {name = "Cold Cube", prices = {["default"] = 3.61, ["Ride"] = 26.69, ["Fly|Ride"] = 62.63, ["Neon"] = 13.12, ["Neon|Ride"] = 47.23, ["Mega"] = 99.74, ["Mega|Ride"] = 157.5}},
    ["rbxassetid://114456035353449"] = {name = "Bauble Buddies", prices = {["default"] = 83.95, ["Ride"] = 78.75, ["Fly|Ride"] = 157.5, ["Neon"] = 241.97, ["Neon|Fly"] = 274.93, ["Neon|Fly|Ride"] = 343.89, ["Mega"] = 684.36, ["Mega|Ride"] = 1029.73, ["Mega|Fly|Ride"] = 773.66}},
    ["rbxassetid://15383967605"] = {name = "Gingerbread Mouse", prices = {["default"] = 24.29, ["Fly"] = 27.82, ["Ride"] = 52.49, ["Fly|Ride"] = 82.39, ["Neon"] = 47.54, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 315, ["Mega"] = 427.34, ["Mega|Ride"] = 513.4, ["Mega|Fly|Ride"] = 467.51}},
    ["rbxassetid://11767069383"] = {name = "Woolly Rhino", prices = {["default"] = 39.04, ["Ride"] = 84, ["Neon"] = 387.34, ["Neon|Ride"] = 654.94, ["Neon|Fly|Ride"] = 943.69, ["Mega"] = 1867.7, ["Mega|Ride"] = 1647.57, ["Mega|Fly|Ride"] = 2059.45}},
    ["rbxassetid://95133623103638"] = {name = "Samoyed", prices = {["default"] = 6.46, ["Ride"] = 60.54, ["Neon"] = 26.25, ["Neon|Ride"] = 93.09, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 141.64, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 288.05}},
    ["rbxassetid://8071236757"] = {name = "St Bernard", prices = {["default"] = 6.57, ["Ride"] = 22.32, ["Fly|Ride"] = 78.74, ["Neon"] = 63, ["Neon|Ride"] = 65.76, ["Neon|Fly|Ride"] = 159.6, ["Mega"] = 399, ["Mega|Ride"] = 381.01, ["Mega|Fly|Ride"] = 467.51}},
    ["rbxassetid://14276930615"] = {name = "Alley Cat", prices = {["default"] = 110.25, ["Fly"] = 514.82, ["Ride"] = 152.39, ["Fly|Ride"] = 271.09, ["Neon"] = 552.13, ["Neon|Ride"] = 565.8, ["Neon|Fly|Ride"] = 601.26, ["Mega|Ride"] = 2335.15, ["Mega|Fly|Ride"] = 1929.38}},
    ["rbxassetid://6498256417"] = {name = "Dolphin", prices = {["default"] = 2.1, ["Fly"] = 27.66, ["Ride"] = 15.65, ["Fly|Ride"] = 41.16, ["Neon"] = 10.5, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 27.98, ["Neon|Fly|Ride"] = 73.5, ["Mega"] = 124.59, ["Mega|Fly"] = 124.11, ["Mega|Ride"] = 184.33, ["Mega|Fly|Ride"] = 150.94}},
    ["rbxassetid://7734900468"] = {name = "Halloween White Skeleton Dog", prices = {["default"] = 8.54, ["Fly"] = 95.78, ["Ride"] = 24.94, ["Fly|Ride"] = 91.88, ["Neon"] = 73.94, ["Neon|Fly"] = 231.98, ["Neon|Ride"] = 92.8, ["Neon|Fly|Ride"] = 178.5, ["Mega"] = 384.6, ["Mega|Ride"] = 329.53, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://9982202041"] = {name = "Poodle", prices = {["default"] = 2.1, ["Ride"] = 12.39, ["Fly|Ride"] = 43.31, ["Neon"] = 2.1, ["Neon|Fly"] = 24.35, ["Neon|Ride"] = 15.45, ["Neon|Fly|Ride"] = 39.67, ["Mega"] = 15.74, ["Mega|Fly"] = 48.74, ["Mega|Ride"] = 34.22, ["Mega|Fly|Ride"] = 84.87}},
    ["rbxassetid://73671766703168"] = {name = "Pilot Gull", prices = {["default"] = 2.1, ["Ride"] = 23.21, ["Neon"] = 2.1, ["Neon|Ride"] = 39.15, ["Mega"] = 30.16, ["Mega|Fly"] = 104.99, ["Mega|Ride"] = 61.76, ["Mega|Fly|Ride"] = 125.99}},
    ["rbxassetid://14146127209"] = {name = "Indian Leopard", prices = {["default"] = 2.63, ["Fly"] = 35.02, ["Ride"] = 18.38, ["Fly|Ride"] = 85.78, ["Neon"] = 14.97, ["Neon|Ride"] = 59.2, ["Mega"] = 262.5, ["Mega|Fly|Ride"] = 240.85}},
    ["rbxassetid://113558592714438"] = {name = "Seabed Creeper", prices = {["default"] = 32.82, ["Ride"] = 52.47, ["Neon"] = 117.74, ["Neon|Ride"] = 411.86, ["Neon|Fly|Ride"] = 630, ["Mega"] = 418.4, ["Mega|Ride"] = 523.69, ["Mega|Fly|Ride"] = 667.27}},
    ["rbxassetid://4281674713"] = {name = "Bee", prices = {["default"] = 3.94, ["Fly"] = 16.96, ["Ride"] = 16.35, ["Fly|Ride"] = 35.97, ["Neon"] = 14.33, ["Neon|Fly"] = 21, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 61.41, ["Mega"] = 114.09, ["Mega|Fly"] = 170.6, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 155.44}},
    ["rbxassetid://5862774392"] = {name = "Bat", prices = {["default"] = 9.34, ["Fly"] = 38.26, ["Ride"] = 26.76, ["Fly|Ride"] = 55.61, ["Neon"] = 21.84, ["Neon|Fly"] = 68.54, ["Neon|Ride"] = 27.82, ["Neon|Fly|Ride"] = 90.09, ["Mega"] = 182.44, ["Mega|Fly"] = 411.9, ["Mega|Ride"] = 184.63, ["Mega|Fly|Ride"] = 233.89}},
    ["rbxassetid://18223359092"] = {name = "Birthday Butterfly 2024", prices = {["default"] = 2.63, ["Fly"] = 21.32, ["Ride"] = 18.09, ["Fly|Ride"] = 80.32, ["Neon"] = 7.55, ["Neon|Fly"] = 85.84, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 89.23, ["Mega"] = 103.29, ["Mega|Fly"] = 123.59, ["Mega|Ride"] = 204.75, ["Mega|Fly|Ride"] = 127.32}},
    ["rbxassetid://17822765706"] = {name = "Pink Betta Fish", prices = {["default"] = 7.71, ["Fly"] = 36.05, ["Ride"] = 23.34, ["Neon"] = 36.05, ["Neon|Ride"] = 81, ["Neon|Fly|Ride"] = 274.95, ["Mega"] = 220.38, ["Mega|Fly"] = 400.32, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 411.9}},
    ["rbxassetid://14146174264"] = {name = "Rock Pigeon", prices = {["default"] = 9.14, ["Ride"] = 122.72, ["Fly|Ride"] = 220.36, ["Neon"] = 46.4, ["Neon|Ride"] = 262.39, ["Mega"] = 411.9, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://11758575946"] = {name = "Water Moon Bear", prices = {["default"] = 2.63, ["Fly"] = 42.21, ["Ride"] = 25.52, ["Fly|Ride"] = 44.35, ["Neon"] = 21, ["Neon|Fly"] = 196.67, ["Neon|Ride"] = 64.87, ["Neon|Fly|Ride"] = 109.35, ["Mega"] = 329.53, ["Mega|Ride"] = 274.95, ["Mega|Fly|Ride"] = 418.28}},
    ["rbxassetid://6498256132"] = {name = "Seahorse", prices = {["default"] = 2.1, ["Fly"] = 20.79, ["Ride"] = 15.74, ["Fly|Ride"] = 34.9, ["Neon"] = 11.81, ["Neon|Fly"] = 68.99, ["Neon|Ride"] = 30.9, ["Neon|Fly|Ride"] = 78.74, ["Mega"] = 131.15, ["Mega|Ride"] = 231.99, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://13664973582"] = {name = "Many Mackerel", prices = {["default"] = 183.72, ["Fly"] = 393.75, ["Ride"] = 308.88, ["Fly|Ride"] = 392.43, ["Neon"] = 1126.39, ["Neon|Ride"] = 1356.98, ["Neon|Fly|Ride"] = 1091.39, ["Mega|Fly|Ride"] = 3740.63}},
    ["rbxassetid://114806716799554"] = {name = "Ringmaster Gibbon", prices = {["default"] = 8.91, ["Ride"] = 62.39, ["Neon"] = 42.94, ["Neon|Ride"] = 55.61, ["Neon|Fly|Ride"] = 411.86, ["Mega"] = 120.84, ["Mega|Ride"] = 543.64, ["Mega|Fly|Ride"] = 472.49}},
    ["rbxassetid://14360917588"] = {name = "Magma Moose", prices = {["default"] = 2.52, ["Fly"] = 102.04, ["Ride"] = 21.63, ["Fly|Ride"] = 79.07, ["Neon"] = 20.26, ["Neon|Fly"] = 274.93, ["Neon|Ride"] = 53.55, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 201.1, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://18957942216"] = {name = "Starhopper", prices = {["default"] = 3.7, ["Ride"] = 35.02, ["Neon"] = 45.94, ["Neon|Ride"] = 213.44, ["Neon|Fly|Ride"] = 617.76, ["Mega"] = 462.81, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 549.29}},
    ["rbxassetid://3181727071"] = {name = "Puma", prices = {["default"] = 2.1, ["Fly"] = 12.37, ["Ride"] = 13.02, ["Fly|Ride"] = 36.05, ["Neon"] = 2.1, ["Neon|Fly"] = 28.76, ["Neon|Ride"] = 15.18, ["Neon|Fly|Ride"] = 44.63, ["Mega"] = 18.38, ["Mega|Fly"] = 162.75, ["Mega|Ride"] = 31.5, ["Mega|Fly|Ride"] = 96.46}},
    ["rbxassetid://4841039508"] = {name = "Rock", prices = {["default"] = 2.63, ["Fly"] = 24.92, ["Ride"] = 18.94, ["Fly|Ride"] = 61.15, ["Neon"] = 9.19, ["Neon|Ride"] = 26.17, ["Neon|Fly|Ride"] = 95.78, ["Mega"] = 85.32, ["Mega|Ride"] = 143.6, ["Mega|Fly|Ride"] = 207.38}},
    ["rbxassetid://94235745630523"] = {name = "Rainbow Trout", prices = {["default"] = 3.29, ["Ride"] = 144.38, ["Fly|Ride"] = 196.66, ["Neon"] = 26.25, ["Neon|Ride"] = 274.93, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 78.75, ["Mega|Ride"] = 204.93, ["Mega|Fly|Ride"] = 309.7}},
    ["rbxassetid://4440867249"] = {name = "Llama", prices = {["default"] = 77.23, ["Fly"] = 162.39, ["Ride"] = 92.76, ["Fly|Ride"] = 158.82, ["Neon"] = 619.32, ["Neon|Ride"] = 566, ["Neon|Fly|Ride"] = 420, ["Mega"] = 2059.45, ["Mega|Ride"] = 3434.12, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://11571113805"] = {name = "Bloodhound", prices = {["default"] = 9.24, ["Fly"] = 91.88, ["Ride"] = 30.16, ["Fly|Ride"] = 262.48, ["Neon"] = 22.32, ["Neon|Ride"] = 102.98, ["Neon|Fly|Ride"] = 122.54, ["Mega"] = 211.54, ["Mega|Ride"] = 777.73, ["Mega|Fly|Ride"] = 410.87}},
    ["rbxassetid://78423968285099"] = {name = "Wren", prices = {["default"] = 2.5, ["Fly"] = 20.99, ["Ride"] = 41.11, ["Neon"] = 3.94, ["Neon|Ride"] = 177.06, ["Neon|Fly|Ride"] = 522.01, ["Mega"] = 52.5, ["Mega|Fly"] = 313.69, ["Mega|Ride"] = 82.4, ["Mega|Fly|Ride"] = 102.08}},
    ["rbxassetid://110871792705214"] = {name = "Burger Bear", prices = {["default"] = 59.07, ["Fly"] = 77.73, ["Ride"] = 94.39, ["Fly|Ride"] = 208.76, ["Neon"] = 155.42, ["Neon|Ride"] = 223.13, ["Neon|Fly|Ride"] = 309.68, ["Mega"] = 636.57, ["Mega|Ride"] = 614.25, ["Mega|Fly|Ride"] = 728.43}},
    ["rbxassetid://3181727637"] = {name = "Fennec Fox", prices = {["default"] = 2.1, ["Fly"] = 14.44, ["Ride"] = 13.78, ["Fly|Ride"] = 30.2, ["Neon"] = 2.1, ["Neon|Fly"] = 18.55, ["Neon|Ride"] = 15.68, ["Neon|Fly|Ride"] = 35.15, ["Mega"] = 16.96, ["Mega|Fly"] = 49.38, ["Mega|Ride"] = 47.38, ["Mega|Fly|Ride"] = 102.99}},
    ["rbxassetid://115530716039589"] = {name = "Milk Choccybunny", prices = {["default"] = 2.1, ["Neon"] = 3.93, ["Neon|Ride"] = 64.87, ["Neon|Fly|Ride"] = 179.19, ["Mega"] = 19.59, ["Mega|Ride"] = 96.81, ["Mega|Fly|Ride"] = 205.96}},
    ["rbxassetid://83001092186817"] = {name = "White Choccybunny", prices = {["default"] = 4.65, ["Ride"] = 107.63, ["Neon"] = 10.5, ["Neon|Ride"] = 108.61, ["Neon|Fly|Ride"] = 181.22, ["Mega"] = 59.07, ["Mega|Fly"] = 179.19, ["Mega|Ride"] = 116.16, ["Mega|Fly|Ride"] = 210.3}},
    ["rbxassetid://103795616446776"] = {name = "Waffle Wyrm", prices = {["default"] = 11.33, ["Fly"] = 45.94, ["Ride"] = 51.5, ["Fly|Ride"] = 105, ["Neon"] = 27.82, ["Neon|Fly"] = 137.97, ["Neon|Ride"] = 72.19, ["Neon|Fly|Ride"] = 171.67, ["Mega"] = 199.78, ["Mega|Fly"] = 332.9, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 288.74}},
    ["rbxassetid://9982358951"] = {name = "Orangutan", prices = {["default"] = 2.1, ["Fly"] = 15.45, ["Ride"] = 15.4, ["Fly|Ride"] = 31.94, ["Neon"] = 2.41, ["Neon|Fly"] = 25.66, ["Neon|Ride"] = 20.61, ["Neon|Fly|Ride"] = 32.82, ["Mega"] = 18.04, ["Mega|Ride"] = 48.24, ["Mega|Fly|Ride"] = 118.12}},
    ["rbxassetid://129021417712364"] = {name = "Kage Crow", prices = {["default"] = 22.12, ["Fly"] = 131.25, ["Ride"] = 123.56, ["Neon"] = 104.82, ["Neon|Fly"] = 411.86, ["Neon|Ride"] = 183.74, ["Neon|Fly|Ride"] = 961.65, ["Mega"] = 410.87, ["Mega|Ride"] = 438.38, ["Mega|Fly|Ride"] = 686.83}},
    ["rbxassetid://4849941238"] = {name = "Hedgehog", prices = {["default"] = 2782.96, ["Ride"] = 2609, ["Fly|Ride"] = 2559.38, ["Neon|Fly|Ride"] = 9595.81, ["Mega|Fly|Ride"] = 34598.61}},
    ["rbxassetid://4800190144"] = {name = "Ginger Cat", prices = {["default"] = 2.1, ["Fly"] = 132.42, ["Ride"] = 15.83, ["Fly|Ride"] = 44.61, ["Neon"] = 15.44, ["Neon|Fly"] = 62.65, ["Neon|Ride"] = 23.7, ["Neon|Fly|Ride"] = 45.66, ["Mega"] = 76.21, ["Mega|Fly"] = 459.27, ["Mega|Ride"] = 99.75, ["Mega|Fly|Ride"] = 156.19}},
    ["rbxassetid://18119333909"] = {name = "Rodeo Bull", prices = {["default"] = 2.1, ["Neon"] = 5.16, ["Mega"] = 187.04, ["Mega|Fly"] = 441, ["Mega|Ride"] = 437.07, ["Mega|Fly|Ride"] = 412.13}},
    ["rbxassetid://11837080223"] = {name = "Highland Cow", prices = {["default"] = 25.52, ["Fly"] = 110.18, ["Ride"] = 32.96, ["Fly|Ride"] = 105, ["Neon"] = 118.12, ["Neon|Ride"] = 105.56, ["Neon|Fly|Ride"] = 275.63, ["Mega"] = 343.94, ["Mega|Ride"] = 403.67, ["Mega|Fly|Ride"] = 482.9}},
    ["rbxassetid://14398816006"] = {name = "Rooster", prices = {["default"] = 32.41, ["Ride"] = 66.94, ["Neon"] = 171.66, ["Neon|Ride"] = 205.94, ["Neon|Fly|Ride"] = 274.93, ["Mega"] = 1235.68, ["Mega|Ride"] = 815.55, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://3409444089"] = {name = "Hyena", prices = {["default"] = 144.41, ["Fly"] = 1373.49, ["Ride"] = 197.87, ["Fly|Ride"] = 220.36, ["Neon"] = 1312.5, ["Neon|Ride"] = 693.39, ["Neon|Fly|Ride"] = 881.57, ["Mega"] = 6178.33, ["Mega|Fly|Ride"] = 3412.5}},
    ["rbxassetid://127067345833475"] = {name = "Hummingbird", prices = {["default"] = 5.71, ["Ride"] = 28.88, ["Fly|Ride"] = 675.94, ["Neon"] = 18.38, ["Neon|Ride"] = 140.14, ["Mega"] = 156.19, ["Mega|Ride"] = 164.77, ["Mega|Fly|Ride"] = 582.75}},
    ["rbxassetid://130497948875084"] = {name = "Marabou Stork", prices = {["default"] = 2.1, ["Ride"] = 55.61, ["Fly|Ride"] = 137.97, ["Neon"] = 13.13, ["Neon|Ride"] = 274.93, ["Mega"] = 124.41, ["Mega|Ride"] = 320.15, ["Mega|Fly|Ride"] = 419.99}},
    ["rbxassetid://127017727552531"] = {name = "Angus Calf", prices = {["default"] = 2.63, ["Fly"] = 101.99, ["Ride"] = 40.61, ["Neon"] = 11.46, ["Neon|Ride"] = 24.73, ["Mega"] = 82.55, ["Mega|Ride"] = 112.53, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://12779130089"] = {name = "Sprout Snail", prices = {["default"] = 10.5, ["Ride"] = 102.98, ["Neon"] = 135.19, ["Neon|Ride"] = 1165.82, ["Mega"] = 463.97, ["Mega|Ride"] = 612.69, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://117824155556510"] = {name = "Princess Mare", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 47.57, ["Mega"] = 16.89, ["Mega|Fly"] = 116, ["Mega|Ride"] = 87.94, ["Mega|Fly|Ride"] = 274.95}},
    ["rbxassetid://122766274014139"] = {name = "Gaelic Fae", prices = {["default"] = 85.32, ["Fly"] = 137.97, ["Ride"] = 110.18, ["Fly|Ride"] = 160.01, ["Neon"] = 454.07, ["Neon|Fly"] = 257.41, ["Neon|Ride"] = 451.5, ["Neon|Fly|Ride"] = 511.49, ["Mega"] = 1050, ["Mega|Fly|Ride"] = 1736.13}},
    ["rbxassetid://17255807019"] = {name = "Weevil", prices = {["default"] = 2.1, ["Ride"] = 91.82, ["Neon"] = 10.21, ["Neon|Ride"] = 68.99, ["Neon|Fly|Ride"] = 205.96, ["Mega"] = 118.13, ["Mega|Ride"] = 253.33, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://3743720235"] = {name = "Capybara", prices = {["default"] = 44.63, ["Fly"] = 205.94, ["Ride"] = 85.5, ["Fly|Ride"] = 154.03, ["Neon"] = 262.5, ["Neon|Ride"] = 274.93, ["Neon|Fly|Ride"] = 686.75, ["Mega"] = 2625, ["Mega|Fly|Ride"] = 1547.44}},
    ["rbxassetid://106815320234576"] = {name = "Ehecatl", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 19.51, ["Fly|Ride"] = 51.33, ["Neon"] = 4.55, ["Neon|Fly"] = 87.44, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 83.98, ["Mega"] = 78.28, ["Mega|Ride"] = 118.12, ["Mega|Fly|Ride"] = 168.51}},
    ["rbxassetid://110449571836616"] = {name = "Irish Setter", prices = {["default"] = 6.51, ["Neon"] = 21, ["Neon|Ride"] = 105, ["Mega"] = 63.93, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://93751644677101"] = {name = "Winter Doe", prices = {["default"] = 7.65, ["Ride"] = 68.99, ["Neon"] = 104.81, ["Neon|Ride"] = 101.95, ["Neon|Fly|Ride"] = 205.94, ["Mega"] = 232.4, ["Mega|Ride"] = 346.01, ["Mega|Fly|Ride"] = 773.66}},
    ["rbxassetid://90667836208550"] = {name = "Munchkin Cat", prices = {["default"] = 354.38, ["Ride"] = 465.22, ["Fly|Ride"] = 551.25, ["Neon"] = 1157.34, ["Neon|Ride"] = 1729.73, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Ride"] = 4725, ["Mega|Fly|Ride"] = 3846.02}},
    ["rbxassetid://3743734696"] = {name = "Rhino", prices = {["default"] = 39.38, ["Ride"] = 55.36, ["Fly|Ride"] = 81.27, ["Neon"] = 274.93, ["Neon|Ride"] = 255.97, ["Neon|Fly|Ride"] = 233.73, ["Mega|Fly|Ride"] = 1098.72}},
    ["rbxassetid://7734928397"] = {name = "Halloween Blue Scorpion", prices = {["default"] = 2.63, ["Fly"] = 49.88, ["Ride"] = 19.68, ["Fly|Ride"] = 91.88, ["Neon"] = 9.09, ["Neon|Fly"] = 85.32, ["Neon|Ride"] = 21.87, ["Neon|Fly|Ride"] = 89.25, ["Mega"] = 59.07, ["Mega|Ride"] = 85.32, ["Mega|Fly|Ride"] = 96.81}},
    ["rbxassetid://116859365721104"] = {name = "Shadow Dragon Ducky", prices = {["default"] = 15.75, ["Fly"] = 219.18, ["Ride"] = 52.03, ["Fly|Ride"] = 124.09, ["Neon"] = 64.32, ["Neon|Fly"] = 185.58, ["Neon|Ride"] = 69.61, ["Neon|Fly|Ride"] = 180.55, ["Mega"] = 249.38, ["Mega|Fly"] = 954.59, ["Mega|Ride"] = 263.82, ["Mega|Fly|Ride"] = 377.87}},
    ["rbxassetid://6060991084"] = {name = "Musk Ox", prices = {["default"] = 10.28, ["Ride"] = 20.68, ["Fly|Ride"] = 262.56, ["Neon"] = 139, ["Neon|Ride"] = 76.2, ["Mega"] = 1098.72, ["Mega|Ride"] = 514.5, ["Mega|Fly|Ride"] = 412.84}},
    ["rbxassetid://119284351481681"] = {name = "Violet Friend", prices = {["default"] = 3.94, ["Neon"] = 20.69, ["Mega"] = 63, ["Mega|Ride"] = 122.06}},
    ["rbxassetid://10971808356"] = {name = "Basilisk", prices = {["default"] = 2.1, ["Fly"] = 86.62, ["Ride"] = 12.37, ["Fly|Ride"] = 55.61, ["Neon"] = 24.94, ["Neon|Ride"] = 31.9, ["Neon|Fly|Ride"] = 210.06, ["Mega"] = 123.59, ["Mega|Ride"] = 94.75, ["Mega|Fly|Ride"] = 1647.57}},
    ["rbxassetid://3744706727"] = {name = "Platypus", prices = {["default"] = 105, ["Ride"] = 129.74, ["Fly|Ride"] = 223.13, ["Neon"] = 634.39, ["Neon|Ride"] = 616.88, ["Neon|Fly|Ride"] = 769.13, ["Mega|Fly|Ride"] = 2593.87}},
    ["rbxassetid://12480556316"] = {name = "Black Macaque", prices = {["default"] = 51.19, ["Ride"] = 102.98, ["Fly|Ride"] = 137.97, ["Neon"] = 192.94, ["Neon|Ride"] = 192.92, ["Neon|Fly|Ride"] = 274.93, ["Mega"] = 682.5, ["Mega|Ride"] = 730.74, ["Mega|Fly|Ride"] = 673.45}},
    ["rbxassetid://4849941000"] = {name = "Dalmatian", prices = {["default"] = 2168.15, ["Fly"] = 2334.09, ["Ride"] = 2152.5, ["Fly|Ride"] = 2099.99, ["Neon"] = 10982.67, ["Neon|Fly|Ride"] = 5904.05, ["Mega|Fly|Ride"] = 26250}},
    ["rbxassetid://139319822015938"] = {name = "Sea Skeleton Panda", prices = {["default"] = 3.41, ["Fly"] = 65625, ["Ride"] = 75.98, ["Fly|Ride"] = 196.87, ["Neon"] = 13.13, ["Neon|Ride"] = 137.97, ["Neon|Fly|Ride"] = 105, ["Mega"] = 105, ["Mega|Fly"] = 786.19, ["Mega|Ride"] = 190.13, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://104838807480936"] = {name = "Winter Fawn", prices = {["default"] = 15.75, ["Ride"] = 51.24, ["Neon"] = 44.63, ["Neon|Ride"] = 54.53, ["Neon|Fly|Ride"] = 232.32, ["Mega"] = 185.36, ["Mega|Ride"] = 308.94, ["Mega|Fly|Ride"] = 646.68}},
    ["rbxassetid://100705885132301"] = {name = "Cabbit", prices = {["default"] = 1025.1, ["Fly"] = 1208.75, ["Ride"] = 945, ["Fly|Ride"] = 879.38, ["Neon"] = 2778.57, ["Neon|Ride"] = 2611.87, ["Neon|Fly|Ride"] = 2782.5, ["Mega|Fly|Ride"] = 11156.25}},
    ["rbxassetid://12480406935"] = {name = "Binturong", prices = {["default"] = 32.82, ["Fly"] = 68.99, ["Ride"] = 55.61, ["Fly|Ride"] = 173.35, ["Neon"] = 157.5, ["Neon|Ride"] = 297.18, ["Mega"] = 839.9, ["Mega|Ride"] = 804.56, ["Mega|Fly|Ride"] = 851.6}},
    ["rbxassetid://73245262062822"] = {name = "Prism Snake", prices = {["default"] = 2.63, ["Ride"] = 23, ["Fly|Ride"] = 102.98, ["Neon"] = 15.75, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 214.6, ["Mega|Ride"] = 155.44, ["Mega|Fly|Ride"] = 549.88}},
    ["rbxassetid://113717425344888"] = {name = "Magpie", prices = {["default"] = 2.63, ["Fly"] = 52.41, ["Ride"] = 137.97, ["Neon"] = 2.52, ["Neon|Ride"] = 54.94, ["Neon|Fly|Ride"] = 77.73, ["Mega"] = 35.02, ["Mega|Ride"] = 106.08, ["Mega|Fly|Ride"] = 247.15}},
    ["rbxassetid://10318105900"] = {name = "Purple Butterfly", prices = {["default"] = 84.91, ["Ride"] = 127.32, ["Fly|Ride"] = 205.94, ["Neon"] = 459.38, ["Neon|Ride"] = 511.88, ["Neon|Fly|Ride"] = 551.25, ["Mega"] = 8237.77, ["Mega|Fly|Ride"] = 5322.66}},
    ["rbxassetid://95049698731940"] = {name = "Throwback Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15503941919"] = {name = "Arctic Hare", prices = {["default"] = 3.94, ["Neon"] = 24.73, ["Neon|Ride"] = 123.56, ["Mega"] = 145.16, ["Mega|Ride"] = 325.41, ["Mega|Fly|Ride"] = 163.96}},
    ["rbxassetid://10274421272"] = {name = "Royal Corgi", prices = {["default"] = 73.49, ["Ride"] = 136.5, ["Fly|Ride"] = 102.98, ["Neon"] = 385.87, ["Neon|Ride"] = 463.95, ["Neon|Fly|Ride"] = 411.86}},
    ["rbxassetid://13978968837"] = {name = "Bird of Paradise", prices = {["default"] = 3.82, ["Fly"] = 105, ["Fly|Ride"] = 110.18, ["Neon"] = 18.38, ["Neon|Ride"] = 77.73, ["Neon|Fly|Ride"] = 196.87, ["Mega"] = 203.44, ["Mega|Ride"] = 164.07, ["Mega|Fly|Ride"] = 288.33}},
    ["rbxassetid://3261465850"] = {name = "Pink Cat", prices = {["default"] = 255.93, ["Ride"] = 275.63, ["Fly|Ride"] = 374.21, ["Neon"] = 1438.92, ["Neon|Ride"] = 836.06, ["Neon|Fly|Ride"] = 879.01, ["Mega|Fly|Ride"] = 3899.56}},
    ["rbxassetid://8969010905"] = {name = "Red Fox", prices = {["default"] = 6.93, ["Fly"] = 87.94, ["Ride"] = 22.04, ["Fly|Ride"] = 55.61, ["Neon"] = 22.32, ["Neon|Ride"] = 65.62, ["Neon|Fly|Ride"] = 115.5, ["Mega"] = 232.32, ["Mega|Ride"] = 272.12, ["Mega|Fly|Ride"] = 371.16}},
    ["rbxassetid://3181728128"] = {name = "Red Panda", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 15.74, ["Fly|Ride"] = 32.81, ["Neon"] = 5.24, ["Neon|Fly"] = 27.82, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 52.53, ["Mega"] = 54.58, ["Mega|Fly"] = 142.12, ["Mega|Ride"] = 90.57, ["Mega|Fly|Ride"] = 141.73}},
    ["rbxassetid://13077769577"] = {name = "Pelican", prices = {["default"] = 916.13, ["Ride"] = 1050, ["Fly|Ride"] = 1141.88, ["Neon|Ride"] = 7551.04, ["Neon|Fly|Ride"] = 5464.06, ["Mega"] = 26086.94}},
    ["rbxassetid://115281603518501"] = {name = "DJ Snooze", prices = {["default"] = 9.19, ["Fly"] = 961.65, ["Ride"] = 72.19, ["Fly|Ride"] = 205.94, ["Neon"] = 42, ["Neon|Ride"] = 130.77, ["Mega"] = 255.94, ["Mega|Ride"] = 378.95, ["Mega|Fly|Ride"] = 488.11}},
    ["rbxassetid://111847888001946"] = {name = "Choco Penguin", prices = {["default"] = 7.88, ["Fly"] = 46.09, ["Ride"] = 31.5, ["Fly|Ride"] = 96.8, ["Neon"] = 30.14, ["Neon|Fly"] = 124.1, ["Neon|Ride"] = 58.71, ["Neon|Fly|Ride"] = 133.86, ["Mega"] = 186.65, ["Mega|Fly"] = 227.59, ["Mega|Ride"] = 185.36, ["Mega|Fly|Ride"] = 268.75}},
    ["rbxassetid://4621220487"] = {name = "Panda", prices = {["default"] = 93.19, ["Fly"] = 45.24, ["Ride"] = 37.3, ["Fly|Ride"] = 83.91, ["Neon|Ride"] = 199.5, ["Neon|Fly|Ride"] = 181.91, ["Mega"] = 2059.45, ["Mega|Ride"] = 1235.68, ["Mega|Fly|Ride"] = 927.91}},
    ["rbxassetid://12917347184"] = {name = "Flower Power Duckling", prices = {["default"] = 14.44, ["Fly"] = 77.23, ["Ride"] = 27.44, ["Fly|Ride"] = 89.25, ["Neon"] = 72.86, ["Neon|Fly"] = 82.39, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 177.18, ["Mega"] = 367.49, ["Mega|Fly"] = 367.5, ["Mega|Ride"] = 376.69, ["Mega|Fly|Ride"] = 335.9}},
    ["rbxassetid://93775555430694"] = {name = "Pumpkin Friend", prices = {["default"] = 26.25, ["Ride"] = 209.99, ["Fly|Ride"] = 401.56, ["Neon"] = 113.95, ["Neon|Ride"] = 542.8, ["Mega"] = 463.97, ["Mega|Ride"] = 574.6, ["Mega|Fly|Ride"] = 514.87}},
    ["rbxassetid://83317902236850"] = {name = "Kakapo", prices = {["default"] = 2.1, ["Ride"] = 65.63, ["Fly|Ride"] = 274.93, ["Neon"] = 2.24, ["Neon|Fly"] = 55.61, ["Neon|Ride"] = 109.27, ["Neon|Fly|Ride"] = 309.68, ["Mega"] = 15.75, ["Mega|Ride"] = 74.72, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://5862774043"] = {name = "Ghost Bunny", prices = {["default"] = 55.13, ["Fly"] = 110.25, ["Ride"] = 65.54, ["Fly|Ride"] = 145.68, ["Neon"] = 338.65, ["Neon|Fly"] = 382.73, ["Neon|Ride"] = 371.16, ["Neon|Fly|Ride"] = 398.89, ["Mega"] = 3295.13, ["Mega|Ride"] = 1547.28, ["Mega|Fly|Ride"] = 1203.87}},
    ["rbxassetid://10639131895"] = {name = "Spider Crab", prices = {["default"] = 2.63, ["Fly"] = 103.31, ["Ride"] = 26.25, ["Fly|Ride"] = 104.99, ["Neon"] = 43.72, ["Neon|Ride"] = 86.5, ["Mega"] = 773.07, ["Mega|Ride"] = 354.06, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://10193736072"] = {name = "Red Crowned Crane", prices = {["default"] = 2.1, ["Fly"] = 20.6, ["Ride"] = 20.61, ["Fly|Ride"] = 38.07, ["Neon"] = 14.85, ["Neon|Ride"] = 52.53, ["Neon|Fly|Ride"] = 122.84, ["Mega|Ride"] = 268.58, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://13804047294"] = {name = "Arctic Tern", prices = {["default"] = 3.93, ["Ride"] = 126, ["Neon"] = 20.14, ["Neon|Fly|Ride"] = 184.31, ["Mega"] = 274.95}},
    ["rbxassetid://14883937353"] = {name = "Ghost Dog", prices = {["default"] = 39.51, ["Ride"] = 76.55, ["Fly|Ride"] = 262.5, ["Neon"] = 262.48, ["Neon|Ride"] = 294, ["Neon|Fly|Ride"] = 350.07, ["Mega"] = 823.79, ["Mega|Ride"] = 1058.99, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://103241919688695"] = {name = "2025 Birthday Butterfly", prices = {["default"] = 14.34, ["Fly|Ride"] = 411.86, ["Neon"] = 20.99, ["Neon|Ride"] = 77.23, ["Neon|Fly|Ride"] = 105, ["Mega"] = 101.67, ["Mega|Ride"] = 110.19, ["Mega|Fly|Ride"] = 310.27}},
    ["rbxassetid://86594144838863"] = {name = "Tree Frog", prices = {["default"] = 2.1, ["Ride"] = 39.38, ["Neon"] = 2.1, ["Neon|Ride"] = 20.61, ["Mega"] = 15.63, ["Mega|Ride"] = 55.61, ["Mega|Fly|Ride"] = 385.71}},
    ["rbxassetid://99048375832409"] = {name = "Shih Tzu", prices = {["default"] = 2.1, ["Fly"] = 102.94, ["Ride"] = 35.77, ["Fly|Ride"] = 134.85, ["Neon"] = 2.1, ["Neon|Ride"] = 32.96, ["Mega"] = 29.89, ["Mega|Ride"] = 43.78, ["Mega|Fly|Ride"] = 129.84}},
    ["rbxassetid://6998403122"] = {name = "Kirin", prices = {["default"] = 2.1, ["Fly"] = 23.35, ["Ride"] = 15.75, ["Fly|Ride"] = 39.31, ["Neon"] = 6.26, ["Neon|Ride"] = 19.02, ["Neon|Fly|Ride"] = 76.2, ["Mega"] = 123.59, ["Mega|Ride"] = 59.07, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://15930472964"] = {name = "Gila Monster", prices = {["default"] = 2.1, ["Ride"] = 28.88, ["Fly|Ride"] = 65.63, ["Neon"] = 22.32, ["Neon|Ride"] = 1312.5, ["Mega"] = 118.09, ["Mega|Ride"] = 106.3, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://5721843144"] = {name = "Dilophosaurus", prices = {["default"] = 2.1, ["Fly"] = 36.14, ["Ride"] = 15.72, ["Fly|Ride"] = 46.4, ["Neon"] = 12.42, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 78.74, ["Mega"] = 229.04, ["Mega|Ride"] = 274.95, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://109520235810036"] = {name = "Mini Schnauzer", prices = {["default"] = 57.66, ["Fly"] = 123.56, ["Ride"] = 155.43, ["Fly|Ride"] = 261.53, ["Neon"] = 156.45, ["Neon|Ride"] = 329.48, ["Neon|Fly|Ride"] = 1029.61, ["Mega"] = 1547.28, ["Mega|Ride"] = 947.36, ["Mega|Fly|Ride"] = 1091.52}},
    ["rbxassetid://3181728229"] = {name = "Snow Cat", prices = {["default"] = 2.1, ["Fly"] = 25.75, ["Ride"] = 15.69, ["Fly|Ride"] = 35.34, ["Neon"] = 3.94, ["Neon|Fly"] = 27.82, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 43.32, ["Mega"] = 22.25, ["Mega|Fly|Ride"] = 129.74}},
    ["rbxassetid://4506925747"] = {name = "Wolf", prices = {["default"] = 15.39, ["Fly"] = 77.6, ["Ride"] = 55.61, ["Fly|Ride"] = 94.74, ["Neon"] = 25.55, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 46.41, ["Neon|Fly|Ride"] = 123.27, ["Mega"] = 382.77, ["Mega|Fly"] = 321.78, ["Mega|Ride"] = 289.7, ["Mega|Fly|Ride"] = 299.25}},
    ["rbxassetid://5862774473"] = {name = "Albino Bat", prices = {["default"] = 17.46, ["Fly"] = 39.38, ["Ride"] = 30.01, ["Fly|Ride"] = 81.38, ["Neon"] = 109.05, ["Neon|Ride"] = 142.68, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 787.5, ["Mega|Ride"] = 557.7, ["Mega|Fly|Ride"] = 619.39}},
    ["rbxassetid://14978701751"] = {name = "Scarecrow", prices = {["default"] = 3.54, ["Fly"] = 196.88, ["Neon"] = 44.54, ["Mega"] = 288.33, ["Mega|Ride"] = 259.88, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://10235589000"] = {name = "Corgi", prices = {["default"] = 2.1, ["Fly"] = 19.68, ["Ride"] = 15.45, ["Fly|Ride"] = 38.8, ["Neon"] = 5.23, ["Neon|Fly"] = 49.88, ["Neon|Ride"] = 18.57, ["Neon|Fly|Ride"] = 59.07, ["Mega"] = 43.05, ["Mega|Fly"] = 131.25, ["Mega|Ride"] = 59.41, ["Mega|Fly|Ride"] = 122.07}},
    ["rbxassetid://103710623311342"] = {name = "Ghost Chick", prices = {["default"] = 3.68, ["Fly"] = 52.5, ["Ride"] = 30.9, ["Neon"] = 11.63, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 91.88, ["Mega"] = 134.91, ["Mega|Fly"] = 735, ["Mega|Ride"] = 155.81, ["Mega|Fly|Ride"] = 407.78}},
    ["rbxassetid://4440866423"] = {name = "Cow", prices = {["default"] = 1039.49, ["Fly"] = 1146.98, ["Ride"] = 1018.39, ["Fly|Ride"] = 1102.5, ["Neon"] = 2992.13, ["Neon|Ride"] = 2191.88, ["Neon|Fly|Ride"] = 2485.87, ["Mega|Fly|Ride"] = 6929.7}},
    ["rbxassetid://15093139154"] = {name = "Slime", prices = {["default"] = 72.19, ["Ride"] = 137.82, ["Fly|Ride"] = 143.81, ["Neon"] = 411.86, ["Neon|Ride"] = 480.83, ["Neon|Fly|Ride"] = 604.38, ["Mega"] = 1923.53, ["Mega|Ride"] = 2471.34, ["Mega|Fly|Ride"] = 1867.92}},
    ["rbxassetid://82170828935980"] = {name = "Dracula Fish", prices = {["default"] = 2.1, ["Fly"] = 55.61, ["Ride"] = 39.38, ["Neon"] = 5.25, ["Neon|Ride"] = 52.41, ["Neon|Fly|Ride"] = 205.94, ["Mega"] = 78.31, ["Mega|Fly|Ride"] = 205.96}},
    ["rbxassetid://11109302289"] = {name = "Zombie Wolf", prices = {["default"] = 70.88, ["Ride"] = 94.74, ["Fly|Ride"] = 155.4, ["Neon"] = 261.53, ["Neon|Ride"] = 367.49, ["Neon|Fly|Ride"] = 523.69, ["Mega"] = 1050, ["Mega|Ride"] = 1318.06, ["Mega|Fly|Ride"] = 1304.66}},
    ["rbxassetid://15369729071"] = {name = "Nutcracker Squirrel", prices = {["default"] = 5.25, ["Ride"] = 26.7, ["Fly|Ride"] = 89.59, ["Neon"] = 21.51, ["Neon|Fly"] = 54.53, ["Neon|Ride"] = 47.31, ["Neon|Fly|Ride"] = 274.95, ["Mega"] = 271.27, ["Mega|Ride"] = 337.87, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://9800792849"] = {name = "Goat", prices = {["default"] = 297.07, ["Fly"] = 411.86, ["Ride"] = 316.1, ["Fly|Ride"] = 378, ["Neon|Ride"] = 1522.5, ["Neon|Fly|Ride"] = 1647.37, ["Mega|Fly|Ride"] = 4569.91}},
    ["rbxassetid://12509687499"] = {name = "Banded Palm Civet", prices = {["default"] = 2.61, ["Fly"] = 75.64, ["Ride"] = 40.17, ["Fly|Ride"] = 202.63, ["Neon"] = 25.56, ["Neon|Ride"] = 54.28, ["Mega"] = 308.94, ["Mega|Fly"] = 321.29, ["Mega|Ride"] = 185.59, ["Mega|Fly|Ride"] = 433.13}},
    ["rbxassetid://10381386150"] = {name = "Rhino Beetle", prices = {["default"] = 2.1, ["Neon"] = 22.32, ["Neon|Ride"] = 155.43, ["Mega"] = 329.53}},
    ["rbxassetid://130734656883878"] = {name = "Merry Mistletroll", prices = {["default"] = 45.31, ["Ride"] = 137.97, ["Fly|Ride"] = 153.82, ["Neon"] = 122.95, ["Neon|Fly"] = 411.86, ["Neon|Ride"] = 191.51, ["Neon|Fly|Ride"] = 274.93, ["Mega"] = 597.26, ["Mega|Ride"] = 721.88, ["Mega|Fly|Ride"] = 720.82}},
    ["rbxassetid://15923337068"] = {name = "Oryx", prices = {["default"] = 2.1, ["Ride"] = 49.65, ["Fly|Ride"] = 274.93, ["Neon"] = 20.61, ["Neon|Ride"] = 411.86, ["Mega"] = 227.07, ["Mega|Ride"] = 250.74, ["Mega|Fly|Ride"] = 454.39}},
    ["rbxassetid://6245080365"] = {name = "Ox", prices = {["default"] = 2.1, ["Fly"] = 12.69, ["Ride"] = 12.92, ["Fly|Ride"] = 34.13, ["Neon"] = 3.89, ["Neon|Fly"] = 31.38, ["Neon|Ride"] = 155.43, ["Neon|Fly|Ride"] = 37.53, ["Mega"] = 26.24, ["Mega|Ride"] = 39.94, ["Mega|Fly|Ride"] = 76.13}},
    ["rbxassetid://13810870050"] = {name = "African Wild Dog", prices = {["default"] = 4593.75, ["Ride"] = 4442.82, ["Fly|Ride"] = 4488.75, ["Neon"] = 30887.76, ["Neon|Fly|Ride"] = 19293.74, ["Mega|Fly|Ride"] = 85123.86}},
    ["rbxassetid://12596400214"] = {name = "Goldfish", prices = {["default"] = 20.98, ["Fly"] = 39.38, ["Ride"] = 54.94, ["Neon"] = 52.39, ["Neon|Ride"] = 106.32, ["Mega|Ride"] = 236.71, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://4736656915"] = {name = "Australian Kelpie", prices = {["default"] = 2.1, ["Fly"] = 23.45, ["Ride"] = 17.07, ["Fly|Ride"] = 28.46, ["Neon"] = 13, ["Neon|Fly"] = 45.9, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 84, ["Mega"] = 144.37, ["Mega|Ride"] = 164.77, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://3743711305"] = {name = "Crocodile", prices = {["default"] = 495.47, ["Fly"] = 547.77, ["Ride"] = 525, ["Fly|Ride"] = 603.75, ["Neon"] = 1510.42, ["Neon|Ride"] = 1640.63, ["Neon|Fly|Ride"] = 1425.66, ["Mega|Fly|Ride"] = 5492.54}},
    ["rbxassetid://74373220330198"] = {name = "Officer Gibbon", prices = {["default"] = 6.57, ["Ride"] = 26.25, ["Neon"] = 17.07, ["Neon|Ride"] = 145.69, ["Mega"] = 140.59, ["Mega|Fly|Ride"] = 686.83}},
    ["rbxassetid://18508184138"] = {name = "Peregrine Falcon", prices = {["default"] = 8.27, ["Fly"] = 4118.38, ["Ride"] = 46.4, ["Neon"] = 24.35, ["Neon|Ride"] = 274.93, ["Neon|Fly|Ride"] = 274.93, ["Mega"] = 409.85, ["Mega|Ride"] = 401.63, ["Mega|Fly|Ride"] = 491.54}},
    ["rbxassetid://92389214029179"] = {name = "Kaijunior", prices = {["default"] = 2.1, ["Fly"] = 52.45, ["Ride"] = 23.21, ["Neon"] = 6.57, ["Neon|Fly"] = 124.68, ["Neon|Ride"] = 22.4, ["Neon|Fly|Ride"] = 91.75, ["Mega"] = 55.61, ["Mega|Ride"] = 76.12, ["Mega|Fly|Ride"] = 274.95}},
    ["rbxassetid://3409443986"] = {name = "Flamingo", prices = {["default"] = 769.96, ["Fly"] = 2059.19, ["Ride"] = 726.67, ["Fly|Ride"] = 787.5, ["Neon"] = 2362.5, ["Neon|Ride"] = 2609, ["Neon|Fly|Ride"] = 2231.25}},
    ["rbxassetid://126933432685319"] = {name = "Cattuccino", prices = {["default"] = 7.77, ["Fly"] = 287.65, ["Ride"] = 74.81, ["Neon"] = 29.58, ["Neon|Ride"] = 68.99, ["Neon|Fly|Ride"] = 644.44, ["Mega"] = 156.19, ["Mega|Ride"] = 209.14, ["Mega|Fly|Ride"] = 387.49}},
    ["rbxassetid://11631390464"] = {name = "Ermine", prices = {["default"] = 5.25, ["Fly"] = 236.15, ["Ride"] = 39.38, ["Fly|Ride"] = 137.97, ["Neon"] = 25.08, ["Neon|Ride"] = 54.53, ["Neon|Fly|Ride"] = 201.81, ["Mega"] = 203.43, ["Mega|Ride"] = 218.76, ["Mega|Fly|Ride"] = 265.13}},
    ["rbxassetid://4708551221"] = {name = "Emu", prices = {["default"] = 2.1, ["Fly"] = 34.1, ["Ride"] = 16.68, ["Fly|Ride"] = 49.49, ["Neon"] = 15.38, ["Neon|Fly"] = 199.5, ["Neon|Ride"] = 31.17, ["Neon|Fly|Ride"] = 81.36, ["Mega"] = 274.95, ["Mega|Fly"] = 247.15, ["Mega|Ride"] = 195.57, ["Mega|Fly|Ride"] = 208.85}},
    ["rbxassetid://16088266364"] = {name = "Burning Bunny", prices = {["default"] = 15.5, ["Ride"] = 46.4, ["Fly|Ride"] = 155.4, ["Neon"] = 118.13, ["Mega"] = 549.88, ["Mega|Fly|Ride"] = 741.41}},
    ["rbxassetid://80832101513100"] = {name = "2026 Birthday Butterfly", prices = {["default"] = 2.1, ["Fly|Ride"] = 411.86, ["Neon"] = 3.92, ["Neon|Fly"] = 68.99, ["Neon|Ride"] = 45.23, ["Neon|Fly|Ride"] = 184.31, ["Mega"] = 44.18, ["Mega|Ride"] = 138.01, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://14639007389"] = {name = "Caterpillar", prices = {["default"] = 511.88, ["Ride"] = 564.37, ["Fly|Ride"] = 541.57, ["Neon"] = 2589.57, ["Neon|Ride"] = 2707.01, ["Neon|Fly|Ride"] = 2367.46, ["Mega|Fly|Ride"] = 7861.88}},
    ["rbxassetid://82920146813845"] = {name = "Little Lamb", prices = {["default"] = 3.89, ["Ride"] = 62.4, ["Fly|Ride"] = 309.64, ["Neon"] = 15.45, ["Neon|Ride"] = 77.73, ["Neon|Fly|Ride"] = 152.39, ["Mega"] = 63, ["Mega|Ride"] = 205.96, ["Mega|Fly|Ride"] = 305.82}},
    ["rbxassetid://96424154406922"] = {name = "Crimson Cape", prices = {["default"] = 2.1, ["Ride"] = 41.2, ["Neon"] = 6.19, ["Neon|Fly"] = 137.97, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 42, ["Mega|Ride"] = 137.82, ["Mega|Fly|Ride"] = 274.95}},
    ["rbxassetid://109008428989602"] = {name = "Pangolin", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 5.25, ["Neon|Ride"] = 41.73, ["Neon|Fly|Ride"] = 137.97, ["Mega"] = 45.94, ["Mega|Fly"] = 152.41, ["Mega|Ride"] = 82.4, ["Mega|Fly|Ride"] = 147}},
    ["rbxassetid://16722909218"] = {name = "Floral Eggy", prices = {["default"] = 2.63, ["Ride"] = 27.46, ["Neon"] = 18.55, ["Mega"] = 201.84}},
    ["rbxassetid://76735046136809"] = {name = "Frostbite Cub", prices = {["default"] = 123.98, ["Fly"] = 72.19, ["Ride"] = 60.15, ["Fly|Ride"] = 294.57, ["Neon"] = 129.94, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 334.69, ["Mega"] = 686.83, ["Mega|Ride"] = 681.19, ["Mega|Fly|Ride"] = 728.02}},
    ["rbxassetid://15684947715"] = {name = "Quokka", prices = {["default"] = 30.86, ["Ride"] = 274.93, ["Fly|Ride"] = 137.97, ["Neon"] = 101.1, ["Neon|Ride"] = 176.08, ["Neon|Fly|Ride"] = 301.88, ["Mega"] = 464.19, ["Mega|Fly"] = 411.9, ["Mega|Ride"] = 389.82, ["Mega|Fly|Ride"] = 560.79}},
    ["rbxassetid://5721843001"] = {name = "Deinonychus", prices = {["default"] = 2.63, ["Fly"] = 19.36, ["Ride"] = 15.74, ["Fly|Ride"] = 44.33, ["Neon"] = 28.87, ["Neon|Ride"] = 35.13, ["Neon|Fly|Ride"] = 57.74, ["Mega"] = 299.92, ["Mega|Ride"] = 276.86, ["Mega|Fly|Ride"] = 256.35}},
    ["rbxassetid://16999461770"] = {name = "Inmate Capuchin Monkey", prices = {["default"] = 15.45, ["Ride"] = 64.32, ["Fly|Ride"] = 124.09, ["Neon"] = 137.97, ["Neon|Ride"] = 131.25, ["Mega"] = 309.7}},
    ["rbxassetid://119664699815373"] = {name = "Frozen Penguin", prices = {["default"] = 2.1, ["Ride"] = 25.52, ["Fly|Ride"] = 73.12, ["Neon"] = 14.44, ["Neon|Ride"] = 33.65, ["Neon|Fly|Ride"] = 206.46, ["Mega"] = 98.87, ["Mega|Ride"] = 152.41, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://5067924307"] = {name = "Business Monkey", prices = {["default"] = 19.69, ["Fly"] = 23.63, ["Ride"] = 23.62, ["Fly|Ride"] = 77.72, ["Neon"] = 231.96, ["Neon|Ride"] = 185.34, ["Neon|Fly|Ride"] = 198.34, ["Mega"] = 925.74, ["Mega|Ride"] = 927.91, ["Mega|Fly|Ride"] = 892.79}},
    ["rbxassetid://126192643157832"] = {name = "Manta Ray", prices = {["default"] = 68.99, ["Fly"] = 874.13, ["Neon"] = 273.99, ["Mega|Fly|Ride"] = 961.77}},
    ["rbxassetid://4440866911"] = {name = "Silly Duck", prices = {["default"] = 61.79, ["Fly"] = 115.38, ["Ride"] = 73.49, ["Fly|Ride"] = 162.5, ["Neon"] = 294.96, ["Neon|Ride"] = 313.69, ["Neon|Fly|Ride"] = 364.88, ["Mega|Ride"] = 1640.07, ["Mega|Fly|Ride"] = 1505.46}},
    ["rbxassetid://110544962124445"] = {name = "Cake Friend", prices = {["default"] = 42, ["Fly"] = 291.38, ["Ride"] = 88.55, ["Fly|Ride"] = 656.25, ["Neon"] = 144.38, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 407.11, ["Mega"] = 569.05, ["Mega|Fly"] = 526.6, ["Mega|Ride"] = 659.04, ["Mega|Fly|Ride"] = 620.82}},
    ["rbxassetid://16127157068"] = {name = "Rice Cake Rabbit", prices = {["default"] = 22.39, ["Ride"] = 56.43, ["Fly|Ride"] = 137.97, ["Neon"] = 123.38, ["Neon|Ride"] = 274.26, ["Mega"] = 393.75, ["Mega|Ride"] = 755.84, ["Mega|Fly|Ride"] = 1235.68}},
    ["rbxassetid://7734900613"] = {name = "Halloween Evil Dachshund", prices = {["default"] = 18.27, ["Fly"] = 428.27, ["Ride"] = 47.25, ["Fly|Ride"] = 190.32, ["Neon"] = 87.92, ["Neon|Fly"] = 420, ["Neon|Ride"] = 120.75, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 464.37, ["Mega|Ride"] = 461.56, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://9664282145"] = {name = "Robot", prices = {["default"] = 2.1, ["Fly"] = 17.74, ["Ride"] = 15.24, ["Fly|Ride"] = 35.02, ["Neon"] = 4.66, ["Neon|Fly"] = 25.41, ["Neon|Ride"] = 27.35, ["Neon|Fly|Ride"] = 41.2, ["Mega"] = 44.61, ["Mega|Fly"] = 155.44, ["Mega|Ride"] = 57.75, ["Mega|Fly|Ride"] = 103.69}},
    ["rbxassetid://3261465791"] = {name = "Pink Egg", prices = {["default"] = 1253.91}},
    ["rbxassetid://126725051633301"] = {name = "Headless Horse", prices = {["default"] = 39.37, ["Fly"] = 231.97, ["Ride"] = 126.93, ["Fly|Ride"] = 288.75, ["Neon"] = 291.38, ["Neon|Ride"] = 258.65, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 782.6, ["Mega|Ride"] = 773.66, ["Mega|Fly|Ride"] = 921.61}},
    ["rbxassetid://88554799028713"] = {name = "Sneak Weasel", prices = {["default"] = 2.1, ["Ride"] = 79.71, ["Neon"] = 3.6, ["Neon|Fly"] = 96.8, ["Neon|Ride"] = 43.18, ["Neon|Fly|Ride"] = 288.3, ["Mega"] = 48.57, ["Mega|Ride"] = 84.92, ["Mega|Fly|Ride"] = 205.96}},
    ["rbxassetid://14639008203"] = {name = "English Sheepdog", prices = {["default"] = 28.88, ["Ride"] = 69.6, ["Fly|Ride"] = 152.39, ["Neon"] = 128.37, ["Neon|Ride"] = 137.97, ["Neon|Fly|Ride"] = 544.69, ["Mega|Ride"] = 773.66, ["Mega|Fly|Ride"] = 843.24}},
    ["rbxassetid://133131190079833"] = {name = "Oakee", prices = {["default"] = 2.1, ["Neon"] = 3.82, ["Neon|Ride"] = 105, ["Mega"] = 32.82}},
    ["rbxassetid://79856043024325"] = {name = "Chestnut Glyptodon", prices = {["default"] = 2.1, ["Neon"] = 3.94, ["Mega|Ride"] = 154.04, ["Mega|Fly|Ride"] = 273}},
    ["rbxassetid://12720028898"] = {name = "Hare", prices = {["default"] = 109.32, ["Ride"] = 134.55, ["Fly|Ride"] = 257.25, ["Neon"] = 514.82, ["Neon|Ride"] = 613.65, ["Neon|Fly|Ride"] = 686.83, ["Mega|Ride"] = 2127.42, ["Mega|Fly|Ride"] = 1811.25}},
    ["rbxassetid://16897788024"] = {name = "Capuchin Monkey", prices = {["default"] = 2.1, ["Fly"] = 65.62, ["Ride"] = 19.69, ["Fly|Ride"] = 92.99, ["Neon"] = 6.98, ["Neon|Ride"] = 26.17, ["Neon|Fly|Ride"] = 99.74, ["Mega"] = 90.57, ["Mega|Ride"] = 108.71, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://121639546210522"] = {name = "Amber Butterfly", prices = {["default"] = 2.1, ["Fly"] = 38.07, ["Ride"] = 68.99, ["Fly|Ride"] = 55.61, ["Neon"] = 3.93, ["Neon|Fly"] = 61.79, ["Neon|Ride"] = 35.02, ["Neon|Fly|Ride"] = 122.54, ["Mega"] = 38.07, ["Mega|Ride"] = 123.27, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://79005166120532"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Ride"] = 82.39, ["Neon"] = 3.46, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 127.34, ["Mega"] = 36.72, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 236.85}},
    ["rbxassetid://138741319376538"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 27.57, ["Neon"] = 3.94, ["Neon|Ride"] = 156.19, ["Mega"] = 62.9, ["Mega|Ride"] = 201.84}},
    ["rbxassetid://133558151150234"] = {name = "Black Widow", prices = {["default"] = 62.56, ["Ride"] = 118.13, ["Fly|Ride"] = 449.61, ["Neon"] = 361.4, ["Neon|Ride"] = 509.66, ["Neon|Fly|Ride"] = 695.63, ["Mega"] = 1235.68, ["Mega|Ride"] = 1544.6, ["Mega|Fly|Ride"] = 1495.17}},
    ["rbxassetid://122945704087152"] = {name = "Chilling Spider", prices = {["default"] = 10.4, ["Ride"] = 61.76, ["Fly|Ride"] = 131.25, ["Neon"] = 53.37, ["Neon|Ride"] = 155.43, ["Mega"] = 379.65, ["Mega|Ride"] = 853.79}},
    ["rbxassetid://1373237029"] = {name = "Big Head Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://2657668946"] = {name = "Cure All Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://1373237971"] = {name = "Grow Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4315743582"] = {name = "Honey Badger", prices = {["default"] = 328.12, ["Fly"] = 463.93, ["Ride"] = 467.44, ["Fly|Ride"] = 617.76, ["Neon"] = 1029.61, ["Neon|Ride"] = 1083.28, ["Neon|Fly|Ride"] = 1233.75, ["Mega|Fly|Ride"] = 4448.4}},
    ["rbxassetid://1373208271"] = {name = "Hyperspeed Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4047157976"] = {name = "Fly Potion", prices = {["default"] = 86.04}},
    ["rbxassetid://3342628435"] = {name = "Ride Potion", prices = {["default"] = 51.49}},
    ["rbxassetid://1509389697"] = {name = "Adopt Me Boy Scooter", prices = {["default"] = 24.38}},
    ["rbxassetid://1509384540"] = {name = "Adopt Me Girl Scooter", prices = {["default"] = 35.96}},
    ["rbxassetid://1256627798"] = {name = "Adopt Me Snowboard 1", prices = {["default"] = 110.15}},
    ["rbxassetid://1256627585"] = {name = "Adopt Me Snowboard 2", prices = {["default"] = 57.9}},
    ["rbxassetid://2782643682"] = {name = "Axel", prices = {["default"] = 57.75}},
    ["rbxassetid://3009779146"] = {name = "Banana Car", prices = {["default"] = 6.57}},
    ["rbxassetid://1306904296"] = {name = "Bathtub", prices = {["default"] = 245.43}},
    ["rbxassetid://1307341557"] = {name = "Bethink Skateboard", prices = {["default"] = 30.19}},
    ["rbxassetid://908269395"] = {name = "Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://1509319125"] = {name = "Black Scooter", prices = {["default"] = 28.54}},
    ["rbxassetid://1306898658"] = {name = "Black Skateboard", prices = {["default"] = 6.55}},
    ["rbxassetid://1256625297"] = {name = "Black Snowboard", prices = {["default"] = 7.18}},
    ["rbxassetid://1266478264"] = {name = "Blue Neon Snowboard", prices = {["default"] = 205.09}},
    ["rbxassetid://4800244517"] = {name = "Blue Rider", prices = {["default"] = 2.1}},
    ["rbxassetid://1509318734"] = {name = "Blue Scooter", prices = {["default"] = 4.87}},
    ["rbxassetid://1306898360"] = {name = "Blue Skateboard", prices = {["default"] = 10.34}},
    ["rbxassetid://1256625905"] = {name = "Blue Snowboard", prices = {["default"] = 8.96}},
    ["rbxassetid://7165481985"] = {name = "Bubble Car", prices = {["default"] = 5.25}},
    ["rbxassetid://12115176522"] = {name = "Toxic Barrel", prices = {["default"] = 10.5}},
    ["rbxassetid://2657667116"] = {name = "Bunny Carriage", prices = {["default"] = 564.38}},
    ["rbxassetid://6475610034"] = {name = "Butterfly Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264167"] = {name = "Camper Van", prices = {["default"] = 2.1}},
    ["rbxassetid://2758237053"] = {name = "Car", prices = {["default"] = 2.1}},
    ["rbxassetid://14465252948"] = {name = "Super Jetpack", prices = {["default"] = 822.55}},
    ["rbxassetid://4754697599"] = {name = "Choo Choo Train", prices = {["default"] = 62.97}},
    ["rbxassetid://2408035766"] = {name = "Cloud", prices = {["default"] = 1038.97}},
    ["rbxassetid://5057099424"] = {name = "Clown Car", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099515"] = {name = "Clown Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750671"] = {name = "Cookie Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8203695278"] = {name = "Snowmobile", prices = {["default"] = 7.88}},
    ["rbxassetid://8243269978"] = {name = "Zamboni", prices = {["default"] = 2.63}},
    ["rbxassetid://1509385561"] = {name = "Cupcake Scooter", prices = {["default"] = 20.66}},
    ["rbxassetid://4822522305"] = {name = "Daisy Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8517689681"] = {name = "Landsailer", prices = {["default"] = 2.1}},
    ["rbxassetid://8566306089"] = {name = "Trireme", prices = {["default"] = 2.1}},
    ["rbxassetid://6504033614"] = {name = "Dino Truck", prices = {["default"] = 3.94}},
    ["rbxassetid://1512774745"] = {name = "Doge Scooter", prices = {["default"] = 31.32}},
    ["rbxassetid://1307341942"] = {name = "Doge Skateboard", prices = {["default"] = 32.81}},
    ["rbxassetid://3486906742"] = {name = "Dogmobile", prices = {["default"] = 39.25}},
    ["rbxassetid://2880427418"] = {name = "Donut Cycle", prices = {["default"] = 14.44}},
    ["rbxassetid://3486907843"] = {name = "Donut Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2782643731"] = {name = "Douglas", prices = {["default"] = 11.82}},
    ["rbxassetid://1509391407"] = {name = "Duck Scooter", prices = {["default"] = 15.75}},
    ["rbxassetid://9291032374"] = {name = "Egg Delivery Machine", prices = {["default"] = 3.94}},
    ["rbxassetid://1509377123"] = {name = "Emoji Scooter", prices = {["default"] = 17.3}},
    ["rbxassetid://9973767611"] = {name = "Harvest Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://9973768669"] = {name = "Tractor", prices = {["default"] = 4.05}},
    ["rbxassetid://1307341332"] = {name = "Fidget Skateboard", prices = {["default"] = 14.44}},
    ["rbxassetid://1306904101"] = {name = "Fissy Skateboard", prices = {["default"] = 7.86}},
    ["rbxassetid://4823285384"] = {name = "Flower Wagon", prices = {["default"] = 7.35}},
    ["rbxassetid://7475653998"] = {name = "Fossil Paw Helicopter", prices = {["default"] = 6.56}},
    ["rbxassetid://9406027381"] = {name = "Starter Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://6475609765"] = {name = "Futuristic Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291832"] = {name = "Ghost Vehicle", prices = {["default"] = 1865.4}},
    ["rbxassetid://10905638416"] = {name = "Ancient Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760422"] = {name = "Bat Face Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://10919870588"] = {name = "Dapper Friend Carrier", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760559"] = {name = "Dirt Bike Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10967588257"] = {name = "Hot Tub Muscle Car", prices = {["default"] = 45.55}},
    ["rbxassetid://10905207734"] = {name = "Soapy Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9037078630"] = {name = "Horse And Carriage", prices = {["default"] = 273}},
    ["rbxassetid://10913434990"] = {name = "Unstable Triangle Car", prices = {["default"] = 2.12}},
    ["rbxassetid://8979306571"] = {name = "Wizard Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1512770654"] = {name = "Glass Scooter", prices = {["default"] = 10.31}},
    ["rbxassetid://1306903971"] = {name = "Glass Skateboard", prices = {["default"] = 8.26}},
    ["rbxassetid://1256627375"] = {name = "Glass Snowboard", prices = {["default"] = 39.38}},
    ["rbxassetid://1064481531"] = {name = "GoKart", prices = {["default"] = 206.21}},
    ["rbxassetid://1509326491"] = {name = "Gold Scooter", prices = {["default"] = 9.36}},
    ["rbxassetid://1306902802"] = {name = "Gold Skateboard", prices = {["default"] = 10.31}},
    ["rbxassetid://12519249137"] = {name = "Bumper Car", prices = {["default"] = 2.1}},
    ["rbxassetid://12519249424"] = {name = "Circus Ball Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265134428"] = {name = "Green Neon Snowboard", prices = {["default"] = 1373.32}},
    ["rbxassetid://7839195952"] = {name = "Halloween Black Ponycycle", prices = {["default"] = 30.76}},
    ["rbxassetid://11119263404"] = {name = "Headless Horseman's Biplane", prices = {["default"] = 4.11}},
    ["rbxassetid://10920073281"] = {name = "Throwing Knife Target", prices = {["default"] = 2.1}},
    ["rbxassetid://10920073157"] = {name = "Shadow Rider", prices = {["default"] = 22.96}},
    ["rbxassetid://11125166616"] = {name = "Unicorn Zombie Ponycycle", prices = {["default"] = 11.01}},
    ["rbxassetid://2848331544"] = {name = "Heart Hoverboard", prices = {["default"] = 2.63}},
    ["rbxassetid://2657670919"] = {name = "Horse Cycle", prices = {["default"] = 215.71}},
    ["rbxassetid://3163531592"] = {name = "Traveling House", prices = {["default"] = 28.87}},
    ["rbxassetid://4382798606"] = {name = "Hoverboard", prices = {["default"] = 15.45}},
    ["rbxassetid://6475613264"] = {name = "Hovercar", prices = {["default"] = 2.24}},
    ["rbxassetid://4797807001"] = {name = "Human Bubble", prices = {["default"] = 2.1}},
    ["rbxassetid://4588192578"] = {name = "Ice Cream Truck", prices = {["default"] = 29.67}},
    ["rbxassetid://4470749585"] = {name = "Ice Queen Sleigh", prices = {["default"] = 2.1}},
    ["rbxassetid://1509333762"] = {name = "Ice Scooter", prices = {["default"] = 10.31}},
    ["rbxassetid://6504033516"] = {name = "Imagination Box", prices = {["default"] = 3.93}},
    ["rbxassetid://10619155042"] = {name = "Street Racer", prices = {["default"] = 26.25}},
    ["rbxassetid://2749267159"] = {name = "Limo", prices = {["default"] = 2.1}},
    ["rbxassetid://8665606953"] = {name = "Dragon Train", prices = {["default"] = 125.99}},
    ["rbxassetid://11758583286"] = {name = "Crescent Moon Car", prices = {["default"] = 190.32}},
    ["rbxassetid://6276452323"] = {name = "Lunar Muscle Car", prices = {["default"] = 3.35}},
    ["rbxassetid://7165482478"] = {name = "Magical Girl Car", prices = {["default"] = 7.22}},
    ["rbxassetid://7368045552"] = {name = "Magical Princess Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1306902978"] = {name = "Melon Skateboard", prices = {["default"] = 29.3}},
    ["rbxassetid://3009779540"] = {name = "Monocycle", prices = {["default"] = 26.25}},
    ["rbxassetid://1512742703"] = {name = "Mono-Moped", prices = {["default"] = 92.68}},
    ["rbxassetid://2758236960"] = {name = "Moped", prices = {["default"] = 17.07}},
    ["rbxassetid://2758237011"] = {name = "Motorcycle", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264226"] = {name = "Muscle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://1509342852"] = {name = "Neon Black Scooter", prices = {["default"] = 22087.31}},
    ["rbxassetid://1306911569"] = {name = "Neon Black Skateboard", prices = {["default"] = 147.92}},
    ["rbxassetid://1509338320"] = {name = "Neon Blue Scooter", prices = {["default"] = 53.08}},
    ["rbxassetid://1306907175"] = {name = "Neon Blue Skateboard", prices = {["default"] = 134.42}},
    ["rbxassetid://1509342200"] = {name = "Neon Green Scooter", prices = {["default"] = 36.66}},
    ["rbxassetid://1306907671"] = {name = "Neon Green Skateboard", prices = {["default"] = 131.24}},
    ["rbxassetid://1509338451"] = {name = "Neon Orange Scooter", prices = {["default"] = 31.5}},
    ["rbxassetid://1306907450"] = {name = "Neon Orange Skateboard", prices = {["default"] = 31.5}},
    ["rbxassetid://1509339156"] = {name = "Neon Pink Scooter", prices = {["default"] = 75.8}},
    ["rbxassetid://1306911771"] = {name = "Neon Pink Skateboard", prices = {["default"] = 68.99}},
    ["rbxassetid://1509341495"] = {name = "Neon Red Scooter", prices = {["default"] = 46.15}},
    ["rbxassetid://1306907886"] = {name = "Neon Red Skateboard", prices = {["default"] = 32.81}},
    ["rbxassetid://1256625563"] = {name = "Orange Neon Snowboard", prices = {["default"] = 81.86}},
    ["rbxassetid://1509340494"] = {name = "Neon White Scooter", prices = {["default"] = 38.56}},
    ["rbxassetid://1309919907"] = {name = "Neon White Skateboard", prices = {["default"] = 131.25}},
    ["rbxassetid://2860616613"] = {name = "Offroader", prices = {["default"] = 2.1}},
    ["rbxassetid://1265130049"] = {name = "Pink Neon Snowboard", prices = {["default"] = 177.19}},
    ["rbxassetid://1509329807"] = {name = "Pink Scooter", prices = {["default"] = 5.25}},
    ["rbxassetid://4361545125"] = {name = "Pizza Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://7368040075"] = {name = "Plant Powered Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9837424665"] = {name = "Rainbow Trail Magic Carpet", prices = {["default"] = 11.67}},
    ["rbxassetid://2854601262"] = {name = "Prince Carriage", prices = {["default"] = 5.25}},
    ["rbxassetid://2854601314"] = {name = "Princess Carriage", prices = {["default"] = 28.88}},
    ["rbxassetid://4115248893"] = {name = "Pumpkin Carriage", prices = {["default"] = 98.86}},
    ["rbxassetid://7475654312"] = {name = "Racing Monoplane", prices = {["default"] = 2.1}},
    ["rbxassetid://10967874847"] = {name = "Galleon", prices = {["default"] = 2.8}},
    ["rbxassetid://10967808228"] = {name = "Old Sail Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992442"] = {name = "RGB Monster Truck", prices = {["default"] = 2.42}},
    ["rbxassetid://8481992324"] = {name = "RGB UFO", prices = {["default"] = 96.79}},
    ["rbxassetid://5882026006"] = {name = "Ribcage Carriage", prices = {["default"] = 11.2}},
    ["rbxassetid://1265128894"] = {name = "Roblox Snowboard", prices = {["default"] = 357.24}},
    ["rbxassetid://4797807111"] = {name = "Rocket Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://7368052482"] = {name = "Rocket Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://1257419042"] = {name = "Rocket Sled", prices = {["default"] = 656.25}},
    ["rbxassetid://4564588042"] = {name = "Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601162"] = {name = "Royal Carriage", prices = {["default"] = 6.57}},
    ["rbxassetid://13741294258"] = {name = "Giant Cheetah Mount", prices = {["default"] = 577.5}},
    ["rbxassetid://4470749525"] = {name = "Santa's Sleigh", prices = {["default"] = 26.25}},
    ["rbxassetid://4470749209"] = {name = "Sled", prices = {["default"] = 2.1}},
    ["rbxassetid://9342853829"] = {name = "Snow Plow", prices = {["default"] = 2.43}},
    ["rbxassetid://9343367876"] = {name = "Tundra Exploration Machine", prices = {["default"] = 2.1}},
    ["rbxassetid://1265142495"] = {name = "Snow Snowboard", prices = {["default"] = 604.45}},
    ["rbxassetid://7165482648"] = {name = "Speedboat", prices = {["default"] = 2.1}},
    ["rbxassetid://12719600101"] = {name = "Daisymobile", prices = {["default"] = 60.59}},
    ["rbxassetid://12792507038"] = {name = "Flower Truck", prices = {["default"] = 115.08}},
    ["rbxassetid://12996592162"] = {name = "Lavender Teapot Carriage", prices = {["default"] = 19.69}},
    ["rbxassetid://12917527253"] = {name = "Rabbit Helicopter", prices = {["default"] = 204.75}},
    ["rbxassetid://12996592079"] = {name = "Rose Petal Carriage", prices = {["default"] = 76.13}},
    ["rbxassetid://12996592010"] = {name = "Royal Crown Carriage", prices = {["default"] = 11.82}},
    ["rbxassetid://6504033423"] = {name = "Squirrel Car", prices = {["default"] = 4.11}},
    ["rbxassetid://6798176757"] = {name = "Standard Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://6797010981"] = {name = "Standard Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10224002323"] = {name = "Emperor's Chariot", prices = {["default"] = 7.88}},
    ["rbxassetid://10202931873"] = {name = "Orchid Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://10202932215"] = {name = "Hovercraft", prices = {["default"] = 2.1}},
    ["rbxassetid://10224209770"] = {name = "Planetary Core Car", prices = {["default"] = 2.1}},
    ["rbxassetid://10203332627"] = {name = "Medieval Wagon", prices = {["default"] = 2.1}},
    ["rbxassetid://13607580379"] = {name = "Beach Buggy", prices = {["default"] = 5.25}},
    ["rbxassetid://13683681091"] = {name = "Beachgoer", prices = {["default"] = 2.14}},
    ["rbxassetid://13683679951"] = {name = "Crabby Cruiser", prices = {["default"] = 21.67}},
    ["rbxassetid://3579315827"] = {name = "Surfboard", prices = {["default"] = 2.1}},
    ["rbxassetid://3186425945"] = {name = "SUV", prices = {["default"] = 2.52}},
    ["rbxassetid://1614139188"] = {name = "Multi-Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8727492188"] = {name = "Black Cab", prices = {["default"] = 3.88}},
    ["rbxassetid://8727477150"] = {name = "Yellow Taxi Cab", prices = {["default"] = 3.83}},
    ["rbxassetid://2783002443"] = {name = "Tiffany", prices = {["default"] = 14.44}},
    ["rbxassetid://3206264796"] = {name = "Tiny Convertible", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671636"] = {name = "Unicorn Cycle", prices = {["default"] = 188.79}},
    ["rbxassetid://3142180107"] = {name = "Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231299"] = {name = "Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506670"] = {name = "Family Car", prices = {["default"] = 2.1}},
    ["rbxassetid://8925104785"] = {name = "Gyrocopter", prices = {["default"] = 70.35}},
    ["rbxassetid://8859231666"] = {name = "Classic Helicopter", prices = {["default"] = 2.42}},
    ["rbxassetid://8860682054"] = {name = "Classic Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231811"] = {name = "Motorbike", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506795"] = {name = "Off-Road Car", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506884"] = {name = "Open Top Speeder", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231943"] = {name = "Classic Airplane", prices = {["default"] = 2.63}},
    ["rbxassetid://9108507006"] = {name = "Sports Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8859232022"] = {name = "Tandem Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265135075"] = {name = "White Neon Snowboard", prices = {["default"] = 1048.58}},
    ["rbxassetid://1509328859"] = {name = "White Scooter", prices = {["default"] = 7.76}},
    ["rbxassetid://1306898856"] = {name = "White Skateboard", prices = {["default"] = 15.75}},
    ["rbxassetid://1256624956"] = {name = "White Snowboard", prices = {["default"] = 7.31}},
    ["rbxassetid://7165482807"] = {name = "Wing Trunk Car", prices = {["default"] = 20.56}},
    ["rbxassetid://8080952782"] = {name = "Festive Deliveries Present Truck", prices = {["default"] = 104.99}},
    ["rbxassetid://8190703270"] = {name = "Festive Deliveries Sleigh", prices = {["default"] = 6.57}},
    ["rbxassetid://7975097837"] = {name = "Festive Ice Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://8190703329"] = {name = "Toy Rescue Helicopter", prices = {["default"] = 7.07}},
    ["rbxassetid://11697121962"] = {name = "Candy Snowmobile", prices = {["default"] = 14}},
    ["rbxassetid://11574949668"] = {name = "Giant Snowball", prices = {["default"] = 90.56}},
    ["rbxassetid://11764928443"] = {name = "Gingerbread Sleigh", prices = {["default"] = 102.05}},
    ["rbxassetid://11706055135"] = {name = "Husky Sled", prices = {["default"] = 34.13}},
    ["rbxassetid://11466900358"] = {name = "Icebreaker Ship", prices = {["default"] = 2.1}},
    ["rbxassetid://11768005537"] = {name = "Ice Plane", prices = {["default"] = 11.16}},
    ["rbxassetid://11706157454"] = {name = "Snowblower Toboggan", prices = {["default"] = 4.13}},
    ["rbxassetid://11582939967"] = {name = "Strawberry Shortcake Skates", prices = {["default"] = 2.63}},
    ["rbxassetid://11582928541"] = {name = "Strawberry Shortcake Unicycle", prices = {["default"] = 3.94}},
    ["rbxassetid://4797807321"] = {name = "Witch's Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1509321524"] = {name = "Wood Scooter", prices = {["default"] = 9.08}},
    ["rbxassetid://1306899055"] = {name = "Wood Skateboard", prices = {["default"] = 10.25}},
    ["rbxassetid://4361544852"] = {name = "Airplane Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4797806115"] = {name = "Angelic Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671618"] = {name = "Anna Rattle", prices = {["default"] = 2.24}},
    ["rbxassetid://4712355837"] = {name = "Astro Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4115251996"] = {name = "Axe Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2657667102"] = {name = "Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779116"] = {name = "Balloons", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779170"] = {name = "Banana Plush", prices = {["default"] = 2.49}},
    ["rbxassetid://3009779233"] = {name = "Banana Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248143"] = {name = "Banjo", prices = {["default"] = 3.4}},
    ["rbxassetid://4470749845"] = {name = "Bauble Balloon", prices = {["default"] = 2.63}},
    ["rbxassetid://5061468615"] = {name = "Briefcase Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907018"] = {name = "Bubblegum Machine Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046064"] = {name = "Bunny Plush", prices = {["default"] = 12.29}},
    ["rbxassetid://4470749083"] = {name = "Candle", prices = {["default"] = 2.1}},
    ["rbxassetid://6710107927"] = {name = "Candy Cannon", prices = {["default"] = 7492.64}},
    ["rbxassetid://3082046250"] = {name = "Carrot Rattle", prices = {["default"] = 2.6}},
    ["rbxassetid://2408035756"] = {name = "Cat Plush", prices = {["default"] = 11.5}},
    ["rbxassetid://3009779289"] = {name = "Caticorn Rattle", prices = {["default"] = 5.25}},
    ["rbxassetid://3082047003"] = {name = "Chick Plush", prices = {["default"] = 6.96}},
    ["rbxassetid://3082046215"] = {name = "Chocolate Bunny Balloon", prices = {["default"] = 3.94}},
    ["rbxassetid://1257271764"] = {name = "Christmas Cat Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://1257273388"] = {name = "Christmas Doge Rattle", prices = {["default"] = 26.25}},
    ["rbxassetid://4470749153"] = {name = "Cookie Dough Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://10979219546"] = {name = "Cotton Candy Stand", prices = {["default"] = 23.63}},
    ["rbxassetid://4115248463"] = {name = "Creepy Balloon", prices = {["default"] = 2.5}},
    ["rbxassetid://2408035767"] = {name = "Croc Plush", prices = {["default"] = 5.32}},
    ["rbxassetid://4115248599"] = {name = "Crossbow Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468734"] = {name = "Cymbal Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://4822522594"] = {name = "Dandelion Propeller", prices = {["default"] = 4.66}},
    ["rbxassetid://4797806584"] = {name = "Didgeridoo", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779323"] = {name = "Donut Rattle", prices = {["default"] = 2.43}},
    ["rbxassetid://3454109877"] = {name = "Donut Throw Toy", prices = {["default"] = 69.62}},
    ["rbxassetid://3486907555"] = {name = "Dragon Balloon", prices = {["default"] = 2.24}},
    ["rbxassetid://3009779349"] = {name = "Duck Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046102"] = {name = "Easter Bunny Plush", prices = {["default"] = 6.46}},
    ["rbxassetid://1555803323"] = {name = "Egg Rattle", prices = {["default"] = 3.45}},
    ["rbxassetid://2408051109"] = {name = "Elephant Plush", prices = {["default"] = 3.05}},
    ["rbxassetid://4470750254"] = {name = "Elf Plush", prices = {["default"] = 2.63}},
    ["rbxassetid://2657668953"] = {name = "Elf Rattle", prices = {["default"] = 2.24}},
    ["rbxassetid://5882028408"] = {name = "Eyeball Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408035763"] = {name = "Fancy Balloon", prices = {["default"] = 99.74}},
    ["rbxassetid://2408052395"] = {name = "Fancy Umbrella", prices = {["default"] = 3.46}},
    ["rbxassetid://3009779377"] = {name = "Flower Rattle", prices = {["default"] = 2.24}},
    ["rbxassetid://2466291815"] = {name = "Flying Broomstick", prices = {["default"] = 4330.97}},
    ["rbxassetid://3454109803"] = {name = "Football Throw Toy", prices = {["default"] = 5.16}},
    ["rbxassetid://7368042855"] = {name = "Galaxy Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749638"] = {name = "Gift Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://1310513344"] = {name = "Glider", prices = {["default"] = 262.5}},
    ["rbxassetid://6936627177"] = {name = "Golden Maned Unicorn Rattle", prices = {["default"] = 2.63}},
    ["rbxassetid://3142180004"] = {name = "Grappling Hook", prices = {["default"] = 6.01}},
    ["rbxassetid://3486907282"] = {name = "Griffin Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://1419098937"] = {name = "Heart Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://1419099271"] = {name = "Heart Plushie", prices = {["default"] = 3.05}},
    ["rbxassetid://2848331436"] = {name = "Heart Rattle", prices = {["default"] = 51.12}},
    ["rbxassetid://2657670910"] = {name = "Horse Plush", prices = {["default"] = 5.08}},
    ["rbxassetid://3818347838"] = {name = "Hotdog Stand", prices = {["default"] = 7.88}},
    ["rbxassetid://1555807694"] = {name = "Hugging Egg", prices = {["default"] = 92.54}},
    ["rbxassetid://4470749277"] = {name = "Ice Club Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779419"] = {name = "Ice Cream Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4361546643"] = {name = "Ice Cream Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749342"] = {name = "Ice Pick Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052390"] = {name = "Inflatable Sword", prices = {["default"] = 2.63}},
    ["rbxassetid://2408051119"] = {name = "Jackhammer", prices = {["default"] = 2.1}},
    ["rbxassetid://3486908136"] = {name = "Kangaroo Pogo", prices = {["default"] = 3.94}},
    ["rbxassetid://4822522509"] = {name = "Lavender Bundle", prices = {["default"] = 2.1}},
    ["rbxassetid://3523677453"] = {name = "Lemonade Stand", prices = {["default"] = 2.63}},
    ["rbxassetid://6475613071"] = {name = "Lime Slice Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051107"] = {name = "Llama Plush", prices = {["default"] = 6.46}},
    ["rbxassetid://4661940658"] = {name = "Magic House Door", prices = {["default"] = 65.62}},
    ["rbxassetid://3009779472"] = {name = "Marsh Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779496"] = {name = "Marsh Plush", prices = {["default"] = 3.42}},
    ["rbxassetid://5057099190"] = {name = "Monkey Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099046"] = {name = "Monkey Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670913"] = {name = "Noob Balloon", prices = {["default"] = 3.54}},
    ["rbxassetid://3009779607"] = {name = "Octopus Plush", prices = {["default"] = 2.52}},
    ["rbxassetid://4470749788"] = {name = "Ornament Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670921"] = {name = "Phoenix Plush", prices = {["default"] = 9.78}},
    ["rbxassetid://7368034465"] = {name = "Pink Cat Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544972"] = {name = "Plunger Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051114"] = {name = "Puppy Plush", prices = {["default"] = 3.14}},
    ["rbxassetid://3082046011"] = {name = "Rabbit Rattle", prices = {["default"] = 5.36}},
    ["rbxassetid://2408055079"] = {name = "Rainbow Wand", prices = {["default"] = 7.24}},
    ["rbxassetid://4470749750"] = {name = "Reindeer Leash", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779583"] = {name = "Rocket Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749474"] = {name = "Santa Leash", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750189"] = {name = "Santa Rattle", prices = {["default"] = 2.37}},
    ["rbxassetid://5061468835"] = {name = "Scroll Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://6475612857"] = {name = "Shuttle Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5882028350"] = {name = "Skull Drum", prices = {["default"] = 3.82}},
    ["rbxassetid://4470749413"] = {name = "Sleigh Bells Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://6059308940"] = {name = "Snowball Launcher", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671626"] = {name = "Snowman Plush", prices = {["default"] = 2.35}},
    ["rbxassetid://4470749691"] = {name = "Snowman Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750120"] = {name = "Sock Chew Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052387"] = {name = "Squid Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468930"] = {name = "Staff Ingredient", prices = {["default"] = 23.25}},
    ["rbxassetid://6768659222"] = {name = "Standard Grappling Hook", prices = {["default"] = 2.63}},
    ["rbxassetid://2408055085"] = {name = "Starpower Wand", prices = {["default"] = 3.05}},
    ["rbxassetid://3009779638"] = {name = "Telescope Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4710374217"] = {name = "Tennis Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4464390422"] = {name = "Turkey Plush", prices = {["default"] = 2.5}},
    ["rbxassetid://3977264097"] = {name = "Unicorn Leash", prices = {["default"] = 9.9}},
    ["rbxassetid://3570154347"] = {name = "Unicorn Plush", prices = {["default"] = 96.87}},
    ["rbxassetid://2408055086"] = {name = "Wooden Pogo", prices = {["default"] = 3.49}},
    ["rbxassetid://4155284126"] = {name = "Zombie Buffalo Plush", prices = {["default"] = 42.29}},
    ["rbxassetid://4880426741"] = {name = "Adventurer's Hood", prices = {["default"] = 3.94}},
    ["rbxassetid://4880426585"] = {name = "Adventurer's Sword", prices = {["default"] = 3.94}},
    ["rbxassetid://5726048254"] = {name = "Amber Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973461"] = {name = "Angel Wings", prices = {["default"] = 1040.82}},
    ["rbxassetid://6380734633"] = {name = "Antenna", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972567"] = {name = "Aviators", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973554"] = {name = "Bat Wings", prices = {["default"] = 37.41}},
    ["rbxassetid://6380843886"] = {name = "Bee Hive", prices = {["default"] = 2.62}},
    ["rbxassetid://6380734557"] = {name = "Bee Wings", prices = {["default"] = 4.73}},
    ["rbxassetid://4849973352"] = {name = "Beret", prices = {["default"] = 2.1}},
    ["rbxassetid://5881347869"] = {name = "Bewitched Hat", prices = {["default"] = 14.44}},
    ["rbxassetid://5415514537"] = {name = "Black 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415514707"] = {name = "Black Boots", prices = {["default"] = 21.31}},
    ["rbxassetid://5415514845"] = {name = "Black Cozy Hood", prices = {["default"] = 10.5}},
    ["rbxassetid://5415515017"] = {name = "Black Designer Backpack", prices = {["default"] = 6.57}},
    ["rbxassetid://4849975075"] = {name = "Black Fedora", prices = {["default"] = 3.62}},
    ["rbxassetid://5415515284"] = {name = "Black Hightops", prices = {["default"] = 5.25}},
    ["rbxassetid://5415515507"] = {name = "Black Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426690"] = {name = "Black Scarf", prices = {["default"] = 78.75}},
    ["rbxassetid://5415515653"] = {name = "Black Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5444594385"] = {name = "Blue Butterfly Wings", prices = {["default"] = 14.44}},
    ["rbxassetid://4849980085"] = {name = "Blue Cat Ear Headphones", prices = {["default"] = 41.2}},
    ["rbxassetid://5415515800"] = {name = "Blue Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048365"] = {name = "Bone Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426624"] = {name = "Briefcase", prices = {["default"] = 2.1}},
    ["rbxassetid://6706595341"] = {name = "Bunny Ear Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975457"] = {name = "Buttoned Ushanka", prices = {["default"] = 2.63}},
    ["rbxassetid://4849978837"] = {name = "Buzz Off! Skateboard", prices = {["default"] = 2.1}},
    ["rbxassetid://5415516304"] = {name = "Cassette", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975557"] = {name = "Chef Hat", prices = {["default"] = 82.64}},
    ["rbxassetid://6380734302"] = {name = "Cherry Earrings", prices = {["default"] = 10.22}},
    ["rbxassetid://6706591422"] = {name = "Chick Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://6706592723"] = {name = "Chick Hat", prices = {["default"] = 2.63}},
    ["rbxassetid://4849975633"] = {name = "Chicken Hat", prices = {["default"] = 49.22}},
    ["rbxassetid://4849972658"] = {name = "Clout Goggles", prices = {["default"] = 20.98}},
    ["rbxassetid://4849975702"] = {name = "Conductor Hat", prices = {["default"] = 5.21}},
    ["rbxassetid://4936545219"] = {name = "Cutlass", prices = {["default"] = 2.52}},
    ["rbxassetid://4849972740"] = {name = "Cyborg Shades", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037745"] = {name = "Daisy Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7601648534"] = {name = "Eco Blue Reusable Bottle Backpack", prices = {["default"] = 11.46}},
    ["rbxassetid://7542826699"] = {name = "Eco Blue Solar Panel Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810947"] = {name = "Eco Brown Branch Headphones", prices = {["default"] = 9.19}},
    ["rbxassetid://7542815049"] = {name = "Eco Brown Hiking Backpack", prices = {["default"] = 37.54}},
    ["rbxassetid://7542816175"] = {name = "Eco Green Leaf Afro", prices = {["default"] = 2.63}},
    ["rbxassetid://7542816369"] = {name = "Eco Green Leaf Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810810"] = {name = "Eco Orange Leaf Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542820583"] = {name = "Eco Orange Maple Cape", prices = {["default"] = 8.53}},
    ["rbxassetid://7542810709"] = {name = "Eco Orange Maple Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542817978"] = {name = "Eco Orange Maple Leaf Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://7542823324"] = {name = "Eco Orange Pumpkin Eyepatch", prices = {["default"] = 18.8}},
    ["rbxassetid://7542824283"] = {name = "Eco Orange Pumpkin Pie Wings", prices = {["default"] = 49.26}},
    ["rbxassetid://7542813412"] = {name = "Eco Red Cranberry Branch Wings", prices = {["default"] = 18.38}},
    ["rbxassetid://7542821672"] = {name = "Eco Red Mushroom Hood", prices = {["default"] = 4.86}},
    ["rbxassetid://6706593596"] = {name = "Egg Barrette", prices = {["default"] = 2.1}},
    ["rbxassetid://6706594347"] = {name = "Egg Glasses", prices = {["default"] = 3.94}},
    ["rbxassetid://4850383048"] = {name = "Elf Hat", prices = {["default"] = 70.87}},
    ["rbxassetid://4849976006"] = {name = "Explorer Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495463"] = {name = "Eyepatch", prices = {["default"] = 26.25}},
    ["rbxassetid://6060998776"] = {name = "Festive Tree Hat", prices = {["default"] = 2.63}},
    ["rbxassetid://4853278462"] = {name = "Firey Aura", prices = {["default"] = 4.66}},
    ["rbxassetid://4849979365"] = {name = "First Aid Bag", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976218"] = {name = "Flamenco Hat", prices = {["default"] = 6.19}},
    ["rbxassetid://6437127230"] = {name = "Flower Collar", prices = {["default"] = 2.12}},
    ["rbxassetid://6380734218"] = {name = "Flower Crown", prices = {["default"] = 27.88}},
    ["rbxassetid://5726048455"] = {name = "Forgotten Flower", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734014"] = {name = "Froggy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://6060998635"] = {name = "Fur Boots", prices = {["default"] = 7.88}},
    ["rbxassetid://5415517473"] = {name = "Gold Chain", prices = {["default"] = 105}},
    ["rbxassetid://5415517604"] = {name = "Gold Circle Glasses", prices = {["default"] = 26.25}},
    ["rbxassetid://5415517745"] = {name = "Gold Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979471"] = {name = "Golden Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730894"] = {name = "Goth Shoes", prices = {["default"] = 144.38}},
    ["rbxassetid://4849976420"] = {name = "Green Lotus", prices = {["default"] = 2.3}},
    ["rbxassetid://7368039312"] = {name = "Growing Flower Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4489907389"] = {name = "Halo", prices = {["default"] = 1257.45}},
    ["rbxassetid://5444594659"] = {name = "Handheld", prices = {["default"] = 3.45}},
    ["rbxassetid://4849976512"] = {name = "Head Chef", prices = {["default"] = 233.1}},
    ["rbxassetid://5067924536"] = {name = "Head Tie", prices = {["default"] = 4.66}},
    ["rbxassetid://6404037642"] = {name = "Headband", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979572"] = {name = "Headset", prices = {["default"] = 2.63}},
    ["rbxassetid://5415521592"] = {name = "Hoop Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991420"] = {name = "Ice Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991330"] = {name = "Ice Earrings", prices = {["default"] = 2.63}},
    ["rbxassetid://6060991245"] = {name = "Ice Wings", prices = {["default"] = 2.63}},
    ["rbxassetid://4849973617"] = {name = "Jade Moth Wings", prices = {["default"] = 48.77}},
    ["rbxassetid://4849979214"] = {name = "Jeff's Nametag", prices = {["default"] = 72.19}},
    ["rbxassetid://5415517859"] = {name = "Jetpack", prices = {["default"] = 2.5}},
    ["rbxassetid://5067924626"] = {name = "Kitsune Mask", prices = {["default"] = 2.63}},
    ["rbxassetid://4849973992"] = {name = "Lavender Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730364"] = {name = "Leaf Wings", prices = {["default"] = 4.14}},
    ["rbxassetid://6380730271"] = {name = "Leprechaun Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278902"] = {name = "Luggage", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924890"] = {name = "Monkey King Crown", prices = {["default"] = 32.7}},
    ["rbxassetid://4849977086"] = {name = "Monocle", prices = {["default"] = 11.61}},
    ["rbxassetid://4849979887"] = {name = "Moon Tome", prices = {["default"] = 18.37}},
    ["rbxassetid://4849976759"] = {name = "Morion", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048545"] = {name = "Nautilus Shell Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976912"] = {name = "Ninja Headband", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727237"] = {name = "Orange Glasses", prices = {["default"] = 2.63}},
    ["rbxassetid://4849977244"] = {name = "Party Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://5415523249"] = {name = "Pearl Necklace", prices = {["default"] = 2.63}},
    ["rbxassetid://6380727177"] = {name = "Picnic Basket", prices = {["default"] = 3.61}},
    ["rbxassetid://5415518324"] = {name = "Pink 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518474"] = {name = "Pink Boots", prices = {["default"] = 6.57}},
    ["rbxassetid://5444594884"] = {name = "Pink Butterfly Wings", prices = {["default"] = 2.63}},
    ["rbxassetid://4849979637"] = {name = "Pink Cat Ear Headphones", prices = {["default"] = 56.16}},
    ["rbxassetid://5415518613"] = {name = "Pink Designer Backpack", prices = {["default"] = 3.02}},
    ["rbxassetid://4849972826"] = {name = "Pink Heart Glasses", prices = {["default"] = 72.18}},
    ["rbxassetid://5457768184"] = {name = "Pink Hightops", prices = {["default"] = 2.63}},
    ["rbxassetid://5415518811"] = {name = "Pink Instant Camera", prices = {["default"] = 3.92}},
    ["rbxassetid://4849977427"] = {name = "Pink Lotus", prices = {["default"] = 2.24}},
    ["rbxassetid://5415520296"] = {name = "Pink Sneakers", prices = {["default"] = 3.94}},
    ["rbxassetid://4849977514"] = {name = "Pirate Hat", prices = {["default"] = 2.63}},
    ["rbxassetid://5444711861"] = {name = "Platinum Tiara", prices = {["default"] = 31.5}},
    ["rbxassetid://4849977607"] = {name = "Propeller Hat", prices = {["default"] = 124.69}},
    ["rbxassetid://4849972928"] = {name = "Purple Heart Glasses", prices = {["default"] = 3.56}},
    ["rbxassetid://4849977695"] = {name = "Purple Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037362"] = {name = "Rain Boots", prices = {["default"] = 76.83}},
    ["rbxassetid://5415520831"] = {name = "Rain Hat", prices = {["default"] = 7.88}},
    ["rbxassetid://7498079214"] = {name = "RB Battles Trophy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977830"] = {name = "Red Beanie", prices = {["default"] = 2.1}},
    ["rbxassetid://6380847814"] = {name = "Red Masquerade Mask", prices = {["default"] = 3.48}},
    ["rbxassetid://5415520972"] = {name = "Red Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521183"] = {name = "Red Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973276"] = {name = "Reindeer Antlers", prices = {["default"] = 33.64}},
    ["rbxassetid://4933495361"] = {name = "Respectful Mustache", prices = {["default"] = 137.96}},
    ["rbxassetid://8151013513"] = {name = "RGB Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978102"] = {name = "Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495425"] = {name = "Ruff", prices = {["default"] = 52.5}},
    ["rbxassetid://4849978200"] = {name = "Sailor Cap", prices = {["default"] = 91.88}},
    ["rbxassetid://4850382817"] = {name = "Santa Hat", prices = {["default"] = 237.56}},
    ["rbxassetid://5881348094"] = {name = "Scythe", prices = {["default"] = 2.63}},
    ["rbxassetid://4853278537"] = {name = "Shadow Aura", prices = {["default"] = 110.17}},
    ["rbxassetid://4849980009"] = {name = "Shadow Shuriken", prices = {["default"] = 8.26}},
    ["rbxassetid://4849973681"] = {name = "Shadow Wings", prices = {["default"] = 164.07}},
    ["rbxassetid://4849972466"] = {name = "Shark Fin", prices = {["default"] = 3.92}},
    ["rbxassetid://4849973100"] = {name = "Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521379"] = {name = "Silver Chain", prices = {["default"] = 7.88}},
    ["rbxassetid://4849974099"] = {name = "Skeleton Shell", prices = {["default"] = 2.1}},
    ["rbxassetid://4849974434"] = {name = "Spike Collar", prices = {["default"] = 31.4}},
    ["rbxassetid://6380723429"] = {name = "Strawberry Hat", prices = {["default"] = 58.8}},
    ["rbxassetid://4849975162"] = {name = "Sun Tome", prices = {["default"] = 3.94}},
    ["rbxassetid://4849976090"] = {name = "Sushi Skateboard", prices = {["default"] = 42.84}},
    ["rbxassetid://4849976985"] = {name = "Turtle Shell", prices = {["default"] = 6.18}},
    ["rbxassetid://4849978035"] = {name = "Watermelon Backpack", prices = {["default"] = 3.18}},
    ["rbxassetid://5415522308"] = {name = "White Designer Backpack", prices = {["default"] = 35.95}},
    ["rbxassetid://5415522533"] = {name = "White Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979019"] = {name = "Windup Key", prices = {["default"] = 14.65}},
    ["rbxassetid://4849977314"] = {name = "Witch Hat", prices = {["default"] = 36.92}},
    ["rbxassetid://4849978608"] = {name = "Wizard Hat", prices = {["default"] = 11.46}},
    ["rbxassetid://5415522859"] = {name = "Yellow Designer Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5415522973"] = {name = "Yellow Instant Camera", prices = {["default"] = 4.11}},
    ["rbxassetid://5415523115"] = {name = "Yellow Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277758"] = {name = "Airplane Stroller", prices = {["default"] = 17.01}},
    ["rbxassetid://2657667120"] = {name = "Baby Basket Stroller", prices = {["default"] = 50.55}},
    ["rbxassetid://2761277454"] = {name = "Balloon Stroller", prices = {["default"] = 3.94}},
    ["rbxassetid://3009779202"] = {name = "Banana Stroller", prices = {["default"] = 2.43}},
    ["rbxassetid://3082046286"] = {name = "Bunny Stroller", prices = {["default"] = 20.79}},
    ["rbxassetid://3009779260"] = {name = "Cannon Stroller", prices = {["default"] = 3.84}},
    ["rbxassetid://3269748269"] = {name = "Car Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6475616233"] = {name = "Catapult Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248341"] = {name = "Cauldron Stroller", prices = {["default"] = 3.82}},
    ["rbxassetid://2408051111"] = {name = "Cradle Stroller", prices = {["default"] = 36.66}},
    ["rbxassetid://4361544460"] = {name = "Crate Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3486905775"] = {name = "Dog House Stroller", prices = {["default"] = 2.63}},
    ["rbxassetid://1408016951"] = {name = "Double Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1406692267"] = {name = "Droplet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277656"] = {name = "Duck Stroller", prices = {["default"] = 52.5}},
    ["rbxassetid://3082046174"] = {name = "Easter Egg Stroller", prices = {["default"] = 20.85}},
    ["rbxassetid://2761277703"] = {name = "Egg Stroller", prices = {["default"] = 1771.88}},
    ["rbxassetid://4822522123"] = {name = "Flower Stroller", prices = {["default"] = 9.01}},
    ["rbxassetid://3009779395"] = {name = "French Fries Stroller", prices = {["default"] = 6.78}},
    ["rbxassetid://3082046130"] = {name = "Half Egg Stroller", prices = {["default"] = 37.29}},
    ["rbxassetid://3486906113"] = {name = "Hatched Egg Stroller", prices = {["default"] = 2.24}},
    ["rbxassetid://2848462165"] = {name = "Heart Stroller", prices = {["default"] = 377.03}},
    ["rbxassetid://6475613319"] = {name = "High Heel Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6967530077"] = {name = "Hover Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670917"] = {name = "Ice Cream Stroller", prices = {["default"] = 11.82}},
    ["rbxassetid://3486906383"] = {name = "Kangaroo Stroller", prices = {["default"] = 10.17}},
    ["rbxassetid://7368046225"] = {name = "Lunar Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936630605"] = {name = "Magic Carpet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936629525"] = {name = "Magic Moon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6309085791"] = {name = "Palanquin Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936631399"] = {name = "Pelican Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670918"] = {name = "Pizza Stroller", prices = {["default"] = 9.43}},
    ["rbxassetid://3009779443"] = {name = "Popsicle Stroller", prices = {["default"] = 15.45}},
    ["rbxassetid://6936628317"] = {name = "Princess Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://5882036757"] = {name = "Pumpkin Stroller", prices = {["default"] = 9.11}},
    ["rbxassetid://2408052388"] = {name = "Quad Stroller", prices = {["default"] = 262.4}},
    ["rbxassetid://2408035750"] = {name = "Race Car Stroller", prices = {["default"] = 32.71}},
    ["rbxassetid://6710108407"] = {name = "Rainbow Stroller", prices = {["default"] = 49.88}},
    ["rbxassetid://4470748252"] = {name = "Reindeer Stroller", prices = {["default"] = 5.92}},
    ["rbxassetid://8526099597"] = {name = "RGB Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2981204560"] = {name = "Rocket Ship Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://13986982302"] = {name = "Shopping Cart Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936628967"] = {name = "Teacup Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2982964426"] = {name = "Throne Stroller", prices = {["default"] = 5.25}},
    ["rbxassetid://2657671637"] = {name = "Trike Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544584"] = {name = "Triple Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277803"] = {name = "Unicorn Stroller", prices = {["default"] = 61.6}},
    ["rbxassetid://2466291803"] = {name = "Vampire Stroller", prices = {["default"] = 124.69}},
    ["rbxassetid://3066606234"] = {name = "Wheelbarrow Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://113061955717247"] = {name = "Admin Abuse Box", prices = {["default"] = 2.1}},
    ["rbxassetid://5888839551"] = {name = "Bat Box", prices = {["default"] = 52.5}},
    ["rbxassetid://4510471983"] = {name = "Golden Gift", prices = {["default"] = 918.75}},
    ["rbxassetid://5057100696"] = {name = "Monkey Box", prices = {["default"] = 157.5}},
    ["rbxassetid://6240246974"] = {name = "Ox Box", prices = {["default"] = 6.57}},
    ["rbxassetid://5067925110"] = {name = "Premium Monkey Box", prices = {["default"] = 2161.89}},
    ["rbxassetid://4621220017"] = {name = "Rat Box", prices = {["default"] = 524.99}},
    ["rbxassetid://8604215904"] = {name = "RGB Reward Box", prices = {["default"] = 6.57}},
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