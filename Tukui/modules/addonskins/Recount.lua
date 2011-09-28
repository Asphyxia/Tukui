
--[[ Credit Tukz ]]--
local T, C, L = unpack(Tukui)
local Recount = _G.Recount

local function SkinFrame(frame)
	frame.bgMain = CreateFrame("Frame", nil, frame)
	frame.bgMain:SetTemplate("Transparent")
	frame.bgMain:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT")
	frame.bgMain:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT")
	frame.bgMain:SetPoint("TOP", frame, "TOP", 0, -7)
	frame.bgMain:SetFrameLevel(frame:GetFrameLevel())
	frame.CloseButton:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -1, -9)
	frame.TitleBackground = CreateFrame("Frame", nil, frame.bgMain)
	frame.TitleBackground:SetPoint("TOP", 0)
	frame.TitleBackground:SetPoint("LEFT", 0)
	frame.TitleBackground:SetPoint("RIGHT", 0)
	frame.TitleBackground:SetHeight(24)
	frame.TitleBackground:SetTemplate("Transparent")
	frame.Title:SetFont(C.media.pixelfont, C["datatext"].fontsize, "MONOCHROMEOUTLINE")
	frame.Title:SetParent(frame.TitleBackground)
	frame.Title:ClearAllPoints()
	frame.Title:SetPoint("LEFT", 4, 0)
	frame.CloseButton:SetNormalTexture("")
	frame.CloseButton:SetPushedTexture("")
	frame.CloseButton:SetHighlightTexture("")
	frame.CloseButton.t = frame.CloseButton:CreateFontString(nil, "OVERLAY")
	frame.CloseButton.t:SetFont(C.media.pixelfont, C["datatext"].fontsize, "MONOCHROMEOUTLINE")
	frame.CloseButton.t:SetPoint("CENTER", 0, 1)
	frame.CloseButton.t:SetText(T.datacolor.."X")
end

Recount.UpdateBarTextures = function(self)
	for k, v in pairs(Recount.MainWindow.Rows) do
		v.StatusBar:SetStatusBarTexture(C["media"].normTex)
		v.StatusBar:GetStatusBarTexture():SetHorizTile(false)
		v.StatusBar:GetStatusBarTexture():SetVertTile(false)
		v.LeftText:SetPoint("LEFT", 4, 1)
		v.LeftText:SetFont(C.media.pixelfont, C["datatext"].fontsize, "MONOCHROMEOUTLINE")
		v.RightText:SetPoint("RIGHT", -4, 1)
		v.RightText:SetFont(C.media.pixelfont, C["datatext"].fontsize, "MONOCHROMEOUTLINE")
	end
end
Recount.SetBarTextures = Recount.UpdateBarTextures

-- Fix bar textures as they're created
Recount.SetupBar_ = Recount.SetupBar
Recount.SetupBar = function(self, bar)
	self:SetupBar_(bar)
	bar.StatusBar:SetStatusBarTexture(C["media"].normTex)
end

-- Skin frames when they're created
Recount.CreateFrame_ = Recount.CreateFrame
Recount.CreateFrame = function(self, Name, Title, Height, Width, ShowFunc, HideFunc)
	local frame = self:CreateFrame_(Name, Title, Height, Width, ShowFunc, HideFunc)
	SkinFrame(frame)
	return frame
end

-- frame we want to skins
local elements = {
	Recount.MainWindow,
	Recount.ConfigWindow,
	Recount.GraphWindow,
	Recount.DetailWindow,
	Recount.ResetFrame,
}

-- skin them
for i = 1, getn(elements) do
	local frame = elements[i]
	if frame then
		SkinFrame(frame)
	end
end

--Update Textures
Recount:UpdateBarTextures()

-- skin dropdown
Recount.MainWindow.FileButton:HookScript("OnClick", function(self) if LibDropdownFrame0 then LibDropdownFrame0:SetTemplate() end end)

-- reskin button
Recount.MainWindow.RightButton:SetTemplate("Transparent")
Recount.MainWindow.RightButton:SetNormalTexture("")
Recount.MainWindow.RightButton:SetPushedTexture("")	
Recount.MainWindow.RightButton:SetHighlightTexture("")
Recount.MainWindow.RightButton:SetSize(16, 16)
Recount.MainWindow.RightButton:FontString("text", C.media.pixelfont, C["datatext"].fontsize, "MONOCHROMEOUTLINE")
Recount.MainWindow.RightButton.text:SetText(T.datacolor..">")
Recount.MainWindow.RightButton.text:SetPoint("CENTER", 1, 1)
Recount.MainWindow.RightButton:ClearAllPoints()
Recount.MainWindow.RightButton:SetPoint("RIGHT", Recount.MainWindow.CloseButton, "LEFT", -2, 0)

Recount.MainWindow.LeftButton:SetTemplate("Transparent")
Recount.MainWindow.LeftButton:SetNormalTexture("")
Recount.MainWindow.LeftButton:SetPushedTexture("")	
Recount.MainWindow.LeftButton:SetHighlightTexture("")
Recount.MainWindow.LeftButton:SetSize(16, 16)
Recount.MainWindow.LeftButton:FontString("text", C.media.pixelfont, C["datatext"].fontsize, "MONOCHROMEOUTLINE")
Recount.MainWindow.LeftButton.text:SetText(T.datacolor.."<")
Recount.MainWindow.LeftButton.text:SetPoint("CENTER", 1, 1)
Recount.MainWindow.LeftButton:SetPoint("RIGHT", Recount.MainWindow.RightButton, "LEFT", -2, 0)

