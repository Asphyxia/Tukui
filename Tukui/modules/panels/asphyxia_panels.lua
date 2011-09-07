local T, C, L = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales

local DataVisibility = 1

local function ModifiedBackdrop(self)
	local color = RAID_CLASS_COLORS[T.myclass]
	self:SetBackdropColor(color.r*.15, color.g*.15, color.b*.15)
	self:SetBackdropBorderColor(color.r, color.g, color.b)
end

local function OriginalBackdrop(self)
	self:SetTemplate("Default")
end

---------------------------------------------------------
---[[ ADDITIONAL (Asphyxia) PANELS ]]---
---------------------------------------------------------

-- INFO CENTER (FOR STATS)
local icenter = CreateFrame("Frame", "TukuiInfoCenter", TukuiBar1)
icenter:CreatePanel("Default", TukuiBar1:GetWidth(), 20, "TOP", TukuiBar1, "BOTTOM", 0, -3)
icenter:CreateOverlay(icenter)
icenter:CreateShadow("Default")
icenter:SetFrameLevel(2)
icenter:SetFrameStrata("BACKGROUND")

-- INFO CENTER LEFT (FOR STATS)
local icenterleft = CreateFrame("Frame", "TukuiInfoCenterLeft", TukuiBar2)
icenterleft:CreatePanel("Default", TukuiBar2:GetWidth(), 20, "TOP", TukuiBar2, "BOTTOM", 0, -3)
icenterleft:CreateOverlay(icenterleft)
icenterleft:CreateShadow("Default")
icenterleft:SetFrameLevel(2)
icenterleft:SetFrameStrata("BACKGROUND")

-- INFO CENTER RIGHT (FOR STATS)
local icenterright = CreateFrame("Frame", "TukuiInfoCenterRight", TukuiBar3)
icenterright:CreatePanel("Default", TukuiBar3:GetWidth(), 20, "TOP", TukuiBar3, "BOTTOM", 0, -3)
icenterright:CreateOverlay(icenterright)
icenterright:CreateShadow("Default")
icenterright:SetFrameLevel(2)
icenterright:SetFrameStrata("BACKGROUND")

-- SPECSWITCHER
if C.datatext.enable_specswitcher then
	local specswitcher = CreateFrame("Button", "TukuiSpecSwitcher", TukuiTabsLeftBackground)
	specswitcher :Size(75, TukuiTabsLeftBackground:GetHeight())
	specswitcher :Point("RIGHT", TukuiTabsLeftBackground, "RIGHT", -41, 0)
	specswitcher :SetFrameStrata(TukuiTabsLeftBackground:GetFrameStrata())
	specswitcher :SetFrameLevel(TukuiTabsLeftBackground:GetFrameLevel() + 1)

	local talenticon = CreateFrame("Frame", "TukuiTalentIcon", TukuiSpecSwitcher)
	--talenticon:CreatePanel("Default", 18, 18, "LEFT", specswitcher, "RIGHT", 20, 0)
	talenticon:CreatePanel("Default", TukuiTabsLeftBackground:GetHeight()-4, TukuiTabsLeftBackground:GetHeight()-4, "LEFT", specswitcher, "RIGHT", 20, 0)
	--talenticon:CreateShadow("Default")
	talenticon:SetFrameLevel(2)
	talenticon:SetFrameStrata("DIALOG")

	talenticon.tex = talenticon:CreateTexture(nil, "ARTWORK")
	talenticon.tex:Point("TOPLEFT", 2, -2)
	talenticon.tex:Point("BOTTOMRIGHT", -2, 2)
	talenticon.tex:SetTexCoord(0.08, 0.92, 0.08, 0.92)

	local UpdateTexture = function(self)
		if not GetPrimaryTalentTree() then return end
		local primary = GetPrimaryTalentTree()
		local tex = select(4, GetTalentTabInfo(primary))

		self.tex:SetTexture(tex)
	end

	talenticon:RegisterEvent("PLAYER_ENTERING_WORLD")
	talenticon:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
	talenticon:RegisterEvent("PLAYER_TALENT_UPDATE")
	talenticon:SetScript("OnEvent", UpdateTexture)
