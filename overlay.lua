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
    ["rbxassetid://137637490639925"] = {name = "Royal Mistletroll", prices = {["default"] = 917.44, ["Fly|Ride"] = 1689.19, ["Neon"] = 6765.73, ["Neon|Fly|Ride"] = 5381.25}},
    ["rbxassetid://140355753768438"] = {name = "Moonbeam Peacock", prices = {["default"] = 433.13, ["Fly|Ride"] = 544.69, ["Neon"] = 2098.6, ["Neon|Fly|Ride"] = 1706.25, ["Mega"] = 12078.33, ["Mega|Fly|Ride"] = 7083.12}},
    ["rbxassetid://18117855573"] = {name = "Balloon Unicorn", prices = {["Fly|Ride"] = 4961.25, ["Neon|Fly|Ride"] = 24369.01, ["Mega|Fly|Ride"] = 70838.43}},
    ["rbxassetid://75782719698946"] = {name = "Red Dutch Guinea Pig", prices = {["default"] = 161.44, ["Fly|Ride"] = 213.12, ["Neon"] = 1049.84, ["Neon|Ride"] = 976.52, ["Neon|Fly|Ride"] = 984.38, ["Mega|Fly|Ride"] = 4495.32}},
    ["rbxassetid://5067924142"] = {name = "Albino Monkey", prices = {["default"] = 548.63, ["Fly"] = 850.07, ["Fly|Ride"] = 565.11, ["Neon|Fly|Ride"] = 1745.63, ["Mega|Fly|Ride"] = 6517.83}},
    ["rbxassetid://108312620331321"] = {name = "Villain Gibbon", prices = {["default"] = 8.12, ["Fly|Ride"] = 105, ["Neon"] = 72.19, ["Neon|Fly"] = 283.73, ["Neon|Ride"] = 63, ["Neon|Fly|Ride"] = 404.25, ["Mega"] = 352.79, ["Mega|Ride"] = 354.92, ["Mega|Fly|Ride"] = 403.79}},
    ["rbxassetid://17255958862"] = {name = "Alicorn", prices = {["default"] = 4.28, ["Fly|Ride"] = 66.75, ["Neon"] = 25.58, ["Neon|Fly"] = 70.14, ["Neon|Ride"] = 56.8, ["Neon|Fly|Ride"] = 128.63, ["Mega"] = 184.9, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 298.37}},
    ["rbxassetid://90170598608675"] = {name = "Moonbeam Butterfly", prices = {["default"] = 116.94, ["Fly|Ride"] = 208.69, ["Neon"] = 532.82, ["Neon|Ride"] = 492.19, ["Neon|Fly|Ride"] = 669.43, ["Mega"] = 1586.82, ["Mega|Ride"] = 2492.44, ["Mega|Fly|Ride"] = 2770.14}},
    ["rbxassetid://7126722445"] = {name = "Goldhorn", prices = {["default"] = 40.74, ["Fly|Ride"] = 105, ["Neon"] = 257.62, ["Neon|Ride"] = 198.72, ["Neon|Fly|Ride"] = 301.88, ["Mega"] = 1417.48, ["Mega|Ride"] = 1128.12, ["Mega|Fly|Ride"] = 918.74}},
    ["rbxassetid://13186021971"] = {name = "Cuddly Candle", prices = {["default"] = 23.63, ["Fly|Ride"] = 75.93, ["Neon"] = 210.24, ["Neon|Ride"] = 113.71, ["Neon|Fly|Ride"] = 184.9, ["Mega|Ride"] = 483.19, ["Mega|Fly|Ride"] = 777.82}},
    ["rbxassetid://14146196672"] = {name = "Gargoyle", prices = {["default"] = 54.49, ["Fly|Ride"] = 162.74, ["Neon"] = 341.84, ["Neon|Ride"] = 317.72, ["Neon|Fly|Ride"] = 425.25, ["Mega|Ride"] = 1062.58, ["Mega|Fly|Ride"] = 1275.1}},
    ["rbxassetid://129762233626342"] = {name = "Royal Moon Egg", prices = {["default"] = 73.4}},
    ["rbxassetid://89693546199400"] = {name = "Cupid Dragon", prices = {["default"] = 334.85, ["Fly|Ride"] = 380.63, ["Neon"] = 1266.61, ["Neon|Ride"] = 1048.69, ["Neon|Fly|Ride"] = 1155, ["Mega|Fly|Ride"] = 5100.36}},
    ["rbxassetid://8665606875"] = {name = "Dancing Dragon", prices = {["default"] = 124.69, ["Fly|Ride"] = 169.32, ["Neon|Fly"] = 628.26, ["Neon|Ride"] = 573.03, ["Neon|Fly|Ride"] = 631.78, ["Mega"] = 4312.63, ["Mega|Fly|Ride"] = 2467.5}},
    ["rbxassetid://110411427278536"] = {name = "Huntsman Robin", prices = {["default"] = 3.56, ["Fly|Ride"] = 131.25, ["Neon"] = 21.26, ["Neon|Ride"] = 56.35, ["Neon|Fly|Ride"] = 202.73, ["Mega"] = 150.94, ["Mega|Fly"] = 393.75, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 253.65}},
    ["rbxassetid://10925517718"] = {name = "Lava Dragon", prices = {["default"] = 170.63, ["Fly|Ride"] = 223.13, ["Neon|Ride"] = 956.32, ["Neon|Fly|Ride"] = 693, ["Mega|Fly|Ride"] = 3149.9}},
    ["rbxassetid://4797806482"] = {name = "Diamond Griffin", prices = {["default"] = 2.63, ["Fly"] = 31.88, ["Fly|Ride"] = 42.52, ["Neon"] = 30.32, ["Neon|Fly"] = 127.52, ["Neon|Ride"] = 53.13, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 184.9, ["Mega|Ride"] = 322.51, ["Mega|Fly|Ride"] = 422.63}},
    ["rbxassetid://122648024705835"] = {name = "Scarebear", prices = {["default"] = 84, ["Fly|Ride"] = 236.79, ["Neon"] = 262.5, ["Neon|Ride"] = 368.73, ["Neon|Fly|Ride"] = 425.04, ["Mega"] = 1700.13, ["Mega|Ride"] = 1421.12, ["Mega|Fly|Ride"] = 1391.25}},
    ["rbxassetid://13104102169"] = {name = "Danger Egg", prices = {["default"] = 40.19}},
    ["rbxassetid://133163961974577"] = {name = "2D Doggy", prices = {["default"] = 76.12, ["Fly|Ride"] = 279.47, ["Neon"] = 577.5, ["Neon|Fly|Ride"] = 779.94, ["Mega"] = 2125.16, ["Mega|Fly|Ride"] = 2125.16}},
    ["rbxassetid://126071806166898"] = {name = "Evil Chick", prices = {["default"] = 19.68, ["Fly|Ride"] = 355.69, ["Neon"] = 321.57, ["Neon|Ride"] = 209.99, ["Neon|Fly|Ride"] = 429.19, ["Mega"] = 2778.03, ["Mega|Ride"] = 708.75, ["Mega|Fly|Ride"] = 708.75}},
    ["rbxassetid://5721843247"] = {name = "Dodo", prices = {["default"] = 39.38, ["Fly|Ride"] = 103.67, ["Neon"] = 211.46, ["Neon|Ride"] = 220.49, ["Neon|Fly|Ride"] = 262.48, ["Mega"] = 1690.98, ["Mega|Ride"] = 1020.08, ["Mega|Fly|Ride"] = 941.07}},
    ["rbxassetid://119640582603552"] = {name = "Violet Butterfly", prices = {["default"] = 46.76, ["Fly|Ride"] = 283.73, ["Neon"] = 212.52, ["Neon|Ride"] = 384.58, ["Neon|Fly|Ride"] = 467.25, ["Mega"] = 1967.44, ["Mega|Ride"] = 1700.13, ["Mega|Fly|Ride"] = 1448.2}},
    ["rbxassetid://16088264958"] = {name = "Volcanic Rhino", prices = {["default"] = 36.14, ["Fly|Ride"] = 142.4, ["Neon"] = 120.75, ["Neon|Ride"] = 211.46, ["Neon|Fly|Ride"] = 253.97, ["Mega"] = 1207.92, ["Mega|Fly|Ride"] = 1023.75}},
    ["rbxassetid://75251818654427"] = {name = "Apple Owl", prices = {["default"] = 38.07, ["Fly|Ride"] = 178.53, ["Neon"] = 163.65, ["Neon|Fly"] = 234.85, ["Neon|Ride"] = 212.79, ["Neon|Fly|Ride"] = 262.49, ["Mega|Ride"] = 1124.82, ["Mega|Fly|Ride"] = 1010.63}},
    ["rbxassetid://3181727433"] = {name = "Dragon", prices = {["default"] = 7.28, ["Fly|Ride"] = 42.51, ["Neon"] = 36.74, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 54.21, ["Neon|Fly|Ride"] = 90.57, ["Mega"] = 170.63, ["Mega|Fly"] = 27000.57, ["Mega|Ride"] = 182.44, ["Mega|Fly|Ride"] = 247.1}},
    ["rbxassetid://121496682360324"] = {name = "Sugar Axolotl", prices = {["default"] = 393.75, ["Fly|Ride"] = 510.57, ["Neon|Ride"] = 1575, ["Neon|Fly|Ride"] = 1964.82, ["Mega"] = 10625.72, ["Mega|Fly|Ride"] = 9179.54}},
    ["rbxassetid://11694854226"] = {name = "Shetland Pony Light Brown", prices = {["default"] = 9.87, ["Fly|Ride"] = 65.63, ["Neon"] = 216.99, ["Neon|Ride"] = 129.94, ["Mega|Ride"] = 807.57, ["Mega|Fly|Ride"] = 927.64}},
    ["rbxassetid://4797806957"] = {name = "Golden Unicorn", prices = {["default"] = 6.39, ["Fly|Ride"] = 46.65, ["Neon"] = 52.49, ["Neon|Ride"] = 83.95, ["Neon|Fly|Ride"] = 125.98, ["Mega|Ride"] = 315.93, ["Mega|Fly|Ride"] = 510.04}},
    ["rbxassetid://110822620060051"] = {name = "Frost Phoenix", prices = {["default"] = 84.96, ["Fly"] = 142.4, ["Fly|Ride"] = 105, ["Neon"] = 378.3, ["Neon|Fly"] = 326.23, ["Neon|Ride"] = 378.3, ["Neon|Fly|Ride"] = 399, ["Mega"] = 6400.31, ["Mega|Ride"] = 5832.75, ["Mega|Fly|Ride"] = 2098.69}},
    ["rbxassetid://13894724323"] = {name = "Billy Goat", prices = {["default"] = 11.61, ["Fly|Ride"] = 75.95, ["Neon"] = 96.42, ["Neon|Ride"] = 112.88, ["Neon|Fly|Ride"] = 184.9, ["Mega"] = 708.75, ["Mega|Ride"] = 724.71}},
    ["rbxassetid://123037843357105"] = {name = "Glormy Leo", prices = {["default"] = 209.3, ["Fly|Ride"] = 291.38, ["Neon"] = 742.75, ["Neon|Ride"] = 774.38, ["Neon|Fly|Ride"] = 729.96, ["Mega"] = 3257.86, ["Mega|Fly|Ride"] = 2919.96}},
    ["rbxassetid://12479078933"] = {name = "Southeast Asia Egg", prices = {["default"] = 23.6}},
    ["rbxassetid://122739780018633"] = {name = "Quetzalcoatl", prices = {["default"] = 3.68, ["Fly"] = 32.81, ["Fly|Ride"] = 55.68, ["Neon"] = 26.16, ["Neon|Fly"] = 142.4, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 105, ["Mega"] = 141.41, ["Mega|Fly"] = 212.52, ["Mega|Ride"] = 135.19, ["Mega|Fly|Ride"] = 288.74}},
    ["rbxassetid://70953296065239"] = {name = "Frostbite Bear", prices = {["default"] = 892.49, ["Fly|Ride"] = 938.44, ["Neon"] = 6374.38, ["Neon|Ride"] = 4817.72, ["Neon|Fly|Ride"] = 4746.52, ["Mega|Ride"] = 54352.46, ["Mega|Fly|Ride"] = 17001.15}},
    ["rbxassetid://14978701948"] = {name = "Scarecrow Crow", prices = {["default"] = 14.72, ["Fly|Ride"] = 91.88, ["Neon"] = 157.27, ["Neon|Ride"] = 150.9, ["Neon|Fly|Ride"] = 181.13, ["Mega"] = 1009.32, ["Mega|Ride"] = 1088.09, ["Mega|Fly|Ride"] = 616.88}},
    ["rbxassetid://11191341630"] = {name = "Jousting Horse", prices = {["default"] = 157.5, ["Fly|Ride"] = 283.73, ["Neon"] = 830.82, ["Neon|Ride"] = 787.5, ["Neon|Fly|Ride"] = 1030.31, ["Mega|Ride"] = 6074.25, ["Mega|Fly|Ride"] = 4028.13}},
    ["rbxassetid://76801905892592"] = {name = "Royal Aztec Egg", prices = {["default"] = 38.07}},
    ["rbxassetid://98801943598121"] = {name = "Priceless Shrimp", prices = {["default"] = 14.44, ["Fly|Ride"] = 145.69, ["Neon"] = 90.63, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 340.04, ["Mega"] = 241.58, ["Mega|Ride"] = 566.19, ["Mega|Fly|Ride"] = 597.9}},
    ["rbxassetid://95214789806437"] = {name = "Aztec Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://18515755354"] = {name = "Cheetah", prices = {["default"] = 112.35, ["Fly|Ride"] = 270.97, ["Neon"] = 483.28, ["Neon|Ride"] = 420, ["Neon|Fly|Ride"] = 505.8, ["Mega"] = 2125.16, ["Mega|Fly|Ride"] = 1998.56}},
    ["rbxassetid://18117855114"] = {name = "Corn Doggo", prices = {["default"] = 103.3, ["Fly|Ride"] = 354.92, ["Neon"] = 387.19, ["Neon|Fly"] = 567.42, ["Neon|Ride"] = 434.78, ["Neon|Fly|Ride"] = 493.5, ["Mega|Ride"] = 1378.13, ["Mega|Fly|Ride"] = 1240.32}},
    ["rbxassetid://8972175010"] = {name = "Woodland Egg", prices = {["default"] = 44.63}},
    ["rbxassetid://3710823011"] = {name = "Golden Penguin", prices = {["default"] = 79.06, ["Fly"] = 112.65, ["Fly|Ride"] = 64.32, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 324.18, ["Mega"] = 4250.3, ["Mega|Fly|Ride"] = 1246.88}},
    ["rbxassetid://136490701345923"] = {name = "Glormy Crab", prices = {["default"] = 6.57, ["Fly|Ride"] = 206.54, ["Neon"] = 36.14, ["Neon|Fly"] = 223.13, ["Neon|Ride"] = 126, ["Neon|Fly|Ride"] = 239.09, ["Mega"] = 170.62, ["Mega|Fly"] = 362.37, ["Mega|Ride"] = 274.16, ["Mega|Fly|Ride"] = 656.24}},
    ["rbxassetid://14782580581"] = {name = "Vampire Dragon", prices = {["default"] = 570.84, ["Fly|Ride"] = 527.63, ["Neon|Fly"] = 3825.27, ["Neon|Ride"] = 1846.49, ["Neon|Fly|Ride"] = 1755.51, ["Mega|Ride"] = 14876.02, ["Mega|Fly|Ride"] = 7481.25}},
    ["rbxassetid://88405494856204"] = {name = "Solaris", prices = {["default"] = 90.45, ["Fly"] = 483.19, ["Fly|Ride"] = 168.7, ["Neon"] = 479.07, ["Neon|Ride"] = 556.5, ["Neon|Fly|Ride"] = 525, ["Mega|Ride"] = 2550.19, ["Mega|Fly|Ride"] = 2562.94}},
    ["rbxassetid://84468510887759"] = {name = "Orchid Butterfly", prices = {["default"] = 4250.3, ["Fly|Ride"] = 3892.22, ["Neon|Fly|Ride"] = 14874.95}},
    ["rbxassetid://11109286837"] = {name = "Lava Wolf", prices = {["default"] = 49.98, ["Fly|Ride"] = 137.82, ["Neon"] = 440.98, ["Neon|Ride"] = 314.14, ["Neon|Fly|Ride"] = 472.5, ["Mega"] = 1910.51, ["Mega|Ride"] = 1181.25, ["Mega|Fly|Ride"] = 1647.19}},
    ["rbxassetid://12403863809"] = {name = "Albino Gorilla", prices = {["default"] = 71.21, ["Fly|Ride"] = 142.4, ["Neon"] = 575.75, ["Neon|Ride"] = 427.88, ["Neon|Fly|Ride"] = 426.05, ["Mega"] = 6234.12, ["Mega|Ride"] = 2388.75, ["Mega|Fly|Ride"] = 1864.01}},
    ["rbxassetid://6060988121"] = {name = "Snow Owl", prices = {["default"] = 31.66, ["Fly|Ride"] = 85.32, ["Neon"] = 130.1, ["Neon|Fly"] = 289.98, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 189.91, ["Mega"] = 992.45, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 577.5}},
    ["rbxassetid://112630556645658"] = {name = "Moon Egg", prices = {["default"] = 6.39}},
    ["rbxassetid://10357473556"] = {name = "Golden Chow-Chow", prices = {["default"] = 45.83, ["Fly|Ride"] = 80.96, ["Neon|Ride"] = 283.73, ["Neon|Fly|Ride"] = 425.04, ["Mega|Ride"] = 1288.77, ["Mega|Fly|Ride"] = 1513.12}},
    ["rbxassetid://5721843384"] = {name = "Fossil Egg", prices = {["default"] = 43.32}},
    ["rbxassetid://92775688228060"] = {name = "Papa Moose", prices = {["default"] = 282.19, ["Fly|Ride"] = 318.93, ["Neon|Ride"] = 1102.97, ["Neon|Fly|Ride"] = 1100.84, ["Mega|Fly|Ride"] = 4581.82}},
    ["rbxassetid://12479991588"] = {name = "Frost Unicorn", prices = {["default"] = 635.23, ["Fly|Ride"] = 783.57, ["Neon"] = 2625, ["Neon|Fly|Ride"] = 2625, ["Mega|Fly|Ride"] = 10220.25}},
    ["rbxassetid://9661880325"] = {name = "Zodiac Minion Egg", prices = {["default"] = 6.56}},
    ["rbxassetid://7126719832"] = {name = "Phoenix", prices = {["default"] = 26.16, ["Fly|Ride"] = 70.79, ["Neon"] = 225.28, ["Neon|Ride"] = 129.94, ["Neon|Fly|Ride"] = 199.17, ["Mega"] = 2125.16, ["Mega|Ride"] = 1159.54, ["Mega|Fly|Ride"] = 761.24}},
    ["rbxassetid://119386690822810"] = {name = "Royal Fairytale Egg", prices = {["default"] = 20.13}},
    ["rbxassetid://4440866299"] = {name = "Crow", prices = {["default"] = 10625.72, ["Fly|Ride"] = 4528.13, ["Neon|Ride"] = 17721.35, ["Neon|Fly|Ride"] = 10827.6, ["Mega|Fly|Ride"] = 43481.96}},
    ["rbxassetid://4797806531"] = {name = "Diamond Unicorn", prices = {["default"] = 8.63, ["Fly|Ride"] = 55.86, ["Neon"] = 85.01, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 221.82, ["Mega"] = 462.61, ["Mega|Ride"] = 490.88, ["Mega|Fly|Ride"] = 598.23}},
    ["rbxassetid://88817325500927"] = {name = "Kraken", prices = {["default"] = 13.02, ["Neon"] = 71.21, ["Neon|Ride"] = 122.07, ["Neon|Fly|Ride"] = 105, ["Mega"] = 742.75, ["Mega|Ride"] = 823.71, ["Mega|Fly|Ride"] = 992.45}},
    ["rbxassetid://9490243442"] = {name = "Diamond King Penguin", prices = {["default"] = 65.26, ["Fly|Ride"] = 91.4, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 498.75, ["Mega"] = 4250.3, ["Mega|Fly|Ride"] = 1771.91}},
    ["rbxassetid://107787284008278"] = {name = "Primal Kaijunior", prices = {["default"] = 7.6, ["Fly|Ride"] = 61.69, ["Neon"] = 56.25, ["Neon|Ride"] = 148.32, ["Neon|Fly|Ride"] = 161.86, ["Mega"] = 1417.48, ["Mega|Ride"] = 721.88, ["Mega|Fly|Ride"] = 813.75}},
    ["rbxassetid://4506837037"] = {name = "Arctic Reindeer", prices = {["default"] = 2053.51, ["Fly|Ride"] = 1614.38, ["Neon|Fly|Ride"] = 3150, ["Mega|Fly|Ride"] = 12468.75}},
    ["rbxassetid://4184878149"] = {name = "Bat Dragon", prices = {["default"] = 35419.75, ["Fly|Ride"] = 27300, ["Neon|Ride"] = 65625, ["Neon|Fly|Ride"] = 56437.5, ["Mega"] = 210000, ["Mega|Fly|Ride"] = 183748.69}},
    ["rbxassetid://118641789458122"] = {name = "Gilded Snake", prices = {["default"] = 21, ["Fly|Ride"] = 125.4, ["Neon"] = 283.73, ["Neon|Ride"] = 208.69, ["Neon|Fly|Ride"] = 567.42, ["Mega"] = 992.45, ["Mega|Ride"] = 1141.88, ["Mega|Fly|Ride"] = 1386.6}},
    ["rbxassetid://71844856693163"] = {name = "Purrowl", prices = {["default"] = 2.92, ["Fly|Ride"] = 161.44, ["Neon"] = 19.49, ["Neon|Fly"] = 57.39, ["Neon|Ride"] = 58.7, ["Neon|Fly|Ride"] = 157.49, ["Mega"] = 129.94, ["Mega|Fly"] = 308.02, ["Mega|Ride"] = 181.13, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://7195311687"] = {name = "Mythic Egg", prices = {["default"] = 22.32}},
    ["rbxassetid://102330087609546"] = {name = "Fire Mare", prices = {["default"] = 7.17, ["Fly|Ride"] = 105, ["Neon"] = 58.46, ["Neon|Ride"] = 116.81, ["Neon|Fly|Ride"] = 212.52, ["Mega"] = 425.04, ["Mega|Ride"] = 420.8, ["Mega|Fly|Ride"] = 688.56}},
    ["rbxassetid://16659215347"] = {name = "Candyfloss Chick", prices = {["default"] = 779.94, ["Fly|Ride"] = 810.76, ["Neon"] = 2762.7, ["Neon|Ride"] = 2805.21, ["Neon|Fly|Ride"] = 2625, ["Mega|Fly|Ride"] = 9493.02}},
    ["rbxassetid://9281950769"] = {name = "Sugar Glider", prices = {["default"] = 787.4, ["Fly|Ride"] = 984.38, ["Neon"] = 4108.98, ["Neon|Ride"] = 3270.99, ["Neon|Fly|Ride"] = 3675, ["Mega|Fly|Ride"] = 11618.16}},
    ["rbxassetid://15485137935"] = {name = "Fleur De Ice", prices = {["default"] = 12.56, ["Fly|Ride"] = 72.17, ["Neon"] = 78.75, ["Neon|Ride"] = 100.91, ["Neon|Fly|Ride"] = 161.21, ["Mega"] = 1209.72, ["Mega|Ride"] = 481.69, ["Mega|Fly|Ride"] = 558.93}},
    ["rbxassetid://6498256269"] = {name = "Ocean Egg", prices = {["default"] = 23.36}},
    ["rbxassetid://8704877940"] = {name = "Lavender Dragon", prices = {["default"] = 66.85, ["Fly|Ride"] = 113.71, ["Neon"] = 598.06, ["Neon|Ride"] = 488.79, ["Neon|Fly|Ride"] = 374.07, ["Mega"] = 19687.5, ["Mega|Ride"] = 2080.53, ["Mega|Fly|Ride"] = 2098.6}},
    ["rbxassetid://13685038182"] = {name = "Leviathan", prices = {["default"] = 78.74, ["Fly|Ride"] = 212.52, ["Neon"] = 450.19, ["Neon|Ride"] = 386.78, ["Neon|Fly|Ride"] = 425.04, ["Mega"] = 1409.47, ["Mega|Fly|Ride"] = 1932.54}},
    ["rbxassetid://4797806358"] = {name = "Diamond Dragon", prices = {["default"] = 4.26, ["Fly|Ride"] = 51.48, ["Neon"] = 37.2, ["Neon|Fly"] = 524.98, ["Neon|Ride"] = 68.01, ["Neon|Fly|Ride"] = 161.86, ["Mega|Fly|Ride"] = 660.71}},
    ["rbxassetid://5862774327"] = {name = "Cerberus", prices = {["default"] = 144.38, ["Fly|Ride"] = 244.36, ["Neon"] = 606.71, ["Neon|Ride"] = 576.19, ["Neon|Fly|Ride"] = 590.63, ["Mega"] = 5100.36, ["Mega|Fly|Ride"] = 2493.74}},
    ["rbxassetid://74012786571707"] = {name = "Three Blind Mice", prices = {["default"] = 4.04, ["Fly|Ride"] = 656.25, ["Neon"] = 30.82, ["Neon|Fly"] = 170.02, ["Neon|Ride"] = 142.4, ["Neon|Fly|Ride"] = 326.8, ["Mega"] = 191.62, ["Mega|Fly"] = 337.92, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 418.68}},
    ["rbxassetid://15931348363"] = {name = "Criosphinx", prices = {["default"] = 15.75, ["Fly"] = 63.56, ["Fly|Ride"] = 77.31, ["Neon"] = 128.63, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 666.25, ["Mega|Ride"] = 822.45, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://118278167134251"] = {name = "Influencer Gibbon", prices = {["default"] = 38.27, ["Fly|Ride"] = 156.19, ["Neon"] = 210.24, ["Neon|Ride"] = 223.13, ["Mega"] = 918.75, ["Mega|Ride"] = 1161.57, ["Mega|Fly|Ride"] = 637.55}},
    ["rbxassetid://17059982206"] = {name = "Dimorphodon", prices = {["default"] = 13.13, ["Fly|Ride"] = 70.79, ["Neon"] = 91.88, ["Neon|Ride"] = 116.94, ["Neon|Fly|Ride"] = 142.4, ["Mega|Fly|Ride"] = 1115.63}},
    ["rbxassetid://119212313534429"] = {name = "Giant Panda", prices = {["default"] = 7084.17, ["Fly|Ride"] = 5643.75, ["Neon"] = 35419.75, ["Neon|Ride"] = 24937.5, ["Neon|Fly|Ride"] = 25076.69}},
    ["rbxassetid://6060998707"] = {name = "Frost Fury", prices = {["default"] = 223.13, ["Fly|Ride"] = 283.05, ["Neon"] = 637.55, ["Neon|Fly|Ride"] = 558.6, ["Mega|Fly|Ride"] = 1909.69}},
    ["rbxassetid://88882779021298"] = {name = "Kitty Bat", prices = {["default"] = 52.5, ["Fly|Ride"] = 191.27, ["Neon"] = 156.18, ["Neon|Fly"] = 322.6, ["Neon|Ride"] = 159.06, ["Neon|Fly|Ride"] = 275.63, ["Mega"] = 459.25, ["Mega|Fly"] = 645, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 579}},
    ["rbxassetid://16441372760"] = {name = "Diamond Mahi Mahi", prices = {["default"] = 2.1, ["Fly|Ride"] = 52.49, ["Neon"] = 24.91, ["Neon|Fly"] = 70.14, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 499.8, ["Mega|Ride"] = 330.75, ["Mega|Fly|Ride"] = 355.98}},
    ["rbxassetid://3199974169"] = {name = "Royal Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://84714602656867"] = {name = "Slimingo", prices = {["default"] = 63, ["Fly|Ride"] = 208.04, ["Neon"] = 223.13, ["Neon|Fly"] = 440.98, ["Neon|Ride"] = 258.58, ["Neon|Fly|Ride"] = 387.18, ["Mega"] = 557.52, ["Mega|Ride"] = 708.75, ["Mega|Fly|Ride"] = 692.24}},
    ["rbxassetid://3409443710"] = {name = "Giraffe", prices = {["default"] = 18134.92, ["Fly|Ride"] = 12600, ["Neon|Fly|Ride"] = 27562.5, ["Mega|Fly|Ride"] = 113341.27}},
    ["rbxassetid://121215031043780"] = {name = "Velocirooster", prices = {["default"] = 274.32, ["Fly|Ride"] = 459.38, ["Neon"] = 1519.89, ["Neon|Ride"] = 1413.23, ["Neon|Fly|Ride"] = 1615.13, ["Mega|Fly|Ride"] = 7225.5}},
    ["rbxassetid://5067925034"] = {name = "Ninja Monkey", prices = {["default"] = 57.39, ["Fly|Ride"] = 98.42, ["Neon"] = 403.79, ["Neon|Ride"] = 328.11, ["Neon|Fly|Ride"] = 262.5, ["Mega|Fly|Ride"] = 3081.48}},
    ["rbxassetid://10618035564"] = {name = "Baku", prices = {["default"] = 9.98, ["Fly|Ride"] = 72.51, ["Neon"] = 67.47, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 155.92, ["Mega"] = 393.75, ["Mega|Ride"] = 397.42, ["Mega|Fly|Ride"] = 635.43}},
    ["rbxassetid://13665641282"] = {name = "Shark Puppy", prices = {["default"] = 392.44, ["Fly|Ride"] = 483.38, ["Neon"] = 1677.45, ["Neon|Ride"] = 1376.75, ["Neon|Fly|Ride"] = 1575, ["Mega|Fly|Ride"] = 5098.23}},
    ["rbxassetid://119447343321908"] = {name = "Tealwood Monster", prices = {["default"] = 6.57, ["Fly|Ride"] = 185.27, ["Neon"] = 34.44, ["Neon|Ride"] = 85.41, ["Neon|Fly|Ride"] = 137.81, ["Mega"] = 144.38, ["Mega|Fly"] = 263.92, ["Mega|Ride"] = 212.52, ["Mega|Fly|Ride"] = 377.23}},
    ["rbxassetid://85568505745239"] = {name = "Latte Kitsune", prices = {["default"] = 104.13, ["Fly|Ride"] = 170.63, ["Neon"] = 381.94, ["Neon|Fly"] = 525, ["Neon|Ride"] = 459.38, ["Neon|Fly|Ride"] = 514.99, ["Mega|Ride"] = 1785.13, ["Mega|Fly|Ride"] = 2125.16}},
    ["rbxassetid://3181727727"] = {name = "Griffin", prices = {["default"] = 12.29, ["Fly|Ride"] = 32.82, ["Neon"] = 161.91, ["Neon|Fly"] = 80.64, ["Neon|Ride"] = 196.86, ["Neon|Fly|Ride"] = 78.71, ["Mega"] = 2550.19, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://4822753215"] = {name = "Golden Egg", prices = {["default"] = 10.39}},
    ["rbxassetid://116463571924920"] = {name = "Prismatic Butterfly", prices = {["default"] = 64.96, ["Fly|Ride"] = 425.04, ["Neon"] = 359.63, ["Neon|Fly"] = 423.98, ["Neon|Ride"] = 406.87, ["Neon|Fly|Ride"] = 430.5, ["Mega|Ride"] = 1575, ["Mega|Fly|Ride"] = 1611.26}},
    ["rbxassetid://8596153183"] = {name = "Chameleon", prices = {["default"] = 11.69, ["Fly|Ride"] = 65.44, ["Neon"] = 98.44, ["Neon|Ride"] = 116.94, ["Neon|Fly|Ride"] = 185.74, ["Mega"] = 603.93, ["Mega|Ride"] = 567.42, ["Mega|Fly|Ride"] = 425.04}},
    ["rbxassetid://110774856122162"] = {name = "Gemstone Egg", prices = {["default"] = 30.19}},
    ["rbxassetid://14892649590"] = {name = "Dire Stag", prices = {["default"] = 47.25, ["Fly|Ride"] = 283.73, ["Neon"] = 299.64, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 283.73, ["Mega|Fly|Ride"] = 1664}},
    ["rbxassetid://106744890070136"] = {name = "Oakee Wizard", prices = {["default"] = 3.94, ["Fly|Ride"] = 137.75, ["Neon"] = 21.26, ["Neon|Ride"] = 113.58, ["Neon|Fly|Ride"] = 185.96, ["Mega"] = 144.38, ["Mega|Ride"] = 213.42, ["Mega|Fly|Ride"] = 425.04}},
    ["rbxassetid://9938967576"] = {name = "Chocolate Chow-Chow", prices = {["default"] = 11.81, ["Fly|Ride"] = 85.22, ["Neon"] = 161.91, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 190.21, ["Mega|Ride"] = 425.04, ["Mega|Fly|Ride"] = 425.04}},
    ["rbxassetid://9174893483"] = {name = "Mechapup", prices = {["default"] = 488.57, ["Fly|Ride"] = 577.5, ["Neon|Fly|Ride"] = 5667.77, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://15292843858"] = {name = "Mecha Meow", prices = {["default"] = 38.05, ["Fly|Ride"] = 89.25, ["Neon"] = 103.69, ["Neon|Ride"] = 213.1, ["Neon|Fly|Ride"] = 331.54, ["Mega"] = 776.43, ["Mega|Ride"] = 595.05, ["Mega|Fly|Ride"] = 639.13}},
    ["rbxassetid://15931200262"] = {name = "Cactus Friend", prices = {["default"] = 49.86, ["Fly|Ride"] = 122.2, ["Neon"] = 244.07, ["Neon|Ride"] = 236.15, ["Neon|Fly|Ride"] = 322.88, ["Mega|Fly|Ride"] = 946.76}},
    ["rbxassetid://127221459636244"] = {name = "Strawberry Shortcake Ducky", prices = {["default"] = 20.2, ["Fly|Ride"] = 103.69, ["Neon"] = 98.44, ["Neon|Ride"] = 142.95, ["Neon|Fly|Ride"] = 258.57, ["Mega"] = 432.42, ["Mega|Fly"] = 525, ["Mega|Ride"] = 368.73, ["Mega|Fly|Ride"] = 592.93}},
    ["rbxassetid://4470748644"] = {name = "Frost Dragon", prices = {["default"] = 13125, ["Fly|Ride"] = 8190, ["Neon|Fly|Ride"] = 15592.5, ["Mega|Fly|Ride"] = 38850}},
    ["rbxassetid://15365667976"] = {name = "Chocolate Chip Bat Dragon", prices = {["default"] = 1339.52, ["Fly"] = 1811.92, ["Fly|Ride"] = 1404.36, ["Neon|Fly|Ride"] = 4772.25, ["Mega|Fly|Ride"] = 15585.81}},
    ["rbxassetid://16898343164"] = {name = "Pirate Ghost Capuchin Monkey", prices = {["default"] = 544.05, ["Fly|Ride"] = 707.69, ["Neon"] = 2253.58, ["Neon|Fly|Ride"] = 3187.72, ["Mega"] = 21251.43, ["Mega|Fly|Ride"] = 9535.53}},
    ["rbxassetid://6404812772"] = {name = "Golden Ladybug", prices = {["default"] = 11.11, ["Fly|Ride"] = 41.53, ["Neon"] = 63.76, ["Neon|Ride"] = 72.19, ["Neon|Fly|Ride"] = 123.27, ["Mega|Fly|Ride"] = 572.25}},
    ["rbxassetid://95029455226760"] = {name = "Easter Bunny", prices = {["default"] = 4.6, ["Fly|Ride"] = 157.5, ["Neon"] = 24.86, ["Neon|Ride"] = 55.13, ["Mega"] = 160.13, ["Mega|Ride"] = 184.9, ["Mega|Fly|Ride"] = 265.65}},
    ["rbxassetid://5307473113"] = {name = "Kitsune", prices = {["default"] = 31.5, ["Fly|Ride"] = 103.68, ["Neon"] = 202.16, ["Neon|Ride"] = 150.92, ["Neon|Fly|Ride"] = 182.44, ["Mega|Ride"] = 743.81, ["Mega|Fly|Ride"] = 666.75}},
    ["rbxassetid://4797806780"] = {name = "Golden Dragon", prices = {["default"] = 2.63, ["Fly|Ride"] = 37.59, ["Neon"] = 40.39, ["Neon|Fly"] = 91.88, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 96.06, ["Mega"] = 288.75, ["Mega|Ride"] = 743.71, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://135649428081307"] = {name = "Sakura Spirit", prices = {["default"] = 288.25, ["Fly|Ride"] = 354.36, ["Neon"] = 1611.71, ["Neon|Ride"] = 1305.26, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 3690.75}},
    ["rbxassetid://11109110190"] = {name = "White Amazon", prices = {["default"] = 17.07, ["Fly|Ride"] = 85.16, ["Neon"] = 131.25, ["Neon|Fly"] = 308.44, ["Neon|Ride"] = 141.7, ["Neon|Fly|Ride"] = 249.38, ["Mega"] = 666.25, ["Mega|Ride"] = 425.04, ["Mega|Fly|Ride"] = 694.94}},
    ["rbxassetid://9475753542"] = {name = "Golden Albatross", prices = {["default"] = 9.07, ["Fly|Ride"] = 45.94, ["Neon"] = 82.89, ["Neon|Fly"] = 121.14, ["Neon|Ride"] = 70.83, ["Neon|Fly|Ride"] = 104.21, ["Mega"] = 1575, ["Mega|Ride"] = 608.76, ["Mega|Fly|Ride"] = 423.94}},
    ["rbxassetid://12778628831"] = {name = "Emperor Gorilla", prices = {["default"] = 567.42, ["Fly|Ride"] = 420, ["Neon|Fly|Ride"] = 3543.68, ["Mega|Fly|Ride"] = 12325.84}},
    ["rbxassetid://13672542902"] = {name = "Hot Doggo", prices = {["default"] = 1102.5, ["Fly|Ride"] = 1256.68, ["Neon"] = 4959.03, ["Neon|Fly|Ride"] = 3570, ["Mega|Fly|Ride"] = 12043.19}},
    ["rbxassetid://8070897995"] = {name = "Ice Golem", prices = {["default"] = 142.4, ["Fly|Ride"] = 129.28, ["Neon"] = 586.56, ["Neon|Ride"] = 584.42, ["Neon|Fly|Ride"] = 498.75, ["Mega|Fly|Ride"] = 2550.19}},
    ["rbxassetid://128225904426926"] = {name = "Rose Dragon", prices = {["default"] = 208.28, ["Fly|Ride"] = 247.84, ["Neon"] = 541.61, ["Neon|Ride"] = 768.26, ["Neon|Fly|Ride"] = 648.54, ["Mega|Ride"] = 9187.5, ["Mega|Fly|Ride"] = 2929.5}},
    ["rbxassetid://13883274830"] = {name = "Pirate Hermit Crab", prices = {["default"] = 31.42, ["Fly|Ride"] = 113.71, ["Neon"] = 236.24, ["Neon|Ride"] = 238.13, ["Mega|Ride"] = 1417.48, ["Mega|Fly|Ride"] = 1075.34}},
    ["rbxassetid://95213400890066"] = {name = "Diamond Hummingbird", prices = {["default"] = 393.75, ["Fly|Ride"] = 597.19, ["Neon"] = 1220.63, ["Neon|Fly|Ride"] = 1133.78, ["Mega"] = 5667.77, ["Mega|Fly|Ride"] = 5667.77}},
    ["rbxassetid://10453528102"] = {name = "Diamond Butterfly", prices = {["default"] = 2805.21, ["Fly|Ride"] = 1837.48, ["Neon|Fly|Ride"] = 10625.72, ["Mega|Fly|Ride"] = 32209.28}},
    ["rbxassetid://12778628650"] = {name = "Astronaut Gorilla", prices = {["default"] = 45.85, ["Fly|Ride"] = 196.88, ["Neon"] = 288.75, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 267.79, ["Mega"] = 1417.48, ["Mega|Ride"] = 1133.78, ["Mega|Fly|Ride"] = 992.45}},
    ["rbxassetid://4708551306"] = {name = "Kangaroo", prices = {["default"] = 603.75, ["Fly|Ride"] = 630, ["Neon|Ride"] = 1498.88, ["Neon|Fly|Ride"] = 1154.99, ["Mega|Fly|Ride"] = 3451.75}},
    ["rbxassetid://9542440966"] = {name = "Capricorn", prices = {["default"] = 45.03, ["Fly|Ride"] = 90.57, ["Neon"] = 262.5, ["Neon|Ride"] = 236.81, ["Neon|Fly|Ride"] = 234.94, ["Mega|Fly|Ride"] = 1181.24}},
    ["rbxassetid://9678195673"] = {name = "Ancient Dragon", prices = {["default"] = 3.29, ["Fly|Ride"] = 49.88, ["Neon"] = 26.25, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 48.85, ["Neon|Fly|Ride"] = 102.22, ["Mega"] = 170.62, ["Mega|Fly"] = 249.38, ["Mega|Ride"] = 185.1, ["Mega|Fly|Ride"] = 283.73}},
    ["rbxassetid://132388343771587"] = {name = "Kelp Captain", prices = {["default"] = 28.7, ["Fly|Ride"] = 206.15, ["Neon"] = 262.4, ["Neon|Ride"] = 430.17, ["Neon|Fly|Ride"] = 708.75, ["Mega"] = 1553.49, ["Mega|Ride"] = 1551.37}},
    ["rbxassetid://15148532648"] = {name = "Werewolf", prices = {["default"] = 801.94, ["Fly|Ride"] = 918.22, ["Neon|Ride"] = 3254.99, ["Neon|Fly|Ride"] = 2957.66, ["Mega|Fly|Ride"] = 12378.97}},
    ["rbxassetid://86323568215409"] = {name = "Tortoiseshell Guinea Pig", prices = {["default"] = 645.75, ["Fly|Ride"] = 835.21, ["Neon|Fly|Ride"] = 4240.73, ["Mega|Fly|Ride"] = 15441.3}},
    ["rbxassetid://5973019152"] = {name = "Robo Dog", prices = {["default"] = 13.13, ["Fly|Ride"] = 45.93, ["Neon"] = 144.38, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 113.71, ["Mega"] = 805.64, ["Mega|Ride"] = 482.42, ["Mega|Fly|Ride"] = 747.01}},
    ["rbxassetid://7734928470"] = {name = "Halloween Golden Mummy Cat", prices = {["default"] = 11.76, ["Fly|Ride"] = 91.4, ["Neon"] = 165.26, ["Neon|Ride"] = 82.69, ["Neon|Fly|Ride"] = 210, ["Mega"] = 846.57, ["Mega|Ride"] = 666.25, ["Mega|Fly|Ride"] = 682.5}},
    ["rbxassetid://137429532189183"] = {name = "Fire Stallion", prices = {["default"] = 5.71, ["Fly|Ride"] = 111.57, ["Neon"] = 21.94, ["Neon|Fly"] = 321.61, ["Neon|Ride"] = 68.88, ["Neon|Fly|Ride"] = 204.75, ["Mega"] = 176.67, ["Mega|Fly"] = 548.37, ["Mega|Ride"] = 283.73, ["Mega|Fly|Ride"] = 355.6}},
    ["rbxassetid://7215324578"] = {name = "Axolotl", prices = {["default"] = 38.06, ["Fly|Ride"] = 112.88, ["Neon"] = 295.98, ["Neon|Ride"] = 220.5, ["Neon|Fly|Ride"] = 233.06, ["Mega|Ride"] = 951.79, ["Mega|Fly|Ride"] = 956.71}},
    ["rbxassetid://111805565268081"] = {name = "Black Widow", prices = {["default"] = 90.45, ["Fly|Ride"] = 645.18, ["Neon"] = 437.07, ["Neon|Ride"] = 567.42, ["Neon|Fly|Ride"] = 695.63, ["Mega"] = 2267.54, ["Mega|Ride"] = 2125.16, ["Mega|Fly|Ride"] = 1700.13}},
    ["rbxassetid://103653773461193"] = {name = "Sunglider", prices = {["default"] = 16.02, ["Fly|Ride"] = 95.64, ["Neon"] = 106.32, ["Neon|Fly"] = 113.71, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 148.7, ["Mega"] = 476.04, ["Mega|Ride"] = 362.25, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://6498256069"] = {name = "Shark", prices = {["default"] = 28.66, ["Fly|Ride"] = 84.96, ["Neon"] = 242.82, ["Neon|Fly"] = 1417.48, ["Neon|Ride"] = 208.69, ["Neon|Fly|Ride"] = 215.25, ["Mega"] = 2100, ["Mega|Ride"] = 1195.86, ["Mega|Fly|Ride"] = 1194.38}},
    ["rbxassetid://8663440945"] = {name = "Lunar Gold Tiger", prices = {["default"] = 3.68, ["Fly|Ride"] = 36.18, ["Neon"] = 23.54, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 743.81, ["Mega|Ride"] = 483.14, ["Mega|Fly|Ride"] = 530.23}},
    ["rbxassetid://94185217299816"] = {name = "Dracula Parrot", prices = {["default"] = 6.39, ["Fly|Ride"] = 66.93, ["Neon"] = 39.38, ["Neon|Fly"] = 110.52, ["Neon|Ride"] = 81.38, ["Neon|Fly|Ride"] = 125.4, ["Mega"] = 416.07, ["Mega|Ride"] = 354.92, ["Mega|Fly|Ride"] = 446.25}},
    ["rbxassetid://4621220431"] = {name = "Golden Rat", prices = {["default"] = 59.01, ["Fly|Ride"] = 101.85, ["Neon"] = 525, ["Neon|Fly"] = 211.3, ["Neon|Ride"] = 214.67, ["Neon|Fly|Ride"] = 236.14, ["Mega|Fly|Ride"] = 1074.92}},
    ["rbxassetid://11506045996"] = {name = "Strawberry Shortcake Bat Dragon", prices = {["default"] = 1403.07, ["Fly|Ride"] = 1443.75, ["Neon|Fly|Ride"] = 3790.5, ["Mega|Fly|Ride"] = 12468.75}},
    ["rbxassetid://11758583912"] = {name = "Winged Tiger", prices = {["default"] = 462, ["Fly"] = 524.99, ["Fly|Ride"] = 479.07, ["Neon|Ride"] = 2833.89, ["Neon|Fly|Ride"] = 2362.5, ["Mega"] = 14876.02, ["Mega|Fly|Ride"] = 9350.63}},
    ["rbxassetid://101160794933271"] = {name = "Matcha Cat", prices = {["default"] = 266.37, ["Fly"] = 378.23, ["Fly|Ride"] = 452.67, ["Neon"] = 1275.1, ["Neon|Ride"] = 1551.37, ["Neon|Fly|Ride"] = 1640.63}},
    ["rbxassetid://13892790514"] = {name = "Urban Egg", prices = {["default"] = 39.38}},
    ["rbxassetid://13104109574"] = {name = "Spinosaurus", prices = {["default"] = 24.85, ["Fly|Ride"] = 97.13, ["Neon"] = 325.5, ["Neon|Ride"] = 207.38, ["Neon|Fly|Ride"] = 354.38, ["Mega|Ride"] = 1558.8, ["Mega|Fly|Ride"] = 1036.54}},
    ["rbxassetid://4115248712"] = {name = "Shadow Dragon", prices = {["default"] = 73672.31, ["Fly|Ride"] = 17558.63, ["Neon|Fly|Ride"] = 37800, ["Mega"] = 212514.21, ["Mega|Fly|Ride"] = 89250}},
    ["rbxassetid://71457697470071"] = {name = "Arctic Dusk Dragon", prices = {["default"] = 223.13, ["Fly"] = 292.22, ["Fly|Ride"] = 315, ["Neon"] = 1087.36, ["Neon|Fly"] = 853.13, ["Neon|Ride"] = 921.26, ["Neon|Fly|Ride"] = 797.7, ["Mega"] = 3719.01, ["Mega|Ride"] = 4249.24, ["Mega|Fly|Ride"] = 3441.34}},
    ["rbxassetid://8566683457"] = {name = "Giant Gold Scarab", prices = {["default"] = 216.46, ["Fly|Ride"] = 318.78, ["Neon|Fly|Ride"] = 1771.91}},
    ["rbxassetid://16116063171"] = {name = "Rainbow Dragon", prices = {["default"] = 128.63, ["Fly"] = 992.45, ["Fly|Ride"] = 258.56, ["Neon|Ride"] = 524.99, ["Neon|Fly|Ride"] = 616.88, ["Mega|Fly|Ride"] = 2975.22}},
    ["rbxassetid://9938967130"] = {name = "Black Chow-Chow", prices = {["default"] = 11.71, ["Fly|Ride"] = 52.5, ["Neon"] = 142.4, ["Neon|Ride"] = 99.89, ["Neon|Fly|Ride"] = 708.75, ["Mega"] = 722.3, ["Mega|Ride"] = 708.75, ["Mega|Fly|Ride"] = 929.76}},
    ["rbxassetid://116467943923352"] = {name = "Haetae", prices = {["default"] = 5206.62, ["Fly|Ride"] = 4003.13, ["Neon"] = 27626.86, ["Neon|Fly|Ride"] = 15750}},
    ["rbxassetid://6531232495"] = {name = "Peacock", prices = {["default"] = 27.14, ["Fly|Ride"] = 59.97, ["Neon"] = 131.25, ["Neon|Ride"] = 150.59, ["Neon|Fly|Ride"] = 198.55, ["Mega|Ride"] = 1417.48, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://12557346746"] = {name = "Naga Dragon", prices = {["default"] = 49, ["Fly|Ride"] = 102.79, ["Neon"] = 314.26, ["Neon|Fly"] = 1417.48, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 262.48, ["Mega|Fly|Ride"] = 1374.19}},
    ["rbxassetid://127697654557674"] = {name = "Candicorn", prices = {["default"] = 420, ["Fly|Ride"] = 561.57, ["Neon"] = 1256.07, ["Neon|Ride"] = 1155, ["Neon|Fly|Ride"] = 1220.1, ["Mega|Ride"] = 6800.47, ["Mega|Fly|Ride"] = 9187.5}},
    ["rbxassetid://4281674580"] = {name = "King Bee", prices = {["default"] = 15.94, ["Fly|Ride"] = 52.36, ["Neon"] = 123.38, ["Neon|Fly"] = 160.47, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 141.74, ["Mega|Ride"] = 779.94, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://17822543288"] = {name = "Blue Betta Fish", prices = {["default"] = 11.03, ["Fly|Ride"] = 65.63, ["Neon"] = 85.01, ["Neon|Ride"] = 58.1, ["Neon|Fly|Ride"] = 209.08, ["Mega|Ride"] = 748.88, ["Mega|Fly|Ride"] = 724.71}},
    ["rbxassetid://102300026415493"] = {name = "Moose Calf", prices = {["default"] = 120.75, ["Fly|Ride"] = 208.28, ["Neon"] = 1010.63, ["Neon|Ride"] = 637.79, ["Neon|Fly|Ride"] = 1133.78, ["Mega|Fly|Ride"] = 2738.17}},
    ["rbxassetid://78419574214060"] = {name = "Christmas Spirit", prices = {["default"] = 20.9, ["Fly|Ride"] = 236.15, ["Neon"] = 45.94, ["Neon|Ride"] = 91.83, ["Neon|Fly|Ride"] = 236.23, ["Mega"] = 263.97, ["Mega|Fly"] = 737.44, ["Mega|Ride"] = 301.87, ["Mega|Fly|Ride"] = 429.51}},
    ["rbxassetid://130642623661179"] = {name = "Cryptid", prices = {["default"] = 4263.95, ["Fly|Ride"] = 4042.5, ["Neon"] = 14876.02, ["Neon|Ride"] = 12337.5, ["Neon|Fly|Ride"] = 10328.07, ["Mega"] = 42501.8, ["Mega|Fly|Ride"] = 37945.69}},
    ["rbxassetid://101130894252942"] = {name = "Peach Owl", prices = {["default"] = 28.7, ["Fly|Ride"] = 157.5, ["Neon"] = 233.62, ["Neon|Ride"] = 258.56, ["Neon|Fly|Ride"] = 386.52, ["Mega"] = 850.07, ["Mega|Ride"] = 1771.91, ["Mega|Fly|Ride"] = 782.24}},
    ["rbxassetid://4440866649"] = {name = "Owl", prices = {["default"] = 9318.75, ["Fly|Ride"] = 6167.44, ["Neon|Fly|Ride"] = 14437.5, ["Mega|Fly|Ride"] = 46921.88}},
    ["rbxassetid://6836687169"] = {name = "Golden Griffin", prices = {["default"] = 3.84, ["Fly|Ride"] = 40.06, ["Neon"] = 24.68, ["Neon|Fly"] = 57.39, ["Neon|Ride"] = 49.88, ["Neon|Fly|Ride"] = 89.25, ["Mega"] = 242.28, ["Mega|Ride"] = 372.75, ["Mega|Fly|Ride"] = 248.07}},
    ["rbxassetid://76198828333546"] = {name = "Hippogriff", prices = {["default"] = 15.23, ["Fly|Ride"] = 42, ["Neon"] = 142.4, ["Neon|Fly"] = 234.85, ["Neon|Ride"] = 142.4, ["Neon|Fly|Ride"] = 166.32, ["Mega|Ride"] = 991.6, ["Mega|Fly|Ride"] = 928.7}},
    ["rbxassetid://112567270488274"] = {name = "Crystal Egg", prices = {["default"] = 3.93}},
    ["rbxassetid://10695038557"] = {name = "Maneki-Neko", prices = {["default"] = 10.68, ["Fly|Ride"] = 57.66, ["Neon"] = 98.44, ["Neon|Ride"] = 93.64, ["Mega"] = 1050, ["Mega|Ride"] = 892.57, ["Mega|Fly|Ride"] = 798.02}},
    ["rbxassetid://16911441596"] = {name = "Royal Capuchin Monkey", prices = {["default"] = 27.64, ["Fly|Ride"] = 124.59, ["Neon"] = 203.44, ["Neon|Ride"] = 181.25, ["Neon|Fly|Ride"] = 195.57, ["Mega"] = 945, ["Mega|Ride"] = 850.07, ["Mega|Fly|Ride"] = 1099.88}},
    ["rbxassetid://6963387165"] = {name = "Cobra", prices = {["default"] = 14.38, ["Fly|Ride"] = 35.44, ["Neon|Fly"] = 1059.4, ["Neon|Ride"] = 117.96, ["Neon|Fly|Ride"] = 128.63, ["Mega"] = 2550.19, ["Mega|Fly|Ride"] = 531.57}},
    ["rbxassetid://3409444171"] = {name = "Safari Egg", prices = {["default"] = 8642.96}},
    ["rbxassetid://3743740864"] = {name = "Jungle Egg", prices = {["default"] = 2624.99}},
    ["rbxassetid://10321884333"] = {name = "Japan Egg", prices = {["default"] = 22.3}},
    ["rbxassetid://11109117895"] = {name = "Diamond Amazon", prices = {["default"] = 236.04, ["Fly|Ride"] = 262.49, ["Mega|Fly|Ride"] = 4200}},
    ["rbxassetid://102144672439627"] = {name = "Berry Cool Cube", prices = {["default"] = 15, ["Fly|Ride"] = 123.27, ["Neon"] = 85.01, ["Neon|Ride"] = 116.82, ["Neon|Fly|Ride"] = 265.13, ["Mega"] = 525, ["Mega|Ride"] = 532.67, ["Mega|Fly|Ride"] = 1179.94}},
    ["rbxassetid://17183502626"] = {name = "Garden Egg", prices = {["default"] = 11.11}},
    ["rbxassetid://16722909609"] = {name = "Striped Eggy", prices = {["default"] = 5.25, ["Fly|Ride"] = 85.01, ["Neon|Ride"] = 249.38, ["Mega"] = 1558.8}},
    ["rbxassetid://4440866155"] = {name = "Farm Egg", prices = {["default"] = 2625}},
    ["rbxassetid://88361277330582"] = {name = "Naughty Mistletroll", prices = {["default"] = 123.16, ["Fly|Ride"] = 495.17, ["Neon"] = 918.75, ["Neon|Ride"] = 849.01, ["Neon|Fly|Ride"] = 1558.8, ["Mega|Ride"] = 4108.98, ["Mega|Fly|Ride"] = 3936.45}},
    ["rbxassetid://12778919221"] = {name = "Yule Log Dog", prices = {["default"] = 65.63, ["Fly|Ride"] = 212.52, ["Neon"] = 662, ["Neon|Ride"] = 494.82, ["Neon|Fly|Ride"] = 936.13, ["Mega|Fly|Ride"] = 1837.5}},
    ["rbxassetid://13104112588"] = {name = "Owlbear", prices = {["default"] = 157.46, ["Fly|Ride"] = 230.6, ["Neon"] = 944.98, ["Neon|Ride"] = 787.49, ["Neon|Fly|Ride"] = 849.79, ["Mega|Ride"] = 3258.92, ["Mega|Fly|Ride"] = 3110.61}},
    ["rbxassetid://11192035130"] = {name = "Undead Jousting Horse", prices = {["default"] = 2388.74, ["Fly|Ride"] = 2257.5, ["Neon"] = 14924.89, ["Neon|Ride"] = 8457.16, ["Neon|Fly|Ride"] = 5906.25, ["Mega|Fly|Ride"] = 25593.75}},
    ["rbxassetid://106575933009346"] = {name = "Fairytale Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://96044273915258"] = {name = "Endangered Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://129993159377616"] = {name = "Peahen", prices = {["default"] = 15.75, ["Fly|Ride"] = 100.08, ["Neon"] = 120.83, ["Neon|Fly"] = 161.91, ["Neon|Ride"] = 154.62, ["Neon|Fly|Ride"] = 242.82, ["Mega"] = 955.26, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://12732812236"] = {name = "Tio De Nadal", prices = {["default"] = 822.45, ["Fly|Ride"] = 774.38, ["Neon|Fly|Ride"] = 4187.57}},
    ["rbxassetid://13936755787"] = {name = "Wrapped Doll", prices = {["default"] = 39.38}},
    ["rbxassetid://136441478335419"] = {name = "Emberlight", prices = {["default"] = 14.7, ["Fly|Ride"] = 340.72, ["Neon"] = 94.5, ["Neon|Fly"] = 183.75, ["Neon|Ride"] = 106.26, ["Neon|Fly|Ride"] = 255.03, ["Mega"] = 466.19, ["Mega|Fly"] = 966.28, ["Mega|Ride"] = 496.23, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://17120184484"] = {name = "Rosy Maple Moth", prices = {["default"] = 5.19, ["Fly|Ride"] = 105.2, ["Neon"] = 38.07, ["Neon|Fly"] = 315, ["Neon|Ride"] = 61.64, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 451.75, ["Mega|Ride"] = 262.5}},
    ["rbxassetid://15932251755"] = {name = "Royal Desert Egg", prices = {["default"] = 60.38}},
    ["rbxassetid://8143039289"] = {name = "Golden Walrus", prices = {["default"] = 19.8, ["Fly"] = 109.46, ["Fly|Ride"] = 85.01, ["Neon|Ride"] = 193.32, ["Neon|Fly|Ride"] = 254.62, ["Mega|Ride"] = 992.45, ["Mega|Fly|Ride"] = 2125.16}},
    ["rbxassetid://12187391973"] = {name = "Firefly", prices = {["default"] = 25.58, ["Fly|Ride"] = 76.13, ["Neon|Fly"] = 234.85, ["Neon|Ride"] = 223.13, ["Neon|Fly|Ride"] = 211.46, ["Mega"] = 1449.4, ["Mega|Ride"] = 1811.77, ["Mega|Fly|Ride"] = 989.63}},
    ["rbxassetid://3743647944"] = {name = "Parrot", prices = {["default"] = 5681.59, ["Fly|Ride"] = 4725, ["Neon|Fly|Ride"] = 9843.75, ["Mega|Fly|Ride"] = 35437.5}},
    ["rbxassetid://128454622445076"] = {name = "Dimension Drifter", prices = {["default"] = 9.55, ["Fly|Ride"] = 81.37, ["Neon"] = 52.5, ["Neon|Ride"] = 63.54, ["Neon|Fly|Ride"] = 168.96, ["Mega"] = 510.04, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 525.98}},
    ["rbxassetid://15931761708"] = {name = "Desert Egg", prices = {["default"] = 19.43}},
    ["rbxassetid://17747001377"] = {name = "Majestic Pony", prices = {["default"] = 91.88, ["Fly|Ride"] = 161.72, ["Neon"] = 531.57, ["Neon|Ride"] = 399.71, ["Neon|Fly|Ride"] = 596.81, ["Mega|Ride"] = 2267.54, ["Mega|Fly|Ride"] = 2107.09}},
    ["rbxassetid://94487786469241"] = {name = "Vanilla Penguin", prices = {["default"] = 48.34, ["Fly|Ride"] = 182.78, ["Neon"] = 157.5, ["Neon|Ride"] = 276.28, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 2415.68, ["Mega|Ride"] = 2868.96, ["Mega|Fly|Ride"] = 1028.99}},
    ["rbxassetid://6498256211"] = {name = "Octopus", prices = {["default"] = 18.5, ["Fly|Ride"] = 65, ["Neon"] = 128.77, ["Neon|Fly"] = 229.53, ["Neon|Ride"] = 151.05, ["Neon|Fly|Ride"] = 157.27, ["Mega|Ride"] = 869.65, ["Mega|Fly|Ride"] = 783.56}},
    ["rbxassetid://110654583245787"] = {name = "Sea Turtle", prices = {["default"] = 5.25, ["Fly"] = 113.71, ["Fly|Ride"] = 63.94, ["Neon"] = 31.5, ["Neon|Fly"] = 42.51, ["Neon|Ride"] = 57.39, ["Neon|Fly|Ride"] = 129.94, ["Mega"] = 137.82, ["Mega|Fly"] = 284.95, ["Mega|Ride"] = 198.72, ["Mega|Fly|Ride"] = 284.82}},
    ["rbxassetid://8596147681"] = {name = "Squid", prices = {["default"] = 10.98, ["Fly|Ride"] = 97.95, ["Neon"] = 91.56, ["Neon|Ride"] = 97.17, ["Neon|Fly|Ride"] = 142.4, ["Mega|Ride"] = 382.54, ["Mega|Fly|Ride"] = 498.74}},
    ["rbxassetid://9226723356"] = {name = "Winged Horse", prices = {["default"] = 18.69, ["Fly|Ride"] = 56.44, ["Neon|Fly"] = 144.38, ["Neon|Ride"] = 128.62, ["Neon|Fly|Ride"] = 142.91, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://4733386633"] = {name = "Aussie Egg", prices = {["default"] = 207.65}},
    ["rbxassetid://121951206021245"] = {name = "Kiwi Kiwi", prices = {["default"] = 32.24, ["Fly|Ride"] = 322.6, ["Neon"] = 198.72, ["Neon|Ride"] = 221.03, ["Neon|Fly|Ride"] = 426.54, ["Mega"] = 694.94, ["Mega|Fly|Ride"] = 678.57}},
    ["rbxassetid://9602676771"] = {name = "Diamond Albatross", prices = {["default"] = 160.63, ["Neon|Ride"] = 17001.15, ["Neon|Fly|Ride"] = 28335.59}},
    ["rbxassetid://79965389436178"] = {name = "Sushi Penguin", prices = {["default"] = 47.11, ["Fly|Ride"] = 213.65, ["Neon"] = 252, ["Neon|Ride"] = 326.23, ["Neon|Fly|Ride"] = 461.16, ["Mega"] = 850.5, ["Mega|Ride"] = 1047.2, ["Mega|Fly|Ride"] = 1217.24}},
    ["rbxassetid://126930507653265"] = {name = "Grim Dragon", prices = {["default"] = 1010.63, ["Fly"] = 1575, ["Fly|Ride"] = 1049.97, ["Neon|Fly"] = 4382.02, ["Neon|Ride"] = 4275.71, ["Neon|Fly|Ride"] = 3281.25, ["Mega|Fly|Ride"] = 12337.5}},
    ["rbxassetid://87328715505907"] = {name = "Silverback Gorilla", prices = {["default"] = 425.04, ["Fly|Ride"] = 425.04, ["Neon"] = 2125.16, ["Neon|Ride"] = 1909.69, ["Neon|Fly|Ride"] = 1995, ["Mega"] = 12078.33, ["Mega|Fly|Ride"] = 9186.19}},
    ["rbxassetid://12733311267"] = {name = "Fool Egg", prices = {["default"] = 55.13}},
    ["rbxassetid://139472202653768"] = {name = "Admin Abuse Egg", prices = {["default"] = 2.58}},
    ["rbxassetid://8938702589"] = {name = "Hawk", prices = {["default"] = 8.71, ["Fly|Ride"] = 52.52, ["Neon"] = 78.75, ["Neon|Fly"] = 145.69, ["Neon|Ride"] = 84.34, ["Neon|Fly|Ride"] = 118.12, ["Mega"] = 559.99, ["Mega|Ride"] = 708.75, ["Mega|Fly|Ride"] = 547.23}},
    ["rbxassetid://8938703243"] = {name = "Fallow Deer", prices = {["default"] = 246.75, ["Fly"] = 406.65, ["Fly|Ride"] = 326.7, ["Neon"] = 1193.69, ["Neon|Ride"] = 954.19, ["Neon|Fly|Ride"] = 1089.81, ["Mega|Ride"] = 3117.59, ["Mega|Fly|Ride"] = 2800.89}},
    ["rbxassetid://4822753124"] = {name = "Diamond Egg", prices = {["default"] = 13.13}},
    ["rbxassetid://114823420678686"] = {name = "Dragonfruit Fox", prices = {["default"] = 103.5, ["Fly|Ride"] = 279.78, ["Neon"] = 567.42, ["Neon|Fly"] = 610.32, ["Neon|Ride"] = 567.42, ["Neon|Fly|Ride"] = 656.23, ["Mega"] = 2231.43, ["Mega|Fly|Ride"] = 1914.94}},
    ["rbxassetid://102844319137806"] = {name = "Pineapple Owl", prices = {["default"] = 129.83, ["Neon"] = 1133.78, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 913.5, ["Mega|Fly|Ride"] = 2550.19}},
    ["rbxassetid://82296650763619"] = {name = "Angus Bull", prices = {["default"] = 3.8, ["Fly|Ride"] = 173.21, ["Neon"] = 39.37, ["Neon|Ride"] = 79.7, ["Neon|Fly|Ride"] = 241.22, ["Mega"] = 255.03, ["Mega|Ride"] = 189.84, ["Mega|Fly|Ride"] = 483.14}},
    ["rbxassetid://12917347755"] = {name = "Sunrise Duckling", prices = {["default"] = 9.2, ["Fly|Ride"] = 52.5, ["Neon"] = 142.4, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 319.48, ["Mega|Ride"] = 1417.48, ["Mega|Fly|Ride"] = 616.88}},
    ["rbxassetid://139217275750567"] = {name = "Winter Buck", prices = {["default"] = 10.5, ["Fly|Ride"] = 104.81, ["Neon"] = 85.31, ["Neon|Ride"] = 66.95, ["Neon|Fly|Ride"] = 259.28, ["Mega"] = 422.92, ["Mega|Ride"] = 519.75, ["Mega|Fly|Ride"] = 538.74}},
    ["rbxassetid://114331718573822"] = {name = "Mochi Meow", prices = {["default"] = 5.25, ["Fly|Ride"] = 135.48, ["Neon"] = 26.16, ["Neon|Ride"] = 65.27, ["Neon|Fly|Ride"] = 157.49, ["Mega"] = 144.38, ["Mega|Fly"] = 274.2, ["Mega|Ride"] = 175.87, ["Mega|Fly|Ride"] = 255.94}},
    ["rbxassetid://112560568221286"] = {name = "Strawberry Penguin", prices = {["default"] = 196.88, ["Fly|Ride"] = 386.6, ["Neon"] = 1587.5, ["Neon|Ride"] = 1374.91, ["Neon|Fly|Ride"] = 1424.07, ["Mega|Fly|Ride"] = 5638.02}},
    ["rbxassetid://116818749091454"] = {name = "Dango Penguins", prices = {["default"] = 98.88, ["Fly|Ride"] = 240.16, ["Neon"] = 429.17, ["Neon|Ride"] = 549.7, ["Neon|Fly|Ride"] = 630, ["Mega"] = 2270.73, ["Mega|Ride"] = 1903.13, ["Mega|Fly|Ride"] = 1837.5}},
    ["rbxassetid://12480100169"] = {name = "Tree Kangaroo", prices = {["default"] = 61.01, ["Fly|Ride"] = 126, ["Neon"] = 380.63, ["Neon|Ride"] = 260, ["Neon|Fly|Ride"] = 411.9, ["Mega|Ride"] = 1643.81, ["Mega|Fly|Ride"] = 1800.94}},
    ["rbxassetid://75106733244906"] = {name = "Golden Hummingbird", prices = {["default"] = 11.96, ["Fly|Ride"] = 283.73, ["Neon"] = 170.02, ["Neon|Ride"] = 613.76, ["Neon|Fly|Ride"] = 496.23, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://76354526914534"] = {name = "Frostclaw", prices = {["default"] = 11.73, ["Fly|Ride"] = 85.01, ["Neon"] = 77.44, ["Neon|Ride"] = 68.25, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 377.23, ["Mega|Fly"] = 525, ["Mega|Ride"] = 368.73, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://121712578077668"] = {name = "Blue Whale", prices = {["default"] = 3.56, ["Fly|Ride"] = 87.14, ["Neon"] = 22.32, ["Neon|Fly"] = 68.3, ["Neon|Ride"] = 45.93, ["Neon|Fly|Ride"] = 97.13, ["Mega"] = 131.25, ["Mega|Ride"] = 170.38, ["Mega|Fly|Ride"] = 235.37}},
    ["rbxassetid://76035105070441"] = {name = "Fairy Bat Dragon", prices = {["default"] = 787.49, ["Fly|Ride"] = 909.57, ["Neon"] = 3061.5, ["Neon|Fly"] = 3280.18, ["Neon|Ride"] = 8500.58, ["Neon|Fly|Ride"] = 2849.43, ["Mega|Fly|Ride"] = 10130.57}},
    ["rbxassetid://105346917979221"] = {name = "Aurora Fox", prices = {["default"] = 376.89, ["Fly|Ride"] = 521.94, ["Neon"] = 1208.18, ["Neon|Ride"] = 1515.05, ["Neon|Fly|Ride"] = 1247.67, ["Mega"] = 10625.72, ["Mega|Fly|Ride"] = 7084.17}},
    ["rbxassetid://120475294381736"] = {name = "Glormy Hound", prices = {["default"] = 93.18, ["Fly"] = 133.9, ["Fly|Ride"] = 162.65, ["Neon"] = 346.42, ["Neon|Fly"] = 483.28, ["Neon|Ride"] = 306.89, ["Neon|Fly|Ride"] = 420.8, ["Mega"] = 1312.5, ["Mega|Ride"] = 1587.5, ["Mega|Fly|Ride"] = 1635.32}},
    ["rbxassetid://15570696642"] = {name = "Glacier Kitsune", prices = {["default"] = 206.15, ["Fly|Ride"] = 242.76, ["Neon|Ride"] = 1288.77, ["Neon|Fly|Ride"] = 917.44, ["Mega"] = 10625.72, ["Mega|Fly|Ride"] = 6562.5}},
    ["rbxassetid://16548792521"] = {name = "Golden Hamster", prices = {["default"] = 32.63, ["Fly|Ride"] = 74.61, ["Neon"] = 169.32, ["Neon|Ride"] = 184.9, ["Neon|Fly|Ride"] = 204.75, ["Mega|Fly|Ride"] = 887.25}},
    ["rbxassetid://12935498875"] = {name = "Field Mouse", prices = {["default"] = 233.87, ["Fly|Ride"] = 358.32, ["Neon"] = 1492.2, ["Neon|Ride"] = 787.5, ["Neon|Fly|Ride"] = 971.25, ["Mega"] = 4186.88, ["Mega|Fly|Ride"] = 3790.21}},
    ["rbxassetid://16548793509"] = {name = "Diamond Hamster", prices = {["default"] = 96.04, ["Fly|Ride"] = 136.55, ["Neon|Ride"] = 567.42, ["Mega|Fly|Ride"] = 1545}},
    ["rbxassetid://78823655016197"] = {name = "Jekyll Hydra", prices = {["default"] = 2458.81, ["Fly|Ride"] = 1968.75, ["Neon|Ride"] = 11273.92, ["Neon|Fly|Ride"] = 7635.65, ["Mega"] = 51003.42, ["Mega|Fly|Ride"] = 24156.65}},
    ["rbxassetid://96735424372947"] = {name = "Glormy Dolphin", prices = {["default"] = 15.75, ["Fly|Ride"] = 100.09, ["Neon"] = 72.51, ["Neon|Fly"] = 234.85, ["Neon|Ride"] = 112.65, ["Neon|Fly|Ride"] = 212.52, ["Mega"] = 288.75, ["Mega|Fly"] = 567.42, ["Mega|Ride"] = 306.2, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://16898331554"] = {name = "Princess Capuchin Monkey", prices = {["default"] = 58.97, ["Fly|Ride"] = 155.15, ["Neon"] = 196.88, ["Neon|Fly|Ride"] = 567.42, ["Mega|Ride"] = 931.88, ["Mega|Fly|Ride"] = 1062.58}},
    ["rbxassetid://4315743450"] = {name = "Queen Bee", prices = {["default"] = 97.09, ["Fly|Ride"] = 97.55, ["Neon"] = 525, ["Neon|Ride"] = 590.62, ["Neon|Fly|Ride"] = 393.75, ["Mega|Fly|Ride"] = 1879.82}},
    ["rbxassetid://5067924789"] = {name = "Monkey King", prices = {["default"] = 3543.68, ["Fly|Ride"] = 1044.37, ["Neon|Ride"] = 5155.25, ["Neon|Fly|Ride"] = 4725, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://10284283561"] = {name = "Black-Chested Pheasant", prices = {["default"] = 525, ["Fly|Ride"] = 534.19, ["Neon|Fly|Ride"] = 3221.31, ["Mega|Fly|Ride"] = 11334.46}},
    ["rbxassetid://15504845135"] = {name = "Candy Hare", prices = {["default"] = 69.71, ["Fly|Ride"] = 208.69, ["Neon"] = 442.98, ["Neon|Ride"] = 342.43, ["Neon|Fly|Ride"] = 459.38, ["Mega"] = 5667.77, ["Mega|Ride"] = 2577.52, ["Mega|Fly|Ride"] = 1559.21}},
    ["rbxassetid://11758575657"] = {name = "Lunar Moon Bear", prices = {["default"] = 7.72, ["Fly|Ride"] = 63, ["Neon"] = 74.33, ["Neon|Fly"] = 142.4, ["Neon|Ride"] = 63.76, ["Neon|Fly|Ride"] = 129.94, ["Mega"] = 656.25, ["Mega|Ride"] = 769.32}},
    ["rbxassetid://10318105392"] = {name = "Green Butterfly", prices = {["default"] = 32.79, ["Fly|Ride"] = 141.1, ["Neon"] = 282.66, ["Neon|Fly"] = 183.75, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 2267.54, ["Mega|Ride"] = 1187.82, ["Mega|Fly|Ride"] = 1049.99}},
    ["rbxassetid://84813815094145"] = {name = "Mermicorn", prices = {["default"] = 748.13, ["Fly|Ride"] = 832.12, ["Neon|Ride"] = 2625, ["Neon|Fly|Ride"] = 2508.42, ["Mega|Fly|Ride"] = 9723}},
    ["rbxassetid://4507163112"] = {name = "Christmas Egg", prices = {["default"] = 591.41}},
    ["rbxassetid://14689005829"] = {name = "Blazing Lion", prices = {["default"] = 12079.34, ["Fly|Ride"] = 5248.69, ["Neon"] = 42000, ["Neon|Ride"] = 30454.36, ["Neon|Fly|Ride"] = 18375, ["Mega|Fly|Ride"] = 106115.8}},
    ["rbxassetid://123647431892215"] = {name = "Hero Gibbon", prices = {["default"] = 249.38, ["Neon"] = 1312.5, ["Neon|Ride"] = 1842.51, ["Neon|Fly|Ride"] = 1706.25, ["Mega"] = 6374.38, ["Mega|Fly|Ride"] = 6375.44}},
    ["rbxassetid://106457467498193"] = {name = "Scorching Kaijunior", prices = {["default"] = 78.75, ["Fly|Ride"] = 336, ["Neon"] = 423.98, ["Neon|Ride"] = 793.76, ["Neon|Fly|Ride"] = 633.31, ["Mega|Fly|Ride"] = 2154.91}},
    ["rbxassetid://10926054030"] = {name = "Chimera", prices = {["default"] = 15.24, ["Fly|Ride"] = 84.36, ["Neon"] = 156.92, ["Neon|Fly"] = 1289.12, ["Neon|Ride"] = 125.99, ["Neon|Fly|Ride"] = 214.68, ["Mega|Ride"] = 567.42, ["Mega|Fly|Ride"] = 637.55}},
    ["rbxassetid://9490242683"] = {name = "Golden King Penguin", prices = {["default"] = 10.39, ["Fly"] = 26.25, ["Fly|Ride"] = 48.89, ["Neon"] = 127.52, ["Neon|Ride"] = 322.51, ["Neon|Fly|Ride"] = 177.19, ["Mega"] = 1312.5, ["Mega|Fly|Ride"] = 2125.16}},
    ["rbxassetid://17119623510"] = {name = "Mushroom Friend", prices = {["default"] = 14.04, ["Fly|Ride"] = 89.25, ["Neon"] = 118.13, ["Neon|Ride"] = 126.67, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 645.75, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 654.94}},
    ["rbxassetid://17174656536"] = {name = "Golden Tortoise Beetle", prices = {["default"] = 6.04, ["Fly"] = 62.7, ["Fly|Ride"] = 48.57, ["Neon"] = 31.38, ["Neon|Ride"] = 56.8, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 695.67, ["Mega|Ride"] = 234.94, ["Mega|Fly|Ride"] = 276.28}},
    ["rbxassetid://84310117840681"] = {name = "Super Saru", prices = {["default"] = 28.51, ["Fly|Ride"] = 139.13, ["Neon"] = 203.44, ["Neon|Fly"] = 850.07, ["Neon|Ride"] = 229.53, ["Neon|Fly|Ride"] = 451.5, ["Mega"] = 630, ["Mega|Ride"] = 779.94}},
    ["rbxassetid://77177643028234"] = {name = "Phantom Dragon", prices = {["default"] = 485.52, ["Fly|Ride"] = 554.61, ["Neon"] = 1611.71, ["Neon|Ride"] = 1558.8, ["Neon|Fly|Ride"] = 1443.75, ["Mega"] = 7875, ["Mega|Fly|Ride"] = 5384.06}},
    ["rbxassetid://6245080265"] = {name = "Metal Ox", prices = {["default"] = 2.1, ["Fly|Ride"] = 28.7, ["Neon"] = 23.84, ["Neon|Ride"] = 27.34, ["Neon|Fly|Ride"] = 57.75, ["Mega"] = 170.63, ["Mega|Ride"] = 225.28, ["Mega|Fly|Ride"] = 207.46}},
    ["rbxassetid://3181728194"] = {name = "Unicorn", prices = {["default"] = 45.7, ["Fly|Ride"] = 142.4, ["Neon"] = 196.88, ["Neon|Fly"] = 333.15, ["Neon|Ride"] = 220.53, ["Neon|Fly|Ride"] = 285.86, ["Mega"] = 524.48, ["Mega|Ride"] = 523.69, ["Mega|Fly|Ride"] = 597.08}},
    ["rbxassetid://4708551322"] = {name = "Turtle", prices = {["default"] = 971.19, ["Fly|Ride"] = 746.03, ["Neon|Ride"] = 1988.23, ["Neon|Fly|Ride"] = 1634.07, ["Mega|Fly|Ride"] = 4134.38}},
    ["rbxassetid://5721844281"] = {name = "T-Rex", prices = {["default"] = 29.96, ["Fly|Ride"] = 76.13, ["Neon"] = 255.03, ["Neon|Fly"] = 196.88, ["Neon|Ride"] = 163.7, ["Neon|Fly|Ride"] = 249.35, ["Mega"] = 1207.85, ["Mega|Fly|Ride"] = 840}},
    ["rbxassetid://16127039676"] = {name = "Midnight Dragon", prices = {["default"] = 315, ["Fly|Ride"] = 327.57, ["Neon"] = 1558.8, ["Neon|Ride"] = 1842.51, ["Neon|Fly|Ride"] = 1554.56, ["Mega|Fly|Ride"] = 6442.59}},
    ["rbxassetid://7734925172"] = {name = "Halloween White Ghost Dragon", prices = {["default"] = 196.86, ["Fly|Ride"] = 236.14, ["Neon"] = 992.45, ["Neon|Ride"] = 892.5, ["Neon|Fly|Ride"] = 859.69, ["Mega"] = 4326, ["Mega|Fly|Ride"] = 4036.72}},
    ["rbxassetid://18508016126"] = {name = "Bush Elephant", prices = {["default"] = 841.58, ["Fly|Ride"] = 919.35, ["Neon|Ride"] = 3968.72, ["Neon|Fly|Ride"] = 3400.24, ["Mega|Fly|Ride"] = 8398.69}},
    ["rbxassetid://78218981883168"] = {name = "Coconut Friend", prices = {["default"] = 20.57, ["Fly|Ride"] = 110.25, ["Neon"] = 76.52, ["Neon|Fly"] = 289.98, ["Neon|Ride"] = 99.89, ["Neon|Fly|Ride"] = 126.46, ["Mega"] = 354.37, ["Mega|Ride"] = 422.92, ["Mega|Fly|Ride"] = 425.04}},
    ["rbxassetid://4184878050"] = {name = "Evil Unicorn", prices = {["default"] = 4084.49, ["Fly|Ride"] = 3346.88, ["Neon|Fly|Ride"] = 7350, ["Mega|Fly|Ride"] = 24510.34}},
    ["rbxassetid://103896000727935"] = {name = "Aestus", prices = {["default"] = 104.99, ["Fly|Ride"] = 183.51, ["Neon"] = 477.75, ["Neon|Fly"] = 712.69, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 593.25, ["Mega|Ride"] = 2692.56, ["Mega|Fly|Ride"] = 2833.89}},
    ["rbxassetid://9922229151"] = {name = "Dragonfly", prices = {["default"] = 2.45, ["Fly"] = 212.52, ["Fly|Ride"] = 38.96, ["Neon"] = 19.69, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 36.26, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 160.1, ["Mega|Fly"] = 196.88, ["Mega|Ride"] = 368.73, ["Mega|Fly|Ride"] = 229.69}},
    ["rbxassetid://82820245821381"] = {name = "Temple Friend", prices = {["default"] = 3.76, ["Fly|Ride"] = 57.71, ["Neon"] = 22.32, ["Neon|Fly"] = 118.41, ["Neon|Ride"] = 64.26, ["Neon|Fly|Ride"] = 161.86, ["Mega"] = 161.44, ["Mega|Ride"] = 210, ["Mega|Fly|Ride"] = 361.59}},
    ["rbxassetid://6404812861"] = {name = "Diamond Ladybug", prices = {["default"] = 28.45, ["Fly|Ride"] = 56.11, ["Neon"] = 289.98, ["Neon|Ride"] = 274.2, ["Neon|Fly|Ride"] = 283.73, ["Mega|Fly|Ride"] = 1090.21}},
    ["rbxassetid://107535752953647"] = {name = "Strawberry Tortle", prices = {["default"] = 1147.59, ["Fly|Ride"] = 1049.24, ["Neon"] = 4392.69, ["Neon|Fly|Ride"] = 4250.3}},
    ["rbxassetid://95844539868957"] = {name = "Amethyst Penguin", prices = {["default"] = 6298.69, ["Fly|Ride"] = 7792.92}},
    ["rbxassetid://6240249282"] = {name = "Guardian Lion", prices = {["default"] = 21, ["Fly|Ride"] = 44.63, ["Neon"] = 452.13, ["Neon|Ride"] = 126, ["Neon|Fly|Ride"] = 135.19, ["Mega"] = 2520, ["Mega|Fly|Ride"] = 712.23}},
    ["rbxassetid://11496077150"] = {name = "Ice Moth Dragon", prices = {["default"] = 15.94, ["Fly|Ride"] = 82.2, ["Neon"] = 71.37, ["Neon|Ride"] = 87.94, ["Neon|Fly|Ride"] = 158, ["Mega"] = 886.57, ["Mega|Ride"] = 334.69, ["Mega|Fly|Ride"] = 567.42}},
    ["rbxassetid://5862774166"] = {name = "Skele-Rex", prices = {["default"] = 92.63, ["Fly|Ride"] = 142.7, ["Neon|Ride"] = 420, ["Neon|Fly|Ride"] = 459.38, ["Mega|Fly|Ride"] = 1844.07}},
    ["rbxassetid://11773429123"] = {name = "Nessie", prices = {["default"] = 208.69, ["Fly"] = 306.84, ["Fly|Ride"] = 339.94, ["Neon"] = 918.75, ["Neon|Ride"] = 1071.09, ["Neon|Fly|Ride"] = 984.38, ["Mega"] = 8500.58, ["Mega|Fly|Ride"] = 3968.72}},
    ["rbxassetid://121782270350526"] = {name = "Dark Choccybunny", prices = {["default"] = 4.73, ["Fly|Ride"] = 93.19, ["Neon"] = 21.76, ["Neon|Fly"] = 656.25, ["Neon|Ride"] = 53.13, ["Mega"] = 147.71, ["Mega|Fly"] = 236.97, ["Mega|Ride"] = 191.42, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://129591977577854"] = {name = "Ballet Swan", prices = {["default"] = 184.74, ["Fly|Ride"] = 309.88, ["Neon"] = 779.94, ["Neon|Fly"] = 708.75, ["Neon|Ride"] = 637.55, ["Neon|Fly|Ride"] = 774.38, ["Mega|Fly|Ride"] = 2576.44}},
    ["rbxassetid://9669227320"] = {name = "Zodiac Minion Chick", prices = {["default"] = 3.19, ["Fly"] = 32.82, ["Fly|Ride"] = 161.91, ["Neon"] = 28.79, ["Neon|Fly"] = 71.21, ["Neon|Ride"] = 37.4, ["Neon|Fly|Ride"] = 108.94, ["Mega"] = 225.75, ["Mega|Ride"] = 212.52, ["Mega|Fly|Ride"] = 274.67}},
    ["rbxassetid://13462536955"] = {name = "Caelum Cervi", prices = {["default"] = 231, ["Fly|Ride"] = 255.03, ["Neon"] = 1275.1, ["Neon|Ride"] = 1208.18, ["Neon|Fly|Ride"] = 831.6, ["Mega"] = 10625.72, ["Mega|Fly|Ride"] = 5476.32}},
    ["rbxassetid://10137833794"] = {name = "Green-Chested Pheasant", prices = {["default"] = 7.55, ["Fly|Ride"] = 68.25, ["Neon"] = 73.5, ["Neon|Fly"] = 306.89, ["Neon|Ride"] = 157.27, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 567.42, ["Mega|Ride"] = 496.23, ["Mega|Fly|Ride"] = 498.75}},
    ["rbxassetid://16994954002"] = {name = "Brachiosaurus", prices = {["default"] = 6.3, ["Fly|Ride"] = 72.19, ["Neon"] = 11.05, ["Neon|Fly"] = 170.46, ["Neon|Ride"] = 36.19, ["Neon|Fly|Ride"] = 140.27, ["Mega"] = 82.43, ["Mega|Ride"] = 71.25, ["Mega|Fly|Ride"] = 213.94}},
    ["rbxassetid://121938982134212"] = {name = "Gecko Ducky", prices = {["default"] = 2.1, ["Neon"] = 2.63, ["Mega"] = 18.25, ["Mega|Ride"] = 152.2, ["Mega|Fly|Ride"] = 167.9}},
    ["rbxassetid://17649624018"] = {name = "Kid Goat", prices = {["default"] = 2.15, ["Fly|Ride"] = 113.71, ["Neon"] = 6.49, ["Neon|Ride"] = 27.8, ["Neon|Fly|Ride"] = 89.25, ["Mega"] = 73.48, ["Mega|Fly"] = 161045.1, ["Mega|Ride"] = 76, ["Mega|Fly|Ride"] = 241.22}},
    ["rbxassetid://4440867127"] = {name = "Chicken", prices = {["default"] = 61.69, ["Fly|Ride"] = 186.16, ["Neon"] = 320.25, ["Neon|Fly"] = 327.97, ["Neon|Ride"] = 294, ["Neon|Fly|Ride"] = 368.82, ["Mega|Fly|Ride"] = 1049.9}},
    ["rbxassetid://5721844165"] = {name = "Tasmanian Tiger", prices = {["default"] = 2.1, ["Fly|Ride"] = 78.75, ["Neon"] = 7.48, ["Neon|Ride"] = 18.38, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 91.88, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 262.47}},
    ["rbxassetid://14146063876"] = {name = "Cockroach", prices = {["default"] = 8.51, ["Neon"] = 64.32, ["Neon|Fly"] = 241.64, ["Neon|Ride"] = 299.25, ["Mega"] = 261.19, ["Mega|Ride"] = 425.04}},
    ["rbxassetid://135555287601448"] = {name = "Rubber Ducky", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 54.57, ["Neon|Fly|Ride"] = 283.73, ["Mega"] = 13.1, ["Mega|Fly"] = 142.4, ["Mega|Ride"] = 64.81, ["Mega|Fly|Ride"] = 157.17}},
    ["rbxassetid://9664487060"] = {name = "Ant", prices = {["default"] = 2.1, ["Fly|Ride"] = 24.93, ["Neon"] = 2.1, ["Neon|Fly"] = 26.25, ["Neon|Ride"] = 14.2, ["Neon|Fly|Ride"] = 28.77, ["Mega"] = 13.86, ["Mega|Fly"] = 27.16, ["Mega|Ride"] = 20.61, ["Mega|Fly|Ride"] = 57.39}},
    ["rbxassetid://3293758505"] = {name = "Otter", prices = {["default"] = 2.1, ["Fly"] = 28.7, ["Fly|Ride"] = 66.95, ["Neon"] = 2.1, ["Neon|Fly"] = 20.99, ["Neon|Ride"] = 13.95, ["Neon|Fly|Ride"] = 42.83, ["Mega"] = 21, ["Mega|Fly"] = 161.86, ["Mega|Ride"] = 23.63, ["Mega|Fly|Ride"] = 64.32}},
    ["rbxassetid://79698905581979"] = {name = "Ms. Muffet", prices = {["default"] = 2.1, ["Neon"] = 2.26, ["Neon|Ride"] = 65.62, ["Mega"] = 19.14, ["Mega|Ride"] = 131.77, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://13620861015"] = {name = "Flying Fish", prices = {["default"] = 2.1, ["Fly|Ride"] = 107.63, ["Neon"] = 3.42, ["Neon|Fly"] = 121.14, ["Neon|Ride"] = 20.67, ["Neon|Fly|Ride"] = 81.55, ["Mega"] = 24.83, ["Mega|Fly"] = 91.88, ["Mega|Ride"] = 38.07, ["Mega|Fly|Ride"] = 98.44}},
    ["rbxassetid://100439668574210"] = {name = "Jiggly Jerboa", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 82.08, ["Neon|Fly|Ride"] = 425.04, ["Mega"] = 17.55, ["Mega|Fly"] = 131.25, ["Mega|Ride"] = 72.19, ["Mega|Fly|Ride"] = 212.84}},
    ["rbxassetid://14815828879"] = {name = "Ghost", prices = {["default"] = 3.35, ["Fly|Ride"] = 156.45, ["Neon"] = 12.99, ["Neon|Fly"] = 24.19, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 104.98, ["Mega"] = 131.22, ["Mega|Fly"] = 289.04, ["Mega|Ride"] = 125.89, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://140565380261180"] = {name = "Galapagos Sea Lion", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 43.32, ["Neon|Fly|Ride"] = 321.62, ["Mega"] = 12.7, ["Mega|Fly"] = 144.38, ["Mega|Ride"] = 69.77, ["Mega|Fly|Ride"] = 131.24}},
    ["rbxassetid://14146188240"] = {name = "Bluebottle Fly", prices = {["default"] = 2.15, ["Fly|Ride"] = 142.4, ["Neon"] = 18.14, ["Mega"] = 135.19, ["Mega|Fly"] = 315, ["Mega|Ride"] = 274.31, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://15930540035"] = {name = "Sandfish", prices = {["default"] = 2.1, ["Neon"] = 19.14, ["Neon|Ride"] = 71.21, ["Mega"] = 111.55, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 567.42}},
    ["rbxassetid://74774507671765"] = {name = "Island Tarsier", prices = {["default"] = 2.1, ["Neon"] = 4.22, ["Neon|Ride"] = 27.64, ["Neon|Fly|Ride"] = 141.75, ["Mega"] = 20.2, ["Mega|Ride"] = 39.38, ["Mega|Fly|Ride"] = 131.24}},
    ["rbxassetid://9678196095"] = {name = "Mouse", prices = {["default"] = 2.1, ["Fly|Ride"] = 26.24, ["Neon"] = 2.1, ["Neon|Fly"] = 15.94, ["Neon|Ride"] = 14.43, ["Neon|Fly|Ride"] = 37.7, ["Mega"] = 13.05, ["Mega|Fly"] = 32.76, ["Mega|Ride"] = 19.13, ["Mega|Fly|Ride"] = 49.87}},
    ["rbxassetid://100695038890951"] = {name = "Basic Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13104111122"] = {name = "Piranha", prices = {["default"] = 2.1, ["Fly|Ride"] = 118.1, ["Neon"] = 42.51, ["Neon|Ride"] = 140.95, ["Mega"] = 191.27, ["Mega|Ride"] = 240.19}},
    ["rbxassetid://110856597065248"] = {name = "Bakeneko", prices = {["default"] = 2.1, ["Neon"] = 6.49, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 105, ["Mega"] = 23.36, ["Mega|Ride"] = 47.87, ["Mega|Fly|Ride"] = 111.57}},
    ["rbxassetid://128979941112615"] = {name = "Dirty Ducky", prices = {["default"] = 2.1, ["Neon"] = 6.57, ["Mega"] = 82.69, ["Mega|Ride"] = 161.53, ["Mega|Fly|Ride"] = 254.61}},
    ["rbxassetid://12479656052"] = {name = "Maleo Bird", prices = {["default"] = 2.16, ["Fly|Ride"] = 39.38, ["Neon"] = 19.35, ["Neon|Ride"] = 42.51, ["Neon|Fly|Ride"] = 142.4, ["Mega"] = 124.69, ["Mega|Ride"] = 143.06, ["Mega|Fly|Ride"] = 193.27}},
    ["rbxassetid://3200646599"] = {name = "Cat", prices = {["default"] = 2.1, ["Fly|Ride"] = 31.48, ["Neon"] = 2.1, ["Neon|Fly"] = 15.64, ["Neon|Ride"] = 12.83, ["Neon|Fly|Ride"] = 26.25, ["Mega"] = 12.97, ["Mega|Fly"] = 28.18, ["Mega|Ride"] = 19.69, ["Mega|Fly|Ride"] = 48.34}},
    ["rbxassetid://12479810452"] = {name = "Bali Starling", prices = {["default"] = 2.1, ["Fly|Ride"] = 142.4, ["Neon"] = 10.63, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 196.47, ["Mega"] = 129.64, ["Mega|Ride"] = 160.78, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://9982819219"] = {name = "Dugong", prices = {["default"] = 5.13, ["Fly|Ride"] = 59.07, ["Neon"] = 48.57, ["Neon|Ride"] = 68.16, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 228.38, ["Mega|Ride"] = 291.38, ["Mega|Fly|Ride"] = 281.54}},
    ["rbxassetid://3181727229"] = {name = "Buffalo", prices = {["default"] = 2.1, ["Fly"] = 32.61, ["Fly|Ride"] = 28.7, ["Neon"] = 2.1, ["Neon|Fly"] = 15.65, ["Neon|Ride"] = 15.54, ["Neon|Fly|Ride"] = 32.76, ["Mega"] = 19.81, ["Mega|Ride"] = 31.5, ["Mega|Fly|Ride"] = 79.17}},
    ["rbxassetid://99694153348188"] = {name = "Urchin", prices = {["default"] = 3.94, ["Neon"] = 6.57, ["Neon|Ride"] = 35.47, ["Neon|Fly|Ride"] = 168.96, ["Mega"] = 63, ["Mega|Fly"] = 170.02, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 144.38}},
    ["rbxassetid://84089584046947"] = {name = "Blue Butterfly", prices = {["default"] = 2.1, ["Fly|Ride"] = 65.63, ["Neon"] = 3.5, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 42.51, ["Neon|Fly|Ride"] = 283.73, ["Mega"] = 26.31, ["Mega|Fly"] = 142.4, ["Mega|Ride"] = 59.07, ["Mega|Fly|Ride"] = 313.47}},
    ["rbxassetid://124485808787576"] = {name = "Tegu", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 19.68, ["Neon|Fly|Ride"] = 283.73, ["Mega"] = 11.7, ["Mega|Fly"] = 253.82, ["Mega|Ride"] = 39.4, ["Mega|Fly|Ride"] = 156.18}},
    ["rbxassetid://8938703774"] = {name = "Bullfrog", prices = {["default"] = 2.1, ["Fly|Ride"] = 46.56, ["Neon"] = 5.25, ["Neon|Fly"] = 54.21, ["Neon|Ride"] = 21.26, ["Neon|Fly|Ride"] = 63.76, ["Mega"] = 80.94, ["Mega|Ride"] = 84, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://102746202827395"] = {name = "Hopbop", prices = {["default"] = 2.1, ["Neon"] = 5.16, ["Neon|Ride"] = 26.25, ["Mega"] = 35.39, ["Mega|Fly"] = 241.58, ["Mega|Ride"] = 104.99, ["Mega|Fly|Ride"] = 221.81}},
    ["rbxassetid://6498255997"] = {name = "Stingray", prices = {["default"] = 2.1, ["Fly"] = 24.45, ["Fly|Ride"] = 72.19, ["Neon"] = 5.25, ["Neon|Fly"] = 80.96, ["Neon|Ride"] = 15.75, ["Neon|Fly|Ride"] = 57.39, ["Mega"] = 111.57, ["Mega|Ride"] = 90.55, ["Mega|Fly|Ride"] = 111.57}},
    ["rbxassetid://13104106555"] = {name = "Mosquito", prices = {["default"] = 3.94, ["Neon"] = 31.85, ["Neon|Fly"] = 188.89, ["Neon|Ride"] = 71.21, ["Neon|Fly|Ride"] = 178.78, ["Mega"] = 65.63, ["Mega|Fly"] = 341.25, ["Mega|Ride"] = 210}},
    ["rbxassetid://5721843483"] = {name = "Ground Sloth", prices = {["default"] = 2.1, ["Fly|Ride"] = 32.03, ["Neon"] = 9.19, ["Neon|Fly"] = 28.7, ["Neon|Ride"] = 32.22, ["Neon|Fly|Ride"] = 70.88, ["Mega"] = 263.53, ["Mega|Fly"] = 420, ["Mega|Ride"] = 121.44, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://4506925908"] = {name = "Robin", prices = {["default"] = 3.68, ["Fly"] = 149.1, ["Fly|Ride"] = 71.21, ["Neon"] = 11.45, ["Neon|Fly"] = 66.59, ["Neon|Ride"] = 32.55, ["Neon|Fly|Ride"] = 108.32, ["Mega"] = 170.02, ["Mega|Fly"] = 157.27, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 142.4}},
    ["rbxassetid://10382786163"] = {name = "Sado Mole", prices = {["default"] = 2.1, ["Neon"] = 7.88, ["Neon|Fly|Ride"] = 2625, ["Mega"] = 192.65, ["Mega|Ride"] = 236.25}},
    ["rbxassetid://14471275373"] = {name = "Ash Zebra", prices = {["default"] = 6.06, ["Neon"] = 202, ["Neon|Fly|Ride"] = 794.07, ["Mega"] = 567.42, ["Mega|Ride"] = 708.75, ["Mega|Fly|Ride"] = 981.75}},
    ["rbxassetid://15923574361"] = {name = "Armadillo", prices = {["default"] = 2.16, ["Neon"] = 44.61, ["Neon|Ride"] = 106.55, ["Mega"] = 161.86, ["Mega|Ride"] = 364.23, ["Mega|Fly|Ride"] = 321.3}},
    ["rbxassetid://15921927876"] = {name = "Coyote", prices = {["default"] = 6.29, ["Fly|Ride"] = 120.75, ["Neon"] = 32.95, ["Neon|Ride"] = 71.21, ["Mega"] = 311.07, ["Mega|Ride"] = 326.23, ["Mega|Fly|Ride"] = 387.16}},
    ["rbxassetid://74353184935672"] = {name = "Sheepdog Ducky", prices = {["default"] = 2.1, ["Neon"] = 2.58, ["Neon|Ride"] = 65.01, ["Mega"] = 15.48, ["Mega|Fly"] = 122.2, ["Mega|Ride"] = 127.52, ["Mega|Fly|Ride"] = 191.27}},
    ["rbxassetid://4748889845"] = {name = "Easter 2020 Egg", prices = {["default"] = 47.56}},
    ["rbxassetid://4752655872"] = {name = "Chick", prices = {["default"] = 2.63, ["Fly|Ride"] = 41.72, ["Neon"] = 44.61, ["Neon|Fly"] = 188.48, ["Neon|Ride"] = 56.39, ["Neon|Fly|Ride"] = 78.66, ["Mega|Ride"] = 208.68, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://17174085645"] = {name = "Garden Snake", prices = {["default"] = 2.1, ["Fly"] = 70.88, ["Fly|Ride"] = 64.32, ["Neon"] = 2.1, ["Neon|Fly"] = 52.8, ["Neon|Ride"] = 21.1, ["Neon|Fly|Ride"] = 105, ["Mega"] = 16.42, ["Mega|Fly"] = 142.4, ["Mega|Ride"] = 52.5, ["Mega|Fly|Ride"] = 98.42}},
    ["rbxassetid://17661844380"] = {name = "Show Pony", prices = {["default"] = 2.1, ["Neon"] = 4.19, ["Neon|Ride"] = 36.37, ["Neon|Fly|Ride"] = 74.43, ["Mega"] = 32.2, ["Mega|Ride"] = 63.76, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://8077196440"] = {name = "Walrus", prices = {["default"] = 2.52, ["Fly|Ride"] = 45.73, ["Neon"] = 6.3, ["Neon|Ride"] = 19.14, ["Neon|Fly|Ride"] = 59.07, ["Mega"] = 142.4, ["Mega|Ride"] = 118.01, ["Mega|Fly|Ride"] = 235.91}},
    ["rbxassetid://13104118499"] = {name = "Liger", prices = {["default"] = 3.42, ["Fly"] = 42.51, ["Fly|Ride"] = 57.75, ["Neon"] = 41.84, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 216.57, ["Mega"] = 163.65, ["Mega|Ride"] = 354.92, ["Mega|Fly|Ride"] = 318.78}},
    ["rbxassetid://120937667166493"] = {name = "Aye Aye", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Mega"] = 20.2, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 53.82, ["Mega|Fly|Ride"] = 121.14}},
    ["rbxassetid://3199974297"] = {name = "Cracked Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15348350458"] = {name = "Beluga Whale", prices = {["default"] = 2.1, ["Fly|Ride"] = 34.28, ["Neon"] = 3.75, ["Neon|Fly"] = 28.7, ["Neon|Ride"] = 18.14, ["Neon|Fly|Ride"] = 96.65, ["Mega"] = 26.31, ["Mega|Fly"] = 142.4, ["Mega|Ride"] = 37.97, ["Mega|Fly|Ride"] = 127.52}},
    ["rbxassetid://7126719464"] = {name = "Wolpertinger", prices = {["default"] = 2.1, ["Fly|Ride"] = 41.99, ["Neon"] = 2.6, ["Neon|Fly"] = 57.39, ["Neon|Ride"] = 18.16, ["Neon|Fly|Ride"] = 34.01, ["Mega"] = 48.33, ["Mega|Fly"] = 142.4, ["Mega|Ride"] = 52.5, ["Mega|Fly|Ride"] = 129.94}},
    ["rbxassetid://125112456358906"] = {name = "Frankenfeline", prices = {["default"] = 2.15, ["Fly|Ride"] = 142.4, ["Neon"] = 2.6, ["Neon|Ride"] = 39.19, ["Neon|Fly|Ride"] = 71.21, ["Mega"] = 56.05, ["Mega|Ride"] = 83.82, ["Mega|Fly|Ride"] = 248.06}},
    ["rbxassetid://80556114592490"] = {name = "Japanese Snow Fairy", prices = {["default"] = 2.1, ["Neon"] = 2.52, ["Neon|Ride"] = 28.7, ["Neon|Fly|Ride"] = 155567.57, ["Mega"] = 18.08, ["Mega|Fly"] = 106.45, ["Mega|Ride"] = 55.13, ["Mega|Fly|Ride"] = 136.48}},
    ["rbxassetid://124671555129102"] = {name = "Ratatoskr", prices = {["default"] = 2.1, ["Fly|Ride"] = 43.32, ["Neon"] = 2.3, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 20.36, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 18.17, ["Mega|Fly"] = 63.76, ["Mega|Ride"] = 36.3, ["Mega|Fly|Ride"] = 90.76}},
    ["rbxassetid://116184296449988"] = {name = "Pinkypillar", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 40.39, ["Mega"] = 15.94, ["Mega|Ride"] = 177.47}},
    ["rbxassetid://74353532164157"] = {name = "Red Panda Ducky", prices = {["default"] = 2.63, ["Neon"] = 2.1, ["Neon|Fly|Ride"] = 420, ["Mega"] = 28.88, ["Mega|Ride"] = 191.27, ["Mega|Fly|Ride"] = 263.53}},
    ["rbxassetid://4708551264"] = {name = "Bandicoot", prices = {["default"] = 2.1, ["Fly|Ride"] = 52.5, ["Neon"] = 4.29, ["Neon|Fly"] = 32.81, ["Neon|Ride"] = 15.59, ["Neon|Fly|Ride"] = 42, ["Mega"] = 26.25, ["Mega|Fly"] = 45.7, ["Mega|Ride"] = 50.75, ["Mega|Fly|Ride"] = 107.55}},
    ["rbxassetid://12480314681"] = {name = "Malaysian Tapir", prices = {["default"] = 8.24, ["Neon"] = 123.27, ["Neon|Ride"] = 174.57, ["Mega"] = 406.88, ["Mega|Ride"] = 497.44, ["Mega|Fly|Ride"] = 708.75}},
    ["rbxassetid://17482380743"] = {name = "Classic Teapot", prices = {["default"] = 2.1, ["Neon"] = 32.82, ["Neon|Ride"] = 157.5, ["Mega"] = 195.57, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://14146142724"] = {name = "Mongoose", prices = {["default"] = 2.63, ["Fly|Ride"] = 180.65, ["Neon"] = 18.08, ["Neon|Ride"] = 71.21, ["Neon|Fly|Ride"] = 425.04, ["Mega"] = 250.08, ["Mega|Ride"] = 454.79, ["Mega|Fly|Ride"] = 377.89}},
    ["rbxassetid://3181727351"] = {name = "Dog", prices = {["default"] = 2.1, ["Fly|Ride"] = 27.58, ["Neon"] = 2.1, ["Neon|Fly"] = 15.64, ["Neon|Ride"] = 13.84, ["Neon|Fly|Ride"] = 24.65, ["Mega"] = 13.52, ["Mega|Fly"] = 19.15, ["Mega|Ride"] = 19.16, ["Mega|Fly|Ride"] = 32.82}},
    ["rbxassetid://14267322852"] = {name = "Angelfish", prices = {["default"] = 5.25, ["Neon"] = 6.49, ["Neon|Fly"] = 67.79, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 708.75, ["Mega"] = 77.41, ["Mega|Ride"] = 52.5}},
    ["rbxassetid://110130591707207"] = {name = "California Condor", prices = {["default"] = 2.1, ["Fly"] = 71.21, ["Neon"] = 2.1, ["Neon|Fly"] = 31.91, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 85.01, ["Mega"] = 12.34, ["Mega|Fly"] = 63.76, ["Mega|Ride"] = 71.21, ["Mega|Fly|Ride"] = 127.52}},
    ["rbxassetid://123567499475377"] = {name = "Forest Sprite", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Fly"] = 60.9, ["Neon|Ride"] = 127.32, ["Mega"] = 11.82, ["Mega|Ride"] = 57.39, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://8663441035"] = {name = "Lunar White Tiger", prices = {["default"] = 2.1, ["Fly"] = 42.51, ["Fly|Ride"] = 43.22, ["Neon"] = 6.57, ["Neon|Fly"] = 71.17, ["Neon|Ride"] = 37.99, ["Neon|Fly|Ride"] = 75.91, ["Mega"] = 169.31, ["Mega|Fly"] = 193.27, ["Mega|Ride"] = 177.19, ["Mega|Fly|Ride"] = 292.04}},
    ["rbxassetid://16000498338"] = {name = "Groundhog", prices = {["default"] = 155.4, ["Fly|Ride"] = 410.79, ["Neon"] = 936.13, ["Neon|Fly|Ride"] = 973.32, ["Mega"] = 8500.58, ["Mega|Ride"] = 3330.11, ["Mega|Fly|Ride"] = 3336.48}},
    ["rbxassetid://73268582142443"] = {name = "Kelp Raider", prices = {["default"] = 2.1, ["Neon"] = 6.57, ["Neon|Ride"] = 64.31, ["Mega"] = 65.63, ["Mega|Ride"] = 191.27, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://16369178617"] = {name = "Ornate Horned Frog", prices = {["default"] = 5.25, ["Fly|Ride"] = 62.91, ["Neon"] = 32.45, ["Neon|Ride"] = 170.02, ["Neon|Fly|Ride"] = 142.4, ["Mega"] = 381.82, ["Mega|Ride"] = 530.23, ["Mega|Fly|Ride"] = 643.22}},
    ["rbxassetid://6245080170"] = {name = "Lunar Ox", prices = {["default"] = 2.1, ["Fly|Ride"] = 37.97, ["Neon"] = 6.57, ["Neon|Fly"] = 34.13, ["Neon|Ride"] = 29.78, ["Neon|Fly|Ride"] = 47.4, ["Mega"] = 46.78, ["Mega|Ride"] = 83.91, ["Mega|Fly|Ride"] = 143.75}},
    ["rbxassetid://92652981666929"] = {name = "Starmite", prices = {["default"] = 2.1, ["Fly|Ride"] = 92.59, ["Neon"] = 8.13, ["Neon|Ride"] = 65.37, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 71.21, ["Mega|Ride"] = 193.27, ["Mega|Fly|Ride"] = 419.99}},
    ["rbxassetid://9482496753"] = {name = "King Penguin", prices = {["default"] = 2.1, ["Fly"] = 35.35, ["Fly|Ride"] = 31.23, ["Neon"] = 21.06, ["Neon|Fly"] = 99.89, ["Neon|Ride"] = 31.45, ["Neon|Fly|Ride"] = 77.96, ["Mega|Ride"] = 279.47, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://10489161125"] = {name = "Tanuki", prices = {["default"] = 2.35, ["Fly|Ride"] = 118.13, ["Neon"] = 48.06, ["Neon|Fly|Ride"] = 465.94, ["Mega"] = 262.49, ["Mega|Ride"] = 335.66, ["Mega|Fly|Ride"] = 326.23}},
    ["rbxassetid://7126720060"] = {name = "Wyvern", prices = {["default"] = 3.89, ["Fly|Ride"] = 34.09, ["Neon"] = 24.96, ["Neon|Fly"] = 67.28, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 62.99, ["Mega"] = 262.5, ["Mega|Ride"] = 283.73, ["Mega|Fly|Ride"] = 229.68}},
    ["rbxassetid://4506925800"] = {name = "Swan", prices = {["default"] = 55.13, ["Fly"] = 110.52, ["Fly|Ride"] = 148.31, ["Neon"] = 341.24, ["Neon|Fly"] = 437.07, ["Neon|Ride"] = 397.69, ["Neon|Fly|Ride"] = 436.07, ["Mega|Fly|Ride"] = 1468.68}},
    ["rbxassetid://13621428133"] = {name = "Tortuga de la Isla", prices = {["default"] = 196.67, ["Fly|Ride"] = 318.97, ["Neon"] = 1208.18, ["Neon|Ride"] = 1133.78, ["Neon|Fly|Ride"] = 965.51, ["Mega"] = 10625.72, ["Mega|Fly|Ride"] = 4959.03}},
    ["rbxassetid://6684832189"] = {name = "Lamb", prices = {["default"] = 63.76, ["Fly|Ride"] = 117, ["Neon"] = 262.5, ["Neon|Ride"] = 290.34, ["Neon|Fly|Ride"] = 286.8, ["Mega|Ride"] = 1133.78, ["Mega|Fly|Ride"] = 1380.29}},
    ["rbxassetid://122365328950491"] = {name = "Blossom Snake", prices = {["default"] = 8.51, ["Neon"] = 24.94, ["Neon|Ride"] = 122.8, ["Neon|Fly|Ride"] = 283.4, ["Mega"] = 262.5, ["Mega|Ride"] = 244.13, ["Mega|Fly|Ride"] = 416.73}},
    ["rbxassetid://14360919997"] = {name = "Toasty Red Panda", prices = {["default"] = 8.61, ["Fly|Ride"] = 98.44, ["Neon"] = 44.63, ["Neon|Ride"] = 59.66, ["Neon|Fly|Ride"] = 212.52, ["Mega"] = 355.69, ["Mega|Ride"] = 292.74, ["Mega|Fly|Ride"] = 402.29}},
    ["rbxassetid://3181727278"] = {name = "Rabbit", prices = {["default"] = 2.1, ["Fly"] = 31.5, ["Fly|Ride"] = 44.68, ["Neon"] = 2.1, ["Neon|Fly"] = 21, ["Neon|Ride"] = 21.55, ["Neon|Fly|Ride"] = 39.37, ["Mega"] = 39.8, ["Mega|Fly"] = 147.37, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 413.44}},
    ["rbxassetid://14782579567"] = {name = "Nightmare Owl", prices = {["default"] = 7.07, ["Fly|Ride"] = 66.25, ["Neon"] = 403.54, ["Neon|Fly"] = 354.92, ["Neon|Ride"] = 113.04, ["Neon|Fly|Ride"] = 211.44, ["Mega"] = 425.04, ["Mega|Ride"] = 483.14, ["Mega|Fly|Ride"] = 732.38}},
    ["rbxassetid://6498256342"] = {name = "Narwhal", prices = {["default"] = 2.1, ["Fly"] = 42.51, ["Fly|Ride"] = 36.01, ["Neon"] = 10.02, ["Neon|Fly"] = 80.96, ["Neon|Ride"] = 28.7, ["Neon|Fly|Ride"] = 64.32, ["Mega"] = 157.5, ["Mega|Ride"] = 183.93, ["Mega|Fly|Ride"] = 200.37}},
    ["rbxassetid://9227407648"] = {name = "Ibex", prices = {["default"] = 2.1, ["Fly|Ride"] = 328.13, ["Neon"] = 22.32, ["Neon|Ride"] = 36.14, ["Mega"] = 198.72, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://16440727263"] = {name = "Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 34.01, ["Neon"] = 2.1, ["Neon|Ride"] = 19.68, ["Neon|Fly|Ride"] = 57.73, ["Mega"] = 15.58, ["Mega|Ride"] = 42.51, ["Mega|Fly|Ride"] = 78.74}},
    ["rbxassetid://10318106327"] = {name = "Yellow Butterfly", prices = {["default"] = 2.1, ["Fly|Ride"] = 44.63, ["Neon"] = 15.87, ["Neon|Fly"] = 106.26, ["Neon|Ride"] = 28.7, ["Neon|Fly|Ride"] = 147, ["Mega"] = 78.72, ["Mega|Ride"] = 105.1, ["Mega|Fly|Ride"] = 200.17}},
    ["rbxassetid://13894169749"] = {name = "Black Kite", prices = {["default"] = 2.5, ["Fly|Ride"] = 62.79, ["Neon"] = 15.94, ["Neon|Ride"] = 47.25, ["Mega"] = 131.18, ["Mega|Ride"] = 241.22, ["Mega|Fly|Ride"] = 230.99}},
    ["rbxassetid://4506925595"] = {name = "Polar Bear", prices = {["default"] = 103.85, ["Fly|Ride"] = 183.74, ["Neon"] = 489.56, ["Neon|Ride"] = 441.79, ["Neon|Fly|Ride"] = 524.94, ["Mega"] = 4250.3, ["Mega|Fly|Ride"] = 2255.96}},
    ["rbxassetid://14639006189"] = {name = "Canada Goose", prices = {["default"] = 7.86, ["Fly|Ride"] = 129.28, ["Neon"] = 78.74, ["Neon|Ride"] = 98.42, ["Neon|Fly|Ride"] = 216.57, ["Mega"] = 326.82, ["Mega|Ride"] = 430.87, ["Mega|Fly|Ride"] = 483}},
    ["rbxassetid://5721844402"] = {name = "Triceratops", prices = {["default"] = 2.1, ["Fly|Ride"] = 36.74, ["Neon"] = 13.13, ["Neon|Ride"] = 28.7, ["Neon|Fly|Ride"] = 120.64, ["Mega"] = 246.75, ["Mega|Ride"] = 186.38, ["Mega|Fly|Ride"] = 313.47}},
    ["rbxassetid://83805820117149"] = {name = "Golden Jaguar", prices = {["default"] = 23.55, ["Fly|Ride"] = 178.5, ["Neon"] = 107.63, ["Neon|Ride"] = 142.99, ["Neon|Fly|Ride"] = 617.82, ["Mega"] = 567.42, ["Mega|Fly"] = 850.07, ["Mega|Ride"] = 687.75, ["Mega|Fly|Ride"] = 645}},
    ["rbxassetid://13936754497"] = {name = "Pinocchio", prices = {["default"] = 9.06}},
    ["rbxassetid://17059776562"] = {name = "Ankylosaurus", prices = {["default"] = 15.75, ["Fly|Ride"] = 126.82, ["Neon"] = 36.74, ["Neon|Fly"] = 69.57, ["Neon|Ride"] = 85.79, ["Neon|Fly|Ride"] = 425.04, ["Mega"] = 425.04, ["Mega|Ride"] = 483.14, ["Mega|Fly|Ride"] = 884.14}},
    ["rbxassetid://3181727813"] = {name = "Horse", prices = {["default"] = 31.88, ["Fly"] = 53.17, ["Fly|Ride"] = 42.63, ["Neon|Fly"] = 101818.18, ["Neon|Ride"] = 162.64, ["Neon|Fly|Ride"] = 170.07, ["Mega"] = 1371.79, ["Mega|Fly|Ride"] = 567.42}},
    ["rbxassetid://101098195340953"] = {name = "Mexican Wolf", prices = {["default"] = 2.1, ["Neon"] = 3.8, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 21.19, ["Neon|Fly|Ride"] = 107.62, ["Mega"] = 29.56, ["Mega|Fly"] = 188.99, ["Mega|Ride"] = 58.95, ["Mega|Fly|Ride"] = 229.22}},
    ["rbxassetid://13894408663"] = {name = "Seagull", prices = {["default"] = 9.03, ["Fly"] = 28.7, ["Fly|Ride"] = 65.63, ["Neon"] = 57.48, ["Neon|Ride"] = 63.76, ["Mega"] = 283.73, ["Mega|Fly"] = 403.44, ["Mega|Ride"] = 275.63, ["Mega|Fly|Ride"] = 482.42}},
    ["rbxassetid://6998403532"] = {name = "Sasquatch", prices = {["default"] = 2.1, ["Fly|Ride"] = 65.54, ["Neon"] = 13.13, ["Neon|Fly"] = 186.9, ["Neon|Ride"] = 29.34, ["Neon|Fly|Ride"] = 71.31, ["Mega"] = 184.9, ["Mega|Ride"] = 199.4, ["Mega|Fly|Ride"] = 360.89}},
    ["rbxassetid://108348392849720"] = {name = "Water Opossum", prices = {["default"] = 2.1, ["Fly|Ride"] = 212.52, ["Neon"] = 3.29, ["Neon|Fly"] = 37.2, ["Neon|Ride"] = 32.7, ["Mega"] = 24.45, ["Mega|Ride"] = 57.39, ["Mega|Fly|Ride"] = 121.78}},
    ["rbxassetid://11758575705"] = {name = "Moon Rabbit", prices = {["default"] = 37.97, ["Fly|Ride"] = 68.25, ["Neon"] = 128.54, ["Neon|Ride"] = 205.48, ["Neon|Fly|Ride"] = 567.42, ["Mega"] = 956.32, ["Mega|Ride"] = 992.45, ["Mega|Fly|Ride"] = 866.25}},
    ["rbxassetid://15922874831"] = {name = "Roadrunner", prices = {["default"] = 3.6, ["Fly|Ride"] = 210, ["Neon"] = 95.81, ["Mega|Ride"] = 525}},
    ["rbxassetid://6060988175"] = {name = "Snowman", prices = {["default"] = 2.79, ["Fly|Ride"] = 48.2, ["Neon"] = 16.74, ["Neon|Fly"] = 85.01, ["Neon|Ride"] = 26.22, ["Neon|Fly|Ride"] = 74.06, ["Mega"] = 152.85, ["Mega|Ride"] = 210, ["Mega|Fly|Ride"] = 273.67}},
    ["rbxassetid://12720029414"] = {name = "Wood Pigeon", prices = {["default"] = 39.38, ["Fly|Ride"] = 262.5, ["Neon"] = 367.5, ["Neon|Ride"] = 656.25, ["Mega"] = 4511.27, ["Mega|Ride"] = 2165.63, ["Mega|Fly|Ride"] = 2592.7}},
    ["rbxassetid://136340738568203"] = {name = "Mr Whiskerpips", prices = {["default"] = 5.25, ["Fly|Ride"] = 57.66, ["Neon"] = 33.75, ["Neon|Ride"] = 48.37, ["Neon|Fly|Ride"] = 85.25, ["Mega"] = 252, ["Mega|Ride"] = 212.52, ["Mega|Fly|Ride"] = 319.79}},
    ["rbxassetid://127204329704553"] = {name = "German Shepherd", prices = {["default"] = 70.87, ["Fly|Ride"] = 141.75, ["Neon"] = 227.4, ["Neon|Fly"] = 323.04, ["Neon|Ride"] = 250.5, ["Neon|Fly|Ride"] = 314.74, ["Mega"] = 850.07, ["Mega|Ride"] = 938.97, ["Mega|Fly|Ride"] = 968.63}},
    ["rbxassetid://99868640713300"] = {name = "Puptune", prices = {["default"] = 19.2, ["Fly|Ride"] = 210.24, ["Neon"] = 81.37, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 196.85, ["Mega"] = 315, ["Mega|Ride"] = 335.79, ["Mega|Fly|Ride"] = 355.69}},
    ["rbxassetid://9993276067"] = {name = "2022 Uplift Butterfly", prices = {["default"] = 5.11, ["Fly|Ride"] = 71.21, ["Neon"] = 105.7, ["Neon|Ride"] = 145, ["Neon|Fly|Ride"] = 384.11, ["Mega"] = 212.52, ["Mega|Ride"] = 212.52, ["Mega|Fly|Ride"] = 538.74}},
    ["rbxassetid://136574776317301"] = {name = "Sweetheart Rat", prices = {["default"] = 14.32, ["Fly|Ride"] = 131.25, ["Neon"] = 53.84, ["Neon|Ride"] = 74.41, ["Neon|Fly|Ride"] = 438.38, ["Mega"] = 236.91, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 425.04}},
    ["rbxassetid://17649489402"] = {name = "Cow Calf", prices = {["default"] = 6.06, ["Fly|Ride"] = 72.19, ["Neon"] = 32.44, ["Neon|Ride"] = 59.06, ["Neon|Fly|Ride"] = 129.93, ["Mega"] = 276.63, ["Mega|Ride"] = 250.34, ["Mega|Fly|Ride"] = 347.83}},
    ["rbxassetid://77869404304609"] = {name = "Budgie Witch", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Fly"] = 94.74, ["Neon|Ride"] = 100.95, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 15.75, ["Mega|Ride"] = 142.4, ["Mega|Fly|Ride"] = 523.69}},
    ["rbxassetid://111676861947081"] = {name = "The Black Dog", prices = {["default"] = 3.89, ["Neon"] = 26.25, ["Neon|Ride"] = 184.9, ["Neon|Fly|Ride"] = 202.79, ["Mega"] = 228.38, ["Mega|Ride"] = 301.97, ["Mega|Fly|Ride"] = 425.04}},
    ["rbxassetid://13104122472"] = {name = "Borhyaena Gigantica", prices = {["default"] = 2.1, ["Neon"] = 28.88, ["Neon|Fly"] = 78.64, ["Neon|Ride"] = 71.21, ["Mega"] = 169.11, ["Mega|Ride"] = 282.66, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://105232492496005"] = {name = "Firefighter Gibbon", prices = {["default"] = 3.67, ["Fly|Ride"] = 120.83, ["Neon"] = 28.7, ["Neon|Ride"] = 82.89, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 124.69, ["Mega|Ride"] = 283.73, ["Mega|Fly|Ride"] = 519.74}},
    ["rbxassetid://3409443514"] = {name = "Elephant", prices = {["default"] = 459.17, ["Fly|Ride"] = 559.76, ["Neon"] = 1806.38, ["Neon|Fly"] = 1808.5, ["Neon|Ride"] = 1846.76, ["Neon|Fly|Ride"] = 1548.75, ["Mega|Fly|Ride"] = 5880}},
    ["rbxassetid://10137833682"] = {name = "Brown-Chested Pheasant", prices = {["default"] = 8.51, ["Fly|Ride"] = 42.51, ["Neon"] = 41.45, ["Neon|Ride"] = 70.14, ["Neon|Fly|Ride"] = 341.25, ["Mega"] = 183.75, ["Mega|Ride"] = 368.03, ["Mega|Fly|Ride"] = 351.73}},
    ["rbxassetid://12490691849"] = {name = "Gecko", prices = {["default"] = 5.7, ["Fly|Ride"] = 51.55, ["Neon"] = 39.38, ["Neon|Fly"] = 315, ["Neon|Ride"] = 71.65, ["Neon|Fly|Ride"] = 163.65, ["Mega"] = 331.87, ["Mega|Ride"] = 504.73, ["Mega|Fly|Ride"] = 381.48}},
    ["rbxassetid://9913459163"] = {name = "Trapdoor Snail", prices = {["default"] = 3.42, ["Fly|Ride"] = 50.78, ["Neon"] = 11.82, ["Neon|Ride"] = 49.95, ["Neon|Fly|Ride"] = 131.25}},
    ["rbxassetid://124413732651376"] = {name = "Gumball Caterpillar", prices = {["default"] = 2.1, ["Fly|Ride"] = 52.41, ["Neon"] = 5.25, ["Neon|Ride"] = 30.06, ["Neon|Fly|Ride"] = 99.89, ["Mega"] = 61.43, ["Mega|Fly"] = 283.73, ["Mega|Ride"] = 106.05, ["Mega|Fly|Ride"] = 217.34}},
    ["rbxassetid://96107383056013"] = {name = "Gummy Guana", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 23.6, ["Neon|Fly|Ride"] = 114.09, ["Mega"] = 22.32, ["Mega|Ride"] = 78.66, ["Mega|Fly|Ride"] = 225.28}},
    ["rbxassetid://3261465951"] = {name = "Blue Egg", prices = {["default"] = 1115.52}},
    ["rbxassetid://11245006051"] = {name = "Therapy Dog", prices = {["default"] = 7.41, ["Fly|Ride"] = 331.94, ["Neon"] = 65.25, ["Neon|Ride"] = 91.88, ["Mega"] = 397.42, ["Mega|Ride"] = 850.07, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://76323474173289"] = {name = "Kelp Crewmate", prices = {["default"] = 2.1, ["Neon"] = 5.13, ["Neon|Ride"] = 56.44, ["Neon|Fly|Ride"] = 993.04, ["Mega"] = 37.14, ["Mega|Ride"] = 129.94, ["Mega|Fly|Ride"] = 250.04}},
    ["rbxassetid://14978701264"] = {name = "Scarecrow Horse", prices = {["default"] = 3.42, ["Neon"] = 20.6, ["Neon|Fly"] = 142.4, ["Neon|Ride"] = 71.21, ["Neon|Fly|Ride"] = 262.4, ["Mega"] = 210, ["Mega|Ride"] = 362.37, ["Mega|Fly|Ride"] = 1062.58}},
    ["rbxassetid://3409443801"] = {name = "Lion", prices = {["default"] = 488.25, ["Fly|Ride"] = 498.75, ["Neon|Ride"] = 1259.11, ["Neon|Fly|Ride"] = 1246.88, ["Mega"] = 8858.26, ["Mega|Fly|Ride"] = 6298.69}},
    ["rbxassetid://13979014954"] = {name = "Fossa", prices = {["default"] = 3.56, ["Fly|Ride"] = 425.04, ["Neon"] = 19.69, ["Neon|Ride"] = 77.44, ["Neon|Fly|Ride"] = 193.27, ["Mega"] = 391.05, ["Mega|Ride"] = 483.14, ["Mega|Fly|Ride"] = 741.62}},
    ["rbxassetid://137886461285917"] = {name = "Angus Cow", prices = {["default"] = 2.1, ["Fly|Ride"] = 118.11, ["Neon"] = 2.63, ["Neon|Ride"] = 37.4, ["Neon|Fly|Ride"] = 57.39, ["Mega"] = 32.1, ["Mega|Ride"] = 75.95, ["Mega|Fly|Ride"] = 154.49}},
    ["rbxassetid://128343324254978"] = {name = "Blue Cat", prices = {["default"] = 2.1, ["Neon"] = 6.39, ["Neon|Ride"] = 142.63, ["Neon|Fly|Ride"] = 197.66, ["Mega"] = 32.78, ["Mega|Ride"] = 142.4, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://79274485636628"] = {name = "Indian Flying Fox", prices = {["default"] = 21, ["Fly|Ride"] = 212.52, ["Neon"] = 199.5, ["Neon|Ride"] = 179.82, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 548.37, ["Mega|Ride"] = 472.5, ["Mega|Fly|Ride"] = 544.69}},
    ["rbxassetid://96039704958671"] = {name = "Singularity Pisces", prices = {["default"] = 10.31, ["Neon"] = 104.81, ["Neon|Ride"] = 179.47, ["Neon|Fly|Ride"] = 483.14, ["Mega"] = 403.44, ["Mega|Ride"] = 482.34, ["Mega|Fly|Ride"] = 637.55}},
    ["rbxassetid://12489494348"] = {name = "Komodo Dragon", prices = {["default"] = 3.74, ["Neon"] = 96.94, ["Neon|Ride"] = 183.38, ["Mega"] = 622.69, ["Mega|Ride"] = 1083.84, ["Mega|Fly|Ride"] = 801.94}},
    ["rbxassetid://14360919129"] = {name = "Flaming Zebra", prices = {["default"] = 12.5, ["Neon"] = 167.28, ["Neon|Ride"] = 177.5, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 630, ["Mega|Ride"] = 567.42, ["Mega|Fly|Ride"] = 509.25}},
    ["rbxassetid://108242367048842"] = {name = "Honey Badger", prices = {["default"] = 393.75, ["Fly|Ride"] = 517.11, ["Neon"] = 850.07, ["Neon|Ride"] = 1133.78, ["Neon|Fly|Ride"] = 1102.5, ["Mega|Fly|Ride"] = 3346.87}},
    ["rbxassetid://11119262646"] = {name = "Evil Chickatrice", prices = {["default"] = 3.93, ["Fly"] = 78.75, ["Fly|Ride"] = 64.4, ["Neon"] = 198.17, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 142.4, ["Mega|Fly"] = 590.63, ["Mega|Ride"] = 561.1, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://120631772928905"] = {name = "Subzero Scorpion", prices = {["default"] = 3.94, ["Fly|Ride"] = 127.32, ["Neon"] = 38.57, ["Neon|Ride"] = 221.82, ["Mega"] = 167.9, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 629.99}},
    ["rbxassetid://70394243440806"] = {name = "Ghostly Cat", prices = {["default"] = 27.57, ["Neon"] = 91.77, ["Neon|Ride"] = 161.91, ["Neon|Fly|Ride"] = 260.78, ["Mega"] = 315, ["Mega|Fly"] = 708.75, ["Mega|Ride"] = 288.75, ["Mega|Fly|Ride"] = 465.92}},
    ["rbxassetid://108186720416551"] = {name = "Storm Condor", prices = {["default"] = 2.1, ["Fly|Ride"] = 212.52, ["Neon"] = 7.4, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 275.22, ["Mega"] = 36.75, ["Mega|Ride"] = 128.29, ["Mega|Fly|Ride"] = 250.79}},
    ["rbxassetid://11181152874"] = {name = "Mule", prices = {["default"] = 40.53, ["Neon"] = 315, ["Neon|Ride"] = 244.17, ["Neon|Fly|Ride"] = 425.04, ["Mega"] = 1630.59, ["Mega|Ride"] = 2094.4, ["Mega|Fly|Ride"] = 1365.6}},
    ["rbxassetid://94781392732758"] = {name = "Onza", prices = {["default"] = 2.1, ["Fly|Ride"] = 262.5, ["Neon"] = 7.38, ["Neon|Fly"] = 184.9, ["Neon|Ride"] = 43.88, ["Neon|Fly|Ride"] = 108.53, ["Mega"] = 59.07, ["Mega|Ride"] = 91.81, ["Mega|Fly|Ride"] = 225.75}},
    ["rbxassetid://102763887893057"] = {name = "Cherub Chipmunk", prices = {["default"] = 2.1, ["Fly|Ride"] = 98.21, ["Neon"] = 3.63, ["Neon|Fly"] = 32.82, ["Neon|Ride"] = 48.97, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 26.25, ["Mega|Fly"] = 112.88, ["Mega|Ride"] = 68.25, ["Mega|Fly|Ride"] = 184.9}},
    ["rbxassetid://104845330408668"] = {name = "Icy Porcupine", prices = {["default"] = 2.1, ["Fly|Ride"] = 127.62, ["Neon"] = 6.3, ["Neon|Ride"] = 56.67, ["Neon|Fly|Ride"] = 177.19, ["Mega"] = 77.9, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 313.47}},
    ["rbxassetid://12597275903"] = {name = "White Sand Dollar", prices = {["default"] = 45.65, ["Fly"] = 85.01, ["Fly|Ride"] = 274.16, ["Neon"] = 261.41, ["Neon|Ride"] = 320.46, ["Neon|Fly|Ride"] = 483.14, ["Mega|Ride"] = 1133.78, ["Mega|Fly|Ride"] = 1111.46}},
    ["rbxassetid://9901393350"] = {name = "Irish Water Spaniel", prices = {["default"] = 240.4, ["Fly|Ride"] = 318.94, ["Neon"] = 1476.99, ["Neon|Ride"] = 1246.88, ["Neon|Fly|Ride"] = 1470, ["Mega"] = 9662.66, ["Mega|Fly|Ride"] = 4724.99}},
    ["rbxassetid://128640048014369"] = {name = "River Otter", prices = {["default"] = 14.34, ["Neon"] = 22.32, ["Neon|Fly"] = 350.44, ["Mega"] = 114.19, ["Mega|Ride"] = 189, ["Mega|Fly|Ride"] = 262.4}},
    ["rbxassetid://138984599254588"] = {name = "Tree Sasquatch", prices = {["default"] = 2.1, ["Fly|Ride"] = 161.91, ["Neon"] = 6.57, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 142.4, ["Mega"] = 38.74, ["Mega|Fly"] = 164.07, ["Mega|Ride"] = 91.54, ["Mega|Fly|Ride"] = 196.76}},
    ["rbxassetid://15870220155"] = {name = "Vulture", prices = {["default"] = 2.1, ["Fly|Ride"] = 98.44, ["Neon"] = 32.81, ["Mega"] = 142.4, ["Mega|Ride"] = 351.75, ["Mega|Fly|Ride"] = 399}},
    ["rbxassetid://7734902490"] = {name = "Halloween Black Mummy Cat", prices = {["default"] = 2.1, ["Fly|Ride"] = 116.16, ["Neon"] = 18.27, ["Neon|Ride"] = 52.49, ["Neon|Fly|Ride"] = 139, ["Mega"] = 124.69, ["Mega|Fly"] = 118.12, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 347.82}},
    ["rbxassetid://116677376014234"] = {name = "Sunflower Friend", prices = {["default"] = 2.1, ["Neon"] = 8.47, ["Neon|Fly|Ride"] = 142.4, ["Mega"] = 32.69, ["Mega|Ride"] = 70.74, ["Mega|Fly|Ride"] = 397.42}},
    ["rbxassetid://13186022212"] = {name = "Grinmoire", prices = {["default"] = 2.1, ["Fly|Ride"] = 52.48, ["Neon"] = 4.28, ["Neon|Fly"] = 28.7, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 100.95, ["Mega"] = 39.47, ["Mega|Ride"] = 99.68, ["Mega|Fly|Ride"] = 249.37}},
    ["rbxassetid://11119263014"] = {name = "Chickatrice", prices = {["default"] = 2.1, ["Fly|Ride"] = 47.14, ["Neon"] = 15.18, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 39.68, ["Neon|Fly|Ride"] = 113.71, ["Mega"] = 156.15, ["Mega|Ride"] = 141.75, ["Mega|Fly|Ride"] = 728.44}},
    ["rbxassetid://13104110160"] = {name = "Blue Ringed Octopus", prices = {["default"] = 30.19, ["Fly|Ride"] = 85.32, ["Neon"] = 105, ["Neon|Ride"] = 175.42, ["Neon|Fly|Ride"] = 322.51, ["Mega"] = 393.75, ["Mega|Ride"] = 564.38, ["Mega|Fly|Ride"] = 525.98}},
    ["rbxassetid://16088265753"] = {name = "Flaming Fox", prices = {["default"] = 75.79, ["Fly|Ride"] = 139.13, ["Neon"] = 388.92, ["Neon|Fly"] = 430.64, ["Neon|Ride"] = 341.25, ["Neon|Fly|Ride"] = 455.44, ["Mega"] = 1984.89, ["Mega|Ride"] = 1558.8, ["Mega|Fly|Ride"] = 1515.94}},
    ["rbxassetid://84105347355723"] = {name = "Gibbon", prices = {["default"] = 2.1, ["Fly|Ride"] = 144.38, ["Neon"] = 3.76, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 26.2, ["Neon|Fly|Ride"] = 142.4, ["Mega"] = 32.69, ["Mega|Fly"] = 672, ["Mega|Ride"] = 88.2, ["Mega|Fly|Ride"] = 247.53}},
    ["rbxassetid://9543194411"] = {name = "Swordfish", prices = {["default"] = 2.1, ["Fly|Ride"] = 39.38, ["Neon"] = 3.73, ["Neon|Fly"] = 28.7, ["Neon|Ride"] = 20.88, ["Neon|Fly|Ride"] = 61.68, ["Mega"] = 37.2, ["Mega|Fly"] = 131.21, ["Mega|Ride"] = 68.13, ["Mega|Fly|Ride"] = 96.71}},
    ["rbxassetid://11706157391"] = {name = "Steppe Lion", prices = {["default"] = 2.63, ["Fly"] = 42.51, ["Neon"] = 48.37, ["Neon|Ride"] = 135.19, ["Mega"] = 530.23, ["Mega|Ride"] = 274.32, ["Mega|Fly|Ride"] = 368.73}},
    ["rbxassetid://18119064023"] = {name = "Bald Eagle", prices = {["default"] = 393.74, ["Fly|Ride"] = 637.55, ["Neon"] = 4250.3, ["Neon|Ride"] = 6562.5, ["Neon|Fly|Ride"] = 1771.88, ["Mega|Fly|Ride"] = 5701.5}},
    ["rbxassetid://6060991172"] = {name = "Lynx", prices = {["default"] = 52.41, ["Fly"] = 99.89, ["Fly|Ride"] = 85.22, ["Neon"] = 215, ["Neon|Ride"] = 181.61, ["Neon|Fly|Ride"] = 196.87, ["Mega|Ride"] = 757.39, ["Mega|Fly|Ride"] = 908.51}},
    ["rbxassetid://10614198346"] = {name = "Pomeranian", prices = {["default"] = 2.1, ["Fly|Ride"] = 282.83, ["Neon"] = 7.88, ["Neon|Ride"] = 48.57, ["Neon|Fly|Ride"] = 141.63, ["Mega"] = 78.75, ["Mega|Ride"] = 144.33, ["Mega|Fly|Ride"] = 273}},
    ["rbxassetid://13663102008"] = {name = "Angler Fish", prices = {["default"] = 2.1, ["Fly|Ride"] = 65.63, ["Neon"] = 45.35, ["Neon|Ride"] = 72.34, ["Mega|Fly|Ride"] = 317.72}},
    ["rbxassetid://5067925193"] = {name = "Toy Monkey", prices = {["default"] = 27.45, ["Fly|Ride"] = 106.07, ["Neon"] = 194.25, ["Neon|Ride"] = 274.2, ["Neon|Fly|Ride"] = 319.24, ["Mega"] = 2550.19, ["Mega|Ride"] = 2100, ["Mega|Fly|Ride"] = 1002.75}},
    ["rbxassetid://15698960105"] = {name = "Kookaburra", prices = {["default"] = 95.82, ["Fly"] = 119.44, ["Fly|Ride"] = 227.4, ["Neon"] = 322.6, ["Neon|Fly"] = 708.75, ["Neon|Ride"] = 483.28, ["Neon|Fly|Ride"] = 610.32, ["Mega"] = 8500.58, ["Mega|Fly|Ride"] = 2493.75}},
    ["rbxassetid://14266900917"] = {name = "Ring-tailed Lemur", prices = {["default"] = 236.69, ["Fly|Ride"] = 524.35, ["Neon"] = 708.75, ["Neon|Ride"] = 610.19, ["Neon|Fly|Ride"] = 1026.67, ["Mega|Fly|Ride"] = 3393.87}},
    ["rbxassetid://10467419131"] = {name = "Leopard Cat", prices = {["default"] = 16.25, ["Fly|Ride"] = 142.4, ["Neon"] = 85.2, ["Neon|Fly"] = 120.83, ["Neon|Ride"] = 89.15, ["Neon|Fly|Ride"] = 164.07, ["Mega"] = 389.8, ["Mega|Ride"] = 404.8, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://6498256485"] = {name = "Crab", prices = {["default"] = 2.1, ["Fly"] = 25.45, ["Fly|Ride"] = 47.16, ["Neon"] = 7.65, ["Neon|Ride"] = 23.39, ["Neon|Fly|Ride"] = 92.46, ["Mega"] = 93.18, ["Mega|Ride"] = 104.99, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://5721843587"] = {name = "Glyptodon", prices = {["default"] = 4.26, ["Fly|Ride"] = 47.25, ["Neon"] = 31.48, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 44.63, ["Neon|Fly|Ride"] = 87.92, ["Mega"] = 282.02, ["Mega|Ride"] = 414.3, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://13979141397"] = {name = "Giant Anteater", prices = {["default"] = 314.6, ["Fly|Ride"] = 645.18, ["Neon"] = 1569.1, ["Neon|Ride"] = 1827.63, ["Neon|Fly|Ride"] = 1772.37, ["Mega"] = 10200.69, ["Mega|Fly|Ride"] = 5118.75}},
    ["rbxassetid://109730629255705"] = {name = "Ruddy Duck", prices = {["default"] = 2.1, ["Neon"] = 3.94, ["Neon|Ride"] = 139.41, ["Neon|Fly|Ride"] = 118125, ["Mega"] = 28.24, ["Mega|Ride"] = 169.28}},
    ["rbxassetid://6498259006"] = {name = "Clownfish", prices = {["default"] = 3.07, ["Fly|Ride"] = 55.27, ["Neon"] = 22.32, ["Neon|Ride"] = 38.01, ["Neon|Fly|Ride"] = 96.65, ["Mega"] = 235.91, ["Mega|Ride"] = 212.52, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://11758569695"] = {name = "Amami Rabbit", prices = {["default"] = 14.47, ["Neon"] = 90.33, ["Neon|Fly"] = 425.04, ["Neon|Ride"] = 99.75, ["Neon|Fly|Ride"] = 355.35, ["Mega"] = 496.23, ["Mega|Ride"] = 573.2, ["Mega|Fly|Ride"] = 638.34}},
    ["rbxassetid://11505509482"] = {name = "Ice Wolf", prices = {["default"] = 98.34, ["Fly|Ride"] = 157.27, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 568.32, ["Mega|Fly|Ride"] = 2379.57}},
    ["rbxassetid://9994480266"] = {name = "Royal Palace Spaniel", prices = {["default"] = 18.02, ["Fly"] = 36.14, ["Fly|Ride"] = 49.26, ["Neon"] = 127.52, ["Neon|Ride"] = 89.3, ["Neon|Fly|Ride"] = 141.21, ["Mega"] = 708.75, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 548.9}},
    ["rbxassetid://100897154120273"] = {name = "Clumpty", prices = {["default"] = 2.1, ["Neon"] = 2.63, ["Neon|Ride"] = 142.48, ["Mega"] = 25.99, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://11108831285"] = {name = "Ocelot", prices = {["default"] = 2.1, ["Fly|Ride"] = 82.89, ["Neon"] = 2.1, ["Neon|Fly"] = 38.07, ["Neon|Ride"] = 24.45, ["Neon|Fly|Ride"] = 83.2, ["Mega"] = 26.65, ["Mega|Fly"] = 97.13, ["Mega|Ride"] = 41.99, ["Mega|Fly|Ride"] = 109.99}},
    ["rbxassetid://99323773370664"] = {name = "Dire Wolf", prices = {["default"] = 24.45, ["Fly|Ride"] = 131.25, ["Neon"] = 36.66, ["Neon|Ride"] = 89.06, ["Neon|Fly|Ride"] = 223.13, ["Mega"] = 160.02, ["Mega|Ride"] = 195.57, ["Mega|Fly|Ride"] = 302.13}},
    ["rbxassetid://17649307413"] = {name = "Mini Pig", prices = {["default"] = 1179.93, ["Fly|Ride"] = 1379.44, ["Neon"] = 4376.12, ["Neon|Ride"] = 7084.17, ["Neon|Fly|Ride"] = 4392.69, ["Mega|Fly|Ride"] = 12600}},
    ["rbxassetid://12720029753"] = {name = "Border Collie", prices = {["default"] = 406.88, ["Fly|Ride"] = 554.74, ["Neon"] = 1680, ["Neon|Ride"] = 1640.63, ["Neon|Fly|Ride"] = 1742.64, ["Mega"] = 17001.15, ["Mega|Fly|Ride"] = 7210.62}},
    ["rbxassetid://4440866760"] = {name = "Pig", prices = {["default"] = 278.66, ["Fly|Ride"] = 418.89, ["Neon"] = 787.5, ["Neon|Fly"] = 1128.44, ["Neon|Ride"] = 672.81, ["Neon|Fly|Ride"] = 734.79, ["Mega|Fly|Ride"] = 2916.23}},
    ["rbxassetid://4506925854"] = {name = "Arctic Fox", prices = {["default"] = 229.21, ["Fly"] = 468.61, ["Fly|Ride"] = 355.77, ["Neon"] = 708.75, ["Neon|Ride"] = 603.73, ["Neon|Fly|Ride"] = 656.24, ["Mega|Fly|Ride"] = 3011.34}},
    ["rbxassetid://11758575618"] = {name = "Black Moon Bear", prices = {["default"] = 2.1, ["Fly|Ride"] = 39.37, ["Neon"] = 3.94, ["Neon|Ride"] = 30.15, ["Neon|Fly|Ride"] = 105, ["Mega"] = 69.54, ["Mega|Fly"] = 112.65, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 150.94}},
    ["rbxassetid://15547272520"] = {name = "Christmas Pudding Pup", prices = {["default"] = 231, ["Fly|Ride"] = 433.13, ["Neon"] = 859.69, ["Neon|Ride"] = 1275.1, ["Neon|Fly|Ride"] = 1115.63, ["Mega"] = 21535.15, ["Mega|Ride"] = 5100.36, ["Mega|Fly|Ride"] = 3896.47}},
    ["rbxassetid://78519945248690"] = {name = "Zombie Chick", prices = {["default"] = 7.21, ["Fly|Ride"] = 91.88, ["Neon"] = 25.75, ["Neon|Fly"] = 37.47, ["Neon|Ride"] = 110.52, ["Neon|Fly|Ride"] = 254.63, ["Mega"] = 168.5, ["Mega|Ride"] = 284.02, ["Mega|Fly|Ride"] = 370.77}},
    ["rbxassetid://10357178561"] = {name = "Ibis", prices = {["default"] = 2.1, ["Fly|Ride"] = 38.98, ["Neon"] = 6.57, ["Neon|Ride"] = 42.51, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 104.81, ["Mega|Ride"] = 192.94}},
    ["rbxassetid://96759122303055"] = {name = "Clubtail Dragonfly", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 45.94, ["Mega"] = 26.25, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 177.62}},
    ["rbxassetid://12778628897"] = {name = "Karate Gorilla", prices = {["default"] = 28.76, ["Fly|Ride"] = 459.38, ["Neon"] = 244.13, ["Neon|Ride"] = 355.56, ["Mega"] = 1050, ["Mega|Ride"] = 510.04, ["Mega|Fly|Ride"] = 773.07}},
    ["rbxassetid://13104121371"] = {name = "Poison Dart Frog", prices = {["default"] = 2.1, ["Fly|Ride"] = 68.25, ["Neon"] = 6.57, ["Mega"] = 355.98, ["Mega|Ride"] = 411.24, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://71881209536633"] = {name = "Humbug", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 49.95, ["Neon|Fly|Ride"] = 118.11, ["Mega"] = 20.07, ["Mega|Ride"] = 70.26, ["Mega|Fly|Ride"] = 161.86}},
    ["rbxassetid://11109314958"] = {name = "Ghost Wolf", prices = {["default"] = 4.86, ["Fly|Ride"] = 78.64, ["Neon"] = 15.12, ["Neon|Fly"] = 113.71, ["Neon|Ride"] = 41.58, ["Neon|Fly|Ride"] = 105, ["Mega"] = 136.5, ["Mega|Ride"] = 113.89, ["Mega|Fly|Ride"] = 239.46}},
    ["rbxassetid://16088267136"] = {name = "Wildfire Hawk", prices = {["default"] = 5.77, ["Fly"] = 71.21, ["Neon"] = 30.19, ["Neon|Fly"] = 145, ["Neon|Ride"] = 142.4, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 238.83, ["Mega|Ride"] = 300.53, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://16898328648"] = {name = "Preppy Capuchin Monkey", prices = {["default"] = 20.2, ["Neon"] = 92.9, ["Neon|Ride"] = 184.9, ["Neon|Fly|Ride"] = 317.68, ["Mega"] = 398.61, ["Mega|Ride"] = 795.88}},
    ["rbxassetid://15921713413"] = {name = "Thorny Devil", prices = {["default"] = 2.1, ["Neon"] = 49.68, ["Neon|Fly"] = 49.23, ["Neon|Ride"] = 183.74, ["Neon|Fly|Ride"] = 283.73, ["Mega"] = 328.13, ["Mega|Ride"] = 419.73, ["Mega|Fly|Ride"] = 446.25}},
    ["rbxassetid://16441364976"] = {name = "Gold Mahi Mahi", prices = {["default"] = 2.1, ["Fly|Ride"] = 45.93, ["Neon"] = 3.68, ["Neon|Fly"] = 31.88, ["Neon|Ride"] = 28.54, ["Neon|Fly|Ride"] = 99.89, ["Mega"] = 45.94, ["Mega|Ride"] = 126, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://8077189117"] = {name = "Puffin", prices = {["default"] = 142.4, ["Fly|Ride"] = 229.69, ["Neon"] = 798.02, ["Neon|Ride"] = 907.35, ["Neon|Fly|Ride"] = 823.51, ["Mega"] = 8500.58, ["Mega|Fly|Ride"] = 3500.13}},
    ["rbxassetid://8663441120"] = {name = "Lunar Tiger", prices = {["default"] = 2.1, ["Fly|Ride"] = 36.14, ["Neon"] = 3.82, ["Neon|Fly"] = 40.39, ["Neon|Ride"] = 21.31, ["Neon|Fly|Ride"] = 47.23, ["Mega"] = 25.47, ["Mega|Ride"] = 53.29, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://17174216294"] = {name = "Skunk", prices = {["default"] = 6.57, ["Fly|Ride"] = 196.88, ["Neon"] = 55.59, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 773.03, ["Mega"] = 313.69, ["Mega|Ride"] = 309.75, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://13981141292"] = {name = "Kiwi", prices = {["default"] = 24.94, ["Fly|Ride"] = 170.63, ["Neon"] = 155.91, ["Neon|Ride"] = 355.69, ["Neon|Fly|Ride"] = 255.03, ["Mega"] = 786.19, ["Mega|Ride"] = 623.44, ["Mega|Fly|Ride"] = 850.07}},
    ["rbxassetid://3409443617"] = {name = "Meerkat", prices = {["default"] = 196.88, ["Fly|Ride"] = 296.63, ["Neon"] = 804.27, ["Neon|Ride"] = 682.5, ["Neon|Fly|Ride"] = 755.99, ["Mega|Fly|Ride"] = 3505.44}},
    ["rbxassetid://99042906016947"] = {name = "Seafoam Butterfly", prices = {["default"] = 18.9, ["Neon"] = 91.88, ["Neon|Ride"] = 212.52, ["Mega"] = 287.44, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 318.78}},
    ["rbxassetid://15504847683"] = {name = "Gingerbread Hare", prices = {["default"] = 7.23, ["Fly|Ride"] = 637.55, ["Neon"] = 114.27, ["Neon|Fly"] = 161.91, ["Neon|Ride"] = 211.44, ["Neon|Fly|Ride"] = 159.95, ["Mega"] = 779.94, ["Mega|Ride"] = 850.07, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://15302316802"] = {name = "Peppermint Penguin", prices = {["default"] = 866.25, ["Fly|Ride"] = 1036.88, ["Neon|Ride"] = 4790.63, ["Neon|Fly|Ride"] = 4632.83, ["Mega|Fly|Ride"] = 17000.09}},
    ["rbxassetid://10318106124"] = {name = "Scarlet Butterfly", prices = {["default"] = 7.69, ["Fly|Ride"] = 94.25, ["Neon"] = 21.26, ["Neon|Fly"] = 58.14, ["Neon|Ride"] = 55.13, ["Neon|Fly|Ride"] = 212.52, ["Mega"] = 229.5, ["Mega|Fly|Ride"] = 337.92}},
    ["rbxassetid://14145989411"] = {name = "Toy Poodle", prices = {["default"] = 6.3, ["Fly|Ride"] = 54.21, ["Neon"] = 38.75, ["Neon|Ride"] = 96.67, ["Neon|Fly|Ride"] = 80.94, ["Mega"] = 527.05, ["Mega|Fly"] = 1260, ["Mega|Ride"] = 210}},
    ["rbxassetid://82833859118891"] = {name = "Snowy Mammoth", prices = {["default"] = 2.1, ["Fly"] = 85.01, ["Fly|Ride"] = 95.64, ["Neon"] = 6.24, ["Neon|Ride"] = 46.38, ["Neon|Fly|Ride"] = 170.62, ["Mega"] = 65.63, ["Mega|Ride"] = 350.87, ["Mega|Fly|Ride"] = 386.52}},
    ["rbxassetid://12917346501"] = {name = "Happy Duckling", prices = {["default"] = 9.19, ["Fly|Ride"] = 93.54, ["Neon"] = 66.94, ["Neon|Fly"] = 143.83, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 141.75, ["Mega"] = 435.75, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 456.75}},
    ["rbxassetid://7064993901"] = {name = "2021 Uplift Butterfly", prices = {["default"] = 2.1, ["Fly|Ride"] = 51.91, ["Neon"] = 17.07, ["Neon|Fly"] = 42.74, ["Neon|Ride"] = 29.77, ["Neon|Fly|Ride"] = 65.24, ["Mega"] = 115.5, ["Mega|Fly"] = 280.98, ["Mega|Ride"] = 126.46, ["Mega|Fly|Ride"] = 186.27}},
    ["rbxassetid://10926054144"] = {name = "Slug", prices = {["default"] = 3.94, ["Neon"] = 13.32, ["Neon|Fly"] = 13125, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 124.48, ["Mega|Ride"] = 201.72, ["Mega|Fly|Ride"] = 483.14}},
    ["rbxassetid://11571113906"] = {name = "Glacier Moth", prices = {["default"] = 157.5, ["Fly|Ride"] = 425.04, ["Neon"] = 920.19, ["Neon|Fly|Ride"] = 1411.11, ["Mega|Fly|Ride"] = 3756.2}},
    ["rbxassetid://73641371341710"] = {name = "Ice Cube", prices = {["default"] = 2.1, ["Fly|Ride"] = 108.94, ["Neon"] = 6.2, ["Neon|Fly"] = 34.17, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 61.69, ["Mega|Fly"] = 425.04, ["Mega|Ride"] = 127.36, ["Mega|Fly|Ride"] = 283.73}},
    ["rbxassetid://13077767764"] = {name = "Eel", prices = {["default"] = 3.22, ["Fly|Ride"] = 88.86, ["Neon"] = 27.86, ["Neon|Fly"] = 196.88, ["Neon|Ride"] = 188.26, ["Mega"] = 175.88, ["Mega|Ride"] = 321.57, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://134995672989153"] = {name = "Hammerhead Shark", prices = {["default"] = 3.29, ["Neon"] = 9.19, ["Neon|Ride"] = 85.01, ["Mega"] = 94.37, ["Mega|Ride"] = 120.52, ["Mega|Fly|Ride"] = 459.27}},
    ["rbxassetid://15555939727"] = {name = "Snow Monkey", prices = {["default"] = 69.43, ["Fly|Ride"] = 315, ["Neon"] = 491.98, ["Neon|Ride"] = 392.44, ["Neon|Fly|Ride"] = 645, ["Mega"] = 2550.19, ["Mega|Ride"] = 1611.26, ["Mega|Fly|Ride"] = 1611.26}},
    ["rbxassetid://11758575992"] = {name = "Water Rabbit", prices = {["default"] = 23, ["Fly|Ride"] = 255.03, ["Neon"] = 131.25, ["Neon|Ride"] = 163.65, ["Neon|Fly|Ride"] = 341.93, ["Mega"] = 637.55, ["Mega|Ride"] = 609.93, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://90987982535884"] = {name = "Great Pyrenees", prices = {["default"] = 20.56, ["Fly|Ride"] = 97.13, ["Neon"] = 81.38, ["Neon|Fly"] = 65.25, ["Neon|Ride"] = 124.69, ["Neon|Fly|Ride"] = 242.24, ["Mega"] = 480.3, ["Mega|Ride"] = 392.77, ["Mega|Fly|Ride"] = 459.37}},
    ["rbxassetid://84560154336174"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Neon"] = 6.34, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 236.25, ["Mega"] = 103.69, ["Mega|Ride"] = 163.13, ["Mega|Fly|Ride"] = 482.42}},
    ["rbxassetid://4506847061"] = {name = "Reindeer", prices = {["default"] = 41.45, ["Fly|Ride"] = 154.6, ["Neon"] = 262.49, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 288.78, ["Neon|Fly|Ride"] = 309.23, ["Mega|Fly|Ride"] = 1011.71}},
    ["rbxassetid://98687388677942"] = {name = "Moonpine", prices = {["default"] = 2.1, ["Fly|Ride"] = 52.5, ["Neon"] = 5.9, ["Neon|Ride"] = 57.39, ["Neon|Fly|Ride"] = 126.46, ["Mega"] = 57.39, ["Mega|Fly|Ride"] = 301.88}},
    ["rbxassetid://11109032702"] = {name = "Green Amazon", prices = {["default"] = 20.45, ["Fly|Ride"] = 89.42, ["Neon"] = 70.01, ["Neon|Ride"] = 79.75, ["Neon|Fly|Ride"] = 210, ["Mega"] = 393.75, ["Mega|Fly"] = 971.25, ["Mega|Ride"] = 313.47, ["Mega|Fly|Ride"] = 425.04}},
    ["rbxassetid://3743730108"] = {name = "Black Panther", prices = {["default"] = 36.51, ["Fly|Ride"] = 138.96, ["Neon"] = 258.57, ["Neon|Fly"] = 425.04, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 328.13, ["Mega|Ride"] = 1380.29, ["Mega|Fly|Ride"] = 1254.75}},
    ["rbxassetid://3181727398"] = {name = "Chocolate Labrador", prices = {["default"] = 2.1, ["Fly|Ride"] = 28.84, ["Neon"] = 2.1, ["Neon|Fly"] = 24.4, ["Neon|Ride"] = 15.94, ["Neon|Fly|Ride"] = 39.37, ["Mega"] = 17.07, ["Mega|Fly"] = 120.8, ["Mega|Ride"] = 32.82, ["Mega|Fly|Ride"] = 93.28}},
    ["rbxassetid://134636987874448"] = {name = "Nebula Snake", prices = {["default"] = 2.1, ["Fly|Ride"] = 131.25, ["Neon"] = 20.58, ["Neon|Ride"] = 65.6, ["Neon|Fly|Ride"] = 425.04, ["Mega"] = 227.4, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 392.43}},
    ["rbxassetid://13104122150"] = {name = "Hippo", prices = {["default"] = 10.5, ["Fly|Ride"] = 85.32, ["Neon"] = 110.13, ["Neon|Ride"] = 131.23, ["Neon|Fly|Ride"] = 210, ["Mega"] = 475.3, ["Mega|Ride"] = 444.94, ["Mega|Fly|Ride"] = 637.55}},
    ["rbxassetid://103821295208934"] = {name = "Black Rhino", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 28.86, ["Neon|Fly|Ride"] = 95.81, ["Mega"] = 19.23, ["Mega|Ride"] = 55.13, ["Mega|Fly|Ride"] = 210.4}},
    ["rbxassetid://14782580070"] = {name = "Undead Elk", prices = {["default"] = 15.75, ["Fly|Ride"] = 131.24, ["Neon"] = 119.42, ["Neon|Ride"] = 232.32, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 652.43, ["Mega|Fly"] = 787.5, ["Mega|Ride"] = 535.42, ["Mega|Fly|Ride"] = 637.55}},
    ["rbxassetid://8566683782"] = {name = "Giant Blue Scarab", prices = {["default"] = 9.63, ["Fly|Ride"] = 142.4, ["Neon"] = 376.69, ["Neon|Ride"] = 118.18, ["Neon|Fly|Ride"] = 129.94, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 472.49}},
    ["rbxassetid://14850232913"] = {name = "Cute-A-Cabra", prices = {["default"] = 6.46, ["Neon"] = 40.36, ["Neon|Fly"] = 699.57, ["Neon|Ride"] = 37.47, ["Neon|Fly|Ride"] = 708.75, ["Mega"] = 231, ["Mega|Ride"] = 264.3, ["Mega|Fly|Ride"] = 425.04}},
    ["rbxassetid://15508248825"] = {name = "Eggnog Dog", prices = {["default"] = 5.25, ["Fly|Ride"] = 196.88, ["Neon"] = 49.1, ["Neon|Ride"] = 88.2, ["Neon|Fly|Ride"] = 129.93, ["Mega"] = 212.52, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 362.37}},
    ["rbxassetid://17822797244"] = {name = "Orange Betta Fish", prices = {["default"] = 2.1, ["Fly|Ride"] = 196.88, ["Neon"] = 6.02, ["Neon|Ride"] = 39.29, ["Mega"] = 53.82, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 111.14, ["Mega|Fly|Ride"] = 280.53}},
    ["rbxassetid://9922274393"] = {name = "Retired Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://103431939950304"] = {name = "Pink Dog", prices = {["default"] = 2.1, ["Neon"] = 2.63, ["Neon|Ride"] = 48.35, ["Mega"] = 22.3, ["Mega|Ride"] = 125.4, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://15227882502"] = {name = "Christmas Future Egg", prices = {["default"] = 11.68}},
    ["rbxassetid://12597276740"] = {name = "Red Sand Dollar", prices = {["default"] = 36.54, ["Neon"] = 184.57, ["Neon|Ride"] = 212.52, ["Neon|Fly|Ride"] = 313.69, ["Mega"] = 1842.51, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 888.57}},
    ["rbxassetid://136447612467002"] = {name = "Glyptodon Ducky", prices = {["default"] = 2.1, ["Neon"] = 2.63, ["Neon|Ride"] = 27.45, ["Mega"] = 19.14, ["Mega|Ride"] = 121.14, ["Mega|Fly|Ride"] = 318.78}},
    ["rbxassetid://101033810950061"] = {name = "Sea Slug", prices = {["default"] = 483.19, ["Fly|Ride"] = 902.52, ["Neon"] = 2833.89, ["Neon|Ride"] = 2018.9, ["Neon|Fly|Ride"] = 2635.2, ["Mega"] = 17001.15, ["Mega|Fly|Ride"] = 10500}},
    ["rbxassetid://14353536658"] = {name = "Birthday Butterfly 2023", prices = {["default"] = 3.85, ["Fly|Ride"] = 106.26, ["Neon"] = 35.39, ["Neon|Fly"] = 183.75, ["Neon|Ride"] = 113.71, ["Mega"] = 95.86, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 283.73}},
    ["rbxassetid://9938967851"] = {name = "Tan Chow-Chow", prices = {["default"] = 2.1, ["Fly|Ride"] = 115.83, ["Neon"] = 19.45, ["Neon|Ride"] = 62.68, ["Neon|Fly|Ride"] = 99.65, ["Mega"] = 118.13, ["Mega|Fly"] = 283.73, ["Mega|Ride"] = 157.27, ["Mega|Fly|Ride"] = 216.57}},
    ["rbxassetid://14448124117"] = {name = "Chipmunk", prices = {["default"] = 3.94, ["Fly|Ride"] = 71.54, ["Neon"] = 55.53, ["Neon|Ride"] = 142.4, ["Neon|Fly|Ride"] = 301.88, ["Mega"] = 673.68, ["Mega|Ride"] = 561.75, ["Mega|Fly|Ride"] = 446.25}},
    ["rbxassetid://13104108894"] = {name = "Lammergeier", prices = {["default"] = 2.1, ["Fly|Ride"] = 708.75, ["Neon"] = 18.14, ["Neon|Fly"] = 36.14, ["Neon|Ride"] = 104.99, ["Neon|Fly|Ride"] = 392.44, ["Mega"] = 275.63, ["Mega|Fly|Ride"] = 708.75}},
    ["rbxassetid://14446659851"] = {name = "Raccoon", prices = {["default"] = 9.1, ["Fly|Ride"] = 149.61, ["Neon"] = 72.55, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 273, ["Mega"] = 292.81, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 637.93}},
    ["rbxassetid://84477079324217"] = {name = "Peachick", prices = {["default"] = 4.26, ["Fly|Ride"] = 52.5, ["Neon"] = 27.46, ["Neon|Ride"] = 79.19, ["Neon|Fly|Ride"] = 142.4, ["Mega"] = 227.07, ["Mega|Ride"] = 313.69, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://9718162456"] = {name = "Donkey", prices = {["default"] = 2.1, ["Fly|Ride"] = 76.67, ["Neon"] = 2.1, ["Neon|Fly"] = 23.39, ["Neon|Ride"] = 15.88, ["Neon|Fly|Ride"] = 76.52, ["Mega"] = 15.44, ["Mega|Fly"] = 65.24, ["Mega|Ride"] = 35.41, ["Mega|Fly|Ride"] = 91.38}},
    ["rbxassetid://93800993117604"] = {name = "Love Bird", prices = {["default"] = 7.27, ["Fly|Ride"] = 106.26, ["Neon"] = 25.54, ["Neon|Fly"] = 120.83, ["Neon|Ride"] = 28.88, ["Neon|Fly|Ride"] = 196.89, ["Mega"] = 157.5, ["Mega|Ride"] = 210, ["Mega|Fly|Ride"] = 276.94}},
    ["rbxassetid://13665143675"] = {name = "Lion Cub", prices = {["default"] = 326.71, ["Fly|Ride"] = 360.94, ["Neon"] = 1312.5, ["Neon|Ride"] = 1246.88, ["Neon|Fly|Ride"] = 1253.44, ["Mega|Ride"] = 9372.8, ["Mega|Fly|Ride"] = 4661.51}},
    ["rbxassetid://13883284001"] = {name = "Ice Cream Hermit Crab", prices = {["default"] = 79.68, ["Fly|Ride"] = 283.73, ["Neon"] = 356.57, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 585.38, ["Mega"] = 2267.54, ["Mega|Ride"] = 1691.63, ["Mega|Fly|Ride"] = 1442.63}},
    ["rbxassetid://8938701212"] = {name = "Woodpecker", prices = {["default"] = 2.1, ["Fly|Ride"] = 35.07, ["Neon"] = 5.24, ["Neon|Fly"] = 30.26, ["Neon|Ride"] = 34.01, ["Neon|Fly|Ride"] = 57.39, ["Mega"] = 88.2, ["Mega|Fly"] = 65.24, ["Mega|Ride"] = 78.91, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://4800190034"] = {name = "Toucan", prices = {["default"] = 2.1, ["Fly|Ride"] = 32.95, ["Neon"] = 6.56, ["Neon|Fly"] = 42.51, ["Neon|Ride"] = 25.11, ["Neon|Fly|Ride"] = 56.43, ["Mega"] = 65.63, ["Mega|Fly"] = 283.73, ["Mega|Ride"] = 76.13, ["Mega|Fly|Ride"] = 174.27}},
    ["rbxassetid://15886122789"] = {name = "Deathstalker Scorpion", prices = {["default"] = 2.1, ["Fly"] = 99.89, ["Fly|Ride"] = 98.44, ["Neon"] = 99.89, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 411.24, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://12139402705"] = {name = "Sheeeeep", prices = {["default"] = 223.13, ["Fly|Ride"] = 393.17, ["Neon"] = 1181.25, ["Neon|Ride"] = 1050, ["Neon|Fly|Ride"] = 1574.74, ["Mega|Ride"] = 8500.58, ["Mega|Fly|Ride"] = 3434.82}},
    ["rbxassetid://7126720389"] = {name = "Hydra", prices = {["default"] = 2.1, ["Fly|Ride"] = 26.25, ["Neon"] = 13.13, ["Neon|Fly"] = 104.97, ["Neon|Ride"] = 29.94, ["Neon|Fly|Ride"] = 75.7, ["Mega"] = 255.93, ["Mega|Ride"] = 221.82, ["Mega|Fly|Ride"] = 322.6}},
    ["rbxassetid://17662289865"] = {name = "Punk Pony", prices = {["default"] = 2.1, ["Fly|Ride"] = 340.04, ["Neon"] = 26.42, ["Neon|Ride"] = 42.72, ["Neon|Fly|Ride"] = 283.73, ["Mega"] = 183.75, ["Mega|Ride"] = 300.2, ["Mega|Fly|Ride"] = 454.79}},
    ["rbxassetid://84009422958505"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Neon"] = 6.47, ["Neon|Ride"] = 156.09, ["Mega"] = 68.25, ["Mega|Fly"] = 195.53, ["Mega|Ride"] = 262.49, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://9473352533"] = {name = "Space Whale", prices = {["default"] = 11.87, ["Fly|Ride"] = 80.96, ["Neon"] = 118.13, ["Neon|Ride"] = 72.19, ["Neon|Fly|Ride"] = 139.55, ["Mega"] = 460.69, ["Mega|Ride"] = 438.38, ["Mega|Fly|Ride"] = 588}},
    ["rbxassetid://71528203783155"] = {name = "Pupcake", prices = {["default"] = 42.93, ["Fly|Ride"] = 297.05, ["Neon"] = 103.58, ["Neon|Fly"] = 212.52, ["Neon|Ride"] = 160.76, ["Neon|Fly|Ride"] = 419.73, ["Mega"] = 456.62, ["Mega|Fly"] = 2231.41, ["Mega|Ride"] = 486.09, ["Mega|Fly|Ride"] = 553.09}},
    ["rbxassetid://4440867010"] = {name = "Drake", prices = {["default"] = 24.85, ["Fly"] = 85.01, ["Fly|Ride"] = 109.56, ["Neon"] = 113.71, ["Neon|Fly"] = 286.43, ["Neon|Ride"] = 213.51, ["Neon|Fly|Ride"] = 229.69, ["Mega"] = 850.07, ["Mega|Ride"] = 700.88, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://9708962205"] = {name = "Parakeet", prices = {["default"] = 2.1, ["Fly"] = 19.58, ["Fly|Ride"] = 29.77, ["Neon"] = 2.1, ["Neon|Fly"] = 31.39, ["Neon|Ride"] = 14.86, ["Neon|Fly|Ride"] = 46.76, ["Mega"] = 17.73, ["Mega|Fly"] = 425.04, ["Mega|Ride"] = 33.38, ["Mega|Fly|Ride"] = 94.23}},
    ["rbxassetid://4883302468"] = {name = "Shrew", prices = {["default"] = 184.95, ["Fly|Ride"] = 272.97, ["Neon"] = 2572.15, ["Neon|Ride"] = 918.75, ["Neon|Fly|Ride"] = 1055.66, ["Mega|Fly|Ride"] = 3965.54}},
    ["rbxassetid://11507151679"] = {name = "Irish Elk", prices = {["default"] = 15.94, ["Fly|Ride"] = 104.99, ["Neon"] = 78.75, ["Neon|Ride"] = 133.92, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 430.5, ["Mega|Ride"] = 454.09, ["Mega|Fly|Ride"] = 446.25}},
    ["rbxassetid://17163957321"] = {name = "Blue Jay", prices = {["default"] = 2.1, ["Fly|Ride"] = 42.74, ["Neon"] = 5.24, ["Neon|Fly"] = 40.39, ["Neon|Ride"] = 27.64, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 59.21, ["Mega|Ride"] = 59.07, ["Mega|Fly|Ride"] = 198.72}},
    ["rbxassetid://8705079225"] = {name = "Abyssinian Cat", prices = {["default"] = 2.1, ["Fly|Ride"] = 45.94, ["Neon"] = 2.63, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 25.51, ["Neon|Fly|Ride"] = 127.52, ["Mega"] = 19.35, ["Mega|Fly"] = 142.4, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 78.75}},
    ["rbxassetid://17059483392"] = {name = "Velociraptor", prices = {["default"] = 3.94, ["Fly|Ride"] = 72.19, ["Neon"] = 15.94, ["Neon|Fly"] = 724.9, ["Neon|Ride"] = 49.87, ["Neon|Fly|Ride"] = 99.75, ["Mega"] = 103.69, ["Mega|Ride"] = 131.78, ["Mega|Fly|Ride"] = 275.63}},
    ["rbxassetid://16548686870"] = {name = "Hamster", prices = {["default"] = 8.28, ["Fly|Ride"] = 80.96, ["Neon"] = 48.27, ["Neon|Fly"] = 269.91, ["Neon|Ride"] = 56.43, ["Neon|Fly|Ride"] = 93.19, ["Mega"] = 355.69, ["Mega|Ride"] = 370.12, ["Mega|Fly|Ride"] = 354.89}},
    ["rbxassetid://13883285383"] = {name = "Castle Hermit Crab", prices = {["default"] = 6.48, ["Neon"] = 55.13, ["Neon|Ride"] = 148.77, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 234.94, ["Mega|Ride"] = 313.47, ["Mega|Fly|Ride"] = 411.24}},
    ["rbxassetid://82240382561696"] = {name = "Cocoadile", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 100.36, ["Mega"] = 57.29, ["Mega|Ride"] = 85.31, ["Mega|Fly|Ride"] = 180.65}},
    ["rbxassetid://74702714943302"] = {name = "Grave Owl", prices = {["default"] = 6.28, ["Fly|Ride"] = 131.25, ["Neon"] = 32.81, ["Neon|Fly"] = 102.92, ["Neon|Ride"] = 46.87, ["Neon|Fly|Ride"] = 283.73, ["Mega"] = 250.79, ["Mega|Ride"] = 212.63, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://97556530589327"] = {name = "Bison", prices = {["default"] = 2.1, ["Neon"] = 3.5, ["Neon|Fly"] = 113.71, ["Neon|Ride"] = 45.8, ["Neon|Fly|Ride"] = 102.36, ["Mega"] = 24.41, ["Mega|Ride"] = 105.2, ["Mega|Fly|Ride"] = 142.64}},
    ["rbxassetid://11694855214"] = {name = "Shetland Pony Dark Brown", prices = {["default"] = 2.1, ["Fly|Ride"] = 40.68, ["Neon"] = 2.52, ["Neon|Ride"] = 21.84, ["Neon|Fly|Ride"] = 107.63, ["Mega"] = 54.74, ["Mega|Fly"] = 142.4, ["Mega|Ride"] = 80.07, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://14398823196"] = {name = "Alpaca", prices = {["default"] = 656.25, ["Fly|Ride"] = 735, ["Neon|Ride"] = 4940.97, ["Neon|Fly|Ride"] = 3674.97, ["Mega|Fly|Ride"] = 12723.32}},
    ["rbxassetid://5721843716"] = {name = "Pterodactyl", prices = {["default"] = 2.1, ["Fly|Ride"] = 36.33, ["Neon"] = 11.81, ["Neon|Fly"] = 42.51, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 98.44, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://82057257613990"] = {name = "Unicorn Ducky", prices = {["default"] = 6.39, ["Neon"] = 7.88, ["Neon|Fly"] = 743.81, ["Neon|Ride"] = 106.26, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 56.42, ["Mega|Fly"] = 148.77, ["Mega|Ride"] = 249.26, ["Mega|Fly|Ride"] = 257.15}},
    ["rbxassetid://4708551366"] = {name = "Frog", prices = {["default"] = 11.82, ["Fly|Ride"] = 52.49, ["Neon"] = 63.76, ["Neon|Fly"] = 193.27, ["Neon|Ride"] = 40.68, ["Neon|Fly|Ride"] = 106.89, ["Mega"] = 485.63, ["Mega|Ride"] = 308.44, ["Mega|Fly|Ride"] = 347.8}},
    ["rbxassetid://4800189682"] = {name = "Starfish", prices = {["default"] = 2.1, ["Fly"] = 16.99, ["Fly|Ride"] = 41.99, ["Neon"] = 3.87, ["Neon|Fly"] = 148.77, ["Neon|Ride"] = 23.56, ["Neon|Fly|Ride"] = 61.64, ["Mega"] = 59.05, ["Mega|Fly"] = 131.25, ["Mega|Ride"] = 85.32, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://16736753854"] = {name = "Candy Cane Snail", prices = {["default"] = 30.19, ["Fly|Ride"] = 283.73, ["Neon"] = 169.2, ["Neon|Ride"] = 223.12, ["Neon|Fly|Ride"] = 317.72, ["Mega"] = 765.07, ["Mega|Ride"] = 616.3}},
    ["rbxassetid://10393730410"] = {name = "Orca", prices = {["default"] = 2.1, ["Fly|Ride"] = 76.12, ["Neon"] = 5.2, ["Neon|Fly"] = 137.75, ["Neon|Ride"] = 26.87, ["Neon|Fly|Ride"] = 119.43, ["Mega"] = 43.22, ["Mega|Ride"] = 134.46, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://111642509798043"] = {name = "Toxic Kaijunior", prices = {["default"] = 2.63, ["Fly|Ride"] = 56.86, ["Neon"] = 10.5, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 142.4, ["Mega"] = 89.1, ["Mega|Ride"] = 198.59, ["Mega|Fly|Ride"] = 351.75}},
    ["rbxassetid://14146181621"] = {name = "Tawny Frogmouth", prices = {["default"] = 2.1, ["Fly|Ride"] = 78.75, ["Neon"] = 21.3, ["Mega"] = 97.12, ["Mega|Ride"] = 159.39, ["Mega|Fly|Ride"] = 418.69}},
    ["rbxassetid://9474010501"] = {name = "Ribbon Seal", prices = {["default"] = 2.1, ["Neon"] = 3.93, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 112.98, ["Mega"] = 39.75, ["Mega|Fly"] = 229.68, ["Mega|Ride"] = 76.52, ["Mega|Fly|Ride"] = 144.36}},
    ["rbxassetid://6776872152"] = {name = "Red Squirrel", prices = {["default"] = 11.22, ["Fly|Ride"] = 41.44, ["Neon"] = 105, ["Neon|Ride"] = 80.85, ["Neon|Fly|Ride"] = 141.63, ["Mega|Ride"] = 313.47, ["Mega|Fly|Ride"] = 391.56}},
    ["rbxassetid://84140820920420"] = {name = "Siamese Cat", prices = {["default"] = 774.38, ["Fly|Ride"] = 820.32, ["Neon"] = 1914.41, ["Neon|Ride"] = 1628.55, ["Neon|Fly|Ride"] = 1959.57, ["Mega"] = 4654.13, ["Mega|Ride"] = 5667.77, ["Mega|Fly|Ride"] = 5250}},
    ["rbxassetid://3181727773"] = {name = "Bunny", prices = {["default"] = 2.1, ["Fly"] = 15.94, ["Fly|Ride"] = 27.57, ["Neon"] = 3.68, ["Neon|Fly"] = 36.14, ["Neon|Ride"] = 17.53, ["Neon|Fly|Ride"] = 42.47, ["Mega"] = 54.45, ["Mega|Ride"] = 59.07, ["Mega|Fly|Ride"] = 137.82}},
    ["rbxassetid://17120012859"] = {name = "Praying Mantis", prices = {["default"] = 39.38, ["Fly|Ride"] = 241.64, ["Neon"] = 48.47, ["Neon|Ride"] = 112.52, ["Neon|Fly|Ride"] = 208.68, ["Mega"] = 403.57, ["Mega|Ride"] = 355.69, ["Mega|Fly|Ride"] = 393.73}},
    ["rbxassetid://4440866528"] = {name = "Turkey", prices = {["default"] = 45.94, ["Fly|Ride"] = 105, ["Neon"] = 315, ["Neon|Ride"] = 403.79, ["Neon|Fly|Ride"] = 425.04, ["Mega"] = 1700.13, ["Mega|Fly|Ride"] = 1411.11}},
    ["rbxassetid://9287841987"] = {name = "Black Springer Spaniel", prices = {["default"] = 30.19, ["Fly|Ride"] = 104.9, ["Neon"] = 187.69, ["Neon|Ride"] = 223.15, ["Mega"] = 1288.77, ["Mega|Ride"] = 892.57, ["Mega|Fly|Ride"] = 816.38}},
    ["rbxassetid://87613898139280"] = {name = "Ranger Beaver", prices = {["default"] = 9.76, ["Fly|Ride"] = 145.51, ["Neon"] = 57.39, ["Neon|Ride"] = 124.69, ["Neon|Fly|Ride"] = 265.65, ["Mega"] = 305.82, ["Mega|Ride"] = 423.98, ["Mega|Fly|Ride"] = 460.68}},
    ["rbxassetid://88389663444803"] = {name = "Mirai Moth", prices = {["default"] = 27.71, ["Neon"] = 85.32, ["Neon|Ride"] = 328.46, ["Mega"] = 282.66, ["Mega|Fly"] = 524.21, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 426.57}},
    ["rbxassetid://128469688002747"] = {name = "Moonlight Moth", prices = {["default"] = 16.75, ["Neon"] = 120.75, ["Neon|Ride"] = 322.6, ["Neon|Fly|Ride"] = 525, ["Mega"] = 525, ["Mega|Fly"] = 567, ["Mega|Ride"] = 476.44, ["Mega|Fly|Ride"] = 741.57}},
    ["rbxassetid://13936753561"] = {name = "Dylan", prices = {["default"] = 10.5}},
    ["rbxassetid://10606175827"] = {name = "Koi Carp", prices = {["default"] = 5.25, ["Fly|Ride"] = 72.27, ["Neon"] = 40.47, ["Neon|Ride"] = 48.45, ["Neon|Fly|Ride"] = 213.62, ["Mega"] = 196.88, ["Mega|Fly"] = 480.3, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 280.76}},
    ["rbxassetid://84529929751558"] = {name = "Old King Coal", prices = {["default"] = 2.1, ["Neon"] = 10.48, ["Neon|Fly|Ride"] = 212.52, ["Mega"] = 134.96, ["Mega|Fly|Ride"] = 483.14}},
    ["rbxassetid://11706110842"] = {name = "Snowball Pet", prices = {["default"] = 34.13, ["Fly|Ride"] = 86.63, ["Neon"] = 202.95, ["Neon|Ride"] = 168.96, ["Neon|Fly|Ride"] = 225.75, ["Mega|Ride"] = 681.75, ["Mega|Fly|Ride"] = 733.69}},
    ["rbxassetid://6404812664"] = {name = "Ladybug", prices = {["default"] = 2.63, ["Fly|Ride"] = 35.44, ["Neon"] = 18.87, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 28.69, ["Neon|Fly|Ride"] = 65.61, ["Mega"] = 198.19, ["Mega|Fly"] = 423.98, ["Mega|Ride"] = 152.39, ["Mega|Fly|Ride"] = 233.63}},
    ["rbxassetid://95046891836017"] = {name = "Clover Cow", prices = {["default"] = 5.25, ["Fly|Ride"] = 56.27, ["Neon"] = 14.44, ["Neon|Ride"] = 44.63, ["Neon|Fly|Ride"] = 125.45, ["Mega"] = 144.96, ["Mega|Fly"] = 131.25, ["Mega|Ride"] = 140.2, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://123759251940984"] = {name = "Oakee Knight", prices = {["default"] = 2.1, ["Neon"] = 3.94, ["Mega"] = 56.79, ["Mega|Ride"] = 203.43, ["Mega|Fly|Ride"] = 258.57}},
    ["rbxassetid://9287842106"] = {name = "Brown Springer Spaniel", prices = {["default"] = 28.25, ["Fly|Ride"] = 105, ["Neon"] = 216.78, ["Neon|Ride"] = 210, ["Neon|Fly|Ride"] = 504.89, ["Mega"] = 524.99, ["Mega|Ride"] = 909.57, ["Mega|Fly|Ride"] = 801.94}},
    ["rbxassetid://83890934284839"] = {name = "Zeopod", prices = {["default"] = 2.1, ["Fly|Ride"] = 65.63, ["Neon"] = 3.84, ["Neon|Fly"] = 32.82, ["Neon|Ride"] = 49.95, ["Mega"] = 53.91, ["Mega|Ride"] = 139.94}},
    ["rbxassetid://107096792267421"] = {name = "General Sheepdog", prices = {["default"] = 9.91, ["Neon"] = 65.1, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 399, ["Mega|Fly|Ride"] = 688.56}},
    ["rbxassetid://5721844511"] = {name = "Woolly Mammoth", prices = {["default"] = 2.1, ["Fly|Ride"] = 41.91, ["Neon"] = 16.96, ["Neon|Ride"] = 30.09, ["Neon|Fly|Ride"] = 48.34, ["Mega"] = 194.25, ["Mega|Ride"] = 208.04, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://8143039445"] = {name = "Summer Walrus", prices = {["default"] = 2.1, ["Fly|Ride"] = 68.6, ["Neon"] = 40.69, ["Neon|Ride"] = 36.75, ["Mega"] = 291.38, ["Mega|Ride"] = 423.98, ["Mega|Fly|Ride"] = 313.69}},
    ["rbxassetid://136696735147963"] = {name = "Chilling Spider", prices = {["default"] = 6.43, ["Neon"] = 88.76, ["Neon|Ride"] = 77.43, ["Mega"] = 422.29, ["Mega|Ride"] = 366.19, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://133768672320906"] = {name = "Catte", prices = {["default"] = 34.13, ["Neon"] = 279.47, ["Neon|Ride"] = 240.16, ["Neon|Fly|Ride"] = 630, ["Mega"] = 1755.38, ["Mega|Ride"] = 1305.94}},
    ["rbxassetid://12139319231"] = {name = "Feesh", prices = {["default"] = 13.68, ["Neon"] = 99.89, ["Neon|Ride"] = 183.75, ["Mega"] = 328.13, ["Mega|Ride"] = 382.54, ["Mega|Fly|Ride"] = 609.93}},
    ["rbxassetid://13685039170"] = {name = "Lobster", prices = {["default"] = 6.57, ["Neon"] = 57.75, ["Neon|Fly"] = 212.52, ["Neon|Ride"] = 170.63, ["Mega"] = 805.64, ["Mega|Ride"] = 849.01, ["Mega|Fly|Ride"] = 567.42}},
    ["rbxassetid://87668315398037"] = {name = "Mecha R4BBIT", prices = {["default"] = 18.17, ["Fly|Ride"] = 367.46, ["Neon"] = 107.63, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 643.13, ["Mega|Fly"] = 2125.16, ["Mega|Ride"] = 724.71, ["Mega|Fly|Ride"] = 737.44}},
    ["rbxassetid://120262676323297"] = {name = "Kelp Hunter", prices = {["default"] = 2.63, ["Neon"] = 14.44, ["Neon|Ride"] = 80.94, ["Mega"] = 184.9, ["Mega|Ride"] = 223.13, ["Mega|Fly|Ride"] = 322.51}},
    ["rbxassetid://12403864254"] = {name = "Gorilla", prices = {["default"] = 2.1, ["Fly|Ride"] = 49.95, ["Neon"] = 5.95, ["Neon|Fly"] = 43.02, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 93.19, ["Mega"] = 70.88, ["Mega|Ride"] = 71.31, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://124908510040897"] = {name = "Mistletroll", prices = {["default"] = 2.1, ["Fly|Ride"] = 69.56, ["Neon"] = 11.05, ["Neon|Ride"] = 89.42, ["Neon|Fly|Ride"] = 113.71, ["Mega"] = 74.82, ["Mega|Ride"] = 110.25, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://11189235896"] = {name = "Persian Cat", prices = {["default"] = 2.1, ["Fly|Ride"] = 57.39, ["Neon"] = 5.65, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 107.62, ["Mega"] = 42.95, ["Mega|Fly"] = 113.71, ["Mega|Ride"] = 83.99, ["Mega|Fly|Ride"] = 206.15}},
    ["rbxassetid://14457148635"] = {name = "Magma Snail", prices = {["default"] = 2.1, ["Fly|Ride"] = 118.13, ["Neon"] = 18.06, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 85.01, ["Mega"] = 255.4, ["Mega|Ride"] = 324.19, ["Mega|Fly|Ride"] = 259.88}},
    ["rbxassetid://11694853423"] = {name = "Shetland Pony White", prices = {["default"] = 3.94, ["Fly|Ride"] = 425.04, ["Neon"] = 28.69, ["Neon|Fly"] = 315, ["Neon|Ride"] = 87.94, ["Neon|Fly|Ride"] = 150.94, ["Mega"] = 301.79, ["Mega|Ride"] = 287.46, ["Mega|Fly|Ride"] = 1062.58}},
    ["rbxassetid://4621220568"] = {name = "Rat", prices = {["default"] = 6.3, ["Fly|Ride"] = 71.31, ["Neon"] = 19.58, ["Neon|Fly"] = 113.71, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 92.54, ["Mega"] = 292.69, ["Mega|Ride"] = 227.98, ["Mega|Fly|Ride"] = 283.74}},
    ["rbxassetid://8938702150"] = {name = "Pine Marten", prices = {["default"] = 2.1, ["Fly|Ride"] = 49.88, ["Neon"] = 22.22, ["Neon|Ride"] = 42.29, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 255.03, ["Mega|Ride"] = 155.93, ["Mega|Fly|Ride"] = 186.18}},
    ["rbxassetid://120359009390464"] = {name = "Turtle Doves", prices = {["default"] = 5.15, ["Fly|Ride"] = 91.86, ["Neon"] = 9.28, ["Neon|Fly"] = 437.05, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 128.63, ["Mega"] = 112.65, ["Mega|Fly"] = 196.88, ["Mega|Ride"] = 128.51, ["Mega|Fly|Ride"] = 209.25}},
    ["rbxassetid://71032455578324"] = {name = "Chihuahua", prices = {["default"] = 19.14, ["Fly|Ride"] = 375.16, ["Neon"] = 165.38, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 378, ["Mega"] = 452.82, ["Mega|Ride"] = 582.23, ["Mega|Fly|Ride"] = 644.44}},
    ["rbxassetid://11505487641"] = {name = "Ram", prices = {["default"] = 45.94, ["Fly|Ride"] = 189, ["Neon"] = 200.49, ["Neon|Ride"] = 184.69, ["Neon|Fly|Ride"] = 283.73, ["Mega"] = 1332.48, ["Mega|Ride"] = 923.49, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://117821626163847"] = {name = "Chanekeh", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 24.93, ["Mega|Ride"] = 56.59, ["Mega|Fly|Ride"] = 145.58}},
    ["rbxassetid://14266737982"] = {name = "Cassowary", prices = {["default"] = 6.19, ["Neon"] = 117.7, ["Mega"] = 686.56, ["Mega|Ride"] = 680.06, ["Mega|Fly|Ride"] = 1122.09}},
    ["rbxassetid://13693650831"] = {name = "Leopard Shark", prices = {["default"] = 46.99, ["Neon"] = 333.61, ["Neon|Ride"] = 341.25, ["Neon|Fly|Ride"] = 850.07, ["Mega"] = 1751.14, ["Mega|Ride"] = 1133.78, ["Mega|Fly|Ride"] = 3187.72}},
    ["rbxassetid://100909868233186"] = {name = "Kappakid", prices = {["default"] = 5.25, ["Fly|Ride"] = 63.76, ["Neon"] = 40.67, ["Neon|Fly"] = 129.28, ["Neon|Ride"] = 70.88, ["Neon|Fly|Ride"] = 126, ["Mega"] = 161.44, ["Mega|Ride"] = 232.72, ["Mega|Fly|Ride"] = 248.07}},
    ["rbxassetid://127061844219486"] = {name = "Patchy Bear", prices = {["default"] = 6.24, ["Neon"] = 11.1, ["Neon|Ride"] = 71.21, ["Neon|Fly|Ride"] = 142.4, ["Mega"] = 104.9, ["Mega|Ride"] = 140.44, ["Mega|Fly|Ride"] = 850.07}},
    ["rbxassetid://6998402749"] = {name = "Merhorse", prices = {["default"] = 2.1, ["Fly"] = 29.81, ["Fly|Ride"] = 45.94, ["Neon"] = 11.43, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 97.77, ["Mega"] = 161.86, ["Mega|Fly"] = 196.86, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 267.75}},
    ["rbxassetid://3181727196"] = {name = "Beaver", prices = {["default"] = 2.1, ["Fly|Ride"] = 41.91, ["Neon"] = 2.63, ["Neon|Fly"] = 32.12, ["Neon|Ride"] = 26.16, ["Neon|Fly|Ride"] = 53.38, ["Mega"] = 28.87, ["Mega|Ride"] = 69.56, ["Mega|Fly|Ride"] = 150.73}},
    ["rbxassetid://10377935981"] = {name = "Badger", prices = {["default"] = 2.1, ["Fly|Ride"] = 93.09, ["Neon"] = 3.29, ["Neon|Ride"] = 23.39, ["Neon|Fly|Ride"] = 72.19, ["Mega"] = 38.98, ["Mega|Fly"] = 108.81, ["Mega|Ride"] = 62.7, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://118143096743818"] = {name = "Granny Wolf", prices = {["default"] = 2.1, ["Neon"] = 2.37, ["Neon|Ride"] = 145.07, ["Mega"] = 28.23, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://18819382634"] = {name = "Singularity Beetle", prices = {["default"] = 4.23, ["Neon"] = 37.96, ["Neon|Ride"] = 84, ["Neon|Fly|Ride"] = 141.75, ["Mega"] = 184.9, ["Mega|Fly|Ride"] = 322.51}},
    ["rbxassetid://13664716167"] = {name = "Ostrich", prices = {["default"] = 5.57, ["Fly|Ride"] = 212.65, ["Neon"] = 53.72, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 142.4, ["Mega"] = 223.13, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://3710822879"] = {name = "Penguin", prices = {["default"] = 5.15, ["Fly|Ride"] = 37.76, ["Neon"] = 28.49, ["Neon|Fly"] = 58.01, ["Neon|Ride"] = 32.7, ["Neon|Fly|Ride"] = 83.51, ["Mega"] = 283.73, ["Mega|Ride"] = 227.39, ["Mega|Fly|Ride"] = 350.01}},
    ["rbxassetid://12778628745"] = {name = "Chef Gorilla", prices = {["default"] = 60.38, ["Fly|Ride"] = 262.5, ["Neon"] = 393.75, ["Neon|Ride"] = 567.42, ["Mega"] = 2415.68, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://138841259551372"] = {name = "Vermilion Butterfly", prices = {["default"] = 15.92, ["Neon"] = 283.73, ["Neon|Fly|Ride"] = 630, ["Mega"] = 645, ["Mega|Ride"] = 879.38, ["Mega|Fly|Ride"] = 708.75}},
    ["rbxassetid://3181727125"] = {name = "Snow Puma", prices = {["default"] = 2.1, ["Fly|Ride"] = 38, ["Neon"] = 2.1, ["Neon|Fly"] = 42.51, ["Neon|Ride"] = 19.95, ["Neon|Fly|Ride"] = 56.44, ["Mega"] = 30.34, ["Mega|Ride"] = 92.51, ["Mega|Fly|Ride"] = 189}},
    ["rbxassetid://3181728160"] = {name = "Shiba Inu", prices = {["default"] = 2.1, ["Fly"] = 71.21, ["Fly|Ride"] = 31.27, ["Neon"] = 3.94, ["Neon|Fly"] = 28.7, ["Neon|Ride"] = 19.14, ["Neon|Fly|Ride"] = 43.31, ["Mega"] = 39.38, ["Mega|Fly"] = 122.2, ["Mega|Ride"] = 65.01, ["Mega|Fly|Ride"] = 91.88}},
    ["rbxassetid://3261465893"] = {name = "Blue Dog", prices = {["default"] = 541.15, ["Fly|Ride"] = 426.57, ["Neon|Fly|Ride"] = 1890.33}},
    ["rbxassetid://15504846154"] = {name = "Eggnog Hare", prices = {["default"] = 3.35, ["Neon"] = 39.15, ["Neon|Ride"] = 80.94, ["Mega"] = 403.5, ["Mega|Ride"] = 400.32, ["Mega|Fly|Ride"] = 971.25}},
    ["rbxassetid://4708551244"] = {name = "Dingo", prices = {["default"] = 2.1, ["Fly|Ride"] = 33.18, ["Neon"] = 5.25, ["Neon|Fly"] = 18.02, ["Neon|Ride"] = 15.75, ["Neon|Fly|Ride"] = 31.07, ["Mega|Ride"] = 79.86, ["Mega|Fly|Ride"] = 106.42}},
    ["rbxassetid://140434791311540"] = {name = "French Bulldog", prices = {["default"] = 52.5, ["Fly|Ride"] = 261.19, ["Neon"] = 227.07, ["Neon|Ride"] = 306.71, ["Neon|Fly|Ride"] = 367.26, ["Mega"] = 735, ["Mega|Ride"] = 761.25, ["Mega|Fly|Ride"] = 878.37}},
    ["rbxassetid://5067924710"] = {name = "Monkey", prices = {["default"] = 2.1, ["Fly|Ride"] = 46.11, ["Neon"] = 12.27, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 24.87, ["Neon|Fly|Ride"] = 70.66, ["Mega"] = 118.13, ["Mega|Ride"] = 143.06, ["Mega|Fly|Ride"] = 190.32}},
    ["rbxassetid://73677246948616"] = {name = "Black Tiger", prices = {["default"] = 2.1, ["Fly|Ride"] = 196.88, ["Neon"] = 2.24, ["Neon|Fly"] = 99.89, ["Neon|Ride"] = 18.14, ["Neon|Fly|Ride"] = 75.07, ["Mega"] = 18.38, ["Mega|Ride"] = 75.46, ["Mega|Fly|Ride"] = 208.95}},
    ["rbxassetid://17662893972"] = {name = "Pretty Pony", prices = {["default"] = 35.44, ["Neon"] = 174.57, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 420, ["Mega"] = 805.64, ["Mega|Ride"] = 637.55, ["Mega|Fly|Ride"] = 682.5}},
    ["rbxassetid://16722908853"] = {name = "Dotted Eggy", prices = {["default"] = 2.1, ["Neon"] = 6.39, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 78.64, ["Mega"] = 31.5, ["Mega|Ride"] = 152.25, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://3409443896"] = {name = "Wild Boar", prices = {["default"] = 31.5, ["Fly|Ride"] = 121.14, ["Neon"] = 206.15, ["Neon|Ride"] = 246.78, ["Neon|Fly|Ride"] = 288.46, ["Mega"] = 1678.88, ["Mega|Ride"] = 954.2}},
    ["rbxassetid://12432807176"] = {name = "Possum", prices = {["default"] = 3.66, ["Neon"] = 17.06, ["Neon|Ride"] = 231, ["Neon|Fly|Ride"] = 496.23, ["Mega"] = 170.63, ["Mega|Ride"] = 191.27, ["Mega|Fly|Ride"] = 318.78}},
    ["rbxassetid://94550121082603"] = {name = "Lionfish", prices = {["default"] = 2.1, ["Fly|Ride"] = 71.21, ["Neon"] = 6.57, ["Neon|Ride"] = 39.37, ["Neon|Fly|Ride"] = 432.36, ["Mega"] = 104.14, ["Mega|Ride"] = 124.69, ["Mega|Fly|Ride"] = 419.99}},
    ["rbxassetid://15096097714"] = {name = "Evil Rock", prices = {["default"] = 36.26, ["Fly|Ride"] = 131.25, ["Mega|Ride"] = 1700.13, ["Mega|Fly|Ride"] = 1975.34}},
    ["rbxassetid://117664495619345"] = {name = "Fire Foal", prices = {["default"] = 2.1, ["Neon"] = 4.99, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 158.24, ["Mega"] = 41.99, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 118.11, ["Mega|Fly|Ride"] = 227.54}},
    ["rbxassetid://8938701683"] = {name = "Red Cardinal", prices = {["default"] = 2.1, ["Fly|Ride"] = 102.88, ["Neon"] = 10.49, ["Neon|Fly"] = 26.25, ["Neon|Ride"] = 26.22, ["Neon|Fly|Ride"] = 72.49, ["Mega"] = 161.86, ["Mega|Fly"] = 148.58, ["Mega|Fly|Ride"] = 219.19}},
    ["rbxassetid://12489700965"] = {name = "Tarsier", prices = {["default"] = 7.6, ["Fly|Ride"] = 112.65, ["Neon"] = 79.94, ["Neon|Ride"] = 65.62, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 328.11, ["Mega|Ride"] = 275.62, ["Mega|Fly|Ride"] = 341.24}},
    ["rbxassetid://11765322595"] = {name = "Gingerbread Reindeer", prices = {["default"] = 11.7, ["Fly|Ride"] = 78.75, ["Neon"] = 62.91, ["Neon|Ride"] = 76.52, ["Neon|Fly|Ride"] = 144.37, ["Mega"] = 482.42, ["Mega|Ride"] = 311.85, ["Mega|Fly|Ride"] = 558.93}},
    ["rbxassetid://16382424275"] = {name = "Nautilus", prices = {["default"] = 24.69, ["Fly|Ride"] = 53.34, ["Neon"] = 72.19, ["Neon|Ride"] = 85.31, ["Neon|Fly|Ride"] = 123.27, ["Mega"] = 395.3, ["Mega|Ride"] = 323.53, ["Mega|Fly|Ride"] = 411.24}},
    ["rbxassetid://93997399823425"] = {name = "Chocolate Dutch Guinea Pig", prices = {["default"] = 65.63, ["Fly|Ride"] = 259.77, ["Neon"] = 340.04, ["Neon|Ride"] = 301.88, ["Neon|Fly|Ride"] = 483.14, ["Mega|Ride"] = 1504.61, ["Mega|Fly|Ride"] = 1312.49}},
    ["rbxassetid://75866760046580"] = {name = "Skelebat", prices = {["default"] = 9.19, ["Neon"] = 55.13, ["Neon|Ride"] = 113.71, ["Neon|Fly|Ride"] = 296.09, ["Mega"] = 236.69, ["Mega|Ride"] = 297.53, ["Mega|Fly|Ride"] = 452.67}},
    ["rbxassetid://111661922676557"] = {name = "Momma Moose", prices = {["default"] = 5.25, ["Fly|Ride"] = 71.21, ["Neon"] = 14.34, ["Neon|Ride"] = 47.25, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 262.49, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 246.62}},
    ["rbxassetid://17059860310"] = {name = "Elasmosaurus", prices = {["default"] = 6.26, ["Fly|Ride"] = 155.36, ["Neon"] = 41.45, ["Neon|Ride"] = 85.01, ["Mega"] = 451.75, ["Mega|Ride"] = 595.05, ["Mega|Fly|Ride"] = 761.25}},
    ["rbxassetid://10306934599"] = {name = "Camel", prices = {["default"] = 2.1, ["Fly|Ride"] = 45.94, ["Neon"] = 2.1, ["Neon|Fly"] = 21.69, ["Neon|Ride"] = 15.53, ["Neon|Fly|Ride"] = 44.63, ["Mega"] = 13.75, ["Mega|Ride"] = 26.76, ["Mega|Fly|Ride"] = 72.19}},
    ["rbxassetid://13104107016"] = {name = "Puffer Fish", prices = {["default"] = 48.46, ["Fly|Ride"] = 283.73, ["Neon"] = 236.24, ["Neon|Fly"] = 2408.86, ["Neon|Ride"] = 282.19, ["Neon|Fly|Ride"] = 488.24, ["Mega"] = 1062.58, ["Mega|Ride"] = 944.99, ["Mega|Fly|Ride"] = 822.45}},
    ["rbxassetid://17183022910"] = {name = "Mole", prices = {["default"] = 2.1, ["Fly|Ride"] = 142.4, ["Neon"] = 4.96, ["Neon|Ride"] = 28.59, ["Neon|Fly|Ride"] = 129.93, ["Mega"] = 31.49, ["Mega|Ride"] = 142.4, ["Mega|Fly|Ride"] = 301.88}},
    ["rbxassetid://5721844051"] = {name = "Stegosaurus", prices = {["default"] = 2.1, ["Fly|Ride"] = 59.06, ["Neon"] = 3.94, ["Neon|Ride"] = 28.55, ["Neon|Fly|Ride"] = 90.03, ["Mega"] = 257.25, ["Mega|Ride"] = 192.94, ["Mega|Fly|Ride"] = 282.66}},
    ["rbxassetid://114921997566126"] = {name = "S'mores Raccoon", prices = {["default"] = 60.38, ["Fly|Ride"] = 229.87, ["Neon"] = 229.69, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 779.94, ["Mega"] = 941.07, ["Mega|Ride"] = 1372.11, ["Mega|Fly|Ride"] = 1023.75}},
    ["rbxassetid://93038040448121"] = {name = "Nurse Shark", prices = {["default"] = 2.1, ["Neon"] = 5.25, ["Neon|Ride"] = 1417.48, ["Mega"] = 69.57, ["Mega|Ride"] = 108.45, ["Mega|Fly|Ride"] = 195.57}},
    ["rbxassetid://13936750528"] = {name = "River", prices = {["default"] = 5.03}},
    ["rbxassetid://103142927308458"] = {name = "Black-Footed Ferret", prices = {["default"] = 2.1, ["Fly|Ride"] = 495.17, ["Neon"] = 6.43, ["Neon|Ride"] = 52.41, ["Neon|Fly|Ride"] = 113.9, ["Mega"] = 42.83, ["Mega|Ride"] = 97.12, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://3199974219"] = {name = "Pet Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13803784751"] = {name = "Happy Clam", prices = {["default"] = 112.87, ["Fly|Ride"] = 236.25, ["Neon"] = 833.07, ["Neon|Ride"] = 452.61, ["Neon|Fly|Ride"] = 805.64, ["Mega"] = 3400.24, ["Mega|Fly|Ride"] = 2673.44}},
    ["rbxassetid://13665210525"] = {name = "Warthog", prices = {["default"] = 3.26, ["Neon"] = 20.47, ["Neon|Fly"] = 142.4, ["Neon|Ride"] = 103.58, ["Neon|Fly|Ride"] = 219.43, ["Mega"] = 178.39, ["Mega|Ride"] = 210.67, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://18515939072"] = {name = "Black Marlin", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 21.09, ["Mega"] = 31.4, ["Mega|Ride"] = 57.39, ["Mega|Fly|Ride"] = 283.73}},
    ["rbxassetid://16075008092"] = {name = "Fanghorn Tortoise", prices = {["default"] = 3.61, ["Fly|Ride"] = 131.25, ["Neon"] = 53.91, ["Neon|Ride"] = 89.63, ["Neon|Fly|Ride"] = 153.55, ["Mega"] = 419.73, ["Mega|Ride"] = 420, ["Mega|Fly|Ride"] = 635.2}},
    ["rbxassetid://8566684181"] = {name = "Giant Black Scarab", prices = {["default"] = 15.86, ["Fly"] = 60.92, ["Fly|Ride"] = 56.58, ["Neon"] = 72.17, ["Neon|Ride"] = 157.65, ["Neon|Fly|Ride"] = 309.1, ["Mega"] = 626.07, ["Mega|Ride"] = 595.05, ["Mega|Fly|Ride"] = 403.44}},
    ["rbxassetid://118691035196137"] = {name = "Shiver Wolf", prices = {["default"] = 17.83, ["Neon"] = 132.96, ["Neon|Ride"] = 176.76, ["Neon|Fly|Ride"] = 483.14, ["Mega"] = 561.75, ["Mega|Ride"] = 536.72, ["Mega|Fly|Ride"] = 599.82}},
    ["rbxassetid://3743735223"] = {name = "Brown Bear", prices = {["default"] = 104.98, ["Fly|Ride"] = 225.64, ["Neon"] = 565.13, ["Neon|Fly"] = 850.07, ["Neon|Ride"] = 590.63, ["Neon|Fly|Ride"] = 656.25, ["Mega|Ride"] = 2550.19, ["Mega|Fly|Ride"] = 2833.89}},
    ["rbxassetid://3934251801"] = {name = "Sloth", prices = {["default"] = 6.6, ["Fly|Ride"] = 45.32, ["Neon"] = 38.96, ["Neon|Fly"] = 155.74, ["Neon|Ride"] = 32.63, ["Neon|Fly|Ride"] = 78.56, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 384.5}},
    ["rbxassetid://12139338880"] = {name = "Frogspawn", prices = {["default"] = 3.94, ["Fly|Ride"] = 131.24, ["Neon"] = 16.96, ["Neon|Ride"] = 32.79, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 142.4, ["Mega|Ride"] = 134.96, ["Mega|Fly|Ride"] = 403.44}},
    ["rbxassetid://8070926551"] = {name = "Snow Leopard", prices = {["default"] = 3.91, ["Fly|Ride"] = 132.57, ["Neon"] = 48.54, ["Neon|Ride"] = 73.84, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 393.75, ["Mega|Ride"] = 483.14, ["Mega|Fly|Ride"] = 483}},
    ["rbxassetid://76712147705770"] = {name = "Tuxedo Cat", prices = {["default"] = 45.97, ["Fly|Ride"] = 176.4, ["Neon"] = 198.72, ["Neon|Ride"] = 183.75, ["Neon|Fly|Ride"] = 212.63, ["Mega"] = 954.19, ["Mega|Ride"] = 918.75, ["Mega|Fly|Ride"] = 1035.46}},
    ["rbxassetid://15685468962"] = {name = "Tasmanian Devil", prices = {["default"] = 18.06, ["Neon"] = 111.57, ["Neon|Ride"] = 185.97, ["Neon|Fly|Ride"] = 468.61, ["Mega"] = 710.52, ["Mega|Ride"] = 850.07, ["Mega|Fly|Ride"] = 1132.71}},
    ["rbxassetid://123288277753363"] = {name = "Tri-horned Treehopper", prices = {["default"] = 301.88, ["Neon|Ride"] = 3221.31}},
    ["rbxassetid://6060987821"] = {name = "Yeti", prices = {["default"] = 23.87, ["Fly|Ride"] = 69.57, ["Neon"] = 423.98, ["Neon|Ride"] = 158.04, ["Neon|Fly|Ride"] = 266.96, ["Mega"] = 761.25, ["Mega|Ride"] = 731.07, ["Mega|Fly|Ride"] = 1062.58}},
    ["rbxassetid://9549841158"] = {name = "Zebra", prices = {["default"] = 2.1, ["Fly|Ride"] = 42.56, ["Neon"] = 2.1, ["Neon|Ride"] = 15.18, ["Neon|Fly|Ride"] = 52.41, ["Mega"] = 20.97, ["Mega|Fly"] = 104.14, ["Mega|Ride"] = 39.04, ["Mega|Fly|Ride"] = 111.57}},
    ["rbxassetid://13883282884"] = {name = "Hermit Crab", prices = {["default"] = 3.8, ["Neon"] = 6.3, ["Neon|Ride"] = 42.28, ["Neon|Fly|Ride"] = 140.27, ["Mega"] = 94.96, ["Mega|Ride"] = 111.43, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://92626539723202"] = {name = "Sea Angel", prices = {["default"] = 3.94, ["Neon"] = 13.55, ["Neon|Fly"] = 87.94, ["Neon|Ride"] = 48.2, ["Neon|Fly|Ride"] = 991.39, ["Mega"] = 121.7, ["Mega|Fly"] = 496.23, ["Mega|Ride"] = 129.93, ["Mega|Fly|Ride"] = 342.57}},
    ["rbxassetid://15848329383"] = {name = "Jellyfish", prices = {["default"] = 425.24, ["Fly"] = 505.32, ["Fly|Ride"] = 513.19, ["Neon"] = 1540.74, ["Neon|Ride"] = 1417.48, ["Neon|Fly|Ride"] = 1246.88, ["Mega|Fly|Ride"] = 5299.06}},
    ["rbxassetid://5721843846"] = {name = "Sabertooth", prices = {["default"] = 2.1, ["Fly|Ride"] = 41.47, ["Neon"] = 19.69, ["Neon|Ride"] = 29.86, ["Neon|Fly|Ride"] = 98.43, ["Mega"] = 183.65, ["Mega|Ride"] = 213.93, ["Mega|Fly|Ride"] = 283.73}},
    ["rbxassetid://9475753090"] = {name = "Albatross", prices = {["default"] = 6.57, ["Fly"] = 94.58, ["Fly|Ride"] = 39.38, ["Neon"] = 17.07, ["Neon|Fly"] = 32.95, ["Neon|Ride"] = 59.52, ["Neon|Fly|Ride"] = 93.66, ["Mega|Ride"] = 280.53, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://96894173636082"] = {name = "Clementine Owl", prices = {["default"] = 3.29, ["Fly|Ride"] = 73.5, ["Neon"] = 11.82, ["Neon|Fly"] = 65.25, ["Neon|Ride"] = 40.69, ["Neon|Fly|Ride"] = 107.33, ["Mega"] = 104.74, ["Mega|Ride"] = 283.73, ["Mega|Fly|Ride"] = 236.23}},
    ["rbxassetid://10318105683"] = {name = "Orange Butterfly", prices = {["default"] = 26.23, ["Fly"] = 72.27, ["Fly|Ride"] = 108.4, ["Neon"] = 220.4, ["Neon|Ride"] = 196.85, ["Neon|Fly|Ride"] = 317.72, ["Mega"] = 708.75, ["Mega|Ride"] = 849.01, ["Mega|Fly|Ride"] = 586.69}},
    ["rbxassetid://15937689999"] = {name = "Rattlesnake", prices = {["default"] = 2.1, ["Fly|Ride"] = 51.85, ["Neon"] = 11.59, ["Neon|Ride"] = 32.64, ["Neon|Fly|Ride"] = 210, ["Mega"] = 163.74, ["Mega|Ride"] = 457.8, ["Mega|Fly|Ride"] = 1011.29}},
    ["rbxassetid://10971808447"] = {name = "Evil Basilisk", prices = {["default"] = 6.46, ["Fly|Ride"] = 91.88, ["Neon"] = 168.9, ["Neon|Ride"] = 109.46, ["Neon|Fly|Ride"] = 354.92, ["Mega|Ride"] = 779.94}},
    ["rbxassetid://99104623628550"] = {name = "Snorgle", prices = {["default"] = 2.1, ["Neon"] = 3.76, ["Neon|Ride"] = 142.4, ["Mega"] = 51.1, ["Mega|Ride"] = 120.3, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://136705425555561"] = {name = "Emperor Shrimp", prices = {["default"] = 8.47, ["Neon"] = 52.5, ["Mega"] = 367.5, ["Mega|Ride"] = 322.51, ["Mega|Fly|Ride"] = 705.48}},
    ["rbxassetid://14398819258"] = {name = "Longhorn Cow", prices = {["default"] = 6.04, ["Neon"] = 91.4, ["Neon|Ride"] = 283.73, ["Mega"] = 313.47, ["Mega|Ride"] = 593.07, ["Mega|Fly|Ride"] = 463.32}},
    ["rbxassetid://4708551284"] = {name = "Koala", prices = {["default"] = 6.57, ["Fly|Ride"] = 56.23, ["Neon"] = 35.44, ["Neon|Fly"] = 114.22, ["Neon|Ride"] = 55.01, ["Neon|Fly|Ride"] = 81.39, ["Mega"] = 326.23, ["Mega|Ride"] = 313.47, ["Mega|Fly|Ride"] = 308.74}},
    ["rbxassetid://4115249264"] = {name = "Zombie Buffalo", prices = {["default"] = 363.45, ["Fly|Ride"] = 423.84, ["Neon"] = 1642.41, ["Neon|Ride"] = 1656.34, ["Neon|Fly|Ride"] = 1575, ["Mega|Fly|Ride"] = 8052.63}},
    ["rbxassetid://8939633862"] = {name = "Salamander", prices = {["default"] = 2.1, ["Fly|Ride"] = 39.38, ["Neon"] = 15.65, ["Neon|Fly"] = 80.96, ["Neon|Ride"] = 32.28, ["Neon|Fly|Ride"] = 49.95, ["Mega"] = 248.66, ["Mega|Ride"] = 196.77}},
    ["rbxassetid://7734902431"] = {name = "Halloween White Mummy Cat", prices = {["default"] = 8.21, ["Fly|Ride"] = 131.25, ["Neon"] = 57.65, ["Neon|Ride"] = 123.35, ["Neon|Fly|Ride"] = 210, ["Mega"] = 384.91, ["Mega|Fly"] = 708.75, ["Mega|Ride"] = 420, ["Mega|Fly|Ride"] = 521.74}},
    ["rbxassetid://115869632070663"] = {name = "Snowball Pug", prices = {["default"] = 21, ["Fly|Ride"] = 318.78, ["Neon"] = 92.7, ["Neon|Ride"] = 160.82, ["Neon|Fly|Ride"] = 354.92, ["Mega"] = 340.04, ["Mega|Ride"] = 356.03, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://8077189379"] = {name = "Husky", prices = {["default"] = 52.5, ["Fly|Ride"] = 164.07, ["Neon"] = 320.25, ["Neon|Ride"] = 321.57, ["Neon|Fly|Ride"] = 380.63, ["Mega"] = 2492.09, ["Mega|Ride"] = 1912.64, ["Mega|Fly|Ride"] = 1698.01}},
    ["rbxassetid://98003529163435"] = {name = "Maine Coon", prices = {["default"] = 9.1, ["Fly|Ride"] = 128.63, ["Neon"] = 32.82, ["Neon|Fly"] = 120.83, ["Neon|Ride"] = 104.81, ["Neon|Fly|Ride"] = 245.44, ["Mega"] = 143.05, ["Mega|Ride"] = 207.39, ["Mega|Fly|Ride"] = 349.22}},
    ["rbxassetid://12488273089"] = {name = "Yellow-lipped Sea Krait", prices = {["default"] = 2.1, ["Fly|Ride"] = 58.47, ["Neon"] = 13.02, ["Neon|Ride"] = 15.75, ["Neon|Fly|Ride"] = 126.93, ["Mega"] = 65.62, ["Mega|Ride"] = 161.86, ["Mega|Fly|Ride"] = 261.19}},
    ["rbxassetid://96760582519875"] = {name = "Cozy Mistletroll", prices = {["default"] = 4.73, ["Neon"] = 19.69, ["Neon|Ride"] = 105.84, ["Neon|Fly|Ride"] = 157.49, ["Mega"] = 101.07, ["Mega|Ride"] = 198.72, ["Mega|Fly|Ride"] = 425.04}},
    ["rbxassetid://85229142142232"] = {name = "Bunny Swirl", prices = {["default"] = 32.82, ["Fly|Ride"] = 216.57, ["Neon"] = 111.56, ["Neon|Fly"] = 114.19, ["Neon|Ride"] = 142.79, ["Neon|Fly|Ride"] = 260.61, ["Mega"] = 420, ["Mega|Ride"] = 410.82, ["Mega|Fly|Ride"] = 531.57}},
    ["rbxassetid://121192022038625"] = {name = "Stygian Owl", prices = {["default"] = 3.94, ["Neon"] = 5.32, ["Neon|Ride"] = 137.82, ["Neon|Fly|Ride"] = 202.02, ["Mega"] = 49.14, ["Mega|Fly"] = 161.86, ["Mega|Ride"] = 212.52, ["Mega|Fly|Ride"] = 425.04}},
    ["rbxassetid://83732262844708"] = {name = "Pain au Chat", prices = {["default"] = 22.32, ["Neon"] = 131.25, ["Neon|Ride"] = 401.03, ["Neon|Fly|Ride"] = 850.07, ["Mega"] = 499.13, ["Mega|Fly|Ride"] = 693.8}},
    ["rbxassetid://12792506715"] = {name = "Goose", prices = {["default"] = 892.5, ["Fly|Ride"] = 1152.57, ["Neon"] = 3505.44, ["Neon|Ride"] = 3937.5, ["Neon|Fly|Ride"] = 3281.23, ["Mega|Fly|Ride"] = 10343.08}},
    ["rbxassetid://12779257292"] = {name = "Pudding Cat", prices = {["default"] = 15.6, ["Fly|Ride"] = 193.32, ["Neon"] = 63, ["Neon|Fly"] = 707.69, ["Neon|Ride"] = 142.4, ["Neon|Fly|Ride"] = 321.57, ["Mega"] = 337.89, ["Mega|Ride"] = 328.27, ["Mega|Fly|Ride"] = 708.75}},
    ["rbxassetid://83376259738301"] = {name = "Mrs. Whiskerpips", prices = {["default"] = 2.1, ["Fly|Ride"] = 90.55, ["Neon"] = 6.83, ["Neon|Fly"] = 42.51, ["Neon|Ride"] = 31.12, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 57.54, ["Mega|Ride"] = 78.74, ["Mega|Fly|Ride"] = 161.86}},
    ["rbxassetid://110894046614323"] = {name = "Partridge", prices = {["default"] = 10.5, ["Fly|Ride"] = 142.4, ["Neon"] = 48.57, ["Neon|Fly"] = 83.95, ["Neon|Fly|Ride"] = 393.73, ["Mega"] = 266.13, ["Mega|Ride"] = 411.92, ["Mega|Fly|Ride"] = 924}},
    ["rbxassetid://114034119324343"] = {name = "Muskrat", prices = {["default"] = 2.1, ["Fly|Ride"] = 184.9, ["Neon"] = 2.1, ["Neon|Fly"] = 142.4, ["Neon|Ride"] = 17.06, ["Neon|Fly|Ride"] = 93.17, ["Mega"] = 16.11, ["Mega|Ride"] = 38.19, ["Mega|Fly|Ride"] = 170.02}},
    ["rbxassetid://15547904644"] = {name = "Harp Seal", prices = {["default"] = 56.79, ["Fly|Ride"] = 236.24, ["Neon"] = 234.94, ["Neon|Ride"] = 223.13, ["Neon|Fly|Ride"] = 365.47, ["Mega"] = 918.75, ["Mega|Ride"] = 1038.98, ["Mega|Fly|Ride"] = 913.24}},
    ["rbxassetid://14978702254"] = {name = "Scarecrow Cat", prices = {["default"] = 10.24, ["Fly|Ride"] = 283.73, ["Neon"] = 76.13, ["Neon|Ride"] = 328.12, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 482.42, ["Mega|Ride"] = 602.73, ["Mega|Fly|Ride"] = 637.55}},
    ["rbxassetid://95871612352029"] = {name = "Cold Cube", prices = {["default"] = 2.1, ["Neon"] = 6.04, ["Neon|Ride"] = 35.44, ["Neon|Fly|Ride"] = 212.52, ["Mega"] = 89, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 354.92}},
    ["rbxassetid://114456035353449"] = {name = "Bauble Buddies", prices = {["default"] = 18.4, ["Fly|Ride"] = 112.65, ["Neon"] = 50.96, ["Neon|Ride"] = 86.05, ["Neon|Fly|Ride"] = 190.32, ["Mega"] = 1039.5, ["Mega|Ride"] = 352.79, ["Mega|Fly|Ride"] = 391.13}},
    ["rbxassetid://15383967605"] = {name = "Gingerbread Mouse", prices = {["default"] = 9.19, ["Fly|Ride"] = 45.94, ["Neon"] = 125.4, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 133.01, ["Mega"] = 325.64, ["Mega|Ride"] = 531.29, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://11767069383"] = {name = "Woolly Rhino", prices = {["default"] = 33.31, ["Neon"] = 164.71, ["Neon|Ride"] = 549.94, ["Neon|Fly|Ride"] = 721.88, ["Mega"] = 2125.16, ["Mega|Ride"] = 2408.86, ["Mega|Fly|Ride"] = 1693.76}},
    ["rbxassetid://95133623103638"] = {name = "Samoyed", prices = {["default"] = 4.86, ["Neon"] = 13.13, ["Neon|Ride"] = 70.88, ["Neon|Fly|Ride"] = 161.21, ["Mega"] = 118.12, ["Mega|Ride"] = 150.9, ["Mega|Fly|Ride"] = 227.05}},
    ["rbxassetid://8071236757"] = {name = "St Bernard", prices = {["default"] = 15.94, ["Fly|Ride"] = 90.57, ["Neon"] = 44.47, ["Neon|Fly"] = 184.9, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 87, ["Mega"] = 283.73, ["Mega|Ride"] = 351.75, ["Mega|Fly|Ride"] = 680.06}},
    ["rbxassetid://14276930615"] = {name = "Alley Cat", prices = {["default"] = 107.63, ["Fly|Ride"] = 236.25, ["Neon"] = 441, ["Neon|Fly"] = 426.57, ["Neon|Ride"] = 409.5, ["Neon|Fly|Ride"] = 669.38, ["Mega"] = 2656.44, ["Mega|Ride"] = 2787.14, ["Mega|Fly|Ride"] = 2169.92}},
    ["rbxassetid://6498256417"] = {name = "Dolphin", prices = {["default"] = 2.1, ["Fly|Ride"] = 55.13, ["Neon"] = 11.46, ["Neon|Fly"] = 57.32, ["Neon|Ride"] = 31.88, ["Neon|Fly|Ride"] = 77.43, ["Mega"] = 145.69, ["Mega|Ride"] = 239.49, ["Mega|Fly|Ride"] = 185.96}},
    ["rbxassetid://7734900468"] = {name = "Halloween White Skeleton Dog", prices = {["default"] = 15.49, ["Fly|Ride"] = 116.81, ["Neon"] = 95.82, ["Neon|Ride"] = 106.08, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 452.81, ["Mega|Ride"] = 498.74, ["Mega|Fly|Ride"] = 539.8}},
    ["rbxassetid://9982202041"] = {name = "Poodle", prices = {["default"] = 2.1, ["Fly|Ride"] = 64.32, ["Neon"] = 2.1, ["Neon|Fly"] = 27.62, ["Neon|Ride"] = 15.47, ["Neon|Fly|Ride"] = 39.64, ["Mega"] = 13.63, ["Mega|Fly"] = 50.75, ["Mega|Ride"] = 35.32, ["Mega|Fly|Ride"] = 80.06}},
    ["rbxassetid://73671766703168"] = {name = "Pilot Gull", prices = {["default"] = 2.1, ["Fly|Ride"] = 39.38, ["Neon"] = 3.51, ["Neon|Ride"] = 42.51, ["Neon|Fly|Ride"] = 131.77, ["Mega"] = 13.13, ["Mega|Fly"] = 105, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 168.96}},
    ["rbxassetid://14146127209"] = {name = "Indian Leopard", prices = {["default"] = 2.1, ["Fly|Ride"] = 133.88, ["Neon"] = 11.57, ["Neon|Ride"] = 55.54, ["Neon|Fly|Ride"] = 85.01, ["Mega"] = 85.32, ["Mega|Ride"] = 269.91, ["Mega|Fly|Ride"] = 246.1}},
    ["rbxassetid://113558592714438"] = {name = "Seabed Creeper", prices = {["default"] = 32.82, ["Neon"] = 181.73, ["Neon|Ride"] = 340.04, ["Neon|Fly|Ride"] = 433.13, ["Mega"] = 547.32, ["Mega|Ride"] = 722.56}},
    ["rbxassetid://4281674713"] = {name = "Bee", prices = {["default"] = 2.1, ["Fly|Ride"] = 33.49, ["Neon"] = 9.68, ["Neon|Fly"] = 21.26, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 55.13, ["Mega"] = 111.57, ["Mega|Fly"] = 170.63, ["Mega|Ride"] = 125.4, ["Mega|Fly|Ride"] = 156.19}},
    ["rbxassetid://5862774392"] = {name = "Bat", prices = {["default"] = 6.56, ["Fly|Ride"] = 96.23, ["Neon"] = 28.7, ["Neon|Fly"] = 56.44, ["Neon|Ride"] = 39.24, ["Neon|Fly|Ride"] = 105, ["Mega"] = 230.99, ["Mega|Fly"] = 433.13, ["Mega|Ride"] = 214.62, ["Mega|Fly|Ride"] = 305.34}},
    ["rbxassetid://18223359092"] = {name = "Birthday Butterfly 2024", prices = {["default"] = 2.1, ["Fly|Ride"] = 85.01, ["Neon"] = 8.97, ["Neon|Fly"] = 71.21, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 89.24, ["Mega"] = 78.64, ["Mega|Fly"] = 80.94, ["Mega|Ride"] = 58.47, ["Mega|Fly|Ride"] = 125.9}},
    ["rbxassetid://17822765706"] = {name = "Pink Betta Fish", prices = {["default"] = 11.68, ["Fly|Ride"] = 217.2, ["Neon"] = 37.67, ["Neon|Ride"] = 79.8, ["Neon|Fly|Ride"] = 283.73, ["Mega"] = 236.75, ["Mega|Fly"] = 400.32, ["Mega|Ride"] = 381.48, ["Mega|Fly|Ride"] = 320.25}},
    ["rbxassetid://14146174264"] = {name = "Rock Pigeon", prices = {["default"] = 7.88, ["Neon"] = 50.05, ["Neon|Fly"] = 78.64, ["Neon|Ride"] = 144.38, ["Mega"] = 682.5, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://11758575946"] = {name = "Water Moon Bear", prices = {["default"] = 6.57, ["Fly|Ride"] = 49.61, ["Neon"] = 19.69, ["Neon|Fly"] = 196.87, ["Neon|Ride"] = 39.04, ["Neon|Fly|Ride"] = 105.2, ["Mega"] = 241.58, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 305.82, ["Mega|Fly|Ride"] = 567.42}},
    ["rbxassetid://6498256132"] = {name = "Seahorse", prices = {["default"] = 2.1, ["Fly|Ride"] = 52.41, ["Neon"] = 11.46, ["Neon|Fly"] = 70.51, ["Neon|Ride"] = 25.51, ["Neon|Fly|Ride"] = 71.21, ["Mega"] = 185.96, ["Mega|Ride"] = 102.38, ["Mega|Fly|Ride"] = 157.27}},
    ["rbxassetid://13664973582"] = {name = "Many Mackerel", prices = {["default"] = 180.16, ["Fly|Ride"] = 283.73, ["Neon"] = 1215.43, ["Neon|Ride"] = 1133.78, ["Neon|Fly|Ride"] = 1174.69, ["Mega|Fly|Ride"] = 4200}},
    ["rbxassetid://114806716799554"] = {name = "Ringmaster Gibbon", prices = {["default"] = 3.82, ["Neon"] = 21, ["Neon|Ride"] = 142.4, ["Neon|Fly|Ride"] = 425.04, ["Mega"] = 122.07, ["Mega|Ride"] = 638.67, ["Mega|Fly|Ride"] = 354.92}},
    ["rbxassetid://14360917588"] = {name = "Magma Moose", prices = {["default"] = 2.47, ["Fly|Ride"] = 85.17, ["Neon"] = 23.63, ["Neon|Fly"] = 241.22, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 225.6, ["Mega|Ride"] = 288.75, ["Mega|Fly|Ride"] = 524.98}},
    ["rbxassetid://18957942216"] = {name = "Starhopper", prices = {["default"] = 4.86, ["Fly|Ride"] = 212.89, ["Neon"] = 36.66, ["Neon|Ride"] = 225.28, ["Neon|Fly|Ride"] = 603.74, ["Mega"] = 479.73, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 416.73}},
    ["rbxassetid://3181727071"] = {name = "Puma", prices = {["default"] = 2.1, ["Fly|Ride"] = 32.34, ["Neon"] = 2.1, ["Neon|Fly"] = 35.44, ["Neon|Ride"] = 14.44, ["Neon|Fly|Ride"] = 39.38, ["Mega"] = 18.21, ["Mega|Fly"] = 78.64, ["Mega|Ride"] = 42.2, ["Mega|Fly|Ride"] = 65.63}},
    ["rbxassetid://4841039508"] = {name = "Rock", prices = {["default"] = 4.26, ["Fly|Ride"] = 56.97, ["Neon"] = 14.44, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 107.62, ["Mega"] = 116.94, ["Mega|Ride"] = 128.63, ["Mega|Fly|Ride"] = 190.32}},
    ["rbxassetid://94235745630523"] = {name = "Rainbow Trout", prices = {["default"] = 2.52, ["Neon"] = 8.55, ["Neon|Ride"] = 142.4, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 43.04, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 255.03}},
    ["rbxassetid://4440867249"] = {name = "Llama", prices = {["default"] = 70.86, ["Fly|Ride"] = 164.07, ["Neon"] = 386.63, ["Neon|Fly"] = 434.95, ["Neon|Ride"] = 409.49, ["Neon|Fly|Ride"] = 423.98, ["Mega|Ride"] = 3543.68, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://11571113805"] = {name = "Bloodhound", prices = {["default"] = 2.52, ["Fly|Ride"] = 99.89, ["Neon"] = 23.63, ["Neon|Ride"] = 66.94, ["Mega"] = 167.99, ["Mega|Ride"] = 142.4, ["Mega|Fly|Ride"] = 346.42}},
    ["rbxassetid://78423968285099"] = {name = "Wren", prices = {["default"] = 2.1, ["Neon"] = 6.12, ["Neon|Ride"] = 80.94, ["Neon|Fly|Ride"] = 542.33, ["Mega"] = 66.94, ["Mega|Fly"] = 315, ["Mega|Ride"] = 126, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://110871792705214"] = {name = "Burger Bear", prices = {["default"] = 44.6, ["Fly|Ride"] = 222.32, ["Neon"] = 136.5, ["Neon|Ride"] = 162.56, ["Neon|Fly|Ride"] = 275.63, ["Mega"] = 538.12, ["Mega|Ride"] = 523.69, ["Mega|Fly|Ride"] = 635.43}},
    ["rbxassetid://3181727637"] = {name = "Fennec Fox", prices = {["default"] = 2.1, ["Fly|Ride"] = 32.7, ["Neon"] = 2.1, ["Neon|Fly"] = 16.99, ["Neon|Ride"] = 15.65, ["Neon|Fly|Ride"] = 32.82, ["Mega"] = 19.57, ["Mega|Fly"] = 45.49, ["Mega|Ride"] = 30.18, ["Mega|Fly|Ride"] = 92.46}},
    ["rbxassetid://115530716039589"] = {name = "Milk Choccybunny", prices = {["default"] = 2.1, ["Neon"] = 3.56, ["Neon|Ride"] = 27.56, ["Neon|Fly|Ride"] = 285.32, ["Mega"] = 23.39, ["Mega|Ride"] = 78.62, ["Mega|Fly|Ride"] = 176.06}},
    ["rbxassetid://83001092186817"] = {name = "White Choccybunny", prices = {["default"] = 2.52, ["Neon"] = 7.88, ["Neon|Ride"] = 108.94, ["Neon|Fly|Ride"] = 142.95, ["Mega"] = 55.27, ["Mega|Fly"] = 184.9, ["Mega|Ride"] = 114.85, ["Mega|Fly|Ride"] = 210.78}},
    ["rbxassetid://103795616446776"] = {name = "Waffle Wyrm", prices = {["default"] = 14.52, ["Fly|Ride"] = 128.33, ["Neon"] = 17.07, ["Neon|Fly"] = 91.55, ["Neon|Ride"] = 85.01, ["Neon|Fly|Ride"] = 142.4, ["Mega"] = 102.71, ["Mega|Fly"] = 346.68, ["Mega|Ride"] = 173.79, ["Mega|Fly|Ride"] = 278.71}},
    ["rbxassetid://9982358951"] = {name = "Orangutan", prices = {["default"] = 2.1, ["Fly|Ride"] = 23.63, ["Neon"] = 2.5, ["Neon|Fly"] = 24.5, ["Neon|Ride"] = 22.17, ["Neon|Fly|Ride"] = 44.44, ["Mega"] = 18.38, ["Mega|Ride"] = 63.76, ["Mega|Fly|Ride"] = 78.49}},
    ["rbxassetid://129021417712364"] = {name = "Kage Crow", prices = {["default"] = 18.17, ["Neon"] = 128.63, ["Neon|Fly"] = 425.04, ["Neon|Ride"] = 183.75, ["Neon|Fly|Ride"] = 1312.5, ["Mega"] = 504.73, ["Mega|Ride"] = 590.62, ["Mega|Fly|Ride"] = 741.62}},
    ["rbxassetid://4849941238"] = {name = "Hedgehog", prices = {["default"] = 2738.4, ["Fly|Ride"] = 2321.62, ["Neon"] = 10625.72, ["Neon|Fly|Ride"] = 9775.66, ["Mega|Fly|Ride"] = 42501.8}},
    ["rbxassetid://4800190144"] = {name = "Ginger Cat", prices = {["default"] = 2.1, ["Fly|Ride"] = 34.01, ["Neon"] = 8.99, ["Neon|Fly"] = 58.52, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 57.39, ["Mega"] = 70.53, ["Mega|Fly"] = 425.04, ["Mega|Ride"] = 83.92, ["Mega|Fly|Ride"] = 154.31}},
    ["rbxassetid://18119333909"] = {name = "Rodeo Bull", prices = {["default"] = 2.1, ["Neon"] = 8.4, ["Mega"] = 107.01, ["Mega|Fly"] = 441, ["Mega|Ride"] = 161.44, ["Mega|Fly|Ride"] = 354.92}},
    ["rbxassetid://11837080223"] = {name = "Highland Cow", prices = {["default"] = 19.69, ["Fly|Ride"] = 131.25, ["Neon"] = 73.48, ["Neon|Ride"] = 99.75, ["Neon|Fly|Ride"] = 212.63, ["Mega"] = 459.38, ["Mega|Ride"] = 395.93, ["Mega|Fly|Ride"] = 380.63}},
    ["rbxassetid://14398816006"] = {name = "Rooster", prices = {["default"] = 24.33, ["Neon"] = 161.44, ["Neon|Ride"] = 190.32, ["Mega"] = 430.07, ["Mega|Ride"] = 580.18, ["Mega|Fly|Ride"] = 643.13}},
    ["rbxassetid://3409444089"] = {name = "Hyena", prices = {["default"] = 128.52, ["Fly"] = 212.52, ["Fly|Ride"] = 251.49, ["Neon"] = 1312.5, ["Neon|Ride"] = 714.66, ["Neon|Fly|Ride"] = 701.01, ["Mega"] = 6375.44, ["Mega|Fly|Ride"] = 3782.77}},
    ["rbxassetid://127067345833475"] = {name = "Hummingbird", prices = {["default"] = 6.46, ["Fly|Ride"] = 675.94, ["Neon"] = 19.68, ["Neon|Ride"] = 85.01, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 144.45, ["Mega|Fly"] = 13125, ["Mega|Ride"] = 225.88, ["Mega|Fly|Ride"] = 361.29}},
    ["rbxassetid://130497948875084"] = {name = "Marabou Stork", prices = {["default"] = 2.36, ["Neon"] = 13.01, ["Neon|Ride"] = 114.85, ["Mega"] = 245.44, ["Mega|Ride"] = 333.38, ["Mega|Fly|Ride"] = 267.09}},
    ["rbxassetid://127017727552531"] = {name = "Angus Calf", prices = {["default"] = 2.1, ["Neon"] = 6.47, ["Neon|Fly"] = 92.46, ["Neon|Ride"] = 30.18, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 78.64, ["Mega|Ride"] = 105.66, ["Mega|Fly|Ride"] = 273}},
    ["rbxassetid://12779130089"] = {name = "Sprout Snail", prices = {["default"] = 13.13, ["Fly|Ride"] = 131.25, ["Neon"] = 98.44, ["Neon|Ride"] = 174.27, ["Neon|Fly|Ride"] = 500.49, ["Mega"] = 386.52, ["Mega|Ride"] = 468.61, ["Mega|Fly|Ride"] = 584.73}},
    ["rbxassetid://117824155556510"] = {name = "Princess Mare", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 34.01, ["Mega"] = 15.75, ["Mega|Fly"] = 120.8, ["Mega|Ride"] = 79.97, ["Mega|Fly|Ride"] = 134.54}},
    ["rbxassetid://122766274014139"] = {name = "Gaelic Fae", prices = {["default"] = 78.75, ["Fly"] = 198.72, ["Fly|Ride"] = 142.4, ["Neon"] = 346.5, ["Neon|Fly"] = 454.79, ["Neon|Ride"] = 408.05, ["Neon|Fly|Ride"] = 311.5, ["Mega"] = 3187.72, ["Mega|Fly|Ride"] = 1693.76}},
    ["rbxassetid://17255807019"] = {name = "Weevil", prices = {["default"] = 2.1, ["Neon"] = 3.15, ["Neon|Ride"] = 142.4, ["Neon|Fly|Ride"] = 212.52, ["Mega"] = 70.88, ["Mega|Ride"] = 281.54, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://3743720235"] = {name = "Capybara", prices = {["default"] = 34.09, ["Fly|Ride"] = 184.65, ["Neon"] = 255.03, ["Neon|Ride"] = 389.84, ["Neon|Fly|Ride"] = 467.35, ["Mega"] = 2625, ["Mega|Fly|Ride"] = 2532.12}},
    ["rbxassetid://106815320234576"] = {name = "Ehecatl", prices = {["default"] = 2.1, ["Fly|Ride"] = 51.64, ["Neon"] = 3.68, ["Neon|Fly"] = 87.45, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 83.98, ["Mega"] = 42, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 142.91}},
    ["rbxassetid://110449571836616"] = {name = "Irish Setter", prices = {["default"] = 6.39, ["Fly|Ride"] = 109.46, ["Neon"] = 9.55, ["Neon|Ride"] = 98.44, ["Mega"] = 48.18, ["Mega|Ride"] = 143.08, ["Mega|Fly|Ride"] = 425.04}},
    ["rbxassetid://93751644677101"] = {name = "Winter Doe", prices = {["default"] = 5.92, ["Neon"] = 23.63, ["Neon|Ride"] = 79.97, ["Neon|Fly|Ride"] = 142.4, ["Mega"] = 367.5, ["Mega|Ride"] = 288.75, ["Mega|Fly|Ride"] = 565.3}},
    ["rbxassetid://90667836208550"] = {name = "Munchkin Cat", prices = {["default"] = 337.05, ["Fly|Ride"] = 459.38, ["Neon"] = 966.99, ["Neon|Ride"] = 980.4, ["Neon|Fly|Ride"] = 1076.25, ["Mega"] = 3257.86, ["Mega|Ride"] = 2361.19, ["Mega|Fly|Ride"] = 2823.66}},
    ["rbxassetid://3743734696"] = {name = "Rhino", prices = {["default"] = 26.23, ["Fly|Ride"] = 127.52, ["Neon"] = 196.88, ["Neon|Ride"] = 211.46, ["Neon|Fly|Ride"] = 317.72, ["Mega|Ride"] = 1126.34, ["Mega|Fly|Ride"] = 1700.13}},
    ["rbxassetid://7734928397"] = {name = "Halloween Blue Scorpion", prices = {["default"] = 2.1, ["Fly|Ride"] = 111.57, ["Neon"] = 12.99, ["Neon|Fly"] = 85.32, ["Neon|Ride"] = 24.19, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 124.69, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 314.89}},
    ["rbxassetid://116859365721104"] = {name = "Shadow Dragon Ducky", prices = {["default"] = 24.65, ["Fly"] = 645.05, ["Fly|Ride"] = 131.24, ["Neon"] = 65.25, ["Neon|Fly"] = 161.91, ["Neon|Ride"] = 144, ["Neon|Fly|Ride"] = 183.74, ["Mega"] = 282.19, ["Mega|Fly"] = 425.04, ["Mega|Ride"] = 301.88, ["Mega|Fly|Ride"] = 406.88}},
    ["rbxassetid://6060991084"] = {name = "Musk Ox", prices = {["default"] = 8.68, ["Neon"] = 101.35, ["Neon|Ride"] = 116.82, ["Neon|Fly|Ride"] = 255.03, ["Mega"] = 425.04, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 425.81}},
    ["rbxassetid://119284351481681"] = {name = "Violet Friend", prices = {["default"] = 3.24, ["Neon"] = 19.47, ["Mega"] = 91.87, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 380.42}},
    ["rbxassetid://10971808356"] = {name = "Basilisk", prices = {["default"] = 3.94, ["Fly|Ride"] = 59.52, ["Neon"] = 32.71, ["Neon|Ride"] = 50.16, ["Mega"] = 160.13, ["Mega|Ride"] = 486.93, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://3744706727"] = {name = "Platypus", prices = {["default"] = 98.33, ["Fly|Ride"] = 212.52, ["Neon"] = 793.76, ["Neon|Ride"] = 523.68, ["Neon|Fly|Ride"] = 568.52, ["Mega"] = 2887.5, ["Mega|Ride"] = 3543.8, ["Mega|Fly|Ride"] = 3187.72}},
    ["rbxassetid://12480556316"] = {name = "Black Macaque", prices = {["default"] = 24.52, ["Fly|Ride"] = 91.88, ["Neon"] = 131.25, ["Neon|Ride"] = 234.85, ["Neon|Fly|Ride"] = 283.73, ["Mega"] = 578.69, ["Mega|Ride"] = 722.56, ["Mega|Fly|Ride"] = 731.07}},
    ["rbxassetid://4849941000"] = {name = "Dalmatian", prices = {["default"] = 1763.87, ["Fly|Ride"] = 1890, ["Neon"] = 11334.46, ["Neon|Fly|Ride"] = 6300, ["Mega|Fly|Ride"] = 21654.94}},
    ["rbxassetid://139319822015938"] = {name = "Sea Skeleton Panda", prices = {["default"] = 3.56, ["Fly|Ride"] = 196.87, ["Neon"] = 13.13, ["Neon|Fly|Ride"] = 637.55, ["Mega"] = 118.02, ["Mega|Fly"] = 786.19, ["Mega|Ride"] = 172.57, ["Mega|Fly|Ride"] = 446.24}},
    ["rbxassetid://104838807480936"] = {name = "Winter Fawn", prices = {["default"] = 5.92, ["Fly|Ride"] = 177.47, ["Neon"] = 27.57, ["Neon|Ride"] = 90.56, ["Mega"] = 138.36, ["Mega|Ride"] = 322.51, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://100705885132301"] = {name = "Cabbit", prices = {["default"] = 1050, ["Fly|Ride"] = 866.25, ["Neon"] = 2778.57, ["Neon|Ride"] = 2198.87, ["Neon|Fly|Ride"] = 2494.8, ["Mega"] = 14020.64, ["Mega|Fly|Ride"] = 11752.06}},
    ["rbxassetid://12480406935"] = {name = "Binturong", prices = {["default"] = 24.93, ["Fly|Ride"] = 225.94, ["Neon"] = 212.91, ["Neon|Ride"] = 180.26, ["Neon|Fly|Ride"] = 354.92, ["Mega"] = 844.29, ["Mega|Ride"] = 656.25, ["Mega|Fly|Ride"] = 668.07}},
    ["rbxassetid://73245262062822"] = {name = "Prism Snake", prices = {["default"] = 3.46, ["Fly|Ride"] = 125.57, ["Neon"] = 6.54, ["Neon|Ride"] = 42.6, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 157.5, ["Mega|Ride"] = 317.72, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://113717425344888"] = {name = "Magpie", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 49.14, ["Neon|Fly|Ride"] = 104.14, ["Mega"] = 19.69, ["Mega|Ride"] = 78.64, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://10318105900"] = {name = "Purple Butterfly", prices = {["default"] = 77.43, ["Fly|Ride"] = 170.63, ["Neon"] = 446.29, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 633.31, ["Mega"] = 2415.68, ["Mega|Fly|Ride"] = 2125.16}},
    ["rbxassetid://95049698731940"] = {name = "Throwback Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15503941919"] = {name = "Arctic Hare", prices = {["default"] = 2.1, ["Fly|Ride"] = 74.03, ["Neon"] = 11.82, ["Neon|Ride"] = 64.32, ["Neon|Fly|Ride"] = 127.52, ["Mega"] = 107.62, ["Mega|Ride"] = 122.04, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://10274421272"] = {name = "Royal Corgi", prices = {["default"] = 73.49, ["Fly|Ride"] = 241.22, ["Neon"] = 459.38, ["Neon|Ride"] = 552.55, ["Mega|Fly|Ride"] = 1700.13}},
    ["rbxassetid://13978968837"] = {name = "Bird of Paradise", prices = {["default"] = 6.6, ["Fly|Ride"] = 102.89, ["Neon"] = 26.25, ["Neon|Ride"] = 212.52, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 315, ["Mega|Ride"] = 196.88}},
    ["rbxassetid://3261465850"] = {name = "Pink Cat", prices = {["default"] = 234.82, ["Fly|Ride"] = 320.25, ["Neon"] = 1137.32, ["Neon|Ride"] = 1064.63, ["Neon|Fly|Ride"] = 879.04, ["Mega|Fly|Ride"] = 4671.08}},
    ["rbxassetid://8969010905"] = {name = "Red Fox", prices = {["default"] = 3.94, ["Fly|Ride"] = 49.88, ["Neon"] = 28.77, ["Neon|Ride"] = 57.66, ["Neon|Fly|Ride"] = 112.88, ["Mega"] = 321.47, ["Mega|Ride"] = 159.65, ["Mega|Fly|Ride"] = 257.27}},
    ["rbxassetid://3181728128"] = {name = "Red Panda", prices = {["default"] = 2.1, ["Fly|Ride"] = 31.6, ["Neon"] = 4.23, ["Neon|Fly"] = 37.97, ["Neon|Ride"] = 21.19, ["Neon|Fly|Ride"] = 57.39, ["Mega"] = 41.99, ["Mega|Ride"] = 45.93, ["Mega|Fly|Ride"] = 125.99}},
    ["rbxassetid://13077769577"] = {name = "Pelican", prices = {["default"] = 1272.98, ["Fly|Ride"] = 1254.19, ["Neon|Ride"] = 7792.92, ["Neon|Fly|Ride"] = 6659.15, ["Mega"] = 23673.51, ["Mega|Fly|Ride"] = 28335.59}},
    ["rbxassetid://115281603518501"] = {name = "DJ Snooze", prices = {["default"] = 13.6, ["Neon"] = 74.82, ["Neon|Ride"] = 127.52, ["Mega"] = 244.13, ["Mega|Ride"] = 284.82, ["Mega|Fly|Ride"] = 564.27}},
    ["rbxassetid://111847888001946"] = {name = "Choco Penguin", prices = {["default"] = 7.88, ["Fly|Ride"] = 100.17, ["Neon"] = 19.67, ["Neon|Fly"] = 57.39, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 105, ["Mega"] = 118.13, ["Mega|Ride"] = 205.56, ["Mega|Fly|Ride"] = 341.24}},
    ["rbxassetid://4621220487"] = {name = "Panda", prices = {["default"] = 32.83, ["Fly|Ride"] = 66.89, ["Neon"] = 425.04, ["Neon|Ride"] = 209.9, ["Neon|Fly|Ride"] = 212.63, ["Mega"] = 2550.19, ["Mega|Ride"] = 1128.12, ["Mega|Fly|Ride"] = 799.32}},
    ["rbxassetid://12917347184"] = {name = "Flower Power Duckling", prices = {["default"] = 15.65, ["Fly"] = 99.89, ["Fly|Ride"] = 78.46, ["Neon"] = 57.85, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 98.34, ["Neon|Fly|Ride"] = 227.4, ["Mega"] = 367.5, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 429.26}},
    ["rbxassetid://93775555430694"] = {name = "Pumpkin Friend", prices = {["default"] = 48.56, ["Fly|Ride"] = 636.57, ["Neon"] = 204.65, ["Neon|Ride"] = 495.17, ["Neon|Fly|Ride"] = 538.74, ["Mega"] = 850.07, ["Mega|Ride"] = 850.07, ["Mega|Fly|Ride"] = 850.07}},
    ["rbxassetid://83317902236850"] = {name = "Kakapo", prices = {["default"] = 2.1, ["Fly|Ride"] = 283.73, ["Neon"] = 3.64, ["Neon|Fly"] = 57.39, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 106.26, ["Mega"] = 17.07, ["Mega|Fly"] = 72.14, ["Mega|Ride"] = 142.4, ["Mega|Fly|Ride"] = 196.87}},
    ["rbxassetid://5862774043"] = {name = "Ghost Bunny", prices = {["default"] = 78.63, ["Fly|Ride"] = 185.53, ["Neon"] = 578.82, ["Neon|Fly"] = 670.5, ["Neon|Ride"] = 368.73, ["Neon|Fly|Ride"] = 378, ["Mega"] = 3400.24, ["Mega|Fly|Ride"] = 1666.88}},
    ["rbxassetid://10639131895"] = {name = "Spider Crab", prices = {["default"] = 2.63, ["Fly"] = 783.97, ["Fly|Ride"] = 67.37, ["Neon"] = 198.19, ["Neon|Ride"] = 95.95, ["Neon|Fly|Ride"] = 170.02, ["Mega"] = 773.07, ["Mega|Ride"] = 432.48, ["Mega|Fly|Ride"] = 425.04}},
    ["rbxassetid://10193736072"] = {name = "Red Crowned Crane", prices = {["default"] = 2.1, ["Fly|Ride"] = 39.35, ["Neon"] = 19.69, ["Neon|Fly"] = 80.96, ["Neon|Ride"] = 71.21, ["Neon|Fly|Ride"] = 122.85, ["Mega|Ride"] = 275.07, ["Mega|Fly|Ride"] = 275.63}},
    ["rbxassetid://13804047294"] = {name = "Arctic Tern", prices = {["default"] = 2.1, ["Neon"] = 16, ["Neon|Fly"] = 140.27, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 201.9, ["Mega|Fly|Ride"] = 483.14}},
    ["rbxassetid://14883937353"] = {name = "Ghost Dog", prices = {["default"] = 54.5, ["Fly|Ride"] = 357, ["Neon"] = 328.13, ["Neon|Ride"] = 367.29, ["Neon|Fly|Ride"] = 397.42, ["Mega"] = 2205, ["Mega|Ride"] = 1456.88, ["Mega|Fly|Ride"] = 1246.88}},
    ["rbxassetid://103241919688695"] = {name = "2025 Birthday Butterfly", prices = {["default"] = 3.51, ["Fly|Ride"] = 425.04, ["Neon"] = 18.47, ["Neon|Ride"] = 59.07, ["Mega"] = 126.88, ["Mega|Ride"] = 212.52, ["Mega|Fly|Ride"] = 280.53}},
    ["rbxassetid://86594144838863"] = {name = "Tree Frog", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 118.41, ["Neon|Fly|Ride"] = 71.21, ["Mega"] = 16.86, ["Mega|Ride"] = 192.32, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://99048375832409"] = {name = "Shih Tzu", prices = {["default"] = 2.1, ["Fly|Ride"] = 142.4, ["Neon"] = 2.1, ["Neon|Ride"] = 21.76, ["Neon|Fly|Ride"] = 131.24, ["Mega"] = 18.97, ["Mega|Ride"] = 61.68, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://6998403122"] = {name = "Kirin", prices = {["default"] = 2.1, ["Fly"] = 36.75, ["Fly|Ride"] = 52.41, ["Neon"] = 5.23, ["Neon|Ride"] = 30.37, ["Neon|Fly|Ride"] = 87.94, ["Mega"] = 61.69, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 179.7}},
    ["rbxassetid://15930472964"] = {name = "Gila Monster", prices = {["default"] = 2.1, ["Fly|Ride"] = 113.78, ["Neon"] = 24.35, ["Neon|Ride"] = 65.63, ["Mega"] = 118.1, ["Mega|Ride"] = 106.29, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://5721843144"] = {name = "Dilophosaurus", prices = {["default"] = 2.1, ["Fly|Ride"] = 30.19, ["Neon"] = 9.97, ["Neon|Fly"] = 212.52, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 76.4, ["Mega"] = 170.63, ["Mega|Ride"] = 122.81, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://109520235810036"] = {name = "Mini Schnauzer", prices = {["default"] = 60.58, ["Fly|Ride"] = 279.47, ["Neon"] = 212.52, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 1062.58, ["Mega"] = 695.63, ["Mega|Ride"] = 844.76, ["Mega|Fly|Ride"] = 1128.1}},
    ["rbxassetid://3181728229"] = {name = "Snow Cat", prices = {["default"] = 2.1, ["Fly|Ride"] = 42.51, ["Neon"] = 2.63, ["Neon|Fly"] = 28.7, ["Neon|Ride"] = 17.05, ["Neon|Fly|Ride"] = 42.2, ["Mega"] = 40.69, ["Mega|Ride"] = 118.28, ["Mega|Fly|Ride"] = 104.09}},
    ["rbxassetid://4506925747"] = {name = "Wolf", prices = {["default"] = 7.4, ["Fly"] = 129.94, ["Fly|Ride"] = 71.34, ["Neon"] = 31.49, ["Neon|Fly"] = 91.76, ["Neon|Ride"] = 49.86, ["Neon|Fly|Ride"] = 95.82, ["Mega"] = 300.57, ["Mega|Fly"] = 331.54, ["Mega|Ride"] = 314.9, ["Mega|Fly|Ride"] = 311.07}},
    ["rbxassetid://5862774473"] = {name = "Albino Bat", prices = {["default"] = 18.27, ["Fly|Ride"] = 103.95, ["Neon"] = 152.24, ["Neon|Fly"] = 142.4, ["Neon|Ride"] = 96.46, ["Neon|Fly|Ride"] = 184.9, ["Mega"] = 623.75, ["Mega|Ride"] = 673.68, ["Mega|Fly|Ride"] = 587.35}},
    ["rbxassetid://14978701751"] = {name = "Scarecrow", prices = {["default"] = 7.1, ["Neon"] = 73.5, ["Neon|Ride"] = 103.69, ["Mega"] = 393.75, ["Mega|Ride"] = 448.28, ["Mega|Fly|Ride"] = 357}},
    ["rbxassetid://10235589000"] = {name = "Corgi", prices = {["default"] = 2.1, ["Fly|Ride"] = 32.71, ["Neon"] = 3.94, ["Neon|Fly"] = 28.1, ["Neon|Ride"] = 17.74, ["Neon|Fly|Ride"] = 63, ["Mega"] = 38.07, ["Mega|Ride"] = 40.69, ["Mega|Fly|Ride"] = 108.06}},
    ["rbxassetid://103710623311342"] = {name = "Ghost Chick", prices = {["default"] = 3.94, ["Fly|Ride"] = 54.36, ["Neon"] = 27.64, ["Neon|Fly"] = 157.5, ["Neon|Ride"] = 127.52, ["Mega"] = 183.75, ["Mega|Fly"] = 735, ["Mega|Ride"] = 301.88, ["Mega|Fly|Ride"] = 378.3}},
    ["rbxassetid://4440866423"] = {name = "Cow", prices = {["default"] = 980.42, ["Fly|Ride"] = 1048.69, ["Neon"] = 2916.52, ["Neon|Ride"] = 2034.38, ["Neon|Fly|Ride"] = 2218.12, ["Mega|Fly|Ride"] = 7199.06}},
    ["rbxassetid://15093139154"] = {name = "Slime", prices = {["default"] = 136.52, ["Fly|Ride"] = 636.41, ["Neon"] = 666.25, ["Neon|Ride"] = 853.13, ["Neon|Fly|Ride"] = 945, ["Mega"] = 3186.66, ["Mega|Ride"] = 3543.68, ["Mega|Fly|Ride"] = 2546.25}},
    ["rbxassetid://82170828935980"] = {name = "Dracula Fish", prices = {["default"] = 2.1, ["Fly|Ride"] = 392.44, ["Neon"] = 3.94, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 207.21, ["Mega"] = 78.49, ["Mega|Fly|Ride"] = 1133.78}},
    ["rbxassetid://11109302289"] = {name = "Zombie Wolf", prices = {["default"] = 85.31, ["Fly|Ride"] = 262.49, ["Neon"] = 328.13, ["Neon|Fly"] = 446.25, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 689.07, ["Mega"] = 1967.44, ["Mega|Ride"] = 1876.98, ["Mega|Fly|Ride"] = 1823.64}},
    ["rbxassetid://15369729071"] = {name = "Nutcracker Squirrel", prices = {["default"] = 6.3, ["Neon"] = 15.21, ["Neon|Fly"] = 56.8, ["Neon|Ride"] = 52.67, ["Neon|Fly|Ride"] = 283.73, ["Mega"] = 118.12, ["Mega|Ride"] = 357.05, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://9800792849"] = {name = "Goat", prices = {["default"] = 249.37, ["Fly"] = 333.66, ["Fly|Ride"] = 354.38, ["Neon|Ride"] = 1133.78, ["Neon|Fly|Ride"] = 1365, ["Mega|Fly|Ride"] = 4916.52}},
    ["rbxassetid://12509687499"] = {name = "Banded Palm Civet", prices = {["default"] = 2.1, ["Fly|Ride"] = 216.16, ["Neon"] = 23.9, ["Neon|Fly"] = 49.95, ["Neon|Ride"] = 54.37, ["Mega"] = 241.35, ["Mega|Fly"] = 355.98, ["Mega|Ride"] = 567.42}},
    ["rbxassetid://10381386150"] = {name = "Rhino Beetle", prices = {["default"] = 2.1, ["Neon"] = 43.65, ["Mega"] = 131.25, ["Mega|Ride"] = 262.5}},
    ["rbxassetid://130734656883878"] = {name = "Merry Mistletroll", prices = {["default"] = 27.8, ["Fly|Ride"] = 153.45, ["Neon"] = 116.85, ["Neon|Fly"] = 425.04, ["Neon|Ride"] = 124.69, ["Neon|Fly|Ride"] = 212.52, ["Mega"] = 468.61, ["Mega|Ride"] = 590.81, ["Mega|Fly|Ride"] = 902.27}},
    ["rbxassetid://15923337068"] = {name = "Oryx", prices = {["default"] = 2.1, ["Neon"] = 31.88, ["Neon|Ride"] = 196.87, ["Mega"] = 230.71, ["Mega|Ride"] = 253.32, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://6245080365"] = {name = "Ox", prices = {["default"] = 2.1, ["Fly"] = 26.59, ["Fly|Ride"] = 28.7, ["Neon"] = 2.63, ["Neon|Fly"] = 28.7, ["Neon|Ride"] = 26.18, ["Neon|Fly|Ride"] = 35.33, ["Mega"] = 22.85, ["Mega|Ride"] = 36.14, ["Mega|Fly|Ride"] = 65.01}},
    ["rbxassetid://13810870050"] = {name = "African Wild Dog", prices = {["default"] = 4593.75, ["Fly|Ride"] = 4675.33, ["Neon"] = 31877.14, ["Neon|Fly|Ride"] = 19293.75, ["Mega|Fly|Ride"] = 161045.1}},
    ["rbxassetid://12596400214"] = {name = "Goldfish", prices = {["default"] = 6.57, ["Neon"] = 53.72, ["Neon|Ride"] = 106.32, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 178.5, ["Mega|Ride"] = 215.25, ["Mega|Fly|Ride"] = 425.04}},
    ["rbxassetid://4736656915"] = {name = "Australian Kelpie", prices = {["default"] = 2.1, ["Fly|Ride"] = 42, ["Neon"] = 14.07, ["Neon|Fly"] = 37.2, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 100.5, ["Mega"] = 131.25, ["Mega|Ride"] = 177.47, ["Mega|Fly|Ride"] = 182.78}},
    ["rbxassetid://3743711305"] = {name = "Crocodile", prices = {["default"] = 423.21, ["Fly|Ride"] = 531.57, ["Neon"] = 1601.31, ["Neon|Ride"] = 1292.82, ["Neon|Fly|Ride"] = 1300.81, ["Mega|Fly|Ride"] = 4873.32}},
    ["rbxassetid://74373220330198"] = {name = "Officer Gibbon", prices = {["default"] = 3.08, ["Neon"] = 11.82, ["Neon|Ride"] = 291.38, ["Mega"] = 142.86, ["Mega|Ride"] = 177.19, ["Mega|Fly|Ride"] = 693}},
    ["rbxassetid://18508184138"] = {name = "Peregrine Falcon", prices = {["default"] = 6.57, ["Fly"] = 4249.24, ["Neon"] = 31.88, ["Neon|Fly"] = 117.96, ["Neon|Ride"] = 65.24, ["Neon|Fly|Ride"] = 304.98, ["Mega"] = 423.98, ["Mega|Ride"] = 284.67, ["Mega|Fly|Ride"] = 496.23}},
    ["rbxassetid://92389214029179"] = {name = "Kaijunior", prices = {["default"] = 2.1, ["Fly"] = 50.95, ["Fly|Ride"] = 48.29, ["Neon"] = 3.94, ["Neon|Fly"] = 124.69, ["Neon|Ride"] = 26.76, ["Neon|Fly|Ride"] = 85.25, ["Mega"] = 44.52, ["Mega|Ride"] = 67.33, ["Mega|Fly|Ride"] = 274.16}},
    ["rbxassetid://3409443986"] = {name = "Flamingo", prices = {["default"] = 708.75, ["Fly|Ride"] = 677.03, ["Neon|Ride"] = 2126.27, ["Neon|Fly|Ride"] = 2480.06, ["Mega|Fly|Ride"] = 9209.32}},
    ["rbxassetid://126933432685319"] = {name = "Cattuccino", prices = {["default"] = 9.37, ["Fly|Ride"] = 412.98, ["Neon"] = 31.49, ["Neon|Ride"] = 104.99, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 182.34, ["Mega|Ride"] = 199.5, ["Mega|Fly|Ride"] = 418.69}},
    ["rbxassetid://11631390464"] = {name = "Ermine", prices = {["default"] = 5.24, ["Fly|Ride"] = 76.56, ["Neon"] = 23.63, ["Neon|Ride"] = 59.06, ["Neon|Fly|Ride"] = 144.37, ["Mega"] = 168.96, ["Mega|Fly"] = 805.64, ["Mega|Ride"] = 181.13, ["Mega|Fly|Ride"] = 270.39}},
    ["rbxassetid://4708551221"] = {name = "Emu", prices = {["default"] = 2.62, ["Fly|Ride"] = 43.3, ["Neon"] = 15.59, ["Neon|Fly"] = 199.5, ["Neon|Ride"] = 32.16, ["Neon|Fly|Ride"] = 82.47, ["Mega"] = 184.9, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 232.2}},
    ["rbxassetid://16088266364"] = {name = "Burning Bunny", prices = {["default"] = 21, ["Fly|Ride"] = 55.6, ["Neon"] = 117.59, ["Mega"] = 850.07, ["Mega|Ride"] = 452.82, ["Mega|Fly|Ride"] = 548.3}},
    ["rbxassetid://80832101513100"] = {name = "2026 Birthday Butterfly", prices = {["default"] = 2.1, ["Fly|Ride"] = 425.04, ["Neon"] = 6.35, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 45.7, ["Neon|Fly|Ride"] = 106.26, ["Mega"] = 32.58, ["Mega|Fly"] = 142.4, ["Mega|Ride"] = 59.07, ["Mega|Fly|Ride"] = 185.07}},
    ["rbxassetid://14639007389"] = {name = "Caterpillar", prices = {["default"] = 551.25, ["Fly|Ride"] = 630, ["Neon"] = 2589.57, ["Neon|Fly|Ride"] = 2391.38, ["Mega|Ride"] = 9421.11, ["Mega|Fly|Ride"] = 7861.88}},
    ["rbxassetid://82920146813845"] = {name = "Little Lamb", prices = {["default"] = 2.63, ["Neon"] = 15.43, ["Neon|Ride"] = 86.14, ["Neon|Fly|Ride"] = 65.24, ["Mega"] = 78.75, ["Mega|Ride"] = 156.19, ["Mega|Fly|Ride"] = 419.13}},
    ["rbxassetid://96424154406922"] = {name = "Crimson Cape", prices = {["default"] = 2.1, ["Neon"] = 3.94, ["Neon|Fly"] = 142.4, ["Neon|Ride"] = 30.19, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 42.51, ["Mega|Fly|Ride"] = 283.49}},
    ["rbxassetid://109008428989602"] = {name = "Pangolin", prices = {["default"] = 2.1, ["Neon"] = 3.94, ["Neon|Ride"] = 56.12, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 46.76, ["Mega|Fly"] = 157.27, ["Mega|Ride"] = 118.16, ["Mega|Fly|Ride"] = 145.69}},
    ["rbxassetid://16722909218"] = {name = "Floral Eggy", prices = {["default"] = 2.1, ["Neon"] = 38.27, ["Neon|Ride"] = 48.18, ["Mega"] = 212.52, ["Mega|Ride"] = 328.13}},
    ["rbxassetid://76735046136809"] = {name = "Frostbite Cub", prices = {["default"] = 30.96, ["Fly|Ride"] = 144.37, ["Neon"] = 103.94, ["Neon|Fly"] = 212.52, ["Neon|Ride"] = 113.71, ["Neon|Fly|Ride"] = 241.58, ["Mega"] = 511.88, ["Mega|Ride"] = 437.06, ["Mega|Fly|Ride"] = 547.51}},
    ["rbxassetid://15684947715"] = {name = "Quokka", prices = {["default"] = 32.82, ["Fly|Ride"] = 106.26, ["Neon"] = 78.74, ["Neon|Ride"] = 206.15, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 382.67, ["Mega|Ride"] = 441.13, ["Mega|Fly|Ride"] = 560.81}},
    ["rbxassetid://5721843001"] = {name = "Deinonychus", prices = {["default"] = 2.1, ["Fly|Ride"] = 32.81, ["Neon"] = 28.59, ["Neon|Fly"] = 142.4, ["Neon|Ride"] = 32.15, ["Neon|Fly|Ride"] = 88.1, ["Mega"] = 246.41, ["Mega|Ride"] = 283.73, ["Mega|Fly|Ride"] = 313.47}},
    ["rbxassetid://16999461770"] = {name = "Inmate Capuchin Monkey", prices = {["default"] = 7.74, ["Fly|Ride"] = 140.17, ["Neon"] = 38.05, ["Neon|Ride"] = 142.4, ["Mega|Ride"] = 738.5}},
    ["rbxassetid://119664699815373"] = {name = "Frozen Penguin", prices = {["default"] = 2.1, ["Fly|Ride"] = 106.26, ["Neon"] = 6.02, ["Neon|Ride"] = 38.68, ["Neon|Fly|Ride"] = 113.71, ["Mega"] = 65.63, ["Mega|Ride"] = 115.5, ["Mega|Fly|Ride"] = 272.99}},
    ["rbxassetid://5067924307"] = {name = "Business Monkey", prices = {["default"] = 20.23, ["Fly"] = 113.56, ["Fly|Ride"] = 43.52, ["Neon"] = 110.25, ["Neon|Ride"] = 144.38, ["Neon|Fly|Ride"] = 194.46, ["Mega"] = 787.5, ["Mega|Fly|Ride"] = 841.58}},
    ["rbxassetid://126192643157832"] = {name = "Manta Ray", prices = {["default"] = 57.39, ["Neon"] = 78.75, ["Mega"] = 328.13, ["Mega|Ride"] = 590.63, ["Mega|Fly|Ride"] = 492.85}},
    ["rbxassetid://4440866911"] = {name = "Silly Duck", prices = {["default"] = 49.88, ["Fly|Ride"] = 91.88, ["Neon"] = 324.83, ["Neon|Ride"] = 367.5, ["Neon|Fly|Ride"] = 415.79, ["Mega|Ride"] = 1707.88, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://110544962124445"] = {name = "Cake Friend", prices = {["default"] = 32.81, ["Fly"] = 142.4, ["Fly|Ride"] = 129.94, ["Neon"] = 140.44, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 309.75, ["Mega"] = 551.25, ["Mega|Ride"] = 707.69, ["Mega|Fly|Ride"] = 632}},
    ["rbxassetid://16127157068"] = {name = "Rice Cake Rabbit", prices = {["default"] = 19.69, ["Neon"] = 103.69, ["Neon|Ride"] = 223.12, ["Mega"] = 1050, ["Mega|Ride"] = 805.64, ["Mega|Fly|Ride"] = 807.19}},
    ["rbxassetid://7734900613"] = {name = "Halloween Evil Dachshund", prices = {["default"] = 26.25, ["Fly|Ride"] = 194.46, ["Neon"] = 137.82, ["Neon|Fly"] = 420, ["Neon|Ride"] = 212.14, ["Neon|Fly|Ride"] = 321.57, ["Mega"] = 503.29, ["Mega|Ride"] = 565.55, ["Mega|Fly|Ride"] = 662.75}},
    ["rbxassetid://9664282145"] = {name = "Robot", prices = {["default"] = 2.1, ["Fly|Ride"] = 32.74, ["Neon"] = 3.89, ["Neon|Fly"] = 27.36, ["Neon|Ride"] = 34.07, ["Neon|Fly|Ride"] = 54.21, ["Mega"] = 38.41, ["Mega|Fly"] = 322.51, ["Mega|Ride"] = 57.7, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://3261465791"] = {name = "Pink Egg", prices = {["default"] = 866.24}},
    ["rbxassetid://126725051633301"] = {name = "Headless Horse", prices = {["default"] = 64.32, ["Fly|Ride"] = 262.39, ["Neon"] = 377.9, ["Neon|Ride"] = 458.07, ["Neon|Fly|Ride"] = 558.93, ["Mega"] = 1417.5, ["Mega|Ride"] = 1506.74, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://88554799028713"] = {name = "Sneak Weasel", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Fly"] = 99.89, ["Neon|Ride"] = 43.2, ["Neon|Fly|Ride"] = 297.53, ["Mega"] = 25.95, ["Mega|Ride"] = 84.95, ["Mega|Fly|Ride"] = 152.37}},
    ["rbxassetid://14639008203"] = {name = "English Sheepdog", prices = {["default"] = 22.08, ["Fly|Ride"] = 142.65, ["Neon"] = 124.69, ["Neon|Ride"] = 127.52, ["Neon|Fly|Ride"] = 544.69, ["Mega"] = 591.94, ["Mega|Ride"] = 494.82, ["Mega|Fly|Ride"] = 721.87}},
    ["rbxassetid://133131190079833"] = {name = "Oakee", prices = {["default"] = 2.1, ["Neon"] = 2.6, ["Neon|Fly|Ride"] = 106.26, ["Mega"] = 26.16}},
    ["rbxassetid://79856043024325"] = {name = "Chestnut Glyptodon", prices = {["default"] = 2.1, ["Neon"] = 3.19, ["Mega"] = 22.32, ["Mega|Ride"] = 142.4, ["Mega|Fly|Ride"] = 273}},
    ["rbxassetid://12720028898"] = {name = "Hare", prices = {["default"] = 90.2, ["Fly|Ride"] = 364.88, ["Neon"] = 433.13, ["Neon|Ride"] = 459.38, ["Neon|Fly|Ride"] = 668.32, ["Mega|Ride"] = 2267.54, ["Mega|Fly|Ride"] = 2098.52}},
    ["rbxassetid://16897788024"] = {name = "Capuchin Monkey", prices = {["default"] = 2.1, ["Fly|Ride"] = 101.47, ["Neon"] = 3.94, ["Neon|Fly"] = 42.51, ["Neon|Ride"] = 32.24, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 90.19, ["Mega|Ride"] = 116.81, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://121639546210522"] = {name = "Amber Butterfly", prices = {["default"] = 2.1, ["Fly|Ride"] = 53.82, ["Neon"] = 5.14, ["Neon|Ride"] = 51.19, ["Neon|Fly|Ride"] = 142.4, ["Mega"] = 31.17, ["Mega|Ride"] = 127.52, ["Mega|Fly|Ride"] = 209.99}},
    ["rbxassetid://79005166120532"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Neon"] = 6.34, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 236.25, ["Mega"] = 103.69, ["Mega|Ride"] = 163.13, ["Mega|Fly|Ride"] = 482.42}},
    ["rbxassetid://138741319376538"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Neon"] = 6.47, ["Neon|Ride"] = 156.09, ["Mega"] = 68.25, ["Mega|Fly"] = 195.53, ["Mega|Ride"] = 262.49, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://133558151150234"] = {name = "Black Widow", prices = {["default"] = 90.45, ["Fly|Ride"] = 645.18, ["Neon"] = 437.07, ["Neon|Ride"] = 567.42, ["Neon|Fly|Ride"] = 695.63, ["Mega"] = 2267.54, ["Mega|Ride"] = 2125.16, ["Mega|Fly|Ride"] = 1700.13}},
    ["rbxassetid://122945704087152"] = {name = "Chilling Spider", prices = {["default"] = 6.43, ["Neon"] = 88.76, ["Neon|Ride"] = 77.43, ["Mega"] = 422.29, ["Mega|Ride"] = 366.19, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://4315743582"] = {name = "Honey Badger", prices = {["default"] = 393.75, ["Fly|Ride"] = 517.11, ["Neon"] = 850.07, ["Neon|Ride"] = 1133.78, ["Neon|Fly|Ride"] = 1102.5, ["Mega|Fly|Ride"] = 3346.87}},
    ["rbxassetid://2657671618"] = {name = "Anna Rattle", prices = {["default"] = 2.63}},
    ["rbxassetid://2657667102"] = {name = "Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248143"] = {name = "Banjo", prices = {["default"] = 6.39}},
    ["rbxassetid://4470749845"] = {name = "Bauble Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046064"] = {name = "Bunny Plush", prices = {["default"] = 4.34}},
    ["rbxassetid://6710107927"] = {name = "Candy Cannon", prices = {["default"] = 8925.6}},
    ["rbxassetid://3082046250"] = {name = "Carrot Rattle", prices = {["default"] = 2.63}},
    ["rbxassetid://3082046215"] = {name = "Chocolate Bunny Balloon", prices = {["default"] = 4.26}},
    ["rbxassetid://1257271764"] = {name = "Christmas Cat Rattle", prices = {["default"] = 2.43}},
    ["rbxassetid://1257273388"] = {name = "Christmas Doge Rattle", prices = {["default"] = 38.49}},
    ["rbxassetid://2408035767"] = {name = "Croc Plush", prices = {["default"] = 3.88}},
    ["rbxassetid://5061468734"] = {name = "Cymbal Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://4822522594"] = {name = "Dandelion Propeller", prices = {["default"] = 5.07}},
    ["rbxassetid://3009779323"] = {name = "Donut Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3454109877"] = {name = "Donut Throw Toy", prices = {["default"] = 40.69}},
    ["rbxassetid://3009779349"] = {name = "Duck Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://1555803323"] = {name = "Egg Rattle", prices = {["default"] = 3.89}},
    ["rbxassetid://2408035763"] = {name = "Fancy Balloon", prices = {["default"] = 6.57}},
    ["rbxassetid://2408052395"] = {name = "Fancy Umbrella", prices = {["default"] = 3.12}},
    ["rbxassetid://3009779377"] = {name = "Flower Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291815"] = {name = "Flying Broomstick", prices = {["default"] = 4469.36}},
    ["rbxassetid://3454109803"] = {name = "Football Throw Toy", prices = {["default"] = 10.64}},
    ["rbxassetid://4470749638"] = {name = "Gift Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://3142180004"] = {name = "Grappling Hook", prices = {["default"] = 2.63}},
    ["rbxassetid://2848331436"] = {name = "Heart Rattle", prices = {["default"] = 45.94}},
    ["rbxassetid://2657670910"] = {name = "Horse Plush", prices = {["default"] = 2.77}},
    ["rbxassetid://1555807694"] = {name = "Hugging Egg", prices = {["default"] = 98.44}},
    ["rbxassetid://3009779419"] = {name = "Ice Cream Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052390"] = {name = "Inflatable Sword", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051119"] = {name = "Jackhammer", prices = {["default"] = 15.75}},
    ["rbxassetid://4822522509"] = {name = "Lavender Bundle", prices = {["default"] = 3.84}},
    ["rbxassetid://3009779472"] = {name = "Marsh Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670913"] = {name = "Noob Balloon", prices = {["default"] = 3.83}},
    ["rbxassetid://4470749788"] = {name = "Ornament Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670921"] = {name = "Phoenix Plush", prices = {["default"] = 5.4}},
    ["rbxassetid://3082046011"] = {name = "Rabbit Rattle", prices = {["default"] = 3.93}},
    ["rbxassetid://3009779583"] = {name = "Rocket Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750189"] = {name = "Santa Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468835"] = {name = "Scroll Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671626"] = {name = "Snowman Plush", prices = {["default"] = 2.15}},
    ["rbxassetid://4470749691"] = {name = "Snowman Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750120"] = {name = "Sock Chew Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052387"] = {name = "Squid Plush", prices = {["default"] = 3.82}},
    ["rbxassetid://6768659222"] = {name = "Standard Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779638"] = {name = "Telescope Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://3570154347"] = {name = "Unicorn Plush", prices = {["default"] = 105}},
    ["rbxassetid://2408055086"] = {name = "Wooden Pogo", prices = {["default"] = 3.68}},
    ["rbxassetid://4849973554"] = {name = "Bat Wings", prices = {["default"] = 62.85}},
    ["rbxassetid://5881347869"] = {name = "Bewitched Hat", prices = {["default"] = 22.91}},
    ["rbxassetid://4849980085"] = {name = "Blue Cat Ear Headphones", prices = {["default"] = 12.47}},
    ["rbxassetid://5726048365"] = {name = "Bone Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://6706595341"] = {name = "Bunny Ear Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975557"] = {name = "Chef Hat", prices = {["default"] = 11.82}},
    ["rbxassetid://6706592723"] = {name = "Chick Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972658"] = {name = "Clout Goggles", prices = {["default"] = 3.29}},
    ["rbxassetid://6706594347"] = {name = "Egg Glasses", prices = {["default"] = 2.63}},
    ["rbxassetid://4850383048"] = {name = "Elf Hat", prices = {["default"] = 27.18}},
    ["rbxassetid://5415517604"] = {name = "Gold Circle Glasses", prices = {["default"] = 4.8}},
    ["rbxassetid://5415517745"] = {name = "Gold Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://5415523249"] = {name = "Pearl Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://5444594884"] = {name = "Pink Butterfly Wings", prices = {["default"] = 4.86}},
    ["rbxassetid://4849979637"] = {name = "Pink Cat Ear Headphones", prices = {["default"] = 58.29}},
    ["rbxassetid://4849972826"] = {name = "Pink Heart Glasses", prices = {["default"] = 62.91}},
    ["rbxassetid://5457768184"] = {name = "Pink Hightops", prices = {["default"] = 2.52}},
    ["rbxassetid://5415520296"] = {name = "Pink Sneakers", prices = {["default"] = 5.92}},
    ["rbxassetid://4849977607"] = {name = "Propeller Hat", prices = {["default"] = 137.2}},
    ["rbxassetid://4849972928"] = {name = "Purple Heart Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://5415520831"] = {name = "Rain Hat", prices = {["default"] = 3.19}},
    ["rbxassetid://4849974434"] = {name = "Spike Collar", prices = {["default"] = 26.25}},
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