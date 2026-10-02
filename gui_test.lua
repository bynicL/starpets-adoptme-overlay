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
f.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
f.Parent = scr
print("M6: GUI СЃРѕР·РґР°РЅ, РІСЃС‘ СЂР°Р±РѕС‚Р°РµС‚")