end

-- TIME PANEL
local watch = CreateFrame("Frame", "Tukuiwatch", Minimap)
watch:CreatePanel("Default", 53, 17, "TOP", Minimap, "BOTTOM", T.Scale(0), 8)
watch:CreateShadow("Default")
watch:SetFrameStrata("MEDIUM")
watch:CreateOverlay(watch)
watch:SetFrameLevel(2)

-- SWITCH LAYOUT
if C.chat.background then
	local swl = CreateFrame("Button", "TukuiSwitchLayoutButton", TukuiTabsRightBackground)
	swl:Size(75, TukuiTabsRightBackground:GetHeight())
	swl:Point("RIGHT", TukuiTabsRightBackground, "RIGHT", -21, 0)
	swl:SetFrameStrata(TukuiTabsRightBackground:GetFrameStrata())
	swl:SetFrameLevel(TukuiTabsRightBackground:GetFrameLevel() + 1)
	swl:RegisterForClicks("AnyUp") swl:SetScript("OnClick", function()
		if IsAddOnLoaded("Tukui_Raid") then
			DisableAddOn("Tukui_Raid")
			EnableAddOn("Tukui_Raid_Healing")
			ReloadUI()
		elseif IsAddOnLoaded("Tukui_Raid_Healing") then
			DisableAddOn("Tukui_Raid_Healing")
			EnableAddOn("Tukui_Raid")
			ReloadUI()
		elseif not IsAddOnLoaded("Tukui_Raid_Healing") and not IsAddOnLoaded("Tukui_Raid") then
			EnableAddOn("Tukui_Raid")
			ReloadUI()
		end
	end)

	swl.Text = T.SetFontString(swl, C.media.pixelfont, C["datatext"].fontsize, "MONOCHROMEOUTLINE")
	swl.Text:Point("RIGHT", swl, "RIGHT", -5, 0.5)
	swl.Text:SetText(T.datacolor..L.datatext_switch_layout)
end

-- VERSION BUTTON
local verbutton = CreateFrame("Button", "TukuiVersionButton", TukuiMinimap, "SecureActionButtonTemplate")
verbutton:CreatePanel("Default", 13, 17, "LEFT", Tukuiwatch, "RIGHT", 3, 0)
verbutton:CreateShadow("Default")
verbutton:CreateOverlay(verbutton)
verbutton:SetAttribute("type", "macro")
verbutton:SetAttribute("macrotext", "/version")
verbutton:SetFrameStrata("MEDIUM")
verbutton:SetFrameLevel(2)

verbutton.Text = T.SetFontString(verbutton, C.media.pixelfont, C["datatext"].fontsize, "MONOCHROMEOUTLINE")
verbutton.Text:Point("CENTER", verbutton, "CENTER", 2, 1)
verbutton.Text:SetText(T.datacolor.."V")

verbutton:SetScript("OnMouseDown", function(self)
if InCombatLockdown() then print(ERR_NOT_IN_COMBAT) return end
	if not TukuiVersionFrame:IsShown() then
		T.fadeIn(TukuiVersionFrame)
	else
		T.fadeOut(TukuiVersionFrame)
	end
end)

-- VERSION LOGO (Asphyxia Avatar)
	local avatar = CreateFrame("Frame", "Avatar", TukuiVersionFrame)
	avatar:CreatePanel(avatar, 58, 58, "BOTTOM", TukuiVersionFrame, "TOP", 0, 2)
	avatar:SetFrameLevel(2)
	avatar:SetFrameStrata("BACKGROUND")
	avatar:SetTemplate("Default")
	avatar:CreateShadow("Default")
	
local avatar_tex = avatar:CreateTexture(nil, "OVERLAY")
avatar_tex:SetTexture(C.media.asphyxia)
avatar_tex:SetPoint("TOPLEFT", avatar, "TOPLEFT", 2, -2)
avatar_tex:SetPoint("BOTTOMRIGHT", avatar, "BOTTOMRIGHT", -2, 2)

