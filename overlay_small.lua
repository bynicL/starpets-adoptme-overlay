print('MARK0: скрипт запущен')
-- ============================================
--  Adopt Me Price Overlay вЂ” РџРЈР‘Р›РР§РќРђРЇ Р’Р•Р РЎРРЇ
--  РћРґРёРЅ С„Р°Р№Р»: Р»РѕРіРёРєР° + РІСЃС‚СЂРѕРµРЅРЅС‹Рµ Р°РєС‚СѓР°Р»СЊРЅС‹Рµ С†РµРЅС‹
--  РРіСЂРѕРє Р·Р°РїСѓСЃРєР°РµС‚: loadstring(game:HttpGet("URL"))()
-- ============================================
-- Р–РґС‘Рј РїРѕР»РЅРѕР№ Р·Р°РіСЂСѓР·РєРё РёРіСЂС‹ (РёРЅР°С‡Рµ LocalPlayer/PlayerGui РјРѕРіСѓС‚ Р±С‹С‚СЊ nil -> СЃРєСЂРёРїС‚ СѓРїР°РґС‘С‚)
if not game:IsLoaded() then
    game.Loaded:Wait()
end

print('MARK1: до данных')
print("===== ADOPT ME PRICE OVERLAY (public) =====")

-- РќР°РґС‘Р¶РЅС‹Р№ РїРѕРёСЃРє PlayerGui СЃ РѕР¶РёРґР°РЅРёРµРј LocalPlayer РїСЂРё РЅРµРѕР±С…РѕРґРёРјРѕСЃС‚Рё
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

