﻿local T, C, L = unpack(select(2, ...)) -- Import Functions/Constants, Config, Locales


if not IsAddOnLoaded("Skada") or not C.Addon_Skins.Skada then return end
local Skada = Skada

local Skada = Skada
local barSpacing = T.Scale(1, 1)
local borderWidth = T.Scale(2, 2)

local barmod = Skada.displays["bar"]

-- Used to strip unecessary options from the in-game config
local function StripOptions(options)
	options.baroptions.args.barspacing = nil
	options.titleoptions.args.texture = nil
	options.titleoptions.args.bordertexture = nil
	options.titleoptions.args.thickness = nil
	options.titleoptions.args.margin = nil
	options.titleoptions.args.color = nil
	options.windowoptions = nil
	options.baroptions.args.barfont = nil
	options.titleoptions.args.font = nil
end

local barmod = Skada.displays["bar"]
barmod.AddDisplayOptions_ = barmod.AddDisplayOptions
barmod.AddDisplayOptions = function(self, win, options)
	self:AddDisplayOptions_(win, options)
	StripOptions(options)
end

for k, options in pairs(Skada.options.args.windows.args) do
	if options.type == "group" then
		StripOptions(options.args)
	end
end

local titleBG = {
	bgFile = C["media"].normTex,
	tile = false,
	tileSize = 0
}

barmod.ApplySettings_ = barmod.ApplySettings
barmod.ApplySettings = function(self, win)
	barmod.ApplySettings_(self, win)

	local skada = win.bargroup

	if win.db.enabletitle then
		skada.button:SetBackdrop(titleBG)
	end

	skada:SetTexture(C["media"].normTex)
	skada:SetSpacing(barSpacing)
	skada:SetFont(C.media.pixelfont, C["datatext"].fontsize, "MONOCHROMEOUTLINE")
	skada:SetFrameLevel(5)
	
	local titlefont = CreateFont("TitleFont"..win.db.name)
	titlefont:SetFont(C.media.pixelfont, C["datatext"].fontsize, "MONOCHROMEOUTLINE")
	win.bargroup.button:SetNormalFontObject(titlefont)

	local color = win.db.title.color
	win.bargroup.button:SetBackdropColor(unpack(C["media"].bordercolor))

	skada:SetBackdrop(nil)
	if not skada.backdrop then
		skada:CreateBackdrop("Default")
	end
	skada.backdrop:ClearAllPoints()
	if win.db.enabletitle then
		skada.backdrop:Point('TOPLEFT', win.bargroup.button, 'TOPLEFT', -2, 2)
	else
		skada.backdrop:Point('TOPLEFT', win.bargroup, 'TOPLEFT', -2, 2)
	end
	skada.backdrop:Point('BOTTOMRIGHT', win.bargroup, 'BOTTOMRIGHT', 2, -2)

	if C["Addon_Skins"].embedright == "Skada" then
		win.bargroup.button:SetFrameStrata("MEDIUM")
		win.bargroup.button:SetFrameLevel(5)	
		win.bargroup:SetFrameStrata("MEDIUM")
	end
end

local function EmbedWindow(window, width, barheight, height, point, relativeFrame, relativePoint, ofsx, ofsy)
	window.db.barwidth = width
	window.db.barheight = barheight
	if window.db.enabletitle then 
		height = height - barheight
	end
	window.db.background.height = height
	window.db.spark = false
	window.db.barslocked = true
	window.bargroup:ClearAllPoints()
	window.bargroup:SetPoint(point, relativeFrame, relativePoint, ofsx, ofsy)
	
	barmod.ApplySettings(barmod, window)
end