-- HELP BUTTON
local helpbutton = CreateFrame("Button", "TukuiHelpButton", TukuiMinimap, "SecureActionButtonTemplate")
helpbutton:CreatePanel("Default", 13, 17, "RIGHT", Tukuiwatch, "LEFT", -3, 0)
helpbutton:CreateShadow("Default")
helpbutton:CreateOverlay(helpbutton)
helpbutton:SetAttribute("type", "macro")
helpbutton:SetAttribute("macrotext", "/ahelp")
helpbutton:SetFrameStrata("MEDIUM")
helpbutton:SetFrameLevel(2)

helpbutton.Text = T.SetFontString(helpbutton, C.media.pixelfont, C["datatext"].fontsize, "MONOCHROMEOUTLINE")
helpbutton.Text:Point("CENTER", helpbutton, "CENTER", 1.5, 1)
helpbutton.Text:SetText(T.datacolor.."H")

-- ANIMATION FUNCTION [HELP FRAME]
TukuiAsphyxiaHelpFrame:Animate( 0, 500, 0.8 )
TukuiHelpButton:EnableMouse( true )
TukuiHelpButton:SetScript("OnClick", function(self)
if InCombatLockdown() then return end

if TukuiAsphyxiaHelpFrame:IsVisible() then
TukuiAsphyxiaHelpFrame:SlideOut()
else
TukuiAsphyxiaHelpFrame:SlideIn()
end
end )