Recount.MainWindow.ResetButton:SetTemplate("Transparent")
Recount.MainWindow.ResetButton:SetNormalTexture("")
Recount.MainWindow.ResetButton:SetPushedTexture("")	
Recount.MainWindow.ResetButton:SetHighlightTexture("")
Recount.MainWindow.ResetButton:FontString("text", C.media.pixelfont, C["datatext"].fontsize, "MONOCHROMEOUTLINE")
Recount.MainWindow.ResetButton.text:SetText(T.datacolor.."R")
Recount.MainWindow.ResetButton.text:SetPoint("CENTER", 1, 1)
Recount.MainWindow.ResetButton:SetPoint("RIGHT", Recount.MainWindow.LeftButton, "LEFT", -2, 0)

Recount.MainWindow.FileButton:SetTemplate("Transparent")
Recount.MainWindow.FileButton:SetNormalTexture("")
Recount.MainWindow.FileButton:SetPushedTexture("")	
Recount.MainWindow.FileButton:SetHighlightTexture("")
Recount.MainWindow.FileButton:FontString("text", C.media.pixelfont, C["datatext"].fontsize, "MONOCHROMEOUTLINE")
Recount.MainWindow.FileButton.text:SetText(T.datacolor.."F")
Recount.MainWindow.FileButton.text:SetPoint("CENTER", 1, 1)
Recount.MainWindow.FileButton:SetPoint("RIGHT", Recount.MainWindow.ResetButton, "LEFT", -2, 0)

Recount.MainWindow.ConfigButton:SetTemplate("Transparent")
Recount.MainWindow.ConfigButton:SetNormalTexture("")
Recount.MainWindow.ConfigButton:SetPushedTexture("")	
Recount.MainWindow.ConfigButton:SetHighlightTexture("")
Recount.MainWindow.ConfigButton:FontString("text", C.media.pixelfont, C["datatext"].fontsize, "MONOCHROMEOUTLINE")
Recount.MainWindow.ConfigButton.text:SetText(T.datacolor.."C")
Recount.MainWindow.ConfigButton.text:SetPoint("CENTER", 1, 1)
Recount.MainWindow.ConfigButton:SetPoint("RIGHT", Recount.MainWindow.FileButton, "LEFT", -2, 0)

Recount.MainWindow.ReportButton:SetTemplate("Transparent")
Recount.MainWindow.ReportButton:SetNormalTexture("")
Recount.MainWindow.ReportButton:SetPushedTexture("")	
Recount.MainWindow.ReportButton:SetHighlightTexture("")
Recount.MainWindow.ReportButton:FontString("text", C.media.pixelfont, C["datatext"].fontsize, "MONOCHROMEOUTLINE")
Recount.MainWindow.ReportButton.text:SetText(T.datacolor.."S")
Recount.MainWindow.ReportButton.text:SetPoint("CENTER", 1, 1)
Recount.MainWindow.ReportButton:SetPoint("RIGHT", Recount.MainWindow.ConfigButton, "LEFT", -2, 0)

if C["Addon_Skins"].embedright == "Recount" then
	local Recount_Skin = CreateFrame("Frame")
	Recount_Skin:RegisterEvent("PLAYER_ENTERING_WORLD")
	Recount_Skin:SetScript("OnEvent", function(self)
		self:UnregisterAllEvents()
		self = nil

		Recount_MainWindow:ClearAllPoints()
		Recount_MainWindow:SetPoint("TOPLEFT", TukuiChatBackgroundRight,"TOPLEFT", 0, 7)
		Recount_MainWindow:SetPoint("BOTTOMRIGHT", TukuiChatBackgroundRight,"BOTTOMRIGHT", 0, 0)
		Recount.db.profile.FrameStrata = "3-MEDIUM"
		Recount.db.profile.MainWindowWidth = (TukuiChatBackgroundLeft:GetWidth() - 4)	
	end)
	
	if TukuiTabsRightBackground then
		local button = CreateFrame('Button', 'RecountToggleSwitch', TukuiTabsRightBackground)
		button:Width(90)
		button:Height(TukuiTabsRightBackground:GetHeight() - 4)
		button:Point("CENTER", TukuiTabsRightBackground, "CENTER", 2, 0)
		
		button.tex = button:CreateTexture(nil, 'OVERLAY')
		button.tex:SetTexture([[Interface\AddOns\Tukui\medias\textures\addons_toggle.tga]])
		button.tex:Point('TOPRIGHT', -2, 0)
		button.tex:Height(button:GetHeight() - 4)
		button.tex:Width(16)
		
		button:FontString(nil, C.media.pixelfont, C["datatext"].fontsize +1, "MONOCHROMEOUTLINE")
		button.text:SetPoint('RIGHT', button.tex, 'LEFT')
		button.text:SetTextColor(unpack(C["media"].datacolor))
		
		button:SetScript('OnEnter', function(self) button.text:SetText(L.addons_toggle..' Recount') end)
		button:SetScript('OnLeave', function(self) self.tex:Point('TOPRIGHT', -2, 0); button.text:SetText(nil) end)
		button:SetScript('OnMouseDown', function(self) self.tex:Point('TOPRIGHT', -4, -4) end)
		button:SetScript('OnMouseUp', function(self) self.tex:Point('TOPRIGHT', -2, -2) end)
		button:SetScript('OnClick', function(self) ToggleFrame(Recount_MainWindow) end)
	end	
	
	if C["Addon_Skins"].embedrighttoggle == true then
		TukuiChatBackgroundRight:HookScript("OnShow", function() Recount_MainWindow:Hide() end)
		TukuiChatBackgroundRight:HookScript("OnHide", function() Recount_MainWindow:Show() end)
	end	
end
