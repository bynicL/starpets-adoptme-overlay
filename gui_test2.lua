-- РўРµСЃС‚: СЂР°Р±РѕС‚Р°РµС‚ Р»Рё GUI, РµСЃР»Рё РґРѕР±Р°РІРёС‚СЊ Р±Р»РѕРє СЂРµР°Р»СЊРЅС‹С… РґР°РЅРЅС‹С…
local data = {
    ["rbxassetid://137637490639925"] = {name = "Royal Mistletroll", prices = {["default"] = 1250, ["Ride"] = 1123.75, ["Fly|Ride"] = 1643.21, ["Neon"] = 6586.42, ["Neon|Fly|Ride"] = 4792.78}},
    ["rbxassetid://140355753768438"] = {name = "Moonbeam Peacock", prices = {["default"] = 450, ["Fly"] = 713.71, ["Ride"] = 470, ["Fly|Ride"] = 553.85, ["Neon|Fly|Ride"] = 3068.38}},
    ["rbxassetid://18117855573"] = {name = "Balloon Unicorn", prices = {["default"] = 4249.98, ["Ride"] = 4125, ["Fly|Ride"] = 4199.5, ["Neon|Fly|Ride"] = 18481.85}},
    ["rbxassetid://75782719698946"] = {name = "Red Dutch Guinea Pig", prices = {["default"] = 180, ["Ride"] = 229.85, ["Fly|Ride"] = 313.16, ["Neon"] = 875, ["Neon|Ride"] = 812.5, ["Neon|Fly|Ride"] = 725}},
    ["rbxassetid://5067924142"] = {name = "Albino Monkey", prices = {["default"] = 482.5, ["Fly"] = 685.01, ["Ride"] = 499.99, ["Fly|Ride"] = 497.5, ["Neon|Fly|Ride"] = 1465}},
}
print("D1: РґР°РЅРЅС‹Рµ Р·Р°РіСЂСѓР¶РµРЅС‹, Р·Р°РїРёСЃРµР№:", #data and 5)
print("M1: СЃРєСЂРёРїС‚ Р·Р°РіСЂСѓР¶РµРЅ Xeno")
if not game:IsLoaded() then
    print("M2: Р¶РґС‘Рј game.Loaded")
    game.Loaded:Wait()
end
print("M3: РёРіСЂР° Р·Р°РіСЂСѓР¶РµРЅР°, LocalPlayer=" .. tostring(game.Players.LocalPlayer))
local p = game.Players.LocalPlayer
print("M4: PlayerGui=" .. tostring(p and p:FindFirstChild("PlayerGui")))
print("M5: РїСЂРѕР±СѓРµРј СЃРѕР·РґР°С‚СЊ GUI")
local scr = Instance.new("ScreenGui")
scr.Parent = p:FindFirstChild("PlayerGui")
local f = Instance.new("Frame")
f.Size = UDim2.new(0, 200, 0, 100)
f.Position = UDim2.new(0.5, -100, 0.5, -50)
f.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
f.Parent = scr
print("M6: GUI СЃРѕР·РґР°РЅ, РІСЃС‘ СЂР°Р±РѕС‚Р°РµС‚")