-- INVISIBLE BUTTON (...Don't ask)
local invisButton = CreateFrame("Frame", "invisButton", UIParent)
invisButton:CreatePanel("Transparent", 100, 20, "BOTTOM", UIParent, "BOTTOM", 0, 2, true)
invisButton:SetFrameLevel(0)

-- RESETUI BUTTON
local resetuibutton = CreateFrame("Button", "TukuiResetUIButton", UIParent, "SecureActionButtonTemplate")
resetuibutton:CreatePanel("Default", 26, 20, "RIGHT", invisButton, "LEFT", -3, 0)
resetuibutton:SetFrameStrata("HIGH")
resetuibutton:CreateShadow("Default")
resetuibutton:CreateOverlay(resetuibutton)
resetuibutton:SetAttribute("type", "macro")
resetuibutton:SetAttribute("macrotext", "/resetui")
resetuibutton:HookScript("OnEnter", ModifiedBackdrop)
resetuibutton:HookScript("OnLeave", OriginalBackdrop)

resetuibutton.Text = T.SetFontString(resetuibutton, C.media.pixelfont, C["datatext"].fontsize, "MONOCHROMEOUTLINE")
resetuibutton.Text:Point("CENTER", resetuibutton, "CENTER", 1, 1)
resetuibutton.Text:SetText(T.datacolor.."RS")

-- RELOADUI BUTTON
local rluibutton = CreateFrame("Button", "TukuiReloadUIButton", UIParent, "SecureActionButtonTemplate")
rluibutton:CreatePanel("Default", 26, 20, "LEFT", invisButton, "RIGHT", 3, 0)
rluibutton:SetFrameStrata("HIGH")
rluibutton:CreateShadow("Default")
rluibutton:CreateOverlay(rluibutton)
rluibutton:SetAttribute("type", "macro")
rluibutton:SetAttribute("macrotext", "/rl")
rluibutton:HookScript("OnEnter", ModifiedBackdrop)
rluibutton:HookScript("OnLeave", OriginalBackdrop)

rluibutton.Text = T.SetFontString(rluibutton, C.media.pixelfont, C["datatext"].fontsize, "MONOCHROMEOUTLINE")
rluibutton.Text:Point("CENTER", rluibutton, "CENTER", 1, 1)
rluibutton.Text:SetText(T.datacolor.."RL")

-- WORLD STATE FRAME 
WorldStateAlwaysUpFrame:ClearAllPoints()
WorldStateAlwaysUpFrame:SetPoint("TOP", UIParent, "TOP", 0, T.Scale(-35))

-- UNITFRAME SHOW/HIDE
if C["unitframes"].hideunitframes == true then
local HideUnitframes = function(self, event)
	if event == "PLAYER_REGEN_DISABLED" then
		UIFrameFadeIn(TukuiPlayer, 0.5, 0, 1)
	else
		UIFrameFadeIn(TukuiPlayer, 0.5, 1, 0)
	end
end

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:RegisterEvent("PLAYER_REGEN_ENABLED")
f:RegisterEvent("PLAYER_REGEN_DISABLED")
f:SetScript("OnEvent", HideUnitframes)
end

-- DATATEXT PANEL TOGGLE (Button)
local cp = "|cff9a1212-|r" 
local cm = "|cff9a1212+|r" 
local icb = CreateFrame("Frame", "InfoCenterButton", TukuiChatBackgroundRight)
icb:CreatePanel(nil, 30, 15, "TOPRIGHT", TukuiChatBackgroundRight, "TOPRIGHT", -2, -68)
icb:SetAlpha(0)
icb:SetFrameStrata("MEDIUM")
icb:CreateOverlay(icb)
icb:EnableMouse(true)
icb.f = icb:CreateFontString(nil, overlay)
icb.f:SetPoint("CENTER")
icb.f:SetFont(C["media"].pixelfont, C["datatext"].fontsize, "MONOCHROMEOUTLINE")
icb.f:SetText(cp)
icb.f:Point("CENTER", 1, 0)
icb:SetScript("OnMouseDown", function(self)
	ToggleFrame(TukuiInfoCenterRight)
	ToggleFrame(TukuiInfoCenterLeft)
	ToggleFrame(TukuiInfoCenter)
	if icenter:IsShown() then
		self.f:SetText(cp)
	else
		self.f:SetText(cm)
	end
end)

icb:SetScript("OnEnter", function()
		if InCombatLockdown() then return end
		icb:FadeIn()
	end)

	icb:SetScript("OnLeave", function()
		icb:FadeOut()
	end)
	
-- MINIMAP BUTTONS SKINNING [Credit Elv22 for the base code and Smelly for modification.]
local function SkinButton(f)
    if f:GetObjectType() ~= "Button" then return end
	f:SetPushedTexture(nil)
    f:SetHighlightTexture(nil)
    f:SetDisabledTexture(nil)
	f:SetSize(22, 22)
	
    for i=1, f:GetNumRegions() do
        local region = select(i, f:GetRegions())
        if region:GetObjectType() == "Texture" then
            local tex = region:GetTexture()
            if tex:find("Border") or tex:find("Background") then
                region:SetTexture(nil)
            else
				region:SetDrawLayer("OVERLAY", 5)
                region:ClearAllPoints()
                region:Point("TOPLEFT", f, "TOPLEFT", 2, -2)
                region:Point("BOTTOMRIGHT", f, "BOTTOMRIGHT", -2, 2)
                region:SetTexCoord(.08, .92, .08, .92)
            end
        end
    end
	f:SetTemplate("Default")
	f:SetFrameLevel(f:GetFrameLevel() + 2)
	
end
local x = CreateFrame("Frame")
x:RegisterEvent("PLAYER_LOGIN")
x:SetScript("OnEvent", function(self, event)
    for i=1, Minimap:GetNumChildren() do
        SkinButton(select(i, Minimap:GetChildren()))
    end
    self = nil
end)

-- WORLD STATE UP (move frame)
MiniMapBattlefieldFrame:ClearAllPoints()
MiniMapBattlefieldFrame:Point("BOTTOMRIGHT", TukuiMinimap, "BOTTOMRIGHT", -4, 4)

-- MINIMAP TOGGLE
local mToggle = CreateFrame("Button", "TukuiMinimapToggle", UIParent)
mToggle:CreatePanel("Default", 11, 30, "TOPLEFT", TukuiPlayerBuffs, "TOPRIGHT", 5, 2)
mToggle:CreateShadow("Default")
mToggle:CreateOverlay(mToggle)
mToggle:HookScript("OnEnter", ModifiedBackdrop)
mToggle:HookScript("OnLeave", OriginalBackdrop)

mToggle.Text = T.SetFontString(mToggle, C.media.pixelfont, C["datatext"].fontsize, "MONOCHROMEOUTLINE")
mToggle.Text:Point("CENTER", mToggle, "CENTER", 2, 0.5)
mToggle.Text:SetText("|cffFF0000-|r")

mToggle:SetScript("OnMouseDown", function()
    if TukuiMinimap:IsVisible() then
		TukuiMinimap:Hide()
		TukuiPlayerBuffs:ClearAllPoints()
		TukuiPlayerBuffs:Point("TOPRIGHT", -20, -12)
		TukuiPlayerDebuffs:Point("TOPRIGHT", -20, -150)
		mToggle.Text:SetText("|cff00FF00+|r")
    else
		TukuiMinimap:Show()
		TukuiPlayerBuffs:ClearAllPoints()
		TukuiPlayerBuffs:Point("TOPRIGHT", -206, -12)
		TukuiPlayerDebuffs:Point("TOPRIGHT", -206, -150)
		mToggle.Text:SetText("|cffFF0000-|r")
    end
end)

------------------------------------------------------------------------
	-- Filger Stuff Below (Credits to Sapz)
------------------------------------------------------------------------

local PlayerBuffs = CreateFrame("Frame","FilgerPlayerBuffs",UIParent)
PlayerBuffs:CreatePanel("Default",150,36,"CENTER", UIParent, "CENTER", -273, -75)
PlayerBuffs:SetMovable(true)
PlayerBuffs:SetBackdropBorderColor(1,0,0)
PlayerBuffs.text = T.SetFontString(PlayerBuffs, C.media.pixelfont, C["datatext"].fontsize, "MONOCHROMEOUTLINE")
PlayerBuffs.text:SetPoint("CENTER")
PlayerBuffs.text:SetText("Move Player Buffs")
PlayerBuffs:Hide()

local PlayerDebuffs = CreateFrame("Frame","FilgerPlayerDebuffs",UIParent)
PlayerDebuffs:CreatePanel("Default",150,72,"CENTER", UIParent, "CENTER", -273, -155)
PlayerDebuffs:SetMovable(true)
PlayerDebuffs:SetBackdropBorderColor(1,0,0)
PlayerDebuffs.text = T.SetFontString(PlayerDebuffs, C.media.pixelfont, C["datatext"].fontsize, "MONOCHROMEOUTLINE")
PlayerDebuffs.text:SetPoint("CENTER")
PlayerDebuffs.text:SetText("Move Player Debuffs")
PlayerDebuffs:Hide()

local PlayerProccs = CreateFrame("Frame","FilgerPlayerProccs",UIParent)
PlayerProccs:CreatePanel("Default",150,32,"CENTER", UIParent, "CENTER", -273, -233)
PlayerProccs:SetMovable(true)
PlayerProccs:SetBackdropBorderColor(1,0,0)
PlayerProccs.text = T.SetFontString(PlayerProccs, C.media.pixelfont, C["datatext"].fontsize, "MONOCHROMEOUTLINE")
PlayerProccs.text:SetPoint("CENTER")
PlayerProccs.text:SetText("Move Player Proccs")
PlayerProccs:Hide()

local PlayerHealBuffs = CreateFrame("Frame","FilgerPlayerHealBuffs",UIParent)
PlayerHealBuffs:CreatePanel("Default",150,32,"CENTER", UIParent, "CENTER", -273, -26)
PlayerHealBuffs:SetMovable(true)
PlayerHealBuffs:SetBackdropBorderColor(1,0,0)
PlayerHealBuffs.text = T.SetFontString(PlayerHealBuffs, C.media.pixelfont, C["datatext"].fontsize, "MONOCHROMEOUTLINE")
PlayerHealBuffs.text:SetPoint("CENTER")
PlayerHealBuffs.text:SetText("Move Heal/CD Frame")
PlayerHealBuffs:Hide()

local TargetDebuffs = CreateFrame("Frame","FilgerTargetDebuffs",UIParent)
TargetDebuffs:CreatePanel("Default",150,36,"CENTER", UIParent, "CENTER", 273, -146)
TargetDebuffs:SetMovable(true)
TargetDebuffs:SetBackdropBorderColor(1,0,0)
TargetDebuffs.text = T.SetFontString(TargetDebuffs, C.media.pixelfont, C["datatext"].fontsize, "MONOCHROMEOUTLINE")
TargetDebuffs.text:SetPoint("CENTER")
TargetDebuffs.text:SetText("Move Target Debuffs")
TargetDebuffs:Hide()

local TargetHeals = CreateFrame("Frame","FilgerTargetHeals",UIParent)
TargetHeals:CreatePanel("Default",150,32,"CENTER", UIParent, "CENTER", 273, -146)
TargetHeals:SetMovable(true)
TargetHeals:SetBackdropBorderColor(1,0,0)
TargetHeals.text = T.SetFontString(TargetHeals, C.media.pixelfont, C["datatext"].fontsize, "MONOCHROMEOUTLINE")
TargetHeals.text:SetPoint("CENTER")
TargetHeals.text:SetText("Move Target Heals")
TargetHeals:Hide()

local PvPBuffs = CreateFrame("Frame","FilgerPvPBuffs",UIParent)
PvPBuffs:CreatePanel("Default",150,72,"CENTER", UIParent, "CENTER", 273, -85)
PvPBuffs:SetMovable(true)
PvPBuffs:SetBackdropBorderColor(1,0,0)
PvPBuffs.text = T.SetFontString(PvPBuffs, C.media.pixelfont, C["datatext"].fontsize, "MONOCHROMEOUTLINE")
PvPBuffs.text:SetPoint("CENTER")
PvPBuffs.text:SetText("Move PvP Buffs")
PvPBuffs:Hide()

local WLBuffs = CreateFrame("Frame","FilgerWLBuffs",UIParent)
WLBuffs:CreatePanel("Default",150,50,"CENTER", UIParent, "CENTER", 20, 145)
WLBuffs:SetMovable(true)
WLBuffs:SetBackdropBorderColor(1,0,0)
WLBuffs.text = T.SetFontString(WLBuffs, C.media.pixelfont, C["datatext"].fontsize, "MONOCHROMEOUTLINE")
WLBuffs.text:SetPoint("CENTER")
WLBuffs.text:SetText("Move WL Buffs")
WLBuffs:Hide()

local DebuffBars = CreateFrame("Frame","FilgerDebuffBars",UIParent)
DebuffBars:CreatePanel("Default",150,50,"CENTER", UIParent, "CENTER", 273, 145)
DebuffBars:SetMovable(true)
DebuffBars:SetBackdropBorderColor(1,0,0)
DebuffBars.text = T.SetFontString(DebuffBars, C.media.pixelfont, C["datatext"].fontsize, "MONOCHROMEOUTLINE")
DebuffBars.text:SetPoint("CENTER")
DebuffBars.text:SetText("Move Debuff Bars")
DebuffBars:Hide()

local CDBars = CreateFrame("Frame","FilgerCDBars",UIParent)
CDBars:CreatePanel("Default",150,50,"CENTER", UIParent, "CENTER", -273, 145)
CDBars:SetMovable(true)
CDBars:SetBackdropBorderColor(1,0,0)
CDBars.text = T.SetFontString(CDBars, C.media.pixelfont, C["datatext"].fontsize, "MONOCHROMEOUTLINE")
CDBars.text:SetPoint("CENTER")
CDBars.text:SetText("Move CD Bars")
CDBars:Hide()	