local T, C, L = unpack(Tukui) -- Import: T - functions, constants, variables; C - config; L - locales

-- SWITCH LAYOUT
if C.chat.background then
	local swlicon = CreateFrame("Frame", "TukuiSwitchLayoutIcon", TukuiSwitchLayoutButton)
	swlicon:CreatePanel("Default", TukuiTabsRightBackground:GetHeight()-4, TukuiTabsRightBackground:GetHeight()-4, "LEFT", TukuiSwitchLayoutButton, "RIGHT", 0, 0)
	swlicon:SetFrameStrata("BACKGROUND")
	swlicon:SetFrameLevel(TukuiSwitchLayoutButton:GetFrameLevel())

	local tex = swlicon:CreateTexture(nil, "OVERLAY")
	tex:SetTexture(C.media.switchlayoutdd)
	tex:SetPoint("TOPLEFT", swlicon, "TOPLEFT", 2, -2)
	tex:SetPoint("BOTTOMRIGHT", swlicon, "BOTTOMRIGHT", -2, 2)
end