local windows = {}
function EmbedSkada()
	if #windows == 1 then
		EmbedWindow(windows[1], TukuiChatBackgroundRight:GetWidth() - 4,   (TukuiChatBackgroundRight:GetHeight() - 4 - (barSpacing * 4)) / 10, (TukuiChatBackgroundRight:GetHeight() - 6), "BOTTOMRIGHT", TukuiChatBackgroundRight, "BOTTOMRIGHT", -2, 3)
	elseif #windows == 2 then
		EmbedWindow(windows[1], ((TukuiChatBackgroundRight:GetWidth() - 4) / 2) - (borderWidth + T.mult), (TukuiChatBackgroundRight:GetHeight() - 4 - (barSpacing * 4)) / 10, TukuiChatBackgroundRight:GetHeight() - 4,    "BOTTOMRIGHT", TukuiChatBackgroundRight, "BOTTOMRIGHT", -2, 3)
		EmbedWindow(windows[2], ((TukuiChatBackgroundRight:GetWidth() - 4) / 2) - (borderWidth + T.mult), (TukuiChatBackgroundRight:GetHeight() - 4 - (barSpacing * 4)) / 10, TukuiChatBackgroundRight:GetHeight() - 4,    "BOTTOMLEFT", TukuiChatBackgroundRight, "BOTTOMLEFT", 2, 3)
	elseif #windows > 2 then
		EmbedWindow(windows[1], ((TukuiChatBackgroundRight:GetWidth() - 4) / 2) - (borderWidth + T.mult), (TukuiChatBackgroundRight:GetHeight() - 4 - (barSpacing * 4)) / 10, TukuiChatBackgroundRight:GetHeight() - 4,    "BOTTOMRIGHT", TukuiChatBackgroundRight, "BOTTOMRIGHT", -2, 3)
		EmbedWindow(windows[2], ((TukuiChatBackgroundRight:GetWidth() - 4) / 2) - (borderWidth + T.mult), ((TukuiChatBackgroundRight:GetHeight() - 6 / 2) - (barSpacing * 4)) / 10, TukuiChatBackgroundRight:GetHeight() - 4 / 2 - 2,  "BOTTOMLEFT", TukuiChatBackgroundRight, "BOTTOMLEFT", 2, 3)
		EmbedWindow(windows[3], windows[2].db.barwidth -1 , ((TukuiChatBackgroundRight:GetHeight() - 6 / 2) - (barSpacing * 4)) / 10, TukuiChatBackgroundRight:GetHeight() - 4 / 2 - 2,  "BOTTOMLEFT", windows[2].bargroup.backdrop, "TOPLEFT", 2, 4)
	end
end

-- Update pre-existing displays
for _, window in ipairs(Skada:GetWindows()) do
	window:UpdateDisplay()
end

if C["Addon_Skins"].embedright == "Skada" then
	Skada.CreateWindow_ = Skada.CreateWindow
	function Skada:CreateWindow(name, db)
		Skada:CreateWindow_(name, db)
		
		windows = {}
		for _, window in ipairs(Skada:GetWindows()) do
			tinsert(windows, window)
		end	
		
		EmbedSkada()
	end

	Skada.DeleteWindow_ = Skada.DeleteWindow
	function Skada:DeleteWindow(name)
		Skada:DeleteWindow_(name)
		
		windows = {}
		for _, window in ipairs(Skada:GetWindows()) do
			tinsert(windows, window)
		end	
		
		EmbedSkada()
	end

	local Skada_Skin = CreateFrame("Frame")
	Skada_Skin:RegisterEvent("PLAYER_ENTERING_WORLD")
	Skada_Skin:SetScript("OnEvent", function(self)
		self:UnregisterAllEvents()
		self = nil
		
		EmbedSkada()
	end)

	if TukuiTabsRightBackground then
		local button = CreateFrame('Button', 'SkadaToggleSwitch', TukuiTabsRightBackground)
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
		
		button:SetScript('OnEnter', function(self) button.text:SetText(L.addons_toggle..' Skada') end)
		button:SetScript('OnLeave', function(self) self.tex:Point('TOPRIGHT', -2, -2); button.text:SetText(nil) end)
		button:SetScript('OnMouseDown', function(self) self.tex:Point('TOPRIGHT', -4, -4) end)
		button:SetScript('OnMouseUp', function(self) self.tex:Point('TOPRIGHT', -2, -2) end)
		button:SetScript('OnClick', function(self) Skada:ToggleWindow() end)
	end	
	
	if C["Addon_Skins"].embedrighttoggle == true then
		TukuiChatBackgroundRight:HookScript("OnShow", function()
			for _, window in ipairs(Skada:GetWindows()) do
				window:Hide()
			end
		end)
		TukuiChatBackgroundRight:HookScript("OnHide", function()
			for _, window in ipairs(Skada:GetWindows()) do
				window:Show()
			end
		end)
	end
end