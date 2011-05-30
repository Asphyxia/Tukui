local T, C, L = unpack(Tukui) -- Import: T - functions, constants, variables; C - config; L - locales

-- SWITCH LAYOUT
if C.chat.background then
	local swlicon = CreateFrame("Frame", "TukuiSwitchLayoutIcon", TukuiTabsRightBackground)
	swlicon:CreatePanel("Default", TukuiTabsRightBackground:GetHeight()-6, TukuiTabsRightBackground:GetHeight()-6, "LEFT", TukuiSwitchLayoutButton, "RIGHT", 0, 0)
	swlicon:SetFrameStrata("BACKGROUND")
	swlicon:SetFrameLevel(TukuiSwitchLayoutButton:GetFrameLevel())

	local tex = swlicon:CreateTexture(nil, "OVERLAY")
	tex:SetTexture(C.media.switchlayoutheal)
	tex:SetPoint("TOPLEFT", swlicon, "TOPLEFT", 2, -2)
	tex:SetPoint("BOTTOMRIGHT", swlicon, "BOTTOMRIGHT", -2, 2)
end

