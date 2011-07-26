local T, C, L = unpack(Tukui) -- Import: T - functions, constants, variables; C - config; L - locales

-- SWITCH LAYOUT
if C.chat.background then
	local swlicon = CreateFrame("Frame", "TukuiSwitchLayoutIcon", TukuiInfoCenterRight)
	swlicon:CreatePanel("Default", 20, 20, "LEFT", TukuiInfoCenterRight, "RIGHT", 2, 0)
	swlicon:SetFrameStrata("BACKGROUND")
	swlicon:CreateShadow("Default")
	swlicon:SetFrameLevel(TukuiSwitchLayoutButton:GetFrameLevel())

	local tex = swlicon:CreateTexture(nil, "OVERLAY")
	tex:SetTexture(C.media.switchlayoutheal)
	tex:SetPoint("TOPLEFT", swlicon, "TOPLEFT", 2, -2)
	tex:SetPoint("BOTTOMRIGHT", swlicon, "BOTTOMRIGHT", -2, 2)
end