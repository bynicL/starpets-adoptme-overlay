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
    ["rbxassetid://137637490639925"] = {name = "Royal Mistletroll", prices = {["default"] = 961.1, ["Ride"] = 1133.55, ["Fly|Ride"] = 1312.5, ["Neon"] = 3937.5, ["Neon|Fly|Ride"] = 4374.57, ["Mega|Fly|Ride"] = 20096.23}},
    ["rbxassetid://140355753768438"] = {name = "Moonbeam Peacock", prices = {["default"] = 393.75, ["Fly"] = 538.69, ["Ride"] = 442.86, ["Fly|Ride"] = 415.91, ["Neon|Ride"] = 1834.16, ["Neon|Fly|Ride"] = 1939.93, ["Mega"] = 9873.06, ["Mega|Fly|Ride"] = 8220.85}},
    ["rbxassetid://18117855573"] = {name = "Balloon Unicorn", prices = {["default"] = 4725, ["Ride"] = 5250, ["Fly|Ride"] = 4725, ["Neon"] = 26053.67, ["Neon|Fly|Ride"] = 20429.85, ["Mega|Fly|Ride"] = 66991.6}},
    ["rbxassetid://75782719698946"] = {name = "Red Dutch Guinea Pig", prices = {["default"] = 131.25, ["Ride"] = 170.71, ["Fly|Ride"] = 224.44, ["Neon"] = 1412.23, ["Neon|Ride"] = 821.63, ["Neon|Fly|Ride"] = 1968.75, ["Mega"] = 3807.92, ["Mega|Fly|Ride"] = 2793.65}},
    ["rbxassetid://5067924142"] = {name = "Albino Monkey", prices = {["default"] = 525, ["Fly"] = 662.26, ["Ride"] = 535.48, ["Fly|Ride"] = 546.41, ["Neon|Fly|Ride"] = 1509.38, ["Mega|Fly|Ride"] = 7012.9}},
    ["rbxassetid://108312620331321"] = {name = "Villain Gibbon", prices = {["default"] = 7.77, ["Ride"] = 32.82, ["Fly|Ride"] = 141.56, ["Neon"] = 60.04, ["Neon|Ride"] = 84.25, ["Neon|Fly|Ride"] = 282.43, ["Mega"] = 280.88, ["Mega|Ride"] = 466.48, ["Mega|Fly|Ride"] = 409.37}},
    ["rbxassetid://17255958862"] = {name = "Alicorn", prices = {["default"] = 4.72, ["Fly"] = 33.81, ["Ride"] = 23.16, ["Fly|Ride"] = 61.3, ["Neon"] = 19.69, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 47.25, ["Neon|Fly|Ride"] = 108.54, ["Mega"] = 147, ["Mega|Fly"] = 314.7, ["Mega|Ride"] = 137.82, ["Mega|Fly|Ride"] = 236.13}},
    ["rbxassetid://90170598608675"] = {name = "Moonbeam Butterfly", prices = {["default"] = 107.7, ["Fly"] = 183.79, ["Ride"] = 105.63, ["Fly|Ride"] = 178.5, ["Neon"] = 418.69, ["Neon|Ride"] = 486.36, ["Neon|Fly|Ride"] = 630.44, ["Mega"] = 1885.77, ["Mega|Fly|Ride"] = 1819.35}},
    ["rbxassetid://7126722445"] = {name = "Goldhorn", prices = {["default"] = 36.71, ["Fly"] = 142.61, ["Ride"] = 48.44, ["Fly|Ride"] = 88.09, ["Neon"] = 237.68, ["Neon|Ride"] = 197.64, ["Neon|Fly|Ride"] = 249.38, ["Mega"] = 2100, ["Mega|Ride"] = 1158.26, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://13186021971"] = {name = "Cuddly Candle", prices = {["default"] = 23.21, ["Fly"] = 74.76, ["Ride"] = 31.78, ["Fly|Ride"] = 69.57, ["Neon"] = 211.26, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 139.12, ["Mega|Ride"] = 634.67, ["Mega|Fly|Ride"] = 786.14}},
    ["rbxassetid://14146196672"] = {name = "Gargoyle", prices = {["default"] = 46.36, ["Fly"] = 287.31, ["Ride"] = 65.63, ["Fly|Ride"] = 127.32, ["Neon"] = 315.82, ["Neon|Ride"] = 210.51, ["Neon|Fly|Ride"] = 252.24, ["Mega|Ride"] = 2045.71, ["Mega|Fly|Ride"] = 1367.19}},
    ["rbxassetid://129762233626342"] = {name = "Royal Moon Egg", prices = {["default"] = 79.24}},
    ["rbxassetid://89693546199400"] = {name = "Cupid Dragon", prices = {["default"] = 362.25, ["Fly"] = 440.04, ["Ride"] = 398.82, ["Fly|Ride"] = 445.17, ["Neon"] = 1472.38, ["Neon|Ride"] = 1454.42, ["Neon|Fly|Ride"] = 1365, ["Mega"] = 5642.05, ["Mega|Fly|Ride"] = 5808.12}},
    ["rbxassetid://8665606875"] = {name = "Dancing Dragon", prices = {["default"] = 105, ["Fly"] = 111.57, ["Ride"] = 111.57, ["Fly|Ride"] = 156.97, ["Neon|Ride"] = 564.38, ["Neon|Fly|Ride"] = 328.13, ["Mega|Fly|Ride"] = 2613.19}},
    ["rbxassetid://110411427278536"] = {name = "Huntsman Robin", prices = {["default"] = 2.63, ["Fly"] = 35.94, ["Ride"] = 33.71, ["Fly|Ride"] = 141.52, ["Neon"] = 15.85, ["Neon|Ride"] = 78.29, ["Neon|Fly|Ride"] = 76.18, ["Mega"] = 83.58, ["Mega|Ride"] = 189, ["Mega|Fly|Ride"] = 383.25}},
    ["rbxassetid://10925517718"] = {name = "Lava Dragon", prices = {["default"] = 131.19, ["Fly"] = 155.32, ["Ride"] = 149.6, ["Fly|Ride"] = 195.82, ["Neon"] = 704.51, ["Neon|Ride"] = 628.32, ["Neon|Fly|Ride"] = 525, ["Mega|Fly|Ride"] = 1837.38}},
    ["rbxassetid://4797806482"] = {name = "Diamond Griffin", prices = {["default"] = 3.15, ["Fly"] = 25.36, ["Ride"] = 19.67, ["Fly|Ride"] = 44.63, ["Neon"] = 32.82, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 196.88, ["Mega|Ride"] = 326.82, ["Mega|Fly|Ride"] = 305.82}},
    ["rbxassetid://122648024705835"] = {name = "Scarebear", prices = {["default"] = 51.17, ["Fly"] = 152.97, ["Ride"] = 98.44, ["Fly|Ride"] = 222.3, ["Neon"] = 190.32, ["Neon|Ride"] = 201.6, ["Neon|Fly|Ride"] = 396.82, ["Mega"] = 818.72, ["Mega|Ride"] = 892.01, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://13104102169"] = {name = "Danger Egg", prices = {["default"] = 45.93}},
    ["rbxassetid://133163961974577"] = {name = "2D Doggy", prices = {["default"] = 72.07, ["Ride"] = 181.69, ["Fly|Ride"] = 246.1, ["Neon"] = 280.88, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 2362.5}},
    ["rbxassetid://126071806166898"] = {name = "Evil Chick", prices = {["default"] = 11.82, ["Fly"] = 393.75, ["Ride"] = 28.88, ["Fly|Ride"] = 78.75, ["Neon"] = 128.47, ["Neon|Ride"] = 360.94, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 2710.8, ["Mega|Ride"] = 564.38, ["Mega|Fly|Ride"] = 1692.42}},
    ["rbxassetid://5721843247"] = {name = "Dodo", prices = {["default"] = 32.64, ["Fly"] = 70.79, ["Ride"] = 51.19, ["Fly|Ride"] = 103.51, ["Neon"] = 226.04, ["Neon|Fly"] = 314.77, ["Neon|Ride"] = 203.34, ["Neon|Fly|Ride"] = 242.82, ["Mega"] = 1681.32, ["Mega|Ride"] = 846.21, ["Mega|Fly|Ride"] = 828.14}},
    ["rbxassetid://119640582603552"] = {name = "Violet Butterfly", prices = {["default"] = 57.75, ["Fly"] = 105, ["Ride"] = 189, ["Fly|Ride"] = 139.41, ["Neon"] = 208.68, ["Neon|Fly"] = 390.73, ["Neon|Ride"] = 223.12, ["Neon|Fly|Ride"] = 316.28, ["Mega"] = 1692.42, ["Mega|Ride"] = 1265.09, ["Mega|Fly|Ride"] = 1128.64}},
    ["rbxassetid://16088264958"] = {name = "Volcanic Rhino", prices = {["default"] = 39.46, ["Fly"] = 63.55, ["Ride"] = 35.93, ["Fly|Ride"] = 126.75, ["Neon"] = 183.79, ["Neon|Ride"] = 157.98, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 1207.92, ["Mega|Ride"] = 2100, ["Mega|Fly|Ride"] = 1100.82}},
    ["rbxassetid://75251818654427"] = {name = "Apple Owl", prices = {["default"] = 47.08, ["Fly"] = 648.54, ["Ride"] = 83.45, ["Fly|Ride"] = 131.25, ["Neon"] = 247.17, ["Neon|Ride"] = 309.68, ["Neon|Fly|Ride"] = 393.75, ["Mega|Ride"] = 1124.82, ["Mega|Fly|Ride"] = 846.21}},
    ["rbxassetid://3181727433"] = {name = "Dragon", prices = {["default"] = 5.24, ["Fly"] = 23.62, ["Ride"] = 19.69, ["Fly|Ride"] = 46.6, ["Neon"] = 21, ["Neon|Fly"] = 70.88, ["Neon|Ride"] = 42.32, ["Neon|Fly|Ride"] = 89.41, ["Mega"] = 129.94, ["Mega|Fly"] = 306.76, ["Mega|Ride"] = 140.44, ["Mega|Fly|Ride"] = 225.75}},
    ["rbxassetid://121496682360324"] = {name = "Sugar Axolotl", prices = {["default"] = 294, ["Fly"] = 369.69, ["Ride"] = 352.74, ["Fly|Ride"] = 362.25, ["Neon"] = 1475.25, ["Neon|Ride"] = 1975.89, ["Neon|Fly|Ride"] = 1411.06, ["Mega"] = 10577.52, ["Mega|Fly|Ride"] = 5971.97}},
    ["rbxassetid://11694854226"] = {name = "Shetland Pony Light Brown", prices = {["default"] = 22.32, ["Ride"] = 28.88, ["Fly|Ride"] = 137.3, ["Neon"] = 493.27, ["Neon|Ride"] = 303.59, ["Neon|Fly|Ride"] = 413.59, ["Mega"] = 832.46, ["Mega|Fly|Ride"] = 797.56}},
    ["rbxassetid://4797806957"] = {name = "Golden Unicorn", prices = {["default"] = 6.46, ["Fly"] = 38.04, ["Ride"] = 22.63, ["Fly|Ride"] = 51.09, ["Neon"] = 39.38, ["Neon|Ride"] = 40.69, ["Neon|Fly|Ride"] = 105, ["Mega"] = 317.34, ["Mega|Ride"] = 351.19, ["Mega|Fly|Ride"] = 419.43}},
    ["rbxassetid://110822620060051"] = {name = "Frost Phoenix", prices = {["default"] = 90.85, ["Fly"] = 141.56, ["Ride"] = 113.02, ["Fly|Ride"] = 98.44, ["Neon"] = 417.22, ["Neon|Ride"] = 444.27, ["Neon|Fly|Ride"] = 460.69, ["Mega"] = 6245.42, ["Mega|Ride"] = 1471.35, ["Mega|Fly|Ride"] = 1764.35}},
    ["rbxassetid://13894724323"] = {name = "Billy Goat", prices = {["default"] = 13.13, ["Fly"] = 35.94, ["Ride"] = 28.39, ["Fly|Ride"] = 110.64, ["Neon"] = 75.01, ["Neon|Ride"] = 72.19, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 707.17, ["Mega|Ride"] = 634.67, ["Mega|Fly|Ride"] = 663.23}},
    ["rbxassetid://123037843357105"] = {name = "Glormy Leo", prices = {["default"] = 157.5, ["Fly"] = 352.79, ["Ride"] = 196.88, ["Fly|Ride"] = 236.25, ["Neon"] = 774.38, ["Neon|Ride"] = 802.86, ["Neon|Fly|Ride"] = 773.07, ["Mega"] = 6346.52, ["Mega|Fly|Ride"] = 2977.58}},
    ["rbxassetid://12479078933"] = {name = "Southeast Asia Egg", prices = {["default"] = 36.99}},
    ["rbxassetid://122739780018633"] = {name = "Quetzalcoatl", prices = {["default"] = 5.15, ["Fly"] = 36.49, ["Ride"] = 24.93, ["Fly|Ride"] = 92.95, ["Neon"] = 20.97, ["Neon|Fly"] = 91.96, ["Neon|Ride"] = 42.32, ["Neon|Fly|Ride"] = 157.98, ["Mega"] = 131.25, ["Mega|Fly"] = 235.1, ["Mega|Ride"] = 249.65, ["Mega|Fly|Ride"] = 299.38}},
    ["rbxassetid://70953296065239"] = {name = "Frostbite Bear", prices = {["default"] = 774.38, ["Fly"] = 959.05, ["Ride"] = 863.44, ["Fly|Ride"] = 853.13, ["Neon"] = 4958.94, ["Neon|Ride"] = 5248.69, ["Neon|Fly|Ride"] = 4654.11, ["Mega"] = 9712.5, ["Mega|Ride"] = 53037, ["Mega|Fly|Ride"] = 9843.75}},
    ["rbxassetid://14978701948"] = {name = "Scarecrow Crow", prices = {["default"] = 10.5, ["Fly"] = 28.49, ["Ride"] = 22.32, ["Fly|Ride"] = 72.19, ["Neon"] = 107.76, ["Neon|Ride"] = 112.69, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 511.88, ["Mega|Ride"] = 608.23, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://11191341630"] = {name = "Jousting Horse", prices = {["default"] = 94.5, ["Ride"] = 115.5, ["Fly|Ride"] = 196.88, ["Neon"] = 511.88, ["Neon|Ride"] = 630.44, ["Neon|Fly|Ride"] = 685.13, ["Mega|Ride"] = 6074.25, ["Mega|Fly|Ride"] = 2624.75}},
    ["rbxassetid://76801905892592"] = {name = "Royal Aztec Egg", prices = {["default"] = 35.44}},
    ["rbxassetid://98801943598121"] = {name = "Priceless Shrimp", prices = {["default"] = 17.63, ["Fly"] = 68.85, ["Ride"] = 55.13, ["Fly|Ride"] = 144.38, ["Neon"] = 42.26, ["Neon|Ride"] = 282.43, ["Neon|Fly|Ride"] = 472.5, ["Mega"] = 528.89, ["Mega|Ride"] = 723.19, ["Mega|Fly|Ride"] = 705.54}},
    ["rbxassetid://95214789806437"] = {name = "Aztec Egg", prices = {["default"] = 2.63}},
    ["rbxassetid://18515755354"] = {name = "Cheetah", prices = {["default"] = 131.25, ["Ride"] = 171.94, ["Fly|Ride"] = 263.73, ["Neon"] = 420, ["Neon|Ride"] = 495.1, ["Neon|Fly|Ride"] = 590.63, ["Mega|Fly|Ride"] = 2100}},
    ["rbxassetid://18117855114"] = {name = "Corn Doggo", prices = {["default"] = 118.13, ["Ride"] = 158.92, ["Fly|Ride"] = 216.57, ["Neon"] = 438.38, ["Neon|Ride"] = 366.18, ["Neon|Fly|Ride"] = 579.81, ["Mega"] = 1378.13, ["Mega|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 1544.59}},
    ["rbxassetid://8972175010"] = {name = "Woodland Egg", prices = {["default"] = 52.5}},
    ["rbxassetid://3710823011"] = {name = "Golden Penguin", prices = {["default"] = 59.06, ["Fly"] = 65.63, ["Ride"] = 57.74, ["Fly|Ride"] = 64.32, ["Neon"] = 606.29, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 282.19, ["Mega"] = 4229.97, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://136490701345923"] = {name = "Glormy Crab", prices = {["default"] = 6.48, ["Ride"] = 31.5, ["Fly|Ride"] = 159.51, ["Neon"] = 40.69, ["Neon|Ride"] = 67.72, ["Neon|Fly|Ride"] = 235.9, ["Mega"] = 205.23, ["Mega|Fly"] = 267.75, ["Mega|Ride"] = 143.07, ["Mega|Fly|Ride"] = 350.14}},
    ["rbxassetid://14782580581"] = {name = "Vampire Dragon", prices = {["default"] = 346.5, ["Fly"] = 420, ["Ride"] = 354.38, ["Fly|Ride"] = 393.75, ["Neon|Ride"] = 1155, ["Neon|Fly|Ride"] = 1286.16, ["Mega|Fly|Ride"] = 4724.99}},
    ["rbxassetid://88405494856204"] = {name = "Solaris", prices = {["default"] = 84, ["Fly"] = 99.75, ["Ride"] = 94.5, ["Fly|Ride"] = 105, ["Neon"] = 359.14, ["Neon|Ride"] = 361.9, ["Neon|Fly|Ride"] = 367.49, ["Mega"] = 1411.06, ["Mega|Ride"] = 1901.85, ["Mega|Fly|Ride"] = 1819.35}},
    ["rbxassetid://84468510887759"] = {name = "Orchid Butterfly", prices = {["default"] = 4007.29, ["Ride"] = 3961.13, ["Fly|Ride"] = 3017.43, ["Neon|Fly|Ride"] = 14101.95}},
    ["rbxassetid://11109286837"] = {name = "Lava Wolf", prices = {["default"] = 47.25, ["Fly"] = 113.03, ["Ride"] = 56.44, ["Fly|Ride"] = 95.82, ["Neon"] = 392.44, ["Neon|Ride"] = 229.69, ["Neon|Fly|Ride"] = 376.48, ["Mega|Ride"] = 2115.51, ["Mega|Fly|Ride"] = 1693.13}},
    ["rbxassetid://12403863809"] = {name = "Albino Gorilla", prices = {["default"] = 45.94, ["Ride"] = 48.43, ["Fly|Ride"] = 138.83, ["Neon"] = 479.07, ["Neon|Ride"] = 793.92, ["Neon|Fly|Ride"] = 493.99, ["Mega"] = 6346.52, ["Mega|Fly|Ride"] = 1687.12}},
    ["rbxassetid://6060988121"] = {name = "Snow Owl", prices = {["default"] = 32.74, ["Fly"] = 70.79, ["Ride"] = 57.75, ["Fly|Ride"] = 105.89, ["Neon"] = 197.53, ["Neon|Fly"] = 280.97, ["Neon|Ride"] = 164.07, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 705.54, ["Mega|Ride"] = 912.26, ["Mega|Fly|Ride"] = 647.04}},
    ["rbxassetid://112630556645658"] = {name = "Moon Egg", prices = {["default"] = 8.54}},
    ["rbxassetid://10357473556"] = {name = "Golden Chow-Chow", prices = {["default"] = 63.4, ["Ride"] = 76.13, ["Fly|Ride"] = 117.25, ["Neon"] = 353.84, ["Neon|Ride"] = 471.52, ["Neon|Fly|Ride"] = 501.38, ["Mega|Ride"] = 1411.06, ["Mega|Fly|Ride"] = 1729.02}},
    ["rbxassetid://5721843384"] = {name = "Fossil Egg", prices = {["default"] = 31.78}},
    ["rbxassetid://92775688228060"] = {name = "Papa Moose", prices = {["default"] = 200.69, ["Ride"] = 211.26, ["Fly|Ride"] = 262.5, ["Neon|Ride"] = 3490.59, ["Neon|Fly|Ride"] = 1480.86}},
    ["rbxassetid://12479991588"] = {name = "Frost Unicorn", prices = {["default"] = 704.51, ["Ride"] = 728.44, ["Fly|Ride"] = 840, ["Neon|Ride"] = 3243.08, ["Neon|Fly|Ride"] = 2874.38, ["Mega|Fly|Ride"] = 11812.5}},
    ["rbxassetid://9661880325"] = {name = "Zodiac Minion Egg", prices = {["default"] = 10.58}},
    ["rbxassetid://7126719832"] = {name = "Phoenix", prices = {["default"] = 26.14, ["Fly"] = 52.42, ["Ride"] = 38.07, ["Fly|Ride"] = 64.32, ["Neon"] = 162.75, ["Neon|Ride"] = 141.75, ["Neon|Fly|Ride"] = 210, ["Mega|Ride"] = 918.75, ["Mega|Fly|Ride"] = 707.27}},
    ["rbxassetid://119386690822810"] = {name = "Royal Fairytale Egg", prices = {["default"] = 11.64}},
    ["rbxassetid://4440866299"] = {name = "Crow", prices = {["default"] = 5670, ["Ride"] = 6336.53, ["Fly|Ride"] = 4410, ["Neon|Fly|Ride"] = 9821.44, ["Mega|Fly|Ride"] = 35259.08}},
    ["rbxassetid://4797806531"] = {name = "Diamond Unicorn", prices = {["default"] = 10.5, ["Fly"] = 74.64, ["Ride"] = 27.45, ["Fly|Ride"] = 44.56, ["Neon"] = 65.63, ["Neon|Ride"] = 101.07, ["Neon|Fly|Ride"] = 183.2, ["Mega"] = 420, ["Mega|Ride"] = 450.61, ["Mega|Fly|Ride"] = 421.16}},
    ["rbxassetid://88817325500927"] = {name = "Kraken", prices = {["default"] = 12.68, ["Fly"] = 102.37, ["Ride"] = 32.82, ["Fly|Ride"] = 116.47, ["Neon"] = 85.32, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 231, ["Mega"] = 446.25, ["Mega|Ride"] = 520.43, ["Mega|Fly|Ride"] = 681.21}},
    ["rbxassetid://9490243442"] = {name = "Diamond King Penguin", prices = {["default"] = 80.29, ["Fly"] = 139.21, ["Ride"] = 94.5, ["Fly|Ride"] = 140.44, ["Neon"] = 1409.01, ["Neon|Fly|Ride"] = 420, ["Mega"] = 4231.02}},
    ["rbxassetid://107787284008278"] = {name = "Primal Kaijunior", prices = {["default"] = 12.99, ["Ride"] = 31.29, ["Fly|Ride"] = 139.13, ["Neon"] = 53.82, ["Neon|Ride"] = 120.61, ["Neon|Fly|Ride"] = 110.39, ["Mega"] = 1411.06, ["Mega|Ride"] = 417.03, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://4506837037"] = {name = "Arctic Reindeer", prices = {["default"] = 2100, ["Fly"] = 2486.35, ["Ride"] = 1968.75, ["Fly|Ride"] = 2032.68, ["Neon|Fly|Ride"] = 4200, ["Mega|Fly|Ride"] = 15013.72}},
    ["rbxassetid://4184878149"] = {name = "Bat Dragon", prices = {["default"] = 28166.1, ["Fly"] = 35139.34, ["Ride"] = 35203.61, ["Fly|Ride"] = 23231.25, ["Neon|Ride"] = 65625, ["Neon|Fly|Ride"] = 61687.5, ["Mega"] = 210000, ["Mega|Fly|Ride"] = 197441.87}},
    ["rbxassetid://118641789458122"] = {name = "Gilded Snake", prices = {["default"] = 17.07, ["Fly"] = 393.75, ["Ride"] = 42, ["Fly|Ride"] = 63.74, ["Neon"] = 134.17, ["Neon|Fly"] = 141.56, ["Neon|Ride"] = 174.57, ["Neon|Fly|Ride"] = 280.77, ["Mega"] = 620.92, ["Mega|Ride"] = 1141.88, ["Mega|Fly|Ride"] = 846.21}},
    ["rbxassetid://71844856693163"] = {name = "Purrowl", prices = {["default"] = 2.63, ["Fly"] = 95.07, ["Ride"] = 42.26, ["Fly|Ride"] = 126.75, ["Neon"] = 21.14, ["Neon|Fly"] = 70.79, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 141.75, ["Mega"] = 91.77, ["Mega|Fly"] = 215.8, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://7195311687"] = {name = "Mythic Egg", prices = {["default"] = 23.12}},
    ["rbxassetid://102330087609546"] = {name = "Fire Mare", prices = {["default"] = 6.57, ["Ride"] = 41.19, ["Fly|Ride"] = 111.57, ["Neon"] = 42.26, ["Neon|Ride"] = 105.25, ["Neon|Fly|Ride"] = 463.32, ["Mega"] = 393.75, ["Mega|Ride"] = 468.9, ["Mega|Fly|Ride"] = 471.45}},
    ["rbxassetid://16659215347"] = {name = "Candyfloss Chick", prices = {["default"] = 733.17, ["Ride"] = 706.6, ["Fly|Ride"] = 784.16, ["Neon"] = 2982.15, ["Neon|Ride"] = 2625, ["Neon|Fly|Ride"] = 2491.13, ["Mega|Fly|Ride"] = 11001.08}},
    ["rbxassetid://9281950769"] = {name = "Sugar Glider", prices = {["default"] = 997.5, ["Fly"] = 962.07, ["Ride"] = 984.38, ["Fly|Ride"] = 1124.67, ["Neon|Fly|Ride"] = 3071.25, ["Mega|Fly|Ride"] = 23505.35}},
    ["rbxassetid://15485137935"] = {name = "Fleur De Ice", prices = {["default"] = 24.81, ["Fly"] = 117.67, ["Ride"] = 56.44, ["Fly|Ride"] = 113.02, ["Neon"] = 162.12, ["Neon|Ride"] = 181.55, ["Neon|Fly|Ride"] = 211.56, ["Mega"] = 1023.96, ["Mega|Fly|Ride"] = 1411.06}},
    ["rbxassetid://6498256269"] = {name = "Ocean Egg", prices = {["default"] = 30.16}},
    ["rbxassetid://8704877940"] = {name = "Lavender Dragon", prices = {["default"] = 69.54, ["Fly"] = 65.63, ["Ride"] = 87.07, ["Fly|Ride"] = 133.72, ["Neon"] = 784.97, ["Neon|Ride"] = 564.85, ["Neon|Fly|Ride"] = 412.13, ["Mega|Fly|Ride"] = 1598.63}},
    ["rbxassetid://13685038182"] = {name = "Leviathan", prices = {["default"] = 65.63, ["Fly"] = 84.51, ["Ride"] = 84, ["Fly|Ride"] = 195.39, ["Neon"] = 395.05, ["Neon|Ride"] = 322.86, ["Neon|Fly|Ride"] = 507.74, ["Mega"] = 2131.61, ["Mega|Fly|Ride"] = 1506.26}},
    ["rbxassetid://4797806358"] = {name = "Diamond Dragon", prices = {["default"] = 3.13, ["Fly"] = 32.78, ["Ride"] = 18.96, ["Fly|Ride"] = 52.05, ["Neon"] = 24.3, ["Neon|Fly"] = 314.24, ["Neon|Ride"] = 68.65, ["Neon|Fly|Ride"] = 141.75, ["Mega"] = 296.19, ["Mega|Ride"] = 345.9, ["Mega|Fly|Ride"] = 371.44}},
    ["rbxassetid://5862774327"] = {name = "Cerberus", prices = {["default"] = 70.88, ["Fly"] = 72.19, ["Ride"] = 90.85, ["Fly|Ride"] = 141.18, ["Neon"] = 815.41, ["Neon|Ride"] = 339.98, ["Neon|Fly|Ride"] = 306.49, ["Mega|Fly|Ride"] = 991.93}},
    ["rbxassetid://74012786571707"] = {name = "Three Blind Mice", prices = {["default"] = 3.84, ["Ride"] = 28.53, ["Fly|Ride"] = 262.5, ["Neon"] = 28.53, ["Neon|Fly"] = 268.29, ["Neon|Ride"] = 113.58, ["Neon|Fly|Ride"] = 141.75, ["Mega"] = 90.99, ["Mega|Fly"] = 987.95, ["Mega|Ride"] = 197.81, ["Mega|Fly|Ride"] = 371.83}},
    ["rbxassetid://15931348363"] = {name = "Criosphinx", prices = {["default"] = 15.22, ["Fly"] = 65.63, ["Ride"] = 31.69, ["Fly|Ride"] = 99.29, ["Neon"] = 141.56, ["Neon|Ride"] = 110.82, ["Neon|Fly|Ride"] = 137.94, ["Mega"] = 1050, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://118278167134251"] = {name = "Influencer Gibbon", prices = {["default"] = 22.3, ["Ride"] = 26.25, ["Fly|Ride"] = 156.19, ["Neon"] = 205.33, ["Neon|Ride"] = 348.93, ["Mega"] = 705.54, ["Mega|Ride"] = 1161.57, ["Mega|Fly|Ride"] = 703.29}},
    ["rbxassetid://17059982206"] = {name = "Dimorphodon", prices = {["default"] = 18.38, ["Fly"] = 84.73, ["Ride"] = 32.75, ["Fly|Ride"] = 82.69, ["Neon"] = 103.69, ["Neon|Fly"] = 423.11, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 211.56, ["Mega|Ride"] = 940.35, ["Mega|Fly|Ride"] = 946.71}},
    ["rbxassetid://119212313534429"] = {name = "Giant Panda", prices = {["default"] = 6562.5, ["Ride"] = 5906.25, ["Fly|Ride"] = 5118.75, ["Neon"] = 30984.08, ["Neon|Fly|Ride"] = 23625}},
    ["rbxassetid://6060998707"] = {name = "Frost Fury", prices = {["default"] = 234.11, ["Fly"] = 264.07, ["Ride"] = 247.84, ["Fly|Ride"] = 291.35, ["Neon|Ride"] = 707.26, ["Neon|Fly|Ride"] = 577.5, ["Mega|Fly|Ride"] = 2935.27}},
    ["rbxassetid://88882779021298"] = {name = "Kitty Bat", prices = {["default"] = 34.13, ["Fly"] = 104.11, ["Ride"] = 65.63, ["Fly|Ride"] = 113.56, ["Neon"] = 75.29, ["Neon|Fly"] = 145.99, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 161.44, ["Mega"] = 286.07, ["Mega|Fly"] = 338.49, ["Mega|Ride"] = 313.84, ["Mega|Fly|Ride"] = 376.69}},
    ["rbxassetid://16441372760"] = {name = "Diamond Mahi Mahi", prices = {["default"] = 2.63, ["Fly"] = 41.2, ["Ride"] = 20.9, ["Fly|Ride"] = 99.3, ["Neon"] = 19.69, ["Neon|Ride"] = 57.14, ["Neon|Fly|Ride"] = 192.52, ["Mega"] = 179.82}},
    ["rbxassetid://3199974169"] = {name = "Royal Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://84714602656867"] = {name = "Slimingo", prices = {["default"] = 36.75, ["Fly"] = 98.86, ["Ride"] = 84.5, ["Fly|Ride"] = 153.53, ["Neon"] = 112.88, ["Neon|Fly"] = 282.02, ["Neon|Ride"] = 141.56, ["Neon|Fly|Ride"] = 282.02, ["Mega"] = 612.89, ["Mega|Ride"] = 448.02, ["Mega|Fly|Ride"] = 531.25}},
    ["rbxassetid://3409443710"] = {name = "Giraffe", prices = {["default"] = 18308.43, ["Ride"] = 10893.75, ["Fly|Ride"] = 11025, ["Neon|Fly|Ride"] = 23625, ["Mega|Fly|Ride"] = 91666.8}},
    ["rbxassetid://121215031043780"] = {name = "Velocirooster", prices = {["default"] = 131.25, ["Ride"] = 190.45, ["Fly|Ride"] = 248.2, ["Neon"] = 842.88, ["Neon|Ride"] = 844.1, ["Neon|Fly|Ride"] = 987.95, ["Mega|Fly|Ride"] = 7071.61}},
    ["rbxassetid://5067925034"] = {name = "Ninja Monkey", prices = {["default"] = 66.71, ["Fly"] = 459.38, ["Ride"] = 60.38, ["Fly|Ride"] = 102.17, ["Neon|Fly"] = 470.75, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 288.75, ["Mega|Fly|Ride"] = 2000.25}},
    ["rbxassetid://10618035564"] = {name = "Baku", prices = {["default"] = 9.19, ["Fly"] = 31.78, ["Ride"] = 21.06, ["Fly|Ride"] = 65.54, ["Neon"] = 72.19, ["Neon|Ride"] = 78.74, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 2538.62, ["Mega|Ride"] = 493.99, ["Mega|Fly|Ride"] = 472.45}},
    ["rbxassetid://13665641282"] = {name = "Shark Puppy", prices = {["default"] = 367.5, ["Fly"] = 844.98, ["Ride"] = 404.25, ["Fly|Ride"] = 475.63, ["Neon"] = 1639.32, ["Neon|Ride"] = 1311.19, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 4935}},
    ["rbxassetid://119447343321908"] = {name = "Tealwood Monster", prices = {["default"] = 4.72, ["Fly"] = 87.08, ["Ride"] = 35.44, ["Fly|Ride"] = 105.65, ["Neon"] = 28.06, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 240.12, ["Mega"] = 118.13, ["Mega|Ride"] = 126.94, ["Mega|Fly|Ride"] = 275.03}},
    ["rbxassetid://85568505745239"] = {name = "Latte Kitsune", prices = {["default"] = 178.9, ["Fly"] = 196.49, ["Ride"] = 201.98, ["Fly|Ride"] = 211.23, ["Neon"] = 703.45, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 656.25, ["Mega|Ride"] = 3455.68, ["Mega|Fly|Ride"] = 2559.78}},
    ["rbxassetid://3181727727"] = {name = "Griffin", prices = {["default"] = 12.75, ["Fly"] = 21, ["Ride"] = 21.14, ["Fly|Ride"] = 32.82, ["Neon|Ride"] = 92.55, ["Neon|Fly|Ride"] = 94.5, ["Mega"] = 786.19, ["Mega|Fly|Ride"] = 663.23}},
    ["rbxassetid://4822753215"] = {name = "Golden Egg", prices = {["default"] = 11.64}},
    ["rbxassetid://116463571924920"] = {name = "Prismatic Butterfly", prices = {["default"] = 61.69, ["Ride"] = 72.19, ["Fly|Ride"] = 525, ["Neon"] = 205.97, ["Neon|Fly"] = 1689.96, ["Neon|Ride"] = 370.22, ["Neon|Fly|Ride"] = 468.48, ["Mega"] = 1267.2, ["Mega|Ride"] = 1414.33, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://8596153183"] = {name = "Chameleon", prices = {["default"] = 15.54, ["Fly"] = 104.57, ["Ride"] = 34.13, ["Fly|Ride"] = 84, ["Neon"] = 95.82, ["Neon|Ride"] = 99.75, ["Neon|Fly|Ride"] = 181.02, ["Mega"] = 474.94, ["Mega|Ride"] = 501.48, ["Mega|Fly|Ride"] = 557.82}},
    ["rbxassetid://110774856122162"] = {name = "Gemstone Egg", prices = {["default"] = 13.11}},
    ["rbxassetid://14892649590"] = {name = "Dire Stag", prices = {["default"] = 24.93, ["Fly"] = 109.33, ["Ride"] = 57.75, ["Fly|Ride"] = 235.52, ["Neon"] = 170.62, ["Neon|Ride"] = 223.13, ["Neon|Fly|Ride"] = 239.76, ["Mega"] = 670.63, ["Mega|Ride"] = 691.79, ["Mega|Fly|Ride"] = 748.13}},
    ["rbxassetid://106744890070136"] = {name = "Oakee Wizard", prices = {["default"] = 3.93, ["Ride"] = 36.99, ["Fly|Ride"] = 131.25, ["Neon"] = 23.39, ["Neon|Ride"] = 106.1, ["Neon|Fly|Ride"] = 124.83, ["Mega"] = 109.91, ["Mega|Fly|Ride"] = 395.61}},
    ["rbxassetid://9938967576"] = {name = "Chocolate Chow-Chow", prices = {["default"] = 12.95, ["Ride"] = 30.19, ["Fly|Ride"] = 97.13, ["Neon"] = 105, ["Neon|Ride"] = 111.57, ["Neon|Fly|Ride"] = 224.25, ["Mega"] = 705.54, ["Mega|Ride"] = 495.05, ["Mega|Fly|Ride"] = 759.94}},
    ["rbxassetid://9174893483"] = {name = "Mechapup", prices = {["default"] = 409.5, ["Fly"] = 437.75, ["Ride"] = 328.13, ["Fly|Ride"] = 406.88, ["Neon|Fly|Ride"] = 2362.5, ["Mega|Fly|Ride"] = 7757.56}},
    ["rbxassetid://15292843858"] = {name = "Mecha Meow", prices = {["default"] = 56.86, ["Ride"] = 63.38, ["Fly|Ride"] = 131.25, ["Neon"] = 156.33, ["Neon|Ride"] = 204.02, ["Neon|Fly|Ride"] = 240.12, ["Mega"] = 704.96, ["Mega|Ride"] = 681.45, ["Mega|Fly|Ride"] = 688.62}},
    ["rbxassetid://15931200262"] = {name = "Cactus Friend", prices = {["default"] = 45.14, ["Fly"] = 83.91, ["Ride"] = 55.13, ["Fly|Ride"] = 138.12, ["Neon"] = 201.92, ["Neon|Ride"] = 141.75, ["Neon|Fly|Ride"] = 282.43, ["Mega"] = 1257.59, ["Mega|Ride"] = 1050, ["Mega|Fly|Ride"] = 1093.73}},
    ["rbxassetid://127221459636244"] = {name = "Strawberry Shortcake Ducky", prices = {["default"] = 30.64, ["Ride"] = 63.95, ["Fly|Ride"] = 131.25, ["Neon"] = 71.85, ["Neon|Ride"] = 98.44, ["Neon|Fly|Ride"] = 298.46, ["Mega"] = 387.19, ["Mega|Ride"] = 405.57, ["Mega|Fly|Ride"] = 522.38}},
    ["rbxassetid://4470748644"] = {name = "Frost Dragon", prices = {["default"] = 11287.5, ["Fly"] = 9843.75, ["Ride"] = 11280.75, ["Fly|Ride"] = 7835.63, ["Neon|Fly|Ride"] = 16203.32, ["Mega|Fly|Ride"] = 39372.9}},
    ["rbxassetid://15365667976"] = {name = "Chocolate Chip Bat Dragon", prices = {["default"] = 1868.99, ["Fly"] = 1706.25, ["Ride"] = 1745.63, ["Fly|Ride"] = 1803.38, ["Neon|Fly|Ride"] = 4856.25, ["Mega|Fly|Ride"] = 22050}},
    ["rbxassetid://16898343164"] = {name = "Pirate Ghost Capuchin Monkey", prices = {["default"] = 388.5, ["Ride"] = 464.76, ["Fly|Ride"] = 393.75, ["Neon"] = 2112.45, ["Neon|Ride"] = 1730.49, ["Neon|Fly|Ride"] = 1480.86, ["Mega"] = 16924.03, ["Mega|Fly|Ride"] = 6488.26}},
    ["rbxassetid://6404812772"] = {name = "Golden Ladybug", prices = {["default"] = 7.76, ["Fly"] = 31.7, ["Ride"] = 19.69, ["Fly|Ride"] = 39.56, ["Neon"] = 108.81, ["Neon|Ride"] = 113.21, ["Neon|Fly|Ride"] = 105, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://95029455226760"] = {name = "Easter Bunny", prices = {["default"] = 6.22, ["Fly"] = 39.38, ["Ride"] = 36.86, ["Fly|Ride"] = 124.69, ["Neon"] = 30.61, ["Neon|Ride"] = 47.16, ["Mega"] = 143.73, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 220.41}},
    ["rbxassetid://5307473113"] = {name = "Kitsune", prices = {["default"] = 35.44, ["Fly"] = 52.83, ["Ride"] = 44.38, ["Fly|Ride"] = 85.32, ["Neon|Ride"] = 101.07, ["Neon|Fly|Ride"] = 176.8, ["Mega|Fly|Ride"] = 552.57}},
    ["rbxassetid://4797806780"] = {name = "Golden Dragon", prices = {["default"] = 3.68, ["Fly"] = 27.48, ["Ride"] = 14.44, ["Fly|Ride"] = 39.37, ["Neon"] = 22.32, ["Neon|Fly"] = 282.02, ["Neon|Ride"] = 45.93, ["Neon|Fly|Ride"] = 99.65, ["Mega"] = 360.94, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 325.42}},
    ["rbxassetid://135649428081307"] = {name = "Sakura Spirit", prices = {["default"] = 328.13, ["Fly"] = 314.9, ["Ride"] = 339.31, ["Fly|Ride"] = 360.94, ["Neon|Ride"] = 1312.5, ["Neon|Fly|Ride"] = 1293.18, ["Mega|Fly|Ride"] = 7192.73}},
    ["rbxassetid://11109110190"] = {name = "White Amazon", prices = {["default"] = 28.5, ["Fly"] = 48.19, ["Ride"] = 38.07, ["Fly|Ride"] = 75.3, ["Neon"] = 127.61, ["Neon|Fly"] = 282.02, ["Neon|Ride"] = 139.63, ["Neon|Fly|Ride"] = 220.49, ["Mega|Ride"] = 582.75, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://9475753542"] = {name = "Golden Albatross", prices = {["default"] = 11.64, ["Fly"] = 24.36, ["Ride"] = 23.25, ["Fly|Ride"] = 42, ["Neon"] = 84.51, ["Neon|Fly"] = 136.5, ["Neon|Ride"] = 81.38, ["Neon|Fly|Ride"] = 116.82, ["Mega"] = 528.89, ["Mega|Ride"] = 582.84, ["Mega|Fly|Ride"] = 1128.75}},
    ["rbxassetid://12778628831"] = {name = "Emperor Gorilla", prices = {["default"] = 561.54, ["Fly"] = 787.5, ["Ride"] = 459.38, ["Fly|Ride"] = 793.13, ["Neon|Ride"] = 2750.16, ["Mega|Fly|Ride"] = 8619.19}},
    ["rbxassetid://13672542902"] = {name = "Hot Doggo", prices = {["default"] = 1123.49, ["Fly"] = 1411.85, ["Ride"] = 1170.75, ["Fly|Ride"] = 1181.25, ["Neon"] = 4943.1, ["Neon|Fly|Ride"] = 3570, ["Mega|Fly|Ride"] = 16499.87}},
    ["rbxassetid://8070897995"] = {name = "Ice Golem", prices = {["default"] = 85.32, ["Fly"] = 125.9, ["Ride"] = 93.19, ["Fly|Ride"] = 112.13, ["Neon"] = 502.78, ["Neon|Ride"] = 414.75, ["Neon|Fly|Ride"] = 525, ["Mega|Fly|Ride"] = 1704.94}},
    ["rbxassetid://128225904426926"] = {name = "Rose Dragon", prices = {["default"] = 183.75, ["Fly"] = 204.73, ["Ride"] = 176.77, ["Fly|Ride"] = 224.44, ["Neon"] = 649.63, ["Neon|Fly"] = 887.23, ["Neon|Ride"] = 629.5, ["Neon|Fly|Ride"] = 590.63, ["Mega|Ride"] = 2961.72, ["Mega|Fly|Ride"] = 2625}},
    ["rbxassetid://13883274830"] = {name = "Pirate Hermit Crab", prices = {["default"] = 21, ["Fly"] = 131.25, ["Ride"] = 42, ["Fly|Ride"] = 281.98, ["Neon"] = 183.75, ["Neon|Fly"] = 423.11, ["Neon|Ride"] = 272.99, ["Neon|Fly|Ride"] = 324.74, ["Mega|Ride"] = 942.89, ["Mega|Fly|Ride"] = 865.11}},
    ["rbxassetid://95213400890066"] = {name = "Diamond Hummingbird", prices = {["default"] = 141.56, ["Ride"] = 210.74, ["Fly|Ride"] = 597.19, ["Neon"] = 1056.23, ["Mega|Fly|Ride"] = 2922.94}},
    ["rbxassetid://10453528102"] = {name = "Diamond Butterfly", prices = {["default"] = 2112.45, ["Fly"] = 2526.48, ["Ride"] = 2152.49, ["Fly|Ride"] = 2211.72, ["Neon|Fly|Ride"] = 7192.73, ["Mega|Fly|Ride"] = 48656.55}},
    ["rbxassetid://12778628650"] = {name = "Astronaut Gorilla", prices = {["default"] = 57.14, ["Ride"] = 36.71, ["Fly|Ride"] = 156.32, ["Neon"] = 290.48, ["Neon|Fly"] = 211.26, ["Neon|Ride"] = 282.43, ["Neon|Fly|Ride"] = 295.12, ["Mega"] = 2115.51, ["Mega|Ride"] = 2327.07, ["Mega|Fly|Ride"] = 1807.99}},
    ["rbxassetid://4708551306"] = {name = "Kangaroo", prices = {["default"] = 603.75, ["Fly"] = 675.94, ["Ride"] = 603.75, ["Fly|Ride"] = 633.35, ["Neon|Ride"] = 1266.57, ["Neon|Fly|Ride"] = 1246.88, ["Mega|Fly|Ride"] = 2947.77}},
    ["rbxassetid://9542440966"] = {name = "Capricorn", prices = {["default"] = 39.38, ["Fly"] = 60.38, ["Ride"] = 52.5, ["Fly|Ride"] = 85.32, ["Neon"] = 157.5, ["Neon|Ride"] = 365.44, ["Neon|Fly|Ride"] = 211.56, ["Mega|Fly|Ride"] = 1456.88}},
    ["rbxassetid://9678195673"] = {name = "Ancient Dragon", prices = {["default"] = 3.94, ["Fly"] = 32.75, ["Ride"] = 20.9, ["Fly|Ride"] = 47.07, ["Neon"] = 21.14, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 52.89, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 137.82, ["Mega|Fly"] = 131.25, ["Mega|Ride"] = 139.63, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://132388343771587"] = {name = "Kelp Captain", prices = {["default"] = 40.15, ["Ride"] = 52.42, ["Fly|Ride"] = 78.75, ["Neon"] = 261.95, ["Neon|Ride"] = 264.45, ["Neon|Fly|Ride"] = 312.05, ["Mega|Ride"] = 1411.06, ["Mega|Fly|Ride"] = 942.89}},
    ["rbxassetid://15148532648"] = {name = "Werewolf", prices = {["default"] = 556.11, ["Fly"] = 899.07, ["Ride"] = 564.38, ["Fly|Ride"] = 564.38, ["Neon"] = 1901.21, ["Neon|Ride"] = 1771.88, ["Neon|Fly|Ride"] = 1548.75, ["Mega|Fly|Ride"] = 5250}},
    ["rbxassetid://86323568215409"] = {name = "Tortoiseshell Guinea Pig", prices = {["default"] = 551.25, ["Ride"] = 525, ["Fly|Ride"] = 644.44, ["Neon"] = 5281.08, ["Neon|Ride"] = 4068.75, ["Neon|Fly|Ride"] = 2625, ["Mega|Fly|Ride"] = 9873.06}},
    ["rbxassetid://5973019152"] = {name = "Robo Dog", prices = {["default"] = 15.74, ["Fly"] = 42.08, ["Ride"] = 24.35, ["Fly|Ride"] = 39.3, ["Neon"] = 211.26, ["Neon|Ride"] = 99.45, ["Neon|Fly|Ride"] = 105, ["Mega"] = 787.5, ["Mega|Fly|Ride"] = 578.61}},
    ["rbxassetid://7734928470"] = {name = "Halloween Golden Mummy Cat", prices = {["default"] = 6.54, ["Ride"] = 21.14, ["Fly|Ride"] = 74.82, ["Neon"] = 140.97, ["Neon|Ride"] = 124.69, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 1690.31, ["Mega|Ride"] = 447.45, ["Mega|Fly|Ride"] = 385.03}},
    ["rbxassetid://137429532189183"] = {name = "Fire Stallion", prices = {["default"] = 5.25, ["Ride"] = 31.61, ["Fly|Ride"] = 98.43, ["Neon"] = 19.67, ["Neon|Fly"] = 112.56, ["Neon|Ride"] = 57.75, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 126, ["Mega|Fly"] = 405.45, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 330.74}},
    ["rbxassetid://7215324578"] = {name = "Axolotl", prices = {["default"] = 35.41, ["Fly"] = 56.85, ["Ride"] = 45.68, ["Fly|Ride"] = 94.34, ["Neon"] = 235.38, ["Neon|Ride"] = 183.75, ["Neon|Fly|Ride"] = 259.04, ["Mega|Fly|Ride"] = 656.15}},
    ["rbxassetid://111805565268081"] = {name = "Black Widow", prices = {["default"] = 45.94, ["Ride"] = 91.88, ["Fly|Ride"] = 449.61, ["Neon"] = 282.03, ["Neon|Ride"] = 406.88, ["Neon|Fly|Ride"] = 695.63, ["Mega"] = 1389.9, ["Mega|Ride"] = 1530.58, ["Mega|Fly|Ride"] = 1551.74}},
    ["rbxassetid://103653773461193"] = {name = "Sunglider", prices = {["default"] = 16.91, ["Fly"] = 39.38, ["Ride"] = 27.57, ["Fly|Ride"] = 52.5, ["Neon"] = 110.92, ["Neon|Ride"] = 99.74, ["Neon|Fly|Ride"] = 160.02, ["Mega"] = 423.11, ["Mega|Ride"] = 406.88, ["Mega|Fly|Ride"] = 535.11}},
    ["rbxassetid://6498256069"] = {name = "Shark", prices = {["default"] = 36.49, ["Fly"] = 99.3, ["Ride"] = 45.94, ["Fly|Ride"] = 78.63, ["Neon"] = 408.77, ["Neon|Ride"] = 141.09, ["Neon|Fly|Ride"] = 210.31, ["Mega"] = 2100, ["Mega|Fly|Ride"] = 1178.62}},
    ["rbxassetid://8663440945"] = {name = "Lunar Gold Tiger", prices = {["default"] = 3.82, ["Fly"] = 31.49, ["Ride"] = 17.07, ["Fly|Ride"] = 39.37, ["Neon"] = 31.5, ["Neon|Ride"] = 40.3, ["Neon|Fly|Ride"] = 84.63, ["Mega"] = 183.75, ["Mega|Ride"] = 211.56, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://94185217299816"] = {name = "Dracula Parrot", prices = {["default"] = 5.52, ["Ride"] = 28.53, ["Fly|Ride"] = 78.84, ["Neon"] = 26.17, ["Neon|Fly"] = 157.98, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 152.34, ["Mega"] = 235.9, ["Mega|Fly"] = 480.23, ["Mega|Ride"] = 285.87, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://4621220431"] = {name = "Golden Rat", prices = {["default"] = 47.78, ["Fly"] = 60.38, ["Ride"] = 55.13, ["Fly|Ride"] = 91.88, ["Neon"] = 228.16, ["Neon|Ride"] = 202.05, ["Neon|Fly|Ride"] = 221.5, ["Mega|Fly|Ride"] = 918.64}},
    ["rbxassetid://11506045996"] = {name = "Strawberry Shortcake Bat Dragon", prices = {["default"] = 1903.13, ["Fly"] = 1771.88, ["Ride"] = 1766.63, ["Fly|Ride"] = 1771.88, ["Neon|Ride"] = 5287.71, ["Neon|Fly|Ride"] = 3916.5, ["Mega|Fly|Ride"] = 15515.11}},
    ["rbxassetid://11758583912"] = {name = "Winged Tiger", prices = {["default"] = 446.25, ["Fly"] = 634.47, ["Ride"] = 501.72, ["Fly|Ride"] = 548.02, ["Neon"] = 3138.66, ["Neon|Ride"] = 3103.46, ["Neon|Fly|Ride"] = 2362.5, ["Mega|Fly|Ride"] = 9703.82}},
    ["rbxassetid://101160794933271"] = {name = "Matcha Cat", prices = {["default"] = 221.2, ["Fly"] = 157.5, ["Ride"] = 267.75, ["Fly|Ride"] = 393.75, ["Neon"] = 1202.53, ["Neon|Ride"] = 1179.94, ["Neon|Fly|Ride"] = 1509.42, ["Mega"] = 7052.04, ["Mega|Fly|Ride"] = 6562.5}},
    ["rbxassetid://13892790514"] = {name = "Urban Egg", prices = {["default"] = 50.15}},
    ["rbxassetid://13104109574"] = {name = "Spinosaurus", prices = {["default"] = 28.53, ["Fly"] = 65.63, ["Ride"] = 46.96, ["Fly|Ride"] = 103.69, ["Neon"] = 206.07, ["Neon|Ride"] = 252.73, ["Neon|Fly|Ride"] = 418.98, ["Mega|Ride"] = 1551.74, ["Mega|Fly|Ride"] = 1254.75}},
    ["rbxassetid://4115248712"] = {name = "Shadow Dragon", prices = {["default"] = 33798.89, ["Fly"] = 23625, ["Ride"] = 34781.25, ["Fly|Ride"] = 18087.25, ["Neon|Fly|Ride"] = 38062.5, ["Mega|Fly|Ride"] = 89250}},
    ["rbxassetid://71457697470071"] = {name = "Arctic Dusk Dragon", prices = {["default"] = 287.44, ["Fly"] = 316.32, ["Ride"] = 336.11, ["Fly|Ride"] = 388.5, ["Neon"] = 1056.23, ["Neon|Fly"] = 1600.53, ["Neon|Ride"] = 1004.07, ["Neon|Fly|Ride"] = 918.75, ["Mega"] = 6346.52, ["Mega|Ride"] = 6600.17, ["Mega|Fly|Ride"] = 2625}},
    ["rbxassetid://8566683457"] = {name = "Giant Gold Scarab", prices = {["default"] = 125.9, ["Fly"] = 141.56, ["Ride"] = 188.02, ["Fly|Ride"] = 154.88, ["Neon|Fly|Ride"] = 1057.76, ["Mega|Fly|Ride"] = 4090.34}},
    ["rbxassetid://16116063171"] = {name = "Rainbow Dragon", prices = {["default"] = 122.05, ["Ride"] = 134.64, ["Fly|Ride"] = 195.82, ["Neon"] = 534.31, ["Neon|Ride"] = 521.11, ["Neon|Fly|Ride"] = 525, ["Mega"] = 14104.07, ["Mega|Fly|Ride"] = 2511.11}},
    ["rbxassetid://9938967130"] = {name = "Black Chow-Chow", prices = {["default"] = 14.44, ["Fly"] = 70.79, ["Ride"] = 32.86, ["Fly|Ride"] = 98.44, ["Neon"] = 125.94, ["Neon|Ride"] = 135.19, ["Neon|Fly|Ride"] = 249.38, ["Mega"] = 705.54, ["Mega|Fly|Ride"] = 613.52}},
    ["rbxassetid://116467943923352"] = {name = "Haetae", prices = {["default"] = 5087.6, ["Ride"] = 4675.32, ["Fly|Ride"] = 4060.88, ["Neon|Ride"] = 16924.03, ["Neon|Fly|Ride"] = 17616.85, ["Mega|Fly|Ride"] = 70517.08}},
    ["rbxassetid://6531232495"] = {name = "Peacock", prices = {["default"] = 28.88, ["Fly"] = 45.93, ["Ride"] = 32.82, ["Fly|Ride"] = 62.45, ["Neon"] = 333.94, ["Neon|Ride"] = 220.44, ["Neon|Fly|Ride"] = 157.5, ["Mega|Fly|Ride"] = 685.13}},
    ["rbxassetid://12557346746"] = {name = "Naga Dragon", prices = {["default"] = 44.92, ["Fly"] = 141.56, ["Ride"] = 47.25, ["Fly|Ride"] = 107.63, ["Neon"] = 260.09, ["Neon|Fly"] = 1409.01, ["Neon|Ride"] = 282.43, ["Neon|Fly|Ride"] = 208.69, ["Mega|Fly|Ride"] = 1030.26}},
    ["rbxassetid://127697654557674"] = {name = "Candicorn", prices = {["default"] = 606.4, ["Fly"] = 656.25, ["Ride"] = 590.63, ["Fly|Ride"] = 708.75, ["Neon"] = 1680, ["Neon|Ride"] = 1582.91, ["Neon|Fly|Ride"] = 1443.75, ["Mega|Fly|Ride"] = 4725}},
    ["rbxassetid://4281674580"] = {name = "King Bee", prices = {["default"] = 12.68, ["Fly"] = 28.23, ["Ride"] = 25.36, ["Fly|Ride"] = 42.26, ["Neon"] = 98.44, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 128.86, ["Mega"] = 776.41, ["Mega|Fly|Ride"] = 523.69}},
    ["rbxassetid://17822543288"] = {name = "Blue Betta Fish", prices = {["default"] = 15.86, ["Ride"] = 70.76, ["Fly|Ride"] = 65.63, ["Neon"] = 72.19, ["Neon|Ride"] = 77.44, ["Neon|Fly|Ride"] = 249.38, ["Mega"] = 377.18}},
    ["rbxassetid://102300026415493"] = {name = "Moose Calf", prices = {["default"] = 78.75, ["Ride"] = 139.06, ["Fly|Ride"] = 157.5, ["Neon"] = 703.45, ["Neon|Ride"] = 525.35, ["Neon|Fly|Ride"] = 739.38, ["Mega|Fly|Ride"] = 2193.18}},
    ["rbxassetid://78419574214060"] = {name = "Christmas Spirit", prices = {["default"] = 22.31, ["Fly"] = 141.56, ["Ride"] = 88.93, ["Fly|Ride"] = 144.38, ["Neon"] = 93.56, ["Neon|Ride"] = 137.52, ["Neon|Fly|Ride"] = 246.93, ["Mega"] = 277.6, ["Mega|Fly"] = 786.19, ["Mega|Ride"] = 287.49, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://130642623661179"] = {name = "Cryptid", prices = {["default"] = 3253.69, ["Ride"] = 3163.13, ["Fly|Ride"] = 3281.25, ["Neon"] = 13125, ["Neon|Ride"] = 10059.54, ["Neon|Fly|Ride"] = 8505, ["Mega"] = 63465.05, ["Mega|Fly|Ride"] = 34468.88}},
    ["rbxassetid://101130894252942"] = {name = "Peach Owl", prices = {["default"] = 23.63, ["Fly"] = 57.05, ["Ride"] = 70.79, ["Fly|Ride"] = 105.63, ["Neon"] = 210.67, ["Neon|Ride"] = 197.81, ["Neon|Fly|Ride"] = 366, ["Mega|Ride"] = 951.99, ["Mega|Fly|Ride"] = 892.5}},
    ["rbxassetid://4440866649"] = {name = "Owl", prices = {["default"] = 7087.5, ["Ride"] = 8471.01, ["Fly|Ride"] = 5903.63, ["Neon|Fly|Ride"] = 16363.1, ["Mega|Fly|Ride"] = 60645.1}},
    ["rbxassetid://6836687169"] = {name = "Golden Griffin", prices = {["default"] = 2.63, ["Fly"] = 23.25, ["Ride"] = 17.07, ["Fly|Ride"] = 35.44, ["Neon"] = 27.08, ["Neon|Fly"] = 91.8, ["Neon|Ride"] = 40.09, ["Neon|Fly|Ride"] = 77.44, ["Mega"] = 281.38, ["Mega|Ride"] = 312.05, ["Mega|Fly|Ride"] = 324.74}},
    ["rbxassetid://76198828333546"] = {name = "Hippogriff", prices = {["default"] = 18.75, ["Fly"] = 31.78, ["Ride"] = 30.19, ["Fly|Ride"] = 48.57, ["Neon"] = 70.63, ["Neon|Fly"] = 141.56, ["Neon|Ride"] = 559.37, ["Neon|Fly|Ride"] = 351.19, ["Mega|Ride"] = 1542.85, ["Mega|Fly|Ride"] = 927.94}},
    ["rbxassetid://112567270488274"] = {name = "Crystal Egg", prices = {["default"] = 3.21}},
    ["rbxassetid://10695038557"] = {name = "Maneki-Neko", prices = {["default"] = 16.94, ["Ride"] = 36.99, ["Fly|Ride"] = 126.75, ["Neon"] = 157.28, ["Neon|Ride"] = 127.24, ["Neon|Fly|Ride"] = 138.58, ["Mega"] = 704.48, ["Mega|Ride"] = 987.95, ["Mega|Fly|Ride"] = 865.11}},
    ["rbxassetid://16911441596"] = {name = "Royal Capuchin Monkey", prices = {["default"] = 22.32, ["Fly"] = 262.5, ["Ride"] = 51.19, ["Fly|Ride"] = 141.52, ["Neon"] = 182.43, ["Neon|Ride"] = 154.09, ["Neon|Fly|Ride"] = 280.93, ["Mega"] = 840, ["Mega|Fly|Ride"] = 786.14}},
    ["rbxassetid://6963387165"] = {name = "Cobra", prices = {["default"] = 8.99, ["Fly"] = 23.94, ["Ride"] = 17.62, ["Fly|Ride"] = 41.64, ["Neon"] = 141.56, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 168.27, ["Mega"] = 820.32, ["Mega|Ride"] = 588.13, ["Mega|Fly|Ride"] = 629.39}},
    ["rbxassetid://3409444171"] = {name = "Safari Egg", prices = {["default"] = 8351.51}},
    ["rbxassetid://3743740864"] = {name = "Jungle Egg", prices = {["default"] = 3145.43}},
    ["rbxassetid://10321884333"] = {name = "Japan Egg", prices = {["default"] = 30.64}},
    ["rbxassetid://11109117895"] = {name = "Diamond Amazon", prices = {["default"] = 141.56, ["Fly"] = 174.57, ["Ride"] = 189, ["Fly|Ride"] = 352.74}},
    ["rbxassetid://102144672439627"] = {name = "Berry Cool Cube", prices = {["default"] = 20.79, ["Fly"] = 133.1, ["Ride"] = 51.78, ["Fly|Ride"] = 105, ["Neon"] = 141.1, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 157.95, ["Mega"] = 811.31, ["Mega|Ride"] = 813.75, ["Mega|Fly|Ride"] = 846.21}},
    ["rbxassetid://17183502626"] = {name = "Garden Egg", prices = {["default"] = 9.19}},
    ["rbxassetid://16722909609"] = {name = "Striped Eggy", prices = {["default"] = 9.45, ["Ride"] = 26.25, ["Neon"] = 82.4, ["Neon|Ride"] = 84.63, ["Mega|Fly|Ride"] = 465.94}},
    ["rbxassetid://4440866155"] = {name = "Farm Egg", prices = {["default"] = 2572.5}},
    ["rbxassetid://88361277330582"] = {name = "Naughty Mistletroll", prices = {["default"] = 230.29, ["Ride"] = 259.82, ["Fly|Ride"] = 10498.95, ["Neon"] = 918.75, ["Neon|Ride"] = 705.54, ["Neon|Fly|Ride"] = 791.21, ["Mega|Fly|Ride"] = 2932.1}},
    ["rbxassetid://12778919221"] = {name = "Yule Log Dog", prices = {["default"] = 135.32, ["Ride"] = 176.88, ["Fly|Ride"] = 281.98, ["Neon|Ride"] = 787.5, ["Neon|Fly|Ride"] = 1051.33, ["Mega"] = 3437.7, ["Mega|Ride"] = 2327.07, ["Mega|Fly|Ride"] = 1973.77}},
    ["rbxassetid://13104112588"] = {name = "Owlbear", prices = {["default"] = 177.18, ["Ride"] = 164.07, ["Fly|Ride"] = 221.29, ["Neon"] = 799.32, ["Neon|Ride"] = 840, ["Neon|Fly|Ride"] = 842.03, ["Mega"] = 4654.11, ["Mega|Fly|Ride"] = 3056.82}},
    ["rbxassetid://11192035130"] = {name = "Undead Jousting Horse", prices = {["default"] = 1181.25, ["Fly"] = 2534.93, ["Ride"] = 1194.38, ["Fly|Ride"] = 1286.25, ["Neon"] = 5351.85, ["Neon|Ride"] = 5345.89, ["Neon|Fly|Ride"] = 4462.5, ["Mega|Fly|Ride"] = 22211.72}},
    ["rbxassetid://106575933009346"] = {name = "Fairytale Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://96044273915258"] = {name = "Endangered Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://129993159377616"] = {name = "Peahen", prices = {["default"] = 18.32, ["Fly"] = 82.87, ["Ride"] = 39.38, ["Fly|Ride"] = 86.63, ["Neon"] = 141.1, ["Neon|Ride"] = 297.07, ["Neon|Fly|Ride"] = 422.63, ["Mega"] = 845.16, ["Mega|Fly|Ride"] = 917.09}},
    ["rbxassetid://12732812236"] = {name = "Tio De Nadal", prices = {["default"] = 656.25, ["Fly"] = 2100, ["Ride"] = 688.51, ["Fly|Ride"] = 1050}},
    ["rbxassetid://13936755787"] = {name = "Wrapped Doll", prices = {["default"] = 93.18}},
    ["rbxassetid://136441478335419"] = {name = "Emberlight", prices = {["default"] = 13.13, ["Fly"] = 393.75, ["Ride"] = 36.75, ["Fly|Ride"] = 98.44, ["Neon"] = 90.57, ["Neon|Ride"] = 105.78, ["Neon|Fly|Ride"] = 493.99, ["Mega"] = 363.57, ["Mega|Ride"] = 441.79, ["Mega|Fly|Ride"] = 846.21}},
    ["rbxassetid://17120184484"] = {name = "Rosy Maple Moth", prices = {["default"] = 7.87, ["Fly"] = 131.25, ["Ride"] = 27.57, ["Fly|Ride"] = 52.5, ["Neon"] = 61.01, ["Neon|Ride"] = 83.61, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 423.11, ["Mega|Ride"] = 471.45}},
    ["rbxassetid://15932251755"] = {name = "Royal Desert Egg", prices = {["default"] = 72.17}},
    ["rbxassetid://8143039289"] = {name = "Golden Walrus", prices = {["default"] = 21, ["Fly"] = 108.92, ["Ride"] = 27.55, ["Fly|Ride"] = 65.54, ["Neon"] = 116.82, ["Neon|Ride"] = 158.67, ["Neon|Fly|Ride"] = 597.57, ["Mega"] = 819.77, ["Mega|Ride"] = 846.21, ["Mega|Fly|Ride"] = 1257.59}},
    ["rbxassetid://12187391973"] = {name = "Firefly", prices = {["default"] = 23.25, ["Fly"] = 48.6, ["Ride"] = 30.19, ["Fly|Ride"] = 67.6, ["Neon|Ride"] = 141.75, ["Neon|Fly|Ride"] = 313.52, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://3743647944"] = {name = "Parrot", prices = {["default"] = 5551.88, ["Fly"] = 11266.66, ["Ride"] = 4666.2, ["Fly|Ride"] = 4725, ["Neon|Ride"] = 15515.11, ["Neon|Fly|Ride"] = 10066.88, ["Mega|Fly|Ride"] = 35437.5}},
    ["rbxassetid://128454622445076"] = {name = "Dimension Drifter", prices = {["default"] = 9.19, ["Fly"] = 34.13, ["Ride"] = 32.82, ["Fly|Ride"] = 98.89, ["Neon"] = 65.63, ["Neon|Ride"] = 66.94, ["Neon|Fly|Ride"] = 353.3, ["Mega"] = 528.03, ["Mega|Ride"] = 282.43, ["Mega|Fly|Ride"] = 417.38}},
    ["rbxassetid://15931761708"] = {name = "Desert Egg", prices = {["default"] = 30.64}},
    ["rbxassetid://17747001377"] = {name = "Majestic Pony", prices = {["default"] = 105, ["Fly"] = 373.91, ["Ride"] = 105, ["Fly|Ride"] = 233.41, ["Neon"] = 418.69, ["Neon|Ride"] = 481.69, ["Neon|Fly|Ride"] = 597.57, ["Mega|Ride"] = 4231.02, ["Mega|Fly|Ride"] = 1860.59}},
    ["rbxassetid://94487786469241"] = {name = "Vanilla Penguin", prices = {["default"] = 82.48, ["Ride"] = 105, ["Fly|Ride"] = 153.57, ["Neon"] = 262.5, ["Neon|Ride"] = 346.96, ["Neon|Fly|Ride"] = 511.88, ["Mega|Ride"] = 1607.8, ["Mega|Fly|Ride"] = 1692.42}},
    ["rbxassetid://6498256211"] = {name = "Octopus", prices = {["default"] = 21.29, ["Fly"] = 72.17, ["Ride"] = 32.61, ["Fly|Ride"] = 60.21, ["Neon"] = 169.01, ["Neon|Ride"] = 110.25, ["Neon|Fly|Ride"] = 164.06, ["Mega"] = 691.79, ["Mega|Ride"] = 846.21, ["Mega|Fly|Ride"] = 656.22}},
    ["rbxassetid://110654583245787"] = {name = "Sea Turtle", prices = {["default"] = 4.96, ["Fly"] = 49.26, ["Ride"] = 33.71, ["Fly|Ride"] = 70.96, ["Neon"] = 23.25, ["Neon|Fly"] = 184.07, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 145.78, ["Mega"] = 118.13, ["Mega|Fly"] = 7034.11, ["Mega|Ride"] = 170.63, ["Mega|Fly|Ride"] = 263.82}},
    ["rbxassetid://8596147681"] = {name = "Squid", prices = {["default"] = 13.65, ["Fly"] = 64.22, ["Ride"] = 33.8, ["Fly|Ride"] = 74.82, ["Neon"] = 70.96, ["Neon|Ride"] = 82.69, ["Neon|Fly|Ride"] = 211.56, ["Mega"] = 359.65, ["Mega|Ride"] = 422.63, ["Mega|Fly|Ride"] = 538.13}},
    ["rbxassetid://9226723356"] = {name = "Winged Horse", prices = {["default"] = 23.62, ["Fly"] = 26.5, ["Ride"] = 28.53, ["Fly|Ride"] = 45.94, ["Neon"] = 252.69, ["Neon|Ride"] = 138.96, ["Neon|Fly|Ride"] = 127.05, ["Mega|Fly|Ride"] = 594.02}},
    ["rbxassetid://4733386633"] = {name = "Aussie Egg", prices = {["default"] = 213.94}},
    ["rbxassetid://121951206021245"] = {name = "Kiwi Kiwi", prices = {["default"] = 23.25, ["Ride"] = 95.82, ["Neon"] = 136.5, ["Neon|Ride"] = 164.07, ["Mega"] = 1184.7, ["Mega|Ride"] = 918.75, ["Mega|Fly|Ride"] = 1467.11}},
    ["rbxassetid://9602676771"] = {name = "Diamond Albatross", prices = {["default"] = 170.62, ["Ride"] = 156.19, ["Fly|Ride"] = 262.5, ["Neon|Ride"] = 820.32}},
    ["rbxassetid://79965389436178"] = {name = "Sushi Penguin", prices = {["default"] = 39.38, ["Fly"] = 211.99, ["Ride"] = 98.44, ["Fly|Ride"] = 262.5, ["Neon"] = 196.88, ["Neon|Fly"] = 353.3, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 1005.95, ["Mega|Ride"] = 1116.99, ["Mega|Fly|Ride"] = 1064.18}},
    ["rbxassetid://126930507653265"] = {name = "Grim Dragon", prices = {["default"] = 654.94, ["Fly"] = 780.94, ["Ride"] = 724.5, ["Fly|Ride"] = 721.88, ["Neon|Ride"] = 2231.25, ["Neon|Fly|Ride"] = 2340.26, ["Mega|Fly|Ride"] = 7726.69}},
    ["rbxassetid://87328715505907"] = {name = "Silverback Gorilla", prices = {["default"] = 262.5, ["Fly"] = 288.75, ["Ride"] = 346.5, ["Fly|Ride"] = 315, ["Neon"] = 1549.49, ["Neon|Ride"] = 2043.98, ["Neon|Fly|Ride"] = 1320.23, ["Mega"] = 6128.74, ["Mega|Fly|Ride"] = 4200}},
    ["rbxassetid://12733311267"] = {name = "Fool Egg", prices = {["default"] = 70.79}},
    ["rbxassetid://139472202653768"] = {name = "Admin Abuse Egg", prices = {["default"] = 2.63}},
    ["rbxassetid://8938702589"] = {name = "Hawk", prices = {["default"] = 11.46, ["Fly"] = 31.48, ["Ride"] = 24.81, ["Fly|Ride"] = 56.44, ["Neon"] = 77.95, ["Neon|Fly"] = 230.99, ["Neon|Ride"] = 97.5, ["Neon|Fly|Ride"] = 117.96, ["Mega"] = 405.14, ["Mega|Fly|Ride"] = 551.25}},
    ["rbxassetid://8938703243"] = {name = "Fallow Deer", prices = {["default"] = 307.44, ["Fly"] = 986.52, ["Ride"] = 341.49, ["Fly|Ride"] = 405.55, ["Neon"] = 1086.75, ["Neon|Ride"] = 787.5, ["Neon|Fly|Ride"] = 1030.14, ["Mega|Fly|Ride"] = 3652.43}},
    ["rbxassetid://4822753124"] = {name = "Diamond Egg", prices = {["default"] = 14.44}},
    ["rbxassetid://114823420678686"] = {name = "Dragonfruit Fox", prices = {["default"] = 103.52, ["Fly"] = 590.63, ["Ride"] = 175.32, ["Fly|Ride"] = 255.94, ["Neon"] = 525, ["Neon|Fly"] = 1409.01, ["Neon|Ride"] = 628.69, ["Neon|Fly|Ride"] = 657.64, ["Mega"] = 2819.98, ["Mega|Ride"] = 1975.89, ["Mega|Fly|Ride"] = 1842.04}},
    ["rbxassetid://102844319137806"] = {name = "Pineapple Owl", prices = {["default"] = 144.38, ["Ride"] = 156.33, ["Fly|Ride"] = 281.98, ["Neon"] = 986.52, ["Neon|Fly"] = 1055.17, ["Neon|Ride"] = 888.53}},
    ["rbxassetid://82296650763619"] = {name = "Angus Bull", prices = {["default"] = 6.3, ["Ride"] = 31.69, ["Fly|Ride"] = 94.13, ["Neon"] = 53.81, ["Neon|Ride"] = 70.55, ["Mega"] = 222.7, ["Mega|Ride"] = 436.96, ["Mega|Fly|Ride"] = 367.05}},
    ["rbxassetid://12917347755"] = {name = "Sunrise Duckling", prices = {["default"] = 10.9, ["Fly"] = 62.99, ["Ride"] = 28.88, ["Fly|Ride"] = 65.63, ["Neon"] = 128.63, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 261.19, ["Mega|Ride"] = 705.54, ["Mega|Fly|Ride"] = 577.5}},
    ["rbxassetid://139217275750567"] = {name = "Winter Buck", prices = {["default"] = 20.11, ["Fly"] = 126.37, ["Ride"] = 62.33, ["Fly|Ride"] = 141.39, ["Neon"] = 169.01, ["Neon|Ride"] = 127.32, ["Neon|Fly|Ride"] = 270.8, ["Mega"] = 391.38, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 707.17}},
    ["rbxassetid://114331718573822"] = {name = "Mochi Meow", prices = {["default"] = 4.67, ["Fly"] = 92.96, ["Ride"] = 51.09, ["Fly|Ride"] = 111.18, ["Neon"] = 23.15, ["Neon|Ride"] = 61.3, ["Neon|Fly|Ride"] = 173.6, ["Mega"] = 128.1, ["Mega|Ride"] = 155.12, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://112560568221286"] = {name = "Strawberry Penguin", prices = {["default"] = 262.49, ["Fly"] = 918.75, ["Ride"] = 305.93, ["Fly|Ride"] = 448.48, ["Neon"] = 1478.71, ["Neon|Ride"] = 1214.07, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 6235.45}},
    ["rbxassetid://116818749091454"] = {name = "Dango Penguins", prices = {["default"] = 67.61, ["Fly"] = 1050, ["Ride"] = 144.38, ["Fly|Ride"] = 137.82, ["Neon"] = 393.75, ["Neon|Ride"] = 459.37, ["Neon|Fly|Ride"] = 563.96, ["Mega"] = 1792.88, ["Mega|Ride"] = 1929.38, ["Mega|Fly|Ride"] = 1683.94}},
    ["rbxassetid://12480100169"] = {name = "Tree Kangaroo", prices = {["default"] = 43.32, ["Fly"] = 167.45, ["Ride"] = 84, ["Fly|Ride"] = 126.75, ["Neon|Ride"] = 282.19, ["Neon|Fly|Ride"] = 418.69, ["Mega|Fly|Ride"] = 1515.94}},
    ["rbxassetid://75106733244906"] = {name = "Golden Hummingbird", prices = {["default"] = 19.03, ["Ride"] = 33.8, ["Fly|Ride"] = 282.02, ["Neon|Ride"] = 598.82, ["Neon|Fly|Ride"] = 492.93, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://76354526914534"] = {name = "Frostclaw", prices = {["default"] = 18.38, ["Fly"] = 75.62, ["Ride"] = 39.38, ["Fly|Ride"] = 95.06, ["Neon"] = 88.74, ["Neon|Ride"] = 80.07, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 411.17, ["Mega|Fly"] = 525, ["Mega|Ride"] = 396.67, ["Mega|Fly|Ride"] = 444.36}},
    ["rbxassetid://121712578077668"] = {name = "Blue Whale", prices = {["default"] = 3.75, ["Fly"] = 27.48, ["Ride"] = 25.36, ["Fly|Ride"] = 65.63, ["Neon"] = 18.36, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 117.43, ["Mega"] = 102.18, ["Mega|Ride"] = 141.75, ["Mega|Fly|Ride"] = 227.07}},
    ["rbxassetid://76035105070441"] = {name = "Fairy Bat Dragon", prices = {["default"] = 951.57, ["Fly"] = 1267.47, ["Ride"] = 988.47, ["Fly|Ride"] = 1017.19, ["Neon|Ride"] = 2625, ["Neon|Fly|Ride"] = 2362.5, ["Mega|Fly|Ride"] = 8715}},
    ["rbxassetid://105346917979221"] = {name = "Aurora Fox", prices = {["default"] = 388.5, ["Fly"] = 403.49, ["Ride"] = 393.75, ["Fly|Ride"] = 433.13, ["Neon|Ride"] = 1680, ["Neon|Fly|Ride"] = 1346.07, ["Mega"] = 10577.52, ["Mega|Fly|Ride"] = 5485.51}},
    ["rbxassetid://120475294381736"] = {name = "Glormy Hound", prices = {["default"] = 93.19, ["Ride"] = 115.92, ["Fly|Ride"] = 171.22, ["Neon"] = 282.19, ["Neon|Ride"] = 328.12, ["Neon|Fly|Ride"] = 402.73, ["Mega|Fly|Ride"] = 1885.77}},
    ["rbxassetid://15570696642"] = {name = "Glacier Kitsune", prices = {["default"] = 278.92, ["Fly"] = 338, ["Ride"] = 273.38, ["Fly|Ride"] = 304.48, ["Neon|Ride"] = 1015.46, ["Neon|Fly|Ride"] = 1037.68, ["Mega"] = 10577.52, ["Mega|Fly|Ride"] = 3937.5}},
    ["rbxassetid://16548792521"] = {name = "Golden Hamster", prices = {["default"] = 21.14, ["Fly"] = 52.5, ["Ride"] = 35.44, ["Fly|Ride"] = 65.63, ["Neon"] = 157.49, ["Neon|Ride"] = 126.94, ["Neon|Fly|Ride"] = 141.75, ["Mega"] = 1411.06, ["Mega|Ride"] = 705.54, ["Mega|Fly|Ride"] = 618.87}},
    ["rbxassetid://12935498875"] = {name = "Field Mouse", prices = {["default"] = 421.45, ["Fly|Ride"] = 359.36, ["Neon"] = 1584.98, ["Neon|Ride"] = 1107.48, ["Neon|Fly|Ride"] = 2397.93, ["Mega"] = 5250}},
    ["rbxassetid://16548793509"] = {name = "Diamond Hamster", prices = {["default"] = 110.25, ["Fly"] = 126, ["Ride"] = 65.63, ["Neon"] = 422.5, ["Neon|Ride"] = 504.53, ["Neon|Fly|Ride"] = 590.63, ["Mega|Fly|Ride"] = 1397.82}},
    ["rbxassetid://78823655016197"] = {name = "Jekyll Hydra", prices = {["default"] = 1246.88, ["Ride"] = 1378.13, ["Fly|Ride"] = 1312.5, ["Neon|Fly|Ride"] = 4479.29, ["Mega"] = 50772.05, ["Mega|Fly|Ride"] = 24539.83}},
    ["rbxassetid://96735424372947"] = {name = "Glormy Dolphin", prices = {["default"] = 11.58, ["Fly"] = 49.88, ["Ride"] = 44.47, ["Fly|Ride"] = 91.9, ["Neon"] = 42.11, ["Neon|Fly"] = 157.7, ["Neon|Ride"] = 70.89, ["Neon|Fly|Ride"] = 163.96, ["Mega"] = 253.32, ["Mega|Ride"] = 273.3, ["Mega|Fly|Ride"] = 373.77}},
    ["rbxassetid://16898331554"] = {name = "Princess Capuchin Monkey", prices = {["default"] = 47.25, ["Ride"] = 84, ["Fly|Ride"] = 161.44, ["Neon"] = 304.2, ["Neon|Ride"] = 238.26, ["Neon|Fly|Ride"] = 548.99, ["Mega|Ride"] = 1389.9, ["Mega|Fly|Ride"] = 1403.17}},
    ["rbxassetid://4315743450"] = {name = "Queen Bee", prices = {["default"] = 78.85, ["Fly"] = 80.29, ["Ride"] = 65.62, ["Fly|Ride"] = 78.75, ["Neon|Ride"] = 423.11, ["Neon|Fly|Ride"] = 313.69, ["Mega|Fly|Ride"] = 1402.29}},
    ["rbxassetid://5067924789"] = {name = "Monkey King", prices = {["default"] = 1575, ["Ride"] = 1049.99, ["Fly|Ride"] = 944.99, ["Neon|Fly|Ride"] = 4199.99, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://10284283561"] = {name = "Black-Chested Pheasant", prices = {["default"] = 441.51, ["Fly"] = 842.88, ["Ride"] = 564.03, ["Fly|Ride"] = 525, ["Neon|Fly|Ride"] = 1986.47, ["Mega|Fly|Ride"] = 14143.21}},
    ["rbxassetid://15504845135"] = {name = "Candy Hare", prices = {["default"] = 119.53, ["Fly"] = 314.15, ["Ride"] = 129.93, ["Fly|Ride"] = 196.87, ["Neon"] = 479.53, ["Neon|Ride"] = 433.13, ["Neon|Fly|Ride"] = 502.69, ["Mega"] = 4231.02, ["Mega|Ride"] = 2680.36, ["Mega|Fly|Ride"] = 2111.29}},
    ["rbxassetid://11758575657"] = {name = "Lunar Moon Bear", prices = {["default"] = 8.95, ["Fly"] = 39.38, ["Ride"] = 21.14, ["Fly|Ride"] = 64.34, ["Neon"] = 75.01, ["Neon|Ride"] = 113.21, ["Neon|Fly|Ride"] = 233.63, ["Mega"] = 761.25, ["Mega|Ride"] = 631.89, ["Mega|Fly|Ride"] = 987.95}},
    ["rbxassetid://10318105392"] = {name = "Green Butterfly", prices = {["default"] = 35.38, ["Fly"] = 69.74, ["Ride"] = 48.57, ["Fly|Ride"] = 94.4, ["Neon"] = 204.75, ["Neon|Ride"] = 223.18, ["Neon|Fly|Ride"] = 209.99, ["Mega"] = 1834.16, ["Mega|Fly|Ride"] = 1049.99}},
    ["rbxassetid://84813815094145"] = {name = "Mermicorn", prices = {["default"] = 721.88, ["Ride"] = 748.13, ["Fly|Ride"] = 874.07, ["Neon"] = 3104.22, ["Neon|Ride"] = 2828.44, ["Neon|Fly|Ride"] = 2625, ["Mega|Fly|Ride"] = 23505.35}},
    ["rbxassetid://4507163112"] = {name = "Christmas Egg", prices = {["default"] = 840}},
    ["rbxassetid://14689005829"] = {name = "Blazing Lion", prices = {["default"] = 4593.75, ["Ride"] = 4396.88, ["Fly|Ride"] = 4386.87, ["Neon|Ride"] = 30316.2, ["Neon|Fly|Ride"] = 21682.84, ["Mega|Fly|Ride"] = 90262.11}},
    ["rbxassetid://123647431892215"] = {name = "Hero Gibbon", prices = {["default"] = 157.5, ["Fly"] = 169.01, ["Ride"] = 211.23, ["Fly|Ride"] = 422.5, ["Neon"] = 1689.96, ["Neon|Ride"] = 846.21, ["Neon|Fly|Ride"] = 1411.06, ["Mega"] = 5923.42, ["Mega|Fly|Ride"] = 5642.05}},
    ["rbxassetid://106457467498193"] = {name = "Scorching Kaijunior", prices = {["default"] = 59.07, ["Fly"] = 282.02, ["Ride"] = 77.44, ["Fly|Ride"] = 336, ["Neon"] = 986.52, ["Neon|Ride"] = 486.59, ["Neon|Fly|Ride"] = 987.95, ["Mega|Fly|Ride"] = 2813.63}},
    ["rbxassetid://10926054030"] = {name = "Chimera", prices = {["default"] = 12.92, ["Fly"] = 57.05, ["Ride"] = 26.25, ["Fly|Ride"] = 105, ["Neon"] = 78.75, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 181.95, ["Mega"] = 691.79, ["Mega|Ride"] = 536.29, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://9490242683"] = {name = "Golden King Penguin", prices = {["default"] = 13.09, ["Fly"] = 28.23, ["Ride"] = 26.25, ["Fly|Ride"] = 45.93, ["Neon"] = 91.88, ["Neon|Ride"] = 84.63, ["Neon|Fly|Ride"] = 177.18, ["Mega"] = 1312.5, ["Mega|Fly|Ride"] = 831.41}},
    ["rbxassetid://17119623510"] = {name = "Mushroom Friend", prices = {["default"] = 17.07, ["Fly"] = 52.5, ["Ride"] = 44.71, ["Fly|Ride"] = 65.63, ["Neon"] = 141.56, ["Neon|Ride"] = 122.72, ["Neon|Fly|Ride"] = 190.32, ["Mega|Ride"] = 564.85, ["Mega|Fly|Ride"] = 846.21}},
    ["rbxassetid://17174656536"] = {name = "Golden Tortoise Beetle", prices = {["default"] = 3.18, ["Fly"] = 78.17, ["Ride"] = 21.14, ["Fly|Ride"] = 63.38, ["Neon"] = 42.11, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 74.02, ["Mega|Ride"] = 203.1, ["Mega|Fly|Ride"] = 282.87}},
    ["rbxassetid://84310117840681"] = {name = "Super Saru", prices = {["default"] = 26.22, ["Ride"] = 57.04, ["Fly|Ride"] = 156.33, ["Neon"] = 147.88, ["Neon|Fly"] = 846.21, ["Neon|Ride"] = 183.36, ["Neon|Fly|Ride"] = 251.06, ["Mega"] = 693.9, ["Mega|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 856.79}},
    ["rbxassetid://77177643028234"] = {name = "Phantom Dragon", prices = {["default"] = 298.86, ["Fly"] = 331.66, ["Ride"] = 291.38, ["Fly|Ride"] = 322.6, ["Neon"] = 1050, ["Neon|Fly"] = 950.61, ["Neon|Ride"] = 943.69, ["Neon|Fly|Ride"] = 808.04, ["Mega"] = 6562.5, ["Mega|Fly|Ride"] = 2821.03}},
    ["rbxassetid://6245080265"] = {name = "Metal Ox", prices = {["default"] = 2.63, ["Fly"] = 20.56, ["Ride"] = 15.89, ["Fly|Ride"] = 36.75, ["Neon"] = 19.69, ["Neon|Ride"] = 28.04, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 105, ["Mega|Ride"] = 157.95, ["Mega|Fly|Ride"] = 261.19}},
    ["rbxassetid://3181728194"] = {name = "Unicorn", prices = {["default"] = 40.69, ["Fly"] = 102.37, ["Ride"] = 59.07, ["Fly|Ride"] = 118.25, ["Neon"] = 137.54, ["Neon|Fly"] = 376.61, ["Neon|Ride"] = 176.91, ["Neon|Fly|Ride"] = 245.95, ["Mega"] = 564.27, ["Mega|Ride"] = 547.31, ["Mega|Fly|Ride"] = 529.12}},
    ["rbxassetid://4708551322"] = {name = "Turtle", prices = {["default"] = 802.65, ["Fly"] = 1409.01, ["Ride"] = 758.31, ["Fly|Ride"] = 815.07, ["Neon|Ride"] = 1575, ["Neon|Fly|Ride"] = 1696.86, ["Mega|Fly|Ride"] = 3940.13}},
    ["rbxassetid://5721844281"] = {name = "T-Rex", prices = {["default"] = 31.4, ["Fly"] = 63.48, ["Ride"] = 44.09, ["Fly|Ride"] = 66.94, ["Neon|Fly"] = 470.75, ["Neon|Ride"] = 176.13, ["Neon|Fly|Ride"] = 210, ["Mega"] = 1575, ["Mega|Ride"] = 1128.64, ["Mega|Fly|Ride"] = 603.75}},
    ["rbxassetid://16127039676"] = {name = "Midnight Dragon", prices = {["default"] = 314.15, ["Fly"] = 341.25, ["Ride"] = 241.5, ["Fly|Ride"] = 288.75, ["Neon|Ride"] = 912.85, ["Neon|Fly|Ride"] = 1123.44, ["Mega|Fly|Ride"] = 4652}},
    ["rbxassetid://7734925172"] = {name = "Halloween White Ghost Dragon", prices = {["default"] = 140.12, ["Fly"] = 178.79, ["Ride"] = 131.23, ["Fly|Ride"] = 131.15, ["Neon"] = 633.74, ["Neon|Fly"] = 642.2, ["Neon|Ride"] = 527.83, ["Neon|Fly|Ride"] = 485.63, ["Mega|Fly|Ride"] = 2244.77}},
    ["rbxassetid://18508016126"] = {name = "Bush Elephant", prices = {["default"] = 619.25, ["Ride"] = 577.45, ["Fly|Ride"] = 678.57, ["Neon|Fly|Ride"] = 2001.34, ["Mega|Fly|Ride"] = 7217.44}},
    ["rbxassetid://78218981883168"] = {name = "Coconut Friend", prices = {["default"] = 21.27, ["Ride"] = 52.5, ["Fly|Ride"] = 129.49, ["Neon"] = 91.51, ["Neon|Fly"] = 282.45, ["Neon|Ride"] = 98.44, ["Neon|Fly|Ride"] = 184.07, ["Mega"] = 354.34, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://4184878050"] = {name = "Evil Unicorn", prices = {["default"] = 3992.48, ["Fly"] = 3993.15, ["Ride"] = 3450.61, ["Fly|Ride"] = 3084.38, ["Neon|Fly|Ride"] = 6452.7, ["Mega|Fly|Ride"] = 23745.75}},
    ["rbxassetid://103896000727935"] = {name = "Aestus", prices = {["default"] = 90.57, ["Fly"] = 170.63, ["Ride"] = 105, ["Fly|Ride"] = 131.25, ["Neon"] = 470.75, ["Neon|Ride"] = 446.25, ["Neon|Fly|Ride"] = 406.48, ["Mega|Fly|Ride"] = 1885.77}},
    ["rbxassetid://9922229151"] = {name = "Dragonfly", prices = {["default"] = 2.61, ["Fly"] = 21.14, ["Ride"] = 19.03, ["Fly|Ride"] = 42.26, ["Neon"] = 19.67, ["Neon|Fly"] = 42.24, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 80.4, ["Mega"] = 129.94, ["Mega|Fly"] = 452.82, ["Mega|Ride"] = 233.89, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://82820245821381"] = {name = "Temple Friend", prices = {["default"] = 3.84, ["Ride"] = 27.48, ["Fly|Ride"] = 63, ["Neon"] = 15.86, ["Neon|Fly"] = 157.5, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 266.44, ["Mega"] = 181.95, ["Mega|Ride"] = 181.95, ["Mega|Fly|Ride"] = 278.2}},
    ["rbxassetid://6404812861"] = {name = "Diamond Ladybug", prices = {["default"] = 28.53, ["Fly"] = 57.05, ["Ride"] = 42.31, ["Fly|Ride"] = 59.07, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 282.43, ["Mega|Fly|Ride"] = 1340.19}},
    ["rbxassetid://107535752953647"] = {name = "Strawberry Tortle", prices = {["default"] = 954.98, ["Ride"] = 1093.68, ["Fly|Ride"] = 1206.48, ["Neon"] = 5064.56, ["Neon|Fly|Ride"] = 4593.75}},
    ["rbxassetid://95844539868957"] = {name = "Amethyst Penguin", prices = {["default"] = 5171.23, ["Ride"] = 5881.71, ["Fly|Ride"] = 5162.17}},
    ["rbxassetid://6240249282"] = {name = "Guardian Lion", prices = {["default"] = 19.69, ["Fly"] = 33.81, ["Ride"] = 27.48, ["Fly|Ride"] = 42.26, ["Neon"] = 261.86, ["Neon|Ride"] = 105.78, ["Neon|Fly|Ride"] = 126.12, ["Mega"] = 2428.13, ["Mega|Fly|Ride"] = 564.85}},
    ["rbxassetid://11496077150"] = {name = "Ice Moth Dragon", prices = {["default"] = 20.08, ["Ride"] = 32.11, ["Fly|Ride"] = 80.07, ["Neon"] = 49.88, ["Neon|Fly"] = 141.75, ["Neon|Ride"] = 85.86, ["Neon|Fly|Ride"] = 154.88, ["Mega"] = 933.52, ["Mega|Ride"] = 354.37, ["Mega|Fly|Ride"] = 519.18}},
    ["rbxassetid://5862774166"] = {name = "Skele-Rex", prices = {["default"] = 49.88, ["Fly"] = 85.32, ["Ride"] = 54.44, ["Fly|Ride"] = 80.93, ["Neon"] = 223.49, ["Neon|Ride"] = 267.75, ["Neon|Fly|Ride"] = 275.31, ["Mega"] = 945, ["Mega|Ride"] = 1056.7, ["Mega|Fly|Ride"] = 928.39}},
    ["rbxassetid://11773429123"] = {name = "Nessie", prices = {["default"] = 221.81, ["Fly"] = 281.17, ["Ride"] = 231, ["Fly|Ride"] = 275.93, ["Neon"] = 1211.49, ["Neon|Ride"] = 976.5, ["Neon|Fly|Ride"] = 1190.4, ["Mega"] = 11157.82, ["Mega|Fly|Ride"] = 3506.46}},
    ["rbxassetid://121782270350526"] = {name = "Dark Choccybunny", prices = {["default"] = 3.84, ["Ride"] = 32.26, ["Fly|Ride"] = 105, ["Neon"] = 19.69, ["Neon|Fly"] = 70.95, ["Neon|Ride"] = 63.48, ["Neon|Fly|Ride"] = 211.56, ["Mega"] = 141.75, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 367.75}},
    ["rbxassetid://129591977577854"] = {name = "Ballet Swan", prices = {["default"] = 183.75, ["Fly"] = 211.26, ["Ride"] = 215.46, ["Fly|Ride"] = 262.5, ["Neon"] = 784.97, ["Neon|Ride"] = 744.19, ["Neon|Fly|Ride"] = 786.19, ["Mega|Fly|Ride"] = 3371.07}},
    ["rbxassetid://9669227320"] = {name = "Zodiac Minion Chick", prices = {["default"] = 3.56, ["Fly"] = 21.06, ["Ride"] = 15.74, ["Fly|Ride"] = 39.11, ["Neon"] = 18.35, ["Neon|Fly"] = 52.49, ["Neon|Ride"] = 27.15, ["Neon|Fly|Ride"] = 99.45, ["Mega"] = 131.25, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 316.28}},
    ["rbxassetid://13462536955"] = {name = "Caelum Cervi", prices = {["default"] = 196.88, ["Fly"] = 236.25, ["Ride"] = 208.69, ["Fly|Ride"] = 261.19, ["Neon|Ride"] = 1128.64, ["Neon|Fly|Ride"] = 883.96, ["Mega"] = 10577.52, ["Mega|Ride"] = 6346.52, ["Mega|Fly|Ride"] = 7660.91}},
    ["rbxassetid://10137833794"] = {name = "Green-Chested Pheasant", prices = {["default"] = 8.44, ["Fly"] = 131.25, ["Ride"] = 31.4, ["Fly|Ride"] = 65.63, ["Neon"] = 70.79, ["Neon|Fly"] = 298.94, ["Neon|Ride"] = 137.52, ["Neon|Fly|Ride"] = 272.28, ["Mega"] = 522.13, ["Mega|Ride"] = 564.85, ["Mega|Fly|Ride"] = 466.48}},
    ["rbxassetid://16994954002"] = {name = "Brachiosaurus", prices = {["default"] = 2.1, ["Ride"] = 22.23, ["Neon"] = 8.49, ["Neon|Fly"] = 66.94, ["Neon|Ride"] = 48.34, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 76.13, ["Mega|Ride"] = 115.34, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://121938982134212"] = {name = "Gecko Ducky", prices = {["default"] = 2.1, ["Neon"] = 2.63, ["Mega"] = 15.64, ["Mega|Ride"] = 155.7}},
    ["rbxassetid://17649624018"] = {name = "Kid Goat", prices = {["default"] = 6.57, ["Ride"] = 234.94, ["Fly|Ride"] = 141.52, ["Neon"] = 14.16, ["Neon|Ride"] = 65.01, ["Neon|Fly|Ride"] = 156.56, ["Mega"] = 68.16, ["Mega|Fly"] = 157147.43, ["Mega|Ride"] = 94.5}},
    ["rbxassetid://4440867127"] = {name = "Chicken", prices = {["default"] = 65.63, ["Fly"] = 102.38, ["Ride"] = 104.11, ["Fly|Ride"] = 144.38, ["Neon"] = 262.5, ["Neon|Fly"] = 359.14, ["Neon|Ride"] = 248.07, ["Neon|Fly|Ride"] = 347.82, ["Mega|Fly|Ride"] = 1133.43}},
    ["rbxassetid://5721844165"] = {name = "Tasmanian Tiger", prices = {["default"] = 2.1, ["Fly"] = 40.69, ["Ride"] = 18.38, ["Fly|Ride"] = 43.32, ["Neon"] = 10.58, ["Neon|Ride"] = 21.06, ["Neon|Fly|Ride"] = 105, ["Mega"] = 86.62, ["Mega|Ride"] = 98.34, ["Mega|Fly|Ride"] = 257.25}},
    ["rbxassetid://14146063876"] = {name = "Cockroach", prices = {["default"] = 8.39, ["Ride"] = 91.77, ["Fly|Ride"] = 196.47, ["Neon"] = 74.82, ["Neon|Ride"] = 103.69, ["Mega"] = 485.63, ["Mega|Ride"] = 634.67, ["Mega|Fly|Ride"] = 776.41}},
    ["rbxassetid://135555287601448"] = {name = "Rubber Ducky", prices = {["default"] = 2.1, ["Ride"] = 30.64, ["Neon"] = 2.1, ["Neon|Ride"] = 28.88, ["Neon|Fly|Ride"] = 55.57, ["Mega"] = 16.79, ["Mega|Ride"] = 46.5, ["Mega|Fly|Ride"] = 116.71}},
    ["rbxassetid://9664487060"] = {name = "Ant", prices = {["default"] = 2.1, ["Fly"] = 20.9, ["Ride"] = 18.95, ["Fly|Ride"] = 31.66, ["Neon"] = 2.1, ["Neon|Fly"] = 16.91, ["Neon|Ride"] = 15.8, ["Neon|Fly|Ride"] = 39.95, ["Mega"] = 15.72, ["Mega|Fly"] = 28.44, ["Mega|Ride"] = 26.25, ["Mega|Fly|Ride"] = 58.56}},
    ["rbxassetid://3293758505"] = {name = "Otter", prices = {["default"] = 2.1, ["Fly"] = 131.25, ["Ride"] = 12.64, ["Fly|Ride"] = 34.55, ["Neon"] = 3.92, ["Neon|Fly"] = 15.54, ["Neon|Ride"] = 16.94, ["Neon|Fly|Ride"] = 42.08, ["Mega"] = 42.32, ["Mega|Fly"] = 58.95, ["Mega|Ride"] = 39.29, ["Mega|Fly|Ride"] = 78.66}},
    ["rbxassetid://79698905581979"] = {name = "Ms. Muffet", prices = {["default"] = 2.1, ["Fly|Ride"] = 125.73, ["Neon"] = 2.26, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 70.89, ["Mega"] = 30.07, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 306.76}},
    ["rbxassetid://13620861015"] = {name = "Flying Fish", prices = {["default"] = 2.1, ["Fly"] = 118.02, ["Ride"] = 19.69, ["Fly|Ride"] = 104.51, ["Neon"] = 9.19, ["Neon|Fly"] = 135.03, ["Neon|Ride"] = 70.49, ["Neon|Fly|Ride"] = 86, ["Mega"] = 42.45, ["Mega|Fly"] = 72.19, ["Mega|Ride"] = 75.18, ["Mega|Fly|Ride"] = 163.96}},
    ["rbxassetid://100439668574210"] = {name = "Jiggly Jerboa", prices = {["default"] = 2.1, ["Neon"] = 3.93, ["Neon|Fly|Ride"] = 204.75, ["Mega"] = 14.91, ["Mega|Ride"] = 82.68}},
    ["rbxassetid://14815828879"] = {name = "Ghost", prices = {["default"] = 2.1, ["Fly"] = 47.16, ["Ride"] = 25.89, ["Fly|Ride"] = 47.41, ["Neon"] = 6.45, ["Neon|Fly"] = 36.88, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 78.29, ["Mega"] = 61.37, ["Mega|Fly"] = 195.66, ["Mega|Ride"] = 64.13, ["Mega|Fly|Ride"] = 99.75}},
    ["rbxassetid://140565380261180"] = {name = "Galapagos Sea Lion", prices = {["default"] = 2.1, ["Ride"] = 48.6, ["Neon"] = 2.1, ["Neon|Ride"] = 26.17, ["Neon|Fly|Ride"] = 313.48, ["Mega"] = 21.16, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://14146188240"] = {name = "Bluebottle Fly", prices = {["default"] = 3.29, ["Fly"] = 35.94, ["Ride"] = 52.5, ["Fly|Ride"] = 525, ["Neon"] = 22.23, ["Mega"] = 203.1, ["Mega|Fly"] = 314.99, ["Mega|Ride"] = 282.43}},
    ["rbxassetid://15930540035"] = {name = "Sandfish", prices = {["default"] = 2.1, ["Ride"] = 27.57, ["Neon"] = 15.86, ["Mega"] = 139.13, ["Mega|Fly|Ride"] = 110.02}},
    ["rbxassetid://74774507671765"] = {name = "Island Tarsier", prices = {["default"] = 2.1, ["Ride"] = 70.76, ["Neon"] = 6.36, ["Neon|Ride"] = 37.71, ["Neon|Fly|Ride"] = 76.18, ["Mega"] = 23.29, ["Mega|Fly"] = 79.34, ["Mega|Ride"] = 69.21, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://9678196095"] = {name = "Mouse", prices = {["default"] = 2.1, ["Fly"] = 30.35, ["Ride"] = 18.8, ["Fly|Ride"] = 30.19, ["Neon"] = 2.1, ["Neon|Fly"] = 25.78, ["Neon|Ride"] = 15.7, ["Neon|Fly|Ride"] = 41.88, ["Mega"] = 15.57, ["Mega|Fly"] = 53.62, ["Mega|Ride"] = 18.75, ["Mega|Fly|Ride"] = 56.44}},
    ["rbxassetid://100695038890951"] = {name = "Basic Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13104111122"] = {name = "Piranha", prices = {["default"] = 2.1, ["Fly"] = 72.19, ["Ride"] = 42, ["Neon"] = 26.17, ["Neon|Ride"] = 39.83, ["Mega"] = 253.87, ["Mega|Fly"] = 282.43, ["Mega|Ride"] = 351.65, ["Mega|Fly|Ride"] = 689.68}},
    ["rbxassetid://110856597065248"] = {name = "Bakeneko", prices = {["default"] = 2.1, ["Fly"] = 15.94, ["Ride"] = 41.91, ["Fly|Ride"] = 78.73, ["Neon"] = 6.57, ["Neon|Ride"] = 34.13, ["Neon|Fly|Ride"] = 158.06, ["Mega"] = 28.35, ["Mega|Ride"] = 45.94, ["Mega|Fly|Ride"] = 203.79}},
    ["rbxassetid://128979941112615"] = {name = "Dirty Ducky", prices = {["default"] = 7.12, ["Neon"] = 13.13, ["Neon|Fly|Ride"] = 141.75, ["Mega"] = 74.82, ["Mega|Ride"] = 165.02, ["Mega|Fly|Ride"] = 221.81}},
    ["rbxassetid://12479656052"] = {name = "Maleo Bird", prices = {["default"] = 3.94, ["Fly"] = 21.21, ["Ride"] = 32.81, ["Fly|Ride"] = 192.22, ["Neon"] = 116.52, ["Neon|Ride"] = 70.89, ["Neon|Fly|Ride"] = 126.94, ["Mega"] = 83.18, ["Mega|Ride"] = 85.3, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://3200646599"] = {name = "Cat", prices = {["default"] = 2.1, ["Fly"] = 13.13, ["Ride"] = 12.79, ["Fly|Ride"] = 32.63, ["Neon"] = 2.2, ["Neon|Fly"] = 15.74, ["Neon|Ride"] = 14.97, ["Neon|Fly|Ride"] = 28.58, ["Mega"] = 14.97, ["Mega|Fly"] = 40.21, ["Mega|Ride"] = 22.32, ["Mega|Fly|Ride"] = 52.34}},
    ["rbxassetid://12479810452"] = {name = "Bali Starling", prices = {["default"] = 2.1, ["Fly"] = 23.94, ["Ride"] = 19.65, ["Fly|Ride"] = 48.57, ["Neon"] = 15.61, ["Neon|Ride"] = 113.17, ["Neon|Fly|Ride"] = 75.11, ["Mega"] = 78.75, ["Mega|Fly|Ride"] = 196.77}},
    ["rbxassetid://9982819219"] = {name = "Dugong", prices = {["default"] = 5.25, ["Fly"] = 41.91, ["Ride"] = 30.59, ["Fly|Ride"] = 141.56, ["Neon"] = 70.23, ["Neon|Ride"] = 108.96, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 279.57, ["Mega|Ride"] = 276.94, ["Mega|Fly|Ride"] = 387.85}},
    ["rbxassetid://3181727229"] = {name = "Buffalo", prices = {["default"] = 2.1, ["Fly"] = 13.02, ["Ride"] = 15.81, ["Fly|Ride"] = 26.25, ["Neon"] = 3.93, ["Neon|Fly"] = 20.24, ["Neon|Ride"] = 17.07, ["Neon|Fly|Ride"] = 60.03, ["Mega"] = 35.98, ["Mega|Fly"] = 156.19, ["Mega|Ride"] = 63.66, ["Mega|Fly|Ride"] = 117.78}},
    ["rbxassetid://99694153348188"] = {name = "Urchin", prices = {["default"] = 2.63, ["Fly"] = 176.4, ["Ride"] = 31.5, ["Neon"] = 9.45, ["Neon|Fly"] = 77.53, ["Neon|Ride"] = 40.69, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 59.96, ["Mega|Fly"] = 564.85, ["Mega|Ride"] = 105}},
    ["rbxassetid://84089584046947"] = {name = "Blue Butterfly", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 9.19, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 28.58, ["Neon|Fly|Ride"] = 141.05, ["Mega"] = 32.81, ["Mega|Ride"] = 148.52, ["Mega|Fly|Ride"] = 205.09}},
    ["rbxassetid://124485808787576"] = {name = "Tegu", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Fly"] = 41.08, ["Neon|Ride"] = 18.38, ["Neon|Fly|Ride"] = 101.07, ["Mega"] = 15.1, ["Mega|Ride"] = 52.08}},
    ["rbxassetid://8938703774"] = {name = "Bullfrog", prices = {["default"] = 2.1, ["Fly"] = 88.46, ["Ride"] = 18.95, ["Fly|Ride"] = 59.07, ["Neon"] = 6.57, ["Neon|Fly"] = 46.49, ["Neon|Ride"] = 21.06, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 221.6, ["Mega|Ride"] = 95.82, ["Mega|Fly|Ride"] = 226.38}},
    ["rbxassetid://102746202827395"] = {name = "Hopbop", prices = {["default"] = 2.1, ["Ride"] = 31.39, ["Neon"] = 7.35, ["Neon|Ride"] = 63.79, ["Mega"] = 98.6, ["Mega|Ride"] = 117.88, ["Mega|Fly|Ride"] = 235.74}},
    ["rbxassetid://6498255997"] = {name = "Stingray", prices = {["default"] = 2.1, ["Fly"] = 32.45, ["Ride"] = 16.85, ["Fly|Ride"] = 141.56, ["Neon"] = 6.83, ["Neon|Fly"] = 106.98, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 48.57, ["Mega"] = 65.63, ["Mega|Ride"] = 90.46, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://13104106555"] = {name = "Mosquito", prices = {["default"] = 3.93, ["Ride"] = 82.6, ["Neon"] = 56.6, ["Mega"] = 282.43, ["Mega|Fly|Ride"] = 844.06}},
    ["rbxassetid://5721843483"] = {name = "Ground Sloth", prices = {["default"] = 2.1, ["Ride"] = 21.27, ["Fly|Ride"] = 5413.51, ["Neon"] = 14.44, ["Neon|Fly"] = 59.16, ["Neon|Ride"] = 25.26, ["Neon|Fly|Ride"] = 49.8, ["Mega"] = 190.95, ["Mega|Fly|Ride"] = 282.87}},
    ["rbxassetid://4506925908"] = {name = "Robin", prices = {["default"] = 4.5, ["Fly"] = 20.01, ["Ride"] = 20.96, ["Fly|Ride"] = 141.56, ["Neon"] = 18.38, ["Neon|Fly"] = 15.99, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 70.89, ["Mega"] = 158.67, ["Mega|Ride"] = 124.38, ["Mega|Fly|Ride"] = 209.99}},
    ["rbxassetid://10382786163"] = {name = "Sado Mole", prices = {["default"] = 3.93, ["Fly"] = 79.47, ["Fly|Ride"] = 105.93, ["Neon"] = 22.91, ["Neon|Ride"] = 157.4, ["Mega"] = 202.06, ["Mega|Ride"] = 367.05, ["Mega|Fly|Ride"] = 252.82}},
    ["rbxassetid://14471275373"] = {name = "Ash Zebra", prices = {["default"] = 9.18, ["Ride"] = 78.17, ["Mega"] = 577.5, ["Mega|Ride"] = 536.29, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://15923574361"] = {name = "Armadillo", prices = {["default"] = 3.94, ["Ride"] = 46.68, ["Neon"] = 48.4, ["Neon|Ride"] = 105, ["Mega"] = 212.62, ["Mega|Ride"] = 367.5}},
    ["rbxassetid://15921927876"] = {name = "Coyote", prices = {["default"] = 5.51, ["Ride"] = 41.3, ["Fly|Ride"] = 55.33, ["Neon"] = 49.88, ["Neon|Ride"] = 116.92, ["Neon|Fly|Ride"] = 184.07, ["Mega"] = 198.87, ["Mega|Ride"] = 168.42, ["Mega|Fly|Ride"] = 324.74}},
    ["rbxassetid://74353184935672"] = {name = "Sheepdog Ducky", prices = {["default"] = 2.1, ["Neon"] = 2.24, ["Neon|Ride"] = 92.28, ["Mega"] = 19.9, ["Mega|Ride"] = 139.13, ["Mega|Fly|Ride"] = 148.29}},
    ["rbxassetid://4748889845"] = {name = "Easter 2020 Egg", prices = {["default"] = 48.57}},
    ["rbxassetid://4752655872"] = {name = "Chick", prices = {["default"] = 4.73, ["Fly"] = 21.05, ["Ride"] = 21.14, ["Fly|Ride"] = 56.44, ["Neon"] = 49.23, ["Neon|Ride"] = 47.16, ["Neon|Fly|Ride"] = 80.07, ["Mega"] = 249.38, ["Mega|Ride"] = 351.25, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://17174085645"] = {name = "Garden Snake", prices = {["default"] = 2.1, ["Fly"] = 70.88, ["Ride"] = 18.36, ["Fly|Ride"] = 70.79, ["Neon"] = 4.19, ["Neon|Ride"] = 22.09, ["Mega"] = 66.65, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://17661844380"] = {name = "Show Pony", prices = {["default"] = 2.59, ["Ride"] = 28.53, ["Fly|Ride"] = 140.17, ["Neon"] = 5.16, ["Neon|Ride"] = 30.18, ["Neon|Fly|Ride"] = 157.95, ["Mega"] = 37.97, ["Mega|Ride"] = 78.66, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://8077196440"] = {name = "Walrus", prices = {["default"] = 2.1, ["Fly"] = 45.94, ["Ride"] = 16.68, ["Fly|Ride"] = 78.17, ["Neon"] = 16.33, ["Neon|Ride"] = 27.51, ["Neon|Fly|Ride"] = 90, ["Mega"] = 133.76, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 282.43}},
    ["rbxassetid://13104118499"] = {name = "Liger", prices = {["default"] = 3.81, ["Neon"] = 38.66, ["Neon|Ride"] = 210, ["Neon|Fly|Ride"] = 154.98, ["Mega"] = 328.13, ["Mega|Ride"] = 279.57}},
    ["rbxassetid://120937667166493"] = {name = "Aye Aye", prices = {["default"] = 2.1, ["Neon"] = 3.94, ["Neon|Fly|Ride"] = 79, ["Mega"] = 18.38, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 58.97, ["Mega|Fly|Ride"] = 126.94}},
    ["rbxassetid://3199974297"] = {name = "Cracked Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15348350458"] = {name = "Beluga Whale", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Ride"] = 18.38, ["Fly|Ride"] = 57.05, ["Neon"] = 3.94, ["Neon|Fly"] = 30.19, ["Neon|Ride"] = 27.51, ["Neon|Fly|Ride"] = 84.63, ["Mega"] = 30.19, ["Mega|Fly"] = 200.39, ["Mega|Ride"] = 57.2, ["Mega|Fly|Ride"] = 148.32}},
    ["rbxassetid://7126719464"] = {name = "Wolpertinger", prices = {["default"] = 2.1, ["Fly"] = 12.69, ["Ride"] = 20.08, ["Fly|Ride"] = 39.38, ["Neon"] = 7.65, ["Neon|Fly"] = 70.89, ["Neon|Ride"] = 23.37, ["Neon|Fly|Ride"] = 51.19, ["Mega"] = 65.63, ["Mega|Ride"] = 63, ["Mega|Fly|Ride"] = 141.75}},
    ["rbxassetid://125112456358906"] = {name = "Frankenfeline", prices = {["default"] = 2.1, ["Fly"] = 131.25, ["Ride"] = 26.24, ["Fly|Ride"] = 45.94, ["Neon"] = 3.68, ["Neon|Ride"] = 36.46, ["Neon|Fly|Ride"] = 84.63, ["Mega"] = 26.71, ["Mega|Fly"] = 99.45, ["Mega|Ride"] = 39.38, ["Mega|Fly|Ride"] = 112.87}},
    ["rbxassetid://80556114592490"] = {name = "Japanese Snow Fairy", prices = {["default"] = 2.1, ["Neon"] = 3.94, ["Neon|Ride"] = 38.07, ["Neon|Fly|Ride"] = 173.5, ["Mega"] = 19.48, ["Mega|Fly"] = 146.25, ["Mega|Ride"] = 88.87, ["Mega|Fly|Ride"] = 164.07}},
    ["rbxassetid://124671555129102"] = {name = "Ratatoskr", prices = {["default"] = 2.1, ["Fly"] = 26.17, ["Ride"] = 28.25, ["Fly|Ride"] = 77.37, ["Neon"] = 2.63, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 78.66, ["Mega"] = 17.75, ["Mega|Ride"] = 63.11, ["Mega|Fly|Ride"] = 126.26}},
    ["rbxassetid://116184296449988"] = {name = "Pinkypillar", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Mega"] = 24.34, ["Mega|Ride"] = 230.61}},
    ["rbxassetid://74353532164157"] = {name = "Red Panda Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.84, ["Neon|Ride"] = 157.98, ["Neon|Fly|Ride"] = 282.43, ["Mega"] = 25.1, ["Mega|Ride"] = 113.21}},
    ["rbxassetid://4708551264"] = {name = "Bandicoot", prices = {["default"] = 2.1, ["Fly"] = 28.88, ["Ride"] = 19.69, ["Fly|Ride"] = 69.57, ["Neon"] = 3.83, ["Neon|Fly"] = 71.91, ["Neon|Ride"] = 20.9, ["Neon|Fly|Ride"] = 99.45, ["Mega"] = 63.48, ["Mega|Ride"] = 60.32, ["Mega|Fly|Ride"] = 131.23}},
    ["rbxassetid://12480314681"] = {name = "Malaysian Tapir", prices = {["default"] = 13.12, ["Ride"] = 65.63, ["Neon"] = 91.88, ["Neon|Ride"] = 235.76, ["Mega"] = 389.48, ["Mega|Ride"] = 471.45, ["Mega|Fly|Ride"] = 705.54}},
    ["rbxassetid://17482380743"] = {name = "Classic Teapot", prices = {["default"] = 3.68, ["Fly"] = 6562.49, ["Ride"] = 68.16, ["Fly|Ride"] = 131.15, ["Neon"] = 144.38, ["Mega"] = 210.51, ["Mega|Ride"] = 351.1, ["Mega|Fly|Ride"] = 423.11}},
    ["rbxassetid://14146142724"] = {name = "Mongoose", prices = {["default"] = 7.88, ["Ride"] = 28.3, ["Fly|Ride"] = 422.45, ["Neon"] = 27.26, ["Neon|Ride"] = 84.73, ["Mega"] = 231.67, ["Mega|Ride"] = 196.87, ["Mega|Fly|Ride"] = 293.35}},
    ["rbxassetid://3181727351"] = {name = "Dog", prices = {["default"] = 2.1, ["Fly"] = 15.61, ["Ride"] = 12.64, ["Fly|Ride"] = 26.25, ["Neon"] = 2.1, ["Neon|Fly"] = 17.22, ["Neon|Ride"] = 12.71, ["Neon|Fly|Ride"] = 27.57, ["Mega"] = 19.62, ["Mega|Fly"] = 23.69, ["Mega|Ride"] = 22.32, ["Mega|Fly|Ride"] = 70.89}},
    ["rbxassetid://14267322852"] = {name = "Angelfish", prices = {["default"] = 2.1, ["Ride"] = 55.13, ["Neon"] = 11.94, ["Neon|Fly"] = 84.51, ["Neon|Ride"] = 31.84, ["Neon|Fly|Ride"] = 105, ["Mega"] = 156.56, ["Mega|Ride"] = 141.75}},
    ["rbxassetid://110130591707207"] = {name = "California Condor", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Fly"] = 21.05, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 70.48, ["Mega"] = 15.65, ["Mega|Fly"] = 78.29, ["Mega|Ride"] = 28.48, ["Mega|Fly|Ride"] = 103.58}},
    ["rbxassetid://123567499475377"] = {name = "Forest Sprite", prices = {["default"] = 2.1, ["Neon"] = 3.66, ["Mega"] = 18.95, ["Mega|Ride"] = 99.45, ["Mega|Fly|Ride"] = 210.51}},
    ["rbxassetid://8663441035"] = {name = "Lunar White Tiger", prices = {["default"] = 2.1, ["Fly"] = 21, ["Ride"] = 19.69, ["Fly|Ride"] = 63.38, ["Neon"] = 12.7, ["Neon|Fly"] = 70.79, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 98.98, ["Mega"] = 143.21, ["Mega|Ride"] = 200.99, ["Mega|Fly|Ride"] = 254.35}},
    ["rbxassetid://16000498338"] = {name = "Groundhog", prices = {["default"] = 210.2, ["Ride"] = 196.88, ["Fly|Ride"] = 316.84, ["Neon"] = 1541.07, ["Neon|Ride"] = 937.79, ["Neon|Fly|Ride"] = 917.09, ["Mega"] = 8462.03, ["Mega|Fly|Ride"] = 3675}},
    ["rbxassetid://73268582142443"] = {name = "Kelp Raider", prices = {["default"] = 2.1, ["Neon"] = 6.57, ["Neon|Fly"] = 56.6, ["Neon|Ride"] = 68.25, ["Mega"] = 65.42, ["Mega|Ride"] = 184.07, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://16369178617"] = {name = "Ornate Horned Frog", prices = {["default"] = 5.04, ["Fly"] = 103.68, ["Ride"] = 24.3, ["Fly|Ride"] = 141.56, ["Neon"] = 19.69, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 148.1, ["Mega"] = 464.4, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 629.39}},
    ["rbxassetid://6245080170"] = {name = "Lunar Ox", prices = {["default"] = 2.1, ["Fly"] = 131.25, ["Ride"] = 15.81, ["Fly|Ride"] = 33.8, ["Neon"] = 5.92, ["Neon|Fly"] = 43.32, ["Neon|Ride"] = 28.88, ["Neon|Fly|Ride"] = 45.93, ["Mega"] = 65.63, ["Mega|Fly"] = 94.31, ["Mega|Ride"] = 59.7, ["Mega|Fly|Ride"] = 104.73}},
    ["rbxassetid://92652981666929"] = {name = "Starmite", prices = {["default"] = 2.1, ["Fly"] = 22.32, ["Ride"] = 24.94, ["Fly|Ride"] = 52.5, ["Neon"] = 11.75, ["Neon|Fly"] = 84.51, ["Neon|Ride"] = 80.96, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 119.54, ["Mega|Ride"] = 123.38}},
    ["rbxassetid://9482496753"] = {name = "King Penguin", prices = {["default"] = 3.94, ["Fly"] = 18.38, ["Ride"] = 17.07, ["Fly|Ride"] = 34.13, ["Neon"] = 27.45, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 57.14, ["Mega"] = 160.13, ["Mega|Ride"] = 281.38, ["Mega|Fly|Ride"] = 251.76}},
    ["rbxassetid://10489161125"] = {name = "Tanuki", prices = {["default"] = 4.44, ["Fly"] = 28.53, ["Ride"] = 39.38, ["Fly|Ride"] = 247.07, ["Neon"] = 36.86, ["Neon|Ride"] = 137.45, ["Neon|Fly|Ride"] = 628.32, ["Mega"] = 282.43, ["Mega|Ride"] = 294.07, ["Mega|Fly|Ride"] = 398.35}},
    ["rbxassetid://7126720060"] = {name = "Wyvern", prices = {["default"] = 2.63, ["Fly"] = 19.03, ["Ride"] = 15.75, ["Fly|Ride"] = 35.79, ["Neon"] = 19.69, ["Neon|Fly"] = 83.58, ["Neon|Ride"] = 33.53, ["Neon|Fly|Ride"] = 68.16, ["Mega|Fly"] = 372.35, ["Mega|Ride"] = 281.51, ["Mega|Fly|Ride"] = 188.97}},
    ["rbxassetid://4506925800"] = {name = "Swan", prices = {["default"] = 64.93, ["Fly"] = 105, ["Ride"] = 85.32, ["Fly|Ride"] = 151.35, ["Neon"] = 395.05, ["Neon|Fly"] = 404.92, ["Neon|Ride"] = 378, ["Neon|Fly|Ride"] = 464.24, ["Mega|Fly|Ride"] = 1496.25}},
    ["rbxassetid://13621428133"] = {name = "Tortuga de la Isla", prices = {["default"] = 196.88, ["Fly"] = 322.17, ["Ride"] = 223.13, ["Fly|Ride"] = 234.94, ["Neon|Ride"] = 987.95, ["Neon|Fly|Ride"] = 1099.02, ["Mega"] = 10577.52, ["Mega|Fly|Ride"] = 4226.79}},
    ["rbxassetid://6684832189"] = {name = "Lamb", prices = {["default"] = 68.25, ["Fly"] = 148.25, ["Ride"] = 86.37, ["Fly|Ride"] = 103.2, ["Neon"] = 379.25, ["Neon|Ride"] = 314.99, ["Neon|Fly|Ride"] = 351.65, ["Mega|Fly|Ride"] = 1228.5}},
    ["rbxassetid://122365328950491"] = {name = "Blossom Snake", prices = {["default"] = 4.93, ["Ride"] = 33.8, ["Fly|Ride"] = 84.51, ["Neon"] = 22.3, ["Neon|Ride"] = 79, ["Neon|Fly|Ride"] = 141.47, ["Mega"] = 591.3, ["Mega|Ride"] = 417.23, ["Mega|Fly|Ride"] = 492.85}},
    ["rbxassetid://14360919997"] = {name = "Toasty Red Panda", prices = {["default"] = 11.29, ["Fly"] = 68.14, ["Ride"] = 28.86, ["Fly|Ride"] = 78.75, ["Neon"] = 64.97, ["Neon|Ride"] = 140.44, ["Neon|Fly|Ride"] = 211.56, ["Mega"] = 334.69, ["Mega|Ride"] = 393.5, ["Mega|Fly|Ride"] = 421}},
    ["rbxassetid://3181727278"] = {name = "Rabbit", prices = {["default"] = 2.1, ["Fly"] = 19.03, ["Ride"] = 20.83, ["Fly|Ride"] = 48.6, ["Neon"] = 4.92, ["Neon|Fly"] = 115.5, ["Neon|Ride"] = 27.51, ["Neon|Fly|Ride"] = 49.88, ["Mega"] = 69.83, ["Mega|Fly"] = 209.81, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 197.07}},
    ["rbxassetid://14782579567"] = {name = "Nightmare Owl", prices = {["default"] = 6.55, ["Fly"] = 68.49, ["Ride"] = 28.44, ["Fly|Ride"] = 131.25, ["Neon"] = 23.83, ["Neon|Ride"] = 141.75, ["Neon|Fly|Ride"] = 134.93, ["Mega"] = 790.16, ["Mega|Ride"] = 497.44, ["Mega|Fly|Ride"] = 564.85}},
    ["rbxassetid://6498256342"] = {name = "Narwhal", prices = {["default"] = 2.1, ["Fly"] = 18.17, ["Ride"] = 16.86, ["Fly|Ride"] = 42, ["Neon"] = 18.38, ["Neon|Fly"] = 131.17, ["Neon|Ride"] = 28.44, ["Neon|Fly|Ride"] = 99.45, ["Mega"] = 131.25, ["Mega|Ride"] = 141.75, ["Mega|Fly|Ride"] = 175.88}},
    ["rbxassetid://9227407648"] = {name = "Ibex", prices = {["default"] = 3.67, ["Ride"] = 21.14, ["Fly|Ride"] = 328.13, ["Neon"] = 23.63, ["Neon|Ride"] = 70.89, ["Neon|Fly|Ride"] = 235.74, ["Mega"] = 211.56, ["Mega|Ride"] = 157.95, ["Mega|Fly|Ride"] = 244.36}},
    ["rbxassetid://16440727263"] = {name = "Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 33.81, ["Neon"] = 2.1, ["Neon|Ride"] = 18.38, ["Neon|Fly|Ride"] = 44.81, ["Mega"] = 15.75, ["Mega|Ride"] = 50.55}},
    ["rbxassetid://10318106327"] = {name = "Yellow Butterfly", prices = {["default"] = 2.1, ["Fly"] = 45.93, ["Ride"] = 20.89, ["Fly|Ride"] = 39.38, ["Neon"] = 13.13, ["Neon|Fly"] = 105.65, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 49.88, ["Mega"] = 108.93, ["Mega|Ride"] = 96.49, ["Mega|Fly|Ride"] = 193.31}},
    ["rbxassetid://13894169749"] = {name = "Black Kite", prices = {["default"] = 3.75, ["Ride"] = 17.75, ["Fly|Ride"] = 39.29, ["Neon"] = 63.56, ["Neon|Fly"] = 141.56, ["Neon|Ride"] = 47.25, ["Neon|Fly|Ride"] = 63, ["Mega"] = 113.21, ["Mega|Ride"] = 205.09, ["Mega|Fly|Ride"] = 273}},
    ["rbxassetid://4506925595"] = {name = "Polar Bear", prices = {["default"] = 131.25, ["Fly"] = 231.33, ["Ride"] = 201.49, ["Fly|Ride"] = 246.84, ["Neon"] = 594.51, ["Neon|Ride"] = 498.75, ["Neon|Fly|Ride"] = 524.92, ["Mega|Ride"] = 3478.13, ["Mega|Fly|Ride"] = 2081.37}},
    ["rbxassetid://14639006189"] = {name = "Canada Goose", prices = {["default"] = 6.4, ["Ride"] = 30.19, ["Fly|Ride"] = 205.97, ["Neon"] = 43.32, ["Neon|Ride"] = 81.29, ["Neon|Fly|Ride"] = 129.94, ["Mega"] = 294.5, ["Mega|Ride"] = 282.43, ["Mega|Fly|Ride"] = 423.11}},
    ["rbxassetid://5721844402"] = {name = "Triceratops", prices = {["default"] = 2.1, ["Fly"] = 31.78, ["Ride"] = 27.39, ["Fly|Ride"] = 70.76, ["Neon"] = 26.25, ["Neon|Ride"] = 42.32, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 141.75, ["Mega|Ride"] = 282.43, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://83805820117149"] = {name = "Golden Jaguar", prices = {["default"] = 22.3, ["Fly"] = 59.07, ["Ride"] = 85.32, ["Fly|Ride"] = 178.5, ["Neon"] = 106.2, ["Neon|Ride"] = 126.94, ["Neon|Fly|Ride"] = 282.19, ["Mega"] = 419.88, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 633.61}},
    ["rbxassetid://13936754497"] = {name = "Pinocchio", prices = {["default"] = 3.93}},
    ["rbxassetid://17059776562"] = {name = "Ankylosaurus", prices = {["default"] = 6.27, ["Ride"] = 21.14, ["Neon"] = 68.25, ["Neon|Ride"] = 162.91, ["Neon|Fly|Ride"] = 634.67, ["Mega"] = 283.5, ["Mega|Ride"] = 308.44, ["Mega|Fly|Ride"] = 550.05}},
    ["rbxassetid://3181727813"] = {name = "Horse", prices = {["default"] = 23.25, ["Fly"] = 26.24, ["Ride"] = 28.53, ["Fly|Ride"] = 49.87, ["Neon|Fly"] = 101818.18, ["Neon|Ride"] = 175.87, ["Neon|Fly|Ride"] = 156.19, ["Mega"] = 2115.51, ["Mega|Ride"] = 574, ["Mega|Fly|Ride"] = 564.85}},
    ["rbxassetid://101098195340953"] = {name = "Mexican Wolf", prices = {["default"] = 2.1, ["Fly"] = 31.7, ["Ride"] = 32.82, ["Fly|Ride"] = 78.75, ["Neon"] = 3.94, ["Neon|Ride"] = 28.53, ["Neon|Fly|Ride"] = 70.48, ["Mega"] = 31.84, ["Mega|Ride"] = 73.48, ["Mega|Fly|Ride"] = 166.09}},
    ["rbxassetid://13894408663"] = {name = "Seagull", prices = {["default"] = 4.24, ["Fly"] = 26.25, ["Ride"] = 20.9, ["Fly|Ride"] = 86.62, ["Neon"] = 30.6, ["Neon|Ride"] = 99.45, ["Mega"] = 265.13, ["Mega|Fly"] = 393.67, ["Mega|Ride"] = 203.44, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://6998403532"] = {name = "Sasquatch", prices = {["default"] = 2.63, ["Fly"] = 45.76, ["Ride"] = 15.74, ["Fly|Ride"] = 56.48, ["Neon"] = 14.44, ["Neon|Ride"] = 27.3, ["Neon|Fly|Ride"] = 52.41, ["Mega"] = 136.43, ["Mega|Ride"] = 124.1, ["Mega|Fly|Ride"] = 252.82}},
    ["rbxassetid://108348392849720"] = {name = "Water Opossum", prices = {["default"] = 2.1, ["Ride"] = 23.63, ["Neon"] = 3.93, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 27.57, ["Mega"] = 33.87, ["Mega|Ride"] = 63.75, ["Mega|Fly|Ride"] = 205.06}},
    ["rbxassetid://11758575705"] = {name = "Moon Rabbit", prices = {["default"] = 31.5, ["Fly"] = 70.79, ["Ride"] = 69.57, ["Fly|Ride"] = 525, ["Neon"] = 195.34, ["Neon|Ride"] = 313.57, ["Neon|Fly|Ride"] = 275.63, ["Mega"] = 833.74, ["Mega|Ride"] = 774.38, ["Mega|Fly|Ride"] = 860.24}},
    ["rbxassetid://15922874831"] = {name = "Roadrunner", prices = {["default"] = 3.7, ["Ride"] = 70.76, ["Fly|Ride"] = 65.63, ["Neon"] = 69.55, ["Neon|Ride"] = 78.29, ["Neon|Fly|Ride"] = 211.56, ["Mega|Ride"] = 511.88, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://6060988175"] = {name = "Snowman", prices = {["default"] = 16.7, ["Fly"] = 131.06, ["Ride"] = 48.42, ["Fly|Ride"] = 196.88, ["Neon"] = 75.9, ["Neon|Fly"] = 211.26, ["Neon|Ride"] = 84.69, ["Neon|Fly|Ride"] = 193.58, ["Mega"] = 429.19, ["Mega|Ride"] = 528.89, ["Mega|Fly|Ride"] = 473.2}},
    ["rbxassetid://12720029414"] = {name = "Wood Pigeon", prices = {["default"] = 47.24, ["Fly"] = 141.56, ["Ride"] = 52.5, ["Fly|Ride"] = 262.44, ["Neon"] = 208.69, ["Neon|Ride"] = 393.75, ["Mega|Ride"] = 1968.75, ["Mega|Fly|Ride"] = 2262.53}},
    ["rbxassetid://136340738568203"] = {name = "Mr Whiskerpips", prices = {["default"] = 33.03, ["Fly"] = 131.25, ["Ride"] = 59.7, ["Fly|Ride"] = 141.52, ["Neon"] = 196.88, ["Neon|Ride"] = 115.54, ["Neon|Fly|Ride"] = 846.21, ["Mega"] = 523.61, ["Mega|Ride"] = 353.3, ["Mega|Fly|Ride"] = 409.37}},
    ["rbxassetid://127204329704553"] = {name = "German Shepherd", prices = {["default"] = 74.76, ["Fly"] = 145.69, ["Ride"] = 98.44, ["Fly|Ride"] = 239.99, ["Neon"] = 202.92, ["Neon|Ride"] = 228.38, ["Neon|Fly|Ride"] = 314.7, ["Mega"] = 938.44, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 876.85}},
    ["rbxassetid://99868640713300"] = {name = "Puptune", prices = {["default"] = 32.82, ["Ride"] = 52.5, ["Fly|Ride"] = 162.75, ["Neon"] = 72.19, ["Neon|Ride"] = 120.58, ["Neon|Fly|Ride"] = 252.68, ["Mega"] = 465.56, ["Mega|Ride"] = 310.72, ["Mega|Fly|Ride"] = 406.64}},
    ["rbxassetid://9993276067"] = {name = "2022 Uplift Butterfly", prices = {["default"] = 13.13, ["Fly"] = 69.5, ["Ride"] = 21.14, ["Neon"] = 81.54, ["Neon|Ride"] = 194.24, ["Neon|Fly|Ride"] = 99.45, ["Mega"] = 334.74, ["Mega|Ride"] = 1057.76, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://136574776317301"] = {name = "Sweetheart Rat", prices = {["default"] = 26.17, ["Ride"] = 73.79, ["Fly|Ride"] = 211.26, ["Neon"] = 77.59, ["Neon|Ride"] = 133.88, ["Neon|Fly|Ride"] = 129.94, ["Mega"] = 423.11, ["Mega|Ride"] = 412.13, ["Mega|Fly|Ride"] = 692.35}},
    ["rbxassetid://17649489402"] = {name = "Cow Calf", prices = {["default"] = 9.75, ["Ride"] = 34.13, ["Fly|Ride"] = 139.44, ["Neon"] = 53.89, ["Neon|Ride"] = 91.72, ["Mega"] = 312.05, ["Mega|Ride"] = 290.9, ["Mega|Fly|Ride"] = 377.07}},
    ["rbxassetid://77869404304609"] = {name = "Budgie Witch", prices = {["default"] = 2.1, ["Neon"] = 2.37, ["Neon|Fly"] = 42.26, ["Neon|Ride"] = 56.35, ["Neon|Fly|Ride"] = 92.05, ["Mega"] = 18.38, ["Mega|Fly"] = 141.75, ["Mega|Ride"] = 70.89, ["Mega|Fly|Ride"] = 169.25}},
    ["rbxassetid://111676861947081"] = {name = "The Black Dog", prices = {["default"] = 3.93, ["Ride"] = 209.9, ["Fly|Ride"] = 425.25, ["Neon"] = 12.16, ["Neon|Ride"] = 83.83, ["Mega"] = 121.28, ["Mega|Ride"] = 209.51, ["Mega|Fly|Ride"] = 447.88}},
    ["rbxassetid://13104122472"] = {name = "Borhyaena Gigantica", prices = {["default"] = 2.63, ["Ride"] = 57.04, ["Neon"] = 13.13, ["Neon|Ride"] = 105.78, ["Mega"] = 181.79}},
    ["rbxassetid://105232492496005"] = {name = "Firefighter Gibbon", prices = {["default"] = 5.18, ["Ride"] = 31.44, ["Fly|Ride"] = 116.52, ["Neon"] = 28.53, ["Neon|Ride"] = 82.95, ["Neon|Fly|Ride"] = 281.38, ["Mega"] = 123.38, ["Mega|Ride"] = 152.97, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://3409443514"] = {name = "Elephant", prices = {["default"] = 472.4, ["Ride"] = 522.08, ["Fly|Ride"] = 589.32, ["Neon|Ride"] = 1687.12, ["Neon|Fly|Ride"] = 1443.75, ["Mega|Fly|Ride"] = 5512.5}},
    ["rbxassetid://10137833682"] = {name = "Brown-Chested Pheasant", prices = {["default"] = 7.88, ["Fly"] = 57.05, ["Ride"] = 25.18, ["Fly|Ride"] = 57.04, ["Neon"] = 42.26, ["Neon|Ride"] = 77.84, ["Neon|Fly|Ride"] = 174.44, ["Mega"] = 240.12, ["Mega|Ride"] = 275.03, ["Mega|Fly|Ride"] = 367.05}},
    ["rbxassetid://12490691849"] = {name = "Gecko", prices = {["default"] = 11.69, ["Fly"] = 39.38, ["Ride"] = 28.44, ["Fly|Ride"] = 84.5, ["Neon"] = 55.13, ["Neon|Fly"] = 315, ["Neon|Ride"] = 64.32, ["Mega"] = 228.5, ["Mega|Ride"] = 206.28, ["Mega|Fly|Ride"] = 282.43}},
    ["rbxassetid://9913459163"] = {name = "Trapdoor Snail", prices = {["default"] = 4.25, ["Fly"] = 28.53, ["Ride"] = 22.53, ["Fly|Ride"] = 141.56, ["Neon"] = 36.99, ["Neon|Ride"] = 196.87, ["Mega"] = 223.13, ["Mega|Ride"] = 354.38, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://124413732651376"] = {name = "Gumball Caterpillar", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Ride"] = 27.12, ["Fly|Ride"] = 941.48, ["Neon"] = 10.4, ["Neon|Fly"] = 70.79, ["Neon|Ride"] = 34.13, ["Neon|Fly|Ride"] = 120.39, ["Mega"] = 81.38, ["Mega|Ride"] = 95.82, ["Mega|Fly|Ride"] = 165.02}},
    ["rbxassetid://96107383056013"] = {name = "Gummy Guana", prices = {["default"] = 2.1, ["Fly"] = 70.79, ["Ride"] = 70.46, ["Neon"] = 3.84, ["Neon|Ride"] = 27.51, ["Neon|Fly|Ride"] = 157.95, ["Mega"] = 26.64, ["Mega|Ride"] = 107.27, ["Mega|Fly|Ride"] = 211.56}},
    ["rbxassetid://3261465951"] = {name = "Blue Egg", prices = {["default"] = 1394.22}},
    ["rbxassetid://11245006051"] = {name = "Therapy Dog", prices = {["default"] = 9.19, ["Ride"] = 51.61, ["Neon"] = 59.07, ["Neon|Fly"] = 141.56, ["Neon|Ride"] = 94.32, ["Mega"] = 649.47, ["Mega|Ride"] = 845.16, ["Mega|Fly|Ride"] = 673}},
    ["rbxassetid://76323474173289"] = {name = "Kelp Crewmate", prices = {["default"] = 2.1, ["Ride"] = 38.07, ["Neon"] = 3.8, ["Neon|Ride"] = 42.14, ["Mega"] = 141.75, ["Mega|Ride"] = 136.71, ["Mega|Fly|Ride"] = 235.74}},
    ["rbxassetid://14978701264"] = {name = "Scarecrow Horse", prices = {["default"] = 2.1, ["Fly"] = 42.26, ["Ride"] = 20.01, ["Fly|Ride"] = 525, ["Neon"] = 11.08, ["Neon|Ride"] = 63.48, ["Neon|Fly|Ride"] = 128.63, ["Mega"] = 183.74, ["Mega|Ride"] = 152.25, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://3409443801"] = {name = "Lion", prices = {["default"] = 341.24, ["Ride"] = 422.44, ["Fly|Ride"] = 458.97, ["Neon"] = 1372.04, ["Neon|Ride"] = 1299.38, ["Neon|Fly|Ride"] = 1681.84, ["Mega|Fly|Ride"] = 6562.5}},
    ["rbxassetid://13979014954"] = {name = "Fossa", prices = {["default"] = 8.45, ["Fly"] = 196.88, ["Ride"] = 72.19, ["Neon"] = 86.63, ["Neon|Ride"] = 131.25, ["Mega"] = 376.35, ["Mega|Fly"] = 317.34, ["Mega|Ride"] = 447.88, ["Mega|Fly|Ride"] = 423.11}},
    ["rbxassetid://137886461285917"] = {name = "Angus Cow", prices = {["default"] = 2.5, ["Neon"] = 4.47, ["Neon|Ride"] = 39.81, ["Neon|Fly|Ride"] = 103.28, ["Mega"] = 38.75, ["Mega|Fly"] = 189, ["Mega|Ride"] = 59.07, ["Mega|Fly|Ride"] = 184.75}},
    ["rbxassetid://128343324254978"] = {name = "Blue Cat", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 2.52, ["Neon|Ride"] = 98.28, ["Neon|Fly|Ride"] = 268.68, ["Mega"] = 21, ["Mega|Fly|Ride"] = 192.94}},
    ["rbxassetid://79274485636628"] = {name = "Indian Flying Fox", prices = {["default"] = 9.19, ["Fly"] = 56.27, ["Ride"] = 30.19, ["Fly|Ride"] = 178.5, ["Neon"] = 83.46, ["Neon|Ride"] = 101.07, ["Neon|Fly|Ride"] = 367.5, ["Mega"] = 328.13, ["Mega|Ride"] = 423.11, ["Mega|Fly|Ride"] = 372.75}},
    ["rbxassetid://96039704958671"] = {name = "Singularity Pisces", prices = {["default"] = 7.93, ["Ride"] = 109.85, ["Neon"] = 91.81, ["Neon|Ride"] = 141.75, ["Neon|Fly|Ride"] = 838.69, ["Mega"] = 629.39, ["Mega|Ride"] = 562.74, ["Mega|Fly|Ride"] = 1082.18}},
    ["rbxassetid://12489494348"] = {name = "Komodo Dragon", prices = {["default"] = 5.25, ["Ride"] = 26.25, ["Fly|Ride"] = 99.29, ["Neon"] = 141.09, ["Neon|Ride"] = 200.82, ["Mega"] = 582.75, ["Mega|Ride"] = 328.02, ["Mega|Fly|Ride"] = 1246.88}},
    ["rbxassetid://14360919129"] = {name = "Flaming Zebra", prices = {["default"] = 15.1, ["Ride"] = 43.32, ["Fly|Ride"] = 141.18, ["Neon"] = 110.57, ["Neon|Ride"] = 156.13, ["Neon|Fly|Ride"] = 786.24, ["Mega"] = 523.61, ["Mega|Ride"] = 564.85, ["Mega|Fly|Ride"] = 447.88}},
    ["rbxassetid://108242367048842"] = {name = "Honey Badger", prices = {["default"] = 368.95, ["Ride"] = 367.5, ["Fly|Ride"] = 522.84, ["Neon"] = 1267.47, ["Neon|Ride"] = 1267.2, ["Neon|Fly|Ride"] = 1269.32, ["Mega|Ride"] = 3793.11, ["Mega|Fly|Ride"] = 3193}},
    ["rbxassetid://11119262646"] = {name = "Evil Chickatrice", prices = {["default"] = 4.99, ["Fly"] = 25.36, ["Ride"] = 30.64, ["Fly|Ride"] = 83.56, ["Neon"] = 38.06, ["Neon|Ride"] = 134.39, ["Neon|Fly|Ride"] = 84.63, ["Mega"] = 393.75, ["Mega|Ride"] = 535.5, ["Mega|Fly|Ride"] = 541.58}},
    ["rbxassetid://120631772928905"] = {name = "Subzero Scorpion", prices = {["default"] = 19.03, ["Ride"] = 116.47, ["Neon"] = 42.26, ["Mega"] = 1269.32, ["Mega|Fly|Ride"] = 1692.42}},
    ["rbxassetid://70394243440806"] = {name = "Ghostly Cat", prices = {["default"] = 14.43, ["Ride"] = 55.82, ["Fly|Ride"] = 162.67, ["Neon"] = 40.69, ["Neon|Ride"] = 108.96, ["Neon|Fly|Ride"] = 333.21, ["Mega"] = 196.14, ["Mega|Ride"] = 208.73, ["Mega|Fly|Ride"] = 320.25}},
    ["rbxassetid://108186720416551"] = {name = "Storm Condor", prices = {["default"] = 2.51, ["Ride"] = 42, ["Fly|Ride"] = 110.59, ["Neon"] = 14.43, ["Neon|Ride"] = 45.5, ["Mega"] = 36.83, ["Mega|Ride"] = 78.74, ["Mega|Fly|Ride"] = 235.74}},
    ["rbxassetid://11181152874"] = {name = "Mule", prices = {["default"] = 37.79, ["Fly"] = 63.55, ["Ride"] = 79.93, ["Neon"] = 274.36, ["Neon|Ride"] = 244.39, ["Neon|Fly|Ride"] = 409.37, ["Mega"] = 1055.65, ["Mega|Ride"] = 1124.41, ["Mega|Fly|Ride"] = 1093.29}},
    ["rbxassetid://94781392732758"] = {name = "Onza", prices = {["default"] = 3.29, ["Fly"] = 588.28, ["Ride"] = 30.59, ["Fly|Ride"] = 63.56, ["Neon"] = 11.82, ["Neon|Fly"] = 156.96, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 124.83, ["Mega"] = 67.72, ["Mega|Ride"] = 97.59, ["Mega|Fly|Ride"] = 176.66}},
    ["rbxassetid://102763887893057"] = {name = "Cherub Chipmunk", prices = {["default"] = 2.1, ["Fly"] = 28.53, ["Ride"] = 28.53, ["Fly|Ride"] = 84.51, ["Neon"] = 5.99, ["Neon|Fly"] = 70.79, ["Neon|Ride"] = 35.32, ["Neon|Fly|Ride"] = 140.18, ["Mega"] = 41.27, ["Mega|Fly"] = 92.05, ["Mega|Ride"] = 70.56, ["Mega|Fly|Ride"] = 171.71}},
    ["rbxassetid://104845330408668"] = {name = "Icy Porcupine", prices = {["default"] = 3.83, ["Ride"] = 57.75, ["Fly|Ride"] = 262.5, ["Neon"] = 21, ["Neon|Ride"] = 157.98, ["Neon|Fly|Ride"] = 200.41, ["Mega"] = 105, ["Mega|Ride"] = 190.41, ["Mega|Fly|Ride"] = 562.74}},
    ["rbxassetid://12597275903"] = {name = "White Sand Dollar", prices = {["default"] = 92.85, ["Ride"] = 101.07, ["Fly|Ride"] = 201.75, ["Neon"] = 352.79, ["Neon|Ride"] = 582.75, ["Neon|Fly|Ride"] = 627.38, ["Mega|Fly|Ride"] = 1021.85}},
    ["rbxassetid://9901393350"] = {name = "Irish Water Spaniel", prices = {["default"] = 237.04, ["Ride"] = 270.38, ["Fly|Ride"] = 311.56, ["Neon"] = 1056.23, ["Neon|Ride"] = 918.75, ["Neon|Fly|Ride"] = 1269.32, ["Mega"] = 7052.04, ["Mega|Fly|Ride"] = 4231.02}},
    ["rbxassetid://128640048014369"] = {name = "River Otter", prices = {["default"] = 4.55, ["Neon"] = 36.91, ["Mega"] = 91.88, ["Mega|Ride"] = 166.69, ["Mega|Fly|Ride"] = 423.11}},
    ["rbxassetid://138984599254588"] = {name = "Tree Sasquatch", prices = {["default"] = 10.4, ["Ride"] = 33.43, ["Fly|Ride"] = 210.17, ["Neon"] = 26.23, ["Mega"] = 94.11, ["Mega|Ride"] = 126.94, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://15870220155"] = {name = "Vulture", prices = {["default"] = 3.83, ["Fly"] = 155.56, ["Ride"] = 27.57, ["Neon"] = 39.38, ["Mega"] = 508.6, ["Mega|Ride"] = 337.84, ["Mega|Fly|Ride"] = 393.67}},
    ["rbxassetid://7734902490"] = {name = "Halloween Black Mummy Cat", prices = {["default"] = 2.1, ["Fly"] = 28.88, ["Ride"] = 20.98, ["Fly|Ride"] = 49.87, ["Neon"] = 6.3, ["Neon|Ride"] = 30.7, ["Neon|Fly|Ride"] = 90.2, ["Mega"] = 32.81, ["Mega|Ride"] = 73.5, ["Mega|Fly|Ride"] = 206.07}},
    ["rbxassetid://116677376014234"] = {name = "Sunflower Friend", prices = {["default"] = 2.63, ["Ride"] = 36.71, ["Fly|Ride"] = 282.02, ["Neon"] = 3.94, ["Mega"] = 52.5, ["Mega|Fly"] = 141.75, ["Mega|Ride"] = 206.28, ["Mega|Fly|Ride"] = 282.43}},
    ["rbxassetid://13186022212"] = {name = "Grinmoire", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Ride"] = 18.36, ["Fly|Ride"] = 41.94, ["Neon"] = 6.35, ["Neon|Fly"] = 47.16, ["Neon|Ride"] = 27.51, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 39.38, ["Mega|Ride"] = 95.82, ["Mega|Fly|Ride"] = 141.44}},
    ["rbxassetid://11119263014"] = {name = "Chickatrice", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 24.94, ["Fly|Ride"] = 63.39, ["Neon"] = 8.97, ["Neon|Fly"] = 47.09, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 69.83, ["Mega"] = 170.63, ["Mega|Ride"] = 200.99, ["Mega|Fly|Ride"] = 435.75}},
    ["rbxassetid://13104110160"] = {name = "Blue Ringed Octopus", prices = {["default"] = 35.44, ["Fly"] = 42.26, ["Ride"] = 42.26, ["Fly|Ride"] = 83.65, ["Neon"] = 185.33, ["Neon|Ride"] = 282.43, ["Mega"] = 380.63, ["Mega|Fly"] = 446.25, ["Mega|Ride"] = 435.81, ["Mega|Fly|Ride"] = 643.13}},
    ["rbxassetid://16088265753"] = {name = "Flaming Fox", prices = {["default"] = 78.75, ["Ride"] = 98.68, ["Fly|Ride"] = 131.25, ["Neon"] = 366.19, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 471.19, ["Mega|Ride"] = 3241.88, ["Mega|Fly|Ride"] = 1501.36}},
    ["rbxassetid://84105347355723"] = {name = "Gibbon", prices = {["default"] = 2.1, ["Ride"] = 17.07, ["Fly|Ride"] = 131.25, ["Neon"] = 4.23, ["Neon|Fly|Ride"] = 141.75, ["Mega"] = 56.35, ["Mega|Ride"] = 78.98}},
    ["rbxassetid://9543194411"] = {name = "Swordfish", prices = {["default"] = 2.1, ["Fly"] = 16.77, ["Ride"] = 18.96, ["Fly|Ride"] = 30.15, ["Neon"] = 4.2, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 24.92, ["Neon|Fly|Ride"] = 68.16, ["Mega"] = 32.73, ["Mega|Fly"] = 131.21, ["Mega|Ride"] = 49.88, ["Mega|Fly|Ride"] = 124.69}},
    ["rbxassetid://11706157391"] = {name = "Steppe Lion", prices = {["default"] = 11.64, ["Ride"] = 51.19, ["Neon"] = 122.54, ["Neon|Ride"] = 157.98, ["Neon|Fly|Ride"] = 156.56, ["Mega"] = 627.38, ["Mega|Ride"] = 353.3, ["Mega|Fly|Ride"] = 472.38}},
    ["rbxassetid://18119064023"] = {name = "Bald Eagle", prices = {["default"] = 261.19, ["Fly"] = 413.44, ["Ride"] = 422.45, ["Fly|Ride"] = 301.87, ["Neon|Ride"] = 1128.64, ["Neon|Fly|Ride"] = 1585.59, ["Mega|Fly|Ride"] = 5288.76}},
    ["rbxassetid://6060991172"] = {name = "Lynx", prices = {["default"] = 36.91, ["Fly"] = 141.56, ["Ride"] = 52.49, ["Fly|Ride"] = 113.02, ["Neon"] = 196.88, ["Neon|Ride"] = 214.97, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 1085.26, ["Mega|Ride"] = 963.69, ["Mega|Fly|Ride"] = 904.43}},
    ["rbxassetid://10614198346"] = {name = "Pomeranian", prices = {["default"] = 2.1, ["Ride"] = 32.82, ["Fly|Ride"] = 42.08, ["Neon"] = 6.55, ["Neon|Ride"] = 32.81, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 84, ["Mega|Ride"] = 118.43, ["Mega|Fly|Ride"] = 198.96}},
    ["rbxassetid://13663102008"] = {name = "Angler Fish", prices = {["default"] = 2.63, ["Fly"] = 211.26, ["Ride"] = 28.88, ["Fly|Ride"] = 142.7, ["Neon"] = 30.35, ["Neon|Ride"] = 202.05, ["Mega"] = 210.98}},
    ["rbxassetid://5067925193"] = {name = "Toy Monkey", prices = {["default"] = 29.53, ["Fly"] = 77.91, ["Ride"] = 42.67, ["Fly|Ride"] = 90.84, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 2538.62, ["Mega|Ride"] = 945, ["Mega|Fly|Ride"] = 1100.82}},
    ["rbxassetid://15698960105"] = {name = "Kookaburra", prices = {["default"] = 78.17, ["Ride"] = 140.91, ["Fly|Ride"] = 141.12, ["Neon"] = 414.86, ["Neon|Ride"] = 471.19, ["Neon|Fly|Ride"] = 438.99, ["Mega"] = 3103.46, ["Mega|Fly|Ride"] = 2121.49}},
    ["rbxassetid://14266900917"] = {name = "Ring-tailed Lemur", prices = {["default"] = 211.32, ["Ride"] = 241.24, ["Fly|Ride"] = 332.01, ["Neon|Ride"] = 1120.18, ["Neon|Fly|Ride"] = 1157.19, ["Mega|Fly|Ride"] = 2961.72}},
    ["rbxassetid://10467419131"] = {name = "Leopard Cat", prices = {["default"] = 18.25, ["Ride"] = 7392.62, ["Fly|Ride"] = 216.55, ["Neon"] = 85.45, ["Neon|Ride"] = 144.16, ["Mega"] = 381.62, ["Mega|Ride"] = 361.85, ["Mega|Fly|Ride"] = 1057.76}},
    ["rbxassetid://6498256485"] = {name = "Crab", prices = {["default"] = 2.1, ["Fly"] = 28.53, ["Ride"] = 16.91, ["Fly|Ride"] = 35.95, ["Neon"] = 7.35, ["Neon|Ride"] = 23.29, ["Neon|Fly|Ride"] = 48.67, ["Mega"] = 90.57, ["Mega|Ride"] = 104.99, ["Mega|Fly|Ride"] = 189}},
    ["rbxassetid://5721843587"] = {name = "Glyptodon", prices = {["default"] = 6.57, ["Ride"] = 19.2, ["Fly|Ride"] = 52.5, ["Neon"] = 28.61, ["Neon|Fly"] = 147.88, ["Neon|Ride"] = 48.67, ["Neon|Fly|Ride"] = 84.63, ["Mega"] = 236.25, ["Mega|Ride"] = 216.57, ["Mega|Fly|Ride"] = 283.5}},
    ["rbxassetid://13979141397"] = {name = "Giant Anteater", prices = {["default"] = 301.88, ["Fly"] = 493.27, ["Ride"] = 321.7, ["Fly|Ride"] = 406.88, ["Neon"] = 1354.08, ["Neon|Ride"] = 1375.08, ["Neon|Fly|Ride"] = 1834.16, ["Mega|Fly|Ride"] = 5775}},
    ["rbxassetid://109730629255705"] = {name = "Ruddy Duck", prices = {["default"] = 2.1, ["Ride"] = 46.49, ["Neon"] = 7.88, ["Neon|Fly|Ride"] = 118125, ["Mega"] = 39.38, ["Mega|Ride"] = 148.1, ["Mega|Fly|Ride"] = 268.68}},
    ["rbxassetid://6498259006"] = {name = "Clownfish", prices = {["default"] = 3.82, ["Ride"] = 21.19, ["Fly|Ride"] = 47.09, ["Neon"] = 22.32, ["Neon|Ride"] = 31.75, ["Neon|Fly|Ride"] = 97.13, ["Mega"] = 170.22, ["Mega|Ride"] = 211.56, ["Mega|Fly|Ride"] = 270.8}},
    ["rbxassetid://11758569695"] = {name = "Amami Rabbit", prices = {["default"] = 21.19, ["Ride"] = 141, ["Neon"] = 104.81, ["Neon|Fly"] = 282.43, ["Neon|Ride"] = 133.29, ["Neon|Fly|Ride"] = 564.85, ["Mega"] = 466.48, ["Mega|Ride"] = 472.49, ["Mega|Fly|Ride"] = 625.28}},
    ["rbxassetid://11505509482"] = {name = "Ice Wolf", prices = {["default"] = 152.86, ["Fly"] = 172.17, ["Ride"] = 129.94, ["Fly|Ride"] = 141.52, ["Neon"] = 421.45, ["Neon|Ride"] = 564.85, ["Neon|Fly|Ride"] = 374.07, ["Mega|Fly|Ride"] = 2507.94}},
    ["rbxassetid://9994480266"] = {name = "Royal Palace Spaniel", prices = {["default"] = 19.73, ["Fly"] = 42.26, ["Ride"] = 28.44, ["Fly|Ride"] = 39.38, ["Neon"] = 70.79, ["Neon|Ride"] = 83.25, ["Neon|Fly|Ride"] = 138.33, ["Mega"] = 705.54, ["Mega|Ride"] = 507.66, ["Mega|Fly|Ride"] = 414.75}},
    ["rbxassetid://100897154120273"] = {name = "Clumpty", prices = {["default"] = 2.1, ["Ride"] = 26.24, ["Neon"] = 2.1, ["Neon|Ride"] = 28.58, ["Neon|Fly|Ride"] = 705.54, ["Mega"] = 20.11, ["Mega|Ride"] = 105.78, ["Mega|Fly|Ride"] = 252.82}},
    ["rbxassetid://11108831285"] = {name = "Ocelot", prices = {["default"] = 2.1, ["Ride"] = 19.69, ["Fly|Ride"] = 52.5, ["Neon"] = 3.88, ["Neon|Fly"] = 157.7, ["Neon|Ride"] = 27.51, ["Neon|Fly|Ride"] = 69.18, ["Mega"] = 25.26, ["Mega|Fly"] = 140.27, ["Mega|Ride"] = 47.31, ["Mega|Fly|Ride"] = 103.36}},
    ["rbxassetid://99323773370664"] = {name = "Dire Wolf", prices = {["default"] = 10.49, ["Fly"] = 126, ["Ride"] = 56.44, ["Fly|Ride"] = 158.82, ["Neon"] = 30.19, ["Neon|Fly"] = 99.3, ["Neon|Ride"] = 72.19, ["Neon|Fly|Ride"] = 153.57, ["Mega"] = 134.34, ["Mega|Fly"] = 282.43, ["Mega|Ride"] = 157.95, ["Mega|Fly|Ride"] = 314.27}},
    ["rbxassetid://17649307413"] = {name = "Mini Pig", prices = {["default"] = 1246.88, ["Ride"] = 1296.56, ["Fly|Ride"] = 1302, ["Neon|Ride"] = 7052.04, ["Neon|Fly|Ride"] = 3933.53, ["Mega"] = 18193.32, ["Mega|Fly|Ride"] = 12600}},
    ["rbxassetid://12720029753"] = {name = "Border Collie", prices = {["default"] = 515.29, ["Fly"] = 611.82, ["Ride"] = 599.82, ["Fly|Ride"] = 618.19, ["Neon"] = 2816.93, ["Neon|Fly|Ride"] = 2813.63, ["Mega"] = 14143.21, ["Mega|Fly|Ride"] = 7084.87}},
    ["rbxassetid://4440866760"] = {name = "Pig", prices = {["default"] = 294.23, ["Fly"] = 395.05, ["Ride"] = 340.54, ["Fly|Ride"] = 408.19, ["Neon"] = 735, ["Neon|Ride"] = 798, ["Neon|Fly|Ride"] = 761.25, ["Mega|Fly|Ride"] = 2651.8}},
    ["rbxassetid://4506925854"] = {name = "Arctic Fox", prices = {["default"] = 315, ["Fly"] = 452.07, ["Ride"] = 356.54, ["Fly|Ride"] = 459.38, ["Neon"] = 1023.75, ["Neon|Fly"] = 3138.66, ["Neon|Ride"] = 1001.7, ["Neon|Fly|Ride"] = 945, ["Mega|Ride"] = 3675, ["Mega|Fly|Ride"] = 3641.86}},
    ["rbxassetid://11758575618"] = {name = "Black Moon Bear", prices = {["default"] = 2.1, ["Fly"] = 20.25, ["Ride"] = 17, ["Fly|Ride"] = 44.62, ["Neon"] = 5.09, ["Neon|Ride"] = 21.24, ["Neon|Fly|Ride"] = 70.89, ["Mega"] = 71.37, ["Mega|Ride"] = 112.88, ["Mega|Fly|Ride"] = 144.38}},
    ["rbxassetid://15547272520"] = {name = "Christmas Pudding Pup", prices = {["default"] = 385.24, ["Fly"] = 590.62, ["Ride"] = 421.32, ["Fly|Ride"] = 541.8, ["Neon"] = 853.13, ["Neon|Ride"] = 1076.25, ["Neon|Fly|Ride"] = 1139.24, ["Mega"] = 6346.52, ["Mega|Ride"] = 10154.42, ["Mega|Fly|Ride"] = 4066.13}},
    ["rbxassetid://78519945248690"] = {name = "Zombie Chick", prices = {["default"] = 2.1, ["Fly"] = 183.75, ["Ride"] = 25.33, ["Fly|Ride"] = 39.29, ["Neon"] = 9.19, ["Neon|Ride"] = 56.44, ["Neon|Fly|Ride"] = 112.66, ["Mega"] = 61.37, ["Mega|Ride"] = 99.45, ["Mega|Fly|Ride"] = 218.09}},
    ["rbxassetid://10357178561"] = {name = "Ibis", prices = {["default"] = 2.1, ["Fly"] = 20.76, ["Ride"] = 16.91, ["Fly|Ride"] = 49.88, ["Neon"] = 14.11, ["Neon|Ride"] = 61.69, ["Neon|Fly|Ride"] = 63, ["Mega"] = 91.77, ["Mega|Ride"] = 140.94}},
    ["rbxassetid://96759122303055"] = {name = "Clubtail Dragonfly", prices = {["default"] = 2.1, ["Fly"] = 57.75, ["Neon"] = 2.63, ["Neon|Fly"] = 78.86, ["Neon|Ride"] = 24.34, ["Mega"] = 20.01, ["Mega|Fly"] = 70.89, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://12778628897"] = {name = "Karate Gorilla", prices = {["default"] = 39.38, ["Ride"] = 65.63, ["Fly|Ride"] = 459.38, ["Neon"] = 244.13, ["Neon|Ride"] = 314.24, ["Mega"] = 1692.42, ["Mega|Fly|Ride"] = 942.89}},
    ["rbxassetid://13104121371"] = {name = "Poison Dart Frog", prices = {["default"] = 3.93, ["Fly"] = 65.62, ["Ride"] = 23.55, ["Fly|Ride"] = 43.32, ["Neon"] = 15.86, ["Mega"] = 328.13, ["Mega|Ride"] = 233.89}},
    ["rbxassetid://71881209536633"] = {name = "Humbug", prices = {["default"] = 2.1, ["Ride"] = 55.12, ["Neon"] = 3.94, ["Neon|Fly"] = 141, ["Neon|Ride"] = 36.33, ["Neon|Fly|Ride"] = 95.82, ["Mega"] = 26.17, ["Mega|Fly"] = 705.54, ["Mega|Ride"] = 50.54, ["Mega|Fly|Ride"] = 314.7}},
    ["rbxassetid://11109314958"] = {name = "Ghost Wolf", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 23.99, ["Fly|Ride"] = 49.79, ["Neon"] = 6.56, ["Neon|Fly"] = 52.49, ["Neon|Ride"] = 28.44, ["Neon|Fly|Ride"] = 71.99, ["Mega"] = 60.38, ["Mega|Fly"] = 175.14, ["Mega|Ride"] = 74.51, ["Mega|Fly|Ride"] = 156.24}},
    ["rbxassetid://16088267136"] = {name = "Wildfire Hawk", prices = {["default"] = 5.9, ["Fly"] = 46.98, ["Ride"] = 31.78, ["Fly|Ride"] = 51.45, ["Neon"] = 42.26, ["Neon|Fly"] = 42.26, ["Neon|Ride"] = 70.89, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 237.57, ["Mega|Ride"] = 268.68, ["Mega|Fly|Ride"] = 1019.82}},
    ["rbxassetid://16898328648"] = {name = "Preppy Capuchin Monkey", prices = {["default"] = 11.82, ["Ride"] = 52.41, ["Neon"] = 78.17, ["Mega"] = 353.3, ["Mega|Ride"] = 336.38, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://15921713413"] = {name = "Thorny Devil", prices = {["default"] = 7.87, ["Ride"] = 26.17, ["Fly|Ride"] = 87.94, ["Neon"] = 141.75, ["Neon|Ride"] = 79, ["Neon|Fly|Ride"] = 282.43, ["Mega"] = 452.73, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://16441364976"] = {name = "Gold Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 16.65, ["Ride"] = 15.75, ["Fly|Ride"] = 55.33, ["Neon"] = 3.35, ["Neon|Ride"] = 47.16, ["Mega"] = 43.32, ["Mega|Ride"] = 126, ["Mega|Fly|Ride"] = 317.34}},
    ["rbxassetid://8077189117"] = {name = "Puffin", prices = {["default"] = 204.85, ["Fly"] = 295.75, ["Ride"] = 211.26, ["Fly|Ride"] = 277.75, ["Neon|Ride"] = 1135.3, ["Neon|Fly|Ride"] = 1050, ["Mega"] = 10577.52, ["Mega|Fly|Ride"] = 4442.58}},
    ["rbxassetid://8663441120"] = {name = "Lunar Tiger", prices = {["default"] = 2.1, ["Fly"] = 18.2, ["Ride"] = 15.65, ["Fly|Ride"] = 41.19, ["Neon"] = 3.84, ["Neon|Fly"] = 15.86, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 55.13, ["Mega"] = 37.91, ["Mega|Ride"] = 72.97, ["Mega|Fly|Ride"] = 116.16}},
    ["rbxassetid://17174216294"] = {name = "Skunk", prices = {["default"] = 10.58, ["Ride"] = 42.37, ["Fly|Ride"] = 180.02, ["Neon"] = 73.95, ["Neon|Ride"] = 104.41, ["Mega"] = 350.48, ["Mega|Ride"] = 312.05, ["Mega|Fly|Ride"] = 417.83}},
    ["rbxassetid://13981141292"] = {name = "Kiwi", prices = {["default"] = 35.94, ["Fly"] = 131.25, ["Ride"] = 51.01, ["Fly|Ride"] = 141.56, ["Neon"] = 209.14, ["Neon|Ride"] = 230.31, ["Neon|Fly|Ride"] = 367.05, ["Mega"] = 803.91, ["Mega|Ride"] = 832.08, ["Mega|Fly|Ride"] = 786.14}},
    ["rbxassetid://3409443617"] = {name = "Meerkat", prices = {["default"] = 141.1, ["Fly"] = 308.44, ["Ride"] = 208.29, ["Fly|Ride"] = 299.86, ["Neon"] = 842.88, ["Neon|Ride"] = 651, ["Neon|Fly|Ride"] = 656.25, ["Mega|Ride"] = 3384.82, ["Mega|Fly|Ride"] = 2625}},
    ["rbxassetid://99042906016947"] = {name = "Seafoam Butterfly", prices = {["default"] = 19.55, ["Neon"] = 70.53, ["Neon|Ride"] = 282.43, ["Mega"] = 282.43, ["Mega|Ride"] = 406.88, ["Mega|Fly|Ride"] = 705.54}},
    ["rbxassetid://15504847683"] = {name = "Gingerbread Hare", prices = {["default"] = 28.23, ["Ride"] = 278.82, ["Fly|Ride"] = 633.67, ["Neon"] = 190.13, ["Neon|Ride"] = 634.67, ["Neon|Fly|Ride"] = 846.21, ["Mega"] = 1414.33, ["Mega|Fly|Ride"] = 1269.32}},
    ["rbxassetid://15302316802"] = {name = "Peppermint Penguin", prices = {["default"] = 1181.25, ["Fly"] = 1441.13, ["Ride"] = 984.38, ["Fly|Ride"] = 1180.2, ["Neon|Ride"] = 4442.58, ["Neon|Fly|Ride"] = 4339.95, ["Mega|Fly|Ride"] = 17207.5}},
    ["rbxassetid://10318106124"] = {name = "Scarlet Butterfly", prices = {["default"] = 8.93, ["Fly"] = 16.91, ["Ride"] = 20.57, ["Fly|Ride"] = 63, ["Neon"] = 40.37, ["Neon|Fly"] = 75.06, ["Neon|Ride"] = 46.56, ["Neon|Fly|Ride"] = 200.81, ["Mega"] = 223.18, ["Mega|Ride"] = 240.12, ["Mega|Fly|Ride"] = 387.19}},
    ["rbxassetid://14145989411"] = {name = "Toy Poodle", prices = {["default"] = 5.24, ["Fly"] = 13942.04, ["Ride"] = 28.53, ["Neon"] = 38.04, ["Neon|Ride"] = 140.39, ["Neon|Fly|Ride"] = 144.74, ["Mega"] = 169.25, ["Mega|Ride"] = 200.82, ["Mega|Fly|Ride"] = 469.43}},
    ["rbxassetid://82833859118891"] = {name = "Snowy Mammoth", prices = {["default"] = 3.68, ["Ride"] = 52.5, ["Fly|Ride"] = 525, ["Neon"] = 26.25, ["Neon|Ride"] = 117.89, ["Mega"] = 98.44, ["Mega|Ride"] = 272.92, ["Mega|Fly|Ride"] = 564.85}},
    ["rbxassetid://12917346501"] = {name = "Happy Duckling", prices = {["default"] = 18.31, ["Fly"] = 704.51, ["Ride"] = 39.38, ["Fly|Ride"] = 422.45, ["Neon"] = 86.51, ["Neon|Ride"] = 98.98, ["Neon|Fly|Ride"] = 142.37, ["Mega"] = 391.29, ["Mega|Ride"] = 386.82, ["Mega|Fly|Ride"] = 446.25}},
    ["rbxassetid://7064993901"] = {name = "2021 Uplift Butterfly", prices = {["default"] = 3.78, ["Fly"] = 21.06, ["Ride"] = 15.8, ["Fly|Ride"] = 31.61, ["Neon"] = 22.04, ["Neon|Fly"] = 57.05, ["Neon|Ride"] = 23.25, ["Neon|Fly|Ride"] = 87.81, ["Mega|Ride"] = 149.26, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://10926054144"] = {name = "Slug", prices = {["default"] = 2.63, ["Neon"] = 11.22, ["Neon|Fly"] = 13125, ["Neon|Ride"] = 56.86, ["Neon|Fly|Ride"] = 110.82, ["Mega"] = 233.78, ["Mega|Ride"] = 131.14, ["Mega|Fly|Ride"] = 388.21}},
    ["rbxassetid://11571113906"] = {name = "Glacier Moth", prices = {["default"] = 211.26, ["Ride"] = 333.38, ["Fly|Ride"] = 282.02, ["Neon|Ride"] = 1692.42, ["Neon|Fly|Ride"] = 1454.42, ["Mega|Ride"] = 5250, ["Mega|Fly|Ride"] = 4714.42}},
    ["rbxassetid://73641371341710"] = {name = "Ice Cube", prices = {["default"] = 2.1, ["Ride"] = 27.83, ["Fly|Ride"] = 49.45, ["Neon"] = 10.8, ["Neon|Ride"] = 41.91, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 112.88, ["Mega|Ride"] = 103.43, ["Mega|Fly|Ride"] = 393.67}},
    ["rbxassetid://13077767764"] = {name = "Eel", prices = {["default"] = 6.33, ["Neon"] = 42, ["Neon|Ride"] = 313.85, ["Mega"] = 279.25, ["Mega|Ride"] = 267.25}},
    ["rbxassetid://134995672989153"] = {name = "Hammerhead Shark", prices = {["default"] = 7.76, ["Fly"] = 58.27, ["Ride"] = 34.13, ["Neon"] = 19.26, ["Neon|Ride"] = 57.14, ["Neon|Fly|Ride"] = 207.18, ["Mega"] = 102.71, ["Mega|Fly"] = 423.11, ["Mega|Ride"] = 169.25, ["Mega|Fly|Ride"] = 349.79}},
    ["rbxassetid://15555939727"] = {name = "Snow Monkey", prices = {["default"] = 164.07, ["Fly"] = 338, ["Ride"] = 281.96, ["Fly|Ride"] = 616.88, ["Neon"] = 662.26, ["Neon|Ride"] = 774.38, ["Neon|Fly|Ride"] = 945, ["Mega|Ride"] = 5077.22, ["Mega|Fly|Ride"] = 1975.89}},
    ["rbxassetid://11758575992"] = {name = "Water Rabbit", prices = {["default"] = 23.63, ["Fly"] = 57.05, ["Ride"] = 149.63, ["Fly|Ride"] = 109.87, ["Neon"] = 141.56, ["Neon|Ride"] = 145.99, ["Neon|Fly|Ride"] = 324.74, ["Mega"] = 634.67, ["Mega|Fly|Ride"] = 783.49}},
    ["rbxassetid://90987982535884"] = {name = "Great Pyrenees", prices = {["default"] = 23.59, ["Ride"] = 45.94, ["Fly|Ride"] = 1267.31, ["Neon"] = 65.63, ["Neon|Ride"] = 110.39, ["Neon|Fly|Ride"] = 257.25, ["Mega"] = 477.33, ["Mega|Ride"] = 467.13, ["Mega|Fly|Ride"] = 547.32}},
    ["rbxassetid://84560154336174"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Ride"] = 19.69, ["Neon"] = 3.94, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 35.17, ["Mega"] = 33.45, ["Mega|Ride"] = 78.98, ["Mega|Fly|Ride"] = 114.19}},
    ["rbxassetid://4506847061"] = {name = "Reindeer", prices = {["default"] = 68.25, ["Fly"] = 99.86, ["Ride"] = 83.01, ["Fly|Ride"] = 192.47, ["Neon"] = 395.05, ["Neon|Fly"] = 380.25, ["Neon|Ride"] = 380.81, ["Neon|Fly|Ride"] = 383.25, ["Mega|Fly|Ride"] = 1200.38}},
    ["rbxassetid://98687388677942"] = {name = "Moonpine", prices = {["default"] = 2.1, ["Ride"] = 18.8, ["Neon"] = 6.57, ["Neon|Ride"] = 57.14, ["Neon|Fly|Ride"] = 588, ["Mega"] = 40.69, ["Mega|Ride"] = 141.75}},
    ["rbxassetid://11109032702"] = {name = "Green Amazon", prices = {["default"] = 19.69, ["Fly"] = 32.82, ["Ride"] = 23.63, ["Fly|Ride"] = 124.64, ["Neon"] = 99.3, ["Neon|Ride"] = 110.02, ["Neon|Fly|Ride"] = 141.44, ["Mega"] = 380.63, ["Mega|Ride"] = 408.19, ["Mega|Fly|Ride"] = 367.85}},
    ["rbxassetid://3743730108"] = {name = "Black Panther", prices = {["default"] = 34.13, ["Fly"] = 80.01, ["Ride"] = 85.32, ["Fly|Ride"] = 124.69, ["Neon"] = 238.72, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 262.5, ["Mega|Ride"] = 1233.35, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://3181727398"] = {name = "Chocolate Labrador", prices = {["default"] = 2.1, ["Fly"] = 12.69, ["Ride"] = 15.8, ["Fly|Ride"] = 32.82, ["Neon"] = 2.63, ["Neon|Fly"] = 16.91, ["Neon|Ride"] = 16.12, ["Neon|Fly|Ride"] = 42.26, ["Mega"] = 18.38, ["Mega|Fly"] = 55.41, ["Mega|Ride"] = 39.11, ["Mega|Fly|Ride"] = 83.74}},
    ["rbxassetid://134636987874448"] = {name = "Nebula Snake", prices = {["default"] = 3.92, ["Ride"] = 32.18, ["Fly|Ride"] = 105, ["Neon"] = 14.94, ["Neon|Ride"] = 70.56, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 177.19, ["Mega|Ride"] = 282.43, ["Mega|Fly|Ride"] = 211.56}},
    ["rbxassetid://13104122150"] = {name = "Hippo", prices = {["default"] = 15.74, ["Ride"] = 40.15, ["Neon"] = 144.38, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 358.59, ["Mega"] = 752.08, ["Mega|Ride"] = 472.5, ["Mega|Fly|Ride"] = 651}},
    ["rbxassetid://103821295208934"] = {name = "Black Rhino", prices = {["default"] = 2.1, ["Ride"] = 19.69, ["Neon"] = 2.63, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 137.52, ["Mega"] = 21.16, ["Mega|Ride"] = 78.56}},
    ["rbxassetid://14782580070"] = {name = "Undead Elk", prices = {["default"] = 5.24, ["Fly"] = 210, ["Ride"] = 31.69, ["Fly|Ride"] = 105, ["Neon"] = 64.58, ["Neon|Ride"] = 91.77, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 220.03, ["Mega|Fly"] = 787.5, ["Mega|Ride"] = 228.5, ["Mega|Fly|Ride"] = 316.28}},
    ["rbxassetid://8566683782"] = {name = "Giant Blue Scarab", prices = {["default"] = 15.73, ["Fly"] = 42.11, ["Ride"] = 26.17, ["Fly|Ride"] = 46.6, ["Neon"] = 117.03, ["Neon|Ride"] = 64.56, ["Neon|Fly|Ride"] = 328.13, ["Mega|Ride"] = 360.94, ["Mega|Fly|Ride"] = 705.54}},
    ["rbxassetid://14850232913"] = {name = "Cute-A-Cabra", prices = {["default"] = 3.91, ["Ride"] = 58.8, ["Neon"] = 25.7, ["Neon|Fly"] = 699.57, ["Neon|Ride"] = 77.44, ["Neon|Fly|Ride"] = 200.41, ["Mega"] = 170.63, ["Mega|Ride"] = 186.38, ["Mega|Fly|Ride"] = 282.43}},
    ["rbxassetid://15508248825"] = {name = "Eggnog Dog", prices = {["default"] = 20.9, ["Fly"] = 2112.45, ["Ride"] = 85.56, ["Neon"] = 110.64, ["Neon|Ride"] = 282.43, ["Neon|Fly|Ride"] = 564.85, ["Mega"] = 466.48, ["Mega|Ride"] = 1024.42, ["Mega|Fly|Ride"] = 1127.57}},
    ["rbxassetid://17822797244"] = {name = "Orange Betta Fish", prices = {["default"] = 2.1, ["Ride"] = 125.58, ["Fly|Ride"] = 196.87, ["Neon"] = 8.9, ["Neon|Fly"] = 50.71, ["Neon|Ride"] = 70.89, ["Neon|Fly|Ride"] = 99.08, ["Mega"] = 63.66, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 169.74}},
    ["rbxassetid://9922274393"] = {name = "Retired Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://103431939950304"] = {name = "Pink Dog", prices = {["default"] = 2.1, ["Neon"] = 6.33, ["Mega"] = 23.63, ["Mega|Ride"] = 141.75, ["Mega|Fly|Ride"] = 423.11}},
    ["rbxassetid://15227882502"] = {name = "Christmas Future Egg", prices = {["default"] = 37.97}},
    ["rbxassetid://12597276740"] = {name = "Red Sand Dollar", prices = {["default"] = 70.79, ["Fly"] = 102.38, ["Ride"] = 65.63, ["Fly|Ride"] = 205.97, ["Neon"] = 1050, ["Neon|Ride"] = 228.5, ["Neon|Fly|Ride"] = 1057.76, ["Mega"] = 1114.88, ["Mega|Ride"] = 701.3, ["Mega|Fly|Ride"] = 703.88}},
    ["rbxassetid://136447612467002"] = {name = "Glyptodon Ducky", prices = {["default"] = 2.1, ["Ride"] = 81.38, ["Fly|Ride"] = 141.52, ["Neon"] = 2.63, ["Mega"] = 19.69, ["Mega|Fly"] = 137.82, ["Mega|Ride"] = 99.45, ["Mega|Fly|Ride"] = 118.13}},
    ["rbxassetid://101033810950061"] = {name = "Sea Slug", prices = {["default"] = 551.25, ["Ride"] = 709.86, ["Fly|Ride"] = 525, ["Neon"] = 2390.24, ["Neon|Fly|Ride"] = 2397.93, ["Mega"] = 16924.03, ["Mega|Fly|Ride"] = 14101.95}},
    ["rbxassetid://14353536658"] = {name = "Birthday Butterfly 2023", prices = {["default"] = 3.7, ["Fly"] = 26.17, ["Ride"] = 42.09, ["Fly|Ride"] = 79.22, ["Neon"] = 278.85, ["Neon|Ride"] = 279.25, ["Mega"] = 82.51, ["Mega|Ride"] = 141.75, ["Mega|Fly|Ride"] = 564.85}},
    ["rbxassetid://9938967851"] = {name = "Tan Chow-Chow", prices = {["default"] = 2.52, ["Fly"] = 157.67, ["Ride"] = 21.14, ["Fly|Ride"] = 39.38, ["Neon"] = 22.32, ["Neon|Ride"] = 35.38, ["Neon|Fly|Ride"] = 63.48, ["Mega"] = 138.58, ["Mega|Ride"] = 157.95, ["Mega|Fly|Ride"] = 190.32}},
    ["rbxassetid://14448124117"] = {name = "Chipmunk", prices = {["default"] = 8.85, ["Ride"] = 76.13, ["Fly|Ride"] = 106.31, ["Neon"] = 104.68, ["Neon|Ride"] = 55.42, ["Mega"] = 393.75, ["Mega|Ride"] = 383.25, ["Mega|Fly|Ride"] = 423.11}},
    ["rbxassetid://13104108894"] = {name = "Lammergeier", prices = {["default"] = 3.82, ["Fly"] = 39.38, ["Ride"] = 31.5, ["Fly|Ride"] = 141.56, ["Neon"] = 41.21, ["Mega"] = 294.07}},
    ["rbxassetid://14446659851"] = {name = "Raccoon", prices = {["default"] = 13.13, ["Ride"] = 57.04, ["Fly|Ride"] = 157.39, ["Neon"] = 94.16, ["Neon|Ride"] = 165.01, ["Neon|Fly|Ride"] = 350.44, ["Mega"] = 363.57, ["Mega|Ride"] = 324.74, ["Mega|Fly|Ride"] = 523.69}},
    ["rbxassetid://84477079324217"] = {name = "Peachick", prices = {["default"] = 8.25, ["Fly"] = 98.44, ["Ride"] = 39.38, ["Fly|Ride"] = 787.5, ["Neon"] = 26.14, ["Neon|Ride"] = 93.1, ["Neon|Fly|Ride"] = 141.75, ["Mega"] = 157.95, ["Mega|Fly"] = 488.7, ["Mega|Ride"] = 262.34, ["Mega|Fly|Ride"] = 349.08}},
    ["rbxassetid://9718162456"] = {name = "Donkey", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 15.8, ["Fly|Ride"] = 39.19, ["Neon"] = 2.1, ["Neon|Fly"] = 28.53, ["Neon|Ride"] = 15.88, ["Neon|Fly|Ride"] = 39.29, ["Mega"] = 15.81, ["Mega|Fly"] = 79.11, ["Mega|Ride"] = 26.25, ["Mega|Fly|Ride"] = 91.88}},
    ["rbxassetid://93800993117604"] = {name = "Love Bird", prices = {["default"] = 11.59, ["Ride"] = 39.38, ["Fly|Ride"] = 157.7, ["Neon"] = 32.82, ["Neon|Fly"] = 117.89, ["Neon|Ride"] = 87.94, ["Neon|Fly|Ride"] = 317.34, ["Mega"] = 167.88, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 423.11}},
    ["rbxassetid://13665143675"] = {name = "Lion Cub", prices = {["default"] = 236.25, ["Ride"] = 300.57, ["Fly|Ride"] = 337.97, ["Neon"] = 1480.5, ["Neon|Ride"] = 1107.75, ["Neon|Fly|Ride"] = 1057.76, ["Mega|Fly|Ride"] = 3886.15}},
    ["rbxassetid://13883284001"] = {name = "Ice Cream Hermit Crab", prices = {["default"] = 85.32, ["Fly"] = 156.33, ["Ride"] = 147.87, ["Fly|Ride"] = 262.5, ["Neon"] = 549.25, ["Neon|Ride"] = 493.99, ["Neon|Fly|Ride"] = 623.44, ["Mega"] = 4231.02, ["Mega|Ride"] = 1827.81, ["Mega|Fly|Ride"] = 1627.5}},
    ["rbxassetid://8938701212"] = {name = "Woodpecker", prices = {["default"] = 2.1, ["Fly"] = 12.69, ["Ride"] = 18.96, ["Fly|Ride"] = 39.34, ["Neon"] = 12.71, ["Neon|Fly"] = 18.38, ["Neon|Ride"] = 33.53, ["Neon|Fly|Ride"] = 62.67, ["Mega"] = 90.99, ["Mega|Fly"] = 210.51, ["Mega|Ride"] = 92.05, ["Mega|Fly|Ride"] = 141.75}},
    ["rbxassetid://4800190034"] = {name = "Toucan", prices = {["default"] = 2.1, ["Fly"] = 20.79, ["Ride"] = 15.63, ["Fly|Ride"] = 26.25, ["Neon"] = 6.25, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 22.97, ["Neon|Fly|Ride"] = 48.67, ["Mega"] = 52.5, ["Mega|Fly"] = 353.3, ["Mega|Ride"] = 93.19, ["Mega|Fly|Ride"] = 141.75}},
    ["rbxassetid://15886122789"] = {name = "Deathstalker Scorpion", prices = {["default"] = 3.31, ["Ride"] = 18.38, ["Fly|Ride"] = 98.44, ["Neon"] = 39.38, ["Mega"] = 1128.64}},
    ["rbxassetid://12139402705"] = {name = "Sheeeeep", prices = {["default"] = 210, ["Ride"] = 252, ["Fly|Ride"] = 345.35, ["Neon|Ride"] = 1289.57, ["Neon|Fly|Ride"] = 1235.47, ["Mega|Ride"] = 8462.03, ["Mega|Fly|Ride"] = 3675}},
    ["rbxassetid://7126720389"] = {name = "Hydra", prices = {["default"] = 3.94, ["Fly"] = 21.05, ["Ride"] = 17.31, ["Fly|Ride"] = 35.44, ["Neon"] = 23.63, ["Neon|Fly"] = 157.7, ["Neon|Ride"] = 28.58, ["Neon|Fly|Ride"] = 74.91, ["Mega"] = 290.9, ["Mega|Ride"] = 251.76, ["Mega|Fly|Ride"] = 262.48}},
    ["rbxassetid://17662289865"] = {name = "Punk Pony", prices = {["default"] = 3.91, ["Fly"] = 141.2, ["Ride"] = 40.01, ["Fly|Ride"] = 211.23, ["Neon"] = 27.57, ["Neon|Ride"] = 40.69, ["Mega"] = 230.99, ["Mega|Ride"] = 236.24, ["Mega|Fly|Ride"] = 301.88}},
    ["rbxassetid://84009422958505"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 5.25, ["Neon|Ride"] = 29.89, ["Neon|Fly|Ride"] = 141.75, ["Mega"] = 40.69, ["Mega|Ride"] = 95.7, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://9473352533"] = {name = "Space Whale", prices = {["default"] = 13.54, ["Fly"] = 70.79, ["Ride"] = 25.9, ["Fly|Ride"] = 59.07, ["Neon"] = 124.65, ["Neon|Ride"] = 102.38, ["Neon|Fly|Ride"] = 179.83, ["Mega"] = 728.34, ["Mega|Ride"] = 422.05, ["Mega|Fly|Ride"] = 386.93}},
    ["rbxassetid://71528203783155"] = {name = "Pupcake", prices = {["default"] = 42.26, ["Fly"] = 116.82, ["Ride"] = 93.65, ["Fly|Ride"] = 229.86, ["Neon"] = 136.49, ["Neon|Fly"] = 393.75, ["Neon|Ride"] = 171.36, ["Neon|Fly|Ride"] = 344.86, ["Mega"] = 459.38, ["Mega|Fly"] = 2221.29, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 578.61}},
    ["rbxassetid://4440867010"] = {name = "Drake", prices = {["default"] = 22.31, ["Fly"] = 63.55, ["Ride"] = 41.83, ["Fly|Ride"] = 96.49, ["Neon"] = 118.13, ["Neon|Fly"] = 290.07, ["Neon|Ride"] = 139.07, ["Neon|Fly|Ride"] = 219.19, ["Mega"] = 705.54, ["Mega|Ride"] = 783.12, ["Mega|Fly|Ride"] = 663.17}},
    ["rbxassetid://9708962205"] = {name = "Parakeet", prices = {["default"] = 2.02, ["Fly"] = 17.07, ["Ride"] = 15.85, ["Fly|Ride"] = 32.82, ["Neon"] = 2.1, ["Neon|Fly"] = 23.55, ["Neon|Ride"] = 21.16, ["Neon|Fly|Ride"] = 62.43, ["Mega"] = 20.72, ["Mega|Fly"] = 28.88, ["Mega|Ride"] = 45.5, ["Mega|Fly|Ride"] = 114.35}},
    ["rbxassetid://4883302468"] = {name = "Shrew", prices = {["default"] = 204.74, ["Fly"] = 278.24, ["Ride"] = 252.4, ["Fly|Ride"] = 316.32, ["Neon"] = 892.5, ["Neon|Ride"] = 931.9, ["Neon|Fly|Ride"] = 888.53, ["Mega|Fly|Ride"] = 4188.71}},
    ["rbxassetid://11507151679"] = {name = "Irish Elk", prices = {["default"] = 13, ["Fly"] = 140.39, ["Ride"] = 42, ["Fly|Ride"] = 131.51, ["Neon"] = 105, ["Neon|Ride"] = 211.36, ["Neon|Fly|Ride"] = 210, ["Mega"] = 485.63, ["Mega|Ride"] = 446.25, ["Mega|Fly|Ride"] = 523.69}},
    ["rbxassetid://17163957321"] = {name = "Blue Jay", prices = {["default"] = 2.1, ["Fly"] = 25.36, ["Ride"] = 18.38, ["Fly|Ride"] = 39.3, ["Neon"] = 6.57, ["Neon|Ride"] = 31.84, ["Mega"] = 49.24, ["Mega|Fly"] = 79.34, ["Mega|Ride"] = 99.45, ["Mega|Fly|Ride"] = 78.98}},
    ["rbxassetid://8705079225"] = {name = "Abyssinian Cat", prices = {["default"] = 2.1, ["Fly"] = 28.53, ["Ride"] = 16.86, ["Fly|Ride"] = 56.9, ["Neon"] = 3.42, ["Neon|Fly"] = 47.16, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 97.23, ["Mega"] = 23.63, ["Mega|Fly"] = 141.44, ["Mega|Ride"] = 52.89, ["Mega|Fly|Ride"] = 135.14}},
    ["rbxassetid://17059483392"] = {name = "Velociraptor", prices = {["default"] = 2.1, ["Fly"] = 131.25, ["Ride"] = 21.06, ["Fly|Ride"] = 140.94, ["Neon"] = 7.77, ["Neon|Ride"] = 32.81, ["Neon|Fly|Ride"] = 7052.04, ["Mega"] = 91.88, ["Mega|Ride"] = 128.63, ["Mega|Fly|Ride"] = 379.75}},
    ["rbxassetid://16548686870"] = {name = "Hamster", prices = {["default"] = 9.19, ["Fly"] = 65.63, ["Ride"] = 28.53, ["Fly|Ride"] = 63.2, ["Neon"] = 57.75, ["Neon|Ride"] = 60.32, ["Neon|Fly|Ride"] = 123.12, ["Mega"] = 347.7, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 334.69}},
    ["rbxassetid://13883285383"] = {name = "Castle Hermit Crab", prices = {["default"] = 11.69, ["Ride"] = 26.25, ["Fly|Ride"] = 72.19, ["Neon"] = 39.38, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 236.25, ["Mega|Ride"] = 289.84, ["Mega|Fly|Ride"] = 431.59}},
    ["rbxassetid://82240382561696"] = {name = "Cocoadile", prices = {["default"] = 2.52, ["Fly"] = 21.12, ["Ride"] = 42.26, ["Neon"] = 2.63, ["Neon|Ride"] = 35.44, ["Neon|Fly|Ride"] = 94.32, ["Mega"] = 26.13, ["Mega|Ride"] = 74.86, ["Mega|Fly|Ride"] = 423.11}},
    ["rbxassetid://74702714943302"] = {name = "Grave Owl", prices = {["default"] = 6.57, ["Fly"] = 35.94, ["Ride"] = 35.81, ["Fly|Ride"] = 84.5, ["Neon"] = 23.56, ["Neon|Ride"] = 48.67, ["Neon|Fly|Ride"] = 140.94, ["Mega"] = 157.5, ["Mega|Fly"] = 268.68, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 283.5}},
    ["rbxassetid://97556530589327"] = {name = "Bison", prices = {["default"] = 2.1, ["Ride"] = 126.76, ["Fly|Ride"] = 99.29, ["Neon"] = 5.25, ["Neon|Fly"] = 84.63, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 157.95, ["Mega"] = 32.75, ["Mega|Ride"] = 91.34, ["Mega|Fly|Ride"] = 629.39}},
    ["rbxassetid://11694855214"] = {name = "Shetland Pony Dark Brown", prices = {["default"] = 2.1, ["Fly"] = 24.62, ["Ride"] = 19.03, ["Fly|Ride"] = 65.54, ["Neon"] = 6.3, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 84.99, ["Mega"] = 78.98, ["Mega|Ride"] = 85.22, ["Mega|Fly|Ride"] = 157.31}},
    ["rbxassetid://14398823196"] = {name = "Alpaca", prices = {["default"] = 721.88, ["Ride"] = 704.33, ["Fly|Ride"] = 743.16, ["Neon"] = 3337.65, ["Neon|Ride"] = 3018.75, ["Neon|Fly|Ride"] = 4200.13, ["Mega|Fly|Ride"] = 12462.19}},
    ["rbxassetid://5721843716"] = {name = "Pterodactyl", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 16.78, ["Fly|Ride"] = 35.78, ["Neon"] = 23.16, ["Neon|Fly"] = 44.63, ["Neon|Ride"] = 56.83, ["Neon|Fly|Ride"] = 69.83, ["Mega"] = 189.36, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://82057257613990"] = {name = "Unicorn Ducky", prices = {["default"] = 2.97, ["Ride"] = 45.94, ["Fly|Ride"] = 105.51, ["Neon"] = 6.57, ["Neon|Fly"] = 844.98, ["Neon|Ride"] = 49.73, ["Neon|Fly|Ride"] = 341.25, ["Mega"] = 48.47, ["Mega|Ride"] = 107.63, ["Mega|Fly|Ride"] = 303.18}},
    ["rbxassetid://4708551366"] = {name = "Frog", prices = {["default"] = 13.13, ["Fly"] = 28.54, ["Ride"] = 23.51, ["Fly|Ride"] = 42, ["Neon"] = 49.88, ["Neon|Fly"] = 112.74, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 99.45, ["Mega"] = 312.05, ["Mega|Ride"] = 305.01, ["Mega|Fly|Ride"] = 335.99}},
    ["rbxassetid://4800189682"] = {name = "Starfish", prices = {["default"] = 2.1, ["Fly"] = 28.53, ["Ride"] = 15.85, ["Fly|Ride"] = 33.92, ["Neon"] = 8.97, ["Neon|Fly"] = 131.06, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 47.16, ["Mega"] = 61.69, ["Mega|Fly"] = 349.84, ["Mega|Ride"] = 98.55, ["Mega|Fly|Ride"] = 173.5}},
    ["rbxassetid://16736753854"] = {name = "Candy Cane Snail", prices = {["default"] = 49.85, ["Ride"] = 62.33, ["Neon"] = 282.02, ["Neon|Ride"] = 341.25, ["Neon|Fly|Ride"] = 360.94, ["Mega"] = 887.48, ["Mega|Fly"] = 987.95, ["Mega|Ride"] = 705.54}},
    ["rbxassetid://10393730410"] = {name = "Orca", prices = {["default"] = 2.1, ["Ride"] = 21.14, ["Fly|Ride"] = 88.74, ["Neon"] = 5.24, ["Neon|Ride"] = 28.25, ["Neon|Fly|Ride"] = 206.07, ["Mega"] = 63.66, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 351.75}},
    ["rbxassetid://111642509798043"] = {name = "Toxic Kaijunior", prices = {["default"] = 2.1, ["Fly"] = 73.5, ["Ride"] = 23.63, ["Fly|Ride"] = 61.28, ["Neon"] = 15.74, ["Neon|Fly"] = 141.24, ["Neon|Ride"] = 31.75, ["Neon|Fly|Ride"] = 452.73, ["Mega"] = 126.94, ["Mega|Ride"] = 294.47, ["Mega|Fly|Ride"] = 144.38}},
    ["rbxassetid://14146181621"] = {name = "Tawny Frogmouth", prices = {["default"] = 2.63, ["Fly"] = 26.25, ["Fly|Ride"] = 65.76, ["Neon"] = 15.75, ["Mega"] = 112.23}},
    ["rbxassetid://9474010501"] = {name = "Ribbon Seal", prices = {["default"] = 2.1, ["Fly"] = 2593.49, ["Ride"] = 20.08, ["Fly|Ride"] = 98.44, ["Neon"] = 3.93, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 94.4, ["Mega"] = 40.08, ["Mega|Fly"] = 156.56, ["Mega|Ride"] = 63.48, ["Mega|Fly|Ride"] = 131.18}},
    ["rbxassetid://6776872152"] = {name = "Red Squirrel", prices = {["default"] = 19.69, ["Fly"] = 21.05, ["Ride"] = 16.85, ["Fly|Ride"] = 40.69, ["Neon"] = 79.24, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 114.09, ["Mega"] = 846.21, ["Mega|Ride"] = 495.05, ["Mega|Fly|Ride"] = 426.8}},
    ["rbxassetid://84140820920420"] = {name = "Siamese Cat", prices = {["default"] = 784.88, ["Fly"] = 873.5, ["Ride"] = 735, ["Fly|Ride"] = 838.69, ["Neon"] = 1938.57, ["Neon|Ride"] = 2362.5, ["Neon|Fly|Ride"] = 1998.94, ["Mega|Ride"] = 5397, ["Mega|Fly|Ride"] = 5495.25}},
    ["rbxassetid://3181727773"] = {name = "Bunny", prices = {["default"] = 2.1, ["Fly"] = 19.03, ["Ride"] = 18.8, ["Fly|Ride"] = 41.88, ["Neon"] = 3.91, ["Neon|Fly"] = 70.94, ["Neon|Ride"] = 21.15, ["Neon|Fly|Ride"] = 57.14, ["Mega"] = 45.94, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 148.1}},
    ["rbxassetid://17120012859"] = {name = "Praying Mantis", prices = {["default"] = 6.27, ["Ride"] = 27.57, ["Fly|Ride"] = 92.18, ["Neon"] = 43.32, ["Neon|Ride"] = 115.5, ["Neon|Fly|Ride"] = 248.11, ["Mega"] = 268.68, ["Mega|Ride"] = 351.75, ["Mega|Fly|Ride"] = 454.13}},
    ["rbxassetid://4440866528"] = {name = "Turkey", prices = {["default"] = 52.5, ["Fly"] = 105.65, ["Ride"] = 86.63, ["Fly|Ride"] = 125.88, ["Neon"] = 361.31, ["Neon|Ride"] = 380.81, ["Neon|Fly|Ride"] = 1240.32, ["Mega"] = 1394.13, ["Mega|Ride"] = 1551.74, ["Mega|Fly|Ride"] = 1411.06}},
    ["rbxassetid://9287841987"] = {name = "Black Springer Spaniel", prices = {["default"] = 38.07, ["Ride"] = 49.88, ["Fly|Ride"] = 301.88, ["Neon"] = 320.25, ["Neon|Ride"] = 184.07, ["Neon|Fly|Ride"] = 197.81, ["Mega"] = 920.26, ["Mega|Ride"] = 719.29, ["Mega|Fly|Ride"] = 996.41}},
    ["rbxassetid://87613898139280"] = {name = "Ranger Beaver", prices = {["default"] = 13.13, ["Ride"] = 30.19, ["Fly|Ride"] = 141.52, ["Neon"] = 55.65, ["Neon|Ride"] = 93.19, ["Neon|Fly|Ride"] = 401.97, ["Mega"] = 296.19, ["Mega|Ride"] = 367.05, ["Mega|Fly|Ride"] = 360.94}},
    ["rbxassetid://88389663444803"] = {name = "Mirai Moth", prices = {["default"] = 28.44, ["Ride"] = 99.75, ["Neon"] = 72.19, ["Neon|Fly"] = 347.19, ["Neon|Ride"] = 361.9, ["Mega"] = 316.28, ["Mega|Ride"] = 340.74, ["Mega|Fly|Ride"] = 406.19}},
    ["rbxassetid://128469688002747"] = {name = "Moonlight Moth", prices = {["default"] = 26.04, ["Fly"] = 113.03, ["Ride"] = 94.13, ["Neon"] = 131.25, ["Neon|Ride"] = 119.54, ["Neon|Fly|Ride"] = 525, ["Mega"] = 656.25, ["Mega|Ride"] = 656.25, ["Mega|Fly|Ride"] = 843.29}},
    ["rbxassetid://13936753561"] = {name = "Dylan", prices = {["default"] = 15.63}},
    ["rbxassetid://10606175827"] = {name = "Koi Carp", prices = {["default"] = 5.38, ["Fly"] = 78.85, ["Ride"] = 31.69, ["Fly|Ride"] = 104.56, ["Neon"] = 40.69, ["Neon|Ride"] = 78.66, ["Neon|Fly|Ride"] = 177.72, ["Mega"] = 200.87, ["Mega|Fly"] = 235.74, ["Mega|Ride"] = 216.57, ["Mega|Fly|Ride"] = 289.84}},
    ["rbxassetid://84529929751558"] = {name = "Old King Coal", prices = {["default"] = 6.04, ["Ride"] = 47.07, ["Neon"] = 31.38, ["Mega"] = 350.66, ["Mega|Fly|Ride"] = 951.99}},
    ["rbxassetid://11706110842"] = {name = "Snowball Pet", prices = {["default"] = 59.07, ["Fly"] = 393.75, ["Ride"] = 85.32, ["Fly|Ride"] = 117.47, ["Neon"] = 272.69, ["Neon|Ride"] = 291.38, ["Neon|Fly|Ride"] = 337.97, ["Mega|Ride"] = 878.07, ["Mega|Fly|Ride"] = 818.6}},
    ["rbxassetid://6404812664"] = {name = "Ladybug", prices = {["default"] = 3.82, ["Fly"] = 24.3, ["Ride"] = 16.86, ["Fly|Ride"] = 39.38, ["Neon"] = 28.25, ["Neon|Fly"] = 70.79, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 77.12, ["Mega"] = 262.5, ["Mega|Fly"] = 423.11, ["Mega|Ride"] = 274.18, ["Mega|Fly|Ride"] = 244.13}},
    ["rbxassetid://95046891836017"] = {name = "Clover Cow", prices = {["default"] = 5.92, ["Fly"] = 84.51, ["Ride"] = 30.28, ["Fly|Ride"] = 72.19, ["Neon"] = 20.2, ["Neon|Ride"] = 50.78, ["Neon|Fly|Ride"] = 126.97, ["Mega"] = 140.22, ["Mega|Ride"] = 172.44, ["Mega|Fly|Ride"] = 252.45}},
    ["rbxassetid://123759251940984"] = {name = "Oakee Knight", prices = {["default"] = 2.1, ["Neon"] = 6.57, ["Neon|Ride"] = 201.57, ["Mega"] = 34.13, ["Mega|Ride"] = 79.19, ["Mega|Fly|Ride"] = 137.82}},
    ["rbxassetid://9287842106"] = {name = "Brown Springer Spaniel", prices = {["default"] = 39.37, ["Fly"] = 84.51, ["Ride"] = 48.57, ["Fly|Ride"] = 78.74, ["Neon"] = 282.02, ["Neon|Ride"] = 185.12, ["Neon|Fly|Ride"] = 282.43, ["Mega"] = 1128.64, ["Mega|Fly|Ride"] = 850.5}},
    ["rbxassetid://83890934284839"] = {name = "Zeopod", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 23.78, ["Neon"] = 7.35, ["Neon|Fly"] = 174.57, ["Neon|Ride"] = 70.89, ["Neon|Fly|Ride"] = 223.13, ["Mega"] = 141.75, ["Mega|Fly|Ride"] = 309.68}},
    ["rbxassetid://107096792267421"] = {name = "General Sheepdog", prices = {["default"] = 10.5, ["Ride"] = 44.38, ["Neon"] = 82.69, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 353.3, ["Mega"] = 288.75, ["Mega|Ride"] = 493.99, ["Mega|Fly|Ride"] = 498.75}},
    ["rbxassetid://5721844511"] = {name = "Woolly Mammoth", prices = {["default"] = 2.63, ["Ride"] = 16.7, ["Fly|Ride"] = 47.24, ["Neon"] = 19.95, ["Neon|Ride"] = 40.27, ["Neon|Fly|Ride"] = 78.21, ["Mega"] = 197.81, ["Mega|Ride"] = 232.98, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://8143039445"] = {name = "Summer Walrus", prices = {["default"] = 4.98, ["Fly"] = 52.5, ["Ride"] = 24.19, ["Fly|Ride"] = 65.63, ["Neon"] = 61.28, ["Neon|Ride"] = 141.75, ["Mega"] = 277.14, ["Mega|Ride"] = 247.53, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://136696735147963"] = {name = "Chilling Spider", prices = {["default"] = 3.83, ["Ride"] = 139.41, ["Neon"] = 28.29, ["Neon|Ride"] = 110.82, ["Mega"] = 70.89, ["Mega|Ride"] = 771.1}},
    ["rbxassetid://133768672320906"] = {name = "Catte", prices = {["default"] = 36.75, ["Ride"] = 91.88, ["Neon"] = 195.57, ["Neon|Ride"] = 294.07, ["Neon|Fly|Ride"] = 324.74, ["Mega"] = 1056.7, ["Mega|Ride"] = 1411.06, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://12139319231"] = {name = "Feesh", prices = {["default"] = 18.38, ["Ride"] = 281.98, ["Neon"] = 210, ["Neon|Ride"] = 184.07, ["Mega"] = 508.99, ["Mega|Fly|Ride"] = 570.29}},
    ["rbxassetid://13685039170"] = {name = "Lobster", prices = {["default"] = 7.87, ["Fly"] = 38.04, ["Ride"] = 63.61, ["Neon"] = 99.3, ["Neon|Ride"] = 393.75, ["Mega"] = 592.36, ["Mega|Ride"] = 557.45, ["Mega|Fly|Ride"] = 1692.42}},
    ["rbxassetid://87668315398037"] = {name = "Mecha R4BBIT", prices = {["default"] = 24.75, ["Ride"] = 76.27, ["Fly|Ride"] = 422.03, ["Neon"] = 141.56, ["Neon|Ride"] = 634.67, ["Mega"] = 781.7, ["Mega|Ride"] = 846.21, ["Mega|Fly|Ride"] = 959.39}},
    ["rbxassetid://120262676323297"] = {name = "Kelp Hunter", prices = {["default"] = 5.18, ["Neon"] = 42.33, ["Neon|Ride"] = 423.11, ["Mega"] = 240.12, ["Mega|Fly|Ride"] = 314.7}},
    ["rbxassetid://12403864254"] = {name = "Gorilla", prices = {["default"] = 2.1, ["Fly"] = 21.05, ["Ride"] = 15.85, ["Fly|Ride"] = 41.91, ["Neon"] = 5.92, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 137.82, ["Mega"] = 65.6, ["Mega|Ride"] = 89.25, ["Mega|Fly|Ride"] = 276.29}},
    ["rbxassetid://124908510040897"] = {name = "Mistletroll", prices = {["default"] = 6.57, ["Ride"] = 42.26, ["Fly|Ride"] = 91.9, ["Neon"] = 28.54, ["Neon|Fly"] = 70.89, ["Neon|Ride"] = 61.07, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 157.95, ["Mega|Ride"] = 184.75, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://11189235896"] = {name = "Persian Cat", prices = {["default"] = 2.1, ["Fly"] = 31.49, ["Ride"] = 17.05, ["Fly|Ride"] = 55.13, ["Neon"] = 5.2, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 84.63, ["Mega"] = 59.07, ["Mega|Ride"] = 52.41, ["Mega|Fly|Ride"] = 141.75}},
    ["rbxassetid://14457148635"] = {name = "Magma Snail", prices = {["default"] = 3.87, ["Fly"] = 131.25, ["Ride"] = 63.55, ["Fly|Ride"] = 99.3, ["Neon"] = 39.25, ["Neon|Ride"] = 98.44, ["Neon|Fly|Ride"] = 113.21, ["Mega"] = 222.14, ["Mega|Ride"] = 129.94, ["Mega|Fly|Ride"] = 471.45}},
    ["rbxassetid://11694853423"] = {name = "Shetland Pony White", prices = {["default"] = 5.25, ["Ride"] = 30.19, ["Fly|Ride"] = 103.69, ["Neon"] = 42.11, ["Neon|Ride"] = 97.76, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 235.74, ["Mega|Ride"] = 416.8, ["Mega|Fly|Ride"] = 942.89}},
    ["rbxassetid://4621220568"] = {name = "Rat", prices = {["default"] = 3.92, ["Ride"] = 23.18, ["Fly|Ride"] = 57.04, ["Neon"] = 19.69, ["Neon|Fly"] = 104.77, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 85.32, ["Mega"] = 221.95, ["Mega|Ride"] = 251.99, ["Mega|Fly|Ride"] = 372.33}},
    ["rbxassetid://8938702150"] = {name = "Pine Marten", prices = {["default"] = 2.45, ["Fly"] = 34.07, ["Ride"] = 20.08, ["Fly|Ride"] = 63.38, ["Neon"] = 19.79, ["Neon|Fly"] = 84.51, ["Neon|Ride"] = 42.32, ["Neon|Fly|Ride"] = 78.98, ["Mega"] = 138.58, ["Mega|Ride"] = 176.66, ["Mega|Fly|Ride"] = 314.7}},
    ["rbxassetid://120359009390464"] = {name = "Turtle Doves", prices = {["default"] = 4.99, ["Fly"] = 26.25, ["Ride"] = 61.26, ["Neon"] = 20.89, ["Neon|Fly"] = 436.94, ["Neon|Ride"] = 99.45, ["Neon|Fly|Ride"] = 141.82, ["Mega"] = 102.96, ["Mega|Ride"] = 150.65, ["Mega|Fly|Ride"] = 311.16}},
    ["rbxassetid://71032455578324"] = {name = "Chihuahua", prices = {["default"] = 18.38, ["Fly"] = 105, ["Ride"] = 84.15, ["Fly|Ride"] = 273, ["Neon"] = 101.07, ["Neon|Ride"] = 141.75, ["Neon|Fly|Ride"] = 486.59, ["Mega"] = 367.5, ["Mega|Ride"] = 440.9, ["Mega|Fly|Ride"] = 536.26}},
    ["rbxassetid://11505487641"] = {name = "Ram", prices = {["default"] = 53.82, ["Ride"] = 95.06, ["Fly|Ride"] = 157.65, ["Neon"] = 259.88, ["Neon|Ride"] = 286.13, ["Neon|Fly|Ride"] = 372.69, ["Mega"] = 1050, ["Mega|Ride"] = 918.75, ["Mega|Fly|Ride"] = 976.07}},
    ["rbxassetid://117821626163847"] = {name = "Chanekeh", prices = {["default"] = 2.1, ["Ride"] = 25.36, ["Fly|Ride"] = 65.54, ["Neon"] = 3.68, ["Neon|Ride"] = 37.95, ["Neon|Fly|Ride"] = 58.35, ["Mega"] = 27.03, ["Mega|Ride"] = 71.14, ["Mega|Fly|Ride"] = 111.57}},
    ["rbxassetid://14266737982"] = {name = "Cassowary", prices = {["default"] = 15.57, ["Neon"] = 282.02, ["Mega"] = 423.11, ["Mega|Fly|Ride"] = 1269.32}},
    ["rbxassetid://13693650831"] = {name = "Leopard Shark", prices = {["default"] = 56.44, ["Fly"] = 105, ["Ride"] = 116.82, ["Neon"] = 276.94, ["Neon|Ride"] = 341.25, ["Neon|Fly|Ride"] = 417.83, ["Mega|Ride"] = 1975.89, ["Mega|Fly|Ride"] = 1269.32}},
    ["rbxassetid://100909868233186"] = {name = "Kappakid", prices = {["default"] = 41.21, ["Fly"] = 190.32, ["Ride"] = 42, ["Fly|Ride"] = 126, ["Neon"] = 40.69, ["Neon|Ride"] = 77.44, ["Neon|Fly|Ride"] = 211.56, ["Mega"] = 206.54, ["Mega|Ride"] = 210, ["Mega|Fly|Ride"] = 394.42}},
    ["rbxassetid://127061844219486"] = {name = "Patchy Bear", prices = {["default"] = 2.1, ["Fly"] = 23.25, ["Ride"] = 19.69, ["Fly|Ride"] = 80.29, ["Neon"] = 6.57, ["Neon|Fly"] = 40.2, ["Neon|Ride"] = 31.49, ["Mega"] = 32.51, ["Mega|Ride"] = 54.76, ["Mega|Fly|Ride"] = 152.22}},
    ["rbxassetid://6998402749"] = {name = "Merhorse", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 20.04, ["Fly|Ride"] = 49.2, ["Neon"] = 15.65, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 141.75, ["Mega"] = 156.56, ["Mega|Fly"] = 353.3, ["Mega|Ride"] = 198.68, ["Mega|Fly|Ride"] = 240.12}},
    ["rbxassetid://3181727196"] = {name = "Beaver", prices = {["default"] = 2.1, ["Fly"] = 19.03, ["Ride"] = 15.81, ["Fly|Ride"] = 35.93, ["Neon"] = 2.63, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 57.14, ["Mega"] = 34.13, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 155.93}},
    ["rbxassetid://10377935981"] = {name = "Badger", prices = {["default"] = 2.1, ["Ride"] = 23.25, ["Fly|Ride"] = 65.7, ["Neon"] = 3.92, ["Neon|Ride"] = 28.58, ["Neon|Fly|Ride"] = 84.63, ["Mega"] = 37.58, ["Mega|Fly"] = 168, ["Mega|Ride"] = 64.32, ["Mega|Fly|Ride"] = 180.32}},
    ["rbxassetid://118143096743818"] = {name = "Granny Wolf", prices = {["default"] = 2.1, ["Ride"] = 52.5, ["Neon"] = 2.61, ["Neon|Ride"] = 126.27, ["Mega"] = 17.59, ["Mega|Ride"] = 105.78, ["Mega|Fly|Ride"] = 258.12}},
    ["rbxassetid://18819382634"] = {name = "Singularity Beetle", prices = {["default"] = 10.4, ["Ride"] = 31.4, ["Fly|Ride"] = 262.5, ["Neon"] = 40.14, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 209.45, ["Mega"] = 197.81, ["Mega|Ride"] = 231, ["Mega|Fly|Ride"] = 331.42}},
    ["rbxassetid://13664716167"] = {name = "Ostrich", prices = {["default"] = 11.52, ["Ride"] = 35.35, ["Fly|Ride"] = 257.71, ["Neon"] = 103.06, ["Neon|Ride"] = 61.71, ["Neon|Fly|Ride"] = 234.6, ["Mega"] = 301.88, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://3710822879"] = {name = "Penguin", prices = {["default"] = 5.91, ["Fly"] = 24.05, ["Ride"] = 20.94, ["Fly|Ride"] = 47.14, ["Neon"] = 45.32, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 42.32, ["Neon|Fly|Ride"] = 74.8, ["Mega|Ride"] = 334.69, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://12778628745"] = {name = "Chef Gorilla", prices = {["default"] = 96.37, ["Ride"] = 144.37, ["Fly|Ride"] = 262.5, ["Neon"] = 538.13, ["Neon|Ride"] = 997.5, ["Mega"] = 3143.34, ["Mega|Fly|Ride"] = 1555.97}},
    ["rbxassetid://138841259551372"] = {name = "Vermilion Butterfly", prices = {["default"] = 25.8, ["Fly"] = 72.43, ["Ride"] = 41.91, ["Fly|Ride"] = 59.07, ["Neon"] = 92.98, ["Mega"] = 564.85, ["Mega|Ride"] = 617.54, ["Mega|Fly|Ride"] = 1033.6}},
    ["rbxassetid://3181727125"] = {name = "Snow Puma", prices = {["default"] = 2.1, ["Fly"] = 17.93, ["Ride"] = 15.64, ["Fly|Ride"] = 36.71, ["Neon"] = 3.15, ["Neon|Fly"] = 28.58, ["Neon|Ride"] = 21.16, ["Neon|Fly|Ride"] = 47.16, ["Mega|Ride"] = 94.65, ["Mega|Fly|Ride"] = 143.88}},
    ["rbxassetid://3181728160"] = {name = "Shiba Inu", prices = {["default"] = 2.1, ["Fly"] = 15.65, ["Ride"] = 15.81, ["Fly|Ride"] = 31.69, ["Neon"] = 4.09, ["Neon|Fly"] = 23.4, ["Neon|Ride"] = 21.16, ["Neon|Fly|Ride"] = 37.03, ["Mega"] = 47.25, ["Mega|Ride"] = 55.02, ["Mega|Fly|Ride"] = 95.01}},
    ["rbxassetid://3261465893"] = {name = "Blue Dog", prices = {["default"] = 397.68, ["Ride"] = 428.75, ["Fly|Ride"] = 481.69, ["Neon|Ride"] = 1749.29, ["Neon|Fly|Ride"] = 1509.38}},
    ["rbxassetid://15504846154"] = {name = "Eggnog Hare", prices = {["default"] = 15.31, ["Ride"] = 196.45, ["Fly|Ride"] = 118.13, ["Neon"] = 78.7, ["Mega"] = 440.04, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 1268.26}},
    ["rbxassetid://4708551244"] = {name = "Dingo", prices = {["default"] = 2.1, ["Fly"] = 34.13, ["Ride"] = 15.85, ["Fly|Ride"] = 39.38, ["Neon"] = 5.92, ["Neon|Fly"] = 28.5, ["Neon|Ride"] = 20.74, ["Neon|Fly|Ride"] = 39.11, ["Mega"] = 43.32, ["Mega|Ride"] = 40.69, ["Mega|Fly|Ride"] = 102.27}},
    ["rbxassetid://140434791311540"] = {name = "French Bulldog", prices = {["default"] = 68.23, ["Ride"] = 126.76, ["Fly|Ride"] = 315, ["Neon"] = 242.82, ["Neon|Ride"] = 303.14, ["Neon|Fly|Ride"] = 366.19, ["Mega"] = 735.05, ["Mega|Ride"] = 740.43, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://5067924710"] = {name = "Monkey", prices = {["default"] = 2.1, ["Fly"] = 19.03, ["Ride"] = 19.03, ["Fly|Ride"] = 46.33, ["Neon"] = 13.13, ["Neon|Fly"] = 91.9, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 70.7, ["Mega"] = 75.21, ["Mega|Fly"] = 160.13, ["Mega|Ride"] = 108.57, ["Mega|Fly|Ride"] = 204.38}},
    ["rbxassetid://73677246948616"] = {name = "Black Tiger", prices = {["default"] = 2.1, ["Fly"] = 70.79, ["Ride"] = 57.04, ["Fly|Ride"] = 1312.5, ["Neon"] = 2.63, ["Neon|Ride"] = 28.88, ["Neon|Fly|Ride"] = 283.19, ["Mega"] = 18.38, ["Mega|Fly"] = 126.94, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 224.25}},
    ["rbxassetid://17662893972"] = {name = "Pretty Pony", prices = {["default"] = 57.05, ["Fly"] = 141, ["Ride"] = 99.75, ["Fly|Ride"] = 281.98, ["Neon"] = 174.56, ["Neon|Ride"] = 250.76, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 1263.47, ["Mega|Ride"] = 446.25, ["Mega|Fly|Ride"] = 797.7}},
    ["rbxassetid://16722908853"] = {name = "Dotted Eggy", prices = {["default"] = 2.1, ["Ride"] = 20.01, ["Fly|Ride"] = 39.38, ["Neon"] = 5.24, ["Neon|Ride"] = 55.02, ["Mega"] = 98.98, ["Mega|Ride"] = 121.73, ["Mega|Fly|Ride"] = 144.38}},
    ["rbxassetid://3409443896"] = {name = "Wild Boar", prices = {["default"] = 38.72, ["Fly"] = 78.85, ["Ride"] = 56.37, ["Neon"] = 266.18, ["Neon|Ride"] = 196.76, ["Neon|Fly|Ride"] = 395.61, ["Mega|Ride"] = 1580.3, ["Mega|Fly|Ride"] = 987.95}},
    ["rbxassetid://12432807176"] = {name = "Possum", prices = {["default"] = 10.58, ["Fly|Ride"] = 211.23, ["Neon"] = 42, ["Neon|Ride"] = 203.44, ["Mega"] = 175.88, ["Mega|Ride"] = 603.75, ["Mega|Fly|Ride"] = 551.92}},
    ["rbxassetid://94550121082603"] = {name = "Lionfish", prices = {["default"] = 3.62, ["Fly"] = 70.79, ["Ride"] = 70.76, ["Fly|Ride"] = 65.63, ["Neon"] = 7.88, ["Neon|Fly"] = 78.17, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 108.47, ["Mega"] = 78.75, ["Mega|Ride"] = 721.88, ["Mega|Fly|Ride"] = 564.85}},
    ["rbxassetid://15096097714"] = {name = "Evil Rock", prices = {["default"] = 31.49, ["Ride"] = 55.69, ["Fly|Ride"] = 104.81, ["Neon|Ride"] = 131.25, ["Mega|Ride"] = 1128.64, ["Mega|Fly|Ride"] = 1112.77}},
    ["rbxassetid://117664495619345"] = {name = "Fire Foal", prices = {["default"] = 2.1, ["Fly"] = 144.82, ["Ride"] = 40.03, ["Fly|Ride"] = 908.98, ["Neon"] = 6.57, ["Neon|Ride"] = 25.95, ["Neon|Fly|Ride"] = 162.91, ["Mega"] = 39.38, ["Mega|Fly"] = 158.61, ["Mega|Ride"] = 121.66, ["Mega|Fly|Ride"] = 262.34}},
    ["rbxassetid://8938701683"] = {name = "Red Cardinal", prices = {["default"] = 2.1, ["Fly"] = 56.81, ["Ride"] = 28.43, ["Fly|Ride"] = 102.85, ["Neon"] = 5.92, ["Neon|Fly"] = 41.88, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 84.63, ["Mega"] = 105.78, ["Mega|Fly|Ride"] = 282.43}},
    ["rbxassetid://12489700965"] = {name = "Tarsier", prices = {["default"] = 19.69, ["Ride"] = 45.68, ["Fly|Ride"] = 188.24, ["Neon"] = 77.18, ["Neon|Ride"] = 120.75, ["Mega"] = 311.07, ["Mega|Ride"] = 471.45, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://11765322595"] = {name = "Gingerbread Reindeer", prices = {["default"] = 39.38, ["Ride"] = 67.6, ["Fly|Ride"] = 112.12, ["Neon"] = 203.36, ["Neon|Fly"] = 274.63, ["Neon|Ride"] = 289.84, ["Neon|Fly|Ride"] = 353.99, ["Mega"] = 656.24, ["Mega|Ride"] = 630.97, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://16382424275"] = {name = "Nautilus", prices = {["default"] = 27.57, ["Fly"] = 28.88, ["Ride"] = 35.38, ["Fly|Ride"] = 77.44, ["Neon"] = 103.58, ["Neon|Ride"] = 70.89, ["Neon|Fly|Ride"] = 141.75, ["Mega"] = 620.57, ["Mega|Ride"] = 388.5, ["Mega|Fly|Ride"] = 342.97}},
    ["rbxassetid://93997399823425"] = {name = "Chocolate Dutch Guinea Pig", prices = {["default"] = 72.19, ["Fly"] = 96.49, ["Ride"] = 132.54, ["Fly|Ride"] = 196.85, ["Neon"] = 272.98, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 555.19, ["Mega"] = 1336.54, ["Mega|Ride"] = 1273.13, ["Mega|Fly|Ride"] = 1180.88}},
    ["rbxassetid://75866760046580"] = {name = "Skelebat", prices = {["default"] = 3.94, ["Ride"] = 26.25, ["Fly|Ride"] = 288.75, ["Neon"] = 23.56, ["Neon|Ride"] = 58.8, ["Neon|Fly|Ride"] = 305.76, ["Mega"] = 105, ["Mega|Ride"] = 156.56, ["Mega|Fly|Ride"] = 314.7}},
    ["rbxassetid://111661922676557"] = {name = "Momma Moose", prices = {["default"] = 6.57, ["Ride"] = 23.16, ["Fly|Ride"] = 103.69, ["Neon"] = 23.51, ["Neon|Ride"] = 49.88, ["Mega"] = 139.63, ["Mega|Ride"] = 282.43}},
    ["rbxassetid://17059860310"] = {name = "Elasmosaurus", prices = {["default"] = 15.86, ["Fly"] = 28.88, ["Ride"] = 44.01, ["Fly|Ride"] = 98.95, ["Neon"] = 70.79, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 169.25, ["Mega"] = 282.43, ["Mega|Ride"] = 374.46, ["Mega|Fly|Ride"] = 450.19}},
    ["rbxassetid://10306934599"] = {name = "Camel", prices = {["default"] = 2.1, ["Fly"] = 15.74, ["Ride"] = 14.02, ["Fly|Ride"] = 31.4, ["Neon"] = 2.1, ["Neon|Fly"] = 17.05, ["Neon|Ride"] = 15.75, ["Neon|Fly|Ride"] = 31.5, ["Mega"] = 15.65, ["Mega|Fly"] = 70.89, ["Mega|Ride"] = 23.51, ["Mega|Fly|Ride"] = 118.13}},
    ["rbxassetid://13104107016"] = {name = "Puffer Fish", prices = {["default"] = 47.25, ["Fly"] = 78.17, ["Ride"] = 105, ["Fly|Ride"] = 303.01, ["Neon"] = 231.78, ["Neon|Fly"] = 2394.46, ["Neon|Ride"] = 293.99, ["Neon|Fly|Ride"] = 341.25, ["Mega"] = 846.21, ["Mega|Ride"] = 807.19, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://17183022910"] = {name = "Mole", prices = {["default"] = 2.1, ["Ride"] = 16.96, ["Fly|Ride"] = 109.87, ["Neon"] = 5.96, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 40.08, ["Mega|Fly|Ride"] = 211.56}},
    ["rbxassetid://5721844051"] = {name = "Stegosaurus", prices = {["default"] = 2.1, ["Fly"] = 28.3, ["Ride"] = 19.69, ["Fly|Ride"] = 56.88, ["Neon"] = 13.13, ["Neon|Fly"] = 141.56, ["Neon|Ride"] = 32.44, ["Neon|Fly|Ride"] = 57.14, ["Mega"] = 157.5, ["Mega|Ride"] = 395.61, ["Mega|Fly|Ride"] = 281.04}},
    ["rbxassetid://114921997566126"] = {name = "S'mores Raccoon", prices = {["default"] = 78.72, ["Ride"] = 116.82, ["Fly|Ride"] = 429.84, ["Neon"] = 310.24, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 510.57, ["Mega"] = 1019.82, ["Mega|Ride"] = 917.44, ["Mega|Fly|Ride"] = 1009.32}},
    ["rbxassetid://93038040448121"] = {name = "Nurse Shark", prices = {["default"] = 2.1, ["Ride"] = 42.26, ["Neon"] = 6.35, ["Neon|Ride"] = 42.75, ["Mega"] = 40.69, ["Mega|Ride"] = 126.02, ["Mega|Fly|Ride"] = 160.79}},
    ["rbxassetid://13936750528"] = {name = "River", prices = {["default"] = 13.77}},
    ["rbxassetid://103142927308458"] = {name = "Black-Footed Ferret", prices = {["default"] = 2.1, ["Ride"] = 28.53, ["Fly|Ride"] = 321.9, ["Neon"] = 8.3, ["Neon|Ride"] = 31.84, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 46.56, ["Mega|Ride"] = 105.78, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://3199974219"] = {name = "Pet Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13803784751"] = {name = "Happy Clam", prices = {["default"] = 115.5, ["Ride"] = 181.36, ["Fly|Ride"] = 211.23, ["Neon"] = 538.13, ["Neon|Ride"] = 649.47, ["Neon|Fly|Ride"] = 670.63, ["Mega|Fly|Ride"] = 2680.36}},
    ["rbxassetid://13665210525"] = {name = "Warthog", prices = {["default"] = 3.94, ["Ride"] = 26.25, ["Neon"] = 69.44, ["Neon|Ride"] = 61.69, ["Mega"] = 165.37, ["Mega|Ride"] = 313.82, ["Mega|Fly|Ride"] = 423.11}},
    ["rbxassetid://18515939072"] = {name = "Black Marlin", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Neon"] = 3.29, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 45.42, ["Mega|Ride"] = 99.45, ["Mega|Fly|Ride"] = 141.75}},
    ["rbxassetid://16075008092"] = {name = "Fanghorn Tortoise", prices = {["default"] = 5.16, ["Ride"] = 30.61, ["Neon"] = 51.1, ["Neon|Ride"] = 113.21, ["Neon|Fly|Ride"] = 156.56, ["Mega"] = 421, ["Mega|Ride"] = 564.85, ["Mega|Fly|Ride"] = 629.39}},
    ["rbxassetid://8566684181"] = {name = "Giant Black Scarab", prices = {["default"] = 15.8, ["Fly"] = 19.69, ["Ride"] = 20, ["Fly|Ride"] = 157.5, ["Neon"] = 79.79, ["Neon|Ride"] = 102.56, ["Neon|Fly|Ride"] = 146.16, ["Mega"] = 459.38, ["Mega|Ride"] = 405.57, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://118691035196137"] = {name = "Shiver Wolf", prices = {["default"] = 41.89, ["Neon"] = 170.62, ["Neon|Ride"] = 260.23, ["Neon|Fly|Ride"] = 480.23, ["Mega"] = 700.25, ["Mega|Ride"] = 551.25, ["Mega|Fly|Ride"] = 654.94}},
    ["rbxassetid://3743735223"] = {name = "Brown Bear", prices = {["default"] = 141.75, ["Fly"] = 144.38, ["Ride"] = 158.82, ["Fly|Ride"] = 203.44, ["Neon"] = 538.12, ["Neon|Ride"] = 498.75, ["Neon|Fly|Ride"] = 551.25, ["Mega|Fly|Ride"] = 2100}},
    ["rbxassetid://3934251801"] = {name = "Sloth", prices = {["default"] = 10.49, ["Fly"] = 19.66, ["Ride"] = 18.38, ["Fly|Ride"] = 39.29, ["Neon"] = 39.38, ["Neon|Fly"] = 423.11, ["Neon|Ride"] = 53.43, ["Neon|Fly|Ride"] = 91.88, ["Mega|Ride"] = 564.85, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://12139338880"] = {name = "Frogspawn", prices = {["default"] = 3.83, ["Fly"] = 131.23, ["Ride"] = 17.67, ["Fly|Ride"] = 131.25, ["Neon"] = 27.02, ["Neon|Ride"] = 35.69, ["Neon|Fly|Ride"] = 192.95, ["Mega"] = 137.82, ["Mega|Fly|Ride"] = 423.11}},
    ["rbxassetid://8070926551"] = {name = "Snow Leopard", prices = {["default"] = 21, ["Fly"] = 210, ["Ride"] = 42, ["Neon"] = 104.25, ["Neon|Ride"] = 137.52, ["Mega"] = 380.63, ["Mega|Ride"] = 451.18, ["Mega|Fly|Ride"] = 649.47}},
    ["rbxassetid://76712147705770"] = {name = "Tuxedo Cat", prices = {["default"] = 45.93, ["Fly"] = 113.03, ["Ride"] = 74.82, ["Fly|Ride"] = 211.23, ["Neon"] = 225.17, ["Neon|Ride"] = 223.13, ["Neon|Fly|Ride"] = 279.57, ["Mega"] = 905.63, ["Mega|Ride"] = 918.75, ["Mega|Fly|Ride"] = 863.46}},
    ["rbxassetid://15685468962"] = {name = "Tasmanian Devil", prices = {["default"] = 22.32, ["Ride"] = 81.86, ["Neon"] = 141.56, ["Neon|Ride"] = 126.62, ["Mega"] = 643.13, ["Mega|Ride"] = 739.38, ["Mega|Fly|Ride"] = 987.95}},
    ["rbxassetid://123288277753363"] = {name = "Tri-horned Treehopper", prices = {["default"] = 301.87, ["Ride"] = 390.81, ["Neon"] = 2394.46, ["Neon|Ride"] = 1115.63, ["Neon|Fly|Ride"] = 1014.4, ["Mega|Fly|Ride"] = 4217.27}},
    ["rbxassetid://6060987821"] = {name = "Yeti", prices = {["default"] = 35.94, ["Fly"] = 65.63, ["Ride"] = 34.62, ["Fly|Ride"] = 63.38, ["Neon"] = 197.53, ["Neon|Ride"] = 216.92, ["Neon|Fly|Ride"] = 326.16, ["Mega"] = 984.38, ["Mega|Ride"] = 891.19, ["Mega|Fly|Ride"] = 829.29}},
    ["rbxassetid://9549841158"] = {name = "Zebra", prices = {["default"] = 2.1, ["Fly"] = 28.53, ["Ride"] = 15.75, ["Fly|Ride"] = 28.41, ["Neon"] = 2.63, ["Neon|Ride"] = 16.96, ["Neon|Fly|Ride"] = 55.04, ["Mega"] = 22.1, ["Mega|Fly"] = 107.91, ["Mega|Ride"] = 44.44, ["Mega|Fly|Ride"] = 103.86}},
    ["rbxassetid://13883282884"] = {name = "Hermit Crab", prices = {["default"] = 2.1, ["Ride"] = 211.23, ["Neon"] = 21.1, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 126.94, ["Mega"] = 141.75, ["Mega|Fly"] = 124.69, ["Mega|Ride"] = 223.13, ["Mega|Fly|Ride"] = 373.42}},
    ["rbxassetid://92626539723202"] = {name = "Sea Angel", prices = {["default"] = 5.93, ["Ride"] = 28.43, ["Fly|Ride"] = 129.94, ["Neon"] = 14.84, ["Neon|Ride"] = 78.26, ["Neon|Fly|Ride"] = 156.56, ["Mega"] = 121.28, ["Mega|Fly"] = 240.12, ["Mega|Ride"] = 282.43, ["Mega|Fly|Ride"] = 235.74}},
    ["rbxassetid://15848329383"] = {name = "Jellyfish", prices = {["default"] = 354.38, ["Fly"] = 628.28, ["Ride"] = 380.63, ["Fly|Ride"] = 491.88, ["Neon"] = 1549.49, ["Neon|Ride"] = 1603.12, ["Neon|Fly|Ride"] = 1413.4, ["Mega|Fly|Ride"] = 4865.66}},
    ["rbxassetid://5721843846"] = {name = "Sabertooth", prices = {["default"] = 3.94, ["Fly"] = 47.59, ["Ride"] = 19.47, ["Fly|Ride"] = 42.21, ["Neon"] = 24.94, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 63.66, ["Mega|Ride"] = 255.94, ["Mega|Fly|Ride"] = 423.11}},
    ["rbxassetid://9475753090"] = {name = "Albatross", prices = {["default"] = 4.97, ["Fly"] = 31.7, ["Ride"] = 21.19, ["Fly|Ride"] = 39.38, ["Neon"] = 28.53, ["Neon|Ride"] = 57.14, ["Neon|Fly|Ride"] = 169.25, ["Mega"] = 423.11, ["Mega|Ride"] = 705.54, ["Mega|Fly|Ride"] = 226.38}},
    ["rbxassetid://96894173636082"] = {name = "Clementine Owl", prices = {["default"] = 6.55, ["Fly"] = 35.94, ["Ride"] = 27.4, ["Fly|Ride"] = 65.63, ["Neon"] = 17.07, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 120.74, ["Mega"] = 119.39, ["Mega|Ride"] = 196.87, ["Mega|Fly|Ride"] = 313.52}},
    ["rbxassetid://10318105683"] = {name = "Orange Butterfly", prices = {["default"] = 45.91, ["Fly"] = 66.55, ["Ride"] = 69.74, ["Fly|Ride"] = 59.07, ["Neon"] = 118.13, ["Neon|Fly"] = 145.78, ["Neon|Ride"] = 184.07, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 951.99, ["Mega|Ride"] = 844.1, ["Mega|Fly|Ride"] = 627.58}},
    ["rbxassetid://15937689999"] = {name = "Rattlesnake", prices = {["default"] = 2.1, ["Fly"] = 31.35, ["Ride"] = 28.2, ["Fly|Ride"] = 52.9, ["Neon"] = 18.38, ["Neon|Ride"] = 114.19, ["Neon|Fly|Ride"] = 210, ["Mega"] = 137.82, ["Mega|Ride"] = 176.66, ["Mega|Fly|Ride"] = 820.98}},
    ["rbxassetid://10971808447"] = {name = "Evil Basilisk", prices = {["default"] = 5.25, ["Fly"] = 104.15, ["Ride"] = 24.1, ["Fly|Ride"] = 91.88, ["Neon"] = 153.04, ["Neon|Ride"] = 105.32, ["Mega"] = 705.54, ["Mega|Ride"] = 599.82, ["Mega|Fly|Ride"] = 826.88}},
    ["rbxassetid://99104623628550"] = {name = "Snorgle", prices = {["default"] = 2.1, ["Ride"] = 22.32, ["Fly|Ride"] = 40.69, ["Neon"] = 3.67, ["Neon|Fly"] = 38.07, ["Neon|Ride"] = 15.81, ["Mega"] = 36.75, ["Mega|Ride"] = 120.95, ["Mega|Fly|Ride"] = 282.43}},
    ["rbxassetid://136705425555561"] = {name = "Emperor Shrimp", prices = {["default"] = 9.6, ["Ride"] = 57.04, ["Neon"] = 59.07, ["Mega"] = 315.23, ["Mega|Fly|Ride"] = 846.21}},
    ["rbxassetid://14398819258"] = {name = "Longhorn Cow", prices = {["default"] = 14.43, ["Ride"] = 70.96, ["Fly|Ride"] = 190.13, ["Neon"] = 80.51, ["Mega"] = 316.32, ["Mega|Ride"] = 556.39, ["Mega|Fly|Ride"] = 497.16}},
    ["rbxassetid://4708551284"] = {name = "Koala", prices = {["default"] = 9.09, ["Fly"] = 33.81, ["Ride"] = 27.54, ["Fly|Ride"] = 49.96, ["Neon"] = 28.88, ["Neon|Fly"] = 70.56, ["Neon|Ride"] = 59.05, ["Neon|Fly|Ride"] = 98.34, ["Mega"] = 409.37, ["Mega|Ride"] = 375.38, ["Mega|Fly|Ride"] = 357.27}},
    ["rbxassetid://4115249264"] = {name = "Zombie Buffalo", prices = {["default"] = 190.16, ["Fly"] = 205.24, ["Ride"] = 196.79, ["Fly|Ride"] = 225.06, ["Neon"] = 861.89, ["Neon|Ride"] = 870.55, ["Neon|Fly|Ride"] = 850.95, ["Mega|Fly|Ride"] = 4203.52}},
    ["rbxassetid://8939633862"] = {name = "Salamander", prices = {["default"] = 2.1, ["Fly"] = 21.14, ["Ride"] = 16.91, ["Fly|Ride"] = 63.56, ["Neon"] = 12.39, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 114.85, ["Mega"] = 220.5, ["Mega|Ride"] = 165.02, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://7734902431"] = {name = "Halloween White Mummy Cat", prices = {["default"] = 3.94, ["Fly"] = 31.7, ["Ride"] = 31.69, ["Fly|Ride"] = 103.78, ["Neon"] = 16.96, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 166.69, ["Mega"] = 232.36, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 418.88}},
    ["rbxassetid://115869632070663"] = {name = "Snowball Pug", prices = {["default"] = 42.26, ["Fly"] = 126, ["Ride"] = 99.6, ["Fly|Ride"] = 367.5, ["Neon"] = 152.81, ["Neon|Ride"] = 204.67, ["Neon|Fly|Ride"] = 469.88, ["Mega"] = 393.75, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 522.64}},
    ["rbxassetid://8077189379"] = {name = "Husky", prices = {["default"] = 83.68, ["Fly"] = 142.02, ["Ride"] = 123.36, ["Fly|Ride"] = 261.09, ["Neon"] = 518.62, ["Neon|Ride"] = 471.52, ["Neon|Fly|Ride"] = 466.48, ["Mega"] = 1692.42, ["Mega|Ride"] = 1396.24, ["Mega|Fly|Ride"] = 1406.82}},
    ["rbxassetid://98003529163435"] = {name = "Maine Coon", prices = {["default"] = 38.04, ["Ride"] = 100.34, ["Neon"] = 91.87, ["Neon|Ride"] = 150.93, ["Neon|Fly|Ride"] = 297.49, ["Mega"] = 249.38, ["Mega|Ride"] = 321.42, ["Mega|Fly|Ride"] = 439.24}},
    ["rbxassetid://12488273089"] = {name = "Yellow-lipped Sea Krait", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 16.22, ["Fly|Ride"] = 46.97, ["Neon"] = 15.86, ["Neon|Fly|Ride"] = 59.07, ["Mega"] = 57.46, ["Mega|Ride"] = 184.07, ["Mega|Fly|Ride"] = 252}},
    ["rbxassetid://96760582519875"] = {name = "Cozy Mistletroll", prices = {["default"] = 13.71, ["Ride"] = 42.26, ["Fly|Ride"] = 9154.22, ["Neon"] = 65.63, ["Neon|Fly|Ride"] = 301.88, ["Mega"] = 209.48, ["Mega|Ride"] = 272.86, ["Mega|Fly|Ride"] = 446.25}},
    ["rbxassetid://85229142142232"] = {name = "Bunny Swirl", prices = {["default"] = 73.5, ["Ride"] = 117.87, ["Fly|Ride"] = 168.99, ["Neon"] = 196.88, ["Neon|Ride"] = 262.53, ["Neon|Fly|Ride"] = 400.32, ["Mega"] = 433.12, ["Mega|Ride"] = 498.75, ["Mega|Fly|Ride"] = 504}},
    ["rbxassetid://121192022038625"] = {name = "Stygian Owl", prices = {["default"] = 2.63, ["Ride"] = 120.41, ["Neon"] = 7.03, ["Neon|Fly"] = 28.53, ["Neon|Ride"] = 104.76, ["Neon|Fly|Ride"] = 141.75, ["Mega"] = 49.88, ["Mega|Fly"] = 162.91, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 395.61}},
    ["rbxassetid://83732262844708"] = {name = "Pain au Chat", prices = {["default"] = 11.82, ["Ride"] = 47.07, ["Neon"] = 36.99, ["Neon|Ride"] = 629.47, ["Mega"] = 373.28, ["Mega|Fly|Ride"] = 603.75}},
    ["rbxassetid://12792506715"] = {name = "Goose", prices = {["default"] = 977.81, ["Fly"] = 1242.43, ["Ride"] = 1124.67, ["Fly|Ride"] = 1115.63, ["Neon"] = 3274.28, ["Neon|Ride"] = 3384.82, ["Neon|Fly|Ride"] = 3001.19, ["Mega|Fly|Ride"] = 11090.63}},
    ["rbxassetid://12779257292"] = {name = "Pudding Cat", prices = {["default"] = 34.13, ["Ride"] = 98.86, ["Neon"] = 210.55, ["Neon|Ride"] = 531.57, ["Mega"] = 550.05, ["Mega|Ride"] = 573.76, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://83376259738301"] = {name = "Mrs. Whiskerpips", prices = {["default"] = 8.43, ["Fly"] = 49.12, ["Ride"] = 35.44, ["Fly|Ride"] = 99.75, ["Neon"] = 21.2, ["Neon|Fly"] = 157.5, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 94.5, ["Mega"] = 78.7, ["Mega|Ride"] = 126.94, ["Mega|Fly|Ride"] = 289.84}},
    ["rbxassetid://110894046614323"] = {name = "Partridge", prices = {["default"] = 14.39, ["Ride"] = 131.22, ["Neon"] = 106.32, ["Neon|Ride"] = 156.56, ["Mega|Ride"] = 433.13}},
    ["rbxassetid://114034119324343"] = {name = "Muskrat", prices = {["default"] = 2.1, ["Fly"] = 21.14, ["Ride"] = 22.37, ["Fly|Ride"] = 422.5, ["Neon"] = 2.1, ["Neon|Ride"] = 27.2, ["Neon|Fly|Ride"] = 94.8, ["Mega"] = 19.69, ["Mega|Fly"] = 125.89, ["Mega|Ride"] = 52.41, ["Mega|Fly|Ride"] = 207.34}},
    ["rbxassetid://15547904644"] = {name = "Harp Seal", prices = {["default"] = 85.32, ["Ride"] = 130.77, ["Fly|Ride"] = 344.3, ["Neon"] = 297.42, ["Neon|Ride"] = 343.8, ["Mega"] = 1100.14, ["Mega|Ride"] = 996.18, ["Mega|Fly|Ride"] = 1049.9}},
    ["rbxassetid://14978702254"] = {name = "Scarecrow Cat", prices = {["default"] = 4.75, ["Fly"] = 101.07, ["Ride"] = 52.5, ["Fly|Ride"] = 84.5, ["Neon"] = 35.17, ["Neon|Ride"] = 84.63, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 353.3, ["Mega|Ride"] = 294.79, ["Mega|Fly|Ride"] = 367.05}},
    ["rbxassetid://95871612352029"] = {name = "Cold Cube", prices = {["default"] = 4.91, ["Fly"] = 65.63, ["Ride"] = 26.25, ["Neon"] = 11.82, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 141.75, ["Mega"] = 78.29, ["Mega|Ride"] = 231.67, ["Mega|Fly|Ride"] = 235.74}},
    ["rbxassetid://114456035353449"] = {name = "Bauble Buddies", prices = {["default"] = 57.75, ["Ride"] = 97.13, ["Fly|Ride"] = 166.87, ["Neon"] = 170.63, ["Neon|Fly"] = 280.65, ["Neon|Ride"] = 233.36, ["Neon|Fly|Ride"] = 634.67, ["Mega"] = 535.5, ["Mega|Ride"] = 512.01, ["Mega|Fly|Ride"] = 730.92}},
    ["rbxassetid://15383967605"] = {name = "Gingerbread Mouse", prices = {["default"] = 23.55, ["Fly"] = 57.05, ["Ride"] = 72.19, ["Fly|Ride"] = 196.88, ["Neon"] = 98.44, ["Neon|Ride"] = 211.56, ["Neon|Fly|Ride"] = 315, ["Mega"] = 624.75, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 1090.46}},
    ["rbxassetid://11767069383"] = {name = "Woolly Rhino", prices = {["default"] = 49.23, ["Ride"] = 99.29, ["Neon"] = 774.38, ["Neon|Ride"] = 564.85, ["Neon|Fly|Ride"] = 952.23, ["Mega"] = 2468.81, ["Mega|Ride"] = 1819.35, ["Mega|Fly|Ride"] = 2115.51}},
    ["rbxassetid://95133623103638"] = {name = "Samoyed", prices = {["default"] = 10.5, ["Ride"] = 63.54, ["Neon"] = 30.19, ["Neon|Ride"] = 139.63, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 86.63, ["Mega|Ride"] = 133.88, ["Mega|Fly|Ride"] = 282.87}},
    ["rbxassetid://8071236757"] = {name = "St Bernard", prices = {["default"] = 8.95, ["Fly"] = 33.81, ["Ride"] = 21, ["Fly|Ride"] = 57.04, ["Neon"] = 58.87, ["Neon|Ride"] = 82.69, ["Neon|Fly|Ride"] = 150.21, ["Mega"] = 399, ["Mega|Ride"] = 392.44, ["Mega|Fly|Ride"] = 471.81}},
    ["rbxassetid://14276930615"] = {name = "Alley Cat", prices = {["default"] = 140.44, ["Ride"] = 171.94, ["Fly|Ride"] = 236.25, ["Neon"] = 537.34, ["Neon|Fly"] = 633.74, ["Neon|Ride"] = 538.31, ["Neon|Fly|Ride"] = 518.44, ["Mega|Fly"] = 2821.03, ["Mega|Ride"] = 2115.51, ["Mega|Fly|Ride"] = 1785}},
    ["rbxassetid://6498256417"] = {name = "Dolphin", prices = {["default"] = 2.63, ["Fly"] = 18.83, ["Ride"] = 16.91, ["Fly|Ride"] = 39.82, ["Neon"] = 12.34, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 27.19, ["Neon|Fly|Ride"] = 77.35, ["Mega"] = 140.44, ["Mega|Ride"] = 152.81, ["Mega|Fly|Ride"] = 210.51}},
    ["rbxassetid://7734900468"] = {name = "Halloween White Skeleton Dog", prices = {["default"] = 5.39, ["Fly"] = 87.94, ["Ride"] = 23.62, ["Fly|Ride"] = 67.6, ["Neon"] = 35.44, ["Neon|Fly"] = 281.17, ["Neon|Ride"] = 51.16, ["Neon|Fly|Ride"] = 125.89, ["Mega"] = 220.5, ["Mega|Ride"] = 205.22, ["Mega|Fly|Ride"] = 288.98}},
    ["rbxassetid://9982202041"] = {name = "Poodle", prices = {["default"] = 2.1, ["Ride"] = 15.96, ["Fly|Ride"] = 35.7, ["Neon"] = 2.63, ["Neon|Fly"] = 17.64, ["Neon|Ride"] = 15.81, ["Neon|Fly|Ride"] = 48.57, ["Mega"] = 15.73, ["Mega|Ride"] = 31.49, ["Mega|Fly|Ride"] = 91.95}},
    ["rbxassetid://73671766703168"] = {name = "Pilot Gull", prices = {["default"] = 2.1, ["Fly"] = 21.14, ["Ride"] = 31.69, ["Neon"] = 3.93, ["Neon|Fly"] = 42.26, ["Neon|Ride"] = 42.32, ["Mega"] = 18.75, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 64.32, ["Mega|Fly|Ride"] = 141.75}},
    ["rbxassetid://14146127209"] = {name = "Indian Leopard", prices = {["default"] = 3.63, ["Fly"] = 131.25, ["Ride"] = 27.47, ["Fly|Ride"] = 45.94, ["Neon"] = 15.1, ["Neon|Ride"] = 92.54, ["Mega"] = 134.34, ["Mega|Ride"] = 152.3}},
    ["rbxassetid://113558592714438"] = {name = "Seabed Creeper", prices = {["default"] = 61.07, ["Ride"] = 84, ["Neon"] = 239.77, ["Neon|Ride"] = 451.5, ["Neon|Fly|Ride"] = 630, ["Mega"] = 564.85, ["Mega|Ride"] = 564.85, ["Mega|Fly|Ride"] = 663.23}},
    ["rbxassetid://4281674713"] = {name = "Bee", prices = {["default"] = 3.15, ["Fly"] = 16.75, ["Ride"] = 17.07, ["Fly|Ride"] = 39.38, ["Neon"] = 11.64, ["Neon|Fly"] = 32.29, ["Neon|Ride"] = 28.88, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 91.49, ["Mega|Fly"] = 164.06, ["Mega|Ride"] = 113.21, ["Mega|Fly|Ride"] = 173.25}},
    ["rbxassetid://5862774392"] = {name = "Bat", prices = {["default"] = 3.68, ["Fly"] = 26.24, ["Ride"] = 25.55, ["Fly|Ride"] = 45.94, ["Neon"] = 13.02, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 35.7, ["Neon|Fly|Ride"] = 78.59, ["Mega"] = 126.29, ["Mega|Fly"] = 433.13, ["Mega|Ride"] = 131.24, ["Mega|Fly|Ride"] = 212.19}},
    ["rbxassetid://18223359092"] = {name = "Birthday Butterfly 2024", prices = {["default"] = 3.78, ["Fly"] = 19.59, ["Ride"] = 19.69, ["Fly|Ride"] = 26.25, ["Neon"] = 8.49, ["Neon|Fly"] = 47.09, ["Neon|Ride"] = 23.59, ["Neon|Fly|Ride"] = 105.63, ["Mega"] = 41.27, ["Mega|Ride"] = 59.06, ["Mega|Fly|Ride"] = 106.13}},
    ["rbxassetid://17822765706"] = {name = "Pink Betta Fish", prices = {["default"] = 7.88, ["Fly"] = 280.97, ["Ride"] = 24.85, ["Neon"] = 23.63, ["Neon|Ride"] = 84.63, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 289.84, ["Mega|Fly"] = 400.32, ["Mega|Ride"] = 267.41, ["Mega|Fly|Ride"] = 629.39}},
    ["rbxassetid://14146174264"] = {name = "Rock Pigeon", prices = {["default"] = 7.86, ["Fly"] = 160.7, ["Ride"] = 66, ["Fly|Ride"] = 169.01, ["Neon"] = 99.48, ["Neon|Ride"] = 78.75, ["Mega"] = 408.99, ["Mega|Ride"] = 564.85, ["Mega|Fly|Ride"] = 1057.76}},
    ["rbxassetid://11758575946"] = {name = "Water Moon Bear", prices = {["default"] = 6.57, ["Fly"] = 35.44, ["Ride"] = 21.14, ["Fly|Ride"] = 47.25, ["Neon"] = 26.25, ["Neon|Fly"] = 196.65, ["Neon|Ride"] = 63.48, ["Neon|Fly|Ride"] = 126.14, ["Mega"] = 141.75, ["Mega|Ride"] = 240.12, ["Mega|Fly|Ride"] = 345.9}},
    ["rbxassetid://6498256132"] = {name = "Seahorse", prices = {["default"] = 2.1, ["Fly"] = 20.98, ["Ride"] = 16.85, ["Fly|Ride"] = 52.5, ["Neon"] = 23.63, ["Neon|Fly"] = 37.03, ["Neon|Ride"] = 42.32, ["Neon|Fly|Ride"] = 67.72, ["Mega"] = 157.95, ["Mega|Ride"] = 234.55}},
    ["rbxassetid://13664973582"] = {name = "Many Mackerel", prices = {["default"] = 187.69, ["Fly"] = 393.75, ["Ride"] = 223.07, ["Fly|Ride"] = 305.82, ["Neon"] = 983.35, ["Neon|Ride"] = 846.21, ["Neon|Fly|Ride"] = 1179.94, ["Mega|Ride"] = 3527.62, ["Mega|Fly|Ride"] = 3173.27}},
    ["rbxassetid://114806716799554"] = {name = "Ringmaster Gibbon", prices = {["default"] = 4.66, ["Ride"] = 38.72, ["Neon"] = 30.85, ["Neon|Fly|Ride"] = 282.43, ["Mega"] = 123.38, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 493.99}},
    ["rbxassetid://14360917588"] = {name = "Magma Moose", prices = {["default"] = 3.23, ["Ride"] = 19.09, ["Fly|Ride"] = 118.13, ["Neon"] = 8.46, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 36.02, ["Neon|Fly|Ride"] = 139.65, ["Mega"] = 197.81, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 1178.62}},
    ["rbxassetid://18957942216"] = {name = "Starhopper", prices = {["default"] = 6.57, ["Fly|Ride"] = 157.7, ["Neon"] = 42.26, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 157.95, ["Mega"] = 469.82, ["Mega|Ride"] = 865.11, ["Mega|Fly|Ride"] = 1033.6}},
    ["rbxassetid://3181727071"] = {name = "Puma", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 15.81, ["Fly|Ride"] = 26.25, ["Neon"] = 2.1, ["Neon|Fly"] = 21.14, ["Neon|Ride"] = 15.74, ["Neon|Fly|Ride"] = 31.49, ["Mega"] = 28.41, ["Mega|Ride"] = 34.19, ["Mega|Fly|Ride"] = 82.51}},
    ["rbxassetid://4841039508"] = {name = "Rock", prices = {["default"] = 5.16, ["Fly"] = 56.37, ["Ride"] = 24.05, ["Fly|Ride"] = 56.44, ["Neon"] = 13.13, ["Neon|Fly"] = 42.32, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 83.22, ["Mega"] = 130.58, ["Mega|Ride"] = 102.38, ["Mega|Fly|Ride"] = 216.57}},
    ["rbxassetid://94235745630523"] = {name = "Rainbow Trout", prices = {["default"] = 5.57, ["Ride"] = 54.93, ["Fly|Ride"] = 77.44, ["Neon"] = 15.86, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 68.54, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 190.41}},
    ["rbxassetid://4440867249"] = {name = "Llama", prices = {["default"] = 70.56, ["Fly"] = 102.37, ["Ride"] = 106.91, ["Fly|Ride"] = 149.46, ["Neon"] = 564.03, ["Neon|Ride"] = 401.97, ["Neon|Fly|Ride"] = 455.44, ["Mega|Ride"] = 3527.62, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://11571113805"] = {name = "Bloodhound", prices = {["default"] = 6.45, ["Fly"] = 99.3, ["Ride"] = 33.69, ["Fly|Ride"] = 65.63, ["Neon"] = 23.16, ["Neon|Ride"] = 57.14, ["Mega"] = 215.8, ["Mega|Ride"] = 209.65, ["Mega|Fly|Ride"] = 670.63}},
    ["rbxassetid://78423968285099"] = {name = "Wren", prices = {["default"] = 2.1, ["Fly"] = 31.7, ["Ride"] = 52.5, ["Fly|Ride"] = 164.78, ["Neon"] = 4.24, ["Neon|Ride"] = 57.14, ["Neon|Fly|Ride"] = 169.25, ["Mega"] = 78.29, ["Mega|Fly"] = 412.54, ["Mega|Ride"] = 99.45, ["Mega|Fly|Ride"] = 240.12}},
    ["rbxassetid://110871792705214"] = {name = "Burger Bear", prices = {["default"] = 57.74, ["Fly"] = 124.69, ["Ride"] = 97.13, ["Fly|Ride"] = 236.25, ["Neon"] = 121.48, ["Neon|Ride"] = 141.75, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 555.26, ["Mega|Ride"] = 759.48, ["Mega|Fly|Ride"] = 564.38}},
    ["rbxassetid://3181727637"] = {name = "Fennec Fox", prices = {["default"] = 2.1, ["Fly"] = 16.94, ["Ride"] = 12.71, ["Fly|Ride"] = 35.93, ["Neon"] = 2.1, ["Neon|Fly"] = 38.07, ["Neon|Ride"] = 15.75, ["Neon|Fly|Ride"] = 35.98, ["Mega"] = 23.63, ["Mega|Fly"] = 42.32, ["Mega|Ride"] = 38.27, ["Mega|Fly|Ride"] = 70.88}},
    ["rbxassetid://115530716039589"] = {name = "Milk Choccybunny", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 6.35, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 71.1, ["Mega"] = 32.81, ["Mega|Fly"] = 126.94, ["Mega|Ride"] = 87.94, ["Mega|Fly|Ride"] = 174.48}},
    ["rbxassetid://83001092186817"] = {name = "White Choccybunny", prices = {["default"] = 3.94, ["Ride"] = 107.63, ["Neon"] = 11.46, ["Neon|Ride"] = 93.1, ["Neon|Fly|Ride"] = 197.81, ["Mega"] = 70.53, ["Mega|Ride"] = 138.33, ["Mega|Fly|Ride"] = 296.19}},
    ["rbxassetid://103795616446776"] = {name = "Waffle Wyrm", prices = {["default"] = 7.77, ["Fly"] = 57.75, ["Ride"] = 39.38, ["Fly|Ride"] = 104.56, ["Neon"] = 17.07, ["Neon|Fly"] = 129.94, ["Neon|Ride"] = 71.61, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 103.67, ["Mega|Fly"] = 220.5, ["Mega|Ride"] = 164.26, ["Mega|Fly|Ride"] = 282.87}},
    ["rbxassetid://9982358951"] = {name = "Orangutan", prices = {["default"] = 2.1, ["Fly"] = 15.74, ["Ride"] = 15.12, ["Fly|Ride"] = 36.49, ["Neon"] = 2.1, ["Neon|Fly"] = 28.26, ["Neon|Ride"] = 39.37, ["Neon|Fly|Ride"] = 42.32, ["Mega"] = 18.98, ["Mega|Ride"] = 42.32, ["Mega|Fly|Ride"] = 141.75}},
    ["rbxassetid://129021417712364"] = {name = "Kage Crow", prices = {["default"] = 11.78, ["Ride"] = 42.11, ["Fly|Ride"] = 200.08, ["Neon"] = 70.88, ["Neon|Ride"] = 167.14, ["Neon|Fly|Ride"] = 196.23, ["Mega"] = 281.38, ["Mega|Ride"] = 492.93, ["Mega|Fly|Ride"] = 282.43}},
    ["rbxassetid://4849941238"] = {name = "Hedgehog", prices = {["default"] = 2493.75, ["Fly"] = 3011.29, ["Ride"] = 2625, ["Fly|Ride"] = 2677.5, ["Neon|Fly"] = 9518.72, ["Neon|Fly|Ride"] = 9318.75, ["Mega|Fly|Ride"] = 42310.04}},
    ["rbxassetid://4800190144"] = {name = "Ginger Cat", prices = {["default"] = 2.1, ["Fly"] = 28.53, ["Ride"] = 19.79, ["Fly|Ride"] = 46.49, ["Neon"] = 5.25, ["Neon|Fly"] = 68.99, ["Neon|Ride"] = 21.24, ["Neon|Fly|Ride"] = 53.82, ["Mega"] = 73.48, ["Mega|Fly"] = 141.75, ["Mega|Ride"] = 93.57, ["Mega|Fly|Ride"] = 141.75}},
    ["rbxassetid://18119333909"] = {name = "Rodeo Bull", prices = {["default"] = 5.25, ["Fly|Ride"] = 74.82, ["Neon"] = 13.13, ["Mega"] = 70.89, ["Mega|Ride"] = 437.07, ["Mega|Fly|Ride"] = 634.67}},
    ["rbxassetid://11837080223"] = {name = "Highland Cow", prices = {["default"] = 23.12, ["Ride"] = 30.35, ["Fly|Ride"] = 157.5, ["Neon"] = 80.61, ["Neon|Ride"] = 196.76, ["Neon|Fly|Ride"] = 190.32, ["Mega"] = 471.45, ["Mega|Ride"] = 397.69, ["Mega|Fly|Ride"] = 360.94}},
    ["rbxassetid://14398816006"] = {name = "Rooster", prices = {["default"] = 38.06, ["Ride"] = 78.75, ["Neon"] = 150.93, ["Neon|Ride"] = 389.27, ["Neon|Fly|Ride"] = 423.11, ["Mega"] = 540.75, ["Mega|Ride"] = 729.57, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://3409444089"] = {name = "Hyena", prices = {["default"] = 144.26, ["Fly"] = 282.02, ["Ride"] = 202.43, ["Fly|Ride"] = 203.44, ["Neon"] = 589.38, ["Neon|Fly"] = 656.25, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 747.05, ["Mega"] = 6346.52, ["Mega|Ride"] = 3032.58, ["Mega|Fly|Ride"] = 2362.5}},
    ["rbxassetid://127067345833475"] = {name = "Hummingbird", prices = {["default"] = 7.77, ["Ride"] = 52.5, ["Fly|Ride"] = 675.94, ["Neon"] = 19.48, ["Neon|Fly"] = 70.79, ["Neon|Ride"] = 104.9, ["Neon|Fly|Ride"] = 105.78, ["Mega"] = 223.13, ["Mega|Fly"] = 177.98, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 235.74}},
    ["rbxassetid://130497948875084"] = {name = "Marabou Stork", prices = {["default"] = 2.1, ["Ride"] = 52.5, ["Neon"] = 7.87, ["Neon|Fly"] = 99.3, ["Neon|Ride"] = 42.32, ["Neon|Fly|Ride"] = 527.83, ["Mega"] = 99.45, ["Mega|Ride"] = 261.03, ["Mega|Fly|Ride"] = 838}},
    ["rbxassetid://127017727552531"] = {name = "Angus Calf", prices = {["default"] = 3.83, ["Fly"] = 101.99, ["Ride"] = 35.31, ["Fly|Ride"] = 131.25, ["Neon"] = 12.46, ["Neon|Ride"] = 44.63, ["Mega"] = 84, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 268.68}},
    ["rbxassetid://12779130089"] = {name = "Sprout Snail", prices = {["default"] = 9.75, ["Fly|Ride"] = 656.25, ["Neon"] = 173.23, ["Neon|Ride"] = 1165.81, ["Neon|Fly|Ride"] = 253.87, ["Mega"] = 504.69, ["Mega|Ride"] = 423.11, ["Mega|Fly|Ride"] = 629.39}},
    ["rbxassetid://117824155556510"] = {name = "Princess Mare", prices = {["default"] = 2.1, ["Ride"] = 70.79, ["Neon"] = 2.1, ["Neon|Ride"] = 57.66, ["Mega"] = 18.38, ["Mega|Ride"] = 56.44, ["Mega|Fly|Ride"] = 338.49}},
    ["rbxassetid://122766274014139"] = {name = "Gaelic Fae", prices = {["default"] = 78.73, ["Ride"] = 126.75, ["Fly|Ride"] = 137.82, ["Neon"] = 323.23, ["Neon|Ride"] = 409.5, ["Neon|Fly|Ride"] = 418.69, ["Mega"] = 1365, ["Mega|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 1411.06}},
    ["rbxassetid://17255807019"] = {name = "Weevil", prices = {["default"] = 2.1, ["Ride"] = 32.63, ["Neon"] = 6.36, ["Neon|Ride"] = 104.73, ["Mega"] = 47.16, ["Mega|Ride"] = 141.1}},
    ["rbxassetid://3743720235"] = {name = "Capybara", prices = {["default"] = 45.94, ["Fly"] = 220.03, ["Ride"] = 62.55, ["Fly|Ride"] = 99.29, ["Neon"] = 295.32, ["Neon|Ride"] = 367.5, ["Neon|Fly|Ride"] = 561.6, ["Mega"] = 2625, ["Mega|Ride"] = 1269.32, ["Mega|Fly|Ride"] = 1256.07}},
    ["rbxassetid://106815320234576"] = {name = "Ehecatl", prices = {["default"] = 2.1, ["Fly"] = 33.81, ["Ride"] = 52.5, ["Fly|Ride"] = 42.26, ["Neon"] = 3.94, ["Neon|Fly"] = 121.48, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 94.5, ["Mega"] = 41.7, ["Mega|Ride"] = 69.83, ["Mega|Fly|Ride"] = 123.98}},
    ["rbxassetid://110449571836616"] = {name = "Irish Setter", prices = {["default"] = 3.34, ["Ride"] = 47.6, ["Neon"] = 11.69, ["Neon|Ride"] = 118.13, ["Mega"] = 76.13, ["Mega|Ride"] = 168.2, ["Mega|Fly|Ride"] = 423.11}},
    ["rbxassetid://93751644677101"] = {name = "Winter Doe", prices = {["default"] = 15.75, ["Ride"] = 52.5, ["Fly|Ride"] = 210.2, ["Neon"] = 78.17, ["Neon|Fly|Ride"] = 423.11, ["Mega"] = 205.29, ["Mega|Ride"] = 288.75, ["Mega|Fly|Ride"] = 564.85}},
    ["rbxassetid://90667836208550"] = {name = "Munchkin Cat", prices = {["default"] = 399, ["Ride"] = 434.7, ["Fly|Ride"] = 511.14, ["Neon"] = 1115.63, ["Neon|Ride"] = 1299.36, ["Neon|Fly|Ride"] = 1415.4, ["Mega"] = 4402.37, ["Mega|Ride"] = 3885, ["Mega|Fly|Ride"] = 3675}},
    ["rbxassetid://3743734696"] = {name = "Rhino", prices = {["default"] = 34.13, ["Fly"] = 57.05, ["Ride"] = 49.88, ["Fly|Ride"] = 64.32, ["Neon"] = 139.44, ["Neon|Fly"] = 314.24, ["Neon|Ride"] = 165.02, ["Neon|Fly|Ride"] = 210.51, ["Mega"] = 697.08, ["Mega|Fly|Ride"] = 861.03}},
    ["rbxassetid://7734928397"] = {name = "Halloween Blue Scorpion", prices = {["default"] = 2.1, ["Fly"] = 25.36, ["Ride"] = 19.14, ["Fly|Ride"] = 40.15, ["Neon"] = 6.57, ["Neon|Fly"] = 85.32, ["Neon|Ride"] = 28.58, ["Neon|Fly|Ride"] = 97.02, ["Mega"] = 74.05, ["Mega|Ride"] = 70.89, ["Mega|Fly|Ride"] = 448.5}},
    ["rbxassetid://116859365721104"] = {name = "Shadow Dragon Ducky", prices = {["default"] = 10.43, ["Fly"] = 72.17, ["Ride"] = 36.12, ["Fly|Ride"] = 105, ["Neon"] = 47.25, ["Neon|Fly"] = 197.53, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 171.49, ["Mega"] = 227.07, ["Mega|Fly"] = 393.3, ["Mega|Ride"] = 270.01, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://6060991084"] = {name = "Musk Ox", prices = {["default"] = 9.71, ["Ride"] = 28.88, ["Fly|Ride"] = 70.79, ["Neon"] = 84, ["Neon|Ride"] = 122.72, ["Mega|Ride"] = 471.45, ["Mega|Fly|Ride"] = 350.14}},
    ["rbxassetid://119284351481681"] = {name = "Violet Friend", prices = {["default"] = 4.23, ["Neon"] = 17.07, ["Neon|Fly|Ride"] = 169.25, ["Mega"] = 52.5, ["Mega|Ride"] = 128.63, ["Mega|Fly|Ride"] = 406.88}},
    ["rbxassetid://10971808356"] = {name = "Basilisk", prices = {["default"] = 2.61, ["Fly"] = 86.63, ["Ride"] = 19.08, ["Fly|Ride"] = 69.71, ["Neon"] = 19.69, ["Neon|Ride"] = 42.32, ["Neon|Fly|Ride"] = 215.8, ["Mega"] = 550.43, ["Mega|Ride"] = 486.94, ["Mega|Fly|Ride"] = 493.99}},
    ["rbxassetid://3744706727"] = {name = "Platypus", prices = {["default"] = 105.65, ["Fly"] = 131.25, ["Ride"] = 105.65, ["Fly|Ride"] = 183.75, ["Neon"] = 535.52, ["Neon|Ride"] = 493.99, ["Neon|Fly|Ride"] = 607.17, ["Mega"] = 2509, ["Mega|Ride"] = 2567.18, ["Mega|Fly|Ride"] = 3006.14}},
    ["rbxassetid://12480556316"] = {name = "Black Macaque", prices = {["default"] = 40.15, ["Fly"] = 95.82, ["Ride"] = 78.17, ["Fly|Ride"] = 155.87, ["Neon"] = 192.94, ["Neon|Ride"] = 184.07, ["Mega"] = 704.48, ["Mega|Ride"] = 603.75, ["Mega|Fly|Ride"] = 689.73}},
    ["rbxassetid://4849941000"] = {name = "Dalmatian", prices = {["default"] = 2362.5, ["Fly"] = 2349.23, ["Ride"] = 2165.63, ["Fly|Ride"] = 2313.94, ["Neon"] = 12674.6, ["Neon|Fly|Ride"] = 7615.82, ["Mega|Fly|Ride"] = 26250}},
    ["rbxassetid://139319822015938"] = {name = "Sea Skeleton Panda", prices = {["default"] = 2.63, ["Fly"] = 65625, ["Ride"] = 41.89, ["Fly|Ride"] = 170.63, ["Neon"] = 11.82, ["Neon|Ride"] = 55.97, ["Neon|Fly|Ride"] = 169.32, ["Mega"] = 105, ["Mega|Ride"] = 167.35, ["Mega|Fly|Ride"] = 423.11}},
    ["rbxassetid://104838807480936"] = {name = "Winter Fawn", prices = {["default"] = 14.44, ["Ride"] = 156.32, ["Fly|Ride"] = 156.32, ["Neon"] = 58.99, ["Neon|Ride"] = 110.82, ["Neon|Fly|Ride"] = 248.07, ["Mega"] = 255.94, ["Mega|Ride"] = 417.83, ["Mega|Fly|Ride"] = 562.17}},
    ["rbxassetid://100705885132301"] = {name = "Cabbit", prices = {["default"] = 853.13, ["Fly"] = 1409.01, ["Ride"] = 840, ["Fly|Ride"] = 997.5, ["Neon"] = 2598.75, ["Neon|Ride"] = 2821.88, ["Neon|Fly|Ride"] = 2756.25, ["Mega|Fly|Ride"] = 12112.68}},
    ["rbxassetid://12480406935"] = {name = "Binturong", prices = {["default"] = 49.88, ["Ride"] = 66.09, ["Fly|Ride"] = 262.5, ["Neon"] = 250.3, ["Neon|Ride"] = 291.72, ["Mega"] = 656.25, ["Mega|Ride"] = 804.56, ["Mega|Fly|Ride"] = 685.43}},
    ["rbxassetid://73245262062822"] = {name = "Prism Snake", prices = {["default"] = 2.63, ["Ride"] = 23.63, ["Fly|Ride"] = 64.32, ["Neon"] = 15.74, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 133.29, ["Mega|Fly|Ride"] = 280.88}},
    ["rbxassetid://113717425344888"] = {name = "Magpie", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Neon"] = 2.63, ["Neon|Ride"] = 52.41, ["Mega"] = 27.57, ["Mega|Fly"] = 52.89, ["Mega|Ride"] = 69.83, ["Mega|Fly|Ride"] = 134.34}},
    ["rbxassetid://10318105900"] = {name = "Purple Butterfly", prices = {["default"] = 99.45, ["Ride"] = 125.99, ["Fly|Ride"] = 141.56, ["Neon"] = 459.38, ["Neon|Fly|Ride"] = 544.69, ["Mega"] = 5250, ["Mega|Fly|Ride"] = 2678.24}},
    ["rbxassetid://95049698731940"] = {name = "Throwback Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15503941919"] = {name = "Arctic Hare", prices = {["default"] = 6.57, ["Neon"] = 24.35, ["Neon|Ride"] = 141.75, ["Mega"] = 291.96, ["Mega|Ride"] = 312.05}},
    ["rbxassetid://10274421272"] = {name = "Royal Corgi", prices = {["default"] = 77.41, ["Ride"] = 138.83, ["Neon"] = 514.39, ["Neon|Ride"] = 452.73, ["Mega"] = 1834.16, ["Mega|Fly|Ride"] = 1726.33}},
    ["rbxassetid://13978968837"] = {name = "Bird of Paradise", prices = {["default"] = 8.38, ["Fly"] = 105, ["Fly|Ride"] = 91.88, ["Neon"] = 33.16, ["Neon|Fly|Ride"] = 315, ["Mega"] = 226.38, ["Mega|Fly|Ride"] = 282.43}},
    ["rbxassetid://3261465850"] = {name = "Pink Cat", prices = {["default"] = 254.48, ["Ride"] = 284.26, ["Fly|Ride"] = 328.13, ["Neon"] = 949.55, ["Neon|Fly"] = 1100.97, ["Neon|Ride"] = 1045.08, ["Neon|Fly|Ride"] = 896.57, ["Mega|Fly|Ride"] = 4048.03}},
    ["rbxassetid://8969010905"] = {name = "Red Fox", prices = {["default"] = 6.02, ["Fly"] = 87.71, ["Ride"] = 21.14, ["Fly|Ride"] = 99.65, ["Neon"] = 35.94, ["Neon|Ride"] = 37.03, ["Neon|Fly|Ride"] = 104.96, ["Mega"] = 229.68, ["Mega|Ride"] = 294.07, ["Mega|Fly|Ride"] = 441.69}},
    ["rbxassetid://3181728128"] = {name = "Red Panda", prices = {["default"] = 2.1, ["Fly"] = 18.14, ["Ride"] = 15.74, ["Fly|Ride"] = 34.13, ["Neon"] = 3.94, ["Neon|Fly"] = 36.99, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 42.37, ["Mega"] = 39.38, ["Mega|Fly"] = 104.87, ["Mega|Ride"] = 45.94, ["Mega|Fly|Ride"] = 111.57}},
    ["rbxassetid://13077769577"] = {name = "Pelican", prices = {["default"] = 790.13, ["Fly"] = 1176.54, ["Ride"] = 903, ["Fly|Ride"] = 1029.26, ["Neon|Ride"] = 4950.8, ["Neon|Fly|Ride"] = 4231.02, ["Mega"] = 28286.41, ["Mega|Fly|Ride"] = 28207.06}},
    ["rbxassetid://115281603518501"] = {name = "DJ Snooze", prices = {["default"] = 9.72, ["Fly"] = 986.52, ["Ride"] = 210, ["Neon"] = 39.38, ["Neon|Ride"] = 70.19, ["Mega"] = 151.09, ["Mega|Ride"] = 216.87, ["Mega|Fly|Ride"] = 370.79}},
    ["rbxassetid://111847888001946"] = {name = "Choco Penguin", prices = {["default"] = 11.82, ["Fly"] = 32.82, ["Ride"] = 52.83, ["Neon"] = 21.25, ["Neon|Fly"] = 105.65, ["Neon|Ride"] = 60.21, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 162.91, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 282.34}},
    ["rbxassetid://4621220487"] = {name = "Panda", prices = {["default"] = 32.42, ["Fly"] = 34.13, ["Ride"] = 36.75, ["Fly|Ride"] = 47.25, ["Neon|Ride"] = 116.82, ["Neon|Fly|Ride"] = 150.94, ["Mega"] = 2115.51, ["Mega|Fly|Ride"] = 740.86}},
    ["rbxassetid://12917347184"] = {name = "Flower Power Duckling", prices = {["default"] = 13.71, ["Fly"] = 79.24, ["Ride"] = 26.25, ["Fly|Ride"] = 86.63, ["Neon"] = 53.76, ["Neon|Ride"] = 79, ["Neon|Fly|Ride"] = 156.56, ["Mega"] = 393.5, ["Mega|Ride"] = 376.69, ["Mega|Fly|Ride"] = 443.63}},
    ["rbxassetid://93775555430694"] = {name = "Pumpkin Friend", prices = {["default"] = 23.63, ["Ride"] = 210, ["Fly|Ride"] = 131.25, ["Neon"] = 87.94, ["Neon|Ride"] = 211.56, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 448.5, ["Mega|Ride"] = 465.43, ["Mega|Fly|Ride"] = 588}},
    ["rbxassetid://83317902236850"] = {name = "Kakapo", prices = {["default"] = 2.1, ["Ride"] = 116.59, ["Fly|Ride"] = 235.28, ["Neon"] = 2.63, ["Neon|Ride"] = 33.71, ["Mega"] = 21.16, ["Mega|Fly"] = 84.88, ["Mega|Ride"] = 141.75}},
    ["rbxassetid://5862774043"] = {name = "Ghost Bunny", prices = {["default"] = 32.82, ["Fly"] = 39.38, ["Ride"] = 45.93, ["Fly|Ride"] = 89.25, ["Neon"] = 131.25, ["Neon|Fly"] = 307.38, ["Neon|Ride"] = 236.24, ["Neon|Fly|Ride"] = 242.82, ["Mega"] = 3384.82, ["Mega|Fly|Ride"] = 990.18}},
    ["rbxassetid://10639131895"] = {name = "Spider Crab", prices = {["default"] = 3.93, ["Fly"] = 89.43, ["Ride"] = 19.69, ["Fly|Ride"] = 65.63, ["Neon"] = 42.26, ["Neon|Ride"] = 141.07, ["Neon|Fly|Ride"] = 141.75, ["Mega"] = 773.07, ["Mega|Ride"] = 272.35, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://10193736072"] = {name = "Red Crowned Crane", prices = {["default"] = 2.63, ["Fly"] = 26.14, ["Ride"] = 20.01, ["Fly|Ride"] = 36.74, ["Neon"] = 15.74, ["Neon|Ride"] = 42.14, ["Neon|Fly|Ride"] = 131.24, ["Mega"] = 1056.7, ["Mega|Ride"] = 282.43, ["Mega|Fly|Ride"] = 203.44}},
    ["rbxassetid://13804047294"] = {name = "Arctic Tern", prices = {["default"] = 5.2, ["Ride"] = 103.69, ["Neon"] = 28.53, ["Neon|Fly|Ride"] = 105.78, ["Mega"] = 296.19, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 471.45}},
    ["rbxassetid://14883937353"] = {name = "Ghost Dog", prices = {["default"] = 22.31, ["Fly"] = 262.13, ["Ride"] = 46.82, ["Fly|Ride"] = 262.5, ["Neon"] = 116.81, ["Neon|Fly"] = 311.6, ["Neon|Ride"] = 126.94, ["Neon|Fly|Ride"] = 167.99, ["Mega"] = 656.25, ["Mega|Ride"] = 619.85, ["Mega|Fly|Ride"] = 511.88}},
    ["rbxassetid://103241919688695"] = {name = "2025 Birthday Butterfly", prices = {["default"] = 5.25, ["Ride"] = 98.44, ["Neon"] = 21.06, ["Neon|Ride"] = 74.05, ["Neon|Fly|Ride"] = 113.21, ["Mega"] = 104.89, ["Mega|Fly"] = 70.89, ["Mega|Fly|Ride"] = 314.7}},
    ["rbxassetid://86594144838863"] = {name = "Tree Frog", prices = {["default"] = 2.1, ["Ride"] = 27.47, ["Neon"] = 2.63, ["Neon|Ride"] = 26.25, ["Mega"] = 18.38, ["Mega|Ride"] = 52.38, ["Mega|Fly|Ride"] = 204.75}},
    ["rbxassetid://99048375832409"] = {name = "Shih Tzu", prices = {["default"] = 2.1, ["Ride"] = 20.99, ["Fly|Ride"] = 82.52, ["Neon"] = 3.84, ["Neon|Fly"] = 393.59, ["Neon|Ride"] = 26.17, ["Neon|Fly|Ride"] = 177.72, ["Mega"] = 18.38, ["Mega|Fly"] = 73.86, ["Mega|Ride"] = 42.26, ["Mega|Fly|Ride"] = 107.57}},
    ["rbxassetid://6998403122"] = {name = "Kirin", prices = {["default"] = 2.1, ["Fly"] = 25.89, ["Ride"] = 16.96, ["Fly|Ride"] = 49.26, ["Neon"] = 5.25, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 23.3, ["Neon|Fly|Ride"] = 84.89, ["Mega"] = 97.55, ["Mega|Ride"] = 157.95, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://15930472964"] = {name = "Gila Monster", prices = {["default"] = 2.1, ["Ride"] = 28.41, ["Fly|Ride"] = 57.04, ["Neon"] = 15.86, ["Neon|Ride"] = 1312.5, ["Mega"] = 105, ["Mega|Ride"] = 145.3, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://5721843144"] = {name = "Dilophosaurus", prices = {["default"] = 2.1, ["Fly"] = 26.24, ["Ride"] = 16.91, ["Fly|Ride"] = 40.6, ["Neon"] = 14.38, ["Neon|Fly"] = 42.32, ["Neon|Ride"] = 21.16, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 282.87, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 366.18}},
    ["rbxassetid://109520235810036"] = {name = "Mini Schnauzer", prices = {["default"] = 81.23, ["Ride"] = 205.95, ["Fly|Ride"] = 395.05, ["Neon"] = 209.14, ["Neon|Ride"] = 298.91, ["Neon|Fly|Ride"] = 1057.76, ["Mega"] = 787.5, ["Mega|Fly"] = 1001.7, ["Mega|Ride"] = 845.4, ["Mega|Fly|Ride"] = 987.95}},
    ["rbxassetid://3181728229"] = {name = "Snow Cat", prices = {["default"] = 2.1, ["Fly"] = 22.32, ["Ride"] = 21.06, ["Fly|Ride"] = 39.38, ["Neon"] = 3.84, ["Neon|Fly"] = 28.5, ["Neon|Ride"] = 20.9, ["Neon|Fly|Ride"] = 45.94, ["Mega"] = 41.64, ["Mega|Ride"] = 54.02, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://4506925747"] = {name = "Wolf", prices = {["default"] = 7.88, ["Fly"] = 62.91, ["Ride"] = 40.01, ["Fly|Ride"] = 78.17, ["Neon"] = 57.22, ["Neon|Fly"] = 76.06, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 70.23, ["Mega"] = 846.21, ["Mega|Ride"] = 242.33, ["Mega|Fly|Ride"] = 275.63}},
    ["rbxassetid://5862774473"] = {name = "Albino Bat", prices = {["default"] = 11.54, ["Fly"] = 45.44, ["Ride"] = 28.62, ["Fly|Ride"] = 57.18, ["Neon"] = 72.05, ["Neon|Fly"] = 135.21, ["Neon|Ride"] = 79.34, ["Neon|Fly|Ride"] = 120.75, ["Mega"] = 413.59, ["Mega|Ride"] = 421, ["Mega|Fly|Ride"] = 409.37}},
    ["rbxassetid://14978701751"] = {name = "Scarecrow", prices = {["default"] = 6.57, ["Fly"] = 140.44, ["Ride"] = 47.07, ["Neon"] = 22.37, ["Neon|Ride"] = 70.89, ["Mega"] = 196.88, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 353.3}},
    ["rbxassetid://10235589000"] = {name = "Corgi", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 17.38, ["Fly|Ride"] = 24.94, ["Neon"] = 3.94, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 64.32, ["Mega"] = 47.16, ["Mega|Fly"] = 91.88, ["Mega|Ride"] = 59.07, ["Mega|Fly|Ride"] = 131.18}},
    ["rbxassetid://103710623311342"] = {name = "Ghost Chick", prices = {["default"] = 3.93, ["Fly"] = 78.07, ["Ride"] = 28.44, ["Fly|Ride"] = 141.39, ["Neon"] = 17.07, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 62.46, ["Neon|Fly|Ride"] = 158.67, ["Mega"] = 126, ["Mega|Fly"] = 735, ["Mega|Ride"] = 156.56, ["Mega|Fly|Ride"] = 395.61}},
    ["rbxassetid://4440866423"] = {name = "Cow", prices = {["default"] = 984.38, ["Ride"] = 1005.38, ["Fly|Ride"] = 1063.13, ["Neon"] = 2625, ["Neon|Fly"] = 2887.71, ["Neon|Ride"] = 2837.52, ["Neon|Fly|Ride"] = 2336.25, ["Mega|Fly|Ride"] = 7434}},
    ["rbxassetid://15093139154"] = {name = "Slime", prices = {["default"] = 72.19, ["Ride"] = 65.63, ["Neon"] = 260.24, ["Neon|Ride"] = 279.25, ["Neon|Fly|Ride"] = 312.05, ["Mega"] = 1365.57, ["Mega|Ride"] = 1365.57, ["Mega|Fly|Ride"] = 1295.44}},
    ["rbxassetid://82170828935980"] = {name = "Dracula Fish", prices = {["default"] = 2.1, ["Ride"] = 68.39, ["Neon"] = 5.71, ["Neon|Ride"] = 75.11, ["Neon|Fly|Ride"] = 99.45, ["Mega"] = 69.21}},
    ["rbxassetid://11109302289"] = {name = "Zombie Wolf", prices = {["default"] = 37.88, ["Ride"] = 55.3, ["Fly|Ride"] = 122.54, ["Neon"] = 169.2, ["Neon|Ride"] = 193.76, ["Neon|Fly|Ride"] = 283.1, ["Mega"] = 1023.75, ["Mega|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://15369729071"] = {name = "Nutcracker Squirrel", prices = {["default"] = 9.97, ["Ride"] = 33.13, ["Fly|Ride"] = 280.97, ["Neon"] = 117.41, ["Neon|Ride"] = 281.19, ["Neon|Fly|Ride"] = 281.38, ["Mega"] = 471.45, ["Mega|Fly|Ride"] = 1057.76}},
    ["rbxassetid://9800792849"] = {name = "Goat", prices = {["default"] = 262.5, ["Fly"] = 316.88, ["Ride"] = 262.5, ["Fly|Ride"] = 343.48, ["Neon"] = 984.38, ["Neon|Ride"] = 1139.87, ["Neon|Fly|Ride"] = 1110.38, ["Mega|Fly|Ride"] = 4061.77}},
    ["rbxassetid://12509687499"] = {name = "Banded Palm Civet", prices = {["default"] = 2.1, ["Fly"] = 102.37, ["Ride"] = 22.32, ["Fly|Ride"] = 129.93, ["Neon"] = 19.69, ["Neon|Ride"] = 53.9, ["Mega"] = 399.84, ["Mega|Fly"] = 282.43}},
    ["rbxassetid://10381386150"] = {name = "Rhino Beetle", prices = {["default"] = 2.1, ["Neon"] = 26.25, ["Neon|Ride"] = 141.75}},
    ["rbxassetid://130734656883878"] = {name = "Merry Mistletroll", prices = {["default"] = 65.63, ["Ride"] = 118.13, ["Fly|Ride"] = 282.96, ["Neon"] = 157.5, ["Neon|Ride"] = 410.82, ["Neon|Fly|Ride"] = 401.63, ["Mega"] = 1103.55, ["Mega|Ride"] = 551.25, ["Mega|Fly|Ride"] = 771.1}},
    ["rbxassetid://15923337068"] = {name = "Oryx", prices = {["default"] = 2.1, ["Ride"] = 48.54, ["Fly|Ride"] = 141.18, ["Neon"] = 13.13, ["Mega"] = 224.25, ["Mega|Ride"] = 471.45, ["Mega|Fly|Ride"] = 211.56}},
    ["rbxassetid://6245080365"] = {name = "Ox", prices = {["default"] = 2.1, ["Fly"] = 18.38, ["Ride"] = 15.7, ["Fly|Ride"] = 28.09, ["Neon"] = 3.68, ["Neon|Fly"] = 31.71, ["Neon|Ride"] = 23.29, ["Neon|Fly|Ride"] = 44.44, ["Mega"] = 27.49, ["Mega|Fly"] = 63.66, ["Mega|Ride"] = 40.43, ["Mega|Fly|Ride"] = 72.19}},
    ["rbxassetid://13810870050"] = {name = "African Wild Dog", prices = {["default"] = 4329.94, ["Ride"] = 4331.25, ["Fly|Ride"] = 4198.69, ["Neon"] = 21811.71, ["Neon|Fly|Ride"] = 21359.63, ["Mega|Fly|Ride"] = 57044.24}},
    ["rbxassetid://12596400214"] = {name = "Goldfish", prices = {["default"] = 11.34, ["Ride"] = 35.93, ["Neon"] = 90.57, ["Neon|Ride"] = 49.73, ["Mega"] = 418.69, ["Mega|Fly|Ride"] = 523.69}},
    ["rbxassetid://4736656915"] = {name = "Australian Kelpie", prices = {["default"] = 2.1, ["Fly"] = 19.03, ["Ride"] = 16.96, ["Fly|Ride"] = 42.29, ["Neon"] = 14.36, ["Neon|Ride"] = 28.58, ["Neon|Fly|Ride"] = 63.66, ["Mega"] = 266.57, ["Mega|Ride"] = 130.12, ["Mega|Fly|Ride"] = 205.09}},
    ["rbxassetid://3743711305"] = {name = "Crocodile", prices = {["default"] = 403.05, ["Fly"] = 493.27, ["Ride"] = 393.75, ["Fly|Ride"] = 525.44, ["Neon"] = 1312.5, ["Neon|Ride"] = 1358.44, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 6065.16}},
    ["rbxassetid://74373220330198"] = {name = "Officer Gibbon", prices = {["default"] = 6.41, ["Ride"] = 28.53, ["Neon"] = 17.07, ["Neon|Ride"] = 157.65, ["Mega"] = 141.75, ["Mega|Fly|Ride"] = 317.34}},
    ["rbxassetid://18508184138"] = {name = "Peregrine Falcon", prices = {["default"] = 5.25, ["Fly"] = 122.05, ["Ride"] = 949.55, ["Neon"] = 94.16, ["Neon|Ride"] = 141.75, ["Neon|Fly|Ride"] = 14104.07, ["Mega"] = 380.81, ["Mega|Ride"] = 401.63}},
    ["rbxassetid://92389214029179"] = {name = "Kaijunior", prices = {["default"] = 2.1, ["Fly"] = 52.33, ["Ride"] = 17.97, ["Fly|Ride"] = 82.55, ["Neon"] = 8.46, ["Neon|Fly"] = 43.32, ["Neon|Ride"] = 33.9, ["Neon|Fly|Ride"] = 72.19, ["Mega"] = 47.09, ["Mega|Ride"] = 69.83, ["Mega|Fly|Ride"] = 169.25}},
    ["rbxassetid://3409443986"] = {name = "Flamingo", prices = {["default"] = 630, ["Ride"] = 639.19, ["Fly|Ride"] = 637.88, ["Neon"] = 2492.68, ["Neon|Fly|Ride"] = 1967.34, ["Mega|Fly|Ride"] = 8751.75}},
    ["rbxassetid://126933432685319"] = {name = "Cattuccino", prices = {["default"] = 6.04, ["Ride"] = 39.38, ["Fly|Ride"] = 114.91, ["Neon"] = 26.25, ["Neon|Ride"] = 99.45, ["Neon|Fly|Ride"] = 648.38, ["Mega"] = 126, ["Mega|Ride"] = 190.32, ["Mega|Fly|Ride"] = 306.34}},
    ["rbxassetid://11631390464"] = {name = "Ermine", prices = {["default"] = 7.34, ["Fly"] = 235.94, ["Ride"] = 45.93, ["Fly|Ride"] = 150.94, ["Neon"] = 43.32, ["Neon|Ride"] = 98.99, ["Neon|Fly|Ride"] = 126.94, ["Mega"] = 225.75, ["Mega|Ride"] = 227.67, ["Mega|Fly|Ride"] = 353.3}},
    ["rbxassetid://4708551221"] = {name = "Emu", prices = {["default"] = 2.1, ["Fly"] = 23.16, ["Ride"] = 18.69, ["Fly|Ride"] = 45.94, ["Neon"] = 15.43, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 60.12, ["Mega"] = 233.78, ["Mega|Ride"] = 169.25, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://16088266364"] = {name = "Burning Bunny", prices = {["default"] = 32.68, ["Ride"] = 57.04, ["Neon"] = 104.23, ["Neon|Fly"] = 170.63, ["Neon|Ride"] = 126.94, ["Neon|Fly|Ride"] = 314.74, ["Mega"] = 498.21, ["Mega|Ride"] = 452.82, ["Mega|Fly|Ride"] = 528.89}},
    ["rbxassetid://80832101513100"] = {name = "2026 Birthday Butterfly", prices = {["default"] = 2.1, ["Ride"] = 39.37, ["Neon"] = 3.93, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 208.69, ["Mega"] = 26.25, ["Mega|Fly"] = 42.32, ["Mega|Ride"] = 84.88, ["Mega|Fly|Ride"] = 211.56}},
    ["rbxassetid://14639007389"] = {name = "Caterpillar", prices = {["default"] = 420, ["Ride"] = 450.11, ["Fly|Ride"] = 628.18, ["Neon"] = 1837.5, ["Neon|Ride"] = 2322.85, ["Neon|Fly|Ride"] = 2362.5, ["Mega|Ride"] = 9193.09, ["Mega|Fly|Ride"] = 7848.75}},
    ["rbxassetid://82920146813845"] = {name = "Little Lamb", prices = {["default"] = 2.1, ["Ride"] = 49.65, ["Neon"] = 7.87, ["Neon|Ride"] = 36.93, ["Neon|Fly|Ride"] = 196.35, ["Mega"] = 30.7, ["Mega|Ride"] = 133.29, ["Mega|Fly|Ride"] = 293.7}},
    ["rbxassetid://96424154406922"] = {name = "Crimson Cape", prices = {["default"] = 2.1, ["Ride"] = 27.38, ["Neon"] = 5.12, ["Neon|Fly"] = 70.79, ["Neon|Ride"] = 211.76, ["Neon|Fly|Ride"] = 141.75, ["Mega"] = 39.9, ["Mega|Fly"] = 82.51, ["Mega|Ride"] = 137.82, ["Mega|Fly|Ride"] = 210.51}},
    ["rbxassetid://109008428989602"] = {name = "Pangolin", prices = {["default"] = 2.1, ["Ride"] = 60.37, ["Neon"] = 4.24, ["Neon|Ride"] = 45.91, ["Mega"] = 34.13, ["Mega|Fly"] = 156.56, ["Mega|Ride"] = 90.99}},
    ["rbxassetid://16722909218"] = {name = "Floral Eggy", prices = {["default"] = 3.66, ["Ride"] = 131.25, ["Neon"] = 17.07, ["Neon|Ride"] = 70.89, ["Mega"] = 111.98, ["Mega|Ride"] = 328.13}},
    ["rbxassetid://76735046136809"] = {name = "Frostbite Cub", prices = {["default"] = 49.88, ["Ride"] = 85.3, ["Fly|Ride"] = 203.44, ["Neon"] = 230.27, ["Neon|Ride"] = 282.43, ["Neon|Fly|Ride"] = 353.3, ["Mega"] = 605.06, ["Mega|Ride"] = 479.06, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://15684947715"] = {name = "Quokka", prices = {["default"] = 24.3, ["Fly"] = 69.47, ["Ride"] = 64.31, ["Neon"] = 115.31, ["Neon|Ride"] = 141.75, ["Mega"] = 436.44, ["Mega|Ride"] = 454.76, ["Mega|Fly|Ride"] = 499.06}},
    ["rbxassetid://5721843001"] = {name = "Deinonychus", prices = {["default"] = 3.82, ["Fly"] = 34.65, ["Ride"] = 16.92, ["Fly|Ride"] = 36.74, ["Neon"] = 27.57, ["Neon|Fly"] = 70.79, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 75.87, ["Mega"] = 394.42, ["Mega|Ride"] = 238.04, ["Mega|Fly|Ride"] = 246.48}},
    ["rbxassetid://16999461770"] = {name = "Inmate Capuchin Monkey", prices = {["default"] = 11.82, ["Ride"] = 64.32, ["Neon"] = 169.01, ["Neon|Ride"] = 158.82, ["Neon|Fly|Ride"] = 233.78, ["Mega"] = 334.27, ["Mega|Ride"] = 786.14, ["Mega|Fly|Ride"] = 564.85}},
    ["rbxassetid://119664699815373"] = {name = "Frozen Penguin", prices = {["default"] = 3.68, ["Fly"] = 65.63, ["Ride"] = 27.38, ["Fly|Ride"] = 362.25, ["Neon"] = 17.73, ["Neon|Ride"] = 69.54, ["Mega"] = 144.38, ["Mega|Ride"] = 148.1, ["Mega|Fly|Ride"] = 253.87}},
    ["rbxassetid://5067924307"] = {name = "Business Monkey", prices = {["default"] = 19.99, ["Ride"] = 30.18, ["Fly|Ride"] = 45.94, ["Neon"] = 228.74, ["Neon|Ride"] = 162.91, ["Neon|Fly|Ride"] = 169.25, ["Mega"] = 950.93, ["Mega|Ride"] = 942.89, ["Mega|Fly|Ride"] = 705.54}},
    ["rbxassetid://126192643157832"] = {name = "Manta Ray", prices = {["default"] = 39.26, ["Fly"] = 874.13, ["Neon|Ride"] = 471.52, ["Mega"] = 353.07, ["Mega|Ride"] = 590.63}},
    ["rbxassetid://4440866911"] = {name = "Silly Duck", prices = {["default"] = 44.63, ["Fly"] = 115.5, ["Ride"] = 91.9, ["Fly|Ride"] = 139.13, ["Neon"] = 291.38, ["Neon|Fly"] = 324.74, ["Neon|Ride"] = 276.92, ["Neon|Fly|Ride"] = 382.97, ["Mega"] = 1163.54, ["Mega|Ride"] = 1151.76, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://110544962124445"] = {name = "Cake Friend", prices = {["default"] = 49.88, ["Fly"] = 92.79, ["Ride"] = 77.6, ["Fly|Ride"] = 281.98, ["Neon"] = 126, ["Neon|Ride"] = 141.75, ["Neon|Fly|Ride"] = 421, ["Mega"] = 496.63, ["Mega|Ride"] = 600.31, ["Mega|Fly|Ride"] = 581.06}},
    ["rbxassetid://16127157068"] = {name = "Rice Cake Rabbit", prices = {["default"] = 16.94, ["Ride"] = 59.07, ["Neon"] = 108.94, ["Mega"] = 561.68, ["Mega|Ride"] = 634.67, ["Mega|Fly|Ride"] = 717.17}},
    ["rbxassetid://7734900613"] = {name = "Halloween Evil Dachshund", prices = {["default"] = 7.88, ["Fly"] = 27.18, ["Ride"] = 31.77, ["Fly|Ride"] = 65.63, ["Neon"] = 45.94, ["Neon|Fly"] = 169.01, ["Neon|Ride"] = 57.14, ["Neon|Fly|Ride"] = 116.28, ["Mega"] = 290, ["Mega|Ride"] = 323.69, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://9664282145"] = {name = "Robot", prices = {["default"] = 2.1, ["Fly"] = 17.07, ["Ride"] = 15.85, ["Fly|Ride"] = 38.96, ["Neon"] = 3.94, ["Neon|Fly"] = 24.89, ["Neon|Ride"] = 21.24, ["Neon|Fly|Ride"] = 57.75, ["Mega"] = 41.4, ["Mega|Fly"] = 705.54, ["Mega|Ride"] = 62.99, ["Mega|Fly|Ride"] = 144.38}},
    ["rbxassetid://3261465791"] = {name = "Pink Egg", prices = {["default"] = 1394.22}},
    ["rbxassetid://126725051633301"] = {name = "Headless Horse", prices = {["default"] = 26.41, ["Ride"] = 55.3, ["Fly|Ride"] = 131.25, ["Neon"] = 122.54, ["Neon|Fly"] = 233.44, ["Neon|Ride"] = 210.58, ["Neon|Fly|Ride"] = 283.49, ["Mega"] = 405.14, ["Mega|Ride"] = 498.75, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://88554799028713"] = {name = "Sneak Weasel", prices = {["default"] = 2.1, ["Ride"] = 55.31, ["Neon"] = 5.25, ["Neon|Ride"] = 37.03, ["Neon|Fly|Ride"] = 296.19, ["Mega"] = 32.23, ["Mega|Ride"] = 115.31, ["Mega|Fly|Ride"] = 541}},
    ["rbxassetid://14639008203"] = {name = "English Sheepdog", prices = {["default"] = 28.61, ["Ride"] = 70.76, ["Neon"] = 171.24, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 322.86, ["Mega"] = 633.94, ["Mega|Ride"] = 916.04, ["Mega|Fly|Ride"] = 885.94}},
    ["rbxassetid://133131190079833"] = {name = "Oakee", prices = {["default"] = 2.1, ["Neon"] = 3.94, ["Neon|Ride"] = 105, ["Mega"] = 26.25, ["Mega|Fly|Ride"] = 705.54}},
    ["rbxassetid://79856043024325"] = {name = "Chestnut Glyptodon", prices = {["default"] = 2.1, ["Neon"] = 4.2, ["Neon|Ride"] = 157.98, ["Mega"] = 22.32, ["Mega|Ride"] = 98.44, ["Mega|Fly|Ride"] = 273}},
    ["rbxassetid://12720028898"] = {name = "Hare", prices = {["default"] = 128.18, ["Ride"] = 176.37, ["Fly|Ride"] = 249.37, ["Neon"] = 421.21, ["Neon|Fly"] = 508.41, ["Neon|Ride"] = 518.44, ["Neon|Fly|Ride"] = 570.94, ["Mega|Ride"] = 6482.32, ["Mega|Fly|Ride"] = 2098.69}},
    ["rbxassetid://16897788024"] = {name = "Capuchin Monkey", prices = {["default"] = 2.1, ["Fly"] = 26.11, ["Ride"] = 21.14, ["Fly|Ride"] = 70.63, ["Neon"] = 12.86, ["Neon|Fly"] = 63.39, ["Neon|Ride"] = 35.43, ["Neon|Fly|Ride"] = 92.05, ["Mega"] = 107.63, ["Mega|Ride"] = 133.29, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://121639546210522"] = {name = "Amber Butterfly", prices = {["default"] = 2.1, ["Fly"] = 36.16, ["Ride"] = 131.25, ["Fly|Ride"] = 86.63, ["Neon"] = 6.3, ["Neon|Ride"] = 57.14, ["Neon|Fly|Ride"] = 100.5, ["Mega"] = 27.54, ["Mega|Ride"] = 103.67, ["Mega|Fly|Ride"] = 116.82}},
    ["rbxassetid://79005166120532"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Ride"] = 19.69, ["Neon"] = 3.94, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 35.17, ["Mega"] = 33.45, ["Mega|Ride"] = 78.98, ["Mega|Fly|Ride"] = 114.19}},
    ["rbxassetid://138741319376538"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 5.25, ["Neon|Ride"] = 29.89, ["Neon|Fly|Ride"] = 141.75, ["Mega"] = 40.69, ["Mega|Ride"] = 95.7, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://133558151150234"] = {name = "Black Widow", prices = {["default"] = 45.94, ["Ride"] = 91.88, ["Fly|Ride"] = 449.61, ["Neon"] = 282.03, ["Neon|Ride"] = 406.88, ["Neon|Fly|Ride"] = 695.63, ["Mega"] = 1389.9, ["Mega|Ride"] = 1530.58, ["Mega|Fly|Ride"] = 1551.74}},
    ["rbxassetid://122945704087152"] = {name = "Chilling Spider", prices = {["default"] = 3.83, ["Ride"] = 139.41, ["Neon"] = 28.29, ["Neon|Ride"] = 110.82, ["Mega"] = 70.89, ["Mega|Ride"] = 771.1}},
    ["rbxassetid://1373237029"] = {name = "Big Head Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://2657668946"] = {name = "Cure All Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://1373237971"] = {name = "Grow Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4315743582"] = {name = "Honey Badger", prices = {["default"] = 368.95, ["Ride"] = 367.5, ["Fly|Ride"] = 522.84, ["Neon"] = 1267.47, ["Neon|Ride"] = 1267.2, ["Neon|Fly|Ride"] = 1269.32, ["Mega|Ride"] = 3793.11, ["Mega|Fly|Ride"] = 3193}},
    ["rbxassetid://1373208271"] = {name = "Hyperspeed Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4047157976"] = {name = "Fly Potion", prices = {["default"] = 76.11}},
    ["rbxassetid://3342628435"] = {name = "Ride Potion", prices = {["default"] = 45.94}},
    ["rbxassetid://1509389697"] = {name = "Adopt Me Boy Scooter", prices = {["default"] = 15.86}},
    ["rbxassetid://1509384540"] = {name = "Adopt Me Girl Scooter", prices = {["default"] = 20.74}},
    ["rbxassetid://1256627798"] = {name = "Adopt Me Snowboard 1", prices = {["default"] = 36.75}},
    ["rbxassetid://1256627585"] = {name = "Adopt Me Snowboard 2", prices = {["default"] = 32.82}},
    ["rbxassetid://2782643682"] = {name = "Axel", prices = {["default"] = 10.47}},
    ["rbxassetid://3009779146"] = {name = "Banana Car", prices = {["default"] = 9.08}},
    ["rbxassetid://1306904296"] = {name = "Bathtub", prices = {["default"] = 234.94}},
    ["rbxassetid://1307341557"] = {name = "Bethink Skateboard", prices = {["default"] = 22.32}},
    ["rbxassetid://908269395"] = {name = "Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://1509319125"] = {name = "Black Scooter", prices = {["default"] = 56.43}},
    ["rbxassetid://1306898658"] = {name = "Black Skateboard", prices = {["default"] = 7.35}},
    ["rbxassetid://1256625297"] = {name = "Black Snowboard", prices = {["default"] = 4.72}},
    ["rbxassetid://1266478264"] = {name = "Blue Neon Snowboard", prices = {["default"] = 787.5}},
    ["rbxassetid://4800244517"] = {name = "Blue Rider", prices = {["default"] = 2.1}},
    ["rbxassetid://1509318734"] = {name = "Blue Scooter", prices = {["default"] = 6.35}},
    ["rbxassetid://1306898360"] = {name = "Blue Skateboard", prices = {["default"] = 6.55}},
    ["rbxassetid://1256625905"] = {name = "Blue Snowboard", prices = {["default"] = 5.25}},
    ["rbxassetid://7165481985"] = {name = "Bubble Car", prices = {["default"] = 5.18}},
    ["rbxassetid://12115176522"] = {name = "Toxic Barrel", prices = {["default"] = 20.93}},
    ["rbxassetid://2657667116"] = {name = "Bunny Carriage", prices = {["default"] = 475.13}},
    ["rbxassetid://6475610034"] = {name = "Butterfly Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264167"] = {name = "Camper Van", prices = {["default"] = 2.1}},
    ["rbxassetid://2758237053"] = {name = "Car", prices = {["default"] = 2.1}},
    ["rbxassetid://14465252948"] = {name = "Super Jetpack", prices = {["default"] = 661.86}},
    ["rbxassetid://4754697599"] = {name = "Choo Choo Train", prices = {["default"] = 13.12}},
    ["rbxassetid://2408035766"] = {name = "Cloud", prices = {["default"] = 1312.5}},
    ["rbxassetid://5057099424"] = {name = "Clown Car", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099515"] = {name = "Clown Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2860616529"] = {name = "Convertible", prices = {["default"] = 59.07}},
    ["rbxassetid://4470750671"] = {name = "Cookie Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8203695278"] = {name = "Snowmobile", prices = {["default"] = 7.87}},
    ["rbxassetid://8243269978"] = {name = "Zamboni", prices = {["default"] = 2.1}},
    ["rbxassetid://1509385561"] = {name = "Cupcake Scooter", prices = {["default"] = 15.64}},
    ["rbxassetid://4822522305"] = {name = "Daisy Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8517689681"] = {name = "Landsailer", prices = {["default"] = 2.1}},
    ["rbxassetid://8566306089"] = {name = "Trireme", prices = {["default"] = 2.1}},
    ["rbxassetid://6504033614"] = {name = "Dino Truck", prices = {["default"] = 2.63}},
    ["rbxassetid://1512774745"] = {name = "Doge Scooter", prices = {["default"] = 19.69}},
    ["rbxassetid://1307341942"] = {name = "Doge Skateboard", prices = {["default"] = 65.63}},
    ["rbxassetid://3486906742"] = {name = "Dogmobile", prices = {["default"] = 41.99}},
    ["rbxassetid://2880427418"] = {name = "Donut Cycle", prices = {["default"] = 15.74}},
    ["rbxassetid://3486907843"] = {name = "Donut Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2782643731"] = {name = "Douglas", prices = {["default"] = 13.13}},
    ["rbxassetid://1509391407"] = {name = "Duck Scooter", prices = {["default"] = 13.13}},
    ["rbxassetid://9291032374"] = {name = "Egg Delivery Machine", prices = {["default"] = 7.46}},
    ["rbxassetid://1509377123"] = {name = "Emoji Scooter", prices = {["default"] = 15.74}},
    ["rbxassetid://9973767611"] = {name = "Harvest Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://9973768669"] = {name = "Tractor", prices = {["default"] = 2.63}},
    ["rbxassetid://1307341332"] = {name = "Fidget Skateboard", prices = {["default"] = 24.94}},
    ["rbxassetid://1306904101"] = {name = "Fissy Skateboard", prices = {["default"] = 21}},
    ["rbxassetid://4823285384"] = {name = "Flower Wagon", prices = {["default"] = 3.92}},
    ["rbxassetid://7475653998"] = {name = "Fossil Paw Helicopter", prices = {["default"] = 2.1}},
    ["rbxassetid://9406027381"] = {name = "Starter Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://6475609765"] = {name = "Futuristic Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291832"] = {name = "Ghost Vehicle", prices = {["default"] = 1575}},
    ["rbxassetid://10905638416"] = {name = "Ancient Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760422"] = {name = "Bat Face Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://10919870588"] = {name = "Dapper Friend Carrier", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760559"] = {name = "Dirt Bike Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10967588257"] = {name = "Hot Tub Muscle Car", prices = {["default"] = 160.56}},
    ["rbxassetid://10905207734"] = {name = "Soapy Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9037078630"] = {name = "Horse And Carriage", prices = {["default"] = 308.23}},
    ["rbxassetid://10913434990"] = {name = "Unstable Triangle Car", prices = {["default"] = 4.12}},
    ["rbxassetid://8979306571"] = {name = "Wizard Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1512770654"] = {name = "Glass Scooter", prices = {["default"] = 9.42}},
    ["rbxassetid://1306903971"] = {name = "Glass Skateboard", prices = {["default"] = 784.76}},
    ["rbxassetid://1256627375"] = {name = "Glass Snowboard", prices = {["default"] = 24.93}},
    ["rbxassetid://1064481531"] = {name = "GoKart", prices = {["default"] = 127.31}},
    ["rbxassetid://1509326491"] = {name = "Gold Scooter", prices = {["default"] = 9.92}},
    ["rbxassetid://1306902802"] = {name = "Gold Skateboard", prices = {["default"] = 36.75}},
    ["rbxassetid://1265129435"] = {name = "Gold Snowboard", prices = {["default"] = 168}},
    ["rbxassetid://12519249137"] = {name = "Bumper Car", prices = {["default"] = 2.1}},
    ["rbxassetid://12519249424"] = {name = "Circus Ball Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265134428"] = {name = "Green Neon Snowboard", prices = {["default"] = 864.47}},
    ["rbxassetid://7839195952"] = {name = "Halloween Black Ponycycle", prices = {["default"] = 18.38}},
    ["rbxassetid://11119263404"] = {name = "Headless Horseman's Biplane", prices = {["default"] = 3.89}},
    ["rbxassetid://10920073281"] = {name = "Throwing Knife Target", prices = {["default"] = 2.1}},
    ["rbxassetid://10920073157"] = {name = "Shadow Rider", prices = {["default"] = 22.23}},
    ["rbxassetid://11125166616"] = {name = "Unicorn Zombie Ponycycle", prices = {["default"] = 7.88}},
    ["rbxassetid://2848331544"] = {name = "Heart Hoverboard", prices = {["default"] = 3.76}},
    ["rbxassetid://2657670919"] = {name = "Horse Cycle", prices = {["default"] = 110.25}},
    ["rbxassetid://3163531592"] = {name = "Traveling House", prices = {["default"] = 22.32}},
    ["rbxassetid://4382798606"] = {name = "Hoverboard", prices = {["default"] = 13.13}},
    ["rbxassetid://6475613264"] = {name = "Hovercar", prices = {["default"] = 3.93}},
    ["rbxassetid://4797807001"] = {name = "Human Bubble", prices = {["default"] = 2.1}},
    ["rbxassetid://4588192578"] = {name = "Ice Cream Truck", prices = {["default"] = 15.73}},
    ["rbxassetid://4470749585"] = {name = "Ice Queen Sleigh", prices = {["default"] = 2.52}},
    ["rbxassetid://1509333762"] = {name = "Ice Scooter", prices = {["default"] = 10.49}},
    ["rbxassetid://1265129203"] = {name = "Ice Snowboard", prices = {["default"] = 221.49}},
    ["rbxassetid://6504033516"] = {name = "Imagination Box", prices = {["default"] = 2.52}},
    ["rbxassetid://10619155042"] = {name = "Street Racer", prices = {["default"] = 32.61}},
    ["rbxassetid://2749267159"] = {name = "Limo", prices = {["default"] = 2.1}},
    ["rbxassetid://8665606953"] = {name = "Dragon Train", prices = {["default"] = 132.79}},
    ["rbxassetid://11758583286"] = {name = "Crescent Moon Car", prices = {["default"] = 159.12}},
    ["rbxassetid://6276452323"] = {name = "Lunar Muscle Car", prices = {["default"] = 2.63}},
    ["rbxassetid://7165482478"] = {name = "Magical Girl Car", prices = {["default"] = 9.91}},
    ["rbxassetid://7368045552"] = {name = "Magical Princess Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1306902978"] = {name = "Melon Skateboard", prices = {["default"] = 32.76}},
    ["rbxassetid://3009779540"] = {name = "Monocycle", prices = {["default"] = 24.93}},
    ["rbxassetid://1512742703"] = {name = "Mono-Moped", prices = {["default"] = 77.32}},
    ["rbxassetid://2758236960"] = {name = "Moped", prices = {["default"] = 57.16}},
    ["rbxassetid://2758237011"] = {name = "Motorcycle", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264226"] = {name = "Muscle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://1509342852"] = {name = "Neon Black Scooter", prices = {["default"] = 22354.02}},
    ["rbxassetid://1306911569"] = {name = "Neon Black Skateboard", prices = {["default"] = 183.74}},
    ["rbxassetid://1509338320"] = {name = "Neon Blue Scooter", prices = {["default"] = 26.25}},
    ["rbxassetid://1306907175"] = {name = "Neon Blue Skateboard", prices = {["default"] = 65.58}},
    ["rbxassetid://1509342200"] = {name = "Neon Green Scooter", prices = {["default"] = 48.57}},
    ["rbxassetid://1306907671"] = {name = "Neon Green Skateboard", prices = {["default"] = 39.38}},
    ["rbxassetid://1509338451"] = {name = "Neon Orange Scooter", prices = {["default"] = 54.69}},
    ["rbxassetid://1306907450"] = {name = "Neon Orange Skateboard", prices = {["default"] = 45.94}},
    ["rbxassetid://1509339156"] = {name = "Neon Pink Scooter", prices = {["default"] = 83.43}},
    ["rbxassetid://1306911771"] = {name = "Neon Pink Skateboard", prices = {["default"] = 94.31}},
    ["rbxassetid://1509341495"] = {name = "Neon Red Scooter", prices = {["default"] = 26.25}},
    ["rbxassetid://1306907886"] = {name = "Neon Red Skateboard", prices = {["default"] = 36.75}},
    ["rbxassetid://1256625563"] = {name = "Orange Neon Snowboard", prices = {["default"] = 39.37}},
    ["rbxassetid://1509340494"] = {name = "Neon White Scooter", prices = {["default"] = 44.88}},
    ["rbxassetid://1309919907"] = {name = "Neon White Skateboard", prices = {["default"] = 77.44}},
    ["rbxassetid://2860616613"] = {name = "Offroader", prices = {["default"] = 2.1}},
    ["rbxassetid://1265130049"] = {name = "Pink Neon Snowboard", prices = {["default"] = 341.25}},
    ["rbxassetid://1509329807"] = {name = "Pink Scooter", prices = {["default"] = 11.82}},
    ["rbxassetid://1306898507"] = {name = "Pink Skateboard", prices = {["default"] = 6.57}},
    ["rbxassetid://4361545125"] = {name = "Pizza Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://7368040075"] = {name = "Plant Powered Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9837424665"] = {name = "Rainbow Trail Magic Carpet", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601262"] = {name = "Prince Carriage", prices = {["default"] = 7.8}},
    ["rbxassetid://2854601314"] = {name = "Princess Carriage", prices = {["default"] = 34.12}},
    ["rbxassetid://4115248893"] = {name = "Pumpkin Carriage", prices = {["default"] = 36.75}},
    ["rbxassetid://7475654312"] = {name = "Racing Monoplane", prices = {["default"] = 2.1}},
    ["rbxassetid://10967874847"] = {name = "Galleon", prices = {["default"] = 2.1}},
    ["rbxassetid://10967808228"] = {name = "Old Sail Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992442"] = {name = "RGB Monster Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992324"] = {name = "RGB UFO", prices = {["default"] = 6.57}},
    ["rbxassetid://5882026006"] = {name = "Ribcage Carriage", prices = {["default"] = 6.57}},
    ["rbxassetid://1265128894"] = {name = "Roblox Snowboard", prices = {["default"] = 215.34}},
    ["rbxassetid://4797807111"] = {name = "Rocket Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://7368052482"] = {name = "Rocket Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://1257419042"] = {name = "Rocket Sled", prices = {["default"] = 1050}},
    ["rbxassetid://4564588042"] = {name = "Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601162"] = {name = "Royal Carriage", prices = {["default"] = 11.46}},
    ["rbxassetid://13741294258"] = {name = "Giant Cheetah Mount", prices = {["default"] = 577.5}},
    ["rbxassetid://4470749525"] = {name = "Santa's Sleigh", prices = {["default"] = 44.24}},
    ["rbxassetid://4470749209"] = {name = "Sled", prices = {["default"] = 2.1}},
    ["rbxassetid://9342853829"] = {name = "Snow Plow", prices = {["default"] = 2.1}},
    ["rbxassetid://9343367876"] = {name = "Tundra Exploration Machine", prices = {["default"] = 2.1}},
    ["rbxassetid://1265142495"] = {name = "Snow Snowboard", prices = {["default"] = 380.25}},
    ["rbxassetid://7165482648"] = {name = "Speedboat", prices = {["default"] = 2.1}},
    ["rbxassetid://12719600101"] = {name = "Daisymobile", prices = {["default"] = 40.51}},
    ["rbxassetid://12792507038"] = {name = "Flower Truck", prices = {["default"] = 92.25}},
    ["rbxassetid://12996592162"] = {name = "Lavender Teapot Carriage", prices = {["default"] = 41.83}},
    ["rbxassetid://12917527253"] = {name = "Rabbit Helicopter", prices = {["default"] = 48.57}},
    ["rbxassetid://12996592079"] = {name = "Rose Petal Carriage", prices = {["default"] = 226.04}},
    ["rbxassetid://12996592010"] = {name = "Royal Crown Carriage", prices = {["default"] = 18.9}},
    ["rbxassetid://6504033423"] = {name = "Squirrel Car", prices = {["default"] = 5.92}},
    ["rbxassetid://6798176757"] = {name = "Standard Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://6797010981"] = {name = "Standard Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10224002323"] = {name = "Emperor's Chariot", prices = {["default"] = 14.9}},
    ["rbxassetid://10202931873"] = {name = "Orchid Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://10202932215"] = {name = "Hovercraft", prices = {["default"] = 2.1}},
    ["rbxassetid://10224209770"] = {name = "Planetary Core Car", prices = {["default"] = 2.1}},
    ["rbxassetid://10203332627"] = {name = "Medieval Wagon", prices = {["default"] = 2.1}},
    ["rbxassetid://13607580379"] = {name = "Beach Buggy", prices = {["default"] = 3.28}},
    ["rbxassetid://13683681091"] = {name = "Beachgoer", prices = {["default"] = 3.91}},
    ["rbxassetid://13683679951"] = {name = "Crabby Cruiser", prices = {["default"] = 30.19}},
    ["rbxassetid://3579315827"] = {name = "Surfboard", prices = {["default"] = 2.1}},
    ["rbxassetid://3186425945"] = {name = "SUV", prices = {["default"] = 10.5}},
    ["rbxassetid://1614139188"] = {name = "Multi-Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8727492188"] = {name = "Black Cab", prices = {["default"] = 3.1}},
    ["rbxassetid://8727477150"] = {name = "Yellow Taxi Cab", prices = {["default"] = 7.23}},
    ["rbxassetid://2783002443"] = {name = "Tiffany", prices = {["default"] = 16.94}},
    ["rbxassetid://3206264796"] = {name = "Tiny Convertible", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671636"] = {name = "Unicorn Cycle", prices = {["default"] = 141.07}},
    ["rbxassetid://3142180107"] = {name = "Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231299"] = {name = "Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506670"] = {name = "Family Car", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231666"] = {name = "Classic Helicopter", prices = {["default"] = 2.63}},
    ["rbxassetid://8860682054"] = {name = "Classic Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231811"] = {name = "Motorbike", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506795"] = {name = "Off-Road Car", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506884"] = {name = "Open Top Speeder", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231943"] = {name = "Classic Airplane", prices = {["default"] = 2.63}},
    ["rbxassetid://9108507006"] = {name = "Sports Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8859232022"] = {name = "Tandem Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265135075"] = {name = "White Neon Snowboard", prices = {["default"] = 150.94}},
    ["rbxassetid://1509328859"] = {name = "White Scooter", prices = {["default"] = 7.74}},
    ["rbxassetid://1306898856"] = {name = "White Skateboard", prices = {["default"] = 26.25}},
    ["rbxassetid://1256624956"] = {name = "White Snowboard", prices = {["default"] = 6.57}},
    ["rbxassetid://7165482807"] = {name = "Wing Trunk Car", prices = {["default"] = 26.13}},
    ["rbxassetid://8080952782"] = {name = "Festive Deliveries Present Truck", prices = {["default"] = 51.19}},
    ["rbxassetid://8190703270"] = {name = "Festive Deliveries Sleigh", prices = {["default"] = 7.69}},
    ["rbxassetid://7975097837"] = {name = "Festive Ice Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://8190703329"] = {name = "Toy Rescue Helicopter", prices = {["default"] = 7.88}},
    ["rbxassetid://11697121962"] = {name = "Candy Snowmobile", prices = {["default"] = 15.65}},
    ["rbxassetid://11574949668"] = {name = "Giant Snowball", prices = {["default"] = 11.8}},
    ["rbxassetid://11764928443"] = {name = "Gingerbread Sleigh", prices = {["default"] = 105}},
    ["rbxassetid://11706055135"] = {name = "Husky Sled", prices = {["default"] = 33.66}},
    ["rbxassetid://11466900358"] = {name = "Icebreaker Ship", prices = {["default"] = 2.1}},
    ["rbxassetid://11768005537"] = {name = "Ice Plane", prices = {["default"] = 7.87}},
    ["rbxassetid://11706157454"] = {name = "Snowblower Toboggan", prices = {["default"] = 8.44}},
    ["rbxassetid://11582939967"] = {name = "Strawberry Shortcake Skates", prices = {["default"] = 3.59}},
    ["rbxassetid://11582928541"] = {name = "Strawberry Shortcake Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://4797807321"] = {name = "Witch's Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1509321524"] = {name = "Wood Scooter", prices = {["default"] = 11.79}},
    ["rbxassetid://1306899055"] = {name = "Wood Skateboard", prices = {["default"] = 10.5}},
    ["rbxassetid://4361544852"] = {name = "Airplane Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4797806115"] = {name = "Angelic Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671618"] = {name = "Anna Rattle", prices = {["default"] = 2.63}},
    ["rbxassetid://4712355837"] = {name = "Astro Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://2657667102"] = {name = "Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779116"] = {name = "Balloons", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779170"] = {name = "Banana Plush", prices = {["default"] = 2.63}},
    ["rbxassetid://3009779233"] = {name = "Banana Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248143"] = {name = "Banjo", prices = {["default"] = 5.94}},
    ["rbxassetid://4470749845"] = {name = "Bauble Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468615"] = {name = "Briefcase Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907018"] = {name = "Bubblegum Machine Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046064"] = {name = "Bunny Plush", prices = {["default"] = 4.24}},
    ["rbxassetid://4470749083"] = {name = "Candle", prices = {["default"] = 2.1}},
    ["rbxassetid://6710107927"] = {name = "Candy Cannon", prices = {["default"] = 5670}},
    ["rbxassetid://3082046250"] = {name = "Carrot Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408035756"] = {name = "Cat Plush", prices = {["default"] = 37.7}},
    ["rbxassetid://3009779289"] = {name = "Caticorn Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3082047003"] = {name = "Chick Plush", prices = {["default"] = 10.58}},
    ["rbxassetid://3082046215"] = {name = "Chocolate Bunny Balloon", prices = {["default"] = 4.46}},
    ["rbxassetid://1257271764"] = {name = "Christmas Cat Rattle", prices = {["default"] = 2.63}},
    ["rbxassetid://1257273388"] = {name = "Christmas Doge Rattle", prices = {["default"] = 78.17}},
    ["rbxassetid://4470749153"] = {name = "Cookie Dough Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://10979219546"] = {name = "Cotton Candy Stand", prices = {["default"] = 15.86}},
    ["rbxassetid://4115248463"] = {name = "Creepy Balloon", prices = {["default"] = 3.29}},
    ["rbxassetid://2408035767"] = {name = "Croc Plush", prices = {["default"] = 3.93}},
    ["rbxassetid://4115248599"] = {name = "Crossbow Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468734"] = {name = "Cymbal Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://4822522594"] = {name = "Dandelion Propeller", prices = {["default"] = 15.48}},
    ["rbxassetid://4797806584"] = {name = "Didgeridoo", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779323"] = {name = "Donut Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3454109877"] = {name = "Donut Throw Toy", prices = {["default"] = 131.25}},
    ["rbxassetid://3486907555"] = {name = "Dragon Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779349"] = {name = "Duck Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046102"] = {name = "Easter Bunny Plush", prices = {["default"] = 19.69}},
    ["rbxassetid://1555803323"] = {name = "Egg Rattle", prices = {["default"] = 2.42}},
    ["rbxassetid://2408051109"] = {name = "Elephant Plush", prices = {["default"] = 3.94}},
    ["rbxassetid://4470750254"] = {name = "Elf Plush", prices = {["default"] = 4.87}},
    ["rbxassetid://2657668953"] = {name = "Elf Rattle", prices = {["default"] = 3.59}},
    ["rbxassetid://5882028408"] = {name = "Eyeball Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408035763"] = {name = "Fancy Balloon", prices = {["default"] = 3.93}},
    ["rbxassetid://2408052395"] = {name = "Fancy Umbrella", prices = {["default"] = 3.56}},
    ["rbxassetid://3009779377"] = {name = "Flower Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291815"] = {name = "Flying Broomstick", prices = {["default"] = 4224.87}},
    ["rbxassetid://3454109803"] = {name = "Football Throw Toy", prices = {["default"] = 4.31}},
    ["rbxassetid://7368042855"] = {name = "Galaxy Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749638"] = {name = "Gift Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://1310513344"] = {name = "Glider", prices = {["default"] = 45.94}},
    ["rbxassetid://6936627177"] = {name = "Golden Maned Unicorn Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3142180004"] = {name = "Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907282"] = {name = "Griffin Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://1419098937"] = {name = "Heart Balloon", prices = {["default"] = 2.61}},
    ["rbxassetid://1419099271"] = {name = "Heart Plushie", prices = {["default"] = 4.24}},
    ["rbxassetid://2848331436"] = {name = "Heart Rattle", prices = {["default"] = 81.38}},
    ["rbxassetid://2657670910"] = {name = "Horse Plush", prices = {["default"] = 2.61}},
    ["rbxassetid://3818347838"] = {name = "Hotdog Stand", prices = {["default"] = 6.57}},
    ["rbxassetid://1555807694"] = {name = "Hugging Egg", prices = {["default"] = 278.25}},
    ["rbxassetid://4470749277"] = {name = "Ice Club Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779419"] = {name = "Ice Cream Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4361546643"] = {name = "Ice Cream Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749342"] = {name = "Ice Pick Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052390"] = {name = "Inflatable Sword", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051119"] = {name = "Jackhammer", prices = {["default"] = 2.1}},
    ["rbxassetid://3486908136"] = {name = "Kangaroo Pogo", prices = {["default"] = 3.94}},
    ["rbxassetid://4822522509"] = {name = "Lavender Bundle", prices = {["default"] = 2.63}},
    ["rbxassetid://3523677453"] = {name = "Lemonade Stand", prices = {["default"] = 8.46}},
    ["rbxassetid://6475613071"] = {name = "Lime Slice Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051107"] = {name = "Llama Plush", prices = {["default"] = 9.19}},
    ["rbxassetid://4661940658"] = {name = "Magic House Door", prices = {["default"] = 36.01}},
    ["rbxassetid://3009779472"] = {name = "Marsh Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779496"] = {name = "Marsh Plush", prices = {["default"] = 3.93}},
    ["rbxassetid://5057099190"] = {name = "Monkey Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099046"] = {name = "Monkey Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670913"] = {name = "Noob Balloon", prices = {["default"] = 3.65}},
    ["rbxassetid://3009779607"] = {name = "Octopus Plush", prices = {["default"] = 2.5}},
    ["rbxassetid://4470749788"] = {name = "Ornament Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670921"] = {name = "Phoenix Plush", prices = {["default"] = 13.06}},
    ["rbxassetid://7368034465"] = {name = "Pink Cat Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544972"] = {name = "Plunger Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051114"] = {name = "Puppy Plush", prices = {["default"] = 3.15}},
    ["rbxassetid://3082046011"] = {name = "Rabbit Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408055079"] = {name = "Rainbow Wand", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749750"] = {name = "Reindeer Leash", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779583"] = {name = "Rocket Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749474"] = {name = "Santa Leash", prices = {["default"] = 2.24}},
    ["rbxassetid://4470750189"] = {name = "Santa Rattle", prices = {["default"] = 5.2}},
    ["rbxassetid://5061468835"] = {name = "Scroll Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://6475612857"] = {name = "Shuttle Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5882028350"] = {name = "Skull Drum", prices = {["default"] = 5.25}},
    ["rbxassetid://4470749413"] = {name = "Sleigh Bells Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://6059308940"] = {name = "Snowball Launcher", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671626"] = {name = "Snowman Plush", prices = {["default"] = 4.72}},
    ["rbxassetid://4470749691"] = {name = "Snowman Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750120"] = {name = "Sock Chew Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052387"] = {name = "Squid Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468930"] = {name = "Staff Ingredient", prices = {["default"] = 31.49}},
    ["rbxassetid://6768659222"] = {name = "Standard Grappling Hook", prices = {["default"] = 2.6}},
    ["rbxassetid://2408055085"] = {name = "Starpower Wand", prices = {["default"] = 65.24}},
    ["rbxassetid://3009779638"] = {name = "Telescope Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4710374217"] = {name = "Tennis Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4464390422"] = {name = "Turkey Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://3977264097"] = {name = "Unicorn Leash", prices = {["default"] = 9.19}},
    ["rbxassetid://3570154347"] = {name = "Unicorn Plush", prices = {["default"] = 275.63}},
    ["rbxassetid://2408055086"] = {name = "Wooden Pogo", prices = {["default"] = 3.2}},
    ["rbxassetid://4155284126"] = {name = "Zombie Buffalo Plush", prices = {["default"] = 89.14}},
    ["rbxassetid://4880426741"] = {name = "Adventurer's Hood", prices = {["default"] = 2.61}},
    ["rbxassetid://4880426585"] = {name = "Adventurer's Sword", prices = {["default"] = 6.29}},
    ["rbxassetid://5726048254"] = {name = "Amber Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973461"] = {name = "Angel Wings", prices = {["default"] = 984.38}},
    ["rbxassetid://6380734633"] = {name = "Antenna", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972567"] = {name = "Aviators", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973554"] = {name = "Bat Wings", prices = {["default"] = 14.39}},
    ["rbxassetid://6380843886"] = {name = "Bee Hive", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734557"] = {name = "Bee Wings", prices = {["default"] = 4.98}},
    ["rbxassetid://4849973352"] = {name = "Beret", prices = {["default"] = 2.1}},
    ["rbxassetid://5881347869"] = {name = "Bewitched Hat", prices = {["default"] = 3.82}},
    ["rbxassetid://5415514537"] = {name = "Black 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415514707"] = {name = "Black Boots", prices = {["default"] = 27.07}},
    ["rbxassetid://5415514845"] = {name = "Black Cozy Hood", prices = {["default"] = 3.12}},
    ["rbxassetid://5415515017"] = {name = "Black Designer Backpack", prices = {["default"] = 6.29}},
    ["rbxassetid://4849975075"] = {name = "Black Fedora", prices = {["default"] = 2.1}},
    ["rbxassetid://5415515284"] = {name = "Black Hightops", prices = {["default"] = 11.82}},
    ["rbxassetid://5415515507"] = {name = "Black Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426690"] = {name = "Black Scarf", prices = {["default"] = 26.17}},
    ["rbxassetid://5415515653"] = {name = "Black Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5444594385"] = {name = "Blue Butterfly Wings", prices = {["default"] = 21.14}},
    ["rbxassetid://4849980085"] = {name = "Blue Cat Ear Headphones", prices = {["default"] = 16.94}},
    ["rbxassetid://5415515800"] = {name = "Blue Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048365"] = {name = "Bone Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426624"] = {name = "Briefcase", prices = {["default"] = 2.1}},
    ["rbxassetid://6706595341"] = {name = "Bunny Ear Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975457"] = {name = "Buttoned Ushanka", prices = {["default"] = 10.5}},
    ["rbxassetid://4849978837"] = {name = "Buzz Off! Skateboard", prices = {["default"] = 2.1}},
    ["rbxassetid://5415516304"] = {name = "Cassette", prices = {["default"] = 26.24}},
    ["rbxassetid://4849975557"] = {name = "Chef Hat", prices = {["default"] = 16.79}},
    ["rbxassetid://6380734302"] = {name = "Cherry Earrings", prices = {["default"] = 5.25}},
    ["rbxassetid://6706591422"] = {name = "Chick Backpack", prices = {["default"] = 2.37}},
    ["rbxassetid://6706592723"] = {name = "Chick Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975633"] = {name = "Chicken Hat", prices = {["default"] = 26.25}},
    ["rbxassetid://4849972658"] = {name = "Clout Goggles", prices = {["default"] = 10.58}},
    ["rbxassetid://4849975702"] = {name = "Conductor Hat", prices = {["default"] = 73.05}},
    ["rbxassetid://4936545219"] = {name = "Cutlass", prices = {["default"] = 140.91}},
    ["rbxassetid://4849972740"] = {name = "Cyborg Shades", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037745"] = {name = "Daisy Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7601648534"] = {name = "Eco Blue Reusable Bottle Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542826699"] = {name = "Eco Blue Solar Panel Backpack", prices = {["default"] = 2.37}},
    ["rbxassetid://7542810947"] = {name = "Eco Brown Branch Headphones", prices = {["default"] = 9.19}},
    ["rbxassetid://7542815049"] = {name = "Eco Brown Hiking Backpack", prices = {["default"] = 32.75}},
    ["rbxassetid://7542816175"] = {name = "Eco Green Leaf Afro", prices = {["default"] = 2.63}},
    ["rbxassetid://7542816369"] = {name = "Eco Green Leaf Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810810"] = {name = "Eco Orange Leaf Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542820583"] = {name = "Eco Orange Maple Cape", prices = {["default"] = 11.17}},
    ["rbxassetid://7542810709"] = {name = "Eco Orange Maple Earrings", prices = {["default"] = 8.46}},
    ["rbxassetid://7542817978"] = {name = "Eco Orange Maple Leaf Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://7542823324"] = {name = "Eco Orange Pumpkin Eyepatch", prices = {["default"] = 2.1}},
    ["rbxassetid://7542824283"] = {name = "Eco Orange Pumpkin Pie Wings", prices = {["default"] = 49.73}},
    ["rbxassetid://7542813412"] = {name = "Eco Red Cranberry Branch Wings", prices = {["default"] = 25.55}},
    ["rbxassetid://7542821672"] = {name = "Eco Red Mushroom Hood", prices = {["default"] = 3.93}},
    ["rbxassetid://6706593596"] = {name = "Egg Barrette", prices = {["default"] = 2.1}},
    ["rbxassetid://6706594347"] = {name = "Egg Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4850383048"] = {name = "Elf Hat", prices = {["default"] = 111.97}},
    ["rbxassetid://4849976006"] = {name = "Explorer Hat", prices = {["default"] = 2.61}},
    ["rbxassetid://4933495463"] = {name = "Eyepatch", prices = {["default"] = 7.74}},
    ["rbxassetid://6060998776"] = {name = "Festive Tree Hat", prices = {["default"] = 17.07}},
    ["rbxassetid://4853278462"] = {name = "Firey Aura", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979365"] = {name = "First Aid Bag", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976218"] = {name = "Flamenco Hat", prices = {["default"] = 5.25}},
    ["rbxassetid://6437127230"] = {name = "Flower Collar", prices = {["default"] = 9.42}},
    ["rbxassetid://6380734218"] = {name = "Flower Crown", prices = {["default"] = 10.54}},
    ["rbxassetid://5415517076"] = {name = "Flowery Hair Bow", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048455"] = {name = "Forgotten Flower", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734014"] = {name = "Froggy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://6060998635"] = {name = "Fur Boots", prices = {["default"] = 17.74}},
    ["rbxassetid://5415517473"] = {name = "Gold Chain", prices = {["default"] = 86.63}},
    ["rbxassetid://5415517604"] = {name = "Gold Circle Glasses", prices = {["default"] = 2.63}},
    ["rbxassetid://5415517745"] = {name = "Gold Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979471"] = {name = "Golden Headset", prices = {["default"] = 2.63}},
    ["rbxassetid://6380730894"] = {name = "Goth Shoes", prices = {["default"] = 108.86}},
    ["rbxassetid://4849976420"] = {name = "Green Lotus", prices = {["default"] = 5.25}},
    ["rbxassetid://7368039312"] = {name = "Growing Flower Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4489907389"] = {name = "Halo", prices = {["default"] = 1245.57}},
    ["rbxassetid://5444594659"] = {name = "Handheld", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976512"] = {name = "Head Chef", prices = {["default"] = 186.89}},
    ["rbxassetid://5067924536"] = {name = "Head Tie", prices = {["default"] = 6.35}},
    ["rbxassetid://6404037642"] = {name = "Headband", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979572"] = {name = "Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521592"] = {name = "Hoop Earrings", prices = {["default"] = 2.63}},
    ["rbxassetid://6060991420"] = {name = "Ice Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991330"] = {name = "Ice Earrings", prices = {["default"] = 2.63}},
    ["rbxassetid://6060991245"] = {name = "Ice Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973617"] = {name = "Jade Moth Wings", prices = {["default"] = 10.47}},
    ["rbxassetid://4849979214"] = {name = "Jeff's Nametag", prices = {["default"] = 47.14}},
    ["rbxassetid://5415517859"] = {name = "Jetpack", prices = {["default"] = 2.61}},
    ["rbxassetid://5067924626"] = {name = "Kitsune Mask", prices = {["default"] = 3.94}},
    ["rbxassetid://4849973992"] = {name = "Lavender Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730364"] = {name = "Leaf Wings", prices = {["default"] = 3.56}},
    ["rbxassetid://6380730271"] = {name = "Leprechaun Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278902"] = {name = "Luggage", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924890"] = {name = "Monkey King Crown", prices = {["default"] = 78.17}},
    ["rbxassetid://4849977086"] = {name = "Monocle", prices = {["default"] = 9.19}},
    ["rbxassetid://4849979887"] = {name = "Moon Tome", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976759"] = {name = "Morion", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048545"] = {name = "Nautilus Shell Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976912"] = {name = "Ninja Headband", prices = {["default"] = 3.42}},
    ["rbxassetid://6404037449"] = {name = "Orange Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727237"] = {name = "Orange Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977244"] = {name = "Party Crown", prices = {["default"] = 2.61}},
    ["rbxassetid://5415523249"] = {name = "Pearl Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727177"] = {name = "Picnic Basket", prices = {["default"] = 3.85}},
    ["rbxassetid://5415518324"] = {name = "Pink 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518474"] = {name = "Pink Boots", prices = {["default"] = 11.71}},
    ["rbxassetid://5444594884"] = {name = "Pink Butterfly Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979637"] = {name = "Pink Cat Ear Headphones", prices = {["default"] = 53.72}},
    ["rbxassetid://5415518613"] = {name = "Pink Designer Backpack", prices = {["default"] = 3.94}},
    ["rbxassetid://4849972826"] = {name = "Pink Heart Glasses", prices = {["default"] = 52.48}},
    ["rbxassetid://5457768184"] = {name = "Pink Hightops", prices = {["default"] = 3.7}},
    ["rbxassetid://5415518811"] = {name = "Pink Instant Camera", prices = {["default"] = 6.57}},
    ["rbxassetid://4849977427"] = {name = "Pink Lotus", prices = {["default"] = 2.63}},
    ["rbxassetid://5415520296"] = {name = "Pink Sneakers", prices = {["default"] = 3.84}},
    ["rbxassetid://4849977514"] = {name = "Pirate Hat", prices = {["default"] = 2.63}},
    ["rbxassetid://5444711861"] = {name = "Platinum Tiara", prices = {["default"] = 22.99}},
    ["rbxassetid://4849977607"] = {name = "Propeller Hat", prices = {["default"] = 95.81}},
    ["rbxassetid://4849972928"] = {name = "Purple Heart Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727007"] = {name = "Purple Masquerade Mask", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977695"] = {name = "Purple Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037362"] = {name = "Rain Boots", prices = {["default"] = 75.51}},
    ["rbxassetid://5415520831"] = {name = "Rain Hat", prices = {["default"] = 10.58}},
    ["rbxassetid://7498079214"] = {name = "RB Battles Trophy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977830"] = {name = "Red Beanie", prices = {["default"] = 2.1}},
    ["rbxassetid://6380847814"] = {name = "Red Masquerade Mask", prices = {["default"] = 3.93}},
    ["rbxassetid://5415520972"] = {name = "Red Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521183"] = {name = "Red Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973276"] = {name = "Reindeer Antlers", prices = {["default"] = 15.65}},
    ["rbxassetid://4933495361"] = {name = "Respectful Mustache", prices = {["default"] = 67.9}},
    ["rbxassetid://8151013513"] = {name = "RGB Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978102"] = {name = "Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495425"] = {name = "Ruff", prices = {["default"] = 60.29}},
    ["rbxassetid://4849978200"] = {name = "Sailor Cap", prices = {["default"] = 91.88}},
    ["rbxassetid://4850382817"] = {name = "Santa Hat", prices = {["default"] = 338.54}},
    ["rbxassetid://5881348094"] = {name = "Scythe", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278537"] = {name = "Shadow Aura", prices = {["default"] = 89.2}},
    ["rbxassetid://4849980009"] = {name = "Shadow Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973681"] = {name = "Shadow Wings", prices = {["default"] = 157.47}},
    ["rbxassetid://4849972466"] = {name = "Shark Fin", prices = {["default"] = 3.93}},
    ["rbxassetid://4849973100"] = {name = "Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521379"] = {name = "Silver Chain", prices = {["default"] = 4.72}},
    ["rbxassetid://4849974099"] = {name = "Skeleton Shell", prices = {["default"] = 2.1}},
    ["rbxassetid://4849974434"] = {name = "Spike Collar", prices = {["default"] = 20.98}},
    ["rbxassetid://6380723429"] = {name = "Strawberry Hat", prices = {["default"] = 57.75}},
    ["rbxassetid://4849975162"] = {name = "Sun Tome", prices = {["default"] = 3.66}},
    ["rbxassetid://4849976090"] = {name = "Sushi Skateboard", prices = {["default"] = 23.63}},
    ["rbxassetid://4849976985"] = {name = "Turtle Shell", prices = {["default"] = 3.12}},
    ["rbxassetid://4849978035"] = {name = "Watermelon Backpack", prices = {["default"] = 6.02}},
    ["rbxassetid://5415522308"] = {name = "White Designer Backpack", prices = {["default"] = 9.17}},
    ["rbxassetid://5415522533"] = {name = "White Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979019"] = {name = "Windup Key", prices = {["default"] = 31.7}},
    ["rbxassetid://4849977314"] = {name = "Witch Hat", prices = {["default"] = 7.64}},
    ["rbxassetid://4849978608"] = {name = "Wizard Hat", prices = {["default"] = 6.35}},
    ["rbxassetid://5415522859"] = {name = "Yellow Designer Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5415522973"] = {name = "Yellow Instant Camera", prices = {["default"] = 6.55}},
    ["rbxassetid://5415523115"] = {name = "Yellow Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277758"] = {name = "Airplane Stroller", prices = {["default"] = 30.61}},
    ["rbxassetid://2657667120"] = {name = "Baby Basket Stroller", prices = {["default"] = 45.94}},
    ["rbxassetid://2761277454"] = {name = "Balloon Stroller", prices = {["default"] = 2.63}},
    ["rbxassetid://3009779202"] = {name = "Banana Stroller", prices = {["default"] = 2.63}},
    ["rbxassetid://3082046286"] = {name = "Bunny Stroller", prices = {["default"] = 43.31}},
    ["rbxassetid://3009779260"] = {name = "Cannon Stroller", prices = {["default"] = 3.56}},
    ["rbxassetid://3269748269"] = {name = "Car Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6475616233"] = {name = "Catapult Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248341"] = {name = "Cauldron Stroller", prices = {["default"] = 7.39}},
    ["rbxassetid://2408051111"] = {name = "Cradle Stroller", prices = {["default"] = 102.92}},
    ["rbxassetid://4361544460"] = {name = "Crate Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3486905775"] = {name = "Dog House Stroller", prices = {["default"] = 2.63}},
    ["rbxassetid://1408016951"] = {name = "Double Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1406692267"] = {name = "Droplet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277656"] = {name = "Duck Stroller", prices = {["default"] = 65.63}},
    ["rbxassetid://3082046174"] = {name = "Easter Egg Stroller", prices = {["default"] = 36.99}},
    ["rbxassetid://2761277703"] = {name = "Egg Stroller", prices = {["default"] = 1576.37}},
    ["rbxassetid://4822522123"] = {name = "Flower Stroller", prices = {["default"] = 46.49}},
    ["rbxassetid://3009779395"] = {name = "French Fries Stroller", prices = {["default"] = 6.57}},
    ["rbxassetid://3082046130"] = {name = "Half Egg Stroller", prices = {["default"] = 26.25}},
    ["rbxassetid://3486906113"] = {name = "Hatched Egg Stroller", prices = {["default"] = 2.37}},
    ["rbxassetid://2848462165"] = {name = "Heart Stroller", prices = {["default"] = 249.38}},
    ["rbxassetid://6475613319"] = {name = "High Heel Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6967530077"] = {name = "Hover Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670917"] = {name = "Ice Cream Stroller", prices = {["default"] = 15.74}},
    ["rbxassetid://3486906383"] = {name = "Kangaroo Stroller", prices = {["default"] = 6.57}},
    ["rbxassetid://7368046225"] = {name = "Lunar Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936630605"] = {name = "Magic Carpet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936629525"] = {name = "Magic Moon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6309085791"] = {name = "Palanquin Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936631399"] = {name = "Pelican Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670918"] = {name = "Pizza Stroller", prices = {["default"] = 42.37}},
    ["rbxassetid://3009779443"] = {name = "Popsicle Stroller", prices = {["default"] = 7.88}},
    ["rbxassetid://6936628317"] = {name = "Princess Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://5882036757"] = {name = "Pumpkin Stroller", prices = {["default"] = 3.93}},
    ["rbxassetid://2408052388"] = {name = "Quad Stroller", prices = {["default"] = 170.61}},
    ["rbxassetid://2408035750"] = {name = "Race Car Stroller", prices = {["default"] = 43.08}},
    ["rbxassetid://6710108407"] = {name = "Rainbow Stroller", prices = {["default"] = 57.75}},
    ["rbxassetid://4470748252"] = {name = "Reindeer Stroller", prices = {["default"] = 11.8}},
    ["rbxassetid://8526099597"] = {name = "RGB Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2981204560"] = {name = "Rocket Ship Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://13986982302"] = {name = "Shopping Cart Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936628967"] = {name = "Teacup Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2982964426"] = {name = "Throne Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671637"] = {name = "Trike Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544584"] = {name = "Triple Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277803"] = {name = "Unicorn Stroller", prices = {["default"] = 61.69}},
    ["rbxassetid://2466291803"] = {name = "Vampire Stroller", prices = {["default"] = 104.56}},
    ["rbxassetid://3066606234"] = {name = "Wheelbarrow Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://113061955717247"] = {name = "Admin Abuse Box", prices = {["default"] = 2.1}},
    ["rbxassetid://5888839551"] = {name = "Bat Box", prices = {["default"] = 99.3}},
    ["rbxassetid://4510471983"] = {name = "Golden Gift", prices = {["default"] = 1048.69}},
    ["rbxassetid://5057100696"] = {name = "Monkey Box", prices = {["default"] = 188.61}},
    ["rbxassetid://6240246974"] = {name = "Ox Box", prices = {["default"] = 12.69}},
    ["rbxassetid://5067925110"] = {name = "Premium Monkey Box", prices = {["default"] = 1057.4}},
    ["rbxassetid://4621220017"] = {name = "Rat Box", prices = {["default"] = 420}},
    ["rbxassetid://8604215904"] = {name = "RGB Reward Box", prices = {["default"] = 3.93}},
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