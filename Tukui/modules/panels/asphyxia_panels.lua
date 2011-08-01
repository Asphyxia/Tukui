local T, C, L = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales

local DataVisibility = 1

---------------------------------------------------------
---[[ ADDITIONAL Asphyxia PANELS ]]---
---------------------------------------------------------

--TOP DUMMY FRAME DOES NOTHING 
if C["asphyxia_panels"].toppanel == true then 
local toppanel = CreateFrame("Frame", "TukuiTopPanel", UIParent)
toppanel:CreatePanel("Default", 2000, 20, "TOP", UIParent, "TOP", 0, 0)
toppanel:SetFrameStrata("BACKGROUND")
toppanel:SetFrameLevel(0)
toppanel:CreateShadow("Default")
end

--BOTTOM DUMMY FRAME DOES NOTHING 
if C["asphyxia_panels"].bottompanel == true then 
local bottompanel = CreateFrame("Frame", "TukuiBottomPanel", UIParent)
bottompanel:CreatePanel("Default", 2000, 20, "BOTTOM", UIParent, "BOTTOM", 0, 0)
bottompanel:SetFrameStrata("BACKGROUND")
bottompanel:SetFrameLevel(0)
bottompanel:CreateShadow("Default")
end

-- INFO CENTER (FOR STATS)
local icenter = CreateFrame("Frame", "TukuiInfoCenter", TukuiBar1)
icenter:CreatePanel("Default", TukuiBar1:GetWidth(), 20, "TOP", TukuiBar1, "BOTTOM", 0, -3)
icenter:CreateShadow("Default")
icenter:SetFrameLevel(2)
icenter:SetFrameStrata("BACKGROUND")

--[[-- INFO CENTER LEFT (FOR STATS)
local icenterleft = CreateFrame("Frame", "TukuiInfoCenterLeft", TukuiBar2)
icenterleft:CreatePanel("Default", TukuiBar2:GetWidth(), 20, "TOP", TukuiBar2, "BOTTOM", 0, -3)
icenterleft:CreateShadow("Default")
icenterleft:SetFrameLevel(2)
icenterleft:SetFrameStrata("BACKGROUND")--]]

-- SPECSWITCHER
if C.datatext.enable_specswitcher then
	local icenterbottom = CreateFrame("Frame", "TukuiSpecSwitcher", TukuiBar2)
	icenterbottom:CreatePanel("Default", TukuiBar2:GetWidth() - 22, 20, "TOP", TukuiBar2, "BOTTOM", 11, -3)
	icenterbottom:CreateShadow("Default")
	icenterbottom:SetFrameLevel(0)
	icenterbottom:SetFrameStrata("BACKGROUND")

	local talenticon = CreateFrame("Frame", "TukuiTalentIcon", TukuiSpecSwitcher)
	talenticon:CreatePanel("Default", 20, 20, "RIGHT", icenterbottom, "LEFT", -2, 0)
	talenticon:CreateShadow("Default")
	talenticon:SetFrameLevel(0)
	talenticon:SetFrameStrata("BACKGROUND")

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

-- INFO CENTER RIGHT (FOR STATS)
local icenterright = CreateFrame("Frame", "TukuiInfoCenterRight", TukuiBar3)
icenterright:CreatePanel("Default", TukuiBar3:GetWidth() - 22, 20, "TOP", TukuiBar3, "BOTTOM", -11, -3)
icenterright:CreateShadow("Default")
icenterright:SetFrameLevel(2)
icenterright:SetFrameStrata("BACKGROUND")

-- TIME PANEL
local watch = CreateFrame("Frame", "Tukuiwatch", UIParent)
watch:CreatePanel("Default", 53, 17, "TOP", Minimap, "BOTTOM", T.Scale(0), 8)
watch:CreateShadow("Default")
watch:SetFrameStrata("MEDIUM")
watch:SetFrameLevel(2)

-- SWITCH LAYOUT
local swl = CreateFrame("Button", "TukuiSwitchLayoutButton", icenterright)
	swl:Size(75, TukuiInfoCenterRight:GetHeight())
	swl:Point("CENTER", icenterright, "CENTER", 0, 0)
	swl:SetFrameStrata("BACKGROUND")
	swl:SetFrameLevel(2)
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
	swl.Text:Point("CENTER", swl, "CENTER", 0, 0)
	swl.Text:SetText(T.StatColor..L.datatext_switch_layout)

-- VERSION BUTTON
local verbutton = CreateFrame("Button", "TukuiVersionButton", TukuiMinimap, "SecureActionButtonTemplate")
verbutton:CreatePanel("Default", 13, 17, "LEFT", Tukuiwatch, "RIGHT", 3, 0)
verbutton:CreateShadow("Default")
verbutton:SetAttribute("type", "macro")
verbutton:SetAttribute("macrotext", "/version")
verbutton:SetFrameStrata("MEDIUM")
verbutton:SetFrameLevel(2)

verbutton.Text = T.SetFontString(verbutton, C.media.pixelfont, C["datatext"].fontsize, "MONOCHROMEOUTLINE")
verbutton.Text:Point("CENTER", verbutton, "CENTER", 2, 1)
verbutton.Text:SetText(T.panelcolor.."V")

