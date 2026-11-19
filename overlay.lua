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
    ["rbxassetid://137637490639925"] = {name = "Royal Mistletroll", prices = {["default"] = 1110.38, ["Ride"] = 1050, ["Fly|Ride"] = 1025.07, ["Neon|Fly|Ride"] = 8372.94}},
    ["rbxassetid://140355753768438"] = {name = "Moonbeam Peacock", prices = {["default"] = 439.53, ["Ride"] = 420.56, ["Fly|Ride"] = 530.58, ["Neon|Fly|Ride"] = 2930.54, ["Mega|Fly|Ride"] = 8368.75}},
    ["rbxassetid://18117855573"] = {name = "Balloon Unicorn", prices = {["default"] = 6278.94, ["Ride"] = 5250, ["Fly|Ride"] = 5105.63, ["Neon"] = 25816.87, ["Neon|Fly|Ride"] = 19799.89, ["Mega|Fly|Ride"] = 55820.19}},
    ["rbxassetid://75782719698946"] = {name = "Red Dutch Guinea Pig", prices = {["default"] = 118.13, ["Ride"] = 202.08, ["Fly|Ride"] = 580.63, ["Neon"] = 1186.87, ["Neon|Ride"] = 747.44, ["Neon|Fly|Ride"] = 801.94, ["Mega"] = 3490.48, ["Mega|Fly|Ride"] = 6199.03}},
    ["rbxassetid://5067924142"] = {name = "Albino Monkey", prices = {["default"] = 591.68, ["Ride"] = 491.4, ["Fly|Ride"] = 603.75, ["Neon|Fly|Ride"] = 1508.07, ["Mega"] = 11048.76, ["Mega|Fly|Ride"] = 11621.7}},
    ["rbxassetid://108312620331321"] = {name = "Villain Gibbon", prices = {["default"] = 9.31, ["Ride"] = 46.52, ["Fly|Ride"] = 148.67, ["Neon"] = 41.89, ["Neon|Ride"] = 144.38, ["Neon|Fly|Ride"] = 310.31, ["Mega"] = 280.88, ["Mega|Ride"] = 590.63, ["Mega|Fly|Ride"] = 409.5}},
    ["rbxassetid://17255958862"] = {name = "Alicorn", prices = {["default"] = 5.16, ["Fly"] = 31.5, ["Ride"] = 31.4, ["Fly|Ride"] = 56.44, ["Neon"] = 28.28, ["Neon|Fly"] = 85.84, ["Neon|Ride"] = 48.24, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 93.19, ["Mega|Ride"] = 195.74, ["Mega|Fly|Ride"] = 223.99}},
    ["rbxassetid://90170598608675"] = {name = "Moonbeam Butterfly", prices = {["default"] = 99.49, ["Fly"] = 119.31, ["Ride"] = 158.82, ["Fly|Ride"] = 139.37, ["Neon"] = 540.06, ["Neon|Ride"] = 418.08, ["Neon|Fly|Ride"] = 698.12, ["Mega|Fly|Ride"] = 1947.77}},
    ["rbxassetid://7126722445"] = {name = "Goldhorn", prices = {["default"] = 45.94, ["Ride"] = 56.7, ["Fly|Ride"] = 101.43, ["Neon"] = 375.38, ["Neon|Ride"] = 202.23, ["Neon|Fly|Ride"] = 262.71, ["Mega|Ride"] = 1255.15, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://13186021971"] = {name = "Cuddly Candle", prices = {["default"] = 21.04, ["Fly"] = 94.5, ["Ride"] = 41.88, ["Fly|Ride"] = 49.51, ["Neon"] = 279.46, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 204.75, ["Mega|Fly|Ride"] = 620.62}},
    ["rbxassetid://14146196672"] = {name = "Gargoyle", prices = {["default"] = 54.44, ["Ride"] = 77.22, ["Fly|Ride"] = 98.39, ["Neon"] = 276.32, ["Neon|Ride"] = 217.88, ["Neon|Fly|Ride"] = 276.62, ["Mega|Fly|Ride"] = 1122.19}},
    ["rbxassetid://129762233626342"] = {name = "Royal Moon Egg", prices = {["default"] = 77.44}},
    ["rbxassetid://89693546199400"] = {name = "Cupid Dragon", prices = {["default"] = 413.37, ["Fly"] = 315, ["Ride"] = 334.69, ["Fly|Ride"] = 406.88, ["Neon|Ride"] = 1273.13, ["Neon|Fly|Ride"] = 1246.88, ["Mega|Fly|Ride"] = 4605.13}},
    ["rbxassetid://8665606875"] = {name = "Dancing Dragon", prices = {["default"] = 136.06, ["Ride"] = 127.32, ["Fly|Ride"] = 131.24, ["Neon|Fly|Ride"] = 607.69, ["Mega|Fly|Ride"] = 2721.22}},
    ["rbxassetid://110411427278536"] = {name = "Huntsman Robin", prices = {["default"] = 3.52, ["Ride"] = 32.82, ["Fly|Ride"] = 62.82, ["Neon"] = 20.95, ["Neon|Fly"] = 61.77, ["Neon|Ride"] = 70.14, ["Mega"] = 98.4, ["Mega|Ride"] = 189, ["Mega|Fly|Ride"] = 144.38}},
    ["rbxassetid://10925517718"] = {name = "Lava Dragon", prices = {["default"] = 155.65, ["Fly"] = 154.9, ["Ride"] = 156.98, ["Fly|Ride"] = 166.69, ["Neon"] = 816.38, ["Neon|Fly|Ride"] = 484.71, ["Mega|Fly|Ride"] = 1968.75}},
    ["rbxassetid://4797806482"] = {name = "Diamond Griffin", prices = {["default"] = 3.51, ["Fly"] = 27.29, ["Ride"] = 19.69, ["Fly|Ride"] = 45.94, ["Neon"] = 18.38, ["Neon|Ride"] = 69.09, ["Mega|Ride"] = 326.82, ["Mega|Fly|Ride"] = 292.02}},
    ["rbxassetid://122648024705835"] = {name = "Scarebear", prices = {["default"] = 46.47, ["Fly"] = 140.44, ["Ride"] = 75.35, ["Fly|Ride"] = 118.13, ["Neon"] = 193.98, ["Neon|Ride"] = 182.44, ["Neon|Fly|Ride"] = 293.07, ["Mega"] = 977.55, ["Mega|Ride"] = 1127.89, ["Mega|Fly|Ride"] = 810.1}},
    ["rbxassetid://13104102169"] = {name = "Danger Egg", prices = {["default"] = 51.07}},
    ["rbxassetid://133163961974577"] = {name = "2D Doggy", prices = {["default"] = 64.32, ["Ride"] = 459.38, ["Neon"] = 279.46, ["Neon|Ride"] = 498.75, ["Mega|Fly|Ride"] = 3099.52}},
    ["rbxassetid://126071806166898"] = {name = "Evil Chick", prices = {["default"] = 15.7, ["Fly"] = 393.75, ["Ride"] = 72.19, ["Fly|Ride"] = 223.13, ["Neon"] = 154.92, ["Neon|Ride"] = 360.94, ["Neon|Fly|Ride"] = 259.58, ["Mega"] = 464.88, ["Mega|Ride"] = 757.77}},
    ["rbxassetid://5721843247"] = {name = "Dodo", prices = {["default"] = 34.13, ["Fly"] = 61.93, ["Ride"] = 59.07, ["Fly|Ride"] = 125.55, ["Neon"] = 530.64, ["Neon|Ride"] = 156.19, ["Neon|Fly|Ride"] = 209.34, ["Mega"] = 2293.15, ["Mega|Fly|Ride"] = 810.1}},
    ["rbxassetid://119640582603552"] = {name = "Violet Butterfly", prices = {["default"] = 45.03, ["Fly"] = 92.11, ["Ride"] = 155.76, ["Fly|Ride"] = 196.88, ["Neon"] = 236.24, ["Neon|Ride"] = 223.12, ["Neon|Fly|Ride"] = 209.34, ["Mega"] = 1674.6, ["Mega|Ride"] = 1251.76, ["Mega|Fly|Ride"] = 1254.9}},
    ["rbxassetid://16088264958"] = {name = "Volcanic Rhino", prices = {["default"] = 35.95, ["Ride"] = 52.5, ["Fly|Ride"] = 192.94, ["Neon"] = 170.62, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 7898.82, ["Mega"] = 1207.92, ["Mega|Ride"] = 2100, ["Mega|Fly|Ride"] = 977.55}},
    ["rbxassetid://75251818654427"] = {name = "Apple Owl", prices = {["default"] = 52.5, ["Ride"] = 74.32, ["Fly|Ride"] = 135.19, ["Neon"] = 279.46, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 492.19, ["Mega|Ride"] = 1019.29, ["Mega|Fly|Ride"] = 1199.43}},
    ["rbxassetid://3181727433"] = {name = "Dragon", prices = {["default"] = 5.25, ["Fly"] = 30.18, ["Ride"] = 23.24, ["Fly|Ride"] = 44.63, ["Neon"] = 29.93, ["Neon|Fly"] = 65.72, ["Neon|Ride"] = 41.85, ["Neon|Fly|Ride"] = 70.88, ["Mega"] = 204.37, ["Mega|Fly"] = 27944.64, ["Mega|Ride"] = 154.88, ["Mega|Fly|Ride"] = 226.91}},
    ["rbxassetid://121496682360324"] = {name = "Sugar Axolotl", prices = {["default"] = 300.4, ["Ride"] = 320.25, ["Fly|Ride"] = 362.25, ["Neon"] = 1590.87, ["Neon|Ride"] = 3035.2, ["Neon|Fly|Ride"] = 2015.22, ["Mega|Fly|Ride"] = 5917.55}},
    ["rbxassetid://11694854226"] = {name = "Shetland Pony Light Brown", prices = {["default"] = 11.87, ["Ride"] = 36.75, ["Neon"] = 391.44, ["Mega|Fly|Ride"] = 786.02}},
    ["rbxassetid://4797806957"] = {name = "Golden Unicorn", prices = {["default"] = 5.25, ["Fly"] = 37.94, ["Ride"] = 21, ["Fly|Ride"] = 48.57, ["Neon"] = 35.6, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 141.31, ["Mega"] = 368.43, ["Mega|Fly|Ride"] = 371.44}},
    ["rbxassetid://110822620060051"] = {name = "Frost Phoenix", prices = {["default"] = 99.9, ["Fly"] = 133.2, ["Ride"] = 106.85, ["Fly|Ride"] = 167.48, ["Neon"] = 393.75, ["Neon|Ride"] = 288.75, ["Neon|Fly|Ride"] = 425.99, ["Mega"] = 6158.36, ["Mega|Fly"] = 1455.04, ["Mega|Fly|Ride"] = 1670.21}},
    ["rbxassetid://13894724323"] = {name = "Billy Goat", prices = {["default"] = 13.13, ["Ride"] = 28.88, ["Fly|Ride"] = 115.5, ["Neon"] = 189, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 207.38, ["Mega|Ride"] = 590.63, ["Mega|Fly|Ride"] = 618.56}},
    ["rbxassetid://123037843357105"] = {name = "Glormy Leo", prices = {["default"] = 196.88, ["Fly"] = 356.51, ["Ride"] = 232.33, ["Fly|Ride"] = 418.66, ["Neon"] = 975.47, ["Neon|Ride"] = 748.46, ["Neon|Fly|Ride"] = 816.38, ["Mega|Fly|Ride"] = 3082.09}},
    ["rbxassetid://12479078933"] = {name = "Southeast Asia Egg", prices = {["default"] = 37.7}},
    ["rbxassetid://122739780018633"] = {name = "Quetzalcoatl", prices = {["default"] = 5.16, ["Fly"] = 279.42, ["Ride"] = 27.57, ["Fly|Ride"] = 115.5, ["Neon"] = 21, ["Neon|Fly"] = 70.14, ["Neon|Ride"] = 60.38, ["Neon|Fly|Ride"] = 310.31, ["Mega"] = 131.25, ["Mega|Ride"] = 167.48, ["Mega|Fly|Ride"] = 647.07}},
    ["rbxassetid://70953296065239"] = {name = "Frostbite Bear", prices = {["default"] = 669.38, ["Ride"] = 918.75, ["Fly|Ride"] = 918.75, ["Neon"] = 5582.66, ["Neon|Ride"] = 5906.25, ["Neon|Fly|Ride"] = 3278.63, ["Mega"] = 30838.17, ["Mega|Ride"] = 52297.63, ["Mega|Fly|Ride"] = 11161.12}},
    ["rbxassetid://14978701948"] = {name = "Scarecrow Crow", prices = {["default"] = 7.87, ["Ride"] = 46.07, ["Fly|Ride"] = 123.78, ["Neon"] = 70.14, ["Neon|Ride"] = 139.86, ["Neon|Fly|Ride"] = 174.8, ["Mega"] = 787.5, ["Mega|Ride"] = 604.95, ["Mega|Fly|Ride"] = 820.32}},
    ["rbxassetid://11191341630"] = {name = "Jousting Horse", prices = {["default"] = 111.57, ["Ride"] = 120.37, ["Fly|Ride"] = 265.85, ["Neon"] = 661.47, ["Neon|Ride"] = 514.5, ["Neon|Fly|Ride"] = 525, ["Mega|Ride"] = 6074.25, ["Mega|Fly|Ride"] = 2917.99}},
    ["rbxassetid://76801905892592"] = {name = "Royal Aztec Egg", prices = {["default"] = 48.17}},
    ["rbxassetid://98801943598121"] = {name = "Priceless Shrimp", prices = {["default"] = 19.9, ["Ride"] = 74.32, ["Fly|Ride"] = 262.5, ["Neon"] = 99.43, ["Neon|Fly|Ride"] = 472.5, ["Mega"] = 697.32}},
    ["rbxassetid://95214789806437"] = {name = "Aztec Egg", prices = {["default"] = 2.43}},
    ["rbxassetid://18515755354"] = {name = "Cheetah", prices = {["default"] = 128.47, ["Ride"] = 349.55, ["Fly|Ride"] = 353.07, ["Neon|Ride"] = 590.63, ["Neon|Fly|Ride"] = 684.51, ["Mega|Fly|Ride"] = 1962.41}},
    ["rbxassetid://18117855114"] = {name = "Corn Doggo", prices = {["default"] = 124.88, ["Ride"] = 149.34, ["Fly|Ride"] = 262.5, ["Neon"] = 438.37, ["Neon|Ride"] = 420, ["Neon|Fly|Ride"] = 523.69, ["Mega|Ride"] = 1674.6, ["Mega|Fly|Ride"] = 1470}},
    ["rbxassetid://8972175010"] = {name = "Woodland Egg", prices = {["default"] = 51.75}},
    ["rbxassetid://3710823011"] = {name = "Golden Penguin", prices = {["default"] = 52.5, ["Fly"] = 93.49, ["Ride"] = 52.41, ["Fly|Ride"] = 78.49, ["Neon|Ride"] = 391.44, ["Neon|Fly|Ride"] = 391.13, ["Mega|Fly|Ride"] = 1592.07}},
    ["rbxassetid://136490701345923"] = {name = "Glormy Crab", prices = {["default"] = 7.88, ["Ride"] = 28.49, ["Fly|Ride"] = 158.06, ["Neon"] = 41.22, ["Neon|Ride"] = 154.92, ["Neon|Fly|Ride"] = 182.44, ["Mega"] = 236.25, ["Mega|Fly"] = 267.75, ["Mega|Fly|Ride"] = 396.38}},
    ["rbxassetid://14782580581"] = {name = "Vampire Dragon", prices = {["default"] = 339.56, ["Fly"] = 578.82, ["Ride"] = 350.44, ["Fly|Ride"] = 374.07, ["Neon|Ride"] = 3767.84, ["Neon|Fly|Ride"] = 1307.25, ["Mega|Fly|Ride"] = 7437.9}},
    ["rbxassetid://88405494856204"] = {name = "Solaris", prices = {["default"] = 70.88, ["Fly"] = 99.75, ["Ride"] = 98.44, ["Fly|Ride"] = 128.63, ["Neon"] = 293.07, ["Neon|Ride"] = 418.66, ["Neon|Fly|Ride"] = 353.77, ["Mega|Ride"] = 1870.32, ["Mega|Fly|Ride"] = 1641.11}},
    ["rbxassetid://84468510887759"] = {name = "Orchid Butterfly", prices = {["default"] = 3209.59, ["Fly|Ride"] = 3558.51, ["Neon|Fly|Ride"] = 13953.5}},
    ["rbxassetid://11109286837"] = {name = "Lava Wolf", prices = {["default"] = 54.44, ["Fly"] = 223.97, ["Ride"] = 57.75, ["Fly|Ride"] = 110.34, ["Neon"] = 977.55, ["Neon|Ride"] = 272.13, ["Neon|Fly|Ride"] = 263.82, ["Mega|Ride"] = 2093.24, ["Mega|Fly|Ride"] = 1955.09}},
    ["rbxassetid://12403863809"] = {name = "Albino Gorilla", prices = {["default"] = 129.78, ["Ride"] = 52.35, ["Fly|Ride"] = 152.81, ["Neon"] = 397.72, ["Neon|Ride"] = 785.56, ["Neon|Fly|Ride"] = 558.91, ["Mega|Fly|Ride"] = 1513.42}},
    ["rbxassetid://6060988121"] = {name = "Snow Owl", prices = {["default"] = 28.88, ["Fly"] = 76.13, ["Ride"] = 60.19, ["Fly|Ride"] = 115.5, ["Neon"] = 209.34, ["Neon|Ride"] = 140.54, ["Neon|Fly|Ride"] = 149.63, ["Mega"] = 2625, ["Mega|Ride"] = 493.5, ["Mega|Fly|Ride"] = 643.88}},
    ["rbxassetid://112630556645658"] = {name = "Moon Egg", prices = {["default"] = 12.5}},
    ["rbxassetid://10357473556"] = {name = "Golden Chow-Chow", prices = {["default"] = 60.72, ["Fly|Ride"] = 125.58, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 497.16, ["Mega|Fly|Ride"] = 1240.05}},
    ["rbxassetid://5721843384"] = {name = "Fossil Egg", prices = {["default"] = 32.82}},
    ["rbxassetid://92775688228060"] = {name = "Papa Moose", prices = {["default"] = 227.07, ["Ride"] = 234.94, ["Fly|Ride"] = 334.88, ["Neon|Fly|Ride"] = 1451.66}},
    ["rbxassetid://12479991588"] = {name = "Frost Unicorn", prices = {["default"] = 761.25, ["Ride"] = 759.94, ["Fly|Ride"] = 745.5, ["Neon|Fly|Ride"] = 2493.75, ["Mega|Fly|Ride"] = 11812.5}},
    ["rbxassetid://9661880325"] = {name = "Zodiac Minion Egg", prices = {["default"] = 7.88}},
    ["rbxassetid://7126719832"] = {name = "Phoenix", prices = {["default"] = 30.09, ["Fly"] = 66.32, ["Ride"] = 41.88, ["Fly|Ride"] = 77.46, ["Neon"] = 318.19, ["Neon|Ride"] = 198.87, ["Neon|Fly|Ride"] = 208.69, ["Mega|Fly|Ride"] = 753.58}},
    ["rbxassetid://119386690822810"] = {name = "Royal Fairytale Egg", prices = {["default"] = 9.98}},
    ["rbxassetid://4440866299"] = {name = "Crow", prices = {["default"] = 5040, ["Fly|Ride"] = 5145, ["Neon|Fly|Ride"] = 10827.6, ["Mega|Fly|Ride"] = 41683.53}},
    ["rbxassetid://4797806531"] = {name = "Diamond Unicorn", prices = {["default"] = 9.19, ["Fly"] = 42, ["Ride"] = 23.39, ["Fly|Ride"] = 42.62, ["Neon"] = 91.07, ["Neon|Ride"] = 86.63, ["Neon|Fly|Ride"] = 155.74, ["Mega"] = 392.44, ["Mega|Ride"] = 349.58, ["Mega|Fly|Ride"] = 588}},
    ["rbxassetid://88817325500927"] = {name = "Kraken", prices = {["default"] = 17.43, ["Fly"] = 104.67, ["Ride"] = 39.38, ["Fly|Ride"] = 155.66, ["Neon"] = 140.26, ["Neon|Ride"] = 104.9, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 1034.34, ["Mega|Ride"] = 514.95, ["Mega|Fly|Ride"] = 623.8}},
    ["rbxassetid://9490243442"] = {name = "Diamond King Penguin", prices = {["default"] = 83.74, ["Ride"] = 103.69, ["Fly|Ride"] = 140.26, ["Neon"] = 1396.21, ["Neon|Fly|Ride"] = 572.51}},
    ["rbxassetid://107787284008278"] = {name = "Primal Kaijunior", prices = {["default"] = 10.48, ["Ride"] = 31.37, ["Fly|Ride"] = 139.65, ["Neon"] = 78.75, ["Neon|Ride"] = 98.4, ["Mega"] = 498.2, ["Mega|Ride"] = 556.81, ["Mega|Fly|Ride"] = 620.62}},
    ["rbxassetid://4506837037"] = {name = "Arctic Reindeer", prices = {["default"] = 3460.75, ["Ride"] = 3430.81, ["Fly|Ride"] = 2047.5, ["Neon|Fly|Ride"] = 4449.38, ["Mega|Fly|Ride"] = 14374.22}},
    ["rbxassetid://4184878149"] = {name = "Bat Dragon", prices = {["default"] = 32511.24, ["Ride"] = 26250, ["Fly|Ride"] = 24543.75, ["Neon|Ride"] = 65625, ["Neon|Fly|Ride"] = 65588.24, ["Mega"] = 210000, ["Mega|Fly|Ride"] = 195368.53}},
    ["rbxassetid://118641789458122"] = {name = "Gilded Snake", prices = {["default"] = 27.23, ["Fly"] = 393.75, ["Ride"] = 46.47, ["Fly|Ride"] = 90.61, ["Neon"] = 236.25, ["Neon|Ride"] = 279.46, ["Neon|Fly|Ride"] = 418.66, ["Mega"] = 393.75, ["Mega|Ride"] = 732.65, ["Mega|Fly|Ride"] = 695.63}},
    ["rbxassetid://71844856693163"] = {name = "Purrowl", prices = {["default"] = 3.56, ["Fly"] = 46.07, ["Ride"] = 33.71, ["Fly|Ride"] = 94.5, ["Neon"] = 18.86, ["Neon|Fly"] = 128.63, ["Neon|Ride"] = 49.21, ["Neon|Fly|Ride"] = 86.63, ["Mega"] = 125.62, ["Mega|Ride"] = 274.3, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://7195311687"] = {name = "Mythic Egg", prices = {["default"] = 22.32}},
    ["rbxassetid://102330087609546"] = {name = "Fire Mare", prices = {["default"] = 8.39, ["Ride"] = 35.6, ["Fly|Ride"] = 111.56, ["Neon"] = 89.25, ["Neon|Ride"] = 124.69, ["Neon|Fly|Ride"] = 497.43, ["Mega"] = 350.46, ["Mega|Ride"] = 370.13, ["Mega|Fly|Ride"] = 473.82}},
    ["rbxassetid://16659215347"] = {name = "Candyfloss Chick", prices = {["default"] = 774.52, ["Ride"] = 721.88, ["Fly|Ride"] = 971.25, ["Mega|Fly|Ride"] = 10847.7}},
    ["rbxassetid://9281950769"] = {name = "Sugar Glider", prices = {["default"] = 1032.94, ["Fly"] = 1076.25, ["Ride"] = 851.82, ["Fly|Ride"] = 1036.87, ["Neon|Fly|Ride"] = 3846.33, ["Mega|Fly|Ride"] = 19676.37}},
    ["rbxassetid://15485137935"] = {name = "Fleur De Ice", prices = {["default"] = 28.4, ["Fly"] = 116.13, ["Ride"] = 43.19, ["Fly|Ride"] = 126, ["Neon"] = 209.34, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 334.93, ["Mega|Fly|Ride"] = 736.84}},
    ["rbxassetid://6498256269"] = {name = "Ocean Egg", prices = {["default"] = 36.75}},
    ["rbxassetid://8704877940"] = {name = "Lavender Dragon", prices = {["default"] = 56.32, ["Fly"] = 140.25, ["Ride"] = 73.43, ["Fly|Ride"] = 140.44, ["Neon|Fly|Ride"] = 405.05, ["Mega|Fly|Ride"] = 11621.7}},
    ["rbxassetid://13685038182"] = {name = "Leviathan", prices = {["default"] = 74.32, ["Ride"] = 120.37, ["Fly|Ride"] = 62.73, ["Neon"] = 450.19, ["Neon|Ride"] = 620.62, ["Neon|Fly|Ride"] = 15496.38, ["Mega"] = 2109.17, ["Mega|Fly|Ride"] = 2192.65}},
    ["rbxassetid://4797806358"] = {name = "Diamond Dragon", prices = {["default"] = 3.94, ["Fly"] = 32.78, ["Ride"] = 21.83, ["Fly|Ride"] = 65.63, ["Neon"] = 35.6, ["Neon|Ride"] = 71.01, ["Neon|Fly|Ride"] = 115.5, ["Mega"] = 145.69, ["Mega|Fly|Ride"] = 929.75}},
    ["rbxassetid://5862774327"] = {name = "Cerberus", prices = {["default"] = 61.69, ["Fly"] = 78.75, ["Ride"] = 90.56, ["Fly|Ride"] = 131.24, ["Neon|Ride"] = 362.25, ["Neon|Fly|Ride"] = 315, ["Mega|Fly|Ride"] = 1254.9}},
    ["rbxassetid://74012786571707"] = {name = "Three Blind Mice", prices = {["default"] = 3.93, ["Ride"] = 45.94, ["Fly|Ride"] = 73.27, ["Neon"] = 27.23, ["Neon|Fly"] = 265.85, ["Neon|Ride"] = 105.67, ["Mega"] = 155.74, ["Mega|Ride"] = 918.75, ["Mega|Fly|Ride"] = 392.44}},
    ["rbxassetid://15931348363"] = {name = "Criosphinx", prices = {["default"] = 19.69, ["Fly"] = 65.63, ["Ride"] = 31.79, ["Fly|Ride"] = 155.63, ["Neon"] = 147.52, ["Neon|Ride"] = 164.07, ["Neon|Fly|Ride"] = 449.78, ["Mega|Fly|Ride"] = 731.6}},
    ["rbxassetid://118278167134251"] = {name = "Influencer Gibbon", prices = {["default"] = 36.75, ["Ride"] = 46.47, ["Fly|Ride"] = 272.13, ["Neon"] = 140.26, ["Neon|Ride"] = 267.95, ["Mega|Ride"] = 2093.24}},
    ["rbxassetid://17059982206"] = {name = "Dimorphodon", prices = {["default"] = 14.8, ["Fly"] = 189.06, ["Fly|Ride"] = 55.13, ["Neon"] = 110.96, ["Neon|Ride"] = 172.02, ["Neon|Fly|Ride"] = 249.38, ["Mega|Fly|Ride"] = 907.44}},
    ["rbxassetid://119212313534429"] = {name = "Giant Panda", prices = {["default"] = 6976.94, ["Ride"] = 5906.25, ["Fly|Ride"] = 6046.69, ["Neon"] = 34887.88, ["Neon|Fly|Ride"] = 29088.94}},
    ["rbxassetid://6060998707"] = {name = "Frost Fury", prices = {["default"] = 203.44, ["Fly"] = 203.44, ["Ride"] = 209.79, ["Fly|Ride"] = 262.5, ["Neon|Fly|Ride"] = 525, ["Mega|Fly|Ride"] = 2339.21}},
    ["rbxassetid://88882779021298"] = {name = "Kitty Bat", prices = {["default"] = 37.17, ["Fly"] = 77.54, ["Ride"] = 49.88, ["Fly|Ride"] = 136.07, ["Neon"] = 78.75, ["Neon|Fly"] = 144.45, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 314, ["Mega|Ride"] = 384.13, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://16441372760"] = {name = "Diamond Mahi Mahi", prices = {["default"] = 3.3, ["Ride"] = 26.17, ["Fly|Ride"] = 174.79, ["Neon"] = 26.25, ["Neon|Ride"] = 185.96}},
    ["rbxassetid://3199974169"] = {name = "Royal Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://84714602656867"] = {name = "Slimingo", prices = {["default"] = 31.48, ["Fly"] = 70.13, ["Ride"] = 75.35, ["Fly|Ride"] = 148.32, ["Neon"] = 114.19, ["Neon|Ride"] = 162.75, ["Neon|Fly|Ride"] = 318.94, ["Mega"] = 418.66, ["Mega|Ride"] = 434.36, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://3409443710"] = {name = "Giraffe", prices = {["default"] = 18571.88, ["Ride"] = 17386.36, ["Fly|Ride"] = 11418.75, ["Neon|Fly|Ride"] = 23625}},
    ["rbxassetid://121215031043780"] = {name = "Velocirooster", prices = {["default"] = 141.31, ["Ride"] = 157.5, ["Fly|Ride"] = 266.9, ["Neon|Fly|Ride"] = 974.42}},
    ["rbxassetid://5067925034"] = {name = "Ninja Monkey", prices = {["default"] = 45.94, ["Fly"] = 459.38, ["Ride"] = 58.63, ["Fly|Ride"] = 104.99, ["Neon|Fly"] = 464.88, ["Neon|Ride"] = 272.13, ["Neon|Fly|Ride"] = 265.85, ["Mega|Fly|Ride"] = 1626.45}},
    ["rbxassetid://10618035564"] = {name = "Baku", prices = {["default"] = 8.29, ["Ride"] = 31.5, ["Fly|Ride"] = 52.35, ["Neon"] = 250.14, ["Neon|Ride"] = 111.57, ["Neon|Fly|Ride"] = 279.46, ["Mega"] = 475.17, ["Mega|Ride"] = 492.19}},
    ["rbxassetid://13665641282"] = {name = "Shark Puppy", prices = {["default"] = 389.82, ["Ride"] = 462, ["Fly|Ride"] = 392.05, ["Neon"] = 1640.63, ["Neon|Ride"] = 1582.88, ["Neon|Fly|Ride"] = 1364.99, ["Mega|Fly|Ride"] = 4935}},
    ["rbxassetid://119447343321908"] = {name = "Tealwood Monster", prices = {["default"] = 6.83, ["Ride"] = 95.25, ["Fly|Ride"] = 140.26, ["Neon"] = 32.82, ["Neon|Ride"] = 100.49, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 157.49, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://85568505745239"] = {name = "Latte Kitsune", prices = {["default"] = 150.7, ["Ride"] = 165.38, ["Fly|Ride"] = 208.57, ["Neon"] = 527.26, ["Neon|Ride"] = 422.63, ["Neon|Fly|Ride"] = 459.38, ["Mega"] = 2233.5, ["Mega|Fly|Ride"] = 1744.32}},
    ["rbxassetid://3181727727"] = {name = "Griffin", prices = {["default"] = 10.5, ["Fly"] = 15.84, ["Ride"] = 18.38, ["Fly|Ride"] = 39.29, ["Neon|Ride"] = 102.29, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 2511.89, ["Mega|Fly|Ride"] = 572.51}},
    ["rbxassetid://4822753215"] = {name = "Golden Egg", prices = {["default"] = 10.33}},
    ["rbxassetid://116463571924920"] = {name = "Prismatic Butterfly", prices = {["default"] = 62.79, ["Ride"] = 121.42, ["Fly|Ride"] = 525, ["Neon"] = 406.88, ["Neon|Fly"] = 1674.6, ["Neon|Ride"] = 358.21, ["Neon|Fly|Ride"] = 405.05, ["Mega"] = 1116.75, ["Mega|Fly|Ride"] = 1814.85}},
    ["rbxassetid://8596153183"] = {name = "Chameleon", prices = {["default"] = 15.7, ["Ride"] = 31.4, ["Fly|Ride"] = 62.79, ["Neon"] = 97.13, ["Neon|Ride"] = 106.32, ["Neon|Fly|Ride"] = 210.79, ["Mega|Ride"] = 530.64, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://110774856122162"] = {name = "Gemstone Egg", prices = {["default"] = 15.75}},
    ["rbxassetid://14892649590"] = {name = "Dire Stag", prices = {["default"] = 39.79, ["Fly"] = 210, ["Ride"] = 78.75, ["Fly|Ride"] = 929.01, ["Neon"] = 133.88, ["Neon|Ride"] = 207.36, ["Neon|Fly|Ride"] = 257.49, ["Mega"] = 1535.4, ["Mega|Ride"] = 729.75, ["Mega|Fly|Ride"] = 728.44}},
    ["rbxassetid://106744890070136"] = {name = "Oakee Wizard", prices = {["default"] = 3.94, ["Neon"] = 19.06, ["Neon|Ride"] = 137.12, ["Neon|Fly|Ride"] = 279.46, ["Mega"] = 96.66, ["Mega|Ride"] = 334.93, ["Mega|Fly|Ride"] = 442.74}},
    ["rbxassetid://9938967576"] = {name = "Chocolate Chow-Chow", prices = {["default"] = 18.38, ["Fly"] = 42, ["Ride"] = 35.6, ["Fly|Ride"] = 190.32, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 118.13, ["Mega|Fly|Ride"] = 764.05}},
    ["rbxassetid://9174893483"] = {name = "Mechapup", prices = {["default"] = 393.75, ["Fly"] = 437.75, ["Ride"] = 367.5, ["Fly|Ride"] = 393.75, ["Neon|Fly"] = 1359.57, ["Neon|Fly|Ride"] = 1793.92, ["Mega|Fly|Ride"] = 8791.59}},
    ["rbxassetid://15292843858"] = {name = "Mecha Meow", prices = {["default"] = 52.49, ["Ride"] = 109.16, ["Neon"] = 253.32, ["Neon|Ride"] = 205.15, ["Mega|Ride"] = 681.45, ["Mega|Fly|Ride"] = 1056.47}},
    ["rbxassetid://15931200262"] = {name = "Cactus Friend", prices = {["default"] = 44.02, ["Ride"] = 73.27, ["Fly|Ride"] = 125.62, ["Neon|Ride"] = 165.37, ["Neon|Fly|Ride"] = 630, ["Mega|Ride"] = 1050, ["Mega|Fly|Ride"] = 1521.8}},
    ["rbxassetid://127221459636244"] = {name = "Strawberry Shortcake Ducky", prices = {["default"] = 33.51, ["Fly"] = 95.23, ["Ride"] = 56.6, ["Fly|Ride"] = 102.58, ["Neon"] = 65.63, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 284.69, ["Mega"] = 368.24, ["Mega|Ride"] = 350.44, ["Mega|Fly|Ride"] = 526.46}},
    ["rbxassetid://4470748644"] = {name = "Frost Dragon", prices = {["default"] = 11287.5, ["Ride"] = 11279.8, ["Fly|Ride"] = 7940.63, ["Neon|Fly|Ride"] = 17062.5, ["Mega|Fly|Ride"] = 37406.25}},
    ["rbxassetid://15365667976"] = {name = "Chocolate Chip Bat Dragon", prices = {["Fly"] = 2554.74, ["Ride"] = 2329.49, ["Fly|Ride"] = 2021.25, ["Neon"] = 4593.75, ["Neon|Fly|Ride"] = 4423.13, ["Mega|Fly|Ride"] = 19537.18}},
    ["rbxassetid://16898343164"] = {name = "Pirate Ghost Capuchin Monkey", prices = {["default"] = 378, ["Ride"] = 393.75, ["Fly|Ride"] = 656.25, ["Neon"] = 2093.24, ["Neon|Fly|Ride"] = 1417.13, ["Mega|Fly|Ride"] = 7128.76}},
    ["rbxassetid://6404812772"] = {name = "Golden Ladybug", prices = {["default"] = 14.44, ["Fly"] = 30.19, ["Ride"] = 23.24, ["Fly|Ride"] = 45.14, ["Neon"] = 65.63, ["Neon|Ride"] = 98.4, ["Neon|Fly|Ride"] = 124.57, ["Mega|Fly|Ride"] = 558.84}},
    ["rbxassetid://95029455226760"] = {name = "Easter Bunny", prices = {["default"] = 5.24, ["Ride"] = 50.23, ["Fly|Ride"] = 153.57, ["Neon"] = 21, ["Neon|Ride"] = 78.75, ["Mega"] = 157.5, ["Mega|Ride"] = 230.27}},
    ["rbxassetid://5307473113"] = {name = "Kitsune", prices = {["default"] = 34.1, ["Fly"] = 53.82, ["Ride"] = 51.11, ["Fly|Ride"] = 72.19, ["Neon|Ride"] = 158.07, ["Neon|Fly|Ride"] = 160.13, ["Mega|Fly|Ride"] = 519.75}},
    ["rbxassetid://4797806780"] = {name = "Golden Dragon", prices = {["default"] = 3.59, ["Fly"] = 30.4, ["Ride"] = 20.9, ["Fly|Ride"] = 45.02, ["Neon"] = 26.25, ["Neon|Fly"] = 279.46, ["Neon|Ride"] = 41.89, ["Neon|Fly|Ride"] = 83.91, ["Mega"] = 279.46, ["Mega|Ride"] = 265.85, ["Mega|Fly|Ride"] = 259.88}},
    ["rbxassetid://135649428081307"] = {name = "Sakura Spirit", prices = {["default"] = 341.25, ["Fly"] = 320.24, ["Ride"] = 313.69, ["Fly|Ride"] = 407.98, ["Neon"] = 1255.95, ["Neon|Ride"] = 1394.63, ["Neon|Fly|Ride"] = 1360.62, ["Mega|Fly|Ride"] = 4559.07}},
    ["rbxassetid://11109110190"] = {name = "White Amazon", prices = {["default"] = 35.6, ["Fly"] = 65.63, ["Ride"] = 40.69, ["Fly|Ride"] = 85.84, ["Neon"] = 118.13, ["Neon|Fly"] = 464.88, ["Neon|Ride"] = 217.33, ["Neon|Fly|Ride"] = 209.34, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://9475753542"] = {name = "Golden Albatross", prices = {["default"] = 15.72, ["Fly"] = 28.26, ["Ride"] = 28.26, ["Fly|Ride"] = 42, ["Neon|Fly"] = 125.62, ["Neon|Ride"] = 109.27, ["Neon|Fly|Ride"] = 91.88, ["Mega|Ride"] = 618.19, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://12778628831"] = {name = "Emperor Gorilla", prices = {["default"] = 287.44, ["Ride"] = 627.9, ["Fly|Ride"] = 680.31, ["Mega|Fly|Ride"] = 6279.71}},
    ["rbxassetid://13672542902"] = {name = "Hot Doggo", prices = {["default"] = 1302, ["Ride"] = 1194.38, ["Fly|Ride"] = 1479.94, ["Neon|Fly|Ride"] = 3570, ["Mega|Fly|Ride"] = 17046.71}},
    ["rbxassetid://8070897995"] = {name = "Ice Golem", prices = {["default"] = 73.5, ["Fly"] = 125.58, ["Ride"] = 97.13, ["Fly|Ride"] = 120.75, ["Neon"] = 498.2, ["Neon|Ride"] = 416.06, ["Neon|Fly|Ride"] = 525, ["Mega|Fly|Ride"] = 2099.99}},
    ["rbxassetid://128225904426926"] = {name = "Rose Dragon", prices = {["default"] = 170.63, ["Fly"] = 188.36, ["Ride"] = 210, ["Fly|Ride"] = 209.99, ["Neon"] = 732.9, ["Neon|Ride"] = 836.78, ["Neon|Fly|Ride"] = 605.88, ["Mega|Fly|Ride"] = 3573.15}},
    ["rbxassetid://13883274830"] = {name = "Pirate Hermit Crab", prices = {["default"] = 24.94, ["Ride"] = 80.07, ["Neon"] = 274.13, ["Neon|Ride"] = 272.99, ["Neon|Fly|Ride"] = 418.66, ["Mega|Ride"] = 1814.85, ["Mega|Fly|Ride"] = 2100}},
    ["rbxassetid://95213400890066"] = {name = "Diamond Hummingbird", prices = {["default"] = 142.35, ["Ride"] = 209.32, ["Fly|Ride"] = 597.19, ["Neon"] = 1535.4, ["Neon|Ride"] = 1255.95, ["Neon|Fly|Ride"] = 918.75, ["Mega|Fly|Ride"] = 2997.52}},
    ["rbxassetid://10453528102"] = {name = "Diamond Butterfly", prices = {["default"] = 1706.25, ["Fly"] = 2026.01, ["Ride"] = 2483.25, ["Fly|Ride"] = 1967.44, ["Neon|Fly|Ride"] = 6776.85, ["Mega|Fly|Ride"] = 48144.31}},
    ["rbxassetid://12778628650"] = {name = "Astronaut Gorilla", prices = {["default"] = 62.79, ["Ride"] = 51.19, ["Fly|Ride"] = 265.85, ["Neon"] = 511.88, ["Neon|Fly|Ride"] = 308.77, ["Mega|Ride"] = 2302.57, ["Mega|Fly|Ride"] = 1866.13}},
    ["rbxassetid://4708551306"] = {name = "Kangaroo", prices = {["default"] = 551.25, ["Fly"] = 675.94, ["Ride"] = 590.63, ["Fly|Ride"] = 682.5, ["Neon|Ride"] = 1246.88, ["Neon|Fly|Ride"] = 1200.94, ["Mega|Fly|Ride"] = 2840.25}},
    ["rbxassetid://9542440966"] = {name = "Capricorn", prices = {["default"] = 61.77, ["Fly"] = 138.14, ["Ride"] = 62.99, ["Fly|Ride"] = 104.67, ["Neon"] = 237.6, ["Neon|Ride"] = 513.45, ["Neon|Fly|Ride"] = 262.5, ["Mega|Fly|Ride"] = 989.73}},
    ["rbxassetid://9678195673"] = {name = "Ancient Dragon", prices = {["default"] = 3.62, ["Fly"] = 18.98, ["Ride"] = 19.9, ["Fly|Ride"] = 39.38, ["Neon"] = 23.63, ["Neon|Fly"] = 65.62, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 86.02, ["Mega"] = 195.74, ["Mega|Ride"] = 157.01, ["Mega|Fly|Ride"] = 215.25}},
    ["rbxassetid://132388343771587"] = {name = "Kelp Captain", prices = {["default"] = 47.18, ["Ride"] = 155.86, ["Fly|Ride"] = 253.32, ["Neon"] = 1396.21, ["Neon|Ride"] = 1988.58}},
    ["rbxassetid://15148532648"] = {name = "Werewolf", prices = {["default"] = 551.25, ["Fly"] = 656.16, ["Ride"] = 613.27, ["Fly|Ride"] = 522.38, ["Neon"] = 1955.09, ["Neon|Ride"] = 2756.25, ["Neon|Fly|Ride"] = 1836.19, ["Mega|Fly|Ride"] = 9450}},
    ["rbxassetid://86323568215409"] = {name = "Tortoiseshell Guinea Pig", prices = {["default"] = 485.63, ["Ride"] = 552.56, ["Fly|Ride"] = 715.91, ["Neon"] = 13955.59, ["Neon|Ride"] = 4068.75, ["Neon|Fly|Ride"] = 3409.82, ["Mega|Fly|Ride"] = 12838.84}},
    ["rbxassetid://5973019152"] = {name = "Robo Dog", prices = {["default"] = 13.13, ["Fly"] = 321.29, ["Ride"] = 23.63, ["Fly|Ride"] = 40.69, ["Neon|Ride"] = 171.94, ["Neon|Fly|Ride"] = 148.32}},
    ["rbxassetid://7734928470"] = {name = "Halloween Golden Mummy Cat", prices = {["default"] = 6.57, ["Ride"] = 26.25, ["Fly|Ride"] = 77.44, ["Neon"] = 105, ["Neon|Ride"] = 77.47, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 2511.89, ["Mega|Ride"] = 392.44, ["Mega|Fly|Ride"] = 476.22}},
    ["rbxassetid://137429532189183"] = {name = "Fire Stallion", prices = {["default"] = 6.18, ["Ride"] = 66.94, ["Fly|Ride"] = 83.75, ["Neon"] = 17.07, ["Neon|Fly"] = 311.8, ["Neon|Ride"] = 54.64, ["Mega"] = 170.72, ["Mega|Ride"] = 162.75, ["Mega|Fly|Ride"] = 259.58}},
    ["rbxassetid://7215324578"] = {name = "Axolotl", prices = {["default"] = 43.32, ["Fly"] = 45.86, ["Ride"] = 53.7, ["Fly|Ride"] = 119.31, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 279.46, ["Mega|Fly|Ride"] = 808.01}},
    ["rbxassetid://111805565268081"] = {name = "Black Widow", prices = {["default"] = 45.02, ["Ride"] = 77.44, ["Neon"] = 314, ["Neon|Ride"] = 342.26, ["Neon|Fly|Ride"] = 656.25, ["Mega"] = 1112.56, ["Mega|Ride"] = 1535.4, ["Mega|Fly|Ride"] = 1346.58}},
    ["rbxassetid://103653773461193"] = {name = "Sunglider", prices = {["default"] = 18.38, ["Fly"] = 78.49, ["Ride"] = 36.75, ["Fly|Ride"] = 104.54, ["Neon"] = 104.68, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 194.69, ["Mega|Ride"] = 406.88, ["Mega|Fly|Ride"] = 654.31}},
    ["rbxassetid://6498256069"] = {name = "Shark", prices = {["default"] = 32.71, ["Fly"] = 98.39, ["Ride"] = 36.75, ["Fly|Ride"] = 92.12, ["Neon"] = 347.49, ["Neon|Ride"] = 180.02, ["Neon|Fly|Ride"] = 221.47, ["Mega|Fly|Ride"] = 1121.85}},
    ["rbxassetid://8663440945"] = {name = "Lunar Gold Tiger", prices = {["default"] = 5.25, ["Fly"] = 38.07, ["Ride"] = 24.09, ["Fly|Ride"] = 38.07, ["Neon"] = 24.94, ["Neon|Ride"] = 37.7, ["Neon|Fly|Ride"] = 72.19, ["Mega"] = 183.75, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://94185217299816"] = {name = "Dracula Parrot", prices = {["default"] = 5.5, ["Fly"] = 56.52, ["Ride"] = 35.59, ["Fly|Ride"] = 1837.45, ["Neon"] = 27.43, ["Neon|Fly"] = 155.74, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 139.48, ["Mega"] = 195.74, ["Mega|Ride"] = 630, ["Mega|Fly|Ride"] = 314}},
    ["rbxassetid://4621220431"] = {name = "Golden Rat", prices = {["default"] = 46.48, ["Fly"] = 81.63, ["Ride"] = 63, ["Fly|Ride"] = 82.7, ["Neon"] = 418.84, ["Neon|Ride"] = 233.62, ["Neon|Fly|Ride"] = 273, ["Mega|Fly|Ride"] = 1067.28}},
    ["rbxassetid://11506045996"] = {name = "Strawberry Shortcake Bat Dragon", prices = {["default"] = 1618.32, ["Fly"] = 4883.97, ["Ride"] = 1890, ["Fly|Ride"] = 2098.69, ["Neon|Ride"] = 5028.73, ["Neon|Fly|Ride"] = 4647.57, ["Mega|Fly|Ride"] = 14962.5}},
    ["rbxassetid://11758583912"] = {name = "Winged Tiger", prices = {["default"] = 530.58, ["Fly"] = 627.9, ["Ride"] = 590.63, ["Fly|Ride"] = 612.04, ["Neon"] = 3097.63, ["Neon|Fly|Ride"] = 1863.75, ["Mega|Fly|Ride"] = 8580.16}},
    ["rbxassetid://101160794933271"] = {name = "Matcha Cat", prices = {["default"] = 236.25, ["Ride"] = 308.74, ["Fly|Ride"] = 343.88, ["Neon"] = 1242.34, ["Neon|Ride"] = 1415.88, ["Neon|Fly|Ride"] = 1465.28, ["Mega|Fly|Ride"] = 6140.51}},
    ["rbxassetid://13892790514"] = {name = "Urban Egg", prices = {["default"] = 43.2}},
    ["rbxassetid://13104109574"] = {name = "Spinosaurus", prices = {["default"] = 32.06, ["Fly"] = 65.63, ["Ride"] = 54.58, ["Fly|Ride"] = 91.07, ["Neon|Ride"] = 253.78, ["Mega|Ride"] = 1535.4, ["Mega|Fly|Ride"] = 1535.4}},
    ["rbxassetid://4115248712"] = {name = "Shadow Dragon", prices = {["default"] = 33487.6, ["Fly"] = 20651.38, ["Ride"] = 34781.25, ["Fly|Ride"] = 17062.5, ["Neon|Fly|Ride"] = 35437.5, ["Mega|Fly|Ride"] = 89250}},
    ["rbxassetid://71457697470071"] = {name = "Arctic Dusk Dragon", prices = {["default"] = 278.72, ["Fly"] = 358.97, ["Ride"] = 316.07, ["Fly|Ride"] = 397.72, ["Neon"] = 949.3, ["Neon|Fly"] = 1094.12, ["Neon|Ride"] = 1027.66, ["Neon|Fly|Ride"] = 851.82, ["Mega|Ride"] = 6508.17, ["Mega|Fly|Ride"] = 2489.82}},
    ["rbxassetid://8566683457"] = {name = "Giant Gold Scarab", prices = {["default"] = 223.99, ["Ride"] = 349.55, ["Fly|Ride"] = 262.5, ["Neon|Fly|Ride"] = 837.31}},
    ["rbxassetid://16116063171"] = {name = "Rainbow Dragon", prices = {["default"] = 111.57, ["Ride"] = 105, ["Fly|Ride"] = 219.81, ["Neon"] = 698.12, ["Neon|Ride"] = 1046.63, ["Neon|Fly|Ride"] = 393.74, ["Mega"] = 13955.59, ["Mega|Fly|Ride"] = 1398.21}},
    ["rbxassetid://9938967130"] = {name = "Black Chow-Chow", prices = {["default"] = 19.69, ["Ride"] = 45.94, ["Fly|Ride"] = 98.4, ["Neon|Ride"] = 135.19, ["Neon|Fly|Ride"] = 310.31, ["Mega"] = 1181.25}},
    ["rbxassetid://116467943923352"] = {name = "Haetae", prices = {["default"] = 4527.12, ["Ride"] = 3930.94, ["Fly|Ride"] = 4750.6, ["Neon|Fly|Ride"] = 16406.25}},
    ["rbxassetid://6531232495"] = {name = "Peacock", prices = {["default"] = 28.26, ["Fly"] = 45.94, ["Ride"] = 32.82, ["Fly|Ride"] = 60.25, ["Neon"] = 144.38, ["Neon|Ride"] = 200.96, ["Neon|Fly|Ride"] = 185.96, ["Mega|Fly|Ride"] = 633.94}},
    ["rbxassetid://12557346746"] = {name = "Naga Dragon", prices = {["default"] = 42, ["Fly"] = 193.62, ["Ride"] = 51.19, ["Fly|Ride"] = 91.07, ["Neon|Ride"] = 279.46, ["Neon|Fly|Ride"] = 295.21, ["Mega|Fly|Ride"] = 854.05}},
    ["rbxassetid://127697654557674"] = {name = "Candicorn", prices = {["default"] = 498.75, ["Fly"] = 698.01, ["Ride"] = 551.25, ["Fly|Ride"] = 695.63, ["Neon"] = 1706.25, ["Neon|Ride"] = 1619.14, ["Neon|Fly|Ride"] = 1264.65, ["Mega"] = 5232.05, ["Mega|Fly|Ride"] = 4331.25}},
    ["rbxassetid://4281674580"] = {name = "King Bee", prices = {["default"] = 13.13, ["Fly"] = 30.37, ["Ride"] = 24.94, ["Fly|Ride"] = 48.44, ["Neon"] = 133.98, ["Neon|Ride"] = 103.61, ["Neon|Fly|Ride"] = 119.44, ["Mega"] = 698.12, ["Mega|Fly|Ride"] = 485.63}},
    ["rbxassetid://17822543288"] = {name = "Blue Betta Fish", prices = {["default"] = 26.25, ["Fly"] = 41.88, ["Ride"] = 140.44, ["Fly|Ride"] = 464.6, ["Neon"] = 61.77, ["Neon|Ride"] = 189.46, ["Neon|Fly|Ride"] = 137.12}},
    ["rbxassetid://102300026415493"] = {name = "Moose Calf", prices = {["default"] = 104.99, ["Ride"] = 112, ["Fly|Ride"] = 237.58, ["Neon|Ride"] = 697.32, ["Neon|Fly|Ride"] = 809.82, ["Mega|Ride"] = 2545.38, ["Mega|Fly|Ride"] = 2524.45}},
    ["rbxassetid://78419574214060"] = {name = "Christmas Spirit", prices = {["default"] = 26.25, ["Fly"] = 104.67, ["Ride"] = 83.74, ["Fly|Ride"] = 132.93, ["Neon"] = 115.4, ["Neon|Ride"] = 154.92, ["Neon|Fly|Ride"] = 196.87, ["Mega"] = 221.81, ["Mega|Fly"] = 708.75, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 458.07}},
    ["rbxassetid://130642623661179"] = {name = "Cryptid", prices = {["default"] = 4282.24, ["Ride"] = 4064.36, ["Fly|Ride"] = 3150, ["Neon"] = 7612.5, ["Neon|Ride"] = 17046.71, ["Neon|Fly|Ride"] = 8398.69, ["Mega|Fly|Ride"] = 38739.77}},
    ["rbxassetid://101130894252942"] = {name = "Peach Owl", prices = {["default"] = 35.6, ["Ride"] = 167.46, ["Fly|Ride"] = 108.87, ["Neon"] = 168, ["Neon|Ride"] = 182.13, ["Neon|Fly|Ride"] = 328.13, ["Mega|Fly|Ride"] = 865.57}},
    ["rbxassetid://4440866649"] = {name = "Owl", prices = {["default"] = 7395.53, ["Ride"] = 7674.95, ["Fly|Ride"] = 5773.69, ["Neon|Fly|Ride"] = 17062.5, ["Mega|Fly|Ride"] = 82084.99}},
    ["rbxassetid://6836687169"] = {name = "Golden Griffin", prices = {["default"] = 3.59, ["Fly"] = 20.95, ["Ride"] = 20.95, ["Fly|Ride"] = 41.88, ["Neon"] = 23.63, ["Neon|Fly"] = 140.26, ["Neon|Ride"] = 32.46, ["Neon|Fly|Ride"] = 91.07, ["Mega"] = 131.25, ["Mega|Fly|Ride"] = 308.77}},
    ["rbxassetid://76198828333546"] = {name = "Hippogriff", prices = {["default"] = 49.21, ["Fly"] = 28.26, ["Ride"] = 33.51, ["Fly|Ride"] = 70.13, ["Neon"] = 140.26, ["Neon|Ride"] = 558.91, ["Neon|Fly|Ride"] = 700.21}},
    ["rbxassetid://112567270488274"] = {name = "Crystal Egg", prices = {["default"] = 3.15}},
    ["rbxassetid://10695038557"] = {name = "Maneki-Neko", prices = {["default"] = 10.5, ["Ride"] = 41.83, ["Fly|Ride"] = 125.93, ["Neon"] = 112.01, ["Neon|Ride"] = 192.94, ["Mega|Ride"] = 865.57, ["Mega|Fly|Ride"] = 837.31}},
    ["rbxassetid://16911441596"] = {name = "Royal Capuchin Monkey", prices = {["default"] = 49.95, ["Fly"] = 83.74, ["Ride"] = 132.4, ["Fly|Ride"] = 209.34, ["Neon"] = 182.43, ["Neon|Ride"] = 182.13, ["Neon|Fly|Ride"] = 278.94, ["Mega"] = 840, ["Mega|Ride"] = 929.75, ["Mega|Fly|Ride"] = 931.88}},
    ["rbxassetid://6963387165"] = {name = "Cobra", prices = {["default"] = 15.75, ["Fly"] = 37.7, ["Ride"] = 21.15, ["Fly|Ride"] = 42, ["Neon|Ride"] = 310.31, ["Neon|Fly|Ride"] = 158.82, ["Mega"] = 1117.8, ["Mega|Fly|Ride"] = 945}},
    ["rbxassetid://3409444171"] = {name = "Safari Egg", prices = {["default"] = 8917.18}},
    ["rbxassetid://3743740864"] = {name = "Jungle Egg", prices = {["default"] = 2971.36}},
    ["rbxassetid://10321884333"] = {name = "Japan Egg", prices = {["default"] = 28.25}},
    ["rbxassetid://11109117895"] = {name = "Diamond Amazon", prices = {["default"] = 376.74, ["Ride"] = 321.29, ["Fly|Ride"] = 349.58, ["Neon|Ride"] = 2191.62}},
    ["rbxassetid://102144672439627"] = {name = "Berry Cool Cube", prices = {["default"] = 26.25, ["Fly"] = 131.86, ["Ride"] = 39.38, ["Fly|Ride"] = 105, ["Neon"] = 104.29, ["Neon|Ride"] = 191.55, ["Neon|Fly|Ride"] = 279.46, ["Mega"] = 802.77, ["Mega|Ride"] = 795.44, ["Mega|Fly|Ride"] = 761.25}},
    ["rbxassetid://17183502626"] = {name = "Garden Egg", prices = {["default"] = 7.76}},
    ["rbxassetid://16722909609"] = {name = "Striped Eggy", prices = {["default"] = 8.39, ["Ride"] = 52.5, ["Neon"] = 78.51, ["Neon|Ride"] = 83.75, ["Mega|Fly|Ride"] = 446.25}},
    ["rbxassetid://4440866155"] = {name = "Farm Egg", prices = {["default"] = 2930.54}},
    ["rbxassetid://88361277330582"] = {name = "Naughty Mistletroll", prices = {["default"] = 157.5, ["Ride"] = 144.38, ["Fly|Ride"] = 98.4, ["Neon"] = 698.12, ["Neon|Ride"] = 918.75, ["Neon|Fly|Ride"] = 525, ["Mega|Fly|Ride"] = 2329.79}},
    ["rbxassetid://12778919221"] = {name = "Yule Log Dog", prices = {["default"] = 91.86, ["Ride"] = 193.95, ["Fly|Ride"] = 308.74, ["Neon"] = 837.31, ["Neon|Ride"] = 735, ["Neon|Fly|Ride"] = 945, ["Mega|Fly|Ride"] = 3129.39}},
    ["rbxassetid://13104112588"] = {name = "Owlbear", prices = {["default"] = 180.04, ["Ride"] = 195.57, ["Fly|Ride"] = 240.74, ["Neon"] = 835.22, ["Neon|Ride"] = 840, ["Neon|Fly|Ride"] = 1007.62, ["Mega|Fly|Ride"] = 2937.38}},
    ["rbxassetid://11192035130"] = {name = "Undead Jousting Horse", prices = {["default"] = 1050, ["Fly"] = 2511.58, ["Ride"] = 1167.89, ["Fly|Ride"] = 1085.89, ["Neon|Ride"] = 5578.43, ["Neon|Fly|Ride"] = 4593.75, ["Mega|Fly|Ride"] = 19884.66}},
    ["rbxassetid://106575933009346"] = {name = "Fairytale Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://96044273915258"] = {name = "Endangered Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://129993159377616"] = {name = "Peahen", prices = {["default"] = 18.9, ["Fly"] = 101.56, ["Ride"] = 55.76, ["Fly|Ride"] = 86.63, ["Neon"] = 140.26, ["Neon|Ride"] = 140.26, ["Mega"] = 731.6, ["Mega|Fly|Ride"] = 1814.85}},
    ["rbxassetid://12732812236"] = {name = "Tio De Nadal", prices = {["default"] = 642.64, ["Fly"] = 2100, ["Ride"] = 759.84, ["Fly|Ride"] = 1149.75}},
    ["rbxassetid://13936755787"] = {name = "Wrapped Doll", prices = {["default"] = 67.13}},
    ["rbxassetid://136441478335419"] = {name = "Emberlight", prices = {["default"] = 19.9, ["Fly"] = 393.75, ["Ride"] = 39.79, ["Fly|Ride"] = 98.44, ["Neon"] = 89.25, ["Neon|Ride"] = 104.63, ["Neon|Fly|Ride"] = 129.94, ["Mega"] = 363.57, ["Mega|Ride"] = 575.29, ["Mega|Fly|Ride"] = 498.75}},
    ["rbxassetid://17120184484"] = {name = "Rosy Maple Moth", prices = {["default"] = 7.86, ["Fly"] = 348.38, ["Ride"] = 28.26, ["Fly|Ride"] = 94.5, ["Neon"] = 140.26, ["Neon|Ride"] = 83.61, ["Neon|Fly|Ride"] = 111.57, ["Mega|Ride"] = 487.74}},
    ["rbxassetid://15932251755"] = {name = "Royal Desert Egg", prices = {["default"] = 65.63}},
    ["rbxassetid://8143039289"] = {name = "Golden Walrus", prices = {["default"] = 49.21, ["Ride"] = 35.44, ["Fly|Ride"] = 62.79, ["Neon"] = 177.19, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 542.75, ["Mega"] = 811.15, ["Mega|Fly|Ride"] = 698.12}},
    ["rbxassetid://12187391973"] = {name = "Firefly", prices = {["default"] = 41.88, ["Fly"] = 48.16, ["Ride"] = 46.47, ["Fly|Ride"] = 74.82, ["Neon"] = 237.6, ["Neon|Ride"] = 278.25, ["Neon|Fly|Ride"] = 310.31, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://3743647944"] = {name = "Parrot", prices = {["default"] = 5223.75, ["Fly"] = 11162.89, ["Ride"] = 6209.87, ["Fly|Ride"] = 5250, ["Neon|Ride"] = 12140.75, ["Neon|Fly|Ride"] = 10500, ["Mega|Fly|Ride"] = 37668.75}},
    ["rbxassetid://128454622445076"] = {name = "Dimension Drifter", prices = {["default"] = 10.5, ["Ride"] = 40.82, ["Fly|Ride"] = 72.19, ["Neon"] = 64.32, ["Neon|Ride"] = 127.09, ["Neon|Fly|Ride"] = 115.5, ["Mega"] = 500.3, ["Mega|Ride"] = 388.19, ["Mega|Fly|Ride"] = 417.38}},
    ["rbxassetid://15931761708"] = {name = "Desert Egg", prices = {["default"] = 35.6}},
    ["rbxassetid://17747001377"] = {name = "Majestic Pony", prices = {["default"] = 116.16, ["Fly"] = 370.47, ["Ride"] = 148.62, ["Neon"] = 418.69, ["Neon|Ride"] = 483, ["Neon|Fly|Ride"] = 586.11, ["Mega|Fly|Ride"] = 1873.46}},
    ["rbxassetid://94487786469241"] = {name = "Vanilla Penguin", prices = {["default"] = 62.73, ["Ride"] = 111.57, ["Fly|Ride"] = 349.55, ["Neon"] = 327.6, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 768.24, ["Mega|Ride"] = 1363.76, ["Mega|Fly|Ride"] = 1492.5}},
    ["rbxassetid://6498256211"] = {name = "Octopus", prices = {["default"] = 28.28, ["Fly"] = 70.88, ["Ride"] = 33.69, ["Fly|Ride"] = 74.82, ["Neon|Ride"] = 108.52, ["Neon|Fly|Ride"] = 189, ["Mega|Fly|Ride"] = 616.88}},
    ["rbxassetid://110654583245787"] = {name = "Sea Turtle", prices = {["default"] = 4.65, ["Fly"] = 79.55, ["Ride"] = 37.68, ["Fly|Ride"] = 96.3, ["Neon"] = 23.35, ["Neon|Ride"] = 73.28, ["Neon|Fly|Ride"] = 130.12, ["Mega"] = 207.38, ["Mega|Fly"] = 7034.11, ["Mega|Ride"] = 164.07, ["Mega|Fly|Ride"] = 267.37}},
    ["rbxassetid://8596147681"] = {name = "Squid", prices = {["default"] = 15.7, ["Fly"] = 45.85, ["Ride"] = 30.19, ["Fly|Ride"] = 91.87, ["Neon"] = 70.14, ["Neon|Ride"] = 118.44, ["Neon|Fly|Ride"] = 209.34, ["Mega|Fly|Ride"] = 538.13}},
    ["rbxassetid://9226723356"] = {name = "Winged Horse", prices = {["default"] = 19.46, ["Fly"] = 31.37, ["Ride"] = 31.5, ["Fly|Ride"] = 39.29, ["Neon"] = 209.34, ["Neon|Fly"] = 209.34, ["Neon|Ride"] = 141.75, ["Neon|Fly|Ride"] = 133.98, ["Mega|Fly|Ride"] = 677.17}},
    ["rbxassetid://4733386633"] = {name = "Aussie Egg", prices = {["default"] = 236.25}},
    ["rbxassetid://121951206021245"] = {name = "Kiwi Kiwi", prices = {["default"] = 18.86, ["Ride"] = 125.9, ["Fly|Ride"] = 140.26, ["Neon"] = 152.82, ["Neon|Fly|Ride"] = 525, ["Mega"] = 537.97, ["Mega|Ride"] = 918.75, ["Mega|Fly|Ride"] = 1347.01}},
    ["rbxassetid://9602676771"] = {name = "Diamond Albatross", prices = {["default"] = 125.58, ["Ride"] = 443.63, ["Neon|Fly|Ride"] = 756.72}},
    ["rbxassetid://79965389436178"] = {name = "Sushi Penguin", prices = {["default"] = 39.89, ["Ride"] = 78.75, ["Fly|Ride"] = 275.27, ["Neon"] = 207.24, ["Neon|Ride"] = 374.07, ["Neon|Fly|Ride"] = 518.09, ["Mega"] = 1181.25, ["Mega|Fly|Ride"] = 1396.21}},
    ["rbxassetid://126930507653265"] = {name = "Grim Dragon", prices = {["default"] = 706.13, ["Fly"] = 780.94, ["Ride"] = 682.5, ["Fly|Ride"] = 837.2, ["Neon|Fly|Ride"] = 2098.69, ["Mega|Fly|Ride"] = 6429.94}},
    ["rbxassetid://87328715505907"] = {name = "Silverback Gorilla", prices = {["default"] = 262.5, ["Ride"] = 313.69, ["Fly|Ride"] = 397.72, ["Neon"] = 2930.54, ["Neon|Ride"] = 7535.64, ["Neon|Fly|Ride"] = 1507.14, ["Mega"] = 4416.26, ["Mega|Fly|Ride"] = 4118.44}},
    ["rbxassetid://12733311267"] = {name = "Fool Egg", prices = {["default"] = 109.92}},
    ["rbxassetid://139472202653768"] = {name = "Admin Abuse Egg", prices = {["default"] = 2.5}},
    ["rbxassetid://8938702589"] = {name = "Hawk", prices = {["default"] = 10.48, ["Fly"] = 41.88, ["Ride"] = 26.25, ["Fly|Ride"] = 56.52, ["Neon"] = 80.07, ["Neon|Fly"] = 230.99, ["Neon|Ride"] = 124.37, ["Neon|Fly|Ride"] = 105, ["Mega|Fly|Ride"] = 405.57}},
    ["rbxassetid://8938703243"] = {name = "Fallow Deer", prices = {["default"] = 246.75, ["Fly"] = 977.43, ["Ride"] = 314.9, ["Fly|Ride"] = 301.87, ["Neon|Ride"] = 1088.07, ["Neon|Fly|Ride"] = 1040.82, ["Mega"] = 4186.47, ["Mega|Fly|Ride"] = 3349.18}},
    ["rbxassetid://4822753124"] = {name = "Diamond Egg", prices = {["default"] = 18.86}},
    ["rbxassetid://114823420678686"] = {name = "Dragonfruit Fox", prices = {["default"] = 113.39, ["Fly"] = 590.63, ["Ride"] = 173.74, ["Fly|Ride"] = 250.84, ["Neon"] = 538.13, ["Neon|Fly"] = 1396.21, ["Neon|Ride"] = 502.07, ["Neon|Fly|Ride"] = 654.94, ["Mega"] = 9210.23, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://102844319137806"] = {name = "Pineapple Owl", prices = {["default"] = 127.7, ["Ride"] = 162.65, ["Fly|Ride"] = 328.13, ["Neon"] = 896.66, ["Neon|Ride"] = 997.5}},
    ["rbxassetid://82296650763619"] = {name = "Angus Bull", prices = {["default"] = 7.35, ["Ride"] = 39.38, ["Fly|Ride"] = 141.17, ["Neon"] = 40.84, ["Neon|Ride"] = 140.26, ["Neon|Fly|Ride"] = 167.48, ["Mega"] = 265.85, ["Mega|Ride"] = 232.32, ["Mega|Fly|Ride"] = 409.1}},
    ["rbxassetid://12917347755"] = {name = "Sunrise Duckling", prices = {["default"] = 15.63, ["Fly"] = 48.16, ["Ride"] = 34.85, ["Fly|Ride"] = 76.13, ["Neon"] = 132.92, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 235.39, ["Mega|Ride"] = 689.73, ["Mega|Fly|Ride"] = 572.25}},
    ["rbxassetid://139217275750567"] = {name = "Winter Buck", prices = {["default"] = 26.17, ["Fly"] = 125.58, ["Ride"] = 70.13, ["Fly|Ride"] = 144.38, ["Neon"] = 1883.93, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 283.5, ["Mega|Ride"] = 388.19, ["Mega|Fly|Ride"] = 565.19}},
    ["rbxassetid://114331718573822"] = {name = "Mochi Meow", prices = {["default"] = 5.25, ["Fly"] = 334.88, ["Ride"] = 75.35, ["Fly|Ride"] = 139.39, ["Neon"] = 26.17, ["Neon|Ride"] = 71.18, ["Neon|Fly|Ride"] = 140.26, ["Mega"] = 111.56, ["Mega|Ride"] = 182.13, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://112560568221286"] = {name = "Strawberry Penguin", prices = {["default"] = 281.03, ["Fly"] = 918.75, ["Ride"] = 321.29, ["Fly|Ride"] = 418.62, ["Neon"] = 1255.95, ["Neon|Ride"] = 3139.86, ["Neon|Fly|Ride"] = 1424.07, ["Mega|Fly|Ride"] = 4284.86}},
    ["rbxassetid://116818749091454"] = {name = "Dango Penguins", prices = {["default"] = 91.05, ["Fly"] = 1050, ["Ride"] = 141.75, ["Fly|Ride"] = 249.38, ["Neon"] = 446.25, ["Neon|Ride"] = 522.38, ["Neon|Fly|Ride"] = 523.69, ["Mega"] = 2093.24, ["Mega|Ride"] = 1928.07, ["Mega|Fly|Ride"] = 1647.39}},
    ["rbxassetid://12480100169"] = {name = "Tree Kangaroo", prices = {["default"] = 66.94, ["Fly"] = 1116.62, ["Ride"] = 76.13, ["Fly|Ride"] = 141.75, ["Neon|Ride"] = 439.27, ["Neon|Fly|Ride"] = 527.5, ["Mega|Fly|Ride"] = 1515.94}},
    ["rbxassetid://75106733244906"] = {name = "Golden Hummingbird", prices = {["default"] = 15.7, ["Ride"] = 68.25, ["Fly|Ride"] = 279.46, ["Neon|Ride"] = 590.39, ["Neon|Fly|Ride"] = 488.78, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://76354526914534"] = {name = "Frostclaw", prices = {["default"] = 15.39, ["Ride"] = 41.99, ["Fly|Ride"] = 140.25, ["Neon"] = 68.55, ["Neon|Ride"] = 123.21, ["Neon|Fly|Ride"] = 220.83, ["Mega"] = 467.25, ["Mega|Ride"] = 1116.75, ["Mega|Fly|Ride"] = 444.94}},
    ["rbxassetid://121712578077668"] = {name = "Blue Whale", prices = {["default"] = 3.6, ["Fly"] = 140.25, ["Ride"] = 27.57, ["Fly|Ride"] = 78.26, ["Neon"] = 19.69, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 146.54, ["Mega|Ride"] = 172.02, ["Mega|Fly|Ride"] = 180.6}},
    ["rbxassetid://76035105070441"] = {name = "Fairy Bat Dragon", prices = {["default"] = 1046.5, ["Fly"] = 1128.12, ["Ride"] = 1050, ["Fly|Ride"] = 968.63, ["Neon|Ride"] = 3138.81, ["Neon|Fly|Ride"] = 2775.94, ["Mega|Fly|Ride"] = 7993.13}},
    ["rbxassetid://105346917979221"] = {name = "Aurora Fox", prices = {["default"] = 328.13, ["Ride"] = 321.57, ["Fly|Ride"] = 366.19, ["Neon|Ride"] = 1394.63, ["Neon|Fly|Ride"] = 1443.75, ["Mega|Fly|Ride"] = 4177.05}},
    ["rbxassetid://120475294381736"] = {name = "Glormy Hound", prices = {["default"] = 99.7, ["Ride"] = 155.63, ["Fly|Ride"] = 182.44, ["Neon"] = 384.13, ["Neon|Ride"] = 395.07, ["Neon|Fly|Ride"] = 459.38, ["Mega|Fly|Ride"] = 1587.87}},
    ["rbxassetid://15570696642"] = {name = "Glacier Kitsune", prices = {["default"] = 196.88, ["Ride"] = 248.07, ["Fly|Ride"] = 251.16, ["Neon|Ride"] = 1054.11, ["Neon|Fly|Ride"] = 1036.88, ["Mega|Fly|Ride"] = 3461.17}},
    ["rbxassetid://16548792521"] = {name = "Golden Hamster", prices = {["default"] = 20.95, ["Fly"] = 73.27, ["Ride"] = 39.38, ["Fly|Ride"] = 85.83, ["Neon"] = 155.66, ["Neon|Ride"] = 124.37, ["Neon|Fly|Ride"] = 418.66, ["Mega|Fly|Ride"] = 619.12}},
    ["rbxassetid://12935498875"] = {name = "Field Mouse", prices = {["default"] = 353.77, ["Ride"] = 558.84, ["Neon"] = 1535.4, ["Neon|Ride"] = 1814.85, ["Neon|Fly|Ride"] = 1378.13, ["Mega"] = 5250, ["Mega|Fly|Ride"] = 5441.5}},
    ["rbxassetid://16548793509"] = {name = "Diamond Hamster", prices = {["default"] = 125.58, ["Fly"] = 126, ["Ride"] = 83.74, ["Fly|Ride"] = 154.9, ["Neon|Ride"] = 464.88, ["Neon|Fly|Ride"] = 627.98, ["Mega|Fly|Ride"] = 2015.22}},
    ["rbxassetid://78823655016197"] = {name = "Jekyll Hydra", prices = {["default"] = 1506.59, ["Ride"] = 1535.21, ["Fly|Ride"] = 1607.82, ["Neon|Fly|Ride"] = 4331.25}},
    ["rbxassetid://96735424372947"] = {name = "Glormy Dolphin", prices = {["default"] = 12.59, ["Fly"] = 45.94, ["Ride"] = 67.36, ["Fly|Ride"] = 84, ["Neon"] = 48.17, ["Neon|Fly"] = 167.26, ["Neon|Ride"] = 63, ["Neon|Fly|Ride"] = 158.06, ["Mega"] = 175.71, ["Mega|Ride"] = 261.19, ["Mega|Fly|Ride"] = 418.66}},
    ["rbxassetid://16898331554"] = {name = "Princess Capuchin Monkey", prices = {["default"] = 140.25, ["Ride"] = 84, ["Fly|Ride"] = 315, ["Neon"] = 315, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 437.07, ["Mega|Ride"] = 1116.75, ["Mega|Fly|Ride"] = 969.19}},
    ["rbxassetid://4315743450"] = {name = "Queen Bee", prices = {["default"] = 81.63, ["Fly"] = 77.44, ["Ride"] = 85.32, ["Fly|Ride"] = 85.32, ["Neon|Ride"] = 489.83, ["Neon|Fly|Ride"] = 393.75, ["Mega|Fly|Ride"] = 1632.73}},
    ["rbxassetid://5067924789"] = {name = "Monkey King", prices = {["default"] = 2777.73, ["Ride"] = 962.07, ["Fly|Ride"] = 1104.2, ["Neon|Fly|Ride"] = 4762.11, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://10284283561"] = {name = "Black-Chested Pheasant", prices = {["default"] = 479.36, ["Ride"] = 603.86, ["Fly|Ride"] = 586.04, ["Neon|Fly|Ride"] = 1965.55}},
    ["rbxassetid://15504845135"] = {name = "Candy Hare", prices = {["default"] = 128.63, ["Ride"] = 154.9, ["Neon"] = 492.48, ["Neon|Ride"] = 472.5, ["Neon|Fly|Ride"] = 459.38, ["Mega"] = 4004.38, ["Mega|Ride"] = 2652.14, ["Mega|Fly|Ride"] = 1986.49}},
    ["rbxassetid://11758575657"] = {name = "Lunar Moon Bear", prices = {["default"] = 8.01, ["Fly"] = 131.25, ["Ride"] = 30.19, ["Fly|Ride"] = 67.01, ["Neon"] = 91.88, ["Neon|Ride"] = 125.62, ["Neon|Fly|Ride"] = 155.74, ["Mega"] = 761.25}},
    ["rbxassetid://10318105392"] = {name = "Green Butterfly", prices = {["default"] = 42.75, ["Fly"] = 70.13, ["Ride"] = 54.44, ["Fly|Ride"] = 132.92, ["Neon"] = 279.46, ["Neon|Ride"] = 210.73, ["Neon|Fly|Ride"] = 386.19, ["Mega"] = 1814.85, ["Mega|Fly|Ride"] = 1049.99}},
    ["rbxassetid://84813815094145"] = {name = "Mermicorn", prices = {["default"] = 885.94, ["Ride"] = 774.56, ["Fly|Ride"] = 894.88, ["Neon|Ride"] = 2828.44, ["Neon|Fly|Ride"] = 3300.57, ["Mega|Fly|Ride"] = 12035.04}},
    ["rbxassetid://4507163112"] = {name = "Christmas Egg", prices = {["default"] = 767.82}},
    ["rbxassetid://14689005829"] = {name = "Blazing Lion", prices = {["default"] = 4823.44, ["Ride"] = 4068.75, ["Fly|Ride"] = 4458.57, ["Neon|Ride"] = 29997.06, ["Neon|Fly|Ride"] = 17443.95, ["Mega|Fly|Ride"] = 89311.87}},
    ["rbxassetid://123647431892215"] = {name = "Hero Gibbon", prices = {["default"] = 178.87, ["Fly"] = 418.62, ["Ride"] = 393.75, ["Fly|Ride"] = 405.05, ["Neon"] = 918.75, ["Neon|Ride"] = 837.31, ["Neon|Fly|Ride"] = 918.75, ["Mega"] = 5861.06, ["Mega|Fly|Ride"] = 6199.03}},
    ["rbxassetid://106457467498193"] = {name = "Scorching Kaijunior", prices = {["default"] = 77.42, ["Fly"] = 279.42, ["Ride"] = 122.07, ["Fly|Ride"] = 336, ["Neon"] = 441, ["Neon|Ride"] = 502.39, ["Neon|Fly|Ride"] = 643.68, ["Mega|Fly|Ride"] = 2720.17}},
    ["rbxassetid://10926054030"] = {name = "Chimera", prices = {["default"] = 13.13, ["Fly"] = 131.25, ["Ride"] = 28.88, ["Fly|Ride"] = 91.88, ["Neon"] = 698.12, ["Neon|Ride"] = 115.5, ["Neon|Fly|Ride"] = 174.78, ["Mega|Ride"] = 837.31}},
    ["rbxassetid://9490242683"] = {name = "Golden King Penguin", prices = {["default"] = 18.84, ["Fly"] = 31.37, ["Ride"] = 28.88, ["Fly|Ride"] = 60.73, ["Neon|Ride"] = 310.31, ["Neon|Fly|Ride"] = 263.83, ["Mega|Fly|Ride"] = 627.98}},
    ["rbxassetid://17119623510"] = {name = "Mushroom Friend", prices = {["default"] = 23.24, ["Ride"] = 35.6, ["Fly|Ride"] = 140.26, ["Neon"] = 100.09, ["Neon|Ride"] = 97.13, ["Neon|Fly|Ride"] = 118.13, ["Mega|Ride"] = 859.69, ["Mega|Fly|Ride"] = 816.38}},
    ["rbxassetid://17174656536"] = {name = "Golden Tortoise Beetle", prices = {["default"] = 4.66, ["Ride"] = 22.32, ["Fly|Ride"] = 69.21, ["Neon"] = 35.44, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 310.31, ["Mega|Ride"] = 310.31, ["Mega|Fly|Ride"] = 357}},
    ["rbxassetid://84310117840681"] = {name = "Super Saru", prices = {["default"] = 31.5, ["Fly|Ride"] = 166.43, ["Neon"] = 139.89, ["Neon|Ride"] = 310.31, ["Neon|Fly|Ride"] = 376.8, ["Mega"] = 690.79, ["Mega|Ride"] = 1396.21}},
    ["rbxassetid://77177643028234"] = {name = "Phantom Dragon", prices = {["default"] = 263.62, ["Fly"] = 328.6, ["Ride"] = 241.5, ["Fly|Ride"] = 328.13, ["Neon"] = 732.65, ["Neon|Ride"] = 977.55, ["Neon|Fly|Ride"] = 976.24, ["Mega|Fly|Ride"] = 4126.82}},
    ["rbxassetid://6245080265"] = {name = "Metal Ox", prices = {["default"] = 3.68, ["Fly"] = 16.76, ["Ride"] = 15.75, ["Fly|Ride"] = 35.89, ["Neon"] = 22.31, ["Neon|Ride"] = 49.88, ["Neon|Fly|Ride"] = 80.07, ["Mega"] = 837.31, ["Mega|Ride"] = 736.84, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://3181728194"] = {name = "Unicorn", prices = {["default"] = 39.79, ["Fly"] = 64.91, ["Ride"] = 69.57, ["Fly|Ride"] = 114.08, ["Neon"] = 203.04, ["Neon|Ride"] = 162.75, ["Neon|Fly|Ride"] = 204.65, ["Mega"] = 620.62, ["Mega|Ride"] = 552.36, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://4708551322"] = {name = "Turtle", prices = {["default"] = 853.13, ["Fly"] = 977.43, ["Ride"] = 729.42, ["Fly|Ride"] = 753.38, ["Neon|Fly|Ride"] = 1744.32, ["Mega|Fly|Ride"] = 4200}},
    ["rbxassetid://5721844281"] = {name = "T-Rex", prices = {["default"] = 26.25, ["Fly"] = 165.38, ["Ride"] = 38.06, ["Fly|Ride"] = 98.44, ["Neon"] = 131.25, ["Neon|Fly"] = 464.88, ["Neon|Ride"] = 111.57, ["Neon|Fly|Ride"] = 196.88, ["Mega|Fly|Ride"] = 1046.63}},
    ["rbxassetid://16127039676"] = {name = "Midnight Dragon", prices = {["default"] = 304.26, ["Fly"] = 342.21, ["Ride"] = 241.5, ["Fly|Ride"] = 262.5, ["Neon|Fly"] = 1475.75, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 6133.18}},
    ["rbxassetid://7734925172"] = {name = "Halloween White Ghost Dragon", prices = {["default"] = 137.11, ["Fly"] = 178.96, ["Ride"] = 131.25, ["Fly|Ride"] = 168, ["Neon"] = 556.81, ["Neon|Fly"] = 636.36, ["Neon|Ride"] = 557.86, ["Neon|Fly|Ride"] = 518.09, ["Mega|Fly|Ride"] = 2191.62}},
    ["rbxassetid://18508016126"] = {name = "Bush Elephant", prices = {["default"] = 606, ["Ride"] = 597.19, ["Fly|Ride"] = 684.51, ["Neon|Fly|Ride"] = 2511.89, ["Mega|Fly|Ride"] = 5773.69}},
    ["rbxassetid://78218981883168"] = {name = "Coconut Friend", prices = {["default"] = 28.26, ["Ride"] = 52.35, ["Fly|Ride"] = 95.26, ["Neon"] = 105, ["Neon|Fly"] = 278.94, ["Neon|Ride"] = 109.27, ["Neon|Fly|Ride"] = 211.32, ["Mega"] = 418.66, ["Mega|Ride"] = 395.63, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://4184878050"] = {name = "Evil Unicorn", prices = {["default"] = 3003, ["Ride"] = 3704.58, ["Fly|Ride"] = 3596.25, ["Neon|Fly|Ride"] = 7117, ["Mega|Fly|Ride"] = 23745.75}},
    ["rbxassetid://103896000727935"] = {name = "Aestus", prices = {["default"] = 91.88, ["Fly"] = 164.07, ["Ride"] = 95.01, ["Fly|Ride"] = 139.39, ["Neon"] = 550.97, ["Neon|Ride"] = 417.61, ["Neon|Fly|Ride"] = 497.44}},
    ["rbxassetid://9922229151"] = {name = "Dragonfly", prices = {["default"] = 2.1, ["Fly"] = 51.11, ["Ride"] = 19.69, ["Fly|Ride"] = 43.98, ["Neon"] = 19.69, ["Neon|Fly"] = 87.93, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 111.99, ["Mega"] = 187.85, ["Mega|Fly"] = 452.82, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://82820245821381"] = {name = "Temple Friend", prices = {["default"] = 3.94, ["Ride"] = 28.88, ["Neon"] = 23.63, ["Neon|Ride"] = 62.99, ["Neon|Fly|Ride"] = 266.44, ["Mega"] = 147, ["Mega|Ride"] = 199.5, ["Mega|Fly|Ride"] = 308.77}},
    ["rbxassetid://6404812861"] = {name = "Diamond Ladybug", prices = {["default"] = 140.25, ["Fly"] = 82.86, ["Ride"] = 48.2, ["Fly|Ride"] = 77.46, ["Neon|Ride"] = 698.12, ["Neon|Fly|Ride"] = 316.1, ["Mega|Fly|Ride"] = 1284.21}},
    ["rbxassetid://107535752953647"] = {name = "Strawberry Tortle", prices = {["default"] = 968.63, ["Ride"] = 1174.69, ["Fly|Ride"] = 1312.5}},
    ["rbxassetid://95844539868957"] = {name = "Amethyst Penguin", prices = {["default"] = 5581.98, ["Ride"] = 6139.76, ["Fly|Ride"] = 13125}},
    ["rbxassetid://6240249282"] = {name = "Guardian Lion", prices = {["default"] = 17.05, ["Fly"] = 41.88, ["Ride"] = 23.63, ["Fly|Ride"] = 43.32, ["Neon"] = 142.35, ["Neon|Ride"] = 279.33, ["Neon|Fly|Ride"] = 127.32, ["Mega"] = 2511.89, ["Mega|Fly|Ride"] = 697.07}},
    ["rbxassetid://11496077150"] = {name = "Ice Moth Dragon", prices = {["default"] = 20.95, ["Fly"] = 47.25, ["Ride"] = 36.88, ["Fly|Ride"] = 78.75, ["Neon"] = 155.66, ["Neon|Ride"] = 83.75, ["Neon|Fly|Ride"] = 208.29, ["Mega"] = 919.28, ["Mega|Ride"] = 534.62, ["Mega|Fly|Ride"] = 538.13}},
    ["rbxassetid://5862774166"] = {name = "Skele-Rex", prices = {["default"] = 38.07, ["Fly"] = 157.5, ["Ride"] = 43.23, ["Fly|Ride"] = 64.32, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 275.63, ["Mega|Fly|Ride"] = 984.38}},
    ["rbxassetid://11773429123"] = {name = "Nessie", prices = {["default"] = 217.88, ["Ride"] = 228.16, ["Fly|Ride"] = 293.04, ["Neon|Ride"] = 1335.49, ["Neon|Fly|Ride"] = 1115.7, ["Mega|Fly|Ride"] = 5582.66}},
    ["rbxassetid://121782270350526"] = {name = "Dark Choccybunny", prices = {["default"] = 5.24, ["Ride"] = 43.96, ["Fly|Ride"] = 131.25, ["Neon"] = 21, ["Neon|Fly"] = 656.25, ["Neon|Ride"] = 92.42, ["Neon|Fly|Ride"] = 209.34, ["Mega"] = 115.5, ["Mega|Ride"] = 198.19, ["Mega|Fly|Ride"] = 349.58}},
    ["rbxassetid://129591977577854"] = {name = "Ballet Swan", prices = {["default"] = 183.75, ["Fly"] = 264.78, ["Ride"] = 212.08, ["Fly|Ride"] = 262.5, ["Neon"] = 789.16, ["Neon|Ride"] = 977.55, ["Neon|Fly|Ride"] = 733.69, ["Mega|Fly|Ride"] = 6419.95}},
    ["rbxassetid://9669227320"] = {name = "Zodiac Minion Chick", prices = {["default"] = 3.47, ["Fly"] = 73.5, ["Ride"] = 16.42, ["Fly|Ride"] = 54.78, ["Neon"] = 26.92, ["Neon|Fly|Ride"] = 133.88, ["Mega"] = 464.88, ["Mega|Ride"] = 418.66, ["Mega|Fly|Ride"] = 310.31}},
    ["rbxassetid://13462536955"] = {name = "Caelum Cervi", prices = {["default"] = 250.16, ["Fly"] = 270, ["Ride"] = 231.3, ["Fly|Ride"] = 275.63, ["Neon|Fly|Ride"] = 886.5, ["Mega|Ride"] = 5582.66, ["Mega|Fly|Ride"] = 7554.11}},
    ["rbxassetid://10137833794"] = {name = "Green-Chested Pheasant", prices = {["default"] = 11.63, ["Fly"] = 418.62, ["Ride"] = 26.17, ["Neon"] = 98.4, ["Neon|Fly"] = 295.02, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 279.46, ["Mega"] = 461.57, ["Mega|Ride"] = 620.62, ["Mega|Fly|Ride"] = 494.02}},
    ["rbxassetid://16994954002"] = {name = "Brachiosaurus", prices = {["default"] = 3.68, ["Ride"] = 20.95, ["Neon"] = 14, ["Neon|Fly"] = 43.32, ["Neon|Ride"] = 56.54, ["Neon|Fly|Ride"] = 140.9, ["Mega"] = 75.02, ["Mega|Ride"] = 102.59, ["Mega|Fly|Ride"] = 330.84}},
    ["rbxassetid://121938982134212"] = {name = "Gecko Ducky", prices = {["default"] = 2.63, ["Neon"] = 3.92, ["Mega"] = 21, ["Mega|Ride"] = 153.23}},
    ["rbxassetid://17649624018"] = {name = "Kid Goat", prices = {["default"] = 5.25, ["Ride"] = 35.6, ["Fly|Ride"] = 217.71, ["Neon"] = 10.23, ["Neon|Ride"] = 118.29, ["Neon|Fly|Ride"] = 209.34, ["Mega"] = 69.09, ["Mega|Fly"] = 154956.68, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://4440867127"] = {name = "Chicken", prices = {["default"] = 59.07, ["Fly"] = 78.75, ["Ride"] = 103.3, ["Fly|Ride"] = 65.63, ["Neon"] = 279.46, ["Neon|Ride"] = 355.86, ["Neon|Fly|Ride"] = 393.75, ["Mega|Ride"] = 1311.19, ["Mega|Fly|Ride"] = 2099.76}},
    ["rbxassetid://5721844165"] = {name = "Tasmanian Tiger", prices = {["default"] = 2.1, ["Fly"] = 46.07, ["Ride"] = 18.26, ["Fly|Ride"] = 23.63, ["Neon"] = 8.39, ["Neon|Ride"] = 39.79, ["Neon|Fly|Ride"] = 116.23, ["Mega"] = 109.36, ["Mega|Ride"] = 94.32, ["Mega|Fly|Ride"] = 261.45}},
    ["rbxassetid://14146063876"] = {name = "Cockroach", prices = {["default"] = 13.38, ["Fly|Ride"] = 161.2, ["Neon"] = 168, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 125.62, ["Mega"] = 393.75}},
    ["rbxassetid://135555287601448"] = {name = "Rubber Ducky", prices = {["default"] = 2.1, ["Neon"] = 2.63, ["Neon|Ride"] = 95.74, ["Neon|Fly|Ride"] = 278.25, ["Mega"] = 15.72, ["Mega|Ride"] = 45.94}},
    ["rbxassetid://9664487060"] = {name = "Ant", prices = {["default"] = 2.1, ["Fly"] = 20.95, ["Ride"] = 18, ["Fly|Ride"] = 31.86, ["Neon"] = 2.05, ["Neon|Fly"] = 16.76, ["Neon|Ride"] = 15.65, ["Neon|Fly|Ride"] = 77.17, ["Mega"] = 13.95, ["Mega|Fly"] = 27.57, ["Mega|Ride"] = 23.59, ["Mega|Fly|Ride"] = 62.77}},
    ["rbxassetid://3293758505"] = {name = "Otter", prices = {["default"] = 2.1, ["Ride"] = 140.51, ["Fly|Ride"] = 37.35, ["Neon"] = 3.92, ["Neon|Fly"] = 15.75, ["Neon|Ride"] = 15.74, ["Neon|Fly|Ride"] = 39.79, ["Mega"] = 18.6, ["Mega|Ride"] = 45.94, ["Mega|Fly|Ride"] = 147.69}},
    ["rbxassetid://79698905581979"] = {name = "Ms. Muffet", prices = {["default"] = 2.1, ["Ride"] = 27.19, ["Neon"] = 2.05, ["Neon|Ride"] = 70.14, ["Mega"] = 22.19, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://13620861015"] = {name = "Flying Fish", prices = {["default"] = 2.63, ["Fly"] = 41.73, ["Ride"] = 18.38, ["Fly|Ride"] = 107.52, ["Neon"] = 3.77, ["Neon|Fly"] = 135.05, ["Neon|Ride"] = 92.12, ["Mega"] = 32.46, ["Mega|Fly"] = 52.5, ["Mega|Ride"] = 96.31, ["Mega|Fly|Ride"] = 165.38}},
    ["rbxassetid://100439668574210"] = {name = "Jiggly Jerboa", prices = {["default"] = 2.1, ["Neon"] = 3.23, ["Neon|Fly|Ride"] = 204.75, ["Mega"] = 27.23, ["Mega|Ride"] = 95.82}},
    ["rbxassetid://14815828879"] = {name = "Ghost", prices = {["default"] = 2.1, ["Fly"] = 47.16, ["Ride"] = 20.35, ["Fly|Ride"] = 60.73, ["Neon"] = 6.07, ["Neon|Ride"] = 31.42, ["Neon|Fly|Ride"] = 70.14, ["Mega"] = 48.57, ["Mega|Fly"] = 105, ["Mega|Ride"] = 90.03, ["Mega|Fly|Ride"] = 133.88}},
    ["rbxassetid://140565380261180"] = {name = "Galapagos Sea Lion", prices = {["default"] = 2.1, ["Neon"] = 2.63, ["Neon|Ride"] = 26.17, ["Mega"] = 15.75, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://14146188240"] = {name = "Bluebottle Fly", prices = {["default"] = 2.1, ["Fly|Ride"] = 525, ["Neon"] = 21.69, ["Mega"] = 140.26, ["Mega|Ride"] = 157.5}},
    ["rbxassetid://15930540035"] = {name = "Sandfish", prices = {["default"] = 23.28, ["Neon"] = 23.63, ["Mega"] = 139.13}},
    ["rbxassetid://74774507671765"] = {name = "Island Tarsier", prices = {["default"] = 2.1, ["Ride"] = 70.13, ["Neon"] = 6.13, ["Neon|Ride"] = 103.95, ["Mega"] = 24.94, ["Mega|Ride"] = 173.5}},
    ["rbxassetid://9678196095"] = {name = "Mouse", prices = {["default"] = 2.1, ["Fly"] = 30.24, ["Ride"] = 18.8, ["Neon"] = 2.05, ["Neon|Fly"] = 41.89, ["Neon|Ride"] = 14.86, ["Neon|Fly|Ride"] = 41.88, ["Mega"] = 14.47, ["Mega|Fly"] = 125.51, ["Mega|Ride"] = 23.63, ["Mega|Fly|Ride"] = 45.94}},
    ["rbxassetid://100695038890951"] = {name = "Basic Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13104111122"] = {name = "Piranha", prices = {["default"] = 8.87, ["Fly"] = 72.19, ["Ride"] = 42, ["Neon"] = 31.54, ["Neon|Ride"] = 39.38, ["Mega"] = 196.88}},
    ["rbxassetid://110856597065248"] = {name = "Bakeneko", prices = {["default"] = 2.63, ["Ride"] = 18.31, ["Fly|Ride"] = 78.73, ["Neon"] = 8.45, ["Neon|Ride"] = 34.13, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 35.44, ["Mega|Ride"] = 80.07, ["Mega|Fly|Ride"] = 170.61}},
    ["rbxassetid://128979941112615"] = {name = "Dirty Ducky", prices = {["default"] = 4.93, ["Neon"] = 7.86, ["Neon|Fly|Ride"] = 140.26, ["Mega"] = 82.69, ["Mega|Ride"] = 233.63}},
    ["rbxassetid://12479656052"] = {name = "Maleo Bird", prices = {["default"] = 3.87, ["Fly"] = 31.7, ["Ride"] = 32.71, ["Fly|Ride"] = 190.49, ["Neon"] = 9.83, ["Mega"] = 210, ["Mega|Ride"] = 85.3}},
    ["rbxassetid://3200646599"] = {name = "Cat", prices = {["default"] = 2.1, ["Fly"] = 18.38, ["Ride"] = 78.75, ["Fly|Ride"] = 21, ["Neon"] = 2.1, ["Neon|Fly"] = 17.69, ["Neon|Ride"] = 15.04, ["Neon|Fly|Ride"] = 35.25, ["Mega"] = 15.62, ["Mega|Ride"] = 20.97, ["Mega|Fly|Ride"] = 39.26}},
    ["rbxassetid://12479810452"] = {name = "Bali Starling", prices = {["default"] = 2.63, ["Fly"] = 26.25, ["Ride"] = 19.65, ["Fly|Ride"] = 138.17, ["Neon"] = 54.51, ["Neon|Ride"] = 111.58, ["Mega"] = 128.63, ["Mega|Ride"] = 167.48}},
    ["rbxassetid://9982819219"] = {name = "Dugong", prices = {["default"] = 3.68, ["Neon"] = 105, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 200.71, ["Mega|Ride"] = 321.33}},
    ["rbxassetid://3181727229"] = {name = "Buffalo", prices = {["default"] = 2.1, ["Fly"] = 22.14, ["Ride"] = 15.74, ["Fly|Ride"] = 35.6, ["Neon"] = 2.1, ["Neon|Fly"] = 23.63, ["Neon|Ride"] = 15.72, ["Neon|Fly|Ride"] = 155.74, ["Mega"] = 17.45, ["Mega|Ride"] = 60.73, ["Mega|Fly|Ride"] = 90.2}},
    ["rbxassetid://99694153348188"] = {name = "Urchin", prices = {["default"] = 2.63, ["Neon"] = 6.33, ["Neon|Fly"] = 77.47, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 59.96, ["Mega|Ride"] = 118.13}},
    ["rbxassetid://84089584046947"] = {name = "Blue Butterfly", prices = {["default"] = 2.63, ["Ride"] = 28.49, ["Neon"] = 7.86, ["Neon|Fly|Ride"] = 311.8, ["Mega"] = 70.27, ["Mega|Ride"] = 91.83, ["Mega|Fly|Ride"] = 279.46}},
    ["rbxassetid://124485808787576"] = {name = "Tegu", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Fly"] = 40.69, ["Neon|Ride"] = 35.44, ["Neon|Fly|Ride"] = 84, ["Mega"] = 15.74, ["Mega|Ride"] = 105}},
    ["rbxassetid://8938703774"] = {name = "Bullfrog", prices = {["default"] = 2.1, ["Ride"] = 16.95, ["Fly|Ride"] = 59.07, ["Neon"] = 6.55, ["Neon|Ride"] = 39.6, ["Mega|Ride"] = 140.26}},
    ["rbxassetid://102746202827395"] = {name = "Hopbop", prices = {["default"] = 2.63, ["Ride"] = 41.95, ["Neon"] = 6.56, ["Neon|Ride"] = 45.51, ["Mega"] = 131.25, ["Mega|Ride"] = 262.5}},
    ["rbxassetid://6498255997"] = {name = "Stingray", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 18.27, ["Fly|Ride"] = 108.94, ["Neon"] = 3.6, ["Neon|Ride"] = 19.38, ["Neon|Fly|Ride"] = 102.27, ["Mega"] = 145.49, ["Mega|Fly"] = 125.62, ["Mega|Ride"] = 90.57, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://13104106555"] = {name = "Mosquito", prices = {["default"] = 155.63, ["Ride"] = 81.38, ["Mega|Fly|Ride"] = 844.06}},
    ["rbxassetid://5721843483"] = {name = "Ground Sloth", prices = {["default"] = 2.1, ["Ride"] = 20.95, ["Fly|Ride"] = 5342.75, ["Neon"] = 6.25, ["Neon|Fly"] = 140.26, ["Neon|Ride"] = 27.9, ["Neon|Fly|Ride"] = 156.35, ["Mega"] = 150.94, ["Mega|Fly|Ride"] = 253.3}},
    ["rbxassetid://4506925908"] = {name = "Robin", prices = {["default"] = 2.1, ["Fly"] = 149.1, ["Fly|Ride"] = 141.75, ["Neon"] = 31.86, ["Neon|Fly"] = 98.4, ["Neon|Ride"] = 30.19, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 263.83, ["Mega|Ride"] = 278.41, ["Mega|Fly|Ride"] = 342.03}},
    ["rbxassetid://10382786163"] = {name = "Sado Mole", prices = {["default"] = 3.94, ["Fly"] = 79.47, ["Fly|Ride"] = 104.54, ["Neon"] = 55.13, ["Neon|Ride"] = 62.91, ["Mega"] = 315, ["Mega|Ride"] = 977.55}},
    ["rbxassetid://14471275373"] = {name = "Ash Zebra", prices = {["default"] = 11.02, ["Ride"] = 131.25}},
    ["rbxassetid://15923574361"] = {name = "Armadillo", prices = {["default"] = 2.63, ["Ride"] = 262.5, ["Fly|Ride"] = 70.14, ["Neon"] = 42.16, ["Neon|Ride"] = 140.26, ["Mega"] = 267.63, ["Mega|Ride"] = 367.5}},
    ["rbxassetid://15921927876"] = {name = "Coyote", prices = {["default"] = 5.25, ["Ride"] = 31.5, ["Fly|Ride"] = 110.25, ["Neon"] = 39.35, ["Neon|Ride"] = 157.5, ["Mega"] = 189, ["Mega|Ride"] = 249.27, ["Mega|Fly|Ride"] = 279.46}},
    ["rbxassetid://74353184935672"] = {name = "Sheepdog Ducky", prices = {["default"] = 2.62, ["Neon"] = 3.94, ["Neon|Ride"] = 127.71, ["Mega"] = 21, ["Mega|Ride"] = 139.13, ["Mega|Fly|Ride"] = 148.32}},
    ["rbxassetid://4748889845"] = {name = "Easter 2020 Egg", prices = {["default"] = 53.82}},
    ["rbxassetid://4752655872"] = {name = "Chick", prices = {["default"] = 3.94, ["Fly"] = 26.25, ["Ride"] = 19.65, ["Fly|Ride"] = 51.19, ["Neon"] = 49.96, ["Neon|Ride"] = 34.13, ["Neon|Fly|Ride"] = 106.31, ["Mega"] = 269.07, ["Mega|Ride"] = 308.77, ["Mega|Fly|Ride"] = 270.38}},
    ["rbxassetid://17174085645"] = {name = "Garden Snake", prices = {["default"] = 2.52, ["Fly"] = 70.88, ["Ride"] = 18.15, ["Fly|Ride"] = 70.14, ["Neon"] = 3.66, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 418.66, ["Mega"] = 26.21, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://17661844380"] = {name = "Show Pony", prices = {["default"] = 2.63, ["Ride"] = 48.2, ["Neon"] = 5.55, ["Neon|Ride"] = 30.18, ["Mega"] = 48.17, ["Mega|Ride"] = 77.7, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://8077196440"] = {name = "Walrus", prices = {["default"] = 2.1, ["Fly"] = 45.94, ["Ride"] = 20.95, ["Neon"] = 16.16, ["Neon|Ride"] = 57.75, ["Neon|Fly|Ride"] = 87.28, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 310.31}},
    ["rbxassetid://13104118499"] = {name = "Liger", prices = {["default"] = 7.76, ["Fly"] = 65.63, ["Neon|Ride"] = 210, ["Neon|Fly|Ride"] = 157.31}},
    ["rbxassetid://120937667166493"] = {name = "Aye Aye", prices = {["default"] = 2.5, ["Neon"] = 5.25, ["Neon|Ride"] = 51.15, ["Mega"] = 15.72, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 41.96, ["Mega|Fly|Ride"] = 141.1}},
    ["rbxassetid://3199974297"] = {name = "Cracked Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15348350458"] = {name = "Beluga Whale", prices = {["default"] = 2.1, ["Ride"] = 16.59, ["Fly|Ride"] = 56.54, ["Neon"] = 3.75, ["Neon|Fly"] = 68.83, ["Neon|Ride"] = 28.04, ["Neon|Fly|Ride"] = 99.45, ["Mega"] = 32.26, ["Mega|Fly"] = 155.74, ["Mega|Ride"] = 56.57, ["Mega|Fly|Ride"] = 146.05}},
    ["rbxassetid://7126719464"] = {name = "Wolpertinger", prices = {["default"] = 2.1, ["Ride"] = 21, ["Fly|Ride"] = 48.38, ["Neon"] = 7.65, ["Neon|Fly"] = 104.68, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 56.54, ["Mega"] = 188.41, ["Mega|Ride"] = 101.13, ["Mega|Fly|Ride"] = 124.37}},
    ["rbxassetid://125112456358906"] = {name = "Frankenfeline", prices = {["default"] = 2.63, ["Fly"] = 210, ["Ride"] = 20.89, ["Neon"] = 6.29, ["Neon|Ride"] = 35.6, ["Neon|Fly|Ride"] = 82.03, ["Mega"] = 17.07, ["Mega|Ride"] = 41.97, ["Mega|Fly|Ride"] = 102.38}},
    ["rbxassetid://80556114592490"] = {name = "Japanese Snow Fairy", prices = {["default"] = 2.63, ["Neon"] = 3.82, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 125.62, ["Mega"] = 15.73, ["Mega|Fly"] = 104.82, ["Mega|Ride"] = 66.94, ["Mega|Fly|Ride"] = 164.07}},
    ["rbxassetid://124671555129102"] = {name = "Ratatoskr", prices = {["default"] = 2.1, ["Fly"] = 26.36, ["Ride"] = 27.89, ["Neon"] = 5.25, ["Neon|Fly"] = 17.43, ["Neon|Ride"] = 28.28, ["Neon|Fly|Ride"] = 78.66, ["Mega"] = 15.75, ["Mega|Ride"] = 37.77, ["Mega|Fly|Ride"] = 131.15}},
    ["rbxassetid://116184296449988"] = {name = "Pinkypillar", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 125.62, ["Mega"] = 24.94}},
    ["rbxassetid://74353532164157"] = {name = "Red Panda Ducky", prices = {["default"] = 3.94, ["Neon"] = 3.91, ["Neon|Ride"] = 310.31, ["Neon|Fly|Ride"] = 420, ["Mega"] = 23.25, ["Mega|Ride"] = 262.5}},
    ["rbxassetid://4708551264"] = {name = "Bandicoot", prices = {["default"] = 2.1, ["Fly"] = 17418.62, ["Ride"] = 19.69, ["Neon"] = 6.06, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 42, ["Mega"] = 61.69, ["Mega|Ride"] = 60.22, ["Mega|Fly|Ride"] = 124.95}},
    ["rbxassetid://12480314681"] = {name = "Malaysian Tapir", prices = {["default"] = 13.13, ["Neon"] = 149.63, ["Mega"] = 463.66, ["Mega|Ride"] = 3099.52, ["Mega|Fly|Ride"] = 698.12}},
    ["rbxassetid://17482380743"] = {name = "Classic Teapot", prices = {["default"] = 6.57, ["Fly"] = 6562.5, ["Ride"] = 68.16, ["Neon"] = 40.69, ["Mega"] = 418.66, ["Mega|Ride"] = 315}},
    ["rbxassetid://14146142724"] = {name = "Mongoose", prices = {["default"] = 13.13, ["Ride"] = 31.4, ["Fly|Ride"] = 45.94, ["Neon"] = 28.82, ["Neon|Fly|Ride"] = 91.77, ["Mega"] = 223.99, ["Mega|Fly|Ride"] = 558.91}},
    ["rbxassetid://3181727351"] = {name = "Dog", prices = {["default"] = 2.1, ["Fly"] = 15.63, ["Ride"] = 15.12, ["Fly|Ride"] = 39.41, ["Neon"] = 2.05, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 13.11, ["Neon|Fly|Ride"] = 43.32, ["Mega"] = 18.31, ["Mega|Fly"] = 24.94, ["Mega|Ride"] = 22.14, ["Mega|Fly|Ride"] = 52.12}},
    ["rbxassetid://14267322852"] = {name = "Angelfish", prices = {["default"] = 15.75, ["Ride"] = 55.13, ["Neon"] = 37.7, ["Neon|Fly"] = 140.26, ["Neon|Ride"] = 31.39, ["Neon|Fly|Ride"] = 105, ["Mega"] = 54.63, ["Mega|Ride"] = 140.26}},
    ["rbxassetid://110130591707207"] = {name = "California Condor", prices = {["default"] = 2.1, ["Ride"] = 41.88, ["Neon"] = 2.1, ["Neon|Fly"] = 31.38, ["Neon|Ride"] = 31.42, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 15.42, ["Mega|Fly"] = 78.44, ["Mega|Ride"] = 106.77, ["Mega|Fly|Ride"] = 101.9}},
    ["rbxassetid://123567499475377"] = {name = "Forest Sprite", prices = {["default"] = 2.1, ["Neon"] = 3.93, ["Neon|Fly"] = 60.9, ["Mega"] = 17.07, ["Mega|Fly|Ride"] = 209.24}},
    ["rbxassetid://8663441035"] = {name = "Lunar White Tiger", prices = {["default"] = 2.1, ["Ride"] = 18.38, ["Fly|Ride"] = 35.86, ["Neon"] = 14.34, ["Neon|Ride"] = 32.46, ["Neon|Fly|Ride"] = 102.59, ["Mega"] = 167.48, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 176.79}},
    ["rbxassetid://16000498338"] = {name = "Groundhog", prices = {["default"] = 244.13, ["Ride"] = 252, ["Fly|Ride"] = 329.44, ["Neon"] = 1534.36, ["Neon|Ride"] = 1050, ["Neon|Fly|Ride"] = 1236.55, ["Mega|Fly|Ride"] = 3675}},
    ["rbxassetid://73268582142443"] = {name = "Kelp Raider", prices = {["default"] = 2.1, ["Neon"] = 8.38, ["Neon|Fly"] = 57.23, ["Neon|Ride"] = 82.7, ["Mega"] = 65.09}},
    ["rbxassetid://16369178617"] = {name = "Ornate Horned Frog", prices = {["default"] = 3.93, ["Fly"] = 103.68, ["Ride"] = 31.82, ["Neon|Ride"] = 167.48, ["Mega|Fly|Ride"] = 623.46}},
    ["rbxassetid://6245080170"] = {name = "Lunar Ox", prices = {["default"] = 2.1, ["Fly"] = 837.2, ["Ride"] = 14.43, ["Neon"] = 4.25, ["Neon|Fly"] = 43.32, ["Neon|Ride"] = 26.24, ["Neon|Fly|Ride"] = 61.69, ["Mega"] = 49.88, ["Mega|Ride"] = 78.51, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://92652981666929"] = {name = "Starmite", prices = {["default"] = 2.1, ["Fly|Ride"] = 121.42, ["Neon"] = 5.91, ["Neon|Fly"] = 41.89, ["Neon|Ride"] = 53.4, ["Mega"] = 109.76, ["Mega|Ride"] = 136.07}},
    ["rbxassetid://9482496753"] = {name = "King Penguin", prices = {["default"] = 3.93, ["Fly"] = 23.24, ["Ride"] = 20.95, ["Fly|Ride"] = 46.07, ["Neon"] = 33.51, ["Neon|Ride"] = 50.26, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 204.1, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 154.88}},
    ["rbxassetid://10489161125"] = {name = "Tanuki", prices = {["default"] = 2.63, ["Ride"] = 41.82, ["Fly|Ride"] = 246.75, ["Neon"] = 78.75, ["Neon|Ride"] = 90.57, ["Mega"] = 183.75, ["Mega|Fly|Ride"] = 399}},
    ["rbxassetid://7126720060"] = {name = "Wyvern", prices = {["default"] = 2.1, ["Fly"] = 17.52, ["Ride"] = 16.47, ["Fly|Ride"] = 39.79, ["Neon"] = 23.24, ["Neon|Fly"] = 70.14, ["Neon|Ride"] = 32.46, ["Neon|Fly|Ride"] = 43.32, ["Mega|Ride"] = 389.86, ["Mega|Fly|Ride"] = 166.52}},
    ["rbxassetid://4506925800"] = {name = "Swan", prices = {["default"] = 76.13, ["Fly"] = 118.13, ["Ride"] = 104.32, ["Fly|Ride"] = 131.25, ["Neon"] = 371.57, ["Neon|Fly"] = 405.05, ["Neon|Ride"] = 299.25, ["Neon|Fly|Ride"] = 393.75, ["Mega|Fly|Ride"] = 1347.01}},
    ["rbxassetid://13621428133"] = {name = "Tortuga de la Isla", prices = {["default"] = 227.07, ["Fly"] = 387.87, ["Ride"] = 240.19, ["Fly|Ride"] = 341.25, ["Neon|Fly|Ride"] = 1046.63, ["Mega|Fly|Ride"] = 5998.17}},
    ["rbxassetid://6684832189"] = {name = "Lamb", prices = {["default"] = 56.39, ["Fly"] = 116.13, ["Ride"] = 93.19, ["Fly|Ride"] = 104.68, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 327.48, ["Mega|Fly|Ride"] = 1271.65}},
    ["rbxassetid://122365328950491"] = {name = "Blossom Snake", prices = {["default"] = 4.57, ["Ride"] = 22.98, ["Neon"] = 21, ["Neon|Ride"] = 131.25, ["Mega"] = 585.06, ["Mega|Ride"] = 202.75, ["Mega|Fly|Ride"] = 1046.63}},
    ["rbxassetid://14360919997"] = {name = "Toasty Red Panda", prices = {["default"] = 14.42, ["Ride"] = 36.75, ["Fly|Ride"] = 78.75, ["Neon"] = 85.32, ["Neon|Ride"] = 140.26, ["Neon|Fly|Ride"] = 195.74, ["Mega"] = 937.78, ["Mega|Fly|Ride"] = 648.92}},
    ["rbxassetid://3181727278"] = {name = "Rabbit", prices = {["default"] = 2.1, ["Fly"] = 31.5, ["Ride"] = 17.07, ["Fly|Ride"] = 32.82, ["Neon"] = 5.25, ["Neon|Ride"] = 28.28, ["Neon|Fly|Ride"] = 56.54, ["Mega"] = 64.32, ["Mega|Fly"] = 118.56, ["Mega|Ride"] = 100.49, ["Mega|Fly|Ride"] = 210.76}},
    ["rbxassetid://14782579567"] = {name = "Nightmare Owl", prices = {["default"] = 6.97, ["Fly"] = 287.81, ["Ride"] = 27.23, ["Fly|Ride"] = 104.67, ["Neon"] = 48.17, ["Neon|Ride"] = 69.28, ["Neon|Fly|Ride"] = 407.4, ["Mega"] = 697.07, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 864.94}},
    ["rbxassetid://6498256342"] = {name = "Narwhal", prices = {["default"] = 2.1, ["Fly"] = 28.77, ["Ride"] = 16.42, ["Fly|Ride"] = 56.49, ["Neon"] = 18.25, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 30.19, ["Neon|Fly|Ride"] = 97.13, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 232.45}},
    ["rbxassetid://9227407648"] = {name = "Ibex", prices = {["default"] = 4.2, ["Fly|Ride"] = 328.13, ["Neon"] = 30.21, ["Neon|Ride"] = 56.79, ["Neon|Fly|Ride"] = 155.74, ["Mega"] = 195.74, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 301.02}},
    ["rbxassetid://16440727263"] = {name = "Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 34.35, ["Neon"] = 2.1, ["Neon|Ride"] = 23.04, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 23.04, ["Mega|Ride"] = 51.31, ["Mega|Fly|Ride"] = 195.74}},
    ["rbxassetid://10318106327"] = {name = "Yellow Butterfly", prices = {["default"] = 2.1, ["Fly"] = 45.93, ["Ride"] = 33.51, ["Fly|Ride"] = 54.58, ["Neon"] = 14.44, ["Neon|Fly"] = 104.68, ["Neon|Ride"] = 67.01, ["Neon|Fly|Ride"] = 69.57, ["Mega"] = 125.62, ["Mega|Ride"] = 113.91, ["Mega|Fly|Ride"] = 191.45}},
    ["rbxassetid://13894169749"] = {name = "Black Kite", prices = {["default"] = 5.94, ["Ride"] = 18.06, ["Fly|Ride"] = 83.74, ["Neon"] = 70.14, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 558.91, ["Mega"] = 265.85, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://4506925595"] = {name = "Polar Bear", prices = {["default"] = 117.9, ["Fly"] = 244.89, ["Ride"] = 195.71, ["Fly|Ride"] = 223.99, ["Neon"] = 698.12, ["Neon|Ride"] = 627.98, ["Neon|Fly|Ride"] = 558.18, ["Mega|Fly|Ride"] = 1929.38}},
    ["rbxassetid://14639006189"] = {name = "Canada Goose", prices = {["default"] = 22.13, ["Ride"] = 240.91, ["Fly|Ride"] = 195.74, ["Neon"] = 56.91, ["Neon|Ride"] = 140.26, ["Neon|Fly|Ride"] = 882.32, ["Mega"] = 414.75, ["Mega|Ride"] = 349.58, ["Mega|Fly|Ride"] = 418.66}},
    ["rbxassetid://5721844402"] = {name = "Triceratops", prices = {["default"] = 2.1, ["Ride"] = 20.98, ["Fly|Ride"] = 112.88, ["Neon|Ride"] = 41.89, ["Neon|Fly|Ride"] = 124.68, ["Mega"] = 308.44, ["Mega|Ride"] = 296.21, ["Mega|Fly|Ride"] = 627.98}},
    ["rbxassetid://83805820117149"] = {name = "Golden Jaguar", prices = {["default"] = 39.38, ["Fly"] = 59.07, ["Ride"] = 91.05, ["Fly|Ride"] = 178.5, ["Neon"] = 90.57, ["Neon|Fly|Ride"] = 294.54, ["Mega"] = 530.64, ["Mega|Ride"] = 598.67, ["Mega|Fly|Ride"] = 667.1}},
    ["rbxassetid://13936754497"] = {name = "Pinocchio", prices = {["default"] = 6.38}},
    ["rbxassetid://17059776562"] = {name = "Ankylosaurus", prices = {["default"] = 6.07, ["Ride"] = 32.46, ["Neon"] = 92.12, ["Neon|Ride"] = 46.5, ["Mega"] = 348.67, ["Mega|Fly|Ride"] = 530.64}},
    ["rbxassetid://3181727813"] = {name = "Horse", prices = {["default"] = 15.75, ["Fly"] = 61.77, ["Ride"] = 34.13, ["Fly|Ride"] = 43.32, ["Neon|Fly"] = 101818.18, ["Neon|Ride"] = 140.26, ["Neon|Fly|Ride"] = 140.21, ["Mega|Fly|Ride"] = 620.62}},
    ["rbxassetid://101098195340953"] = {name = "Mexican Wolf", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 3.94, ["Neon|Ride"] = 28.35, ["Neon|Fly|Ride"] = 155.74, ["Mega"] = 27.57, ["Mega|Ride"] = 80.07, ["Mega|Fly|Ride"] = 158.82}},
    ["rbxassetid://13894408663"] = {name = "Seagull", prices = {["default"] = 5.24, ["Fly"] = 34.13, ["Ride"] = 20.57, ["Fly|Ride"] = 85.84, ["Neon|Ride"] = 232.45, ["Mega"] = 279.46, ["Mega|Fly"] = 388.19, ["Mega|Ride"] = 161.2, ["Mega|Fly|Ride"] = 196.79}},
    ["rbxassetid://6998403532"] = {name = "Sasquatch", prices = {["default"] = 2.1, ["Ride"] = 20.95, ["Fly|Ride"] = 61.77, ["Neon"] = 15.74, ["Neon|Ride"] = 36.04, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 116.82, ["Mega|Ride"] = 120.74, ["Mega|Fly|Ride"] = 227.36}},
    ["rbxassetid://108348392849720"] = {name = "Water Opossum", prices = {["default"] = 2.1, ["Ride"] = 32.46, ["Neon"] = 3.78, ["Neon|Ride"] = 42, ["Mega"] = 23.36, ["Mega|Ride"] = 62.95, ["Mega|Fly|Ride"] = 310.31}},
    ["rbxassetid://11758575705"] = {name = "Moon Rabbit", prices = {["default"] = 24.09, ["Ride"] = 65.63, ["Neon"] = 203.42, ["Neon|Ride"] = 280.88, ["Mega"] = 960.81, ["Mega|Ride"] = 752.07, ["Mega|Fly|Ride"] = 1116.75}},
    ["rbxassetid://15922874831"] = {name = "Roadrunner", prices = {["default"] = 4.99, ["Fly|Ride"] = 210, ["Neon"] = 47.25, ["Neon|Ride"] = 119.34, ["Mega"] = 141.18, ["Mega|Ride"] = 388.31}},
    ["rbxassetid://6060988175"] = {name = "Snowman", prices = {["default"] = 6.57, ["Fly"] = 43.36, ["Ride"] = 42.56, ["Fly|Ride"] = 103.95, ["Neon"] = 83.71, ["Neon|Fly"] = 314.99, ["Neon|Ride"] = 52.5, ["Mega"] = 317.94, ["Mega|Ride"] = 376.8, ["Mega|Fly|Ride"] = 464.88}},
    ["rbxassetid://12720029414"] = {name = "Wood Pigeon", prices = {["default"] = 75.37, ["Fly"] = 140.25, ["Ride"] = 105, ["Fly|Ride"] = 209.32, ["Neon"] = 426.57, ["Neon|Ride"] = 656.25, ["Mega|Fly|Ride"] = 3021.65}},
    ["rbxassetid://136340738568203"] = {name = "Mr Whiskerpips", prices = {["default"] = 18.38, ["Ride"] = 157.5, ["Fly|Ride"] = 141.12, ["Neon"] = 99.75, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 119.34, ["Mega"] = 354.38, ["Mega|Ride"] = 653.99, ["Mega|Fly|Ride"] = 502.43}},
    ["rbxassetid://127204329704553"] = {name = "German Shepherd", prices = {["default"] = 69.57, ["Ride"] = 119.6, ["Fly|Ride"] = 155.63, ["Neon"] = 190.32, ["Neon|Ride"] = 278.41, ["Neon|Fly|Ride"] = 367.5, ["Mega"] = 977.55, ["Mega|Ride"] = 826.87, ["Mega|Fly|Ride"] = 853.01}},
    ["rbxassetid://99868640713300"] = {name = "Puptune", prices = {["default"] = 25.18, ["Ride"] = 78.49, ["Fly|Ride"] = 184.56, ["Neon"] = 131.25, ["Neon|Ride"] = 120.75, ["Neon|Fly|Ride"] = 279.46, ["Mega"] = 434.97, ["Mega|Ride"] = 323.87, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://9993276067"] = {name = "2022 Uplift Butterfly", prices = {["default"] = 3.87, ["Fly"] = 69.69, ["Ride"] = 23.04, ["Neon"] = 65.63, ["Neon|Ride"] = 265.85, ["Neon|Fly|Ride"] = 126.25, ["Mega"] = 330.07, ["Mega|Ride"] = 1046.63, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://136574776317301"] = {name = "Sweetheart Rat", prices = {["default"] = 20.79, ["Ride"] = 140.25, ["Fly|Ride"] = 209.34, ["Neon"] = 94.5, ["Neon|Ride"] = 257.98, ["Neon|Fly|Ride"] = 389.82, ["Mega"] = 326.55, ["Mega|Ride"] = 399, ["Mega|Fly|Ride"] = 622.11}},
    ["rbxassetid://17649489402"] = {name = "Cow Calf", prices = {["default"] = 10.48, ["Ride"] = 34.26, ["Fly|Ride"] = 104.89, ["Neon"] = 34.85, ["Neon|Fly"] = 112.01, ["Neon|Ride"] = 94.5, ["Mega"] = 248.72, ["Mega|Ride"] = 273, ["Mega|Fly|Ride"] = 483}},
    ["rbxassetid://77869404304609"] = {name = "Budgie Witch", prices = {["default"] = 2.1, ["Neon"] = 2.37, ["Neon|Fly"] = 698.12, ["Neon|Ride"] = 26.25, ["Mega"] = 17.07, ["Mega|Fly"] = 140.26, ["Mega|Ride"] = 66.94, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://111676861947081"] = {name = "The Black Dog", prices = {["default"] = 6.57, ["Ride"] = 104.67, ["Neon"] = 18.38, ["Neon|Ride"] = 83.83, ["Mega"] = 105, ["Mega|Ride"] = 157.49, ["Mega|Fly|Ride"] = 311.32}},
    ["rbxassetid://13104122472"] = {name = "Borhyaena Gigantica", prices = {["default"] = 3.93, ["Neon"] = 22.32, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 363.19, ["Mega"] = 336}},
    ["rbxassetid://105232492496005"] = {name = "Firefighter Gibbon", prices = {["default"] = 17.43, ["Ride"] = 31.44, ["Neon"] = 27.57, ["Neon|Ride"] = 82.95, ["Mega"] = 123.38, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://3409443514"] = {name = "Elephant", prices = {["default"] = 558.91, ["Ride"] = 572.45, ["Fly|Ride"] = 525, ["Neon"] = 2602.94, ["Neon|Ride"] = 2093.24, ["Neon|Fly|Ride"] = 1443.75, ["Mega|Fly|Ride"] = 5878.95}},
    ["rbxassetid://10137833682"] = {name = "Brown-Chested Pheasant", prices = {["default"] = 10.48, ["Fly"] = 56.52, ["Ride"] = 31.4, ["Fly|Ride"] = 63.06, ["Neon"] = 30.37, ["Neon|Ride"] = 77.9, ["Mega|Ride"] = 418.66}},
    ["rbxassetid://12490691849"] = {name = "Gecko", prices = {["default"] = 9.17, ["Fly"] = 31.5, ["Ride"] = 25.2, ["Neon"] = 56.54, ["Neon|Fly"] = 315, ["Neon|Ride"] = 75.37, ["Mega"] = 364.24, ["Mega|Ride"] = 558.91, ["Mega|Fly|Ride"] = 522.27}},
    ["rbxassetid://9913459163"] = {name = "Trapdoor Snail", prices = {["default"] = 2.97, ["Fly"] = 28.26, ["Ride"] = 23.23, ["Fly|Ride"] = 314, ["Neon|Ride"] = 157.18, ["Mega"] = 223.13, ["Mega|Ride"] = 354.38, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://124413732651376"] = {name = "Gumball Caterpillar", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Ride"] = 28.26, ["Fly|Ride"] = 941.48, ["Neon"] = 6.55, ["Neon|Fly"] = 70.14, ["Neon|Ride"] = 33.5, ["Neon|Fly|Ride"] = 112.35, ["Mega"] = 78.75, ["Mega|Ride"] = 110.96, ["Mega|Fly|Ride"] = 233.63}},
    ["rbxassetid://96107383056013"] = {name = "Gummy Guana", prices = {["default"] = 2.1, ["Ride"] = 698.01, ["Neon"] = 3.94, ["Mega"] = 20.97, ["Mega|Fly|Ride"] = 141.16}},
    ["rbxassetid://3261465951"] = {name = "Blue Egg", prices = {["default"] = 1115.7}},
    ["rbxassetid://11245006051"] = {name = "Therapy Dog", prices = {["default"] = 7.87, ["Fly"] = 65.63, ["Ride"] = 41.27, ["Neon"] = 83.75, ["Neon|Fly"] = 140.26, ["Neon|Ride"] = 140.26, ["Neon|Fly|Ride"] = 523.32, ["Mega"] = 454.25, ["Mega|Ride"] = 604.95, ["Mega|Fly|Ride"] = 1019.42}},
    ["rbxassetid://76323474173289"] = {name = "Kelp Crewmate", prices = {["default"] = 2.63, ["Ride"] = 45.36, ["Neon"] = 7.87, ["Neon|Ride"] = 59.78, ["Mega"] = 86.02, ["Mega|Ride"] = 96.31, ["Mega|Fly|Ride"] = 232.45}},
    ["rbxassetid://14978701264"] = {name = "Scarecrow Horse", prices = {["default"] = 3.94, ["Fly"] = 41.88, ["Ride"] = 42, ["Fly|Ride"] = 525, ["Neon"] = 12.55, ["Neon|Ride"] = 70.14, ["Neon|Fly|Ride"] = 128.63, ["Mega"] = 183.75, ["Mega|Ride"] = 155.74, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://3409443801"] = {name = "Lion", prices = {["default"] = 485.63, ["Ride"] = 558.84, ["Fly|Ride"] = 527.33, ["Neon|Ride"] = 1396.21, ["Neon|Fly|Ride"] = 1509.38, ["Mega|Fly|Ride"] = 14129.32}},
    ["rbxassetid://13979014954"] = {name = "Fossa", prices = {["default"] = 10.48, ["Fly"] = 196.88, ["Ride"] = 72.19, ["Neon"] = 26.25, ["Mega"] = 391.13, ["Mega|Ride"] = 396.68}},
    ["rbxassetid://137886461285917"] = {name = "Angus Cow", prices = {["default"] = 2.1, ["Neon"] = 5.91, ["Neon|Ride"] = 52.35, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 24.82, ["Mega|Fly"] = 189, ["Mega|Ride"] = 94.82, ["Mega|Fly|Ride"] = 140.26}},
    ["rbxassetid://128343324254978"] = {name = "Blue Cat", prices = {["default"] = 2.1, ["Ride"] = 837.2, ["Neon"] = 2.63, ["Neon|Ride"] = 89.25, ["Neon|Fly|Ride"] = 265.85, ["Mega"] = 20.97, ["Mega|Ride"] = 124.37, ["Mega|Fly|Ride"] = 209.34}},
    ["rbxassetid://79274485636628"] = {name = "Indian Flying Fox", prices = {["default"] = 20.95, ["Ride"] = 111.57, ["Neon"] = 75.37, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 309.82, ["Mega"] = 328.13, ["Mega|Ride"] = 481.46, ["Mega|Fly|Ride"] = 372.75}},
    ["rbxassetid://96039704958671"] = {name = "Singularity Pisces", prices = {["default"] = 30.19, ["Neon|Fly|Ride"] = 124.37, ["Mega|Ride"] = 561.29, ["Mega|Fly|Ride"] = 1116.75}},
    ["rbxassetid://12489494348"] = {name = "Komodo Dragon", prices = {["default"] = 7.88, ["Fly|Ride"] = 405.05, ["Neon"] = 140.26, ["Mega"] = 635.73, ["Mega|Fly|Ride"] = 1240.05}},
    ["rbxassetid://14360919129"] = {name = "Flaming Zebra", prices = {["default"] = 10.48, ["Ride"] = 65.54, ["Neon"] = 115.43, ["Neon|Ride"] = 103.69, ["Neon|Fly|Ride"] = 775.19, ["Mega"] = 1859.49}},
    ["rbxassetid://108242367048842"] = {name = "Honey Badger", prices = {["default"] = 315, ["Ride"] = 367.5, ["Fly|Ride"] = 435.41, ["Neon|Fly|Ride"] = 1203.62, ["Mega|Ride"] = 3205.8, ["Mega|Fly|Ride"] = 3150}},
    ["rbxassetid://11119262646"] = {name = "Evil Chickatrice", prices = {["default"] = 6.28, ["Ride"] = 31.37, ["Fly|Ride"] = 82.48, ["Neon"] = 59.07, ["Neon|Ride"] = 138.17, ["Neon|Fly|Ride"] = 140.26, ["Mega"] = 529.78, ["Mega|Ride"] = 522.27, ["Mega|Fly|Ride"] = 837.31}},
    ["rbxassetid://120631772928905"] = {name = "Subzero Scorpion", prices = {["default"] = 5.55, ["Ride"] = 33.51}},
    ["rbxassetid://70394243440806"] = {name = "Ghostly Cat", prices = {["default"] = 11.53, ["Ride"] = 39.63, ["Fly|Ride"] = 161.2, ["Neon"] = 36.48, ["Neon|Ride"] = 103.63, ["Neon|Fly|Ride"] = 125.62, ["Mega"] = 183.74, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 350.27}},
    ["rbxassetid://108186720416551"] = {name = "Storm Condor", prices = {["default"] = 2.1, ["Ride"] = 42, ["Fly|Ride"] = 107.81, ["Neon"] = 11.53, ["Neon|Ride"] = 45.61, ["Mega"] = 37.99, ["Mega|Ride"] = 103.63, ["Mega|Fly|Ride"] = 202.23}},
    ["rbxassetid://11181152874"] = {name = "Mule", prices = {["default"] = 30.19, ["Ride"] = 69.47, ["Neon"] = 242.82, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 464.88, ["Mega|Ride"] = 2771.45, ["Mega|Fly|Ride"] = 878.13}},
    ["rbxassetid://94781392732758"] = {name = "Onza", prices = {["default"] = 2.1, ["Fly"] = 580.63, ["Ride"] = 33.71, ["Fly|Ride"] = 80.07, ["Neon"] = 15.72, ["Neon|Fly"] = 182.13, ["Neon|Ride"] = 44.18, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 85.32, ["Mega|Ride"] = 83.75, ["Mega|Fly|Ride"] = 217.71}},
    ["rbxassetid://102763887893057"] = {name = "Cherub Chipmunk", prices = {["default"] = 2.41, ["Ride"] = 83.74, ["Fly|Ride"] = 148.25, ["Neon"] = 4.99, ["Neon|Ride"] = 45.03, ["Neon|Fly|Ride"] = 112.01, ["Mega"] = 46.1, ["Mega|Ride"] = 52.01, ["Mega|Fly|Ride"] = 140.26}},
    ["rbxassetid://104845330408668"] = {name = "Icy Porcupine", prices = {["default"] = 4.2, ["Ride"] = 167.46, ["Fly|Ride"] = 262.5, ["Neon"] = 19.69, ["Neon|Ride"] = 837.31, ["Neon|Fly|Ride"] = 272.88, ["Mega"] = 105, ["Mega|Ride"] = 137.82, ["Mega|Fly|Ride"] = 310.31}},
    ["rbxassetid://12597275903"] = {name = "White Sand Dollar", prices = {["default"] = 64.32, ["Fly"] = 98.44, ["Ride"] = 105, ["Fly|Ride"] = 150.73, ["Neon"] = 418.66, ["Mega|Fly|Ride"] = 1003.72}},
    ["rbxassetid://9901393350"] = {name = "Irish Water Spaniel", prices = {["default"] = 278.25, ["Ride"] = 309.75, ["Fly|Ride"] = 464.6, ["Neon|Ride"] = 1127.43, ["Neon|Fly|Ride"] = 1341.16, ["Mega|Fly|Ride"] = 5691.51}},
    ["rbxassetid://128640048014369"] = {name = "River Otter", prices = {["default"] = 6.45, ["Neon"] = 27.23, ["Mega"] = 103.69, ["Mega|Ride"] = 170.1, ["Mega|Fly|Ride"] = 497.43}},
    ["rbxassetid://138984599254588"] = {name = "Tree Sasquatch", prices = {["default"] = 8.39, ["Neon"] = 18.66, ["Mega"] = 91.87, ["Mega|Ride"] = 121.43, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://15870220155"] = {name = "Vulture", prices = {["default"] = 3.82, ["Fly"] = 155.57, ["Neon"] = 131.9}},
    ["rbxassetid://7734902490"] = {name = "Halloween Black Mummy Cat", prices = {["default"] = 2.1, ["Fly"] = 53.23, ["Ride"] = 27.57, ["Fly|Ride"] = 41.89, ["Neon"] = 3.93, ["Neon|Ride"] = 28.88, ["Neon|Fly|Ride"] = 182.13, ["Mega"] = 51.19, ["Mega|Ride"] = 107.82, ["Mega|Fly|Ride"] = 178.5}},
    ["rbxassetid://116677376014234"] = {name = "Sunflower Friend", prices = {["default"] = 2.1, ["Ride"] = 58.97, ["Neon"] = 6.34, ["Mega"] = 43.98, ["Mega|Fly"] = 140.26, ["Mega|Ride"] = 206.07}},
    ["rbxassetid://13186022212"] = {name = "Grinmoire", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Ride"] = 20.95, ["Fly|Ride"] = 41.93, ["Neon"] = 3.94, ["Neon|Fly"] = 59.07, ["Neon|Ride"] = 23.04, ["Neon|Fly|Ride"] = 105, ["Mega"] = 45.94, ["Mega|Fly"] = 10884.81, ["Mega|Ride"] = 104.62, ["Mega|Fly|Ride"] = 279.46}},
    ["rbxassetid://11119263014"] = {name = "Chickatrice", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Ride"] = 24.94, ["Fly|Ride"] = 50.26, ["Neon"] = 17.07, ["Neon|Fly"] = 98.4, ["Neon|Ride"] = 30.19, ["Neon|Fly|Ride"] = 91.07, ["Mega"] = 155.74, ["Mega|Ride"] = 236.55, ["Mega|Fly|Ride"] = 558.91}},
    ["rbxassetid://13104110160"] = {name = "Blue Ringed Octopus", prices = {["default"] = 42, ["Ride"] = 140.25, ["Fly|Ride"] = 104.67, ["Neon"] = 91.88, ["Neon|Ride"] = 207.24, ["Neon|Fly|Ride"] = 112.01, ["Mega"] = 367.5, ["Mega|Fly"] = 446.25, ["Mega|Ride"] = 498.75, ["Mega|Fly|Ride"] = 732.65}},
    ["rbxassetid://16088265753"] = {name = "Flaming Fox", prices = {["default"] = 61.47, ["Ride"] = 93.18, ["Neon"] = 487.74, ["Neon|Ride"] = 413.43, ["Mega|Ride"] = 3241.88, ["Mega|Fly|Ride"] = 1489.36}},
    ["rbxassetid://84105347355723"] = {name = "Gibbon", prices = {["default"] = 2.1, ["Ride"] = 23.23, ["Fly|Ride"] = 131.25, ["Neon"] = 5.6, ["Neon|Ride"] = 109.27, ["Neon|Fly|Ride"] = 360.94, ["Mega"] = 39.19, ["Mega|Ride"] = 98.4}},
    ["rbxassetid://9543194411"] = {name = "Swordfish", prices = {["default"] = 2.1, ["Fly"] = 16.77, ["Ride"] = 19.69, ["Fly|Ride"] = 53.43, ["Neon"] = 3.94, ["Neon|Ride"] = 24.86, ["Neon|Fly|Ride"] = 69.57, ["Mega"] = 38.07, ["Mega|Fly"] = 157.5, ["Mega|Ride"] = 56.54, ["Mega|Fly|Ride"] = 118.13}},
    ["rbxassetid://11706157391"] = {name = "Steppe Lion", prices = {["default"] = 11.42, ["Ride"] = 98.39, ["Neon"] = 155.66, ["Neon|Ride"] = 138.17, ["Neon|Fly|Ride"] = 278.41, ["Mega"] = 619.18, ["Mega|Fly|Ride"] = 540.06}},
    ["rbxassetid://18119064023"] = {name = "Bald Eagle", prices = {["default"] = 459.38, ["Fly"] = 249.38, ["Ride"] = 461.51, ["Fly|Ride"] = 279.49, ["Neon|Ride"] = 1046.63, ["Neon|Fly|Ride"] = 1515.52, ["Mega|Fly|Ride"] = 5148.32}},
    ["rbxassetid://6060991172"] = {name = "Lynx", prices = {["default"] = 26.25, ["Fly"] = 209.9, ["Ride"] = 73.5, ["Fly|Ride"] = 116.82, ["Neon|Ride"] = 320.28, ["Neon|Fly|Ride"] = 455.59, ["Mega|Ride"] = 918.75, ["Mega|Fly|Ride"] = 1085.48}},
    ["rbxassetid://10614198346"] = {name = "Pomeranian", prices = {["default"] = 2.1, ["Ride"] = 41.97, ["Neon"] = 15.72, ["Neon|Ride"] = 56.54, ["Neon|Fly|Ride"] = 182.13, ["Mega"] = 99.45, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 246.75}},
    ["rbxassetid://13663102008"] = {name = "Angler Fish", prices = {["default"] = 4.11, ["Fly"] = 209.32, ["Ride"] = 65.63, ["Neon"] = 19.63, ["Mega|Ride"] = 434.66}},
    ["rbxassetid://5067925193"] = {name = "Toy Monkey", prices = {["default"] = 31.6, ["Fly"] = 77.97, ["Ride"] = 45.94, ["Fly|Ride"] = 62.79, ["Neon|Ride"] = 138.17, ["Neon|Fly|Ride"] = 194.69, ["Mega|Ride"] = 904.32, ["Mega|Fly|Ride"] = 1082.22}},
    ["rbxassetid://15698960105"] = {name = "Kookaburra", prices = {["default"] = 86.89, ["Ride"] = 223.97, ["Fly|Ride"] = 189.98, ["Neon"] = 743.12, ["Neon|Ride"] = 544.25, ["Neon|Fly|Ride"] = 610.32, ["Mega"] = 3070.78}},
    ["rbxassetid://14266900917"] = {name = "Ring-tailed Lemur", prices = {["default"] = 236.25, ["Ride"] = 263.81, ["Fly|Ride"] = 265.85, ["Neon|Ride"] = 1360.62, ["Neon|Fly|Ride"] = 958.13, ["Mega|Fly|Ride"] = 3147.19}},
    ["rbxassetid://10467419131"] = {name = "Leopard Cat", prices = {["default"] = 20.57, ["Fly"] = 837.2, ["Ride"] = 67.13, ["Fly|Ride"] = 213.72, ["Neon"] = 111.57, ["Neon|Ride"] = 143.1, ["Mega"] = 388.5, ["Mega|Ride"] = 413.43, ["Mega|Fly|Ride"] = 522.27}},
    ["rbxassetid://6498256485"] = {name = "Crab", prices = {["default"] = 2.1, ["Ride"] = 16.94, ["Fly|Ride"] = 30.19, ["Neon"] = 8.86, ["Neon|Ride"] = 19.9, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 112.01, ["Mega|Ride"] = 140.26, ["Mega|Fly|Ride"] = 189}},
    ["rbxassetid://5721843587"] = {name = "Glyptodon", prices = {["default"] = 2.63, ["Ride"] = 28.25, ["Fly|Ride"] = 70.27, ["Neon"] = 17.05, ["Neon|Fly|Ride"] = 98.58, ["Mega"] = 195.57, ["Mega|Ride"] = 226.09, ["Mega|Fly|Ride"] = 259.87}},
    ["rbxassetid://13979141397"] = {name = "Giant Anteater", prices = {["default"] = 296.63, ["Ride"] = 393.75, ["Fly|Ride"] = 479.36, ["Neon"] = 1354.34, ["Neon|Ride"] = 1284.21, ["Neon|Fly|Ride"] = 1729.03}},
    ["rbxassetid://109730629255705"] = {name = "Ruddy Duck", prices = {["default"] = 2.41, ["Neon"] = 8.9, ["Neon|Fly|Ride"] = 118125, ["Mega"] = 23.25, ["Mega|Ride"] = 158.27}},
    ["rbxassetid://6498259006"] = {name = "Clownfish", prices = {["default"] = 2.1, ["Ride"] = 20.46, ["Fly|Ride"] = 65.04, ["Neon"] = 18.69, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 110.25, ["Mega"] = 131.25, ["Mega|Ride"] = 278.41, ["Mega|Fly|Ride"] = 255.35}},
    ["rbxassetid://11758569695"] = {name = "Amami Rabbit", prices = {["default"] = 17.73, ["Ride"] = 129.54, ["Neon"] = 86.69, ["Mega"] = 619.61, ["Mega|Ride"] = 498.75, ["Mega|Fly|Ride"] = 558.91}},
    ["rbxassetid://11505509482"] = {name = "Ice Wolf", prices = {["default"] = 112.66, ["Fly"] = 296.14, ["Ride"] = 144.38, ["Fly|Ride"] = 147, ["Neon|Ride"] = 698.12, ["Neon|Fly|Ride"] = 393.75, ["Mega|Fly|Ride"] = 1870.32}},
    ["rbxassetid://9994480266"] = {name = "Royal Palace Spaniel", prices = {["Fly"] = 35.6, ["Ride"] = 30.12, ["Fly|Ride"] = 53.82, ["Neon"] = 60.41, ["Neon|Ride"] = 103.69, ["Neon|Fly|Ride"] = 140.26, ["Mega"] = 698.12, ["Mega|Ride"] = 733.69, ["Mega|Fly|Ride"] = 414.75}},
    ["rbxassetid://100897154120273"] = {name = "Clumpty", prices = {["default"] = 2.1, ["Ride"] = 59.06, ["Neon"] = 2.63, ["Neon|Ride"] = 198.75, ["Neon|Fly|Ride"] = 178.27, ["Mega"] = 38.07, ["Mega|Fly|Ride"] = 418.66}},
    ["rbxassetid://11108831285"] = {name = "Ocelot", prices = {["default"] = 2.1, ["Ride"] = 19.69, ["Fly|Ride"] = 83.74, ["Neon"] = 5.25, ["Neon|Fly"] = 31.38, ["Neon|Ride"] = 28.28, ["Neon|Fly|Ride"] = 69.18, ["Mega"] = 28.28, ["Mega|Ride"] = 57.75, ["Mega|Fly|Ride"] = 165.83}},
    ["rbxassetid://99323773370664"] = {name = "Dire Wolf", prices = {["default"] = 11.53, ["Ride"] = 52.41, ["Fly|Ride"] = 131.9, ["Neon"] = 34.9, ["Neon|Fly"] = 263.67, ["Neon|Ride"] = 92.98, ["Neon|Fly|Ride"] = 157.01, ["Mega"] = 147, ["Mega|Ride"] = 233.41, ["Mega|Fly|Ride"] = 323.55}},
    ["rbxassetid://17649307413"] = {name = "Mini Pig", prices = {["default"] = 1455.57, ["Ride"] = 1312.5, ["Fly|Ride"] = 1470, ["Neon|Fly|Ride"] = 4416.57, ["Mega|Fly|Ride"] = 16607.7}},
    ["rbxassetid://12720029753"] = {name = "Border Collie", prices = {["default"] = 553.88, ["Ride"] = 616.88, ["Fly|Ride"] = 616.88, ["Neon|Ride"] = 2930.54, ["Neon|Fly|Ride"] = 2395.32, ["Mega|Fly|Ride"] = 7940.68}},
    ["rbxassetid://4440866760"] = {name = "Pig", prices = {["default"] = 302.82, ["Ride"] = 325.5, ["Fly|Ride"] = 404.86, ["Neon"] = 735, ["Neon|Ride"] = 1123.4, ["Neon|Fly|Ride"] = 900.11, ["Mega"] = 5303.22, ["Mega|Fly|Ride"] = 2508.7}},
    ["rbxassetid://4506925854"] = {name = "Arctic Fox", prices = {["default"] = 276.94, ["Fly"] = 351.75, ["Ride"] = 370.47, ["Fly|Ride"] = 419.18, ["Neon|Ride"] = 989.51, ["Neon|Fly|Ride"] = 853.13, ["Mega|Ride"] = 3675, ["Mega|Fly|Ride"] = 3202.66}},
    ["rbxassetid://11758575618"] = {name = "Black Moon Bear", prices = {["default"] = 2.51, ["Ride"] = 17.69, ["Fly|Ride"] = 49.96, ["Neon"] = 5.25, ["Neon|Ride"] = 40.69, ["Neon|Fly|Ride"] = 59.07, ["Mega"] = 79.56, ["Mega|Ride"] = 112.88, ["Mega|Fly|Ride"] = 200.82}},
    ["rbxassetid://15547272520"] = {name = "Christmas Pudding Pup", prices = {["default"] = 328.13, ["Fly"] = 590.62, ["Ride"] = 380.63, ["Fly|Ride"] = 661.39, ["Neon"] = 1074.49, ["Neon|Ride"] = 1240.05, ["Neon|Fly|Ride"] = 1246.88, ["Mega"] = 21769.6, ["Mega|Ride"] = 4465.93, ["Mega|Fly|Ride"] = 3901.79}},
    ["rbxassetid://78519945248690"] = {name = "Zombie Chick", prices = {["default"] = 2.63, ["Fly"] = 183.75, ["Ride"] = 27.23, ["Neon"] = 9.18, ["Neon|Ride"] = 56.42, ["Neon|Fly|Ride"] = 112.72, ["Mega"] = 220.5, ["Mega|Ride"] = 91.07, ["Mega|Fly|Ride"] = 277.93}},
    ["rbxassetid://10357178561"] = {name = "Ibis", prices = {["default"] = 2.1, ["Fly"] = 24.09, ["Ride"] = 31.4, ["Fly|Ride"] = 49.88, ["Neon"] = 7.86, ["Neon|Ride"] = 61.69, ["Neon|Fly|Ride"] = 83.75, ["Mega"] = 65.63, ["Mega|Ride"] = 140.44, ["Mega|Fly|Ride"] = 209.34}},
    ["rbxassetid://96759122303055"] = {name = "Clubtail Dragonfly", prices = {["default"] = 2.1, ["Fly"] = 57.75, ["Neon"] = 4.06, ["Neon|Fly"] = 77.88, ["Mega"] = 31.39}},
    ["rbxassetid://12778628897"] = {name = "Karate Gorilla", prices = {["default"] = 58.59, ["Ride"] = 65.54, ["Fly|Ride"] = 459.38, ["Neon"] = 273, ["Neon|Ride"] = 310.31}},
    ["rbxassetid://13104121371"] = {name = "Poison Dart Frog", prices = {["default"] = 3.83, ["Fly"] = 65.62, ["Ride"] = 23.56, ["Fly|Ride"] = 60.69, ["Neon"] = 15.72, ["Mega"] = 328.13}},
    ["rbxassetid://71881209536633"] = {name = "Humbug", prices = {["default"] = 2.1, ["Ride"] = 55.12, ["Neon"] = 2.63, ["Neon|Ride"] = 42.16, ["Neon|Fly|Ride"] = 95.82, ["Mega"] = 22.32, ["Mega|Fly"] = 310.31, ["Mega|Ride"] = 93.09, ["Mega|Fly|Ride"] = 140.44}},
    ["rbxassetid://11109314958"] = {name = "Ghost Wolf", prices = {["default"] = 2.1, ["Fly"] = 32.87, ["Ride"] = 21, ["Fly|Ride"] = 49.88, ["Neon"] = 8.4, ["Neon|Fly"] = 91.88, ["Neon|Ride"] = 28.76, ["Neon|Fly|Ride"] = 90.03, ["Mega"] = 78.51, ["Mega|Ride"] = 115.5, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://16088267136"] = {name = "Wildfire Hawk", prices = {["default"] = 3.19, ["Ride"] = 56.91, ["Fly|Ride"] = 51.44, ["Neon"] = 101.54, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 237.57}},
    ["rbxassetid://16898328648"] = {name = "Preppy Capuchin Monkey", prices = {["default"] = 14.21, ["Ride"] = 25.12, ["Neon"] = 83.75, ["Mega"] = 504.39, ["Mega|Ride"] = 334.93, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://15921713413"] = {name = "Thorny Devil", prices = {["default"] = 3.93, ["Ride"] = 41.88, ["Fly|Ride"] = 87.94, ["Neon"] = 187.69, ["Neon|Ride"] = 63.09, ["Neon|Fly|Ride"] = 697.32, ["Mega|Ride"] = 464.88, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://16441364976"] = {name = "Gold Mahi Mahi", prices = {["default"] = 2.1, ["Ride"] = 22.09, ["Fly|Ride"] = 84, ["Neon"] = 3.94, ["Neon|Ride"] = 46.5, ["Mega"] = 40.69, ["Mega|Ride"] = 126}},
    ["rbxassetid://8077189117"] = {name = "Puffin", prices = {["default"] = 229.23, ["Ride"] = 233.39, ["Fly|Ride"] = 406.88, ["Neon"] = 1217.23, ["Neon|Ride"] = 2616.55, ["Neon|Fly|Ride"] = 1050, ["Mega|Fly|Ride"] = 4210.38}},
    ["rbxassetid://8663441120"] = {name = "Lunar Tiger", prices = {["default"] = 2.1, ["Fly"] = 20.1, ["Ride"] = 17.07, ["Fly|Ride"] = 131.25, ["Neon"] = 4.02, ["Neon|Ride"] = 23.04, ["Neon|Fly|Ride"] = 49.88, ["Mega"] = 52.35, ["Mega|Ride"] = 72.19, ["Mega|Fly|Ride"] = 123.38}},
    ["rbxassetid://17174216294"] = {name = "Skunk", prices = {["default"] = 8.39, ["Ride"] = 98.44, ["Fly|Ride"] = 236.25, ["Neon"] = 26.25, ["Neon|Ride"] = 105, ["Mega"] = 315, ["Mega|Ride"] = 418.66, ["Mega|Fly|Ride"] = 464.88}},
    ["rbxassetid://13981141292"] = {name = "Kiwi", prices = {["default"] = 39.58, ["Ride"] = 70.13, ["Fly|Ride"] = 136.07, ["Neon"] = 167.83, ["Neon|Ride"] = 210.51, ["Mega"] = 656.25, ["Mega|Ride"] = 1021.57, ["Mega|Fly|Ride"] = 630}},
    ["rbxassetid://3409443617"] = {name = "Meerkat", prices = {["default"] = 171.94, ["Ride"] = 209.04, ["Fly|Ride"] = 263.76, ["Neon"] = 818.47, ["Neon|Ride"] = 867.57, ["Neon|Fly|Ride"] = 866.25, ["Mega|Ride"] = 2625, ["Mega|Fly|Ride"] = 3452.79}},
    ["rbxassetid://99042906016947"] = {name = "Seafoam Butterfly", prices = {["Neon"] = 119.34, ["Mega"] = 388.19, ["Mega|Ride"] = 406.88, ["Mega|Fly|Ride"] = 698.12}},
    ["rbxassetid://15504847683"] = {name = "Gingerbread Hare", prices = {["default"] = 27.44, ["Ride"] = 261.19, ["Neon"] = 185.84, ["Mega"] = 1116.75, ["Mega|Ride"] = 837.31}},
    ["rbxassetid://15302316802"] = {name = "Peppermint Penguin", prices = {["default"] = 1575, ["Ride"] = 1181.25, ["Fly|Ride"] = 1365, ["Neon|Ride"] = 5906.25, ["Neon|Fly|Ride"] = 4837.47, ["Mega|Fly|Ride"] = 20932.31}},
    ["rbxassetid://10318106124"] = {name = "Scarlet Butterfly", prices = {["default"] = 11.82, ["Fly"] = 43.32, ["Ride"] = 22.32, ["Fly|Ride"] = 63, ["Neon"] = 109.19, ["Neon|Fly"] = 111.57, ["Neon|Ride"] = 49.88, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 262.49, ["Mega|Ride"] = 253.37, ["Mega|Fly|Ride"] = 551.58}},
    ["rbxassetid://14145989411"] = {name = "Toy Poodle", prices = {["default"] = 5.25, ["Fly"] = 39.38, ["Ride"] = 35.44, ["Neon"] = 30.19, ["Neon|Ride"] = 141.03, ["Neon|Fly|Ride"] = 112.88, ["Mega"] = 212.63, ["Mega|Ride"] = 295.21}},
    ["rbxassetid://82833859118891"] = {name = "Snowy Mammoth", prices = {["default"] = 3.94, ["Ride"] = 56.52, ["Fly|Ride"] = 942.38, ["Neon"] = 15.81, ["Neon|Ride"] = 140.26, ["Neon|Fly|Ride"] = 310.31, ["Mega"] = 141.75, ["Mega|Ride"] = 265.85}},
    ["rbxassetid://12917346501"] = {name = "Happy Duckling", prices = {["default"] = 20.5, ["Fly"] = 699.47, ["Ride"] = 31.21, ["Fly|Ride"] = 94.5, ["Neon"] = 72.19, ["Neon|Ride"] = 98.96, ["Neon|Fly|Ride"] = 148.67, ["Mega"] = 488.78, ["Mega|Ride"] = 431.82, ["Mega|Fly|Ride"] = 408.19}},
    ["rbxassetid://7064993901"] = {name = "2021 Uplift Butterfly", prices = {["default"] = 2.1, ["Fly"] = 35.6, ["Ride"] = 18.47, ["Fly|Ride"] = 45.31, ["Neon"] = 18.25, ["Neon|Fly"] = 41.93, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 99.75, ["Mega|Ride"] = 147.61, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://10926054144"] = {name = "Slug", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 52.5, ["Neon"] = 8.44, ["Neon|Fly"] = 13125, ["Mega"] = 195.04, ["Mega|Ride"] = 242.53, ["Mega|Fly|Ride"] = 351.89}},
    ["rbxassetid://11571113906"] = {name = "Glacier Moth", prices = {["default"] = 195.74, ["Fly|Ride"] = 537.92, ["Neon|Ride"] = 1693.13, ["Neon|Fly|Ride"] = 1439.1, ["Mega|Fly|Ride"] = 4552.79}},
    ["rbxassetid://73641371341710"] = {name = "Ice Cube", prices = {["default"] = 2.63, ["Ride"] = 28.88, ["Neon"] = 6.56, ["Neon|Fly"] = 92.93, ["Neon|Ride"] = 41.51, ["Neon|Fly|Ride"] = 140.26, ["Mega"] = 93.85, ["Mega|Ride"] = 155.24, ["Mega|Fly|Ride"] = 232.45}},
    ["rbxassetid://13077767764"] = {name = "Eel", prices = {["default"] = 2.15, ["Neon"] = 35.44, ["Mega"] = 262.5}},
    ["rbxassetid://134995672989153"] = {name = "Hammerhead Shark", prices = {["default"] = 2.41, ["Fly"] = 58.09, ["Ride"] = 40.69, ["Neon"] = 19.28, ["Neon|Ride"] = 60.73, ["Mega"] = 85.23, ["Mega|Ride"] = 85.32, ["Mega|Fly|Ride"] = 434.66}},
    ["rbxassetid://15555939727"] = {name = "Snow Monkey", prices = {["default"] = 143.07, ["Fly"] = 354.9, ["Ride"] = 262.5, ["Fly|Ride"] = 702.19, ["Neon"] = 525, ["Neon|Ride"] = 555.77, ["Neon|Fly|Ride"] = 912.19, ["Mega|Ride"] = 5269.28, ["Mega|Fly|Ride"] = 2093.24}},
    ["rbxassetid://11758575992"] = {name = "Water Rabbit", prices = {["default"] = 15.7, ["Ride"] = 56.52, ["Fly|Ride"] = 108.87, ["Neon"] = 39.38, ["Neon|Fly|Ride"] = 285.91, ["Mega"] = 681.37, ["Mega|Ride"] = 698.12, ["Mega|Fly|Ride"] = 652.05}},
    ["rbxassetid://90987982535884"] = {name = "Great Pyrenees", prices = {["default"] = 19.43, ["Ride"] = 79.55, ["Neon"] = 154.92, ["Neon|Ride"] = 111.57, ["Neon|Fly|Ride"] = 209.34, ["Mega"] = 677.17, ["Mega|Ride"] = 741.34, ["Mega|Fly|Ride"] = 604.34}},
    ["rbxassetid://84560154336174"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Neon"] = 3.91, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 35.44, ["Mega"] = 26.75, ["Mega|Ride"] = 70.62, ["Mega|Fly|Ride"] = 261.19}},
    ["rbxassetid://4506847061"] = {name = "Reindeer", prices = {["default"] = 75.87, ["Fly"] = 123.69, ["Ride"] = 174.57, ["Fly|Ride"] = 221.82, ["Neon"] = 418.66, ["Neon|Ride"] = 349.58, ["Neon|Fly|Ride"] = 434.66, ["Mega|Fly|Ride"] = 1067.56}},
    ["rbxassetid://98687388677942"] = {name = "Moonpine", prices = {["default"] = 2.1, ["Ride"] = 52.5, ["Neon"] = 4.6, ["Neon|Fly"] = 31.38, ["Neon|Ride"] = 30.19, ["Neon|Fly|Ride"] = 588, ["Mega"] = 45.94}},
    ["rbxassetid://11109032702"] = {name = "Green Amazon", prices = {["default"] = 24.09, ["Fly"] = 140.25, ["Ride"] = 35.6, ["Fly|Ride"] = 206.22, ["Neon"] = 93.64, ["Neon|Ride"] = 85.32, ["Neon|Fly|Ride"] = 155.74, ["Mega"] = 418.66, ["Mega|Ride"] = 588.41, ["Mega|Fly|Ride"] = 350.44}},
    ["rbxassetid://3743730108"] = {name = "Black Panther", prices = {["default"] = 44.63, ["Fly"] = 112, ["Ride"] = 97.13, ["Neon"] = 289.91, ["Neon|Ride"] = 183.75, ["Neon|Fly|Ride"] = 376.8, ["Mega|Fly|Ride"] = 1396.21}},
    ["rbxassetid://3181727398"] = {name = "Chocolate Labrador", prices = {["default"] = 2.1, ["Fly"] = 41.88, ["Ride"] = 17.43, ["Fly|Ride"] = 23.63, ["Neon"] = 2.1, ["Neon|Fly"] = 27.89, ["Neon|Ride"] = 18.86, ["Neon|Fly|Ride"] = 48.17, ["Mega"] = 18.86, ["Mega|Fly"] = 55.13, ["Mega|Ride"] = 86.1, ["Mega|Fly|Ride"] = 104.68}},
    ["rbxassetid://134636987874448"] = {name = "Nebula Snake", prices = {["default"] = 3.93, ["Ride"] = 26.25, ["Fly|Ride"] = 1346.59, ["Neon"] = 19.69, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 217.87, ["Mega|Fly|Ride"] = 523.69}},
    ["rbxassetid://13104122150"] = {name = "Hippo", prices = {["default"] = 18.2, ["Ride"] = 61.25, ["Neon"] = 195.74, ["Neon|Ride"] = 173.76, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 621.7, ["Mega|Ride"] = 3139.86, ["Mega|Fly|Ride"] = 628.69}},
    ["rbxassetid://103821295208934"] = {name = "Black Rhino", prices = {["default"] = 2.1, ["Ride"] = 17.07, ["Neon"] = 2.63, ["Mega"] = 24.94}},
    ["rbxassetid://14782580070"] = {name = "Undead Elk", prices = {["default"] = 3.93, ["Fly"] = 210, ["Ride"] = 26.25, ["Fly|Ride"] = 111.57, ["Neon"] = 42.15, ["Neon|Ride"] = 140.26, ["Neon|Fly|Ride"] = 310.31, ["Mega"] = 498.2, ["Mega|Fly"] = 787.5, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 374.98}},
    ["rbxassetid://8566683782"] = {name = "Giant Blue Scarab", prices = {["default"] = 14.75, ["Fly"] = 41.88, ["Ride"] = 32.82, ["Fly|Ride"] = 63.06, ["Neon"] = 837.31, ["Mega|Ride"] = 283.58, ["Mega|Fly|Ride"] = 475.17}},
    ["rbxassetid://14850232913"] = {name = "Cute-A-Cabra", prices = {["default"] = 6.28, ["Ride"] = 58.31, ["Neon"] = 29.96, ["Neon|Fly"] = 699.57, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 200.82, ["Mega"] = 169.32, ["Mega|Ride"] = 195.74, ["Mega|Fly|Ride"] = 290.97}},
    ["rbxassetid://15508248825"] = {name = "Eggnog Dog", prices = {["default"] = 17.05, ["Fly"] = 2092.99, ["Ride"] = 81.38, ["Neon"] = 84, ["Neon|Ride"] = 353.07, ["Neon|Fly|Ride"] = 6197.86, ["Mega"] = 458.99, ["Mega|Ride"] = 542.16, ["Mega|Fly|Ride"] = 975.47}},
    ["rbxassetid://17822797244"] = {name = "Orange Betta Fish", prices = {["default"] = 2.63, ["Ride"] = 145.69, ["Fly|Ride"] = 104.68, ["Neon"] = 8.06, ["Neon|Ride"] = 56.54, ["Neon|Fly|Ride"] = 99.08, ["Mega"] = 74.82, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 166.43}},
    ["rbxassetid://9922274393"] = {name = "Retired Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://103431939950304"] = {name = "Pink Dog", prices = {["default"] = 2.1, ["Neon"] = 3.93, ["Mega"] = 28.87, ["Mega|Ride"] = 137.12}},
    ["rbxassetid://15227882502"] = {name = "Christmas Future Egg", prices = {["default"] = 48.57}},
    ["rbxassetid://12597276740"] = {name = "Red Sand Dollar", prices = {["default"] = 64.32, ["Fly"] = 102.38, ["Ride"] = 92.11, ["Fly|Ride"] = 116.17, ["Neon"] = 1050, ["Neon|Ride"] = 244.93, ["Mega"] = 1088.5, ["Mega|Ride"] = 1116.75, ["Mega|Fly|Ride"] = 837.31}},
    ["rbxassetid://136447612467002"] = {name = "Glyptodon Ducky", prices = {["default"] = 2.1, ["Ride"] = 59.07, ["Neon"] = 2.63, ["Mega"] = 17.36, ["Mega|Ride"] = 8652.38, ["Mega|Fly|Ride"] = 116.82}},
    ["rbxassetid://101033810950061"] = {name = "Sea Slug", prices = {["default"] = 774.56, ["Ride"] = 538.11, ["Fly|Ride"] = 558.91, ["Neon"] = 2625, ["Neon|Ride"] = 1903.13, ["Mega"] = 8372.94, ["Mega|Fly|Ride"] = 10466.16}},
    ["rbxassetid://14353536658"] = {name = "Birthday Butterfly 2023", prices = {["default"] = 2.57, ["Fly"] = 49.88, ["Ride"] = 40.94, ["Fly|Ride"] = 73.27, ["Neon"] = 39.73, ["Mega|Ride"] = 279.46, ["Mega|Fly|Ride"] = 558.91}},
    ["rbxassetid://9938967851"] = {name = "Tan Chow-Chow", prices = {["default"] = 3.93, ["Ride"] = 24.94, ["Fly|Ride"] = 91.88, ["Neon"] = 22.32, ["Neon|Ride"] = 46.5, ["Neon|Fly|Ride"] = 86.89, ["Mega"] = 237.6, ["Mega|Ride"] = 278.94, ["Mega|Fly|Ride"] = 187.69}},
    ["rbxassetid://14448124117"] = {name = "Chipmunk", prices = {["default"] = 11.53, ["Ride"] = 58.08, ["Neon"] = 155.9, ["Mega|Ride"] = 960.81}},
    ["rbxassetid://13104108894"] = {name = "Lammergeier", prices = {["default"] = 3.71, ["Fly"] = 39.38, ["Ride"] = 44.15}},
    ["rbxassetid://14446659851"] = {name = "Raccoon", prices = {["default"] = 6.57, ["Ride"] = 83.74, ["Fly|Ride"] = 157.5, ["Neon"] = 102.67, ["Neon|Ride"] = 106.73, ["Neon|Fly|Ride"] = 350.44, ["Mega"] = 363.57, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 502.39}},
    ["rbxassetid://84477079324217"] = {name = "Peachick", prices = {["default"] = 6.3, ["Fly"] = 105, ["Ride"] = 34.85, ["Neon"] = 15.74, ["Neon|Ride"] = 92.12, ["Neon|Fly|Ride"] = 284.82, ["Mega"] = 294.26, ["Mega|Fly"] = 483.55, ["Mega|Ride"] = 195.57, ["Mega|Fly|Ride"] = 279.46}},
    ["rbxassetid://9718162456"] = {name = "Donkey", prices = {["default"] = 2.1, ["Fly"] = 46.47, ["Ride"] = 15.7, ["Fly|Ride"] = 75.35, ["Neon"] = 2.1, ["Neon|Fly"] = 28.28, ["Neon|Ride"] = 25.35, ["Neon|Fly|Ride"] = 70.26, ["Mega"] = 17.07, ["Mega|Fly"] = 77.88, ["Mega|Ride"] = 63, ["Mega|Fly|Ride"] = 94.5}},
    ["rbxassetid://93800993117604"] = {name = "Love Bird", prices = {["default"] = 5.25, ["Ride"] = 39.38, ["Neon"] = 45.05, ["Neon|Ride"] = 87.94, ["Neon|Fly|Ride"] = 295.21, ["Mega"] = 167.88, ["Mega|Ride"] = 217.88}},
    ["rbxassetid://13665143675"] = {name = "Lion Cub", prices = {["default"] = 248.89, ["Ride"] = 275.62, ["Fly|Ride"] = 425.99, ["Neon"] = 1480.5, ["Neon|Ride"] = 1029.89, ["Neon|Fly|Ride"] = 1912.18, ["Mega|Fly|Ride"] = 4323.58}},
    ["rbxassetid://13883284001"] = {name = "Ice Cream Hermit Crab", prices = {["default"] = 88.48, ["Ride"] = 143.06, ["Fly|Ride"] = 7674.84, ["Neon"] = 460.48, ["Neon|Ride"] = 339.12, ["Neon|Fly|Ride"] = 698.25, ["Mega|Ride"] = 1521.8, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://8938701212"] = {name = "Woodpecker", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 24.94, ["Fly|Ride"] = 38.06, ["Neon"] = 19.66, ["Neon|Ride"] = 34.13, ["Neon|Fly|Ride"] = 65.63, ["Mega|Fly"] = 208.29, ["Mega|Ride"] = 91.07, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://4800190034"] = {name = "Toucan", prices = {["default"] = 2.1, ["Fly"] = 17.26, ["Ride"] = 12.64, ["Fly|Ride"] = 31.5, ["Neon"] = 10.8, ["Neon|Fly"] = 31.5, ["Neon|Ride"] = 24.36, ["Neon|Fly|Ride"] = 70.88, ["Mega"] = 56.54, ["Mega|Ride"] = 112.01, ["Mega|Fly|Ride"] = 198.45}},
    ["rbxassetid://15886122789"] = {name = "Deathstalker Scorpion", prices = {["default"] = 3.94, ["Ride"] = 22.31, ["Fly|Ride"] = 98.44, ["Neon"] = 39.38}},
    ["rbxassetid://12139402705"] = {name = "Sheeeeep", prices = {["default"] = 275.63, ["Ride"] = 262.5, ["Fly|Ride"] = 312.89}},
    ["rbxassetid://7126720389"] = {name = "Hydra", prices = {["default"] = 2.1, ["Fly"] = 28.26, ["Ride"] = 18.38, ["Fly|Ride"] = 77.01, ["Neon"] = 28.28, ["Neon|Fly"] = 155.66, ["Neon|Ride"] = 35.6, ["Neon|Fly|Ride"] = 77.88, ["Mega"] = 286.02, ["Mega|Ride"] = 136.07, ["Mega|Fly|Ride"] = 301.88}},
    ["rbxassetid://17662289865"] = {name = "Punk Pony", prices = {["default"] = 5.18, ["Fly"] = 124.27, ["Ride"] = 39.5, ["Fly|Ride"] = 209.32, ["Neon"] = 31.38, ["Neon|Ride"] = 223.13, ["Mega"] = 230.99, ["Mega|Ride"] = 217.71, ["Mega|Fly|Ride"] = 447.97}},
    ["rbxassetid://84009422958505"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 91.88, ["Neon"] = 4.13, ["Neon|Ride"] = 30.24, ["Neon|Fly|Ride"] = 140.26, ["Mega"] = 42.16, ["Mega|Ride"] = 95.7}},
    ["rbxassetid://9473352533"] = {name = "Space Whale", prices = {["default"] = 16.99, ["Fly"] = 70.13, ["Ride"] = 28.39, ["Fly|Ride"] = 62.74, ["Neon"] = 140.26, ["Neon|Ride"] = 92.99, ["Neon|Fly|Ride"] = 133.98, ["Mega"] = 746.73, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 442.74}},
    ["rbxassetid://71528203783155"] = {name = "Pupcake", prices = {["default"] = 38.07, ["Ride"] = 96.44, ["Fly|Ride"] = 216.57, ["Neon"] = 105, ["Neon|Fly"] = 464.88, ["Neon|Ride"] = 183.75, ["Neon|Fly|Ride"] = 315, ["Mega"] = 459.38, ["Mega|Fly"] = 2197.92, ["Mega|Ride"] = 484.32, ["Mega|Fly|Ride"] = 698.12}},
    ["rbxassetid://4440867010"] = {name = "Drake", prices = {["default"] = 24.92, ["Fly"] = 70.88, ["Ride"] = 43.31, ["Fly|Ride"] = 92.12, ["Neon"] = 131.25, ["Neon|Fly"] = 290.07, ["Neon|Ride"] = 161.2, ["Neon|Fly|Ride"] = 232.61, ["Mega|Ride"] = 945, ["Mega|Fly|Ride"] = 977.55}},
    ["rbxassetid://9708962205"] = {name = "Parakeet", prices = {["default"] = 2.1, ["Fly"] = 15.91, ["Ride"] = 72.01, ["Fly|Ride"] = 51.45, ["Neon"] = 2.1, ["Neon|Fly"] = 45.03, ["Neon|Ride"] = 20.95, ["Neon|Fly|Ride"] = 51.15, ["Mega"] = 27.9, ["Mega|Fly"] = 28.88, ["Mega|Ride"] = 70.14, ["Mega|Fly|Ride"] = 115.5}},
    ["rbxassetid://4883302468"] = {name = "Shrew", prices = {["default"] = 190.32, ["Ride"] = 210, ["Fly|Ride"] = 349.58, ["Neon"] = 774.71, ["Neon|Ride"] = 903.25, ["Neon|Fly|Ride"] = 1145.01, ["Mega"] = 4080.77, ["Mega|Fly|Ride"] = 3746.9}},
    ["rbxassetid://11507151679"] = {name = "Irish Elk", prices = {["default"] = 13.11, ["Fly"] = 140.39, ["Ride"] = 45.94, ["Neon"] = 101.07, ["Neon|Ride"] = 187.69, ["Mega"] = 788.87, ["Mega|Ride"] = 449.78, ["Mega|Fly|Ride"] = 558.91}},
    ["rbxassetid://17163957321"] = {name = "Blue Jay", prices = {["default"] = 2.52, ["Ride"] = 28.26, ["Fly|Ride"] = 56.52, ["Neon"] = 6.15, ["Neon|Ride"] = 31.39, ["Mega"] = 57.21, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://8705079225"] = {name = "Abyssinian Cat", prices = {["default"] = 2.1, ["Fly"] = 25.12, ["Ride"] = 19.69, ["Fly|Ride"] = 70.88, ["Neon"] = 2.63, ["Neon|Ride"] = 28.28, ["Neon|Fly|Ride"] = 96.36, ["Mega"] = 23.63, ["Mega|Fly"] = 137.12, ["Mega|Ride"] = 35.44, ["Mega|Fly|Ride"] = 108.61}},
    ["rbxassetid://17059483392"] = {name = "Velociraptor", prices = {["default"] = 2.63, ["Ride"] = 26.25, ["Fly|Ride"] = 78.51, ["Neon"] = 7.87, ["Neon|Ride"] = 27.23, ["Neon|Fly|Ride"] = 6977.8, ["Mega"] = 124.37, ["Mega|Ride"] = 145.69, ["Mega|Fly|Ride"] = 279.46}},
    ["rbxassetid://16548686870"] = {name = "Hamster", prices = {["default"] = 15.7, ["Fly"] = 65.63, ["Ride"] = 22.58, ["Fly|Ride"] = 70.14, ["Neon"] = 41.89, ["Neon|Ride"] = 45.93, ["Neon|Fly|Ride"] = 90.61, ["Mega"] = 581.1, ["Mega|Ride"] = 351, ["Mega|Fly|Ride"] = 346.44}},
    ["rbxassetid://13883285383"] = {name = "Castle Hermit Crab", prices = {["default"] = 8.44, ["Ride"] = 31.37, ["Neon"] = 41.89, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 210, ["Mega|Ride"] = 208.29, ["Mega|Fly|Ride"] = 309.82}},
    ["rbxassetid://82240382561696"] = {name = "Cocoadile", prices = {["default"] = 2.1, ["Ride"] = 60.4, ["Neon"] = 2.63, ["Neon|Ride"] = 46.11, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 18.38, ["Mega|Ride"] = 62.77, ["Mega|Fly|Ride"] = 279.46}},
    ["rbxassetid://74702714943302"] = {name = "Grave Owl", prices = {["default"] = 91.88, ["Ride"] = 92.92, ["Fly|Ride"] = 83.75, ["Neon"] = 24.94, ["Neon|Fly"] = 102.92, ["Neon|Ride"] = 52.35, ["Neon|Fly|Ride"] = 123.38, ["Mega"] = 223.11, ["Mega|Fly|Ride"] = 244.93}},
    ["rbxassetid://97556530589327"] = {name = "Bison", prices = {["default"] = 2.62, ["Ride"] = 210, ["Neon"] = 4.66, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 155.74, ["Mega"] = 34.12, ["Mega|Ride"] = 96.31, ["Mega|Fly|Ride"] = 620.62}},
    ["rbxassetid://11694855214"] = {name = "Shetland Pony Dark Brown", prices = {["default"] = 2.1, ["Fly"] = 26.54, ["Ride"] = 18.38, ["Fly|Ride"] = 45.94, ["Neon"] = 5.98, ["Neon|Fly"] = 28.28, ["Neon|Ride"] = 23.25, ["Neon|Fly|Ride"] = 124.69, ["Mega"] = 62.19, ["Mega|Ride"] = 91.77, ["Mega|Fly|Ride"] = 195.26}},
    ["rbxassetid://14398823196"] = {name = "Alpaca", prices = {["default"] = 976.5, ["Ride"] = 852.37, ["Fly|Ride"] = 1050, ["Neon|Fly|Ride"] = 4913.87, ["Mega|Fly|Ride"] = 15279.54}},
    ["rbxassetid://5721843716"] = {name = "Pterodactyl", prices = {["default"] = 2.1, ["Fly"] = 19.56, ["Ride"] = 21, ["Fly|Ride"] = 56.54, ["Neon"] = 15.75, ["Neon|Fly"] = 72.19, ["Neon|Ride"] = 57.36, ["Neon|Fly|Ride"] = 61.77, ["Mega"] = 187.37, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://82057257613990"] = {name = "Unicorn Ducky", prices = {["default"] = 2.63, ["Ride"] = 82.69, ["Neon"] = 5.92, ["Neon|Fly|Ride"] = 341.25, ["Mega"] = 51.14, ["Mega|Ride"] = 171.78, ["Mega|Fly|Ride"] = 222.48}},
    ["rbxassetid://4708551366"] = {name = "Frog", prices = {["default"] = 12.55, ["Fly"] = 32.46, ["Ride"] = 27.23, ["Fly|Ride"] = 51.19, ["Neon"] = 39.38, ["Neon|Ride"] = 45.83, ["Neon|Fly|Ride"] = 93.22, ["Mega|Ride"] = 425.99, ["Mega|Fly|Ride"] = 375.75}},
    ["rbxassetid://4800189682"] = {name = "Starfish", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 15.75, ["Fly|Ride"] = 41.89, ["Neon"] = 7.76, ["Neon|Fly"] = 85.3, ["Neon|Ride"] = 22.32, ["Neon|Fly|Ride"] = 63, ["Mega"] = 77.96, ["Mega|Fly"] = 349.84, ["Mega|Ride"] = 104.62, ["Mega|Fly|Ride"] = 229.23}},
    ["rbxassetid://16736753854"] = {name = "Candy Cane Snail", prices = {["default"] = 53.82, ["Neon"] = 469.94, ["Neon|Ride"] = 338.63, ["Mega|Fly|Ride"] = 977.55}},
    ["rbxassetid://10393730410"] = {name = "Orca", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Fly|Ride"] = 698.01, ["Neon"] = 6.35, ["Neon|Ride"] = 35.83, ["Neon|Fly|Ride"] = 206.07, ["Mega"] = 112.01, ["Mega|Ride"] = 90.77, ["Mega|Fly|Ride"] = 392.11}},
    ["rbxassetid://111642509798043"] = {name = "Toxic Kaijunior", prices = {["default"] = 2.35, ["Fly"] = 73.5, ["Ride"] = 26.25, ["Fly|Ride"] = 65.63, ["Neon"] = 13.05, ["Neon|Ride"] = 70.14, ["Neon|Fly|Ride"] = 140.26, ["Mega"] = 131.25, ["Mega|Ride"] = 558.91, ["Mega|Fly|Ride"] = 144.38}},
    ["rbxassetid://14146181621"] = {name = "Tawny Frogmouth", prices = {["default"] = 2.63, ["Fly|Ride"] = 65.76, ["Neon"] = 15.72, ["Mega"] = 107.41}},
    ["rbxassetid://9474010501"] = {name = "Ribbon Seal", prices = {["default"] = 2.1, ["Fly"] = 2593.49, ["Ride"] = 16.88, ["Fly|Ride"] = 98.44, ["Neon"] = 6.57, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 69.21, ["Mega"] = 26.25, ["Mega|Fly"] = 418.66, ["Mega|Ride"] = 61.69}},
    ["rbxassetid://6776872152"] = {name = "Red Squirrel", prices = {["default"] = 16.76, ["Fly"] = 37.17, ["Ride"] = 31.5, ["Fly|Ride"] = 40.69, ["Neon|Ride"] = 112.01, ["Neon|Fly|Ride"] = 98.44, ["Mega|Fly|Ride"] = 470.99}},
    ["rbxassetid://84140820920420"] = {name = "Siamese Cat", prices = {["default"] = 769.78, ["Ride"] = 748.12, ["Fly|Ride"] = 1105.25, ["Neon"] = 1729.91, ["Neon|Ride"] = 2197.92, ["Neon|Fly|Ride"] = 2099.74, ["Mega|Ride"] = 4725, ["Mega|Fly|Ride"] = 5571.15}},
    ["rbxassetid://3181727773"] = {name = "Bunny", prices = {["default"] = 2.1, ["Fly"] = 18.38, ["Ride"] = 22.15, ["Fly|Ride"] = 30.43, ["Neon"] = 4.2, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 50.26, ["Mega"] = 48.17, ["Mega|Ride"] = 77.44, ["Mega|Fly|Ride"] = 193.59}},
    ["rbxassetid://17120012859"] = {name = "Praying Mantis", prices = {["default"] = 8.39, ["Ride"] = 36.65, ["Fly|Ride"] = 70.14, ["Neon"] = 155.66, ["Neon|Ride"] = 131.9, ["Neon|Fly|Ride"] = 301.02, ["Mega"] = 293.07, ["Mega|Ride"] = 351.75, ["Mega|Fly|Ride"] = 441}},
    ["rbxassetid://4440866528"] = {name = "Turkey", prices = {["default"] = 62.79, ["Ride"] = 81.84, ["Fly|Ride"] = 141.23, ["Neon|Ride"] = 379.34, ["Neon|Fly|Ride"] = 567.28, ["Mega"] = 2791.34, ["Mega|Fly|Ride"] = 3099.52}},
    ["rbxassetid://9287841987"] = {name = "Black Springer Spaniel", prices = {["default"] = 54.95, ["Ride"] = 56.52, ["Fly|Ride"] = 301.88, ["Neon"] = 131.25, ["Neon|Ride"] = 177.19, ["Neon|Fly|Ride"] = 310.31, ["Mega"] = 1955.09, ["Mega|Ride"] = 1117.8, ["Mega|Fly|Ride"] = 799.63}},
    ["rbxassetid://87613898139280"] = {name = "Ranger Beaver", prices = {["default"] = 13.11, ["Neon"] = 77.83, ["Neon|Ride"] = 167.48, ["Neon|Fly|Ride"] = 209.34, ["Mega"] = 308.77, ["Mega|Ride"] = 475.17, ["Mega|Fly|Ride"] = 558.91}},
    ["rbxassetid://88389663444803"] = {name = "Mirai Moth", prices = {["default"] = 104.68, ["Neon"] = 80.05, ["Neon|Ride"] = 356.81, ["Mega"] = 607.05, ["Mega|Ride"] = 941.97, ["Mega|Fly|Ride"] = 558.91}},
    ["rbxassetid://128469688002747"] = {name = "Moonlight Moth", prices = {["default"] = 26.25, ["Ride"] = 315, ["Neon"] = 65.63, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 525, ["Mega"] = 1050, ["Mega|Ride"] = 778.28, ["Mega|Fly|Ride"] = 929.75}},
    ["rbxassetid://13936753561"] = {name = "Dylan", prices = {["default"] = 14.47}},
    ["rbxassetid://10606175827"] = {name = "Koi Carp", prices = {["default"] = 4.24, ["Ride"] = 31.5, ["Fly|Ride"] = 105, ["Neon"] = 57.74, ["Neon|Fly"] = 183.75, ["Neon|Ride"] = 66.96, ["Neon|Fly|Ride"] = 493.49, ["Mega"] = 215.62, ["Mega|Ride"] = 216.57, ["Mega|Fly|Ride"] = 566.21}},
    ["rbxassetid://84529929751558"] = {name = "Old King Coal", prices = {["default"] = 6.56, ["Ride"] = 98.39, ["Neon"] = 27.57, ["Mega"] = 278.25}},
    ["rbxassetid://11706110842"] = {name = "Snowball Pet", prices = {["default"] = 63, ["Fly"] = 417.56, ["Ride"] = 68.14, ["Neon"] = 356.23, ["Neon|Ride"] = 223.99, ["Neon|Fly|Ride"] = 227.07, ["Mega"] = 925.32, ["Mega|Ride"] = 759.94, ["Mega|Fly|Ride"] = 910.58}},
    ["rbxassetid://6404812664"] = {name = "Ladybug", prices = {["default"] = 3.94, ["Fly"] = 23.55, ["Ride"] = 17.07, ["Fly|Ride"] = 41.89, ["Neon"] = 26.88, ["Neon|Fly"] = 60.8, ["Neon|Ride"] = 44.63, ["Neon|Fly|Ride"] = 83.75, ["Mega"] = 334.93, ["Mega|Fly"] = 236.55, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 241.5}},
    ["rbxassetid://95046891836017"] = {name = "Clover Cow", prices = {["default"] = 6.23, ["Fly"] = 83.74, ["Ride"] = 52.35, ["Fly|Ride"] = 698.01, ["Neon"] = 22.65, ["Neon|Ride"] = 62.77, ["Neon|Fly|Ride"] = 99.39, ["Mega"] = 310.31, ["Mega|Ride"] = 164.36, ["Mega|Fly|Ride"] = 267.75}},
    ["rbxassetid://123759251940984"] = {name = "Oakee Knight", prices = {["default"] = 2.1, ["Neon"] = 3.93, ["Neon|Ride"] = 198.75, ["Mega"] = 49.21, ["Mega|Ride"] = 203.44}},
    ["rbxassetid://9287842106"] = {name = "Brown Springer Spaniel", prices = {["default"] = 53.45, ["Ride"] = 140.25, ["Fly|Ride"] = 110.96, ["Neon"] = 174.57, ["Neon|Ride"] = 209.34, ["Mega"] = 1085.48, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 774.52}},
    ["rbxassetid://83890934284839"] = {name = "Zeopod", prices = {["default"] = 2.1, ["Neon"] = 11.53, ["Mega"] = 140.26}},
    ["rbxassetid://107096792267421"] = {name = "General Sheepdog", prices = {["default"] = 11.82, ["Neon|Ride"] = 157.5, ["Mega"] = 321.33, ["Mega|Ride"] = 464.88, ["Mega|Fly|Ride"] = 966.05}},
    ["rbxassetid://5721844511"] = {name = "Woolly Mammoth", prices = {["default"] = 2.1, ["Fly"] = 23.25, ["Ride"] = 17.36, ["Fly|Ride"] = 47.25, ["Neon"] = 24.07, ["Neon|Ride"] = 40.27, ["Neon|Fly|Ride"] = 131.25, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 91.88}},
    ["rbxassetid://8143039445"] = {name = "Summer Walrus", prices = {["default"] = 3.89, ["Fly"] = 52.5, ["Ride"] = 24.94, ["Fly|Ride"] = 49.88, ["Neon"] = 52.5, ["Neon|Ride"] = 125.62, ["Mega"] = 391.44, ["Mega|Ride"] = 405.05, ["Mega|Fly|Ride"] = 418.66}},
    ["rbxassetid://136696735147963"] = {name = "Chilling Spider", prices = {["default"] = 4.2, ["Ride"] = 139.47, ["Neon"] = 11.53, ["Neon|Ride"] = 111.57, ["Mega"] = 140.26, ["Mega|Ride"] = 620.62, ["Mega|Fly|Ride"] = 464.88}},
    ["rbxassetid://133768672320906"] = {name = "Catte", prices = {["default"] = 52.35, ["Ride"] = 143.07, ["Neon"] = 182.44, ["Mega"] = 1044.53, ["Mega|Ride"] = 1255.95, ["Mega|Fly|Ride"] = 954.19}},
    ["rbxassetid://12139319231"] = {name = "Feesh", prices = {["default"] = 25.67, ["Ride"] = 251.16, ["Neon"] = 210, ["Mega"] = 393.75, ["Mega|Ride"] = 563.07, ["Mega|Fly|Ride"] = 488.78}},
    ["rbxassetid://13685039170"] = {name = "Lobster", prices = {["default"] = 6.57, ["Ride"] = 105, ["Neon"] = 140.26, ["Mega"] = 525, ["Mega|Ride"] = 1559.25}},
    ["rbxassetid://87668315398037"] = {name = "Mecha R4BBIT", prices = {["default"] = 23.24, ["Ride"] = 91.88, ["Fly|Ride"] = 422.03, ["Neon"] = 91.88, ["Neon|Ride"] = 627.98, ["Neon|Fly|Ride"] = 573.57, ["Mega"] = 766.5, ["Mega|Ride"] = 922.08, ["Mega|Fly|Ride"] = 698.12}},
    ["rbxassetid://120262676323297"] = {name = "Kelp Hunter", prices = {["default"] = 3.72, ["Neon"] = 105, ["Mega"] = 837.31, ["Mega|Fly|Ride"] = 310.31}},
    ["rbxassetid://12403864254"] = {name = "Gorilla", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 28.26, ["Fly|Ride"] = 50.26, ["Neon"] = 18.86, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 43.32, ["Neon|Fly|Ride"] = 137.82, ["Mega"] = 92.98, ["Mega|Ride"] = 99.45, ["Mega|Fly|Ride"] = 258.56}},
    ["rbxassetid://124908510040897"] = {name = "Mistletroll", prices = {["default"] = 5.65, ["Ride"] = 288.65, ["Fly|Ride"] = 91.32, ["Neon"] = 32.53, ["Neon|Ride"] = 89.25, ["Neon|Fly|Ride"] = 164.07, ["Mega"] = 162.53, ["Mega|Ride"] = 487.74}},
    ["rbxassetid://11189235896"] = {name = "Persian Cat", prices = {["default"] = 2.1, ["Fly"] = 131.25, ["Ride"] = 20.97, ["Fly|Ride"] = 53.4, ["Neon"] = 4.99, ["Neon|Ride"] = 23.04, ["Neon|Fly|Ride"] = 90.03, ["Mega"] = 42.16, ["Mega|Fly"] = 116.23, ["Mega|Ride"] = 71.18, ["Mega|Fly|Ride"] = 146.54}},
    ["rbxassetid://14457148635"] = {name = "Magma Snail", prices = {["default"] = 2.1, ["Ride"] = 43.31, ["Fly|Ride"] = 98.4, ["Neon"] = 18.86, ["Neon|Ride"] = 109.27, ["Neon|Fly|Ride"] = 260.63, ["Mega"] = 154.92, ["Mega|Ride"] = 154.88}},
    ["rbxassetid://11694853423"] = {name = "Shetland Pony White", prices = {["default"] = 8.39, ["Ride"] = 19.69, ["Fly|Ride"] = 99.75, ["Neon"] = 81.65, ["Neon|Ride"] = 103.63, ["Neon|Fly|Ride"] = 315, ["Mega|Ride"] = 418.66, ["Mega|Fly|Ride"] = 975.47}},
    ["rbxassetid://4621220568"] = {name = "Rat", prices = {["default"] = 4.88, ["Ride"] = 23.63, ["Fly|Ride"] = 66.94, ["Neon"] = 27.57, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 105, ["Mega"] = 301.44, ["Mega|Ride"] = 208.69, ["Mega|Fly|Ride"] = 274.3}},
    ["rbxassetid://8938702150"] = {name = "Pine Marten", prices = {["default"] = 2.63, ["Ride"] = 24.4, ["Fly|Ride"] = 59.68, ["Neon"] = 23.24, ["Neon|Fly"] = 83.75, ["Neon|Ride"] = 26.25, ["Mega"] = 167.99, ["Mega|Ride"] = 141.16, ["Mega|Fly|Ride"] = 454.25}},
    ["rbxassetid://120359009390464"] = {name = "Turtle Doves", prices = {["default"] = 4.2, ["Fly"] = 301.88, ["Ride"] = 61.14, ["Neon"] = 23.63, ["Neon|Fly"] = 70.14, ["Neon|Ride"] = 140.43, ["Neon|Fly|Ride"] = 72.19, ["Mega"] = 90.61, ["Mega|Ride"] = 305.82, ["Mega|Fly|Ride"] = 362.61}},
    ["rbxassetid://71032455578324"] = {name = "Chihuahua", prices = {["default"] = 11.53, ["Ride"] = 91.88, ["Fly|Ride"] = 279.46, ["Neon"] = 75.99, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 349.58, ["Mega"] = 367.5, ["Mega|Fly"] = 977.55, ["Mega|Ride"] = 417.38, ["Mega|Fly|Ride"] = 616.88}},
    ["rbxassetid://11505487641"] = {name = "Ram", prices = {["default"] = 55.49, ["Ride"] = 102.2, ["Fly|Ride"] = 262.5, ["Neon"] = 249.38, ["Neon|Ride"] = 255.61, ["Neon|Fly|Ride"] = 337.02, ["Mega|Ride"] = 1063.13, ["Mega|Fly|Ride"] = 975.18}},
    ["rbxassetid://117821626163847"] = {name = "Chanekeh", prices = {["default"] = 2.1, ["Ride"] = 20.95, ["Fly|Ride"] = 65.63, ["Neon"] = 3.46, ["Neon|Ride"] = 37.73, ["Mega"] = 31.5, ["Mega|Ride"] = 71.14, ["Mega|Fly|Ride"] = 101.16}},
    ["rbxassetid://14266737982"] = {name = "Cassowary", prices = {["default"] = 8.17, ["Ride"] = 334.88, ["Neon"] = 357.96, ["Mega"] = 416.57, ["Mega|Fly|Ride"] = 1255.95}},
    ["rbxassetid://13693650831"] = {name = "Leopard Shark", prices = {["default"] = 55.13, ["Ride"] = 124.56, ["Neon"] = 304.5, ["Neon|Ride"] = 1116.75, ["Neon|Fly|Ride"] = 615.42, ["Mega"] = 1083.26, ["Mega|Ride"] = 1166.83, ["Mega|Fly|Ride"] = 1255.95}},
    ["rbxassetid://100909868233186"] = {name = "Kappakid", prices = {["default"] = 7.33, ["Fly"] = 190.32, ["Ride"] = 30.29, ["Fly|Ride"] = 126, ["Neon"] = 49.87, ["Neon|Ride"] = 65.63, ["Mega"] = 167.48, ["Mega|Ride"] = 150.73, ["Mega|Fly|Ride"] = 418.66}},
    ["rbxassetid://127061844219486"] = {name = "Patchy Bear", prices = {["default"] = 2.63, ["Fly"] = 157.5, ["Ride"] = 62.87, ["Fly|Ride"] = 84.53, ["Neon"] = 3.93, ["Neon|Ride"] = 27.5, ["Mega"] = 32.61, ["Mega|Ride"] = 40.69, ["Mega|Fly|Ride"] = 155.73}},
    ["rbxassetid://6998402749"] = {name = "Merhorse", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 19.85, ["Fly|Ride"] = 107.63, ["Neon|Fly"] = 418.66, ["Neon|Ride"] = 53.48, ["Neon|Fly|Ride"] = 98.44, ["Mega|Fly"] = 349.58, ["Mega|Ride"] = 103.69, ["Mega|Fly|Ride"] = 231}},
    ["rbxassetid://3181727196"] = {name = "Beaver", prices = {["default"] = 2.1, ["Fly"] = 23.04, ["Ride"] = 18.14, ["Neon"] = 3.93, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 47.25, ["Mega|Ride"] = 81.65, ["Mega|Fly|Ride"] = 146.54}},
    ["rbxassetid://10377935981"] = {name = "Badger", prices = {["default"] = 2.1, ["Ride"] = 27.57, ["Fly|Ride"] = 65.7, ["Neon"] = 5.25, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 112.01, ["Mega"] = 40.69, ["Mega|Fly"] = 168, ["Mega|Ride"] = 60.73, ["Mega|Fly|Ride"] = 167.99}},
    ["rbxassetid://118143096743818"] = {name = "Granny Wolf", prices = {["default"] = 2.1, ["Ride"] = 19.69, ["Neon"] = 2.63, ["Neon|Ride"] = 155.74, ["Mega"] = 22.32, ["Mega|Fly|Ride"] = 257.49}},
    ["rbxassetid://18819382634"] = {name = "Singularity Beetle", prices = {["default"] = 4.38, ["Ride"] = 157.5, ["Neon"] = 130.17, ["Neon|Ride"] = 315, ["Mega"] = 213.94, ["Mega|Ride"] = 309.82}},
    ["rbxassetid://13664716167"] = {name = "Ostrich", prices = {["default"] = 6.43, ["Ride"] = 210, ["Neon"] = 124.69, ["Neon|Ride"] = 98.4, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 347.82, ["Mega|Ride"] = 417.96, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://3710822879"] = {name = "Penguin", prices = {["default"] = 7.86, ["Fly"] = 20.95, ["Ride"] = 22.14, ["Fly|Ride"] = 45.94, ["Neon"] = 48.44, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 49.88, ["Neon|Fly|Ride"] = 82.69, ["Mega|Ride"] = 309.82, ["Mega|Fly|Ride"] = 416.57}},
    ["rbxassetid://12778628745"] = {name = "Chef Gorilla", prices = {["default"] = 79.98, ["Ride"] = 91.87, ["Fly|Ride"] = 262.5, ["Neon"] = 538.13}},
    ["rbxassetid://138841259551372"] = {name = "Vermilion Butterfly", prices = {["default"] = 20.93, ["Fly"] = 72.45, ["Ride"] = 65.63, ["Fly|Ride"] = 112, ["Neon"] = 98.4, ["Mega"] = 621.07, ["Mega|Fly"] = 642.64, ["Mega|Fly|Ride"] = 698.12}},
    ["rbxassetid://3181727125"] = {name = "Snow Puma", prices = {["default"] = 2.1, ["Fly"] = 17.93, ["Ride"] = 20.95, ["Fly|Ride"] = 52.35, ["Neon"] = 4.2, ["Neon|Fly"] = 36.04, ["Neon|Ride"] = 20.95, ["Neon|Fly|Ride"] = 142.96, ["Mega"] = 56.06, ["Mega|Ride"] = 106.77, ["Mega|Fly|Ride"] = 189}},
    ["rbxassetid://3181728160"] = {name = "Shiba Inu", prices = {["default"] = 2.1, ["Fly"] = 30.19, ["Ride"] = 18.38, ["Fly|Ride"] = 30.5, ["Neon"] = 3.86, ["Neon|Fly"] = 26.17, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 54.45, ["Mega"] = 36.75, ["Mega|Ride"] = 51.15, ["Mega|Fly|Ride"] = 91.07}},
    ["rbxassetid://3261465893"] = {name = "Blue Dog", prices = {["default"] = 305.82, ["Ride"] = 399, ["Fly|Ride"] = 648.92, ["Neon|Ride"] = 1443.75, ["Neon|Fly|Ride"] = 1996.32}},
    ["rbxassetid://15504846154"] = {name = "Eggnog Hare", prices = {["default"] = 27.23, ["Neon"] = 103.67, ["Mega"] = 405.05, ["Mega|Ride"] = 488.78, ["Mega|Fly|Ride"] = 974.42}},
    ["rbxassetid://4708551244"] = {name = "Dingo", prices = {["default"] = 2.1, ["Fly"] = 28.26, ["Ride"] = 16.76, ["Fly|Ride"] = 32.82, ["Neon"] = 4.25, ["Neon|Ride"] = 18.86, ["Neon|Fly|Ride"] = 112.01, ["Mega"] = 42, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 140.26}},
    ["rbxassetid://140434791311540"] = {name = "French Bulldog", prices = {["default"] = 68.08, ["Ride"] = 91.04, ["Fly|Ride"] = 279.46, ["Neon"] = 261.68, ["Neon|Ride"] = 288.74, ["Neon|Fly|Ride"] = 491.92, ["Mega"] = 737.63, ["Mega|Ride"] = 1048.95, ["Mega|Fly|Ride"] = 760.91}},
    ["rbxassetid://5067924710"] = {name = "Monkey", prices = {["default"] = 2.1, ["Ride"] = 20.9, ["Fly|Ride"] = 30.56, ["Neon"] = 11.69, ["Neon|Fly"] = 91.07, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 81.38, ["Mega"] = 86.63, ["Mega|Fly"] = 182.13, ["Mega|Ride"] = 164.82, ["Mega|Fly|Ride"] = 226.54}},
    ["rbxassetid://73677246948616"] = {name = "Black Tiger", prices = {["default"] = 2.1, ["Fly"] = 70.13, ["Ride"] = 98.39, ["Neon"] = 2.63, ["Neon|Ride"] = 44.63, ["Neon|Fly|Ride"] = 278.74, ["Mega"] = 16, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://17662893972"] = {name = "Pretty Pony", prices = {["default"] = 63.27, ["Fly"] = 140.51, ["Ride"] = 92.92, ["Fly|Ride"] = 194.69, ["Neon"] = 133.59, ["Neon|Ride"] = 314, ["Neon|Fly|Ride"] = 421.32, ["Mega"] = 894.88, ["Mega|Ride"] = 1097.92, ["Mega|Fly|Ride"] = 853.13}},
    ["rbxassetid://16722908853"] = {name = "Dotted Eggy", prices = {["default"] = 2.63, ["Ride"] = 19.9, ["Fly|Ride"] = 39.38, ["Neon"] = 7.88, ["Neon|Ride"] = 98.4, ["Neon|Fly|Ride"] = 209.34, ["Mega"] = 92.54, ["Mega|Ride"] = 98.4, ["Mega|Fly|Ride"] = 145.68}},
    ["rbxassetid://3409443896"] = {name = "Wild Boar", prices = {["default"] = 43.32, ["Ride"] = 82.04, ["Neon"] = 140.26, ["Neon|Ride"] = 279.46, ["Neon|Fly|Ride"] = 259.58, ["Mega|Ride"] = 1563.66, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://12432807176"] = {name = "Possum", prices = {["default"] = 4.2, ["Ride"] = 114.98, ["Neon"] = 32.74, ["Neon|Ride"] = 183.75, ["Mega"] = 147, ["Mega|Ride"] = 822.94}},
    ["rbxassetid://94550121082603"] = {name = "Lionfish", prices = {["default"] = 2.63, ["Ride"] = 103.37, ["Fly|Ride"] = 698.12, ["Neon"] = 12.48, ["Neon|Fly"] = 62.82, ["Neon|Ride"] = 171.94, ["Neon|Fly|Ride"] = 406.88, ["Mega"] = 77.88, ["Mega|Fly|Ride"] = 558.91}},
    ["rbxassetid://15096097714"] = {name = "Evil Rock", prices = {["default"] = 24.15, ["Ride"] = 48.66, ["Fly|Ride"] = 117.93, ["Neon|Ride"] = 210, ["Mega|Ride"] = 2789.22, ["Mega|Fly|Ride"] = 1074.89}},
    ["rbxassetid://117664495619345"] = {name = "Fire Foal", prices = {["default"] = 2.63, ["Fly"] = 131.62, ["Ride"] = 65.63, ["Neon"] = 7.8, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 46.5, ["Neon|Fly|Ride"] = 154.92, ["Mega"] = 54.7, ["Mega|Fly"] = 158.61, ["Mega|Ride"] = 155.74, ["Mega|Fly|Ride"] = 278.94}},
    ["rbxassetid://8938701683"] = {name = "Red Cardinal", prices = {["default"] = 2.1, ["Ride"] = 21.32, ["Fly|Ride"] = 72.19, ["Neon"] = 5.25, ["Neon|Fly"] = 41.88, ["Neon|Ride"] = 28.28, ["Neon|Fly|Ride"] = 91.88, ["Mega|Ride"] = 91.07, ["Mega|Fly|Ride"] = 286.79}},
    ["rbxassetid://12489700965"] = {name = "Tarsier", prices = {["default"] = 10.31, ["Ride"] = 50.24, ["Fly|Ride"] = 61.77, ["Neon"] = 63, ["Neon|Ride"] = 120.75, ["Mega"] = 332.84, ["Mega|Ride"] = 626.94, ["Mega|Fly|Ride"] = 377.99}},
    ["rbxassetid://11765322595"] = {name = "Gingerbread Reindeer", prices = {["default"] = 28.88, ["Ride"] = 103.69, ["Fly|Ride"] = 170.63, ["Neon"] = 118.13, ["Neon|Ride"] = 167.48, ["Neon|Fly|Ride"] = 263.83, ["Mega"] = 565.69, ["Mega|Ride"] = 698.12, ["Mega|Fly|Ride"] = 597.19}},
    ["rbxassetid://16382424275"] = {name = "Nautilus", prices = {["default"] = 139.39, ["Fly"] = 30.17, ["Ride"] = 35.44, ["Fly|Ride"] = 103.95, ["Neon"] = 103.67, ["Neon|Ride"] = 110.24, ["Neon|Fly|Ride"] = 222.89, ["Mega"] = 623.44, ["Mega|Ride"] = 475.17, ["Mega|Fly|Ride"] = 690.35}},
    ["rbxassetid://93997399823425"] = {name = "Chocolate Dutch Guinea Pig", prices = {["default"] = 57.75, ["Fly"] = 196.88, ["Ride"] = 93.18, ["Fly|Ride"] = 215.6, ["Neon"] = 288.75, ["Neon|Ride"] = 313.69, ["Neon|Fly|Ride"] = 315, ["Mega|Ride"] = 1027.38, ["Mega|Fly|Ride"] = 1158.62}},
    ["rbxassetid://75866760046580"] = {name = "Skelebat", prices = {["default"] = 3.72, ["Ride"] = 39.5, ["Fly|Ride"] = 262.5, ["Neon"] = 16.76, ["Neon|Ride"] = 140.26, ["Neon|Fly|Ride"] = 305.76, ["Mega"] = 139.48, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 349.58}},
    ["rbxassetid://111661922676557"] = {name = "Momma Moose", prices = {["default"] = 5.92, ["Ride"] = 28.26, ["Fly|Ride"] = 118.13, ["Neon"] = 18.38, ["Neon|Ride"] = 70.59, ["Mega"] = 154.11, ["Mega|Ride"] = 220.69, ["Mega|Fly|Ride"] = 308.77}},
    ["rbxassetid://17059860310"] = {name = "Elasmosaurus", prices = {["default"] = 12.66, ["Fly"] = 105, ["Ride"] = 78.98, ["Fly|Ride"] = 109.19, ["Neon"] = 78.75, ["Neon|Ride"] = 64.32, ["Neon|Fly|Ride"] = 167.48, ["Mega"] = 380.63, ["Mega|Fly|Ride"] = 479.07}},
    ["rbxassetid://10306934599"] = {name = "Camel", prices = {["default"] = 2.1, ["Fly"] = 15.74, ["Ride"] = 15.7, ["Fly|Ride"] = 98.39, ["Neon"] = 2.1, ["Neon|Fly"] = 17.07, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 41.79, ["Mega"] = 15.74, ["Mega|Fly"] = 77.88, ["Mega|Ride"] = 56.54, ["Mega|Fly|Ride"] = 118.13}},
    ["rbxassetid://13104107016"] = {name = "Puffer Fish", prices = {["default"] = 44.63, ["Fly"] = 220.5, ["Ride"] = 125.58, ["Neon"] = 485.64, ["Neon|Fly"] = 2372.69, ["Neon|Ride"] = 464.88, ["Mega|Fly"] = 956.63, ["Mega|Ride"] = 929.75, ["Mega|Fly|Ride"] = 965.78}},
    ["rbxassetid://17183022910"] = {name = "Mole", prices = {["default"] = 2.1, ["Ride"] = 25.56, ["Neon"] = 3.92, ["Neon|Ride"] = 42.2, ["Mega"] = 106.77, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://5721844051"] = {name = "Stegosaurus", prices = {["default"] = 2.1, ["Fly"] = 28.25, ["Ride"] = 22.32, ["Fly|Ride"] = 132.3, ["Neon"] = 13.11, ["Neon|Ride"] = 20.96, ["Mega|Ride"] = 279.46, ["Mega|Fly|Ride"] = 246.65}},
    ["rbxassetid://114921997566126"] = {name = "S'mores Raccoon", prices = {["default"] = 98.44, ["Fly"] = 209.32, ["Ride"] = 140.25, ["Fly|Ride"] = 188.76, ["Neon"] = 304.5, ["Neon|Ride"] = 326.82, ["Neon|Fly|Ride"] = 627.98, ["Mega"] = 1155, ["Mega|Ride"] = 917.44, ["Mega|Fly|Ride"] = 1010.63}},
    ["rbxassetid://93038040448121"] = {name = "Nurse Shark", prices = {["default"] = 2.2, ["Ride"] = 42.4, ["Neon"] = 7.34, ["Neon|Ride"] = 1396.21, ["Neon|Fly|Ride"] = 105.77, ["Mega"] = 51.14, ["Mega|Ride"] = 109.27, ["Mega|Fly|Ride"] = 277.77}},
    ["rbxassetid://13936750528"] = {name = "River", prices = {["default"] = 11.8}},
    ["rbxassetid://103142927308458"] = {name = "Black-Footed Ferret", prices = {["default"] = 2.1, ["Ride"] = 28.88, ["Fly|Ride"] = 105, ["Neon"] = 6.57, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 39.38, ["Mega|Ride"] = 115.5, ["Mega|Fly|Ride"] = 194.69}},
    ["rbxassetid://3199974219"] = {name = "Pet Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13803784751"] = {name = "Happy Clam", prices = {["default"] = 118.13, ["Ride"] = 186.3, ["Fly|Ride"] = 449.5, ["Neon"] = 652.05, ["Neon|Ride"] = 556.81, ["Neon|Fly|Ride"] = 735, ["Mega|Fly|Ride"] = 2407.23}},
    ["rbxassetid://13665210525"] = {name = "Warthog", prices = {["default"] = 5.24, ["Ride"] = 42, ["Neon"] = 56.54, ["Neon|Ride"] = 61.69, ["Mega"] = 237.11}},
    ["rbxassetid://18515939072"] = {name = "Black Marlin", prices = {["default"] = 2.1, ["Fly"] = 209.32, ["Neon"] = 3.93, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 45.42}},
    ["rbxassetid://16075008092"] = {name = "Fanghorn Tortoise", prices = {["default"] = 7.87, ["Ride"] = 35.44, ["Neon"] = 51.19, ["Neon|Ride"] = 112.88, ["Mega"] = 388.31, ["Mega|Ride"] = 558.91, ["Mega|Fly|Ride"] = 620.62}},
    ["rbxassetid://8566684181"] = {name = "Giant Black Scarab", prices = {["default"] = 11.81, ["Fly"] = 74.32, ["Ride"] = 28.26, ["Fly|Ride"] = 157.5, ["Neon"] = 83.75, ["Neon|Ride"] = 73.28, ["Neon|Fly|Ride"] = 278.41, ["Mega|Ride"] = 392.44, ["Mega|Fly|Ride"] = 656.23}},
    ["rbxassetid://118691035196137"] = {name = "Shiver Wolf", prices = {["default"] = 31.5, ["Ride"] = 70.13, ["Fly|Ride"] = 278.41, ["Neon"] = 187.37, ["Neon|Ride"] = 279.46, ["Neon|Fly|Ride"] = 472.03, ["Mega"] = 627.98, ["Mega|Fly|Ride"] = 528.24}},
    ["rbxassetid://3743735223"] = {name = "Brown Bear", prices = {["default"] = 97.05, ["Fly"] = 158.27, ["Ride"] = 157.07, ["Fly|Ride"] = 336.78, ["Neon"] = 550.53, ["Neon|Ride"] = 546, ["Neon|Fly|Ride"] = 589.32, ["Mega|Fly|Ride"] = 3049.86}},
    ["rbxassetid://3934251801"] = {name = "Sloth", prices = {["default"] = 9.98, ["Fly"] = 23.63, ["Ride"] = 21, ["Fly|Ride"] = 40.69, ["Neon"] = 42, ["Neon|Ride"] = 41.89, ["Neon|Fly|Ride"] = 91.87, ["Mega|Fly|Ride"] = 288.88}},
    ["rbxassetid://12139338880"] = {name = "Frogspawn", prices = {["default"] = 9.08, ["Fly"] = 131.23, ["Ride"] = 18.95, ["Fly|Ride"] = 131.25, ["Neon"] = 9.4, ["Neon|Ride"] = 43.32, ["Neon|Fly|Ride"] = 262.71, ["Mega"] = 188.41, ["Mega|Fly|Ride"] = 421.32}},
    ["rbxassetid://8070926551"] = {name = "Snow Leopard", prices = {["default"] = 9.85, ["Fly"] = 232.26, ["Ride"] = 55.43, ["Neon"] = 95.82, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 351.93, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 503.62}},
    ["rbxassetid://76712147705770"] = {name = "Tuxedo Cat", prices = {["default"] = 44.63, ["Ride"] = 78.75, ["Fly|Ride"] = 112, ["Neon"] = 209.34, ["Neon|Ride"] = 228.18, ["Neon|Fly|Ride"] = 156.53, ["Mega"] = 949.3, ["Mega|Ride"] = 907.44, ["Mega|Fly|Ride"] = 749.12}},
    ["rbxassetid://15685468962"] = {name = "Tasmanian Devil", prices = {["default"] = 19.67, ["Ride"] = 80.07, ["Neon"] = 182.13, ["Mega"] = 572.51, ["Mega|Fly|Ride"] = 810.1}},
    ["rbxassetid://123288277753363"] = {name = "Tri-horned Treehopper", prices = {["default"] = 262.5, ["Ride"] = 413.44, ["Neon"] = 2372.69, ["Neon|Ride"] = 1181.25, ["Neon|Fly|Ride"] = 1465.28, ["Mega|Fly|Ride"] = 4068.21}},
    ["rbxassetid://6060987821"] = {name = "Yeti", prices = {["default"] = 23.63, ["Ride"] = 40.69, ["Fly|Ride"] = 116.16, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 443.98, ["Mega|Ride"] = 770.33, ["Mega|Fly|Ride"] = 749.1}},
    ["rbxassetid://9549841158"] = {name = "Zebra", prices = {["default"] = 2.1, ["Fly"] = 17.4, ["Ride"] = 17.07, ["Neon"] = 2.63, ["Neon|Ride"] = 18.86, ["Neon|Fly|Ride"] = 55.13, ["Mega"] = 18.38, ["Mega|Fly"] = 98.4, ["Mega|Ride"] = 50.26, ["Mega|Fly|Ride"] = 108.94}},
    ["rbxassetid://13883282884"] = {name = "Hermit Crab", prices = {["default"] = 6.55, ["Ride"] = 211.02, ["Neon"] = 16.76, ["Neon|Ride"] = 39.38, ["Mega"] = 132.78, ["Mega|Ride"] = 261.68}},
    ["rbxassetid://92626539723202"] = {name = "Sea Angel", prices = {["default"] = 2.63, ["Ride"] = 39.37, ["Neon"] = 21.06, ["Neon|Ride"] = 92.98, ["Neon|Fly|Ride"] = 1181.25, ["Mega"] = 154.92, ["Mega|Fly"] = 223.99, ["Mega|Ride"] = 278.41, ["Mega|Fly|Ride"] = 342.57}},
    ["rbxassetid://15848329383"] = {name = "Jellyfish", prices = {["default"] = 454.25, ["Ride"] = 419.99, ["Fly|Ride"] = 544.25, ["Neon"] = 1392.01, ["Neon|Ride"] = 1704.91, ["Mega|Fly|Ride"] = 5034.75}},
    ["rbxassetid://5721843846"] = {name = "Sabertooth", prices = {["default"] = 5.25, ["Fly"] = 39.38, ["Ride"] = 15.58, ["Fly|Ride"] = 42.2, ["Neon"] = 13.13, ["Neon|Ride"] = 28.28, ["Neon|Fly|Ride"] = 94.21, ["Mega|Ride"] = 196.88}},
    ["rbxassetid://9475753090"] = {name = "Albatross", prices = {["default"] = 6.57, ["Fly"] = 31.39, ["Ride"] = 20.98, ["Fly|Ride"] = 59.07, ["Neon|Ride"] = 56.54, ["Neon|Fly|Ride"] = 208.29, ["Mega|Ride"] = 698.12, ["Mega|Fly|Ride"] = 224.44}},
    ["rbxassetid://96894173636082"] = {name = "Clementine Owl", prices = {["default"] = 5.25, ["Fly"] = 26.24, ["Ride"] = 28.33, ["Neon"] = 19.69, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 123.38, ["Mega"] = 126.18, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 1859.49}},
    ["rbxassetid://10318105683"] = {name = "Orange Butterfly", prices = {["default"] = 38.07, ["Fly"] = 210, ["Ride"] = 57.75, ["Fly|Ride"] = 65.63, ["Neon"] = 464.6, ["Neon|Ride"] = 251.21, ["Mega"] = 459.38, ["Mega|Ride"] = 837.31, ["Mega|Fly|Ride"] = 627.98}},
    ["rbxassetid://15937689999"] = {name = "Rattlesnake", prices = {["default"] = 2.63, ["Fly"] = 62.74, ["Ride"] = 28.26, ["Neon"] = 19.04, ["Neon|Ride"] = 114.19, ["Neon|Fly|Ride"] = 210, ["Mega"] = 137.82, ["Mega|Ride"] = 139.48, ["Mega|Fly|Ride"] = 308.77}},
    ["rbxassetid://10971808447"] = {name = "Evil Basilisk", prices = {["default"] = 52.5, ["Fly"] = 104.15, ["Ride"] = 24.94, ["Fly|Ride"] = 78.75, ["Neon"] = 310.13, ["Mega"] = 698.12, ["Mega|Ride"] = 321.33, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://99104623628550"] = {name = "Snorgle", prices = {["default"] = 2.1, ["Ride"] = 35.6, ["Fly|Ride"] = 49.21, ["Neon"] = 6.3, ["Neon|Ride"] = 40.85, ["Mega"] = 73.23, ["Mega|Ride"] = 46.5, ["Mega|Fly|Ride"] = 310.31}},
    ["rbxassetid://136705425555561"] = {name = "Emperor Shrimp", prices = {["default"] = 9.18, ["Ride"] = 69.57, ["Neon"] = 62.74, ["Mega"] = 315}},
    ["rbxassetid://14398819258"] = {name = "Longhorn Cow", prices = {["default"] = 918.75, ["Neon|Ride"] = 69.09, ["Mega"] = 263.76, ["Mega|Ride"] = 371.9, ["Mega|Fly|Ride"] = 485.63}},
    ["rbxassetid://4708551284"] = {name = "Koala", prices = {["default"] = 11.17, ["Fly"] = 26.25, ["Ride"] = 24.94, ["Fly|Ride"] = 61.69, ["Neon"] = 59.64, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 49.88, ["Neon|Fly|Ride"] = 128.76, ["Mega"] = 405.05, ["Mega|Ride"] = 369.59, ["Mega|Fly|Ride"] = 409.5}},
    ["rbxassetid://4115249264"] = {name = "Zombie Buffalo", prices = {["default"] = 208.27, ["Fly"] = 502.32, ["Ride"] = 205.09, ["Fly|Ride"] = 470.99, ["Neon"] = 1575, ["Neon|Ride"] = 914.64, ["Neon|Fly|Ride"] = 971.25, ["Mega|Fly|Ride"] = 6111.2}},
    ["rbxassetid://8939633862"] = {name = "Salamander", prices = {["default"] = 3.42, ["Fly"] = 32.46, ["Ride"] = 15.74, ["Fly|Ride"] = 45.94, ["Neon"] = 19.9, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 140.26, ["Mega"] = 244.93, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://7734902431"] = {name = "Halloween White Mummy Cat", prices = {["default"] = 2.1, ["Ride"] = 98.06, ["Fly|Ride"] = 103.66, ["Neon"] = 15.74, ["Neon|Ride"] = 50.26, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 150.94, ["Mega|Ride"] = 418.66, ["Mega|Fly|Ride"] = 425.25}},
    ["rbxassetid://115869632070663"] = {name = "Snowball Pug", prices = {["default"] = 42, ["Ride"] = 167.46, ["Fly|Ride"] = 526.84, ["Neon"] = 114.38, ["Neon|Ride"] = 251.21, ["Neon|Fly|Ride"] = 418.66, ["Mega"] = 328.13, ["Mega|Ride"] = 418.66, ["Mega|Fly|Ride"] = 497.44}},
    ["rbxassetid://8077189379"] = {name = "Husky", prices = {["default"] = 54.87, ["Ride"] = 114.63, ["Fly|Ride"] = 230.62, ["Neon"] = 463.32, ["Neon|Ride"] = 459.38, ["Neon|Fly|Ride"] = 488.78, ["Mega|Ride"] = 1912.18, ["Mega|Fly|Ride"] = 1375.26}},
    ["rbxassetid://98003529163435"] = {name = "Maine Coon", prices = {["default"] = 40.69, ["Ride"] = 118.28, ["Fly|Ride"] = 223.13, ["Neon"] = 82.69, ["Neon|Ride"] = 209.34, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 308.77, ["Mega|Ride"] = 318.93, ["Mega|Fly|Ride"] = 450.19}},
    ["rbxassetid://12488273089"] = {name = "Yellow-lipped Sea Krait", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 19.69, ["Fly|Ride"] = 58.97, ["Neon"] = 15.72, ["Mega"] = 124.37, ["Mega|Ride"] = 182.13, ["Mega|Fly|Ride"] = 349.58}},
    ["rbxassetid://96760582519875"] = {name = "Cozy Mistletroll", prices = {["default"] = 31.2, ["Ride"] = 83.74, ["Neon"] = 43.32, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 140.26, ["Mega"] = 208.29, ["Mega|Ride"] = 186.32, ["Mega|Fly|Ride"] = 294.66}},
    ["rbxassetid://85229142142232"] = {name = "Bunny Swirl", prices = {["default"] = 69.57, ["Ride"] = 112, ["Fly|Ride"] = 221.82, ["Neon"] = 203.44, ["Neon|Ride"] = 193.15, ["Neon|Fly|Ride"] = 443.78, ["Mega"] = 620.62, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 557.82}},
    ["rbxassetid://121192022038625"] = {name = "Stygian Owl", prices = {["default"] = 2.63, ["Neon"] = 9.19, ["Neon|Ride"] = 104.76, ["Mega"] = 52.5, ["Mega|Ride"] = 140.26, ["Mega|Fly|Ride"] = 310.31}},
    ["rbxassetid://83732262844708"] = {name = "Pain au Chat", prices = {["default"] = 15.7, ["Neon"] = 78.75, ["Mega"] = 514.8, ["Mega|Ride"] = 416.57, ["Mega|Fly|Ride"] = 697.32}},
    ["rbxassetid://12792506715"] = {name = "Goose", prices = {["default"] = 997.49, ["Fly"] = 1342.65, ["Ride"] = 983.07, ["Fly|Ride"] = 1049.99, ["Neon"] = 3321.97, ["Neon|Ride"] = 3347.09, ["Neon|Fly|Ride"] = 3342.9, ["Mega|Fly|Ride"] = 10889}},
    ["rbxassetid://12779257292"] = {name = "Pudding Cat", prices = {["default"] = 36.74, ["Ride"] = 155.63, ["Fly|Ride"] = 210, ["Neon"] = 146.54, ["Neon|Ride"] = 531.57, ["Mega"] = 614.37, ["Mega|Ride"] = 676.12, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://83376259738301"] = {name = "Mrs. Whiskerpips", prices = {["default"] = 6.57, ["Fly"] = 41.51, ["Ride"] = 31.4, ["Fly|Ride"] = 5233.09, ["Neon"] = 21.11, ["Neon|Fly"] = 30.19, ["Neon|Ride"] = 56.54, ["Neon|Fly|Ride"] = 140.26, ["Mega"] = 83.75, ["Mega|Ride"] = 145.49, ["Mega|Fly|Ride"] = 219.19}},
    ["rbxassetid://110894046614323"] = {name = "Partridge", prices = {["default"] = 12.69, ["Ride"] = 131.22, ["Neon"] = 139.39, ["Mega"] = 363.19, ["Mega|Ride"] = 406.8, ["Mega|Fly|Ride"] = 775.19}},
    ["rbxassetid://114034119324343"] = {name = "Muskrat", prices = {["default"] = 2.1, ["Neon"] = 2.63, ["Neon|Ride"] = 36.88, ["Neon|Fly|Ride"] = 129.02, ["Mega"] = 18.34, ["Mega|Ride"] = 63, ["Mega|Fly|Ride"] = 140.26}},
    ["rbxassetid://15547904644"] = {name = "Harp Seal", prices = {["default"] = 95.82, ["Ride"] = 204.35, ["Neon"] = 334.69, ["Neon|Ride"] = 353.07, ["Neon|Fly|Ride"] = 488.78, ["Mega"] = 2093.24, ["Mega|Ride"] = 1023.44, ["Mega|Fly|Ride"] = 1023.74}},
    ["rbxassetid://14978702254"] = {name = "Scarecrow Cat", prices = {["default"] = 5.28, ["Ride"] = 94.07, ["Fly|Ride"] = 812.88, ["Neon"] = 28.25, ["Neon|Ride"] = 83.75, ["Mega"] = 347.49, ["Mega|Ride"] = 262.71, ["Mega|Fly|Ride"] = 418.66}},
    ["rbxassetid://95871612352029"] = {name = "Cold Cube", prices = {["default"] = 3.93, ["Ride"] = 32.82, ["Neon"] = 13.13, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 140.26, ["Mega"] = 147, ["Mega|Ride"] = 248.72, ["Mega|Fly|Ride"] = 378.89}},
    ["rbxassetid://114456035353449"] = {name = "Bauble Buddies", prices = {["default"] = 65.63, ["Fly"] = 105.94, ["Ride"] = 99.75, ["Fly|Ride"] = 202.08, ["Neon"] = 187.67, ["Neon|Ride"] = 488.78, ["Neon|Fly|Ride"] = 452.16, ["Mega"] = 418.66, ["Mega|Ride"] = 575.29, ["Mega|Fly|Ride"] = 505.32}},
    ["rbxassetid://15383967605"] = {name = "Gingerbread Mouse", prices = {["default"] = 15.64, ["Ride"] = 155.63, ["Neon"] = 115.5, ["Neon|Ride"] = 138.17, ["Neon|Fly|Ride"] = 315, ["Mega"] = 612.25, ["Mega|Ride"] = 405.05, ["Mega|Fly|Ride"] = 1090.46}},
    ["rbxassetid://11767069383"] = {name = "Woolly Rhino", prices = {["default"] = 57.75, ["Ride"] = 140.25, ["Neon|Fly|Ride"] = 1300.95, ["Mega|Ride"] = 1814.85, ["Mega|Fly|Ride"] = 1936.25}},
    ["rbxassetid://95133623103638"] = {name = "Samoyed", prices = {["default"] = 11.82, ["Neon"] = 28.88, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 91.68, ["Mega|Ride"] = 131.24, ["Mega|Fly|Ride"] = 259.58}},
    ["rbxassetid://8071236757"] = {name = "St Bernard", prices = {["default"] = 8.28, ["Ride"] = 31.37, ["Fly|Ride"] = 53.38, ["Neon"] = 77.83, ["Neon|Ride"] = 98.4, ["Neon|Fly|Ride"] = 280.88, ["Mega"] = 398.99, ["Mega|Ride"] = 392.44}},
    ["rbxassetid://14276930615"] = {name = "Alley Cat", prices = {["default"] = 114.85, ["Ride"] = 161.18, ["Fly|Ride"] = 223.13, ["Neon"] = 569.63, ["Neon|Ride"] = 532.85, ["Neon|Fly|Ride"] = 656.23, ["Mega|Ride"] = 2415, ["Mega|Fly|Ride"] = 1955.09}},
    ["rbxassetid://6498256417"] = {name = "Dolphin", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 18.62, ["Fly|Ride"] = 44.63, ["Neon"] = 13.02, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 24.44, ["Neon|Fly|Ride"] = 87.94, ["Mega|Ride"] = 136.39, ["Mega|Fly|Ride"] = 203.44}},
    ["rbxassetid://7734900468"] = {name = "Halloween White Skeleton Dog", prices = {["default"] = 5.25, ["Fly"] = 87.94, ["Ride"] = 24.94, ["Fly|Ride"] = 84, ["Neon"] = 21, ["Neon|Ride"] = 45.93, ["Neon|Fly|Ride"] = 138.17, ["Mega"] = 220.5, ["Mega|Ride"] = 191.68, ["Mega|Fly|Ride"] = 346.44}},
    ["rbxassetid://9982202041"] = {name = "Poodle", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 18.84, ["Fly|Ride"] = 35.95, ["Neon"] = 2.05, ["Neon|Fly"] = 35.6, ["Neon|Ride"] = 17.12, ["Neon|Fly|Ride"] = 47.66, ["Mega"] = 15.75, ["Mega|Ride"] = 31.39, ["Mega|Fly|Ride"] = 138.17}},
    ["rbxassetid://73671766703168"] = {name = "Pilot Gull", prices = {["default"] = 2.1, ["Ride"] = 31.4, ["Neon"] = 3.94, ["Neon|Fly"] = 41.89, ["Mega"] = 24.22, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 138.8}},
    ["rbxassetid://14146127209"] = {name = "Indian Leopard", prices = {["default"] = 3.82, ["Fly"] = 131.24, ["Ride"] = 71.18, ["Fly|Ride"] = 488.78, ["Neon"] = 22.32, ["Neon|Ride"] = 92.98, ["Mega"] = 155.74, ["Mega|Ride"] = 207.24}},
    ["rbxassetid://113558592714438"] = {name = "Seabed Creeper", prices = {["default"] = 48.28, ["Ride"] = 315, ["Neon"] = 228.18, ["Neon|Ride"] = 735, ["Neon|Fly|Ride"] = 630, ["Mega|Ride"] = 555.77, ["Mega|Fly|Ride"] = 526.46}},
    ["rbxassetid://4281674713"] = {name = "Bee", prices = {["default"] = 2.63, ["Fly"] = 23.63, ["Ride"] = 23.63, ["Fly|Ride"] = 35.89, ["Neon"] = 15.75, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 26.13, ["Neon|Fly|Ride"] = 69.09, ["Mega"] = 144.13, ["Mega|Fly"] = 238.88, ["Mega|Ride"] = 122.07, ["Mega|Fly|Ride"] = 207.24}},
    ["rbxassetid://5862774392"] = {name = "Bat", prices = {["default"] = 2.1, ["Fly"] = 105, ["Ride"] = 19.69, ["Fly|Ride"] = 49.87, ["Neon"] = 18.36, ["Neon|Fly"] = 52.49, ["Neon|Ride"] = 27.2, ["Neon|Fly|Ride"] = 67.01, ["Mega"] = 136.07, ["Mega|Fly"] = 279.46, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://18223359092"] = {name = "Birthday Butterfly 2024", prices = {["default"] = 2.1, ["Fly"] = 21, ["Ride"] = 19.69, ["Fly|Ride"] = 78.75, ["Neon"] = 15.72, ["Neon|Fly"] = 98.44, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 140.26, ["Mega"] = 50.34, ["Mega|Fly"] = 125.62, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://17822765706"] = {name = "Pink Betta Fish", prices = {["default"] = 13.13, ["Ride"] = 26.17, ["Neon"] = 46.48, ["Neon|Fly|Ride"] = 837.31, ["Mega"] = 246.48, ["Mega|Ride"] = 238.65, ["Mega|Fly|Ride"] = 620.62}},
    ["rbxassetid://14146174264"] = {name = "Rock Pigeon", prices = {["default"] = 13.02, ["Neon"] = 45.1, ["Neon|Ride"] = 85.32, ["Neon|Fly|Ride"] = 279.46, ["Mega|Ride"] = 420}},
    ["rbxassetid://11758575946"] = {name = "Water Moon Bear", prices = {["default"] = 3.71, ["Fly"] = 35.44, ["Ride"] = 26.24, ["Fly|Ride"] = 54.6, ["Neon"] = 26.23, ["Neon|Ride"] = 46.99, ["Mega"] = 173.78, ["Mega|Ride"] = 284.06}},
    ["rbxassetid://6498256132"] = {name = "Seahorse", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 16.86, ["Fly|Ride"] = 41.88, ["Neon"] = 13.84, ["Neon|Ride"] = 50.26, ["Neon|Fly|Ride"] = 70.88, ["Mega"] = 150.94, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 161.2}},
    ["rbxassetid://13664973582"] = {name = "Many Mackerel", prices = {["default"] = 204.75, ["Fly"] = 393.75, ["Ride"] = 210, ["Neon"] = 930.46, ["Neon|Ride"] = 1955.09, ["Neon|Fly|Ride"] = 1255.95, ["Mega"] = 3490.48, ["Mega|Fly|Ride"] = 3642.24}},
    ["rbxassetid://114806716799554"] = {name = "Ringmaster Gibbon", prices = {["default"] = 5.86, ["Ride"] = 39.38, ["Neon"] = 21, ["Mega"] = 123.38, ["Mega|Ride"] = 209.77, ["Mega|Fly|Ride"] = 488.78}},
    ["rbxassetid://14360917588"] = {name = "Magma Moose", prices = {["default"] = 5.39, ["Ride"] = 24.09, ["Fly|Ride"] = 104.99, ["Neon"] = 26.25, ["Neon|Ride"] = 48.17, ["Neon|Fly|Ride"] = 139.65, ["Mega"] = 203.44, ["Mega|Ride"] = 459.38}},
    ["rbxassetid://18957942216"] = {name = "Starhopper", prices = {["default"] = 3.89, ["Neon"] = 40.68, ["Mega"] = 859.69, ["Mega|Ride"] = 409.24}},
    ["rbxassetid://3181727071"] = {name = "Puma", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 17.07, ["Fly|Ride"] = 33.87, ["Neon"] = 2.63, ["Neon|Fly"] = 21, ["Neon|Ride"] = 24.09, ["Neon|Fly|Ride"] = 35.44, ["Mega"] = 28.28, ["Mega|Fly"] = 70.14, ["Mega|Ride"] = 33.51, ["Mega|Fly|Ride"] = 74.33}},
    ["rbxassetid://4841039508"] = {name = "Rock", prices = {["default"] = 2.63, ["Fly"] = 56.47, ["Ride"] = 25.35, ["Fly|Ride"] = 56.44, ["Neon"] = 19, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 26.17, ["Neon|Fly|Ride"] = 72.19, ["Mega"] = 131.25, ["Mega|Ride"] = 140.76, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://94235745630523"] = {name = "Rainbow Trout", prices = {["default"] = 3.42, ["Ride"] = 33.51, ["Neon"] = 12.5, ["Neon|Ride"] = 140.44, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 68.25, ["Mega|Ride"] = 140.26}},
    ["rbxassetid://4440867249"] = {name = "Llama", prices = {["default"] = 76.13, ["Ride"] = 85.32, ["Fly|Ride"] = 260.6, ["Neon"] = 660.42, ["Neon|Ride"] = 393.74, ["Neon|Fly|Ride"] = 768.24, ["Mega|Ride"] = 3490.48, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://11571113805"] = {name = "Bloodhound", prices = {["default"] = 6.27, ["Fly"] = 85.32, ["Fly|Ride"] = 140.26, ["Neon"] = 22.98, ["Neon|Ride"] = 81.65, ["Neon|Fly|Ride"] = 310.31, ["Mega"] = 209.69, ["Mega|Fly|Ride"] = 232.45}},
    ["rbxassetid://78423968285099"] = {name = "Wren", prices = {["default"] = 2.63, ["Ride"] = 52.5, ["Fly|Ride"] = 154.9, ["Neon"] = 5.8, ["Neon|Ride"] = 125.62, ["Neon|Fly|Ride"] = 167.48, ["Mega"] = 66.94, ["Mega|Ride"] = 94.21, ["Mega|Fly|Ride"] = 237.6}},
    ["rbxassetid://110871792705214"] = {name = "Burger Bear", prices = {["default"] = 55.13, ["Fly"] = 124.69, ["Ride"] = 92.92, ["Fly|Ride"] = 299.25, ["Neon"] = 182.13, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 330.75, ["Mega"] = 717.98, ["Mega|Ride"] = 698.12, ["Mega|Fly|Ride"] = 768.24}},
    ["rbxassetid://3181727637"] = {name = "Fennec Fox", prices = {["default"] = 2.1, ["Ride"] = 16.76, ["Fly|Ride"] = 58.59, ["Neon"] = 2.1, ["Neon|Fly"] = 38.07, ["Neon|Ride"] = 17.07, ["Neon|Fly|Ride"] = 36.75, ["Mega"] = 19.46, ["Mega|Fly"] = 48.83, ["Mega|Ride"] = 41.89, ["Mega|Fly|Ride"] = 81.65}},
    ["rbxassetid://115530716039589"] = {name = "Milk Choccybunny", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 2.63, ["Neon|Ride"] = 41.89, ["Neon|Fly|Ride"] = 96.31, ["Mega"] = 26.25, ["Mega|Ride"] = 90.56, ["Mega|Fly|Ride"] = 168}},
    ["rbxassetid://83001092186817"] = {name = "White Choccybunny", prices = {["default"] = 3.92, ["Neon"] = 10.49, ["Neon|Ride"] = 54.03, ["Neon|Fly|Ride"] = 192.94, ["Mega"] = 56.39, ["Mega|Ride"] = 140.26, ["Mega|Fly|Ride"] = 301.44}},
    ["rbxassetid://103795616446776"] = {name = "Waffle Wyrm", prices = {["default"] = 6.57, ["Fly"] = 73.01, ["Ride"] = 56.52, ["Fly|Ride"] = 161.2, ["Neon"] = 32.82, ["Neon|Fly"] = 56.54, ["Neon|Ride"] = 77.42, ["Neon|Fly|Ride"] = 191.55, ["Mega"] = 147.46, ["Mega|Ride"] = 119.7, ["Mega|Fly|Ride"] = 279.46}},
    ["rbxassetid://9982358951"] = {name = "Orangutan", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 17.07, ["Fly|Ride"] = 34.13, ["Neon"] = 2.63, ["Neon|Ride"] = 35.18, ["Neon|Fly|Ride"] = 70.14, ["Mega"] = 19.65, ["Mega|Ride"] = 56.54, ["Mega|Fly|Ride"] = 103.69}},
    ["rbxassetid://129021417712364"] = {name = "Kage Crow", prices = {["default"] = 11.82, ["Ride"] = 41.88, ["Fly|Ride"] = 198.87, ["Neon"] = 60.41, ["Neon|Fly|Ride"] = 279.46, ["Mega"] = 237.6, ["Mega|Ride"] = 497.43, ["Mega|Fly|Ride"] = 283.5}},
    ["rbxassetid://4849941238"] = {name = "Hedgehog", prices = {["default"] = 3937.5, ["Fly"] = 3150, ["Ride"] = 2959.69, ["Fly|Ride"] = 2690.63, ["Neon|Fly|Ride"] = 12718}},
    ["rbxassetid://4800190144"] = {name = "Ginger Cat", prices = {["default"] = 2.1, ["Ride"] = 23.04, ["Fly|Ride"] = 39.87, ["Neon"] = 9.19, ["Neon|Ride"] = 31.42, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 78.75, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 160.39}},
    ["rbxassetid://18119333909"] = {name = "Rodeo Bull", prices = {["default"] = 5.25, ["Neon"] = 13.13, ["Mega"] = 126}},
    ["rbxassetid://11837080223"] = {name = "Highland Cow", prices = {["default"] = 24.93, ["Ride"] = 94.5, ["Fly|Ride"] = 157.49, ["Neon"] = 119.34, ["Neon|Ride"] = 209.34, ["Neon|Fly|Ride"] = 141.39, ["Mega|Fly|Ride"] = 509.72}},
    ["rbxassetid://14398816006"] = {name = "Rooster", prices = {["default"] = 42.21, ["Ride"] = 78.75, ["Neon"] = 203.06, ["Neon|Ride"] = 370.52, ["Mega|Ride"] = 732.38, ["Mega|Fly|Ride"] = 728.8}},
    ["rbxassetid://3409444089"] = {name = "Hyena", prices = {["default"] = 138.5, ["Fly"] = 1396.02, ["Ride"] = 209.32, ["Fly|Ride"] = 249.38, ["Neon"] = 1674.6, ["Neon|Ride"] = 774.38, ["Neon|Fly|Ride"] = 1140.59, ["Mega|Ride"] = 3000.66, ["Mega|Fly|Ride"] = 3490.48}},
    ["rbxassetid://127067345833475"] = {name = "Hummingbird", prices = {["default"] = 13.13, ["Ride"] = 56.52, ["Fly|Ride"] = 675.94, ["Neon"] = 19.9, ["Neon|Ride"] = 155.74, ["Neon|Fly|Ride"] = 145.69, ["Mega"] = 223.99, ["Mega|Ride"] = 190.61, ["Mega|Fly|Ride"] = 732.65}},
    ["rbxassetid://130497948875084"] = {name = "Marabou Stork", prices = {["default"] = 2.1, ["Ride"] = 39.38, ["Neon"] = 12.27, ["Neon|Fly"] = 96.31, ["Neon|Ride"] = 34.13, ["Mega"] = 83.2, ["Mega|Fly|Ride"] = 826.31}},
    ["rbxassetid://127017727552531"] = {name = "Angus Calf", prices = {["default"] = 3.81, ["Fly"] = 101.94, ["Ride"] = 36.02, ["Fly|Ride"] = 118.13, ["Neon"] = 12.69, ["Neon|Ride"] = 44.63, ["Neon|Fly|Ride"] = 251.21, ["Mega"] = 66.4, ["Mega|Ride"] = 98.44, ["Mega|Fly|Ride"] = 287.44}},
    ["rbxassetid://12779130089"] = {name = "Sprout Snail", prices = {["default"] = 14.3, ["Mega"] = 525, ["Mega|Fly|Ride"] = 368.43}},
    ["rbxassetid://117824155556510"] = {name = "Princess Mare", prices = {["default"] = 2.1, ["Ride"] = 70.62, ["Neon"] = 2.1, ["Neon|Ride"] = 32.71, ["Mega"] = 19.69, ["Mega|Ride"] = 133.88, ["Mega|Fly|Ride"] = 698.12}},
    ["rbxassetid://122766274014139"] = {name = "Gaelic Fae", prices = {["default"] = 81.9, ["Ride"] = 127.7, ["Fly|Ride"] = 130.59, ["Neon"] = 366.33, ["Neon|Ride"] = 409.5, ["Neon|Fly|Ride"] = 458.43, ["Mega|Ride"] = 1674.6, ["Mega|Fly|Ride"] = 1132.45}},
    ["rbxassetid://17255807019"] = {name = "Weevil", prices = {["default"] = 2.1, ["Ride"] = 32.65, ["Neon"] = 6.34, ["Mega|Ride"] = 112.88}},
    ["rbxassetid://3743720235"] = {name = "Capybara", prices = {["default"] = 39.38, ["Fly"] = 217.17, ["Ride"] = 76.13, ["Neon"] = 278.76, ["Neon|Ride"] = 367.5, ["Neon|Fly|Ride"] = 513.14, ["Mega"] = 2625, ["Mega|Ride"] = 2791.34, ["Mega|Fly|Ride"] = 1156.32}},
    ["rbxassetid://106815320234576"] = {name = "Ehecatl", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 52.41, ["Fly|Ride"] = 70.14, ["Neon"] = 6.3, ["Neon|Fly|Ride"] = 94.5, ["Mega"] = 49.98, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 213.94}},
    ["rbxassetid://110449571836616"] = {name = "Irish Setter", prices = {["default"] = 6.34, ["Neon"] = 14.44, ["Neon|Ride"] = 151.09, ["Mega"] = 72.19, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://93751644677101"] = {name = "Winter Doe", prices = {["default"] = 11.53, ["Ride"] = 210, ["Neon"] = 51.12, ["Neon|Ride"] = 138.17, ["Mega"] = 209.34, ["Mega|Ride"] = 321.33}},
    ["rbxassetid://90667836208550"] = {name = "Munchkin Cat", prices = {["default"] = 397.67, ["Ride"] = 393.74, ["Fly|Ride"] = 555.77, ["Neon"] = 1114.32, ["Neon|Ride"] = 1141.87, ["Neon|Fly|Ride"] = 1958.18, ["Mega"] = 4047.27, ["Mega|Ride"] = 3558.51, ["Mega|Fly|Ride"] = 3411.19}},
    ["rbxassetid://3743734696"] = {name = "Rhino", prices = {["default"] = 34.13, ["Ride"] = 52.5, ["Fly|Ride"] = 83.75, ["Neon"] = 181.12, ["Neon|Fly"] = 310.31, ["Neon|Ride"] = 208.69, ["Neon|Fly|Ride"] = 210, ["Mega|Fly|Ride"] = 1548.75}},
    ["rbxassetid://7734928397"] = {name = "Halloween Blue Scorpion", prices = {["default"] = 2.1, ["Fly"] = 34.13, ["Ride"] = 20.95, ["Fly|Ride"] = 72.19, ["Neon"] = 7.23, ["Neon|Ride"] = 137.82, ["Neon|Fly|Ride"] = 155.74, ["Mega"] = 111.57, ["Mega|Ride"] = 85.32, ["Mega|Fly|Ride"] = 558.91}},
    ["rbxassetid://116859365721104"] = {name = "Shadow Dragon Ducky", prices = {["default"] = 13.13, ["Fly"] = 109.61, ["Ride"] = 40.95, ["Fly|Ride"] = 91.88, ["Neon"] = 42, ["Neon|Fly"] = 124.29, ["Neon|Ride"] = 86.89, ["Neon|Fly|Ride"] = 176.19, ["Mega"] = 231.32, ["Mega|Fly"] = 374.67, ["Mega|Ride"] = 255.3, ["Mega|Fly|Ride"] = 325.5}},
    ["rbxassetid://6060991084"] = {name = "Musk Ox", prices = {["default"] = 3.94, ["Ride"] = 35.6, ["Neon"] = 105, ["Neon|Ride"] = 96.31, ["Mega|Ride"] = 468.89, ["Mega|Fly|Ride"] = 301.44}},
    ["rbxassetid://119284351481681"] = {name = "Violet Friend", prices = {["default"] = 6.57, ["Neon"] = 18.31, ["Mega"] = 68.02, ["Mega|Ride"] = 139.12}},
    ["rbxassetid://10971808356"] = {name = "Basilisk", prices = {["default"] = 2.1, ["Ride"] = 22.32, ["Fly|Ride"] = 66.32, ["Neon"] = 26.25, ["Neon|Ride"] = 28.46, ["Neon|Fly|Ride"] = 213.52, ["Mega"] = 542.75, ["Mega|Ride"] = 486.94, ["Mega|Fly|Ride"] = 488.78}},
    ["rbxassetid://3744706727"] = {name = "Platypus", prices = {["default"] = 107.63, ["Fly"] = 161.18, ["Ride"] = 122.13, ["Neon|Ride"] = 558.91, ["Neon|Fly|Ride"] = 558.91, ["Mega"] = 2372.69, ["Mega|Ride"] = 2540.15, ["Mega|Fly|Ride"] = 2679.35}},
    ["rbxassetid://12480556316"] = {name = "Black Macaque", prices = {["default"] = 45.94, ["Ride"] = 62.73, ["Fly|Ride"] = 144, ["Neon"] = 192.94, ["Neon|Ride"] = 272.13, ["Mega"] = 698.12, ["Mega|Ride"] = 635.73, ["Mega|Fly|Ride"] = 820.57}},
    ["rbxassetid://4849941000"] = {name = "Dalmatian", prices = {["default"] = 2930.54, ["Fly"] = 2349.23, ["Ride"] = 2493.75, ["Fly|Ride"] = 2415, ["Neon"] = 12559.4, ["Neon|Fly|Ride"] = 7604.72, ["Mega|Fly|Ride"] = 26250}},
    ["rbxassetid://139319822015938"] = {name = "Sea Skeleton Panda", prices = {["default"] = 3.94, ["Fly"] = 65625, ["Ride"] = 28.88, ["Fly|Ride"] = 170.63, ["Neon"] = 12.48, ["Neon|Ride"] = 49.21, ["Mega"] = 104.94, ["Mega|Ride"] = 172.02}},
    ["rbxassetid://104838807480936"] = {name = "Winter Fawn", prices = {["default"] = 15.74, ["Ride"] = 90.02, ["Fly|Ride"] = 195.74, ["Neon"] = 81.65, ["Neon|Ride"] = 155.74, ["Neon|Fly|Ride"] = 273, ["Mega"] = 182.13, ["Mega|Ride"] = 314, ["Mega|Fly|Ride"] = 458.8}},
    ["rbxassetid://100705885132301"] = {name = "Cabbit", prices = {["default"] = 918.75, ["Ride"] = 984.38, ["Fly|Ride"] = 1023.75, ["Neon"] = 4750.6, ["Neon|Ride"] = 4750.6, ["Neon|Fly|Ride"] = 3793.13, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://12480406935"] = {name = "Binturong", prices = {["default"] = 52.5, ["Ride"] = 49.88, ["Fly|Ride"] = 262.5, ["Neon"] = 223.99, ["Mega"] = 757.77, ["Mega|Ride"] = 1883.93, ["Mega|Fly|Ride"] = 752.07}},
    ["rbxassetid://73245262062822"] = {name = "Prism Snake", prices = {["default"] = 4.47, ["Ride"] = 28.25, ["Neon"] = 21, ["Neon|Ride"] = 73.5, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 200.96, ["Mega|Ride"] = 346.44, ["Mega|Fly|Ride"] = 280.88}},
    ["rbxassetid://113717425344888"] = {name = "Magpie", prices = {["default"] = 2.1, ["Fly"] = 111.19, ["Neon"] = 6.3, ["Neon|Ride"] = 52.5, ["Mega"] = 21, ["Mega|Ride"] = 68.25, ["Mega|Fly|Ride"] = 125.62}},
    ["rbxassetid://10318105900"] = {name = "Purple Butterfly", prices = {["default"] = 85.13, ["Ride"] = 126, ["Neon"] = 698.12, ["Mega|Fly|Ride"] = 5333.21}},
    ["rbxassetid://95049698731940"] = {name = "Throwback Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15503941919"] = {name = "Arctic Hare", prices = {["default"] = 5.25, ["Neon"] = 39.38, ["Neon|Ride"] = 97.63, ["Mega"] = 286.85, ["Mega|Ride"] = 183.7}},
    ["rbxassetid://10274421272"] = {name = "Royal Corgi", prices = {["default"] = 56.52, ["Mega|Fly|Ride"] = 1745.77}},
    ["rbxassetid://13978968837"] = {name = "Bird of Paradise", prices = {["default"] = 4.55, ["Fly"] = 105, ["Neon"] = 54.45, ["Neon|Fly|Ride"] = 315, ["Mega"] = 221.9}},
    ["rbxassetid://3261465850"] = {name = "Pink Cat", prices = {["default"] = 255.94, ["Ride"] = 357.91, ["Fly|Ride"] = 310.79, ["Neon"] = 1766.63, ["Neon|Ride"] = 721.88, ["Neon|Fly|Ride"] = 1073.84, ["Mega|Fly|Ride"] = 5113.56}},
    ["rbxassetid://8969010905"] = {name = "Red Fox", prices = {["default"] = 5.65, ["Fly"] = 28.26, ["Ride"] = 23.04, ["Fly|Ride"] = 67.01, ["Neon"] = 39, ["Neon|Ride"] = 71.18, ["Neon|Fly|Ride"] = 232.45, ["Mega"] = 342.26, ["Mega|Ride"] = 314, ["Mega|Fly|Ride"] = 349.58}},
    ["rbxassetid://3181728128"] = {name = "Red Panda", prices = {["default"] = 2.1, ["Fly"] = 26.72, ["Ride"] = 36.75, ["Neon"] = 3.93, ["Neon|Fly"] = 38.07, ["Neon|Ride"] = 23.25, ["Neon|Fly|Ride"] = 60.72, ["Mega"] = 53.48, ["Mega|Ride"] = 74.33, ["Mega|Fly|Ride"] = 98.4}},
    ["rbxassetid://13077769577"] = {name = "Pelican", prices = {["default"] = 787.5, ["Fly"] = 1103.01, ["Ride"] = 903, ["Fly|Ride"] = 787.5, ["Neon|Ride"] = 7675.89, ["Neon|Fly|Ride"] = 4186.47}},
    ["rbxassetid://115281603518501"] = {name = "DJ Snooze", prices = {["default"] = 4.67, ["Ride"] = 210, ["Neon"] = 40.45, ["Mega"] = 98.44, ["Mega|Ride"] = 518.09, ["Mega|Fly|Ride"] = 291.38}},
    ["rbxassetid://111847888001946"] = {name = "Choco Penguin", prices = {["default"] = 8.39, ["Ride"] = 52.35, ["Neon"] = 30.64, ["Neon|Ride"] = 70.14, ["Neon|Fly|Ride"] = 180.97, ["Mega"] = 157.5, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 408.72}},
    ["rbxassetid://4621220487"] = {name = "Panda", prices = {["default"] = 40.62, ["Fly"] = 53.76, ["Ride"] = 35.81, ["Fly|Ride"] = 62.72, ["Neon|Ride"] = 141.31, ["Neon|Fly|Ride"] = 183.75, ["Mega|Fly|Ride"] = 1255.15}},
    ["rbxassetid://12917347184"] = {name = "Flower Power Duckling", prices = {["default"] = 13.13, ["Fly"] = 78.49, ["Ride"] = 35.6, ["Fly|Ride"] = 90.76, ["Neon"] = 124.69, ["Neon|Ride"] = 82.7, ["Neon|Fly|Ride"] = 279.46, ["Mega"] = 408.19, ["Mega|Ride"] = 287.83, ["Mega|Fly|Ride"] = 443.63}},
    ["rbxassetid://93775555430694"] = {name = "Pumpkin Friend", prices = {["default"] = 17.81, ["Ride"] = 210, ["Fly|Ride"] = 152.81, ["Neon"] = 116.76, ["Neon|Ride"] = 203.06, ["Mega"] = 698.12, ["Mega|Ride"] = 492.97, ["Mega|Fly|Ride"] = 586.11}},
    ["rbxassetid://83317902236850"] = {name = "Kakapo", prices = {["default"] = 2.1, ["Fly"] = 45.94, ["Ride"] = 116.59, ["Fly|Ride"] = 232.26, ["Neon"] = 2.63, ["Neon|Ride"] = 31.42, ["Mega"] = 18.38, ["Mega|Ride"] = 140.26}},
    ["rbxassetid://5862774043"] = {name = "Ghost Bunny", prices = {["default"] = 32.82, ["Fly"] = 48.57, ["Ride"] = 39.38, ["Fly|Ride"] = 77.44, ["Neon"] = 277.49, ["Neon|Ride"] = 144.38, ["Neon|Fly|Ride"] = 249.38, ["Mega|Fly|Ride"] = 1454.8}},
    ["rbxassetid://10639131895"] = {name = "Spider Crab", prices = {["default"] = 9.31, ["Fly"] = 140.25, ["Ride"] = 25.71, ["Fly|Ride"] = 127.32, ["Neon|Fly|Ride"] = 140.26, ["Mega"] = 773.07}},
    ["rbxassetid://10193736072"] = {name = "Red Crowned Crane", prices = {["default"] = 2.1, ["Fly"] = 25.12, ["Ride"] = 18.38, ["Fly|Ride"] = 52.35, ["Neon"] = 35.44, ["Neon|Ride"] = 6977.8, ["Mega|Ride"] = 279.46, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://13804047294"] = {name = "Arctic Tern", prices = {["default"] = 3.81, ["Ride"] = 174.79, ["Neon"] = 105, ["Neon|Fly|Ride"] = 104.68, ["Mega"] = 262.5}},
    ["rbxassetid://14883937353"] = {name = "Ghost Dog", prices = {["default"] = 21.81, ["Fly"] = 262.4, ["Ride"] = 46.47, ["Neon"] = 116.81, ["Neon|Ride"] = 211.32, ["Neon|Fly|Ride"] = 226.09, ["Mega|Ride"] = 760.07, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://103241919688695"] = {name = "2025 Birthday Butterfly", prices = {["default"] = 7.87, ["Neon"] = 21.83, ["Neon|Ride"] = 62.82, ["Mega"] = 97.97, ["Mega|Fly|Ride"] = 310.31}},
    ["rbxassetid://86594144838863"] = {name = "Tree Frog", prices = {["default"] = 2.1, ["Ride"] = 25.83, ["Neon"] = 2.62, ["Neon|Ride"] = 91.88, ["Mega"] = 27.23, ["Mega|Ride"] = 51.19, ["Mega|Fly|Ride"] = 203.44}},
    ["rbxassetid://99048375832409"] = {name = "Shih Tzu", prices = {["default"] = 2.1, ["Ride"] = 44.63, ["Neon"] = 2.63, ["Neon|Fly"] = 393.65, ["Neon|Ride"] = 38.07, ["Mega"] = 20.96, ["Mega|Fly"] = 73.86, ["Mega|Ride"] = 32.82, ["Mega|Fly|Ride"] = 114.19}},
    ["rbxassetid://6998403122"] = {name = "Kirin", prices = {["default"] = 2.1, ["Fly"] = 36.75, ["Ride"] = 24.07, ["Fly|Ride"] = 40.05, ["Neon"] = 11.17, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 83.69, ["Mega"] = 104.68, ["Mega|Ride"] = 140.52, ["Mega|Fly|Ride"] = 246.4}},
    ["rbxassetid://15930472964"] = {name = "Gila Monster", prices = {["default"] = 2.63, ["Ride"] = 27.28, ["Fly|Ride"] = 49.21, ["Neon"] = 91.88, ["Neon|Ride"] = 70.14, ["Mega"] = 154.92, ["Mega|Ride"] = 147.91}},
    ["rbxassetid://5721843144"] = {name = "Dilophosaurus", prices = {["default"] = 2.63, ["Fly"] = 39.8, ["Ride"] = 16.95, ["Fly|Ride"] = 39.79, ["Neon"] = 33.51, ["Neon|Ride"] = 31.4, ["Neon|Fly|Ride"] = 80.07, ["Mega"] = 249.38, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 361.59}},
    ["rbxassetid://109520235810036"] = {name = "Mini Schnauzer", prices = {["default"] = 81.65, ["Fly|Ride"] = 391.44, ["Neon"] = 250.68, ["Neon|Ride"] = 310.31, ["Mega|Ride"] = 1050, ["Mega|Fly|Ride"] = 949.3}},
    ["rbxassetid://3181728229"] = {name = "Snow Cat", prices = {["default"] = 2.1, ["Fly"] = 26.18, ["Ride"] = 14.96, ["Fly|Ride"] = 31.42, ["Neon"] = 3.82, ["Neon|Fly"] = 72.19, ["Neon|Ride"] = 17.07, ["Neon|Fly|Ride"] = 53.68, ["Mega"] = 36.75, ["Mega|Ride"] = 39.53, ["Mega|Fly|Ride"] = 144.45}},
    ["rbxassetid://4506925747"] = {name = "Wolf", prices = {["default"] = 7.85, ["Fly"] = 31.37, ["Ride"] = 39.38, ["Fly|Ride"] = 56.85, ["Neon"] = 39.38, ["Neon|Fly"] = 98.4, ["Neon|Ride"] = 59.06, ["Neon|Fly|Ride"] = 158.89, ["Mega"] = 459.08, ["Mega|Ride"] = 328.12, ["Mega|Fly|Ride"] = 542.77}},
    ["rbxassetid://5862774473"] = {name = "Albino Bat", prices = {["default"] = 11.82, ["Fly"] = 140.25, ["Ride"] = 28.26, ["Fly|Ride"] = 82.69, ["Neon"] = 72.13, ["Neon|Ride"] = 91.07, ["Neon|Fly|Ride"] = 105, ["Mega|Ride"] = 558.91, ["Mega|Fly|Ride"] = 461.34}},
    ["rbxassetid://14978701751"] = {name = "Scarecrow", prices = {["default"] = 2.63, ["Fly"] = 140.38, ["Ride"] = 46.14, ["Neon"] = 19.9, ["Mega"] = 196.88, ["Mega|Ride"] = 244.93, ["Mega|Fly|Ride"] = 349.58}},
    ["rbxassetid://10235589000"] = {name = "Corgi", prices = {["default"] = 2.1, ["Ride"] = 16.68, ["Fly|Ride"] = 56.54, ["Neon"] = 4.5, ["Neon|Fly"] = 81.38, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 109.27, ["Mega"] = 41.2, ["Mega|Fly"] = 91.88, ["Mega|Ride"] = 56.64}},
    ["rbxassetid://103710623311342"] = {name = "Ghost Chick", prices = {["default"] = 3.89, ["Ride"] = 38.07, ["Neon"] = 11.95, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 99.45, ["Mega"] = 108.87, ["Mega|Fly"] = 735, ["Mega|Ride"] = 132.93, ["Mega|Fly|Ride"] = 380.99}},
    ["rbxassetid://4440866423"] = {name = "Cow", prices = {["default"] = 974.56, ["Fly"] = 1250.82, ["Ride"] = 1050, ["Fly|Ride"] = 1168.13, ["Neon|Ride"] = 3058.91, ["Neon|Fly|Ride"] = 2278.5, ["Mega|Fly|Ride"] = 7434}},
    ["rbxassetid://15093139154"] = {name = "Slime", prices = {["default"] = 56.54, ["Ride"] = 91.88, ["Neon"] = 262.5, ["Neon|Ride"] = 270.04, ["Mega"] = 2812.69, ["Mega|Fly|Ride"] = 1168.41}},
    ["rbxassetid://82170828935980"] = {name = "Dracula Fish", prices = {["default"] = 2.1, ["Fly"] = 62.35, ["Neon"] = 5.25, ["Neon|Ride"] = 85.32, ["Neon|Fly|Ride"] = 315, ["Mega"] = 65.91}},
    ["rbxassetid://11109302289"] = {name = "Zombie Wolf", prices = {["default"] = 32.82, ["Ride"] = 43.22, ["Fly|Ride"] = 262.5, ["Neon"] = 193.98, ["Neon|Ride"] = 192.94, ["Neon|Fly|Ride"] = 464.88, ["Mega"] = 2047.76, ["Mega|Ride"] = 986.97, ["Mega|Fly|Ride"] = 1286.13}},
    ["rbxassetid://15369729071"] = {name = "Nutcracker Squirrel", prices = {["default"] = 7.86, ["Ride"] = 116.13, ["Neon"] = 28.28, ["Neon|Ride"] = 315, ["Mega"] = 426.54}},
    ["rbxassetid://9800792849"] = {name = "Goat", prices = {["default"] = 275.63, ["Fly"] = 929.01, ["Ride"] = 324.18, ["Fly|Ride"] = 561.75, ["Neon|Ride"] = 1320.38, ["Neon|Fly|Ride"] = 1110.38, ["Mega|Fly|Ride"] = 4545.47}},
    ["rbxassetid://12509687499"] = {name = "Banded Palm Civet", prices = {["default"] = 2.41, ["Fly"] = 102.38, ["Ride"] = 22.32, ["Fly|Ride"] = 129.93, ["Neon"] = 56.54, ["Mega"] = 400.86}},
    ["rbxassetid://10381386150"] = {name = "Rhino Beetle", prices = {["default"] = 2.63, ["Fly|Ride"] = 698.12, ["Neon"] = 56.54, ["Neon|Ride"] = 140.26}},
    ["rbxassetid://130734656883878"] = {name = "Merry Mistletroll", prices = {["default"] = 52.5, ["Ride"] = 104.67, ["Neon"] = 163.78, ["Neon|Ride"] = 308.77, ["Mega"] = 693.93, ["Mega|Ride"] = 1019.42, ["Mega|Fly|Ride"] = 794.4}},
    ["rbxassetid://15923337068"] = {name = "Oryx", prices = {["default"] = 3.93, ["Ride"] = 67.33, ["Neon"] = 23.63, ["Mega"] = 223.99, ["Mega|Ride"] = 275.27}},
    ["rbxassetid://6245080365"] = {name = "Ox", prices = {["default"] = 2.1, ["Fly"] = 18.38, ["Ride"] = 17.07, ["Fly|Ride"] = 32.82, ["Neon"] = 2.61, ["Neon|Fly"] = 31.38, ["Neon|Ride"] = 33.51, ["Neon|Fly|Ride"] = 68.25, ["Mega"] = 42.14, ["Mega|Fly"] = 46.5, ["Mega|Ride"] = 43.98, ["Mega|Fly|Ride"] = 89.22}},
    ["rbxassetid://13810870050"] = {name = "African Wild Dog", prices = {["default"] = 4199.9, ["Ride"] = 5336.05, ["Fly|Ride"] = 4097.63, ["Neon"] = 18839.08, ["Neon|Fly|Ride"] = 26138.18}},
    ["rbxassetid://12596400214"] = {name = "Goldfish", prices = {["default"] = 12.11, ["Ride"] = 56.44, ["Neon"] = 131.25, ["Neon|Ride"] = 140.26, ["Mega"] = 262.5, ["Mega|Ride"] = 388.19, ["Mega|Fly|Ride"] = 523.69}},
    ["rbxassetid://4736656915"] = {name = "Australian Kelpie", prices = {["default"] = 2.1, ["Ride"] = 37.17, ["Fly|Ride"] = 35.6, ["Neon"] = 15.69, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 137.16, ["Mega"] = 282.6, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 205.15}},
    ["rbxassetid://3743711305"] = {name = "Crocodile", prices = {["default"] = 464.51, ["Fly"] = 840, ["Ride"] = 492.19, ["Fly|Ride"] = 537.97, ["Neon"] = 1674.6, ["Neon|Fly|Ride"] = 1396.21, ["Mega|Fly|Ride"] = 6429.13}},
    ["rbxassetid://74373220330198"] = {name = "Officer Gibbon", prices = {["default"] = 4.99, ["Ride"] = 52.5, ["Neon"] = 22.32, ["Neon|Ride"] = 209.34, ["Mega"] = 144.13, ["Mega|Fly|Ride"] = 698.12}},
    ["rbxassetid://18508184138"] = {name = "Peregrine Falcon", prices = {["default"] = 4.2, ["Fly"] = 110.25, ["Ride"] = 77.82, ["Neon"] = 65.63, ["Neon|Ride"] = 279.46, ["Neon|Fly|Ride"] = 141.31, ["Mega"] = 324.47, ["Mega|Ride"] = 401.63}},
    ["rbxassetid://92389214029179"] = {name = "Kaijunior", prices = {["default"] = 2.63, ["Ride"] = 28.46, ["Fly|Ride"] = 82.55, ["Neon"] = 3.93, ["Neon|Fly"] = 43.32, ["Neon|Ride"] = 26.25, ["Mega"] = 42, ["Mega|Ride"] = 73.64, ["Mega|Fly|Ride"] = 154.92}},
    ["rbxassetid://3409443986"] = {name = "Flamingo", prices = {["default"] = 616.88, ["Ride"] = 582.75, ["Fly|Ride"] = 651, ["Neon|Fly|Ride"] = 2652.14, ["Mega|Fly|Ride"] = 8751.75}},
    ["rbxassetid://126933432685319"] = {name = "Cattuccino", prices = {["default"] = 6.56, ["Ride"] = 41.83, ["Neon"] = 26.24, ["Neon|Ride"] = 108.94, ["Neon|Fly|Ride"] = 190.61, ["Mega"] = 131.25, ["Mega|Ride"] = 199.5, ["Mega|Fly|Ride"] = 432}},
    ["rbxassetid://11631390464"] = {name = "Ermine", prices = {["default"] = 10.49, ["Fly"] = 54.58, ["Ride"] = 56.91, ["Fly|Ride"] = 131.25, ["Neon"] = 35.44, ["Neon|Ride"] = 100.9, ["Neon|Fly|Ride"] = 3875.86, ["Mega"] = 265.85, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 363.19}},
    ["rbxassetid://4708551221"] = {name = "Emu", prices = {["default"] = 2.63, ["Fly"] = 23.04, ["Ride"] = 19.83, ["Neon"] = 16.96, ["Neon|Ride"] = 33.72, ["Neon|Fly|Ride"] = 87.93, ["Mega"] = 150.81, ["Mega|Fly|Ride"] = 198.87}},
    ["rbxassetid://16088266364"] = {name = "Burning Bunny", prices = {["default"] = 39.38, ["Ride"] = 52.35, ["Neon"] = 118.13, ["Mega"] = 555.77}},
    ["rbxassetid://80832101513100"] = {name = "2026 Birthday Butterfly", prices = {["default"] = 2.1, ["Neon"] = 3.94, ["Neon|Fly|Ride"] = 2033.81, ["Mega"] = 26.22, ["Mega|Ride"] = 110.42, ["Mega|Fly|Ride"] = 231.28}},
    ["rbxassetid://14639007389"] = {name = "Caterpillar", prices = {["default"] = 561.75, ["Ride"] = 418.62, ["Fly|Ride"] = 597.63, ["Neon|Ride"] = 2074.41, ["Neon|Fly|Ride"] = 2294.2, ["Mega|Fly|Ride"] = 8677.94}},
    ["rbxassetid://82920146813845"] = {name = "Little Lamb", prices = {["default"] = 2.1, ["Ride"] = 92.92, ["Neon"] = 8.39, ["Neon|Ride"] = 48.57, ["Neon|Fly|Ride"] = 140.26, ["Mega"] = 61.77, ["Mega|Ride"] = 133.98, ["Mega|Fly|Ride"] = 259.58}},
    ["rbxassetid://96424154406922"] = {name = "Crimson Cape", prices = {["default"] = 2.1, ["Ride"] = 52.5, ["Neon"] = 3.93, ["Neon|Ride"] = 203.06, ["Mega"] = 35.57, ["Mega|Ride"] = 82.7}},
    ["rbxassetid://109008428989602"] = {name = "Pangolin", prices = {["default"] = 2.1, ["Neon"] = 2.63, ["Neon|Ride"] = 45.92, ["Mega"] = 37.95, ["Mega|Fly"] = 154.92}},
    ["rbxassetid://16722909218"] = {name = "Floral Eggy", prices = {["default"] = 3.59, ["Ride"] = 131.25, ["Neon"] = 17.07, ["Mega"] = 209.34}},
    ["rbxassetid://76735046136809"] = {name = "Frostbite Cub", prices = {["default"] = 48.57, ["Ride"] = 84.94, ["Fly|Ride"] = 155.66, ["Neon"] = 216.57, ["Neon|Ride"] = 231.32, ["Neon|Fly|Ride"] = 349.58, ["Mega"] = 593.25, ["Mega|Ride"] = 610.21, ["Mega|Fly|Ride"] = 734.58}},
    ["rbxassetid://15684947715"] = {name = "Quokka", prices = {["default"] = 13.12, ["Fly"] = 69.57, ["Ride"] = 62.99, ["Neon"] = 84.13, ["Neon|Ride"] = 140.48, ["Neon|Fly|Ride"] = 279.46, ["Mega"] = 354.63, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://5721843001"] = {name = "Deinonychus", prices = {["default"] = 2.1, ["Fly"] = 34.65, ["Ride"] = 19.85, ["Fly|Ride"] = 32.81, ["Neon"] = 30.37, ["Neon|Ride"] = 35.48, ["Neon|Fly|Ride"] = 82.7, ["Mega|Fly|Ride"] = 259.58}},
    ["rbxassetid://16999461770"] = {name = "Inmate Capuchin Monkey", prices = {["default"] = 13.13, ["Ride"] = 52.5, ["Neon"] = 279.46, ["Neon|Ride"] = 158.82, ["Mega|Ride"] = 775.19, ["Mega|Fly|Ride"] = 540.06}},
    ["rbxassetid://119664699815373"] = {name = "Frozen Penguin", prices = {["default"] = 2.1, ["Ride"] = 33.51, ["Fly|Ride"] = 362.25, ["Neon"] = 13.13, ["Neon|Ride"] = 44.63, ["Mega"] = 132.93, ["Mega|Ride"] = 154.92, ["Mega|Fly|Ride"] = 231.32}},
    ["rbxassetid://5067924307"] = {name = "Business Monkey", prices = {["default"] = 24.09, ["Fly"] = 69.57, ["Ride"] = 45.94, ["Fly|Ride"] = 56.44, ["Neon"] = 249.11, ["Neon|Ride"] = 119.34, ["Neon|Fly|Ride"] = 167.48, ["Mega"] = 1050, ["Mega|Fly|Ride"] = 695.63}},
    ["rbxassetid://126192643157832"] = {name = "Manta Ray", prices = {["default"] = 35.6, ["Fly"] = 874.13, ["Ride"] = 62.79, ["Neon"] = 131.25, ["Mega|Ride"] = 623.8}},
    ["rbxassetid://4440866911"] = {name = "Silly Duck", prices = {["default"] = 39.38, ["Fly"] = 118.13, ["Ride"] = 93.18, ["Fly|Ride"] = 199.02, ["Neon"] = 256.7, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 452.16, ["Mega"] = 1074.89, ["Mega|Ride"] = 1381.54, ["Mega|Fly|Ride"] = 1140.83}},
    ["rbxassetid://110544962124445"] = {name = "Cake Friend", prices = {["default"] = 57.75, ["Fly"] = 140.25, ["Ride"] = 102.21, ["Neon"] = 209.34, ["Neon|Ride"] = 297.52, ["Neon|Fly|Ride"] = 251.21, ["Mega|Ride"] = 952.64, ["Mega|Fly|Ride"] = 612.94}},
    ["rbxassetid://16127157068"] = {name = "Rice Cake Rabbit", prices = {["default"] = 39.79, ["Ride"] = 78.49, ["Neon"] = 414.47, ["Neon|Ride"] = 223.13, ["Mega"] = 559.57, ["Mega|Ride"] = 1074.89}},
    ["rbxassetid://7734900613"] = {name = "Halloween Evil Dachshund", prices = {["default"] = 7.82, ["Fly"] = 52.5, ["Ride"] = 32.71, ["Fly|Ride"] = 140.26, ["Neon"] = 61.26, ["Neon|Fly"] = 167.48, ["Neon|Ride"] = 77.88, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 467.77, ["Mega|Ride"] = 345.19, ["Mega|Fly|Ride"] = 795.44}},
    ["rbxassetid://9664282145"] = {name = "Robot", prices = {["default"] = 2.1, ["Fly"] = 28.26, ["Ride"] = 17.07, ["Fly|Ride"] = 26.25, ["Neon"] = 2.63, ["Neon|Fly"] = 32.82, ["Neon|Ride"] = 21.11, ["Neon|Fly|Ride"] = 85.32, ["Mega"] = 59.07, ["Mega|Ride"] = 63, ["Mega|Fly|Ride"] = 183.18}},
    ["rbxassetid://3261465791"] = {name = "Pink Egg", prices = {["default"] = 974.42}},
    ["rbxassetid://126725051633301"] = {name = "Headless Horse", prices = {["default"] = 25.57, ["Ride"] = 127.32, ["Fly|Ride"] = 262.5, ["Neon"] = 132.93, ["Neon|Ride"] = 140.26, ["Mega"] = 558.91, ["Mega|Ride"] = 597.37, ["Mega|Fly|Ride"] = 490.91}},
    ["rbxassetid://88554799028713"] = {name = "Sneak Weasel", prices = {["default"] = 2.1, ["Ride"] = 31.37, ["Neon"] = 3.56, ["Neon|Fly|Ride"] = 293.07, ["Mega"] = 31.39, ["Mega|Ride"] = 89.55}},
    ["rbxassetid://14639008203"] = {name = "English Sheepdog", prices = {["default"] = 26.23, ["Ride"] = 83.74, ["Neon"] = 315, ["Neon|Fly|Ride"] = 544.69, ["Mega"] = 711.38, ["Mega|Ride"] = 805.91, ["Mega|Fly|Ride"] = 760.91}},
    ["rbxassetid://133131190079833"] = {name = "Oakee", prices = {["default"] = 2.1, ["Neon"] = 3.94, ["Mega"] = 31.4}},
    ["rbxassetid://79856043024325"] = {name = "Chestnut Glyptodon", prices = {["default"] = 2.52, ["Neon"] = 6.57, ["Mega"] = 41.89, ["Mega|Ride"] = 199.5, ["Mega|Fly|Ride"] = 273}},
    ["rbxassetid://12720028898"] = {name = "Hare", prices = {["default"] = 98.44, ["Ride"] = 140.25, ["Fly|Ride"] = 341.21, ["Neon"] = 799.1, ["Neon|Ride"] = 556.81, ["Neon|Fly|Ride"] = 863.97, ["Mega|Ride"] = 2372.69, ["Mega|Fly|Ride"] = 2784.01}},
    ["rbxassetid://16897788024"] = {name = "Capuchin Monkey", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Ride"] = 24.09, ["Fly|Ride"] = 125.58, ["Neon"] = 11.43, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 418.66, ["Mega|Ride"] = 100.49, ["Mega|Fly|Ride"] = 558.91}},
    ["rbxassetid://121639546210522"] = {name = "Amber Butterfly", prices = {["default"] = 2.1, ["Fly|Ride"] = 86.63, ["Neon"] = 3.92, ["Neon|Ride"] = 56.54, ["Neon|Fly|Ride"] = 419.99, ["Mega"] = 36.75, ["Mega|Ride"] = 124.57}},
    ["rbxassetid://79005166120532"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Neon"] = 3.91, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 35.44, ["Mega"] = 26.75, ["Mega|Ride"] = 70.62, ["Mega|Fly|Ride"] = 261.19}},
    ["rbxassetid://138741319376538"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 91.88, ["Neon"] = 4.13, ["Neon|Ride"] = 30.24, ["Neon|Fly|Ride"] = 140.26, ["Mega"] = 42.16, ["Mega|Ride"] = 95.7}},
    ["rbxassetid://133558151150234"] = {name = "Black Widow", prices = {["default"] = 45.02, ["Ride"] = 77.44, ["Neon"] = 314, ["Neon|Ride"] = 342.26, ["Neon|Fly|Ride"] = 656.25, ["Mega"] = 1112.56, ["Mega|Ride"] = 1535.4, ["Mega|Fly|Ride"] = 1346.58}},
    ["rbxassetid://122945704087152"] = {name = "Chilling Spider", prices = {["default"] = 4.2, ["Ride"] = 139.47, ["Neon"] = 11.53, ["Neon|Ride"] = 111.57, ["Mega"] = 140.26, ["Mega|Ride"] = 620.62, ["Mega|Fly|Ride"] = 464.88}},
    ["rbxassetid://1373237029"] = {name = "Big Head Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://2657668946"] = {name = "Cure All Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://1373237971"] = {name = "Grow Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4315743582"] = {name = "Honey Badger", prices = {["default"] = 315, ["Ride"] = 367.5, ["Fly|Ride"] = 435.41, ["Neon|Fly|Ride"] = 1203.62, ["Mega|Ride"] = 3205.8, ["Mega|Fly|Ride"] = 3150}},
    ["rbxassetid://1373208271"] = {name = "Hyperspeed Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4047157976"] = {name = "Fly Potion", prices = {["default"] = 72.16}},
    ["rbxassetid://3342628435"] = {name = "Ride Potion", prices = {["default"] = 39.38}},
    ["rbxassetid://1509389697"] = {name = "Adopt Me Boy Scooter", prices = {["default"] = 19.69}},
    ["rbxassetid://1509384540"] = {name = "Adopt Me Girl Scooter", prices = {["default"] = 28.31}},
    ["rbxassetid://1256627798"] = {name = "Adopt Me Snowboard 1", prices = {["default"] = 523.32}},
    ["rbxassetid://1256627585"] = {name = "Adopt Me Snowboard 2", prices = {["default"] = 53.4}},
    ["rbxassetid://2782643682"] = {name = "Axel", prices = {["default"] = 10.5}},
    ["rbxassetid://3009779146"] = {name = "Banana Car", prices = {["default"] = 6.34}},
    ["rbxassetid://1306904296"] = {name = "Bathtub", prices = {["default"] = 212.63}},
    ["rbxassetid://1307341557"] = {name = "Bethink Skateboard", prices = {["default"] = 21.19}},
    ["rbxassetid://908269395"] = {name = "Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://1509319125"] = {name = "Black Scooter", prices = {["default"] = 43.61}},
    ["rbxassetid://1306898658"] = {name = "Black Skateboard", prices = {["default"] = 7.88}},
    ["rbxassetid://1256625297"] = {name = "Black Snowboard", prices = {["default"] = 32.82}},
    ["rbxassetid://1266478264"] = {name = "Blue Neon Snowboard", prices = {["default"] = 262.16}},
    ["rbxassetid://4800244517"] = {name = "Blue Rider", prices = {["default"] = 2.1}},
    ["rbxassetid://1509318734"] = {name = "Blue Scooter", prices = {["default"] = 5.25}},
    ["rbxassetid://1256625905"] = {name = "Blue Snowboard", prices = {["default"] = 6.57}},
    ["rbxassetid://7165481985"] = {name = "Bubble Car", prices = {["default"] = 12.58}},
    ["rbxassetid://12115176522"] = {name = "Toxic Barrel", prices = {["default"] = 23.29}},
    ["rbxassetid://2657667116"] = {name = "Bunny Carriage", prices = {["default"] = 465.94}},
    ["rbxassetid://6475610034"] = {name = "Butterfly Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264167"] = {name = "Camper Van", prices = {["default"] = 2.63}},
    ["rbxassetid://2758237053"] = {name = "Car", prices = {["default"] = 2.1}},
    ["rbxassetid://14465252948"] = {name = "Super Jetpack", prices = {["default"] = 661.86}},
    ["rbxassetid://4754697599"] = {name = "Choo Choo Train", prices = {["default"] = 10.5}},
    ["rbxassetid://2408035766"] = {name = "Cloud", prices = {["default"] = 1111.69}},
    ["rbxassetid://5057099424"] = {name = "Clown Car", prices = {["default"] = 2.63}},
    ["rbxassetid://5057099515"] = {name = "Clown Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750671"] = {name = "Cookie Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8203695278"] = {name = "Snowmobile", prices = {["default"] = 7.88}},
    ["rbxassetid://8243269978"] = {name = "Zamboni", prices = {["default"] = 2.5}},
    ["rbxassetid://1509385561"] = {name = "Cupcake Scooter", prices = {["default"] = 14.39}},
    ["rbxassetid://4822522305"] = {name = "Daisy Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8517689681"] = {name = "Landsailer", prices = {["default"] = 2.63}},
    ["rbxassetid://8566306089"] = {name = "Trireme", prices = {["default"] = 2.1}},
    ["rbxassetid://6504033614"] = {name = "Dino Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://1512774745"] = {name = "Doge Scooter", prices = {["default"] = 52.5}},
    ["rbxassetid://1307341942"] = {name = "Doge Skateboard", prices = {["default"] = 5259.96}},
    ["rbxassetid://3486906742"] = {name = "Dogmobile", prices = {["default"] = 43.31}},
    ["rbxassetid://2880427418"] = {name = "Donut Cycle", prices = {["default"] = 22.32}},
    ["rbxassetid://3486907843"] = {name = "Donut Unicycle", prices = {["default"] = 2.63}},
    ["rbxassetid://2782643731"] = {name = "Douglas", prices = {["default"] = 9.09}},
    ["rbxassetid://9291032374"] = {name = "Egg Delivery Machine", prices = {["default"] = 17.43}},
    ["rbxassetid://1509377123"] = {name = "Emoji Scooter", prices = {["default"] = 11.8}},
    ["rbxassetid://9973767611"] = {name = "Harvest Truck", prices = {["default"] = 2.49}},
    ["rbxassetid://9973768669"] = {name = "Tractor", prices = {["default"] = 2.63}},
    ["rbxassetid://1307341332"] = {name = "Fidget Skateboard", prices = {["default"] = 61.69}},
    ["rbxassetid://1306904101"] = {name = "Fissy Skateboard", prices = {["default"] = 17.07}},
    ["rbxassetid://4823285384"] = {name = "Flower Wagon", prices = {["default"] = 6.45}},
    ["rbxassetid://7475653998"] = {name = "Fossil Paw Helicopter", prices = {["default"] = 2.61}},
    ["rbxassetid://9406027381"] = {name = "Starter Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://6475609765"] = {name = "Futuristic Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291832"] = {name = "Ghost Vehicle", prices = {["default"] = 1364.99}},
    ["rbxassetid://10905638416"] = {name = "Ancient Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760422"] = {name = "Bat Face Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://10919870588"] = {name = "Dapper Friend Carrier", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760559"] = {name = "Dirt Bike Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10967588257"] = {name = "Hot Tub Muscle Car", prices = {["default"] = 116.82}},
    ["rbxassetid://10905207734"] = {name = "Soapy Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9037078630"] = {name = "Horse And Carriage", prices = {["default"] = 304.63}},
    ["rbxassetid://10913434990"] = {name = "Unstable Triangle Car", prices = {["default"] = 3.92}},
    ["rbxassetid://8979306571"] = {name = "Wizard Caravan", prices = {["default"] = 2.43}},
    ["rbxassetid://1512770654"] = {name = "Glass Scooter", prices = {["default"] = 9.8}},
    ["rbxassetid://1306903971"] = {name = "Glass Skateboard", prices = {["default"] = 57.75}},
    ["rbxassetid://1064481531"] = {name = "GoKart", prices = {["default"] = 115.5}},
    ["rbxassetid://1509326491"] = {name = "Gold Scooter", prices = {["default"] = 28.28}},
    ["rbxassetid://1306902802"] = {name = "Gold Skateboard", prices = {["default"] = 12.85}},
    ["rbxassetid://12519249137"] = {name = "Bumper Car", prices = {["default"] = 2.63}},
    ["rbxassetid://12519249424"] = {name = "Circus Ball Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265134428"] = {name = "Green Neon Snowboard", prices = {["default"] = 162.07}},
    ["rbxassetid://7839195952"] = {name = "Halloween Black Ponycycle", prices = {["default"] = 22.29}},
    ["rbxassetid://11119263404"] = {name = "Headless Horseman's Biplane", prices = {["default"] = 5.25}},
    ["rbxassetid://10920073281"] = {name = "Throwing Knife Target", prices = {["default"] = 2.1}},
    ["rbxassetid://10920073157"] = {name = "Shadow Rider", prices = {["default"] = 22.29}},
    ["rbxassetid://11125166616"] = {name = "Unicorn Zombie Ponycycle", prices = {["default"] = 15.62}},
    ["rbxassetid://2848331544"] = {name = "Heart Hoverboard", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670919"] = {name = "Horse Cycle", prices = {["default"] = 101.06}},
    ["rbxassetid://3163531592"] = {name = "Traveling House", prices = {["default"] = 19.67}},
    ["rbxassetid://4382798606"] = {name = "Hoverboard", prices = {["default"] = 7.88}},
    ["rbxassetid://6475613264"] = {name = "Hovercar", prices = {["default"] = 3.42}},
    ["rbxassetid://4797807001"] = {name = "Human Bubble", prices = {["default"] = 2.1}},
    ["rbxassetid://4588192578"] = {name = "Ice Cream Truck", prices = {["default"] = 14.34}},
    ["rbxassetid://4470749585"] = {name = "Ice Queen Sleigh", prices = {["default"] = 2.1}},
    ["rbxassetid://1509333762"] = {name = "Ice Scooter", prices = {["default"] = 9.19}},
    ["rbxassetid://1265129203"] = {name = "Ice Snowboard", prices = {["default"] = 224.58}},
    ["rbxassetid://6504033516"] = {name = "Imagination Box", prices = {["default"] = 3.62}},
    ["rbxassetid://10619155042"] = {name = "Street Racer", prices = {["default"] = 26.17}},
    ["rbxassetid://2749267159"] = {name = "Limo", prices = {["default"] = 2.1}},
    ["rbxassetid://8665606953"] = {name = "Dragon Train", prices = {["default"] = 112.24}},
    ["rbxassetid://11758583286"] = {name = "Crescent Moon Car", prices = {["default"] = 152.25}},
    ["rbxassetid://6276452323"] = {name = "Lunar Muscle Car", prices = {["default"] = 6.3}},
    ["rbxassetid://7165482478"] = {name = "Magical Girl Car", prices = {["default"] = 6.57}},
    ["rbxassetid://7368045552"] = {name = "Magical Princess Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779540"] = {name = "Monocycle", prices = {["default"] = 27.57}},
    ["rbxassetid://1512742703"] = {name = "Mono-Moped", prices = {["default"] = 76.13}},
    ["rbxassetid://2758236960"] = {name = "Moped", prices = {["default"] = 155.65}},
    ["rbxassetid://2758237011"] = {name = "Motorcycle", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264226"] = {name = "Muscle Car", prices = {["default"] = 2.52}},
    ["rbxassetid://1306911569"] = {name = "Neon Black Skateboard", prices = {["default"] = 167.85}},
    ["rbxassetid://1509338320"] = {name = "Neon Blue Scooter", prices = {["default"] = 53.74}},
    ["rbxassetid://1306907175"] = {name = "Neon Blue Skateboard", prices = {["default"] = 132.86}},
    ["rbxassetid://1509342200"] = {name = "Neon Green Scooter", prices = {["default"] = 34.13}},
    ["rbxassetid://1306907671"] = {name = "Neon Green Skateboard", prices = {["default"] = 279.46}},
    ["rbxassetid://1509338451"] = {name = "Neon Orange Scooter", prices = {["default"] = 39.38}},
    ["rbxassetid://1306907450"] = {name = "Neon Orange Skateboard", prices = {["default"] = 36.75}},
    ["rbxassetid://1509339156"] = {name = "Neon Pink Scooter", prices = {["default"] = 76.04}},
    ["rbxassetid://1306911771"] = {name = "Neon Pink Skateboard", prices = {["default"] = 52.5}},
    ["rbxassetid://1509341495"] = {name = "Neon Red Scooter", prices = {["default"] = 272.95}},
    ["rbxassetid://1256625563"] = {name = "Orange Neon Snowboard", prices = {["default"] = 91.88}},
    ["rbxassetid://1509340494"] = {name = "Neon White Scooter", prices = {["default"] = 40.43}},
    ["rbxassetid://1309919907"] = {name = "Neon White Skateboard", prices = {["default"] = 40.66}},
    ["rbxassetid://2860616613"] = {name = "Offroader", prices = {["default"] = 2.1}},
    ["rbxassetid://1509329807"] = {name = "Pink Scooter", prices = {["default"] = 9.14}},
    ["rbxassetid://1306898507"] = {name = "Pink Skateboard", prices = {["default"] = 6.57}},
    ["rbxassetid://4361545125"] = {name = "Pizza Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://7368040075"] = {name = "Plant Powered Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9837424665"] = {name = "Rainbow Trail Magic Carpet", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601262"] = {name = "Prince Carriage", prices = {["default"] = 6.45}},
    ["rbxassetid://2854601314"] = {name = "Princess Carriage", prices = {["default"] = 26.17}},
    ["rbxassetid://4115248893"] = {name = "Pumpkin Carriage", prices = {["default"] = 43.32}},
    ["rbxassetid://7475654312"] = {name = "Racing Monoplane", prices = {["default"] = 3.94}},
    ["rbxassetid://10967874847"] = {name = "Galleon", prices = {["default"] = 6.57}},
    ["rbxassetid://10967808228"] = {name = "Old Sail Boat", prices = {["default"] = 2.63}},
    ["rbxassetid://8481992442"] = {name = "RGB Monster Truck", prices = {["default"] = 2.24}},
    ["rbxassetid://8481992324"] = {name = "RGB UFO", prices = {["default"] = 2.63}},
    ["rbxassetid://5882026006"] = {name = "Ribcage Carriage", prices = {["default"] = 5.16}},
    ["rbxassetid://4797807111"] = {name = "Rocket Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://7368052482"] = {name = "Rocket Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://4564588042"] = {name = "Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601162"] = {name = "Royal Carriage", prices = {["default"] = 8.72}},
    ["rbxassetid://13741294258"] = {name = "Giant Cheetah Mount", prices = {["default"] = 501.38}},
    ["rbxassetid://4470749525"] = {name = "Santa's Sleigh", prices = {["default"] = 33.53}},
    ["rbxassetid://4470749209"] = {name = "Sled", prices = {["default"] = 2.1}},
    ["rbxassetid://9342853829"] = {name = "Snow Plow", prices = {["default"] = 2.63}},
    ["rbxassetid://9343367876"] = {name = "Tundra Exploration Machine", prices = {["default"] = 2.63}},
    ["rbxassetid://1265142495"] = {name = "Snow Snowboard", prices = {["default"] = 236.25}},
    ["rbxassetid://7165482648"] = {name = "Speedboat", prices = {["default"] = 2.1}},
    ["rbxassetid://12719600101"] = {name = "Daisymobile", prices = {["default"] = 53.07}},
    ["rbxassetid://12996592162"] = {name = "Lavender Teapot Carriage", prices = {["default"] = 38.07}},
    ["rbxassetid://12917527253"] = {name = "Rabbit Helicopter", prices = {["default"] = 41.94}},
    ["rbxassetid://12996592079"] = {name = "Rose Petal Carriage", prices = {["default"] = 135.19}},
    ["rbxassetid://12996592010"] = {name = "Royal Crown Carriage", prices = {["default"] = 28.88}},
    ["rbxassetid://6504033423"] = {name = "Squirrel Car", prices = {["default"] = 5.25}},
    ["rbxassetid://6798176757"] = {name = "Standard Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://6797010981"] = {name = "Standard Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10224002323"] = {name = "Emperor's Chariot", prices = {["default"] = 13.34}},
    ["rbxassetid://10202931873"] = {name = "Orchid Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://10202932215"] = {name = "Hovercraft", prices = {["default"] = 2.1}},
    ["rbxassetid://10224209770"] = {name = "Planetary Core Car", prices = {["default"] = 2.35}},
    ["rbxassetid://10203332627"] = {name = "Medieval Wagon", prices = {["default"] = 2.63}},
    ["rbxassetid://13607580379"] = {name = "Beach Buggy", prices = {["default"] = 2.97}},
    ["rbxassetid://13683681091"] = {name = "Beachgoer", prices = {["default"] = 3.93}},
    ["rbxassetid://13683679951"] = {name = "Crabby Cruiser", prices = {["default"] = 60.84}},
    ["rbxassetid://3579315827"] = {name = "Surfboard", prices = {["default"] = 2.63}},
    ["rbxassetid://3186425945"] = {name = "SUV", prices = {["default"] = 7.88}},
    ["rbxassetid://1614139188"] = {name = "Multi-Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8727492188"] = {name = "Black Cab", prices = {["default"] = 3.73}},
    ["rbxassetid://8727477150"] = {name = "Yellow Taxi Cab", prices = {["default"] = 45.03}},
    ["rbxassetid://2783002443"] = {name = "Tiffany", prices = {["default"] = 17.93}},
    ["rbxassetid://3206264796"] = {name = "Tiny Convertible", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671636"] = {name = "Unicorn Cycle", prices = {["default"] = 106.47}},
    ["rbxassetid://3142180107"] = {name = "Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231299"] = {name = "Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506670"] = {name = "Family Car", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231666"] = {name = "Classic Helicopter", prices = {["default"] = 4.73}},
    ["rbxassetid://8860682054"] = {name = "Classic Boat", prices = {["default"] = 2.63}},
    ["rbxassetid://8859231811"] = {name = "Motorbike", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506795"] = {name = "Off-Road Car", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506884"] = {name = "Open Top Speeder", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231943"] = {name = "Classic Airplane", prices = {["default"] = 2.63}},
    ["rbxassetid://9108507006"] = {name = "Sports Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8859232022"] = {name = "Tandem Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265135075"] = {name = "White Neon Snowboard", prices = {["default"] = 1045.58}},
    ["rbxassetid://1509328859"] = {name = "White Scooter", prices = {["default"] = 7.18}},
    ["rbxassetid://1306898856"] = {name = "White Skateboard", prices = {["default"] = 10.5}},
    ["rbxassetid://1256624956"] = {name = "White Snowboard", prices = {["default"] = 52.5}},
    ["rbxassetid://7165482807"] = {name = "Wing Trunk Car", prices = {["default"] = 21}},
    ["rbxassetid://8080952782"] = {name = "Festive Deliveries Present Truck", prices = {["default"] = 33.71}},
    ["rbxassetid://8190703270"] = {name = "Festive Deliveries Sleigh", prices = {["default"] = 12.22}},
    ["rbxassetid://7975097837"] = {name = "Festive Ice Skates", prices = {["default"] = 2.52}},
    ["rbxassetid://11697121962"] = {name = "Candy Snowmobile", prices = {["default"] = 16.67}},
    ["rbxassetid://11574949668"] = {name = "Giant Snowball", prices = {["default"] = 16.42}},
    ["rbxassetid://11764928443"] = {name = "Gingerbread Sleigh", prices = {["default"] = 91.88}},
    ["rbxassetid://11706055135"] = {name = "Husky Sled", prices = {["default"] = 66.07}},
    ["rbxassetid://11466900358"] = {name = "Icebreaker Ship", prices = {["default"] = 2.1}},
    ["rbxassetid://11706157454"] = {name = "Snowblower Toboggan", prices = {["default"] = 6.01}},
    ["rbxassetid://11582939967"] = {name = "Strawberry Shortcake Skates", prices = {["default"] = 3.3}},
    ["rbxassetid://11582928541"] = {name = "Strawberry Shortcake Unicycle", prices = {["default"] = 3.05}},
    ["rbxassetid://4797807321"] = {name = "Witch's Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1509321524"] = {name = "Wood Scooter", prices = {["default"] = 9.19}},
    ["rbxassetid://1306899055"] = {name = "Wood Skateboard", prices = {["default"] = 630}},
    ["rbxassetid://4361544852"] = {name = "Airplane Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4797806115"] = {name = "Angelic Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671618"] = {name = "Anna Rattle", prices = {["default"] = 3.54}},
    ["rbxassetid://4712355837"] = {name = "Astro Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://2657667102"] = {name = "Balloon", prices = {["default"] = 61.57}},
    ["rbxassetid://3009779116"] = {name = "Balloons", prices = {["default"] = 2.63}},
    ["rbxassetid://3009779170"] = {name = "Banana Plush", prices = {["default"] = 3.62}},
    ["rbxassetid://3009779233"] = {name = "Banana Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248143"] = {name = "Banjo", prices = {["default"] = 4.46}},
    ["rbxassetid://4470749845"] = {name = "Bauble Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468615"] = {name = "Briefcase Ingredient", prices = {["default"] = 2.63}},
    ["rbxassetid://3486907018"] = {name = "Bubblegum Machine Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046064"] = {name = "Bunny Plush", prices = {["default"] = 4.67}},
    ["rbxassetid://4470749083"] = {name = "Candle", prices = {["default"] = 2.63}},
    ["rbxassetid://6710107927"] = {name = "Candy Cannon", prices = {["default"] = 7636.12}},
    ["rbxassetid://3082046250"] = {name = "Carrot Rattle", prices = {["default"] = 6.99}},
    ["rbxassetid://2408035756"] = {name = "Cat Plush", prices = {["default"] = 39.75}},
    ["rbxassetid://3009779289"] = {name = "Caticorn Rattle", prices = {["default"] = 3.94}},
    ["rbxassetid://3082047003"] = {name = "Chick Plush", prices = {["default"] = 6.56}},
    ["rbxassetid://3082046215"] = {name = "Chocolate Bunny Balloon", prices = {["default"] = 3.93}},
    ["rbxassetid://1257271764"] = {name = "Christmas Cat Rattle", prices = {["default"] = 2.72}},
    ["rbxassetid://1257273388"] = {name = "Christmas Doge Rattle", prices = {["default"] = 35.43}},
    ["rbxassetid://4470749153"] = {name = "Cookie Dough Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://10979219546"] = {name = "Cotton Candy Stand", prices = {["default"] = 65.63}},
    ["rbxassetid://4115248463"] = {name = "Creepy Balloon", prices = {["default"] = 3.73}},
    ["rbxassetid://2408035767"] = {name = "Croc Plush", prices = {["default"] = 3.83}},
    ["rbxassetid://4115248599"] = {name = "Crossbow Grappling Hook", prices = {["default"] = 20.93}},
    ["rbxassetid://5061468734"] = {name = "Cymbal Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://4822522594"] = {name = "Dandelion Propeller", prices = {["default"] = 14.42}},
    ["rbxassetid://4797806584"] = {name = "Didgeridoo", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779323"] = {name = "Donut Rattle", prices = {["default"] = 2.63}},
    ["rbxassetid://3454109877"] = {name = "Donut Throw Toy", prices = {["default"] = 105}},
    ["rbxassetid://3486907555"] = {name = "Dragon Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779349"] = {name = "Duck Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046102"] = {name = "Easter Bunny Plush", prices = {["default"] = 14.44}},
    ["rbxassetid://1555803323"] = {name = "Egg Rattle", prices = {["default"] = 3.94}},
    ["rbxassetid://2408051109"] = {name = "Elephant Plush", prices = {["default"] = 9.08}},
    ["rbxassetid://4470750254"] = {name = "Elf Plush", prices = {["default"] = 3.56}},
    ["rbxassetid://2657668953"] = {name = "Elf Rattle", prices = {["default"] = 3.93}},
    ["rbxassetid://5882028408"] = {name = "Eyeball Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408035763"] = {name = "Fancy Balloon", prices = {["default"] = 3.81}},
    ["rbxassetid://2408052395"] = {name = "Fancy Umbrella", prices = {["default"] = 32.46}},
    ["rbxassetid://3009779377"] = {name = "Flower Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291815"] = {name = "Flying Broomstick", prices = {["default"] = 4338.04}},
    ["rbxassetid://3454109803"] = {name = "Football Throw Toy", prices = {["default"] = 4.51}},
    ["rbxassetid://7368042855"] = {name = "Galaxy Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749638"] = {name = "Gift Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://1310513344"] = {name = "Glider", prices = {["default"] = 45.23}},
    ["rbxassetid://6936627177"] = {name = "Golden Maned Unicorn Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3142180004"] = {name = "Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907282"] = {name = "Griffin Propeller", prices = {["default"] = 2.63}},
    ["rbxassetid://1419098937"] = {name = "Heart Balloon", prices = {["default"] = 2.63}},
    ["rbxassetid://1419099271"] = {name = "Heart Plushie", prices = {["default"] = 7.76}},
    ["rbxassetid://2848331436"] = {name = "Heart Rattle", prices = {["default"] = 81.38}},
    ["rbxassetid://2657670910"] = {name = "Horse Plush", prices = {["default"] = 2.63}},
    ["rbxassetid://3818347838"] = {name = "Hotdog Stand", prices = {["default"] = 9.98}},
    ["rbxassetid://1555807694"] = {name = "Hugging Egg", prices = {["default"] = 140.26}},
    ["rbxassetid://4470749277"] = {name = "Ice Club Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779419"] = {name = "Ice Cream Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4361546643"] = {name = "Ice Cream Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749342"] = {name = "Ice Pick Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052390"] = {name = "Inflatable Sword", prices = {["default"] = 2.63}},
    ["rbxassetid://2408051119"] = {name = "Jackhammer", prices = {["default"] = 13.13}},
    ["rbxassetid://3486908136"] = {name = "Kangaroo Pogo", prices = {["default"] = 2.35}},
    ["rbxassetid://4822522509"] = {name = "Lavender Bundle", prices = {["default"] = 2.63}},
    ["rbxassetid://3523677453"] = {name = "Lemonade Stand", prices = {["default"] = 5.25}},
    ["rbxassetid://6475613071"] = {name = "Lime Slice Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051107"] = {name = "Llama Plush", prices = {["default"] = 41.88}},
    ["rbxassetid://4661940658"] = {name = "Magic House Door", prices = {["default"] = 26.25}},
    ["rbxassetid://3009779472"] = {name = "Marsh Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779496"] = {name = "Marsh Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099190"] = {name = "Monkey Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099046"] = {name = "Monkey Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670913"] = {name = "Noob Balloon", prices = {["default"] = 3.46}},
    ["rbxassetid://3009779607"] = {name = "Octopus Plush", prices = {["default"] = 2.52}},
    ["rbxassetid://4470749788"] = {name = "Ornament Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670921"] = {name = "Phoenix Plush", prices = {["default"] = 11.82}},
    ["rbxassetid://7368034465"] = {name = "Pink Cat Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544972"] = {name = "Plunger Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051114"] = {name = "Puppy Plush", prices = {["default"] = 5.24}},
    ["rbxassetid://3082046011"] = {name = "Rabbit Rattle", prices = {["default"] = 4.2}},
    ["rbxassetid://2408055079"] = {name = "Rainbow Wand", prices = {["default"] = 3.49}},
    ["rbxassetid://4470749750"] = {name = "Reindeer Leash", prices = {["default"] = 11.69}},
    ["rbxassetid://3009779583"] = {name = "Rocket Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749474"] = {name = "Santa Leash", prices = {["default"] = 2.63}},
    ["rbxassetid://4470750189"] = {name = "Santa Rattle", prices = {["default"] = 2.15}},
    ["rbxassetid://5061468835"] = {name = "Scroll Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://6475612857"] = {name = "Shuttle Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5882028350"] = {name = "Skull Drum", prices = {["default"] = 5.25}},
    ["rbxassetid://4470749413"] = {name = "Sleigh Bells Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://6059308940"] = {name = "Snowball Launcher", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671626"] = {name = "Snowman Plush", prices = {["default"] = 6.3}},
    ["rbxassetid://4470749691"] = {name = "Snowman Rattle", prices = {["default"] = 2.63}},
    ["rbxassetid://4470750120"] = {name = "Sock Chew Toy", prices = {["default"] = 2.63}},
    ["rbxassetid://2408052387"] = {name = "Squid Plush", prices = {["default"] = 6.06}},
    ["rbxassetid://5061468930"] = {name = "Staff Ingredient", prices = {["default"] = 18.38}},
    ["rbxassetid://6768659222"] = {name = "Standard Grappling Hook", prices = {["default"] = 2.61}},
    ["rbxassetid://2408055085"] = {name = "Starpower Wand", prices = {["default"] = 14.33}},
    ["rbxassetid://3009779638"] = {name = "Telescope Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4710374217"] = {name = "Tennis Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4464390422"] = {name = "Turkey Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://3977264097"] = {name = "Unicorn Leash", prices = {["default"] = 6.57}},
    ["rbxassetid://3570154347"] = {name = "Unicorn Plush", prices = {["default"] = 131.24}},
    ["rbxassetid://2408055086"] = {name = "Wooden Pogo", prices = {["default"] = 2.56}},
    ["rbxassetid://4155284126"] = {name = "Zombie Buffalo Plush", prices = {["default"] = 56.63}},
    ["rbxassetid://4880426741"] = {name = "Adventurer's Hood", prices = {["default"] = 7.86}},
    ["rbxassetid://4880426585"] = {name = "Adventurer's Sword", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048254"] = {name = "Amber Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973461"] = {name = "Angel Wings", prices = {["default"] = 1255.95}},
    ["rbxassetid://6380734633"] = {name = "Antenna", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972567"] = {name = "Aviators", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973554"] = {name = "Bat Wings", prices = {["default"] = 20.97}},
    ["rbxassetid://6380843886"] = {name = "Bee Hive", prices = {["default"] = 4.66}},
    ["rbxassetid://6380734557"] = {name = "Bee Wings", prices = {["default"] = 5.25}},
    ["rbxassetid://4849973352"] = {name = "Beret", prices = {["default"] = 2.1}},
    ["rbxassetid://5881347869"] = {name = "Bewitched Hat", prices = {["default"] = 6.22}},
    ["rbxassetid://5415514537"] = {name = "Black 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415514707"] = {name = "Black Boots", prices = {["default"] = 26.25}},
    ["rbxassetid://5415514845"] = {name = "Black Cozy Hood", prices = {["default"] = 7.88}},
    ["rbxassetid://5415515017"] = {name = "Black Designer Backpack", prices = {["default"] = 5.25}},
    ["rbxassetid://4849975075"] = {name = "Black Fedora", prices = {["default"] = 3.92}},
    ["rbxassetid://5415515284"] = {name = "Black Hightops", prices = {["default"] = 5.25}},
    ["rbxassetid://5415515507"] = {name = "Black Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426690"] = {name = "Black Scarf", prices = {["default"] = 18.17}},
    ["rbxassetid://5415515653"] = {name = "Black Sneakers", prices = {["default"] = 4.86}},
    ["rbxassetid://5444594385"] = {name = "Blue Butterfly Wings", prices = {["default"] = 13.13}},
    ["rbxassetid://4849980085"] = {name = "Blue Cat Ear Headphones", prices = {["default"] = 19.69}},
    ["rbxassetid://5415515800"] = {name = "Blue Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048365"] = {name = "Bone Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426624"] = {name = "Briefcase", prices = {["default"] = 2.1}},
    ["rbxassetid://6706595341"] = {name = "Bunny Ear Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978837"] = {name = "Buzz Off! Skateboard", prices = {["default"] = 3.94}},
    ["rbxassetid://5415516304"] = {name = "Cassette", prices = {["default"] = 3.83}},
    ["rbxassetid://4849975557"] = {name = "Chef Hat", prices = {["default"] = 12.74}},
    ["rbxassetid://6380734302"] = {name = "Cherry Earrings", prices = {["default"] = 3.62}},
    ["rbxassetid://6706591422"] = {name = "Chick Backpack", prices = {["default"] = 2.63}},
    ["rbxassetid://6706592723"] = {name = "Chick Hat", prices = {["default"] = 3.82}},
    ["rbxassetid://4849975633"] = {name = "Chicken Hat", prices = {["default"] = 12.78}},
    ["rbxassetid://4849972658"] = {name = "Clout Goggles", prices = {["default"] = 6.57}},
    ["rbxassetid://4849975702"] = {name = "Conductor Hat", prices = {["default"] = 7.18}},
    ["rbxassetid://4936545219"] = {name = "Cutlass", prices = {["default"] = 126.94}},
    ["rbxassetid://4849972740"] = {name = "Cyborg Shades", prices = {["default"] = 2.63}},
    ["rbxassetid://6404037745"] = {name = "Daisy Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7601648534"] = {name = "Eco Blue Reusable Bottle Backpack", prices = {["default"] = 11.82}},
    ["rbxassetid://7542826699"] = {name = "Eco Blue Solar Panel Backpack", prices = {["default"] = 2.37}},
    ["rbxassetid://7542810947"] = {name = "Eco Brown Branch Headphones", prices = {["default"] = 19.9}},
    ["rbxassetid://7542815049"] = {name = "Eco Brown Hiking Backpack", prices = {["default"] = 46.66}},
    ["rbxassetid://7542816175"] = {name = "Eco Green Leaf Afro", prices = {["default"] = 2.63}},
    ["rbxassetid://7542816369"] = {name = "Eco Green Leaf Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810810"] = {name = "Eco Orange Leaf Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542820583"] = {name = "Eco Orange Maple Cape", prices = {["default"] = 11.39}},
    ["rbxassetid://7542810709"] = {name = "Eco Orange Maple Earrings", prices = {["default"] = 2.63}},
    ["rbxassetid://7542817978"] = {name = "Eco Orange Maple Leaf Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://7542823324"] = {name = "Eco Orange Pumpkin Eyepatch", prices = {["default"] = 4.75}},
    ["rbxassetid://7542824283"] = {name = "Eco Orange Pumpkin Pie Wings", prices = {["default"] = 26.24}},
    ["rbxassetid://7542813412"] = {name = "Eco Red Cranberry Branch Wings", prices = {["default"] = 24.04}},
    ["rbxassetid://7542821672"] = {name = "Eco Red Mushroom Hood", prices = {["default"] = 3.44}},
    ["rbxassetid://6706593596"] = {name = "Egg Barrette", prices = {["default"] = 2.1}},
    ["rbxassetid://6706594347"] = {name = "Egg Glasses", prices = {["default"] = 4.2}},
    ["rbxassetid://4850383048"] = {name = "Elf Hat", prices = {["default"] = 91.69}},
    ["rbxassetid://4849976006"] = {name = "Explorer Hat", prices = {["default"] = 3.93}},
    ["rbxassetid://4933495463"] = {name = "Eyepatch", prices = {["default"] = 6.13}},
    ["rbxassetid://6060998776"] = {name = "Festive Tree Hat", prices = {["default"] = 6.57}},
    ["rbxassetid://4853278462"] = {name = "Firey Aura", prices = {["default"] = 2.63}},
    ["rbxassetid://4849979365"] = {name = "First Aid Bag", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976218"] = {name = "Flamenco Hat", prices = {["default"] = 8.45}},
    ["rbxassetid://6437127230"] = {name = "Flower Collar", prices = {["default"] = 3.92}},
    ["rbxassetid://6380734218"] = {name = "Flower Crown", prices = {["default"] = 7.86}},
    ["rbxassetid://5415517076"] = {name = "Flowery Hair Bow", prices = {["default"] = 2.63}},
    ["rbxassetid://5726048455"] = {name = "Forgotten Flower", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734014"] = {name = "Froggy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://6060998635"] = {name = "Fur Boots", prices = {["default"] = 9.19}},
    ["rbxassetid://5415517473"] = {name = "Gold Chain", prices = {["default"] = 85.63}},
    ["rbxassetid://5415517604"] = {name = "Gold Circle Glasses", prices = {["default"] = 12.79}},
    ["rbxassetid://5415517745"] = {name = "Gold Tiara", prices = {["default"] = 2.63}},
    ["rbxassetid://4849979471"] = {name = "Golden Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730894"] = {name = "Goth Shoes", prices = {["default"] = 99.95}},
    ["rbxassetid://4849976420"] = {name = "Green Lotus", prices = {["default"] = 4.68}},
    ["rbxassetid://7368039312"] = {name = "Growing Flower Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4489907389"] = {name = "Halo", prices = {["default"] = 1316.44}},
    ["rbxassetid://5444594659"] = {name = "Handheld", prices = {["default"] = 4.66}},
    ["rbxassetid://4849976512"] = {name = "Head Chef", prices = {["default"] = 213.67}},
    ["rbxassetid://5067924536"] = {name = "Head Tie", prices = {["default"] = 8.43}},
    ["rbxassetid://6404037642"] = {name = "Headband", prices = {["default"] = 5.25}},
    ["rbxassetid://4849979572"] = {name = "Headset", prices = {["default"] = 2.63}},
    ["rbxassetid://5415521592"] = {name = "Hoop Earrings", prices = {["default"] = 2.63}},
    ["rbxassetid://6060991420"] = {name = "Ice Crown", prices = {["default"] = 2.63}},
    ["rbxassetid://6060991330"] = {name = "Ice Earrings", prices = {["default"] = 2.24}},
    ["rbxassetid://6060991245"] = {name = "Ice Wings", prices = {["default"] = 2.61}},
    ["rbxassetid://4849973617"] = {name = "Jade Moth Wings", prices = {["default"] = 17.52}},
    ["rbxassetid://4849979214"] = {name = "Jeff's Nametag", prices = {["default"] = 46.6}},
    ["rbxassetid://5415517859"] = {name = "Jetpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924626"] = {name = "Kitsune Mask", prices = {["default"] = 9.19}},
    ["rbxassetid://4849973992"] = {name = "Lavender Scarf", prices = {["default"] = 2.24}},
    ["rbxassetid://6380730271"] = {name = "Leprechaun Hat", prices = {["default"] = 6.57}},
    ["rbxassetid://4853278902"] = {name = "Luggage", prices = {["default"] = 2.63}},
    ["rbxassetid://5067924890"] = {name = "Monkey King Crown", prices = {["default"] = 67.01}},
    ["rbxassetid://4849977086"] = {name = "Monocle", prices = {["default"] = 7.39}},
    ["rbxassetid://4849979887"] = {name = "Moon Tome", prices = {["default"] = 2.37}},
    ["rbxassetid://4849976759"] = {name = "Morion", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048545"] = {name = "Nautilus Shell Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976912"] = {name = "Ninja Headband", prices = {["default"] = 4.66}},
    ["rbxassetid://6404037449"] = {name = "Orange Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727237"] = {name = "Orange Glasses", prices = {["default"] = 2.63}},
    ["rbxassetid://4849977244"] = {name = "Party Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://5415523249"] = {name = "Pearl Necklace", prices = {["default"] = 2.63}},
    ["rbxassetid://6380727177"] = {name = "Picnic Basket", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518324"] = {name = "Pink 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518474"] = {name = "Pink Boots", prices = {["default"] = 7.44}},
    ["rbxassetid://5444594884"] = {name = "Pink Butterfly Wings", prices = {["default"] = 5.44}},
    ["rbxassetid://4849979637"] = {name = "Pink Cat Ear Headphones", prices = {["default"] = 77.47}},
    ["rbxassetid://5415518613"] = {name = "Pink Designer Backpack", prices = {["default"] = 3.4}},
    ["rbxassetid://4849972826"] = {name = "Pink Heart Glasses", prices = {["default"] = 74.33}},
    ["rbxassetid://5457768184"] = {name = "Pink Hightops", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518811"] = {name = "Pink Instant Camera", prices = {["default"] = 5.25}},
    ["rbxassetid://4849977427"] = {name = "Pink Lotus", prices = {["default"] = 2.1}},
    ["rbxassetid://5415520296"] = {name = "Pink Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977514"] = {name = "Pirate Hat", prices = {["default"] = 5.93}},
    ["rbxassetid://5444711861"] = {name = "Platinum Tiara", prices = {["default"] = 42}},
    ["rbxassetid://4849977607"] = {name = "Propeller Hat", prices = {["default"] = 91.69}},
    ["rbxassetid://4849972928"] = {name = "Purple Heart Glasses", prices = {["default"] = 5.25}},
    ["rbxassetid://6380727007"] = {name = "Purple Masquerade Mask", prices = {["default"] = 3.73}},
    ["rbxassetid://4849977695"] = {name = "Purple Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037362"] = {name = "Rain Boots", prices = {["default"] = 64.32}},
    ["rbxassetid://5415520831"] = {name = "Rain Hat", prices = {["default"] = 5.07}},
    ["rbxassetid://7498079214"] = {name = "RB Battles Trophy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977830"] = {name = "Red Beanie", prices = {["default"] = 2.1}},
    ["rbxassetid://6380847814"] = {name = "Red Masquerade Mask", prices = {["default"] = 3.84}},
    ["rbxassetid://5415520972"] = {name = "Red Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521183"] = {name = "Red Sneakers", prices = {["default"] = 2.63}},
    ["rbxassetid://4849973276"] = {name = "Reindeer Antlers", prices = {["default"] = 6.57}},
    ["rbxassetid://4933495361"] = {name = "Respectful Mustache", prices = {["default"] = 65.54}},
    ["rbxassetid://8151013513"] = {name = "RGB Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978102"] = {name = "Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495425"] = {name = "Ruff", prices = {["default"] = 56.44}},
    ["rbxassetid://4849978200"] = {name = "Sailor Cap", prices = {["default"] = 57.75}},
    ["rbxassetid://4850382817"] = {name = "Santa Hat", prices = {["default"] = 275.63}},
    ["rbxassetid://5881348094"] = {name = "Scythe", prices = {["default"] = 3.73}},
    ["rbxassetid://4853278537"] = {name = "Shadow Aura", prices = {["default"] = 39.37}},
    ["rbxassetid://4849980009"] = {name = "Shadow Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973681"] = {name = "Shadow Wings", prices = {["default"] = 144.72}},
    ["rbxassetid://4849972466"] = {name = "Shark Fin", prices = {["default"] = 2.63}},
    ["rbxassetid://4849973100"] = {name = "Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521379"] = {name = "Silver Chain", prices = {["default"] = 2.57}},
    ["rbxassetid://4849974099"] = {name = "Skeleton Shell", prices = {["default"] = 2.63}},
    ["rbxassetid://4849974434"] = {name = "Spike Collar", prices = {["default"] = 14.32}},
    ["rbxassetid://6380723429"] = {name = "Strawberry Hat", prices = {["default"] = 65.63}},
    ["rbxassetid://4849975162"] = {name = "Sun Tome", prices = {["default"] = 3.73}},
    ["rbxassetid://4849976090"] = {name = "Sushi Skateboard", prices = {["default"] = 23.63}},
    ["rbxassetid://4849978035"] = {name = "Watermelon Backpack", prices = {["default"] = 6.55}},
    ["rbxassetid://5415522308"] = {name = "White Designer Backpack", prices = {["default"] = 7.76}},
    ["rbxassetid://5415522533"] = {name = "White Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979019"] = {name = "Windup Key", prices = {["default"] = 24.43}},
    ["rbxassetid://4849977314"] = {name = "Witch Hat", prices = {["default"] = 3.45}},
    ["rbxassetid://4849978608"] = {name = "Wizard Hat", prices = {["default"] = 2.61}},
    ["rbxassetid://5415522859"] = {name = "Yellow Designer Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5415522973"] = {name = "Yellow Instant Camera", prices = {["default"] = 2.1}},
    ["rbxassetid://5415523115"] = {name = "Yellow Sneakers", prices = {["default"] = 2.63}},
    ["rbxassetid://2761277758"] = {name = "Airplane Stroller", prices = {["default"] = 140.26}},
    ["rbxassetid://2657667120"] = {name = "Baby Basket Stroller", prices = {["default"] = 98.4}},
    ["rbxassetid://2761277454"] = {name = "Balloon Stroller", prices = {["default"] = 3.19}},
    ["rbxassetid://3009779202"] = {name = "Banana Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046286"] = {name = "Bunny Stroller", prices = {["default"] = 43.17}},
    ["rbxassetid://3009779260"] = {name = "Cannon Stroller", prices = {["default"] = 6.18}},
    ["rbxassetid://3269748269"] = {name = "Car Stroller", prices = {["default"] = 2.63}},
    ["rbxassetid://6475616233"] = {name = "Catapult Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248341"] = {name = "Cauldron Stroller", prices = {["default"] = 6.4}},
    ["rbxassetid://2408051111"] = {name = "Cradle Stroller", prices = {["default"] = 68.25}},
    ["rbxassetid://4361544460"] = {name = "Crate Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3486905775"] = {name = "Dog House Stroller", prices = {["default"] = 3.83}},
    ["rbxassetid://1408016951"] = {name = "Double Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1406692267"] = {name = "Droplet Stroller", prices = {["default"] = 2.63}},
    ["rbxassetid://2761277656"] = {name = "Duck Stroller", prices = {["default"] = 73.5}},
    ["rbxassetid://3082046174"] = {name = "Easter Egg Stroller", prices = {["default"] = 45.03}},
    ["rbxassetid://2761277703"] = {name = "Egg Stroller", prices = {["default"] = 1997.71}},
    ["rbxassetid://4822522123"] = {name = "Flower Stroller", prices = {["default"] = 32.64}},
    ["rbxassetid://3009779395"] = {name = "French Fries Stroller", prices = {["default"] = 6.57}},
    ["rbxassetid://3082046130"] = {name = "Half Egg Stroller", prices = {["default"] = 39.38}},
    ["rbxassetid://3486906113"] = {name = "Hatched Egg Stroller", prices = {["default"] = 2.63}},
    ["rbxassetid://2848462165"] = {name = "Heart Stroller", prices = {["default"] = 249.25}},
    ["rbxassetid://6475613319"] = {name = "High Heel Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6967530077"] = {name = "Hover Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670917"] = {name = "Ice Cream Stroller", prices = {["default"] = 14.84}},
    ["rbxassetid://3486906383"] = {name = "Kangaroo Stroller", prices = {["default"] = 5.16}},
    ["rbxassetid://7368046225"] = {name = "Lunar Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936630605"] = {name = "Magic Carpet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936629525"] = {name = "Magic Moon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6309085791"] = {name = "Palanquin Stroller", prices = {["default"] = 2.63}},
    ["rbxassetid://6936631399"] = {name = "Pelican Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670918"] = {name = "Pizza Stroller", prices = {["default"] = 13.71}},
    ["rbxassetid://3009779443"] = {name = "Popsicle Stroller", prices = {["default"] = 10.49}},
    ["rbxassetid://6936628317"] = {name = "Princess Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://5882036757"] = {name = "Pumpkin Stroller", prices = {["default"] = 3.84}},
    ["rbxassetid://2408052388"] = {name = "Quad Stroller", prices = {["default"] = 164.07}},
    ["rbxassetid://6710108407"] = {name = "Rainbow Stroller", prices = {["default"] = 44.63}},
    ["rbxassetid://4470748252"] = {name = "Reindeer Stroller", prices = {["default"] = 11.7}},
    ["rbxassetid://8526099597"] = {name = "RGB Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2981204560"] = {name = "Rocket Ship Stroller", prices = {["default"] = 2.63}},
    ["rbxassetid://13986982302"] = {name = "Shopping Cart Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936628967"] = {name = "Teacup Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2982964426"] = {name = "Throne Stroller", prices = {["default"] = 2.63}},
    ["rbxassetid://2657671637"] = {name = "Trike Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544584"] = {name = "Triple Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277803"] = {name = "Unicorn Stroller", prices = {["default"] = 77.44}},
    ["rbxassetid://2466291803"] = {name = "Vampire Stroller", prices = {["default"] = 103.69}},
    ["rbxassetid://3066606234"] = {name = "Wheelbarrow Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://113061955717247"] = {name = "Admin Abuse Box", prices = {["default"] = 2.1}},
    ["rbxassetid://5888839551"] = {name = "Bat Box", prices = {["default"] = 94.5}},
    ["rbxassetid://4510471983"] = {name = "Golden Gift", prices = {["default"] = 1044.53}},
    ["rbxassetid://5057100696"] = {name = "Monkey Box", prices = {["default"] = 197.78}},
    ["rbxassetid://6240246974"] = {name = "Ox Box", prices = {["default"] = 9.19}},
    ["rbxassetid://5067925110"] = {name = "Premium Monkey Box", prices = {["default"] = 1188.65}},
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