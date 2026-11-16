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
    ["rbxassetid://137637490639925"] = {name = "Royal Mistletroll", prices = {["default"] = 891.13, ["Fly"] = 1127.27, ["Ride"] = 853.13, ["Fly|Ride"] = 1025.07, ["Neon"] = 6574.64, ["Neon|Ride"] = 4930.57, ["Neon|Fly|Ride"] = 4225.35, ["Mega|Fly|Ride"] = 21174.57}},
    ["rbxassetid://140355753768438"] = {name = "Moonbeam Peacock", prices = {["default"] = 393.75, ["Fly"] = 538.82, ["Ride"] = 479.66, ["Fly|Ride"] = 417.32, ["Neon|Fly|Ride"] = 2072.44, ["Mega"] = 9862.32, ["Mega|Fly|Ride"] = 8451.78}},
    ["rbxassetid://18117855573"] = {name = "Balloon Unicorn", prices = {["default"] = 4725, ["Ride"] = 4725, ["Fly|Ride"] = 4749.94, ["Neon"] = 26059.99, ["Neon|Fly|Ride"] = 21764.9, ["Mega|Fly|Ride"] = 60366.75}},
    ["rbxassetid://75782719698946"] = {name = "Red Dutch Guinea Pig", prices = {["default"] = 129.94, ["Ride"] = 156.19, ["Fly|Ride"] = 282.1, ["Neon"] = 1408.86, ["Neon|Ride"] = 821.63, ["Neon|Fly|Ride"] = 564.24, ["Mega|Fly|Ride"] = 3130.67}},
    ["rbxassetid://5067924142"] = {name = "Albino Monkey", prices = {["default"] = 577.5, ["Ride"] = 472.49, ["Fly|Ride"] = 547.59, ["Neon|Fly|Ride"] = 1443.75, ["Mega"] = 11162, ["Mega|Fly|Ride"] = 6337.78}},
    ["rbxassetid://108312620331321"] = {name = "Villain Gibbon", prices = {["default"] = 13.13, ["Ride"] = 46.98, ["Fly|Ride"] = 141.58, ["Neon"] = 42.26, ["Neon|Ride"] = 140.83, ["Neon|Fly|Ride"] = 282.13, ["Mega"] = 262.5, ["Mega|Ride"] = 467.34, ["Mega|Fly|Ride"] = 465.94}},
    ["rbxassetid://17255958862"] = {name = "Alicorn", prices = {["default"] = 5.25, ["Fly"] = 28.88, ["Ride"] = 26.51, ["Fly|Ride"] = 59.63, ["Neon"] = 32.82, ["Neon|Fly"] = 65.51, ["Neon|Ride"] = 49.32, ["Neon|Fly|Ride"] = 105, ["Mega"] = 111.57, ["Mega|Ride"] = 141.6, ["Mega|Fly|Ride"] = 234.78}},
    ["rbxassetid://90170598608675"] = {name = "Moonbeam Butterfly", prices = {["default"] = 118.13, ["Ride"] = 131.25, ["Fly|Ride"] = 231, ["Neon"] = 590.63, ["Neon|Ride"] = 420.48, ["Neon|Fly|Ride"] = 1690.57, ["Mega"] = 1878.54, ["Mega|Fly|Ride"] = 1771.62}},
    ["rbxassetid://7126722445"] = {name = "Goldhorn", prices = {["default"] = 42.27, ["Fly"] = 157.12, ["Ride"] = 42, ["Fly|Ride"] = 106.73, ["Neon"] = 375.38, ["Neon|Ride"] = 183.75, ["Neon|Fly|Ride"] = 261.19, ["Mega"] = 2100, ["Mega|Ride"] = 1268.02, ["Mega|Fly|Ride"] = 963.29}},
    ["rbxassetid://13186021971"] = {name = "Cuddly Candle", prices = {["default"] = 21.11, ["Fly"] = 74.76, ["Ride"] = 43.2, ["Fly|Ride"] = 67.62, ["Neon"] = 282.1, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 192.31, ["Mega|Fly|Ride"] = 728.44}},
    ["rbxassetid://14146196672"] = {name = "Gargoyle", prices = {["default"] = 56.78, ["Ride"] = 73.5, ["Fly|Ride"] = 127.3, ["Neon"] = 262.5, ["Neon|Ride"] = 204.98, ["Neon|Fly|Ride"] = 265.94, ["Mega|Ride"] = 1372.54, ["Mega|Fly|Ride"] = 1260}},
    ["rbxassetid://129762233626342"] = {name = "Royal Moon Egg", prices = {["default"] = 54.89}},
    ["rbxassetid://89693546199400"] = {name = "Cupid Dragon", prices = {["default"] = 509.51, ["Ride"] = 357, ["Fly|Ride"] = 448.69, ["Neon|Fly|Ride"] = 1300.64, ["Mega|Fly|Ride"] = 5257.02}},
    ["rbxassetid://8665606875"] = {name = "Dancing Dragon", prices = {["default"] = 123.38, ["Fly"] = 177.48, ["Ride"] = 130.54, ["Fly|Ride"] = 150.94, ["Neon|Ride"] = 564.38, ["Neon|Fly|Ride"] = 542.96, ["Mega|Fly|Ride"] = 3099.7}},
    ["rbxassetid://110411427278536"] = {name = "Huntsman Robin", prices = {["default"] = 3.89, ["Fly"] = 35.94, ["Ride"] = 33.81, ["Fly|Ride"] = 141.58, ["Neon"] = 18.38, ["Neon|Fly"] = 62.35, ["Neon|Ride"] = 78.2, ["Neon|Fly|Ride"] = 80.32, ["Mega"] = 126, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 383.25}},
    ["rbxassetid://10925517718"] = {name = "Lava Dragon", prices = {["default"] = 131.25, ["Fly"] = 187.69, ["Ride"] = 141.72, ["Fly|Ride"] = 176.46, ["Neon"] = 704.68, ["Neon|Ride"] = 1340.8, ["Neon|Fly|Ride"] = 523.66, ["Mega|Fly|Ride"] = 1837.38}},
    ["rbxassetid://4797806482"] = {name = "Diamond Griffin", prices = {["default"] = 3.73, ["Fly"] = 24.31, ["Ride"] = 19.69, ["Fly|Ride"] = 45.94, ["Neon"] = 27.57, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 105, ["Mega"] = 211.34, ["Mega|Ride"] = 326.82, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://122648024705835"] = {name = "Scarebear", prices = {["default"] = 52.5, ["Fly"] = 262.5, ["Ride"] = 93.19, ["Fly|Ride"] = 157.34, ["Neon"] = 177.19, ["Neon|Ride"] = 223.97, ["Neon|Fly|Ride"] = 316.99, ["Mega"] = 826.55, ["Mega|Ride"] = 790.21, ["Mega|Fly|Ride"] = 756}},
    ["rbxassetid://13104102169"] = {name = "Danger Egg", prices = {["default"] = 70.8}},
    ["rbxassetid://133163961974577"] = {name = "2D Doggy", prices = {["default"] = 65.5, ["Ride"] = 97.01, ["Neon"] = 280.88, ["Neon|Ride"] = 498.75, ["Neon|Fly|Ride"] = 2362.5, ["Mega|Fly|Ride"] = 3130.67}},
    ["rbxassetid://126071806166898"] = {name = "Evil Chick", prices = {["default"] = 18.38, ["Fly"] = 393.75, ["Ride"] = 31.7, ["Fly|Ride"] = 106.32, ["Neon"] = 154.26, ["Neon|Ride"] = 360.94, ["Neon|Fly|Ride"] = 268.38, ["Mega"] = 2700.41, ["Mega|Ride"] = 564.38, ["Mega|Fly|Ride"] = 1690.37}},
    ["rbxassetid://5721843247"] = {name = "Dodo", prices = {["default"] = 42, ["Fly"] = 70.8, ["Ride"] = 59.07, ["Fly|Ride"] = 127.76, ["Neon"] = 295.82, ["Neon|Fly"] = 314.84, ["Neon|Ride"] = 203.34, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 1681.32, ["Mega|Fly|Ride"] = 815.06}},
    ["rbxassetid://119640582603552"] = {name = "Violet Butterfly", prices = {["default"] = 55.49, ["Ride"] = 155.76, ["Fly|Ride"] = 196.88, ["Neon"] = 207.38, ["Neon|Ride"] = 223.12, ["Neon|Fly|Ride"] = 315.94, ["Mega"] = 1967.44, ["Mega|Ride"] = 1254.21, ["Mega|Fly|Ride"] = 1266.72}},
    ["rbxassetid://16088264958"] = {name = "Volcanic Rhino", prices = {["default"] = 45.8, ["Ride"] = 50.72, ["Fly|Ride"] = 179.62, ["Neon"] = 172.23, ["Neon|Ride"] = 211.95, ["Neon|Fly|Ride"] = 169.08, ["Mega"] = 1207.92, ["Mega|Ride"] = 2100, ["Mega|Fly|Ride"] = 986.75}},
    ["rbxassetid://75251818654427"] = {name = "Apple Owl", prices = {["default"] = 43.63, ["Fly"] = 648.69, ["Ride"] = 83.47, ["Fly|Ride"] = 131.25, ["Neon"] = 313.42, ["Neon|Ride"] = 309.68, ["Neon|Fly|Ride"] = 492.19, ["Mega|Ride"] = 1124.82, ["Mega|Fly|Ride"] = 1254.05}},
    ["rbxassetid://3181727433"] = {name = "Dragon", prices = {["default"] = 6.57, ["Fly"] = 32.82, ["Ride"] = 23.63, ["Fly|Ride"] = 49.67, ["Neon"] = 31.48, ["Neon|Fly"] = 70.79, ["Neon|Ride"] = 40.69, ["Neon|Fly|Ride"] = 94.65, ["Mega"] = 129.94, ["Mega|Fly"] = 234.84, ["Mega|Ride"] = 126.81, ["Mega|Fly|Ride"] = 211.31}},
    ["rbxassetid://121496682360324"] = {name = "Sugar Axolotl", prices = {["default"] = 325.47, ["Ride"] = 338.63, ["Fly|Ride"] = 362.25, ["Neon"] = 1181.25, ["Neon|Ride"] = 1973.74, ["Neon|Fly|Ride"] = 1666.88, ["Mega"] = 10566, ["Mega|Fly|Ride"] = 7332.94}},
    ["rbxassetid://11694854226"] = {name = "Shetland Pony Light Brown", prices = {["default"] = 22.32, ["Ride"] = 27.2, ["Fly|Ride"] = 137.52, ["Neon"] = 238.79, ["Neon|Ride"] = 304.5, ["Neon|Fly|Ride"] = 409.98, ["Mega|Fly|Ride"] = 760.68}},
    ["rbxassetid://4797806957"] = {name = "Golden Unicorn", prices = {["default"] = 6.57, ["Fly"] = 48.61, ["Ride"] = 25.36, ["Fly|Ride"] = 53.82, ["Neon"] = 55.19, ["Neon|Ride"] = 70.8, ["Neon|Fly|Ride"] = 105, ["Mega"] = 375.73, ["Mega|Fly|Ride"] = 379.09}},
    ["rbxassetid://110822620060051"] = {name = "Frost Phoenix", prices = {["default"] = 100.17, ["Fly"] = 140.89, ["Ride"] = 125.73, ["Fly|Ride"] = 156.37, ["Neon"] = 420, ["Neon|Ride"] = 464.86, ["Neon|Fly|Ride"] = 446.25, ["Mega"] = 6221.46, ["Mega|Ride"] = 1474.02, ["Mega|Fly|Ride"] = 1512.89}},
    ["rbxassetid://13894724323"] = {name = "Billy Goat", prices = {["default"] = 15.86, ["Fly"] = 35.94, ["Ride"] = 26.25, ["Fly|Ride"] = 59.04, ["Neon"] = 78.2, ["Neon|Ride"] = 141.58, ["Neon|Fly|Ride"] = 207.38, ["Mega"] = 704.46, ["Mega|Ride"] = 590.63, ["Mega|Fly|Ride"] = 627.56}},
    ["rbxassetid://123037843357105"] = {name = "Glormy Leo", prices = {["default"] = 187.69, ["Fly"] = 352.88, ["Ride"] = 244.18, ["Fly|Ride"] = 315.91, ["Neon"] = 761.25, ["Neon|Ride"] = 787.5, ["Neon|Fly|Ride"] = 773.07, ["Mega"] = 6339.6, ["Mega|Fly|Ride"] = 3084.38}},
    ["rbxassetid://12479078933"] = {name = "Southeast Asia Egg", prices = {["default"] = 23.63}},
    ["rbxassetid://122739780018633"] = {name = "Quetzalcoatl", prices = {["default"] = 4.24, ["Fly"] = 36.41, ["Ride"] = 27.57, ["Fly|Ride"] = 92.77, ["Neon"] = 21, ["Neon|Fly"] = 91.92, ["Neon|Ride"] = 35.44, ["Neon|Fly|Ride"] = 187.87, ["Mega"] = 131.25, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://70953296065239"] = {name = "Frostbite Bear", prices = {["default"] = 721.88, ["Ride"] = 825.57, ["Fly|Ride"] = 820.32, ["Neon"] = 4507.98, ["Neon|Ride"] = 4085.4, ["Neon|Fly|Ride"] = 3776.3, ["Mega"] = 12256.56, ["Mega|Ride"] = 52833.62, ["Mega|Fly|Ride"] = 12537.15}},
    ["rbxassetid://14978701948"] = {name = "Scarecrow Crow", prices = {["default"] = 7.87, ["Fly"] = 39.93, ["Ride"] = 46.5, ["Fly|Ride"] = 90.87, ["Neon"] = 108.83, ["Neon|Ride"] = 139.86, ["Neon|Fly|Ride"] = 141.75, ["Mega"] = 511.88, ["Mega|Ride"] = 598.05, ["Mega|Fly|Ride"] = 535.64}},
    ["rbxassetid://11191341630"] = {name = "Jousting Horse", prices = {["default"] = 94.5, ["Ride"] = 118.13, ["Fly|Ride"] = 228.38, ["Neon"] = 667.71, ["Neon|Ride"] = 625.45, ["Neon|Fly|Ride"] = 590.63, ["Mega|Ride"] = 6074.25, ["Mega|Fly|Ride"] = 2254.52}},
    ["rbxassetid://76801905892592"] = {name = "Royal Aztec Egg", prices = {["default"] = 36.04}},
    ["rbxassetid://98801943598121"] = {name = "Priceless Shrimp", prices = {["default"] = 28.54, ["Ride"] = 55.13, ["Fly|Ride"] = 140.9, ["Neon"] = 169.04, ["Neon|Ride"] = 141.58, ["Neon|Fly|Ride"] = 472.5, ["Mega"] = 564.24, ["Mega|Ride"] = 723.19}},
    ["rbxassetid://95214789806437"] = {name = "Aztec Egg", prices = {["default"] = 2.63}},
    ["rbxassetid://18515755354"] = {name = "Cheetah", prices = {["Ride"] = 199.5, ["Fly|Ride"] = 354.58, ["Neon|Ride"] = 498.75, ["Neon|Fly|Ride"] = 704.76, ["Mega|Fly|Ride"] = 2279.88}},
    ["rbxassetid://18117855114"] = {name = "Corn Doggo", prices = {["default"] = 134.17, ["Ride"] = 157.5, ["Fly|Ride"] = 245.44, ["Neon"] = 514.25, ["Neon|Ride"] = 420, ["Neon|Fly|Ride"] = 485.63, ["Mega"] = 1312.5, ["Mega|Ride"] = 1509.38, ["Mega|Fly|Ride"] = 1469.99}},
    ["rbxassetid://8972175010"] = {name = "Woodland Egg", prices = {["default"] = 63}},
    ["rbxassetid://3710823011"] = {name = "Golden Penguin", prices = {["default"] = 60.38, ["Fly"] = 65.63, ["Ride"] = 64.32, ["Fly|Ride"] = 79.15, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 311.07, ["Mega"] = 4225.35, ["Mega|Fly|Ride"] = 1315.81}},
    ["rbxassetid://136490701345923"] = {name = "Glormy Crab", prices = {["default"] = 9.4, ["Ride"] = 28.54, ["Fly|Ride"] = 159.54, ["Neon"] = 38.07, ["Neon|Ride"] = 141.58, ["Neon|Fly|Ride"] = 226.12, ["Mega"] = 165.95, ["Mega|Fly"] = 267.75, ["Mega|Ride"] = 264.16, ["Mega|Fly|Ride"] = 348.65}},
    ["rbxassetid://14782580581"] = {name = "Vampire Dragon", prices = {["default"] = 339.56, ["Fly"] = 492.19, ["Ride"] = 351.75, ["Fly|Ride"] = 406.88, ["Neon|Ride"] = 1549.86, ["Neon|Fly|Ride"] = 1210.8, ["Mega|Fly|Ride"] = 4541.78}},
    ["rbxassetid://88405494856204"] = {name = "Solaris", prices = {["default"] = 73.5, ["Fly"] = 99.75, ["Ride"] = 78.75, ["Fly|Ride"] = 128.91, ["Neon"] = 354.38, ["Neon|Ride"] = 380.35, ["Neon|Fly|Ride"] = 369.02, ["Mega|Fly|Ride"] = 1869.97}},
    ["rbxassetid://84468510887759"] = {name = "Orchid Butterfly", prices = {["default"] = 3662.35, ["Ride"] = 3734.63, ["Fly|Ride"] = 3017.43, ["Neon|Fly|Ride"] = 14086.58}},
    ["rbxassetid://11109286837"] = {name = "Lava Wolf", prices = {["default"] = 39.38, ["Fly"] = 84.53, ["Ride"] = 39.38, ["Fly|Ride"] = 105.67, ["Neon|Ride"] = 229.69, ["Neon|Fly|Ride"] = 313.5, ["Mega"] = 1901.89, ["Mega|Ride"] = 1901.89, ["Mega|Fly|Ride"] = 2028.44}},
    ["rbxassetid://12403863809"] = {name = "Albino Gorilla", prices = {["default"] = 90.86, ["Ride"] = 84.53, ["Fly|Ride"] = 140.9, ["Neon"] = 479.07, ["Neon|Ride"] = 792.95, ["Neon|Fly|Ride"] = 564.24, ["Mega"] = 6339.6, ["Mega|Fly|Ride"] = 1582.61}},
    ["rbxassetid://6060988121"] = {name = "Snow Owl", prices = {["default"] = 38.07, ["Fly"] = 76.13, ["Ride"] = 56.44, ["Fly|Ride"] = 125.62, ["Neon"] = 274.71, ["Neon|Fly"] = 281.03, ["Neon|Ride"] = 173.25, ["Neon|Fly|Ride"] = 236.6, ["Mega"] = 2625, ["Mega|Ride"] = 595.27, ["Mega|Fly|Ride"] = 580.13}},
    ["rbxassetid://112630556645658"] = {name = "Moon Egg", prices = {["default"] = 12.68}},
    ["rbxassetid://10357473556"] = {name = "Golden Chow-Chow", prices = {["default"] = 72.19, ["Ride"] = 70.8, ["Fly|Ride"] = 117.28, ["Neon"] = 353.93, ["Neon|Ride"] = 469.64, ["Neon|Fly|Ride"] = 501.89}},
    ["rbxassetid://5721843384"] = {name = "Fossil Egg", prices = {["default"] = 39.38}},
    ["rbxassetid://92775688228060"] = {name = "Papa Moose", prices = {["default"] = 200.97, ["Ride"] = 311.68, ["Fly|Ride"] = 338.08, ["Neon|Fly|Ride"] = 1465.16}},
    ["rbxassetid://12479991588"] = {name = "Frost Unicorn", prices = {["default"] = 845.09, ["Ride"] = 757.95, ["Fly|Ride"] = 766.5, ["Neon|Ride"] = 3239.15, ["Neon|Fly|Ride"] = 2559.38, ["Mega|Fly|Ride"] = 11812.5}},
    ["rbxassetid://9661880325"] = {name = "Zodiac Minion Egg", prices = {["default"] = 17.62}},
    ["rbxassetid://7126719832"] = {name = "Phoenix", prices = {["default"] = 28.88, ["Fly"] = 52.42, ["Ride"] = 43.32, ["Fly|Ride"] = 72.19, ["Neon"] = 183.75, ["Neon|Ride"] = 177.19, ["Neon|Fly|Ride"] = 224.01, ["Mega|Ride"] = 918.75, ["Mega|Fly|Ride"] = 662.58}},
    ["rbxassetid://119386690822810"] = {name = "Royal Fairytale Egg", prices = {["default"] = 11.82}},
    ["rbxassetid://4440866299"] = {name = "Crow", prices = {["default"] = 5139.75, ["Fly|Ride"] = 5145, ["Neon|Fly|Ride"] = 9495.94, ["Mega|Fly|Ride"] = 40710.06}},
    ["rbxassetid://4797806531"] = {name = "Diamond Unicorn", prices = {["default"] = 10.5, ["Fly"] = 42.26, ["Ride"] = 28.04, ["Fly|Ride"] = 45.94, ["Neon"] = 105.67, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 139.31, ["Mega"] = 393.75, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 462.81}},
    ["rbxassetid://88817325500927"] = {name = "Kraken", prices = {["default"] = 17.62, ["Fly"] = 105.67, ["Ride"] = 30.19, ["Fly|Ride"] = 116.24, ["Neon"] = 78.75, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 845.3, ["Mega|Ride"] = 519.86, ["Mega|Fly|Ride"] = 1458.19}},
    ["rbxassetid://9490243442"] = {name = "Diamond King Penguin", prices = {["default"] = 109.88, ["Fly"] = 139.21, ["Ride"] = 103.69, ["Fly|Ride"] = 140.44, ["Neon"] = 1409.35, ["Neon|Fly|Ride"] = 420, ["Mega"] = 4226.4}},
    ["rbxassetid://107787284008278"] = {name = "Primal Kaijunior", prices = {["default"] = 7.88, ["Ride"] = 35.95, ["Fly|Ride"] = 139.65, ["Neon"] = 53.82, ["Neon|Ride"] = 84.53, ["Neon|Fly|Ride"] = 717.38, ["Mega"] = 1409.52, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://4506837037"] = {name = "Arctic Reindeer", prices = {["default"] = 2126.25, ["Fly"] = 3099.32, ["Fly|Ride"] = 2043.57, ["Neon|Fly|Ride"] = 4725, ["Mega|Fly|Ride"] = 14119.41}},
    ["rbxassetid://4184878149"] = {name = "Bat Dragon", prices = {["default"] = 34168.32, ["Fly"] = 31305.41, ["Ride"] = 35216.41, ["Fly|Ride"] = 23625, ["Neon|Ride"] = 65625, ["Neon|Fly|Ride"] = 61687.5, ["Mega"] = 210000, ["Mega|Fly|Ride"] = 197208.23}},
    ["rbxassetid://118641789458122"] = {name = "Gilded Snake", prices = {["default"] = 19.69, ["Fly"] = 393.75, ["Ride"] = 50.72, ["Fly|Ride"] = 126.79, ["Neon"] = 135.24, ["Neon|Ride"] = 178.38, ["Neon|Fly|Ride"] = 422.66, ["Mega"] = 1470, ["Mega|Ride"] = 676.24, ["Mega|Fly|Ride"] = 690.96}},
    ["rbxassetid://71844856693163"] = {name = "Purrowl", prices = {["default"] = 3.68, ["Ride"] = 39.93, ["Fly|Ride"] = 96.15, ["Neon"] = 15.75, ["Neon|Fly"] = 130.33, ["Neon|Ride"] = 40.69, ["Neon|Fly|Ride"] = 80.07, ["Mega"] = 115.14, ["Mega|Ride"] = 159.95, ["Mega|Fly|Ride"] = 254.63}},
    ["rbxassetid://7195311687"] = {name = "Mythic Egg", prices = {["default"] = 23.63}},
    ["rbxassetid://102330087609546"] = {name = "Fire Mare", prices = {["default"] = 7.49, ["Ride"] = 38.07, ["Fly|Ride"] = 111.57, ["Neon"] = 63.41, ["Neon|Ride"] = 105.25, ["Neon|Fly|Ride"] = 463.32, ["Mega"] = 393.75, ["Mega|Ride"] = 370.13, ["Mega|Fly|Ride"] = 421.55}},
    ["rbxassetid://16659215347"] = {name = "Candyfloss Chick", prices = {["default"] = 656.25, ["Ride"] = 708.75, ["Fly|Ride"] = 722.67, ["Neon"] = 2975.03, ["Neon|Fly|Ride"] = 2491.13, ["Mega|Fly|Ride"] = 10956.71}},
    ["rbxassetid://9281950769"] = {name = "Sugar Glider", prices = {["default"] = 918.75, ["Fly"] = 1076.25, ["Ride"] = 905.63, ["Fly|Ride"] = 1156.31, ["Neon|Fly|Ride"] = 3071.25, ["Mega|Fly|Ride"] = 28172.91}},
    ["rbxassetid://15485137935"] = {name = "Fleur De Ice", prices = {["default"] = 31.5, ["Fly"] = 117.42, ["Ride"] = 43.32, ["Fly|Ride"] = 126.79, ["Neon"] = 180.85, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 420.55, ["Mega|Fly|Ride"] = 760.68}},
    ["rbxassetid://6498256269"] = {name = "Ocean Egg", prices = {["default"] = 31.49}},
    ["rbxassetid://8704877940"] = {name = "Lavender Dragon", prices = {["default"] = 78.75, ["Fly"] = 106.32, ["Ride"] = 99.32, ["Fly|Ride"] = 126, ["Neon"] = 469.63, ["Neon|Ride"] = 425.77, ["Neon|Fly|Ride"] = 410.82, ["Mega|Fly|Ride"] = 1598.63}},
    ["rbxassetid://13685038182"] = {name = "Leviathan", prices = {["default"] = 67.71, ["Ride"] = 121.51, ["Fly|Ride"] = 150.03, ["Neon"] = 450.19, ["Neon|Ride"] = 517.77, ["Neon|Fly|Ride"] = 15655.2, ["Mega"] = 2129.29, ["Mega|Fly|Ride"] = 1651.28}},
    ["rbxassetid://4797806358"] = {name = "Diamond Dragon", prices = {["default"] = 3.68, ["Fly"] = 32.78, ["Ride"] = 22.32, ["Fly|Ride"] = 39.38, ["Neon"] = 32.82, ["Neon|Fly"] = 313.49, ["Neon|Ride"] = 77.37, ["Neon|Fly|Ride"] = 105, ["Mega"] = 197.6, ["Mega|Ride"] = 211.34, ["Mega|Fly|Ride"] = 371.44}},
    ["rbxassetid://5862774327"] = {name = "Cerberus", prices = {["default"] = 82.69, ["Fly"] = 112.96, ["Ride"] = 77.31, ["Fly|Ride"] = 146.68, ["Neon"] = 422.6, ["Neon|Ride"] = 362.25, ["Neon|Fly|Ride"] = 300.55, ["Mega|Fly|Ride"] = 982.94}},
    ["rbxassetid://74012786571707"] = {name = "Three Blind Mice", prices = {["default"] = 3.49, ["Fly"] = 42.27, ["Ride"] = 42.27, ["Fly|Ride"] = 262.5, ["Neon"] = 25.24, ["Neon|Fly"] = 268.36, ["Neon|Ride"] = 104.61, ["Mega"] = 101.94, ["Mega|Fly"] = 986.88, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 349.46}},
    ["rbxassetid://15931348363"] = {name = "Criosphinx", prices = {["default"] = 21, ["Fly"] = 65.63, ["Ride"] = 31.24, ["Fly|Ride"] = 117.42, ["Neon"] = 140.9, ["Neon|Ride"] = 164.07, ["Neon|Fly|Ride"] = 185.52, ["Mega"] = 1050, ["Mega|Fly|Ride"] = 728.44}},
    ["rbxassetid://118278167134251"] = {name = "Influencer Gibbon", prices = {["default"] = 32.75, ["Ride"] = 46.52, ["Fly|Ride"] = 282.1, ["Neon"] = 183.84, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 704.76, ["Mega|Ride"] = 2113.2, ["Mega|Fly|Ride"] = 703.29}},
    ["rbxassetid://17059982206"] = {name = "Dimorphodon", prices = {["default"] = 17.07, ["Fly"] = 44.84, ["Ride"] = 42, ["Fly|Ride"] = 77.44, ["Neon"] = 103.69, ["Neon|Fly"] = 422.6, ["Neon|Ride"] = 64.93, ["Neon|Fly|Ride"] = 249.38, ["Mega|Ride"] = 942.43, ["Mega|Fly|Ride"] = 928.65}},
    ["rbxassetid://119212313534429"] = {name = "Giant Panda", prices = {["default"] = 4462.5, ["Ride"] = 5906.25, ["Fly|Ride"] = 5118.74, ["Neon"] = 30991.58, ["Neon|Fly|Ride"] = 24937.5}},
    ["rbxassetid://6060998707"] = {name = "Frost Fury", prices = {["default"] = 259.77, ["Fly"] = 268.33, ["Ride"] = 223.13, ["Fly|Ride"] = 281.69, ["Neon|Fly|Ride"] = 542.33, ["Mega|Fly|Ride"] = 2514.41}},
    ["rbxassetid://88882779021298"] = {name = "Kitty Bat", prices = {["default"] = 36.75, ["Fly"] = 94.08, ["Ride"] = 65.3, ["Fly|Ride"] = 114.51, ["Neon"] = 73.5, ["Neon|Fly"] = 241.5, ["Neon|Ride"] = 112.97, ["Neon|Fly|Ride"] = 169.09, ["Mega"] = 285.73, ["Mega|Ride"] = 313.84, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://16441372760"] = {name = "Diamond Mahi Mahi", prices = {["default"] = 3.42, ["Fly"] = 41.1, ["Ride"] = 19.82, ["Fly|Ride"] = 176.45, ["Neon"] = 21.78, ["Neon|Ride"] = 57.06, ["Mega"] = 170.63}},
    ["rbxassetid://3199974169"] = {name = "Royal Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://84714602656867"] = {name = "Slimingo", prices = {["default"] = 31.5, ["Fly"] = 132.68, ["Ride"] = 78.65, ["Fly|Ride"] = 146.19, ["Neon"] = 114.76, ["Neon|Fly"] = 264.14, ["Neon|Ride"] = 216.57, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 479.07, ["Mega|Ride"] = 428.71, ["Mega|Fly|Ride"] = 531.25}},
    ["rbxassetid://3409443710"] = {name = "Giraffe", prices = {["default"] = 18310.66, ["Ride"] = 10237.5, ["Fly|Ride"] = 12337.5, ["Neon|Fly|Ride"] = 23625, ["Mega|Fly|Ride"] = 91555.89}},
    ["rbxassetid://121215031043780"] = {name = "Velocirooster", prices = {["default"] = 153.54, ["Ride"] = 179.65, ["Fly|Ride"] = 281.03, ["Neon"] = 843.07, ["Neon|Ride"] = 704.68, ["Neon|Fly|Ride"] = 939.27}},
    ["rbxassetid://5067925034"] = {name = "Ninja Monkey", prices = {["default"] = 33.08, ["Fly"] = 436.41, ["Ride"] = 44.63, ["Fly|Ride"] = 105, ["Neon|Fly"] = 469.64, ["Neon|Ride"] = 288.75, ["Neon|Fly|Ride"] = 288.75, ["Mega|Fly|Ride"] = 1815.02}},
    ["rbxassetid://10618035564"] = {name = "Baku", prices = {["default"] = 9.4, ["Ride"] = 24.31, ["Fly|Ride"] = 57.66, ["Neon"] = 65.63, ["Neon|Ride"] = 78.73, ["Neon|Fly|Ride"] = 162.73, ["Mega"] = 479.72, ["Mega|Ride"] = 492.19, ["Mega|Fly|Ride"] = 387.74}},
    ["rbxassetid://13665641282"] = {name = "Shark Puppy", prices = {["default"] = 385.88, ["Fly"] = 845.19, ["Ride"] = 414.3, ["Fly|Ride"] = 440.88, ["Neon"] = 1639.32, ["Neon|Ride"] = 1312.5, ["Neon|Fly|Ride"] = 1443.75, ["Mega|Fly|Ride"] = 4935}},
    ["rbxassetid://119447343321908"] = {name = "Tealwood Monster", prices = {["default"] = 8.46, ["Ride"] = 60.24, ["Fly|Ride"] = 211.31, ["Neon"] = 32.76, ["Neon|Ride"] = 95.82, ["Neon|Fly|Ride"] = 238.81, ["Mega"] = 118.13, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 281.74}},
    ["rbxassetid://85568505745239"] = {name = "Latte Kitsune", prices = {["default"] = 120.75, ["Fly"] = 211.29, ["Ride"] = 192.28, ["Fly|Ride"] = 244.13, ["Neon"] = 671.93, ["Neon|Ride"] = 446.25, ["Neon|Fly|Ride"] = 472.5, ["Mega"] = 2254.8, ["Mega|Ride"] = 3451.92, ["Mega|Fly|Ride"] = 2112.94}},
    ["rbxassetid://3181727727"] = {name = "Griffin", prices = {["default"] = 11.46, ["Fly"] = 21, ["Ride"] = 19.69, ["Fly|Ride"] = 36.75, ["Neon|Ride"] = 99.57, ["Neon|Fly|Ride"] = 86.66, ["Mega"] = 2535.86, ["Mega|Fly|Ride"] = 577.5}},
    ["rbxassetid://4822753215"] = {name = "Golden Egg", prices = {["default"] = 12.69}},
    ["rbxassetid://116463571924920"] = {name = "Prismatic Butterfly", prices = {["default"] = 61.69, ["Ride"] = 93.94, ["Fly|Ride"] = 525, ["Neon"] = 244.06, ["Neon|Fly"] = 1690.37, ["Neon|Ride"] = 369.84, ["Neon|Fly|Ride"] = 470.14, ["Mega"] = 1265.82, ["Mega|Ride"] = 1408.91, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://8596153183"] = {name = "Chameleon", prices = {["default"] = 12.9, ["Fly"] = 104.6, ["Ride"] = 34.13, ["Fly|Ride"] = 93.19, ["Neon"] = 84.53, ["Neon|Ride"] = 105.67, ["Neon|Fly|Ride"] = 210.29, ["Mega|Ride"] = 501.48, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://110774856122162"] = {name = "Gemstone Egg", prices = {["default"] = 17.99}},
    ["rbxassetid://14892649590"] = {name = "Dire Stag", prices = {["default"] = 22.16, ["Fly"] = 210, ["Ride"] = 63.41, ["Fly|Ride"] = 236.25, ["Neon"] = 141.75, ["Neon|Ride"] = 204.3, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 1550.05, ["Mega|Ride"] = 828.39, ["Mega|Fly|Ride"] = 734.99}},
    ["rbxassetid://106744890070136"] = {name = "Oakee Wizard", prices = {["default"] = 3.94, ["Ride"] = 32.76, ["Fly|Ride"] = 131.25, ["Neon"] = 19.04, ["Neon|Ride"] = 138.42, ["Neon|Fly|Ride"] = 282.13, ["Mega"] = 98.88, ["Mega|Fly|Ride"] = 424.95}},
    ["rbxassetid://9938967576"] = {name = "Chocolate Chow-Chow", prices = {["default"] = 18.38, ["Ride"] = 35.94, ["Fly|Ride"] = 112.01, ["Neon"] = 141.58, ["Neon|Ride"] = 112.49, ["Neon|Fly|Ride"] = 131.25, ["Mega|Fly|Ride"] = 800.82}},
    ["rbxassetid://9174893483"] = {name = "Mechapup", prices = {["default"] = 393.75, ["Fly"] = 437.75, ["Ride"] = 301.88, ["Fly|Ride"] = 469.63, ["Neon|Fly"] = 1372.37, ["Neon|Fly|Ride"] = 1895.56, ["Mega|Fly|Ride"] = 8874.37}},
    ["rbxassetid://15292843858"] = {name = "Mecha Meow", prices = {["default"] = 63.39, ["Ride"] = 70.45, ["Fly|Ride"] = 131.25, ["Neon"] = 215.54, ["Neon|Ride"] = 209.2, ["Neon|Fly|Ride"] = 224.01, ["Mega"] = 704.96, ["Mega|Ride"] = 681.45, ["Mega|Fly|Ride"] = 986.75}},
    ["rbxassetid://15931200262"] = {name = "Cactus Friend", prices = {["default"] = 65.63, ["Fly"] = 84.53, ["Ride"] = 109.89, ["Fly|Ride"] = 125.87, ["Neon"] = 203.1, ["Neon|Ride"] = 289.52, ["Neon|Fly|Ride"] = 630, ["Mega|Ride"] = 1050, ["Mega|Fly|Ride"] = 844.14}},
    ["rbxassetid://127221459636244"] = {name = "Strawberry Shortcake Ducky", prices = {["default"] = 21.14, ["Ride"] = 45.94, ["Fly|Ride"] = 131.25, ["Neon"] = 72.76, ["Neon|Ride"] = 211.31, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 311.72, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 521.07}},
    ["rbxassetid://4470748644"] = {name = "Frost Dragon", prices = {["default"] = 11287.5, ["Fly"] = 11269.81, ["Ride"] = 11270.8, ["Fly|Ride"] = 8130.94, ["Neon|Fly|Ride"] = 17317.13, ["Mega|Fly|Ride"] = 39372.9}},
    ["rbxassetid://15365667976"] = {name = "Chocolate Chip Bat Dragon", prices = {["Ride"] = 1953, ["Fly|Ride"] = 1924.1, ["Neon|Fly|Ride"] = 4364.07, ["Mega|Fly|Ride"] = 21525}},
    ["rbxassetid://16898343164"] = {name = "Pirate Ghost Capuchin Monkey", prices = {["default"] = 378, ["Ride"] = 446.16, ["Fly|Ride"] = 420, ["Neon"] = 2112.95, ["Neon|Ride"] = 3169.43, ["Neon|Fly|Ride"] = 1426.43, ["Mega"] = 16905.59, ["Mega|Fly|Ride"] = 7200.39}},
    ["rbxassetid://6404812772"] = {name = "Golden Ladybug", prices = {["default"] = 12.78, ["Fly"] = 31.7, ["Ride"] = 26.25, ["Fly|Ride"] = 51.19, ["Neon"] = 78.75, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 183.86, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://95029455226760"] = {name = "Easter Bunny", prices = {["default"] = 7.88, ["Ride"] = 57.06, ["Fly|Ride"] = 111.57, ["Neon"] = 24.94, ["Neon|Ride"] = 52.5, ["Mega"] = 118.13, ["Mega|Ride"] = 233.66}},
    ["rbxassetid://5307473113"] = {name = "Kitsune", prices = {["default"] = 39.11, ["Fly"] = 48.61, ["Ride"] = 55.13, ["Fly|Ride"] = 87.94, ["Neon|Ride"] = 154.72, ["Neon|Fly|Ride"] = 162.75, ["Mega|Fly|Ride"] = 524.56}},
    ["rbxassetid://4797806780"] = {name = "Golden Dragon", prices = {["default"] = 3.94, ["Fly"] = 19.67, ["Ride"] = 20.09, ["Fly|Ride"] = 39.38, ["Neon"] = 31.5, ["Neon|Fly"] = 282.1, ["Neon|Ride"] = 54.96, ["Neon|Fly|Ride"] = 99.75, ["Mega"] = 360.94, ["Mega|Ride"] = 210, ["Mega|Fly|Ride"] = 276.41}},
    ["rbxassetid://135649428081307"] = {name = "Sakura Spirit", prices = {["default"] = 363.4, ["Fly"] = 320.25, ["Ride"] = 288.75, ["Fly|Ride"] = 354.38, ["Neon|Ride"] = 1761.12, ["Neon|Fly|Ride"] = 1381, ["Mega|Fly|Ride"] = 5225.32}},
    ["rbxassetid://11109110190"] = {name = "White Amazon", prices = {["default"] = 30.85, ["Fly"] = 45.76, ["Ride"] = 40.69, ["Fly|Ride"] = 99.32, ["Neon"] = 169.04, ["Neon|Fly"] = 282.1, ["Neon|Ride"] = 156.96, ["Neon|Fly|Ride"] = 178.49, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://9475753542"] = {name = "Golden Albatross", prices = {["default"] = 13.13, ["Fly"] = 21.11, ["Ride"] = 27.48, ["Fly|Ride"] = 42, ["Neon"] = 141.58, ["Neon|Fly"] = 126.79, ["Neon|Ride"] = 110.37, ["Neon|Fly|Ride"] = 111.57, ["Mega"] = 1575, ["Mega|Ride"] = 582.21, ["Mega|Fly|Ride"] = 498.67}},
    ["rbxassetid://12778628831"] = {name = "Emperor Gorilla", prices = {["default"] = 514.45, ["Fly"] = 787.5, ["Ride"] = 459.38, ["Fly|Ride"] = 793.43, ["Mega|Fly|Ride"] = 7817.9}},
    ["rbxassetid://13672542902"] = {name = "Hot Doggo", prices = {["default"] = 1101.02, ["Ride"] = 1170.75, ["Fly|Ride"] = 1181.25, ["Neon"] = 4944.3, ["Neon|Fly|Ride"] = 3570, ["Mega|Fly|Ride"] = 17999.79}},
    ["rbxassetid://8070897995"] = {name = "Ice Golem", prices = {["default"] = 106.32, ["Fly"] = 125.63, ["Ride"] = 93.19, ["Fly|Ride"] = 113.06, ["Neon"] = 502.9, ["Neon|Ride"] = 414.75, ["Neon|Fly|Ride"] = 525, ["Mega|Fly|Ride"] = 1834.88}},
    ["rbxassetid://128225904426926"] = {name = "Rose Dragon", prices = {["default"] = 170.63, ["Fly"] = 226.08, ["Ride"] = 183.75, ["Fly|Ride"] = 224.44, ["Neon"] = 704.68, ["Neon|Ride"] = 629.5, ["Neon|Fly|Ride"] = 615.57, ["Mega|Ride"] = 7582.32, ["Mega|Fly|Ride"] = 2625}},
    ["rbxassetid://13883274830"] = {name = "Pirate Hermit Crab", prices = {["default"] = 22.32, ["Ride"] = 37, ["Neon"] = 395.14, ["Neon|Ride"] = 272.99, ["Neon|Fly|Ride"] = 315.94, ["Mega|Ride"] = 1832.16, ["Mega|Fly|Ride"] = 1054.37}},
    ["rbxassetid://95213400890066"] = {name = "Diamond Hummingbird", prices = {["default"] = 215.52, ["Ride"] = 211.31, ["Fly|Ride"] = 597.19, ["Neon"] = 1549.86, ["Neon|Fly|Ride"] = 1690.57, ["Mega|Fly|Ride"] = 4069.74}},
    ["rbxassetid://10453528102"] = {name = "Diamond Butterfly", prices = {["default"] = 1967.44, ["Fly"] = 2429.89, ["Ride"] = 2296.5, ["Fly|Ride"] = 2112.95, ["Mega|Fly|Ride"] = 48597.67}},
    ["rbxassetid://12778628650"] = {name = "Astronaut Gorilla", prices = {["default"] = 92.97, ["Ride"] = 48.57, ["Fly|Ride"] = 196.88, ["Neon"] = 290.55, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 352.93, ["Mega|Ride"] = 2324.54, ["Mega|Fly|Ride"] = 2535.54}},
    ["rbxassetid://4708551306"] = {name = "Kangaroo", prices = {["default"] = 607.18, ["Fly"] = 675.94, ["Ride"] = 612.22, ["Fly|Ride"] = 643.13, ["Neon|Ride"] = 1546.69, ["Neon|Fly|Ride"] = 1187.82, ["Mega|Fly|Ride"] = 2794.61}},
    ["rbxassetid://9542440966"] = {name = "Capricorn", prices = {["default"] = 62.34, ["Fly"] = 139.46, ["Ride"] = 57.75, ["Fly|Ride"] = 105, ["Neon|Ride"] = 199.5, ["Neon|Fly|Ride"] = 313.5, ["Mega|Fly|Ride"] = 989.73}},
    ["rbxassetid://9678195673"] = {name = "Ancient Dragon", prices = {["default"] = 3.94, ["Fly"] = 22.32, ["Ride"] = 20.83, ["Fly|Ride"] = 45.94, ["Neon"] = 24.31, ["Neon|Fly"] = 62.32, ["Neon|Ride"] = 39.68, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 126.35, ["Mega|Fly"] = 349.75, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 215.25}},
    ["rbxassetid://132388343771587"] = {name = "Kelp Captain", prices = {["default"] = 53.82, ["Ride"] = 52.5, ["Fly|Ride"] = 46.98, ["Neon"] = 1409.35, ["Neon|Ride"] = 775.46, ["Neon|Fly|Ride"] = 282.13, ["Mega|Ride"] = 1409.52, ["Mega|Fly|Ride"] = 939.09}},
    ["rbxassetid://15148532648"] = {name = "Werewolf", prices = {["default"] = 563.19, ["Fly"] = 899.07, ["Ride"] = 576.18, ["Fly|Ride"] = 613.17, ["Neon"] = 2505.42, ["Neon|Ride"] = 1771.88, ["Neon|Fly|Ride"] = 1663.67, ["Mega|Fly|Ride"] = 5250}},
    ["rbxassetid://86323568215409"] = {name = "Tortoiseshell Guinea Pig", prices = {["default"] = 552.43, ["Ride"] = 587.62, ["Fly|Ride"] = 656.25, ["Neon"] = 281585.38, ["Neon|Ride"] = 4068.75, ["Neon|Fly|Ride"] = 2625, ["Mega|Fly|Ride"] = 8719.35}},
    ["rbxassetid://5973019152"] = {name = "Robo Dog", prices = {["default"] = 21, ["Fly"] = 42.27, ["Ride"] = 23.63, ["Fly|Ride"] = 54.95, ["Neon"] = 211.31, ["Neon|Ride"] = 105.67, ["Neon|Fly|Ride"] = 132.57, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://7734928470"] = {name = "Halloween Golden Mummy Cat", prices = {["default"] = 10.5, ["Ride"] = 22.32, ["Fly|Ride"] = 79.25, ["Neon"] = 141.9, ["Neon|Ride"] = 78.2, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 1688.46, ["Mega|Ride"] = 439.78, ["Mega|Fly|Ride"] = 479.66}},
    ["rbxassetid://137429532189183"] = {name = "Fire Stallion", prices = {["default"] = 5.15, ["Ride"] = 21, ["Fly|Ride"] = 99.32, ["Neon"] = 19.59, ["Neon|Fly"] = 313.49, ["Neon|Ride"] = 42.27, ["Neon|Fly|Ride"] = 141.6, ["Mega"] = 135.27, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 282.1}},
    ["rbxassetid://7215324578"] = {name = "Axolotl", prices = {["default"] = 32.19, ["Fly"] = 45.92, ["Ride"] = 43.32, ["Fly|Ride"] = 91.88, ["Neon|Ride"] = 170.63, ["Neon|Fly|Ride"] = 252, ["Mega|Fly|Ride"] = 742.81}},
    ["rbxassetid://111805565268081"] = {name = "Black Widow", prices = {["default"] = 39.38, ["Ride"] = 91.88, ["Fly|Ride"] = 211.31, ["Neon"] = 335.97, ["Neon|Ride"] = 345.49, ["Neon|Fly|Ride"] = 656.25, ["Mega"] = 1236.23, ["Mega|Ride"] = 1550.05, ["Mega|Fly|Ride"] = 1359.69}},
    ["rbxassetid://103653773461193"] = {name = "Sunglider", prices = {["default"] = 18.27, ["Fly"] = 57.14, ["Ride"] = 31.71, ["Fly|Ride"] = 70.04, ["Neon"] = 117.28, ["Neon|Ride"] = 93.13, ["Neon|Fly|Ride"] = 160.13, ["Mega|Ride"] = 406.88, ["Mega|Fly|Ride"] = 518.55}},
    ["rbxassetid://6498256069"] = {name = "Shark", prices = {["default"] = 34.13, ["Fly"] = 99.31, ["Ride"] = 41.91, ["Fly|Ride"] = 87.33, ["Neon"] = 350.77, ["Neon|Ride"] = 211.31, ["Neon|Fly|Ride"] = 210.04, ["Mega"] = 2100, ["Mega|Ride"] = 1221.06, ["Mega|Fly|Ride"] = 1181.15}},
    ["rbxassetid://8663440945"] = {name = "Lunar Gold Tiger", prices = {["default"] = 4.71, ["Fly"] = 31.49, ["Ride"] = 20.09, ["Fly|Ride"] = 48.61, ["Neon"] = 32.76, ["Neon|Ride"] = 42.27, ["Neon|Fly|Ride"] = 86.9, ["Mega"] = 177.19, ["Mega|Ride"] = 253.6, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://94185217299816"] = {name = "Dracula Parrot", prices = {["default"] = 6.35, ["Fly"] = 70.8, ["Ride"] = 30.19, ["Fly|Ride"] = 32398.8, ["Neon"] = 28.88, ["Neon|Fly"] = 157.34, ["Neon|Ride"] = 41.22, ["Neon|Fly|Ride"] = 150.05, ["Mega"] = 196.54, ["Mega|Fly"] = 479.72, ["Mega|Ride"] = 238.81, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://4621220431"] = {name = "Golden Rat", prices = {["default"] = 26.25, ["Fly"] = 60.38, ["Ride"] = 63.4, ["Fly|Ride"] = 91.88, ["Neon"] = 420.49, ["Neon|Fly"] = 281.79, ["Neon|Ride"] = 234.84, ["Neon|Fly|Ride"] = 221.53, ["Mega|Fly|Ride"] = 918.64}},
    ["rbxassetid://11506045996"] = {name = "Strawberry Shortcake Bat Dragon", prices = {["default"] = 1890, ["Ride"] = 1798.13, ["Fly|Ride"] = 1863.75, ["Neon|Fly|Ride"] = 4200, ["Mega|Fly|Ride"] = 14962.5}},
    ["rbxassetid://11758583912"] = {name = "Winged Tiger", prices = {["default"] = 665.52, ["Fly"] = 666.58, ["Ride"] = 590.63, ["Fly|Ride"] = 574.05, ["Neon"] = 3131.18, ["Neon|Ride"] = 3099.7, ["Neon|Fly|Ride"] = 2362.5, ["Mega|Fly|Ride"] = 8738.08}},
    ["rbxassetid://101160794933271"] = {name = "Matcha Cat", prices = {["default"] = 240.83, ["Fly"] = 338.05, ["Ride"] = 288.75, ["Fly|Ride"] = 379.32, ["Neon"] = 1409.35, ["Neon|Ride"] = 1489.64, ["Neon|Fly|Ride"] = 1550.05, ["Mega|Fly|Ride"] = 6240.59}},
    ["rbxassetid://13892790514"] = {name = "Urban Egg", prices = {["default"] = 46.6}},
    ["rbxassetid://13104109574"] = {name = "Spinosaurus", prices = {["default"] = 32.82, ["Fly"] = 65.63, ["Ride"] = 63.41, ["Fly|Ride"] = 95.82, ["Neon"] = 338.08, ["Neon|Ride"] = 247.23, ["Neon|Fly|Ride"] = 316.99, ["Mega|Ride"] = 1550.05, ["Mega|Fly|Ride"] = 1254.75}},
    ["rbxassetid://4115248712"] = {name = "Shadow Dragon", prices = {["default"] = 33802.98, ["Fly"] = 23625, ["Ride"] = 34781.25, ["Fly|Ride"] = 16585.15, ["Neon|Fly|Ride"] = 38062.5, ["Mega|Fly|Ride"] = 89250}},
    ["rbxassetid://71457697470071"] = {name = "Arctic Dusk Dragon", prices = {["default"] = 300.57, ["Fly"] = 359.59, ["Ride"] = 308.44, ["Fly|Ride"] = 287.46, ["Neon"] = 986.75, ["Neon|Ride"] = 833.44, ["Neon|Fly|Ride"] = 853.13, ["Mega"] = 3287.44, ["Mega|Ride"] = 6574.86, ["Mega|Fly|Ride"] = 2624.99}},
    ["rbxassetid://8566683457"] = {name = "Giant Gold Scarab", prices = {["default"] = 226.79, ["Fly"] = 525, ["Ride"] = 249.38, ["Fly|Ride"] = 173.77, ["Neon|Fly|Ride"] = 1722.38, ["Mega|Fly|Ride"] = 4367.9}},
    ["rbxassetid://16116063171"] = {name = "Rainbow Dragon", prices = {["default"] = 118.13, ["Ride"] = 124.67, ["Fly|Ride"] = 183.75, ["Neon|Ride"] = 778.18, ["Neon|Fly|Ride"] = 633.97, ["Mega"] = 14088.71, ["Mega|Fly|Ride"] = 1559.36}},
    ["rbxassetid://9938967130"] = {name = "Black Chow-Chow", prices = {["default"] = 19.69, ["Ride"] = 32.82, ["Fly|Ride"] = 98.44, ["Neon"] = 105.67, ["Neon|Ride"] = 135.19, ["Neon|Fly|Ride"] = 282.13, ["Mega"] = 1968.75}},
    ["rbxassetid://116467943923352"] = {name = "Haetae", prices = {["default"] = 3937.5, ["Ride"] = 4462.5, ["Fly|Ride"] = 4473, ["Neon|Fly|Ride"] = 17626.88, ["Mega|Fly|Ride"] = 70431.75}},
    ["rbxassetid://6531232495"] = {name = "Peacock", prices = {["default"] = 22.32, ["Fly"] = 49.88, ["Ride"] = 32.82, ["Fly|Ride"] = 64.32, ["Neon"] = 333.94, ["Neon|Ride"] = 211.32, ["Neon|Fly|Ride"] = 170.63, ["Mega|Fly|Ride"] = 633.29}},
    ["rbxassetid://12557346746"] = {name = "Naga Dragon", prices = {["default"] = 44.62, ["Fly"] = 195.44, ["Ride"] = 49.81, ["Fly|Ride"] = 100.32, ["Neon"] = 234.82, ["Neon|Fly"] = 1409.35, ["Neon|Ride"] = 282.1, ["Neon|Fly|Ride"] = 288.75, ["Mega|Fly|Ride"] = 922.31}},
    ["rbxassetid://127697654557674"] = {name = "Candicorn", prices = {["default"] = 561.75, ["Ride"] = 590.63, ["Fly|Ride"] = 702.86, ["Neon"] = 1597.25, ["Neon|Ride"] = 1458.19, ["Neon|Fly|Ride"] = 1378.13, ["Mega"] = 4462.5, ["Mega|Fly|Ride"] = 4329.94}},
    ["rbxassetid://4281674580"] = {name = "King Bee", prices = {["default"] = 18.38, ["Fly"] = 24.57, ["Ride"] = 24.94, ["Fly|Ride"] = 49.67, ["Neon"] = 98.44, ["Neon|Ride"] = 107.61, ["Neon|Fly|Ride"] = 125.99, ["Mega|Fly|Ride"] = 485.63}},
    ["rbxassetid://17822543288"] = {name = "Blue Betta Fish", prices = {["default"] = 15.96, ["Ride"] = 65.63, ["Fly|Ride"] = 469.63, ["Neon"] = 45.94, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 141.6}},
    ["rbxassetid://102300026415493"] = {name = "Moose Calf", prices = {["default"] = 93.92, ["Ride"] = 124.69, ["Fly|Ride"] = 159.54, ["Neon"] = 746.7, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 741.76, ["Mega|Fly|Ride"] = 2193.18}},
    ["rbxassetid://78419574214060"] = {name = "Christmas Spirit", prices = {["default"] = 26.25, ["Ride"] = 97.13, ["Fly|Ride"] = 155, ["Neon"] = 85.32, ["Neon|Ride"] = 132.57, ["Neon|Fly|Ride"] = 253.13, ["Mega"] = 261.19, ["Mega|Fly"] = 708.75, ["Mega|Ride"] = 326.71, ["Mega|Fly|Ride"] = 383.44}},
    ["rbxassetid://130642623661179"] = {name = "Cryptid", prices = {["default"] = 3189.38, ["Ride"] = 3281.25, ["Fly|Ride"] = 3215.63, ["Neon"] = 13125, ["Neon|Ride"] = 17960.01, ["Neon|Fly|Ride"] = 8491.88, ["Mega"] = 63395.93, ["Mega|Fly|Ride"] = 34434.82}},
    ["rbxassetid://101130894252942"] = {name = "Peach Owl", prices = {["default"] = 40.69, ["Fly"] = 115.5, ["Ride"] = 141.58, ["Fly|Ride"] = 105.52, ["Neon"] = 168, ["Neon|Ride"] = 197.6, ["Neon|Fly|Ride"] = 365.6, ["Mega|Fly|Ride"] = 892.5}},
    ["rbxassetid://4440866649"] = {name = "Owl", prices = {["default"] = 5906.25, ["Ride"] = 8453.1, ["Fly|Ride"] = 6024.38, ["Neon|Fly|Ride"] = 17062.5, ["Mega|Fly|Ride"] = 60571.71}},
    ["rbxassetid://6836687169"] = {name = "Golden Griffin", prices = {["default"] = 3.68, ["Fly"] = 21, ["Ride"] = 21.14, ["Fly|Ride"] = 30.19, ["Neon"] = 23.25, ["Neon|Fly"] = 91.8, ["Neon|Ride"] = 39.93, ["Neon|Fly|Ride"] = 76.13, ["Mega"] = 203.44, ["Mega|Fly|Ride"] = 311.68}},
    ["rbxassetid://76198828333546"] = {name = "Hippogriff", prices = {["default"] = 28.54, ["Fly"] = 35.44, ["Ride"] = 33.63, ["Fly|Ride"] = 52.84, ["Neon"] = 201.8, ["Neon|Ride"] = 559.37, ["Neon|Fly|Ride"] = 210.29, ["Mega|Fly|Ride"] = 927.94}},
    ["rbxassetid://112567270488274"] = {name = "Crystal Egg", prices = {["default"] = 3.21}},
    ["rbxassetid://10695038557"] = {name = "Maneki-Neko", prices = {["default"] = 15.75, ["Ride"] = 32.82, ["Fly|Ride"] = 126.79, ["Neon"] = 113.07, ["Neon|Ride"] = 127.24, ["Neon|Fly|Ride"] = 233.66, ["Mega"] = 1050, ["Mega|Ride"] = 984.76, ["Mega|Fly|Ride"] = 861.62}},
    ["rbxassetid://16911441596"] = {name = "Royal Capuchin Monkey", prices = {["default"] = 44.39, ["Fly"] = 92.97, ["Ride"] = 45.94, ["Fly|Ride"] = 141.58, ["Neon"] = 182.43, ["Neon|Ride"] = 154.09, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 840, ["Mega|Ride"] = 939.27, ["Mega|Fly|Ride"] = 931.88}},
    ["rbxassetid://6963387165"] = {name = "Cobra", prices = {["default"] = 16.91, ["Fly"] = 27.48, ["Ride"] = 21.15, ["Fly|Ride"] = 44.39, ["Neon"] = 141.61, ["Neon|Ride"] = 157.34, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 1128.47, ["Mega|Ride"] = 585.87, ["Mega|Fly|Ride"] = 674.98}},
    ["rbxassetid://3409444171"] = {name = "Safari Egg", prices = {["default"] = 7306.69}},
    ["rbxassetid://3743740864"] = {name = "Jungle Egg", prices = {["default"] = 3018.75}},
    ["rbxassetid://10321884333"] = {name = "Japan Egg", prices = {["default"] = 26.25}},
    ["rbxassetid://11109117895"] = {name = "Diamond Amazon", prices = {["default"] = 295.79, ["Fly"] = 352.88, ["Ride"] = 324.36, ["Fly|Ride"] = 311.68}},
    ["rbxassetid://102144672439627"] = {name = "Berry Cool Cube", prices = {["default"] = 21.14, ["Fly"] = 133.13, ["Ride"] = 65.63, ["Fly|Ride"] = 105, ["Neon"] = 234.7, ["Neon|Ride"] = 140.9, ["Neon|Fly|Ride"] = 454.38, ["Mega|Ride"] = 939.27, ["Mega|Fly|Ride"] = 793.43}},
    ["rbxassetid://17183502626"] = {name = "Garden Egg", prices = {["default"] = 10.58}},
    ["rbxassetid://16722909609"] = {name = "Striped Eggy", prices = {["default"] = 9.19, ["Neon|Ride"] = 84.53, ["Mega|Fly|Ride"] = 465.94}},
    ["rbxassetid://4440866155"] = {name = "Farm Egg", prices = {["default"] = 2468.19}},
    ["rbxassetid://88361277330582"] = {name = "Naughty Mistletroll", prices = {["default"] = 211.29, ["Ride"] = 229.69, ["Fly|Ride"] = 420.49, ["Neon"] = 918.75, ["Neon|Ride"] = 845.19, ["Mega|Fly|Ride"] = 2505}},
    ["rbxassetid://12778919221"] = {name = "Yule Log Dog", prices = {["default"] = 158.47, ["Ride"] = 183.75, ["Fly|Ride"] = 352.88, ["Neon"] = 845.19, ["Neon|Ride"] = 704.68, ["Neon|Fly|Ride"] = 950.95, ["Mega"] = 3433.96, ["Mega|Fly|Ride"] = 3380.72}},
    ["rbxassetid://13104112588"] = {name = "Owlbear", prices = {["default"] = 177.18, ["Ride"] = 180.68, ["Fly|Ride"] = 196.88, ["Neon"] = 799.32, ["Neon|Ride"] = 840, ["Neon|Fly|Ride"] = 855.8, ["Mega"] = 4649.06, ["Mega|Fly|Ride"] = 2915.88}},
    ["rbxassetid://11192035130"] = {name = "Undead Jousting Horse", prices = {["default"] = 1115.63, ["Fly"] = 2535.54, ["Ride"] = 1076.25, ["Fly|Ride"] = 1181.25, ["Neon"] = 5353.15, ["Neon|Ride"] = 5635.53, ["Neon|Fly|Ride"] = 4593.75, ["Mega|Fly|Ride"] = 20071.91}},
    ["rbxassetid://106575933009346"] = {name = "Fairytale Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://96044273915258"] = {name = "Endangered Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://129993159377616"] = {name = "Peahen", prices = {["default"] = 17.37, ["Fly"] = 102.15, ["Ride"] = 39.38, ["Fly|Ride"] = 86.63, ["Neon"] = 141.58, ["Neon|Ride"] = 295.88, ["Neon|Fly|Ride"] = 431.11, ["Mega"] = 939.27, ["Mega|Fly|Ride"] = 903.31}},
    ["rbxassetid://12732812236"] = {name = "Tio De Nadal", prices = {["default"] = 654.94, ["Fly"] = 2100, ["Ride"] = 759.84, ["Fly|Ride"] = 845.19}},
    ["rbxassetid://13936755787"] = {name = "Wrapped Doll", prices = {["default"] = 91.88}},
    ["rbxassetid://136441478335419"] = {name = "Emberlight", prices = {["default"] = 14.44, ["Fly"] = 393.75, ["Ride"] = 48.57, ["Fly|Ride"] = 98.44, ["Neon"] = 89.25, ["Neon|Ride"] = 105.67, ["Neon|Fly|Ride"] = 181.75, ["Mega"] = 363.57, ["Mega|Ride"] = 446.25, ["Mega|Fly|Ride"] = 633.9}},
    ["rbxassetid://17120184484"] = {name = "Rosy Maple Moth", prices = {["default"] = 10.58, ["Fly"] = 32.82, ["Ride"] = 32.76, ["Fly|Ride"] = 94.5, ["Neon"] = 52.5, ["Neon|Ride"] = 83.61, ["Neon|Fly|Ride"] = 167.24, ["Mega"] = 918.75, ["Mega|Ride"] = 408.92, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://15932251755"] = {name = "Royal Desert Egg", prices = {["default"] = 78.75}},
    ["rbxassetid://8143039289"] = {name = "Golden Walrus", prices = {["default"] = 49.66, ["Ride"] = 28.87, ["Fly|Ride"] = 65.54, ["Neon"] = 177.19, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 548.31, ["Mega"] = 818.88, ["Mega|Fly|Ride"] = 704.68}},
    ["rbxassetid://12187391973"] = {name = "Firefly", prices = {["Fly"] = 48.61, ["Ride"] = 46.5, ["Fly|Ride"] = 61.69, ["Neon"] = 238.79, ["Neon|Fly"] = 244.22, ["Neon|Ride"] = 141.58, ["Neon|Fly|Ride"] = 196.88, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://3743647944"] = {name = "Parrot", prices = {["default"] = 5229, ["Fly"] = 11269.39, ["Ride"] = 6269.1, ["Fly|Ride"] = 4987.5, ["Neon|Fly|Ride"] = 10500, ["Mega|Fly|Ride"] = 37758}},
    ["rbxassetid://128454622445076"] = {name = "Dimension Drifter", prices = {["default"] = 11.82, ["Fly"] = 80.07, ["Ride"] = 32.82, ["Fly|Ride"] = 99.32, ["Neon"] = 79.48, ["Neon|Ride"] = 141.58, ["Neon|Fly|Ride"] = 141.6, ["Mega"] = 526.01, ["Mega|Ride"] = 422.66, ["Mega|Fly|Ride"] = 395.14}},
    ["rbxassetid://15931761708"] = {name = "Desert Egg", prices = {["default"] = 31.7}},
    ["rbxassetid://17747001377"] = {name = "Majestic Pony", prices = {["default"] = 112.88, ["Fly"] = 374, ["Ride"] = 196.88, ["Neon"] = 418.69, ["Neon|Ride"] = 483, ["Neon|Fly|Ride"] = 696.94, ["Mega|Ride"] = 4226.4, ["Mega|Fly|Ride"] = 1973.5}},
    ["rbxassetid://94487786469241"] = {name = "Vanilla Penguin", prices = {["default"] = 97.13, ["Ride"] = 105, ["Fly|Ride"] = 197.58, ["Neon"] = 327.6, ["Neon|Ride"] = 320.25, ["Neon|Fly|Ride"] = 511.88, ["Mega|Ride"] = 1576.46, ["Mega|Fly|Ride"] = 1584.72}},
    ["rbxassetid://6498256211"] = {name = "Octopus", prices = {["default"] = 21, ["Fly"] = 70.68, ["Ride"] = 37, ["Fly|Ride"] = 70.88, ["Neon"] = 183.75, ["Neon|Ride"] = 126, ["Neon|Fly|Ride"] = 164.07, ["Mega|Fly|Ride"] = 656.22}},
    ["rbxassetid://110654583245787"] = {name = "Sea Turtle", prices = {["default"] = 6.57, ["Fly"] = 49.55, ["Ride"] = 33.69, ["Fly|Ride"] = 78.75, ["Neon"] = 25.26, ["Neon|Fly"] = 183.84, ["Neon|Ride"] = 49.65, ["Neon|Fly|Ride"] = 152.13, ["Mega"] = 133.12, ["Mega|Fly"] = 7034.11, ["Mega|Ride"] = 158.08, ["Mega|Fly|Ride"] = 244.13}},
    ["rbxassetid://8596147681"] = {name = "Squid", prices = {["default"] = 10.42, ["Fly"] = 52.5, ["Ride"] = 42, ["Fly|Ride"] = 90.57, ["Neon"] = 91.92, ["Neon|Ride"] = 112.88, ["Neon|Fly|Ride"] = 211.34, ["Mega"] = 704.76, ["Mega|Ride"] = 517.78, ["Mega|Fly|Ride"] = 538.13}},
    ["rbxassetid://9226723356"] = {name = "Winged Horse", prices = {["default"] = 23.57, ["Fly"] = 35.94, ["Ride"] = 31.5, ["Fly|Ride"] = 52.84, ["Neon"] = 208.69, ["Neon|Ride"] = 248.29, ["Neon|Fly|Ride"] = 126, ["Mega|Fly|Ride"] = 655.97}},
    ["rbxassetid://4733386633"] = {name = "Aussie Egg", prices = {["default"] = 223.13}},
    ["rbxassetid://121951206021245"] = {name = "Kiwi Kiwi", prices = {["default"] = 19.95, ["Ride"] = 107.57, ["Neon"] = 157.5, ["Neon|Ride"] = 422.66, ["Mega"] = 967.85, ["Mega|Ride"] = 918.75, ["Mega|Fly|Ride"] = 1407.23}},
    ["rbxassetid://9602676771"] = {name = "Diamond Albatross", prices = {["default"] = 196.88, ["Ride"] = 443.63, ["Fly|Ride"] = 362.38, ["Neon|Ride"] = 820.32, ["Neon|Fly|Ride"] = 742.81}},
    ["rbxassetid://79965389436178"] = {name = "Sushi Penguin", prices = {["default"] = 52.49, ["Fly"] = 211.99, ["Ride"] = 97.67, ["Neon"] = 309.75, ["Neon|Ride"] = 470.67, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 1183.88, ["Mega|Ride"] = 1043.93, ["Mega|Fly|Ride"] = 995.26}},
    ["rbxassetid://126930507653265"] = {name = "Grim Dragon", prices = {["default"] = 810.04, ["Fly"] = 780.94, ["Ride"] = 721.88, ["Fly|Ride"] = 735.44, ["Neon|Ride"] = 2231.25, ["Neon|Fly|Ride"] = 2207.12, ["Mega|Fly|Ride"] = 6483.75}},
    ["rbxassetid://87328715505907"] = {name = "Silverback Gorilla", prices = {["default"] = 320.25, ["Ride"] = 330.75, ["Fly|Ride"] = 384.58, ["Neon"] = 1549.86, ["Neon|Ride"] = 2035.84, ["Neon|Fly|Ride"] = 1396.5, ["Mega"] = 6732.2, ["Mega|Fly|Ride"] = 5134.42}},
    ["rbxassetid://12733311267"] = {name = "Fool Egg", prices = {["default"] = 115.5}},
    ["rbxassetid://139472202653768"] = {name = "Admin Abuse Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://8938702589"] = {name = "Hawk", prices = {["default"] = 7.88, ["Fly"] = 35.44, ["Ride"] = 24.81, ["Fly|Ride"] = 56.44, ["Neon"] = 77.95, ["Neon|Ride"] = 97.5, ["Neon|Fly|Ride"] = 127.32, ["Mega"] = 282.13, ["Mega|Fly|Ride"] = 452.82}},
    ["rbxassetid://8938703243"] = {name = "Fallow Deer", prices = {["default"] = 301.4, ["Fly"] = 458.67, ["Ride"] = 347.27, ["Fly|Ride"] = 420.71, ["Neon"] = 2800.72, ["Neon|Ride"] = 1032.03, ["Neon|Fly|Ride"] = 1047.38, ["Mega|Fly|Ride"] = 3380.72}},
    ["rbxassetid://4822753124"] = {name = "Diamond Egg", prices = {["default"] = 17.99}},
    ["rbxassetid://114823420678686"] = {name = "Dragonfruit Fox", prices = {["default"] = 114.77, ["Fly"] = 590.63, ["Ride"] = 157.5, ["Fly|Ride"] = 246.11, ["Neon"] = 459.38, ["Neon|Ride"] = 588.4, ["Neon|Fly|Ride"] = 624.75, ["Mega"] = 9439.66, ["Mega|Ride"] = 2035.87, ["Mega|Fly|Ride"] = 1771.88}},
    ["rbxassetid://102844319137806"] = {name = "Pineapple Owl", prices = {["default"] = 147, ["Ride"] = 165.38, ["Fly|Ride"] = 141.58, ["Neon|Ride"] = 887.56, ["Neon|Fly|Ride"] = 1014.35}},
    ["rbxassetid://82296650763619"] = {name = "Angus Bull", prices = {["default"] = 6.57, ["Ride"] = 45.94, ["Fly|Ride"] = 204.98, ["Neon"] = 52.48, ["Neon|Ride"] = 69.75, ["Neon|Fly|Ride"] = 169.08, ["Mega"] = 222.7, ["Mega|Ride"] = 282.13, ["Mega|Fly|Ride"] = 324.36}},
    ["rbxassetid://12917347755"] = {name = "Sunrise Duckling", prices = {["default"] = 27.48, ["Fly"] = 52.5, ["Ride"] = 39.38, ["Fly|Ride"] = 76.13, ["Neon"] = 138.42, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 247.26, ["Mega|Ride"] = 696.31, ["Mega|Fly|Ride"] = 577.5}},
    ["rbxassetid://139217275750567"] = {name = "Winter Buck", prices = {["default"] = 23.25, ["Fly"] = 131.25, ["Ride"] = 44.39, ["Fly|Ride"] = 127.32, ["Neon"] = 156.19, ["Neon|Ride"] = 127.32, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 498.74, ["Mega|Ride"] = 469.64, ["Mega|Fly|Ride"] = 591.64}},
    ["rbxassetid://114331718573822"] = {name = "Mochi Meow", prices = {["default"] = 6.35, ["Fly"] = 92.98, ["Ride"] = 52.5, ["Fly|Ride"] = 140.9, ["Neon"] = 15.86, ["Neon|Ride"] = 63.41, ["Neon|Fly|Ride"] = 148.72, ["Mega"] = 111.55, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 244.13}},
    ["rbxassetid://112560568221286"] = {name = "Strawberry Penguin", prices = {["default"] = 305.9, ["Fly"] = 918.75, ["Ride"] = 308.44, ["Fly|Ride"] = 741.57, ["Neon|Ride"] = 1214.07, ["Neon|Fly|Ride"] = 1338.73, ["Mega|Fly|Ride"] = 4431.91}},
    ["rbxassetid://116818749091454"] = {name = "Dango Penguins", prices = {["default"] = 87.94, ["Fly"] = 141.58, ["Ride"] = 136.5, ["Fly|Ride"] = 215.3, ["Neon"] = 456.73, ["Neon|Ride"] = 459.37, ["Neon|Fly|Ride"] = 553.56, ["Mega"] = 1792.88, ["Mega|Ride"] = 1928.07, ["Mega|Fly|Ride"] = 1575}},
    ["rbxassetid://12480100169"] = {name = "Tree Kangaroo", prices = {["default"] = 78.67, ["Fly"] = 126.77, ["Ride"] = 91.91, ["Fly|Ride"] = 112.01, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 460.69, ["Mega|Fly|Ride"] = 1515.94}},
    ["rbxassetid://75106733244906"] = {name = "Golden Hummingbird", prices = {["default"] = 20.09, ["Ride"] = 68.25, ["Fly|Ride"] = 282.1, ["Neon|Ride"] = 596.45, ["Neon|Fly|Ride"] = 492.39, ["Mega|Ride"] = 420, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://76354526914534"] = {name = "Frostclaw", prices = {["default"] = 24.94, ["Fly"] = 75.62, ["Ride"] = 54.95, ["Fly|Ride"] = 95.1, ["Neon"] = 78.2, ["Neon|Ride"] = 117.28, ["Neon|Fly|Ride"] = 181.73, ["Mega"] = 459.08, ["Mega|Fly"] = 525, ["Mega|Ride"] = 538.89, ["Mega|Fly|Ride"] = 444.94}},
    ["rbxassetid://121712578077668"] = {name = "Blue Whale", prices = {["default"] = 3.94, ["Fly"] = 27.57, ["Ride"] = 25.44, ["Fly|Ride"] = 42.27, ["Neon"] = 17.07, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 101.07, ["Mega|Ride"] = 125.88, ["Mega|Fly|Ride"] = 181.13}},
    ["rbxassetid://76035105070441"] = {name = "Fairy Bat Dragon", prices = {["default"] = 918.75, ["Fly"] = 1155.79, ["Ride"] = 912.19, ["Fly|Ride"] = 988.31, ["Neon"] = 5479.26, ["Neon|Ride"] = 2625, ["Neon|Fly|Ride"] = 2428.13, ["Mega|Fly|Ride"] = 7809.38}},
    ["rbxassetid://105346917979221"] = {name = "Aurora Fox", prices = {["default"] = 360.72, ["Ride"] = 384.21, ["Fly|Ride"] = 438.38, ["Neon|Ride"] = 1566.23, ["Neon|Fly|Ride"] = 1312.5, ["Mega"] = 10566, ["Mega|Fly|Ride"] = 5302.44}},
    ["rbxassetid://120475294381736"] = {name = "Glormy Hound", prices = {["default"] = 85.32, ["Ride"] = 112.88, ["Fly|Ride"] = 194.25, ["Neon"] = 386.69, ["Neon|Ride"] = 401.48, ["Neon|Fly|Ride"] = 413.15, ["Mega|Fly|Ride"] = 1617.47}},
    ["rbxassetid://15570696642"] = {name = "Glacier Kitsune", prices = {["default"] = 242.82, ["Ride"] = 260.8, ["Fly|Ride"] = 286.39, ["Neon|Ride"] = 1064.89, ["Neon|Fly|Ride"] = 1047.38, ["Mega"] = 10566, ["Mega|Fly|Ride"] = 3937.5}},
    ["rbxassetid://16548792521"] = {name = "Golden Hamster", prices = {["default"] = 23.63, ["Fly"] = 52.5, ["Ride"] = 38.74, ["Fly|Ride"] = 75.26, ["Neon"] = 157.49, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 230.35, ["Mega|Ride"] = 783.13, ["Mega|Fly|Ride"] = 618.87}},
    ["rbxassetid://12935498875"] = {name = "Field Mouse", prices = {["default"] = 232.91, ["Fly|Ride"] = 448.88, ["Neon"] = 1266.41, ["Neon|Fly|Ride"] = 1951.56, ["Mega"] = 5250, ["Mega|Fly|Ride"] = 6338.84}},
    ["rbxassetid://16548793509"] = {name = "Diamond Hamster", prices = {["default"] = 141.57, ["Fly"] = 126, ["Ride"] = 141.58, ["Fly|Ride"] = 156.37, ["Neon"] = 422.6, ["Neon|Ride"] = 487.26, ["Neon|Fly|Ride"] = 633.89, ["Mega|Fly|Ride"] = 1397.82}},
    ["rbxassetid://78823655016197"] = {name = "Jekyll Hydra", prices = {["default"] = 1307.25, ["Ride"] = 1181.25, ["Fly|Ride"] = 1312.5, ["Neon|Fly|Ride"] = 4331.25, ["Mega"] = 50716.75, ["Mega|Fly|Ride"] = 24651.71}},
    ["rbxassetid://96735424372947"] = {name = "Glormy Dolphin", prices = {["default"] = 14.44, ["Fly"] = 45.94, ["Ride"] = 39.38, ["Fly|Ride"] = 86.63, ["Neon"] = 50.74, ["Neon|Fly"] = 157.5, ["Neon|Ride"] = 82.69, ["Neon|Fly|Ride"] = 157.35, ["Mega"] = 223.13, ["Mega|Ride"] = 275.63, ["Mega|Fly|Ride"] = 351.75}},
    ["rbxassetid://16898331554"] = {name = "Princess Capuchin Monkey", prices = {["default"] = 69.74, ["Ride"] = 84, ["Fly|Ride"] = 315, ["Neon"] = 315, ["Neon|Ride"] = 316.32, ["Neon|Fly|Ride"] = 334.69, ["Mega|Fly|Ride"] = 1126.21}},
    ["rbxassetid://4315743450"] = {name = "Queen Bee", prices = {["default"] = 70.8, ["Fly"] = 84, ["Ride"] = 78.75, ["Fly|Ride"] = 83.7, ["Neon|Ride"] = 410.82, ["Neon|Fly|Ride"] = 378, ["Mega|Fly|Ride"] = 1575}},
    ["rbxassetid://5067924789"] = {name = "Monkey King", prices = {["default"] = 2816.23, ["Ride"] = 1049.99, ["Fly|Ride"] = 945.21, ["Neon|Fly|Ride"] = 4199.99, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://10284283561"] = {name = "Black-Chested Pheasant", prices = {["default"] = 525, ["Ride"] = 446.25, ["Fly|Ride"] = 525, ["Neon|Fly|Ride"] = 1984.31, ["Mega|Fly|Ride"] = 14086.17}},
    ["rbxassetid://15504845135"] = {name = "Candy Hare", prices = {["default"] = 111.93, ["Fly"] = 313.45, ["Ride"] = 137.81, ["Fly|Ride"] = 234.94, ["Neon"] = 465.92, ["Neon|Ride"] = 456.75, ["Neon|Fly|Ride"] = 691.03, ["Mega"] = 4015.09, ["Mega|Ride"] = 1968.75, ["Mega|Fly|Ride"] = 1986.17}},
    ["rbxassetid://11758575657"] = {name = "Lunar Moon Bear", prices = {["default"] = 13.13, ["Fly"] = 39.38, ["Ride"] = 28.49, ["Fly|Ride"] = 79.52, ["Neon"] = 73.97, ["Neon|Ride"] = 103.57, ["Neon|Fly|Ride"] = 233.63, ["Mega"] = 761.25, ["Mega|Ride"] = 508.59, ["Mega|Fly|Ride"] = 986.75}},
    ["rbxassetid://10318105392"] = {name = "Green Butterfly", prices = {["default"] = 49.66, ["Fly"] = 70.8, ["Ride"] = 48.57, ["Fly|Ride"] = 94.4, ["Neon"] = 251.27, ["Neon|Fly"] = 408.86, ["Neon|Ride"] = 210.79, ["Neon|Fly|Ride"] = 209.99, ["Mega"] = 1832.16, ["Mega|Fly|Ride"] = 1049.99}},
    ["rbxassetid://84813815094145"] = {name = "Mermicorn", prices = {["default"] = 816.74, ["Ride"] = 826.88, ["Fly|Ride"] = 871.08, ["Neon|Ride"] = 2828.44, ["Neon|Fly|Ride"] = 3319.14, ["Mega|Fly|Ride"] = 12148.38}},
    ["rbxassetid://4507163112"] = {name = "Christmas Egg", prices = {["default"] = 774.38}},
    ["rbxassetid://14689005829"] = {name = "Blazing Lion", prices = {["default"] = 4823.44, ["Ride"] = 4068.75, ["Fly|Ride"] = 4085.82, ["Neon|Ride"] = 30279.52, ["Neon|Fly|Ride"] = 21659.23, ["Mega|Fly|Ride"] = 90152.89}},
    ["rbxassetid://123647431892215"] = {name = "Hero Gibbon", prices = {["default"] = 156.36, ["Fly"] = 169.62, ["Ride"] = 393.75, ["Fly|Ride"] = 422.6, ["Neon"] = 918.75, ["Neon|Ride"] = 1252.74, ["Neon|Fly|Ride"] = 918.75, ["Mega"] = 5916.96, ["Mega|Fly|Ride"] = 5635.23}},
    ["rbxassetid://106457467498193"] = {name = "Scorching Kaijunior", prices = {["default"] = 70.56, ["Fly"] = 282.06, ["Ride"] = 77.44, ["Fly|Ride"] = 336, ["Neon"] = 441, ["Neon|Ride"] = 564.17, ["Neon|Fly|Ride"] = 986.88, ["Mega|Fly|Ride"] = 2804.94}},
    ["rbxassetid://10926054030"] = {name = "Chimera", prices = {["default"] = 15.85, ["Fly"] = 126.79, ["Ride"] = 28.54, ["Fly|Ride"] = 91.88, ["Neon"] = 141.58, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 177.86, ["Mega"] = 420.55, ["Mega|Ride"] = 528.31, ["Mega|Fly|Ride"] = 522.97}},
    ["rbxassetid://9490242683"] = {name = "Golden King Penguin", prices = {["default"] = 27.48, ["Fly"] = 30.27, ["Ride"] = 22.32, ["Fly|Ride"] = 45.94, ["Neon"] = 105, ["Neon|Fly"] = 282.1, ["Neon|Ride"] = 313.49, ["Neon|Fly|Ride"] = 177.18, ["Mega"] = 1312.5, ["Mega|Fly|Ride"] = 790.26}},
    ["rbxassetid://17119623510"] = {name = "Mushroom Friend", prices = {["default"] = 15.74, ["Ride"] = 45.94, ["Fly|Ride"] = 90.57, ["Neon"] = 139.47, ["Neon|Ride"] = 98.44, ["Neon|Fly|Ride"] = 313.5, ["Mega|Ride"] = 859.69, ["Mega|Fly|Ride"] = 845.19}},
    ["rbxassetid://17174656536"] = {name = "Golden Tortoise Beetle", prices = {["default"] = 6.57, ["Fly"] = 57.06, ["Ride"] = 22.32, ["Fly|Ride"] = 63.4, ["Neon"] = 28.19, ["Neon|Fly"] = 348.65, ["Neon|Ride"] = 54.02, ["Neon|Fly|Ride"] = 134.65, ["Mega|Ride"] = 313.5, ["Mega|Fly|Ride"] = 357}},
    ["rbxassetid://84310117840681"] = {name = "Super Saru", prices = {["default"] = 31.5, ["Ride"] = 70.8, ["Fly|Ride"] = 167.99, ["Neon"] = 197.58, ["Neon|Fly"] = 845.19, ["Neon|Ride"] = 180.68, ["Neon|Fly|Ride"] = 232.32, ["Mega"] = 676.24, ["Mega|Ride"] = 720.9, ["Mega|Fly|Ride"] = 861.62}},
    ["rbxassetid://77177643028234"] = {name = "Phantom Dragon", prices = {["default"] = 276.94, ["Fly"] = 331.71, ["Ride"] = 284.12, ["Fly|Ride"] = 305.58, ["Neon"] = 866.32, ["Neon|Ride"] = 939.26, ["Neon|Fly|Ride"] = 688.29, ["Mega"] = 6562.5, ["Mega|Fly|Ride"] = 5315.63}},
    ["rbxassetid://6245080265"] = {name = "Metal Ox", prices = {["default"] = 3.93, ["Fly"] = 15.86, ["Ride"] = 15.86, ["Fly|Ride"] = 35.83, ["Neon"] = 21.14, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 303.27, ["Mega|Ride"] = 194.43, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://3181728194"] = {name = "Unicorn", prices = {["default"] = 42, ["Fly"] = 130.14, ["Ride"] = 73.5, ["Fly|Ride"] = 122.08, ["Neon"] = 166.16, ["Neon|Fly"] = 288.75, ["Neon|Ride"] = 170.63, ["Neon|Fly|Ride"] = 243.59, ["Mega"] = 563.05, ["Mega|Ride"] = 547.29, ["Mega|Fly|Ride"] = 616.88}},
    ["rbxassetid://4708551322"] = {name = "Turtle", prices = {["default"] = 754.69, ["Fly"] = 887.34, ["Ride"] = 750.5, ["Fly|Ride"] = 813.75, ["Neon|Ride"] = 1575, ["Neon|Fly|Ride"] = 1437.19, ["Mega|Fly|Ride"] = 4003.13}},
    ["rbxassetid://5721844281"] = {name = "T-Rex", prices = {["default"] = 35.23, ["Fly"] = 107.63, ["Ride"] = 39.38, ["Fly|Ride"] = 97.13, ["Neon"] = 158.09, ["Neon|Fly"] = 469.64, ["Neon|Ride"] = 127.32, ["Neon|Fly|Ride"] = 210, ["Mega"] = 1575, ["Mega|Ride"] = 1127.4, ["Mega|Fly|Ride"] = 654.93}},
    ["rbxassetid://16127039676"] = {name = "Midnight Dragon", prices = {["default"] = 239.8, ["Fly"] = 316.41, ["Ride"] = 237.57, ["Fly|Ride"] = 312.89, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 4606.23}},
    ["rbxassetid://7734925172"] = {name = "Halloween White Ghost Dragon", prices = {["default"] = 105, ["Fly"] = 175.88, ["Ride"] = 134.75, ["Fly|Ride"] = 170.63, ["Neon"] = 564.17, ["Neon|Ride"] = 626.97, ["Neon|Fly|Ride"] = 419.98, ["Mega"] = 2958.5, ["Mega|Fly|Ride"] = 2213.3}},
    ["rbxassetid://18508016126"] = {name = "Bush Elephant", prices = {["default"] = 576.73, ["Ride"] = 570.93, ["Fly|Ride"] = 682.5, ["Neon"] = 2520.75, ["Neon|Fly|Ride"] = 2348.17, ["Mega|Fly|Ride"] = 6561.19}},
    ["rbxassetid://78218981883168"] = {name = "Coconut Friend", prices = {["default"] = 26.25, ["Ride"] = 56.44, ["Fly|Ride"] = 156.37, ["Neon"] = 84, ["Neon|Fly"] = 281.79, ["Neon|Ride"] = 115.03, ["Neon|Fly|Ride"] = 270.05, ["Mega"] = 354.16, ["Mega|Ride"] = 380.63, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://4184878050"] = {name = "Evil Unicorn", prices = {["default"] = 3018.75, ["Fly"] = 3018.75, ["Ride"] = 3936.19, ["Fly|Ride"] = 3084.37, ["Neon|Fly|Ride"] = 6300, ["Mega|Fly|Ride"] = 23745.75}},
    ["rbxassetid://103896000727935"] = {name = "Aestus", prices = {["default"] = 105.66, ["Fly"] = 141.56, ["Ride"] = 105.99, ["Fly|Ride"] = 132.57, ["Neon"] = 398.02, ["Neon|Ride"] = 446.25, ["Neon|Fly|Ride"] = 404.25, ["Mega"] = 1901.89, ["Mega|Fly|Ride"] = 1690.37}},
    ["rbxassetid://9922229151"] = {name = "Dragonfly", prices = {["default"] = 3.29, ["Fly"] = 21, ["Ride"] = 22.23, ["Fly|Ride"] = 61.29, ["Neon"] = 19.69, ["Neon|Fly"] = 42.24, ["Neon|Ride"] = 31.71, ["Neon|Fly|Ride"] = 80.32, ["Mega"] = 129.06, ["Mega|Fly"] = 452.82, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://82820245821381"] = {name = "Temple Friend", prices = {["default"] = 3.41, ["Ride"] = 28.49, ["Fly|Ride"] = 157.34, ["Neon"] = 25.64, ["Neon|Fly"] = 157.5, ["Neon|Ride"] = 62.99, ["Neon|Fly|Ride"] = 211.34, ["Mega"] = 144.38, ["Mega|Ride"] = 199.5, ["Mega|Fly|Ride"] = 278.2}},
    ["rbxassetid://6404812861"] = {name = "Diamond Ladybug", prices = {["default"] = 45.4, ["Fly"] = 65.5, ["Ride"] = 38.06, ["Fly|Ride"] = 64.32, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 420.55, ["Mega|Fly|Ride"] = 1318.49}},
    ["rbxassetid://107535752953647"] = {name = "Strawberry Tortle", prices = {["default"] = 942.38, ["Ride"] = 1042.76, ["Fly|Ride"] = 1115.63, ["Neon"] = 5053.12, ["Mega|Fly|Ride"] = 27468.26}},
    ["rbxassetid://95844539868957"] = {name = "Amethyst Penguin", prices = {["default"] = 4930.56, ["Ride"] = 4930.98, ["Fly|Ride"] = 4644.26, ["Neon|Fly|Ride"] = 17062.5}},
    ["rbxassetid://6240249282"] = {name = "Guardian Lion", prices = {["default"] = 24.94, ["Fly"] = 35.94, ["Ride"] = 27.27, ["Fly|Ride"] = 57.06, ["Neon"] = 105, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 136.5, ["Mega"] = 2428.13, ["Mega|Fly|Ride"] = 655.03}},
    ["rbxassetid://11496077150"] = {name = "Ice Moth Dragon", prices = {["default"] = 19.69, ["Fly"] = 70.46, ["Ride"] = 40.16, ["Fly|Ride"] = 103.56, ["Neon"] = 105.67, ["Neon|Ride"] = 122.57, ["Neon|Fly|Ride"] = 166.73, ["Mega"] = 924.02, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 455.15}},
    ["rbxassetid://5862774166"] = {name = "Skele-Rex", prices = {["default"] = 45.55, ["Fly"] = 211.31, ["Ride"] = 49.88, ["Fly|Ride"] = 85.87, ["Neon|Ride"] = 313.49, ["Neon|Fly|Ride"] = 261.19, ["Mega|Ride"] = 1158.05, ["Mega|Fly|Ride"] = 868.88}},
    ["rbxassetid://11773429123"] = {name = "Nessie", prices = {["default"] = 217.88, ["Ride"] = 229.69, ["Fly|Ride"] = 192.83, ["Neon|Ride"] = 976.5, ["Neon|Fly|Ride"] = 945, ["Mega"] = 11115.03, ["Mega|Fly|Ride"] = 4043.13}},
    ["rbxassetid://121782270350526"] = {name = "Dark Choccybunny", prices = {["default"] = 4.71, ["Ride"] = 32.82, ["Fly|Ride"] = 105, ["Neon"] = 27.48, ["Neon|Fly"] = 70.95, ["Neon|Ride"] = 92.42, ["Neon|Fly|Ride"] = 244.22, ["Mega"] = 115.5, ["Mega|Ride"] = 198.19, ["Mega|Fly|Ride"] = 366.26}},
    ["rbxassetid://129591977577854"] = {name = "Ballet Swan", prices = {["default"] = 139.19, ["Fly"] = 267.7, ["Ride"] = 196.88, ["Fly|Ride"] = 278.1, ["Neon"] = 845.19, ["Neon|Ride"] = 744.19, ["Neon|Fly|Ride"] = 786.19, ["Mega|Fly|Ride"] = 3353.25}},
    ["rbxassetid://9669227320"] = {name = "Zodiac Minion Chick", prices = {["default"] = 3.56, ["Fly"] = 31.7, ["Ride"] = 18.94, ["Fly|Ride"] = 39.38, ["Neon"] = 15.75, ["Neon|Fly"] = 121.79, ["Neon|Ride"] = 32.76, ["Neon|Fly|Ride"] = 93.94, ["Mega"] = 469.64, ["Mega|Ride"] = 422.66, ["Mega|Fly|Ride"] = 739.54}},
    ["rbxassetid://13462536955"] = {name = "Caelum Cervi", prices = {["default"] = 282.06, ["Fly"] = 272.6, ["Ride"] = 245.44, ["Fly|Ride"] = 275.63, ["Neon|Ride"] = 1005.01, ["Neon|Fly|Ride"] = 1115.63, ["Mega"] = 10566, ["Mega|Ride"] = 5635.92, ["Mega|Fly|Ride"] = 7630.02}},
    ["rbxassetid://10137833794"] = {name = "Green-Chested Pheasant", prices = {["default"] = 17.62, ["Fly"] = 422.55, ["Ride"] = 31.69, ["Fly|Ride"] = 84.53, ["Neon"] = 70.8, ["Neon|Fly"] = 298.23, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 156.39, ["Mega"] = 465.97, ["Mega|Ride"] = 564.24, ["Mega|Fly|Ride"] = 469.55}},
    ["rbxassetid://16994954002"] = {name = "Brachiosaurus", prices = {["default"] = 3.15, ["Ride"] = 28.88, ["Neon"] = 15.75, ["Neon|Fly"] = 66.94, ["Neon|Ride"] = 28.88, ["Neon|Fly|Ride"] = 141.6, ["Mega"] = 89.25, ["Mega|Ride"] = 101.74, ["Mega|Fly|Ride"] = 211.87}},
    ["rbxassetid://121938982134212"] = {name = "Gecko Ducky", prices = {["default"] = 2.63, ["Neon"] = 3.93, ["Mega"] = 19.04, ["Mega|Ride"] = 155.7}},
    ["rbxassetid://17649624018"] = {name = "Kid Goat", prices = {["default"] = 2.63, ["Ride"] = 35.94, ["Fly|Ride"] = 141.94, ["Neon"] = 11.82, ["Neon|Ride"] = 85.32, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 68.25, ["Mega|Fly"] = 156544.8, ["Mega|Ride"] = 98.44, ["Mega|Fly|Ride"] = 181.88}},
    ["rbxassetid://4440867127"] = {name = "Chicken", prices = {["default"] = 86.64, ["Fly"] = 139.47, ["Ride"] = 105, ["Fly|Ride"] = 176.89, ["Neon"] = 262.5, ["Neon|Ride"] = 209.2, ["Neon|Fly|Ride"] = 334.99, ["Mega|Fly|Ride"] = 1240.32}},
    ["rbxassetid://5721844165"] = {name = "Tasmanian Tiger", prices = {["default"] = 2.1, ["Fly"] = 28.54, ["Ride"] = 18.38, ["Fly|Ride"] = 41.14, ["Neon"] = 5.07, ["Neon|Ride"] = 21.15, ["Neon|Fly|Ride"] = 113.07, ["Mega"] = 86.63, ["Mega|Ride"] = 98.34, ["Mega|Fly|Ride"] = 261.45}},
    ["rbxassetid://14146063876"] = {name = "Cockroach", prices = {["default"] = 10.5, ["Ride"] = 91.68, ["Neon"] = 210, ["Neon|Ride"] = 127.24, ["Mega"] = 417.32}},
    ["rbxassetid://135555287601448"] = {name = "Rubber Ducky", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 28.25, ["Neon|Fly|Ride"] = 278.25, ["Mega"] = 15.85, ["Mega|Ride"] = 45.99}},
    ["rbxassetid://9664487060"] = {name = "Ant", prices = {["default"] = 2.1, ["Fly"] = 21.11, ["Ride"] = 18, ["Neon"] = 2.1, ["Neon|Fly"] = 16.91, ["Neon|Ride"] = 16.88, ["Neon|Fly|Ride"] = 35.23, ["Mega"] = 21.15, ["Mega|Fly"] = 27.57, ["Mega|Ride"] = 22.32, ["Mega|Fly|Ride"] = 65.63}},
    ["rbxassetid://3293758505"] = {name = "Otter", prices = {["default"] = 2.1, ["Ride"] = 15.85, ["Fly|Ride"] = 48.51, ["Neon"] = 3.94, ["Neon|Fly"] = 32.82, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 40.7, ["Mega"] = 40.69, ["Mega|Ride"] = 39.38, ["Mega|Fly|Ride"] = 157.32}},
    ["rbxassetid://79698905581979"] = {name = "Ms. Muffet", prices = {["default"] = 2.1, ["Fly|Ride"] = 125.73, ["Neon"] = 2.1, ["Neon|Ride"] = 58.72, ["Mega"] = 23.63, ["Mega|Ride"] = 121.12}},
    ["rbxassetid://13620861015"] = {name = "Flying Fish", prices = {["default"] = 2.63, ["Fly"] = 42.24, ["Ride"] = 38.05, ["Fly|Ride"] = 107.52, ["Neon"] = 8.47, ["Neon|Fly"] = 135.03, ["Neon|Ride"] = 70.8, ["Neon|Fly|Ride"] = 81.68, ["Mega"] = 28.32, ["Mega|Fly"] = 91.88, ["Mega|Ride"] = 97.22, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://100439668574210"] = {name = "Jiggly Jerboa", prices = {["default"] = 2.1, ["Neon"] = 3.42, ["Neon|Ride"] = 42.27, ["Neon|Fly|Ride"] = 99.33, ["Mega"] = 19.04, ["Mega|Ride"] = 93.49}},
    ["rbxassetid://14815828879"] = {name = "Ghost", prices = {["default"] = 3.63, ["Fly"] = 47.16, ["Ride"] = 25.85, ["Fly|Ride"] = 63.4, ["Neon"] = 6.56, ["Neon|Fly"] = 38.06, ["Neon|Ride"] = 28.88, ["Neon|Fly|Ride"] = 70.81, ["Mega"] = 73.33, ["Mega|Fly"] = 139.49, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 119.28}},
    ["rbxassetid://140565380261180"] = {name = "Galapagos Sea Lion", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 26.17, ["Neon|Fly|Ride"] = 313.28, ["Mega"] = 15.74, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://14146188240"] = {name = "Bluebottle Fly", prices = {["default"] = 2.63, ["Ride"] = 52.5, ["Fly|Ride"] = 525, ["Neon"] = 21.92, ["Mega"] = 141.6, ["Mega|Fly"] = 314.99, ["Mega|Ride"] = 282.13}},
    ["rbxassetid://15930540035"] = {name = "Sandfish", prices = {["default"] = 3.34, ["Neon"] = 16.89, ["Mega"] = 139.13}},
    ["rbxassetid://74774507671765"] = {name = "Island Tarsier", prices = {["default"] = 2.45, ["Ride"] = 70.8, ["Neon"] = 6.35, ["Neon|Ride"] = 37.71, ["Neon|Fly|Ride"] = 76.1, ["Mega"] = 24.94, ["Mega|Ride"] = 174.96, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://9678196095"] = {name = "Mouse", prices = {["default"] = 2.1, ["Fly"] = 30.54, ["Ride"] = 18.4, ["Fly|Ride"] = 30.19, ["Neon"] = 2.1, ["Neon|Fly"] = 42.27, ["Neon|Ride"] = 16.91, ["Neon|Fly|Ride"] = 41.88, ["Mega"] = 14.44, ["Mega|Fly"] = 53.9, ["Mega|Ride"] = 21.15, ["Mega|Fly|Ride"] = 57.66}},
    ["rbxassetid://100695038890951"] = {name = "Basic Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13104111122"] = {name = "Piranha", prices = {["default"] = 2.1, ["Fly"] = 72.19, ["Ride"] = 26.25, ["Fly|Ride"] = 107.78, ["Neon"] = 31.39, ["Neon|Ride"] = 39.38, ["Mega"] = 253.6, ["Mega|Ride"] = 352.93, ["Mega|Fly|Ride"] = 688.84}},
    ["rbxassetid://110856597065248"] = {name = "Bakeneko", prices = {["default"] = 2.1, ["Ride"] = 42, ["Fly|Ride"] = 78.73, ["Neon"] = 6.57, ["Neon|Ride"] = 34.13, ["Neon|Fly|Ride"] = 117.43, ["Mega"] = 34.13, ["Mega|Ride"] = 141.6, ["Mega|Fly|Ride"] = 183.81}},
    ["rbxassetid://128979941112615"] = {name = "Dirty Ducky", prices = {["default"] = 6.57, ["Neon"] = 12.11, ["Neon|Fly|Ride"] = 141.6, ["Mega"] = 89.25, ["Mega|Ride"] = 233.63, ["Mega|Fly|Ride"] = 221.81}},
    ["rbxassetid://12479656052"] = {name = "Maleo Bird", prices = {["default"] = 3.68, ["Fly"] = 31.7, ["Ride"] = 21.2, ["Fly|Ride"] = 192.29, ["Neon"] = 10.58, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 31.71, ["Neon|Fly|Ride"] = 126.81, ["Mega"] = 210, ["Mega|Ride"] = 85.3}},
    ["rbxassetid://3200646599"] = {name = "Cat", prices = {["default"] = 2.1, ["Fly"] = 39.29, ["Ride"] = 14.21, ["Fly|Ride"] = 39.38, ["Neon"] = 2.1, ["Neon|Fly"] = 20.9, ["Neon|Ride"] = 13.13, ["Neon|Fly|Ride"] = 28.48, ["Mega"] = 15.85, ["Mega|Fly"] = 40.17, ["Mega|Ride"] = 22.32, ["Mega|Fly|Ride"] = 55.13}},
    ["rbxassetid://12479810452"] = {name = "Bali Starling", prices = {["default"] = 3.39, ["Fly"] = 23.96, ["Ride"] = 19.65, ["Fly|Ride"] = 48.57, ["Neon"] = 22.46, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 75.03, ["Mega"] = 128.63, ["Mega|Ride"] = 253.6, ["Mega|Fly|Ride"] = 266.25}},
    ["rbxassetid://9982819219"] = {name = "Dugong", prices = {["default"] = 4.7, ["Fly"] = 41.91, ["Fly|Ride"] = 141.39, ["Neon"] = 70.41, ["Neon|Ride"] = 112.88, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 266.27, ["Mega|Ride"] = 276.94, ["Mega|Fly|Ride"] = 385.23}},
    ["rbxassetid://3181727229"] = {name = "Buffalo", prices = {["default"] = 2.1, ["Fly"] = 22.33, ["Ride"] = 15.39, ["Fly|Ride"] = 35.44, ["Neon"] = 2.1, ["Neon|Fly"] = 16.9, ["Neon|Ride"] = 17.07, ["Neon|Fly|Ride"] = 63.41, ["Mega|Ride"] = 57.75, ["Mega|Fly|Ride"] = 98.28}},
    ["rbxassetid://99694153348188"] = {name = "Urchin", prices = {["default"] = 2.63, ["Fly"] = 176.43, ["Neon"] = 9.4, ["Neon|Fly"] = 77.53, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 42.06, ["Mega|Fly"] = 564.24, ["Mega|Ride"] = 118.13}},
    ["rbxassetid://84089584046947"] = {name = "Blue Butterfly", prices = {["default"] = 2.63, ["Ride"] = 27.48, ["Neon"] = 8.45, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 157.43, ["Neon|Fly|Ride"] = 313.5, ["Mega"] = 38.07, ["Mega|Ride"] = 102.16, ["Mega|Fly|Ride"] = 157.32}},
    ["rbxassetid://124485808787576"] = {name = "Tegu", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Fly"] = 40.69, ["Neon|Ride"] = 28.54, ["Neon|Fly|Ride"] = 3150, ["Mega"] = 18.79, ["Mega|Ride"] = 105}},
    ["rbxassetid://8938703774"] = {name = "Bullfrog", prices = {["default"] = 2.1, ["Fly"] = 88.76, ["Ride"] = 17.05, ["Fly|Ride"] = 59.07, ["Neon"] = 4.25, ["Neon|Fly"] = 46.5, ["Neon|Ride"] = 21.14, ["Neon|Fly|Ride"] = 75.03, ["Mega"] = 117.93, ["Mega|Ride"] = 95.82, ["Mega|Fly|Ride"] = 269.41}},
    ["rbxassetid://102746202827395"] = {name = "Hopbop", prices = {["default"] = 2.63, ["Ride"] = 31.49, ["Neon"] = 25.38, ["Neon|Ride"] = 52.5, ["Mega"] = 89.25}},
    ["rbxassetid://6498255997"] = {name = "Stingray", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 15.65, ["Fly|Ride"] = 125.9, ["Neon"] = 7.74, ["Neon|Fly"] = 141.58, ["Neon|Ride"] = 19.59, ["Neon|Fly|Ride"] = 78.21, ["Mega"] = 39.38, ["Mega|Fly"] = 126.81, ["Mega|Ride"] = 90.57, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://13104106555"] = {name = "Mosquito", prices = {["default"] = 3.41, ["Ride"] = 82.6, ["Neon"] = 87.84, ["Mega|Fly|Ride"] = 844.06}},
    ["rbxassetid://5721843483"] = {name = "Ground Sloth", prices = {["default"] = 2.1, ["Ride"] = 21, ["Fly|Ride"] = 5400.61, ["Neon"] = 15.27, ["Neon|Fly"] = 141.58, ["Neon|Ride"] = 28.88, ["Neon|Fly|Ride"] = 157.35, ["Mega"] = 145.14, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://4506925908"] = {name = "Robin", prices = {["default"] = 15.75, ["Fly"] = 24.31, ["Ride"] = 29.64, ["Fly|Ride"] = 112.62, ["Neon"] = 23.45, ["Neon|Fly"] = 99.32, ["Neon|Ride"] = 35.94, ["Neon|Fly|Ride"] = 84.62, ["Mega|Ride"] = 203.26, ["Mega|Fly|Ride"] = 195.83}},
    ["rbxassetid://10382786163"] = {name = "Sado Mole", prices = {["default"] = 3.29, ["Fly"] = 79.47, ["Ride"] = 32.82, ["Fly|Ride"] = 105.68, ["Neon"] = 33.39, ["Neon|Ride"] = 93.94, ["Mega"] = 315, ["Mega|Ride"] = 405.56}},
    ["rbxassetid://14471275373"] = {name = "Ash Zebra", prices = {["default"] = 11.82, ["Mega"] = 556.5, ["Mega|Fly|Ride"] = 794.07}},
    ["rbxassetid://15923574361"] = {name = "Armadillo", prices = {["default"] = 3.68, ["Ride"] = 262.5, ["Fly|Ride"] = 70.8, ["Neon"] = 82.42, ["Neon|Ride"] = 105, ["Mega"] = 253.56, ["Mega|Ride"] = 367.5}},
    ["rbxassetid://15921927876"] = {name = "Coyote", prices = {["default"] = 9.11, ["Ride"] = 33.87, ["Neon"] = 42, ["Neon|Ride"] = 99.32, ["Neon|Fly|Ride"] = 141.6, ["Mega"] = 469.64, ["Mega|Ride"] = 251.33, ["Mega|Fly|Ride"] = 391.79}},
    ["rbxassetid://74353184935672"] = {name = "Sheepdog Ducky", prices = {["default"] = 2.1, ["Neon"] = 2.5, ["Neon|Ride"] = 128.91, ["Mega"] = 22.32, ["Mega|Ride"] = 139.12, ["Mega|Fly|Ride"] = 148.29}},
    ["rbxassetid://4748889845"] = {name = "Easter 2020 Egg", prices = {["default"] = 43.32}},
    ["rbxassetid://4752655872"] = {name = "Chick", prices = {["default"] = 6.57, ["Fly"] = 26.25, ["Ride"] = 21.11, ["Fly|Ride"] = 66.94, ["Neon"] = 32.82, ["Neon|Ride"] = 40.69, ["Neon|Fly|Ride"] = 103.76, ["Mega"] = 236.25, ["Mega|Ride"] = 331.78, ["Mega|Fly|Ride"] = 275.88}},
    ["rbxassetid://17174085645"] = {name = "Garden Snake", prices = {["default"] = 2.1, ["Fly"] = 70.88, ["Ride"] = 18.36, ["Fly|Ride"] = 70.8, ["Neon"] = 3.78, ["Neon|Ride"] = 23.55, ["Mega"] = 38.56, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://17661844380"] = {name = "Show Pony", prices = {["default"] = 2.1, ["Ride"] = 27.48, ["Fly|Ride"] = 140.27, ["Neon"] = 4.71, ["Neon|Ride"] = 30.18, ["Neon|Fly|Ride"] = 93.94, ["Mega"] = 42, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://8077196440"] = {name = "Walrus", prices = {["default"] = 2.1, ["Fly"] = 45.94, ["Ride"] = 19.69, ["Fly|Ride"] = 78.2, ["Neon"] = 15.44, ["Neon|Ride"] = 21.14, ["Neon|Fly|Ride"] = 87.28, ["Mega"] = 133.76, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 313.43}},
    ["rbxassetid://13104118499"] = {name = "Liger", prices = {["default"] = 3.42, ["Ride"] = 31.71, ["Neon"] = 45.94, ["Neon|Ride"] = 210, ["Neon|Fly|Ride"] = 191.63}},
    ["rbxassetid://120937667166493"] = {name = "Aye Aye", prices = {["default"] = 2.1, ["Neon"] = 2.3, ["Neon|Ride"] = 51.68, ["Mega"] = 18.95, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 51.19, ["Mega|Fly|Ride"] = 141.1}},
    ["rbxassetid://3199974297"] = {name = "Cracked Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15348350458"] = {name = "Beluga Whale", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Ride"] = 19.03, ["Fly|Ride"] = 56.99, ["Neon"] = 4.52, ["Neon|Fly"] = 30.19, ["Neon|Ride"] = 28.54, ["Neon|Fly|Ride"] = 96.16, ["Mega"] = 32.82, ["Mega|Fly"] = 187.87, ["Mega|Ride"] = 57.17, ["Mega|Fly|Ride"] = 146.41}},
    ["rbxassetid://7126719464"] = {name = "Wolpertinger", prices = {["default"] = 2.1, ["Fly"] = 28.5, ["Ride"] = 19.21, ["Fly|Ride"] = 45.45, ["Neon"] = 8.46, ["Neon|Fly"] = 103.56, ["Neon|Ride"] = 23.37, ["Neon|Fly|Ride"] = 70.81, ["Mega"] = 190.2, ["Mega|Ride"] = 113.07, ["Mega|Fly|Ride"] = 157.32}},
    ["rbxassetid://125112456358906"] = {name = "Frankenfeline", prices = {["default"] = 2.1, ["Fly"] = 210, ["Ride"] = 20.98, ["Fly|Ride"] = 45.94, ["Neon"] = 3.82, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 82.03, ["Mega"] = 21, ["Mega|Ride"] = 47.34, ["Mega|Fly|Ride"] = 105.99}},
    ["rbxassetid://80556114592490"] = {name = "Japanese Snow Fairy", prices = {["default"] = 2.1, ["Neon"] = 4.93, ["Neon|Ride"] = 38.06, ["Neon|Fly|Ride"] = 151220.35, ["Mega"] = 23.18, ["Mega|Fly"] = 104.81, ["Mega|Ride"] = 84.5, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://124671555129102"] = {name = "Ratatoskr", prices = {["default"] = 2.1, ["Fly"] = 26.36, ["Ride"] = 24.05, ["Fly|Ride"] = 77.37, ["Neon"] = 3.93, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 31.66, ["Neon|Fly|Ride"] = 66.94, ["Mega"] = 20.79, ["Mega|Ride"] = 51.19, ["Mega|Fly|Ride"] = 131.02}},
    ["rbxassetid://116184296449988"] = {name = "Pinkypillar", prices = {["default"] = 2.1, ["Neon"] = 3.81, ["Mega"] = 25.93, ["Mega|Ride"] = 235.94}},
    ["rbxassetid://74353532164157"] = {name = "Red Panda Ducky", prices = {["default"] = 2.63, ["Neon"] = 3.92, ["Neon|Ride"] = 157.34, ["Neon|Fly|Ride"] = 282.13, ["Mega"] = 30.18, ["Mega|Fly"] = 117.43}},
    ["rbxassetid://4708551264"] = {name = "Bandicoot", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 19.69, ["Neon"] = 6.45, ["Neon|Fly"] = 71.91, ["Neon|Ride"] = 22.33, ["Neon|Fly|Ride"] = 87.94, ["Mega"] = 61.69, ["Mega|Ride"] = 60.21, ["Mega|Fly|Ride"] = 131.08}},
    ["rbxassetid://12480314681"] = {name = "Malaysian Tapir", prices = {["default"] = 6.57, ["Ride"] = 65.63, ["Fly|Ride"] = 117.28, ["Neon"] = 528.26, ["Neon|Ride"] = 259.88, ["Mega"] = 383.36, ["Mega|Ride"] = 3131.28, ["Mega|Fly|Ride"] = 739.54}},
    ["rbxassetid://17482380743"] = {name = "Classic Teapot", prices = {["default"] = 3.93, ["Fly"] = 6562.49, ["Ride"] = 32.82, ["Neon"] = 78.2, ["Mega"] = 739.64, ["Mega|Ride"] = 315}},
    ["rbxassetid://14146142724"] = {name = "Mongoose", prices = {["default"] = 4.71, ["Ride"] = 31.58, ["Fly|Ride"] = 45.94, ["Neon"] = 28.5, ["Mega"] = 205, ["Mega|Fly|Ride"] = 338.63}},
    ["rbxassetid://3181727351"] = {name = "Dog", prices = {["default"] = 2.1, ["Fly"] = 15.86, ["Ride"] = 15.74, ["Fly|Ride"] = 26.25, ["Neon"] = 2.1, ["Neon|Fly"] = 19.69, ["Neon|Ride"] = 12.5, ["Neon|Fly|Ride"] = 31.49, ["Mega"] = 18.38, ["Mega|Fly"] = 26.25, ["Mega|Ride"] = 26.25, ["Mega|Fly|Ride"] = 56.44}},
    ["rbxassetid://14267322852"] = {name = "Angelfish", prices = {["default"] = 6.57, ["Ride"] = 55.13, ["Neon"] = 32.82, ["Neon|Fly"] = 141.58, ["Neon|Ride"] = 32.76, ["Neon|Fly|Ride"] = 105, ["Mega"] = 45.93, ["Mega|Ride"] = 141.6}},
    ["rbxassetid://110130591707207"] = {name = "California Condor", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Fly"] = 31.71, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 79.05, ["Mega"] = 12.7, ["Mega|Fly"] = 78.44, ["Mega|Ride"] = 101.07, ["Mega|Fly|Ride"] = 103.58}},
    ["rbxassetid://123567499475377"] = {name = "Forest Sprite", prices = {["default"] = 2.1, ["Neon"] = 3.93, ["Neon|Fly"] = 60.9, ["Mega"] = 16.54, ["Mega|Fly|Ride"] = 282.13}},
    ["rbxassetid://8663441035"] = {name = "Lunar White Tiger", prices = {["default"] = 2.63, ["Fly"] = 19.69, ["Ride"] = 20.09, ["Fly|Ride"] = 63.41, ["Neon"] = 17.07, ["Neon|Fly"] = 141.58, ["Neon|Ride"] = 31.71, ["Neon|Fly|Ride"] = 105.68, ["Mega"] = 143.21, ["Mega|Ride"] = 193.87, ["Mega|Fly|Ride"] = 250.2}},
    ["rbxassetid://16000498338"] = {name = "Groundhog", prices = {["default"] = 177.19, ["Ride"] = 252, ["Fly|Ride"] = 316.96, ["Neon"] = 1267.77, ["Neon|Ride"] = 937.79, ["Neon|Fly|Ride"] = 1690.57, ["Mega"] = 8452.8, ["Mega|Fly|Ride"] = 3945.94}},
    ["rbxassetid://73268582142443"] = {name = "Kelp Raider", prices = {["default"] = 2.1, ["Neon"] = 10.39, ["Neon|Ride"] = 68.25, ["Mega"] = 65.42, ["Mega|Ride"] = 177.53, ["Mega|Fly|Ride"] = 556.78}},
    ["rbxassetid://16369178617"] = {name = "Ornate Horned Frog", prices = {["default"] = 3.94, ["Fly"] = 103.68, ["Ride"] = 31.82, ["Neon"] = 59.07, ["Neon|Ride"] = 169.04, ["Neon|Fly|Ride"] = 147.94, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 626.84}},
    ["rbxassetid://6245080170"] = {name = "Lunar Ox", prices = {["default"] = 2.1, ["Fly"] = 845.09, ["Ride"] = 14.44, ["Neon"] = 7.12, ["Neon|Fly"] = 43.32, ["Neon|Ride"] = 28.88, ["Neon|Fly|Ride"] = 61.69, ["Mega"] = 65.63, ["Mega|Ride"] = 80.54, ["Mega|Fly|Ride"] = 134.18}},
    ["rbxassetid://92652981666929"] = {name = "Starmite", prices = {["default"] = 2.63, ["Fly"] = 19.69, ["Ride"] = 24.94, ["Fly|Ride"] = 120.89, ["Neon"] = 11.82, ["Neon|Fly"] = 42.27, ["Neon|Ride"] = 80.16, ["Mega"] = 117.29, ["Mega|Ride"] = 91.88}},
    ["rbxassetid://9482496753"] = {name = "King Penguin", prices = {["default"] = 5.25, ["Fly"] = 28.88, ["Ride"] = 17.07, ["Fly|Ride"] = 36.75, ["Neon"] = 28.7, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 206.06, ["Mega|Ride"] = 170.63, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://10489161125"] = {name = "Tanuki", prices = {["default"] = 42.27, ["Fly"] = 42.27, ["Ride"] = 63.4, ["Fly|Ride"] = 246.75, ["Neon"] = 140.44, ["Neon|Ride"] = 116.82, ["Neon|Fly|Ride"] = 627.63, ["Mega"] = 183.75, ["Mega|Fly|Ride"] = 380.35}},
    ["rbxassetid://7126720060"] = {name = "Wyvern", prices = {["default"] = 3.94, ["Fly"] = 23.63, ["Ride"] = 16.91, ["Fly|Ride"] = 36.75, ["Neon"] = 21.21, ["Neon|Fly"] = 99.32, ["Neon|Ride"] = 25.72, ["Neon|Fly|Ride"] = 68.25, ["Mega"] = 196.88, ["Mega|Fly"] = 328.13, ["Mega|Ride"] = 281.51, ["Mega|Fly|Ride"] = 150.94}},
    ["rbxassetid://4506925800"] = {name = "Swan", prices = {["default"] = 70.66, ["Fly"] = 85.32, ["Ride"] = 105.99, ["Fly|Ride"] = 140.44, ["Neon"] = 446.25, ["Neon|Fly"] = 404.92, ["Neon|Ride"] = 312.37, ["Neon|Fly|Ride"] = 409.78, ["Mega|Fly|Ride"] = 1529.07}},
    ["rbxassetid://13621428133"] = {name = "Tortuga de la Isla", prices = {["default"] = 216.56, ["Fly"] = 322.17, ["Ride"] = 248.07, ["Fly|Ride"] = 262.5, ["Neon|Ride"] = 1056.48, ["Neon|Fly|Ride"] = 1098.57, ["Mega"] = 10566, ["Mega|Fly|Ride"] = 4221.67}},
    ["rbxassetid://6684832189"] = {name = "Lamb", prices = {["default"] = 74.82, ["Fly"] = 181.99, ["Ride"] = 84, ["Fly|Ride"] = 105.52, ["Neon"] = 685.13, ["Neon|Ride"] = 298.23, ["Neon|Fly|Ride"] = 339.94, ["Mega|Fly|Ride"] = 1148.66}},
    ["rbxassetid://122365328950491"] = {name = "Blossom Snake", prices = {["default"] = 4.6, ["Ride"] = 33.81, ["Fly|Ride"] = 141.58, ["Neon"] = 35.23, ["Neon|Ride"] = 72.81, ["Neon|Fly|Ride"] = 143.72, ["Mega"] = 196.88, ["Mega|Ride"] = 193.6, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://14360919997"] = {name = "Toasty Red Panda", prices = {["default"] = 94.29, ["Fly"] = 68.14, ["Ride"] = 32.19, ["Fly|Ride"] = 78.75, ["Neon"] = 79.25, ["Neon|Fly"] = 91.88, ["Neon|Ride"] = 291.37, ["Neon|Fly|Ride"] = 197.6, ["Mega"] = 353.07, ["Mega|Ride"] = 451.5, ["Mega|Fly|Ride"] = 673.81}},
    ["rbxassetid://3181727278"] = {name = "Rabbit", prices = {["default"] = 2.1, ["Fly"] = 31.5, ["Ride"] = 26.25, ["Neon"] = 7.06, ["Neon|Fly"] = 115.5, ["Neon|Ride"] = 21.13, ["Neon|Fly|Ride"] = 87.71, ["Mega"] = 63.41, ["Mega|Fly"] = 209.01, ["Mega|Fly|Ride"] = 211.31}},
    ["rbxassetid://14782579567"] = {name = "Nightmare Owl", prices = {["default"] = 7.88, ["Fly"] = 68.49, ["Ride"] = 27.57, ["Fly|Ride"] = 105, ["Neon"] = 48.61, ["Neon|Ride"] = 69.75, ["Neon|Fly|Ride"] = 134.93, ["Mega"] = 703.7, ["Mega|Ride"] = 497.44, ["Mega|Fly|Ride"] = 422.6}},
    ["rbxassetid://6498256342"] = {name = "Narwhal", prices = {["default"] = 3.94, ["Fly"] = 28.53, ["Ride"] = 19.69, ["Fly|Ride"] = 46.86, ["Neon"] = 19.03, ["Neon|Fly"] = 145.69, ["Neon|Ride"] = 28.54, ["Neon|Fly|Ride"] = 97.13, ["Mega"] = 131.25, ["Mega|Ride"] = 141.6, ["Mega|Fly|Ride"] = 175.88}},
    ["rbxassetid://9227407648"] = {name = "Ibex", prices = {["default"] = 3.66, ["Ride"] = 28.54, ["Fly|Ride"] = 328.13, ["Neon"] = 15.74, ["Neon|Ride"] = 57.06, ["Neon|Fly|Ride"] = 157.35, ["Mega"] = 207.37, ["Mega|Ride"] = 209.22, ["Mega|Fly|Ride"] = 312.25}},
    ["rbxassetid://16440727263"] = {name = "Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 28.54, ["Neon"] = 2.1, ["Neon|Ride"] = 17.07, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 15.74, ["Mega|Ride"] = 38.06, ["Mega|Fly|Ride"] = 197.55}},
    ["rbxassetid://10318106327"] = {name = "Yellow Butterfly", prices = {["default"] = 2.1, ["Fly"] = 45.93, ["Ride"] = 20.89, ["Fly|Ride"] = 55.13, ["Neon"] = 13.13, ["Neon|Fly"] = 70.8, ["Neon|Ride"] = 57.26, ["Neon|Fly|Ride"] = 69.57, ["Mega"] = 108.81, ["Mega|Ride"] = 105.68, ["Mega|Fly|Ride"] = 192.29}},
    ["rbxassetid://13894169749"] = {name = "Black Kite", prices = {["default"] = 3.94, ["Ride"] = 17.07, ["Fly|Ride"] = 57.06, ["Neon"] = 63.41, ["Neon|Fly"] = 141.58, ["Neon|Ride"] = 47.25, ["Neon|Fly|Ride"] = 63, ["Mega"] = 268.38, ["Mega|Ride"] = 206.07, ["Mega|Fly|Ride"] = 271.69}},
    ["rbxassetid://4506925595"] = {name = "Polar Bear", prices = {["default"] = 144.38, ["Fly"] = 211.31, ["Ride"] = 189.92, ["Fly|Ride"] = 231, ["Neon"] = 494.82, ["Neon|Fly"] = 669.82, ["Neon|Ride"] = 498.73, ["Neon|Fly|Ride"] = 595.85, ["Mega|Fly|Ride"] = 1947.75}},
    ["rbxassetid://14639006189"] = {name = "Canada Goose", prices = {["default"] = 8.46, ["Ride"] = 30.19, ["Fly|Ride"] = 206.04, ["Neon"] = 63.4, ["Neon|Ride"] = 113.06, ["Neon|Fly|Ride"] = 152.25, ["Mega"] = 414.75, ["Mega|Ride"] = 564.24, ["Mega|Fly|Ride"] = 485.35}},
    ["rbxassetid://5721844402"] = {name = "Triceratops", prices = {["default"] = 2.1, ["Fly"] = 31.7, ["Ride"] = 21, ["Fly|Ride"] = 50.72, ["Neon"] = 25.36, ["Neon|Ride"] = 42.27, ["Neon|Fly|Ride"] = 105.68, ["Mega"] = 183.86, ["Mega|Ride"] = 282.13, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://83805820117149"] = {name = "Golden Jaguar", prices = {["default"] = 28.88, ["Fly"] = 59.07, ["Ride"] = 85.31, ["Fly|Ride"] = 178.5, ["Neon"] = 106.2, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 294.54, ["Mega"] = 486.68, ["Mega|Ride"] = 469.64, ["Mega|Fly|Ride"] = 635.24}},
    ["rbxassetid://13936754497"] = {name = "Pinocchio", prices = {["default"] = 4.2}},
    ["rbxassetid://17059776562"] = {name = "Ankylosaurus", prices = {["default"] = 6.27, ["Ride"] = 25.52, ["Neon"] = 92.98, ["Neon|Ride"] = 162.71, ["Neon|Fly|Ride"] = 633.97, ["Mega"] = 315, ["Mega|Ride"] = 408.92, ["Mega|Fly|Ride"] = 552.44}},
    ["rbxassetid://3181727813"] = {name = "Horse", prices = {["default"] = 31.4, ["Fly"] = 62.34, ["Ride"] = 31.5, ["Fly|Ride"] = 57.21, ["Neon|Fly"] = 101818.18, ["Neon|Ride"] = 124.68, ["Neon|Fly|Ride"] = 126.81, ["Mega"] = 2113.2, ["Mega|Fly|Ride"] = 528.69}},
    ["rbxassetid://101098195340953"] = {name = "Mexican Wolf", prices = {["default"] = 2.1, ["Fly"] = 31.7, ["Ride"] = 19.69, ["Neon"] = 5.25, ["Neon|Ride"] = 35.44, ["Neon|Fly|Ride"] = 106.32, ["Mega"] = 36.75, ["Mega|Fly|Ride"] = 163.44}},
    ["rbxassetid://13894408663"] = {name = "Seagull", prices = {["default"] = 5.25, ["Fly"] = 28.09, ["Ride"] = 20.79, ["Fly|Ride"] = 78.2, ["Neon"] = 39.38, ["Neon|Ride"] = 44.63, ["Mega"] = 268.38, ["Mega|Fly"] = 392.16, ["Mega|Ride"] = 203.44, ["Mega|Fly|Ride"] = 309.75}},
    ["rbxassetid://6998403532"] = {name = "Sasquatch", prices = {["default"] = 2.1, ["Ride"] = 23.25, ["Fly|Ride"] = 61.69, ["Neon"] = 28.54, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 118.13, ["Mega|Ride"] = 124, ["Mega|Fly|Ride"] = 234.78}},
    ["rbxassetid://108348392849720"] = {name = "Water Opossum", prices = {["default"] = 2.1, ["Ride"] = 32.76, ["Neon"] = 3.93, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 26.73, ["Neon|Fly|Ride"] = 196.08, ["Mega"] = 23.26, ["Mega|Ride"] = 62.99, ["Mega|Fly|Ride"] = 204.75}},
    ["rbxassetid://11758575705"] = {name = "Moon Rabbit", prices = {["default"] = 36.75, ["Ride"] = 80.31, ["Fly|Ride"] = 282.1, ["Neon"] = 248.06, ["Neon|Ride"] = 282.1, ["Mega"] = 843.51, ["Mega|Ride"] = 756, ["Mega|Fly|Ride"] = 929.08}},
    ["rbxassetid://15922874831"] = {name = "Roadrunner", prices = {["default"] = 6.57, ["Ride"] = 49.67, ["Fly|Ride"] = 210, ["Neon"] = 48.77, ["Neon|Ride"] = 78.2, ["Neon|Fly|Ride"] = 211.34, ["Mega|Ride"] = 511.88, ["Mega|Fly|Ride"] = 704.68}},
    ["rbxassetid://6060988175"] = {name = "Snowman", prices = {["default"] = 11.64, ["Fly"] = 96.96, ["Ride"] = 69.57, ["Fly|Ride"] = 105, ["Neon"] = 70.55, ["Neon|Fly"] = 211.31, ["Neon|Ride"] = 54.05, ["Neon|Fly|Ride"] = 267.75, ["Mega"] = 378, ["Mega|Ride"] = 354.89, ["Mega|Fly|Ride"] = 493.38}},
    ["rbxassetid://12720029414"] = {name = "Wood Pigeon", prices = {["default"] = 79.25, ["Fly"] = 433.13, ["Ride"] = 103.69, ["Fly|Ride"] = 262.44, ["Neon"] = 208.69, ["Neon|Ride"] = 393.75, ["Mega|Ride"] = 1968.75, ["Mega|Fly|Ride"] = 3052.02}},
    ["rbxassetid://136340738568203"] = {name = "Mr Whiskerpips", prices = {["default"] = 26.25, ["Ride"] = 46.35, ["Fly|Ride"] = 197.58, ["Neon"] = 125.48, ["Neon|Ride"] = 211.04, ["Neon|Fly|Ride"] = 656.25, ["Mega"] = 538.13, ["Mega|Ride"] = 462.66, ["Mega|Fly|Ride"] = 564.17}},
    ["rbxassetid://127204329704553"] = {name = "German Shepherd", prices = {["default"] = 72.19, ["Ride"] = 115.5, ["Fly|Ride"] = 200.79, ["Neon"] = 203.43, ["Neon|Ride"] = 269.21, ["Neon|Fly|Ride"] = 341.12, ["Mega"] = 1085.14, ["Mega|Ride"] = 1012.24, ["Mega|Fly|Ride"] = 853.13}},
    ["rbxassetid://99868640713300"] = {name = "Puptune", prices = {["default"] = 49.66, ["Ride"] = 105, ["Fly|Ride"] = 162.75, ["Neon"] = 98.44, ["Neon|Ride"] = 125.79, ["Neon|Fly|Ride"] = 204.09, ["Mega"] = 535.39, ["Mega|Ride"] = 282.83, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://9993276067"] = {name = "2022 Uplift Butterfly", prices = {["default"] = 3.83, ["Fly"] = 69.5, ["Ride"] = 25.36, ["Neon"] = 81.54, ["Neon|Ride"] = 194.24, ["Neon|Fly|Ride"] = 126.81, ["Mega"] = 333.45, ["Mega|Ride"] = 1056.61, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://136574776317301"] = {name = "Sweetheart Rat", prices = {["default"] = 28.88, ["Ride"] = 82.69, ["Fly|Ride"] = 197.58, ["Neon"] = 126.79, ["Neon|Ride"] = 161.34, ["Neon|Fly|Ride"] = 525, ["Mega"] = 364.54, ["Mega|Ride"] = 384.23, ["Mega|Fly|Ride"] = 577.9}},
    ["rbxassetid://17649489402"] = {name = "Cow Calf", prices = {["default"] = 13.13, ["Ride"] = 48.61, ["Fly|Ride"] = 139.17, ["Neon|Ride"] = 123.33, ["Mega"] = 311.72, ["Mega|Ride"] = 311.72, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://77869404304609"] = {name = "Budgie Witch", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 56.44, ["Mega"] = 20.09, ["Mega|Fly"] = 141.6, ["Mega|Ride"] = 70.81, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://111676861947081"] = {name = "The Black Dog", prices = {["default"] = 4.24, ["Ride"] = 209.79, ["Neon"] = 18.38, ["Neon|Ride"] = 83.83, ["Mega"] = 115.5, ["Mega|Ride"] = 157.35, ["Mega|Fly|Ride"] = 313.43}},
    ["rbxassetid://13104122472"] = {name = "Borhyaena Gigantica", prices = {["default"] = 2.1, ["Neon"] = 22.32, ["Neon|Ride"] = 147.92, ["Mega"] = 281.07}},
    ["rbxassetid://105232492496005"] = {name = "Firefighter Gibbon", prices = {["default"] = 21, ["Ride"] = 31.44, ["Fly|Ride"] = 116.24, ["Neon"] = 27.57, ["Neon|Ride"] = 82.95, ["Neon|Fly|Ride"] = 282.13, ["Mega"] = 123.38, ["Mega|Ride"] = 152.97, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://3409443514"] = {name = "Elephant", prices = {["default"] = 469.93, ["Ride"] = 511.88, ["Fly|Ride"] = 624.52, ["Neon"] = 2503.07, ["Neon|Ride"] = 2112.95, ["Neon|Fly|Ride"] = 1574.9, ["Mega|Fly|Ride"] = 5878.95}},
    ["rbxassetid://10137833682"] = {name = "Brown-Chested Pheasant", prices = {["default"] = 8.46, ["Fly"] = 26.25, ["Ride"] = 25.18, ["Fly|Ride"] = 63.41, ["Neon"] = 42.27, ["Neon|Ride"] = 78.2, ["Neon|Fly|Ride"] = 210, ["Mega"] = 211.34, ["Mega|Ride"] = 401.56}},
    ["rbxassetid://12490691849"] = {name = "Gecko", prices = {["default"] = 9.19, ["Fly"] = 21.14, ["Ride"] = 40.22, ["Fly|Ride"] = 84.53, ["Neon"] = 70.46, ["Neon|Fly"] = 315, ["Neon|Ride"] = 64.32, ["Mega"] = 369.84, ["Mega|Ride"] = 264.79, ["Mega|Fly|Ride"] = 469.55}},
    ["rbxassetid://9913459163"] = {name = "Trapdoor Snail", prices = {["default"] = 3.15, ["Fly"] = 28.54, ["Ride"] = 22.33, ["Fly|Ride"] = 316.96, ["Neon"] = 37, ["Neon|Ride"] = 157.35, ["Mega"] = 282.13, ["Mega|Ride"] = 354.38, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://124413732651376"] = {name = "Gumball Caterpillar", prices = {["default"] = 2.1, ["Fly"] = 101.43, ["Ride"] = 30.51, ["Fly|Ride"] = 941.48, ["Neon"] = 11.64, ["Neon|Fly"] = 70.8, ["Neon|Ride"] = 39.26, ["Neon|Fly|Ride"] = 108.98, ["Mega"] = 84.55, ["Mega|Ride"] = 106.95, ["Mega|Fly|Ride"] = 213.43}},
    ["rbxassetid://96107383056013"] = {name = "Gummy Guana", prices = {["default"] = 2.1, ["Fly"] = 70.8, ["Ride"] = 70.8, ["Neon"] = 3.15, ["Neon|Fly"] = 46.98, ["Neon|Ride"] = 49.67, ["Neon|Fly|Ride"] = 157.35, ["Mega"] = 28.54, ["Mega|Fly|Ride"] = 211.31}},
    ["rbxassetid://3261465951"] = {name = "Blue Egg", prices = {["default"] = 1126.08}},
    ["rbxassetid://11245006051"] = {name = "Therapy Dog", prices = {["default"] = 8.54, ["Fly"] = 57.06, ["Ride"] = 30.18, ["Neon"] = 59.07, ["Neon|Fly"] = 141.58, ["Neon|Ride"] = 157.34, ["Mega"] = 528.31, ["Mega|Ride"] = 814.04, ["Mega|Fly|Ride"] = 1055.42}},
    ["rbxassetid://76323474173289"] = {name = "Kelp Crewmate", prices = {["default"] = 2.1, ["Ride"] = 38.07, ["Neon"] = 13.13, ["Neon|Ride"] = 42.26, ["Mega"] = 84.96, ["Mega|Ride"] = 141.6, ["Mega|Fly|Ride"] = 234.78}},
    ["rbxassetid://14978701264"] = {name = "Scarecrow Horse", prices = {["default"] = 2.63, ["Fly"] = 42.27, ["Ride"] = 42, ["Fly|Ride"] = 525, ["Neon"] = 13.13, ["Neon|Ride"] = 70.8, ["Neon|Fly|Ride"] = 128.63, ["Mega"] = 164.07, ["Mega|Ride"] = 154.88, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://3409443801"] = {name = "Lion", prices = {["default"] = 384.06, ["Ride"] = 450.97, ["Fly|Ride"] = 472.06, ["Neon"] = 1372.37, ["Neon|Ride"] = 1509.38, ["Neon|Fly|Ride"] = 1876.95, ["Mega|Fly|Ride"] = 6562.5}},
    ["rbxassetid://13979014954"] = {name = "Fossa", prices = {["default"] = 7.35, ["Fly"] = 196.88, ["Ride"] = 72.19, ["Neon"] = 55.04, ["Neon|Ride"] = 131.25, ["Mega"] = 422.82, ["Mega|Ride"] = 253.6}},
    ["rbxassetid://137886461285917"] = {name = "Angus Cow", prices = {["default"] = 2.1, ["Neon"] = 6.57, ["Neon|Ride"] = 52.84, ["Neon|Fly|Ride"] = 91.81, ["Mega"] = 38.06, ["Mega|Fly"] = 189, ["Mega|Ride"] = 63.4, ["Mega|Fly|Ride"] = 174.12}},
    ["rbxassetid://128343324254978"] = {name = "Blue Cat", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 3.93, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 268.38, ["Mega"] = 20.9, ["Mega|Ride"] = 149.13, ["Mega|Fly|Ride"] = 192.94}},
    ["rbxassetid://79274485636628"] = {name = "Indian Flying Fox", prices = {["default"] = 13.13, ["Fly"] = 76.08, ["Ride"] = 70.8, ["Fly|Ride"] = 178.5, ["Neon"] = 70.46, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 367.5, ["Mega"] = 328.13, ["Mega|Ride"] = 328.76, ["Mega|Fly|Ride"] = 372.75}},
    ["rbxassetid://96039704958671"] = {name = "Singularity Pisces", prices = {["default"] = 5.25, ["Ride"] = 141.58, ["Neon"] = 108.55, ["Neon|Ride"] = 704.68, ["Neon|Fly|Ride"] = 125.64, ["Mega"] = 626.98, ["Mega|Ride"] = 561.29, ["Mega|Fly|Ride"] = 1127.27}},
    ["rbxassetid://12489494348"] = {name = "Komodo Dragon", prices = {["default"] = 3.94, ["Ride"] = 31.7, ["Fly|Ride"] = 99.16, ["Neon"] = 141.94, ["Mega"] = 582.75, ["Mega|Ride"] = 414.21, ["Mega|Fly|Ride"] = 1246.88}},
    ["rbxassetid://14360919129"] = {name = "Flaming Zebra", prices = {["default"] = 12.48, ["Ride"] = 43.32, ["Neon"] = 115.49, ["Neon|Ride"] = 141.58, ["Neon|Fly|Ride"] = 783.13, ["Mega"] = 657.5, ["Mega|Ride"] = 548.31, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://108242367048842"] = {name = "Honey Badger", prices = {["default"] = 361.55, ["Ride"] = 341.25, ["Fly|Ride"] = 446.16, ["Neon"] = 1267.77, ["Neon|Ride"] = 1123.04, ["Neon|Fly|Ride"] = 1267.93, ["Mega"] = 3633.66, ["Mega|Ride"] = 3519.54, ["Mega|Fly|Ride"] = 3154.29}},
    ["rbxassetid://11119262646"] = {name = "Evil Chickatrice", prices = {["default"] = 6.35, ["Fly"] = 25.44, ["Ride"] = 28.54, ["Fly|Ride"] = 83.37, ["Neon"] = 68.11, ["Neon|Ride"] = 130.33, ["Mega"] = 529.78, ["Mega|Ride"] = 523.04, ["Mega|Fly|Ride"] = 536.71}},
    ["rbxassetid://120631772928905"] = {name = "Subzero Scorpion", prices = {["default"] = 6.46, ["Ride"] = 33.5, ["Fly|Ride"] = 105, ["Neon"] = 31.71, ["Mega"] = 422.66, ["Mega|Fly|Ride"] = 1690.37}},
    ["rbxassetid://70394243440806"] = {name = "Ghostly Cat", prices = {["default"] = 10.58, ["Ride"] = 48.27, ["Fly|Ride"] = 162.71, ["Neon"] = 40.69, ["Neon|Ride"] = 95.81, ["Mega"] = 185.07, ["Mega|Ride"] = 210, ["Mega|Fly|Ride"] = 318.94}},
    ["rbxassetid://108186720416551"] = {name = "Storm Condor", prices = {["default"] = 2.46, ["Ride"] = 42.27, ["Fly|Ride"] = 113.06, ["Neon"] = 11.82, ["Neon|Ride"] = 45.61, ["Mega"] = 38.03, ["Mega|Ride"] = 105.68, ["Mega|Fly|Ride"] = 219.52}},
    ["rbxassetid://11181152874"] = {name = "Mule", prices = {["default"] = 51.19, ["Ride"] = 68.25, ["Neon"] = 282.1, ["Neon|Ride"] = 241.89, ["Neon|Fly|Ride"] = 281.07, ["Mega"] = 2535.86, ["Mega|Ride"] = 986.88, ["Mega|Fly|Ride"] = 983.15}},
    ["rbxassetid://94781392732758"] = {name = "Onza", prices = {["default"] = 3.93, ["Fly"] = 586.99, ["Ride"] = 31.5, ["Fly|Ride"] = 80.07, ["Neon"] = 15.75, ["Neon|Fly"] = 183.84, ["Neon|Ride"] = 56.44, ["Neon|Fly|Ride"] = 84.55, ["Mega"] = 68.25, ["Mega|Ride"] = 99.02, ["Mega|Fly|Ride"] = 219.19}},
    ["rbxassetid://102763887893057"] = {name = "Cherub Chipmunk", prices = {["default"] = 2.1, ["Ride"] = 84.53, ["Fly|Ride"] = 80.31, ["Neon"] = 5.8, ["Neon|Fly"] = 70.8, ["Neon|Ride"] = 51.19, ["Neon|Fly|Ride"] = 140.38, ["Mega"] = 27.57, ["Mega|Fly"] = 91.93, ["Mega|Ride"] = 70.04, ["Mega|Fly|Ride"] = 141.58}},
    ["rbxassetid://104845330408668"] = {name = "Icy Porcupine", prices = {["default"] = 3.94, ["Ride"] = 57.75, ["Fly|Ride"] = 262.5, ["Neon"] = 17.62, ["Neon|Fly|Ride"] = 250.43, ["Mega"] = 116.82, ["Mega|Ride"] = 190.32, ["Mega|Fly|Ride"] = 392.09}},
    ["rbxassetid://12597275903"] = {name = "White Sand Dollar", prices = {["default"] = 57.06, ["Ride"] = 105.61, ["Fly|Ride"] = 110.14, ["Neon"] = 352.88, ["Neon|Ride"] = 465.94, ["Neon|Fly|Ride"] = 692.35, ["Mega|Fly|Ride"] = 1355.82}},
    ["rbxassetid://9901393350"] = {name = "Irish Water Spaniel", prices = {["default"] = 278.25, ["Ride"] = 308.12, ["Fly|Ride"] = 408.86, ["Neon|Ride"] = 1099.87, ["Neon|Fly|Ride"] = 1265.82, ["Mega"] = 7044.36, ["Mega|Fly|Ride"] = 4695.39}},
    ["rbxassetid://128640048014369"] = {name = "River Otter", prices = {["default"] = 5.24, ["Neon"] = 39.93, ["Mega"] = 91.49, ["Mega|Ride"] = 243.03, ["Mega|Fly|Ride"] = 378}},
    ["rbxassetid://138984599254588"] = {name = "Tree Sasquatch", prices = {["default"] = 6.57, ["Neon"] = 26.25, ["Mega"] = 92.04, ["Mega|Ride"] = 422.66, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://15870220155"] = {name = "Vulture", prices = {["default"] = 6.57, ["Fly"] = 155.57, ["Ride"] = 91.88, ["Neon"] = 39.38, ["Neon|Fly|Ride"] = 157.35}},
    ["rbxassetid://7734902490"] = {name = "Halloween Black Mummy Cat", prices = {["default"] = 2.1, ["Fly"] = 53.23, ["Ride"] = 28.48, ["Fly|Ride"] = 49.87, ["Neon"] = 6.45, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 183.86, ["Mega"] = 51.1, ["Mega|Ride"] = 74.82, ["Mega|Fly|Ride"] = 178.5}},
    ["rbxassetid://116677376014234"] = {name = "Sunflower Friend", prices = {["default"] = 2.1, ["Ride"] = 69.75, ["Fly|Ride"] = 282.1, ["Neon"] = 7.88, ["Mega"] = 52.5, ["Mega|Fly"] = 141.6, ["Mega|Ride"] = 206.06}},
    ["rbxassetid://13186022212"] = {name = "Grinmoire", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Ride"] = 18.38, ["Fly|Ride"] = 41.93, ["Neon"] = 6.35, ["Neon|Fly"] = 46.98, ["Neon|Ride"] = 27.49, ["Neon|Fly|Ride"] = 105, ["Mega"] = 43.32, ["Mega|Ride"] = 95.82, ["Mega|Fly|Ride"] = 282.1}},
    ["rbxassetid://11119263014"] = {name = "Chickatrice", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Ride"] = 24.94, ["Fly|Ride"] = 55.13, ["Neon"] = 17.07, ["Neon|Fly"] = 46.98, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 91.93, ["Mega"] = 170.63, ["Mega|Ride"] = 199.5, ["Mega|Fly|Ride"] = 433.13}},
    ["rbxassetid://13104110160"] = {name = "Blue Ringed Octopus", prices = {["default"] = 126, ["Ride"] = 52.49, ["Fly|Ride"] = 83.65, ["Neon"] = 140.9, ["Neon|Ride"] = 282.13, ["Mega"] = 367.5, ["Mega|Fly"] = 446.25, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 615.57}},
    ["rbxassetid://16088265753"] = {name = "Flaming Fox", prices = {["default"] = 73.5, ["Ride"] = 98.86, ["Neon"] = 452.19, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 471.19, ["Mega"] = 3131.28, ["Mega|Ride"] = 2113.2, ["Mega|Fly|Ride"] = 1831.93}},
    ["rbxassetid://84105347355723"] = {name = "Gibbon", prices = {["default"] = 2.1, ["Ride"] = 23.23, ["Fly|Ride"] = 131.25, ["Neon"] = 5.65, ["Neon|Ride"] = 110.37, ["Neon|Fly|Ride"] = 141.6, ["Mega"] = 40.05, ["Mega|Ride"] = 91.93}},
    ["rbxassetid://9543194411"] = {name = "Swordfish", prices = {["default"] = 2.1, ["Fly"] = 16.77, ["Ride"] = 18.9, ["Fly|Ride"] = 30.15, ["Neon"] = 3.93, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 24.92, ["Neon|Fly|Ride"] = 62.85, ["Mega"] = 42.29, ["Mega|Fly"] = 131.2, ["Mega|Ride"] = 49.88, ["Mega|Fly|Ride"] = 123.38}},
    ["rbxassetid://11706157391"] = {name = "Steppe Lion", prices = {["default"] = 4.24, ["Ride"] = 31.71, ["Neon"] = 65.63, ["Neon|Ride"] = 422.6, ["Neon|Fly|Ride"] = 281.07, ["Mega"] = 619.18, ["Mega|Ride"] = 311.72, ["Mega|Fly|Ride"] = 472.38}},
    ["rbxassetid://18119064023"] = {name = "Bald Eagle", prices = {["default"] = 223.12, ["Fly"] = 259.88, ["Ride"] = 422.6, ["Fly|Ride"] = 301.88, ["Neon|Ride"] = 1267.77, ["Neon|Fly|Ride"] = 1532.08, ["Mega|Fly|Ride"] = 5635.23}},
    ["rbxassetid://6060991172"] = {name = "Lynx", prices = {["default"] = 51.19, ["Fly"] = 209.9, ["Ride"] = 74.92, ["Neon"] = 223.13, ["Neon|Ride"] = 230.05, ["Neon|Fly|Ride"] = 291.38, ["Mega"] = 982.48, ["Mega|Ride"] = 761.25, ["Mega|Fly|Ride"] = 894.71}},
    ["rbxassetid://10614198346"] = {name = "Pomeranian", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 11.17, ["Neon|Ride"] = 44.63, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 93.19, ["Mega|Ride"] = 106.95, ["Mega|Fly|Ride"] = 215.76}},
    ["rbxassetid://13663102008"] = {name = "Angler Fish", prices = {["default"] = 2.1, ["Fly"] = 211.31, ["Ride"] = 65.63, ["Neon"] = 18.38, ["Neon|Ride"] = 201.84, ["Mega"] = 486.05, ["Mega|Ride"] = 439.11}},
    ["rbxassetid://5067925193"] = {name = "Toy Monkey", prices = {["default"] = 56.44, ["Fly"] = 78.2, ["Ride"] = 45.94, ["Fly|Ride"] = 69.75, ["Neon|Fly|Ride"] = 282.13, ["Mega"] = 2535.86, ["Mega|Ride"] = 904.32, ["Mega|Fly|Ride"] = 1252.52}},
    ["rbxassetid://15698960105"] = {name = "Kookaburra", prices = {["default"] = 108.68, ["Ride"] = 129.94, ["Fly|Ride"] = 190.21, ["Neon"] = 426.57, ["Neon|Ride"] = 469.88, ["Neon|Fly|Ride"] = 610.32, ["Mega"] = 3100.08, ["Mega|Fly|Ride"] = 2192.76}},
    ["rbxassetid://14266900917"] = {name = "Ring-tailed Lemur", prices = {["default"] = 210, ["Ride"] = 288.75, ["Fly|Ride"] = 421.55, ["Neon|Ride"] = 1365, ["Neon|Fly|Ride"] = 1181.25, ["Mega|Fly|Ride"] = 3168.37}},
    ["rbxassetid://10467419131"] = {name = "Leopard Cat", prices = {["default"] = 13.13, ["Ride"] = 63.4, ["Fly|Ride"] = 216.04, ["Neon"] = 111.57, ["Neon|Ride"] = 253.6, ["Mega"] = 386.54, ["Mega|Ride"] = 469.64, ["Mega|Fly|Ride"] = 571.95}},
    ["rbxassetid://6498256485"] = {name = "Crab", prices = {["default"] = 2.1, ["Fly"] = 131.25, ["Ride"] = 17.38, ["Fly|Ride"] = 42.27, ["Neon"] = 6.57, ["Neon|Ride"] = 20.05, ["Neon|Fly|Ride"] = 70.46, ["Mega"] = 91.5, ["Mega|Ride"] = 104.99, ["Mega|Fly|Ride"] = 189}},
    ["rbxassetid://5721843587"] = {name = "Glyptodon", prices = {["default"] = 3.93, ["Ride"] = 28.51, ["Fly|Ride"] = 39.38, ["Neon"] = 27.57, ["Neon|Fly"] = 147.92, ["Neon|Ride"] = 40.69, ["Neon|Fly|Ride"] = 92.76, ["Mega"] = 195.57, ["Mega|Ride"] = 221.82, ["Mega|Fly|Ride"] = 272.22}},
    ["rbxassetid://13979141397"] = {name = "Giant Anteater", prices = {["default"] = 269, ["Ride"] = 296.63, ["Fly|Ride"] = 493.12, ["Neon"] = 1369.2, ["Neon|Ride"] = 1252.74, ["Neon|Fly|Ride"] = 1832.16, ["Mega|Fly|Ride"] = 6684.3}},
    ["rbxassetid://109730629255705"] = {name = "Ruddy Duck", prices = {["default"] = 2.63, ["Ride"] = 46.5, ["Neon"] = 9.19, ["Neon|Fly|Ride"] = 118125, ["Mega"] = 31.11, ["Mega|Ride"] = 109.91, ["Mega|Fly|Ride"] = 313.43}},
    ["rbxassetid://6498259006"] = {name = "Clownfish", prices = {["default"] = 3.82, ["Ride"] = 19.65, ["Fly|Ride"] = 47.18, ["Neon"] = 25.85, ["Neon|Ride"] = 31.87, ["Neon|Fly|Ride"] = 85.32, ["Mega"] = 170.22, ["Mega|Ride"] = 313.5, ["Mega|Fly|Ride"] = 251.46}},
    ["rbxassetid://11758569695"] = {name = "Amami Rabbit", prices = {["default"] = 21, ["Ride"] = 141.58, ["Neon"] = 101.07, ["Neon|Fly"] = 282.1, ["Neon|Ride"] = 158.82, ["Neon|Fly|Ride"] = 564.24, ["Mega|Ride"] = 502.47, ["Mega|Fly|Ride"] = 649.76}},
    ["rbxassetid://11505509482"] = {name = "Ice Wolf", prices = {["default"] = 111.57, ["Fly"] = 281.01, ["Ride"] = 123.36, ["Fly|Ride"] = 140.44, ["Neon|Ride"] = 479.66, ["Neon|Fly|Ride"] = 528.35, ["Mega|Fly|Ride"] = 2183.74}},
    ["rbxassetid://9994480266"] = {name = "Royal Palace Spaniel", prices = {["default"] = 22.32, ["Fly"] = 49.88, ["Ride"] = 35.44, ["Fly|Ride"] = 59.17, ["Neon"] = 57.06, ["Neon|Ride"] = 81.56, ["Neon|Fly|Ride"] = 129.94, ["Mega"] = 704.76, ["Mega|Ride"] = 507.66, ["Mega|Fly|Ride"] = 564.17}},
    ["rbxassetid://100897154120273"] = {name = "Clumpty", prices = {["default"] = 2.1, ["Ride"] = 24.71, ["Neon"] = 2.63, ["Neon|Ride"] = 200.79, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 26.25, ["Mega|Fly|Ride"] = 422.6}},
    ["rbxassetid://11108831285"] = {name = "Ocelot", prices = {["default"] = 2.1, ["Ride"] = 19.69, ["Fly|Ride"] = 72.19, ["Neon"] = 3.54, ["Neon|Fly"] = 31.71, ["Neon|Ride"] = 26.17, ["Neon|Fly|Ride"] = 69.18, ["Mega"] = 21.15, ["Mega|Fly"] = 139.73, ["Mega|Ride"] = 57.75, ["Mega|Fly|Ride"] = 102.86}},
    ["rbxassetid://99323773370664"] = {name = "Dire Wolf", prices = {["default"] = 17.62, ["Fly"] = 126.79, ["Ride"] = 59.07, ["Fly|Ride"] = 127.32, ["Neon"] = 39.38, ["Neon|Fly"] = 266.53, ["Neon|Ride"] = 86.63, ["Neon|Fly|Ride"] = 164.68, ["Mega"] = 131.24, ["Mega|Ride"] = 170.63, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://17649307413"] = {name = "Mini Pig", prices = {["default"] = 1246.88, ["Ride"] = 1312.5, ["Fly|Ride"] = 1378.13, ["Neon"] = 7184.02, ["Neon|Ride"] = 7044.36, ["Neon|Fly|Ride"] = 4419.77, ["Mega|Fly|Ride"] = 12600}},
    ["rbxassetid://12720029753"] = {name = "Border Collie", prices = {["default"] = 703.24, ["Ride"] = 594.57, ["Fly|Ride"] = 643.13, ["Neon|Fly|Ride"] = 2493.75, ["Mega"] = 14088.98, ["Mega|Fly|Ride"] = 7084.87}},
    ["rbxassetid://4440866760"] = {name = "Pig", prices = {["default"] = 298.64, ["Fly"] = 396.14, ["Ride"] = 367.5, ["Fly|Ride"] = 441.7, ["Neon"] = 735, ["Neon|Ride"] = 939.26, ["Neon|Fly|Ride"] = 814.83, ["Mega"] = 5352.75, ["Mega|Fly|Ride"] = 2572.81}},
    ["rbxassetid://4506925854"] = {name = "Arctic Fox", prices = {["default"] = 315, ["Fly"] = 438.45, ["Ride"] = 374.72, ["Fly|Ride"] = 435.75, ["Neon|Fly"] = 3131.25, ["Neon|Ride"] = 912.18, ["Neon|Fly|Ride"] = 881.99, ["Mega|Ride"] = 3675, ["Mega|Fly|Ride"] = 3518.06}},
    ["rbxassetid://11758575618"] = {name = "Black Moon Bear", prices = {["default"] = 2.1, ["Fly"] = 80.31, ["Ride"] = 19.03, ["Fly|Ride"] = 44.62, ["Neon"] = 6.88, ["Neon|Ride"] = 32.42, ["Neon|Fly|Ride"] = 80.32, ["Mega"] = 65.63, ["Mega|Ride"] = 105.68, ["Mega|Fly|Ride"] = 144.38}},
    ["rbxassetid://15547272520"] = {name = "Christmas Pudding Pup", prices = {["default"] = 350.62, ["Fly"] = 590.62, ["Ride"] = 384.18, ["Fly|Ride"] = 452.82, ["Neon"] = 1115.63, ["Neon|Ride"] = 1022.43, ["Neon|Fly|Ride"] = 1191.44, ["Mega"] = 6339.6, ["Mega|Ride"] = 9580.19, ["Mega|Fly|Ride"] = 3806.25}},
    ["rbxassetid://78519945248690"] = {name = "Zombie Chick", prices = {["default"] = 3.94, ["Fly"] = 183.75, ["Ride"] = 27.48, ["Neon"] = 8.46, ["Neon|Ride"] = 56.44, ["Neon|Fly|Ride"] = 113.07, ["Mega"] = 67.96, ["Mega|Ride"] = 106.32, ["Mega|Fly|Ride"] = 272.25}},
    ["rbxassetid://10357178561"] = {name = "Ibis", prices = {["default"] = 2.1, ["Fly"] = 20.14, ["Ride"] = 23.63, ["Fly|Ride"] = 49.88, ["Neon"] = 15.89, ["Neon|Ride"] = 61.69, ["Neon|Fly|Ride"] = 63, ["Mega"] = 65.63, ["Mega|Ride"] = 140.94, ["Mega|Fly|Ride"] = 313.43}},
    ["rbxassetid://96759122303055"] = {name = "Clubtail Dragonfly", prices = {["default"] = 2.1, ["Fly"] = 57.75, ["Neon"] = 3.93, ["Neon|Fly"] = 78.68, ["Mega"] = 20.98, ["Mega|Fly"] = 70.81, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://12778628897"] = {name = "Karate Gorilla", prices = {["default"] = 53.89, ["Ride"] = 65.63, ["Fly|Ride"] = 459.38, ["Neon"] = 244.13, ["Neon|Ride"] = 313.49, ["Mega"] = 1690.57, ["Mega|Fly|Ride"] = 939.09}},
    ["rbxassetid://13104121371"] = {name = "Poison Dart Frog", prices = {["default"] = 2.63, ["Fly"] = 65.61, ["Ride"] = 23.56, ["Fly|Ride"] = 43.32, ["Neon"] = 24.31, ["Mega"] = 328.13}},
    ["rbxassetid://71881209536633"] = {name = "Humbug", prices = {["default"] = 2.63, ["Ride"] = 55.12, ["Neon"] = 4.13, ["Neon|Fly"] = 105.67, ["Neon|Ride"] = 36.28, ["Neon|Fly|Ride"] = 116.82, ["Mega"] = 27.48, ["Mega|Fly"] = 338.13, ["Mega|Ride"] = 42.35, ["Mega|Fly|Ride"] = 308.44}},
    ["rbxassetid://11109314958"] = {name = "Ghost Wolf", prices = {["default"] = 2.1, ["Fly"] = 31.5, ["Ride"] = 21.15, ["Fly|Ride"] = 63, ["Neon"] = 9.4, ["Neon|Fly"] = 122.57, ["Neon|Ride"] = 25.45, ["Neon|Fly|Ride"] = 71.99, ["Mega"] = 60.38, ["Mega|Fly"] = 136.2, ["Mega|Ride"] = 80.07, ["Mega|Fly|Ride"] = 156.09}},
    ["rbxassetid://16088267136"] = {name = "Wildfire Hawk", prices = {["default"] = 3.73, ["Fly"] = 46.97, ["Ride"] = 28.25, ["Fly|Ride"] = 51.44, ["Neon"] = 105.67, ["Neon|Fly"] = 140.9, ["Neon|Ride"] = 139.47, ["Neon|Fly|Ride"] = 249.38, ["Mega"] = 237.57, ["Mega|Fly|Ride"] = 1019.82}},
    ["rbxassetid://16898328648"] = {name = "Preppy Capuchin Monkey", prices = {["default"] = 9.19, ["Ride"] = 52.41, ["Neon"] = 113.06, ["Mega"] = 509.56, ["Mega|Ride"] = 338.13, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://15921713413"] = {name = "Thorny Devil", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Fly|Ride"] = 87.94, ["Neon"] = 40.69, ["Neon|Ride"] = 63.41, ["Neon|Fly|Ride"] = 704.46, ["Mega"] = 242.82, ["Mega|Ride"] = 469.64, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://16441364976"] = {name = "Gold Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 19.03, ["Fly|Ride"] = 84, ["Neon"] = 3.93, ["Neon|Ride"] = 35.94, ["Mega"] = 40.69, ["Mega|Ride"] = 57.07, ["Mega|Fly|Ride"] = 316.96}},
    ["rbxassetid://8077189117"] = {name = "Puffin", prices = {["default"] = 250.69, ["Fly"] = 313.49, ["Ride"] = 239.22, ["Fly|Ride"] = 406.88, ["Neon"] = 1174.05, ["Neon|Ride"] = 1371.32, ["Neon|Fly|Ride"] = 1050, ["Mega"] = 10566, ["Mega|Fly|Ride"] = 4362.75}},
    ["rbxassetid://8663441120"] = {name = "Lunar Tiger", prices = {["default"] = 2.1, ["Fly"] = 35.94, ["Ride"] = 16.83, ["Fly|Ride"] = 31.71, ["Neon"] = 6.46, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 55.13, ["Mega"] = 49.67, ["Mega|Ride"] = 63.41, ["Mega|Fly|Ride"] = 118.13}},
    ["rbxassetid://17174216294"] = {name = "Skunk", prices = {["default"] = 11.64, ["Ride"] = 98.44, ["Fly|Ride"] = 102.38, ["Neon"] = 62.99, ["Neon|Ride"] = 104.41, ["Mega"] = 324.39, ["Mega|Ride"] = 337.86, ["Mega|Fly|Ride"] = 469.55}},
    ["rbxassetid://13981141292"] = {name = "Kiwi", prices = {["default"] = 32.71, ["Ride"] = 141.58, ["Fly|Ride"] = 141.58, ["Neon"] = 187.03, ["Neon|Ride"] = 231.38, ["Mega"] = 763.04, ["Mega|Ride"] = 821.87, ["Mega|Fly|Ride"] = 786.43}},
    ["rbxassetid://3409443617"] = {name = "Meerkat", prices = {["default"] = 193.23, ["Ride"] = 220.5, ["Fly|Ride"] = 315.34, ["Neon"] = 826.18, ["Neon|Ride"] = 649.69, ["Neon|Fly|Ride"] = 866.25, ["Mega|Ride"] = 3381.13, ["Mega|Fly|Ride"] = 2685.21}},
    ["rbxassetid://99042906016947"] = {name = "Seafoam Butterfly", prices = {["default"] = 26.25, ["Neon"] = 78.75, ["Mega"] = 392.16, ["Mega|Ride"] = 406.88, ["Mega|Fly|Ride"] = 704.68}},
    ["rbxassetid://15504847683"] = {name = "Gingerbread Hare", prices = {["default"] = 48.61, ["Ride"] = 261.19, ["Fly|Ride"] = 633.9, ["Neon"] = 234.82, ["Neon|Ride"] = 633.9, ["Neon|Fly|Ride"] = 845.3, ["Mega"] = 1690.57, ["Mega|Fly|Ride"] = 2112.95}},
    ["rbxassetid://15302316802"] = {name = "Peppermint Penguin", prices = {["default"] = 1181.25, ["Fly"] = 1441.13, ["Ride"] = 1050, ["Fly|Ride"] = 1128.75, ["Neon|Ride"] = 4224.85, ["Neon|Fly|Ride"] = 4056.93, ["Mega"] = 16766.12, ["Mega|Fly|Ride"] = 17114.84}},
    ["rbxassetid://10318106124"] = {name = "Scarlet Butterfly", prices = {["default"] = 8.28, ["Fly"] = 28.2, ["Ride"] = 22.33, ["Fly|Ride"] = 63, ["Neon"] = 22.32, ["Neon|Fly"] = 111.57, ["Neon|Ride"] = 63.41, ["Neon|Fly|Ride"] = 200.81, ["Mega"] = 211.95, ["Mega|Ride"] = 216.57, ["Mega|Fly|Ride"] = 534.11}},
    ["rbxassetid://14145989411"] = {name = "Toy Poodle", prices = {["default"] = 9.19, ["Fly"] = 39.38, ["Ride"] = 35.44, ["Neon"] = 42.27, ["Neon|Ride"] = 141.58, ["Neon|Fly|Ride"] = 144.74, ["Mega"] = 282.13, ["Mega|Ride"] = 217.88, ["Mega|Fly|Ride"] = 439.03}},
    ["rbxassetid://82833859118891"] = {name = "Snowy Mammoth", prices = {["default"] = 3.94, ["Fly"] = 191.22, ["Ride"] = 38.07, ["Fly|Ride"] = 942.38, ["Neon"] = 32.82, ["Neon|Ride"] = 78.68, ["Mega"] = 139.54, ["Mega|Ride"] = 295.86, ["Mega|Fly|Ride"] = 845.19}},
    ["rbxassetid://12917346501"] = {name = "Happy Duckling", prices = {["default"] = 22.32, ["Fly"] = 704.6, ["Ride"] = 49.67, ["Fly|Ride"] = 85.32, ["Neon"] = 86.63, ["Neon|Ride"] = 98.98, ["Neon|Fly|Ride"] = 211.11, ["Mega"] = 360.75, ["Mega|Ride"] = 359.72, ["Mega|Fly|Ride"] = 418.69}},
    ["rbxassetid://7064993901"] = {name = "2021 Uplift Butterfly", prices = {["default"] = 2.63, ["Fly"] = 24.31, ["Ride"] = 21.14, ["Fly|Ride"] = 45.67, ["Neon"] = 23.63, ["Neon|Fly"] = 57.06, ["Neon|Ride"] = 35.94, ["Neon|Fly|Ride"] = 84.55, ["Mega|Ride"] = 125.53, ["Mega|Fly|Ride"] = 197.58}},
    ["rbxassetid://10926054144"] = {name = "Slug", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 52.5, ["Neon"] = 12.17, ["Neon|Fly"] = 13125, ["Neon|Ride"] = 46.96, ["Neon|Fly|Ride"] = 110.37, ["Mega"] = 311.67, ["Mega|Ride"] = 137.73, ["Mega|Fly|Ride"] = 367.49}},
    ["rbxassetid://11571113906"] = {name = "Glacier Moth", prices = {["default"] = 262.5, ["Ride"] = 333.38, ["Fly|Ride"] = 564.17, ["Neon|Fly"] = 1181.25, ["Neon|Ride"] = 1550.05, ["Neon|Fly|Ride"] = 1452.84, ["Mega|Fly|Ride"] = 4135.04}},
    ["rbxassetid://73641371341710"] = {name = "Ice Cube", prices = {["default"] = 6.3, ["Ride"] = 28.54, ["Fly|Ride"] = 54.02, ["Neon"] = 13.13, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 41.88, ["Neon|Fly|Ride"] = 135.27, ["Mega"] = 104.98, ["Mega|Ride"] = 422.66, ["Mega|Fly|Ride"] = 266.48}},
    ["rbxassetid://13077767764"] = {name = "Eel", prices = {["default"] = 2.52, ["Neon"] = 21, ["Neon|Ride"] = 313.69, ["Mega"] = 278.64, ["Mega|Ride"] = 986.88}},
    ["rbxassetid://134995672989153"] = {name = "Hammerhead Shark", prices = {["default"] = 3.14, ["Fly"] = 58.16, ["Ride"] = 34.13, ["Neon"] = 20.1, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 207.18, ["Mega"] = 92.06, ["Mega|Fly"] = 422.66, ["Mega|Ride"] = 134.19, ["Mega|Fly|Ride"] = 348.48}},
    ["rbxassetid://15555939727"] = {name = "Snow Monkey", prices = {["default"] = 170.63, ["Fly"] = 354.9, ["Ride"] = 242.82, ["Fly|Ride"] = 352.88, ["Neon"] = 656.25, ["Neon|Ride"] = 721.88, ["Neon|Fly|Ride"] = 929.6, ["Mega|Ride"] = 5071.69, ["Mega|Fly|Ride"] = 1678.69}},
    ["rbxassetid://11758575992"] = {name = "Water Rabbit", prices = {["default"] = 22.3, ["Fly"] = 61.62, ["Ride"] = 99.32, ["Fly|Ride"] = 109.89, ["Neon"] = 150.94, ["Neon|Fly|Ride"] = 282.13, ["Mega"] = 687.86, ["Mega|Ride"] = 721.67, ["Mega|Fly|Ride"] = 759.84}},
    ["rbxassetid://90987982535884"] = {name = "Great Pyrenees", prices = {["default"] = 30.19, ["Ride"] = 88.07, ["Fly|Ride"] = 1267.77, ["Neon"] = 103.69, ["Neon|Ride"] = 133.88, ["Neon|Fly|Ride"] = 273.6, ["Mega"] = 703.7, ["Mega|Ride"] = 427.88, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://84560154336174"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Fly"] = 44.63, ["Ride"] = 19.69, ["Neon"] = 4.24, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 35.44, ["Mega"] = 31.71, ["Mega|Ride"] = 71.97, ["Mega|Fly|Ride"] = 261.19}},
    ["rbxassetid://4506847061"] = {name = "Reindeer", prices = {["default"] = 95.82, ["Fly"] = 99.86, ["Ride"] = 118.64, ["Fly|Ride"] = 208.69, ["Neon"] = 315, ["Neon|Fly"] = 471.78, ["Neon|Ride"] = 368.67, ["Neon|Fly|Ride"] = 419.14, ["Mega|Fly|Ride"] = 1083.93}},
    ["rbxassetid://98687388677942"] = {name = "Moonpine", prices = {["default"] = 2.1, ["Ride"] = 20.09, ["Neon"] = 6.15, ["Neon|Ride"] = 57.06, ["Neon|Fly|Ride"] = 588, ["Mega"] = 42.29}},
    ["rbxassetid://11109032702"] = {name = "Green Amazon", prices = {["default"] = 36.99, ["Fly"] = 141.57, ["Ride"] = 31.4, ["Fly|Ride"] = 124.68, ["Neon"] = 57.06, ["Neon|Ride"] = 109.88, ["Neon|Fly|Ride"] = 140.44, ["Mega"] = 380.63, ["Mega|Ride"] = 388.85, ["Mega|Fly|Ride"] = 384.44}},
    ["rbxassetid://3743730108"] = {name = "Black Panther", prices = {["default"] = 51.11, ["Fly"] = 80.01, ["Ride"] = 85.32, ["Fly|Ride"] = 141.58, ["Neon"] = 239.46, ["Neon|Ride"] = 238.87, ["Neon|Fly|Ride"] = 334.69, ["Mega|Ride"] = 1232.01, ["Mega|Fly|Ride"] = 1134}},
    ["rbxassetid://3181727398"] = {name = "Chocolate Labrador", prices = {["default"] = 2.1, ["Fly"] = 28.88, ["Ride"] = 16.91, ["Fly|Ride"] = 37, ["Neon"] = 2.63, ["Neon|Fly"] = 28.2, ["Neon|Ride"] = 15.86, ["Neon|Fly|Ride"] = 36.98, ["Mega"] = 24.31, ["Mega|Fly"] = 55.13, ["Mega|Ride"] = 34.13, ["Mega|Fly|Ride"] = 84}},
    ["rbxassetid://134636987874448"] = {name = "Nebula Snake", prices = {["default"] = 3.94, ["Ride"] = 32.18, ["Fly|Ride"] = 1346.59, ["Neon"] = 37, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 144.38, ["Mega|Ride"] = 281.54, ["Mega|Fly|Ride"] = 523.69}},
    ["rbxassetid://13104122150"] = {name = "Hippo", prices = {["default"] = 19.69, ["Ride"] = 85.32, ["Neon"] = 180.83, ["Neon|Fly"] = 196.88, ["Neon|Ride"] = 211.31, ["Neon|Fly|Ride"] = 626.98, ["Mega"] = 700.54, ["Mega|Ride"] = 648.77, ["Mega|Fly|Ride"] = 625.45}},
    ["rbxassetid://103821295208934"] = {name = "Black Rhino", prices = {["default"] = 2.1, ["Ride"] = 26.76, ["Neon"] = 2.63, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 137.38, ["Mega"] = 28.35, ["Mega|Ride"] = 78.65}},
    ["rbxassetid://14782580070"] = {name = "Undead Elk", prices = {["default"] = 10.42, ["Fly"] = 210, ["Ride"] = 28.54, ["Fly|Ride"] = 111.57, ["Neon"] = 49.91, ["Neon|Ride"] = 126.79, ["Neon|Fly|Ride"] = 215.56, ["Mega"] = 408.92, ["Mega|Fly"] = 787.5, ["Mega|Ride"] = 249.37, ["Mega|Fly|Ride"] = 377.56}},
    ["rbxassetid://8566683782"] = {name = "Giant Blue Scarab", prices = {["default"] = 34.06, ["Fly"] = 42.27, ["Ride"] = 28.54, ["Fly|Ride"] = 63.41, ["Neon"] = 117.03, ["Neon|Ride"] = 64.56, ["Neon|Fly|Ride"] = 328.13, ["Mega|Ride"] = 441.68, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://14850232913"] = {name = "Cute-A-Cabra", prices = {["default"] = 7.88, ["Ride"] = 83.27, ["Neon"] = 35.1, ["Neon|Fly"] = 699.57, ["Neon|Ride"] = 73.97, ["Mega"] = 169.32, ["Mega|Ride"] = 162.79, ["Mega|Fly|Ride"] = 293.71}},
    ["rbxassetid://15508248825"] = {name = "Eggnog Dog", prices = {["default"] = 19.59, ["Fly"] = 2112.7, ["Ride"] = 101.26, ["Neon"] = 100.32, ["Neon|Fly|Ride"] = 422.66, ["Mega"] = 459.12, ["Mega|Ride"] = 479.72, ["Mega|Fly|Ride"] = 981.1}},
    ["rbxassetid://17822797244"] = {name = "Orange Betta Fish", prices = {["default"] = 2.63, ["Ride"] = 125.58, ["Fly|Ride"] = 141.58, ["Neon"] = 4.04, ["Neon|Fly"] = 49.67, ["Neon|Ride"] = 99.32, ["Neon|Fly|Ride"] = 99.08, ["Mega"] = 74.82, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 180.7, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://9922274393"] = {name = "Retired Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://103431939950304"] = {name = "Pink Dog", prices = {["default"] = 2.1, ["Neon"] = 7.88, ["Neon|Ride"] = 31.5, ["Mega"] = 21, ["Mega|Ride"] = 137.76, ["Mega|Fly|Ride"] = 313.43}},
    ["rbxassetid://15227882502"] = {name = "Christmas Future Egg", prices = {["default"] = 42.27}},
    ["rbxassetid://12597276740"] = {name = "Red Sand Dollar", prices = {["default"] = 63.4, ["Fly"] = 102.38, ["Ride"] = 65.63, ["Fly|Ride"] = 206.04, ["Neon"] = 1050, ["Neon|Ride"] = 247.24, ["Neon|Fly|Ride"] = 1056.61, ["Mega|Ride"] = 984.76, ["Mega|Fly|Ride"] = 889.88}},
    ["rbxassetid://136447612467002"] = {name = "Glyptodon Ducky", prices = {["default"] = 2.1, ["Ride"] = 81.38, ["Fly|Ride"] = 105, ["Neon"] = 3.29, ["Mega"] = 18.99, ["Mega|Fly"] = 137.82, ["Mega|Ride"] = 105.68, ["Mega|Fly|Ride"] = 116.82}},
    ["rbxassetid://101033810950061"] = {name = "Sea Slug", prices = {["default"] = 469.6, ["Ride"] = 570.92, ["Fly|Ride"] = 626.96, ["Neon"] = 2625, ["Neon|Ride"] = 1968.75, ["Neon|Fly|Ride"] = 2395.33, ["Mega"] = 8452.8, ["Mega|Fly|Ride"] = 10564.72}},
    ["rbxassetid://14353536658"] = {name = "Birthday Butterfly 2023", prices = {["default"] = 6.57, ["Fly"] = 26.17, ["Ride"] = 42.27, ["Fly|Ride"] = 76.08, ["Neon"] = 32.82, ["Neon|Fly"] = 704.68, ["Neon|Ride"] = 104.61, ["Mega"] = 84.55, ["Mega|Ride"] = 141.6, ["Mega|Fly|Ride"] = 563.75}},
    ["rbxassetid://9938967851"] = {name = "Tan Chow-Chow", prices = {["default"] = 2.1, ["Fly"] = 157.33, ["Ride"] = 23.25, ["Fly|Ride"] = 52.5, ["Neon"] = 26.25, ["Neon|Ride"] = 33.91, ["Neon|Fly|Ride"] = 86.9, ["Mega"] = 282.13, ["Mega|Ride"] = 158.05, ["Mega|Fly|Ride"] = 187.69}},
    ["rbxassetid://14448124117"] = {name = "Chipmunk", prices = {["default"] = 28.54, ["Ride"] = 54.95, ["Fly|Ride"] = 106.32, ["Neon"] = 117.03, ["Neon|Ride"] = 181.13, ["Mega"] = 1087.26, ["Mega|Fly|Ride"] = 1056.48}},
    ["rbxassetid://13104108894"] = {name = "Lammergeier", prices = {["default"] = 3.29, ["Fly"] = 39.38, ["Ride"] = 44.63, ["Fly|Ride"] = 141.58, ["Mega"] = 293.74}},
    ["rbxassetid://14446659851"] = {name = "Raccoon", prices = {["default"] = 10.5, ["Ride"] = 126.79, ["Fly|Ride"] = 157.5, ["Neon"] = 144.38, ["Neon|Ride"] = 229.17, ["Neon|Fly|Ride"] = 350.44, ["Mega|Ride"] = 375.86, ["Mega|Fly|Ride"] = 392.44}},
    ["rbxassetid://84477079324217"] = {name = "Peachick", prices = {["default"] = 13.13, ["Fly"] = 97.64, ["Ride"] = 31.7, ["Fly|Ride"] = 787.5, ["Neon"] = 42, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 284.82, ["Mega"] = 228.09, ["Mega|Fly"] = 488.17, ["Mega|Ride"] = 195.57, ["Mega|Fly|Ride"] = 311.68}},
    ["rbxassetid://9718162456"] = {name = "Donkey", prices = {["default"] = 2.1, ["Fly"] = 27.48, ["Ride"] = 15.86, ["Fly|Ride"] = 39.29, ["Neon"] = 2.1, ["Neon|Fly"] = 28.54, ["Neon|Ride"] = 20.09, ["Neon|Fly|Ride"] = 59.07, ["Mega"] = 16.42, ["Mega|Fly"] = 78.68, ["Mega|Ride"] = 39.38, ["Mega|Fly|Ride"] = 91.88}},
    ["rbxassetid://93800993117604"] = {name = "Love Bird", prices = {["default"] = 9.19, ["Ride"] = 32.82, ["Fly|Ride"] = 157.94, ["Neon"] = 45.45, ["Neon|Ride"] = 87.94, ["Neon|Fly|Ride"] = 316.99, ["Mega"] = 167.88, ["Mega|Ride"] = 217.88, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://13665143675"] = {name = "Lion Cub", prices = {["default"] = 261.19, ["Ride"] = 315, ["Fly|Ride"] = 393.75, ["Neon"] = 1480.5, ["Neon|Ride"] = 1181.25, ["Neon|Fly|Ride"] = 2111.09, ["Mega|Fly|Ride"] = 3607.05}},
    ["rbxassetid://13883284001"] = {name = "Ice Cream Hermit Crab", prices = {["default"] = 110.25, ["Fly"] = 156.37, ["Ride"] = 149.63, ["Fly|Ride"] = 7747.11, ["Neon"] = 380.35, ["Neon|Ride"] = 664.53, ["Neon|Fly|Ride"] = 698.25, ["Mega"] = 4226.4, ["Mega|Ride"] = 2113.2, ["Mega|Fly|Ride"] = 1536.69}},
    ["rbxassetid://8938701212"] = {name = "Woodpecker", prices = {["default"] = 2.1, ["Fly"] = 23.25, ["Ride"] = 22.32, ["Fly|Ride"] = 39.34, ["Neon"] = 19.69, ["Neon|Ride"] = 33.53, ["Neon|Fly|Ride"] = 62.67, ["Mega|Fly"] = 210.29, ["Mega|Ride"] = 91.93, ["Mega|Fly|Ride"] = 141.58}},
    ["rbxassetid://4800190034"] = {name = "Toucan", prices = {["default"] = 2.1, ["Fly"] = 23.49, ["Ride"] = 16.92, ["Fly|Ride"] = 36.42, ["Neon"] = 9.19, ["Neon|Fly"] = 31.71, ["Neon|Ride"] = 27.49, ["Neon|Fly|Ride"] = 63.41, ["Mega"] = 73.5, ["Mega|Fly"] = 352.93, ["Mega|Ride"] = 70.81, ["Mega|Fly|Ride"] = 152.25}},
    ["rbxassetid://15886122789"] = {name = "Deathstalker Scorpion", prices = {["default"] = 4.54, ["Ride"] = 22.32, ["Fly|Ride"] = 98.44, ["Neon"] = 39.38, ["Mega"] = 1127.4}},
    ["rbxassetid://12139402705"] = {name = "Sheeeeep", prices = {["default"] = 247.86, ["Ride"] = 275.63, ["Fly|Ride"] = 347.82, ["Neon"] = 1575, ["Neon|Ride"] = 1566.23, ["Neon|Fly|Ride"] = 1789.32, ["Mega|Ride"] = 8452.8, ["Mega|Fly|Ride"] = 3648.75}},
    ["rbxassetid://7126720389"] = {name = "Hydra", prices = {["default"] = 2.45, ["Fly"] = 23.99, ["Ride"] = 19.03, ["Fly|Ride"] = 39.38, ["Neon"] = 17.62, ["Neon|Fly"] = 157.34, ["Neon|Ride"] = 35.44, ["Neon|Fly|Ride"] = 78.73, ["Mega"] = 286.02, ["Mega|Ride"] = 240.92, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://17662289865"] = {name = "Punk Pony", prices = {["default"] = 8.46, ["Fly"] = 140.89, ["Ride"] = 39.93, ["Fly|Ride"] = 211.31, ["Neon"] = 37.58, ["Neon|Ride"] = 35.43, ["Mega"] = 251.35, ["Mega|Ride"] = 236.24, ["Mega|Fly|Ride"] = 417.12}},
    ["rbxassetid://84009422958505"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 91.88, ["Neon"] = 5.25, ["Neon|Ride"] = 30.3, ["Neon|Fly|Ride"] = 141.6, ["Mega"] = 40.69, ["Mega|Ride"] = 95.7, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://9473352533"] = {name = "Space Whale", prices = {["default"] = 23.25, ["Fly"] = 70.8, ["Ride"] = 23, ["Fly|Ride"] = 46.98, ["Neon"] = 87.05, ["Neon|Ride"] = 102.16, ["Neon|Fly|Ride"] = 141.6, ["Mega"] = 761.15, ["Mega|Ride"] = 422.69, ["Mega|Fly|Ride"] = 469.55}},
    ["rbxassetid://71528203783155"] = {name = "Pupcake", prices = {["default"] = 54.32, ["Ride"] = 141.58, ["Fly|Ride"] = 184.9, ["Neon"] = 111.57, ["Neon|Fly"] = 393.75, ["Neon|Ride"] = 168, ["Neon|Fly|Ride"] = 345.43, ["Mega"] = 450.19, ["Mega|Fly"] = 2218.88, ["Mega|Ride"] = 493.79, ["Mega|Fly|Ride"] = 617.13}},
    ["rbxassetid://4440867010"] = {name = "Drake", prices = {["default"] = 28.54, ["Fly"] = 157.33, ["Ride"] = 53.82, ["Fly|Ride"] = 141.58, ["Neon"] = 131.25, ["Neon|Fly"] = 290.07, ["Neon|Ride"] = 145.53, ["Neon|Fly|Ride"] = 219.19, ["Mega|Ride"] = 783.12, ["Mega|Fly|Ride"] = 939.09}},
    ["rbxassetid://9708962205"] = {name = "Parakeet", prices = {["default"] = 2.1, ["Fly"] = 15.91, ["Ride"] = 18.8, ["Fly|Ride"] = 51.44, ["Neon"] = 2.1, ["Neon|Fly"] = 23.55, ["Neon|Ride"] = 21.14, ["Neon|Fly|Ride"] = 63, ["Mega"] = 21.15, ["Mega|Fly"] = 45.94, ["Mega|Ride"] = 70.81, ["Mega|Fly|Ride"] = 115.5}},
    ["rbxassetid://4883302468"] = {name = "Shrew", prices = {["default"] = 194.25, ["Fly"] = 278.24, ["Ride"] = 242.82, ["Fly|Ride"] = 339.94, ["Neon"] = 1127.13, ["Neon|Ride"] = 958.13, ["Neon|Fly|Ride"] = 1059.78, ["Mega|Fly|Ride"] = 3907.91}},
    ["rbxassetid://11507151679"] = {name = "Irish Elk", prices = {["default"] = 14.44, ["Fly"] = 140.39, ["Ride"] = 41.45, ["Neon"] = 111.57, ["Neon|Ride"] = 188.25, ["Neon|Fly|Ride"] = 210, ["Mega"] = 633.97, ["Mega|Fly|Ride"] = 587.35}},
    ["rbxassetid://17163957321"] = {name = "Blue Jay", prices = {["default"] = 2.1, ["Ride"] = 18.38, ["Fly|Ride"] = 59.07, ["Neon"] = 6.57, ["Neon|Ride"] = 31.71, ["Mega"] = 60.24, ["Mega|Ride"] = 99.58, ["Mega|Fly|Ride"] = 298.17}},
    ["rbxassetid://8705079225"] = {name = "Abyssinian Cat", prices = {["default"] = 2.1, ["Fly"] = 25.36, ["Ride"] = 46.98, ["Fly|Ride"] = 70.82, ["Neon"] = 3.71, ["Neon|Fly"] = 46.98, ["Neon|Ride"] = 21.29, ["Neon|Fly|Ride"] = 97.23, ["Mega"] = 21.15, ["Mega|Fly"] = 140.9, ["Mega|Ride"] = 43.32, ["Mega|Fly|Ride"] = 117.41}},
    ["rbxassetid://17059483392"] = {name = "Velociraptor", prices = {["default"] = 2.1, ["Ride"] = 22.32, ["Fly|Ride"] = 90.87, ["Neon"] = 6.56, ["Neon|Ride"] = 42.27, ["Neon|Fly|Ride"] = 65.52, ["Mega"] = 92.93, ["Mega|Ride"] = 174.57, ["Mega|Fly|Ride"] = 352.88}},
    ["rbxassetid://16548686870"] = {name = "Hamster", prices = {["default"] = 14.11, ["Fly"] = 65.63, ["Ride"] = 22.32, ["Fly|Ride"] = 68.25, ["Neon"] = 39.37, ["Neon|Ride"] = 62.91, ["Neon|Fly|Ride"] = 106.95, ["Mega"] = 502.52, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 381.44}},
    ["rbxassetid://13883285383"] = {name = "Castle Hermit Crab", prices = {["default"] = 7.87, ["Ride"] = 31.71, ["Neon"] = 52.84, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 210, ["Mega|Ride"] = 299.41}},
    ["rbxassetid://82240382561696"] = {name = "Cocoadile", prices = {["default"] = 2.1, ["Ride"] = 61.06, ["Neon"] = 3.7, ["Neon|Ride"] = 31.71, ["Mega"] = 23.63, ["Mega|Ride"] = 78.21, ["Mega|Fly|Ride"] = 282.1}},
    ["rbxassetid://74702714943302"] = {name = "Grave Owl", prices = {["default"] = 12.93, ["Ride"] = 35.44, ["Fly|Ride"] = 84.53, ["Neon"] = 31.71, ["Neon|Fly"] = 102.92, ["Neon|Ride"] = 42.15, ["Neon|Fly|Ride"] = 123.38, ["Mega"] = 150.48, ["Mega|Ride"] = 264.16, ["Mega|Fly|Ride"] = 283.4}},
    ["rbxassetid://97556530589327"] = {name = "Bison", prices = {["default"] = 2.1, ["Ride"] = 126.79, ["Fly|Ride"] = 99.32, ["Neon"] = 8.46, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 157.35, ["Mega"] = 34.12, ["Mega|Ride"] = 91.34, ["Mega|Fly|Ride"] = 626.84}},
    ["rbxassetid://11694855214"] = {name = "Shetland Pony Dark Brown", prices = {["default"] = 2.1, ["Fly"] = 24.63, ["Ride"] = 18.38, ["Fly|Ride"] = 52.5, ["Neon"] = 6.08, ["Neon|Ride"] = 25.36, ["Neon|Fly|Ride"] = 117.6, ["Mega"] = 65.63, ["Mega|Ride"] = 73.83, ["Mega|Fly|Ride"] = 150.94}},
    ["rbxassetid://14398823196"] = {name = "Alpaca", prices = {["default"] = 735, ["Ride"] = 787.5, ["Fly|Ride"] = 1050, ["Neon|Fly|Ride"] = 4222.18, ["Mega|Fly|Ride"] = 15809.38}},
    ["rbxassetid://5721843716"] = {name = "Pterodactyl", prices = {["default"] = 2.1, ["Fly"] = 22.33, ["Ride"] = 15.75, ["Fly|Ride"] = 32.8, ["Neon"] = 15.81, ["Neon|Fly"] = 44.61, ["Neon|Ride"] = 57.06, ["Neon|Fly|Ride"] = 56.59, ["Mega"] = 189.15, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://82057257613990"] = {name = "Unicorn Ducky", prices = {["default"] = 3.94, ["Ride"] = 54.02, ["Fly|Ride"] = 132.57, ["Neon"] = 14.11, ["Neon|Ride"] = 84, ["Neon|Fly|Ride"] = 341.25, ["Mega"] = 49.09, ["Mega|Ride"] = 106.21, ["Mega|Fly|Ride"] = 222.48}},
    ["rbxassetid://4708551366"] = {name = "Frog", prices = {["default"] = 73.5, ["Ride"] = 28.54, ["Fly|Ride"] = 46.98, ["Neon"] = 44.63, ["Neon|Fly"] = 112.74, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 116.82, ["Mega"] = 328.13, ["Mega|Ride"] = 291.89, ["Mega|Fly|Ride"] = 325.34}},
    ["rbxassetid://4800189682"] = {name = "Starfish", prices = {["default"] = 2.1, ["Fly"] = 28.54, ["Ride"] = 17.62, ["Fly|Ride"] = 42.27, ["Neon"] = 11.64, ["Neon|Fly"] = 87.93, ["Neon|Ride"] = 22.23, ["Neon|Fly|Ride"] = 61.95, ["Mega"] = 78.75, ["Mega|Fly"] = 349.84, ["Mega|Ride"] = 99.75, ["Mega|Fly|Ride"] = 234.15}},
    ["rbxassetid://16736753854"] = {name = "Candy Cane Snail", prices = {["default"] = 66.86, ["Neon"] = 311.68, ["Neon|Ride"] = 341.25, ["Mega"] = 896.44, ["Mega|Fly|Ride"] = 986.75}},
    ["rbxassetid://10393730410"] = {name = "Orca", prices = {["default"] = 2.1, ["Ride"] = 37, ["Fly|Ride"] = 704.68, ["Neon"] = 6.57, ["Neon|Ride"] = 35.23, ["Neon|Fly|Ride"] = 206.07, ["Mega"] = 86.9, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 354.38}},
    ["rbxassetid://111642509798043"] = {name = "Toxic Kaijunior", prices = {["default"] = 3.94, ["Fly"] = 73.5, ["Ride"] = 22.32, ["Fly|Ride"] = 61.29, ["Neon"] = 13.09, ["Neon|Fly"] = 140.9, ["Neon|Ride"] = 42.27, ["Neon|Fly|Ride"] = 452.24, ["Mega"] = 140.9, ["Mega|Ride"] = 344.46, ["Mega|Fly|Ride"] = 144.38}},
    ["rbxassetid://14146181621"] = {name = "Tawny Frogmouth", prices = {["default"] = 2.1, ["Fly|Ride"] = 65.85, ["Neon"] = 15.72, ["Mega"] = 113.07}},
    ["rbxassetid://9474010501"] = {name = "Ribbon Seal", prices = {["default"] = 2.1, ["Fly"] = 2593.49, ["Ride"] = 20.96, ["Fly|Ride"] = 98.44, ["Neon"] = 3.94, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 94.5, ["Mega"] = 54.02, ["Mega|Fly"] = 156.39, ["Mega|Ride"] = 63.41, ["Mega|Fly|Ride"] = 127.16}},
    ["rbxassetid://6776872152"] = {name = "Red Squirrel", prices = {["default"] = 17.04, ["Fly"] = 37.58, ["Ride"] = 21, ["Fly|Ride"] = 42, ["Neon"] = 137.82, ["Neon|Ride"] = 113.06, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 845.3, ["Mega|Ride"] = 527.25, ["Mega|Fly|Ride"] = 443.73}},
    ["rbxassetid://84140820920420"] = {name = "Siamese Cat", prices = {["default"] = 721.88, ["Ride"] = 714, ["Fly|Ride"] = 903.67, ["Neon"] = 2099.99, ["Neon|Ride"] = 2193.17, ["Neon|Fly|Ride"] = 1994.88, ["Mega|Ride"] = 4987.5, ["Mega|Fly|Ride"] = 4912.84}},
    ["rbxassetid://3181727773"] = {name = "Bunny", prices = {["default"] = 2.1, ["Fly"] = 68.25, ["Ride"] = 19.03, ["Fly|Ride"] = 39.26, ["Neon"] = 3.94, ["Neon|Fly"] = 28.35, ["Neon|Ride"] = 23.49, ["Neon|Fly|Ride"] = 81.38, ["Mega"] = 52.5, ["Mega|Ride"] = 77.44, ["Mega|Fly|Ride"] = 140.44}},
    ["rbxassetid://17120012859"] = {name = "Praying Mantis", prices = {["default"] = 8.46, ["Ride"] = 37, ["Fly|Ride"] = 92.18, ["Neon"] = 52.5, ["Neon|Ride"] = 57.75, ["Neon|Fly|Ride"] = 248.11, ["Mega"] = 141.6, ["Mega|Ride"] = 351.75, ["Mega|Fly|Ride"] = 441}},
    ["rbxassetid://4440866528"] = {name = "Turkey", prices = {["default"] = 68.1, ["Ride"] = 72.19, ["Fly|Ride"] = 126.75, ["Neon|Ride"] = 564.17, ["Neon|Fly|Ride"] = 831.55, ["Mega"] = 1833.25, ["Mega|Fly|Ride"] = 2231.25}},
    ["rbxassetid://9287841987"] = {name = "Black Springer Spaniel", prices = {["default"] = 54.95, ["Fly"] = 141.58, ["Ride"] = 90.57, ["Fly|Ride"] = 71.01, ["Neon"] = 196.88, ["Neon|Ride"] = 185.95, ["Neon|Fly|Ride"] = 268.38, ["Mega"] = 919.26, ["Mega|Ride"] = 892.32, ["Mega|Fly|Ride"] = 986.75}},
    ["rbxassetid://87613898139280"] = {name = "Ranger Beaver", prices = {["default"] = 28.54, ["Ride"] = 131.25, ["Neon"] = 78.68, ["Neon|Ride"] = 169.04, ["Neon|Fly|Ride"] = 407.42, ["Mega"] = 418.43, ["Mega|Ride"] = 412.1}},
    ["rbxassetid://88389663444803"] = {name = "Mirai Moth", prices = {["default"] = 63.4, ["Ride"] = 141.58, ["Neon"] = 126.79, ["Neon|Fly"] = 157.34, ["Neon|Ride"] = 360.45, ["Mega"] = 313.5, ["Mega|Ride"] = 283.5, ["Mega|Fly|Ride"] = 523.04}},
    ["rbxassetid://128469688002747"] = {name = "Moonlight Moth", prices = {["default"] = 30.19, ["Fly"] = 113.06, ["Ride"] = 315, ["Neon"] = 131.25, ["Neon|Ride"] = 156.37, ["Neon|Fly|Ride"] = 525, ["Mega"] = 1050, ["Mega|Ride"] = 618.76, ["Mega|Fly|Ride"] = 840.67}},
    ["rbxassetid://13936753561"] = {name = "Dylan", prices = {["default"] = 26.25}},
    ["rbxassetid://10606175827"] = {name = "Koi Carp", prices = {["default"] = 9.19, ["Fly"] = 78.67, ["Ride"] = 31.71, ["Fly|Ride"] = 105, ["Neon"] = 57.06, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 169.08, ["Mega"] = 184.12, ["Mega|Ride"] = 216.57, ["Mega|Fly|Ride"] = 422.6}},
    ["rbxassetid://84529929751558"] = {name = "Old King Coal", prices = {["default"] = 3.6, ["Ride"] = 99.32, ["Neon"] = 27.57, ["Mega"] = 282.13, ["Mega|Fly|Ride"] = 950.84}},
    ["rbxassetid://11706110842"] = {name = "Snowball Pet", prices = {["default"] = 70.8, ["Fly"] = 83.91, ["Ride"] = 63.4, ["Fly|Ride"] = 105, ["Neon"] = 189, ["Neon|Ride"] = 291.38, ["Neon|Fly|Ride"] = 420.55, ["Mega|Ride"] = 878.07, ["Mega|Fly|Ride"] = 813.75}},
    ["rbxassetid://6404812664"] = {name = "Ladybug", prices = {["default"] = 3.94, ["Fly"] = 26.25, ["Ride"] = 19.57, ["Fly|Ride"] = 42, ["Neon"] = 28.53, ["Neon|Fly"] = 61.27, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 95.82, ["Mega"] = 262.5, ["Mega|Fly"] = 238.81, ["Mega|Ride"] = 258.97, ["Mega|Fly|Ride"] = 224.17}},
    ["rbxassetid://95046891836017"] = {name = "Clover Cow", prices = {["default"] = 7.88, ["Fly"] = 84.52, ["Ride"] = 31.7, ["Fly|Ride"] = 141.58, ["Neon"] = 30.19, ["Neon|Ride"] = 50.67, ["Neon|Fly|Ride"] = 116.41, ["Mega"] = 130.39, ["Mega|Fly"] = 301.45, ["Mega|Ride"] = 172.66, ["Mega|Fly|Ride"] = 252.45}},
    ["rbxassetid://123759251940984"] = {name = "Oakee Knight", prices = {["default"] = 2.1, ["Neon"] = 6.57, ["Neon|Ride"] = 200.79, ["Mega"] = 34.13, ["Mega|Ride"] = 203.44, ["Mega|Fly|Ride"] = 192.29}},
    ["rbxassetid://9287842106"] = {name = "Brown Springer Spaniel", prices = {["default"] = 59.16, ["Fly"] = 148.32, ["Ride"] = 59.07, ["Fly|Ride"] = 85.32, ["Neon"] = 177.3, ["Neon|Ride"] = 239.84, ["Neon|Fly|Ride"] = 316.99, ["Mega"] = 845.3, ["Mega|Ride"] = 840, ["Mega|Fly|Ride"] = 896.1}},
    ["rbxassetid://83890934284839"] = {name = "Zeopod", prices = {["default"] = 2.1, ["Fly|Ride"] = 141.58, ["Neon"] = 9.4, ["Neon|Fly|Ride"] = 298.24, ["Mega"] = 141.6, ["Mega|Fly|Ride"] = 286.42}},
    ["rbxassetid://107096792267421"] = {name = "General Sheepdog", prices = {["default"] = 13.13, ["Ride"] = 160.13, ["Neon"] = 313.49, ["Neon|Ride"] = 99.32, ["Neon|Fly|Ride"] = 295.86, ["Mega"] = 313.5, ["Mega|Ride"] = 465.97, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://5721844511"] = {name = "Woolly Mammoth", prices = {["default"] = 2.1, ["Fly"] = 23.63, ["Ride"] = 18.88, ["Fly|Ride"] = 47.24, ["Neon"] = 18.62, ["Neon|Ride"] = 40.27, ["Neon|Fly|Ride"] = 91.91, ["Mega"] = 173.78, ["Mega|Ride"] = 196.23, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://8143039445"] = {name = "Summer Walrus", prices = {["default"] = 3.52, ["Fly"] = 52.5, ["Ride"] = 19.69, ["Fly|Ride"] = 49.88, ["Neon"] = 61.26, ["Neon|Ride"] = 244.06, ["Mega"] = 282.13, ["Mega|Ride"] = 184.93, ["Mega|Fly|Ride"] = 418.04}},
    ["rbxassetid://136696735147963"] = {name = "Chilling Spider", prices = {["default"] = 5.64, ["Ride"] = 139.47, ["Neon"] = 10.47, ["Neon|Ride"] = 110.37, ["Mega"] = 141.6, ["Mega|Ride"] = 557.17}},
    ["rbxassetid://133768672320906"] = {name = "Catte", prices = {["default"] = 47.25, ["Ride"] = 112.09, ["Fly|Ride"] = 211.31, ["Neon"] = 182.44, ["Neon|Ride"] = 316.96, ["Mega"] = 918.75, ["Mega|Ride"] = 986.88, ["Mega|Fly|Ride"] = 969.56}},
    ["rbxassetid://12139319231"] = {name = "Feesh", prices = {["default"] = 28.54, ["Ride"] = 281.6, ["Neon"] = 141.58, ["Mega"] = 516.05}},
    ["rbxassetid://13685039170"] = {name = "Lobster", prices = {["default"] = 11.43, ["Ride"] = 105, ["Neon"] = 110.37, ["Mega"] = 581.18, ["Mega|Ride"] = 556.85, ["Mega|Fly|Ride"] = 1690.37}},
    ["rbxassetid://87668315398037"] = {name = "Mecha R4BBIT", prices = {["default"] = 28.54, ["Ride"] = 76.27, ["Fly|Ride"] = 141.58, ["Neon"] = 465.92, ["Neon|Ride"] = 633.9, ["Neon|Fly|Ride"] = 573.57, ["Mega"] = 945, ["Mega|Ride"] = 781.95, ["Mega|Fly|Ride"] = 941.73}},
    ["rbxassetid://120262676323297"] = {name = "Kelp Hunter", prices = {["default"] = 3.75, ["Ride"] = 21.14, ["Neon"] = 42.81, ["Neon|Ride"] = 422.6, ["Mega"] = 282.13, ["Mega|Fly|Ride"] = 313.43}},
    ["rbxassetid://12403864254"] = {name = "Gorilla", prices = {["default"] = 2.1, ["Fly"] = 26.24, ["Ride"] = 17.71, ["Fly|Ride"] = 52.5, ["Neon"] = 15.86, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 32.76, ["Neon|Fly|Ride"] = 137.82, ["Mega"] = 69.76, ["Mega|Ride"] = 89.25, ["Mega|Fly|Ride"] = 259.88}},
    ["rbxassetid://124908510040897"] = {name = "Mistletroll", prices = {["default"] = 2.63, ["Ride"] = 47.66, ["Fly|Ride"] = 91.92, ["Neon"] = 42, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 144.38, ["Mega|Ride"] = 320.17}},
    ["rbxassetid://11189235896"] = {name = "Persian Cat", prices = {["default"] = 2.1, ["Fly"] = 32.75, ["Ride"] = 23.63, ["Fly|Ride"] = 55.13, ["Neon"] = 5.92, ["Neon|Ride"] = 26.51, ["Neon|Fly|Ride"] = 90.88, ["Mega"] = 44.44, ["Mega|Ride"] = 84.55, ["Mega|Fly|Ride"] = 196.05}},
    ["rbxassetid://14457148635"] = {name = "Magma Snail", prices = {["default"] = 2.1, ["Ride"] = 63.41, ["Fly|Ride"] = 42.27, ["Neon"] = 35.44, ["Neon|Ride"] = 98.44, ["Neon|Fly|Ride"] = 197.6, ["Mega"] = 175.41, ["Mega|Ride"] = 154.88, ["Mega|Fly|Ride"] = 469.55}},
    ["rbxassetid://11694853423"] = {name = "Shetland Pony White", prices = {["default"] = 6.35, ["Ride"] = 28.53, ["Fly|Ride"] = 99.75, ["Neon"] = 42.27, ["Neon|Ride"] = 97.76, ["Neon|Fly|Ride"] = 211.34, ["Mega|Ride"] = 416.8, ["Mega|Fly|Ride"] = 392.09}},
    ["rbxassetid://4621220568"] = {name = "Rat", prices = {["default"] = 6.57, ["Ride"] = 22.14, ["Fly|Ride"] = 56.7, ["Neon"] = 18.38, ["Neon|Fly"] = 105.67, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 105, ["Mega|Ride"] = 252, ["Mega|Fly|Ride"] = 317.94}},
    ["rbxassetid://8938702150"] = {name = "Pine Marten", prices = {["default"] = 2.63, ["Ride"] = 25.36, ["Fly|Ride"] = 63.4, ["Neon"] = 19.03, ["Neon|Fly|Ride"] = 105.68, ["Mega"] = 141.53, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 462.75}},
    ["rbxassetid://120359009390464"] = {name = "Turtle Doves", prices = {["default"] = 3.08, ["Fly"] = 301.88, ["Ride"] = 61.29, ["Neon"] = 18.38, ["Neon|Fly"] = 168.87, ["Neon|Ride"] = 87.94, ["Neon|Fly|Ride"] = 463.78, ["Mega"] = 92.55, ["Mega|Ride"] = 305.82, ["Mega|Fly|Ride"] = 309.75}},
    ["rbxassetid://71032455578324"] = {name = "Chihuahua", prices = {["default"] = 18.38, ["Ride"] = 78.75, ["Fly|Ride"] = 280.88, ["Neon"] = 116.82, ["Neon|Ride"] = 159.93, ["Neon|Fly|Ride"] = 352.86, ["Mega"] = 355.68, ["Mega|Fly"] = 1968.75, ["Mega|Ride"] = 440.9, ["Mega|Fly|Ride"] = 557.88}},
    ["rbxassetid://11505487641"] = {name = "Ram", prices = {["default"] = 70.8, ["Fly"] = 204.28, ["Ride"] = 99.32, ["Fly|Ride"] = 129.94, ["Neon"] = 249.38, ["Neon|Ride"] = 269.07, ["Neon|Fly|Ride"] = 346.5, ["Mega"] = 1050, ["Mega|Ride"] = 853.13, ["Mega|Fly|Ride"] = 975.19}},
    ["rbxassetid://117821626163847"] = {name = "Chanekeh", prices = {["default"] = 2.1, ["Ride"] = 25.51, ["Fly|Ride"] = 65.54, ["Neon"] = 3.93, ["Neon|Ride"] = 37.95, ["Neon|Fly|Ride"] = 58.35, ["Mega"] = 31.5, ["Mega|Ride"] = 71.14, ["Mega|Fly|Ride"] = 115.55}},
    ["rbxassetid://14266737982"] = {name = "Cassowary", prices = {["default"] = 11.02, ["Ride"] = 350.77, ["Neon"] = 281.59, ["Mega"] = 1043.93, ["Mega|Ride"] = 517.78, ["Mega|Fly|Ride"] = 1267.77}},
    ["rbxassetid://13693650831"] = {name = "Leopard Shark", prices = {["default"] = 45.94, ["Ride"] = 126.73, ["Neon"] = 211.95, ["Neon|Ride"] = 341.25, ["Mega"] = 1092.54, ["Mega|Ride"] = 1973.74, ["Mega|Fly|Ride"] = 1263.55}},
    ["rbxassetid://100909868233186"] = {name = "Kappakid", prices = {["default"] = 15.86, ["Fly"] = 190.32, ["Ride"] = 36.75, ["Fly|Ride"] = 126, ["Neon"] = 62.35, ["Neon|Ride"] = 77.44, ["Mega"] = 133.49, ["Mega|Ride"] = 249.38, ["Mega|Fly|Ride"] = 393.1}},
    ["rbxassetid://127061844219486"] = {name = "Patchy Bear", prices = {["default"] = 2.1, ["Fly"] = 157.5, ["Ride"] = 31.7, ["Fly|Ride"] = 84.79, ["Neon"] = 4.99, ["Neon|Ride"] = 27.5, ["Neon|Fly|Ride"] = 42.29, ["Mega"] = 30.19, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 54.75, ["Mega|Fly|Ride"] = 155.66}},
    ["rbxassetid://6998402749"] = {name = "Merhorse", prices = {["default"] = 3.94, ["Fly"] = 39.38, ["Ride"] = 23.49, ["Fly|Ride"] = 70.8, ["Neon"] = 19.69, ["Neon|Ride"] = 40.69, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 211.34, ["Mega|Fly"] = 352.93, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 231}},
    ["rbxassetid://3181727196"] = {name = "Beaver", prices = {["default"] = 2.1, ["Fly"] = 23.25, ["Ride"] = 20.09, ["Fly|Ride"] = 35.44, ["Neon"] = 3.94, ["Neon|Ride"] = 27.02, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 34.13, ["Mega|Ride"] = 68.08, ["Mega|Fly|Ride"] = 111.57}},
    ["rbxassetid://10377935981"] = {name = "Badger", prices = {["default"] = 2.1, ["Ride"] = 18.36, ["Fly|Ride"] = 65.7, ["Neon"] = 5.25, ["Neon|Ride"] = 37, ["Neon|Fly|Ride"] = 84, ["Mega"] = 40.69, ["Mega|Fly"] = 168, ["Mega|Ride"] = 45.94, ["Mega|Fly|Ride"] = 178.5}},
    ["rbxassetid://118143096743818"] = {name = "Granny Wolf", prices = {["default"] = 2.1, ["Ride"] = 52.5, ["Neon"] = 2.62, ["Neon|Ride"] = 157.34, ["Neon|Fly|Ride"] = 78.68, ["Mega"] = 21.8, ["Mega|Ride"] = 105.68, ["Mega|Fly|Ride"] = 259.91}},
    ["rbxassetid://18819382634"] = {name = "Singularity Beetle", prices = {["default"] = 4.36, ["Ride"] = 157.5, ["Fly|Ride"] = 359.22, ["Neon"] = 43.32, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 209.22, ["Mega"] = 197.6, ["Mega|Ride"] = 314.88, ["Mega|Fly|Ride"] = 1127.27}},
    ["rbxassetid://13664716167"] = {name = "Ostrich", prices = {["default"] = 21.14, ["Ride"] = 34.13, ["Neon"] = 124.43, ["Neon|Ride"] = 200.82, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 387.72, ["Mega|Ride"] = 421.6, ["Mega|Fly|Ride"] = 507.12}},
    ["rbxassetid://3710822879"] = {name = "Penguin", prices = {["default"] = 8.46, ["Fly"] = 22.32, ["Ride"] = 21.14, ["Fly|Ride"] = 47.12, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 52.85, ["Neon|Fly|Ride"] = 78.73, ["Mega|Ride"] = 334.69, ["Mega|Fly|Ride"] = 393.64}},
    ["rbxassetid://12778628745"] = {name = "Chef Gorilla", prices = {["default"] = 79.98, ["Ride"] = 144.38, ["Fly|Ride"] = 262.5, ["Neon"] = 538.13, ["Neon|Ride"] = 888.57, ["Mega"] = 3131.28, ["Mega|Fly|Ride"] = 1554.09}},
    ["rbxassetid://138841259551372"] = {name = "Vermilion Butterfly", prices = {["default"] = 18.36, ["Fly"] = 72.43, ["Ride"] = 65.63, ["Fly|Ride"] = 70.8, ["Neon"] = 103.69, ["Mega"] = 617.53, ["Mega|Fly"] = 648.77, ["Mega|Ride"] = 603.75, ["Mega|Fly|Ride"] = 1029.67}},
    ["rbxassetid://3181727125"] = {name = "Snow Puma", prices = {["default"] = 2.1, ["Fly"] = 17.93, ["Ride"] = 19.03, ["Fly|Ride"] = 26.25, ["Neon"] = 4.71, ["Neon|Fly"] = 33.81, ["Neon|Ride"] = 21.14, ["Neon|Fly|Ride"] = 69.28, ["Mega"] = 58.72, ["Mega|Ride"] = 131.03, ["Mega|Fly|Ride"] = 144.38}},
    ["rbxassetid://3181728160"] = {name = "Shiba Inu", prices = {["default"] = 2.1, ["Fly"] = 23.63, ["Ride"] = 16.14, ["Fly|Ride"] = 32.55, ["Neon"] = 3.82, ["Neon|Fly"] = 22.91, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 49.67, ["Mega|Ride"] = 52.5, ["Mega|Fly|Ride"] = 86.63}},
    ["rbxassetid://3261465893"] = {name = "Blue Dog", prices = {["default"] = 349.19, ["Ride"] = 397.43, ["Fly|Ride"] = 441.79, ["Neon|Fly|Ride"] = 1522.5}},
    ["rbxassetid://15504846154"] = {name = "Eggnog Hare", prices = {["default"] = 17.07, ["Fly|Ride"] = 89.25, ["Neon"] = 103.42, ["Neon|Ride"] = 120.46, ["Neon|Fly|Ride"] = 282.13, ["Mega"] = 564.24, ["Mega|Ride"] = 426.57, ["Mega|Fly|Ride"] = 1000.5}},
    ["rbxassetid://4708551244"] = {name = "Dingo", prices = {["default"] = 2.1, ["Fly"] = 27.12, ["Ride"] = 18.38, ["Fly|Ride"] = 32.76, ["Neon"] = 5.8, ["Neon|Fly"] = 28.61, ["Neon|Ride"] = 21.14, ["Neon|Fly|Ride"] = 42.29, ["Mega"] = 42.18, ["Mega|Ride"] = 57.75, ["Mega|Fly|Ride"] = 93.72}},
    ["rbxassetid://140434791311540"] = {name = "French Bulldog", prices = {["default"] = 72.19, ["Ride"] = 122.04, ["Fly|Ride"] = 282.19, ["Neon"] = 211.21, ["Neon|Ride"] = 302.71, ["Neon|Fly|Ride"] = 366.19, ["Mega"] = 734.99, ["Mega|Ride"] = 1048.95, ["Mega|Fly|Ride"] = 912.19}},
    ["rbxassetid://5067924710"] = {name = "Monkey", prices = {["default"] = 3.94, ["Ride"] = 15.86, ["Fly|Ride"] = 45.45, ["Neon"] = 21.14, ["Neon|Fly"] = 91.92, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 81.38, ["Mega"] = 173.78, ["Mega|Fly"] = 183.86, ["Mega|Ride"] = 96.35, ["Mega|Fly|Ride"] = 249.64}},
    ["rbxassetid://73677246948616"] = {name = "Black Tiger", prices = {["default"] = 2.1, ["Fly"] = 70.8, ["Ride"] = 39.38, ["Neon"] = 3.93, ["Neon|Ride"] = 44.63, ["Neon|Fly|Ride"] = 283.29, ["Mega"] = 24.31, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 189}},
    ["rbxassetid://17662893972"] = {name = "Pretty Pony", prices = {["default"] = 84, ["Fly"] = 141.58, ["Ride"] = 95.82, ["Fly|Ride"] = 196.52, ["Neon"] = 240.19, ["Neon|Ride"] = 295.82, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 885.28, ["Mega|Ride"] = 633.97, ["Mega|Fly|Ride"] = 853.13}},
    ["rbxassetid://16722908853"] = {name = "Dotted Eggy", prices = {["default"] = 2.1, ["Ride"] = 17.62, ["Neon"] = 3.93, ["Neon|Ride"] = 99.32, ["Mega"] = 101.43, ["Mega|Ride"] = 82.69, ["Mega|Fly|Ride"] = 160.13}},
    ["rbxassetid://3409443896"] = {name = "Wild Boar", prices = {["default"] = 69.28, ["Ride"] = 63, ["Fly|Ride"] = 393.75, ["Neon"] = 181.73, ["Neon|Ride"] = 197.58, ["Neon|Fly|Ride"] = 234.84, ["Mega|Ride"] = 1578.57, ["Mega|Fly|Ride"] = 1054.37}},
    ["rbxassetid://12432807176"] = {name = "Possum", prices = {["default"] = 5.16, ["Fly|Ride"] = 211.31, ["Neon"] = 42.27, ["Neon|Ride"] = 183.75, ["Mega"] = 156.39, ["Mega|Ride"] = 845.3, ["Mega|Fly|Ride"] = 547.98}},
    ["rbxassetid://94550121082603"] = {name = "Lionfish", prices = {["default"] = 3.93, ["Ride"] = 70.8, ["Fly|Ride"] = 65.63, ["Neon"] = 10.55, ["Neon|Ride"] = 57.06, ["Neon|Fly|Ride"] = 406.88, ["Mega"] = 61.69, ["Mega|Ride"] = 569.63, ["Mega|Fly|Ride"] = 564.17}},
    ["rbxassetid://15096097714"] = {name = "Evil Rock", prices = {["default"] = 24.94, ["Ride"] = 78.68, ["Fly|Ride"] = 118.13, ["Neon|Ride"] = 226.1, ["Mega|Ride"] = 1127.4, ["Mega|Fly|Ride"] = 1051.2}},
    ["rbxassetid://117664495619345"] = {name = "Fire Foal", prices = {["default"] = 2.63, ["Fly"] = 144.8, ["Ride"] = 65.63, ["Fly|Ride"] = 908.98, ["Neon"] = 5.25, ["Neon|Fly"] = 78.66, ["Neon|Ride"] = 31.71, ["Neon|Fly|Ride"] = 156.39, ["Mega"] = 53.82, ["Mega|Fly"] = 158.61, ["Mega|Ride"] = 65.01, ["Mega|Fly|Ride"] = 279.78}},
    ["rbxassetid://8938701683"] = {name = "Red Cardinal", prices = {["default"] = 2.1, ["Fly"] = 46.98, ["Ride"] = 21.09, ["Fly|Ride"] = 72.17, ["Neon"] = 6.2, ["Neon|Fly"] = 41.88, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 105.59, ["Mega|Fly|Ride"] = 282.1}},
    ["rbxassetid://12489700965"] = {name = "Tarsier", prices = {["default"] = 31.7, ["Ride"] = 45.94, ["Fly|Ride"] = 187.86, ["Neon"] = 76.39, ["Neon|Ride"] = 120.75, ["Mega"] = 422.66, ["Mega|Ride"] = 577.98, ["Mega|Fly|Ride"] = 377.99}},
    ["rbxassetid://11765322595"] = {name = "Gingerbread Reindeer", prices = {["default"] = 45.94, ["Ride"] = 50.04, ["Fly|Ride"] = 251.27, ["Neon"] = 196.88, ["Neon|Ride"] = 211.31, ["Neon|Fly|Ride"] = 294.1, ["Mega"] = 590.62, ["Mega|Ride"] = 645.5, ["Mega|Fly|Ride"] = 705.03}},
    ["rbxassetid://16382424275"] = {name = "Nautilus", prices = {["default"] = 32.82, ["Fly"] = 183.82, ["Ride"] = 35.4, ["Fly|Ride"] = 77.44, ["Neon"] = 140.44, ["Neon|Ride"] = 110.25, ["Neon|Fly|Ride"] = 233.52, ["Mega"] = 626.98, ["Mega|Ride"] = 527.25, ["Mega|Fly|Ride"] = 422.63}},
    ["rbxassetid://93997399823425"] = {name = "Chocolate Dutch Guinea Pig", prices = {["default"] = 82.69, ["Fly"] = 196.88, ["Ride"] = 129.94, ["Fly|Ride"] = 157.5, ["Neon"] = 328.13, ["Neon|Ride"] = 313.68, ["Neon|Fly|Ride"] = 523.69, ["Mega"] = 1494.05, ["Mega|Ride"] = 1246.88, ["Mega|Fly|Ride"] = 1242.82}},
    ["rbxassetid://75866760046580"] = {name = "Skelebat", prices = {["default"] = 4.45, ["Ride"] = 39.9, ["Fly|Ride"] = 288.75, ["Neon"] = 33.81, ["Neon|Ride"] = 141.58, ["Neon|Fly|Ride"] = 305.8, ["Mega"] = 110.37, ["Mega|Ride"] = 281.07, ["Mega|Fly|Ride"] = 234.78}},
    ["rbxassetid://111661922676557"] = {name = "Momma Moose", prices = {["default"] = 7.77, ["Ride"] = 21.11, ["Fly|Ride"] = 104.61, ["Neon"] = 21.14, ["Neon|Ride"] = 71.86, ["Mega"] = 203.44, ["Mega|Ride"] = 173.25}},
    ["rbxassetid://17059860310"] = {name = "Elasmosaurus", prices = {["default"] = 15.86, ["Fly"] = 87.94, ["Ride"] = 39.38, ["Fly|Ride"] = 110.37, ["Neon"] = 32.75, ["Neon|Ride"] = 73.5, ["Neon|Fly|Ride"] = 141.6, ["Mega"] = 380.63, ["Mega|Fly|Ride"] = 479.07}},
    ["rbxassetid://10306934599"] = {name = "Camel", prices = {["default"] = 2.1, ["Fly"] = 15.74, ["Ride"] = 14.84, ["Fly|Ride"] = 45.45, ["Neon"] = 2.1, ["Neon|Fly"] = 17.07, ["Neon|Ride"] = 15.86, ["Neon|Fly|Ride"] = 42, ["Mega"] = 19.69, ["Mega|Fly"] = 70.81, ["Mega|Ride"] = 35.95, ["Mega|Fly|Ride"] = 118.13}},
    ["rbxassetid://13104107016"] = {name = "Puffer Fish", prices = {["default"] = 49.88, ["Fly"] = 125.72, ["Ride"] = 422.6, ["Fly|Ride"] = 303.01, ["Neon"] = 223.13, ["Neon|Fly"] = 2395.03, ["Neon|Ride"] = 291.37, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 3169.81, ["Mega|Ride"] = 807.19, ["Mega|Fly|Ride"] = 821.96}},
    ["rbxassetid://17183022910"] = {name = "Mole", prices = {["default"] = 2.1, ["Ride"] = 19.09, ["Fly|Ride"] = 109.89, ["Neon"] = 3.92, ["Neon|Ride"] = 26.25, ["Mega"] = 107.79, ["Mega|Fly|Ride"] = 211.31}},
    ["rbxassetid://5721844051"] = {name = "Stegosaurus", prices = {["default"] = 2.1, ["Fly"] = 28.54, ["Ride"] = 19.69, ["Fly|Ride"] = 57.06, ["Neon"] = 13.13, ["Neon|Fly"] = 141.58, ["Neon|Ride"] = 28.62, ["Neon|Fly|Ride"] = 78.68, ["Mega"] = 157.5, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 252.13}},
    ["rbxassetid://114921997566126"] = {name = "S'mores Raccoon", prices = {["default"] = 91.88, ["Ride"] = 154.26, ["Fly|Ride"] = 196.88, ["Neon"] = 255.94, ["Neon|Ride"] = 332.14, ["Neon|Fly|Ride"] = 511.88, ["Mega"] = 889.86, ["Mega|Ride"] = 905.63, ["Mega|Fly|Ride"] = 1010.63}},
    ["rbxassetid://93038040448121"] = {name = "Nurse Shark", prices = {["default"] = 2.1, ["Ride"] = 57.06, ["Neon"] = 7.46, ["Neon|Ride"] = 42, ["Mega"] = 59.07, ["Mega|Ride"] = 119.25, ["Mega|Fly|Ride"] = 275.63}},
    ["rbxassetid://13936750528"] = {name = "River", prices = {["default"] = 210}},
    ["rbxassetid://103142927308458"] = {name = "Black-Footed Ferret", prices = {["default"] = 2.1, ["Ride"] = 20425.82, ["Fly|Ride"] = 262.5, ["Neon"] = 7.23, ["Neon|Ride"] = 63.4, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 45.45, ["Mega|Ride"] = 115.5, ["Mega|Fly|Ride"] = 1034.25}},
    ["rbxassetid://3199974219"] = {name = "Pet Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13803784751"] = {name = "Happy Clam", prices = {["default"] = 116.82, ["Ride"] = 118.13, ["Fly|Ride"] = 422.6, ["Neon"] = 833.44, ["Neon|Ride"] = 701.51, ["Neon|Fly|Ride"] = 523.69, ["Mega|Fly|Ride"] = 2564.07}},
    ["rbxassetid://13665210525"] = {name = "Warthog", prices = {["default"] = 2.63, ["Neon"] = 23.25, ["Neon|Ride"] = 61.69, ["Mega"] = 170.63, ["Mega|Ride"] = 314.42, ["Mega|Fly|Ride"] = 469.55}},
    ["rbxassetid://18515939072"] = {name = "Black Marlin", prices = {["default"] = 2.63, ["Fly"] = 26.25, ["Neon"] = 5.25, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 234.85, ["Mega"] = 35.95, ["Mega|Ride"] = 99.33, ["Mega|Fly|Ride"] = 312.9}},
    ["rbxassetid://16075008092"] = {name = "Fanghorn Tortoise", prices = {["default"] = 5.98, ["Ride"] = 35.44, ["Neon"] = 51.1, ["Neon|Ride"] = 112.88, ["Mega"] = 393.07, ["Mega|Ride"] = 633.97, ["Mega|Fly|Ride"] = 626.84}},
    ["rbxassetid://8566684181"] = {name = "Giant Black Scarab", prices = {["default"] = 10.26, ["Fly"] = 75.02, ["Ride"] = 28.54, ["Fly|Ride"] = 157.5, ["Neon"] = 28.54, ["Neon|Ride"] = 90.87, ["Neon|Fly|Ride"] = 281.07, ["Mega"] = 453.48, ["Mega|Ride"] = 392.44, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://118691035196137"] = {name = "Shiver Wolf", prices = {["default"] = 28.88, ["Ride"] = 281.03, ["Neon"] = 212.52, ["Neon|Fly|Ride"] = 422.66, ["Mega"] = 721.88, ["Mega|Ride"] = 360.94, ["Mega|Fly|Ride"] = 471.18}},
    ["rbxassetid://3743735223"] = {name = "Brown Bear", prices = {["default"] = 152.25, ["Fly"] = 144.38, ["Ride"] = 191.63, ["Fly|Ride"] = 238.77, ["Neon"] = 597.98, ["Neon|Ride"] = 498.75, ["Neon|Fly|Ride"] = 589.32, ["Mega|Fly|Ride"] = 2110.12}},
    ["rbxassetid://3934251801"] = {name = "Sloth", prices = {["default"] = 8.46, ["Fly"] = 18.38, ["Ride"] = 24.31, ["Fly|Ride"] = 52.84, ["Neon"] = 62.53, ["Neon|Fly"] = 422.6, ["Neon|Ride"] = 57.06, ["Neon|Fly|Ride"] = 91.93, ["Mega|Ride"] = 564.24, ["Mega|Fly|Ride"] = 373.55}},
    ["rbxassetid://12139338880"] = {name = "Frogspawn", prices = {["default"] = 3.94, ["Fly"] = 131.23, ["Ride"] = 21.21, ["Fly|Ride"] = 131.25, ["Neon"] = 25.96, ["Neon|Ride"] = 35.44, ["Neon|Fly|Ride"] = 251.95, ["Mega"] = 127.77, ["Mega|Fly|Ride"] = 421.55}},
    ["rbxassetid://8070926551"] = {name = "Snow Leopard", prices = {["default"] = 11.7, ["Fly"] = 234.82, ["Ride"] = 55.13, ["Neon"] = 64.32, ["Neon|Ride"] = 138.42, ["Mega"] = 524.09, ["Mega|Fly|Ride"] = 549.94}},
    ["rbxassetid://76712147705770"] = {name = "Tuxedo Cat", prices = {["default"] = 51.48, ["Ride"] = 56.38, ["Fly|Ride"] = 211.31, ["Neon"] = 221.88, ["Neon|Ride"] = 272.6, ["Neon|Fly|Ride"] = 304.32, ["Mega"] = 972.08, ["Mega|Ride"] = 918.75, ["Mega|Fly|Ride"] = 858.51}},
    ["rbxassetid://15685468962"] = {name = "Tasmanian Devil", prices = {["default"] = 35.94, ["Ride"] = 81.86, ["Neon"] = 122.57, ["Neon|Ride"] = 126.62, ["Mega"] = 691.03, ["Mega|Ride"] = 704.76, ["Mega|Fly|Ride"] = 817.72}},
    ["rbxassetid://123288277753363"] = {name = "Tri-horned Treehopper", prices = {["default"] = 301.87, ["Ride"] = 413.44, ["Neon"] = 2395.03, ["Neon|Ride"] = 1115.63, ["Neon|Fly|Ride"] = 1690.57, ["Mega|Fly|Ride"] = 4120.26}},
    ["rbxassetid://6060987821"] = {name = "Yeti", prices = {["default"] = 38.8, ["Ride"] = 45.94, ["Fly|Ride"] = 84.79, ["Neon|Ride"] = 211.95, ["Neon|Fly|Ride"] = 325.64, ["Mega"] = 1181.25, ["Mega|Ride"] = 830.5, ["Mega|Fly|Ride"] = 776.1}},
    ["rbxassetid://9549841158"] = {name = "Zebra", prices = {["default"] = 2.1, ["Fly"] = 17.4, ["Ride"] = 15.91, ["Fly|Ride"] = 95.1, ["Neon"] = 2.63, ["Neon|Ride"] = 19.55, ["Neon|Fly|Ride"] = 45.94, ["Mega"] = 21.19, ["Mega|Fly"] = 105, ["Mega|Ride"] = 69.28, ["Mega|Fly|Ride"] = 94.35}},
    ["rbxassetid://13883282884"] = {name = "Hermit Crab", prices = {["default"] = 4.7, ["Ride"] = 211.02, ["Neon"] = 16.91, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 126.97, ["Mega"] = 147.95, ["Mega|Fly"] = 124.69, ["Mega|Ride"] = 89.25, ["Mega|Fly|Ride"] = 370.79}},
    ["rbxassetid://92626539723202"] = {name = "Sea Angel", prices = {["default"] = 3.67, ["Ride"] = 33.8, ["Neon"] = 13.13, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 1181.25, ["Mega"] = 147.94, ["Mega|Fly"] = 239.87, ["Mega|Ride"] = 188.09, ["Mega|Fly|Ride"] = 342.57}},
    ["rbxassetid://15848329383"] = {name = "Jellyfish", prices = {["default"] = 360.94, ["Fly"] = 626.96, ["Ride"] = 388.5, ["Fly|Ride"] = 515.28, ["Neon"] = 1803.41, ["Neon|Fly"] = 1831.93, ["Neon|Ride"] = 1722.37, ["Neon|Fly|Ride"] = 1973.74, ["Mega|Ride"] = 6339.6, ["Mega|Fly|Ride"] = 5033.44}},
    ["rbxassetid://5721843846"] = {name = "Sabertooth", prices = {["default"] = 5.25, ["Fly"] = 70.8, ["Ride"] = 15.81, ["Fly|Ride"] = 66.57, ["Neon"] = 38.14, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 78.33, ["Mega|Ride"] = 223.12, ["Mega|Fly|Ride"] = 685.13}},
    ["rbxassetid://9475753090"] = {name = "Albatross", prices = {["default"] = 7.85, ["Fly"] = 31.65, ["Ride"] = 21, ["Fly|Ride"] = 52.84, ["Neon|Ride"] = 57.06, ["Neon|Fly|Ride"] = 210.29, ["Mega"] = 422.66, ["Mega|Ride"] = 704.76, ["Mega|Fly|Ride"] = 211.31}},
    ["rbxassetid://96894173636082"] = {name = "Clementine Owl", prices = {["default"] = 4.71, ["Fly"] = 84.52, ["Ride"] = 27.49, ["Fly|Ride"] = 105.67, ["Neon"] = 23.63, ["Neon|Ride"] = 65.62, ["Neon|Fly|Ride"] = 114.18, ["Mega"] = 128.97, ["Mega|Ride"] = 117.43, ["Mega|Fly|Ride"] = 329.63}},
    ["rbxassetid://10318105683"] = {name = "Orange Butterfly", prices = {["default"] = 31.91, ["Fly"] = 210, ["Ride"] = 63.4, ["Fly|Ride"] = 65.63, ["Neon"] = 117.42, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 656.25, ["Mega|Ride"] = 844.24, ["Mega|Fly|Ride"] = 643.11}},
    ["rbxassetid://15937689999"] = {name = "Rattlesnake", prices = {["default"] = 2.1, ["Fly"] = 315, ["Ride"] = 28.14, ["Fly|Ride"] = 73.97, ["Neon"] = 18.38, ["Neon|Ride"] = 114.19, ["Neon|Fly|Ride"] = 210, ["Mega"] = 99.33, ["Mega|Ride"] = 140.9}},
    ["rbxassetid://10971808447"] = {name = "Evil Basilisk", prices = {["default"] = 10.5, ["Fly"] = 104.15, ["Ride"] = 24.94, ["Fly|Ride"] = 91.88, ["Neon"] = 153.04, ["Neon|Ride"] = 106.32, ["Mega"] = 704.76, ["Mega|Ride"] = 313.5, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://99104623628550"] = {name = "Snorgle", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 3.93, ["Neon|Ride"] = 26.25, ["Mega"] = 38.98, ["Mega|Ride"] = 113.07, ["Mega|Fly|Ride"] = 282.1}},
    ["rbxassetid://136705425555561"] = {name = "Emperor Shrimp", prices = {["default"] = 15.86, ["Ride"] = 69.57, ["Neon"] = 89.25, ["Mega"] = 239.4, ["Mega|Fly|Ride"] = 6338.84}},
    ["rbxassetid://14398819258"] = {name = "Longhorn Cow", prices = {["default"] = 9.19, ["Ride"] = 141.58, ["Neon"] = 78.09, ["Mega"] = 311.72, ["Mega|Ride"] = 375.73, ["Mega|Fly|Ride"] = 1056.48}},
    ["rbxassetid://4708551284"] = {name = "Koala", prices = {["default"] = 12.99, ["Fly"] = 30.19, ["Ride"] = 28.54, ["Fly|Ride"] = 53.82, ["Neon"] = 78.06, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 122.06, ["Mega"] = 408.92, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 378.8}},
    ["rbxassetid://4115249264"] = {name = "Zombie Buffalo", prices = {["default"] = 169.45, ["Fly"] = 205.24, ["Ride"] = 210, ["Fly|Ride"] = 259.91, ["Neon"] = 853.1, ["Neon|Ride"] = 869.5, ["Neon|Fly|Ride"] = 812.55, ["Mega|Fly|Ride"] = 4641}},
    ["rbxassetid://8939633862"] = {name = "Salamander", prices = {["default"] = 3.94, ["Fly"] = 21.2, ["Ride"] = 15.81, ["Fly|Ride"] = 45.94, ["Neon"] = 84.53, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 141.6, ["Mega"] = 220.5, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://7734902431"] = {name = "Halloween White Mummy Cat", prices = {["default"] = 3.94, ["Ride"] = 69.75, ["Fly|Ride"] = 103.76, ["Neon"] = 13.13, ["Neon|Ride"] = 32.81, ["Neon|Fly|Ride"] = 166.69, ["Mega"] = 195.57, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 410.82}},
    ["rbxassetid://115869632070663"] = {name = "Snowball Pug", prices = {["default"] = 47.25, ["Ride"] = 105, ["Fly|Ride"] = 346.36, ["Neon"] = 141.58, ["Neon|Ride"] = 704.68, ["Neon|Fly|Ride"] = 469.88, ["Mega"] = 342.57, ["Mega|Ride"] = 385.67, ["Mega|Fly|Ride"] = 483.37}},
    ["rbxassetid://8077189379"] = {name = "Husky", prices = {["default"] = 80.07, ["Fly"] = 169, ["Ride"] = 124.91, ["Fly|Ride"] = 211.31, ["Neon"] = 467.34, ["Neon|Ride"] = 459.38, ["Neon|Fly|Ride"] = 474.75, ["Mega|Ride"] = 1791.57, ["Mega|Fly|Ride"] = 1452.3}},
    ["rbxassetid://98003529163435"] = {name = "Maine Coon", prices = {["default"] = 52.5, ["Ride"] = 102.21, ["Fly|Ride"] = 223.13, ["Neon"] = 106.94, ["Neon|Ride"] = 183.84, ["Neon|Fly|Ride"] = 422.66, ["Mega"] = 282.19, ["Mega|Ride"] = 319.56, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://12488273089"] = {name = "Yellow-lipped Sea Krait", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 19.69, ["Fly|Ride"] = 59.07, ["Neon"] = 15.86, ["Neon|Fly|Ride"] = 59.07, ["Mega"] = 125.64, ["Mega|Ride"] = 183.86, ["Mega|Fly|Ride"] = 352.88}},
    ["rbxassetid://96760582519875"] = {name = "Cozy Mistletroll", prices = {["default"] = 26.25, ["Fly|Ride"] = 9156.45, ["Neon"] = 84, ["Mega"] = 198.89, ["Mega|Ride"] = 268.42, ["Mega|Fly|Ride"] = 295.82}},
    ["rbxassetid://85229142142232"] = {name = "Bunny Swirl", prices = {["default"] = 89.25, ["Ride"] = 117.63, ["Fly|Ride"] = 221.82, ["Neon"] = 216.57, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 407.66, ["Mega"] = 486.88, ["Mega|Ride"] = 519.75, ["Mega|Fly|Ride"] = 612.94}},
    ["rbxassetid://121192022038625"] = {name = "Stygian Owl", prices = {["default"] = 2.63, ["Ride"] = 72.18, ["Neon"] = 7.88, ["Neon|Ride"] = 103.69, ["Neon|Fly|Ride"] = 105, ["Mega"] = 53.82, ["Mega|Fly"] = 162.73, ["Mega|Ride"] = 127.77, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://83732262844708"] = {name = "Pain au Chat", prices = {["default"] = 15.1, ["Ride"] = 282.1, ["Neon"] = 85.32, ["Neon|Ride"] = 162.71, ["Mega"] = 332.18, ["Mega|Ride"] = 549.94, ["Mega|Fly|Ride"] = 581.94}},
    ["rbxassetid://12792506715"] = {name = "Goose", prices = {["default"] = 1155, ["Fly"] = 2112.7, ["Ride"] = 997.5, ["Fly|Ride"] = 1102.5, ["Neon|Ride"] = 3380.72, ["Neon|Fly|Ride"] = 2625, ["Mega|Fly|Ride"] = 11634.6}},
    ["rbxassetid://12779257292"] = {name = "Pudding Cat", prices = {["default"] = 28.88, ["Ride"] = 111.56, ["Fly|Ride"] = 223.99, ["Neon"] = 141.58, ["Neon|Ride"] = 531.57, ["Mega"] = 845.3, ["Mega|Ride"] = 656.25, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://83376259738301"] = {name = "Mrs. Whiskerpips", prices = {["default"] = 11.82, ["Fly"] = 48.61, ["Ride"] = 42, ["Fly|Ride"] = 422.6, ["Neon"] = 33.81, ["Neon|Fly"] = 157.5, ["Neon|Ride"] = 49.8, ["Neon|Fly|Ride"] = 110.37, ["Mega"] = 111.56, ["Mega|Fly"] = 113.07, ["Mega|Ride"] = 413.15, ["Mega|Fly|Ride"] = 277.39}},
    ["rbxassetid://110894046614323"] = {name = "Partridge", prices = {["default"] = 28.54, ["Ride"] = 131.22, ["Neon"] = 131.25, ["Mega"] = 366.65, ["Mega|Ride"] = 328.13}},
    ["rbxassetid://114034119324343"] = {name = "Muskrat", prices = {["default"] = 2.1, ["Ride"] = 30.65, ["Fly|Ride"] = 422.6, ["Neon"] = 2.1, ["Neon|Ride"] = 28.49, ["Neon|Fly|Ride"] = 93.93, ["Mega"] = 19.69, ["Mega|Fly"] = 125.74, ["Mega|Ride"] = 94.5, ["Mega|Fly|Ride"] = 549.39}},
    ["rbxassetid://15547904644"] = {name = "Harp Seal", prices = {["default"] = 75.74, ["Ride"] = 148.58, ["Fly|Ride"] = 311.68, ["Neon"] = 313.69, ["Neon|Ride"] = 341.57, ["Neon|Fly|Ride"] = 478.64, ["Mega"] = 1045.59, ["Mega|Ride"] = 1443.75, ["Mega|Fly|Ride"] = 1252.52}},
    ["rbxassetid://14978702254"] = {name = "Scarecrow Cat", prices = {["default"] = 6.35, ["Fly"] = 101.07, ["Ride"] = 84.53, ["Fly|Ride"] = 71.01, ["Neon"] = 34.44, ["Neon|Ride"] = 84.79, ["Mega"] = 352.93, ["Mega|Ride"] = 263.53, ["Mega|Fly|Ride"] = 296.63}},
    ["rbxassetid://95871612352029"] = {name = "Cold Cube", prices = {["default"] = 7.06, ["Ride"] = 19.69, ["Neon"] = 17.62, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 141.6, ["Mega"] = 147, ["Mega|Ride"] = 239.87, ["Mega|Fly|Ride"] = 301.88}},
    ["rbxassetid://114456035353449"] = {name = "Bauble Buddies", prices = {["default"] = 61.69, ["Ride"] = 97.21, ["Fly|Ride"] = 150.03, ["Neon"] = 152.81, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 612.84, ["Mega"] = 535.5, ["Mega|Ride"] = 472.33, ["Mega|Fly|Ride"] = 731.09}},
    ["rbxassetid://15383967605"] = {name = "Gingerbread Mouse", prices = {["default"] = 21.14, ["Ride"] = 99.75, ["Fly|Ride"] = 70.8, ["Neon"] = 78.68, ["Neon|Ride"] = 179.82, ["Neon|Fly|Ride"] = 315, ["Mega"] = 612.26, ["Mega|Ride"] = 648.77, ["Mega|Fly|Ride"] = 644.46}},
    ["rbxassetid://11767069383"] = {name = "Woolly Rhino", prices = {["default"] = 49.79, ["Ride"] = 422.6, ["Neon"] = 774.38, ["Neon|Ride"] = 845.19, ["Neon|Fly|Ride"] = 1313.38, ["Mega"] = 2535.86, ["Mega|Ride"] = 1832.16, ["Mega|Fly|Ride"] = 2119.36}},
    ["rbxassetid://95133623103638"] = {name = "Samoyed", prices = {["default"] = 14.44, ["Neon"] = 24.31, ["Neon|Ride"] = 99.32, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 95.11, ["Mega|Ride"] = 131.15, ["Mega|Fly|Ride"] = 284.93}},
    ["rbxassetid://8071236757"] = {name = "St Bernard", prices = {["default"] = 8.46, ["Fly"] = 28.54, ["Ride"] = 28.5, ["Fly|Ride"] = 70.8, ["Neon"] = 141.58, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 282.13, ["Mega"] = 399, ["Mega|Ride"] = 392.44, ["Mega|Fly|Ride"] = 434.34}},
    ["rbxassetid://14276930615"] = {name = "Alley Cat", prices = {["default"] = 128.61, ["Ride"] = 177.19, ["Fly|Ride"] = 236.83, ["Neon"] = 512.07, ["Neon|Ride"] = 532.88, ["Neon|Fly|Ride"] = 633.38, ["Mega|Fly"] = 2817.96, ["Mega|Ride"] = 2361.19, ["Mega|Fly|Ride"] = 2224.69}},
    ["rbxassetid://6498256417"] = {name = "Dolphin", prices = {["default"] = 3.93, ["Fly"] = 39.38, ["Ride"] = 20.09, ["Fly|Ride"] = 28.75, ["Neon"] = 11.64, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 27.46, ["Neon|Fly|Ride"] = 77.35, ["Mega"] = 119.44, ["Mega|Ride"] = 136.5, ["Mega|Fly|Ride"] = 210.77}},
    ["rbxassetid://7734900468"] = {name = "Halloween White Skeleton Dog", prices = {["default"] = 5.25, ["Fly"] = 115.35, ["Ride"] = 23.63, ["Fly|Ride"] = 84.53, ["Neon"] = 31.5, ["Neon|Fly"] = 281.17, ["Neon|Ride"] = 63.4, ["Neon|Fly|Ride"] = 99.33, ["Mega"] = 217.59, ["Mega|Ride"] = 183.43, ["Mega|Fly|Ride"] = 279.35}},
    ["rbxassetid://9982202041"] = {name = "Poodle", prices = {["default"] = 2.1, ["Ride"] = 15.86, ["Fly|Ride"] = 36.05, ["Neon"] = 2.1, ["Neon|Fly"] = 35.83, ["Neon|Ride"] = 16.96, ["Neon|Fly|Ride"] = 48.49, ["Mega"] = 14.44, ["Mega|Ride"] = 31.24, ["Mega|Fly|Ride"] = 91.88}},
    ["rbxassetid://73671766703168"] = {name = "Pilot Gull", prices = {["default"] = 2.1, ["Ride"] = 31.7, ["Neon"] = 3.94, ["Neon|Fly"] = 42.27, ["Mega"] = 21.15, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 64.32, ["Mega|Fly|Ride"] = 139.47}},
    ["rbxassetid://14146127209"] = {name = "Indian Leopard", prices = {["default"] = 3.94, ["Fly"] = 132.47, ["Ride"] = 71.86, ["Neon"] = 21.15, ["Neon|Ride"] = 93.94, ["Mega"] = 134.19, ["Mega|Ride"] = 152.3}},
    ["rbxassetid://113558592714438"] = {name = "Seabed Creeper", prices = {["default"] = 42.27, ["Ride"] = 315, ["Neon"] = 234.82, ["Neon|Ride"] = 452.82, ["Neon|Fly|Ride"] = 630, ["Mega"] = 774.38, ["Mega|Fly|Ride"] = 697.28}},
    ["rbxassetid://4281674713"] = {name = "Bee", prices = {["default"] = 2.1, ["Fly"] = 22.32, ["Ride"] = 23.25, ["Fly|Ride"] = 39.38, ["Neon"] = 17.07, ["Neon|Fly"] = 28.88, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 53.95, ["Mega"] = 111.57, ["Mega|Fly"] = 212.36, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 161.17}},
    ["rbxassetid://5862774392"] = {name = "Bat", prices = {["default"] = 7.06, ["Fly"] = 38.05, ["Ride"] = 31.7, ["Fly|Ride"] = 68.22, ["Neon"] = 15.75, ["Neon|Fly"] = 93.94, ["Neon|Ride"] = 31.71, ["Neon|Fly|Ride"] = 76.13, ["Mega"] = 126, ["Mega|Fly"] = 433.13, ["Mega|Ride"] = 126.98, ["Mega|Fly|Ride"] = 190.3}},
    ["rbxassetid://18223359092"] = {name = "Birthday Butterfly 2024", prices = {["default"] = 2.5, ["Fly"] = 25.85, ["Ride"] = 19.69, ["Fly|Ride"] = 91.88, ["Neon"] = 11.75, ["Neon|Fly"] = 98.44, ["Neon|Ride"] = 22.33, ["Neon|Fly|Ride"] = 107.79, ["Mega"] = 103.69, ["Mega|Ride"] = 65.61, ["Mega|Fly|Ride"] = 125.62}},
    ["rbxassetid://17822765706"] = {name = "Pink Betta Fish", prices = {["default"] = 13.13, ["Fly"] = 281.01, ["Ride"] = 26.24, ["Neon"] = 31.71, ["Neon|Ride"] = 83.47, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 259.93, ["Mega|Ride"] = 243.03, ["Mega|Fly|Ride"] = 626.84}},
    ["rbxassetid://14146174264"] = {name = "Rock Pigeon", prices = {["default"] = 6.55, ["Fly"] = 160.7, ["Ride"] = 84.55, ["Neon"] = 46.92, ["Neon|Ride"] = 105, ["Mega"] = 223.13, ["Mega|Ride"] = 564.24, ["Mega|Fly|Ride"] = 1056.48}},
    ["rbxassetid://11758575946"] = {name = "Water Moon Bear", prices = {["default"] = 7.06, ["Fly"] = 35.44, ["Ride"] = 23.25, ["Fly|Ride"] = 57.06, ["Neon"] = 35.44, ["Neon|Fly"] = 196.65, ["Neon|Ride"] = 46.99, ["Mega"] = 173.78, ["Mega|Ride"] = 282.13, ["Mega|Fly|Ride"] = 338.63}},
    ["rbxassetid://6498256132"] = {name = "Seahorse", prices = {["default"] = 2.1, ["Ride"] = 16.86, ["Fly|Ride"] = 37, ["Neon"] = 23.55, ["Neon|Fly"] = 84.53, ["Neon|Ride"] = 48.61, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 262.5, ["Mega|Ride"] = 234.71, ["Mega|Fly|Ride"] = 223.92}},
    ["rbxassetid://13664973582"] = {name = "Many Mackerel", prices = {["default"] = 190.32, ["Fly"] = 393.75, ["Ride"] = 210, ["Fly|Ride"] = 305.82, ["Neon"] = 1224.46, ["Neon|Ride"] = 986.75, ["Neon|Fly|Ride"] = 1179.94, ["Mega|Fly|Ride"] = 3155.25}},
    ["rbxassetid://114806716799554"] = {name = "Ringmaster Gibbon", prices = {["default"] = 6.07, ["Ride"] = 30.54, ["Neon"] = 26.25, ["Neon|Fly|Ride"] = 282.13, ["Mega"] = 123.38, ["Mega|Ride"] = 211.34, ["Mega|Fly|Ride"] = 493.38}},
    ["rbxassetid://14360917588"] = {name = "Magma Moose", prices = {["default"] = 3.94, ["Ride"] = 27.48, ["Fly|Ride"] = 118.13, ["Neon"] = 21.15, ["Neon|Ride"] = 52.84, ["Neon|Fly|Ride"] = 139.65, ["Mega"] = 180.7, ["Mega|Ride"] = 211.34, ["Mega|Fly|Ride"] = 1173.85}},
    ["rbxassetid://18957942216"] = {name = "Starhopper", prices = {["default"] = 5.25, ["Fly|Ride"] = 157.34, ["Neon"] = 31.68, ["Neon|Fly|Ride"] = 633.97, ["Mega"] = 467.61, ["Mega|Fly|Ride"] = 1007.35}},
    ["rbxassetid://3181727071"] = {name = "Puma", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 15.86, ["Fly|Ride"] = 35.94, ["Neon"] = 2.1, ["Neon|Fly"] = 42.27, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 37.85, ["Mega"] = 19.04, ["Mega|Fly"] = 70.81, ["Mega|Ride"] = 34.13, ["Mega|Fly|Ride"] = 93.93}},
    ["rbxassetid://4841039508"] = {name = "Rock", prices = {["default"] = 3.92, ["Fly"] = 56.35, ["Ride"] = 21.14, ["Fly|Ride"] = 42.27, ["Neon"] = 11.82, ["Neon|Ride"] = 31.7, ["Neon|Fly|Ride"] = 99.49, ["Mega"] = 141.39, ["Mega|Ride"] = 143.07, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://94235745630523"] = {name = "Rainbow Trout", prices = {["default"] = 3.82, ["Ride"] = 156.37, ["Neon"] = 12.99, ["Neon|Ride"] = 140.44, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 64.32, ["Mega|Ride"] = 126.81, ["Mega|Fly|Ride"] = 234.55}},
    ["rbxassetid://4440867249"] = {name = "Llama", prices = {["default"] = 70.56, ["Fly"] = 185.95, ["Ride"] = 99.67, ["Fly|Ride"] = 131.25, ["Neon"] = 666.65, ["Neon|Ride"] = 393.73, ["Neon|Fly|Ride"] = 455.44, ["Mega|Ride"] = 3523.77, ["Mega|Fly|Ride"] = 1565.08}},
    ["rbxassetid://11571113805"] = {name = "Bloodhound", prices = {["default"] = 6.35, ["Fly"] = 85.32, ["Ride"] = 37, ["Fly|Ride"] = 65.54, ["Neon"] = 21.95, ["Neon|Ride"] = 70.12, ["Neon|Fly|Ride"] = 113.07, ["Mega"] = 282.13, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 253.57}},
    ["rbxassetid://78423968285099"] = {name = "Wren", prices = {["default"] = 2.63, ["Fly"] = 31.7, ["Ride"] = 52.5, ["Fly|Ride"] = 164.82, ["Neon"] = 15.75, ["Neon|Ride"] = 57.07, ["Neon|Fly|Ride"] = 169.08, ["Mega"] = 67.65, ["Mega|Fly"] = 412.1, ["Mega|Ride"] = 126, ["Mega|Fly|Ride"] = 239.84}},
    ["rbxassetid://110871792705214"] = {name = "Burger Bear", prices = {["default"] = 65.62, ["Fly"] = 124.69, ["Ride"] = 110.73, ["Fly|Ride"] = 211.31, ["Neon"] = 153.57, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 332.07, ["Mega"] = 577.5, ["Mega|Ride"] = 627.38, ["Mega|Fly|Ride"] = 1017.19}},
    ["rbxassetid://3181727637"] = {name = "Fennec Fox", prices = {["default"] = 2.1, ["Ride"] = 13.13, ["Fly|Ride"] = 59.17, ["Neon"] = 2.1, ["Neon|Fly"] = 21, ["Neon|Ride"] = 15.86, ["Neon|Fly|Ride"] = 42.29, ["Mega"] = 21.77, ["Mega|Fly"] = 42.29, ["Mega|Ride"] = 29.35, ["Mega|Fly|Ride"] = 78.75}},
    ["rbxassetid://115530716039589"] = {name = "Milk Choccybunny", prices = {["default"] = 2.1, ["Neon"] = 4.24, ["Neon|Ride"] = 42.27, ["Neon|Fly|Ride"] = 99.33, ["Mega"] = 26.25, ["Mega|Ride"] = 90.57, ["Mega|Fly|Ride"] = 282.1}},
    ["rbxassetid://83001092186817"] = {name = "White Choccybunny", prices = {["default"] = 2.63, ["Ride"] = 157.34, ["Neon"] = 8.46, ["Neon|Ride"] = 58.68, ["Neon|Fly|Ride"] = 197.6, ["Mega"] = 56.44, ["Mega|Ride"] = 133.51}},
    ["rbxassetid://103795616446776"] = {name = "Waffle Wyrm", prices = {["default"] = 15.86, ["Fly"] = 113.06, ["Ride"] = 53.82, ["Fly|Ride"] = 129.96, ["Neon"] = 19.69, ["Neon|Fly"] = 129.96, ["Neon|Ride"] = 57.23, ["Neon|Fly|Ride"] = 177.18, ["Mega"] = 128.92, ["Mega|Fly"] = 204.3, ["Mega|Ride"] = 181.94, ["Mega|Fly|Ride"] = 265.13}},
    ["rbxassetid://9982358951"] = {name = "Orangutan", prices = {["default"] = 2.1, ["Fly"] = 15.74, ["Ride"] = 12.69, ["Fly|Ride"] = 34.13, ["Neon"] = 2.63, ["Neon|Fly"] = 22.33, ["Neon|Ride"] = 35.18, ["Neon|Fly|Ride"] = 63.41, ["Mega"] = 17.62, ["Mega|Ride"] = 42.29, ["Mega|Fly|Ride"] = 103.69}},
    ["rbxassetid://129021417712364"] = {name = "Kage Crow", prices = {["default"] = 11.43, ["Ride"] = 42.27, ["Fly|Ride"] = 200.48, ["Neon"] = 70.88, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 183.86, ["Mega"] = 421.04, ["Mega|Ride"] = 474.43}},
    ["rbxassetid://4849941238"] = {name = "Hedgehog", prices = {["default"] = 2730, ["Fly"] = 3150, ["Ride"] = 2737.49, ["Fly|Ride"] = 2730, ["Neon|Fly|Ride"] = 9355.5}},
    ["rbxassetid://4800190144"] = {name = "Ginger Cat", prices = {["default"] = 2.1, ["Fly"] = 52.49, ["Ride"] = 23.25, ["Fly|Ride"] = 44.39, ["Neon"] = 12.93, ["Neon|Fly"] = 68.57, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 117.43, ["Mega|Ride"] = 104.69, ["Mega|Fly|Ride"] = 174.47}},
    ["rbxassetid://18119333909"] = {name = "Rodeo Bull", prices = {["default"] = 5.25, ["Neon"] = 12.47, ["Mega"] = 126, ["Mega|Ride"] = 437.07, ["Mega|Fly|Ride"] = 633.9}},
    ["rbxassetid://11837080223"] = {name = "Highland Cow", prices = {["default"] = 27.48, ["Ride"] = 40.16, ["Fly|Ride"] = 157.5, ["Neon"] = 103.69, ["Neon|Ride"] = 152.65, ["Neon|Fly|Ride"] = 254.26, ["Mega"] = 564.24, ["Mega|Ride"] = 397.69}},
    ["rbxassetid://14398816006"] = {name = "Rooster", prices = {["default"] = 42.27, ["Ride"] = 78.75, ["Neon"] = 150.94, ["Mega"] = 739.64, ["Mega|Ride"] = 726.77, ["Mega|Fly|Ride"] = 1458.19}},
    ["rbxassetid://3409444089"] = {name = "Hyena", prices = {["default"] = 152.09, ["Fly"] = 282.06, ["Ride"] = 188.31, ["Fly|Ride"] = 263.97, ["Neon"] = 1312.5, ["Neon|Fly"] = 656.25, ["Neon|Ride"] = 774.38, ["Neon|Fly|Ride"] = 760.77, ["Mega"] = 6339.6, ["Mega|Fly|Ride"] = 2362.5}},
    ["rbxassetid://127067345833475"] = {name = "Hummingbird", prices = {["default"] = 5.98, ["Ride"] = 65.63, ["Fly|Ride"] = 675.94, ["Neon"] = 19.03, ["Neon|Fly"] = 70.8, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 223.13, ["Mega|Fly"] = 157.35, ["Mega|Ride"] = 201.95, ["Mega|Fly|Ride"] = 253.32}},
    ["rbxassetid://130497948875084"] = {name = "Marabou Stork", prices = {["default"] = 2.1, ["Ride"] = 39.38, ["Neon"] = 14.43, ["Neon|Fly"] = 99.32, ["Neon|Ride"] = 42.27, ["Mega"] = 147.94, ["Mega|Ride"] = 261.03, ["Mega|Fly|Ride"] = 834.62}},
    ["rbxassetid://127017727552531"] = {name = "Angus Calf", prices = {["default"] = 3.94, ["Fly"] = 101.98, ["Ride"] = 70.8, ["Fly|Ride"] = 131.25, ["Neon"] = 9.19, ["Neon|Ride"] = 44.63, ["Mega"] = 68.25, ["Mega|Ride"] = 420.55, ["Mega|Fly|Ride"] = 287.44}},
    ["rbxassetid://12779130089"] = {name = "Sprout Snail", prices = {["default"] = 15.75, ["Neon|Ride"] = 1549.86, ["Neon|Fly|Ride"] = 295.86, ["Mega"] = 476.39, ["Mega|Ride"] = 469.64, ["Mega|Fly|Ride"] = 430}},
    ["rbxassetid://117824155556510"] = {name = "Princess Mare", prices = {["default"] = 2.1, ["Ride"] = 70.8, ["Neon"] = 2.1, ["Neon|Ride"] = 32.82, ["Mega"] = 17.07, ["Mega|Ride"] = 63, ["Mega|Fly|Ride"] = 282.1}},
    ["rbxassetid://122766274014139"] = {name = "Gaelic Fae", prices = {["default"] = 82.69, ["Ride"] = 72.19, ["Fly|Ride"] = 131.07, ["Neon|Ride"] = 409.5, ["Neon|Fly|Ride"] = 418.69, ["Mega|Ride"] = 1690.57, ["Mega|Fly|Ride"] = 1722.05}},
    ["rbxassetid://17255807019"] = {name = "Weevil", prices = {["default"] = 2.1, ["Ride"] = 32.65, ["Neon"] = 6.36, ["Neon|Ride"] = 100.37, ["Mega"] = 93.94, ["Mega|Ride"] = 122.07}},
    ["rbxassetid://3743720235"] = {name = "Capybara", prices = {["default"] = 39.38, ["Fly"] = 219.56, ["Ride"] = 113.06, ["Fly|Ride"] = 149.94, ["Neon"] = 265.83, ["Neon|Ride"] = 365.44, ["Neon|Fly|Ride"] = 529.52, ["Mega"] = 2625, ["Mega|Ride"] = 2817.96, ["Mega|Fly|Ride"] = 1156.32}},
    ["rbxassetid://106815320234576"] = {name = "Ehecatl", prices = {["default"] = 2.1, ["Fly"] = 33.81, ["Ride"] = 52.5, ["Fly|Ride"] = 70.66, ["Neon"] = 6.57, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 94.5, ["Mega"] = 52.5, ["Mega|Ride"] = 138.56, ["Mega|Fly|Ride"] = 209.35}},
    ["rbxassetid://110449571836616"] = {name = "Irish Setter", prices = {["default"] = 4.72, ["Ride"] = 2254.52, ["Neon"] = 17.52, ["Neon|Ride"] = 128.91, ["Mega"] = 80.07, ["Mega|Ride"] = 173.2, ["Mega|Fly|Ride"] = 544.69}},
    ["rbxassetid://93751644677101"] = {name = "Winter Doe", prices = {["default"] = 14.44, ["Ride"] = 210, ["Fly|Ride"] = 210.25, ["Neon"] = 70.8, ["Neon|Ride"] = 139.47, ["Neon|Fly|Ride"] = 691.03, ["Mega"] = 234.84, ["Mega|Ride"] = 288.75, ["Mega|Fly|Ride"] = 950.84}},
    ["rbxassetid://90667836208550"] = {name = "Munchkin Cat", prices = {["default"] = 378.44, ["Ride"] = 400.32, ["Fly|Ride"] = 490.88, ["Neon"] = 1102.5, ["Neon|Ride"] = 1172.98, ["Neon|Fly|Ride"] = 1307.25, ["Mega"] = 4106.01, ["Mega|Ride"] = 3806.25, ["Mega|Fly|Ride"] = 3542.44}},
    ["rbxassetid://3743734696"] = {name = "Rhino", prices = {["default"] = 39.38, ["Ride"] = 46.98, ["Fly|Ride"] = 81.38, ["Neon"] = 249.35, ["Neon|Fly"] = 313.49, ["Neon|Ride"] = 158.1, ["Neon|Fly|Ride"] = 200.76, ["Mega|Fly|Ride"] = 984.38}},
    ["rbxassetid://7734928397"] = {name = "Halloween Blue Scorpion", prices = {["default"] = 2.1, ["Fly"] = 32.76, ["Ride"] = 18.38, ["Fly|Ride"] = 72.19, ["Neon"] = 7.41, ["Neon|Fly"] = 85.32, ["Neon|Ride"] = 42.27, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 82.43, ["Mega|Ride"] = 71.19, ["Mega|Fly|Ride"] = 626.84}},
    ["rbxassetid://116859365721104"] = {name = "Shadow Dragon Ducky", prices = {["default"] = 17.07, ["Fly"] = 109.88, ["Ride"] = 39.38, ["Fly|Ride"] = 98.43, ["Neon"] = 35.43, ["Neon|Fly"] = 142.01, ["Neon|Ride"] = 74.82, ["Neon|Fly|Ride"] = 176.48, ["Mega"] = 215.25, ["Mega|Fly"] = 393.07, ["Mega|Ride"] = 247.95, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://6060991084"] = {name = "Musk Ox", prices = {["default"] = 10.5, ["Ride"] = 35.94, ["Fly|Ride"] = 70.8, ["Neon"] = 105, ["Neon|Ride"] = 99.32, ["Mega|Ride"] = 469.62, ["Mega|Fly|Ride"] = 528.24}},
    ["rbxassetid://119284351481681"] = {name = "Violet Friend", prices = {["default"] = 2.63, ["Neon"] = 25.85, ["Mega"] = 62.91, ["Mega|Ride"] = 94.5}},
    ["rbxassetid://10971808356"] = {name = "Basilisk", prices = {["default"] = 2.63, ["Fly"] = 86.63, ["Ride"] = 20.01, ["Fly|Ride"] = 66.57, ["Neon"] = 26.25, ["Neon|Ride"] = 46.5, ["Neon|Fly|Ride"] = 215.56, ["Mega"] = 548.31, ["Mega|Ride"] = 486.94, ["Mega|Fly|Ride"] = 493.38}},
    ["rbxassetid://3744706727"] = {name = "Platypus", prices = {["default"] = 106.32, ["Fly"] = 131.25, ["Ride"] = 141.58, ["Fly|Ride"] = 223.13, ["Neon|Ride"] = 590.63, ["Neon|Fly|Ride"] = 606.51, ["Mega"] = 2449.2, ["Mega|Ride"] = 2564.38, ["Mega|Fly|Ride"] = 2827.13}},
    ["rbxassetid://12480556316"] = {name = "Black Macaque", prices = {["default"] = 25.67, ["Ride"] = 63.41, ["Fly|Ride"] = 144, ["Neon"] = 192.94, ["Neon|Ride"] = 189.13, ["Mega"] = 845.3, ["Mega|Ride"] = 704.76}},
    ["rbxassetid://4849941000"] = {name = "Dalmatian", prices = {["default"] = 2817.28, ["Ride"] = 2680.68, ["Fly|Ride"] = 2415, ["Neon"] = 12677.66, ["Neon|Fly|Ride"] = 7607.53, ["Mega|Fly|Ride"] = 26250}},
    ["rbxassetid://139319822015938"] = {name = "Sea Skeleton Panda", prices = {["default"] = 2.63, ["Fly"] = 65625, ["Ride"] = 41.89, ["Fly|Ride"] = 170.63, ["Neon"] = 13.13, ["Neon|Ride"] = 35.94, ["Neon|Fly|Ride"] = 197.6, ["Mega"] = 106.95, ["Mega|Ride"] = 169.32, ["Mega|Fly|Ride"] = 1267.77}},
    ["rbxassetid://104838807480936"] = {name = "Winter Fawn", prices = {["default"] = 21, ["Ride"] = 90.87, ["Neon"] = 44.39, ["Neon|Fly|Ride"] = 211.34, ["Mega"] = 183.86, ["Mega|Ride"] = 338.13, ["Mega|Fly|Ride"] = 673.31}},
    ["rbxassetid://100705885132301"] = {name = "Cabbit", prices = {["default"] = 918.75, ["Fly"] = 1409.35, ["Ride"] = 918.75, ["Fly|Ride"] = 1023.75, ["Neon"] = 2598.75, ["Neon|Ride"] = 3150, ["Neon|Fly|Ride"] = 3131.28, ["Mega|Fly|Ride"] = 16903.55}},
    ["rbxassetid://12480406935"] = {name = "Binturong", prices = {["default"] = 45.94, ["Ride"] = 44.63, ["Fly|Ride"] = 262.5, ["Neon"] = 234.82, ["Neon|Ride"] = 291.72, ["Mega"] = 840, ["Mega|Ride"] = 803.25, ["Mega|Fly|Ride"] = 752.07}},
    ["rbxassetid://73245262062822"] = {name = "Prism Snake", prices = {["default"] = 6.13, ["Ride"] = 31.7, ["Neon"] = 17.59, ["Neon|Ride"] = 73.97, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 211.34, ["Mega|Ride"] = 349.75, ["Mega|Fly|Ride"] = 234.78}},
    ["rbxassetid://113717425344888"] = {name = "Magpie", prices = {["default"] = 2.63, ["Fly"] = 39.38, ["Neon"] = 4.24, ["Neon|Ride"] = 52.5, ["Mega"] = 29.59, ["Mega|Ride"] = 68.25, ["Mega|Fly|Ride"] = 126.79}},
    ["rbxassetid://10318105900"] = {name = "Purple Butterfly", prices = {["default"] = 91.8, ["Ride"] = 125.99, ["Neon"] = 704.68, ["Neon|Fly|Ride"] = 544.69, ["Mega"] = 5250, ["Mega|Fly|Ride"] = 2661.12}},
    ["rbxassetid://95049698731940"] = {name = "Throwback Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15503941919"] = {name = "Arctic Hare", prices = {["default"] = 8.4, ["Neon"] = 19.69, ["Neon|Ride"] = 113.06, ["Mega"] = 162.79, ["Mega|Fly|Ride"] = 408.86}},
    ["rbxassetid://10274421272"] = {name = "Royal Corgi", prices = {["default"] = 77.49, ["Ride"] = 291.38, ["Neon"] = 514.52, ["Neon|Ride"] = 525, ["Mega|Fly|Ride"] = 1795.13}},
    ["rbxassetid://13978968837"] = {name = "Bird of Paradise", prices = {["Fly"] = 105, ["Fly|Ride"] = 113.06, ["Neon"] = 32.82, ["Neon|Fly|Ride"] = 315, ["Mega"] = 224.01}},
    ["rbxassetid://3261465850"] = {name = "Pink Cat", prices = {["default"] = 246.04, ["Ride"] = 265.81, ["Fly|Ride"] = 325.29, ["Neon"] = 1096.56, ["Neon|Ride"] = 918.75, ["Neon|Fly|Ride"] = 980.49, ["Mega|Fly|Ride"] = 3937.48}},
    ["rbxassetid://8969010905"] = {name = "Red Fox", prices = {["default"] = 3.29, ["Fly"] = 87.46, ["Ride"] = 30.65, ["Fly|Ride"] = 99.65, ["Neon"] = 50.72, ["Neon|Ride"] = 62.22, ["Neon|Fly|Ride"] = 113.07, ["Mega"] = 225.75, ["Mega|Ride"] = 656.25, ["Mega|Fly|Ride"] = 432.64}},
    ["rbxassetid://3181728128"] = {name = "Red Panda", prices = {["default"] = 2.1, ["Fly"] = 24.31, ["Ride"] = 20.09, ["Fly|Ride"] = 42.27, ["Neon"] = 5.92, ["Neon|Fly"] = 38.07, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 53.9, ["Mega"] = 39.38, ["Mega|Fly"] = 104.87, ["Mega|Ride"] = 73.5, ["Mega|Fly|Ride"] = 118.29}},
    ["rbxassetid://13077769577"] = {name = "Pelican", prices = {["default"] = 832.13, ["Fly"] = 1113.53, ["Ride"] = 903, ["Fly|Ride"] = 1026.9, ["Neon|Ride"] = 7748.18, ["Neon|Fly|Ride"] = 4226.4, ["Mega"] = 28177.94}},
    ["rbxassetid://115281603518501"] = {name = "DJ Snooze", prices = {["default"] = 17.62, ["Fly"] = 986.28, ["Ride"] = 42.27, ["Neon"] = 42.3, ["Mega"] = 131.24, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 417.32}},
    ["rbxassetid://111847888001946"] = {name = "Choco Penguin", prices = {["default"] = 11.75, ["Fly"] = 47.25, ["Ride"] = 44.16, ["Neon"] = 35.94, ["Neon|Ride"] = 70.8, ["Neon|Fly|Ride"] = 139.89, ["Mega"] = 183.75, ["Mega|Ride"] = 190.09, ["Mega|Fly|Ride"] = 267.26}},
    ["rbxassetid://4621220487"] = {name = "Panda", prices = {["default"] = 38.07, ["Fly"] = 44.54, ["Ride"] = 44.63, ["Fly|Ride"] = 83.47, ["Neon|Ride"] = 180.25, ["Neon|Fly|Ride"] = 157.35, ["Mega"] = 2113.2, ["Mega|Fly|Ride"] = 696.94}},
    ["rbxassetid://12917347184"] = {name = "Flower Power Duckling", prices = {["default"] = 42, ["Fly"] = 79.25, ["Ride"] = 37, ["Fly|Ride"] = 86.63, ["Neon"] = 59.07, ["Neon|Ride"] = 112.83, ["Neon|Fly|Ride"] = 282.13, ["Mega"] = 393.75, ["Mega|Ride"] = 352.93, ["Mega|Fly|Ride"] = 442.31}},
    ["rbxassetid://93775555430694"] = {name = "Pumpkin Friend", prices = {["default"] = 28.4, ["Ride"] = 65.63, ["Fly|Ride"] = 111.57, ["Neon"] = 108.83, ["Neon|Ride"] = 221.88, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 704.76, ["Mega|Ride"] = 352.93, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://83317902236850"] = {name = "Kakapo", prices = {["default"] = 2.1, ["Ride"] = 116.59, ["Fly|Ride"] = 234.82, ["Neon"] = 2.24, ["Neon|Ride"] = 31.7, ["Mega"] = 17.07, ["Mega|Ride"] = 141.6}},
    ["rbxassetid://5862774043"] = {name = "Ghost Bunny", prices = {["default"] = 32.82, ["Fly"] = 48.57, ["Ride"] = 53, ["Fly|Ride"] = 90.56, ["Neon"] = 233.49, ["Neon|Ride"] = 236.07, ["Neon|Fly|Ride"] = 242.82, ["Mega"] = 3381.13, ["Mega|Fly|Ride"] = 1279.69}},
    ["rbxassetid://10639131895"] = {name = "Spider Crab", prices = {["default"] = 2.1, ["Fly"] = 89.66, ["Ride"] = 28.54, ["Fly|Ride"] = 113.06, ["Neon"] = 42, ["Neon|Ride"] = 141.07, ["Neon|Fly|Ride"] = 141.6, ["Mega"] = 773.07, ["Mega|Ride"] = 271.69, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://10193736072"] = {name = "Red Crowned Crane", prices = {["default"] = 2.1, ["Fly"] = 26.16, ["Ride"] = 21.14, ["Fly|Ride"] = 53.9, ["Neon|Ride"] = 42.24, ["Neon|Fly|Ride"] = 131.24, ["Mega"] = 1043.93, ["Mega|Ride"] = 282.13, ["Mega|Fly|Ride"] = 203.44}},
    ["rbxassetid://13804047294"] = {name = "Arctic Tern", prices = {["default"] = 4.14, ["Ride"] = 176.45, ["Neon"] = 26.24, ["Neon|Fly|Ride"] = 105.68, ["Mega"] = 262.5, ["Mega|Ride"] = 196.88}},
    ["rbxassetid://14883937353"] = {name = "Ghost Dog", prices = {["default"] = 22.32, ["Fly"] = 262.23, ["Ride"] = 63.41, ["Fly|Ride"] = 129.94, ["Neon"] = 105, ["Neon|Ride"] = 174.57, ["Neon|Fly|Ride"] = 224.01, ["Mega|Ride"] = 767.86, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://103241919688695"] = {name = "2025 Birthday Butterfly", prices = {["default"] = 6.57, ["Neon"] = 23.62, ["Neon|Ride"] = 63.4, ["Mega"] = 104.89, ["Mega|Fly"] = 704.76, ["Mega|Fly|Ride"] = 313.43}},
    ["rbxassetid://86594144838863"] = {name = "Tree Frog", prices = {["default"] = 2.1, ["Ride"] = 27.48, ["Neon"] = 2.5, ["Neon|Ride"] = 26.25, ["Mega"] = 23.49, ["Mega|Ride"] = 51.19, ["Mega|Fly|Ride"] = 203.44}},
    ["rbxassetid://99048375832409"] = {name = "Shih Tzu", prices = {["default"] = 2.1, ["Ride"] = 27.2, ["Neon"] = 2.63, ["Neon|Fly"] = 393.59, ["Neon|Ride"] = 28.54, ["Neon|Fly|Ride"] = 78.68, ["Mega"] = 22.32, ["Mega|Fly"] = 73.86, ["Mega|Ride"] = 52.85, ["Mega|Fly|Ride"] = 106.94}},
    ["rbxassetid://6998403122"] = {name = "Kirin", prices = {["default"] = 2.1, ["Fly"] = 25.89, ["Ride"] = 24, ["Fly|Ride"] = 38.07, ["Neon"] = 5.25, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 141.6, ["Mega"] = 105.68, ["Mega|Ride"] = 126.81, ["Mega|Fly|Ride"] = 242.17}},
    ["rbxassetid://15930472964"] = {name = "Gila Monster", prices = {["default"] = 2.63, ["Ride"] = 28.58, ["Fly|Ride"] = 57.06, ["Neon"] = 15.86, ["Mega"] = 142.01, ["Mega|Ride"] = 147.91, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://5721843144"] = {name = "Dilophosaurus", prices = {["default"] = 4.2, ["Fly"] = 26.25, ["Ride"] = 16.96, ["Fly|Ride"] = 42.4, ["Neon"] = 17.07, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 80.07, ["Mega"] = 290.58, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 363.57}},
    ["rbxassetid://109520235810036"] = {name = "Mini Schnauzer", prices = {["default"] = 65.63, ["Fly|Ride"] = 395.14, ["Neon"] = 250.69, ["Neon|Ride"] = 412.05, ["Neon|Fly|Ride"] = 1056.61, ["Mega"] = 1028.09, ["Mega|Fly"] = 986.88, ["Mega|Ride"] = 911.87, ["Mega|Fly|Ride"] = 898.93}},
    ["rbxassetid://3181728229"] = {name = "Snow Cat", prices = {["default"] = 2.1, ["Fly"] = 26.43, ["Ride"] = 17.07, ["Fly|Ride"] = 41.67, ["Neon"] = 3.29, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 20.9, ["Neon|Fly|Ride"] = 56.85, ["Mega"] = 38.17, ["Mega|Ride"] = 55.13, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://4506925747"] = {name = "Wolf", prices = {["default"] = 10.5, ["Fly"] = 42.27, ["Ride"] = 65.63, ["Fly|Ride"] = 80.07, ["Neon"] = 51.65, ["Neon|Fly"] = 70.66, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 105, ["Mega"] = 845.3, ["Mega|Ride"] = 311.72, ["Mega|Fly|Ride"] = 308.48}},
    ["rbxassetid://5862774473"] = {name = "Albino Bat", prices = {["default"] = 10.5, ["Fly"] = 98.63, ["Ride"] = 27.57, ["Fly|Ride"] = 70.97, ["Neon"] = 105.67, ["Neon|Ride"] = 73.5, ["Neon|Fly|Ride"] = 149.16, ["Mega"] = 1267.93, ["Mega|Ride"] = 420, ["Mega|Fly|Ride"] = 610.41}},
    ["rbxassetid://14978701751"] = {name = "Scarecrow", prices = {["default"] = 3.52, ["Fly"] = 140.38, ["Ride"] = 46.96, ["Neon"] = 6.57, ["Neon|Ride"] = 70.8, ["Mega"] = 196.87, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 352.88}},
    ["rbxassetid://10235589000"] = {name = "Corgi", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 17.33, ["Fly|Ride"] = 141.58, ["Neon"] = 3.94, ["Neon|Fly"] = 59.07, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 64.32, ["Mega"] = 41.2, ["Mega|Fly"] = 91.88, ["Mega|Ride"] = 52.5, ["Mega|Fly|Ride"] = 211.31}},
    ["rbxassetid://103710623311342"] = {name = "Ghost Chick", prices = {["default"] = 3.94, ["Fly"] = 78.07, ["Ride"] = 28.53, ["Fly|Ride"] = 141.39, ["Neon"] = 18.38, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 100.37, ["Neon|Fly|Ride"] = 211.34, ["Mega"] = 118.13, ["Mega|Fly"] = 735, ["Mega|Ride"] = 103.69, ["Mega|Fly|Ride"] = 283.5}},
    ["rbxassetid://4440866423"] = {name = "Cow", prices = {["default"] = 1050, ["Ride"] = 1048.69, ["Fly|Ride"] = 1102.49, ["Neon|Ride"] = 2266.69, ["Neon|Fly|Ride"] = 2296.88, ["Mega|Fly|Ride"] = 7434}},
    ["rbxassetid://15093139154"] = {name = "Slime", prices = {["default"] = 65.63, ["Ride"] = 88.07, ["Neon"] = 260.24, ["Neon|Ride"] = 261.19, ["Neon|Fly|Ride"] = 600.16, ["Mega"] = 1215.11, ["Mega|Ride"] = 1215.11, ["Mega|Fly|Ride"] = 1223}},
    ["rbxassetid://82170828935980"] = {name = "Dracula Fish", prices = {["default"] = 2.1, ["Fly"] = 73.97, ["Neon"] = 5.23, ["Neon|Ride"] = 75.45, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 65.63, ["Mega|Fly|Ride"] = 157.32}},
    ["rbxassetid://11109302289"] = {name = "Zombie Wolf", prices = {["default"] = 39.38, ["Ride"] = 56.44, ["Fly|Ride"] = 194.4, ["Neon"] = 190.8, ["Neon|Ride"] = 225.67, ["Neon|Fly|Ride"] = 294.81, ["Mega"] = 1286.95, ["Mega|Ride"] = 992.6, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://15369729071"] = {name = "Nutcracker Squirrel", prices = {["default"] = 7.88, ["Ride"] = 27.01, ["Fly|Ride"] = 281.03, ["Neon"] = 39.38, ["Neon|Ride"] = 282.09, ["Neon|Fly|Ride"] = 282.13, ["Mega"] = 252, ["Mega|Fly|Ride"] = 1056.48}},
    ["rbxassetid://9800792849"] = {name = "Goat", prices = {["default"] = 269.07, ["Fly"] = 422.55, ["Ride"] = 288.75, ["Fly|Ride"] = 345.78, ["Neon"] = 1345.96, ["Neon|Ride"] = 1320.38, ["Neon|Fly|Ride"] = 1048.95, ["Mega|Fly|Ride"] = 3918.36}},
    ["rbxassetid://12509687499"] = {name = "Banded Palm Civet", prices = {["default"] = 2.63, ["Fly"] = 102.37, ["Ride"] = 22.32, ["Fly|Ride"] = 129.93, ["Neon"] = 19.69, ["Mega"] = 399.41, ["Mega|Fly"] = 282.13}},
    ["rbxassetid://10381386150"] = {name = "Rhino Beetle", prices = {["default"] = 2.1, ["Neon"] = 57.06, ["Neon|Ride"] = 141.6}},
    ["rbxassetid://130734656883878"] = {name = "Merry Mistletroll", prices = {["default"] = 65.63, ["Ride"] = 121.51, ["Fly|Ride"] = 282.96, ["Neon"] = 141.58, ["Neon|Ride"] = 422.6, ["Mega"] = 1127.4, ["Mega|Ride"] = 714.67, ["Mega|Fly|Ride"] = 1000.79}},
    ["rbxassetid://15923337068"] = {name = "Oryx", prices = {["default"] = 3.94, ["Ride"] = 48.54, ["Neon"] = 21, ["Mega"] = 247.26, ["Mega|Ride"] = 277.91}},
    ["rbxassetid://6245080365"] = {name = "Ox", prices = {["default"] = 2.1, ["Fly"] = 18.38, ["Ride"] = 15.91, ["Fly|Ride"] = 32.82, ["Neon"] = 3.94, ["Neon|Fly"] = 31.71, ["Neon|Ride"] = 20.98, ["Neon|Fly|Ride"] = 44.4, ["Mega"] = 31.49, ["Mega|Fly"] = 31.71, ["Mega|Ride"] = 234816.01, ["Mega|Fly|Ride"] = 89.25}},
    ["rbxassetid://13810870050"] = {name = "African Wild Dog", prices = {["default"] = 4199.99, ["Ride"] = 4318.13, ["Fly|Ride"] = 4199.99, ["Neon"] = 18784.65, ["Neon|Fly|Ride"] = 21359.63, ["Mega|Fly|Ride"] = 87335.29}},
    ["rbxassetid://12596400214"] = {name = "Goldfish", prices = {["default"] = 12.69, ["Ride"] = 31.71, ["Neon"] = 173.77, ["Neon|Ride"] = 126.79, ["Mega"] = 469.64, ["Mega|Fly|Ride"] = 523.69}},
    ["rbxassetid://4736656915"] = {name = "Australian Kelpie", prices = {["default"] = 3.94, ["Ride"] = 23.49, ["Fly|Ride"] = 38.07, ["Neon"] = 26.25, ["Neon|Ride"] = 34.13, ["Neon|Fly|Ride"] = 78.68, ["Mega"] = 281.79, ["Mega|Ride"] = 124.35, ["Mega|Fly|Ride"] = 202.51}},
    ["rbxassetid://3743711305"] = {name = "Crocodile", prices = {["default"] = 459.38, ["Fly"] = 514.52, ["Ride"] = 420, ["Fly|Ride"] = 516.75, ["Neon"] = 1050, ["Neon|Ride"] = 1594.69, ["Neon|Fly|Ride"] = 1517.3, ["Mega|Fly|Ride"] = 6057.82}},
    ["rbxassetid://74373220330198"] = {name = "Officer Gibbon", prices = {["default"] = 6.57, ["Ride"] = 52.5, ["Neon"] = 17.07, ["Neon|Ride"] = 158.06, ["Mega"] = 141.6, ["Mega|Fly|Ride"] = 690.38}},
    ["rbxassetid://18508184138"] = {name = "Peregrine Falcon", prices = {["default"] = 11.75, ["Fly"] = 110.12, ["Ride"] = 157.34, ["Neon"] = 93.94, ["Neon|Ride"] = 141.58, ["Neon|Fly|Ride"] = 164.07, ["Mega"] = 386.54, ["Mega|Ride"] = 401.63}},
    ["rbxassetid://92389214029179"] = {name = "Kaijunior", prices = {["default"] = 2.1, ["Ride"] = 19.69, ["Fly|Ride"] = 82.55, ["Neon"] = 7.66, ["Neon|Fly"] = 43.32, ["Neon|Ride"] = 31.71, ["Neon|Fly|Ride"] = 70.88, ["Mega"] = 39.38, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 159.54}},
    ["rbxassetid://3409443986"] = {name = "Flamingo", prices = {["default"] = 627.38, ["Fly"] = 774.88, ["Ride"] = 597.19, ["Fly|Ride"] = 689.07, ["Neon|Fly|Ride"] = 1967.44, ["Mega|Fly|Ride"] = 8751.75}},
    ["rbxassetid://126933432685319"] = {name = "Cattuccino", prices = {["default"] = 7.88, ["Ride"] = 57.06, ["Neon"] = 19.69, ["Neon|Ride"] = 105.67, ["Neon|Fly|Ride"] = 648.38, ["Mega"] = 154.43, ["Mega|Ride"] = 209.55, ["Mega|Fly|Ride"] = 275.85}},
    ["rbxassetid://11631390464"] = {name = "Ermine", prices = {["default"] = 5.24, ["Fly"] = 49.66, ["Ride"] = 35.44, ["Fly|Ride"] = 131.25, ["Neon"] = 51.19, ["Neon|Ride"] = 63.86, ["Neon|Fly|Ride"] = 3915.57, ["Mega"] = 244.18, ["Mega|Ride"] = 227.67, ["Mega|Fly|Ride"] = 327.42}},
    ["rbxassetid://4708551221"] = {name = "Emu", prices = {["default"] = 2.63, ["Fly"] = 28.54, ["Ride"] = 20.9, ["Fly|Ride"] = 55.19, ["Neon"] = 19.38, ["Neon|Ride"] = 28.46, ["Neon|Fly|Ride"] = 65.77, ["Mega"] = 196.88, ["Mega|Ride"] = 158.82, ["Mega|Fly|Ride"] = 208.69}},
    ["rbxassetid://16088266364"] = {name = "Burning Bunny", prices = {["default"] = 79.84, ["Ride"] = 78.68, ["Neon"] = 99.32, ["Neon|Ride"] = 126.79, ["Neon|Fly|Ride"] = 313.5, ["Mega"] = 561.07, ["Mega|Ride"] = 452.82, ["Mega|Fly|Ride"] = 616.88}},
    ["rbxassetid://80832101513100"] = {name = "2026 Birthday Butterfly", prices = {["default"] = 2.1, ["Ride"] = 39.37, ["Neon"] = 3.82, ["Neon|Ride"] = 69.75, ["Neon|Fly|Ride"] = 208.69, ["Mega"] = 19.69, ["Mega|Ride"] = 87.76, ["Mega|Fly|Ride"] = 177.19}},
    ["rbxassetid://14639007389"] = {name = "Caterpillar", prices = {["default"] = 420, ["Ride"] = 485.63, ["Fly|Ride"] = 627.56, ["Neon"] = 2958.13, ["Neon|Ride"] = 2093.94, ["Neon|Fly|Ride"] = 2362.5, ["Mega|Ride"] = 9157.83, ["Mega|Fly|Ride"] = 7848.75}},
    ["rbxassetid://82920146813845"] = {name = "Little Lamb", prices = {["default"] = 2.1, ["Ride"] = 97.21, ["Neon"] = 9.19, ["Neon|Ride"] = 48.59, ["Mega"] = 65.63, ["Mega|Ride"] = 133.24, ["Mega|Fly|Ride"] = 247.93}},
    ["rbxassetid://96424154406922"] = {name = "Crimson Cape", prices = {["default"] = 2.1, ["Ride"] = 27.3, ["Neon"] = 3.94, ["Neon|Ride"] = 211.35, ["Mega"] = 40.69, ["Mega|Ride"] = 84.55, ["Mega|Fly|Ride"] = 265.19}},
    ["rbxassetid://109008428989602"] = {name = "Pangolin", prices = {["default"] = 2.1, ["Ride"] = 60.37, ["Neon"] = 3.68, ["Neon|Ride"] = 34.13, ["Mega"] = 41.22, ["Mega|Fly"] = 156.39}},
    ["rbxassetid://16722909218"] = {name = "Floral Eggy", prices = {["default"] = 3.94, ["Ride"] = 157.34, ["Neon"] = 17.07, ["Mega"] = 211.34, ["Mega|Ride"] = 328.13}},
    ["rbxassetid://76735046136809"] = {name = "Frostbite Cub", prices = {["default"] = 52.5, ["Ride"] = 88.87, ["Fly|Ride"] = 143.07, ["Neon"] = 233.62, ["Neon|Ride"] = 316.32, ["Neon|Fly|Ride"] = 350.8, ["Mega"] = 638.79, ["Mega|Ride"] = 671.83, ["Mega|Fly|Ride"] = 730.04}},
    ["rbxassetid://15684947715"] = {name = "Quokka", prices = {["default"] = 19.55, ["Ride"] = 61.29, ["Neon"] = 72.19, ["Neon|Ride"] = 130.33, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 422.6, ["Mega|Fly|Ride"] = 493.5}},
    ["rbxassetid://5721843001"] = {name = "Deinonychus", prices = {["default"] = 4.71, ["Fly"] = 26.25, ["Ride"] = 19.69, ["Fly|Ride"] = 36.75, ["Neon"] = 45.45, ["Neon|Ride"] = 30.86, ["Neon|Fly|Ride"] = 46.98, ["Mega"] = 326.17, ["Mega|Ride"] = 238.04, ["Mega|Fly|Ride"] = 246.47}},
    ["rbxassetid://16999461770"] = {name = "Inmate Capuchin Monkey", prices = {["default"] = 13.89, ["Ride"] = 92.98, ["Neon"] = 180.83, ["Neon|Ride"] = 158.82, ["Neon|Fly|Ride"] = 211.34, ["Mega|Ride"] = 783.13, ["Mega|Fly|Ride"] = 986.75}},
    ["rbxassetid://119664699815373"] = {name = "Frozen Penguin", prices = {["default"] = 5.25, ["Ride"] = 32.76, ["Fly|Ride"] = 362.25, ["Neon"] = 17.61, ["Neon|Ride"] = 43.73, ["Mega"] = 131.25, ["Mega|Ride"] = 206.06, ["Mega|Fly|Ride"] = 244.06}},
    ["rbxassetid://5067924307"] = {name = "Business Monkey", prices = {["default"] = 19.85, ["Ride"] = 32.76, ["Fly|Ride"] = 59.17, ["Neon"] = 228.74, ["Neon|Ride"] = 134.18, ["Neon|Fly|Ride"] = 211.34, ["Mega"] = 949.9, ["Mega|Ride"] = 939.27, ["Mega|Fly|Ride"] = 704.68}},
    ["rbxassetid://126192643157832"] = {name = "Manta Ray", prices = {["default"] = 103.32, ["Fly"] = 874.13, ["Mega|Ride"] = 590.63}},
    ["rbxassetid://4440866911"] = {name = "Silly Duck", prices = {["default"] = 63, ["Fly"] = 115.5, ["Ride"] = 94.5, ["Fly|Ride"] = 139.13, ["Neon"] = 291.6, ["Neon|Fly"] = 348.04, ["Neon|Ride"] = 299.25, ["Neon|Fly|Ride"] = 432.08, ["Mega|Ride"] = 1331.43, ["Mega|Fly|Ride"] = 1316.44}},
    ["rbxassetid://110544962124445"] = {name = "Cake Friend", prices = {["default"] = 57.06, ["Fly"] = 141.57, ["Ride"] = 102.21, ["Fly|Ride"] = 282.1, ["Neon"] = 192.29, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 364.88, ["Mega|Ride"] = 555.61, ["Mega|Fly|Ride"] = 612.94}},
    ["rbxassetid://16127157068"] = {name = "Rice Cake Rabbit", prices = {["default"] = 19.69, ["Ride"] = 79.25, ["Neon"] = 211.31, ["Mega"] = 561.07, ["Mega|Ride"] = 1056.61, ["Mega|Fly|Ride"] = 1266.72}},
    ["rbxassetid://7734900613"] = {name = "Halloween Evil Dachshund", prices = {["default"] = 10.58, ["Ride"] = 31.71, ["Fly|Ride"] = 65.63, ["Neon"] = 61.52, ["Neon|Fly"] = 169.04, ["Neon|Ride"] = 96.15, ["Neon|Fly|Ride"] = 116.28, ["Mega"] = 457.47, ["Mega|Ride"] = 319.85, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://9664282145"] = {name = "Robot", prices = {["default"] = 2.1, ["Fly"] = 28.54, ["Ride"] = 17.07, ["Fly|Ride"] = 41.82, ["Neon"] = 3.94, ["Neon|Fly"] = 24.89, ["Neon|Ride"] = 21.14, ["Neon|Fly|Ride"] = 57.75, ["Mega"] = 45.94, ["Mega|Fly"] = 704.76, ["Mega|Ride"] = 63, ["Mega|Fly|Ride"] = 185.95}},
    ["rbxassetid://3261465791"] = {name = "Pink Egg", prices = {["default"] = 969.93}},
    ["rbxassetid://126725051633301"] = {name = "Headless Horse", prices = {["default"] = 26.24, ["Ride"] = 125.73, ["Fly|Ride"] = 105.67, ["Neon"] = 134.18, ["Neon|Ride"] = 196.49, ["Neon|Fly|Ride"] = 422.68, ["Mega"] = 564.24, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 494.9}},
    ["rbxassetid://88554799028713"] = {name = "Sneak Weasel", prices = {["default"] = 2.1, ["Ride"] = 46.98, ["Neon"] = 3.29, ["Neon|Ride"] = 37, ["Neon|Fly|Ride"] = 295.68, ["Mega"] = 26.23, ["Mega|Ride"] = 85.32, ["Mega|Fly|Ride"] = 538.81}},
    ["rbxassetid://14639008203"] = {name = "English Sheepdog", prices = {["default"] = 28.54, ["Ride"] = 65.63, ["Fly|Ride"] = 278.92, ["Neon"] = 315, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 544.69, ["Mega"] = 630, ["Mega|Ride"] = 832.61, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://133131190079833"] = {name = "Oakee", prices = {["default"] = 2.1, ["Neon"] = 2.63, ["Neon|Ride"] = 105, ["Mega"] = 46.98}},
    ["rbxassetid://79856043024325"] = {name = "Chestnut Glyptodon", prices = {["default"] = 2.1, ["Neon"] = 5.25, ["Neon|Ride"] = 157.34, ["Mega"] = 41.11, ["Mega|Ride"] = 199.5, ["Mega|Fly|Ride"] = 273}},
    ["rbxassetid://12720028898"] = {name = "Hare", prices = {["default"] = 133.88, ["Ride"] = 162.11, ["Fly|Ride"] = 344.43, ["Neon"] = 591.64, ["Neon|Ride"] = 590.63, ["Neon|Fly|Ride"] = 656.19, ["Mega|Ride"] = 6457.45, ["Mega|Fly|Ride"] = 2034.38}},
    ["rbxassetid://16897788024"] = {name = "Capuchin Monkey", prices = {["default"] = 4.09, ["Fly"] = 26.11, ["Ride"] = 25.36, ["Fly|Ride"] = 48.57, ["Neon"] = 11.43, ["Neon|Ride"] = 40.16, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 107.62, ["Mega|Ride"] = 101.07, ["Mega|Fly|Ride"] = 564.17}},
    ["rbxassetid://121639546210522"] = {name = "Amber Butterfly", prices = {["default"] = 2.1, ["Fly"] = 30.97, ["Fly|Ride"] = 110.37, ["Neon"] = 5.24, ["Neon|Ride"] = 57.06, ["Neon|Fly|Ride"] = 101.46, ["Mega"] = 38.26, ["Mega|Ride"] = 93.11, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://79005166120532"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Fly"] = 44.63, ["Ride"] = 19.69, ["Neon"] = 4.24, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 35.44, ["Mega"] = 31.71, ["Mega|Ride"] = 71.97, ["Mega|Fly|Ride"] = 261.19}},
    ["rbxassetid://138741319376538"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 91.88, ["Neon"] = 5.25, ["Neon|Ride"] = 30.3, ["Neon|Fly|Ride"] = 141.6, ["Mega"] = 40.69, ["Mega|Ride"] = 95.7, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://133558151150234"] = {name = "Black Widow", prices = {["default"] = 39.38, ["Ride"] = 91.88, ["Fly|Ride"] = 211.31, ["Neon"] = 335.97, ["Neon|Ride"] = 345.49, ["Neon|Fly|Ride"] = 656.25, ["Mega"] = 1236.23, ["Mega|Ride"] = 1550.05, ["Mega|Fly|Ride"] = 1359.69}},
    ["rbxassetid://122945704087152"] = {name = "Chilling Spider", prices = {["default"] = 5.64, ["Ride"] = 139.47, ["Neon"] = 10.47, ["Neon|Ride"] = 110.37, ["Mega"] = 141.6, ["Mega|Ride"] = 557.17}},
    ["rbxassetid://1373237029"] = {name = "Big Head Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://2657668946"] = {name = "Cure All Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://1373237971"] = {name = "Grow Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4315743582"] = {name = "Honey Badger", prices = {["default"] = 361.55, ["Ride"] = 341.25, ["Fly|Ride"] = 446.16, ["Neon"] = 1267.77, ["Neon|Ride"] = 1123.04, ["Neon|Fly|Ride"] = 1267.93, ["Mega"] = 3633.66, ["Mega|Ride"] = 3519.54, ["Mega|Fly|Ride"] = 3154.29}},
    ["rbxassetid://1373208271"] = {name = "Hyperspeed Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4047157976"] = {name = "Fly Potion", prices = {["default"] = 74.75}},
    ["rbxassetid://3342628435"] = {name = "Ride Potion", prices = {["default"] = 42.59}},
    ["rbxassetid://1509389697"] = {name = "Adopt Me Boy Scooter", prices = {["default"] = 15.75}},
    ["rbxassetid://1509384540"] = {name = "Adopt Me Girl Scooter", prices = {["default"] = 19.03}},
    ["rbxassetid://1256627798"] = {name = "Adopt Me Snowboard 1", prices = {["default"] = 56.38}},
    ["rbxassetid://1256627585"] = {name = "Adopt Me Snowboard 2", prices = {["default"] = 39.38}},
    ["rbxassetid://2782643682"] = {name = "Axel", prices = {["default"] = 19.69}},
    ["rbxassetid://3009779146"] = {name = "Banana Car", prices = {["default"] = 15.86}},
    ["rbxassetid://1306904296"] = {name = "Bathtub", prices = {["default"] = 216.57}},
    ["rbxassetid://1307341557"] = {name = "Bethink Skateboard", prices = {["default"] = 22.3}},
    ["rbxassetid://908269395"] = {name = "Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://1509319125"] = {name = "Black Scooter", prices = {["default"] = 32.82}},
    ["rbxassetid://1306898658"] = {name = "Black Skateboard", prices = {["default"] = 7.8}},
    ["rbxassetid://1256625297"] = {name = "Black Snowboard", prices = {["default"] = 5.25}},
    ["rbxassetid://1266478264"] = {name = "Blue Neon Snowboard", prices = {["default"] = 262.38}},
    ["rbxassetid://4800244517"] = {name = "Blue Rider", prices = {["default"] = 2.1}},
    ["rbxassetid://1509318734"] = {name = "Blue Scooter", prices = {["default"] = 3.94}},
    ["rbxassetid://1306898360"] = {name = "Blue Skateboard", prices = {["default"] = 8.46}},
    ["rbxassetid://1256625905"] = {name = "Blue Snowboard", prices = {["default"] = 4.7}},
    ["rbxassetid://7165481985"] = {name = "Bubble Car", prices = {["default"] = 5.71}},
    ["rbxassetid://12115176522"] = {name = "Toxic Barrel", prices = {["default"] = 23.45}},
    ["rbxassetid://2657667116"] = {name = "Bunny Carriage", prices = {["default"] = 475.13}},
    ["rbxassetid://6475610034"] = {name = "Butterfly Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264167"] = {name = "Camper Van", prices = {["default"] = 2.63}},
    ["rbxassetid://2758237053"] = {name = "Car", prices = {["default"] = 2.1}},
    ["rbxassetid://14465252948"] = {name = "Super Jetpack", prices = {["default"] = 661.86}},
    ["rbxassetid://4754697599"] = {name = "Choo Choo Train", prices = {["default"] = 13.13}},
    ["rbxassetid://2408035766"] = {name = "Cloud", prices = {["default"] = 1114.32}},
    ["rbxassetid://5057099424"] = {name = "Clown Car", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099515"] = {name = "Clown Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2860616529"] = {name = "Convertible", prices = {["default"] = 115.59}},
    ["rbxassetid://4470750671"] = {name = "Cookie Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8203695278"] = {name = "Snowmobile", prices = {["default"] = 10.58}},
    ["rbxassetid://8243269978"] = {name = "Zamboni", prices = {["default"] = 2.1}},
    ["rbxassetid://1509385561"] = {name = "Cupcake Scooter", prices = {["default"] = 14.44}},
    ["rbxassetid://4822522305"] = {name = "Daisy Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8517689681"] = {name = "Landsailer", prices = {["default"] = 2.63}},
    ["rbxassetid://8566306089"] = {name = "Trireme", prices = {["default"] = 2.63}},
    ["rbxassetid://6504033614"] = {name = "Dino Truck", prices = {["default"] = 2.3}},
    ["rbxassetid://1512774745"] = {name = "Doge Scooter", prices = {["default"] = 27.48}},
    ["rbxassetid://1307341942"] = {name = "Doge Skateboard", prices = {["default"] = 68.52}},
    ["rbxassetid://3486906742"] = {name = "Dogmobile", prices = {["default"] = 43.32}},
    ["rbxassetid://2880427418"] = {name = "Donut Cycle", prices = {["default"] = 33.81}},
    ["rbxassetid://3486907843"] = {name = "Donut Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2782643731"] = {name = "Douglas", prices = {["default"] = 9.19}},
    ["rbxassetid://1509391407"] = {name = "Duck Scooter", prices = {["default"] = 13.09}},
    ["rbxassetid://9291032374"] = {name = "Egg Delivery Machine", prices = {["default"] = 6.57}},
    ["rbxassetid://1509377123"] = {name = "Emoji Scooter", prices = {["default"] = 13.13}},
    ["rbxassetid://9973767611"] = {name = "Harvest Truck", prices = {["default"] = 2.49}},
    ["rbxassetid://9973768669"] = {name = "Tractor", prices = {["default"] = 2.1}},
    ["rbxassetid://1307341332"] = {name = "Fidget Skateboard", prices = {["default"] = 22.32}},
    ["rbxassetid://1306904101"] = {name = "Fissy Skateboard", prices = {["default"] = 21}},
    ["rbxassetid://4823285384"] = {name = "Flower Wagon", prices = {["default"] = 6.56}},
    ["rbxassetid://7475653998"] = {name = "Fossil Paw Helicopter", prices = {["default"] = 2.1}},
    ["rbxassetid://9406027381"] = {name = "Starter Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://6475609765"] = {name = "Futuristic Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291832"] = {name = "Ghost Vehicle", prices = {["default"] = 1575}},
    ["rbxassetid://10905638416"] = {name = "Ancient Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760422"] = {name = "Bat Face Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://10919870588"] = {name = "Dapper Friend Carrier", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760559"] = {name = "Dirt Bike Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10905207734"] = {name = "Soapy Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9037078630"] = {name = "Horse And Carriage", prices = {["default"] = 308.23}},
    ["rbxassetid://10913434990"] = {name = "Unstable Triangle Car", prices = {["default"] = 3.94}},
    ["rbxassetid://8979306571"] = {name = "Wizard Caravan", prices = {["default"] = 2.24}},
    ["rbxassetid://1512770654"] = {name = "Glass Scooter", prices = {["default"] = 10.49}},
    ["rbxassetid://1306903971"] = {name = "Glass Skateboard", prices = {["default"] = 72.17}},
    ["rbxassetid://1256627375"] = {name = "Glass Snowboard", prices = {["default"] = 45.81}},
    ["rbxassetid://1064481531"] = {name = "GoKart", prices = {["default"] = 115.48}},
    ["rbxassetid://1509326491"] = {name = "Gold Scooter", prices = {["default"] = 10.5}},
    ["rbxassetid://1306902802"] = {name = "Gold Skateboard", prices = {["default"] = 22.33}},
    ["rbxassetid://12519249137"] = {name = "Bumper Car", prices = {["default"] = 2.1}},
    ["rbxassetid://12519249424"] = {name = "Circus Ball Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265134428"] = {name = "Green Neon Snowboard", prices = {["default"] = 187.87}},
    ["rbxassetid://7839195952"] = {name = "Halloween Black Ponycycle", prices = {["default"] = 14.44}},
    ["rbxassetid://11119263404"] = {name = "Headless Horseman's Biplane", prices = {["default"] = 7.35}},
    ["rbxassetid://10920073281"] = {name = "Throwing Knife Target", prices = {["default"] = 2.1}},
    ["rbxassetid://10920073157"] = {name = "Shadow Rider", prices = {["default"] = 63.41}},
    ["rbxassetid://11125166616"] = {name = "Unicorn Zombie Ponycycle", prices = {["default"] = 11.82}},
    ["rbxassetid://2848331544"] = {name = "Heart Hoverboard", prices = {["default"] = 3.94}},
    ["rbxassetid://2657670919"] = {name = "Horse Cycle", prices = {["default"] = 105}},
    ["rbxassetid://3163531592"] = {name = "Traveling House", prices = {["default"] = 24.93}},
    ["rbxassetid://4382798606"] = {name = "Hoverboard", prices = {["default"] = 6.54}},
    ["rbxassetid://6475613264"] = {name = "Hovercar", prices = {["default"] = 4.24}},
    ["rbxassetid://4797807001"] = {name = "Human Bubble", prices = {["default"] = 2.1}},
    ["rbxassetid://4588192578"] = {name = "Ice Cream Truck", prices = {["default"] = 10.5}},
    ["rbxassetid://4470749585"] = {name = "Ice Queen Sleigh", prices = {["default"] = 2.1}},
    ["rbxassetid://1509333762"] = {name = "Ice Scooter", prices = {["default"] = 10.4}},
    ["rbxassetid://6504033516"] = {name = "Imagination Box", prices = {["default"] = 8.39}},
    ["rbxassetid://10619155042"] = {name = "Street Racer", prices = {["default"] = 35.94}},
    ["rbxassetid://2749267159"] = {name = "Limo", prices = {["default"] = 2.1}},
    ["rbxassetid://8665606953"] = {name = "Dragon Train", prices = {["default"] = 111.57}},
    ["rbxassetid://11758583286"] = {name = "Crescent Moon Car", prices = {["default"] = 158.82}},
    ["rbxassetid://6276452323"] = {name = "Lunar Muscle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://7165482478"] = {name = "Magical Girl Car", prices = {["default"] = 7.66}},
    ["rbxassetid://7368045552"] = {name = "Magical Princess Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1306902978"] = {name = "Melon Skateboard", prices = {["default"] = 65.76}},
    ["rbxassetid://1512742703"] = {name = "Mono-Moped", prices = {["default"] = 59.31}},
    ["rbxassetid://2758236960"] = {name = "Moped", prices = {["default"] = 57.75}},
    ["rbxassetid://2758237011"] = {name = "Motorcycle", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264226"] = {name = "Muscle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://1509342852"] = {name = "Neon Black Scooter", prices = {["default"] = 22307.35}},
    ["rbxassetid://1306911569"] = {name = "Neon Black Skateboard", prices = {["default"] = 166.92}},
    ["rbxassetid://1509338320"] = {name = "Neon Blue Scooter", prices = {["default"] = 39.38}},
    ["rbxassetid://1306907175"] = {name = "Neon Blue Skateboard", prices = {["default"] = 52.5}},
    ["rbxassetid://1509342200"] = {name = "Neon Green Scooter", prices = {["default"] = 35.21}},
    ["rbxassetid://1306907671"] = {name = "Neon Green Skateboard", prices = {["default"] = 61.28}},
    ["rbxassetid://1509338451"] = {name = "Neon Orange Scooter", prices = {["default"] = 42}},
    ["rbxassetid://1306907450"] = {name = "Neon Orange Skateboard", prices = {["default"] = 42}},
    ["rbxassetid://1509339156"] = {name = "Neon Pink Scooter", prices = {["default"] = 78.19}},
    ["rbxassetid://1306911771"] = {name = "Neon Pink Skateboard", prices = {["default"] = 42}},
    ["rbxassetid://1509341495"] = {name = "Neon Red Scooter", prices = {["default"] = 54.51}},
    ["rbxassetid://1306907886"] = {name = "Neon Red Skateboard", prices = {["default"] = 31.71}},
    ["rbxassetid://1256625563"] = {name = "Orange Neon Snowboard", prices = {["default"] = 26.25}},
    ["rbxassetid://1509340494"] = {name = "Neon White Scooter", prices = {["default"] = 40.69}},
    ["rbxassetid://1309919907"] = {name = "Neon White Skateboard", prices = {["default"] = 40.69}},
    ["rbxassetid://2860616613"] = {name = "Offroader", prices = {["default"] = 2.1}},
    ["rbxassetid://1509329807"] = {name = "Pink Scooter", prices = {["default"] = 11.82}},
    ["rbxassetid://1306898507"] = {name = "Pink Skateboard", prices = {["default"] = 70.8}},
    ["rbxassetid://4361545125"] = {name = "Pizza Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://7368040075"] = {name = "Plant Powered Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9837424665"] = {name = "Rainbow Trail Magic Carpet", prices = {["default"] = 7.88}},
    ["rbxassetid://2854601262"] = {name = "Prince Carriage", prices = {["default"] = 6.75}},
    ["rbxassetid://2854601314"] = {name = "Princess Carriage", prices = {["default"] = 23.63}},
    ["rbxassetid://4115248893"] = {name = "Pumpkin Carriage", prices = {["default"] = 42.29}},
    ["rbxassetid://7475654312"] = {name = "Racing Monoplane", prices = {["default"] = 2.1}},
    ["rbxassetid://10967874847"] = {name = "Galleon", prices = {["default"] = 3.91}},
    ["rbxassetid://10967808228"] = {name = "Old Sail Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992442"] = {name = "RGB Monster Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992324"] = {name = "RGB UFO", prices = {["default"] = 15.75}},
    ["rbxassetid://5882026006"] = {name = "Ribcage Carriage", prices = {["default"] = 10.5}},
    ["rbxassetid://4797807111"] = {name = "Rocket Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://7368052482"] = {name = "Rocket Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://1257419042"] = {name = "Rocket Sled", prices = {["default"] = 656.25}},
    ["rbxassetid://4564588042"] = {name = "Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601162"] = {name = "Royal Carriage", prices = {["default"] = 7.88}},
    ["rbxassetid://13741294258"] = {name = "Giant Cheetah Mount", prices = {["default"] = 622.84}},
    ["rbxassetid://4470749525"] = {name = "Santa's Sleigh", prices = {["default"] = 33.5}},
    ["rbxassetid://4470749209"] = {name = "Sled", prices = {["default"] = 2.1}},
    ["rbxassetid://9342853829"] = {name = "Snow Plow", prices = {["default"] = 2.1}},
    ["rbxassetid://9343367876"] = {name = "Tundra Exploration Machine", prices = {["default"] = 2.1}},
    ["rbxassetid://1265142495"] = {name = "Snow Snowboard", prices = {["default"] = 262.5}},
    ["rbxassetid://7165482648"] = {name = "Speedboat", prices = {["default"] = 2.1}},
    ["rbxassetid://12719600101"] = {name = "Daisymobile", prices = {["default"] = 39.38}},
    ["rbxassetid://12792507038"] = {name = "Flower Truck", prices = {["default"] = 93.21}},
    ["rbxassetid://12996592162"] = {name = "Lavender Teapot Carriage", prices = {["default"] = 45.44}},
    ["rbxassetid://12917527253"] = {name = "Rabbit Helicopter", prices = {["default"] = 42.27}},
    ["rbxassetid://12996592079"] = {name = "Rose Petal Carriage", prices = {["default"] = 112.88}},
    ["rbxassetid://12996592010"] = {name = "Royal Crown Carriage", prices = {["default"] = 31.5}},
    ["rbxassetid://6504033423"] = {name = "Squirrel Car", prices = {["default"] = 6.47}},
    ["rbxassetid://6798176757"] = {name = "Standard Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://6797010981"] = {name = "Standard Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10224002323"] = {name = "Emperor's Chariot", prices = {["default"] = 14.33}},
    ["rbxassetid://10202931873"] = {name = "Orchid Racer", prices = {["default"] = 2.63}},
    ["rbxassetid://10202932215"] = {name = "Hovercraft", prices = {["default"] = 2.1}},
    ["rbxassetid://10224209770"] = {name = "Planetary Core Car", prices = {["default"] = 2.1}},
    ["rbxassetid://10203332627"] = {name = "Medieval Wagon", prices = {["default"] = 2.1}},
    ["rbxassetid://13607580379"] = {name = "Beach Buggy", prices = {["default"] = 3.28}},
    ["rbxassetid://13683681091"] = {name = "Beachgoer", prices = {["default"] = 3.87}},
    ["rbxassetid://13683679951"] = {name = "Crabby Cruiser", prices = {["default"] = 43.32}},
    ["rbxassetid://3579315827"] = {name = "Surfboard", prices = {["default"] = 2.1}},
    ["rbxassetid://3186425945"] = {name = "SUV", prices = {["default"] = 15.86}},
    ["rbxassetid://1614139188"] = {name = "Multi-Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8727492188"] = {name = "Black Cab", prices = {["default"] = 3.94}},
    ["rbxassetid://8727477150"] = {name = "Yellow Taxi Cab", prices = {["default"] = 43.32}},
    ["rbxassetid://2783002443"] = {name = "Tiffany", prices = {["default"] = 31.7}},
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
    ["rbxassetid://1265135075"] = {name = "White Neon Snowboard", prices = {["default"] = 1055.31}},
    ["rbxassetid://1509328859"] = {name = "White Scooter", prices = {["default"] = 7.72}},
    ["rbxassetid://1306898856"] = {name = "White Skateboard", prices = {["default"] = 10.49}},
    ["rbxassetid://1256624956"] = {name = "White Snowboard", prices = {["default"] = 8.46}},
    ["rbxassetid://7165482807"] = {name = "Wing Trunk Car", prices = {["default"] = 26.14}},
    ["rbxassetid://8080952782"] = {name = "Festive Deliveries Present Truck", prices = {["default"] = 52.5}},
    ["rbxassetid://8190703270"] = {name = "Festive Deliveries Sleigh", prices = {["default"] = 15.86}},
    ["rbxassetid://7975097837"] = {name = "Festive Ice Skates", prices = {["default"] = 2.63}},
    ["rbxassetid://8190703329"] = {name = "Toy Rescue Helicopter", prices = {["default"] = 4.71}},
    ["rbxassetid://11697121962"] = {name = "Candy Snowmobile", prices = {["default"] = 34.13}},
    ["rbxassetid://11574949668"] = {name = "Giant Snowball", prices = {["default"] = 18.35}},
    ["rbxassetid://11764928443"] = {name = "Gingerbread Sleigh", prices = {["default"] = 141.75}},
    ["rbxassetid://11706055135"] = {name = "Husky Sled", prices = {["default"] = 115.5}},
    ["rbxassetid://11466900358"] = {name = "Icebreaker Ship", prices = {["default"] = 2.1}},
    ["rbxassetid://11768005537"] = {name = "Ice Plane", prices = {["default"] = 6.57}},
    ["rbxassetid://11706157454"] = {name = "Snowblower Toboggan", prices = {["default"] = 6.57}},
    ["rbxassetid://11582939967"] = {name = "Strawberry Shortcake Skates", prices = {["default"] = 7.06}},
    ["rbxassetid://11582928541"] = {name = "Strawberry Shortcake Unicycle", prices = {["default"] = 2.37}},
    ["rbxassetid://4797807321"] = {name = "Witch's Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1509321524"] = {name = "Wood Scooter", prices = {["default"] = 9.34}},
    ["rbxassetid://1306899055"] = {name = "Wood Skateboard", prices = {["default"] = 9.17}},
    ["rbxassetid://4361544852"] = {name = "Airplane Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4797806115"] = {name = "Angelic Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671618"] = {name = "Anna Rattle", prices = {["default"] = 3.54}},
    ["rbxassetid://4712355837"] = {name = "Astro Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://2657667102"] = {name = "Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779116"] = {name = "Balloons", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779170"] = {name = "Banana Plush", prices = {["default"] = 3.94}},
    ["rbxassetid://3009779233"] = {name = "Banana Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248143"] = {name = "Banjo", prices = {["default"] = 4.56}},
    ["rbxassetid://4470749845"] = {name = "Bauble Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468615"] = {name = "Briefcase Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907018"] = {name = "Bubblegum Machine Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046064"] = {name = "Bunny Plush", prices = {["default"] = 6.57}},
    ["rbxassetid://4470749083"] = {name = "Candle", prices = {["default"] = 2.63}},
    ["rbxassetid://6710107927"] = {name = "Candy Cannon", prices = {["default"] = 7709.21}},
    ["rbxassetid://3082046250"] = {name = "Carrot Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408035756"] = {name = "Cat Plush", prices = {["default"] = 48.45}},
    ["rbxassetid://3009779289"] = {name = "Caticorn Rattle", prices = {["default"] = 3.78}},
    ["rbxassetid://3082046215"] = {name = "Chocolate Bunny Balloon", prices = {["default"] = 7.88}},
    ["rbxassetid://1257271764"] = {name = "Christmas Cat Rattle", prices = {["default"] = 4.77}},
    ["rbxassetid://1257273388"] = {name = "Christmas Doge Rattle", prices = {["default"] = 127.32}},
    ["rbxassetid://4470749153"] = {name = "Cookie Dough Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://10979219546"] = {name = "Cotton Candy Stand", prices = {["default"] = 15.75}},
    ["rbxassetid://4115248463"] = {name = "Creepy Balloon", prices = {["default"] = 3.94}},
    ["rbxassetid://2408035767"] = {name = "Croc Plush", prices = {["default"] = 3.87}},
    ["rbxassetid://4115248599"] = {name = "Crossbow Grappling Hook", prices = {["default"] = 6.35}},
    ["rbxassetid://5061468734"] = {name = "Cymbal Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://4822522594"] = {name = "Dandelion Propeller", prices = {["default"] = 15.65}},
    ["rbxassetid://4797806584"] = {name = "Didgeridoo", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779323"] = {name = "Donut Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907555"] = {name = "Dragon Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779349"] = {name = "Duck Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046102"] = {name = "Easter Bunny Plush", prices = {["default"] = 35.94}},
    ["rbxassetid://1555803323"] = {name = "Egg Rattle", prices = {["default"] = 2.37}},
    ["rbxassetid://2408051109"] = {name = "Elephant Plush", prices = {["default"] = 9.35}},
    ["rbxassetid://4470750254"] = {name = "Elf Plush", prices = {["default"] = 6.35}},
    ["rbxassetid://2657668953"] = {name = "Elf Rattle", prices = {["default"] = 3.93}},
    ["rbxassetid://5882028408"] = {name = "Eyeball Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408035763"] = {name = "Fancy Balloon", prices = {["default"] = 3.82}},
    ["rbxassetid://2408052395"] = {name = "Fancy Umbrella", prices = {["default"] = 3.56}},
    ["rbxassetid://3009779377"] = {name = "Flower Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291815"] = {name = "Flying Broomstick", prices = {["default"] = 3239.82}},
    ["rbxassetid://3454109803"] = {name = "Football Throw Toy", prices = {["default"] = 4.61}},
    ["rbxassetid://7368042855"] = {name = "Galaxy Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749638"] = {name = "Gift Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://1310513344"] = {name = "Glider", prices = {["default"] = 43.31}},
    ["rbxassetid://6936627177"] = {name = "Golden Maned Unicorn Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3142180004"] = {name = "Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907282"] = {name = "Griffin Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://1419098937"] = {name = "Heart Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://1419099271"] = {name = "Heart Plushie", prices = {["default"] = 7.88}},
    ["rbxassetid://2848331436"] = {name = "Heart Rattle", prices = {["default"] = 72.19}},
    ["rbxassetid://2657670910"] = {name = "Horse Plush", prices = {["default"] = 2.63}},
    ["rbxassetid://3818347838"] = {name = "Hotdog Stand", prices = {["default"] = 6.46}},
    ["rbxassetid://1555807694"] = {name = "Hugging Egg", prices = {["default"] = 125.53}},
    ["rbxassetid://4470749277"] = {name = "Ice Club Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779419"] = {name = "Ice Cream Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4361546643"] = {name = "Ice Cream Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749342"] = {name = "Ice Pick Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052390"] = {name = "Inflatable Sword", prices = {["default"] = 2.63}},
    ["rbxassetid://2408051119"] = {name = "Jackhammer", prices = {["default"] = 7.88}},
    ["rbxassetid://3486908136"] = {name = "Kangaroo Pogo", prices = {["default"] = 3.33}},
    ["rbxassetid://4822522509"] = {name = "Lavender Bundle", prices = {["default"] = 2.63}},
    ["rbxassetid://3523677453"] = {name = "Lemonade Stand", prices = {["default"] = 10.5}},
    ["rbxassetid://6475613071"] = {name = "Lime Slice Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051107"] = {name = "Llama Plush", prices = {["default"] = 50.72}},
    ["rbxassetid://4661940658"] = {name = "Magic House Door", prices = {["default"] = 110.25}},
    ["rbxassetid://3009779472"] = {name = "Marsh Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779496"] = {name = "Marsh Plush", prices = {["default"] = 3.94}},
    ["rbxassetid://5057099190"] = {name = "Monkey Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099046"] = {name = "Monkey Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670913"] = {name = "Noob Balloon", prices = {["default"] = 3.67}},
    ["rbxassetid://3009779607"] = {name = "Octopus Plush", prices = {["default"] = 2.61}},
    ["rbxassetid://4470749788"] = {name = "Ornament Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670921"] = {name = "Phoenix Plush", prices = {["default"] = 14.44}},
    ["rbxassetid://7368034465"] = {name = "Pink Cat Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544972"] = {name = "Plunger Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051114"] = {name = "Puppy Plush", prices = {["default"] = 6.57}},
    ["rbxassetid://3082046011"] = {name = "Rabbit Rattle", prices = {["default"] = 4.24}},
    ["rbxassetid://2408055079"] = {name = "Rainbow Wand", prices = {["default"] = 3.93}},
    ["rbxassetid://4470749750"] = {name = "Reindeer Leash", prices = {["default"] = 9.4}},
    ["rbxassetid://3009779583"] = {name = "Rocket Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749474"] = {name = "Santa Leash", prices = {["default"] = 2.63}},
    ["rbxassetid://4470750189"] = {name = "Santa Rattle", prices = {["default"] = 4.04}},
    ["rbxassetid://5061468835"] = {name = "Scroll Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://6475612857"] = {name = "Shuttle Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5882028350"] = {name = "Skull Drum", prices = {["default"] = 5.25}},
    ["rbxassetid://4470749413"] = {name = "Sleigh Bells Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://6059308940"] = {name = "Snowball Launcher", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671626"] = {name = "Snowman Plush", prices = {["default"] = 3.94}},
    ["rbxassetid://4470749691"] = {name = "Snowman Rattle", prices = {["default"] = 2.63}},
    ["rbxassetid://4470750120"] = {name = "Sock Chew Toy", prices = {["default"] = 3.94}},
    ["rbxassetid://2408052387"] = {name = "Squid Plush", prices = {["default"] = 6.57}},
    ["rbxassetid://5061468930"] = {name = "Staff Ingredient", prices = {["default"] = 19.67}},
    ["rbxassetid://6768659222"] = {name = "Standard Grappling Hook", prices = {["default"] = 2.63}},
    ["rbxassetid://2408055085"] = {name = "Starpower Wand", prices = {["default"] = 39.29}},
    ["rbxassetid://3009779638"] = {name = "Telescope Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4710374217"] = {name = "Tennis Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4464390422"] = {name = "Turkey Plush", prices = {["default"] = 2.39}},
    ["rbxassetid://3977264097"] = {name = "Unicorn Leash", prices = {["default"] = 16.93}},
    ["rbxassetid://3570154347"] = {name = "Unicorn Plush", prices = {["default"] = 117.57}},
    ["rbxassetid://2408055086"] = {name = "Wooden Pogo", prices = {["default"] = 2.63}},
    ["rbxassetid://4155284126"] = {name = "Zombie Buffalo Plush", prices = {["default"] = 89.25}},
    ["rbxassetid://4880426741"] = {name = "Adventurer's Hood", prices = {["default"] = 7.87}},
    ["rbxassetid://4880426585"] = {name = "Adventurer's Sword", prices = {["default"] = 2.46}},
    ["rbxassetid://5726048254"] = {name = "Amber Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973461"] = {name = "Angel Wings", prices = {["default"] = 983.07}},
    ["rbxassetid://6380734633"] = {name = "Antenna", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972567"] = {name = "Aviators", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973554"] = {name = "Bat Wings", prices = {["default"] = 13.13}},
    ["rbxassetid://6380843886"] = {name = "Bee Hive", prices = {["default"] = 2.63}},
    ["rbxassetid://6380734557"] = {name = "Bee Wings", prices = {["default"] = 2.61}},
    ["rbxassetid://4849973352"] = {name = "Beret", prices = {["default"] = 2.1}},
    ["rbxassetid://5881347869"] = {name = "Bewitched Hat", prices = {["default"] = 6.3}},
    ["rbxassetid://5415514537"] = {name = "Black 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415514707"] = {name = "Black Boots", prices = {["default"] = 28.54}},
    ["rbxassetid://5415514845"] = {name = "Black Cozy Hood", prices = {["default"] = 2.1}},
    ["rbxassetid://5415515017"] = {name = "Black Designer Backpack", prices = {["default"] = 3.83}},
    ["rbxassetid://4849975075"] = {name = "Black Fedora", prices = {["default"] = 3.94}},
    ["rbxassetid://5415515284"] = {name = "Black Hightops", prices = {["default"] = 6.57}},
    ["rbxassetid://5415515507"] = {name = "Black Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426690"] = {name = "Black Scarf", prices = {["default"] = 18.38}},
    ["rbxassetid://5415515653"] = {name = "Black Sneakers", prices = {["default"] = 7.85}},
    ["rbxassetid://5444594385"] = {name = "Blue Butterfly Wings", prices = {["default"] = 15.75}},
    ["rbxassetid://4849980085"] = {name = "Blue Cat Ear Headphones", prices = {["default"] = 22.32}},
    ["rbxassetid://5415515800"] = {name = "Blue Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048365"] = {name = "Bone Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426624"] = {name = "Briefcase", prices = {["default"] = 2.1}},
    ["rbxassetid://6706595341"] = {name = "Bunny Ear Tiara", prices = {["default"] = 2.63}},
    ["rbxassetid://4849975457"] = {name = "Buttoned Ushanka", prices = {["default"] = 6.57}},
    ["rbxassetid://4849978837"] = {name = "Buzz Off! Skateboard", prices = {["default"] = 3.94}},
    ["rbxassetid://5415516304"] = {name = "Cassette", prices = {["default"] = 3.93}},
    ["rbxassetid://4849975557"] = {name = "Chef Hat", prices = {["default"] = 15.75}},
    ["rbxassetid://6380734302"] = {name = "Cherry Earrings", prices = {["default"] = 3.63}},
    ["rbxassetid://6706591422"] = {name = "Chick Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://6706592723"] = {name = "Chick Hat", prices = {["default"] = 3.94}},
    ["rbxassetid://4849975633"] = {name = "Chicken Hat", prices = {["default"] = 16.75}},
    ["rbxassetid://4849972658"] = {name = "Clout Goggles", prices = {["default"] = 4.24}},
    ["rbxassetid://4849975702"] = {name = "Conductor Hat", prices = {["default"] = 73.15}},
    ["rbxassetid://4936545219"] = {name = "Cutlass", prices = {["default"] = 140.11}},
    ["rbxassetid://4849972740"] = {name = "Cyborg Shades", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037745"] = {name = "Daisy Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7601648534"] = {name = "Eco Blue Reusable Bottle Backpack", prices = {["default"] = 11.82}},
    ["rbxassetid://7542826699"] = {name = "Eco Blue Solar Panel Backpack", prices = {["default"] = 2.37}},
    ["rbxassetid://7542810947"] = {name = "Eco Brown Branch Headphones", prices = {["default"] = 5.25}},
    ["rbxassetid://7542815049"] = {name = "Eco Brown Hiking Backpack", prices = {["default"] = 32.86}},
    ["rbxassetid://7542816175"] = {name = "Eco Green Leaf Afro", prices = {["default"] = 2.63}},
    ["rbxassetid://7542816369"] = {name = "Eco Green Leaf Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810810"] = {name = "Eco Orange Leaf Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542820583"] = {name = "Eco Orange Maple Cape", prices = {["default"] = 11.39}},
    ["rbxassetid://7542810709"] = {name = "Eco Orange Maple Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542817978"] = {name = "Eco Orange Maple Leaf Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://7542823324"] = {name = "Eco Orange Pumpkin Eyepatch", prices = {["default"] = 2.1}},
    ["rbxassetid://7542824283"] = {name = "Eco Orange Pumpkin Pie Wings", prices = {["default"] = 48.57}},
    ["rbxassetid://7542813412"] = {name = "Eco Red Cranberry Branch Wings", prices = {["default"] = 24.15}},
    ["rbxassetid://7542821672"] = {name = "Eco Red Mushroom Hood", prices = {["default"] = 3.82}},
    ["rbxassetid://6706593596"] = {name = "Egg Barrette", prices = {["default"] = 2.1}},
    ["rbxassetid://6706594347"] = {name = "Egg Glasses", prices = {["default"] = 31.5}},
    ["rbxassetid://4850383048"] = {name = "Elf Hat", prices = {["default"] = 89.15}},
    ["rbxassetid://4849976006"] = {name = "Explorer Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495463"] = {name = "Eyepatch", prices = {["default"] = 11.82}},
    ["rbxassetid://6060998776"] = {name = "Festive Tree Hat", prices = {["default"] = 12.48}},
    ["rbxassetid://4853278462"] = {name = "Firey Aura", prices = {["default"] = 2.63}},
    ["rbxassetid://4849979365"] = {name = "First Aid Bag", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976218"] = {name = "Flamenco Hat", prices = {["default"] = 8.46}},
    ["rbxassetid://6437127230"] = {name = "Flower Collar", prices = {["default"] = 5.25}},
    ["rbxassetid://6380734218"] = {name = "Flower Crown", prices = {["default"] = 20.09}},
    ["rbxassetid://5415517076"] = {name = "Flowery Hair Bow", prices = {["default"] = 78.68}},
    ["rbxassetid://5726048455"] = {name = "Forgotten Flower", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734014"] = {name = "Froggy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://6060998635"] = {name = "Fur Boots", prices = {["default"] = 15.73}},
    ["rbxassetid://5415517473"] = {name = "Gold Chain", prices = {["default"] = 78.75}},
    ["rbxassetid://5415517604"] = {name = "Gold Circle Glasses", prices = {["default"] = 2.63}},
    ["rbxassetid://5415517745"] = {name = "Gold Tiara", prices = {["default"] = 6.57}},
    ["rbxassetid://4849979471"] = {name = "Golden Headset", prices = {["default"] = 2.61}},
    ["rbxassetid://6380730894"] = {name = "Goth Shoes", prices = {["default"] = 106.23}},
    ["rbxassetid://4849976420"] = {name = "Green Lotus", prices = {["default"] = 5.24}},
    ["rbxassetid://7368039312"] = {name = "Growing Flower Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4489907389"] = {name = "Halo", prices = {["default"] = 1224.15}},
    ["rbxassetid://5444594659"] = {name = "Handheld", prices = {["default"] = 2.3}},
    ["rbxassetid://4849976512"] = {name = "Head Chef", prices = {["default"] = 187.69}},
    ["rbxassetid://5067924536"] = {name = "Head Tie", prices = {["default"] = 6.57}},
    ["rbxassetid://6404037642"] = {name = "Headband", prices = {["default"] = 5.25}},
    ["rbxassetid://4849979572"] = {name = "Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521592"] = {name = "Hoop Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991420"] = {name = "Ice Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991330"] = {name = "Ice Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991245"] = {name = "Ice Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973617"] = {name = "Jade Moth Wings", prices = {["default"] = 10.5}},
    ["rbxassetid://4849979214"] = {name = "Jeff's Nametag", prices = {["default"] = 53.64}},
    ["rbxassetid://5415517859"] = {name = "Jetpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924626"] = {name = "Kitsune Mask", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973992"] = {name = "Lavender Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730271"] = {name = "Leprechaun Hat", prices = {["default"] = 4.6}},
    ["rbxassetid://4853278902"] = {name = "Luggage", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924890"] = {name = "Monkey King Crown", prices = {["default"] = 67.31}},
    ["rbxassetid://4849977086"] = {name = "Monocle", prices = {["default"] = 7.74}},
    ["rbxassetid://4849979887"] = {name = "Moon Tome", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976759"] = {name = "Morion", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048545"] = {name = "Nautilus Shell Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976912"] = {name = "Ninja Headband", prices = {["default"] = 6.57}},
    ["rbxassetid://6404037449"] = {name = "Orange Backpack", prices = {["default"] = 3.81}},
    ["rbxassetid://6380727237"] = {name = "Orange Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977244"] = {name = "Party Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://5415523249"] = {name = "Pearl Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727177"] = {name = "Picnic Basket", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518324"] = {name = "Pink 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518474"] = {name = "Pink Boots", prices = {["default"] = 11.82}},
    ["rbxassetid://5444594884"] = {name = "Pink Butterfly Wings", prices = {["default"] = 7.88}},
    ["rbxassetid://4849979637"] = {name = "Pink Cat Ear Headphones", prices = {["default"] = 71.85}},
    ["rbxassetid://5415518613"] = {name = "Pink Designer Backpack", prices = {["default"] = 8.35}},
    ["rbxassetid://4849972826"] = {name = "Pink Heart Glasses", prices = {["default"] = 72.19}},
    ["rbxassetid://5457768184"] = {name = "Pink Hightops", prices = {["default"] = 2.63}},
    ["rbxassetid://5415518811"] = {name = "Pink Instant Camera", prices = {["default"] = 25.36}},
    ["rbxassetid://4849977427"] = {name = "Pink Lotus", prices = {["default"] = 2.1}},
    ["rbxassetid://5415520296"] = {name = "Pink Sneakers", prices = {["default"] = 3.94}},
    ["rbxassetid://4849977514"] = {name = "Pirate Hat", prices = {["default"] = 7.35}},
    ["rbxassetid://5444711861"] = {name = "Platinum Tiara", prices = {["default"] = 22.95}},
    ["rbxassetid://4849977607"] = {name = "Propeller Hat", prices = {["default"] = 102.38}},
    ["rbxassetid://4849972928"] = {name = "Purple Heart Glasses", prices = {["default"] = 8.46}},
    ["rbxassetid://6380727007"] = {name = "Purple Masquerade Mask", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977695"] = {name = "Purple Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037362"] = {name = "Rain Boots", prices = {["default"] = 69.57}},
    ["rbxassetid://5415520831"] = {name = "Rain Hat", prices = {["default"] = 7.6}},
    ["rbxassetid://7498079214"] = {name = "RB Battles Trophy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977830"] = {name = "Red Beanie", prices = {["default"] = 2.1}},
    ["rbxassetid://6380847814"] = {name = "Red Masquerade Mask", prices = {["default"] = 3.93}},
    ["rbxassetid://5415520972"] = {name = "Red Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521183"] = {name = "Red Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973276"] = {name = "Reindeer Antlers", prices = {["default"] = 4.66}},
    ["rbxassetid://4933495361"] = {name = "Respectful Mustache", prices = {["default"] = 65.01}},
    ["rbxassetid://8151013513"] = {name = "RGB Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978102"] = {name = "Rose", prices = {["default"] = 2.24}},
    ["rbxassetid://4933495425"] = {name = "Ruff", prices = {["default"] = 57.66}},
    ["rbxassetid://4849978200"] = {name = "Sailor Cap", prices = {["default"] = 59.07}},
    ["rbxassetid://4850382817"] = {name = "Santa Hat", prices = {["default"] = 328.13}},
    ["rbxassetid://5881348094"] = {name = "Scythe", prices = {["default"] = 3.77}},
    ["rbxassetid://4853278537"] = {name = "Shadow Aura", prices = {["default"] = 39.38}},
    ["rbxassetid://4849980009"] = {name = "Shadow Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973681"] = {name = "Shadow Wings", prices = {["default"] = 124.69}},
    ["rbxassetid://4849972466"] = {name = "Shark Fin", prices = {["default"] = 3.59}},
    ["rbxassetid://4849973100"] = {name = "Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521379"] = {name = "Silver Chain", prices = {["default"] = 2.1}},
    ["rbxassetid://4849974099"] = {name = "Skeleton Shell", prices = {["default"] = 2.1}},
    ["rbxassetid://4849974434"] = {name = "Spike Collar", prices = {["default"] = 15.74}},
    ["rbxassetid://6380723429"] = {name = "Strawberry Hat", prices = {["default"] = 57.75}},
    ["rbxassetid://4849975162"] = {name = "Sun Tome", prices = {["default"] = 3.94}},
    ["rbxassetid://4849976090"] = {name = "Sushi Skateboard", prices = {["default"] = 23.63}},
    ["rbxassetid://4849976985"] = {name = "Turtle Shell", prices = {["default"] = 6.3}},
    ["rbxassetid://4849978035"] = {name = "Watermelon Backpack", prices = {["default"] = 5.7}},
    ["rbxassetid://5415522308"] = {name = "White Designer Backpack", prices = {["default"] = 7.66}},
    ["rbxassetid://5415522533"] = {name = "White Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979019"] = {name = "Windup Key", prices = {["default"] = 24.94}},
    ["rbxassetid://4849977314"] = {name = "Witch Hat", prices = {["default"] = 3.78}},
    ["rbxassetid://4849978608"] = {name = "Wizard Hat", prices = {["default"] = 3.94}},
    ["rbxassetid://5415522859"] = {name = "Yellow Designer Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5415522973"] = {name = "Yellow Instant Camera", prices = {["default"] = 2.1}},
    ["rbxassetid://5415523115"] = {name = "Yellow Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277758"] = {name = "Airplane Stroller", prices = {["default"] = 157.35}},
    ["rbxassetid://2657667120"] = {name = "Baby Basket Stroller", prices = {["default"] = 66.94}},
    ["rbxassetid://2761277454"] = {name = "Balloon Stroller", prices = {["default"] = 8.45}},
    ["rbxassetid://3009779202"] = {name = "Banana Stroller", prices = {["default"] = 3.94}},
    ["rbxassetid://3082046286"] = {name = "Bunny Stroller", prices = {["default"] = 141.57}},
    ["rbxassetid://3009779260"] = {name = "Cannon Stroller", prices = {["default"] = 7.76}},
    ["rbxassetid://3269748269"] = {name = "Car Stroller", prices = {["default"] = 2.63}},
    ["rbxassetid://6475616233"] = {name = "Catapult Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248341"] = {name = "Cauldron Stroller", prices = {["default"] = 7.39}},
    ["rbxassetid://2408051111"] = {name = "Cradle Stroller", prices = {["default"] = 79.32}},
    ["rbxassetid://4361544460"] = {name = "Crate Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3486905775"] = {name = "Dog House Stroller", prices = {["default"] = 4.24}},
    ["rbxassetid://1408016951"] = {name = "Double Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1406692267"] = {name = "Droplet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277656"] = {name = "Duck Stroller", prices = {["default"] = 65.63}},
    ["rbxassetid://3082046174"] = {name = "Easter Egg Stroller", prices = {["default"] = 27.09}},
    ["rbxassetid://2761277703"] = {name = "Egg Stroller", prices = {["default"] = 1583.48}},
    ["rbxassetid://4822522123"] = {name = "Flower Stroller", prices = {["default"] = 32.71}},
    ["rbxassetid://3009779395"] = {name = "French Fries Stroller", prices = {["default"] = 15.75}},
    ["rbxassetid://3082046130"] = {name = "Half Egg Stroller", prices = {["default"] = 31.5}},
    ["rbxassetid://3486906113"] = {name = "Hatched Egg Stroller", prices = {["default"] = 2.63}},
    ["rbxassetid://2848462165"] = {name = "Heart Stroller", prices = {["default"] = 249.25}},
    ["rbxassetid://6475613319"] = {name = "High Heel Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6967530077"] = {name = "Hover Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670917"] = {name = "Ice Cream Stroller", prices = {["default"] = 14.2}},
    ["rbxassetid://3486906383"] = {name = "Kangaroo Stroller", prices = {["default"] = 6.57}},
    ["rbxassetid://7368046225"] = {name = "Lunar Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936630605"] = {name = "Magic Carpet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936629525"] = {name = "Magic Moon Stroller", prices = {["default"] = 2.24}},
    ["rbxassetid://6309085791"] = {name = "Palanquin Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936631399"] = {name = "Pelican Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670918"] = {name = "Pizza Stroller", prices = {["default"] = 14.34}},
    ["rbxassetid://3009779443"] = {name = "Popsicle Stroller", prices = {["default"] = 8.28}},
    ["rbxassetid://6936628317"] = {name = "Princess Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://5882036757"] = {name = "Pumpkin Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052388"] = {name = "Quad Stroller", prices = {["default"] = 169.32}},
    ["rbxassetid://2408035750"] = {name = "Race Car Stroller", prices = {["default"] = 45.94}},
    ["rbxassetid://6710108407"] = {name = "Rainbow Stroller", prices = {["default"] = 35.44}},
    ["rbxassetid://4470748252"] = {name = "Reindeer Stroller", prices = {["default"] = 25.85}},
    ["rbxassetid://8526099597"] = {name = "RGB Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2981204560"] = {name = "Rocket Ship Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://13986982302"] = {name = "Shopping Cart Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936628967"] = {name = "Teacup Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2982964426"] = {name = "Throne Stroller", prices = {["default"] = 2.6}},
    ["rbxassetid://2657671637"] = {name = "Trike Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544584"] = {name = "Triple Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277803"] = {name = "Unicorn Stroller", prices = {["default"] = 76.13}},
    ["rbxassetid://2466291803"] = {name = "Vampire Stroller", prices = {["default"] = 103.69}},
    ["rbxassetid://3066606234"] = {name = "Wheelbarrow Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://113061955717247"] = {name = "Admin Abuse Box", prices = {["default"] = 2.1}},
    ["rbxassetid://5888839551"] = {name = "Bat Box", prices = {["default"] = 101.07}},
    ["rbxassetid://4510471983"] = {name = "Golden Gift", prices = {["default"] = 918.75}},
    ["rbxassetid://5057100696"] = {name = "Monkey Box", prices = {["default"] = 199.5}},
    ["rbxassetid://6240246974"] = {name = "Ox Box", prices = {["default"] = 7.66}},
    ["rbxassetid://5067925110"] = {name = "Premium Monkey Box", prices = {["default"] = 1267.63}},
    ["rbxassetid://4621220017"] = {name = "Rat Box", prices = {["default"] = 556.5}},
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