--[[verbutton:SetScript("OnEnter", function()
		if InCombatLockdown() then return end
		verbutton:FadeIn()
	end)

	verbutton:SetScript("OnLeave", function()
		verbutton:FadeOut()
	end)--]]

-- VERSION LOGO (Asphyxia Avatar)
	local avatar = CreateFrame("Frame", nil, TukuiVersionFrame)
	avatar:CreatePanel(avatar, 58, 58, "BOTTOM", TukuiVersionFrame, "TOP", 0, 2)
	avatar:SetFrameLevel(2)
	avatar:SetFrameStrata("BACKGROUND")
	avatar:SetTemplate("Default")
	avatar:CreateShadow("")
	
	local avatar_tex = avatar:CreateTexture(nil, "OVERLAY")
avatar_tex:SetTexture(C.media.asphyxia)
avatar_tex:SetPoint("TOPLEFT", avatar, "TOPLEFT", 2, -2)
avatar_tex:SetPoint("BOTTOMRIGHT", avatar, "BOTTOMRIGHT", -2, 2)

-- HELP BUTTON
local helpbutton = CreateFrame("Button", "TukuiHelpButton", TukuiMinimap, "SecureActionButtonTemplate")
helpbutton:CreatePanel("Default", 13, 17, "RIGHT", Tukuiwatch, "LEFT", -3, 0)
helpbutton:CreateShadow("Default")
helpbutton:SetAttribute("type", "macro")
helpbutton:SetAttribute("macrotext", "/ahelp")
helpbutton:SetFrameStrata("MEDIUM")
helpbutton:SetFrameLevel(2)

helpbutton.Text = T.SetFontString(helpbutton, C.media.pixelfont, C["datatext"].fontsize, "MONOCHROMEOUTLINE")
helpbutton.Text:Point("CENTER", helpbutton, "CENTER", 1.5, 1)
helpbutton.Text:SetText(T.panelcolor.."H")

-- Animate function
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

local function ModifiedBackdrop(self)
	local color = RAID_CLASS_COLORS[T.myclass]
	self:SetBackdropColor(unpack(C["media"].backdropcolor))
	self:SetBackdropBorderColor(color.r, color.g, color.b)
end

local function OriginalBackdrop(self)
	self:SetBackdropColor(unpack(C["media"].backdropcolor))
	self:SetBackdropBorderColor(unpack(C["media"].bordercolor))
end

-- ADDONS BUTTON
local adbutton = CreateFrame("Button", "TukuiAddonsButton", UIParent, "SecureActionButtonTemplate")
adbutton:CreatePanel("Default", 100, 17, "BOTTOM", UIParent, "BOTTOM", 0, 12)
adbutton:SetFrameStrata("HIGH")
adbutton:SetAlpha(0)
adbutton:CreateShadow("Default")
adbutton:SetAttribute("type", "macro")
adbutton:SetAttribute("macrotext", "/am")
adbutton:HookScript("OnEnter", ModifiedBackdrop)
adbutton:HookScript("OnLeave", OriginalBackdrop)

adbutton.Text = T.SetFontString(adbutton, C.media.pixelfont, C["datatext"].fontsize, "MONOCHROMEOUTLINE")
adbutton.Text:Point("CENTER", adbutton, "CENTER", 1, 1)
adbutton.Text:SetText(T.panelcolor..ADDONS)
adbutton.Text:SetShadowColor( 0, 0, 0 )
adbutton.Text:SetShadowOffset(1.25, -1.25)

adbutton:SetScript("OnEnter", function()
		if InCombatLockdown() then return end
		adbutton:FadeIn()
	end)

	adbutton:SetScript("OnLeave", function()
		adbutton:FadeOut()
	end)

--[[adbutton.Status = CreateFrame( "StatusBar", "HydraDataStatus", adbutton)
adbutton.Status:SetFrameLevel(2)
adbutton.Status:SetStatusBarTexture( C["media"].normTex)
adbutton.Status:SetMinMaxValues( 0, 100 )
adbutton.Status:SetStatusBarColor( 41/255,  79/255, 155/255)
adbutton.Status:Point( "TOPLEFT", adbutton, "TOPLEFT", 2, -2)
adbutton.Status:Point( "BOTTOMRIGHT", adbutton, "BOTTOMRIGHT", -2, 2)--]]

-- RESETUI BUTTON
local resetuibutton = CreateFrame("Button", "TukuiResetUIButton", UIParent, "SecureActionButtonTemplate")
resetuibutton:CreatePanel("Default", 60, 17, "LEFT", TukuiAddonsButton, "RIGHT", 5, 0)
resetuibutton:SetFrameStrata("HIGH")
resetuibutton:SetAlpha(0)
resetuibutton:CreateShadow("Default")
resetuibutton:SetAttribute("type", "macro")
resetuibutton:SetAttribute("macrotext", "/resetui")
resetuibutton:HookScript("OnEnter", ModifiedBackdrop)
resetuibutton:HookScript("OnLeave", OriginalBackdrop)

