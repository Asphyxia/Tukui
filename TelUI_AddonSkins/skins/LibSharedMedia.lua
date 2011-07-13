--[[
	LibSharedMedia-3.0 Integration Skin - Registers textures and fonts used by
	the skins with LibSharedMedia to make it easier to skin addons which do not
	have an editless skin file or which cannot be fully skinned without edits.
	
	File version 91.109
	(C)2010 Darth Android / Telroth - The Venture Co.
]]

--[[if not LibStub then return end -- No LibStub, then LSM isn't even loaded in the first place.
local LSM = LibStub("LibSharedMedia-3.0", true)
if not LSM or not Mod_AddonSkins then return end

Mod_AddonSkins:RegisterSkin("LibSharedMedia",function(Skin,skin,Layout,layout,config)
	LSM:Register("statusbar","TelUI Statusbar",config.barTexture)
	LSM:Register("background","TelUI Background",config.bgTexture)
	LSM:Register("border","TelUI Border",config.borderTexture)
	LSM:Register("font","TelUI Font",config.font)
end)--]]