-- ===== Р’РЎРўР РћР•РќРќР«Р• Р”РђРќРќР«Р• (Р·Р°РїРѕР»РЅСЏРµС‚ РіРµРЅРµСЂР°С‚РѕСЂ / GitHub Actions) =====
-- РЎС‚СЂСѓРєС‚СѓСЂР°: ["rbxassetid://..."] = { name="...", prices={ ["default"]=С†РµРЅР°, ... } }
-- =====BEGIN_PRICES=====
local PRICES_DATA = {
    ["rbxassetid://137637490639925"] = {name = "Royal Mistletroll", prices = {["default"] = 1250, ["Ride"] = 1123.75, ["Fly|Ride"] = 1643.21, ["Neon"] = 6586.42, ["Neon|Fly|Ride"] = 4792.78}},
    ["rbxassetid://140355753768438"] = {name = "Moonbeam Peacock", prices = {["default"] = 450, ["Fly"] = 713.71, ["Ride"] = 470, ["Fly|Ride"] = 553.85, ["Neon|Fly|Ride"] = 3068.38}},
    ["rbxassetid://18117855573"] = {name = "Balloon Unicorn", prices = {["default"] = 4249.98, ["Ride"] = 4125, ["Fly|Ride"] = 4199.5, ["Neon|Fly|Ride"] = 18481.85}},
    ["rbxassetid://75782719698946"] = {name = "Red Dutch Guinea Pig", prices = {["default"] = 180, ["Ride"] = 229.85, ["Fly|Ride"] = 313.16, ["Neon"] = 875, ["Neon|Ride"] = 812.5, ["Neon|Fly|Ride"] = 725}},
    ["rbxassetid://5067924142"] = {name = "Albino Monkey", prices = {["default"] = 482.5, ["Fly"] = 685.01, ["Ride"] = 499.99, ["Fly|Ride"] = 497.5, ["Neon|Fly|Ride"] = 1465}},
    ["rbxassetid://108312620331321"] = {name = "Villain Gibbon", prices = {["default"] = 11.23, ["Ride"] = 56.25, ["Fly|Ride"] = 125, ["Neon"] = 101.68, ["Neon|Fly"] = 274.21, ["Neon|Ride"] = 100, ["Neon|Fly|Ride"] = 157.57}},
    ["rbxassetid://17255958862"] = {name = "Alicorn", prices = {["default"] = 4.71, ["Fly"] = 37.12, ["Ride"] = 31.24, ["Fly|Ride"] = 54.99, ["Neon"] = 29.8, ["Neon|Fly"] = 94.9, ["Neon|Ride"] = 47.07, ["Neon|Fly|Ride"] = 99.65}},
    ["rbxassetid://90170598608675"] = {name = "Moonbeam Butterfly", prices = {["default"] = 100, ["Fly"] = 282.2, ["Ride"] = 112.5, ["Fly|Ride"] = 313.94, ["Neon"] = 416.87, ["Neon|Ride"] = 468.75, ["Neon|Fly|Ride"] = 684.15}},
    ["rbxassetid://7126722445"] = {name = "Goldhorn", prices = {["default"] = 36.01, ["Fly"] = 100, ["Ride"] = 45.98, ["Fly|Ride"] = 95.07, ["Neon"] = 357.49, ["Neon|Fly"] = 231.25, ["Neon|Ride"] = 204.1, ["Neon|Fly|Ride"] = 275}},
    ["rbxassetid://13186021971"] = {name = "Cuddly Candle", prices = {["default"] = 22.37, ["Fly"] = 31.8, ["Ride"] = 30.28, ["Fly|Ride"] = 67.8, ["Neon"] = 250, ["Neon|Ride"] = 166.25, ["Neon|Fly|Ride"] = 192.1}},
    ["rbxassetid://14146196672"] = {name = "Gargoyle", prices = {["default"] = 68.74, ["Fly"] = 75, ["Ride"] = 86.25, ["Fly|Ride"] = 219.8, ["Neon"] = 387.5, ["Neon|Ride"] = 250, ["Neon|Fly|Ride"] = 313.94}},
    ["rbxassetid://129762233626342"] = {name = "Royal Moon Egg", prices = {["default"] = 68.75}},
    ["rbxassetid://89693546199400"] = {name = "Cupid Dragon", prices = {["default"] = 353.75, ["Fly"] = 324.98, ["Ride"] = 348.75, ["Fly|Ride"] = 362.5, ["Neon|Ride"] = 960, ["Neon|Fly|Ride"] = 1006.87}},
    ["rbxassetid://8665606875"] = {name = "Dancing Dragon", prices = {["default"] = 124.98, ["Fly"] = 164.82, ["Ride"] = 149.9, ["Fly|Ride"] = 179.98, ["Neon|Fly|Ride"] = 643.83}},
    ["rbxassetid://110411427278536"] = {name = "Huntsman Robin", prices = {["default"] = 3.75, ["Fly"] = 80.8, ["Ride"] = 41.09, ["Neon"] = 23.53, ["Neon|Ride"] = 112.5, ["Neon|Fly|Ride"] = 235.17}},
    ["rbxassetid://10925517718"] = {name = "Lava Dragon", prices = {["default"] = 200, ["Fly"] = 223.75, ["Ride"] = 200, ["Fly|Ride"] = 267.5, ["Neon"] = 975.65, ["Neon|Ride"] = 812.5, ["Neon|Fly|Ride"] = 809.53}},
    ["rbxassetid://4797806482"] = {name = "Diamond Griffin", prices = {["default"] = 3, ["Fly"] = 24.66, ["Ride"] = 18.55, ["Fly|Ride"] = 41.24, ["Neon"] = 26.71, ["Neon|Fly"] = 123.24, ["Neon|Ride"] = 68.83, ["Neon|Fly|Ride"] = 96.24}},
    ["rbxassetid://122648024705835"] = {name = "Scarebear", prices = {["default"] = 153.54, ["Fly"] = 212.5, ["Ride"] = 192.05, ["Fly|Ride"] = 250, ["Neon"] = 563.21, ["Neon|Ride"] = 498.13, ["Neon|Fly|Ride"] = 606.25}},
    ["rbxassetid://13104102169"] = {name = "Danger Egg", prices = {["default"] = 41.12}},
    ["rbxassetid://133163961974577"] = {name = "2D Doggy", prices = {["default"] = 86.25, ["Ride"] = 156.25, ["Fly|Ride"] = 310, ["Neon"] = 575, ["Neon|Ride"] = 492.96, ["Neon|Fly|Ride"] = 750}},
    ["rbxassetid://126071806166898"] = {name = "Evil Chick", prices = {["default"] = 20.39, ["Fly"] = 375, ["Ride"] = 109.9, ["Fly|Ride"] = 82.41, ["Neon"] = 250, ["Neon|Ride"] = 411.51, ["Neon|Fly|Ride"] = 409.76}},
    ["rbxassetid://5721843247"] = {name = "Dodo", prices = {["default"] = 41.21, ["Fly"] = 81.25, ["Ride"] = 49.89, ["Fly|Ride"] = 103.75, ["Neon"] = 206.25, ["Neon|Ride"] = 185, ["Neon|Fly|Ride"] = 243.75}},
    ["rbxassetid://119640582603552"] = {name = "Violet Butterfly", prices = {["default"] = 45.78, ["Fly"] = 87.5, ["Ride"] = 82.15, ["Fly|Ride"] = 187.5, ["Neon"] = 294.76, ["Neon|Ride"] = 384.1, ["Neon|Fly|Ride"] = 500}},
    ["rbxassetid://16088264958"] = {name = "Volcanic Rhino", prices = {["default"] = 33.82, ["Ride"] = 63.68, ["Fly|Ride"] = 133.52, ["Neon"] = 200, ["Neon|Ride"] = 155, ["Neon|Fly|Ride"] = 262.5}},
    ["rbxassetid://75251818654427"] = {name = "Apple Owl", prices = {["default"] = 42.49, ["Ride"] = 69.62, ["Fly|Ride"] = 118.11, ["Neon"] = 225, ["Neon|Ride"] = 260.4, ["Neon|Fly|Ride"] = 308.11}},
    ["rbxassetid://3181727433"] = {name = "Dragon", prices = {["default"] = 6.23, ["Fly"] = 30.53, ["Ride"] = 22.89, ["Fly|Ride"] = 42.5, ["Neon"] = 27.64, ["Neon|Fly"] = 56.23, ["Neon|Ride"] = 59.37, ["Neon|Fly|Ride"] = 99.99}},
    ["rbxassetid://121496682360324"] = {name = "Sugar Axolotl", prices = {["default"] = 387.5, ["Ride"] = 482.59, ["Fly|Ride"] = 630.59, ["Neon|Ride"] = 2179.18, ["Neon|Fly|Ride"] = 2177.67}},
    ["rbxassetid://11694854226"] = {name = "Shetland Pony Light Brown", prices = {["default"] = 13.61, ["Ride"] = 30, ["Fly|Ride"] = 78.8, ["Neon"] = 137.63, ["Neon|Ride"] = 108.88}},
    ["rbxassetid://4797806957"] = {name = "Golden Unicorn", prices = {["default"] = 8.25, ["Fly"] = 41.25, ["Ride"] = 23.63, ["Fly|Ride"] = 41.36, ["Neon"] = 77.03, ["Neon|Ride"] = 54.99, ["Neon|Fly|Ride"] = 135.27}},
    ["rbxassetid://110822620060051"] = {name = "Frost Phoenix", prices = {["default"] = 76.82, ["Fly"] = 86.55, ["Ride"] = 88.75, ["Fly|Ride"] = 137.39, ["Neon"] = 337.5, ["Neon|Fly"] = 452.92, ["Neon|Ride"] = 287.5, ["Neon|Fly|Ride"] = 400}},
    ["rbxassetid://13894724323"] = {name = "Billy Goat", prices = {["default"] = 8.23, ["Ride"] = 32.93, ["Fly|Ride"] = 56.25, ["Neon"] = 78.75, ["Neon|Ride"] = 118.74, ["Neon|Fly|Ride"] = 249.7}},
    ["rbxassetid://123037843357105"] = {name = "Glormy Leo", prices = {["default"] = 216.23, ["Fly"] = 287.39, ["Ride"] = 249.9, ["Fly|Ride"] = 313.81, ["Neon"] = 820.7, ["Neon|Ride"] = 799.54, ["Neon|Fly|Ride"] = 697.49}},
    ["rbxassetid://12479078933"] = {name = "Southeast Asia Egg", prices = {["default"] = 24.92}},
    ["rbxassetid://122739780018633"] = {name = "Quetzalcoatl", prices = {["default"] = 3.75, ["Fly"] = 26.6, ["Ride"] = 22.42, ["Fly|Ride"] = 73.48, ["Neon"] = 23, ["Neon|Fly"] = 137.45, ["Neon|Ride"] = 55, ["Neon|Fly|Ride"] = 137.49}},
    ["rbxassetid://70953296065239"] = {name = "Frostbite Bear", prices = {["default"] = 1250, ["Fly"] = 3125, ["Ride"] = 1402.42, ["Fly|Ride"] = 1741.79, ["Neon"] = 8888.75, ["Neon|Fly|Ride"] = 6875}},
    ["rbxassetid://14978701948"] = {name = "Scarecrow Crow", prices = {["default"] = 13.75, ["Ride"] = 43.74, ["Fly|Ride"] = 100.94, ["Neon"] = 213.75, ["Neon|Ride"] = 373.75, ["Neon|Fly|Ride"] = 1094.79}},
    ["rbxassetid://11191341630"] = {name = "Jousting Horse", prices = {["default"] = 231.25, ["Ride"] = 265.14, ["Fly|Ride"] = 340, ["Neon"] = 1100.08, ["Neon|Ride"] = 937.5, ["Neon|Fly|Ride"] = 1000}},
    ["rbxassetid://76801905892592"] = {name = "Royal Aztec Egg", prices = {["default"] = 42.77}},
    ["rbxassetid://98801943598121"] = {name = "Priceless Shrimp", prices = {["default"] = 18.58, ["Fly"] = 82.66, ["Ride"] = 45.87, ["Fly|Ride"] = 137.63, ["Neon"] = 87.5, ["Neon|Ride"] = 122.5, ["Neon|Fly|Ride"] = 392.84}},
    ["rbxassetid://95214789806437"] = {name = "Aztec Egg", prices = {["default"] = 2}},
    ["rbxassetid://18515755354"] = {name = "Cheetah", prices = {["default"] = 109.9, ["Fly"] = 141.12, ["Ride"] = 125, ["Fly|Ride"] = 219.8, ["Neon"] = 780.53, ["Neon|Ride"] = 650}}
print('MARK2: данные загружены')
=====END_PRICES=====


-- ===== Р¤РЈРќРљР¦РР =====
local colors = {
    ok = Color3.fromRGB(0, 255, 136),
    unknown = Color3.fromRGB(255, 120, 120),
    bg_ok = Color3.fromRGB(10, 30, 20),
    bg_unknown = Color3.fromRGB(40, 10, 10),
}

-- ===== РџРћРРЎРљ Р¦Р•РќР« (РєР°СЃРєР°Рґ) =====
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

-- ===== Р’РђР РРђРќРў РЎР›РћРўРђ =====
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

-- ===== РџР›РђРЁРљРђ =====
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

-- ===== Р¤РћР РњРђРў =====
local function format_price(p)
    if not p then return "?" end
    if p >= 1000000 then return string.format("%.2fM", p / 1000000)
    elseif p >= 1000 then return string.format("%.1fK", p / 1000)
    elseif p >= 100 then return tostring(math.floor(p))
    else return string.format("%.2f", p) end
end

-- ===== РЎРљРђРќРР РћР’РђРќРР• =====
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
                        local text = (stack > 1) and ("x" .. stack .. " = " .. format_price(total) .. "в‚Ѕ") or (format_price(price) .. "в‚Ѕ")
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

-- ===== РРќР’Р•РќРўРђР Р¬ =====
local function scan_backpack()
    local backpack = PG:FindFirstChild("BackpackApp")
    if not backpack or not backpack.Enabled then return end
    local pets = nil
    for _, obj in pairs(backpack:GetDescendants()) do
        if obj.Name == "pets" then pets = obj; break end
    end
    if pets then scan_container(pets, nil) end
end

-- ===== РџРђРќР•Р›Р¬ РўР Р•Р™Р”Рђ =====
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
    title.Text = "РђРќРђР›РР— РўР Р•Р™Р”Рђ"
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
    verdict.Text = "вљ–пёЏ  Р РђР’РќРћ"
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
    my.Text = "рџ’° РўС‹: 0 в‚Ѕ"
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
    partner.Text = "рџ‘¤ РџР°СЂС‚РЅС‘СЂ: 0 в‚Ѕ"
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
    result.Text = "рџ“Љ  РћР±С‰Р°СЏ РІС‹РіРѕРґР°: 0 в‚Ѕ"
    result.TextColor3 = Color3.fromRGB(255, 220, 100)
    result.TextSize = 15
    result.Font = Enum.Font.GothamBlack
    result.TextXAlignment = Enum.TextXAlignment.Center
    result.ZIndex = 102
    result.Parent = p

    local rc = Instance.new("UICorner")
    rc.CornerRadius = UDim.new(0, 8)
    rc.Parent = result

    -- ===== РљР›РРљРђР‘Р•Р›Р¬РќРђРЇ РЎРЎР«Р›РљРђ РќРђ DISCORD =====
    local discord = Instance.new("TextButton")
    discord.Name = "DiscordLink"
    discord.Size = UDim2.new(1, -24, 0, 28)
    discord.Position = UDim2.new(0, 12, 1, -36)
    discord.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
    discord.BackgroundTransparency = 0.1
    discord.BorderSizePixel = 0
    discord.AutoButtonColor = true
    discord.Text = "рџ’¬  Р’СЃС‚СѓРїРёС‚СЊ РІ Discord  вЂў  " .. DISCORD_URL
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
                discord.Text = "вњ…  РЎСЃС‹Р»РєР° СЃРєРѕРїРёСЂРѕРІР°РЅР°! Р’СЃС‚Р°РІСЊ РІ Р±СЂР°СѓР·РµСЂ"
                task.delay(2.5, function()
                    if discord and discord.Parent then
                        discord.Text = "рџ’¬  Р’СЃС‚СѓРїРёС‚СЊ РІ Discord  вЂў  " .. DISCORD_URL
                    end
                end)
            end
        end
    end

    discord.MouseButton1Click:Connect(open_discord)

    -- РџРµСЂРµС‚Р°СЃРєРёРІР°РЅРёРµ
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

-- ===== РўР Р•Р™Р” =====
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

    panel.MySum.Text = "рџ’° РўС‹: " .. format_price(my_results.total) .. " в‚Ѕ (" .. my_results.count .. ")"
    panel.PartnerSum.Text = "рџ‘¤ РџР°СЂС‚РЅС‘СЂ: " .. format_price(pt_results.total) .. " в‚Ѕ (" .. pt_results.count .. ")"

    local diff = pt_results.total - my_results.total
    if diff > 5 then
        panel.Verdict.Text = "вњ…  Р’Р«Р“РћР”РќРћ  +" .. format_price(diff) .. " в‚Ѕ"
        panel.Verdict.TextColor3 = Color3.fromRGB(100, 255, 100)
        panel.Verdict.BackgroundColor3 = Color3.fromRGB(15, 60, 20)
        panel.Result.Text = "рџ“Љ  РћР±С‰Р°СЏ РІС‹РіРѕРґР°: +" .. format_price(diff) .. " в‚Ѕ"
        panel.Result.TextColor3 = Color3.fromRGB(100, 255, 100)
        panel.Result.BackgroundColor3 = Color3.fromRGB(15, 60, 20)
    elseif diff < -5 then
        panel.Verdict.Text = "вќЊ  РќР•Р’Р«Р“РћР”РќРћ  " .. format_price(diff) .. " в‚Ѕ"
        panel.Verdict.TextColor3 = Color3.fromRGB(255, 100, 100)
        panel.Verdict.BackgroundColor3 = Color3.fromRGB(60, 15, 20)
        panel.Result.Text = "рџ“Љ  РћР±С‰Р°СЏ РІС‹РіРѕРґР°: " .. format_price(diff) .. " в‚Ѕ"
        panel.Result.TextColor3 = Color3.fromRGB(255, 100, 100)
        panel.Result.BackgroundColor3 = Color3.fromRGB(60, 15, 20)
    else
        panel.Verdict.Text = "вљ–пёЏ  Р РђР’РќРћ  (" .. format_price(diff) .. " в‚Ѕ)"
        panel.Verdict.TextColor3 = Color3.fromRGB(255, 220, 100)
        panel.Verdict.BackgroundColor3 = Color3.fromRGB(50, 45, 15)
        panel.Result.Text = "рџ“Љ  РћР±С‰Р°СЏ РІС‹РіРѕРґР°: " .. format_price(diff) .. " в‚Ѕ"
        panel.Result.TextColor3 = Color3.fromRGB(255, 220, 100)
        panel.Result.BackgroundColor3 = Color3.fromRGB(50, 45, 15)
    end
end

-- ===== Р¦РРљР› =====
print("[*] Overlay Р·Р°РїСѓС‰РµРЅ. РџСЂРѕРІРµСЂРєР° РєР°Р¶РґС‹Рµ 2 СЃРµРє.")
task.spawn(function()
    while true do
        task.wait(1)
        pcall(scan_backpack)
        pcall(scan_trade)
    end
end)