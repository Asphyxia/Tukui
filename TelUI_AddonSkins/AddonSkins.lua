--[[
	Mod_AddonSkins - Addon skinning and integration for TelUI
]]
if not TelUI then return end
local TelUI = TelUI
local Mod_AddonSkins = TelUI:CreateClass("Mod_AddonSkins")

function Mod_AddonSkins.__construct()
	local self = super()
	for name,func in pairs(Mod_AddonSkins:GetSkins()) do
		if TelUI.addonskins[name] ~= false then
			TelUI.safecall(func,Skin, TelUI.loadedSkin, Layout, TelUI.loadedLayout, TelUI.skin)
		end
	end
	return self
end

function Mod_AddonSkins:RegisterSkin(name, initFunc)
	self = Mod_AddonSkins -- Static function
	if type(initFunc) ~= "function" then error("initFunc must be a function!",2) end
	self.skins[name] = initFunc
	--
end

function Mod_AddonSkins:GetSkins()
	self = Mod_AddonSkins -- Static function
	return self.skins
end

Mod_AddonSkins.skins = {}