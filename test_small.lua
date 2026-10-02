-- РњР°Р»РµРЅСЊРєРёР№ С‚РµСЃС‚РѕРІС‹Р№ СЃРєСЂРёРїС‚: РїСЂРѕРІРµСЂСЏРµС‚, С‡С‚Рѕ loadstring СЃ GitHub СЂР°Р±РѕС‚Р°РµС‚
if not game:IsLoaded() then game.Loaded:Wait() end
print("=== MINI TEST OK ===")
local p = game.Players.LocalPlayer
print("LocalPlayer:", tostring(p))
print("PlayerGui РЅР°Р№РґРµРЅ:", tostring(p and p:FindFirstChild("PlayerGui")))
