local T, C, L = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales

-- sCombo (Minimal Combo Bar Replacement)
-- Author: Smelly

if not C.sCombo.enable or not C.unitframes.enable then return end

TukuiTarget:DisableElement('CPoints') 
local Options = {
	comboWidth = T.Scale(40),
	comboHeight = T.Scale(11),
	spacing = T.Scale(3), 
	colors = {
		[1] = {0.60, 0, 0, 1},
		[2] = {0.60, 0.30, 0, 1},
		[3] = {0.60, 0.60, 0, 1},
		[4] = {0.30, 0.60, 0, 1},
		[5] = {0, 0.60, 0, 1},
	},
}

local Anchor = CreateFrame("Frame", "sComboAnchor", UIParent)
Anchor:CreatePanel("", ((Options.comboWidth + Options.spacing)*5)-Options.spacing, 12, "CENTER", UIParent, "CENTER", 0, -175)
Anchor:SetBackdropBorderColor(1,0,0)
Anchor:CreateShadow("")
Anchor:SetMovable(true)
Anchor:Hide()
Anchor.text = Anchor:CreateFontString(nil, "OVERLAY")
Anchor.text:SetFont(C.media.pixelfont, C["datatext"].fontsize, "MONOCHROMEOUTLINE")
Anchor.text:SetPoint("CENTER")
Anchor.text:SetText(T.panelcolor.."Move CP-Bar (sCombo)")

local sCombo = CreateFrame("Frame", "sCombo", UIParent)
for i = 1, 5 do
	sCombo[i] = CreateFrame("Frame", "sCombo"..i, UIParent)
	sCombo[i]:CreatePanel("Default", Options.comboWidth, Options.comboHeight, "CENTER", UIParent, "CENTER", 0, 0)
	sCombo[i]:CreateShadow("Default")
	if C.datatext.fontsize == 8 then
		sCombo[i].text = sCombo[i]:CreateFontString(nil, "OVERLAY")
		sCombo[i].text:SetFont(C.media.pixelfont, C["datatext"].fontsize, "MONOCHROMEOUTLINE")
		sCombo[i].text:SetPoint("CENTER")
		sCombo[i].text:SetText(i)
	end
		
	if i == 1 then
		sCombo[i]:Point("TOPLEFT", Anchor, "BOTTOMLEFT", 0, -3)
	else
		sCombo[i]:Point("LEFT", sCombo[i-1], "RIGHT", Options.spacing, 0)
	end
	
	sCombo[i]:SetBackdropBorderColor(unpack(Options.colors[i]))
	sCombo[i]:RegisterEvent("PLAYER_ENTERING_WORLD")
	sCombo[i]:RegisterEvent("UNIT_COMBO_POINTS")
	sCombo[i]:RegisterEvent("PLAYER_TARGET_CHANGED")
	sCombo[i]:SetScript("OnEvent", function(self, event)
	local points, pt = 0, GetComboPoints("player", "target")
		if pt == points then
			sCombo[i]:Hide()
		elseif pt > points then
			for i = points + 1, pt do
				sCombo[i]:Show()
			end
		else
			for i = pt + 1, points do
				sCombo[i]:Hide()
			end
		end
		points = pt	
	end)
end

-- slash command
local move = false
SLASH_MOVESCOMBO1 = "/scp"
SlashCmdList.MOVESCOMBO = function()
if InCombatLockdown() then print(ERR_NOT_IN_COMBAT) return end
	if not move then
		move = true
		Anchor:EnableMouse(true)
		Anchor:Show()
		Anchor:SetScript("OnMouseDown", function(self) self:StartMoving() end)
		Anchor:SetScript("OnMouseUp", function(self) self:StopMovingOrSizing() end)
		for i = 1,5 do 
			sCombo[i]:Show() 
			sCombo[i]:UnregisterAllEvents()
		end
	else
		move = false
		Anchor:EnableMouse(false)
		Anchor:Hide()
		for i = 1,5 do 
			sCombo[i]:Hide() 
			sCombo[i]:RegisterEvent("PLAYER_ENTERING_WORLD")
			sCombo[i]:RegisterEvent("UNIT_COMBO_POINTS")
			sCombo[i]:RegisterEvent("PLAYER_TARGET_CHANGED")
		end
	end
end

-- energy bar
if not C.sCombo.energybar or not C.unitframes.enable then return end
local sPowerBG = CreateFrame("Frame", "sPowerBG", TukuiTarget)
sPowerBG:CreatePanel(nil, (Options.comboWidth * 5) + (Options.spacing * 5) - Options.spacing, Options.comboHeight, "TOPLEFT", Anchor, "BOTTOMLEFT", 0, -(Options.comboHeight+6))
sPowerBG:CreateShadow()
local sPowerStatus = CreateFrame("StatusBar", "sPowerStatus", TukuiTarget)
sPowerStatus:SetStatusBarTexture(C.media.normTex)
sPowerStatus:SetFrameLevel(6)
sPowerStatus:Point("TOPLEFT", sPowerBG, "TOPLEFT", 2, -2)
sPowerStatus:Point("BOTTOMRIGHT", sPowerBG, "BOTTOMRIGHT", -2, 2)
sPowerStatus.t = sPowerStatus:CreateFontString(nil, "OVERLAY")
sPowerStatus.t:SetPoint("CENTER")
sPowerStatus.t:SetFont(C.media.pixelfont, C["datatext"].fontsize, "MONOCHROMEOUTLINE")
sPowerStatus.t:SetShadowOffset(0.5, -0.5)
sPowerStatus.t:SetShadowColor(0,0,0)
local color = RAID_CLASS_COLORS[T.myclass]
sPowerStatus:SetStatusBarColor(color.r, color.g, color.b)
local t = 0
sPowerStatus:SetScript("OnUpdate", function(self, elapsed)
    t = t + elapsed;
    if (t > 0.07) then
        sPowerStatus:SetMinMaxValues(0, UnitPowerMax("player"))
        local power = UnitPower("player")
        sPowerStatus:SetValue(power)
		sPowerStatus.t:SetText(power)
    end
end)
sPowerBG:RegisterEvent("PLAYER_ENTERING_WORLD")
sPowerBG:RegisterEvent("UNIT_DISPLAYPOWER")
sPowerBG:SetScript("OnEvent", function(self, event)
local p, _ = UnitPowerType("player")
    if p == SPELL_POWER_ENERGY then
        sPowerBG:Show()
        sPowerStatus:Show()
    else
        sPowerBG:Hide()
        sPowerStatus:Hide()
    end
end)