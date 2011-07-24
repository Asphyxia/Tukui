-- Credits to Dajova :-*
local T, C, L = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales
if not IsAddOnLoaded("TinyDPS") or not C.Addon_Skins.TinyDPS then return end

local TinyDPS = CreateFrame("Frame")
TinyDPS:RegisterEvent("ADDON_LOADED")
TinyDPS:SetScript("OnEvent", function(self, event, addon)
	if not addon == "TinyDPS" then return end
	tdps.width = TukuiMinimap:GetWidth()
	tdps.barHeight = 14
	tdps.spacing = 1
	tdpsFont.name = C["media"].pixelfont
	tdpsFont.size = 12
	tdpsFont.outline = "MONOCHROMEOUTLINE"

	tdpsPosition = {x = 0, y = -6}

	tdpsFrame:SetHeight(tdps.barHeight + 4)
	tdpsFrame:SetTemplate("Default")
	tdpsFrame:CreateShadow("Default")

	tdpsAnchor:SetPoint('BOTTOMLEFT', TukuiMinimap, 'BOTTOMLEFT', 0, -44)

	self:UnregisterEvent("ADDON_LOADED")
end)