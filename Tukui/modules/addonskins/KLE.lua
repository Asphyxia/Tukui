-- KLE Skin, credits to Elv22
local T, C, L = unpack(select(2, ...)) -- Import Functions/Constants, Config, Locales

if not IsAddOnLoaded("KLE") or not C.Addon_Skins.KLE then return end

local KLE = KLE
local _G = getfenv(0)
local barSpacing = T.Scale(3, 1)
local borderWidth = T.Scale(2, 2)
local buttonZoom = {.09,.91,.09,.91}

local function SkinKLEBar(bar)
	-- The main bar
	bar:SetTemplate("Default")
	bar.bg:SetTexture(nil)
	bar.border:Kill()
	bar.statusbar:SetStatusBarTexture(C["media"].normTex)
	bar.statusbar:ClearAllPoints()
	bar.statusbar:SetPoint("TOPLEFT",borderWidth, -borderWidth)
	bar.statusbar:SetPoint("BOTTOMRIGHT",-borderWidth, borderWidth)
	
	-- Right Icon
	bar.righticon:SetTemplate("Default")
	bar.righticon.border:Kill()
	bar.righticon.t:SetTexCoord(unpack(buttonZoom))
	bar.righticon.t:ClearAllPoints()
	bar.righticon.t:SetPoint("TOPLEFT", borderWidth, -borderWidth)
	bar.righticon.t:SetPoint("BOTTOMRIGHT", -borderWidth, borderWidth)
	bar.righticon.t:SetDrawLayer("ARTWORK")
	
	-- Left Icon
	bar.lefticon:SetTemplate("Default")
	bar.lefticon.border:Kill()
	bar.lefticon.t:SetTexCoord(unpack(buttonZoom))
	bar.lefticon.t:ClearAllPoints()
	bar.lefticon.t:SetPoint("TOPLEFT",borderWidth, -borderWidth)
	bar.lefticon.t:SetPoint("BOTTOMRIGHT",-borderWidth, borderWidth)
	bar.lefticon.t:SetDrawLayer("ARTWORK")
end

--Kill KLE's skinning
KLE.NotifyBarTextureChanged = T.dummy
KLE.NotifyBorderChanged = T.dummy
KLE.NotifyBorderColorChanged = T.dummy
KLE.NotifyBorderEdgeSizeChanged = T.dummy
KLE.NotifyBackgroundTextureChanged = T.dummy
KLE.NotifyBackgroundInsetChanged = T.dummy
KLE.NotifyBackgroundColorChanged = T.dummy

--Hook Window Creation
KLE.CreateWindow_ = KLE.CreateWindow
KLE.CreateWindow = function(self, name, width, height)
	local win = self:CreateWindow_(name, width, height)
	win:CreateShadow("")
	win:SetTemplate("Default")
	return win
end

-- Skin the pane
KLE.Pane:SetTemplate("Default")
KLE.Pane:CreateShadow("")

-- Hook Health frames (Skin & spacing)
KLE.LayoutHealthWatchers_ = KLE.LayoutHealthWatchers
KLE.LayoutHealthWatchers = function(self)
	self.db.profile.Pane.BarSpacing = barSpacing
	self:LayoutHealthWatchers_()
	for i,hw in ipairs(self.HW) do
		if hw:IsShown() then
			hw:SetTemplate("Default")
			hw:CreateShadow("")
			hw.border:Kill()
			hw.healthbar:SetStatusBarTexture(C["media"].normTex)
		end
	end
end

KLE.Alerts.RefreshBars_ = KLE.Alerts.RefreshBars
KLE.Alerts.RefreshBars = function(self)
	if self.refreshing then return end
	self.refreshing = true
	self.db.profile.BarSpacing = barSpacing
	self.db.profile.IconXOffset = barSpacing
	self:RefreshBars_()
	local i = 1
	while _G["KLEAlertBar"..i] do
		local bar = _G["KLEAlertBar"..i]
		bar:SetScale(1)
		bar:SetAlpha(1)
		bar.SetAlpha = T.dummy
		bar.SetScale = T.dummy
		SkinKLEBar(bar)
		i = i + 1
	end
	self.refreshing = false
end

KLE.Alerts.Dropdown_ = KLE.Alerts.Dropdown
KLE.Alerts.Dropdown = function(self,...)
	self:Dropdown_(...)
	self:RefreshBars()
end

KLE.Alerts.CenterPopup_ = KLE.Alerts.CenterPopup
KLE.Alerts.CenterPopup = function(self,...)
	self:CenterPopup_(...)
	self:RefreshBars()
end

KLE.Alerts.Simple_ = KLE.Alerts.Simple
KLE.Alerts.Simple = function(self,...)
	self:Simple_(...)
	self:RefreshBars()
end

-- Force some updates
KLE:LayoutHealthWatchers()
KLE.Alerts:RefreshBars()
KLE.Pane.border:Kill()

--Force some default profile options
if not KLEDB then KLEDB = {} end
if not KLEDB["profiles"] then KLEDB["profiles"] = {} end
if not KLEDB["profiles"][T.myname.." - "..GetRealmName()] then KLEDB["profiles"][T.myname.." - "..T.myrealm] = {} end
if not KLEDB["profiles"][T.myname.." - "..GetRealmName()]["Globals"] then KLEDB["profiles"][T.myname.." - "..T.myrealm]["Globals"] = {} end
KLEDB["profiles"][T.myname.." - "..T.myrealm]["Globals"]["BackgroundTexture"] = "Tukui Blank"
KLEDB["profiles"][T.myname.." - "..T.myrealm]["Globals"]["BarTexture"] = "Tukui Statusbar"
KLEDB["profiles"][T.myname.." - "..T.myrealm]["Globals"]["Border"] = "None"
KLEDB["profiles"][T.myname.." - "..T.myrealm]["Globals"]["Font"] = "Tukui Normal Font"
KLEDB["profiles"][T.myname.." - "..T.myrealm]["Globals"]["TimerFont"] = "Tukui Normal Font"