resetuibutton:SetScript("OnEnter", function()
		if InCombatLockdown() then return end
		resetuibutton:FadeIn()
	end)

	resetuibutton:SetScript("OnLeave", function()
		resetuibutton:FadeOut()
	end)

resetuibutton.Text = T.SetFontString(resetuibutton, C.media.pixelfont, C["datatext"].fontsize, "MONOCHROMEOUTLINE")
resetuibutton.Text:Point("CENTER", resetuibutton, "CENTER", 1, 1)
resetuibutton.Text:SetText(T.panelcolor.."Reset UI")

-- RELOADUI BUTTON
local rluibutton = CreateFrame("Button", "TukuiReloadUIButton", UIParent, "SecureActionButtonTemplate")
rluibutton:CreatePanel("Default", 60, 17, "LEFT", resetuibutton, "RIGHT", 5, 0)
rluibutton:SetFrameStrata("HIGH")
rluibutton:SetAlpha(0)
rluibutton:CreateShadow("Default")
rluibutton:SetAttribute("type", "macro")
rluibutton:SetAttribute("macrotext", "/rl")
rluibutton:HookScript("OnEnter", ModifiedBackdrop)
rluibutton:HookScript("OnLeave", OriginalBackdrop)

rluibutton:SetScript("OnEnter", function()
		if InCombatLockdown() then return end
		rluibutton:FadeIn()
	end)

	rluibutton:SetScript("OnLeave", function()
		rluibutton:FadeOut()
	end)

rluibutton.Text = T.SetFontString(rluibutton, C.media.pixelfont, C["datatext"].fontsize, "MONOCHROMEOUTLINE")
rluibutton.Text:Point("CENTER", rluibutton, "CENTER", 1, 1)
rluibutton.Text:SetText(T.panelcolor.."Reload UI")

-- CONFIG BUTTON
local configbutton = CreateFrame("Button", "TukuiConfigButton", UIParent, "SecureActionButtonTemplate")
configbutton:CreatePanel("Default", 60, 17, "RIGHT", TukuiAddonsButton, "LEFT", -5, 0)
configbutton:SetFrameStrata("HIGH")
configbutton:SetAlpha(0)
configbutton:CreateShadow("Default")
configbutton:SetAttribute("type", "macro")
configbutton:SetAttribute("macrotext", "/tc")
configbutton:HookScript("OnEnter", ModifiedBackdrop)
configbutton:HookScript("OnLeave", OriginalBackdrop)

configbutton:SetScript("OnEnter", function()
		if InCombatLockdown() then return end
		configbutton:FadeIn()
	end)

	configbutton:SetScript("OnLeave", function()
		configbutton:FadeOut()
	end)

configbutton.Text = T.SetFontString(configbutton, C.media.pixelfont, C["datatext"].fontsize, "MONOCHROMEOUTLINE")
configbutton.Text:Point("CENTER", configbutton, "CENTER", 1, 1)
configbutton.Text:SetText(T.panelcolor.."Config UI")

-- MOVEUI BUTTON
local moveuibutton = CreateFrame("Button", "TukuiMoveUIButton", UIParent, "SecureActionButtonTemplate")
moveuibutton:CreatePanel("Default", 60, 17, "RIGHT", configbutton, "LEFT", -5, 0)
moveuibutton:SetFrameStrata("HIGH")
moveuibutton:SetAlpha(0)
moveuibutton:CreateShadow("Default")
moveuibutton:SetAttribute("type", "macro")
moveuibutton:SetAttribute("macrotext", "/mtukui")
moveuibutton:HookScript("OnEnter", ModifiedBackdrop)
moveuibutton:HookScript("OnLeave", OriginalBackdrop)

moveuibutton:SetScript("OnEnter", function()
		if InCombatLockdown() then return end
		moveuibutton:FadeIn()
	end)

	moveuibutton:SetScript("OnLeave", function()
		moveuibutton:FadeOut()
	end)

moveuibutton.Text = T.SetFontString(moveuibutton, C.media.pixelfont, C["datatext"].fontsize, "MONOCHROMEOUTLINE")
moveuibutton.Text:Point("CENTER", moveuibutton, "CENTER", 1, 1)
moveuibutton.Text:SetText(T.panelcolor.."Move UI")

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
icb:CreatePanel(nil, 30, 15, "RIGHT", TukuiTabsRightBackground, "RIGHT", -118, 0)
icb:SetAlpha(0)
icb:SetFrameStrata("MEDIUM")
icb:EnableMouse(true)
icb.f = icb:CreateFontString(nil, overlay)
icb.f:SetPoint("CENTER")
icb.f:SetFont(C["media"].pixelfont, 12, "MONOCHROMEOUTLINE")
icb.f:SetText(cp)
icb.f:Point("CENTER", 1, 0)
icb:SetScript("OnMouseDown", function(self)
	ToggleFrame(TukuiInfoCenterRight)
	ToggleFrame(TukuiSpecSwitcher)
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

-- move button
MiniMapBattlefieldFrame:ClearAllPoints()
MiniMapBattlefieldFrame:Point("BOTTOMRIGHT", TukuiMinimap, "BOTTOMRIGHT", -4, 4)