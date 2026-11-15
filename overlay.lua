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
    ["rbxassetid://137637490639925"] = {name = "Royal Mistletroll", prices = {["default"] = 910.42, ["Fly"] = 1129.87, ["Ride"] = 1050, ["Fly|Ride"] = 1025.07, ["Neon"] = 6605.27, ["Neon|Ride"] = 4941.91, ["Neon|Fly|Ride"] = 3921.75, ["Mega|Fly|Ride"] = 21174.57}},
    ["rbxassetid://140355753768438"] = {name = "Moonbeam Peacock", prices = {["default"] = 392.23, ["Fly"] = 540.05, ["Ride"] = 367.5, ["Fly|Ride"] = 525.16, ["Neon|Fly|Ride"] = 1942.04, ["Mega"] = 9885, ["Mega|Fly|Ride"] = 8230.8}},
    ["rbxassetid://18117855573"] = {name = "Balloon Unicorn", prices = {["default"] = 4725, ["Ride"] = 5250, ["Fly|Ride"] = 4725, ["Neon"] = 26119.96, ["Neon|Fly|Ride"] = 22004.01, ["Mega|Fly|Ride"] = 62130.17}},
    ["rbxassetid://75782719698946"] = {name = "Red Dutch Guinea Pig", prices = {["default"] = 124.69, ["Ride"] = 183.75, ["Fly|Ride"] = 252.42, ["Neon"] = 1415.43, ["Neon|Ride"] = 821.63, ["Neon|Fly|Ride"] = 1412.59, ["Mega"] = 3812.52, ["Mega|Fly|Ride"] = 2586.71}},
    ["rbxassetid://5067924142"] = {name = "Albino Monkey", prices = {["default"] = 498.75, ["Ride"] = 528.34, ["Fly|Ride"] = 533.44, ["Neon|Ride"] = 1855.21, ["Neon|Fly|Ride"] = 1483.13, ["Mega"] = 11213.47, ["Mega|Fly|Ride"] = 6353.13}},
    ["rbxassetid://108312620331321"] = {name = "Villain Gibbon", prices = {["default"] = 7.77, ["Ride"] = 32.82, ["Fly|Ride"] = 150.98, ["Neon"] = 49.79, ["Neon|Ride"] = 141.56, ["Neon|Fly|Ride"] = 282.75, ["Mega"] = 262.5, ["Mega|Ride"] = 467.34, ["Mega|Fly|Ride"] = 465.94}},
    ["rbxassetid://17255958862"] = {name = "Alicorn", prices = {["default"] = 3.91, ["Fly"] = 28.88, ["Ride"] = 21.19, ["Fly|Ride"] = 62.64, ["Neon"] = 24.94, ["Neon|Fly"] = 65.67, ["Neon|Ride"] = 36.59, ["Neon|Fly|Ride"] = 105, ["Mega"] = 118.13, ["Mega|Ride"] = 141.58, ["Mega|Fly|Ride"] = 244.56}},
    ["rbxassetid://90170598608675"] = {name = "Moonbeam Butterfly", prices = {["default"] = 99.56, ["Fly"] = 184.26, ["Ride"] = 156.76, ["Fly|Ride"] = 231, ["Neon"] = 418.69, ["Neon|Ride"] = 471.75, ["Neon|Fly|Ride"] = 706.3, ["Mega|Fly|Ride"] = 1821.54}},
    ["rbxassetid://7126722445"] = {name = "Goldhorn", prices = {["default"] = 31.49, ["Fly"] = 142.96, ["Ride"] = 42, ["Fly|Ride"] = 98.44, ["Neon"] = 235.92, ["Neon|Ride"] = 183.75, ["Neon|Fly|Ride"] = 248.12, ["Mega"] = 2100, ["Mega|Ride"] = 1273.88, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://13186021971"] = {name = "Cuddly Candle", prices = {["default"] = 26.25, ["Fly"] = 74.76, ["Ride"] = 39.38, ["Fly|Ride"] = 69.57, ["Neon"] = 282.75, ["Neon|Ride"] = 181.09, ["Neon|Fly|Ride"] = 204.75, ["Mega|Fly|Ride"] = 728.44}},
    ["rbxassetid://14146196672"] = {name = "Gargoyle", prices = {["default"] = 47.25, ["Fly"] = 288.03, ["Ride"] = 65.63, ["Fly|Ride"] = 131.62, ["Neon"] = 262.5, ["Neon|Fly"] = 224.12, ["Neon|Ride"] = 210.74, ["Neon|Fly|Ride"] = 265.42, ["Mega|Ride"] = 1375.7, ["Mega|Fly|Ride"] = 1270.85}},
    ["rbxassetid://129762233626342"] = {name = "Royal Moon Egg", prices = {["default"] = 82.69}},
    ["rbxassetid://89693546199400"] = {name = "Cupid Dragon", prices = {["default"] = 379.32, ["Ride"] = 366.19, ["Fly|Ride"] = 349.13, ["Neon"] = 1283.63, ["Neon|Ride"] = 1269.63, ["Neon|Fly|Ride"] = 1330.41, ["Mega"] = 5648.89, ["Mega|Fly|Ride"] = 5505.92}},
    ["rbxassetid://8665606875"] = {name = "Dancing Dragon", prices = {["default"] = 123.38, ["Fly"] = 177.91, ["Ride"] = 139.13, ["Fly|Ride"] = 157.37, ["Neon|Ride"] = 564.38, ["Neon|Fly|Ride"] = 544.37, ["Mega|Fly|Ride"] = 2151.97}},
    ["rbxassetid://110411427278536"] = {name = "Huntsman Robin", prices = {["default"] = 2.63, ["Fly"] = 32.84, ["Ride"] = 51.85, ["Fly|Ride"] = 78.75, ["Neon"] = 15.75, ["Neon|Ride"] = 78.38, ["Neon|Fly|Ride"] = 80.49, ["Mega"] = 84, ["Mega|Ride"] = 189, ["Mega|Fly|Ride"] = 383.25}},
    ["rbxassetid://10925517718"] = {name = "Lava Dragon", prices = {["default"] = 118.13, ["Fly"] = 187.69, ["Ride"] = 144.53, ["Fly|Ride"] = 186.38, ["Neon"] = 706.3, ["Neon|Ride"] = 1347.01, ["Neon|Fly|Ride"] = 521.07, ["Mega|Fly|Ride"] = 1837.38}},
    ["rbxassetid://4797806482"] = {name = "Diamond Griffin", prices = {["default"] = 2.63, ["Fly"] = 24.36, ["Ride"] = 19.67, ["Fly|Ride"] = 52.44, ["Neon"] = 37.08, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 254.19, ["Mega|Ride"] = 326.82, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://122648024705835"] = {name = "Scarebear", prices = {["default"] = 43.62, ["Fly"] = 262.5, ["Ride"] = 93.19, ["Fly|Ride"] = 105.92, ["Neon"] = 177.19, ["Neon|Ride"] = 223.97, ["Neon|Fly|Ride"] = 317.63, ["Mega"] = 688.38, ["Mega|Ride"] = 811, ["Mega|Fly|Ride"] = 756}},
    ["rbxassetid://13104102169"] = {name = "Danger Egg", prices = {["default"] = 57.66}},
    ["rbxassetid://133163961974577"] = {name = "2D Doggy", prices = {["default"] = 65.63, ["Ride"] = 117.54, ["Neon"] = 280.88, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 2362.5, ["Mega|Fly|Ride"] = 3145.73}},
    ["rbxassetid://126071806166898"] = {name = "Evil Chick", prices = {["default"] = 14.44, ["Fly"] = 393.75, ["Ride"] = 36.02, ["Fly|Ride"] = 106.32, ["Neon"] = 154.62, ["Neon|Ride"] = 344.01, ["Neon|Fly|Ride"] = 268.98, ["Mega"] = 2712.85, ["Mega|Ride"] = 564.38, ["Mega|Fly|Ride"] = 1694.47}},
    ["rbxassetid://5721843247"] = {name = "Dodo", prices = {["default"] = 37.65, ["Fly"] = 70.96, ["Ride"] = 56.91, ["Fly|Ride"] = 105, ["Neon"] = 224.51, ["Neon|Ride"] = 203.34, ["Neon|Fly|Ride"] = 210, ["Mega"] = 1681.32, ["Mega|Fly|Ride"] = 834.73}},
    ["rbxassetid://119640582603552"] = {name = "Violet Butterfly", prices = {["default"] = 57.2, ["Ride"] = 155.76, ["Fly|Ride"] = 132.88, ["Neon"] = 208.68, ["Neon|Ride"] = 223.12, ["Neon|Fly|Ride"] = 316.63, ["Mega"] = 1694.47, ["Mega|Ride"] = 1264.5, ["Mega|Fly|Ride"] = 1269.79}},
    ["rbxassetid://16088264958"] = {name = "Volcanic Rhino", prices = {["default"] = 36.04, ["Fly"] = 63.71, ["Ride"] = 50.85, ["Fly|Ride"] = 158.17, ["Neon|Ride"] = 211.79, ["Neon|Fly|Ride"] = 169.44, ["Mega"] = 1207.92, ["Mega|Ride"] = 2100, ["Mega|Fly|Ride"] = 1101.82}},
    ["rbxassetid://75251818654427"] = {name = "Apple Owl", prices = {["default"] = 43.53, ["Fly"] = 650.67, ["Ride"] = 83.67, ["Fly|Ride"] = 135.19, ["Neon"] = 313.42, ["Neon|Ride"] = 282.75, ["Neon|Fly|Ride"] = 492.19, ["Mega|Ride"] = 1124.82, ["Mega|Fly|Ride"] = 1270.85}},
    ["rbxassetid://3181727433"] = {name = "Dragon", prices = {["default"] = 6.3, ["Fly"] = 35.44, ["Ride"] = 22.31, ["Fly|Ride"] = 55.12, ["Neon"] = 31.5, ["Neon|Fly"] = 70.88, ["Neon|Ride"] = 44.63, ["Neon|Fly|Ride"] = 86.63, ["Mega"] = 129.94, ["Mega|Fly"] = 275.63, ["Mega|Ride"] = 127.1, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://121496682360324"] = {name = "Sugar Axolotl", prices = {["default"] = 332.51, ["Ride"] = 338.63, ["Fly|Ride"] = 362.12, ["Neon"] = 1181.25, ["Neon|Ride"] = 1978.05, ["Neon|Fly|Ride"] = 1666.88, ["Mega"] = 10590.32, ["Mega|Fly|Ride"] = 5976.52}},
    ["rbxassetid://11694854226"] = {name = "Shetland Pony Light Brown", prices = {["default"] = 14.05, ["Ride"] = 27.43, ["Fly|Ride"] = 137.52, ["Neon"] = 239.32, ["Neon|Ride"] = 304.5, ["Mega"] = 833.47}},
    ["rbxassetid://4797806957"] = {name = "Golden Unicorn", prices = {["default"] = 9.19, ["Fly"] = 48.72, ["Ride"] = 21.19, ["Fly|Ride"] = 48.57, ["Neon"] = 42, ["Neon|Ride"] = 64.32, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 314.94, ["Mega|Ride"] = 619.5, ["Mega|Fly|Ride"] = 379.6}},
    ["rbxassetid://110822620060051"] = {name = "Frost Phoenix", prices = {["default"] = 100.96, ["Fly"] = 141.54, ["Ride"] = 113.32, ["Fly|Ride"] = 142.01, ["Neon"] = 375.93, ["Neon|Ride"] = 462.76, ["Neon|Fly|Ride"] = 446.25, ["Mega"] = 6250.16, ["Mega|Ride"] = 1474.02, ["Mega|Fly|Ride"] = 1587.5}},
    ["rbxassetid://13894724323"] = {name = "Billy Goat", prices = {["default"] = 11.12, ["Fly"] = 36.02, ["Ride"] = 28.88, ["Fly|Ride"] = 59.05, ["Neon"] = 84.73, ["Neon|Ride"] = 141.9, ["Neon|Fly|Ride"] = 195.82, ["Mega|Ride"] = 635.43, ["Mega|Fly|Ride"] = 635.43}},
    ["rbxassetid://123037843357105"] = {name = "Glormy Leo", prices = {["default"] = 220.37, ["Fly"] = 353.69, ["Ride"] = 275.63, ["Fly|Ride"] = 269.07, ["Neon"] = 773.07, ["Neon|Ride"] = 1058.92, ["Neon|Fly|Ride"] = 773.07, ["Mega"] = 6354.21, ["Mega|Ride"] = 2858.35, ["Mega|Fly|Ride"] = 3146.07}},
    ["rbxassetid://12479078933"] = {name = "Southeast Asia Egg", prices = {["default"] = 39.38}},
    ["rbxassetid://122739780018633"] = {name = "Quetzalcoatl", prices = {["default"] = 3.42, ["Fly"] = 36.58, ["Ride"] = 21, ["Fly|Ride"] = 93.19, ["Neon"] = 15.75, ["Neon|Fly"] = 99.56, ["Neon|Ride"] = 36.02, ["Neon|Fly|Ride"] = 107.73, ["Mega"] = 131.25, ["Mega|Fly"] = 211.82, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://70953296065239"] = {name = "Frostbite Bear", prices = {["default"] = 724.5, ["Ride"] = 851.82, ["Fly|Ride"] = 913.5, ["Neon"] = 4518.35, ["Neon|Ride"] = 3069.77, ["Neon|Fly|Ride"] = 3493.33, ["Mega"] = 12567.54, ["Mega|Ride"] = 53077.26, ["Mega|Fly|Ride"] = 12694.61}},
    ["rbxassetid://14978701948"] = {name = "Scarecrow Crow", prices = {["default"] = 6.57, ["Fly"] = 28.49, ["Ride"] = 28.88, ["Fly|Ride"] = 91.09, ["Neon"] = 109.08, ["Neon|Ride"] = 118.09, ["Neon|Fly|Ride"] = 138.73, ["Mega"] = 511.88, ["Mega|Ride"] = 599.43, ["Mega|Fly|Ride"] = 537.07}},
    ["rbxassetid://11191341630"] = {name = "Jousting Horse", prices = {["default"] = 94.5, ["Ride"] = 118.13, ["Fly|Ride"] = 235.91, ["Neon"] = 669.24, ["Neon|Ride"] = 626.89, ["Neon|Fly|Ride"] = 656.25, ["Mega|Ride"] = 6074.25, ["Mega|Fly|Ride"] = 2328.82}},
    ["rbxassetid://76801905892592"] = {name = "Royal Aztec Egg", prices = {["default"] = 36.02}},
    ["rbxassetid://98801943598121"] = {name = "Priceless Shrimp", prices = {["default"] = 15.74, ["Ride"] = 53, ["Fly|Ride"] = 141.56, ["Neon"] = 169.45, ["Neon|Ride"] = 156.73, ["Neon|Fly|Ride"] = 472.5, ["Mega"] = 565.55, ["Mega|Ride"] = 723.19, ["Mega|Fly|Ride"] = 786.75}},
    ["rbxassetid://95214789806437"] = {name = "Aztec Egg", prices = {["default"] = 2.63}},
    ["rbxassetid://18515755354"] = {name = "Cheetah", prices = {["default"] = 131.25, ["Fly"] = 210.74, ["Ride"] = 170.63, ["Neon|Ride"] = 498.75, ["Neon|Fly|Ride"] = 706.3, ["Mega|Fly|Ride"] = 2327.77}},
    ["rbxassetid://18117855114"] = {name = "Corn Doggo", prices = {["default"] = 89.25, ["Ride"] = 157.5, ["Fly|Ride"] = 245.44, ["Neon"] = 480.75, ["Neon|Ride"] = 420, ["Neon|Fly|Ride"] = 537.76, ["Mega"] = 1312.5, ["Mega|Ride"] = 1509.38, ["Mega|Fly|Ride"] = 1475.2}},
    ["rbxassetid://8972175010"] = {name = "Woodland Egg", prices = {["default"] = 48.57}},
    ["rbxassetid://3710823011"] = {name = "Golden Penguin", prices = {["default"] = 60.38, ["Fly"] = 65.63, ["Ride"] = 49.79, ["Fly|Ride"] = 77.7, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 311.07, ["Mega"] = 4235.07, ["Mega|Fly|Ride"] = 1350.74}},
    ["rbxassetid://136490701345923"] = {name = "Glormy Crab", prices = {["default"] = 10.28, ["Ride"] = 36.58, ["Fly|Ride"] = 159.93, ["Neon"] = 31.5, ["Neon|Ride"] = 54.02, ["Neon|Fly|Ride"] = 226.63, ["Mega"] = 171.51, ["Mega|Fly"] = 267.75, ["Mega|Ride"] = 264.78, ["Mega|Fly|Ride"] = 350.73}},
    ["rbxassetid://14782580581"] = {name = "Vampire Dragon", prices = {["default"] = 322.55, ["Fly"] = 420, ["Ride"] = 351.75, ["Fly|Ride"] = 411.1, ["Neon|Ride"] = 1554.55, ["Neon|Fly|Ride"] = 1244.07, ["Mega|Fly|Ride"] = 4606.81}},
    ["rbxassetid://88405494856204"] = {name = "Solaris", prices = {["default"] = 77.44, ["Fly"] = 99.75, ["Ride"] = 98.44, ["Fly|Ride"] = 122.68, ["Neon"] = 354.38, ["Neon|Ride"] = 381.22, ["Neon|Fly|Ride"] = 328.13, ["Mega|Ride"] = 1904.15, ["Mega|Fly|Ride"] = 1821.54}},
    ["rbxassetid://84468510887759"] = {name = "Orchid Butterfly", prices = {["default"] = 3797.24, ["Ride"] = 3743.7, ["Fly|Ride"] = 3017.43, ["Neon|Fly|Ride"] = 13764.69}},
    ["rbxassetid://11109286837"] = {name = "Lava Wolf", prices = {["default"] = 51.19, ["Fly"] = 113.32, ["Ride"] = 56.44, ["Fly|Ride"] = 95.82, ["Neon|Ride"] = 229.69, ["Neon|Fly|Ride"] = 692.39, ["Mega"] = 1906.27, ["Mega|Ride"] = 1115.63}},
    ["rbxassetid://12403863809"] = {name = "Albino Gorilla", prices = {["default"] = 85.32, ["Ride"] = 60.38, ["Fly|Ride"] = 141.56, ["Neon"] = 479.07, ["Neon|Ride"] = 794.78, ["Neon|Fly|Ride"] = 494.53, ["Mega"] = 6354.21, ["Mega|Fly|Ride"] = 1624.56}},
    ["rbxassetid://6060988121"] = {name = "Snow Owl", prices = {["default"] = 39.29, ["Fly"] = 76.13, ["Ride"] = 69.57, ["Fly|Ride"] = 125.9, ["Neon"] = 150.94, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 205.05, ["Mega"] = 2598.75, ["Mega|Ride"] = 613.35, ["Mega|Fly|Ride"] = 612.91}},
    ["rbxassetid://112630556645658"] = {name = "Moon Egg", prices = {["default"] = 12.6}},
    ["rbxassetid://10357473556"] = {name = "Golden Chow-Chow", prices = {["default"] = 49.81, ["Ride"] = 76.13, ["Fly|Ride"] = 117.57, ["Neon"] = 354.75, ["Neon|Ride"] = 471.81, ["Neon|Fly|Ride"] = 508.3}},
    ["rbxassetid://5721843384"] = {name = "Fossil Egg", prices = {["default"] = 38.06}},
    ["rbxassetid://92775688228060"] = {name = "Papa Moose", prices = {["default"] = 200.97, ["Ride"] = 317.69, ["Fly|Ride"] = 338.9, ["Neon|Fly|Ride"] = 1468.71}},
    ["rbxassetid://12479991588"] = {name = "Frost Unicorn", prices = {["default"] = 723.19, ["Ride"] = 793.89, ["Fly|Ride"] = 787.5, ["Neon|Ride"] = 3246.62, ["Neon|Fly|Ride"] = 2756.25, ["Mega|Fly|Ride"] = 11812.5}},
    ["rbxassetid://9661880325"] = {name = "Zodiac Minion Egg", prices = {["default"] = 3.93}},
    ["rbxassetid://7126719832"] = {name = "Phoenix", prices = {["default"] = 30.74, ["Fly"] = 52.42, ["Ride"] = 36.75, ["Fly|Ride"] = 70.97, ["Neon"] = 183.75, ["Neon|Ride"] = 177.19, ["Neon|Fly|Ride"] = 202.71, ["Mega|Ride"] = 918.75, ["Mega|Fly|Ride"] = 662.58}},
    ["rbxassetid://119386690822810"] = {name = "Royal Fairytale Egg", prices = {["default"] = 9.98}},
    ["rbxassetid://4440866299"] = {name = "Crow", prices = {["default"] = 4265.63, ["Ride"] = 5903.05, ["Fly|Ride"] = 4723.69, ["Neon|Fly|Ride"] = 9495.94, ["Mega|Fly|Ride"] = 40808.71}},
    ["rbxassetid://4797806531"] = {name = "Diamond Unicorn", prices = {["default"] = 10.49, ["Fly"] = 65.63, ["Ride"] = 27.56, ["Fly|Ride"] = 52.5, ["Neon"] = 97.02, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 105, ["Mega"] = 393.75, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 471.81}},
    ["rbxassetid://88817325500927"] = {name = "Kraken", prices = {["default"] = 10.5, ["Fly"] = 94.39, ["Ride"] = 30.19, ["Fly|Ride"] = 116.79, ["Neon"] = 78.75, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 847.24, ["Mega|Ride"] = 521.06, ["Mega|Fly|Ride"] = 660.85}},
    ["rbxassetid://9490243442"] = {name = "Diamond King Penguin", prices = {["default"] = 85.32, ["Fly"] = 139.21, ["Ride"] = 94.5, ["Fly|Ride"] = 140.44, ["Neon"] = 1412.59, ["Neon|Fly|Ride"] = 420, ["Mega"] = 4236.14}},
    ["rbxassetid://107787284008278"] = {name = "Primal Kaijunior", prices = {["default"] = 13.13, ["Ride"] = 42, ["Fly|Ride"] = 139.65, ["Neon"] = 53.82, ["Neon|Ride"] = 90.57, ["Mega"] = 1412.76, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://4506837037"] = {name = "Arctic Reindeer", prices = {["default"] = 2100, ["Fly"] = 2471.44, ["Ride"] = 2021.25, ["Fly|Ride"] = 2065.88, ["Neon|Fly|Ride"] = 3937.5, ["Mega|Fly|Ride"] = 14119.41}},
    ["rbxassetid://4184878149"] = {name = "Bat Dragon", prices = {["default"] = 31449.22, ["Fly"] = 35223.07, ["Ride"] = 35319.38, ["Fly|Ride"] = 23887.5, ["Neon|Ride"] = 65625, ["Neon|Fly|Ride"] = 61687.5, ["Mega"] = 210000, ["Mega|Fly|Ride"] = 197686.09}},
    ["rbxassetid://118641789458122"] = {name = "Gilded Snake", prices = {["default"] = 35.78, ["Fly"] = 393.75, ["Ride"] = 42, ["Fly|Ride"] = 91.09, ["Neon"] = 135.55, ["Neon|Ride"] = 178.38, ["Neon|Fly|Ride"] = 282.75, ["Mega"] = 565.55, ["Mega|Ride"] = 677.79, ["Mega|Fly|Ride"] = 706.54}},
    ["rbxassetid://71844856693163"] = {name = "Purrowl", prices = {["default"] = 3.42, ["Ride"] = 38.06, ["Fly|Ride"] = 236.18, ["Neon"] = 14.44, ["Neon|Fly"] = 130.93, ["Neon|Ride"] = 43.32, ["Neon|Fly|Ride"] = 105, ["Mega"] = 117.91, ["Mega|Ride"] = 161.26, ["Mega|Fly|Ride"] = 254.63}},
    ["rbxassetid://7195311687"] = {name = "Mythic Egg", prices = {["default"] = 23.63}},
    ["rbxassetid://102330087609546"] = {name = "Fire Mare", prices = {["default"] = 7.77, ["Ride"] = 37.96, ["Fly|Ride"] = 111.57, ["Neon"] = 68.25, ["Neon|Ride"] = 105.25, ["Neon|Fly|Ride"] = 463.32, ["Mega"] = 393.75, ["Mega|Ride"] = 370.68, ["Mega|Fly|Ride"] = 467.25}},
    ["rbxassetid://16659215347"] = {name = "Candyfloss Chick", prices = {["default"] = 682.5, ["Ride"] = 712.69, ["Fly|Ride"] = 732.27, ["Neon"] = 2988.9, ["Neon|Fly|Ride"] = 2362.5, ["Mega|Fly|Ride"] = 11011.04}},
    ["rbxassetid://9281950769"] = {name = "Sugar Glider", prices = {["default"] = 997.48, ["Fly"] = 900.38, ["Ride"] = 905.63, ["Fly|Ride"] = 1102.5, ["Neon|Fly|Ride"] = 3071.25, ["Mega|Fly|Ride"] = 21179.58}},
    ["rbxassetid://15485137935"] = {name = "Fleur De Ice", prices = {["default"] = 17.07, ["Fly"] = 117.95, ["Ride"] = 52.5, ["Fly|Ride"] = 127.1, ["Neon"] = 160.99, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 338.9, ["Mega|Fly|Ride"] = 740.28}},
    ["rbxassetid://6498256269"] = {name = "Ocean Egg", prices = {["default"] = 28.88}},
    ["rbxassetid://8704877940"] = {name = "Lavender Dragon", prices = {["default"] = 71.32, ["Fly"] = 106.32, ["Ride"] = 105.89, ["Fly|Ride"] = 117.93, ["Neon"] = 471.81, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 410.82, ["Mega|Fly|Ride"] = 1598.63}},
    ["rbxassetid://13685038182"] = {name = "Leviathan", prices = {["default"] = 63.68, ["Ride"] = 85.32, ["Fly|Ride"] = 150.41, ["Neon"] = 396.04, ["Neon|Ride"] = 520.17, ["Neon|Fly|Ride"] = 423.57, ["Mega"] = 2134.19, ["Mega|Fly|Ride"] = 2203.3}},
    ["rbxassetid://4797806358"] = {name = "Diamond Dragon", prices = {["default"] = 4.6, ["Fly"] = 32.78, ["Ride"] = 22.32, ["Fly|Ride"] = 48.57, ["Neon"] = 69.9, ["Neon|Fly"] = 314.95, ["Neon|Ride"] = 77.42, ["Neon|Fly|Ride"] = 105, ["Mega"] = 145.69, ["Mega|Ride"] = 282.78, ["Mega|Fly|Ride"] = 371.44}},
    ["rbxassetid://5862774327"] = {name = "Cerberus", prices = {["default"] = 77.35, ["Fly"] = 89.25, ["Ride"] = 77.31, ["Fly|Ride"] = 140.44, ["Neon"] = 423.57, ["Neon|Ride"] = 347.33, ["Neon|Fly|Ride"] = 300.55, ["Mega|Fly|Ride"] = 982.94}},
    ["rbxassetid://74012786571707"] = {name = "Three Blind Mice", prices = {["default"] = 3.29, ["Ride"] = 39.38, ["Fly|Ride"] = 262.5, ["Neon"] = 25.43, ["Neon|Fly"] = 268.98, ["Neon|Ride"] = 114.39, ["Neon|Fly|Ride"] = 141.9, ["Mega"] = 104.9, ["Mega|Fly"] = 989.15, ["Mega|Ride"] = 918.75, ["Mega|Fly|Ride"] = 361.33}},
    ["rbxassetid://15931348363"] = {name = "Criosphinx", prices = {["default"] = 15.9, ["Fly"] = 65.63, ["Ride"] = 26.25, ["Fly|Ride"] = 117.96, ["Neon"] = 141.9, ["Neon|Ride"] = 141.9, ["Neon|Fly|Ride"] = 186.38, ["Mega"] = 1050, ["Mega|Fly|Ride"] = 728.44}},
    ["rbxassetid://118278167134251"] = {name = "Influencer Gibbon", prices = {["default"] = 32.82, ["Ride"] = 46.52, ["Fly|Ride"] = 282.78, ["Neon"] = 198.02, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 706.3, ["Mega"] = 706.38, ["Mega|Ride"] = 1161.57, ["Mega|Fly|Ride"] = 703.29}},
    ["rbxassetid://17059982206"] = {name = "Dimorphodon", prices = {["default"] = 17.82, ["Fly"] = 44.84, ["Ride"] = 42, ["Fly|Ride"] = 77.44, ["Neon"] = 103.69, ["Neon|Fly"] = 423.57, ["Neon|Ride"] = 66.94, ["Neon|Fly|Ride"] = 249.38, ["Mega|Ride"] = 942.43, ["Mega|Fly|Ride"] = 930.9}},
    ["rbxassetid://119212313534429"] = {name = "Giant Panda", prices = {["default"] = 4462.5, ["Ride"] = 5906.25, ["Fly|Ride"] = 5118.75, ["Neon"] = 31062.92, ["Neon|Fly|Ride"] = 26119.96}},
    ["rbxassetid://6060998707"] = {name = "Frost Fury", prices = {["default"] = 211.95, ["Fly"] = 268.79, ["Ride"] = 248.77, ["Fly|Ride"] = 275.63, ["Neon|Fly|Ride"] = 571.62, ["Mega|Fly|Ride"] = 2533.13}},
    ["rbxassetid://88882779021298"] = {name = "Kitty Bat", prices = {["default"] = 38.15, ["Fly"] = 94.02, ["Ride"] = 57.75, ["Fly|Ride"] = 107.69, ["Neon"] = 75.87, ["Neon|Fly"] = 241.5, ["Neon|Ride"] = 97.12, ["Neon|Fly|Ride"] = 187.52, ["Mega"] = 285.75, ["Mega|Ride"] = 313.69, ["Mega|Fly|Ride"] = 437.07}},
    ["rbxassetid://16441372760"] = {name = "Diamond Mahi Mahi", prices = {["default"] = 3.29, ["Fly"] = 41.29, ["Ride"] = 24.39, ["Fly|Ride"] = 176.88, ["Neon"] = 22.78, ["Neon|Ride"] = 56.27, ["Mega"] = 160.13}},
    ["rbxassetid://3199974169"] = {name = "Royal Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://84714602656867"] = {name = "Slimingo", prices = {["default"] = 31.5, ["Fly"] = 99.56, ["Ride"] = 80.49, ["Fly|Ride"] = 144.01, ["Neon"] = 118.88, ["Neon|Fly"] = 264.74, ["Neon|Ride"] = 124.9, ["Neon|Fly|Ride"] = 276.81, ["Mega"] = 479.07, ["Mega|Ride"] = 448.02, ["Mega|Fly|Ride"] = 531.25}},
    ["rbxassetid://3409443710"] = {name = "Giraffe", prices = {["default"] = 18355.03, ["Ride"] = 11156.25, ["Fly|Ride"] = 11334.65, ["Neon|Fly|Ride"] = 23625, ["Mega|Fly|Ride"] = 91777.72}},
    ["rbxassetid://121215031043780"] = {name = "Velocirooster", prices = {["default"] = 141.54, ["Ride"] = 141.9, ["Fly|Ride"] = 266.58, ["Neon"] = 845.01, ["Neon|Ride"] = 734.89, ["Neon|Fly|Ride"] = 943.62}},
    ["rbxassetid://5067925034"] = {name = "Ninja Monkey", prices = {["default"] = 43.19, ["Fly"] = 436.41, ["Ride"] = 44.63, ["Fly|Ride"] = 105, ["Neon|Fly"] = 471.81, ["Neon|Ride"] = 288.75, ["Neon|Fly|Ride"] = 288.75, ["Mega|Fly|Ride"] = 1934.86}},
    ["rbxassetid://10618035564"] = {name = "Baku", prices = {["default"] = 10.44, ["Fly"] = 31.86, ["Ride"] = 24.94, ["Fly|Ride"] = 57.75, ["Neon"] = 65.63, ["Neon|Ride"] = 78.73, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 480.81, ["Mega|Ride"] = 492.19, ["Mega|Fly|Ride"] = 397.16}},
    ["rbxassetid://13665641282"] = {name = "Shark Puppy", prices = {["default"] = 367.5, ["Fly"] = 847.14, ["Ride"] = 414.3, ["Fly|Ride"] = 446.25, ["Neon"] = 1639.32, ["Neon|Ride"] = 1587.32, ["Neon|Fly|Ride"] = 1443.75, ["Mega"] = 5294.12, ["Mega|Fly|Ride"] = 4935}},
    ["rbxassetid://119447343321908"] = {name = "Tealwood Monster", prices = {["default"] = 7.87, ["Ride"] = 60.38, ["Fly|Ride"] = 158.55, ["Neon"] = 26.25, ["Neon|Ride"] = 95.82, ["Neon|Fly|Ride"] = 239.32, ["Mega"] = 118.13, ["Mega|Ride"] = 165.56, ["Mega|Fly|Ride"] = 282.78}},
    ["rbxassetid://85568505745239"] = {name = "Latte Kitsune", prices = {["default"] = 137.82, ["Fly"] = 211.79, ["Ride"] = 177.06, ["Fly|Ride"] = 239.27, ["Neon"] = 697.83, ["Neon|Ride"] = 446.25, ["Neon|Fly|Ride"] = 525, ["Mega|Ride"] = 3459.87, ["Mega|Fly|Ride"] = 1906.27}},
    ["rbxassetid://3181727727"] = {name = "Griffin", prices = {["default"] = 11.42, ["Fly"] = 15.9, ["Ride"] = 17.07, ["Fly|Ride"] = 27.56, ["Neon|Ride"] = 99.56, ["Neon|Fly|Ride"] = 53.82, ["Mega"] = 2541.69, ["Mega|Fly|Ride"] = 583.54}},
    ["rbxassetid://4822753215"] = {name = "Golden Egg", prices = {["default"] = 6.38}},
    ["rbxassetid://116463571924920"] = {name = "Prismatic Butterfly", prices = {["default"] = 59.07, ["Ride"] = 94.38, ["Fly|Ride"] = 525, ["Neon"] = 226.65, ["Neon|Fly"] = 1694.26, ["Neon|Ride"] = 360.04, ["Neon|Fly|Ride"] = 471.28, ["Mega"] = 1268.73, ["Mega|Ride"] = 1415.4, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://8596153183"] = {name = "Chameleon", prices = {["default"] = 19.07, ["Fly"] = 61.69, ["Ride"] = 39.38, ["Fly|Ride"] = 93.19, ["Neon"] = 97.13, ["Neon|Ride"] = 113.32, ["Neon|Fly|Ride"] = 210.74, ["Mega"] = 467.28, ["Mega|Ride"] = 501.48, ["Mega|Fly|Ride"] = 840}},
    ["rbxassetid://110774856122162"] = {name = "Gemstone Egg", prices = {["default"] = 15.49}},
    ["rbxassetid://14892649590"] = {name = "Dire Stag", prices = {["default"] = 22.29, ["Fly"] = 210, ["Ride"] = 57.75, ["Fly|Ride"] = 236.18, ["Neon"] = 164.07, ["Neon|Ride"] = 211.79, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 1130, ["Mega|Ride"] = 830.3, ["Mega|Fly|Ride"] = 735}},
    ["rbxassetid://106744890070136"] = {name = "Oakee Wizard", prices = {["default"] = 3.93, ["Ride"] = 32.84, ["Fly|Ride"] = 131.25, ["Neon"] = 19.66, ["Neon|Ride"] = 138.73, ["Neon|Fly|Ride"] = 282.75, ["Mega"] = 101.33, ["Mega|Fly|Ride"] = 424.6}},
    ["rbxassetid://9938967576"] = {name = "Chocolate Chow-Chow", prices = {["default"] = 15.74, ["Fly"] = 42, ["Ride"] = 36.59, ["Fly|Ride"] = 54.32, ["Neon"] = 141.9, ["Neon|Ride"] = 112.49, ["Neon|Fly|Ride"] = 131.25, ["Mega|Fly|Ride"] = 804.88}},
    ["rbxassetid://9174893483"] = {name = "Mechapup", prices = {["default"] = 392.43, ["Fly"] = 437.75, ["Ride"] = 328.06, ["Fly|Ride"] = 409.89, ["Neon|Fly"] = 1375.54, ["Neon|Fly|Ride"] = 1934.63, ["Mega|Fly|Ride"] = 8895.87}},
    ["rbxassetid://15292843858"] = {name = "Mecha Meow", prices = {["default"] = 42, ["Ride"] = 69.91, ["Fly|Ride"] = 131.25, ["Neon"] = 156.73, ["Neon|Ride"] = 205.58, ["Neon|Fly|Ride"] = 224.51, ["Mega"] = 704.96, ["Mega|Ride"] = 681.45, ["Mega|Fly|Ride"] = 689.07}},
    ["rbxassetid://15931200262"] = {name = "Cactus Friend", prices = {["default"] = 61.69, ["Fly"] = 84.56, ["Ride"] = 79.44, ["Fly|Ride"] = 118.13, ["Neon"] = 203.1, ["Neon|Ride"] = 203.36, ["Neon|Fly|Ride"] = 313.69, ["Mega|Ride"] = 1050, ["Mega|Fly|Ride"] = 847.24}},
    ["rbxassetid://127221459636244"] = {name = "Strawberry Shortcake Ducky", prices = {["default"] = 24.94, ["Fly"] = 68.25, ["Ride"] = 49.79, ["Fly|Ride"] = 131.25, ["Neon"] = 87.86, ["Neon|Ride"] = 156.73, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 354.38, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 521.07}},
    ["rbxassetid://4470748644"] = {name = "Frost Dragon", prices = {["default"] = 11287.5, ["Fly"] = 9843.75, ["Ride"] = 10589.02, ["Fly|Ride"] = 8334.38, ["Neon|Fly|Ride"] = 19060.13, ["Mega|Fly|Ride"] = 39372.9}},
    ["rbxassetid://15365667976"] = {name = "Chocolate Chip Bat Dragon", prices = {["default"] = 1869, ["Ride"] = 1771.88, ["Fly|Ride"] = 1798.13, ["Neon|Ride"] = 5661.67, ["Neon|Fly|Ride"] = 4331.25, ["Mega|Fly|Ride"] = 22312.5}},
    ["rbxassetid://16898343164"] = {name = "Pirate Ghost Capuchin Monkey", prices = {["default"] = 378, ["Ride"] = 448.17, ["Fly|Ride"] = 393.75, ["Neon"] = 2117.82, ["Neon|Ride"] = 1312.5, ["Neon|Fly|Ride"] = 1429.54, ["Mega"] = 16944.51, ["Mega|Fly|Ride"] = 7235.04}},
    ["rbxassetid://6404812772"] = {name = "Golden Ladybug", prices = {["default"] = 12.79, ["Fly"] = 30.82, ["Ride"] = 23.63, ["Fly|Ride"] = 49.88, ["Neon"] = 78.75, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 141.9, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://95029455226760"] = {name = "Easter Bunny", prices = {["default"] = 6.38, ["Ride"] = 57.21, ["Fly|Ride"] = 152.24, ["Neon"] = 24.94, ["Neon|Ride"] = 52.5, ["Mega"] = 133.72, ["Mega|Ride"] = 174.57}},
    ["rbxassetid://5307473113"] = {name = "Kitsune", prices = {["default"] = 38.07, ["Fly"] = 48.72, ["Ride"] = 41.28, ["Fly|Ride"] = 87.94, ["Neon|Ride"] = 153.67, ["Neon|Fly|Ride"] = 157.5, ["Mega|Fly|Ride"] = 537.25}},
    ["rbxassetid://4797806780"] = {name = "Golden Dragon", prices = {["default"] = 3.68, ["Fly"] = 32.82, ["Ride"] = 18.38, ["Fly|Ride"] = 29.93, ["Neon"] = 31.49, ["Neon|Fly"] = 282.75, ["Neon|Ride"] = 55.09, ["Neon|Fly|Ride"] = 99.42, ["Mega"] = 360.94, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 282.18}},
    ["rbxassetid://135649428081307"] = {name = "Sakura Spirit", prices = {["default"] = 405.7, ["Fly"] = 314.99, ["Ride"] = 328.13, ["Fly|Ride"] = 383.21, ["Neon|Ride"] = 1340.59, ["Neon|Fly|Ride"] = 1181.25, ["Mega|Fly|Ride"] = 5640.42}},
    ["rbxassetid://11109110190"] = {name = "White Amazon", prices = {["default"] = 22.42, ["Fly"] = 45.77, ["Ride"] = 35.4, ["Fly|Ride"] = 70.97, ["Neon"] = 127.61, ["Neon|Fly"] = 282.75, ["Neon|Ride"] = 156.96, ["Neon|Fly|Ride"] = 178.49, ["Mega|Ride"] = 582.75, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://9475753542"] = {name = "Golden Albatross", prices = {["default"] = 11.82, ["Fly"] = 28.29, ["Ride"] = 20.97, ["Fly|Ride"] = 39.38, ["Neon"] = 141.9, ["Neon|Fly"] = 127.09, ["Neon|Ride"] = 110.9, ["Neon|Fly|Ride"] = 111.57, ["Mega"] = 529.53, ["Mega|Ride"] = 583.54, ["Mega|Fly|Ride"] = 629.87}},
    ["rbxassetid://12778628831"] = {name = "Emperor Gorilla", prices = {["default"] = 564.77, ["Fly"] = 787.5, ["Ride"] = 459.38, ["Fly|Ride"] = 688.38, ["Mega|Fly|Ride"] = 11153.72}},
    ["rbxassetid://13672542902"] = {name = "Hot Doggo", prices = {["default"] = 1101.02, ["Ride"] = 1170.75, ["Fly|Ride"] = 1181.25, ["Neon"] = 4955.68, ["Neon|Ride"] = 4801.08, ["Neon|Fly|Ride"] = 3570, ["Mega|Fly|Ride"] = 18498.1}},
    ["rbxassetid://8070897995"] = {name = "Ice Golem", prices = {["default"] = 103.69, ["Fly"] = 110.15, ["Ride"] = 93.19, ["Fly|Ride"] = 113.33, ["Neon"] = 504.06, ["Neon|Ride"] = 414.75, ["Neon|Fly|Ride"] = 525, ["Mega|Fly|Ride"] = 1640.63}},
    ["rbxassetid://128225904426926"] = {name = "Rose Dragon", prices = {["default"] = 178.71, ["Fly"] = 190.32, ["Ride"] = 181.32, ["Fly|Ride"] = 224.44, ["Neon"] = 706.3, ["Neon|Ride"] = 524.18, ["Neon|Fly|Ride"] = 628.69, ["Mega|Ride"] = 2965.3, ["Mega|Fly|Ride"] = 2625}},
    ["rbxassetid://13883274830"] = {name = "Pirate Hermit Crab", prices = {["default"] = 24.91, ["Ride"] = 42, ["Neon"] = 183.75, ["Neon|Ride"] = 272.99, ["Neon|Fly|Ride"] = 325.1, ["Mega|Ride"] = 943.61, ["Mega|Fly|Ride"] = 1056.92}},
    ["rbxassetid://95213400890066"] = {name = "Diamond Hummingbird", prices = {["default"] = 141.9, ["Ride"] = 211.82, ["Fly|Ride"] = 597.19, ["Mega|Fly|Ride"] = 2673.93}},
    ["rbxassetid://10453528102"] = {name = "Diamond Butterfly", prices = {["default"] = 2117.82, ["Ride"] = 2302.08, ["Fly|Ride"] = 2189.02, ["Mega|Fly|Ride"] = 48715.43}},
    ["rbxassetid://12778628650"] = {name = "Astronaut Gorilla", prices = {["default"] = 57.14, ["Ride"] = 48.57, ["Fly|Ride"] = 156.76, ["Neon"] = 291.24, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 353.93, ["Mega"] = 2111.72, ["Mega|Ride"] = 2329.88, ["Mega|Fly|Ride"] = 2541.69}},
    ["rbxassetid://4708551306"] = {name = "Kangaroo", prices = {["default"] = 573.57, ["Fly"] = 675.94, ["Ride"] = 598.55, ["Fly|Ride"] = 616.88, ["Neon|Ride"] = 1266.57, ["Neon|Fly|Ride"] = 1165.49, ["Mega|Fly|Ride"] = 2853.38}},
    ["rbxassetid://9542440966"] = {name = "Capricorn", prices = {["default"] = 42.39, ["Fly"] = 60.38, ["Ride"] = 57.75, ["Fly|Ride"] = 104.62, ["Neon|Ride"] = 513.45, ["Neon|Fly|Ride"] = 314.94, ["Mega|Fly|Ride"] = 989.73}},
    ["rbxassetid://9678195673"] = {name = "Ancient Dragon", prices = {["default"] = 2.63, ["Fly"] = 22.32, ["Ride"] = 18.88, ["Fly|Ride"] = 38.27, ["Neon"] = 27.56, ["Neon|Fly"] = 62.32, ["Neon|Ride"] = 42.4, ["Neon|Fly|Ride"] = 85.32, ["Mega"] = 121.82, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 215.25}},
    ["rbxassetid://132388343771587"] = {name = "Kelp Captain", prices = {["default"] = 47.18, ["Ride"] = 52.5, ["Fly|Ride"] = 79.04, ["Neon"] = 1412.59, ["Neon|Ride"] = 777.26, ["Neon|Fly|Ride"] = 282.75, ["Mega|Ride"] = 1412.76, ["Mega|Fly|Ride"] = 943.61}},
    ["rbxassetid://15148532648"] = {name = "Werewolf", prices = {["default"] = 562.83, ["Fly"] = 899.07, ["Ride"] = 577.5, ["Fly|Ride"] = 638.37, ["Neon"] = 2007.7, ["Neon|Ride"] = 1771.88, ["Neon|Fly|Ride"] = 1644.72, ["Mega|Fly|Ride"] = 5250}},
    ["rbxassetid://86323568215409"] = {name = "Tortoiseshell Guinea Pig", prices = {["default"] = 573.71, ["Ride"] = 590.94, ["Fly|Ride"] = 525, ["Neon"] = 35293.25, ["Neon|Ride"] = 4068.75, ["Neon|Fly|Ride"] = 2625, ["Mega|Fly|Ride"] = 9435.97}},
    ["rbxassetid://5973019152"] = {name = "Robo Dog", prices = {["default"] = 23, ["Fly"] = 42.38, ["Ride"] = 23.63, ["Fly|Ride"] = 49.3, ["Neon"] = 211.79, ["Neon|Ride"] = 99.56, ["Neon|Fly|Ride"] = 118.13, ["Mega|Ride"] = 422.58, ["Mega|Fly|Ride"] = 422.58}},
    ["rbxassetid://7734928470"] = {name = "Halloween Golden Mummy Cat", prices = {["default"] = 10.4, ["Ride"] = 20.9, ["Fly|Ride"] = 65.63, ["Neon"] = 141.96, ["Neon|Ride"] = 56.59, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 1692.34, ["Mega|Ride"] = 439.51, ["Mega|Fly|Ride"] = 1207.5}},
    ["rbxassetid://137429532189183"] = {name = "Fire Stallion", prices = {["default"] = 4.24, ["Ride"] = 40.25, ["Fly|Ride"] = 99.57, ["Neon"] = 17.07, ["Neon|Fly"] = 113.3, ["Neon|Ride"] = 45.93, ["Neon|Fly|Ride"] = 141.9, ["Mega"] = 139.2, ["Mega|Fly"] = 405.77, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 334.69}},
    ["rbxassetid://7215324578"] = {name = "Axolotl", prices = {["default"] = 36.93, ["Fly"] = 45.93, ["Ride"] = 52.49, ["Fly|Ride"] = 100.96, ["Neon|Ride"] = 142.01, ["Neon|Fly|Ride"] = 225.9, ["Mega|Fly|Ride"] = 777.05}},
    ["rbxassetid://111805565268081"] = {name = "Black Widow", prices = {["default"] = 39.38, ["Ride"] = 91.88, ["Fly|Ride"] = 449.61, ["Neon"] = 336.71, ["Neon|Ride"] = 346.27, ["Neon|Fly|Ride"] = 695.63, ["Mega"] = 1268.73, ["Mega|Ride"] = 1553.62, ["Mega|Fly|Ride"] = 1379.93}},
    ["rbxassetid://103653773461193"] = {name = "Sunglider", prices = {["default"] = 18.27, ["Fly"] = 57.14, ["Ride"] = 32.82, ["Fly|Ride"] = 73.05, ["Neon"] = 120.73, ["Neon|Ride"] = 93.14, ["Neon|Fly|Ride"] = 158.07, ["Mega|Ride"] = 406.88, ["Mega|Fly|Ride"] = 446.25}},
    ["rbxassetid://6498256069"] = {name = "Shark", prices = {["default"] = 30.19, ["Fly"] = 99.56, ["Ride"] = 41.91, ["Fly|Ride"] = 65.63, ["Neon"] = 351.58, ["Neon|Ride"] = 211.79, ["Neon|Fly|Ride"] = 224.2, ["Mega"] = 2100, ["Mega|Ride"] = 1226.69, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://8663440945"] = {name = "Lunar Gold Tiger", prices = {["default"] = 3.14, ["Fly"] = 16.96, ["Ride"] = 16.96, ["Fly|Ride"] = 39.37, ["Neon"] = 31.49, ["Neon|Ride"] = 42.37, ["Neon|Fly|Ride"] = 94.37, ["Mega"] = 177.19, ["Mega|Ride"] = 211.82, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://94185217299816"] = {name = "Dracula Parrot", prices = {["default"] = 3.84, ["Fly"] = 70.96, ["Ride"] = 28.62, ["Fly|Ride"] = 67.24, ["Neon"] = 27.57, ["Neon|Fly"] = 158.07, ["Neon|Ride"] = 42.37, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 201.23, ["Mega|Fly"] = 480.81, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://4621220431"] = {name = "Golden Rat", prices = {["default"] = 47.19, ["Fly"] = 60.38, ["Ride"] = 65.63, ["Fly|Ride"] = 91.88, ["Neon"] = 421.66, ["Neon|Ride"] = 279.34, ["Neon|Fly|Ride"] = 221.53, ["Mega|Fly|Ride"] = 918.64}},
    ["rbxassetid://11506045996"] = {name = "Strawberry Shortcake Bat Dragon", prices = {["default"] = 1890, ["Fly"] = 2313.86, ["Ride"] = 1758.75, ["Fly|Ride"] = 1837.5, ["Neon|Fly|Ride"] = 3916.5, ["Mega|Fly|Ride"] = 14962.5}},
    ["rbxassetid://11758583912"] = {name = "Winged Tiger", prices = {["default"] = 748.65, ["Fly"] = 531.57, ["Ride"] = 535.5, ["Fly|Ride"] = 551.52, ["Neon"] = 3145.76, ["Neon|Ride"] = 3106.84, ["Neon|Fly|Ride"] = 2362.5, ["Mega|Fly|Ride"] = 8788.9}},
    ["rbxassetid://101160794933271"] = {name = "Matcha Cat", prices = {["default"] = 240.01, ["Fly"] = 338.87, ["Ride"] = 286.35, ["Fly|Ride"] = 384.57, ["Neon"] = 1412.59, ["Neon|Ride"] = 1565.07, ["Neon|Fly|Ride"] = 1553.43, ["Mega|Fly|Ride"] = 6284.3}},
    ["rbxassetid://13892790514"] = {name = "Urban Egg", prices = {["default"] = 38.63}},
    ["rbxassetid://13104109574"] = {name = "Spinosaurus", prices = {["default"] = 32.82, ["Fly"] = 65.63, ["Ride"] = 65.67, ["Fly|Ride"] = 95.82, ["Neon|Ride"] = 196.87, ["Neon|Fly|Ride"] = 317.69, ["Mega"] = 1163.9, ["Mega|Ride"] = 1553.62, ["Mega|Fly|Ride"] = 1254.75}},
    ["rbxassetid://4115248712"] = {name = "Shadow Dragon", prices = {["default"] = 33884.9, ["Fly"] = 23625, ["Ride"] = 34781.25, ["Fly|Ride"] = 16406.15, ["Neon|Fly|Ride"] = 38062.5, ["Mega|Fly|Ride"] = 89250}},
    ["rbxassetid://71457697470071"] = {name = "Arctic Dusk Dragon", prices = {["default"] = 301.87, ["Fly"] = 367.05, ["Ride"] = 314.9, ["Fly|Ride"] = 393.75, ["Neon"] = 989.04, ["Neon|Ride"] = 826.88, ["Neon|Fly|Ride"] = 840, ["Mega"] = 5307.74, ["Mega|Ride"] = 6605.18, ["Mega|Fly|Ride"] = 2625}},
    ["rbxassetid://8566683457"] = {name = "Giant Gold Scarab", prices = {["default"] = 226.79, ["Fly"] = 525, ["Ride"] = 188.5, ["Fly|Ride"] = 154.88, ["Neon|Fly|Ride"] = 1058.92, ["Mega|Fly|Ride"] = 4095.28}},
    ["rbxassetid://16116063171"] = {name = "Rainbow Dragon", prices = {["default"] = 99.56, ["Ride"] = 132.46, ["Fly|Ride"] = 183.75, ["Neon|Ride"] = 777.26, ["Neon|Fly|Ride"] = 420, ["Mega"] = 14121.13, ["Mega|Fly|Ride"] = 1587.5}},
    ["rbxassetid://9938967130"] = {name = "Black Chow-Chow", prices = {["default"] = 18.38, ["Fly"] = 94.5, ["Ride"] = 32.82, ["Fly|Ride"] = 98.44, ["Neon"] = 105.92, ["Neon|Ride"] = 135.19, ["Neon|Fly|Ride"] = 278.51, ["Mega"] = 1968.75, ["Mega|Fly|Ride"] = 648.15}},
    ["rbxassetid://116467943923352"] = {name = "Haetae", prices = {["default"] = 3937.5, ["Ride"] = 4515, ["Fly|Ride"] = 4583.25, ["Neon|Fly|Ride"] = 28237.77, ["Mega|Fly|Ride"] = 70602.41}},
    ["rbxassetid://6531232495"] = {name = "Peacock", prices = {["default"] = 34.13, ["Fly"] = 45.94, ["Ride"] = 34.13, ["Fly|Ride"] = 60.25, ["Neon"] = 333.94, ["Neon|Ride"] = 141.9, ["Neon|Fly|Ride"] = 157.5, ["Mega|Fly|Ride"] = 633.29}},
    ["rbxassetid://12557346746"] = {name = "Naga Dragon", prices = {["default"] = 44.62, ["Ride"] = 49.81, ["Fly|Ride"] = 104.35, ["Neon"] = 235.92, ["Neon|Fly"] = 1412.59, ["Neon|Ride"] = 282.75, ["Neon|Fly|Ride"] = 208.69, ["Mega|Fly|Ride"] = 953.14}},
    ["rbxassetid://127697654557674"] = {name = "Candicorn", prices = {["default"] = 564.38, ["Fly"] = 747.71, ["Ride"] = 619.49, ["Fly|Ride"] = 672, ["Neon"] = 1638, ["Neon|Ride"] = 1443.75, ["Neon|Fly|Ride"] = 1483.13, ["Mega"] = 4462.5, ["Mega|Fly|Ride"] = 4265.63}},
    ["rbxassetid://4281674580"] = {name = "King Bee", prices = {["default"] = 17.71, ["Fly"] = 27.88, ["Ride"] = 22.32, ["Fly|Ride"] = 41.85, ["Neon"] = 98.44, ["Neon|Ride"] = 107.61, ["Neon|Fly|Ride"] = 126, ["Mega"] = 777.35, ["Mega|Ride"] = 565.55, ["Mega|Fly|Ride"] = 498.75}},
    ["rbxassetid://17822543288"] = {name = "Blue Betta Fish", prices = {["default"] = 16.26, ["Ride"] = 65.63, ["Fly|Ride"] = 471.8, ["Neon"] = 45.94, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 210.74}},
    ["rbxassetid://102300026415493"] = {name = "Moose Calf", prices = {["default"] = 102.38, ["Ride"] = 129.94, ["Fly|Ride"] = 159.93, ["Neon"] = 750.18, ["Neon|Ride"] = 635.36, ["Neon|Fly|Ride"] = 740.28, ["Mega|Fly|Ride"] = 2193.18}},
    ["rbxassetid://78419574214060"] = {name = "Christmas Spirit", prices = {["default"] = 22.32, ["Fly"] = 110.15, ["Ride"] = 97.13, ["Fly|Ride"] = 155.71, ["Neon"] = 95.37, ["Neon|Ride"] = 124.69, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 248.89, ["Mega|Fly"] = 708.75, ["Mega|Ride"] = 342.22, ["Mega|Fly|Ride"] = 396.3}},
    ["rbxassetid://130642623661179"] = {name = "Cryptid", prices = {["default"] = 3189.38, ["Ride"] = 3837.75, ["Fly|Ride"] = 3346.88, ["Neon"] = 13125, ["Neon|Ride"] = 18001.36, ["Neon|Fly|Ride"] = 8491.88, ["Mega"] = 63541.85, ["Mega|Fly|Ride"] = 34468.88}},
    ["rbxassetid://101130894252942"] = {name = "Peach Owl", prices = {["default"] = 36.66, ["Fly"] = 115.5, ["Ride"] = 63, ["Fly|Ride"] = 105.92, ["Neon"] = 168, ["Neon|Ride"] = 198.02, ["Neon|Fly|Ride"] = 366.43, ["Mega|Fly|Ride"] = 892.5}},
    ["rbxassetid://4440866649"] = {name = "Owl", prices = {["default"] = 5906.25, ["Ride"] = 8491.2, ["Fly|Ride"] = 5843.64, ["Neon|Fly|Ride"] = 17062.5, ["Mega|Fly|Ride"] = 60718.48}},
    ["rbxassetid://6836687169"] = {name = "Golden Griffin", prices = {["default"] = 2.56, ["Fly"] = 21, ["Ride"] = 20.14, ["Fly|Ride"] = 42.38, ["Neon"] = 19.07, ["Neon|Fly"] = 91.8, ["Neon|Ride"] = 36.04, ["Neon|Fly|Ride"] = 76.13, ["Mega"] = 203.44, ["Mega|Ride"] = 211.82, ["Mega|Fly|Ride"] = 312.42}},
    ["rbxassetid://76198828333546"] = {name = "Hippogriff", prices = {["default"] = 19.69, ["Fly"] = 36.75, ["Ride"] = 33.38, ["Fly|Ride"] = 50.74, ["Neon"] = 202.27, ["Neon|Ride"] = 559.37, ["Neon|Fly|Ride"] = 198.02, ["Mega|Ride"] = 1477.23, ["Mega|Fly|Ride"] = 927.94}},
    ["rbxassetid://112567270488274"] = {name = "Crystal Egg", prices = {["default"] = 2.63}},
    ["rbxassetid://10695038557"] = {name = "Maneki-Neko", prices = {["default"] = 10.5, ["Ride"] = 32.82, ["Fly|Ride"] = 127.1, ["Neon"] = 158.07, ["Neon|Ride"] = 120.73, ["Neon|Fly|Ride"] = 91.08, ["Mega"] = 1050, ["Mega|Ride"] = 987.04, ["Mega|Fly|Ride"] = 889.6}},
    ["rbxassetid://16911441596"] = {name = "Royal Capuchin Monkey", prices = {["default"] = 42.4, ["Fly"] = 99.56, ["Ride"] = 45.94, ["Fly|Ride"] = 141.92, ["Neon"] = 182.43, ["Neon|Ride"] = 154.09, ["Neon|Fly|Ride"] = 205.41, ["Mega"] = 840, ["Mega|Ride"] = 943.61, ["Mega|Fly|Ride"] = 931.88}},
    ["rbxassetid://6963387165"] = {name = "Cobra", prices = {["default"] = 15.94, ["Fly"] = 23.55, ["Ride"] = 21, ["Fly|Ride"] = 44.49, ["Neon"] = 141.61, ["Neon|Ride"] = 158.07, ["Neon|Fly|Ride"] = 164.07, ["Mega"] = 1131.06, ["Mega|Ride"] = 588.58, ["Mega|Fly|Ride"] = 678.23}},
    ["rbxassetid://3409444171"] = {name = "Safari Egg", prices = {["default"] = 8380.17}},
    ["rbxassetid://3743740864"] = {name = "Jungle Egg", prices = {["default"] = 2716.11}},
    ["rbxassetid://10321884333"] = {name = "Japan Egg", prices = {["default"] = 26.17}},
    ["rbxassetid://11109117895"] = {name = "Diamond Amazon", prices = {["default"] = 70.96, ["Fly"] = 174.57, ["Ride"] = 189, ["Fly|Ride"] = 353.74}},
    ["rbxassetid://102144672439627"] = {name = "Berry Cool Cube", prices = {["default"] = 40.69, ["Ride"] = 43.32, ["Fly|Ride"] = 105, ["Neon"] = 234.7, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 288.75, ["Mega|Ride"] = 943.61, ["Mega|Fly|Ride"] = 853.13}},
    ["rbxassetid://17183502626"] = {name = "Garden Egg", prices = {["default"] = 10.48}},
    ["rbxassetid://16722909609"] = {name = "Striped Eggy", prices = {["default"] = 9.19, ["Neon|Ride"] = 84.73, ["Mega|Fly|Ride"] = 465.94}},
    ["rbxassetid://4440866155"] = {name = "Farm Egg", prices = {["default"] = 2570.95}},
    ["rbxassetid://88361277330582"] = {name = "Naughty Mistletroll", prices = {["default"] = 239.32, ["Ride"] = 229.69, ["Fly|Ride"] = 10498.95, ["Neon"] = 918.75, ["Neon|Ride"] = 847.14, ["Mega|Fly|Ride"] = 2517.05}},
    ["rbxassetid://12778919221"] = {name = "Yule Log Dog", prices = {["default"] = 131.14, ["Ride"] = 205.25, ["Fly|Ride"] = 314.94, ["Neon|Ride"] = 787.5, ["Neon|Fly|Ride"] = 953.03, ["Mega"] = 3441.86, ["Mega|Fly|Ride"] = 3388.92}},
    ["rbxassetid://13104112588"] = {name = "Owlbear", prices = {["default"] = 141.9, ["Ride"] = 196.88, ["Fly|Ride"] = 206.07, ["Neon"] = 799.32, ["Neon|Ride"] = 840, ["Neon|Fly|Ride"] = 852.97, ["Mega"] = 4659.75, ["Mega|Fly|Ride"] = 2937.38}},
    ["rbxassetid://11192035130"] = {name = "Undead Jousting Horse", prices = {["default"] = 1181.23, ["Fly"] = 2541.38, ["Ride"] = 1115.63, ["Fly|Ride"] = 1181.25, ["Neon"] = 5365.47, ["Neon|Ride"] = 5351.71, ["Neon|Fly|Ride"] = 5220.41, ["Mega|Fly|Ride"] = 16944.51}},
    ["rbxassetid://106575933009346"] = {name = "Fairytale Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://96044273915258"] = {name = "Endangered Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://129993159377616"] = {name = "Peahen", prices = {["default"] = 18.98, ["Fly"] = 102.62, ["Ride"] = 39.38, ["Fly|Ride"] = 78.39, ["Neon"] = 141.9, ["Neon|Ride"] = 297.25, ["Neon|Fly|Ride"] = 437.07, ["Mega"] = 846.18, ["Mega|Fly|Ride"] = 915.02}},
    ["rbxassetid://12732812236"] = {name = "Tio De Nadal", prices = {["default"] = 654.94, ["Fly"] = 2100, ["Ride"] = 688.51, ["Fly|Ride"] = 847.24}},
    ["rbxassetid://13936755787"] = {name = "Wrapped Doll", prices = {["default"] = 98.44}},
    ["rbxassetid://136441478335419"] = {name = "Emberlight", prices = {["default"] = 14.44, ["Fly"] = 393.75, ["Ride"] = 48.57, ["Fly|Ride"] = 98.44, ["Neon"] = 89.25, ["Neon|Ride"] = 104.85, ["Neon|Fly|Ride"] = 169.32, ["Mega"] = 363.57, ["Mega|Ride"] = 338.63, ["Mega|Fly|Ride"] = 634.37}},
    ["rbxassetid://17120184484"] = {name = "Rosy Maple Moth", prices = {["default"] = 11.65, ["Fly"] = 32.82, ["Ride"] = 32.84, ["Fly|Ride"] = 94.5, ["Neon"] = 61.38, ["Neon|Ride"] = 83.61, ["Neon|Fly|Ride"] = 167.82, ["Mega"] = 423.63, ["Mega|Ride"] = 418.34, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://15932251755"] = {name = "Royal Desert Egg", prices = {["default"] = 99.56}},
    ["rbxassetid://8143039289"] = {name = "Golden Walrus", prices = {["default"] = 23.63, ["Ride"] = 36.01, ["Fly|Ride"] = 65.54, ["Neon"] = 177.19, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 550.83, ["Mega"] = 820.76, ["Mega|Fly|Ride"] = 804.88}},
    ["rbxassetid://12187391973"] = {name = "Firefly", prices = {["default"] = 28.61, ["Fly"] = 48.72, ["Ride"] = 46.6, ["Fly|Ride"] = 51.82, ["Neon"] = 239.32, ["Neon|Ride"] = 141.9, ["Neon|Fly|Ride"] = 196.88, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://3743647944"] = {name = "Parrot", prices = {["default"] = 5239.49, ["Fly"] = 11295.33, ["Ride"] = 6562.5, ["Fly|Ride"] = 4725, ["Neon|Fly|Ride"] = 10077.38, ["Mega|Fly|Ride"] = 37798.69}},
    ["rbxassetid://128454622445076"] = {name = "Dimension Drifter", prices = {["default"] = 11.69, ["Fly"] = 80.07, ["Ride"] = 32.82, ["Fly|Ride"] = 57.75, ["Neon"] = 79.48, ["Neon|Ride"] = 116.79, ["Neon|Fly|Ride"] = 211.79, ["Mega"] = 528.43, ["Mega|Ride"] = 471.87, ["Mega|Fly|Ride"] = 396.33}},
    ["rbxassetid://15931761708"] = {name = "Desert Egg", prices = {["default"] = 26.25}},
    ["rbxassetid://17747001377"] = {name = "Majestic Pony", prices = {["default"] = 112.88, ["Fly"] = 374.87, ["Ride"] = 196.88, ["Fly|Ride"] = 288.75, ["Neon"] = 418.69, ["Neon|Ride"] = 481.69, ["Neon|Fly|Ride"] = 636.95, ["Mega|Ride"] = 4236.14, ["Mega|Fly|Ride"] = 1855.44}},
    ["rbxassetid://94487786469241"] = {name = "Vanilla Penguin", prices = {["default"] = 89.25, ["Ride"] = 105.95, ["Fly|Ride"] = 179.29, ["Neon"] = 314.95, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 511.88, ["Mega|Ride"] = 1588.56, ["Mega|Fly|Ride"] = 1673.27}},
    ["rbxassetid://6498256211"] = {name = "Octopus", prices = {["default"] = 21, ["Fly"] = 70.85, ["Ride"] = 32.82, ["Fly|Ride"] = 68.31, ["Neon"] = 137.68, ["Neon|Ride"] = 104.85, ["Neon|Fly|Ride"] = 158.07, ["Mega|Fly|Ride"] = 656.23}},
    ["rbxassetid://110654583245787"] = {name = "Sea Turtle", prices = {["default"] = 4.99, ["Fly"] = 49.76, ["Ride"] = 33.71, ["Fly|Ride"] = 78.75, ["Neon"] = 20.43, ["Neon|Fly"] = 184.26, ["Neon|Ride"] = 51.19, ["Neon|Fly|Ride"] = 164.07, ["Mega"] = 117.39, ["Mega|Fly"] = 7034.11, ["Mega|Ride"] = 158.06, ["Mega|Fly|Ride"] = 244.13}},
    ["rbxassetid://8596147681"] = {name = "Squid", prices = {["default"] = 14.44, ["Fly"] = 52.5, ["Ride"] = 32.84, ["Fly|Ride"] = 72.19, ["Neon"] = 98.44, ["Neon|Ride"] = 112.88, ["Neon|Fly|Ride"] = 211.79, ["Mega|Ride"] = 494.58, ["Mega|Fly|Ride"] = 524.24}},
    ["rbxassetid://9226723356"] = {name = "Winged Horse", prices = {["default"] = 19.59, ["Fly"] = 27.57, ["Ride"] = 31.79, ["Fly|Ride"] = 49.81, ["Neon"] = 208.71, ["Neon|Ride"] = 141.75, ["Neon|Fly|Ride"] = 125.99, ["Mega|Fly|Ride"] = 658.34}},
    ["rbxassetid://4733386633"] = {name = "Aussie Egg", prices = {["default"] = 221.82}},
    ["rbxassetid://121951206021245"] = {name = "Kiwi Kiwi", prices = {["default"] = 20.14, ["Ride"] = 110.88, ["Neon"] = 177.19, ["Mega"] = 1176.59, ["Mega|Ride"] = 918.75, ["Mega|Fly|Ride"] = 1480.54}},
    ["rbxassetid://9602676771"] = {name = "Diamond Albatross", prices = {["default"] = 196.88, ["Ride"] = 443.63, ["Fly|Ride"] = 363.26, ["Neon|Ride"] = 820.32}},
    ["rbxassetid://79965389436178"] = {name = "Sushi Penguin", prices = {["default"] = 47.25, ["Fly"] = 211.99, ["Ride"] = 97.67, ["Fly|Ride"] = 254.63, ["Neon"] = 311.07, ["Neon|Ride"] = 366.99, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 1183.88, ["Mega|Ride"] = 1038.93, ["Mega|Fly|Ride"] = 1008.51}},
    ["rbxassetid://126930507653265"] = {name = "Grim Dragon", prices = {["default"] = 706.13, ["Fly"] = 780.94, ["Ride"] = 721.88, ["Fly|Ride"] = 748.23, ["Neon|Ride"] = 2231.25, ["Neon|Fly|Ride"] = 2221.98, ["Mega|Ride"] = 7942.74, ["Mega|Fly|Ride"] = 6561.19}},
    ["rbxassetid://87328715505907"] = {name = "Silverback Gorilla", prices = {["default"] = 262.5, ["Ride"] = 330.75, ["Fly|Ride"] = 423.63, ["Neon"] = 1553.43, ["Neon|Ride"] = 1163.75, ["Neon|Fly|Ride"] = 1269.63, ["Mega"] = 4235.07, ["Mega|Fly|Ride"] = 3675}},
    ["rbxassetid://12733311267"] = {name = "Fool Egg", prices = {["default"] = 90.57}},
    ["rbxassetid://139472202653768"] = {name = "Admin Abuse Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://8938702589"] = {name = "Hawk", prices = {["default"] = 15.74, ["Fly"] = 31.48, ["Ride"] = 24.81, ["Fly|Ride"] = 57.21, ["Neon"] = 77.95, ["Neon|Ride"] = 97.5, ["Neon|Fly|Ride"] = 122.07, ["Mega"] = 282.78, ["Mega|Ride"] = 423.63, ["Mega|Fly|Ride"] = 452.82}},
    ["rbxassetid://8938703243"] = {name = "Fallow Deer", prices = {["default"] = 286.2, ["Fly"] = 458.67, ["Ride"] = 341.25, ["Fly|Ride"] = 420, ["Neon"] = 2807.17, ["Neon|Ride"] = 892.5, ["Neon|Fly|Ride"] = 994.25, ["Mega|Fly|Ride"] = 3375.15}},
    ["rbxassetid://4822753124"] = {name = "Diamond Egg", prices = {["default"] = 17.07}},
    ["rbxassetid://114823420678686"] = {name = "Dragonfruit Fox", prices = {["default"] = 105, ["Fly"] = 590.63, ["Ride"] = 141.94, ["Fly|Ride"] = 249.38, ["Neon"] = 459.38, ["Neon|Fly"] = 1412.59, ["Neon|Ride"] = 565.47, ["Neon|Fly|Ride"] = 643.13, ["Mega"] = 2823.38, ["Mega|Fly|Ride"] = 1771.88}},
    ["rbxassetid://102844319137806"] = {name = "Pineapple Owl", prices = {["default"] = 131.25, ["Ride"] = 168, ["Fly|Ride"] = 209.7, ["Neon|Ride"] = 889.49, ["Neon|Fly|Ride"] = 1016.57}},
    ["rbxassetid://82296650763619"] = {name = "Angus Bull", prices = {["default"] = 5.25, ["Ride"] = 26.25, ["Fly|Ride"] = 205.47, ["Neon"] = 53.76, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 169.44, ["Mega"] = 210, ["Mega|Ride"] = 282.71, ["Mega|Fly|Ride"] = 377.45}},
    ["rbxassetid://12917347755"] = {name = "Sunrise Duckling", prices = {["default"] = 19.69, ["Fly"] = 52.5, ["Ride"] = 37.08, ["Fly|Ride"] = 65.63, ["Neon"] = 131.86, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 247.8, ["Mega|Ride"] = 706.38, ["Mega|Fly|Ride"] = 577.5}},
    ["rbxassetid://139217275750567"] = {name = "Winter Buck", prices = {["default"] = 19.38, ["Fly"] = 131.25, ["Ride"] = 62.48, ["Fly|Ride"] = 127.32, ["Neon"] = 203.33, ["Neon|Ride"] = 127.32, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 498.74, ["Mega|Ride"] = 476.58, ["Mega|Fly|Ride"] = 734.98}},
    ["rbxassetid://114331718573822"] = {name = "Mochi Meow", prices = {["default"] = 3.93, ["Fly"] = 59.07, ["Ride"] = 56.44, ["Fly|Ride"] = 111.18, ["Neon"] = 26.24, ["Neon|Ride"] = 63.71, ["Neon|Fly|Ride"] = 141.9, ["Mega"] = 105, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 244.13}},
    ["rbxassetid://112560568221286"] = {name = "Strawberry Penguin", prices = {["default"] = 313.71, ["Fly"] = 918.75, ["Ride"] = 262.48, ["Fly|Ride"] = 741.57, ["Neon|Ride"] = 1214.07, ["Neon|Fly|Ride"] = 1424.07, ["Mega|Fly|Ride"] = 4518.9}},
    ["rbxassetid://116818749091454"] = {name = "Dango Penguins", prices = {["default"] = 87.94, ["Fly"] = 254.31, ["Ride"] = 113.33, ["Fly|Ride"] = 215.3, ["Neon"] = 325.1, ["Neon|Ride"] = 459.37, ["Neon|Fly|Ride"] = 548.85, ["Mega"] = 2328.82, ["Mega|Ride"] = 1928.07, ["Mega|Fly|Ride"] = 1620.97}},
    ["rbxassetid://12480100169"] = {name = "Tree Kangaroo", prices = {["default"] = 61.08, ["Fly"] = 127.09, ["Ride"] = 89.54, ["Fly|Ride"] = 128.63, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 460.69, ["Mega|Fly|Ride"] = 1515.94}},
    ["rbxassetid://75106733244906"] = {name = "Golden Hummingbird", prices = {["default"] = 21.19, ["Ride"] = 33.91, ["Fly|Ride"] = 282.78, ["Neon|Ride"] = 599.21, ["Neon|Fly|Ride"] = 493.46, ["Mega|Ride"] = 420, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://76354526914534"] = {name = "Frostclaw", prices = {["default"] = 18.38, ["Fly"] = 75.62, ["Ride"] = 55.09, ["Fly|Ride"] = 95.33, ["Neon"] = 84.79, ["Neon|Ride"] = 120.73, ["Neon|Fly|Ride"] = 187.56, ["Mega"] = 579.31, ["Mega|Fly"] = 525, ["Mega|Ride"] = 371.74, ["Mega|Fly|Ride"] = 444.94}},
    ["rbxassetid://121712578077668"] = {name = "Blue Whale", prices = {["default"] = 3.42, ["Fly"] = 27.57, ["Ride"] = 22.32, ["Fly|Ride"] = 78.75, ["Neon"] = 18.88, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 98.01, ["Mega|Ride"] = 127.32, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://76035105070441"] = {name = "Fairy Bat Dragon", prices = {["default"] = 918.75, ["Fly"] = 1413.62, ["Ride"] = 985.2, ["Fly|Ride"] = 971.25, ["Neon|Ride"] = 2625, ["Neon|Fly|Ride"] = 2388.75, ["Mega|Fly|Ride"] = 8032.5}},
    ["rbxassetid://105346917979221"] = {name = "Aurora Fox", prices = {["default"] = 373.7, ["Fly"] = 484.99, ["Ride"] = 396.33, ["Fly|Ride"] = 438.23, ["Neon|Ride"] = 1680, ["Neon|Fly|Ride"] = 1575, ["Mega"] = 10590.32, ["Mega|Fly|Ride"] = 5330.07}},
    ["rbxassetid://120475294381736"] = {name = "Glormy Hound", prices = {["default"] = 104.84, ["Ride"] = 170.63, ["Fly|Ride"] = 188.73, ["Neon"] = 387.57, ["Neon|Ride"] = 402.4, ["Neon|Fly|Ride"] = 372.75, ["Mega"] = 1481.6, ["Mega|Ride"] = 1836.37, ["Mega|Fly|Ride"] = 1887.21}},
    ["rbxassetid://15570696642"] = {name = "Glacier Kitsune", prices = {["default"] = 251.99, ["Ride"] = 260.07, ["Fly|Ride"] = 295.32, ["Neon|Ride"] = 1290.4, ["Neon|Fly|Ride"] = 910.67, ["Mega"] = 10590.32, ["Mega|Fly|Ride"] = 3937.5}},
    ["rbxassetid://16548792521"] = {name = "Golden Hamster", prices = {["default"] = 25.44, ["Fly"] = 52.5, ["Ride"] = 35.21, ["Fly|Ride"] = 85.32, ["Neon"] = 157.49, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 164.07, ["Mega|Ride"] = 786.75, ["Mega|Fly|Ride"] = 618.87}},
    ["rbxassetid://12935498875"] = {name = "Field Mouse", prices = {["default"] = 393.75, ["Ride"] = 494.58, ["Neon"] = 1584.98, ["Neon|Fly|Ride"] = 1978.05, ["Mega"] = 4446.88, ["Mega|Fly|Ride"] = 4446.88}},
    ["rbxassetid://16548793509"] = {name = "Diamond Hamster", prices = {["default"] = 93.2, ["Fly"] = 126, ["Ride"] = 95.71, ["Fly|Ride"] = 156.76, ["Neon"] = 423.57, ["Neon|Ride"] = 489.51, ["Neon|Fly|Ride"] = 635.36, ["Mega|Fly|Ride"] = 1397.82}},
    ["rbxassetid://78823655016197"] = {name = "Jekyll Hydra", prices = {["default"] = 1312.5, ["Ride"] = 1181.25, ["Fly|Ride"] = 1448.52, ["Neon|Fly|Ride"] = 4331.25, ["Mega"] = 50833.49, ["Mega|Fly|Ride"] = 24711.44}},
    ["rbxassetid://96735424372947"] = {name = "Glormy Dolphin", prices = {["default"] = 13.13, ["Fly"] = 65.54, ["Ride"] = 35.44, ["Fly|Ride"] = 97.13, ["Neon"] = 50.75, ["Neon|Fly"] = 168.38, ["Neon|Ride"] = 83.71, ["Neon|Fly|Ride"] = 133.45, ["Mega"] = 236.23, ["Mega|Ride"] = 275.63, ["Mega|Fly|Ride"] = 356.67}},
    ["rbxassetid://16898331554"] = {name = "Princess Capuchin Monkey", prices = {["default"] = 70.96, ["Ride"] = 84, ["Fly|Ride"] = 224.54, ["Neon"] = 315, ["Neon|Ride"] = 255.94, ["Neon|Fly|Ride"] = 423.63, ["Mega|Ride"] = 1143.77, ["Mega|Fly|Ride"] = 1270.85}},
    ["rbxassetid://4315743450"] = {name = "Queen Bee", prices = {["default"] = 78.75, ["Fly"] = 84, ["Ride"] = 78.75, ["Fly|Ride"] = 85.32, ["Neon|Ride"] = 410.82, ["Neon|Fly|Ride"] = 392.44, ["Mega|Fly|Ride"] = 1575}},
    ["rbxassetid://5067924789"] = {name = "Monkey King", prices = {["default"] = 1575, ["Ride"] = 1010.63, ["Fly|Ride"] = 958.85, ["Neon|Fly|Ride"] = 4199.99, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://10284283561"] = {name = "Black-Chested Pheasant", prices = {["default"] = 370.62, ["Ride"] = 498.75, ["Fly|Ride"] = 525, ["Neon|Fly|Ride"] = 1988.63, ["Mega|Fly|Ride"] = 14153.95}},
    ["rbxassetid://15504845135"] = {name = "Candy Hare", prices = {["default"] = 98.12, ["Fly"] = 131.25, ["Ride"] = 150.94, ["Fly|Ride"] = 282.78, ["Neon"] = 562.69, ["Neon|Ride"] = 456.75, ["Neon|Fly|Ride"] = 706.38, ["Mega"] = 4024.33, ["Mega|Ride"] = 2683.59, ["Mega|Fly|Ride"] = 2118.08}},
    ["rbxassetid://11758575657"] = {name = "Lunar Moon Bear", prices = {["default"] = 11.46, ["Fly"] = 39.38, ["Ride"] = 28.61, ["Fly|Ride"] = 65.63, ["Neon"] = 72.02, ["Neon|Ride"] = 88.97, ["Neon|Fly|Ride"] = 233.63, ["Mega"] = 761.25, ["Mega|Ride"] = 508.59, ["Mega|Fly|Ride"] = 989.15}},
    ["rbxassetid://10318105392"] = {name = "Green Butterfly", prices = {["default"] = 47.16, ["Fly"] = 70.96, ["Ride"] = 48.57, ["Fly|Ride"] = 68.25, ["Neon"] = 204.75, ["Neon|Ride"] = 210.76, ["Neon|Fly|Ride"] = 209.99, ["Mega"] = 1836.37, ["Mega|Fly|Ride"] = 1049.99}},
    ["rbxassetid://84813815094145"] = {name = "Mermicorn", prices = {["default"] = 834.2, ["Ride"] = 826.88, ["Fly|Ride"] = 839.06, ["Neon|Ride"] = 2828.44, ["Neon|Fly|Ride"] = 2964.94, ["Mega|Fly|Ride"] = 12707.33}},
    ["rbxassetid://4507163112"] = {name = "Christmas Egg", prices = {["default"] = 787.5}},
    ["rbxassetid://14689005829"] = {name = "Blazing Lion", prices = {["default"] = 4823.44, ["Ride"] = 4200, ["Fly|Ride"] = 4080.21, ["Neon|Ride"] = 30349.23, ["Neon|Fly|Ride"] = 21706.47, ["Mega|Fly|Ride"] = 90371.34}},
    ["rbxassetid://123647431892215"] = {name = "Hero Gibbon", prices = {["default"] = 167.32, ["Fly"] = 169.44, ["Ride"] = 393.75, ["Fly|Ride"] = 423.63, ["Neon"] = 918.75, ["Neon|Ride"] = 847.14, ["Neon|Fly|Ride"] = 918.75, ["Mega"] = 5930.58, ["Mega|Fly|Ride"] = 6291.44}},
    ["rbxassetid://106457467498193"] = {name = "Scorching Kaijunior", prices = {["default"] = 70.86, ["Fly"] = 282.75, ["Ride"] = 77.44, ["Fly|Ride"] = 336, ["Neon"] = 441, ["Neon|Ride"] = 508.3, ["Neon|Fly|Ride"] = 989.04, ["Mega|Fly|Ride"] = 2811.75}},
    ["rbxassetid://10926054030"] = {name = "Chimera", prices = {["default"] = 14.43, ["Fly"] = 127.09, ["Ride"] = 28.62, ["Fly|Ride"] = 105, ["Neon"] = 141.9, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 141.92, ["Mega"] = 422.58, ["Mega|Ride"] = 528.47, ["Mega|Fly|Ride"] = 524.24}},
    ["rbxassetid://9490242683"] = {name = "Golden King Penguin", prices = {["default"] = 13.07, ["Fly"] = 30.27, ["Ride"] = 31.5, ["Fly|Ride"] = 45.94, ["Neon"] = 105, ["Neon|Ride"] = 314.95, ["Neon|Fly|Ride"] = 234.94, ["Mega"] = 1312.5, ["Mega|Fly|Ride"] = 802.75}},
    ["rbxassetid://17119623510"] = {name = "Mushroom Friend", prices = {["default"] = 22.32, ["Fly"] = 70.96, ["Ride"] = 45.94, ["Fly|Ride"] = 90.57, ["Neon"] = 141.9, ["Neon|Ride"] = 105.98, ["Neon|Fly|Ride"] = 177.19, ["Mega|Ride"] = 859.69, ["Mega|Fly|Ride"] = 780.94}},
    ["rbxassetid://17174656536"] = {name = "Golden Tortoise Beetle", prices = {["default"] = 4.3, ["Fly"] = 57.2, ["Ride"] = 20.97, ["Fly|Ride"] = 63.56, ["Neon"] = 36.58, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 134.5, ["Mega|Ride"] = 314.94, ["Mega|Fly|Ride"] = 314.94}},
    ["rbxassetid://84310117840681"] = {name = "Super Saru", prices = {["default"] = 24.94, ["Ride"] = 57.21, ["Fly|Ride"] = 168.39, ["Neon"] = 108.02, ["Neon|Fly"] = 847.14, ["Neon|Ride"] = 131.24, ["Neon|Fly|Ride"] = 251.06, ["Mega"] = 692.62, ["Mega|Ride"] = 1355.82, ["Mega|Fly|Ride"] = 943.61}},
    ["rbxassetid://77177643028234"] = {name = "Phantom Dragon", prices = {["default"] = 276.6, ["Fly"] = 332.51, ["Ride"] = 291.38, ["Fly|Ride"] = 300.57, ["Neon"] = 868.31, ["Neon|Ride"] = 977.82, ["Neon|Fly|Ride"] = 689.5, ["Mega"] = 6562.5, ["Mega|Fly|Ride"] = 5348.44}},
    ["rbxassetid://6245080265"] = {name = "Metal Ox", prices = {["default"] = 3.89, ["Fly"] = 16.96, ["Ride"] = 16.86, ["Fly|Ride"] = 36.66, ["Neon"] = 22.32, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 303.96, ["Mega|Ride"] = 117.57, ["Mega|Fly|Ride"] = 261.19}},
    ["rbxassetid://3181728194"] = {name = "Unicorn", prices = {["default"] = 36.75, ["Fly"] = 130.88, ["Ride"] = 63.71, ["Fly|Ride"] = 114.09, ["Neon"] = 144.38, ["Neon|Fly"] = 288.75, ["Neon|Ride"] = 156.19, ["Neon|Fly|Ride"] = 219.93, ["Mega"] = 564.38, ["Mega|Fly"] = 780.84, ["Mega|Ride"] = 547.3, ["Mega|Fly|Ride"] = 544.69}},
    ["rbxassetid://4708551322"] = {name = "Turtle", prices = {["default"] = 767.82, ["Fly"] = 932.91, ["Ride"] = 770.53, ["Fly|Ride"] = 787.5, ["Neon|Ride"] = 1575, ["Neon|Fly|Ride"] = 1542.19, ["Mega"] = 3806.25, ["Mega|Fly|Ride"] = 4003.13}},
    ["rbxassetid://5721844281"] = {name = "T-Rex", prices = {["default"] = 30.19, ["Fly"] = 107.63, ["Ride"] = 40.69, ["Fly|Ride"] = 72.19, ["Neon"] = 158.09, ["Neon|Fly"] = 471.81, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 210, ["Mega"] = 1575, ["Mega|Ride"] = 1130, ["Mega|Fly|Ride"] = 654.93}},
    ["rbxassetid://16127039676"] = {name = "Midnight Dragon", prices = {["default"] = 267.72, ["Fly"] = 316.98, ["Ride"] = 241.5, ["Fly|Ride"] = 262.5, ["Neon|Fly|Ride"] = 1128.75, ["Mega|Fly|Ride"] = 4602.56}},
    ["rbxassetid://7734925172"] = {name = "Halloween White Ghost Dragon", prices = {["default"] = 126, ["Fly"] = 179.82, ["Ride"] = 112.87, ["Fly|Ride"] = 141.75, ["Neon"] = 635.36, ["Neon|Fly"] = 643.82, ["Neon|Ride"] = 629.88, ["Neon|Fly|Ride"] = 466.62, ["Mega"] = 2965.3, ["Mega|Fly|Ride"] = 2222.92}},
    ["rbxassetid://18508016126"] = {name = "Bush Elephant", prices = {["default"] = 592.97, ["Ride"] = 570.94, ["Fly|Ride"] = 682.5, ["Neon"] = 5365.47, ["Neon|Fly|Ride"] = 1880.04, ["Mega"] = 7942.74, ["Mega|Fly|Ride"] = 7217.44}},
    ["rbxassetid://78218981883168"] = {name = "Coconut Friend", prices = {["default"] = 20.98, ["Fly"] = 104.35, ["Ride"] = 52.5, ["Fly|Ride"] = 156.76, ["Neon"] = 89.15, ["Neon|Fly"] = 283.1, ["Neon|Ride"] = 118.6, ["Neon|Fly|Ride"] = 141.9, ["Mega"] = 354.24, ["Mega|Ride"] = 380.63, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://4184878050"] = {name = "Evil Unicorn", prices = {["default"] = 3018.75, ["Fly"] = 3018.75, ["Ride"] = 3936.19, ["Fly|Ride"] = 3018.75, ["Neon|Fly|Ride"] = 5906.25, ["Mega|Fly|Ride"] = 23745.75}},
    ["rbxassetid://103896000727935"] = {name = "Aestus", prices = {["default"] = 85.31, ["Fly"] = 141.57, ["Ride"] = 106.32, ["Fly|Ride"] = 136.6, ["Neon"] = 550.97, ["Neon|Ride"] = 446.25, ["Neon|Fly|Ride"] = 384.81, ["Mega|Ride"] = 1481.6, ["Mega|Fly|Ride"] = 1688.11}},
    ["rbxassetid://9922229151"] = {name = "Dragonfly", prices = {["default"] = 2.63, ["Fly"] = 33.76, ["Ride"] = 18.88, ["Fly|Ride"] = 42.38, ["Neon"] = 15.75, ["Neon|Fly"] = 42.24, ["Neon|Ride"] = 40.13, ["Neon|Fly|Ride"] = 79.44, ["Mega"] = 133.82, ["Mega|Fly"] = 452.82, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://82820245821381"] = {name = "Temple Friend", prices = {["default"] = 3.5, ["Ride"] = 28.49, ["Fly|Ride"] = 158.06, ["Neon"] = 25.43, ["Neon|Fly"] = 157.5, ["Neon|Ride"] = 62.99, ["Neon|Fly|Ride"] = 266.44, ["Mega"] = 173.25, ["Mega|Ride"] = 173.7, ["Mega|Fly|Ride"] = 316.66}},
    ["rbxassetid://6404812861"] = {name = "Diamond Ladybug", prices = {["default"] = 37.74, ["Fly"] = 65.63, ["Ride"] = 40.69, ["Fly|Ride"] = 70.97, ["Neon|Ride"] = 254.16, ["Neon|Fly|Ride"] = 421.46, ["Mega|Fly|Ride"] = 1370.4}},
    ["rbxassetid://107535752953647"] = {name = "Strawberry Tortle", prices = {["default"] = 911.72, ["Ride"] = 1049.09, ["Fly|Ride"] = 1227.19, ["Neon"] = 5064.74, ["Mega|Fly|Ride"] = 27534.82}},
    ["rbxassetid://95844539868957"] = {name = "Amethyst Penguin", prices = {["default"] = 4953.2, ["Ride"] = 4200, ["Fly|Ride"] = 4751.88}},
    ["rbxassetid://6240249282"] = {name = "Guardian Lion", prices = {["default"] = 17.07, ["Fly"] = 36.02, ["Ride"] = 27.27, ["Fly|Ride"] = 47.16, ["Neon"] = 105, ["Neon|Ride"] = 79.44, ["Neon|Fly|Ride"] = 136.31, ["Mega"] = 2428.13, ["Mega|Fly|Ride"] = 626.42}},
    ["rbxassetid://11496077150"] = {name = "Ice Moth Dragon", prices = {["default"] = 21.2, ["Fly"] = 70.79, ["Ride"] = 40.24, ["Fly|Ride"] = 93.19, ["Neon"] = 105.91, ["Neon|Ride"] = 122.84, ["Neon|Fly|Ride"] = 209.97, ["Mega"] = 943.61, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 476.05}},
    ["rbxassetid://5862774166"] = {name = "Skele-Rex", prices = {["default"] = 45.85, ["Fly"] = 157.47, ["Ride"] = 49.87, ["Fly|Ride"] = 66.94, ["Neon|Ride"] = 259.72, ["Neon|Fly|Ride"] = 262.5, ["Mega|Fly|Ride"] = 883.76}},
    ["rbxassetid://11773429123"] = {name = "Nessie", prices = {["default"] = 217.88, ["Ride"] = 214.44, ["Fly|Ride"] = 236.25, ["Neon|Ride"] = 976.5, ["Neon|Fly|Ride"] = 943.69, ["Mega"] = 11166.29, ["Mega|Ride"] = 3281.95, ["Mega|Fly|Ride"] = 3387.86}},
    ["rbxassetid://121782270350526"] = {name = "Dark Choccybunny", prices = {["default"] = 3.93, ["Ride"] = 32.48, ["Fly|Ride"] = 131.25, ["Neon"] = 21, ["Neon|Fly"] = 70.95, ["Neon|Ride"] = 92.42, ["Neon|Fly|Ride"] = 211.79, ["Mega"] = 115.5, ["Mega|Ride"] = 198.19, ["Mega|Fly|Ride"] = 368.02}},
    ["rbxassetid://129591977577854"] = {name = "Ballet Swan", prices = {["default"] = 189, ["Fly"] = 249.92, ["Ride"] = 183.75, ["Fly|Ride"] = 278.88, ["Neon"] = 799.58, ["Neon|Ride"] = 744.19, ["Neon|Fly|Ride"] = 786.19, ["Mega|Fly|Ride"] = 3346.54}},
    ["rbxassetid://9669227320"] = {name = "Zodiac Minion Chick", prices = {["default"] = 3.14, ["Fly"] = 24.12, ["Ride"] = 16.96, ["Fly|Ride"] = 39.11, ["Neon"] = 18.38, ["Neon|Fly"] = 121.79, ["Neon|Ride"] = 28.61, ["Neon|Fly|Ride"] = 105, ["Mega"] = 282.75, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 741.35}},
    ["rbxassetid://13462536955"] = {name = "Caelum Cervi", prices = {["default"] = 220.27, ["Fly"] = 220.55, ["Ride"] = 237.57, ["Fly|Ride"] = 235.91, ["Neon|Ride"] = 963.62, ["Neon|Fly|Ride"] = 1115.63, ["Mega"] = 10590.32, ["Mega|Fly|Ride"] = 4235.07}},
    ["rbxassetid://10137833794"] = {name = "Green-Chested Pheasant", prices = {["default"] = 13.02, ["Fly"] = 30.19, ["Ride"] = 31.69, ["Fly|Ride"] = 49.8, ["Neon"] = 70.96, ["Neon|Fly"] = 299.61, ["Neon|Ride"] = 113.32, ["Neon|Fly|Ride"] = 156.73, ["Mega"] = 466.28, ["Mega|Ride"] = 565.55, ["Mega|Fly|Ride"] = 371.74}},
    ["rbxassetid://16994954002"] = {name = "Brachiosaurus", prices = {["default"] = 2.1, ["Ride"] = 28.62, ["Neon"] = 7.77, ["Neon|Fly"] = 66.94, ["Neon|Ride"] = 45.56, ["Neon|Fly|Ride"] = 84.45, ["Mega"] = 76.11, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 215.78}},
    ["rbxassetid://121938982134212"] = {name = "Gecko Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.94, ["Mega"] = 19.59, ["Mega|Ride"] = 155.7}},
    ["rbxassetid://17649624018"] = {name = "Kid Goat", prices = {["default"] = 7.88, ["Ride"] = 42.38, ["Fly|Ride"] = 220.29, ["Neon"] = 9.19, ["Neon|Ride"] = 65.61, ["Neon|Fly|Ride"] = 144.37, ["Mega"] = 68.16, ["Mega|Fly"] = 157266.73, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 183.99}},
    ["rbxassetid://4440867127"] = {name = "Chicken", prices = {["default"] = 66.45, ["Fly"] = 139.79, ["Ride"] = 105, ["Fly|Ride"] = 173.31, ["Neon"] = 294, ["Neon|Ride"] = 330.27, ["Neon|Fly|Ride"] = 345.85, ["Mega|Fly|Ride"] = 1270.85}},
    ["rbxassetid://5721844165"] = {name = "Tasmanian Tiger", prices = {["default"] = 2.1, ["Fly"] = 28.61, ["Ride"] = 18.27, ["Fly|Ride"] = 41.14, ["Neon"] = 5.25, ["Neon|Ride"] = 21.17, ["Neon|Fly|Ride"] = 113.32, ["Mega"] = 93.27, ["Mega|Ride"] = 98.34, ["Mega|Fly|Ride"] = 257.25}},
    ["rbxassetid://14146063876"] = {name = "Cockroach", prices = {["default"] = 9.19, ["Ride"] = 91.59, ["Fly|Ride"] = 197.02, ["Neon"] = 210, ["Neon|Ride"] = 315, ["Mega"] = 456.75, ["Mega|Ride"] = 635.43}},
    ["rbxassetid://135555287601448"] = {name = "Rubber Ducky", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 28.67, ["Neon|Fly|Ride"] = 278.25, ["Mega"] = 26.17, ["Mega|Ride"] = 45.61, ["Mega|Fly|Ride"] = 143.73}},
    ["rbxassetid://9664487060"] = {name = "Ant", prices = {["default"] = 2.1, ["Fly"] = 21.11, ["Ride"] = 18, ["Fly|Ride"] = 31.75, ["Neon"] = 2.1, ["Neon|Fly"] = 16.96, ["Neon|Ride"] = 17.69, ["Neon|Fly|Ride"] = 35.23, ["Mega"] = 15.49, ["Mega|Fly"] = 27.57, ["Mega|Ride"] = 19.69, ["Mega|Fly|Ride"] = 70.88}},
    ["rbxassetid://3293758505"] = {name = "Otter", prices = {["default"] = 2.1, ["Ride"] = 15.9, ["Fly|Ride"] = 49.71, ["Neon"] = 2.63, ["Neon|Fly"] = 19.07, ["Neon|Ride"] = 17.75, ["Neon|Fly|Ride"] = 42.39, ["Mega"] = 40.27, ["Mega|Ride"] = 38.75, ["Mega|Fly|Ride"] = 77.35}},
    ["rbxassetid://79698905581979"] = {name = "Ms. Muffet", prices = {["default"] = 2.1, ["Fly|Ride"] = 125.73, ["Neon"] = 2.1, ["Neon|Ride"] = 58.99, ["Mega"] = 24.94, ["Mega|Ride"] = 118.13}},
    ["rbxassetid://13620861015"] = {name = "Flying Fish", prices = {["default"] = 2.1, ["Fly"] = 118.13, ["Ride"] = 38.14, ["Fly|Ride"] = 104.2, ["Neon"] = 8.49, ["Neon|Fly"] = 135.03, ["Neon|Ride"] = 70.96, ["Neon|Fly|Ride"] = 81.69, ["Mega"] = 28.32, ["Mega|Fly"] = 72.19, ["Mega|Ride"] = 97.43, ["Mega|Fly|Ride"] = 164.17}},
    ["rbxassetid://100439668574210"] = {name = "Jiggly Jerboa", prices = {["default"] = 2.1, ["Neon"] = 3.6, ["Neon|Ride"] = 42.37, ["Neon|Fly|Ride"] = 99.56, ["Mega"] = 24.94, ["Mega|Ride"] = 98.44}},
    ["rbxassetid://14815828879"] = {name = "Ghost", prices = {["default"] = 2.1, ["Fly"] = 47.16, ["Ride"] = 25.96, ["Fly|Ride"] = 63.56, ["Neon"] = 4.87, ["Neon|Fly"] = 37.97, ["Neon|Ride"] = 31.78, ["Neon|Fly|Ride"] = 67.45, ["Mega"] = 73.33, ["Mega|Fly"] = 352.69, ["Mega|Ride"] = 63.95, ["Mega|Fly|Ride"] = 120.16}},
    ["rbxassetid://140565380261180"] = {name = "Galapagos Sea Lion", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 26.17, ["Neon|Fly|Ride"] = 313.28, ["Mega"] = 23.3, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://14146188240"] = {name = "Bluebottle Fly", prices = {["default"] = 2.1, ["Ride"] = 52.5, ["Fly|Ride"] = 525, ["Neon"] = 21.92, ["Mega"] = 203.35, ["Mega|Fly"] = 314.99, ["Mega|Ride"] = 282.78}},
    ["rbxassetid://15930540035"] = {name = "Sandfish", prices = {["default"] = 2.1, ["Neon"] = 23.63, ["Mega"] = 139.13, ["Mega|Fly|Ride"] = 405.77}},
    ["rbxassetid://74774507671765"] = {name = "Island Tarsier", prices = {["default"] = 2.1, ["Ride"] = 70.97, ["Neon"] = 3.42, ["Neon|Ride"] = 37.71, ["Neon|Fly|Ride"] = 76.26, ["Mega"] = 22.5, ["Mega|Fly"] = 79.44, ["Mega|Ride"] = 70.79, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://9678196095"] = {name = "Mouse", prices = {["default"] = 2.1, ["Fly"] = 30.6, ["Ride"] = 18.69, ["Fly|Ride"] = 30.19, ["Neon"] = 2.1, ["Neon|Fly"] = 18.9, ["Neon|Ride"] = 17.71, ["Neon|Fly|Ride"] = 41.88, ["Mega"] = 13.12, ["Mega|Fly"] = 53.95, ["Mega|Ride"] = 22.79, ["Mega|Fly|Ride"] = 57.66}},
    ["rbxassetid://100695038890951"] = {name = "Basic Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13104111122"] = {name = "Piranha", prices = {["default"] = 2.63, ["Fly"] = 72.19, ["Ride"] = 31.5, ["Neon"] = 31.39, ["Neon|Ride"] = 39.38, ["Mega"] = 269, ["Mega|Fly"] = 353.74, ["Mega|Ride"] = 353.74, ["Mega|Fly|Ride"] = 690.51}},
    ["rbxassetid://110856597065248"] = {name = "Bakeneko", prices = {["default"] = 2.1, ["Ride"] = 41.91, ["Fly|Ride"] = 78.73, ["Neon"] = 6.57, ["Neon|Fly"] = 23.61, ["Neon|Ride"] = 34.13, ["Neon|Fly|Ride"] = 117.97, ["Mega"] = 55.09, ["Mega|Ride"] = 79.04, ["Mega|Fly|Ride"] = 158.07}},
    ["rbxassetid://128979941112615"] = {name = "Dirty Ducky", prices = {["default"] = 3.94, ["Neon"] = 13.13, ["Neon|Fly|Ride"] = 141.92, ["Mega"] = 71.06, ["Mega|Ride"] = 233.63, ["Mega|Fly|Ride"] = 221.81}},
    ["rbxassetid://12479656052"] = {name = "Maleo Bird", prices = {["default"] = 3.94, ["Fly"] = 31.8, ["Ride"] = 21.2, ["Fly|Ride"] = 192.76, ["Neon"] = 11.65, ["Neon|Fly"] = 65.63, ["Neon|Fly|Ride"] = 127.09, ["Mega"] = 78.39, ["Mega|Ride"] = 85.3}},
    ["rbxassetid://3200646599"] = {name = "Cat", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 12.71, ["Fly|Ride"] = 26.25, ["Neon"] = 2.1, ["Neon|Fly"] = 20.9, ["Neon|Ride"] = 15.74, ["Neon|Fly|Ride"] = 32.82, ["Mega"] = 18.12, ["Mega|Ride"] = 22.32, ["Mega|Fly|Ride"] = 52.49}},
    ["rbxassetid://12479810452"] = {name = "Bali Starling", prices = {["default"] = 2.1, ["Fly"] = 23.94, ["Ride"] = 19.65, ["Fly|Ride"] = 48.57, ["Neon"] = 22.46, ["Neon|Ride"] = 113.25, ["Mega"] = 128.63, ["Mega|Fly|Ride"] = 266.44}},
    ["rbxassetid://9982819219"] = {name = "Dugong", prices = {["default"] = 13.02, ["Fly"] = 41.91, ["Ride"] = 30.68, ["Fly|Ride"] = 141.39, ["Neon"] = 74.75, ["Neon|Ride"] = 112.88, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 279.57, ["Mega|Ride"] = 276.94, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://3181727229"] = {name = "Buffalo", prices = {["default"] = 2.1, ["Fly"] = 22.32, ["Ride"] = 15.64, ["Fly|Ride"] = 28.62, ["Neon"] = 2.1, ["Neon|Fly"] = 22.44, ["Neon|Ride"] = 17.07, ["Neon|Fly|Ride"] = 63.71, ["Mega|Fly"] = 156.19, ["Mega|Ride"] = 49.55, ["Mega|Fly|Ride"] = 91.87}},
    ["rbxassetid://99694153348188"] = {name = "Urchin", prices = {["default"] = 2.63, ["Fly"] = 176.85, ["Ride"] = 26.25, ["Neon"] = 9.09, ["Neon|Fly"] = 77.53, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 54.9, ["Mega|Fly"] = 565.55, ["Mega|Ride"] = 118.13}},
    ["rbxassetid://84089584046947"] = {name = "Blue Butterfly", prices = {["default"] = 2.1, ["Ride"] = 27.56, ["Neon"] = 5.01, ["Neon|Fly"] = 118.13, ["Neon|Fly|Ride"] = 126.21, ["Mega"] = 35.43, ["Mega|Ride"] = 141.56, ["Mega|Fly|Ride"] = 205.25}},
    ["rbxassetid://124485808787576"] = {name = "Tegu", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Fly"] = 40.69, ["Neon|Ride"] = 21.21, ["Neon|Fly|Ride"] = 101.07, ["Mega"] = 19.67, ["Mega|Ride"] = 52.08}},
    ["rbxassetid://8938703774"] = {name = "Bullfrog", prices = {["default"] = 2.1, ["Fly"] = 88.97, ["Ride"] = 21.18, ["Fly|Ride"] = 45.55, ["Neon"] = 11.69, ["Neon|Fly"] = 46.6, ["Neon|Ride"] = 27.56, ["Neon|Fly|Ride"] = 101.67, ["Mega"] = 221.75, ["Mega|Ride"] = 95.82, ["Mega|Fly|Ride"] = 270.06}},
    ["rbxassetid://102746202827395"] = {name = "Hopbop", prices = {["default"] = 2.1, ["Ride"] = 31.49, ["Neon"] = 20.14, ["Neon|Ride"] = 52.5, ["Mega"] = 94.4, ["Mega|Ride"] = 165.15, ["Mega|Fly|Ride"] = 267.77}},
    ["rbxassetid://6498255997"] = {name = "Stingray", prices = {["default"] = 2.1, ["Fly"] = 26.17, ["Ride"] = 20.98, ["Fly|Ride"] = 126.14, ["Neon"] = 7.39, ["Neon|Fly"] = 141.9, ["Neon|Ride"] = 19.59, ["Neon|Fly|Ride"] = 48.47, ["Mega"] = 39.38, ["Mega|Fly"] = 127.16, ["Mega|Ride"] = 90.57, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://13104106555"] = {name = "Mosquito", prices = {["default"] = 7.1, ["Fly"] = 26.25, ["Ride"] = 82.6, ["Neon"] = 87.84, ["Mega"] = 279.6, ["Mega|Fly|Ride"] = 844.06}},
    ["rbxassetid://5721843483"] = {name = "Ground Sloth", prices = {["default"] = 2.1, ["Ride"] = 19.69, ["Fly|Ride"] = 5425.59, ["Neon"] = 13.13, ["Neon|Fly"] = 141.9, ["Neon|Ride"] = 27.15, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 150.94, ["Mega|Fly|Ride"] = 267.77}},
    ["rbxassetid://4506925908"] = {name = "Robin", prices = {["default"] = 15.75, ["Fly"] = 17.07, ["Ride"] = 28.53, ["Fly|Ride"] = 141.92, ["Neon"] = 23.55, ["Neon|Fly"] = 99.56, ["Neon|Ride"] = 36.02, ["Neon|Fly|Ride"] = 84.62, ["Mega"] = 278.54, ["Mega|Ride"] = 118.01, ["Mega|Fly|Ride"] = 209.47}},
    ["rbxassetid://10382786163"] = {name = "Sado Mole", prices = {["default"] = 3.29, ["Fly"] = 79.47, ["Ride"] = 32.82, ["Fly|Ride"] = 106.14, ["Neon"] = 33.83, ["Neon|Ride"] = 158, ["Mega"] = 202.05, ["Mega|Ride"] = 405.56}},
    ["rbxassetid://14471275373"] = {name = "Ash Zebra", prices = {["default"] = 13.13, ["Neon"] = 99.56, ["Mega"] = 556.5, ["Mega|Fly|Ride"] = 794.07}},
    ["rbxassetid://15923574361"] = {name = "Armadillo", prices = {["default"] = 2.1, ["Ride"] = 35.32, ["Fly|Ride"] = 70.97, ["Neon"] = 72.19, ["Neon|Ride"] = 105, ["Mega"] = 268.93, ["Mega|Ride"] = 367.5}},
    ["rbxassetid://15921927876"] = {name = "Coyote", prices = {["default"] = 6.57, ["Ride"] = 33.8, ["Neon"] = 49.88, ["Neon|Ride"] = 99.56, ["Mega"] = 471.81, ["Mega|Ride"] = 251.97, ["Mega|Fly|Ride"] = 393.1}},
    ["rbxassetid://74353184935672"] = {name = "Sheepdog Ducky", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 129.2, ["Mega"] = 15.74, ["Mega|Ride"] = 139.13, ["Mega|Fly|Ride"] = 148.29}},
    ["rbxassetid://4748889845"] = {name = "Easter 2020 Egg", prices = {["default"] = 53.05}},
    ["rbxassetid://4752655872"] = {name = "Chick", prices = {["default"] = 3.72, ["Fly"] = 26.25, ["Ride"] = 22.23, ["Fly|Ride"] = 42, ["Neon"] = 32.87, ["Neon|Ride"] = 41.15, ["Neon|Fly|Ride"] = 105.91, ["Mega"] = 249.38, ["Mega|Ride"] = 314.94, ["Mega|Fly|Ride"] = 281}},
    ["rbxassetid://17174085645"] = {name = "Garden Snake", prices = {["default"] = 2.1, ["Fly"] = 70.88, ["Ride"] = 13.13, ["Fly|Ride"] = 70.86, ["Neon"] = 3.94, ["Neon|Ride"] = 23.55, ["Mega"] = 38.96, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://17661844380"] = {name = "Show Pony", prices = {["default"] = 2.1, ["Ride"] = 45.49, ["Fly|Ride"] = 140.27, ["Neon"] = 6.04, ["Neon|Ride"] = 30.18, ["Neon|Fly|Ride"] = 158.07, ["Mega"] = 42, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 299.25}},
    ["rbxassetid://8077196440"] = {name = "Walrus", prices = {["default"] = 2.1, ["Fly"] = 45.94, ["Ride"] = 19.69, ["Fly|Ride"] = 78.39, ["Neon"] = 15.74, ["Neon|Ride"] = 57.2, ["Neon|Fly|Ride"] = 90, ["Mega"] = 133.76, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 314.94}},
    ["rbxassetid://13104118499"] = {name = "Liger", prices = {["default"] = 3.94, ["Neon"] = 32.45, ["Neon|Ride"] = 210, ["Neon|Fly|Ride"] = 156.75, ["Mega"] = 328.13, ["Mega|Ride"] = 282.78}},
    ["rbxassetid://120937667166493"] = {name = "Aye Aye", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 51.92, ["Mega"] = 18.38, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 50.91, ["Mega|Fly|Ride"] = 141.1}},
    ["rbxassetid://3199974297"] = {name = "Cracked Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15348350458"] = {name = "Beluga Whale", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Ride"] = 21.19, ["Fly|Ride"] = 57.21, ["Neon"] = 4.68, ["Neon|Fly"] = 30.19, ["Neon|Ride"] = 28.61, ["Neon|Fly|Ride"] = 96.38, ["Mega"] = 32.82, ["Mega|Fly"] = 188.73, ["Mega|Ride"] = 57.2, ["Mega|Fly|Ride"] = 146.41}},
    ["rbxassetid://7126719464"] = {name = "Wolpertinger", prices = {["default"] = 2.1, ["Fly"] = 28.61, ["Ride"] = 14.44, ["Fly|Ride"] = 39.38, ["Neon"] = 8.39, ["Neon|Fly"] = 103.79, ["Neon|Ride"] = 23.37, ["Neon|Fly|Ride"] = 70.96, ["Mega"] = 65.63, ["Mega|Fly"] = 113.33, ["Mega|Ride"] = 63, ["Mega|Fly|Ride"] = 158.07}},
    ["rbxassetid://125112456358906"] = {name = "Frankenfeline", prices = {["default"] = 2.1, ["Fly"] = 210, ["Ride"] = 26.24, ["Fly|Ride"] = 45.94, ["Neon"] = 3.94, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 74.13, ["Mega"] = 25.44, ["Mega|Fly"] = 99.57, ["Mega|Ride"] = 47.44, ["Mega|Fly|Ride"] = 107.19}},
    ["rbxassetid://80556114592490"] = {name = "Japanese Snow Fairy", prices = {["default"] = 2.1, ["Neon"] = 4.87, ["Neon|Ride"] = 38.06, ["Neon|Fly|Ride"] = 173.7, ["Mega"] = 33.66, ["Mega|Fly"] = 104.81, ["Mega|Ride"] = 84.5, ["Mega|Fly|Ride"] = 162.42}},
    ["rbxassetid://124671555129102"] = {name = "Ratatoskr", prices = {["default"] = 2.1, ["Fly"] = 26.36, ["Ride"] = 27.62, ["Fly|Ride"] = 77.37, ["Neon"] = 5.25, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 39.37, ["Neon|Fly|Ride"] = 68.16, ["Mega"] = 24.76, ["Mega|Ride"] = 51.19, ["Mega|Fly|Ride"] = 124.84}},
    ["rbxassetid://116184296449988"] = {name = "Pinkypillar", prices = {["default"] = 2.1, ["Neon"] = 2.9, ["Mega"] = 25.96, ["Mega|Ride"] = 235.94}},
    ["rbxassetid://74353532164157"] = {name = "Red Panda Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.92, ["Neon|Ride"] = 158.07, ["Neon|Fly|Ride"] = 420, ["Mega"] = 30.19, ["Mega|Fly"] = 117.97}},
    ["rbxassetid://4708551264"] = {name = "Bandicoot", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 19.69, ["Neon"] = 6.56, ["Neon|Fly"] = 71.8, ["Neon|Ride"] = 21.19, ["Neon|Fly|Ride"] = 87.94, ["Mega"] = 61.69, ["Mega|Ride"] = 60.21, ["Mega|Fly|Ride"] = 131.1}},
    ["rbxassetid://12480314681"] = {name = "Malaysian Tapir", prices = {["default"] = 9.98, ["Ride"] = 65.63, ["Fly|Ride"] = 117.57, ["Neon"] = 95.82, ["Neon|Ride"] = 235.92, ["Mega"] = 396.93, ["Mega|Ride"] = 453.28, ["Mega|Fly|Ride"] = 777.35}},
    ["rbxassetid://17482380743"] = {name = "Classic Teapot", prices = {["default"] = 2.1, ["Fly"] = 6562.49, ["Ride"] = 68.16, ["Fly|Ride"] = 131.25, ["Neon"] = 52.5, ["Mega"] = 210.77, ["Mega|Ride"] = 313.04, ["Mega|Fly|Ride"] = 423.63}},
    ["rbxassetid://14146142724"] = {name = "Mongoose", prices = {["default"] = 2.1, ["Ride"] = 31.4, ["Fly|Ride"] = 423.63, ["Neon"] = 99.56, ["Mega"] = 216.05, ["Mega|Ride"] = 216.05, ["Mega|Fly|Ride"] = 338.63}},
    ["rbxassetid://3181727351"] = {name = "Dog", prices = {["default"] = 2.1, ["Fly"] = 15.61, ["Ride"] = 15.75, ["Fly|Ride"] = 39.69, ["Neon"] = 2.1, ["Neon|Fly"] = 24.36, ["Neon|Ride"] = 16.96, ["Neon|Fly|Ride"] = 28.88, ["Mega"] = 18.38, ["Mega|Fly"] = 27.56, ["Mega|Ride"] = 19.69, ["Mega|Fly|Ride"] = 57.75}},
    ["rbxassetid://14267322852"] = {name = "Angelfish", prices = {["default"] = 2.1, ["Ride"] = 55.13, ["Neon"] = 38.14, ["Neon|Fly"] = 141.9, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 105, ["Mega"] = 45.93, ["Mega|Ride"] = 141.92}},
    ["rbxassetid://110130591707207"] = {name = "California Condor", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Fly"] = 31.78, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 70.96, ["Mega"] = 18.38, ["Mega|Fly"] = 78.44, ["Mega|Ride"] = 101.07, ["Mega|Fly|Ride"] = 103.58}},
    ["rbxassetid://123567499475377"] = {name = "Forest Sprite", prices = {["default"] = 2.1, ["Neon"] = 3.94, ["Neon|Fly"] = 60.9, ["Mega"] = 19.69, ["Mega|Ride"] = 99.57, ["Mega|Fly|Ride"] = 282.78}},
    ["rbxassetid://8663441035"] = {name = "Lunar White Tiger", prices = {["default"] = 2.1, ["Fly"] = 52.96, ["Ride"] = 19.69, ["Fly|Ride"] = 52.5, ["Neon"] = 9.19, ["Neon|Fly"] = 141.9, ["Neon|Ride"] = 30.82, ["Neon|Fly|Ride"] = 99.43, ["Mega"] = 143.21, ["Mega|Ride"] = 193.87, ["Mega|Fly|Ride"] = 250.63}},
    ["rbxassetid://16000498338"] = {name = "Groundhog", prices = {["default"] = 158, ["Ride"] = 191.07, ["Fly|Ride"] = 317.72, ["Neon"] = 1270.69, ["Neon|Ride"] = 937.79, ["Neon|Fly|Ride"] = 1119.57, ["Mega"] = 8472.27, ["Mega|Fly|Ride"] = 4137.66}},
    ["rbxassetid://73268582142443"] = {name = "Kelp Raider", prices = {["default"] = 2.1, ["Neon"] = 10.5, ["Neon|Fly"] = 57.14, ["Neon|Ride"] = 68.25, ["Mega"] = 65.42, ["Mega|Ride"] = 177.94, ["Mega|Fly|Ride"] = 558.13}},
    ["rbxassetid://16369178617"] = {name = "Ornate Horned Frog", prices = {["default"] = 3.82, ["Fly"] = 103.68, ["Ride"] = 24.38, ["Fly|Ride"] = 141.92, ["Neon"] = 30.73, ["Neon|Ride"] = 18.38, ["Neon|Fly|Ride"] = 148.28, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 629.87}},
    ["rbxassetid://6245080170"] = {name = "Lunar Ox", prices = {["default"] = 2.1, ["Fly"] = 847.14, ["Ride"] = 17.71, ["Fly|Ride"] = 21.18, ["Neon"] = 5.25, ["Neon|Fly"] = 43.32, ["Neon|Ride"] = 21.19, ["Neon|Fly|Ride"] = 45.94, ["Mega"] = 65.63, ["Mega|Fly"] = 94.38, ["Mega|Ride"] = 80.5, ["Mega|Fly|Ride"] = 134.51}},
    ["rbxassetid://92652981666929"] = {name = "Starmite", prices = {["default"] = 2.1, ["Ride"] = 24.94, ["Fly|Ride"] = 120.89, ["Neon"] = 5.64, ["Neon|Fly"] = 42.37, ["Neon|Ride"] = 82.62, ["Mega"] = 117.59, ["Mega|Ride"] = 98.44}},
    ["rbxassetid://9482496753"] = {name = "King Penguin", prices = {["default"] = 3.54, ["Fly"] = 28.77, ["Ride"] = 17.07, ["Fly|Ride"] = 44.44, ["Neon"] = 23.62, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 160.13, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 158.07}},
    ["rbxassetid://10489161125"] = {name = "Tanuki", prices = {["default"] = 2.1, ["Fly"] = 42.37, ["Fly|Ride"] = 246.75, ["Neon"] = 30.19, ["Neon|Ride"] = 87.94, ["Neon|Fly|Ride"] = 629.01, ["Mega"] = 183.75, ["Mega|Fly|Ride"] = 399}},
    ["rbxassetid://7126720060"] = {name = "Wyvern", prices = {["default"] = 2.63, ["Fly"] = 19.05, ["Ride"] = 15.91, ["Fly|Ride"] = 32.82, ["Neon"] = 21.21, ["Neon|Fly"] = 63.71, ["Neon|Ride"] = 25.99, ["Neon|Fly|Ride"] = 47.25, ["Mega"] = 196.88, ["Mega|Fly"] = 384.57, ["Mega|Ride"] = 281.51, ["Mega|Fly|Ride"] = 187.85}},
    ["rbxassetid://4506925800"] = {name = "Swan", prices = {["default"] = 66.94, ["Fly"] = 85.32, ["Ride"] = 99.79, ["Fly|Ride"] = 139.8, ["Neon"] = 446.25, ["Neon|Fly"] = 404.92, ["Neon|Ride"] = 312.38, ["Neon|Fly|Ride"] = 423.88, ["Mega|Fly|Ride"] = 1566.21}},
    ["rbxassetid://13621428133"] = {name = "Tortuga de la Isla", prices = {["default"] = 210, ["Fly"] = 236.25, ["Ride"] = 245.68, ["Fly|Ride"] = 282.71, ["Neon|Ride"] = 2647.28, ["Neon|Fly|Ride"] = 1096.55, ["Mega"] = 10590.32, ["Mega|Fly|Ride"] = 10590.32}},
    ["rbxassetid://6684832189"] = {name = "Lamb", prices = {["default"] = 68.16, ["Fly"] = 182.81, ["Ride"] = 85.32, ["Fly|Ride"] = 114.79, ["Neon"] = 408.12, ["Neon|Ride"] = 301.87, ["Neon|Fly|Ride"] = 288.75, ["Mega|Fly|Ride"] = 1148.32}},
    ["rbxassetid://122365328950491"] = {name = "Blossom Snake", prices = {["default"] = 2.1, ["Ride"] = 36.03, ["Fly|Ride"] = 82.62, ["Neon"] = 23.63, ["Neon|Ride"] = 98.44, ["Neon|Fly|Ride"] = 144.03, ["Mega"] = 196.88, ["Mega|Ride"] = 193.6, ["Mega|Fly|Ride"] = 393.1}},
    ["rbxassetid://14360919997"] = {name = "Toasty Red Panda", prices = {["default"] = 27.15, ["Fly"] = 68.14, ["Ride"] = 32.19, ["Fly|Ride"] = 78.75, ["Neon"] = 79.44, ["Neon|Ride"] = 97.13, ["Neon|Fly|Ride"] = 198.02, ["Mega"] = 353.07, ["Mega|Ride"] = 383.21, ["Mega|Fly|Ride"] = 1186.13}},
    ["rbxassetid://3181727278"] = {name = "Rabbit", prices = {["default"] = 2.1, ["Fly"] = 31.5, ["Ride"] = 26.25, ["Fly|Ride"] = 55.32, ["Neon"] = 3.92, ["Neon|Fly"] = 115.5, ["Neon|Ride"] = 23.33, ["Neon|Fly|Ride"] = 87.91, ["Mega"] = 49.48, ["Mega|Fly"] = 209.97, ["Mega|Ride"] = 105.92, ["Mega|Fly|Ride"] = 210.77}},
    ["rbxassetid://14782579567"] = {name = "Nightmare Owl", prices = {["default"] = 8.38, ["Fly"] = 68.49, ["Ride"] = 28.61, ["Fly|Ride"] = 131.25, ["Neon"] = 41.32, ["Neon|Ride"] = 49.26, ["Neon|Fly|Ride"] = 134.93, ["Mega"] = 706.38, ["Mega|Ride"] = 282.19, ["Mega|Fly|Ride"] = 423.63}},
    ["rbxassetid://6498256342"] = {name = "Narwhal", prices = {["default"] = 2.1, ["Fly"] = 28.53, ["Ride"] = 15.39, ["Fly|Ride"] = 47.18, ["Neon"] = 23.33, ["Neon|Fly"] = 145.69, ["Neon|Ride"] = 33.91, ["Neon|Fly|Ride"] = 97.13, ["Mega"] = 131.25, ["Mega|Ride"] = 141.99, ["Mega|Fly|Ride"] = 175.88}},
    ["rbxassetid://9227407648"] = {name = "Ibex", prices = {["default"] = 2.63, ["Ride"] = 27.57, ["Fly|Ride"] = 328.13, ["Neon"] = 15.74, ["Neon|Ride"] = 70.96, ["Neon|Fly|Ride"] = 235.92, ["Mega"] = 207.37, ["Mega|Ride"] = 141.9, ["Mega|Fly|Ride"] = 240.51}},
    ["rbxassetid://16440727263"] = {name = "Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 28.61, ["Neon"] = 2.1, ["Neon|Ride"] = 17.07, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 15.74, ["Mega|Ride"] = 51.91, ["Mega|Fly|Ride"] = 198.14}},
    ["rbxassetid://10318106327"] = {name = "Yellow Butterfly", prices = {["default"] = 2.1, ["Fly"] = 45.93, ["Ride"] = 20.89, ["Fly|Ride"] = 55.13, ["Neon"] = 13.13, ["Neon|Fly"] = 70.96, ["Neon|Ride"] = 52.49, ["Neon|Fly|Ride"] = 69.57, ["Mega"] = 108.78, ["Mega|Ride"] = 105.92, ["Mega|Fly|Ride"] = 192.29}},
    ["rbxassetid://13894169749"] = {name = "Black Kite", prices = {["default"] = 3.26, ["Ride"] = 17.07, ["Fly|Ride"] = 57.21, ["Neon"] = 63.71, ["Neon|Fly"] = 141.9, ["Neon|Ride"] = 47.25, ["Neon|Fly|Ride"] = 63, ["Mega"] = 269, ["Mega|Ride"] = 206.07, ["Mega|Fly|Ride"] = 271.69}},
    ["rbxassetid://4506925595"] = {name = "Polar Bear", prices = {["default"] = 144.38, ["Fly"] = 220.27, ["Ride"] = 191, ["Fly|Ride"] = 233.66, ["Neon"] = 525, ["Neon|Fly"] = 671.35, ["Neon|Ride"] = 485.62, ["Neon|Fly|Ride"] = 595.86, ["Mega|Fly|Ride"] = 1948.05}},
    ["rbxassetid://14639006189"] = {name = "Canada Goose", prices = {["default"] = 4.99, ["Ride"] = 30.19, ["Fly|Ride"] = 117.96, ["Neon"] = 78.75, ["Neon|Ride"] = 113.32, ["Neon|Fly|Ride"] = 156.19, ["Mega"] = 307.47, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 485.35}},
    ["rbxassetid://5721844402"] = {name = "Triceratops", prices = {["default"] = 2.1, ["Fly"] = 31.86, ["Ride"] = 26.25, ["Fly|Ride"] = 50.85, ["Neon"] = 25.41, ["Neon|Ride"] = 42.37, ["Neon|Fly|Ride"] = 105.91, ["Mega"] = 141.75, ["Mega|Ride"] = 282.93, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://83805820117149"] = {name = "Golden Jaguar", prices = {["default"] = 22.28, ["Fly"] = 59.07, ["Ride"] = 85.31, ["Fly|Ride"] = 178.5, ["Neon"] = 106.2, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 294.54, ["Mega"] = 423.78, ["Mega|Ride"] = 457.52, ["Mega|Fly|Ride"] = 635.25}},
    ["rbxassetid://13936754497"] = {name = "Pinocchio", prices = {["default"] = 4.34}},
    ["rbxassetid://17059776562"] = {name = "Ankylosaurus", prices = {["default"] = 2.1, ["Ride"] = 25.52, ["Neon"] = 47.2, ["Neon|Ride"] = 163.08, ["Neon|Fly|Ride"] = 635.36, ["Mega"] = 315, ["Mega|Ride"] = 409.86, ["Mega|Fly|Ride"] = 550.72}},
    ["rbxassetid://3181727813"] = {name = "Horse", prices = {["default"] = 24.82, ["Fly"] = 26.24, ["Ride"] = 28.46, ["Fly|Ride"] = 59.07, ["Neon|Fly"] = 101818.18, ["Neon|Ride"] = 124.69, ["Neon|Fly|Ride"] = 161.97, ["Mega"] = 2118.08, ["Mega|Fly|Ride"] = 516.77}},
    ["rbxassetid://101098195340953"] = {name = "Mexican Wolf", prices = {["default"] = 2.1, ["Fly"] = 31.78, ["Ride"] = 21, ["Neon"] = 3.93, ["Neon|Ride"] = 28.7, ["Neon|Fly|Ride"] = 106.32, ["Mega"] = 93.19}},
    ["rbxassetid://13894408663"] = {name = "Seagull", prices = {["default"] = 3.93, ["Fly"] = 28.09, ["Ride"] = 21, ["Fly|Ride"] = 78.39, ["Neon"] = 49.79, ["Neon|Ride"] = 99.56, ["Mega"] = 264.48, ["Mega|Fly"] = 393.96, ["Mega|Ride"] = 203.44, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://6998403532"] = {name = "Sasquatch", prices = {["default"] = 2.1, ["Ride"] = 18.38, ["Fly|Ride"] = 62.5, ["Neon"] = 28.61, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 118.13, ["Mega|Ride"] = 124.04, ["Mega|Fly|Ride"] = 210.77}},
    ["rbxassetid://108348392849720"] = {name = "Water Opossum", prices = {["default"] = 2.1, ["Neon"] = 4.73, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 141.56, ["Mega"] = 30.18, ["Mega|Ride"] = 62.99, ["Mega|Fly|Ride"] = 204.75}},
    ["rbxassetid://11758575705"] = {name = "Moon Rabbit", prices = {["default"] = 29.3, ["Ride"] = 59.07, ["Fly|Ride"] = 99.57, ["Neon"] = 170.63, ["Neon|Ride"] = 282.75, ["Neon|Fly|Ride"] = 282.75, ["Mega"] = 1022.64, ["Mega|Ride"] = 759.94, ["Mega|Fly|Ride"] = 816.11}},
    ["rbxassetid://15922874831"] = {name = "Roadrunner", prices = {["default"] = 3.65, ["Ride"] = 70.96, ["Fly|Ride"] = 65.63, ["Neon"] = 48.75, ["Neon|Ride"] = 79.44, ["Neon|Fly|Ride"] = 211.79, ["Mega|Ride"] = 511.88, ["Mega|Fly|Ride"] = 706.38}},
    ["rbxassetid://6060988175"] = {name = "Snowman", prices = {["default"] = 7.66, ["Fly"] = 96.86, ["Ride"] = 52.96, ["Fly|Ride"] = 105, ["Neon"] = 82.69, ["Neon|Fly"] = 211.79, ["Neon|Ride"] = 84.68, ["Neon|Fly|Ride"] = 420, ["Mega"] = 328.13, ["Mega|Ride"] = 471.81, ["Mega|Fly|Ride"] = 470.54}},
    ["rbxassetid://12720029414"] = {name = "Wood Pigeon", prices = {["default"] = 52.5, ["Fly"] = 137.68, ["Ride"] = 103.69, ["Neon"] = 290.16, ["Neon|Ride"] = 393.75, ["Mega|Ride"] = 1968.75, ["Mega|Fly|Ride"] = 3066.7}},
    ["rbxassetid://136340738568203"] = {name = "Mr Whiskerpips", prices = {["default"] = 26.17, ["Ride"] = 131.25, ["Fly|Ride"] = 198.06, ["Neon"] = 164.14, ["Neon|Ride"] = 430.82, ["Neon|Fly|Ride"] = 656.25, ["Mega"] = 440.52, ["Mega|Ride"] = 462.66, ["Mega|Fly|Ride"] = 450.39}},
    ["rbxassetid://127204329704553"] = {name = "German Shepherd", prices = {["default"] = 72.01, ["Ride"] = 104.78, ["Fly|Ride"] = 205.25, ["Neon"] = 203.43, ["Neon|Ride"] = 240.48, ["Neon|Fly|Ride"] = 360, ["Mega"] = 2044.08, ["Mega|Ride"] = 980.17, ["Mega|Fly|Ride"] = 808.38}},
    ["rbxassetid://99868640713300"] = {name = "Puptune", prices = {["default"] = 42.37, ["Ride"] = 105, ["Fly|Ride"] = 162.75, ["Neon"] = 105.91, ["Neon|Ride"] = 128.78, ["Neon|Fly|Ride"] = 205.25, ["Mega"] = 351.5, ["Mega|Ride"] = 279.71, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://9993276067"] = {name = "2022 Uplift Butterfly", prices = {["default"] = 3.89, ["Fly"] = 69.5, ["Ride"] = 23.33, ["Neon"] = 59.07, ["Neon|Ride"] = 194.24, ["Neon|Fly|Ride"] = 127.09, ["Mega"] = 335, ["Mega|Ride"] = 1059.05, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://136574776317301"] = {name = "Sweetheart Rat", prices = {["default"] = 23.63, ["Ride"] = 82.69, ["Fly|Ride"] = 205.47, ["Neon"] = 105.91, ["Neon|Ride"] = 161.33, ["Neon|Fly|Ride"] = 438.38, ["Mega"] = 378.88, ["Mega|Ride"] = 346.49, ["Mega|Fly|Ride"] = 579.31}},
    ["rbxassetid://17649489402"] = {name = "Cow Calf", prices = {["default"] = 14.44, ["Ride"] = 34.13, ["Fly|Ride"] = 139.8, ["Neon"] = 188.74, ["Neon|Ride"] = 109.78, ["Mega"] = 312.42, ["Mega|Ride"] = 301.88, ["Mega|Fly|Ride"] = 351.1}},
    ["rbxassetid://77869404304609"] = {name = "Budgie Witch", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 56.35, ["Mega"] = 21, ["Mega|Fly"] = 141.92, ["Mega|Ride"] = 70.81, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://111676861947081"] = {name = "The Black Dog", prices = {["default"] = 2.5, ["Ride"] = 209.79, ["Neon"] = 14.44, ["Neon|Ride"] = 83.83, ["Mega"] = 116.68, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 314.94}},
    ["rbxassetid://13104122472"] = {name = "Borhyaena Gigantica", prices = {["default"] = 2.1, ["Ride"] = 57.21, ["Neon"] = 22.32, ["Neon|Ride"] = 106.32, ["Mega"] = 281.72, ["Mega|Ride"] = 141.92}},
    ["rbxassetid://105232492496005"] = {name = "Firefighter Gibbon", prices = {["default"] = 6.57, ["Ride"] = 31.44, ["Fly|Ride"] = 116.79, ["Neon"] = 27.57, ["Neon|Ride"] = 82.95, ["Mega"] = 123.38, ["Mega|Ride"] = 152.97, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://3409443514"] = {name = "Elephant", prices = {["default"] = 472.5, ["Ride"] = 517.37, ["Fly|Ride"] = 551.25, ["Neon"] = 2514.73, ["Neon|Ride"] = 2117.82, ["Neon|Fly|Ride"] = 1443.75, ["Mega|Fly|Ride"] = 4593.75}},
    ["rbxassetid://10137833682"] = {name = "Brown-Chested Pheasant", prices = {["default"] = 8.49, ["Fly"] = 57.2, ["Ride"] = 25.18, ["Fly|Ride"] = 63.71, ["Neon"] = 39.38, ["Neon|Ride"] = 78.33, ["Neon|Fly|Ride"] = 210, ["Mega"] = 240.41, ["Mega|Ride"] = 275.37}},
    ["rbxassetid://12490691849"] = {name = "Gecko", prices = {["default"] = 10.5, ["Fly"] = 31.86, ["Ride"] = 40.22, ["Fly|Ride"] = 84.74, ["Neon"] = 79.44, ["Neon|Fly"] = 315, ["Neon|Ride"] = 64.32, ["Mega"] = 269, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 342.51}},
    ["rbxassetid://9913459163"] = {name = "Trapdoor Snail", prices = {["default"] = 2.52, ["Fly"] = 28.61, ["Ride"] = 21.67, ["Fly|Ride"] = 141.92, ["Neon"] = 37.08, ["Neon|Ride"] = 157.76, ["Mega"] = 223.13, ["Mega|Ride"] = 354.38, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://124413732651376"] = {name = "Gumball Caterpillar", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Ride"] = 36.04, ["Fly|Ride"] = 941.48, ["Neon"] = 12.6, ["Neon|Fly"] = 70.96, ["Neon|Ride"] = 39.26, ["Neon|Fly|Ride"] = 112.35, ["Mega"] = 110.88, ["Mega|Ride"] = 106.17, ["Mega|Fly|Ride"] = 192.56}},
    ["rbxassetid://96107383056013"] = {name = "Gummy Guana", prices = {["default"] = 2.1, ["Fly"] = 70.96, ["Ride"] = 19.69, ["Neon"] = 2.63, ["Neon|Fly"] = 47.2, ["Neon|Ride"] = 19.69, ["Mega"] = 31.49, ["Mega|Fly|Ride"] = 210.67}},
    ["rbxassetid://3261465951"] = {name = "Blue Egg", prices = {["default"] = 1128.81}},
    ["rbxassetid://11245006051"] = {name = "Therapy Dog", prices = {["default"] = 9.17, ["Fly"] = 57.2, ["Ride"] = 30.18, ["Neon"] = 69.57, ["Neon|Fly"] = 141.9, ["Neon|Ride"] = 72.18, ["Mega"] = 529.53, ["Mega|Ride"] = 636.17, ["Mega|Fly|Ride"] = 896.43}},
    ["rbxassetid://76323474173289"] = {name = "Kelp Crewmate", prices = {["default"] = 2.1, ["Neon"] = 12.72, ["Neon|Ride"] = 42.37, ["Mega"] = 84.96, ["Mega|Ride"] = 141.92, ["Mega|Fly|Ride"] = 235.6}},
    ["rbxassetid://14978701264"] = {name = "Scarecrow Horse", prices = {["default"] = 2.1, ["Fly"] = 42.37, ["Ride"] = 42, ["Fly|Ride"] = 525, ["Neon"] = 9.19, ["Neon|Ride"] = 63.55, ["Neon|Fly|Ride"] = 128.63, ["Mega"] = 183.74, ["Mega|Ride"] = 152.25, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://3409443801"] = {name = "Lion", prices = {["default"] = 393.75, ["Ride"] = 415.77, ["Fly|Ride"] = 469.83, ["Neon"] = 1375.54, ["Neon|Ride"] = 1181.25, ["Neon|Fly|Ride"] = 1887.38, ["Mega|Fly|Ride"] = 6562.5}},
    ["rbxassetid://13979014954"] = {name = "Fossa", prices = {["default"] = 6.9, ["Fly"] = 196.88, ["Ride"] = 72.19, ["Neon"] = 54.02, ["Neon|Ride"] = 131.25, ["Mega"] = 422.82, ["Mega|Ride"] = 401.38}},
    ["rbxassetid://137886461285917"] = {name = "Angus Cow", prices = {["default"] = 2.1, ["Neon"] = 3.94, ["Neon|Ride"] = 52.96, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 39.38, ["Mega|Fly"] = 189, ["Mega|Ride"] = 39.38, ["Mega|Fly|Ride"] = 175.47}},
    ["rbxassetid://128343324254978"] = {name = "Blue Cat", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 2.61, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 268.98, ["Mega"] = 20.9, ["Mega|Ride"] = 149.81, ["Mega|Fly|Ride"] = 192.94}},
    ["rbxassetid://79274485636628"] = {name = "Indian Flying Fox", prices = {["default"] = 13.13, ["Fly"] = 56.27, ["Ride"] = 37.08, ["Fly|Ride"] = 141.92, ["Neon"] = 78.38, ["Neon|Ride"] = 63.71, ["Neon|Fly|Ride"] = 354.75, ["Mega"] = 328.13, ["Mega|Ride"] = 565.69, ["Mega|Fly|Ride"] = 372.75}},
    ["rbxassetid://96039704958671"] = {name = "Singularity Pisces", prices = {["default"] = 12.91, ["Ride"] = 117.96, ["Neon"] = 108.52, ["Neon|Ride"] = 141.9, ["Neon|Fly|Ride"] = 126.21, ["Mega"] = 629.87, ["Mega|Ride"] = 561.29, ["Mega|Fly|Ride"] = 1072.98}},
    ["rbxassetid://12489494348"] = {name = "Komodo Dragon", prices = {["default"] = 3.41, ["Ride"] = 19.69, ["Fly|Ride"] = 99.57, ["Neon"] = 141.74, ["Neon|Ride"] = 200.82, ["Mega"] = 582.75, ["Mega|Ride"] = 328.02, ["Mega|Fly|Ride"] = 1246.88}},
    ["rbxassetid://14360919129"] = {name = "Flaming Zebra", prices = {["default"] = 9.17, ["Ride"] = 43.32, ["Fly|Ride"] = 141.56, ["Neon"] = 127.05, ["Neon|Ride"] = 129.94, ["Neon|Fly|Ride"] = 786.75, ["Mega"] = 660.19, ["Mega|Ride"] = 565.55, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://108242367048842"] = {name = "Honey Badger", prices = {["default"] = 328.13, ["Ride"] = 341.25, ["Fly|Ride"] = 448.21, ["Neon"] = 1270.69, ["Neon|Ride"] = 1125.63, ["Neon|Fly|Ride"] = 1200.81, ["Mega"] = 3642.02, ["Mega|Ride"] = 3596.49, ["Mega|Fly|Ride"] = 3176.73}},
    ["rbxassetid://11119262646"] = {name = "Evil Chickatrice", prices = {["default"] = 4.73, ["Fly"] = 25.44, ["Ride"] = 44.63, ["Fly|Ride"] = 83.76, ["Neon"] = 68.43, ["Neon|Ride"] = 99.56, ["Neon|Fly|Ride"] = 169.57, ["Mega"] = 529.66, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 542.24}},
    ["rbxassetid://120631772928905"] = {name = "Subzero Scorpion", prices = {["default"] = 3.94, ["Ride"] = 33.91, ["Fly|Ride"] = 105, ["Neon"] = 42.37, ["Mega"] = 989.15, ["Mega|Fly|Ride"] = 1694.47}},
    ["rbxassetid://70394243440806"] = {name = "Ghostly Cat", prices = {["default"] = 11.65, ["Ride"] = 50.29, ["Fly|Ride"] = 163.11, ["Neon"] = 40.69, ["Neon|Ride"] = 98.69, ["Mega"] = 185.16, ["Mega|Ride"] = 201.9, ["Mega|Fly|Ride"] = 318.94}},
    ["rbxassetid://108186720416551"] = {name = "Storm Condor", prices = {["default"] = 2.47, ["Ride"] = 19.69, ["Fly|Ride"] = 110.88, ["Neon"] = 11.82, ["Neon|Ride"] = 45.61, ["Mega"] = 38.06, ["Mega|Ride"] = 131.34, ["Mega|Fly|Ride"] = 235.92}},
    ["rbxassetid://11181152874"] = {name = "Mule", prices = {["default"] = 48.57, ["Fly"] = 113.32, ["Ride"] = 69.47, ["Neon"] = 263.67, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 281.69, ["Mega"] = 2541.69, ["Mega|Ride"] = 989.15, ["Mega|Fly|Ride"] = 987.44}},
    ["rbxassetid://94781392732758"] = {name = "Onza", prices = {["default"] = 2.1, ["Fly"] = 589.68, ["Ride"] = 31.49, ["Fly|Ride"] = 80.07, ["Neon"] = 10.61, ["Neon|Fly"] = 156.96, ["Neon|Ride"] = 57.2, ["Neon|Fly|Ride"] = 84.73, ["Mega"] = 72.19, ["Mega|Ride"] = 95.01, ["Mega|Fly|Ride"] = 220.5}},
    ["rbxassetid://102763887893057"] = {name = "Cherub Chipmunk", prices = {["default"] = 2.1, ["Ride"] = 27.56, ["Fly|Ride"] = 148.25, ["Neon"] = 6.04, ["Neon|Fly"] = 70.96, ["Neon|Ride"] = 51.19, ["Neon|Fly|Ride"] = 140.39, ["Mega"] = 32.79, ["Mega|Fly"] = 92.15, ["Mega|Ride"] = 73.03, ["Mega|Fly|Ride"] = 160.47}},
    ["rbxassetid://104845330408668"] = {name = "Icy Porcupine", prices = {["default"] = 2.1, ["Ride"] = 57.75, ["Fly|Ride"] = 262.5, ["Neon"] = 21, ["Neon|Ride"] = 57.2, ["Neon|Fly|Ride"] = 250.43, ["Mega"] = 116.82, ["Mega|Ride"] = 185.46, ["Mega|Fly|Ride"] = 493.5}},
    ["rbxassetid://12597275903"] = {name = "White Sand Dollar", prices = {["default"] = 52.5, ["Ride"] = 105.92, ["Fly|Ride"] = 110.25, ["Neon"] = 353.69, ["Neon|Ride"] = 465.94, ["Neon|Fly|Ride"] = 692.35, ["Mega|Fly|Ride"] = 1355.82}},
    ["rbxassetid://9901393350"] = {name = "Irish Water Spaniel", prices = {["default"] = 278.25, ["Ride"] = 309.74, ["Fly|Ride"] = 360.08, ["Neon|Ride"] = 1099.87, ["Neon|Fly|Ride"] = 1072.64, ["Mega"] = 7060.57, ["Mega|Fly|Ride"] = 4331.25}},
    ["rbxassetid://128640048014369"] = {name = "River Otter", prices = {["default"] = 6.57, ["Ride"] = 42.37, ["Fly|Ride"] = 39.38, ["Neon"] = 42, ["Mega"] = 91.59, ["Mega|Ride"] = 325.14, ["Mega|Fly|Ride"] = 378}},
    ["rbxassetid://138984599254588"] = {name = "Tree Sasquatch", prices = {["default"] = 3.56, ["Neon"] = 26.25, ["Mega"] = 92.04, ["Mega|Ride"] = 600.49, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://15870220155"] = {name = "Vulture", prices = {["default"] = 3.82, ["Fly"] = 155.57, ["Ride"] = 91.88, ["Neon"] = 39.38, ["Neon|Fly|Ride"] = 158.07, ["Mega"] = 504.67, ["Mega|Ride"] = 341.25}},
    ["rbxassetid://7734902490"] = {name = "Halloween Black Mummy Cat", prices = {["default"] = 2.1, ["Fly"] = 53.23, ["Ride"] = 28.48, ["Fly|Ride"] = 49.87, ["Neon"] = 3.93, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 184.26, ["Mega"] = 51.18, ["Mega|Ride"] = 74.82, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://116677376014234"] = {name = "Sunflower Friend", prices = {["default"] = 2.1, ["Ride"] = 58.97, ["Fly|Ride"] = 282.78, ["Neon"] = 9.19, ["Mega"] = 39.37, ["Mega|Fly"] = 57.21, ["Mega|Ride"] = 206.53}},
    ["rbxassetid://13186022212"] = {name = "Grinmoire", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Ride"] = 18.38, ["Fly|Ride"] = 41.93, ["Neon"] = 6.38, ["Neon|Fly"] = 47.2, ["Neon|Ride"] = 27.56, ["Neon|Fly|Ride"] = 103.79, ["Mega"] = 57.21, ["Mega|Ride"] = 95.82, ["Mega|Fly|Ride"] = 282.78}},
    ["rbxassetid://11119263014"] = {name = "Chickatrice", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Ride"] = 24.94, ["Fly|Ride"] = 32.82, ["Neon"] = 16.86, ["Neon|Fly"] = 47.2, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 92.14, ["Mega"] = 170.63, ["Mega|Ride"] = 199.12, ["Mega|Fly|Ride"] = 433.13}},
    ["rbxassetid://13104110160"] = {name = "Blue Ringed Octopus", prices = {["default"] = 28.61, ["Fly"] = 52.5, ["Ride"] = 52.49, ["Fly|Ride"] = 83.65, ["Neon"] = 158.08, ["Neon|Ride"] = 211.79, ["Mega"] = 367.5, ["Mega|Fly"] = 446.25, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 615.57}},
    ["rbxassetid://16088265753"] = {name = "Flaming Fox", prices = {["default"] = 73.5, ["Ride"] = 98.72, ["Neon"] = 453.22, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 469.88, ["Mega"] = 3145.73, ["Mega|Ride"] = 2118.08, ["Mega|Fly|Ride"] = 1421.41}},
    ["rbxassetid://84105347355723"] = {name = "Gibbon", prices = {["default"] = 2.1, ["Ride"] = 19.69, ["Fly|Ride"] = 131.25, ["Neon"] = 5.65, ["Neon|Ride"] = 110.9, ["Neon|Fly|Ride"] = 141.9, ["Mega"] = 48.74, ["Mega|Ride"] = 97.44}},
    ["rbxassetid://9543194411"] = {name = "Swordfish", prices = {["default"] = 2.1, ["Fly"] = 16.77, ["Ride"] = 18.93, ["Fly|Ride"] = 30.15, ["Neon"] = 3.94, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 24.92, ["Neon|Fly|Ride"] = 63.08, ["Mega"] = 40.25, ["Mega|Fly"] = 131.21, ["Mega|Ride"] = 49.88, ["Mega|Fly|Ride"] = 123.38}},
    ["rbxassetid://11706157391"] = {name = "Steppe Lion", prices = {["default"] = 3.28, ["Ride"] = 42.38, ["Neon|Ride"] = 423.57, ["Neon|Fly|Ride"] = 281.69, ["Mega"] = 627.38, ["Mega|Ride"] = 352.4, ["Mega|Fly|Ride"] = 472.38}},
    ["rbxassetid://18119064023"] = {name = "Bald Eagle", prices = {["default"] = 220.89, ["Fly"] = 259.88, ["Ride"] = 423.57, ["Fly|Ride"] = 286.78, ["Neon|Ride"] = 1270.69, ["Neon|Fly|Ride"] = 1587.32, ["Mega|Fly|Ride"] = 5295.17}},
    ["rbxassetid://6060991172"] = {name = "Lynx", prices = {["default"] = 59.07, ["Fly"] = 157.5, ["Ride"] = 72.19, ["Fly|Ride"] = 137.69, ["Neon"] = 283.1, ["Neon|Ride"] = 230.05, ["Neon|Fly|Ride"] = 291.38, ["Mega"] = 986.83, ["Mega|Fly|Ride"] = 891.63}},
    ["rbxassetid://10614198346"] = {name = "Pomeranian", prices = {["default"] = 2.1, ["Ride"] = 30.19, ["Neon"] = 10.5, ["Neon|Ride"] = 42.37, ["Neon|Fly|Ride"] = 99.56, ["Mega"] = 93.19, ["Mega|Ride"] = 110.99, ["Mega|Fly|Ride"] = 218.18}},
    ["rbxassetid://13663102008"] = {name = "Angler Fish", prices = {["default"] = 2.1, ["Fly"] = 211.79, ["Ride"] = 65.63, ["Fly|Ride"] = 142.7, ["Neon"] = 21.11, ["Neon|Ride"] = 202.27, ["Mega"] = 487.17, ["Mega|Ride"] = 471.81}},
    ["rbxassetid://5067925193"] = {name = "Toy Monkey", prices = {["default"] = 51.97, ["Fly"] = 78.28, ["Ride"] = 45.94, ["Fly|Ride"] = 80.07, ["Neon|Fly|Ride"] = 254.16, ["Mega"] = 2541.69, ["Mega|Ride"] = 918.75, ["Mega|Fly|Ride"] = 1101.66}},
    ["rbxassetid://15698960105"] = {name = "Kookaburra", prices = {["default"] = 103.69, ["Ride"] = 141.57, ["Fly|Ride"] = 190.3, ["Neon"] = 426.57, ["Neon|Ride"] = 469.88, ["Neon|Fly|Ride"] = 459.38, ["Mega"] = 3107.21, ["Mega|Fly|Ride"] = 2203.31}},
    ["rbxassetid://14266900917"] = {name = "Ring-tailed Lemur", prices = {["default"] = 208.69, ["Fly"] = 277.15, ["Ride"] = 275.09, ["Fly|Ride"] = 338.9, ["Neon"] = 1058.92, ["Neon|Ride"] = 1365, ["Neon|Fly|Ride"] = 1181.25, ["Mega|Fly|Ride"] = 3248.06}},
    ["rbxassetid://10467419131"] = {name = "Leopard Cat", prices = {["default"] = 9.19, ["Ride"] = 84, ["Fly|Ride"] = 217.03, ["Neon"] = 112.88, ["Neon|Ride"] = 118.13, ["Mega"] = 388.5, ["Mega|Ride"] = 366.63, ["Mega|Fly|Ride"] = 1059.05}},
    ["rbxassetid://6498256485"] = {name = "Crab", prices = {["default"] = 2.1, ["Fly"] = 131.25, ["Ride"] = 16.94, ["Fly|Ride"] = 39.38, ["Neon"] = 7.09, ["Neon|Ride"] = 24.36, ["Neon|Fly|Ride"] = 84.73, ["Mega"] = 91.5, ["Mega|Ride"] = 104.99, ["Mega|Fly|Ride"] = 189}},
    ["rbxassetid://5721843587"] = {name = "Glyptodon", prices = {["default"] = 2.1, ["Ride"] = 23.63, ["Fly|Ride"] = 39.38, ["Neon"] = 17.07, ["Neon|Fly"] = 148.26, ["Neon|Ride"] = 40.69, ["Neon|Fly|Ride"] = 97.7, ["Mega"] = 250.79, ["Mega|Ride"] = 221.82, ["Mega|Fly|Ride"] = 276.42}},
    ["rbxassetid://13979141397"] = {name = "Giant Anteater", prices = {["default"] = 269, ["Ride"] = 284.59, ["Fly|Ride"] = 495.39, ["Neon"] = 1372.35, ["Neon|Ride"] = 1258.56, ["Neon|Fly|Ride"] = 1829.8, ["Mega|Fly|Ride"] = 6700.5}},
    ["rbxassetid://109730629255705"] = {name = "Ruddy Duck", prices = {["default"] = 2.1, ["Ride"] = 46.6, ["Neon"] = 9.19, ["Neon|Fly|Ride"] = 118125, ["Mega"] = 31.76, ["Mega|Ride"] = 110.16}},
    ["rbxassetid://6498259006"] = {name = "Clownfish", prices = {["default"] = 4.73, ["Ride"] = 19.65, ["Fly|Ride"] = 47.18, ["Neon"] = 27.15, ["Neon|Ride"] = 31.87, ["Neon|Fly|Ride"] = 85.32, ["Mega"] = 170.22, ["Mega|Ride"] = 330.43, ["Mega|Fly|Ride"] = 254.19}},
    ["rbxassetid://11758569695"] = {name = "Amami Rabbit", prices = {["default"] = 16.94, ["Ride"] = 141.9, ["Neon"] = 85.32, ["Neon|Fly"] = 282.75, ["Neon|Ride"] = 158.82, ["Neon|Fly|Ride"] = 565.47, ["Mega|Ride"] = 472.49, ["Mega|Fly|Ride"] = 741.35}},
    ["rbxassetid://11505509482"] = {name = "Ice Wolf", prices = {["default"] = 95.31, ["Fly"] = 172.62, ["Ride"] = 123.38, ["Fly|Ride"] = 131.25, ["Neon|Ride"] = 508.3, ["Neon|Fly|Ride"] = 530.78, ["Mega|Fly|Ride"] = 2202.8}},
    ["rbxassetid://9994480266"] = {name = "Royal Palace Spaniel", prices = {["default"] = 18.19, ["Fly"] = 45.05, ["Ride"] = 33.91, ["Fly|Ride"] = 53.72, ["Neon"] = 110.9, ["Neon|Ride"] = 82.69, ["Neon|Fly|Ride"] = 129.94, ["Mega"] = 706.38, ["Mega|Ride"] = 507.66, ["Mega|Fly|Ride"] = 412.13}},
    ["rbxassetid://100897154120273"] = {name = "Clumpty", prices = {["default"] = 2.1, ["Ride"] = 24.93, ["Neon"] = 2.1, ["Neon|Ride"] = 201.71, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 26.25}},
    ["rbxassetid://11108831285"] = {name = "Ocelot", prices = {["default"] = 2.1, ["Ride"] = 19.69, ["Fly|Ride"] = 52.5, ["Neon"] = 3.56, ["Neon|Fly"] = 47.2, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 69.18, ["Mega"] = 21.2, ["Mega|Fly"] = 140.38, ["Mega|Ride"] = 57.21, ["Mega|Fly|Ride"] = 103.36}},
    ["rbxassetid://99323773370664"] = {name = "Dire Wolf", prices = {["default"] = 10.5, ["Fly"] = 91.88, ["Ride"] = 52.5, ["Fly|Ride"] = 145.69, ["Neon"] = 34.13, ["Neon|Fly"] = 267.77, ["Neon|Ride"] = 72.19, ["Neon|Fly|Ride"] = 129.94, ["Mega"] = 134.35, ["Mega|Ride"] = 170.63, ["Mega|Fly|Ride"] = 313.69}},
    ["rbxassetid://17649307413"] = {name = "Mini Pig", prices = {["default"] = 1246.88, ["Ride"] = 1312.5, ["Fly|Ride"] = 1378.13, ["Neon"] = 7200.55, ["Neon|Ride"] = 7059.72, ["Neon|Fly|Ride"] = 7624.12, ["Mega|Fly|Ride"] = 12600}},
    ["rbxassetid://12720029753"] = {name = "Border Collie", prices = {["default"] = 777.53, ["Ride"] = 792.75, ["Fly|Ride"] = 960.56, ["Mega"] = 14153.95, ["Mega|Fly|Ride"] = 7084.87}},
    ["rbxassetid://4440866760"] = {name = "Pig", prices = {["default"] = 282.71, ["Fly"] = 396.04, ["Ride"] = 351.75, ["Fly|Ride"] = 421.5, ["Neon"] = 735, ["Neon|Ride"] = 682.5, ["Neon|Fly|Ride"] = 778.94, ["Mega"] = 5365.06, ["Mega|Fly|Ride"] = 2638.49}},
    ["rbxassetid://4506925854"] = {name = "Arctic Fox", prices = {["default"] = 294, ["Fly"] = 439.45, ["Ride"] = 375.62, ["Fly|Ride"] = 418.43, ["Neon"] = 1769.28, ["Neon|Fly"] = 3145.76, ["Neon|Ride"] = 939.74, ["Neon|Fly|Ride"] = 882, ["Mega|Ride"] = 3675, ["Mega|Fly|Ride"] = 3654.73}},
    ["rbxassetid://11758575618"] = {name = "Black Moon Bear", prices = {["default"] = 2.1, ["Fly"] = 80.49, ["Ride"] = 17.04, ["Fly|Ride"] = 44.62, ["Neon"] = 5.55, ["Neon|Ride"] = 32.42, ["Neon|Fly|Ride"] = 80.49, ["Mega"] = 75.25, ["Mega|Ride"] = 112.88, ["Mega|Fly|Ride"] = 144.38}},
    ["rbxassetid://15547272520"] = {name = "Christmas Pudding Pup", prices = {["default"] = 341.83, ["Fly"] = 590.62, ["Ride"] = 367.5, ["Fly|Ride"] = 492.19, ["Neon"] = 1115.63, ["Neon|Ride"] = 1048.69, ["Neon|Fly|Ride"] = 1219.32, ["Mega"] = 6354.21, ["Mega|Ride"] = 4719.84, ["Mega|Fly|Ride"] = 3937.5}},
    ["rbxassetid://78519945248690"] = {name = "Zombie Chick", prices = {["default"] = 2.63, ["Fly"] = 183.75, ["Ride"] = 27.56, ["Fly|Ride"] = 50.74, ["Neon"] = 9.19, ["Neon|Ride"] = 56.44, ["Neon|Fly|Ride"] = 113.19, ["Mega"] = 67.96, ["Mega|Ride"] = 106.32, ["Mega|Fly|Ride"] = 272.25}},
    ["rbxassetid://10357178561"] = {name = "Ibis", prices = {["default"] = 2.1, ["Fly"] = 20.35, ["Ride"] = 16.25, ["Fly|Ride"] = 49.88, ["Neon"] = 15.9, ["Neon|Ride"] = 61.69, ["Neon|Fly|Ride"] = 63, ["Mega"] = 65.63, ["Mega|Ride"] = 140.94, ["Mega|Fly|Ride"] = 314.62}},
    ["rbxassetid://96759122303055"] = {name = "Clubtail Dragonfly", prices = {["default"] = 2.1, ["Fly"] = 57.75, ["Neon"] = 3.94, ["Neon|Fly"] = 78.95, ["Neon|Ride"] = 24.36, ["Mega"] = 15.74, ["Mega|Fly"] = 63.56, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://12778628897"] = {name = "Karate Gorilla", prices = {["default"] = 39.38, ["Ride"] = 65.63, ["Fly|Ride"] = 459.38, ["Neon"] = 244.13, ["Neon|Ride"] = 314.95, ["Mega"] = 1694.47, ["Mega|Ride"] = 900.19, ["Mega|Fly|Ride"] = 943.61}},
    ["rbxassetid://13104121371"] = {name = "Poison Dart Frog", prices = {["default"] = 2.1, ["Fly"] = 65.61, ["Ride"] = 23.57, ["Fly|Ride"] = 43.32, ["Neon"] = 32.82, ["Mega"] = 328.13}},
    ["rbxassetid://71881209536633"] = {name = "Humbug", prices = {["default"] = 2.1, ["Ride"] = 55.12, ["Neon"] = 4.64, ["Neon|Fly"] = 105.95, ["Neon|Ride"] = 49.79, ["Neon|Fly|Ride"] = 95.82, ["Mega"] = 19.69, ["Mega|Fly"] = 629.87, ["Mega|Ride"] = 42.37, ["Mega|Fly|Ride"] = 308.44}},
    ["rbxassetid://11109314958"] = {name = "Ghost Wolf", prices = {["default"] = 2.1, ["Fly"] = 31.49, ["Ride"] = 23.61, ["Fly|Ride"] = 63, ["Neon"] = 7.88, ["Neon|Fly"] = 91.88, ["Neon|Ride"] = 25.43, ["Neon|Fly|Ride"] = 71.99, ["Mega"] = 56.44, ["Mega|Fly"] = 158.07, ["Mega|Ride"] = 81.38, ["Mega|Fly|Ride"] = 158.29}},
    ["rbxassetid://16088267136"] = {name = "Wildfire Hawk", prices = {["default"] = 3.83, ["Fly"] = 47.18, ["Ride"] = 28.61, ["Fly|Ride"] = 51.45, ["Neon"] = 105.91, ["Neon|Fly"] = 141.56, ["Neon|Ride"] = 70.98, ["Neon|Fly|Ride"] = 249.38, ["Mega"] = 237.57, ["Mega|Fly|Ride"] = 1019.82}},
    ["rbxassetid://16898328648"] = {name = "Preppy Capuchin Monkey", prices = {["default"] = 15.39, ["Ride"] = 52.41, ["Neon"] = 110.19, ["Mega"] = 353.93, ["Mega|Ride"] = 336.78, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://15921713413"] = {name = "Thorny Devil", prices = {["default"] = 2.1, ["Ride"] = 26.17, ["Fly|Ride"] = 87.94, ["Neon"] = 40.69, ["Neon|Ride"] = 63.61, ["Neon|Fly|Ride"] = 707.73, ["Mega"] = 350.56, ["Mega|Ride"] = 471.81, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://16441364976"] = {name = "Gold Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 16.44, ["Ride"] = 19.07, ["Fly|Ride"] = 57.21, ["Neon"] = 5.24, ["Neon|Ride"] = 47.11, ["Mega"] = 40.69, ["Mega|Ride"] = 57.21, ["Mega|Fly|Ride"] = 317.72}},
    ["rbxassetid://8077189117"] = {name = "Puffin", prices = {["default"] = 190.32, ["Fly"] = 296.51, ["Ride"] = 239.22, ["Fly|Ride"] = 347.82, ["Neon"] = 786.75, ["Neon|Ride"] = 1374.48, ["Neon|Fly|Ride"] = 1050, ["Mega"] = 10590.32, ["Mega|Fly|Ride"] = 4434.18}},
    ["rbxassetid://8663441120"] = {name = "Lunar Tiger", prices = {["default"] = 2.1, ["Fly"] = 36.02, ["Ride"] = 18.96, ["Fly|Ride"] = 31.86, ["Neon"] = 4.13, ["Neon|Ride"] = 23.62, ["Neon|Fly|Ride"] = 44.07, ["Mega"] = 38.15, ["Mega|Ride"] = 64.51, ["Mega|Fly|Ride"] = 118.13}},
    ["rbxassetid://17174216294"] = {name = "Skunk", prices = {["default"] = 9.43, ["Ride"] = 98.44, ["Fly|Ride"] = 236.25, ["Neon"] = 64.32, ["Neon|Ride"] = 104.41, ["Mega"] = 300.04, ["Mega|Ride"] = 348.02, ["Mega|Fly|Ride"] = 629.87}},
    ["rbxassetid://13981141292"] = {name = "Kiwi", prices = {["default"] = 39.29, ["Ride"] = 133.53, ["Fly|Ride"] = 141.92, ["Neon"] = 187.03, ["Neon|Ride"] = 231.91, ["Mega"] = 721.88, ["Mega|Ride"] = 741.35, ["Mega|Fly|Ride"] = 814.51}},
    ["rbxassetid://3409443617"] = {name = "Meerkat", prices = {["default"] = 178.5, ["Ride"] = 220.5, ["Fly|Ride"] = 292.69, ["Neon"] = 836.55, ["Neon|Ride"] = 649.69, ["Neon|Fly|Ride"] = 817, ["Mega|Fly|Ride"] = 3022.49}},
    ["rbxassetid://99042906016947"] = {name = "Seafoam Butterfly", prices = {["default"] = 19.51, ["Neon"] = 82.69, ["Mega"] = 281.54, ["Mega|Ride"] = 406.88, ["Mega|Fly|Ride"] = 706.38}},
    ["rbxassetid://15504847683"] = {name = "Gingerbread Hare", prices = {["default"] = 26.17, ["Ride"] = 279.57, ["Fly|Ride"] = 154.88, ["Neon"] = 169.32, ["Neon|Ride"] = 635.36, ["Neon|Fly|Ride"] = 847.14, ["Mega"] = 1415.4, ["Mega|Fly|Ride"] = 2118.08}},
    ["rbxassetid://15302316802"] = {name = "Peppermint Penguin", prices = {["default"] = 975.19, ["Fly"] = 1441.13, ["Ride"] = 1048.69, ["Fly|Ride"] = 1180.2, ["Neon|Ride"] = 4362.69, ["Neon|Fly|Ride"] = 4160.13, ["Mega|Fly|Ride"] = 18244.44}},
    ["rbxassetid://10318106124"] = {name = "Scarlet Butterfly", prices = {["default"] = 8.28, ["Fly"] = 28.32, ["Ride"] = 21, ["Fly|Ride"] = 63, ["Neon"] = 22.32, ["Neon|Fly"] = 111.57, ["Neon|Ride"] = 63.71, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 211.76, ["Mega|Ride"] = 238.3, ["Mega|Fly|Ride"] = 534.98}},
    ["rbxassetid://14145989411"] = {name = "Toy Poodle", prices = {["default"] = 3.93, ["Fly"] = 39.38, ["Ride"] = 35.44, ["Neon"] = 42.37, ["Neon|Ride"] = 141.9, ["Neon|Fly|Ride"] = 144.74, ["Mega"] = 212.63, ["Mega|Ride"] = 217.88, ["Mega|Fly|Ride"] = 454.32}},
    ["rbxassetid://82833859118891"] = {name = "Snowy Mammoth", prices = {["default"] = 3.68, ["Ride"] = 39.38, ["Fly|Ride"] = 942.38, ["Neon"] = 35.38, ["Neon|Ride"] = 79.04, ["Mega"] = 141.72, ["Mega|Ride"] = 296.63, ["Mega|Fly|Ride"] = 629.87}},
    ["rbxassetid://12917346501"] = {name = "Happy Duckling", prices = {["default"] = 15.44, ["Fly"] = 706.3, ["Ride"] = 39.38, ["Fly|Ride"] = 97.19, ["Neon"] = 84.73, ["Neon|Ride"] = 98.98, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 373.2, ["Mega|Ride"] = 376.84, ["Mega|Fly|Ride"] = 418.69}},
    ["rbxassetid://7064993901"] = {name = "2021 Uplift Butterfly", prices = {["default"] = 2.1, ["Fly"] = 28.62, ["Ride"] = 21.19, ["Fly|Ride"] = 47.11, ["Neon"] = 22.32, ["Neon|Fly"] = 57.2, ["Neon|Ride"] = 31.49, ["Neon|Fly|Ride"] = 84.73, ["Mega|Ride"] = 102.37, ["Mega|Fly|Ride"] = 206.26}},
    ["rbxassetid://10926054144"] = {name = "Slug", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 52.5, ["Neon"] = 13.13, ["Neon|Fly"] = 13125, ["Neon|Ride"] = 53.73, ["Neon|Fly|Ride"] = 847.14, ["Mega"] = 233.24, ["Mega|Ride"] = 137.45, ["Mega|Fly|Ride"] = 367.49}},
    ["rbxassetid://11571113906"] = {name = "Glacier Moth", prices = {["default"] = 168, ["Ride"] = 333.38, ["Fly|Ride"] = 565.55, ["Neon|Ride"] = 1553.43, ["Neon|Fly|Ride"] = 1456, ["Mega|Fly|Ride"] = 4236.14}},
    ["rbxassetid://73641371341710"] = {name = "Ice Cube", prices = {["default"] = 2.1, ["Ride"] = 45.55, ["Fly|Ride"] = 54.26, ["Neon"] = 10.5, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 41.89, ["Neon|Fly|Ride"] = 139.79, ["Mega"] = 111.45, ["Mega|Ride"] = 269, ["Mega|Fly|Ride"] = 235.94}},
    ["rbxassetid://13077767764"] = {name = "Eel", prices = {["default"] = 3.94, ["Neon"] = 21, ["Neon|Ride"] = 313.69, ["Mega"] = 278.64, ["Mega|Ride"] = 267.25}},
    ["rbxassetid://134995672989153"] = {name = "Hammerhead Shark", prices = {["default"] = 3.82, ["Fly"] = 58.2, ["Ride"] = 34.13, ["Neon"] = 20.22, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 207.18, ["Mega"] = 85.31, ["Mega|Fly"] = 423.63, ["Mega|Ride"] = 163.11, ["Mega|Fly|Ride"] = 348.48}},
    ["rbxassetid://15555939727"] = {name = "Snow Monkey", prices = {["default"] = 177.19, ["Fly"] = 354.9, ["Ride"] = 255.82, ["Fly|Ride"] = 565.55, ["Neon"] = 640.5, ["Neon|Ride"] = 766.66, ["Neon|Fly|Ride"] = 918.75, ["Mega|Ride"] = 5083.37, ["Mega|Fly|Ride"] = 1836.19}},
    ["rbxassetid://11758575992"] = {name = "Water Rabbit", prices = {["default"] = 21.95, ["Fly"] = 61.62, ["Ride"] = 141.92, ["Fly|Ride"] = 158.82, ["Neon"] = 141.75, ["Neon|Fly|Ride"] = 282.75, ["Mega"] = 563.41, ["Mega|Ride"] = 736.04, ["Mega|Fly|Ride"] = 769.27}},
    ["rbxassetid://90987982535884"] = {name = "Great Pyrenees", prices = {["default"] = 18.38, ["Ride"] = 63.71, ["Fly|Ride"] = 1270.85, ["Neon"] = 103.69, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 275.34, ["Mega"] = 550.72, ["Mega|Ride"] = 420, ["Mega|Fly|Ride"] = 538.13}},
    ["rbxassetid://84560154336174"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Fly"] = 45.94, ["Ride"] = 19.69, ["Neon"] = 3.92, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 35.44, ["Mega"] = 34.13, ["Mega|Ride"] = 76.27, ["Mega|Fly|Ride"] = 261.19}},
    ["rbxassetid://4506847061"] = {name = "Reindeer", prices = {["default"] = 63.72, ["Fly"] = 99.86, ["Ride"] = 110.25, ["Fly|Ride"] = 262.65, ["Neon"] = 321.46, ["Neon|Fly"] = 381.22, ["Neon|Ride"] = 376.98, ["Neon|Fly|Ride"] = 353.91, ["Mega|Fly|Ride"] = 1115.63}},
    ["rbxassetid://98687388677942"] = {name = "Moonpine", prices = {["default"] = 2.1, ["Ride"] = 20.14, ["Neon"] = 3.94, ["Neon|Ride"] = 23.61, ["Neon|Fly|Ride"] = 588, ["Mega"] = 40.69}},
    ["rbxassetid://11109032702"] = {name = "Green Amazon", prices = {["default"] = 18.36, ["Fly"] = 65.63, ["Ride"] = 31.4, ["Fly|Ride"] = 126.04, ["Neon"] = 57.2, ["Neon|Ride"] = 110.15, ["Neon|Fly|Ride"] = 141.56, ["Mega"] = 380.63, ["Mega|Ride"] = 389.74, ["Mega|Fly|Ride"] = 361.74}},
    ["rbxassetid://3743730108"] = {name = "Black Panther", prices = {["default"] = 49.7, ["Fly"] = 80.01, ["Ride"] = 85.32, ["Neon"] = 239.46, ["Neon|Ride"] = 238.87, ["Neon|Fly|Ride"] = 354.38, ["Mega|Ride"] = 1234.85, ["Mega|Fly|Ride"] = 1256.07}},
    ["rbxassetid://3181727398"] = {name = "Chocolate Labrador", prices = {["default"] = 2.1, ["Fly"] = 28.61, ["Ride"] = 12.71, ["Fly|Ride"] = 31.86, ["Neon"] = 2.1, ["Neon|Fly"] = 28.32, ["Neon|Ride"] = 17.71, ["Neon|Fly|Ride"] = 38.15, ["Mega"] = 19.69, ["Mega|Fly"] = 55.13, ["Mega|Ride"] = 39.38, ["Mega|Fly|Ride"] = 83.74}},
    ["rbxassetid://134636987874448"] = {name = "Nebula Snake", prices = {["default"] = 2.63, ["Ride"] = 32.18, ["Fly|Ride"] = 1346.58, ["Neon"] = 17.46, ["Neon|Ride"] = 63.71, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 157.5, ["Mega|Ride"] = 198.06, ["Mega|Fly|Ride"] = 523.69}},
    ["rbxassetid://13104122150"] = {name = "Hippo", prices = {["default"] = 18.38, ["Ride"] = 56.44, ["Neon"] = 150.94, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 211.79, ["Neon|Fly|Ride"] = 629.88, ["Mega"] = 702.16, ["Mega|Ride"] = 650.26, ["Mega|Fly|Ride"] = 626.33}},
    ["rbxassetid://103821295208934"] = {name = "Black Rhino", prices = {["default"] = 2.1, ["Ride"] = 26.76, ["Neon"] = 2.63, ["Neon|Ride"] = 28.61, ["Neon|Fly|Ride"] = 137.68, ["Mega"] = 31.79, ["Mega|Ride"] = 78.65, ["Mega|Fly|Ride"] = 310.42}},
    ["rbxassetid://14782580070"] = {name = "Undead Elk", prices = {["default"] = 3.82, ["Fly"] = 210, ["Ride"] = 28.62, ["Fly|Ride"] = 79.04, ["Neon"] = 61.32, ["Neon|Ride"] = 127.09, ["Neon|Fly|Ride"] = 216.03, ["Mega"] = 405.62, ["Mega|Fly"] = 787.5, ["Mega|Ride"] = 216.49, ["Mega|Fly|Ride"] = 387.01}},
    ["rbxassetid://8566683782"] = {name = "Giant Blue Scarab", prices = {["default"] = 15.63, ["Fly"] = 42.37, ["Ride"] = 28.61, ["Fly|Ride"] = 63.71, ["Neon"] = 117.03, ["Neon|Ride"] = 64.56, ["Neon|Fly|Ride"] = 328.13, ["Mega|Ride"] = 442.7, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://14850232913"] = {name = "Cute-A-Cabra", prices = {["default"] = 2.1, ["Ride"] = 58.97, ["Neon"] = 37, ["Neon|Fly"] = 699.57, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 200.82, ["Mega"] = 169.32, ["Mega|Ride"] = 168.61, ["Mega|Fly|Ride"] = 291.24}},
    ["rbxassetid://15508248825"] = {name = "Eggnog Dog", prices = {["default"] = 18.27, ["Fly"] = 2117.82, ["Ride"] = 99.56, ["Neon"] = 118.13, ["Neon|Ride"] = 423.57, ["Neon|Fly|Ride"] = 6290.34, ["Mega"] = 459.12, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 987.67}},
    ["rbxassetid://17822797244"] = {name = "Orange Betta Fish", prices = {["default"] = 2.1, ["Ride"] = 125.58, ["Fly|Ride"] = 196.87, ["Neon"] = 7.56, ["Neon|Fly"] = 49.79, ["Neon|Ride"] = 99.56, ["Neon|Fly|Ride"] = 99.08, ["Mega"] = 74.82, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 158.07, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://9922274393"] = {name = "Retired Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://103431939950304"] = {name = "Pink Dog", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 42.37, ["Mega"] = 21, ["Mega|Ride"] = 135.63, ["Mega|Fly|Ride"] = 423.63}},
    ["rbxassetid://15227882502"] = {name = "Christmas Future Egg", prices = {["default"] = 31.29}},
    ["rbxassetid://12597276740"] = {name = "Red Sand Dollar", prices = {["default"] = 59.07, ["Fly"] = 102.38, ["Ride"] = 65.63, ["Fly|Ride"] = 206.53, ["Neon"] = 1050, ["Neon|Ride"] = 282.75, ["Neon|Fly|Ride"] = 1058.92, ["Mega"] = 1116.24, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 703.88}},
    ["rbxassetid://136447612467002"] = {name = "Glyptodon Ducky", prices = {["default"] = 2.1, ["Ride"] = 81.38, ["Fly|Ride"] = 131.25, ["Neon"] = 3.93, ["Mega"] = 23.29, ["Mega|Fly"] = 137.82, ["Mega|Ride"] = 99.6, ["Mega|Fly|Ride"] = 116.82}},
    ["rbxassetid://101033810950061"] = {name = "Sea Slug", prices = {["default"] = 551.25, ["Ride"] = 577.47, ["Fly|Ride"] = 645.19, ["Neon"] = 2625, ["Neon|Ride"] = 2397.36, ["Neon|Fly|Ride"] = 2400.55, ["Mega"] = 16944.51, ["Mega|Fly|Ride"] = 10590.32}},
    ["rbxassetid://14353536658"] = {name = "Birthday Butterfly 2023", prices = {["default"] = 3.68, ["Fly"] = 26.25, ["Ride"] = 42.33, ["Fly|Ride"] = 78.39, ["Neon"] = 32.82, ["Neon|Ride"] = 104.85, ["Mega"] = 84.74, ["Mega|Ride"] = 141.92, ["Mega|Fly|Ride"] = 565.85}},
    ["rbxassetid://9938967851"] = {name = "Tan Chow-Chow", prices = {["default"] = 3.93, ["Fly"] = 158.05, ["Ride"] = 23.25, ["Fly|Ride"] = 52.5, ["Neon"] = 22.32, ["Neon|Ride"] = 33.91, ["Neon|Fly|Ride"] = 84.95, ["Mega"] = 282.78, ["Mega|Ride"] = 158.05, ["Mega|Fly|Ride"] = 187.69}},
    ["rbxassetid://14448124117"] = {name = "Chipmunk", prices = {["default"] = 23.63, ["Ride"] = 28.62, ["Fly|Ride"] = 106.31, ["Neon"] = 155.33, ["Neon|Ride"] = 181.13, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 501.99, ["Mega|Fly|Ride"] = 1046.33}},
    ["rbxassetid://13104108894"] = {name = "Lammergeier", prices = {["default"] = 3.81, ["Fly"] = 39.38, ["Ride"] = 31.5, ["Fly|Ride"] = 141.92, ["Neon"] = 40.69, ["Mega"] = 294}},
    ["rbxassetid://14446659851"] = {name = "Raccoon", prices = {["default"] = 13.02, ["Ride"] = 206.07, ["Fly|Ride"] = 157.49, ["Neon"] = 167.27, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 350.44, ["Mega"] = 363.57, ["Mega|Ride"] = 373.73, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://84477079324217"] = {name = "Peachick", prices = {["default"] = 6.57, ["Fly"] = 97.64, ["Ride"] = 31.86, ["Fly|Ride"] = 847.24, ["Neon"] = 31.86, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 284.82, ["Mega"] = 215.25, ["Mega|Fly"] = 489.28, ["Mega|Ride"] = 195.57, ["Mega|Fly|Ride"] = 333.61}},
    ["rbxassetid://9718162456"] = {name = "Donkey", prices = {["default"] = 2.1, ["Fly"] = 27.56, ["Ride"] = 15.9, ["Fly|Ride"] = 32.82, ["Neon"] = 2.1, ["Neon|Fly"] = 28.61, ["Neon|Ride"] = 19.07, ["Neon|Fly|Ride"] = 32.71, ["Mega"] = 16.42, ["Mega|Ride"] = 41.32, ["Mega|Fly|Ride"] = 91.88}},
    ["rbxassetid://93800993117604"] = {name = "Love Bird", prices = {["default"] = 6.35, ["Ride"] = 32.82, ["Fly|Ride"] = 157.94, ["Neon"] = 34.04, ["Neon|Ride"] = 87.94, ["Neon|Fly|Ride"] = 317.69, ["Mega"] = 167.88, ["Mega|Ride"] = 217.88, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://13665143675"] = {name = "Lion Cub", prices = {["default"] = 276.94, ["Ride"] = 307.39, ["Fly|Ride"] = 393.75, ["Neon"] = 1480.5, ["Neon|Ride"] = 1181.25, ["Neon|Fly|Ride"] = 1391.25, ["Mega|Fly|Ride"] = 3750.48}},
    ["rbxassetid://13883284001"] = {name = "Ice Cream Hermit Crab", prices = {["default"] = 103.68, ["Fly"] = 156.73, ["Ride"] = 137.27, ["Fly|Ride"] = 294.88, ["Neon"] = 471.81, ["Neon|Ride"] = 667.63, ["Neon|Fly|Ride"] = 698.25, ["Mega"] = 4236.14, ["Mega|Ride"] = 2118.08, ["Mega|Fly|Ride"] = 1502.8}},
    ["rbxassetid://8938701212"] = {name = "Woodpecker", prices = {["default"] = 2.1, ["Fly"] = 23.31, ["Ride"] = 22.42, ["Fly|Ride"] = 39.37, ["Neon"] = 9.17, ["Neon|Ride"] = 33.53, ["Neon|Fly|Ride"] = 62.67, ["Mega|Fly"] = 210.77, ["Mega|Ride"] = 92.15, ["Mega|Fly|Ride"] = 141.99}},
    ["rbxassetid://4800190034"] = {name = "Toucan", prices = {["default"] = 2.1, ["Fly"] = 18.38, ["Ride"] = 15.8, ["Fly|Ride"] = 31.79, ["Neon"] = 9.08, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 27.56, ["Neon|Fly|Ride"] = 70.79, ["Mega"] = 78.75, ["Mega|Fly"] = 353.74, ["Mega|Ride"] = 93.19, ["Mega|Fly|Ride"] = 156.19}},
    ["rbxassetid://15886122789"] = {name = "Deathstalker Scorpion", prices = {["default"] = 4.72, ["Ride"] = 18.38, ["Fly|Ride"] = 98.44, ["Neon"] = 39.38, ["Mega"] = 1130}},
    ["rbxassetid://12139402705"] = {name = "Sheeeeep", prices = {["default"] = 231, ["Ride"] = 275.63, ["Fly|Ride"] = 353.74, ["Neon|Ride"] = 1834.38, ["Neon|Fly|Ride"] = 1792.87, ["Mega|Ride"] = 8472.27, ["Mega|Fly|Ride"] = 3648.75}},
    ["rbxassetid://7126720389"] = {name = "Hydra", prices = {["default"] = 2.1, ["Fly"] = 22.32, ["Ride"] = 15.9, ["Fly|Ride"] = 31.76, ["Neon"] = 11.81, ["Neon|Fly"] = 158.07, ["Neon|Ride"] = 33.91, ["Neon|Fly|Ride"] = 92.14, ["Mega"] = 353.74, ["Mega|Ride"] = 244.64, ["Mega|Fly|Ride"] = 258.81}},
    ["rbxassetid://17662289865"] = {name = "Punk Pony", prices = {["default"] = 4.14, ["Fly"] = 141.54, ["Ride"] = 40.11, ["Fly|Ride"] = 211.82, ["Neon"] = 31.5, ["Neon|Ride"] = 35.43, ["Mega"] = 251.35, ["Mega|Ride"] = 236.24, ["Mega|Fly|Ride"] = 301.88}},
    ["rbxassetid://84009422958505"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 91.88, ["Neon"] = 5.25, ["Neon|Ride"] = 30.31, ["Neon|Fly|Ride"] = 85.32, ["Mega"] = 40.69, ["Mega|Ride"] = 95.7, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://9473352533"] = {name = "Space Whale", prices = {["default"] = 21, ["Fly"] = 70.96, ["Ride"] = 27.57, ["Fly|Ride"] = 59.07, ["Neon"] = 87.05, ["Neon|Ride"] = 99.56, ["Neon|Fly|Ride"] = 180.03, ["Mega"] = 761.15, ["Mega|Ride"] = 422.69, ["Mega|Fly|Ride"] = 422.1}},
    ["rbxassetid://71528203783155"] = {name = "Pupcake", prices = {["default"] = 65.09, ["Ride"] = 113.33, ["Fly|Ride"] = 225.06, ["Neon"] = 124.69, ["Neon|Fly"] = 393.75, ["Neon|Ride"] = 165.81, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 450.19, ["Mega|Fly"] = 2223.98, ["Mega|Ride"] = 505.75, ["Mega|Fly|Ride"] = 556.78}},
    ["rbxassetid://4440867010"] = {name = "Drake", prices = {["default"] = 24.94, ["Fly"] = 63.71, ["Ride"] = 43.32, ["Fly|Ride"] = 92.03, ["Neon"] = 131.25, ["Neon|Fly"] = 290.07, ["Neon|Ride"] = 149.39, ["Neon|Fly|Ride"] = 219.19, ["Mega|Ride"] = 783.12, ["Mega|Fly|Ride"] = 740.28}},
    ["rbxassetid://9708962205"] = {name = "Parakeet", prices = {["default"] = 2.1, ["Fly"] = 15.91, ["Ride"] = 16.96, ["Fly|Ride"] = 49.81, ["Neon"] = 2.1, ["Neon|Fly"] = 23.63, ["Neon|Ride"] = 20.14, ["Neon|Fly|Ride"] = 61.62, ["Mega"] = 23.31, ["Mega|Fly"] = 28.88, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 115.5}},
    ["rbxassetid://4883302468"] = {name = "Shrew", prices = {["default"] = 194.25, ["Fly"] = 278.24, ["Ride"] = 242.82, ["Fly|Ride"] = 339.94, ["Neon"] = 1088.27, ["Neon|Ride"] = 958.13, ["Neon|Fly|Ride"] = 1158.46, ["Mega"] = 4129.17, ["Mega|Fly|Ride"] = 4162.01}},
    ["rbxassetid://11507151679"] = {name = "Irish Elk", prices = {["default"] = 12.79, ["Fly"] = 140.39, ["Ride"] = 41.45, ["Neon"] = 111.57, ["Neon|Ride"] = 188.25, ["Neon|Fly|Ride"] = 210, ["Mega"] = 783.7, ["Mega|Ride"] = 589.77, ["Mega|Fly|Ride"] = 587.35}},
    ["rbxassetid://17163957321"] = {name = "Blue Jay", prices = {["default"] = 2.1, ["Ride"] = 18.38, ["Fly|Ride"] = 39.38, ["Neon"] = 6.57, ["Neon|Ride"] = 31.86, ["Mega"] = 62.48, ["Mega|Ride"] = 99.58, ["Mega|Fly|Ride"] = 79.06}},
    ["rbxassetid://8705079225"] = {name = "Abyssinian Cat", prices = {["default"] = 2.1, ["Fly"] = 27.56, ["Ride"] = 47.19, ["Fly|Ride"] = 56.9, ["Neon"] = 3.42, ["Neon|Fly"] = 47.2, ["Neon|Ride"] = 21.3, ["Neon|Fly|Ride"] = 97.23, ["Mega"] = 25.6, ["Mega|Fly"] = 141.56, ["Mega|Ride"] = 52.97, ["Mega|Fly|Ride"] = 93.45}},
    ["rbxassetid://17059483392"] = {name = "Velociraptor", prices = {["default"] = 2.1, ["Ride"] = 23.56, ["Fly|Ride"] = 141.75, ["Neon"] = 6.57, ["Neon|Ride"] = 42.37, ["Neon|Fly|Ride"] = 7060.57, ["Mega"] = 92.93, ["Mega|Ride"] = 174.57, ["Mega|Fly|Ride"] = 353.74}},
    ["rbxassetid://16548686870"] = {name = "Hamster", prices = {["default"] = 12.89, ["Fly"] = 65.63, ["Ride"] = 27.57, ["Fly|Ride"] = 68.25, ["Neon"] = 49.88, ["Neon|Ride"] = 63, ["Neon|Fly|Ride"] = 80.07, ["Mega"] = 356.22, ["Mega|Ride"] = 315.15, ["Mega|Fly|Ride"] = 343.59}},
    ["rbxassetid://13883285383"] = {name = "Castle Hermit Crab", prices = {["default"] = 7.66, ["Neon"] = 53.91, ["Neon|Ride"] = 70.96, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 223.13, ["Mega|Ride"] = 300.79}},
    ["rbxassetid://82240382561696"] = {name = "Cocoadile", prices = {["default"] = 2.1, ["Ride"] = 63.71, ["Neon"] = 3.81, ["Neon|Ride"] = 42.37, ["Mega"] = 19.69, ["Mega|Ride"] = 73.5, ["Mega|Fly|Ride"] = 282.78}},
    ["rbxassetid://74702714943302"] = {name = "Grave Owl", prices = {["default"] = 8.81, ["Ride"] = 27.57, ["Fly|Ride"] = 84.74, ["Neon"] = 24.36, ["Neon|Fly"] = 102.92, ["Neon|Ride"] = 52.98, ["Neon|Fly|Ride"] = 124.68, ["Mega"] = 156.53, ["Mega|Fly"] = 211.82, ["Mega|Ride"] = 141.92, ["Mega|Fly|Ride"] = 283.4}},
    ["rbxassetid://97556530589327"] = {name = "Bison", prices = {["default"] = 2.1, ["Ride"] = 127.09, ["Fly|Ride"] = 99.57, ["Neon"] = 6.25, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 158.07, ["Mega"] = 34.12, ["Mega|Ride"] = 91.34, ["Mega|Fly|Ride"] = 629.9}},
    ["rbxassetid://11694855214"] = {name = "Shetland Pony Dark Brown", prices = {["default"] = 2.1, ["Fly"] = 24.62, ["Ride"] = 18.38, ["Fly|Ride"] = 59.07, ["Neon"] = 6.09, ["Neon|Ride"] = 26.57, ["Neon|Fly|Ride"] = 117.56, ["Mega"] = 69.91, ["Mega|Ride"] = 56.11, ["Mega|Fly|Ride"] = 161.69}},
    ["rbxassetid://14398823196"] = {name = "Alpaca", prices = {["default"] = 746.03, ["Ride"] = 745.5, ["Fly|Ride"] = 1050, ["Neon|Fly|Ride"] = 4966.28, ["Mega|Fly|Ride"] = 14831.15}},
    ["rbxassetid://5721843716"] = {name = "Pterodactyl", prices = {["default"] = 2.1, ["Fly"] = 23.61, ["Ride"] = 15.74, ["Fly|Ride"] = 32.81, ["Neon"] = 23.12, ["Neon|Fly"] = 44.61, ["Neon|Ride"] = 57.2, ["Neon|Fly|Ride"] = 56.59, ["Mega"] = 189.58, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://82057257613990"] = {name = "Unicorn Ducky", prices = {["default"] = 2.1, ["Ride"] = 69.91, ["Fly|Ride"] = 99.57, ["Neon"] = 10.45, ["Neon|Fly"] = 847.14, ["Neon|Ride"] = 84, ["Neon|Fly|Ride"] = 164.07, ["Mega"] = 47.25, ["Mega|Ride"] = 106.32, ["Mega|Fly|Ride"] = 227.73}},
    ["rbxassetid://4708551366"] = {name = "Frog", prices = {["default"] = 7.87, ["Fly"] = 28.61, ["Ride"] = 21, ["Fly|Ride"] = 45, ["Neon"] = 44.63, ["Neon|Fly"] = 112.74, ["Neon|Ride"] = 47.18, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 328.13, ["Mega|Ride"] = 293.47, ["Mega|Fly|Ride"] = 325.34}},
    ["rbxassetid://4800189682"] = {name = "Starfish", prices = {["default"] = 2.1, ["Fly"] = 14.44, ["Ride"] = 16.96, ["Fly|Ride"] = 32.82, ["Neon"] = 7.88, ["Neon|Fly"] = 91.86, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 61.69, ["Mega|Fly"] = 349.84, ["Mega|Ride"] = 96.76, ["Mega|Fly|Ride"] = 169.47}},
    ["rbxassetid://16736753854"] = {name = "Candy Cane Snail", prices = {["default"] = 67.78, ["Ride"] = 49.79, ["Neon"] = 312.39, ["Neon|Ride"] = 341.25, ["Mega"] = 896.44}},
    ["rbxassetid://10393730410"] = {name = "Orca", prices = {["default"] = 2.1, ["Fly"] = 129.94, ["Ride"] = 28.88, ["Fly|Ride"] = 706.38, ["Neon"] = 5.25, ["Neon|Ride"] = 106.17, ["Neon|Fly|Ride"] = 206.07, ["Mega"] = 63.67, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 348.48}},
    ["rbxassetid://111642509798043"] = {name = "Toxic Kaijunior", prices = {["default"] = 3.94, ["Fly"] = 73.5, ["Ride"] = 22.5, ["Fly|Ride"] = 61.44, ["Neon"] = 14.12, ["Neon|Fly"] = 141.56, ["Neon|Ride"] = 42.37, ["Neon|Fly|Ride"] = 453.22, ["Mega"] = 82.6, ["Mega|Ride"] = 296.55, ["Mega|Fly|Ride"] = 144.38}},
    ["rbxassetid://14146181621"] = {name = "Tawny Frogmouth", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Fly|Ride"] = 65.76, ["Neon"] = 15.73, ["Mega"] = 112.23, ["Mega|Fly"] = 282.78}},
    ["rbxassetid://9474010501"] = {name = "Ribbon Seal", prices = {["default"] = 2.1, ["Fly"] = 2593.49, ["Ride"] = 20.08, ["Fly|Ride"] = 98.44, ["Neon"] = 3.93, ["Neon|Ride"] = 23.61, ["Neon|Fly|Ride"] = 94.37, ["Mega"] = 38.06, ["Mega|Fly"] = 157.5, ["Mega|Ride"] = 59.06, ["Mega|Fly|Ride"] = 127.16}},
    ["rbxassetid://6776872152"] = {name = "Red Squirrel", prices = {["default"] = 19.59, ["Fly"] = 37.74, ["Ride"] = 19.69, ["Fly|Ride"] = 30.19, ["Neon"] = 137.82, ["Neon|Ride"] = 104.85, ["Neon|Fly|Ride"] = 110.25, ["Mega"] = 847.24, ["Mega|Ride"] = 528.47, ["Mega|Fly|Ride"] = 444.81}},
    ["rbxassetid://84140820920420"] = {name = "Siamese Cat", prices = {["default"] = 735, ["Ride"] = 715.32, ["Fly|Ride"] = 858.38, ["Neon"] = 2099.99, ["Neon|Ride"] = 2203.34, ["Neon|Fly|Ride"] = 1998.94, ["Mega"] = 8292.01, ["Mega|Ride"] = 5184.38, ["Mega|Fly|Ride"] = 5248.2}},
    ["rbxassetid://3181727773"] = {name = "Bunny", prices = {["default"] = 2.1, ["Fly"] = 24.36, ["Ride"] = 19.06, ["Fly|Ride"] = 41.01, ["Neon"] = 6.17, ["Neon|Fly"] = 28.35, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 67.78, ["Mega"] = 52.49, ["Mega|Ride"] = 77.44, ["Mega|Fly|Ride"] = 140.44}},
    ["rbxassetid://17120012859"] = {name = "Praying Mantis", prices = {["default"] = 6.5, ["Ride"] = 37.08, ["Fly|Ride"] = 92.18, ["Neon"] = 56.44, ["Neon|Ride"] = 57.75, ["Neon|Fly|Ride"] = 248.11, ["Mega"] = 209.7, ["Mega|Ride"] = 351.75, ["Mega|Fly|Ride"] = 441}},
    ["rbxassetid://4440866528"] = {name = "Turkey", prices = {["default"] = 59.07, ["Fly"] = 105.91, ["Ride"] = 85.32, ["Fly|Ride"] = 128.08, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 833.47, ["Mega"] = 2824.45, ["Mega|Fly|Ride"] = 2231.25}},
    ["rbxassetid://9287841987"] = {name = "Black Springer Spaniel", prices = {["default"] = 43.32, ["Ride"] = 90.57, ["Fly|Ride"] = 70.97, ["Neon"] = 196.88, ["Neon|Ride"] = 177.19, ["Neon|Fly|Ride"] = 198.17, ["Mega"] = 921.37, ["Mega|Ride"] = 839.99, ["Mega|Fly|Ride"] = 994.45}},
    ["rbxassetid://87613898139280"] = {name = "Ranger Beaver", prices = {["default"] = 15.74, ["Ride"] = 45.94, ["Neon"] = 79.04, ["Neon|Ride"] = 169.44, ["Neon|Fly|Ride"] = 282.78, ["Mega"] = 317.72, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 565.55}},
    ["rbxassetid://88389663444803"] = {name = "Mirai Moth", prices = {["default"] = 36.75, ["Neon"] = 79.48, ["Neon|Fly"] = 158.07, ["Neon|Ride"] = 362.13, ["Mega"] = 314.94, ["Mega|Ride"] = 282.19, ["Mega|Fly|Ride"] = 409.31}},
    ["rbxassetid://128469688002747"] = {name = "Moonlight Moth", prices = {["default"] = 79.04, ["Fly"] = 113.32, ["Ride"] = 315, ["Neon"] = 137.82, ["Neon|Ride"] = 158.82, ["Neon|Fly|Ride"] = 525, ["Mega"] = 652.98, ["Mega|Ride"] = 629.87, ["Mega|Fly|Ride"] = 840.67}},
    ["rbxassetid://13936753561"] = {name = "Dylan", prices = {["default"] = 10.5}},
    ["rbxassetid://10606175827"] = {name = "Koi Carp", prices = {["default"] = 8.49, ["Fly"] = 79.03, ["Ride"] = 20.98, ["Fly|Ride"] = 105, ["Neon"] = 57.2, ["Neon|Ride"] = 76.13, ["Neon|Fly|Ride"] = 169.44, ["Mega"] = 184.03, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 313.49}},
    ["rbxassetid://84529929751558"] = {name = "Old King Coal", prices = {["default"] = 3.6, ["Ride"] = 99.56, ["Neon"] = 19.69, ["Mega"] = 350.66, ["Mega|Fly|Ride"] = 953.14}},
    ["rbxassetid://11706110842"] = {name = "Snowball Pet", prices = {["default"] = 71.45, ["Fly"] = 83.93, ["Ride"] = 84.69, ["Fly|Ride"] = 116.82, ["Neon"] = 189, ["Neon|Ride"] = 145.69, ["Neon|Fly|Ride"] = 295.32, ["Mega|Ride"] = 878.07, ["Mega|Fly|Ride"] = 791.33}},
    ["rbxassetid://6404812664"] = {name = "Ladybug", prices = {["default"] = 3.63, ["Fly"] = 28.13, ["Ride"] = 15.75, ["Fly|Ride"] = 43.31, ["Neon"] = 28.53, ["Neon|Fly"] = 61.43, ["Neon|Ride"] = 30.79, ["Neon|Fly|Ride"] = 77.12, ["Mega"] = 262.5, ["Mega|Fly"] = 239.36, ["Mega|Ride"] = 258.97, ["Mega|Fly|Ride"] = 234.56}},
    ["rbxassetid://95046891836017"] = {name = "Clover Cow", prices = {["default"] = 9.09, ["Fly"] = 84.73, ["Ride"] = 31.78, ["Fly|Ride"] = 105, ["Neon"] = 28.2, ["Neon|Fly"] = 127.09, ["Neon|Ride"] = 51.92, ["Neon|Fly|Ride"] = 120.3, ["Mega"] = 124.69, ["Mega|Fly"] = 301.45, ["Mega|Ride"] = 173.42, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://123759251940984"] = {name = "Oakee Knight", prices = {["default"] = 2.1, ["Neon"] = 6.57, ["Neon|Ride"] = 201.71, ["Mega"] = 34.13, ["Mega|Ride"] = 203.44, ["Mega|Fly|Ride"] = 192.76}},
    ["rbxassetid://9287842106"] = {name = "Brown Springer Spaniel", prices = {["default"] = 45.94, ["Fly"] = 148.32, ["Ride"] = 70.88, ["Fly|Ride"] = 85.32, ["Neon"] = 178.12, ["Neon|Ride"] = 240.39, ["Neon|Fly|Ride"] = 282.78, ["Mega"] = 1130, ["Mega|Ride"] = 837.46, ["Mega|Fly|Ride"] = 914.4}},
    ["rbxassetid://83890934284839"] = {name = "Zeopod", prices = {["default"] = 2.1, ["Ride"] = 36.02, ["Fly|Ride"] = 141.92, ["Neon"] = 12.99, ["Neon|Fly|Ride"] = 299.61, ["Mega"] = 141.92, ["Mega|Fly|Ride"] = 306.68}},
    ["rbxassetid://107096792267421"] = {name = "General Sheepdog", prices = {["default"] = 11.82, ["Ride"] = 160.13, ["Neon"] = 141.92, ["Neon|Ride"] = 141.9, ["Neon|Fly|Ride"] = 296.51, ["Mega"] = 314.94, ["Mega|Ride"] = 467.04, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://5721844511"] = {name = "Woolly Mammoth", prices = {["default"] = 2.1, ["Fly"] = 23.63, ["Ride"] = 18.51, ["Fly|Ride"] = 39.38, ["Neon"] = 18.64, ["Neon|Ride"] = 40.27, ["Neon|Fly|Ride"] = 93.19, ["Mega"] = 174.58, ["Mega|Ride"] = 196.23, ["Mega|Fly|Ride"] = 314.35}},
    ["rbxassetid://8143039445"] = {name = "Summer Walrus", prices = {["default"] = 3.67, ["Fly"] = 52.5, ["Ride"] = 19.67, ["Fly|Ride"] = 49.88, ["Neon"] = 61.26, ["Neon|Ride"] = 244.62, ["Mega"] = 279.6, ["Mega|Ride"] = 185.35, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://136696735147963"] = {name = "Chilling Spider", prices = {["default"] = 5.16, ["Ride"] = 139.8, ["Neon"] = 21, ["Neon|Ride"] = 110.9, ["Mega"] = 141.92, ["Mega|Ride"] = 574.23}},
    ["rbxassetid://133768672320906"] = {name = "Catte", prices = {["default"] = 43.31, ["Ride"] = 112.05, ["Neon"] = 192.94, ["Neon|Ride"] = 317.69, ["Mega"] = 1057.98, ["Mega|Ride"] = 1412.76, ["Mega|Fly|Ride"] = 1049.74}},
    ["rbxassetid://12139319231"] = {name = "Feesh", prices = {["default"] = 24.86, ["Ride"] = 281.6, ["Neon"] = 210, ["Mega"] = 516.05}},
    ["rbxassetid://13685039170"] = {name = "Lobster", prices = {["default"] = 11.81, ["Ride"] = 63.61, ["Neon"] = 141.96, ["Mega"] = 583.86, ["Mega|Ride"] = 524.24, ["Mega|Fly|Ride"] = 1694.47}},
    ["rbxassetid://87668315398037"] = {name = "Mecha R4BBIT", prices = {["default"] = 24.73, ["Ride"] = 76.27, ["Fly|Ride"] = 141.92, ["Neon"] = 169.44, ["Neon|Ride"] = 635.36, ["Neon|Fly|Ride"] = 573.57, ["Mega|Ride"] = 847.24, ["Mega|Fly|Ride"] = 913.47}},
    ["rbxassetid://120262676323297"] = {name = "Kelp Hunter", prices = {["default"] = 3.93, ["Neon"] = 42.47, ["Neon|Ride"] = 423.57, ["Mega"] = 281.72, ["Mega|Fly|Ride"] = 314.94}},
    ["rbxassetid://12403864254"] = {name = "Gorilla", prices = {["default"] = 2.1, ["Fly"] = 26.24, ["Ride"] = 16.96, ["Fly|Ride"] = 52.5, ["Neon"] = 8.49, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 32.84, ["Neon|Fly|Ride"] = 137.82, ["Mega"] = 62.5, ["Mega|Ride"] = 89.25, ["Mega|Fly|Ride"] = 259.88}},
    ["rbxassetid://124908510040897"] = {name = "Mistletroll", prices = {["default"] = 7.13, ["Ride"] = 48.17, ["Fly|Ride"] = 92.14, ["Neon"] = 26.24, ["Neon|Ride"] = 70.79, ["Neon|Fly|Ride"] = 144.38, ["Mega|Ride"] = 216.57, ["Mega|Fly|Ride"] = 314.94}},
    ["rbxassetid://11189235896"] = {name = "Persian Cat", prices = {["default"] = 2.1, ["Fly"] = 32.74, ["Ride"] = 21, ["Fly|Ride"] = 55.13, ["Neon"] = 4.87, ["Neon|Ride"] = 26.59, ["Neon|Fly|Ride"] = 84.73, ["Mega"] = 59.07, ["Mega|Fly"] = 117.97, ["Mega|Ride"] = 83.56, ["Mega|Fly|Ride"] = 139.46}},
    ["rbxassetid://14457148635"] = {name = "Magma Snail", prices = {["default"] = 3.91, ["Ride"] = 63.71, ["Fly|Ride"] = 42.38, ["Neon"] = 38.06, ["Neon|Ride"] = 98.44, ["Neon|Fly|Ride"] = 198.02, ["Mega"] = 104.86, ["Mega|Ride"] = 155.37, ["Mega|Fly|Ride"] = 471.81}},
    ["rbxassetid://11694853423"] = {name = "Shetland Pony White", prices = {["default"] = 6.3, ["Ride"] = 27.57, ["Fly|Ride"] = 99.75, ["Neon"] = 42.37, ["Neon|Ride"] = 97.76, ["Neon|Fly|Ride"] = 211.79, ["Mega|Ride"] = 416.8, ["Mega|Fly|Ride"] = 393.96}},
    ["rbxassetid://4621220568"] = {name = "Rat", prices = {["default"] = 7.1, ["Ride"] = 22.14, ["Fly|Ride"] = 56.7, ["Neon"] = 30.19, ["Neon|Fly"] = 104.77, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 102.37, ["Mega"] = 305.01, ["Mega|Ride"] = 252, ["Mega|Fly|Ride"] = 276.94}},
    ["rbxassetid://8938702150"] = {name = "Pine Marten", prices = {["default"] = 2.1, ["Fly"] = 34.07, ["Ride"] = 21, ["Fly|Ride"] = 61.44, ["Neon|Fly"] = 84.73, ["Neon|Fly|Ride"] = 127.09, ["Mega"] = 141.91, ["Mega|Ride"] = 436.41, ["Mega|Fly|Ride"] = 472.35}},
    ["rbxassetid://120359009390464"] = {name = "Turtle Doves", prices = {["default"] = 12.29, ["Fly"] = 301.88, ["Ride"] = 28.88, ["Neon"] = 24.92, ["Neon|Fly"] = 169.44, ["Neon|Ride"] = 89.65, ["Neon|Fly|Ride"] = 465.92, ["Mega"] = 98.26, ["Mega|Ride"] = 211.82, ["Mega|Fly|Ride"] = 309.75}},
    ["rbxassetid://71032455578324"] = {name = "Chihuahua", prices = {["default"] = 19.43, ["Ride"] = 72.19, ["Fly|Ride"] = 282.78, ["Neon"] = 79.05, ["Neon|Ride"] = 160.3, ["Neon|Fly|Ride"] = 409.81, ["Mega"] = 357, ["Mega|Fly"] = 1968.75, ["Mega|Ride"] = 440.9, ["Mega|Fly|Ride"] = 563.87}},
    ["rbxassetid://11505487641"] = {name = "Ram", prices = {["default"] = 51.19, ["Fly"] = 205.23, ["Ride"] = 92.03, ["Fly|Ride"] = 291.38, ["Neon"] = 249.38, ["Neon|Ride"] = 263.82, ["Neon|Fly|Ride"] = 381.27, ["Mega"] = 1050, ["Mega|Ride"] = 853.13, ["Mega|Fly|Ride"] = 975.19}},
    ["rbxassetid://117821626163847"] = {name = "Chanekeh", prices = {["default"] = 2.1, ["Ride"] = 25.51, ["Fly|Ride"] = 65.63, ["Neon"] = 3.94, ["Neon|Ride"] = 37.95, ["Neon|Fly|Ride"] = 58.35, ["Mega"] = 26.57, ["Mega|Ride"] = 71.14, ["Mega|Fly|Ride"] = 115.55}},
    ["rbxassetid://14266737982"] = {name = "Cassowary", prices = {["default"] = 11.4, ["Ride"] = 351.61, ["Neon"] = 281.59, ["Mega"] = 915.48, ["Mega|Fly|Ride"] = 1270.85}},
    ["rbxassetid://13693650831"] = {name = "Leopard Shark", prices = {["default"] = 52.41, ["Ride"] = 127.1, ["Neon"] = 211.79, ["Neon|Ride"] = 341.25, ["Mega|Ride"] = 1978.28, ["Mega|Fly|Ride"] = 1266.62}},
    ["rbxassetid://100909868233186"] = {name = "Kappakid", prices = {["default"] = 10.5, ["Fly"] = 190.32, ["Ride"] = 31.79, ["Fly|Ride"] = 126, ["Neon"] = 49.88, ["Neon|Ride"] = 72.19, ["Neon|Fly|Ride"] = 211.79, ["Mega"] = 137.63, ["Mega|Ride"] = 249.38, ["Mega|Fly|Ride"] = 393.1}},
    ["rbxassetid://127061844219486"] = {name = "Patchy Bear", prices = {["default"] = 2.1, ["Fly"] = 157.5, ["Ride"] = 31.86, ["Fly|Ride"] = 84.74, ["Neon"] = 6.04, ["Neon|Ride"] = 27.55, ["Mega"] = 20.97, ["Mega|Ride"] = 51.19, ["Mega|Fly|Ride"] = 143.72}},
    ["rbxassetid://6998402749"] = {name = "Merhorse", prices = {["default"] = 2.1, ["Fly"] = 706.13, ["Ride"] = 21.2, ["Fly|Ride"] = 45.94, ["Neon"] = 158.02, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 141.92, ["Mega|Fly"] = 353.93, ["Mega|Ride"] = 198.65, ["Mega|Fly|Ride"] = 226.65}},
    ["rbxassetid://3181727196"] = {name = "Beaver", prices = {["default"] = 2.1, ["Fly"] = 24.36, ["Ride"] = 19.07, ["Fly|Ride"] = 33.91, ["Neon"] = 3.82, ["Neon|Ride"] = 27.15, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 27.56, ["Mega|Ride"] = 68.08, ["Mega|Fly|Ride"] = 116.94}},
    ["rbxassetid://10377935981"] = {name = "Badger", prices = {["default"] = 2.1, ["Ride"] = 18.8, ["Fly|Ride"] = 65.7, ["Neon"] = 3.93, ["Neon|Ride"] = 37.08, ["Neon|Fly|Ride"] = 84, ["Mega"] = 43.98, ["Mega|Fly"] = 168, ["Mega|Ride"] = 55.11, ["Mega|Fly|Ride"] = 179.82}},
    ["rbxassetid://118143096743818"] = {name = "Granny Wolf", prices = {["default"] = 2.1, ["Ride"] = 52.5, ["Neon"] = 2.37, ["Neon|Ride"] = 158.07, ["Mega"] = 21, ["Mega|Ride"] = 105.98, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://18819382634"] = {name = "Singularity Beetle", prices = {["default"] = 4.39, ["Ride"] = 31.79, ["Fly|Ride"] = 360.08, ["Neon"] = 72.19, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 209.68, ["Mega"] = 198.06, ["Mega|Ride"] = 231, ["Mega|Fly|Ride"] = 624.1}},
    ["rbxassetid://13664716167"] = {name = "Ostrich", prices = {["default"] = 15.9, ["Ride"] = 34.13, ["Fly|Ride"] = 261.85, ["Neon"] = 45.94, ["Neon|Ride"] = 200.82, ["Neon|Fly|Ride"] = 234.68, ["Mega"] = 388.68, ["Mega|Ride"] = 422.58, ["Mega|Fly|Ride"] = 550.72}},
    ["rbxassetid://3710822879"] = {name = "Penguin", prices = {["default"] = 11.65, ["Fly"] = 19.69, ["Ride"] = 18.38, ["Fly|Ride"] = 47.12, ["Neon"] = 32.82, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 60.37, ["Neon|Fly|Ride"] = 81.38, ["Mega|Ride"] = 334.69, ["Mega|Fly|Ride"] = 404.09}},
    ["rbxassetid://12778628745"] = {name = "Chef Gorilla", prices = {["default"] = 79.98, ["Ride"] = 144.38, ["Fly|Ride"] = 262.5, ["Neon"] = 538.13, ["Neon|Ride"] = 888.57, ["Mega"] = 3145.73, ["Mega|Fly|Ride"] = 1557.86}},
    ["rbxassetid://138841259551372"] = {name = "Vermilion Butterfly", prices = {["default"] = 18.59, ["Fly"] = 72.43, ["Ride"] = 65.63, ["Fly|Ride"] = 76.27, ["Neon"] = 93.19, ["Mega"] = 423.52, ["Mega|Ride"] = 603.75, ["Mega|Fly|Ride"] = 1029.67}},
    ["rbxassetid://3181727125"] = {name = "Snow Puma", prices = {["default"] = 2.1, ["Fly"] = 17.93, ["Ride"] = 10.5, ["Fly|Ride"] = 36.72, ["Neon"] = 3.15, ["Neon|Fly"] = 33.91, ["Neon|Ride"] = 21.19, ["Neon|Fly|Ride"] = 69.28, ["Mega"] = 61.35, ["Mega|Ride"] = 108.03, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://3181728160"] = {name = "Shiba Inu", prices = {["default"] = 2.1, ["Fly"] = 23.31, ["Ride"] = 16.05, ["Fly|Ride"] = 32.55, ["Neon"] = 3.87, ["Neon|Fly"] = 22.91, ["Neon|Ride"] = 21.21, ["Neon|Fly|Ride"] = 42, ["Mega"] = 47.25, ["Mega|Ride"] = 52.5, ["Mega|Fly|Ride"] = 87.94}},
    ["rbxassetid://3261465893"] = {name = "Blue Dog", prices = {["default"] = 360, ["Ride"] = 416.93, ["Fly|Ride"] = 438.39, ["Neon|Fly|Ride"] = 1522.5}},
    ["rbxassetid://15504846154"] = {name = "Eggnog Hare", prices = {["default"] = 10.4, ["Ride"] = 84.74, ["Fly|Ride"] = 209.7, ["Neon"] = 70.96, ["Neon|Ride"] = 82.69, ["Mega"] = 433.79, ["Mega|Ride"] = 420, ["Mega|Fly|Ride"] = 1002.92}},
    ["rbxassetid://4708551244"] = {name = "Dingo", prices = {["default"] = 2.1, ["Fly"] = 34.13, ["Ride"] = 18.38, ["Fly|Ride"] = 30.19, ["Neon"] = 5.85, ["Neon|Ride"] = 21.19, ["Neon|Fly|Ride"] = 42.37, ["Mega"] = 42.38, ["Mega|Ride"] = 57.11, ["Mega|Fly|Ride"] = 97.28}},
    ["rbxassetid://140434791311540"] = {name = "French Bulldog", prices = {["default"] = 72.19, ["Ride"] = 122.06, ["Fly|Ride"] = 315, ["Neon"] = 211.26, ["Neon|Ride"] = 302.74, ["Neon|Fly|Ride"] = 366.19, ["Mega"] = 700.14, ["Mega|Ride"] = 733.69, ["Mega|Fly|Ride"] = 912.19}},
    ["rbxassetid://5067924710"] = {name = "Monkey", prices = {["default"] = 2.1, ["Ride"] = 17.46, ["Fly|Ride"] = 45.55, ["Neon"] = 13.02, ["Neon|Fly"] = 67.6, ["Neon|Ride"] = 23.6, ["Neon|Fly|Ride"] = 84.3, ["Mega"] = 104.42, ["Mega|Fly"] = 184.29, ["Mega|Ride"] = 96.33, ["Mega|Fly|Ride"] = 207.83}},
    ["rbxassetid://73677246948616"] = {name = "Black Tiger", prices = {["default"] = 2.1, ["Fly"] = 70.96, ["Ride"] = 57.21, ["Fly|Ride"] = 1312.5, ["Neon"] = 3.61, ["Neon|Ride"] = 28.88, ["Neon|Fly|Ride"] = 283.19, ["Mega"] = 18.38, ["Mega|Ride"] = 83.68, ["Mega|Fly|Ride"] = 189}},
    ["rbxassetid://17662893972"] = {name = "Pretty Pony", prices = {["default"] = 86.84, ["Fly"] = 134.9, ["Ride"] = 107.63, ["Fly|Ride"] = 266.89, ["Neon"] = 240.24, ["Neon|Ride"] = 332.51, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 889.35, ["Mega|Ride"] = 657.03, ["Mega|Fly|Ride"] = 722.22}},
    ["rbxassetid://16722908853"] = {name = "Dotted Eggy", prices = {["default"] = 2.1, ["Ride"] = 21.84, ["Fly|Ride"] = 39.38, ["Neon"] = 5.23, ["Neon|Ride"] = 99.56, ["Mega"] = 101.67, ["Mega|Ride"] = 82.62, ["Mega|Fly|Ride"] = 160.13}},
    ["rbxassetid://3409443896"] = {name = "Wild Boar", prices = {["default"] = 35.44, ["Fly"] = 141.9, ["Ride"] = 49.88, ["Neon"] = 182.2, ["Neon|Ride"] = 205.44, ["Neon|Fly|Ride"] = 234.94, ["Mega|Ride"] = 1582.21, ["Mega|Fly|Ride"] = 984.38}},
    ["rbxassetid://12432807176"] = {name = "Possum", prices = {["default"] = 5.25, ["Fly|Ride"] = 211.82, ["Neon"] = 42.37, ["Neon|Ride"] = 203.44, ["Mega"] = 172.6, ["Mega|Ride"] = 847.24, ["Mega|Fly|Ride"] = 547.98}},
    ["rbxassetid://94550121082603"] = {name = "Lionfish", prices = {["default"] = 3.68, ["Ride"] = 70.96, ["Fly|Ride"] = 65.63, ["Neon"] = 12.73, ["Neon|Fly"] = 63.55, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 406.88, ["Mega"] = 72.1, ["Mega|Ride"] = 569.63, ["Mega|Fly|Ride"] = 565.55}},
    ["rbxassetid://15096097714"] = {name = "Evil Rock", prices = {["default"] = 24.43, ["Ride"] = 49.55, ["Fly|Ride"] = 104.81, ["Neon|Ride"] = 226.63, ["Mega|Ride"] = 1130, ["Mega|Fly|Ride"] = 1099.29}},
    ["rbxassetid://117664495619345"] = {name = "Fire Foal", prices = {["default"] = 2.1, ["Fly"] = 144.82, ["Ride"] = 65.63, ["Fly|Ride"] = 908.98, ["Neon"] = 4.86, ["Neon|Fly"] = 78.66, ["Neon|Ride"] = 52.96, ["Neon|Fly|Ride"] = 156.76, ["Mega"] = 36.58, ["Mega|Fly"] = 158.61, ["Mega|Ride"] = 127.16, ["Mega|Fly|Ride"] = 281.98}},
    ["rbxassetid://8938701683"] = {name = "Red Cardinal", prices = {["default"] = 2.1, ["Fly"] = 57.21, ["Ride"] = 28.6, ["Fly|Ride"] = 72.17, ["Neon"] = 4.6, ["Neon|Fly"] = 41.88, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 79.04, ["Mega"] = 105.77, ["Mega|Ride"] = 131.24, ["Mega|Fly|Ride"] = 278.92}},
    ["rbxassetid://12489700965"] = {name = "Tarsier", prices = {["default"] = 6.56, ["Ride"] = 50.77, ["Fly|Ride"] = 188.73, ["Neon"] = 78.75, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 141.9, ["Mega"] = 311.07, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 465.94}},
    ["rbxassetid://11765322595"] = {name = "Gingerbread Reindeer", prices = {["default"] = 28.67, ["Ride"] = 86.92, ["Fly|Ride"] = 105, ["Neon"] = 183.74, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 322.82, ["Mega"] = 643.12, ["Mega|Ride"] = 647.24, ["Mega|Fly|Ride"] = 699.77}},
    ["rbxassetid://16382424275"] = {name = "Nautilus", prices = {["default"] = 31.5, ["Fly"] = 184.26, ["Ride"] = 35.4, ["Fly|Ride"] = 77.44, ["Neon"] = 103.69, ["Neon|Ride"] = 110.25, ["Neon|Fly|Ride"] = 154.88, ["Mega"] = 629.87, ["Mega|Fly|Ride"] = 471.81}},
    ["rbxassetid://93997399823425"] = {name = "Chocolate Dutch Guinea Pig", prices = {["default"] = 77.44, ["Fly"] = 196.88, ["Ride"] = 129.94, ["Fly|Ride"] = 225.77, ["Neon"] = 341.25, ["Neon|Ride"] = 354.37, ["Neon|Fly|Ride"] = 544.69, ["Mega|Ride"] = 1181.25, ["Mega|Fly|Ride"] = 1233.75}},
    ["rbxassetid://75866760046580"] = {name = "Skelebat", prices = {["default"] = 4.73, ["Ride"] = 40.13, ["Fly|Ride"] = 288.75, ["Neon"] = 15.74, ["Neon|Ride"] = 58.8, ["Neon|Fly|Ride"] = 305.8, ["Mega"] = 89.24, ["Mega|Ride"] = 135.19, ["Mega|Fly|Ride"] = 235.92}},
    ["rbxassetid://111661922676557"] = {name = "Momma Moose", prices = {["default"] = 6.41, ["Ride"] = 26.24, ["Fly|Ride"] = 70.97, ["Neon"] = 26.99, ["Neon|Ride"] = 49.88, ["Neon|Fly|Ride"] = 211.79, ["Mega"] = 203.44, ["Mega|Ride"] = 169.45}},
    ["rbxassetid://17059860310"] = {name = "Elasmosaurus", prices = {["default"] = 9.18, ["Fly"] = 87.94, ["Ride"] = 39.38, ["Fly|Ride"] = 110.25, ["Neon"] = 124.97, ["Neon|Ride"] = 103.69, ["Neon|Fly|Ride"] = 156.73, ["Mega"] = 629.87, ["Mega|Ride"] = 353.74}},
    ["rbxassetid://10306934599"] = {name = "Camel", prices = {["default"] = 2.1, ["Fly"] = 15.74, ["Ride"] = 14.84, ["Fly|Ride"] = 38.14, ["Neon"] = 2.1, ["Neon|Fly"] = 17.07, ["Neon|Ride"] = 15.9, ["Neon|Fly|Ride"] = 61.6, ["Mega"] = 14.44, ["Mega|Fly"] = 70.97, ["Mega|Ride"] = 31.79, ["Mega|Fly|Ride"] = 118.13}},
    ["rbxassetid://13104107016"] = {name = "Puffer Fish", prices = {["default"] = 61.69, ["Fly"] = 78.38, ["Ride"] = 184.26, ["Fly|Ride"] = 303.01, ["Neon"] = 220.57, ["Neon|Fly"] = 2400.55, ["Neon|Ride"] = 291.37, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 3177.12, ["Mega|Ride"] = 807.19, ["Mega|Fly|Ride"] = 840}},
    ["rbxassetid://17183022910"] = {name = "Mole", prices = {["default"] = 2.1, ["Ride"] = 21.19, ["Fly|Ride"] = 110.16, ["Neon"] = 5.98, ["Neon|Ride"] = 26.25, ["Mega"] = 42.95, ["Mega|Fly|Ride"] = 211.82}},
    ["rbxassetid://5721844051"] = {name = "Stegosaurus", prices = {["default"] = 2.1, ["Fly"] = 28.53, ["Ride"] = 22.32, ["Fly|Ride"] = 57.21, ["Neon"] = 13.13, ["Neon|Fly"] = 141.9, ["Neon|Ride"] = 28.62, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 157.5, ["Mega|Ride"] = 391.85, ["Mega|Fly|Ride"] = 252.13}},
    ["rbxassetid://114921997566126"] = {name = "S'mores Raccoon", prices = {["default"] = 84, ["Ride"] = 156.73, ["Fly|Ride"] = 431.04, ["Neon"] = 211.79, ["Neon|Ride"] = 264.74, ["Neon|Fly|Ride"] = 510.57, ["Mega"] = 944.98, ["Mega|Ride"] = 905.63, ["Mega|Fly|Ride"] = 1010.63}},
    ["rbxassetid://93038040448121"] = {name = "Nurse Shark", prices = {["default"] = 2.1, ["Ride"] = 42.37, ["Neon"] = 7.46, ["Neon|Ride"] = 42, ["Mega"] = 59.07, ["Mega|Ride"] = 125.22, ["Mega|Fly|Ride"] = 275.63}},
    ["rbxassetid://13936750528"] = {name = "River", prices = {["default"] = 11.84}},
    ["rbxassetid://103142927308458"] = {name = "Black-Footed Ferret", prices = {["default"] = 2.1, ["Ride"] = 20475.31, ["Fly|Ride"] = 282.78, ["Neon"] = 9.19, ["Neon|Ride"] = 58.37, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 43.32, ["Mega|Ride"] = 115.5, ["Mega|Fly|Ride"] = 1034.25}},
    ["rbxassetid://3199974219"] = {name = "Pet Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13803784751"] = {name = "Happy Clam", prices = {["default"] = 127.32, ["Ride"] = 190.61, ["Fly|Ride"] = 456.47, ["Neon"] = 833.44, ["Neon|Ride"] = 702.19, ["Neon|Fly|Ride"] = 706.3, ["Mega|Fly|Ride"] = 2612.65}},
    ["rbxassetid://13665210525"] = {name = "Warthog", prices = {["default"] = 3.68, ["Ride"] = 26.25, ["Neon"] = 37.08, ["Neon|Ride"] = 61.69, ["Mega"] = 173.25, ["Mega|Ride"] = 314.42, ["Mega|Fly|Ride"] = 419.35}},
    ["rbxassetid://18515939072"] = {name = "Black Marlin", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Neon"] = 5.25, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 36.01, ["Mega|Ride"] = 99.62}},
    ["rbxassetid://16075008092"] = {name = "Fanghorn Tortoise", prices = {["default"] = 5.02, ["Ride"] = 28.61, ["Neon"] = 51.19, ["Neon|Ride"] = 112.88, ["Neon|Fly|Ride"] = 169.44, ["Mega"] = 393.99, ["Mega|Ride"] = 635.43, ["Mega|Fly|Ride"] = 629.95}},
    ["rbxassetid://8566684181"] = {name = "Giant Black Scarab", prices = {["default"] = 10.39, ["Fly"] = 75.21, ["Ride"] = 19.99, ["Fly|Ride"] = 157.5, ["Neon"] = 59.07, ["Neon|Ride"] = 91.08, ["Neon|Fly|Ride"] = 282.75, ["Mega"] = 456.75, ["Mega|Ride"] = 405.57, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://118691035196137"] = {name = "Shiver Wolf", prices = {["default"] = 36.72, ["Ride"] = 99.57, ["Fly|Ride"] = 282.78, ["Neon"] = 212.63, ["Neon|Fly|Ride"] = 423.63, ["Mega"] = 721.88, ["Mega|Ride"] = 380.63, ["Mega|Fly|Ride"] = 514.49}},
    ["rbxassetid://3743735223"] = {name = "Brown Bear", prices = {["default"] = 150.67, ["Fly"] = 161.52, ["Ride"] = 191.63, ["Fly|Ride"] = 203.44, ["Neon"] = 616.88, ["Neon|Ride"] = 498.75, ["Neon|Fly|Ride"] = 589.31, ["Mega|Fly|Ride"] = 2159.07}},
    ["rbxassetid://3934251801"] = {name = "Sloth", prices = {["default"] = 8.82, ["Fly"] = 22.19, ["Ride"] = 19.59, ["Fly|Ride"] = 49.33, ["Neon"] = 62.53, ["Neon|Fly"] = 70.96, ["Neon|Ride"] = 61.44, ["Neon|Fly|Ride"] = 94.28, ["Mega|Ride"] = 423.63, ["Mega|Fly|Ride"] = 452.75}},
    ["rbxassetid://12139338880"] = {name = "Frogspawn", prices = {["default"] = 3.7, ["Fly"] = 131.23, ["Ride"] = 32.85, ["Fly|Ride"] = 131.25, ["Neon"] = 27.56, ["Neon|Ride"] = 35.44, ["Neon|Fly|Ride"] = 192.95, ["Mega"] = 130.92, ["Mega|Fly|Ride"] = 422.58}},
    ["rbxassetid://8070926551"] = {name = "Snow Leopard", prices = {["default"] = 16.75, ["Fly"] = 105, ["Ride"] = 55.13, ["Neon"] = 63.51, ["Neon|Ride"] = 158.07, ["Mega"] = 528.47, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 549.94}},
    ["rbxassetid://76712147705770"] = {name = "Tuxedo Cat", prices = {["default"] = 42.4, ["Fly"] = 113.32, ["Ride"] = 84.79, ["Fly|Ride"] = 211.82, ["Neon"] = 228.38, ["Neon|Ride"] = 223.13, ["Neon|Fly|Ride"] = 282.75, ["Mega"] = 974.33, ["Mega|Ride"] = 918.75, ["Mega|Fly|Ride"] = 851.34}},
    ["rbxassetid://15685468962"] = {name = "Tasmanian Devil", prices = {["default"] = 13.55, ["Ride"] = 81.85, ["Neon"] = 131.25, ["Neon|Ride"] = 126.62, ["Neon|Fly|Ride"] = 70.96, ["Mega"] = 707.45, ["Mega|Ride"] = 706.38, ["Mega|Fly|Ride"] = 786.75}},
    ["rbxassetid://123288277753363"] = {name = "Tri-horned Treehopper", prices = {["default"] = 301.87, ["Ride"] = 413.44, ["Neon"] = 2400.55, ["Neon|Ride"] = 1115.63, ["Mega|Fly|Ride"] = 4130.24}},
    ["rbxassetid://6060987821"] = {name = "Yeti", prices = {["default"] = 30.19, ["Fly"] = 65.63, ["Ride"] = 48.57, ["Fly|Ride"] = 84.74, ["Neon|Ride"] = 211.81, ["Neon|Fly|Ride"] = 309.84, ["Mega"] = 1181.25, ["Mega|Ride"] = 832.41, ["Mega|Fly|Ride"] = 792.81}},
    ["rbxassetid://9549841158"] = {name = "Zebra", prices = {["default"] = 2.1, ["Fly"] = 17.4, ["Ride"] = 15.9, ["Fly|Ride"] = 77.44, ["Neon"] = 2.1, ["Neon|Ride"] = 19.57, ["Neon|Fly|Ride"] = 45.94, ["Mega"] = 18.04, ["Mega|Fly"] = 107.63, ["Mega|Ride"] = 49.8, ["Mega|Fly|Ride"] = 94.37}},
    ["rbxassetid://13883282884"] = {name = "Hermit Crab", prices = {["default"] = 3.92, ["Ride"] = 65.63, ["Neon"] = 13.12, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 126.97, ["Mega"] = 141.92, ["Mega|Fly"] = 124.69, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 370.79}},
    ["rbxassetid://92626539723202"] = {name = "Sea Angel", prices = {["default"] = 3.91, ["Ride"] = 33.87, ["Fly|Ride"] = 129.94, ["Neon"] = 21.21, ["Neon|Ride"] = 78.26, ["Neon|Fly|Ride"] = 139.79, ["Mega"] = 148.28, ["Mega|Fly"] = 240.41, ["Mega|Ride"] = 136.84, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://15848329383"] = {name = "Jellyfish", prices = {["default"] = 328.13, ["Fly"] = 629.78, ["Ride"] = 367.49, ["Fly|Ride"] = 433.13, ["Neon"] = 2625, ["Neon|Fly"] = 2541.38, ["Neon|Ride"] = 1694.26, ["Neon|Fly|Ride"] = 1978.05, ["Mega|Ride"] = 6354.21, ["Mega|Fly|Ride"] = 5033.44}},
    ["rbxassetid://5721843846"] = {name = "Sabertooth", prices = {["default"] = 2.1, ["Fly"] = 70.96, ["Ride"] = 15.9, ["Fly|Ride"] = 56.44, ["Neon"] = 38.13, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 78.33, ["Mega|Ride"] = 223.12, ["Mega|Fly|Ride"] = 685.13}},
    ["rbxassetid://9475753090"] = {name = "Albatross", prices = {["default"] = 11.82, ["Fly"] = 31.77, ["Ride"] = 21, ["Fly|Ride"] = 52.97, ["Neon|Ride"] = 57.2, ["Neon|Fly|Ride"] = 210.74, ["Mega"] = 423.63, ["Mega|Ride"] = 706.38, ["Mega|Fly|Ride"] = 211.95}},
    ["rbxassetid://96894173636082"] = {name = "Clementine Owl", prices = {["default"] = 3.56, ["Fly"] = 36.02, ["Ride"] = 27.56, ["Fly|Ride"] = 65.63, ["Neon"] = 23.63, ["Neon|Fly"] = 105, ["Neon|Ride"] = 65.62, ["Neon|Fly|Ride"] = 126.21, ["Mega"] = 132.76, ["Mega|Ride"] = 194.25, ["Mega|Fly|Ride"] = 313.77}},
    ["rbxassetid://10318105683"] = {name = "Orange Butterfly", prices = {["default"] = 38.75, ["Fly"] = 210, ["Ride"] = 69.9, ["Fly|Ride"] = 65.63, ["Neon"] = 117.97, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 656.25, ["Mega|Ride"] = 845.25, ["Mega|Fly|Ride"] = 643.11}},
    ["rbxassetid://15937689999"] = {name = "Rattlesnake", prices = {["default"] = 2.1, ["Fly"] = 31.34, ["Ride"] = 28.14, ["Fly|Ride"] = 70.97, ["Neon"] = 10.5, ["Neon|Ride"] = 114.19, ["Neon|Fly|Ride"] = 210, ["Mega"] = 137.82, ["Mega|Ride"] = 141.56, ["Mega|Fly|Ride"] = 818.35}},
    ["rbxassetid://10971808447"] = {name = "Evil Basilisk", prices = {["default"] = 3.94, ["Fly"] = 104.15, ["Ride"] = 24.94, ["Fly|Ride"] = 57.23, ["Neon"] = 153.04, ["Neon|Ride"] = 106.32, ["Mega"] = 706.38, ["Mega|Ride"] = 471.81, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://99104623628550"] = {name = "Snorgle", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 3.93, ["Neon|Ride"] = 26.25, ["Mega"] = 38.96, ["Mega|Ride"] = 110.81, ["Mega|Fly|Ride"] = 282.78}},
    ["rbxassetid://136705425555561"] = {name = "Emperor Shrimp", prices = {["default"] = 9.19, ["Ride"] = 57.21, ["Neon"] = 52.5, ["Mega"] = 254.19, ["Mega|Fly|Ride"] = 6354.21}},
    ["rbxassetid://14398819258"] = {name = "Longhorn Cow", prices = {["default"] = 9.19, ["Ride"] = 141.92, ["Neon"] = 78.89, ["Mega"] = 296.55, ["Mega|Ride"] = 471.81, ["Mega|Fly|Ride"] = 703.68}},
    ["rbxassetid://4708551284"] = {name = "Koala", prices = {["default"] = 10.5, ["Fly"] = 30.77, ["Ride"] = 28.5, ["Fly|Ride"] = 56.63, ["Neon"] = 62.93, ["Neon|Fly"] = 70.56, ["Neon|Ride"] = 58.79, ["Neon|Fly|Ride"] = 106.26, ["Mega"] = 409.86, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 385.02}},
    ["rbxassetid://4115249264"] = {name = "Zombie Buffalo", prices = {["default"] = 169.45, ["Fly"] = 205.24, ["Ride"] = 205.96, ["Fly|Ride"] = 190.32, ["Neon"] = 865.44, ["Neon|Ride"] = 871.48, ["Neon|Fly|Ride"] = 849.79, ["Mega|Fly|Ride"] = 4221.31}},
    ["rbxassetid://8939633862"] = {name = "Salamander", prices = {["default"] = 2.63, ["Fly"] = 21.2, ["Ride"] = 19.52, ["Fly|Ride"] = 63.71, ["Neon"] = 12.39, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 113.54, ["Mega"] = 220.5, ["Mega|Ride"] = 423.63, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://7734902431"] = {name = "Halloween White Mummy Cat", prices = {["default"] = 2.1, ["Ride"] = 31.79, ["Fly|Ride"] = 103.76, ["Neon"] = 15.74, ["Neon|Ride"] = 32.81, ["Neon|Fly|Ride"] = 166.69, ["Mega"] = 195.57, ["Mega|Ride"] = 141.9, ["Mega|Fly|Ride"] = 410.82}},
    ["rbxassetid://115869632070663"] = {name = "Snowball Pug", prices = {["default"] = 49.79, ["Ride"] = 105, ["Fly|Ride"] = 529.53, ["Neon"] = 156.79, ["Neon|Ride"] = 266.85, ["Neon|Fly|Ride"] = 469.88, ["Mega"] = 354.38, ["Mega|Ride"] = 386.98, ["Mega|Fly|Ride"] = 483}},
    ["rbxassetid://8077189379"] = {name = "Husky", prices = {["default"] = 59.06, ["Fly"] = 169.44, ["Ride"] = 105, ["Fly|Ride"] = 226.79, ["Neon"] = 466.98, ["Neon|Fly"] = 423.57, ["Neon|Ride"] = 485.62, ["Neon|Fly|Ride"] = 474.41, ["Mega|Ride"] = 1791.57, ["Mega|Fly|Ride"] = 1499.08}},
    ["rbxassetid://98003529163435"] = {name = "Maine Coon", prices = {["default"] = 41.91, ["Ride"] = 156.19, ["Fly|Ride"] = 315, ["Neon"] = 91.95, ["Neon|Ride"] = 239.32, ["Neon|Fly|Ride"] = 423.57, ["Mega"] = 282.38, ["Mega|Ride"] = 320.24, ["Mega|Fly|Ride"] = 407.45}},
    ["rbxassetid://12488273089"] = {name = "Yellow-lipped Sea Krait", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 19.69, ["Fly|Ride"] = 47.16, ["Neon"] = 15.9, ["Neon|Fly|Ride"] = 59.07, ["Mega"] = 126.21, ["Mega|Ride"] = 184.29, ["Mega|Fly|Ride"] = 353.74}},
    ["rbxassetid://96760582519875"] = {name = "Cozy Mistletroll", prices = {["default"] = 19.08, ["Neon"] = 65.63, ["Mega"] = 204.57, ["Mega|Ride"] = 269.07, ["Mega|Fly|Ride"] = 422.58}},
    ["rbxassetid://85229142142232"] = {name = "Bunny Swirl", prices = {["default"] = 82.69, ["Ride"] = 118.13, ["Fly|Ride"] = 216.57, ["Neon"] = 223.86, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 634.3, ["Mega"] = 470.19, ["Mega|Ride"] = 519.75, ["Mega|Fly|Ride"] = 530.25}},
    ["rbxassetid://121192022038625"] = {name = "Stygian Owl", prices = {["default"] = 3.15, ["Ride"] = 78.75, ["Neon"] = 9.5, ["Neon|Ride"] = 104.76, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 56.44, ["Mega|Fly"] = 163.11, ["Mega|Ride"] = 139.8, ["Mega|Fly|Ride"] = 316.66}},
    ["rbxassetid://83732262844708"] = {name = "Pain au Chat", prices = {["default"] = 15.54, ["Ride"] = 235.91, ["Neon"] = 85.32, ["Neon|Ride"] = 176.85, ["Mega"] = 350.01, ["Mega|Ride"] = 549.94, ["Mega|Fly|Ride"] = 583.05}},
    ["rbxassetid://12792506715"] = {name = "Goose", prices = {["default"] = 997.5, ["Fly"] = 2117.82, ["Ride"] = 1015.88, ["Fly|Ride"] = 1050, ["Neon|Ride"] = 3933.68, ["Neon|Fly|Ride"] = 2835.98, ["Mega|Fly|Ride"] = 11634.6}},
    ["rbxassetid://12779257292"] = {name = "Pudding Cat", prices = {["default"] = 35.44, ["Ride"] = 111.56, ["Fly|Ride"] = 210, ["Neon"] = 145.68, ["Neon|Ride"] = 246.49, ["Mega"] = 847.24, ["Mega|Ride"] = 701.1, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://83376259738301"] = {name = "Mrs. Whiskerpips", prices = {["default"] = 4.76, ["Fly"] = 49.12, ["Ride"] = 141.9, ["Fly|Ride"] = 423.63, ["Neon"] = 21, ["Neon|Fly"] = 157.5, ["Neon|Ride"] = 49.8, ["Neon|Fly|Ride"] = 127.1, ["Mega"] = 98.44, ["Mega|Ride"] = 423.63, ["Mega|Fly|Ride"] = 220.44}},
    ["rbxassetid://110894046614323"] = {name = "Partridge", prices = {["default"] = 10.39, ["Ride"] = 131.22, ["Neon"] = 78.75, ["Mega"] = 367.5, ["Mega|Ride"] = 328.13}},
    ["rbxassetid://114034119324343"] = {name = "Muskrat", prices = {["default"] = 2.1, ["Ride"] = 49.79, ["Fly|Ride"] = 423.63, ["Neon"] = 2.1, ["Neon|Ride"] = 28.6, ["Neon|Fly|Ride"] = 99.56, ["Mega"] = 36.75, ["Mega|Fly"] = 126.04, ["Mega|Ride"] = 94.38, ["Mega|Fly|Ride"] = 550.72}},
    ["rbxassetid://15547904644"] = {name = "Harp Seal", prices = {["default"] = 72.19, ["Ride"] = 131.25, ["Fly|Ride"] = 262.5, ["Neon"] = 287.44, ["Neon|Ride"] = 341.57, ["Neon|Fly|Ride"] = 596.17, ["Mega"] = 1043.2, ["Mega|Ride"] = 1069.41, ["Mega|Fly|Ride"] = 1049.9}},
    ["rbxassetid://14978702254"] = {name = "Scarecrow Cat", prices = {["default"] = 6.46, ["Fly"] = 101.07, ["Ride"] = 52.5, ["Fly|Ride"] = 70.97, ["Neon"] = 34.96, ["Neon|Ride"] = 84.73, ["Mega"] = 353.74, ["Mega|Ride"] = 290.33, ["Mega|Fly|Ride"] = 296.63}},
    ["rbxassetid://95871612352029"] = {name = "Cold Cube", prices = {["default"] = 3.94, ["Ride"] = 24.38, ["Neon"] = 19.95, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 141.9, ["Mega"] = 147, ["Mega|Ride"] = 240.41, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://114456035353449"] = {name = "Bauble Buddies", prices = {["default"] = 44.63, ["Ride"] = 78.75, ["Fly|Ride"] = 150.41, ["Neon"] = 154.35, ["Neon|Fly"] = 280.65, ["Neon|Ride"] = 226.63, ["Neon|Fly|Ride"] = 635.36, ["Mega"] = 535.5, ["Mega|Ride"] = 489.25, ["Mega|Fly|Ride"] = 669.97}},
    ["rbxassetid://15383967605"] = {name = "Gingerbread Mouse", prices = {["default"] = 17.07, ["Ride"] = 98.44, ["Fly|Ride"] = 196.88, ["Neon"] = 115.5, ["Neon|Ride"] = 211.79, ["Neon|Fly|Ride"] = 314.94, ["Mega"] = 612.26, ["Mega|Ride"] = 606.27, ["Mega|Fly|Ride"] = 1090.46}},
    ["rbxassetid://11767069383"] = {name = "Woolly Rhino", prices = {["default"] = 49.83, ["Ride"] = 423.63, ["Neon"] = 774.38, ["Neon|Ride"] = 1019.82, ["Neon|Fly|Ride"] = 928.6, ["Mega"] = 2541.69, ["Mega|Ride"] = 2359.01, ["Mega|Fly|Ride"] = 2118.08}},
    ["rbxassetid://95133623103638"] = {name = "Samoyed", prices = {["default"] = 7.09, ["Ride"] = 102.63, ["Neon"] = 19.69, ["Neon|Ride"] = 99.58, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 110.16, ["Mega|Ride"] = 144.9, ["Mega|Fly|Ride"] = 268.73}},
    ["rbxassetid://8071236757"] = {name = "St Bernard", prices = {["default"] = 6.36, ["Fly"] = 28.61, ["Ride"] = 21, ["Fly|Ride"] = 70.97, ["Neon"] = 141.9, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 494.53, ["Mega"] = 393.75, ["Mega|Ride"] = 392.44, ["Mega|Fly|Ride"] = 440.12}},
    ["rbxassetid://14276930615"] = {name = "Alley Cat", prices = {["default"] = 128.63, ["Ride"] = 187.69, ["Fly|Ride"] = 217.09, ["Neon"] = 535.45, ["Neon|Fly"] = 511.88, ["Neon|Ride"] = 446.25, ["Neon|Fly|Ride"] = 525, ["Mega|Fly"] = 2824.45, ["Mega|Ride"] = 2361.19, ["Mega|Fly|Ride"] = 1785}},
    ["rbxassetid://6498256417"] = {name = "Dolphin", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 20.14, ["Fly|Ride"] = 47.18, ["Neon"] = 20.9, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 28.62, ["Neon|Fly|Ride"] = 70.96, ["Mega"] = 131.25, ["Mega|Ride"] = 136.5, ["Mega|Fly|Ride"] = 210.78}},
    ["rbxassetid://7734900468"] = {name = "Halloween White Skeleton Dog", prices = {["default"] = 5.25, ["Fly"] = 36.04, ["Ride"] = 23.62, ["Fly|Ride"] = 78.59, ["Neon"] = 31.49, ["Neon|Fly"] = 281.17, ["Neon|Ride"] = 49.56, ["Neon|Fly|Ride"] = 127.09, ["Mega"] = 213.56, ["Mega|Ride"] = 190.08, ["Mega|Fly|Ride"] = 278.53}},
    ["rbxassetid://9982202041"] = {name = "Poodle", prices = {["default"] = 2.1, ["Ride"] = 19.07, ["Fly|Ride"] = 36.02, ["Neon"] = 2.1, ["Neon|Fly"] = 31.5, ["Neon|Ride"] = 17.22, ["Neon|Fly|Ride"] = 48.51, ["Mega"] = 15.74, ["Mega|Ride"] = 31.49, ["Mega|Fly|Ride"] = 96.87}},
    ["rbxassetid://73671766703168"] = {name = "Pilot Gull", prices = {["default"] = 2.1, ["Ride"] = 31.79, ["Neon"] = 3.93, ["Neon|Fly"] = 42.37, ["Mega"] = 19.69, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 64.32, ["Mega|Fly|Ride"] = 150.99}},
    ["rbxassetid://14146127209"] = {name = "Indian Leopard", prices = {["default"] = 2.1, ["Fly"] = 132.8, ["Ride"] = 72.02, ["Fly|Ride"] = 63.56, ["Neon"] = 22.32, ["Neon|Ride"] = 89.92, ["Mega"] = 134.51, ["Mega|Ride"] = 152.3}},
    ["rbxassetid://113558592714438"] = {name = "Seabed Creeper", prices = {["default"] = 42.37, ["Ride"] = 315, ["Fly|Ride"] = 170.62, ["Neon"] = 220.59, ["Neon|Ride"] = 452.82, ["Neon|Fly|Ride"] = 630, ["Mega"] = 536.95, ["Mega|Ride"] = 565.55}},
    ["rbxassetid://4281674713"] = {name = "Bee", prices = {["default"] = 3.15, ["Fly"] = 24.94, ["Ride"] = 18.36, ["Fly|Ride"] = 42.39, ["Neon"] = 15.75, ["Neon|Fly"] = 32.42, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 57.75, ["Mega"] = 111.57, ["Mega|Fly"] = 212.33, ["Mega|Ride"] = 112.88, ["Mega|Fly|Ride"] = 168.93}},
    ["rbxassetid://5862774392"] = {name = "Bat", prices = {["default"] = 3.67, ["Fly"] = 37.1, ["Ride"] = 25.41, ["Fly|Ride"] = 68.16, ["Neon"] = 17.71, ["Neon|Fly"] = 94.38, ["Neon|Ride"] = 31.79, ["Neon|Fly|Ride"] = 70.88, ["Mega"] = 125.35, ["Mega|Fly"] = 433.13, ["Mega|Ride"] = 130.39, ["Mega|Fly|Ride"] = 192.84}},
    ["rbxassetid://18223359092"] = {name = "Birthday Butterfly 2024", prices = {["default"] = 3.81, ["Fly"] = 19.69, ["Ride"] = 19.69, ["Fly|Ride"] = 91.88, ["Neon"] = 9.55, ["Neon|Fly"] = 47.2, ["Neon|Ride"] = 27.56, ["Neon|Fly|Ride"] = 108.02, ["Mega"] = 61.44, ["Mega|Fly"] = 146.16, ["Mega|Ride"] = 65.62, ["Mega|Fly|Ride"] = 141.56}},
    ["rbxassetid://17822765706"] = {name = "Pink Betta Fish", prices = {["default"] = 11.61, ["Fly"] = 281.69, ["Ride"] = 24.94, ["Neon"] = 31.49, ["Neon|Ride"] = 83.69, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 264.78, ["Mega|Fly"] = 294.9, ["Mega|Ride"] = 248.85, ["Mega|Fly|Ride"] = 629.87}},
    ["rbxassetid://14146174264"] = {name = "Rock Pigeon", prices = {["default"] = 6.57, ["Fly"] = 154.62, ["Fly|Ride"] = 131.25, ["Neon"] = 47.22, ["Neon|Ride"] = 105, ["Mega"] = 229.69, ["Mega|Ride"] = 565.55, ["Mega|Fly|Ride"] = 1059.05}},
    ["rbxassetid://11758575946"] = {name = "Water Moon Bear", prices = {["default"] = 3.29, ["Fly"] = 30.74, ["Ride"] = 23.31, ["Fly|Ride"] = 52.5, ["Neon"] = 31.86, ["Neon|Fly"] = 196.65, ["Neon|Ride"] = 113.4, ["Mega"] = 188.73, ["Mega|Ride"] = 235.94, ["Mega|Fly|Ride"] = 335.84}},
    ["rbxassetid://6498256132"] = {name = "Seahorse", prices = {["default"] = 2.1, ["Ride"] = 16.96, ["Fly|Ride"] = 36.02, ["Neon"] = 18.8, ["Neon|Fly"] = 84.73, ["Neon|Ride"] = 48.72, ["Neon|Fly|Ride"] = 67.78, ["Mega"] = 423.63, ["Mega|Ride"] = 234.71, ["Mega|Fly|Ride"] = 226.59}},
    ["rbxassetid://13664973582"] = {name = "Many Mackerel", prices = {["default"] = 183.75, ["Fly"] = 393.75, ["Ride"] = 209.99, ["Fly|Ride"] = 305.82, ["Neon"] = 904.71, ["Neon|Ride"] = 915.26, ["Neon|Fly|Ride"] = 1174.69, ["Mega|Fly|Ride"] = 3155.25}},
    ["rbxassetid://114806716799554"] = {name = "Ringmaster Gibbon", prices = {["default"] = 3.94, ["Ride"] = 30.68, ["Neon"] = 26.25, ["Neon|Fly|Ride"] = 282.75, ["Mega"] = 123.38, ["Mega|Ride"] = 211.87, ["Mega|Fly|Ride"] = 494.58}},
    ["rbxassetid://14360917588"] = {name = "Magma Moose", prices = {["default"] = 3.6, ["Ride"] = 27.56, ["Fly|Ride"] = 118.13, ["Neon"] = 22.42, ["Neon|Ride"] = 35.79, ["Neon|Fly|Ride"] = 139.65, ["Mega"] = 167.43, ["Mega|Ride"] = 211.82, ["Mega|Fly|Ride"] = 1179.51}},
    ["rbxassetid://18957942216"] = {name = "Starhopper", prices = {["default"] = 6.45, ["Fly|Ride"] = 158.06, ["Neon"] = 39.37, ["Neon|Fly|Ride"] = 635.36, ["Mega"] = 470.08, ["Mega|Ride"] = 471.81, ["Mega|Fly|Ride"] = 1007.35}},
    ["rbxassetid://3181727071"] = {name = "Puma", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 15.91, ["Fly|Ride"] = 36.02, ["Neon"] = 2.1, ["Neon|Fly"] = 28.76, ["Neon|Ride"] = 16.96, ["Neon|Fly|Ride"] = 40.8, ["Mega"] = 26.25, ["Mega|Fly"] = 70.97, ["Mega|Ride"] = 34.13, ["Mega|Fly|Ride"] = 84.74}},
    ["rbxassetid://4841039508"] = {name = "Rock", prices = {["default"] = 2.1, ["Fly"] = 56.44, ["Ride"] = 18.38, ["Fly|Ride"] = 42.38, ["Neon"] = 11.82, ["Neon|Ride"] = 23.14, ["Neon|Fly|Ride"] = 99.49, ["Mega"] = 141.39, ["Mega|Ride"] = 142.96, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://94235745630523"] = {name = "Rainbow Trout", prices = {["default"] = 3.94, ["Ride"] = 65.63, ["Fly|Ride"] = 77.44, ["Neon"] = 12.99, ["Neon|Ride"] = 140.44, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 65.63, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 235.12}},
    ["rbxassetid://4440867249"] = {name = "Llama", prices = {["default"] = 70.56, ["Fly"] = 186.39, ["Ride"] = 105.92, ["Fly|Ride"] = 138.53, ["Neon"] = 312.39, ["Neon|Ride"] = 393.73, ["Neon|Fly|Ride"] = 455.44, ["Mega|Ride"] = 3531.89, ["Mega|Fly|Ride"] = 1634.32}},
    ["rbxassetid://11571113805"] = {name = "Bloodhound", prices = {["default"] = 3.93, ["Fly"] = 85.32, ["Ride"] = 41.32, ["Fly|Ride"] = 65.54, ["Neon"] = 22.58, ["Neon|Ride"] = 55.2, ["Neon|Fly|Ride"] = 135.66, ["Mega"] = 218.18, ["Mega|Ride"] = 229.69, ["Mega|Fly|Ride"] = 629.87}},
    ["rbxassetid://78423968285099"] = {name = "Wren", prices = {["default"] = 2.1, ["Fly"] = 31.78, ["Ride"] = 52.5, ["Fly|Ride"] = 165.22, ["Neon"] = 12.99, ["Neon|Ride"] = 57.2, ["Neon|Fly|Ride"] = 169.44, ["Mega"] = 75.22, ["Mega|Fly"] = 413.03, ["Mega|Ride"] = 126, ["Mega|Fly|Ride"] = 240.19}},
    ["rbxassetid://110871792705214"] = {name = "Burger Bear", prices = {["default"] = 57.73, ["Fly"] = 124.69, ["Ride"] = 109.1, ["Fly|Ride"] = 158.06, ["Neon"] = 153.57, ["Neon|Ride"] = 224.12, ["Neon|Fly|Ride"] = 332.07, ["Mega"] = 577.5, ["Mega|Ride"] = 627.38, ["Mega|Fly|Ride"] = 630}},
    ["rbxassetid://3181727637"] = {name = "Fennec Fox", prices = {["default"] = 2.1, ["Fly"] = 10.5, ["Ride"] = 15.21, ["Fly|Ride"] = 59.32, ["Neon"] = 2.1, ["Neon|Fly"] = 31.86, ["Neon|Ride"] = 16.96, ["Neon|Fly|Ride"] = 42.37, ["Mega"] = 22.05, ["Mega|Fly"] = 42.38, ["Mega|Ride"] = 31.77, ["Mega|Fly|Ride"] = 78.75}},
    ["rbxassetid://115530716039589"] = {name = "Milk Choccybunny", prices = {["default"] = 2.1, ["Neon"] = 3.93, ["Neon|Ride"] = 42.37, ["Neon|Fly|Ride"] = 99.57, ["Mega"] = 27.46, ["Mega|Ride"] = 90.57, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://83001092186817"] = {name = "White Choccybunny", prices = {["default"] = 3.93, ["Ride"] = 158.06, ["Neon"] = 11.82, ["Neon|Ride"] = 61.15, ["Mega"] = 61.69, ["Mega|Ride"] = 147}},
    ["rbxassetid://103795616446776"] = {name = "Waffle Wyrm", prices = {["default"] = 6.38, ["Fly"] = 57.75, ["Ride"] = 54.87, ["Fly|Ride"] = 120.53, ["Neon"] = 38.06, ["Neon|Fly"] = 180.02, ["Neon|Ride"] = 57.2, ["Neon|Fly|Ride"] = 177.18, ["Mega"] = 471.81, ["Mega|Fly"] = 314.94, ["Mega|Ride"] = 156.85, ["Mega|Fly|Ride"] = 260.55}},
    ["rbxassetid://9982358951"] = {name = "Orangutan", prices = {["default"] = 2.1, ["Fly"] = 13.13, ["Ride"] = 14.95, ["Fly|Ride"] = 34.13, ["Neon"] = 2.1, ["Neon|Ride"] = 35.37, ["Neon|Fly|Ride"] = 63.55, ["Mega"] = 20.88, ["Mega|Ride"] = 41.32, ["Mega|Fly|Ride"] = 98.44}},
    ["rbxassetid://129021417712364"] = {name = "Kage Crow", prices = {["default"] = 11.75, ["Ride"] = 42.38, ["Fly|Ride"] = 200.48, ["Neon"] = 59.07, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 184.26, ["Mega"] = 381.27, ["Mega|Ride"] = 475.52, ["Mega|Fly|Ride"] = 313.49}},
    ["rbxassetid://4849941238"] = {name = "Hedgehog", prices = {["default"] = 2623.69, ["Fly"] = 3150, ["Ride"] = 2493.75, ["Fly|Ride"] = 2625}},
    ["rbxassetid://4800190144"] = {name = "Ginger Cat", prices = {["default"] = 2.1, ["Fly"] = 52.49, ["Ride"] = 15.75, ["Fly|Ride"] = 47.25, ["Neon"] = 5.25, ["Neon|Fly"] = 68.6, ["Neon|Ride"] = 26.24, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 89.25, ["Mega|Ride"] = 102.52, ["Mega|Fly|Ride"] = 160.92}},
    ["rbxassetid://18119333909"] = {name = "Rodeo Bull", prices = {["default"] = 5.25, ["Neon"] = 12.47, ["Mega"] = 126, ["Mega|Ride"] = 437.07, ["Mega|Fly|Ride"] = 635.43}},
    ["rbxassetid://11837080223"] = {name = "Highland Cow", prices = {["default"] = 19.69, ["Ride"] = 35.44, ["Fly|Ride"] = 157.5, ["Neon"] = 94.5, ["Neon|Ride"] = 141.9, ["Neon|Fly|Ride"] = 254.26, ["Mega"] = 565.55, ["Mega|Ride"] = 397.69, ["Mega|Fly|Ride"] = 847.24}},
    ["rbxassetid://14398816006"] = {name = "Rooster", prices = {["default"] = 32.54, ["Ride"] = 78.75, ["Neon"] = 150.94, ["Mega"] = 540.75, ["Mega|Ride"] = 730.12, ["Mega|Fly|Ride"] = 1458.19}},
    ["rbxassetid://3409444089"] = {name = "Hyena", prices = {["default"] = 152.09, ["Fly"] = 282.95, ["Ride"] = 183.23, ["Fly|Ride"] = 279.57, ["Neon"] = 1312.5, ["Neon|Fly"] = 656.25, ["Neon|Ride"] = 689.85, ["Neon|Fly|Ride"] = 690.72, ["Mega"] = 6354.21, ["Mega|Fly|Ride"] = 2231.25}},
    ["rbxassetid://127067345833475"] = {name = "Hummingbird", prices = {["default"] = 8.97, ["Ride"] = 57.2, ["Fly|Ride"] = 675.94, ["Neon"] = 20.98, ["Neon|Fly"] = 70.96, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 99.57, ["Mega"] = 223.13, ["Mega|Fly"] = 169.87, ["Mega|Ride"] = 189.58, ["Mega|Fly|Ride"] = 253.32}},
    ["rbxassetid://130497948875084"] = {name = "Marabou Stork", prices = {["default"] = 2.1, ["Ride"] = 63.55, ["Neon"] = 14.43, ["Neon|Fly"] = 99.56, ["Neon|Ride"] = 42.37, ["Mega"] = 84.74, ["Mega|Ride"] = 261.03, ["Mega|Fly|Ride"] = 838.31}},
    ["rbxassetid://127017727552531"] = {name = "Angus Calf", prices = {["default"] = 2.1, ["Fly"] = 101.99, ["Ride"] = 33.91, ["Fly|Ride"] = 131.25, ["Neon"] = 10.4, ["Neon|Ride"] = 44.63, ["Mega"] = 76.13, ["Mega|Ride"] = 423.63, ["Mega|Fly|Ride"] = 269}},
    ["rbxassetid://12779130089"] = {name = "Sprout Snail", prices = {["default"] = 14.34, ["Neon|Ride"] = 1165.82, ["Neon|Fly|Ride"] = 211.82, ["Mega"] = 476.39, ["Mega|Ride"] = 422.58, ["Mega|Fly|Ride"] = 453.28}},
    ["rbxassetid://117824155556510"] = {name = "Princess Mare", prices = {["default"] = 2.1, ["Ride"] = 70.96, ["Neon"] = 2.1, ["Neon|Ride"] = 32.82, ["Mega"] = 15.75, ["Mega|Ride"] = 57.75, ["Mega|Fly|Ride"] = 282.78}},
    ["rbxassetid://122766274014139"] = {name = "Gaelic Fae", prices = {["default"] = 82.69, ["Ride"] = 91.88, ["Fly|Ride"] = 131.25, ["Neon|Ride"] = 409.5, ["Neon|Fly|Ride"] = 418.69, ["Mega"] = 1365, ["Mega|Ride"] = 1415.61}},
    ["rbxassetid://17255807019"] = {name = "Weevil", prices = {["default"] = 2.1, ["Ride"] = 32.65, ["Neon"] = 6.36, ["Neon|Ride"] = 100.61, ["Mega"] = 94.38, ["Mega|Ride"] = 122.84}},
    ["rbxassetid://3743720235"] = {name = "Capybara", prices = {["default"] = 43.31, ["Fly"] = 220.55, ["Ride"] = 76.13, ["Fly|Ride"] = 149.94, ["Neon"] = 265.83, ["Neon|Ride"] = 366.99, ["Neon|Fly|Ride"] = 529.47, ["Mega"] = 2625, ["Mega|Ride"] = 2824.45, ["Mega|Fly|Ride"] = 1156.32}},
    ["rbxassetid://106815320234576"] = {name = "Ehecatl", prices = {["default"] = 2.1, ["Fly"] = 33.87, ["Ride"] = 52.5, ["Fly|Ride"] = 70.97, ["Neon"] = 6.33, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 94.5, ["Mega"] = 42, ["Mega|Ride"] = 61.44, ["Mega|Fly|Ride"] = 206.73}},
    ["rbxassetid://110449571836616"] = {name = "Irish Setter", prices = {["default"] = 2.1, ["Ride"] = 2259.99, ["Neon"] = 18.38, ["Neon|Ride"] = 91.88, ["Mega"] = 65.61, ["Mega|Ride"] = 108.94, ["Mega|Fly|Ride"] = 544.69}},
    ["rbxassetid://93751644677101"] = {name = "Winter Doe", prices = {["default"] = 9.09, ["Ride"] = 210, ["Fly|Ride"] = 157.5, ["Neon"] = 74.2, ["Neon|Ride"] = 141.9, ["Neon|Fly|Ride"] = 692.53, ["Mega"] = 198.26, ["Mega|Ride"] = 288.75, ["Mega|Fly|Ride"] = 953.14}},
    ["rbxassetid://90667836208550"] = {name = "Munchkin Cat", prices = {["default"] = 347.28, ["Ride"] = 397.6, ["Fly|Ride"] = 472.5, ["Neon"] = 1102.5, ["Neon|Ride"] = 1217.1, ["Neon|Fly|Ride"] = 1355.29, ["Mega"] = 4193.78, ["Mega|Ride"] = 3806.25, ["Mega|Fly|Ride"] = 3543.75}},
    ["rbxassetid://3743734696"] = {name = "Rhino", prices = {["default"] = 40.69, ["Ride"] = 52.5, ["Fly|Ride"] = 75.9, ["Neon"] = 235.92, ["Neon|Fly"] = 314.95, ["Neon|Ride"] = 158.1, ["Neon|Fly|Ride"] = 201.21, ["Mega"] = 702.16, ["Mega|Fly|Ride"] = 754.89}},
    ["rbxassetid://7734928397"] = {name = "Halloween Blue Scorpion", prices = {["default"] = 2.1, ["Fly"] = 34.13, ["Ride"] = 18.38, ["Fly|Ride"] = 72.19, ["Neon"] = 7.51, ["Neon|Fly"] = 85.32, ["Neon|Ride"] = 28.61, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 105, ["Mega|Ride"] = 71.19, ["Mega|Fly|Ride"] = 786.75}},
    ["rbxassetid://116859365721104"] = {name = "Shadow Dragon Ducky", prices = {["default"] = 13.02, ["Fly"] = 110.15, ["Ride"] = 24.36, ["Fly|Ride"] = 91.87, ["Neon"] = 40.09, ["Neon|Fly"] = 198.02, ["Neon|Ride"] = 74.82, ["Neon|Fly|Ride"] = 171.33, ["Mega"] = 227.07, ["Mega|Fly"] = 396.1, ["Mega|Ride"] = 246.69, ["Mega|Fly|Ride"] = 294}},
    ["rbxassetid://6060991084"] = {name = "Musk Ox", prices = {["default"] = 7.87, ["Ride"] = 36.02, ["Fly|Ride"] = 70.95, ["Neon"] = 105, ["Neon|Ride"] = 99.56, ["Mega|Ride"] = 471.87, ["Mega|Fly|Ride"] = 583.86}},
    ["rbxassetid://119284351481681"] = {name = "Violet Friend", prices = {["default"] = 3.94, ["Neon"] = 19, ["Neon|Fly|Ride"] = 169.44, ["Mega"] = 62.91, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 406.88}},
    ["rbxassetid://10971808356"] = {name = "Basilisk", prices = {["default"] = 2.1, ["Fly"] = 86.63, ["Ride"] = 22.19, ["Fly|Ride"] = 66.73, ["Neon"] = 26.25, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 216.03, ["Mega"] = 550.83, ["Mega|Ride"] = 423.63, ["Mega|Fly|Ride"] = 494.58}},
    ["rbxassetid://3744706727"] = {name = "Platypus", prices = {["default"] = 113.87, ["Fly"] = 131.25, ["Ride"] = 125.98, ["Fly|Ride"] = 223.13, ["Neon"] = 570.9, ["Neon|Ride"] = 615.55, ["Neon|Fly|Ride"] = 565.88, ["Mega"] = 2454.84, ["Mega|Ride"] = 2570.28, ["Mega|Fly|Ride"] = 2853.04}},
    ["rbxassetid://12480556316"] = {name = "Black Macaque", prices = {["default"] = 26.25, ["Ride"] = 85.1, ["Fly|Ride"] = 144.04, ["Neon"] = 192.94, ["Neon|Ride"] = 189.56, ["Mega"] = 705.33, ["Mega|Ride"] = 706.38}},
    ["rbxassetid://4849941000"] = {name = "Dalmatian", prices = {["default"] = 2625, ["Fly"] = 2349.23, ["Ride"] = 2837.82, ["Fly|Ride"] = 2315.25, ["Neon"] = 12706.84, ["Neon|Fly|Ride"] = 6902.54, ["Mega|Fly|Ride"] = 26250}},
    ["rbxassetid://139319822015938"] = {name = "Sea Skeleton Panda", prices = {["default"] = 3.67, ["Fly"] = 65625, ["Ride"] = 41.89, ["Fly|Ride"] = 170.63, ["Neon"] = 13.13, ["Neon|Ride"] = 36.02, ["Neon|Fly|Ride"] = 198.02, ["Mega"] = 110.99, ["Mega|Ride"] = 169.32, ["Mega|Fly|Ride"] = 423.63}},
    ["rbxassetid://104838807480936"] = {name = "Winter Fawn", prices = {["default"] = 13.13, ["Ride"] = 65.63, ["Neon"] = 45.55, ["Neon|Fly|Ride"] = 211.79, ["Mega"] = 198.06, ["Mega|Ride"] = 338.9, ["Mega|Fly|Ride"] = 673.32}},
    ["rbxassetid://100705885132301"] = {name = "Cabbit", prices = {["default"] = 945, ["Fly"] = 1412.59, ["Ride"] = 900.38, ["Fly|Ride"] = 1018.49, ["Neon"] = 2598.75, ["Neon|Ride"] = 2493.75, ["Neon|Fly|Ride"] = 2526.57, ["Mega|Fly|Ride"] = 15815.58}},
    ["rbxassetid://12480406935"] = {name = "Binturong", prices = {["default"] = 45.94, ["Ride"] = 66.09, ["Fly|Ride"] = 262.5, ["Neon"] = 235.92, ["Neon|Ride"] = 291.72, ["Mega"] = 777.35, ["Mega|Ride"] = 803.25, ["Mega|Fly|Ride"] = 752.07}},
    ["rbxassetid://73245262062822"] = {name = "Prism Snake", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 23.63, ["Neon"] = 21, ["Neon|Ride"] = 74.13, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 194.92, ["Mega|Fly|Ride"] = 235.92}},
    ["rbxassetid://113717425344888"] = {name = "Magpie", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Neon"] = 6.38, ["Neon|Ride"] = 52.5, ["Mega"] = 27.2, ["Mega|Ride"] = 68.25, ["Mega|Fly|Ride"] = 127.1}},
    ["rbxassetid://10318105900"] = {name = "Purple Butterfly", prices = {["default"] = 91.85, ["Ride"] = 125.99, ["Fly|Ride"] = 141.92, ["Neon"] = 706.3, ["Neon|Fly|Ride"] = 544.69, ["Mega"] = 8472.27, ["Mega|Fly|Ride"] = 2673.93}},
    ["rbxassetid://95049698731940"] = {name = "Throwback Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15503941919"] = {name = "Arctic Hare", prices = {["default"] = 3.93, ["Neon"] = 26.25, ["Neon|Ride"] = 113.32, ["Mega"] = 212.63}},
    ["rbxassetid://10274421272"] = {name = "Royal Corgi", prices = {["default"] = 78.75, ["Ride"] = 291.38, ["Neon"] = 414.09, ["Neon|Ride"] = 449, ["Mega"] = 1836.37, ["Mega|Fly|Ride"] = 1800.37}},
    ["rbxassetid://13978968837"] = {name = "Bird of Paradise", prices = {["default"] = 5.15, ["Fly"] = 105, ["Fly|Ride"] = 113.33, ["Neon"] = 38.13, ["Neon|Fly|Ride"] = 315, ["Mega"] = 226.73, ["Mega|Fly|Ride"] = 282.78}},
    ["rbxassetid://3261465850"] = {name = "Pink Cat", prices = {["default"] = 246.09, ["Ride"] = 269.3, ["Fly|Ride"] = 315, ["Neon"] = 1101.68, ["Neon|Ride"] = 989.73, ["Neon|Fly|Ride"] = 967.32, ["Mega|Fly|Ride"] = 4057.16}},
    ["rbxassetid://8969010905"] = {name = "Red Fox", prices = {["default"] = 5.25, ["Fly"] = 87.46, ["Ride"] = 31.79, ["Fly|Ride"] = 70.97, ["Neon"] = 42.38, ["Neon|Ride"] = 64.15, ["Neon|Fly|Ride"] = 113.32, ["Mega"] = 250.04, ["Mega|Ride"] = 656.25, ["Mega|Fly|Ride"] = 435.26}},
    ["rbxassetid://3181728128"] = {name = "Red Panda", prices = {["default"] = 2.1, ["Fly"] = 18.15, ["Ride"] = 17.07, ["Fly|Ride"] = 36.02, ["Neon"] = 3.92, ["Neon|Fly"] = 38.07, ["Neon|Ride"] = 22.42, ["Neon|Fly|Ride"] = 61.44, ["Mega"] = 41.32, ["Mega|Fly"] = 104.87, ["Mega|Ride"] = 121.64, ["Mega|Fly|Ride"] = 105.92}},
    ["rbxassetid://13077769577"] = {name = "Pelican", prices = {["default"] = 832.13, ["Fly"] = 1214.57, ["Ride"] = 903, ["Fly|Ride"] = 1040.8, ["Neon|Ride"] = 7766.01, ["Neon|Fly|Ride"] = 4235.63, ["Mega"] = 28307.88}},
    ["rbxassetid://115281603518501"] = {name = "DJ Snooze", prices = {["default"] = 6.57, ["Fly"] = 989.63, ["Ride"] = 42.38, ["Neon"] = 42.3, ["Neon|Ride"] = 52.5, ["Mega"] = 151.06, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 369.48}},
    ["rbxassetid://111847888001946"] = {name = "Choco Penguin", prices = {["default"] = 8.77, ["Fly"] = 47.19, ["Ride"] = 44.16, ["Fly|Ride"] = 108.94, ["Neon"] = 30.73, ["Neon|Ride"] = 63.71, ["Neon|Fly|Ride"] = 139.79, ["Mega"] = 183.75, ["Mega|Ride"] = 190.09, ["Mega|Fly|Ride"] = 274.28}},
    ["rbxassetid://4621220487"] = {name = "Panda", prices = {["default"] = 38.06, ["Fly"] = 40.51, ["Ride"] = 38.75, ["Fly|Ride"] = 59.06, ["Neon|Ride"] = 183.7, ["Neon|Fly|Ride"] = 210, ["Mega"] = 2118.08, ["Mega|Fly|Ride"] = 779.45}},
    ["rbxassetid://12917347184"] = {name = "Flower Power Duckling", prices = {["default"] = 15.74, ["Fly"] = 79.44, ["Ride"] = 35.44, ["Fly|Ride"] = 86.52, ["Neon"] = 87.9, ["Neon|Ride"] = 105.91, ["Neon|Fly|Ride"] = 282.75, ["Mega"] = 393.75, ["Mega|Ride"] = 353.74, ["Mega|Fly|Ride"] = 442.31}},
    ["rbxassetid://93775555430694"] = {name = "Pumpkin Friend", prices = {["default"] = 30.37, ["Ride"] = 183.75, ["Fly|Ride"] = 111.57, ["Neon"] = 109.08, ["Neon|Ride"] = 211.79, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 508.66, ["Mega|Ride"] = 409.86, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://83317902236850"] = {name = "Kakapo", prices = {["default"] = 2.1, ["Fly"] = 63.55, ["Ride"] = 116.59, ["Fly|Ride"] = 235.91, ["Neon"] = 3.93, ["Neon|Ride"] = 28.13, ["Mega"] = 21.2, ["Mega|Fly"] = 84.95, ["Mega|Ride"] = 141.92}},
    ["rbxassetid://5862774043"] = {name = "Ghost Bunny", prices = {["default"] = 44.63, ["Fly"] = 63.55, ["Ride"] = 47.2, ["Fly|Ride"] = 70.97, ["Neon"] = 191.13, ["Neon|Fly"] = 310.21, ["Neon|Ride"] = 236.12, ["Neon|Fly|Ride"] = 242.82, ["Mega"] = 3388.92, ["Mega|Fly|Ride"] = 1116.2}},
    ["rbxassetid://10639131895"] = {name = "Spider Crab", prices = {["default"] = 2.1, ["Fly"] = 89.66, ["Ride"] = 28.62, ["Fly|Ride"] = 65.63, ["Neon"] = 42, ["Neon|Ride"] = 141.07, ["Neon|Fly|Ride"] = 141.92, ["Mega"] = 773.07, ["Mega|Ride"] = 271.69, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://10193736072"] = {name = "Red Crowned Crane", prices = {["default"] = 2.1, ["Fly"] = 26.16, ["Ride"] = 16.96, ["Fly|Ride"] = 36.75, ["Neon"] = 27.46, ["Neon|Ride"] = 42.37, ["Neon|Fly|Ride"] = 131.24, ["Mega"] = 1057.98, ["Mega|Ride"] = 282.78, ["Mega|Fly|Ride"] = 203.44}},
    ["rbxassetid://13804047294"] = {name = "Arctic Tern", prices = {["default"] = 4.5, ["Ride"] = 141.92, ["Neon"] = 57.21, ["Neon|Fly|Ride"] = 105.91, ["Mega"] = 296.71, ["Mega|Fly|Ride"] = 471.81}},
    ["rbxassetid://14883937353"] = {name = "Ghost Dog", prices = {["default"] = 16.75, ["Fly"] = 262.13, ["Ride"] = 49.8, ["Neon"] = 116.81, ["Neon|Ride"] = 174.57, ["Neon|Fly|Ride"] = 211.79, ["Mega|Ride"] = 634.76, ["Mega|Fly|Ride"] = 511.88}},
    ["rbxassetid://103241919688695"] = {name = "2025 Birthday Butterfly", prices = {["default"] = 8.54, ["Ride"] = 98.44, ["Neon"] = 18.38, ["Neon|Ride"] = 63.55, ["Neon|Fly|Ride"] = 113.32, ["Mega"] = 104.87, ["Mega|Fly|Ride"] = 314.94}},
    ["rbxassetid://86594144838863"] = {name = "Tree Frog", prices = {["default"] = 2.1, ["Ride"] = 27.56, ["Neon"] = 2.1, ["Neon|Ride"] = 26.25, ["Mega"] = 18.27, ["Mega|Ride"] = 52.38, ["Mega|Fly|Ride"] = 202.79}},
    ["rbxassetid://99048375832409"] = {name = "Shih Tzu", prices = {["default"] = 2.1, ["Ride"] = 27.36, ["Neon"] = 2.1, ["Neon|Fly"] = 393.59, ["Neon|Ride"] = 28.61, ["Mega"] = 23.63, ["Mega|Fly"] = 73.86, ["Mega|Ride"] = 38.56, ["Mega|Fly|Ride"] = 112.89}},
    ["rbxassetid://6998403122"] = {name = "Kirin", prices = {["default"] = 2.1, ["Fly"] = 25.89, ["Ride"] = 24, ["Fly|Ride"] = 40.05, ["Neon"] = 5.81, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 25.43, ["Neon|Fly|Ride"] = 84.95, ["Mega"] = 99.57, ["Mega|Ride"] = 127.09, ["Mega|Fly|Ride"] = 176.88}},
    ["rbxassetid://15930472964"] = {name = "Gila Monster", prices = {["default"] = 2.1, ["Ride"] = 28.58, ["Fly|Ride"] = 57.21, ["Neon"] = 13.13, ["Neon|Ride"] = 1312.5, ["Mega"] = 142.01, ["Mega|Ride"] = 148.24, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://5721843144"] = {name = "Dilophosaurus", prices = {["default"] = 2.1, ["Fly"] = 18.88, ["Ride"] = 17.07, ["Fly|Ride"] = 42.4, ["Neon"] = 16.89, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 80.07, ["Mega"] = 281.54, ["Mega|Ride"] = 223.13, ["Mega|Fly|Ride"] = 361.6}},
    ["rbxassetid://109520235810036"] = {name = "Mini Schnauzer", prices = {["default"] = 65.63, ["Fly|Ride"] = 396.1, ["Neon"] = 210.74, ["Neon|Ride"] = 413.18, ["Neon|Fly|Ride"] = 1058.92, ["Mega"] = 1030.45, ["Mega|Fly"] = 1002.92, ["Mega|Ride"] = 1050, ["Mega|Fly|Ride"] = 957.07}},
    ["rbxassetid://3181728229"] = {name = "Snow Cat", prices = {["default"] = 2.1, ["Fly"] = 26.19, ["Ride"] = 17.07, ["Fly|Ride"] = 36.02, ["Neon"] = 2.61, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 20.14, ["Neon|Fly|Ride"] = 56.88, ["Mega"] = 38.96, ["Mega|Ride"] = 56.44, ["Mega|Fly|Ride"] = 127.32}},
    ["rbxassetid://4506925747"] = {name = "Wolf", prices = {["default"] = 8.39, ["Fly"] = 42.37, ["Ride"] = 37.08, ["Fly|Ride"] = 70.97, ["Neon"] = 52.5, ["Neon|Fly"] = 70.96, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 105.16, ["Mega"] = 328.13, ["Mega|Ride"] = 275.37, ["Mega|Fly|Ride"] = 295.07}},
    ["rbxassetid://5862774473"] = {name = "Albino Bat", prices = {["default"] = 13.01, ["Fly"] = 57.2, ["Ride"] = 27.57, ["Fly|Ride"] = 57.21, ["Neon"] = 45.94, ["Neon|Fly"] = 135.55, ["Neon|Ride"] = 70.96, ["Neon|Fly|Ride"] = 154.43, ["Mega"] = 1270.85, ["Mega|Ride"] = 420, ["Mega|Fly|Ride"] = 449.88}},
    ["rbxassetid://14978701751"] = {name = "Scarecrow", prices = {["default"] = 3.67, ["Fly"] = 140.38, ["Ride"] = 47.2, ["Neon"] = 26.17, ["Neon|Ride"] = 70.96, ["Mega"] = 196.87, ["Mega|Ride"] = 249.38}},
    ["rbxassetid://10235589000"] = {name = "Corgi", prices = {["default"] = 2.1, ["Fly"] = 17.71, ["Ride"] = 17.33, ["Fly|Ride"] = 67.25, ["Neon"] = 3.83, ["Neon|Fly"] = 59.07, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 64.32, ["Mega"] = 44.6, ["Mega|Fly"] = 91.88, ["Mega|Ride"] = 52.5, ["Mega|Fly|Ride"] = 240.41}},
    ["rbxassetid://103710623311342"] = {name = "Ghost Chick", prices = {["default"] = 2.63, ["Fly"] = 78.07, ["Ride"] = 28.61, ["Fly|Ride"] = 141.39, ["Neon"] = 18.38, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 100.61, ["Neon|Fly|Ride"] = 158.86, ["Mega"] = 126, ["Mega|Fly"] = 735, ["Mega|Ride"] = 103.69, ["Mega|Fly|Ride"] = 283.5}},
    ["rbxassetid://4440866423"] = {name = "Cow", prices = {["default"] = 1050, ["Ride"] = 984.38, ["Fly|Ride"] = 1113.4, ["Neon|Ride"] = 2310, ["Neon|Fly|Ride"] = 2323.13, ["Mega|Fly|Ride"] = 7434}},
    ["rbxassetid://15093139154"] = {name = "Slime", prices = {["default"] = 45.94, ["Ride"] = 112.63, ["Neon"] = 260.24, ["Neon|Ride"] = 316.32, ["Neon|Fly|Ride"] = 303.93, ["Mega"] = 1367.23, ["Mega|Ride"] = 1340.75, ["Mega|Fly|Ride"] = 1252.52}},
    ["rbxassetid://82170828935980"] = {name = "Dracula Fish", prices = {["default"] = 2.1, ["Fly"] = 74.13, ["Neon"] = 5.25, ["Neon|Ride"] = 75.45, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 65.63, ["Mega|Fly|Ride"] = 158.07}},
    ["rbxassetid://11109302289"] = {name = "Zombie Wolf", prices = {["default"] = 32.82, ["Ride"] = 56.44, ["Fly|Ride"] = 184.29, ["Neon"] = 190.8, ["Neon|Ride"] = 235.94, ["Neon|Fly|Ride"] = 276.55, ["Mega"] = 1258.53, ["Mega|Ride"] = 994.88, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://15369729071"] = {name = "Nutcracker Squirrel", prices = {["default"] = 7.87, ["Ride"] = 27.28, ["Fly|Ride"] = 281.72, ["Neon"] = 67.78, ["Neon|Ride"] = 72.08, ["Neon|Fly|Ride"] = 282.78, ["Mega"] = 282.78, ["Mega|Fly|Ride"] = 1059.05}},
    ["rbxassetid://9800792849"] = {name = "Goat", prices = {["default"] = 267.72, ["Fly"] = 423.57, ["Ride"] = 282.19, ["Fly|Ride"] = 561.75, ["Neon"] = 984.38, ["Neon|Ride"] = 1320.38, ["Neon|Fly|Ride"] = 1048.95, ["Mega|Fly|Ride"] = 4091}},
    ["rbxassetid://12509687499"] = {name = "Banded Palm Civet", prices = {["default"] = 2.63, ["Fly"] = 102.37, ["Ride"] = 22.32, ["Fly|Ride"] = 129.93, ["Neon"] = 19.69, ["Mega"] = 400.33}},
    ["rbxassetid://10381386150"] = {name = "Rhino Beetle", prices = {["default"] = 2.1, ["Neon"] = 57.2, ["Neon|Ride"] = 141.9, ["Mega|Ride"] = 338.9}},
    ["rbxassetid://130734656883878"] = {name = "Merry Mistletroll", prices = {["default"] = 44.63, ["Ride"] = 91.88, ["Fly|Ride"] = 282.96, ["Neon"] = 131.25, ["Neon|Ride"] = 423.57, ["Mega"] = 1130, ["Mega|Ride"] = 714.67, ["Mega|Fly|Ride"] = 796.42}},
    ["rbxassetid://15923337068"] = {name = "Oryx", prices = {["default"] = 2.1, ["Ride"] = 48.54, ["Neon"] = 13.86, ["Mega"] = 224.54, ["Mega|Ride"] = 278.55}},
    ["rbxassetid://6245080365"] = {name = "Ox", prices = {["default"] = 2.1, ["Fly"] = 18.38, ["Ride"] = 15.9, ["Fly|Ride"] = 32.82, ["Neon"] = 3.28, ["Neon|Fly"] = 31.84, ["Neon|Ride"] = 20.98, ["Neon|Fly|Ride"] = 41.08, ["Mega"] = 63, ["Mega|Fly"] = 70.79, ["Mega|Ride"] = 41.32, ["Mega|Fly|Ride"] = 92.25}},
    ["rbxassetid://13810870050"] = {name = "African Wild Dog", prices = {["default"] = 4199.99, ["Ride"] = 4318.13, ["Fly|Ride"] = 4199.99, ["Neon"] = 18872.17, ["Neon|Fly|Ride"] = 21359.63, ["Mega|Fly|Ride"] = 45185.67}},
    ["rbxassetid://12596400214"] = {name = "Goldfish", prices = {["default"] = 10.48, ["Ride"] = 56.43, ["Neon"] = 141.56, ["Neon|Ride"] = 141.56, ["Mega"] = 459.38, ["Mega|Ride"] = 374.07, ["Mega|Fly|Ride"] = 523.69}},
    ["rbxassetid://4736656915"] = {name = "Australian Kelpie", prices = {["default"] = 3.94, ["Ride"] = 18.8, ["Fly|Ride"] = 44.63, ["Neon"] = 26.25, ["Neon|Ride"] = 34.13, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 283.1, ["Mega|Ride"] = 124.35, ["Mega|Fly|Ride"] = 203.85}},
    ["rbxassetid://3743711305"] = {name = "Crocodile", prices = {["default"] = 403.05, ["Fly"] = 515.7, ["Ride"] = 444.94, ["Fly|Ride"] = 472.5, ["Neon"] = 1050, ["Neon|Ride"] = 1594.69, ["Neon|Fly|Ride"] = 1526.27, ["Mega|Fly|Ride"] = 6072.5}},
    ["rbxassetid://74373220330198"] = {name = "Officer Gibbon", prices = {["default"] = 5.76, ["Ride"] = 52.5, ["Neon"] = 17.07, ["Neon|Ride"] = 158.06, ["Mega"] = 141.92, ["Mega|Fly|Ride"] = 690.38}},
    ["rbxassetid://18508184138"] = {name = "Peregrine Falcon", prices = {["default"] = 5.16, ["Fly"] = 110.12, ["Ride"] = 158.05, ["Neon"] = 94.35, ["Neon|Ride"] = 141.9, ["Neon|Fly|Ride"] = 164.07, ["Mega"] = 386.54, ["Mega|Ride"] = 401.63}},
    ["rbxassetid://92389214029179"] = {name = "Kaijunior", prices = {["default"] = 2.1, ["Ride"] = 30.73, ["Fly|Ride"] = 82.55, ["Neon"] = 7.87, ["Neon|Fly"] = 43.32, ["Neon|Ride"] = 30.19, ["Neon|Fly|Ride"] = 72.19, ["Mega"] = 37.36, ["Mega|Ride"] = 85.22, ["Mega|Fly|Ride"] = 156.76}},
    ["rbxassetid://3409443986"] = {name = "Flamingo", prices = {["default"] = 627.38, ["Fly"] = 734.89, ["Ride"] = 599.64, ["Fly|Ride"] = 670.69, ["Neon|Fly|Ride"] = 1966.02, ["Mega|Fly|Ride"] = 8751.75}},
    ["rbxassetid://126933432685319"] = {name = "Cattuccino", prices = {["default"] = 6.57, ["Ride"] = 65.63, ["Neon"] = 17.07, ["Neon|Ride"] = 99.56, ["Neon|Fly|Ride"] = 648.38, ["Mega"] = 147.18, ["Mega|Ride"] = 282.78, ["Mega|Fly|Ride"] = 283.57}},
    ["rbxassetid://11631390464"] = {name = "Ermine", prices = {["default"] = 6.57, ["Fly"] = 169.44, ["Ride"] = 54.28, ["Fly|Ride"] = 150.94, ["Neon"] = 50.93, ["Neon|Ride"] = 98.44, ["Neon|Fly|Ride"] = 3933.63, ["Mega"] = 236.36, ["Mega|Ride"] = 227.67, ["Mega|Fly|Ride"] = 334.84}},
    ["rbxassetid://4708551221"] = {name = "Emu", prices = {["default"] = 2.1, ["Fly"] = 28.54, ["Ride"] = 15.9, ["Fly|Ride"] = 35.49, ["Neon"] = 19.48, ["Neon|Ride"] = 31.49, ["Neon|Fly|Ride"] = 66.07, ["Mega"] = 196.88, ["Mega|Ride"] = 158.82, ["Mega|Fly|Ride"] = 190.32}},
    ["rbxassetid://16088266364"] = {name = "Burning Bunny", prices = {["default"] = 22.31, ["Ride"] = 57.21, ["Neon"] = 78.67, ["Neon|Fly"] = 170.63, ["Neon|Ride"] = 127.09, ["Neon|Fly|Ride"] = 314.95, ["Mega"] = 562.36, ["Mega|Ride"] = 452.82, ["Mega|Fly|Ride"] = 616.88}},
    ["rbxassetid://80832101513100"] = {name = "2026 Birthday Butterfly", prices = {["default"] = 2.1, ["Ride"] = 39.37, ["Neon"] = 3.94, ["Neon|Ride"] = 51.19, ["Neon|Fly|Ride"] = 208.69, ["Mega"] = 24.94, ["Mega|Ride"] = 87.77, ["Mega|Fly|Ride"] = 228.66}},
    ["rbxassetid://14639007389"] = {name = "Caterpillar", prices = {["default"] = 419.98, ["Ride"] = 485.63, ["Fly|Ride"] = 635.43, ["Neon"] = 2966.25, ["Neon|Ride"] = 2094.52, ["Neon|Fly|Ride"] = 2362.5, ["Mega|Ride"] = 9200.07, ["Mega|Fly|Ride"] = 7848.75}},
    ["rbxassetid://82920146813845"] = {name = "Little Lamb", prices = {["default"] = 2.1, ["Ride"] = 97.43, ["Neon"] = 6.57, ["Neon|Ride"] = 91.88, ["Mega"] = 53.82, ["Mega|Ride"] = 133.44, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://96424154406922"] = {name = "Crimson Cape", prices = {["default"] = 2.1, ["Ride"] = 27.33, ["Neon"] = 4.25, ["Neon|Fly"] = 141.9, ["Neon|Ride"] = 212.33, ["Neon|Fly|Ride"] = 131.24, ["Mega"] = 40.22, ["Mega|Fly"] = 80.5, ["Mega|Ride"] = 141.92}},
    ["rbxassetid://109008428989602"] = {name = "Pangolin", prices = {["default"] = 2.1, ["Ride"] = 60.37, ["Neon"] = 3.82, ["Neon|Ride"] = 34.13, ["Mega"] = 37.08, ["Mega|Ride"] = 92.14}},
    ["rbxassetid://16722909218"] = {name = "Floral Eggy", prices = {["default"] = 2.1, ["Ride"] = 131.25, ["Neon"] = 17.07, ["Mega"] = 211.82, ["Mega|Ride"] = 328.13}},
    ["rbxassetid://76735046136809"] = {name = "Frostbite Cub", prices = {["default"] = 52.49, ["Ride"] = 90.56, ["Fly|Ride"] = 203.44, ["Neon"] = 223.13, ["Neon|Ride"] = 301.88, ["Neon|Fly|Ride"] = 351.1, ["Mega"] = 669.38, ["Mega|Ride"] = 706.37, ["Mega|Fly|Ride"] = 749.53}},
    ["rbxassetid://15684947715"] = {name = "Quokka", prices = {["default"] = 24.86, ["Fly"] = 69.57, ["Ride"] = 86.63, ["Neon"] = 87.28, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 220.59, ["Mega"] = 463.1, ["Mega|Ride"] = 565.55, ["Mega|Fly|Ride"] = 496.11}},
    ["rbxassetid://5721843001"] = {name = "Deinonychus", prices = {["default"] = 2.1, ["Fly"] = 34.65, ["Ride"] = 17.1, ["Fly|Ride"] = 36.66, ["Neon"] = 30.38, ["Neon|Ride"] = 31.18, ["Neon|Fly|Ride"] = 59.91, ["Mega"] = 328.13, ["Mega|Ride"] = 209.7, ["Mega|Fly|Ride"] = 246.47}},
    ["rbxassetid://16999461770"] = {name = "Inmate Capuchin Monkey", prices = {["default"] = 11.82, ["Ride"] = 64.32, ["Neon"] = 169.44, ["Neon|Ride"] = 158.82, ["Neon|Fly|Ride"] = 211.79, ["Mega|Ride"] = 786.75, ["Mega|Fly|Ride"] = 565.55}},
    ["rbxassetid://119664699815373"] = {name = "Frozen Penguin", prices = {["default"] = 2.1, ["Ride"] = 32.87, ["Fly|Ride"] = 362.25, ["Neon"] = 18.38, ["Neon|Ride"] = 44.18, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 131.25, ["Mega|Ride"] = 211.82, ["Mega|Fly|Ride"] = 254.19}},
    ["rbxassetid://5067924307"] = {name = "Business Monkey", prices = {["default"] = 16.3, ["Ride"] = 32.84, ["Fly|Ride"] = 45.94, ["Neon"] = 228.74, ["Neon|Ride"] = 154.62, ["Neon|Fly|Ride"] = 141.9, ["Mega"] = 952.09, ["Mega|Ride"] = 989.15, ["Mega|Fly|Ride"] = 685.2}},
    ["rbxassetid://126192643157832"] = {name = "Manta Ray", prices = {["Fly"] = 874.13, ["Mega"] = 504.84, ["Mega|Ride"] = 590.63}},
    ["rbxassetid://4440866911"] = {name = "Silly Duck", prices = {["default"] = 52.5, ["Fly"] = 115.5, ["Ride"] = 94.5, ["Fly|Ride"] = 124.69, ["Neon"] = 296.51, ["Neon|Fly"] = 348.04, ["Neon|Ride"] = 299.25, ["Neon|Fly|Ride"] = 394.27, ["Mega|Ride"] = 1337.7, ["Mega|Fly|Ride"] = 1192.49}},
    ["rbxassetid://110544962124445"] = {name = "Cake Friend", prices = {["default"] = 52.5, ["Fly"] = 141.9, ["Ride"] = 105, ["Fly|Ride"] = 282.78, ["Neon"] = 156.6, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 314.95, ["Mega"] = 513.35, ["Mega|Ride"] = 564.69, ["Mega|Fly|Ride"] = 612.94}},
    ["rbxassetid://16127157068"] = {name = "Rice Cake Rabbit", prices = {["default"] = 19.69, ["Ride"] = 59.07, ["Neon"] = 141.57, ["Neon|Ride"] = 39.38, ["Mega"] = 562.36, ["Mega|Ride"] = 635.43, ["Mega|Fly|Ride"] = 1269.79}},
    ["rbxassetid://7734900613"] = {name = "Halloween Evil Dachshund", prices = {["default"] = 6.57, ["Ride"] = 21.25, ["Fly|Ride"] = 65.63, ["Neon"] = 45.94, ["Neon|Fly"] = 169.44, ["Neon|Ride"] = 71.76, ["Neon|Fly|Ride"] = 116.28, ["Mega"] = 289.98, ["Mega|Ride"] = 325.14, ["Mega|Fly|Ride"] = 354.38}},
    ["rbxassetid://9664282145"] = {name = "Robot", prices = {["default"] = 2.1, ["Fly"] = 28.61, ["Ride"] = 15.9, ["Fly|Ride"] = 38.96, ["Neon"] = 3.59, ["Neon|Fly"] = 24.89, ["Neon|Ride"] = 22.32, ["Neon|Fly|Ride"] = 57.75, ["Mega"] = 42, ["Mega|Fly"] = 706.38, ["Mega|Ride"] = 63, ["Mega|Fly|Ride"] = 186.4}},
    ["rbxassetid://3261465791"] = {name = "Pink Egg", prices = {["default"] = 986.56}},
    ["rbxassetid://126725051633301"] = {name = "Headless Horse", prices = {["default"] = 17.84, ["Ride"] = 76.26, ["Fly|Ride"] = 126.21, ["Neon"] = 127.09, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 471.81, ["Mega"] = 423.63, ["Mega|Ride"] = 409.86, ["Mega|Fly|Ride"] = 504}},
    ["rbxassetid://88554799028713"] = {name = "Sneak Weasel", prices = {["default"] = 2.1, ["Ride"] = 47.19, ["Neon"] = 3.92, ["Neon|Ride"] = 37.08, ["Neon|Fly|Ride"] = 296.69, ["Mega"] = 26.24, ["Mega|Ride"] = 103.69, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://14639008203"] = {name = "English Sheepdog", prices = {["default"] = 32.61, ["Ride"] = 65.63, ["Fly|Ride"] = 282.78, ["Neon"] = 203.33, ["Neon|Ride"] = 169.44, ["Neon|Fly|Ride"] = 544.69, ["Mega"] = 633.94, ["Mega|Ride"] = 834.53, ["Mega|Fly|Ride"] = 565.55}},
    ["rbxassetid://133131190079833"] = {name = "Oakee", prices = {["default"] = 2.1, ["Neon"] = 3.93, ["Neon|Ride"] = 105, ["Mega"] = 34.13}},
    ["rbxassetid://79856043024325"] = {name = "Chestnut Glyptodon", prices = {["default"] = 2.1, ["Neon"] = 4.25, ["Mega"] = 23.63, ["Mega|Ride"] = 98.44, ["Mega|Fly|Ride"] = 273}},
    ["rbxassetid://12720028898"] = {name = "Hare", prices = {["default"] = 105.98, ["Ride"] = 173.7, ["Fly|Ride"] = 267.77, ["Neon"] = 597.19, ["Neon|Ride"] = 518.44, ["Neon|Fly|Ride"] = 668.18, ["Mega|Ride"] = 6487.23, ["Mega|Fly|Ride"] = 2100}},
    ["rbxassetid://16897788024"] = {name = "Capuchin Monkey", prices = {["default"] = 2.1, ["Fly"] = 26.11, ["Ride"] = 19.07, ["Fly|Ride"] = 127.1, ["Neon"] = 10.39, ["Neon|Fly"] = 63.55, ["Neon|Ride"] = 40.24, ["Neon|Fly|Ride"] = 92.19, ["Mega"] = 107.62, ["Mega|Ride"] = 112.88, ["Mega|Fly|Ride"] = 565.55}},
    ["rbxassetid://121639546210522"] = {name = "Amber Butterfly", prices = {["default"] = 2.1, ["Fly"] = 30.97, ["Ride"] = 131.25, ["Fly|Ride"] = 86.63, ["Neon"] = 6.29, ["Neon|Ride"] = 57.2, ["Neon|Fly|Ride"] = 101.67, ["Mega"] = 38.25, ["Mega|Ride"] = 93.44, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://79005166120532"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Fly"] = 45.94, ["Ride"] = 19.69, ["Neon"] = 3.92, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 35.44, ["Mega"] = 34.13, ["Mega|Ride"] = 76.27, ["Mega|Fly|Ride"] = 261.19}},
    ["rbxassetid://138741319376538"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 91.88, ["Neon"] = 5.25, ["Neon|Ride"] = 30.31, ["Neon|Fly|Ride"] = 85.32, ["Mega"] = 40.69, ["Mega|Ride"] = 95.7, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://133558151150234"] = {name = "Black Widow", prices = {["default"] = 39.38, ["Ride"] = 91.88, ["Fly|Ride"] = 449.61, ["Neon"] = 336.71, ["Neon|Ride"] = 346.27, ["Neon|Fly|Ride"] = 695.63, ["Mega"] = 1268.73, ["Mega|Ride"] = 1553.62, ["Mega|Fly|Ride"] = 1379.93}},
    ["rbxassetid://122945704087152"] = {name = "Chilling Spider", prices = {["default"] = 5.16, ["Ride"] = 139.8, ["Neon"] = 21, ["Neon|Ride"] = 110.9, ["Mega"] = 141.92, ["Mega|Ride"] = 574.23}},
    ["rbxassetid://1373237029"] = {name = "Big Head Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://2657668946"] = {name = "Cure All Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://1373237971"] = {name = "Grow Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4315743582"] = {name = "Honey Badger", prices = {["default"] = 328.13, ["Ride"] = 341.25, ["Fly|Ride"] = 448.21, ["Neon"] = 1270.69, ["Neon|Ride"] = 1125.63, ["Neon|Fly|Ride"] = 1200.81, ["Mega"] = 3642.02, ["Mega|Ride"] = 3596.49, ["Mega|Fly|Ride"] = 3176.73}},
    ["rbxassetid://1373208271"] = {name = "Hyperspeed Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4047157976"] = {name = "Fly Potion", prices = {["default"] = 72.19}},
    ["rbxassetid://3342628435"] = {name = "Ride Potion", prices = {["default"] = 43.04}},
    ["rbxassetid://1509389697"] = {name = "Adopt Me Boy Scooter", prices = {["default"] = 15.91}},
    ["rbxassetid://1509384540"] = {name = "Adopt Me Girl Scooter", prices = {["default"] = 20.88}},
    ["rbxassetid://1256627798"] = {name = "Adopt Me Snowboard 1", prices = {["default"] = 42.98}},
    ["rbxassetid://1256627585"] = {name = "Adopt Me Snowboard 2", prices = {["default"] = 39.38}},
    ["rbxassetid://2782643682"] = {name = "Axel", prices = {["default"] = 10.5}},
    ["rbxassetid://3009779146"] = {name = "Banana Car", prices = {["default"] = 16.42}},
    ["rbxassetid://1306904296"] = {name = "Bathtub", prices = {["default"] = 223.13}},
    ["rbxassetid://1307341557"] = {name = "Bethink Skateboard", prices = {["default"] = 22.32}},
    ["rbxassetid://908269395"] = {name = "Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://1509319125"] = {name = "Black Scooter", prices = {["default"] = 42.34}},
    ["rbxassetid://1306898658"] = {name = "Black Skateboard", prices = {["default"] = 78.75}},
    ["rbxassetid://1256625297"] = {name = "Black Snowboard", prices = {["default"] = 2.63}},
    ["rbxassetid://1266478264"] = {name = "Blue Neon Snowboard", prices = {["default"] = 262.43}},
    ["rbxassetid://4800244517"] = {name = "Blue Rider", prices = {["default"] = 2.1}},
    ["rbxassetid://1509318734"] = {name = "Blue Scooter", prices = {["default"] = 4.61}},
    ["rbxassetid://1306898360"] = {name = "Blue Skateboard", prices = {["default"] = 7.1}},
    ["rbxassetid://1256625905"] = {name = "Blue Snowboard", prices = {["default"] = 3.94}},
    ["rbxassetid://7165481985"] = {name = "Bubble Car", prices = {["default"] = 5.59}},
    ["rbxassetid://12115176522"] = {name = "Toxic Barrel", prices = {["default"] = 23.63}},
    ["rbxassetid://2657667116"] = {name = "Bunny Carriage", prices = {["default"] = 475.13}},
    ["rbxassetid://6475610034"] = {name = "Butterfly Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264167"] = {name = "Camper Van", prices = {["default"] = 2.1}},
    ["rbxassetid://2758237053"] = {name = "Car", prices = {["default"] = 2.1}},
    ["rbxassetid://14465252948"] = {name = "Super Jetpack", prices = {["default"] = 661.86}},
    ["rbxassetid://4754697599"] = {name = "Choo Choo Train", prices = {["default"] = 10.5}},
    ["rbxassetid://2408035766"] = {name = "Cloud", prices = {["default"] = 1114.32}},
    ["rbxassetid://5057099424"] = {name = "Clown Car", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099515"] = {name = "Clown Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2860616529"] = {name = "Convertible", prices = {["default"] = 115.59}},
    ["rbxassetid://4470750671"] = {name = "Cookie Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8203695278"] = {name = "Snowmobile", prices = {["default"] = 7.87}},
    ["rbxassetid://8243269978"] = {name = "Zamboni", prices = {["default"] = 2.1}},
    ["rbxassetid://1509385561"] = {name = "Cupcake Scooter", prices = {["default"] = 14.44}},
    ["rbxassetid://4822522305"] = {name = "Daisy Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8517689681"] = {name = "Landsailer", prices = {["default"] = 2.1}},
    ["rbxassetid://8566306089"] = {name = "Trireme", prices = {["default"] = 2.63}},
    ["rbxassetid://6504033614"] = {name = "Dino Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://1512774745"] = {name = "Doge Scooter", prices = {["default"] = 30.72}},
    ["rbxassetid://1307341942"] = {name = "Doge Skateboard", prices = {["default"] = 65.61}},
    ["rbxassetid://3486906742"] = {name = "Dogmobile", prices = {["default"] = 40.69}},
    ["rbxassetid://2880427418"] = {name = "Donut Cycle", prices = {["default"] = 79.03}},
    ["rbxassetid://3486907843"] = {name = "Donut Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2782643731"] = {name = "Douglas", prices = {["default"] = 9.81}},
    ["rbxassetid://1509391407"] = {name = "Duck Scooter", prices = {["default"] = 13.1}},
    ["rbxassetid://9291032374"] = {name = "Egg Delivery Machine", prices = {["default"] = 3.63}},
    ["rbxassetid://1509377123"] = {name = "Emoji Scooter", prices = {["default"] = 13.13}},
    ["rbxassetid://9973767611"] = {name = "Harvest Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://9973768669"] = {name = "Tractor", prices = {["default"] = 2.26}},
    ["rbxassetid://1307341332"] = {name = "Fidget Skateboard", prices = {["default"] = 22.32}},
    ["rbxassetid://1306904101"] = {name = "Fissy Skateboard", prices = {["default"] = 21}},
    ["rbxassetid://4823285384"] = {name = "Flower Wagon", prices = {["default"] = 3.93}},
    ["rbxassetid://7475653998"] = {name = "Fossil Paw Helicopter", prices = {["default"] = 2.63}},
    ["rbxassetid://9406027381"] = {name = "Starter Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://6475609765"] = {name = "Futuristic Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291832"] = {name = "Ghost Vehicle", prices = {["default"] = 1575}},
    ["rbxassetid://10905638416"] = {name = "Ancient Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760422"] = {name = "Bat Face Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://10919870588"] = {name = "Dapper Friend Carrier", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760559"] = {name = "Dirt Bike Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10967588257"] = {name = "Hot Tub Muscle Car", prices = {["default"] = 158.09}},
    ["rbxassetid://10905207734"] = {name = "Soapy Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9037078630"] = {name = "Horse And Carriage", prices = {["default"] = 308.23}},
    ["rbxassetid://10913434990"] = {name = "Unstable Triangle Car", prices = {["default"] = 3.94}},
    ["rbxassetid://8979306571"] = {name = "Wizard Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1512770654"] = {name = "Glass Scooter", prices = {["default"] = 10.5}},
    ["rbxassetid://1306903971"] = {name = "Glass Skateboard", prices = {["default"] = 393.75}},
    ["rbxassetid://1064481531"] = {name = "GoKart", prices = {["default"] = 115.48}},
    ["rbxassetid://1509326491"] = {name = "Gold Scooter", prices = {["default"] = 9.4}},
    ["rbxassetid://12519249137"] = {name = "Bumper Car", prices = {["default"] = 2.1}},
    ["rbxassetid://12519249424"] = {name = "Circus Ball Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265134428"] = {name = "Green Neon Snowboard", prices = {["default"] = 299.11}},
    ["rbxassetid://7839195952"] = {name = "Halloween Black Ponycycle", prices = {["default"] = 20.88}},
    ["rbxassetid://11119263404"] = {name = "Headless Horseman's Biplane", prices = {["default"] = 7.67}},
    ["rbxassetid://10920073281"] = {name = "Throwing Knife Target", prices = {["default"] = 2.1}},
    ["rbxassetid://10920073157"] = {name = "Shadow Rider", prices = {["default"] = 40.69}},
    ["rbxassetid://11125166616"] = {name = "Unicorn Zombie Ponycycle", prices = {["default"] = 10.5}},
    ["rbxassetid://2848331544"] = {name = "Heart Hoverboard", prices = {["default"] = 4.25}},
    ["rbxassetid://2657670919"] = {name = "Horse Cycle", prices = {["default"] = 105}},
    ["rbxassetid://3163531592"] = {name = "Traveling House", prices = {["default"] = 28.62}},
    ["rbxassetid://4382798606"] = {name = "Hoverboard", prices = {["default"] = 7.34}},
    ["rbxassetid://6475613264"] = {name = "Hovercar", prices = {["default"] = 2.1}},
    ["rbxassetid://4797807001"] = {name = "Human Bubble", prices = {["default"] = 2.1}},
    ["rbxassetid://4588192578"] = {name = "Ice Cream Truck", prices = {["default"] = 18.38}},
    ["rbxassetid://4470749585"] = {name = "Ice Queen Sleigh", prices = {["default"] = 2.1}},
    ["rbxassetid://1509333762"] = {name = "Ice Scooter", prices = {["default"] = 10.4}},
    ["rbxassetid://6504033516"] = {name = "Imagination Box", prices = {["default"] = 4.6}},
    ["rbxassetid://10619155042"] = {name = "Street Racer", prices = {["default"] = 32.61}},
    ["rbxassetid://2749267159"] = {name = "Limo", prices = {["default"] = 2.1}},
    ["rbxassetid://8665606953"] = {name = "Dragon Train", prices = {["default"] = 111.57}},
    ["rbxassetid://11758583286"] = {name = "Crescent Moon Car", prices = {["default"] = 152.25}},
    ["rbxassetid://6276452323"] = {name = "Lunar Muscle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://7165482478"] = {name = "Magical Girl Car", prices = {["default"] = 7.76}},
    ["rbxassetid://7368045552"] = {name = "Magical Princess Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1306902978"] = {name = "Melon Skateboard", prices = {["default"] = 22.32}},
    ["rbxassetid://3009779540"] = {name = "Monocycle", prices = {["default"] = 39.08}},
    ["rbxassetid://1512742703"] = {name = "Mono-Moped", prices = {["default"] = 77.18}},
    ["rbxassetid://2758236960"] = {name = "Moped", prices = {["default"] = 57.75}},
    ["rbxassetid://2758237011"] = {name = "Motorcycle", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264226"] = {name = "Muscle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://1509342852"] = {name = "Neon Black Scooter", prices = {["default"] = 22407.29}},
    ["rbxassetid://1306911569"] = {name = "Neon Black Skateboard", prices = {["default"] = 183.73}},
    ["rbxassetid://1509338320"] = {name = "Neon Blue Scooter", prices = {["default"] = 32.84}},
    ["rbxassetid://1306907175"] = {name = "Neon Blue Skateboard", prices = {["default"] = 52.5}},
    ["rbxassetid://1509342200"] = {name = "Neon Green Scooter", prices = {["default"] = 37.07}},
    ["rbxassetid://1306907671"] = {name = "Neon Green Skateboard", prices = {["default"] = 39.31}},
    ["rbxassetid://1509338451"] = {name = "Neon Orange Scooter", prices = {["default"] = 42}},
    ["rbxassetid://1306907450"] = {name = "Neon Orange Skateboard", prices = {["default"] = 42}},
    ["rbxassetid://1509339156"] = {name = "Neon Pink Scooter", prices = {["default"] = 78.38}},
    ["rbxassetid://1306911771"] = {name = "Neon Pink Skateboard", prices = {["default"] = 48.72}},
    ["rbxassetid://1509341495"] = {name = "Neon Red Scooter", prices = {["default"] = 51.19}},
    ["rbxassetid://1306907886"] = {name = "Neon Red Skateboard", prices = {["default"] = 37.07}},
    ["rbxassetid://1256625563"] = {name = "Orange Neon Snowboard", prices = {["default"] = 32.81}},
    ["rbxassetid://1509340494"] = {name = "Neon White Scooter", prices = {["default"] = 40.69}},
    ["rbxassetid://1309919907"] = {name = "Neon White Skateboard", prices = {["default"] = 52.49}},
    ["rbxassetid://2860616613"] = {name = "Offroader", prices = {["default"] = 2.1}},
    ["rbxassetid://1509329807"] = {name = "Pink Scooter", prices = {["default"] = 10.5}},
    ["rbxassetid://1306898507"] = {name = "Pink Skateboard", prices = {["default"] = 8.34}},
    ["rbxassetid://4361545125"] = {name = "Pizza Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://7368040075"] = {name = "Plant Powered Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9837424665"] = {name = "Rainbow Trail Magic Carpet", prices = {["default"] = 6.57}},
    ["rbxassetid://2854601262"] = {name = "Prince Carriage", prices = {["default"] = 6.85}},
    ["rbxassetid://2854601314"] = {name = "Princess Carriage", prices = {["default"] = 33.89}},
    ["rbxassetid://4115248893"] = {name = "Pumpkin Carriage", prices = {["default"] = 42.37}},
    ["rbxassetid://7475654312"] = {name = "Racing Monoplane", prices = {["default"] = 2.1}},
    ["rbxassetid://10967874847"] = {name = "Galleon", prices = {["default"] = 8.49}},
    ["rbxassetid://10967808228"] = {name = "Old Sail Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992442"] = {name = "RGB Monster Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992324"] = {name = "RGB UFO", prices = {["default"] = 3.94}},
    ["rbxassetid://5882026006"] = {name = "Ribcage Carriage", prices = {["default"] = 3.93}},
    ["rbxassetid://4797807111"] = {name = "Rocket Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://7368052482"] = {name = "Rocket Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://1257419042"] = {name = "Rocket Sled", prices = {["default"] = 656.25}},
    ["rbxassetid://4564588042"] = {name = "Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601162"] = {name = "Royal Carriage", prices = {["default"] = 7.77}},
    ["rbxassetid://13741294258"] = {name = "Giant Cheetah Mount", prices = {["default"] = 525}},
    ["rbxassetid://4470749525"] = {name = "Santa's Sleigh", prices = {["default"] = 33.5}},
    ["rbxassetid://4470749209"] = {name = "Sled", prices = {["default"] = 2.1}},
    ["rbxassetid://9342853829"] = {name = "Snow Plow", prices = {["default"] = 2.63}},
    ["rbxassetid://9343367876"] = {name = "Tundra Exploration Machine", prices = {["default"] = 2.1}},
    ["rbxassetid://1265142495"] = {name = "Snow Snowboard", prices = {["default"] = 315}},
    ["rbxassetid://7165482648"] = {name = "Speedboat", prices = {["default"] = 2.1}},
    ["rbxassetid://12719600101"] = {name = "Daisymobile", prices = {["default"] = 41.74}},
    ["rbxassetid://12792507038"] = {name = "Flower Truck", prices = {["default"] = 93.21}},
    ["rbxassetid://12996592162"] = {name = "Lavender Teapot Carriage", prices = {["default"] = 45.54}},
    ["rbxassetid://12917527253"] = {name = "Rabbit Helicopter", prices = {["default"] = 42.37}},
    ["rbxassetid://12996592079"] = {name = "Rose Petal Carriage", prices = {["default"] = 113.34}},
    ["rbxassetid://12996592010"] = {name = "Royal Crown Carriage", prices = {["default"] = 30.56}},
    ["rbxassetid://6504033423"] = {name = "Squirrel Car", prices = {["default"] = 2.63}},
    ["rbxassetid://6798176757"] = {name = "Standard Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://6797010981"] = {name = "Standard Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10224002323"] = {name = "Emperor's Chariot", prices = {["default"] = 14.33}},
    ["rbxassetid://10202931873"] = {name = "Orchid Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://10202932215"] = {name = "Hovercraft", prices = {["default"] = 2.1}},
    ["rbxassetid://10224209770"] = {name = "Planetary Core Car", prices = {["default"] = 2.1}},
    ["rbxassetid://10203332627"] = {name = "Medieval Wagon", prices = {["default"] = 2.1}},
    ["rbxassetid://13607580379"] = {name = "Beach Buggy", prices = {["default"] = 3.29}},
    ["rbxassetid://13683681091"] = {name = "Beachgoer", prices = {["default"] = 3.89}},
    ["rbxassetid://13683679951"] = {name = "Crabby Cruiser", prices = {["default"] = 58.91}},
    ["rbxassetid://3579315827"] = {name = "Surfboard", prices = {["default"] = 2.1}},
    ["rbxassetid://3186425945"] = {name = "SUV", prices = {["default"] = 2.52}},
    ["rbxassetid://1614139188"] = {name = "Multi-Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8727492188"] = {name = "Black Cab", prices = {["default"] = 3.03}},
    ["rbxassetid://8727477150"] = {name = "Yellow Taxi Cab", prices = {["default"] = 12.99}},
    ["rbxassetid://2783002443"] = {name = "Tiffany", prices = {["default"] = 21}},
    ["rbxassetid://3206264796"] = {name = "Tiny Convertible", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671636"] = {name = "Unicorn Cycle", prices = {["default"] = 131.24}},
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
    ["rbxassetid://1265135075"] = {name = "White Neon Snowboard", prices = {["default"] = 1057.87}},
    ["rbxassetid://1509328859"] = {name = "White Scooter", prices = {["default"] = 7.72}},
    ["rbxassetid://1306898856"] = {name = "White Skateboard", prices = {["default"] = 21.21}},
    ["rbxassetid://1256624956"] = {name = "White Snowboard", prices = {["default"] = 6.57}},
    ["rbxassetid://7165482807"] = {name = "Wing Trunk Car", prices = {["default"] = 22.25}},
    ["rbxassetid://8080952782"] = {name = "Festive Deliveries Present Truck", prices = {["default"] = 39.38}},
    ["rbxassetid://8190703270"] = {name = "Festive Deliveries Sleigh", prices = {["default"] = 11.82}},
    ["rbxassetid://7975097837"] = {name = "Festive Ice Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://8190703329"] = {name = "Toy Rescue Helicopter", prices = {["default"] = 9.38}},
    ["rbxassetid://11697121962"] = {name = "Candy Snowmobile", prices = {["default"] = 28.61}},
    ["rbxassetid://11574949668"] = {name = "Giant Snowball", prices = {["default"] = 18.38}},
    ["rbxassetid://11764928443"] = {name = "Gingerbread Sleigh", prices = {["default"] = 103.69}},
    ["rbxassetid://11706055135"] = {name = "Husky Sled", prices = {["default"] = 42}},
    ["rbxassetid://11466900358"] = {name = "Icebreaker Ship", prices = {["default"] = 2.1}},
    ["rbxassetid://11768005537"] = {name = "Ice Plane", prices = {["default"] = 7.76}},
    ["rbxassetid://11706157454"] = {name = "Snowblower Toboggan", prices = {["default"] = 6.46}},
    ["rbxassetid://11582939967"] = {name = "Strawberry Shortcake Skates", prices = {["default"] = 9.19}},
    ["rbxassetid://11582928541"] = {name = "Strawberry Shortcake Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://4797807321"] = {name = "Witch's Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1509321524"] = {name = "Wood Scooter", prices = {["default"] = 9.44}},
    ["rbxassetid://1306899055"] = {name = "Wood Skateboard", prices = {["default"] = 10.5}},
    ["rbxassetid://4361544852"] = {name = "Airplane Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4797806115"] = {name = "Angelic Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671618"] = {name = "Anna Rattle", prices = {["default"] = 3.54}},
    ["rbxassetid://4712355837"] = {name = "Astro Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://2657667102"] = {name = "Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779116"] = {name = "Balloons", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779170"] = {name = "Banana Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779233"] = {name = "Banana Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248143"] = {name = "Banjo", prices = {["default"] = 4.6}},
    ["rbxassetid://4470749845"] = {name = "Bauble Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468615"] = {name = "Briefcase Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907018"] = {name = "Bubblegum Machine Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046064"] = {name = "Bunny Plush", prices = {["default"] = 4.67}},
    ["rbxassetid://4470749083"] = {name = "Candle", prices = {["default"] = 2.63}},
    ["rbxassetid://6710107927"] = {name = "Candy Cannon", prices = {["default"] = 5730.38}},
    ["rbxassetid://3082046250"] = {name = "Carrot Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408035756"] = {name = "Cat Plush", prices = {["default"] = 104.97}},
    ["rbxassetid://3009779289"] = {name = "Caticorn Rattle", prices = {["default"] = 3.36}},
    ["rbxassetid://3082047003"] = {name = "Chick Plush", prices = {["default"] = 7.66}},
    ["rbxassetid://3082046215"] = {name = "Chocolate Bunny Balloon", prices = {["default"] = 4.44}},
    ["rbxassetid://1257271764"] = {name = "Christmas Cat Rattle", prices = {["default"] = 2.63}},
    ["rbxassetid://1257273388"] = {name = "Christmas Doge Rattle", prices = {["default"] = 127.16}},
    ["rbxassetid://4470749153"] = {name = "Cookie Dough Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://10979219546"] = {name = "Cotton Candy Stand", prices = {["default"] = 16.44}},
    ["rbxassetid://4115248463"] = {name = "Creepy Balloon", prices = {["default"] = 3.94}},
    ["rbxassetid://2408035767"] = {name = "Croc Plush", prices = {["default"] = 3.87}},
    ["rbxassetid://4115248599"] = {name = "Crossbow Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468734"] = {name = "Cymbal Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://4822522594"] = {name = "Dandelion Propeller", prices = {["default"] = 15.65}},
    ["rbxassetid://4797806584"] = {name = "Didgeridoo", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779323"] = {name = "Donut Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3454109877"] = {name = "Donut Throw Toy", prices = {["default"] = 131.25}},
    ["rbxassetid://3486907555"] = {name = "Dragon Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779349"] = {name = "Duck Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046102"] = {name = "Easter Bunny Plush", prices = {["default"] = 17.07}},
    ["rbxassetid://1555803323"] = {name = "Egg Rattle", prices = {["default"] = 2.39}},
    ["rbxassetid://2408051109"] = {name = "Elephant Plush", prices = {["default"] = 9.4}},
    ["rbxassetid://4470750254"] = {name = "Elf Plush", prices = {["default"] = 3.76}},
    ["rbxassetid://2657668953"] = {name = "Elf Rattle", prices = {["default"] = 3.93}},
    ["rbxassetid://5882028408"] = {name = "Eyeball Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408035763"] = {name = "Fancy Balloon", prices = {["default"] = 3.82}},
    ["rbxassetid://2408052395"] = {name = "Fancy Umbrella", prices = {["default"] = 3.56}},
    ["rbxassetid://3009779377"] = {name = "Flower Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291815"] = {name = "Flying Broomstick", prices = {["default"] = 3671.24}},
    ["rbxassetid://3454109803"] = {name = "Football Throw Toy", prices = {["default"] = 4.61}},
    ["rbxassetid://7368042855"] = {name = "Galaxy Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749638"] = {name = "Gift Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://1310513344"] = {name = "Glider", prices = {["default"] = 43.32}},
    ["rbxassetid://6936627177"] = {name = "Golden Maned Unicorn Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3142180004"] = {name = "Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907282"] = {name = "Griffin Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://1419098937"] = {name = "Heart Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://1419099271"] = {name = "Heart Plushie", prices = {["default"] = 11.65}},
    ["rbxassetid://2848331436"] = {name = "Heart Rattle", prices = {["default"] = 72.19}},
    ["rbxassetid://2657670910"] = {name = "Horse Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://3818347838"] = {name = "Hotdog Stand", prices = {["default"] = 9.7}},
    ["rbxassetid://1555807694"] = {name = "Hugging Egg", prices = {["default"] = 158.01}},
    ["rbxassetid://4470749277"] = {name = "Ice Club Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779419"] = {name = "Ice Cream Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4361546643"] = {name = "Ice Cream Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749342"] = {name = "Ice Pick Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052390"] = {name = "Inflatable Sword", prices = {["default"] = 2.63}},
    ["rbxassetid://2408051119"] = {name = "Jackhammer", prices = {["default"] = 2.1}},
    ["rbxassetid://3486908136"] = {name = "Kangaroo Pogo", prices = {["default"] = 3.33}},
    ["rbxassetid://4822522509"] = {name = "Lavender Bundle", prices = {["default"] = 2.63}},
    ["rbxassetid://3523677453"] = {name = "Lemonade Stand", prices = {["default"] = 3.42}},
    ["rbxassetid://6475613071"] = {name = "Lime Slice Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051107"] = {name = "Llama Plush", prices = {["default"] = 194.25}},
    ["rbxassetid://4661940658"] = {name = "Magic House Door", prices = {["default"] = 35.4}},
    ["rbxassetid://3009779472"] = {name = "Marsh Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779496"] = {name = "Marsh Plush", prices = {["default"] = 3.91}},
    ["rbxassetid://5057099190"] = {name = "Monkey Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099046"] = {name = "Monkey Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670913"] = {name = "Noob Balloon", prices = {["default"] = 3.67}},
    ["rbxassetid://3009779607"] = {name = "Octopus Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749788"] = {name = "Ornament Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670921"] = {name = "Phoenix Plush", prices = {["default"] = 13.02}},
    ["rbxassetid://7368034465"] = {name = "Pink Cat Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544972"] = {name = "Plunger Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051114"] = {name = "Puppy Plush", prices = {["default"] = 6.48}},
    ["rbxassetid://3082046011"] = {name = "Rabbit Rattle", prices = {["default"] = 2.37}},
    ["rbxassetid://2408055079"] = {name = "Rainbow Wand", prices = {["default"] = 3.93}},
    ["rbxassetid://4470749750"] = {name = "Reindeer Leash", prices = {["default"] = 2.37}},
    ["rbxassetid://3009779583"] = {name = "Rocket Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749474"] = {name = "Santa Leash", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750189"] = {name = "Santa Rattle", prices = {["default"] = 4.25}},
    ["rbxassetid://5061468835"] = {name = "Scroll Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://6475612857"] = {name = "Shuttle Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5882028350"] = {name = "Skull Drum", prices = {["default"] = 5.25}},
    ["rbxassetid://4470749413"] = {name = "Sleigh Bells Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://6059308940"] = {name = "Snowball Launcher", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671626"] = {name = "Snowman Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749691"] = {name = "Snowman Rattle", prices = {["default"] = 2.63}},
    ["rbxassetid://4470750120"] = {name = "Sock Chew Toy", prices = {["default"] = 2.63}},
    ["rbxassetid://2408052387"] = {name = "Squid Plush", prices = {["default"] = 6.57}},
    ["rbxassetid://5061468930"] = {name = "Staff Ingredient", prices = {["default"] = 28.72}},
    ["rbxassetid://6768659222"] = {name = "Standard Grappling Hook", prices = {["default"] = 2.59}},
    ["rbxassetid://2408055085"] = {name = "Starpower Wand", prices = {["default"] = 62.97}},
    ["rbxassetid://3009779638"] = {name = "Telescope Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4710374217"] = {name = "Tennis Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4464390422"] = {name = "Turkey Plush", prices = {["default"] = 2.39}},
    ["rbxassetid://3977264097"] = {name = "Unicorn Leash", prices = {["default"] = 17.03}},
    ["rbxassetid://3570154347"] = {name = "Unicorn Plush", prices = {["default"] = 117.56}},
    ["rbxassetid://2408055086"] = {name = "Wooden Pogo", prices = {["default"] = 3.1}},
    ["rbxassetid://4155284126"] = {name = "Zombie Buffalo Plush", prices = {["default"] = 85.32}},
    ["rbxassetid://4880426741"] = {name = "Adventurer's Hood", prices = {["default"] = 8.49}},
    ["rbxassetid://4880426585"] = {name = "Adventurer's Sword", prices = {["default"] = 4.94}},
    ["rbxassetid://5726048254"] = {name = "Amber Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973461"] = {name = "Angel Wings", prices = {["default"] = 983.07}},
    ["rbxassetid://6380734633"] = {name = "Antenna", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972567"] = {name = "Aviators", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973554"] = {name = "Bat Wings", prices = {["default"] = 15.54}},
    ["rbxassetid://6380843886"] = {name = "Bee Hive", prices = {["default"] = 2.63}},
    ["rbxassetid://6380734557"] = {name = "Bee Wings", prices = {["default"] = 3.92}},
    ["rbxassetid://4849973352"] = {name = "Beret", prices = {["default"] = 2.1}},
    ["rbxassetid://5881347869"] = {name = "Bewitched Hat", prices = {["default"] = 6.57}},
    ["rbxassetid://5415514537"] = {name = "Black 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415514707"] = {name = "Black Boots", prices = {["default"] = 19.69}},
    ["rbxassetid://5415514845"] = {name = "Black Cozy Hood", prices = {["default"] = 2.1}},
    ["rbxassetid://5415515017"] = {name = "Black Designer Backpack", prices = {["default"] = 5.16}},
    ["rbxassetid://4849975075"] = {name = "Black Fedora", prices = {["default"] = 2.1}},
    ["rbxassetid://5415515284"] = {name = "Black Hightops", prices = {["default"] = 6.56}},
    ["rbxassetid://5415515507"] = {name = "Black Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426690"] = {name = "Black Scarf", prices = {["default"] = 20.9}},
    ["rbxassetid://5415515653"] = {name = "Black Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5444594385"] = {name = "Blue Butterfly Wings", prices = {["default"] = 14.43}},
    ["rbxassetid://4849980085"] = {name = "Blue Cat Ear Headphones", prices = {["default"] = 22.23}},
    ["rbxassetid://5415515800"] = {name = "Blue Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048365"] = {name = "Bone Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426624"] = {name = "Briefcase", prices = {["default"] = 2.1}},
    ["rbxassetid://6706595341"] = {name = "Bunny Ear Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975457"] = {name = "Buttoned Ushanka", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978837"] = {name = "Buzz Off! Skateboard", prices = {["default"] = 2.1}},
    ["rbxassetid://5415516304"] = {name = "Cassette", prices = {["default"] = 3.93}},
    ["rbxassetid://4849975557"] = {name = "Chef Hat", prices = {["default"] = 18.38}},
    ["rbxassetid://6380734302"] = {name = "Cherry Earrings", prices = {["default"] = 3.83}},
    ["rbxassetid://6706591422"] = {name = "Chick Backpack", prices = {["default"] = 2.63}},
    ["rbxassetid://6706592723"] = {name = "Chick Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975633"] = {name = "Chicken Hat", prices = {["default"] = 19.28}},
    ["rbxassetid://4849972658"] = {name = "Clout Goggles", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975702"] = {name = "Conductor Hat", prices = {["default"] = 73.15}},
    ["rbxassetid://4936545219"] = {name = "Cutlass", prices = {["default"] = 140.24}},
    ["rbxassetid://4849972740"] = {name = "Cyborg Shades", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037745"] = {name = "Daisy Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7601648534"] = {name = "Eco Blue Reusable Bottle Backpack", prices = {["default"] = 11.82}},
    ["rbxassetid://7542826699"] = {name = "Eco Blue Solar Panel Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810947"] = {name = "Eco Brown Branch Headphones", prices = {["default"] = 6.51}},
    ["rbxassetid://7542815049"] = {name = "Eco Brown Hiking Backpack", prices = {["default"] = 32.75}},
    ["rbxassetid://7542816175"] = {name = "Eco Green Leaf Afro", prices = {["default"] = 2.63}},
    ["rbxassetid://7542816369"] = {name = "Eco Green Leaf Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810810"] = {name = "Eco Orange Leaf Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542820583"] = {name = "Eco Orange Maple Cape", prices = {["default"] = 10.9}},
    ["rbxassetid://7542810709"] = {name = "Eco Orange Maple Earrings", prices = {["default"] = 2.6}},
    ["rbxassetid://7542817978"] = {name = "Eco Orange Maple Leaf Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://7542823324"] = {name = "Eco Orange Pumpkin Eyepatch", prices = {["default"] = 2.1}},
    ["rbxassetid://7542824283"] = {name = "Eco Orange Pumpkin Pie Wings", prices = {["default"] = 48.57}},
    ["rbxassetid://7542813412"] = {name = "Eco Red Cranberry Branch Wings", prices = {["default"] = 24.26}},
    ["rbxassetid://7542821672"] = {name = "Eco Red Mushroom Hood", prices = {["default"] = 3.89}},
    ["rbxassetid://6706593596"] = {name = "Egg Barrette", prices = {["default"] = 2.1}},
    ["rbxassetid://6706594347"] = {name = "Egg Glasses", prices = {["default"] = 10.6}},
    ["rbxassetid://4850383048"] = {name = "Elf Hat", prices = {["default"] = 92.87}},
    ["rbxassetid://4849976006"] = {name = "Explorer Hat", prices = {["default"] = 3.94}},
    ["rbxassetid://4933495463"] = {name = "Eyepatch", prices = {["default"] = 5.84}},
    ["rbxassetid://6060998776"] = {name = "Festive Tree Hat", prices = {["default"] = 3.93}},
    ["rbxassetid://4853278462"] = {name = "Firey Aura", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979365"] = {name = "First Aid Bag", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976218"] = {name = "Flamenco Hat", prices = {["default"] = 4.59}},
    ["rbxassetid://6437127230"] = {name = "Flower Collar", prices = {["default"] = 6.57}},
    ["rbxassetid://6380734218"] = {name = "Flower Crown", prices = {["default"] = 8.49}},
    ["rbxassetid://5726048455"] = {name = "Forgotten Flower", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734014"] = {name = "Froggy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://6060998635"] = {name = "Fur Boots", prices = {["default"] = 13.81}},
    ["rbxassetid://5415517473"] = {name = "Gold Chain", prices = {["default"] = 78.75}},
    ["rbxassetid://5415517604"] = {name = "Gold Circle Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://5415517745"] = {name = "Gold Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979471"] = {name = "Golden Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730894"] = {name = "Goth Shoes", prices = {["default"] = 106.23}},
    ["rbxassetid://4849976420"] = {name = "Green Lotus", prices = {["default"] = 5.25}},
    ["rbxassetid://7368039312"] = {name = "Growing Flower Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4489907389"] = {name = "Halo", prices = {["default"] = 1244.25}},
    ["rbxassetid://5444594659"] = {name = "Handheld", prices = {["default"] = 2.33}},
    ["rbxassetid://4849976512"] = {name = "Head Chef", prices = {["default"] = 178.45}},
    ["rbxassetid://5067924536"] = {name = "Head Tie", prices = {["default"] = 3.83}},
    ["rbxassetid://6404037642"] = {name = "Headband", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979572"] = {name = "Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521592"] = {name = "Hoop Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991420"] = {name = "Ice Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991330"] = {name = "Ice Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991245"] = {name = "Ice Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973617"] = {name = "Jade Moth Wings", prices = {["default"] = 17.69}},
    ["rbxassetid://4849979214"] = {name = "Jeff's Nametag", prices = {["default"] = 38.06}},
    ["rbxassetid://5415517859"] = {name = "Jetpack", prices = {["default"] = 2.21}},
    ["rbxassetid://5067924626"] = {name = "Kitsune Mask", prices = {["default"] = 3.94}},
    ["rbxassetid://4849973992"] = {name = "Lavender Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730364"] = {name = "Leaf Wings", prices = {["default"] = 3.94}},
    ["rbxassetid://6380730271"] = {name = "Leprechaun Hat", prices = {["default"] = 2.63}},
    ["rbxassetid://4853278902"] = {name = "Luggage", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924890"] = {name = "Monkey King Crown", prices = {["default"] = 69.9}},
    ["rbxassetid://4849977086"] = {name = "Monocle", prices = {["default"] = 8.81}},
    ["rbxassetid://4849979887"] = {name = "Moon Tome", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976759"] = {name = "Morion", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048545"] = {name = "Nautilus Shell Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976912"] = {name = "Ninja Headband", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037449"] = {name = "Orange Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727237"] = {name = "Orange Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977244"] = {name = "Party Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://5415523249"] = {name = "Pearl Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727177"] = {name = "Picnic Basket", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518324"] = {name = "Pink 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518474"] = {name = "Pink Boots", prices = {["default"] = 9.43}},
    ["rbxassetid://5444594884"] = {name = "Pink Butterfly Wings", prices = {["default"] = 6.57}},
    ["rbxassetid://4849979637"] = {name = "Pink Cat Ear Headphones", prices = {["default"] = 75.11}},
    ["rbxassetid://5415518613"] = {name = "Pink Designer Backpack", prices = {["default"] = 8.81}},
    ["rbxassetid://4849972826"] = {name = "Pink Heart Glasses", prices = {["default"] = 63.55}},
    ["rbxassetid://5457768184"] = {name = "Pink Hightops", prices = {["default"] = 6.38}},
    ["rbxassetid://5415518811"] = {name = "Pink Instant Camera", prices = {["default"] = 19.69}},
    ["rbxassetid://4849977427"] = {name = "Pink Lotus", prices = {["default"] = 2.1}},
    ["rbxassetid://5415520296"] = {name = "Pink Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977514"] = {name = "Pirate Hat", prices = {["default"] = 7.64}},
    ["rbxassetid://5444711861"] = {name = "Platinum Tiara", prices = {["default"] = 22.98}},
    ["rbxassetid://4849977607"] = {name = "Propeller Hat", prices = {["default"] = 102.96}},
    ["rbxassetid://4849972928"] = {name = "Purple Heart Glasses", prices = {["default"] = 2.63}},
    ["rbxassetid://6380727007"] = {name = "Purple Masquerade Mask", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977695"] = {name = "Purple Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037362"] = {name = "Rain Boots", prices = {["default"] = 70.88}},
    ["rbxassetid://5415520831"] = {name = "Rain Hat", prices = {["default"] = 8.54}},
    ["rbxassetid://7498079214"] = {name = "RB Battles Trophy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977830"] = {name = "Red Beanie", prices = {["default"] = 2.1}},
    ["rbxassetid://6380847814"] = {name = "Red Masquerade Mask", prices = {["default"] = 3.71}},
    ["rbxassetid://5415520972"] = {name = "Red Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521183"] = {name = "Red Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973276"] = {name = "Reindeer Antlers", prices = {["default"] = 6.57}},
    ["rbxassetid://4933495361"] = {name = "Respectful Mustache", prices = {["default"] = 65.93}},
    ["rbxassetid://8151013513"] = {name = "RGB Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978102"] = {name = "Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495425"] = {name = "Ruff", prices = {["default"] = 59.76}},
    ["rbxassetid://4849978200"] = {name = "Sailor Cap", prices = {["default"] = 78.75}},
    ["rbxassetid://4850382817"] = {name = "Santa Hat", prices = {["default"] = 314.22}},
    ["rbxassetid://5881348094"] = {name = "Scythe", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278537"] = {name = "Shadow Aura", prices = {["default"] = 41.97}},
    ["rbxassetid://4849980009"] = {name = "Shadow Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973681"] = {name = "Shadow Wings", prices = {["default"] = 144.38}},
    ["rbxassetid://4849972466"] = {name = "Shark Fin", prices = {["default"] = 3.71}},
    ["rbxassetid://4849973100"] = {name = "Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521379"] = {name = "Silver Chain", prices = {["default"] = 2.1}},
    ["rbxassetid://4849974099"] = {name = "Skeleton Shell", prices = {["default"] = 2.1}},
    ["rbxassetid://4849974434"] = {name = "Spike Collar", prices = {["default"] = 13.02}},
    ["rbxassetid://6380723429"] = {name = "Strawberry Hat", prices = {["default"] = 49.88}},
    ["rbxassetid://4849975162"] = {name = "Sun Tome", prices = {["default"] = 3.76}},
    ["rbxassetid://4849976090"] = {name = "Sushi Skateboard", prices = {["default"] = 23.63}},
    ["rbxassetid://4849976985"] = {name = "Turtle Shell", prices = {["default"] = 3.15}},
    ["rbxassetid://4849978035"] = {name = "Watermelon Backpack", prices = {["default"] = 5.25}},
    ["rbxassetid://5415522308"] = {name = "White Designer Backpack", prices = {["default"] = 8.9}},
    ["rbxassetid://5415522533"] = {name = "White Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979019"] = {name = "Windup Key", prices = {["default"] = 26.25}},
    ["rbxassetid://4849977314"] = {name = "Witch Hat", prices = {["default"] = 4.57}},
    ["rbxassetid://4849978608"] = {name = "Wizard Hat", prices = {["default"] = 5.09}},
    ["rbxassetid://5415522859"] = {name = "Yellow Designer Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5415522973"] = {name = "Yellow Instant Camera", prices = {["default"] = 2.35}},
    ["rbxassetid://5415523115"] = {name = "Yellow Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277758"] = {name = "Airplane Stroller", prices = {["default"] = 38.14}},
    ["rbxassetid://2657667120"] = {name = "Baby Basket Stroller", prices = {["default"] = 66.94}},
    ["rbxassetid://2761277454"] = {name = "Balloon Stroller", prices = {["default"] = 4.64}},
    ["rbxassetid://3009779202"] = {name = "Banana Stroller", prices = {["default"] = 3.71}},
    ["rbxassetid://3082046286"] = {name = "Bunny Stroller", prices = {["default"] = 36.02}},
    ["rbxassetid://3009779260"] = {name = "Cannon Stroller", prices = {["default"] = 6.38}},
    ["rbxassetid://3269748269"] = {name = "Car Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6475616233"] = {name = "Catapult Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248341"] = {name = "Cauldron Stroller", prices = {["default"] = 4.66}},
    ["rbxassetid://2408051111"] = {name = "Cradle Stroller", prices = {["default"] = 79.43}},
    ["rbxassetid://4361544460"] = {name = "Crate Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3486905775"] = {name = "Dog House Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1408016951"] = {name = "Double Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1406692267"] = {name = "Droplet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277656"] = {name = "Duck Stroller", prices = {["default"] = 42.39}},
    ["rbxassetid://3082046174"] = {name = "Easter Egg Stroller", prices = {["default"] = 27.2}},
    ["rbxassetid://2761277703"] = {name = "Egg Stroller", prices = {["default"] = 1431.66}},
    ["rbxassetid://4822522123"] = {name = "Flower Stroller", prices = {["default"] = 32.82}},
    ["rbxassetid://3009779395"] = {name = "French Fries Stroller", prices = {["default"] = 4.76}},
    ["rbxassetid://3082046130"] = {name = "Half Egg Stroller", prices = {["default"] = 29.51}},
    ["rbxassetid://3486906113"] = {name = "Hatched Egg Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2848462165"] = {name = "Heart Stroller", prices = {["default"] = 249.25}},
    ["rbxassetid://6475613319"] = {name = "High Heel Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6967530077"] = {name = "Hover Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670917"] = {name = "Ice Cream Stroller", prices = {["default"] = 15.65}},
    ["rbxassetid://3486906383"] = {name = "Kangaroo Stroller", prices = {["default"] = 10.6}},
    ["rbxassetid://7368046225"] = {name = "Lunar Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936630605"] = {name = "Magic Carpet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936629525"] = {name = "Magic Moon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6309085791"] = {name = "Palanquin Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936631399"] = {name = "Pelican Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670918"] = {name = "Pizza Stroller", prices = {["default"] = 14.34}},
    ["rbxassetid://3009779443"] = {name = "Popsicle Stroller", prices = {["default"] = 8.28}},
    ["rbxassetid://6936628317"] = {name = "Princess Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://5882036757"] = {name = "Pumpkin Stroller", prices = {["default"] = 5.24}},
    ["rbxassetid://2408052388"] = {name = "Quad Stroller", prices = {["default"] = 170.62}},
    ["rbxassetid://2408035750"] = {name = "Race Car Stroller", prices = {["default"] = 43.31}},
    ["rbxassetid://6710108407"] = {name = "Rainbow Stroller", prices = {["default"] = 55}},
    ["rbxassetid://4470748252"] = {name = "Reindeer Stroller", prices = {["default"] = 20.11}},
    ["rbxassetid://8526099597"] = {name = "RGB Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2981204560"] = {name = "Rocket Ship Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://13986982302"] = {name = "Shopping Cart Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936628967"] = {name = "Teacup Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2982964426"] = {name = "Throne Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671637"] = {name = "Trike Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544584"] = {name = "Triple Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277803"] = {name = "Unicorn Stroller", prices = {["default"] = 73.56}},
    ["rbxassetid://2466291803"] = {name = "Vampire Stroller", prices = {["default"] = 46.6}},
    ["rbxassetid://3066606234"] = {name = "Wheelbarrow Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://113061955717247"] = {name = "Admin Abuse Box", prices = {["default"] = 2.1}},
    ["rbxassetid://5888839551"] = {name = "Bat Box", prices = {["default"] = 98.44}},
    ["rbxassetid://4510471983"] = {name = "Golden Gift", prices = {["default"] = 918.75}},
    ["rbxassetid://5057100696"] = {name = "Monkey Box", prices = {["default"] = 209.9}},
    ["rbxassetid://6240246974"] = {name = "Ox Box", prices = {["default"] = 9.09}},
    ["rbxassetid://5067925110"] = {name = "Premium Monkey Box", prices = {["default"] = 1319.9}},
    ["rbxassetid://4621220017"] = {name = "Rat Box", prices = {["default"] = 588.5}},
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