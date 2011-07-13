--[[	
	(C)2010 Darth Android / Telroth-Black Dragonflight
]]
-- TelUI_AddonSkins
AddonSkins_Mod = CreateFrame("Frame")
local AddonSkins_Mod = AddonSkins_Mod
local T, C, L = unpack(select(2, ...)) -- Import Functions/Constants, Config, Locales

local function skinFrame(self, frame)
	--Unfortionatly theres not a prettier way of doing this
	if frame:GetParent():GetName() == "Recount_ConfigWindow" then
		frame:SetTemplate("Transparent")
		frame:SetFrameStrata("BACKGROUND")
		frame.SetFrameStrata = T.dummy
	elseif frame:GetName() == "OmenBarList" or 
		frame:GetName() == "OmenTitle" or 
		frame:GetName() == "DXEPane" or 
		frame:GetName() == "SkadaBG" or 
		frame:GetParent():GetName() == "Recount_MainWindow" or 
		frame:GetParent():GetName() == "Recount_GraphWindow" or 
		frame:GetParent():GetName() == "Recount_DetailWindow" then
			frame:SetTemplate("Transparent")
		if frame:GetParent():GetName() ~= "Recount_GraphWindow" and frame:GetParent():GetName() ~= "Recount_DetailWindow" then
			frame:SetFrameStrata("MEDIUM")
		else
			frame:SetFrameStrata("BACKGROUND")
		end
	else
		frame:SetTemplate("Transparent")
	end
	--frame:CreateShadow("Default")
end
local function skinButton(self, button)
	skinFrame(self, button)
	-- Crazy hacks which only work because self = Skin *AND* self = config
	local name = button:GetName()
	local icon = _G[name.."Icon"]
	if icon then
		icon:SetTexCoord(unpack(self.buttonZoom))
		icon:SetDrawLayer("ARTWORK")
		icon:ClearAllPoints()
		icon:SetPoint("TOPLEFT",button,"TOPLEFT",self.borderWidth, -self.borderWidth)
		icon:SetPoint("BOTTOMRIGHT",button,"BOTTOMRIGHT",-self.borderWidth, self.borderWidth)
	end
end

AddonSkins_Mod.SkinFrame = skinFrame
AddonSkins_Mod.SkinBackgroundFrame = skinFrame
AddonSkins_Mod.SkinButton = skinButton
AddonSkins_Mod.normTexture = C.media.normTex
AddonSkins_Mod.bgTexture = C.media.blank
AddonSkins_Mod.font = C.media.pixelfont
AddonSkins_Mod.smallFont = C.media.pixelfont
AddonSkins_Mod.fontSize = 8
AddonSkins_Mod.buttonSize = T.Scale(27,27)
AddonSkins_Mod.buttonSpacing = T.Scale(T.buttonspacing,T.buttonspacing)
AddonSkins_Mod.borderWidth = T.Scale(2,2)
AddonSkins_Mod.buttonZoom = {.09,.91,.09,.91}
AddonSkins_Mod.barSpacing = T.Scale(1,1)
AddonSkins_Mod.barHeight = T.Scale(20,20)
AddonSkins_Mod.skins = {}

-- Dummy function expected by some skins
function dummy() end

function AddonSkins_Mod:RegisterSkin(name, initFunc)
	self = AddonSkins_Mod -- Static function
	if type(initFunc) ~= "function" then error("initFunc must be a function!",2) end
	self.skins[name] = initFunc
end

AddonSkins_Mod:RegisterEvent("PLAYER_LOGIN")
AddonSkins_Mod:SetScript("OnEvent",function(self, event, addon)
	-- Initialize all skins
	for name, func in pairs(self.skins) do
		func(self,self,self,self,self) -- AddonSkins_Mod functions as skin, layout, and config.
	end
	self:UnregisterEvent("PLAYER_LOGIN")
end)