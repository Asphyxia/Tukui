--[[
	Recount Skin by Darth Android / Telroth - Black Dragonflight
	
	Skins Recount to look like TelUI.
	
	Todo:
	 + Reorganize to support skin subclass overrides
	 + Reorganize to support layout subclass overrides
	 + Skin "Reset Data" windows
	 
	(C)2010 Darth Android / Telroth - Black Dragonflight
	File version v15.37
]]
local T, C, L = unpack(select(2, ...)) -- Import Functions/Constants, Config, Locales


if not IsAddOnLoaded("Recount") or not C.Addon_Skins.Recount then return end
local Recount = _G.Recount

local function SkinFrame(frame)
	frame.bgMain = CreateFrame("Frame", nil, frame)
	frame.bgMain:SetTemplate("Default")
	frame.bgMain:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT")
	frame.bgMain:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT")
	frame.bgMain:SetPoint("TOP", frame, "TOP", 0, -7)
	frame.bgMain:SetFrameLevel(frame:GetFrameLevel())
	frame.CloseButton:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -1, -9)
	frame:SetBackdrop(nil)
	frame.Title:SetFont(C.media.pixelfont, C["datatext"].fontsize+1, "MONOCHROMEOUTLINE")
	frame.CloseButton:SetNormalTexture("")
	frame.CloseButton:SetPushedTexture("")
	frame.CloseButton:SetHighlightTexture("")
	frame.CloseButton.t = frame.CloseButton:CreateFontString(nil, "OVERLAY")
	frame.CloseButton.t:SetFont(C.media.pixelfont, C["datatext"].fontsize, "MONOCHROMEOUTLINE")
	frame.CloseButton.t:SetPoint("CENTER", 0, 1)
	frame.CloseButton.t:SetText(T.datacolor.."X")
	frame.CloseButton:SetScript("OnEnter", function() frame.CloseButton.t:SetText(T.datacolor.."X") end)
	frame.CloseButton:SetScript("OnLeave", function() frame.CloseButton.t:SetText(T.datacolor.."X") end)
end

Recount.UpdateBarTextures = function(self)
		for k, v in pairs(Recount.MainWindow.Rows) do
			v.StatusBar:SetStatusBarTexture(C["media"].normTex)
			v.StatusBar:GetStatusBarTexture():SetHorizTile(false)
			v.StatusBar:GetStatusBarTexture():SetVertTile(false)
			v.LeftText:SetPoint("LEFT", 4, 1)
			v.LeftText:SetFont(C.media.pixelfont, C["datatext"].fontsize+1, "MONOCHROMEOUTLINE")
			v.RightText:SetPoint("RIGHT", -4, 1)
			v.RightText:SetFont(C.media.pixelfont, C["datatext"].fontsize+1, "MONOCHROMEOUTLINE")
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

-- Skin existing frames
if Recount.MainWindow then SkinFrame(Recount.MainWindow) end
if Recount.ConfigWindow then SkinFrame(Recount.ConfigWindow) end
if Recount.GraphWindow then SkinFrame(Recount.GraphWindow) end
if Recount.DetailWindow then SkinFrame(Recount.DetailWindow) end
if Recount.ResetFrame then SkinFrame(Recount.ResetFrame) end
if _G["Recount_Realtime_!RAID_DAMAGE"] then SkinFrame(_G["Recount_Realtime_!RAID_DAMAGE"].Window) end
if _G["Recount_Realtime_!RAID_HEALING"] then SkinFrame(_G["Recount_Realtime_!RAID_HEALING"].Window) end
if _G["Recount_Realtime_!RAID_HEALINGTAKEN"] then SkinFrame(_G["Recount_Realtime_!RAID_HEALINGTAKEN"].Window) end
if _G["Recount_Realtime_!RAID_DAMAGETAKEN"] then SkinFrame(_G["Recount_Realtime_!RAID_DAMAGETAKEN"].Window) end
if _G["Recount_Realtime_Bandwidth Available_AVAILABLE_BANDWIDTH"] then SkinFrame(_G["Recount_Realtime_Bandwidth Available_AVAILABLE_BANDWIDTH"].Window) end
if _G["Recount_Realtime_FPS_FPS"] then SkinFrame(_G["Recount_Realtime_FPS_FPS"].Window) end
if _G["Recount_Realtime_Latency_LAG"] then SkinFrame(_G["Recount_Realtime_Latency_LAG"].Window) end
if _G["Recount_Realtime_Downstream Traffic_DOWN_TRAFFIC"] then SkinFrame(_G["Recount_Realtime_Downstream Traffic_DOWN_TRAFFIC"].Window) end
if _G["Recount_Realtime_Upstream Traffic_UP_TRAFFIC"] then SkinFrame(_G["Recount_Realtime_Upstream Traffic_UP_TRAFFIC"].Window) end

--Update Textures
Recount:UpdateBarTextures()

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
		button.tex:Point('TOPRIGHT', -2, -2)
		button.tex:Height(button:GetHeight() - 4)
		button.tex:Width(16)
		
		button:FontString(nil, C.media.pixelfont, C["datatext"].fontsize, "MONOCHROMEOUTLINE")
		button.text:SetPoint('RIGHT', button.tex, 'LEFT')
		button.text:SetTextColor(unpack(C["media"].datacolor))
		
		button:SetScript('OnEnter', function(self) button.text:SetText(L.addons_toggle..' Recount') end)
		button:SetScript('OnLeave', function(self) self.tex:Point('TOPRIGHT', -2, -2); button.text:SetText(nil) end)
		button:SetScript('OnMouseDown', function(self) self.tex:Point('TOPRIGHT', -4, -4) end)
		button:SetScript('OnMouseUp', function(self) self.tex:Point('TOPRIGHT', -2, -2) end)
		button:SetScript('OnClick', function(self) ToggleFrame(Recount_MainWindow) end)
	end	
	
	if C["Addon_Skins"].embedrighttoggle == true then
		TukuiChatBackgroundRight:HookScript("OnShow", function() Recount_MainWindow:Hide() end)
		TukuiChatBackgroundRight:HookScript("OnHide", function() Recount_MainWindow:Show() end)
	end	
end