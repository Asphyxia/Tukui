local T, C, L = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales
if not C["actionbar"].enable == true then return end

---------------------------------------------------------------------------
-- Setup Shapeshift Bar
---------------------------------------------------------------------------

-- used for anchor totembar or shapeshiftbar
local TukuiShift = CreateFrame("Frame","TukuiShiftBar",UIParent)
TukuiShift:SetPoint("BOTTOM", TukuiBar2, "TOP", 0, 12)
TukuiShift:SetWidth((T.petbuttonsize * 5) + (T.petbuttonsize * 4))
TukuiShift:SetHeight(T.petbuttonsize/2)
TukuiShift:SetFrameStrata("MEDIUM")
TukuiShift:SetMovable(true)
TukuiShift:SetClampedToScreen(true)
--TukuiShift:SetTemplate("Default")
TukuiShift:SetAlpha(1)

-- shapeshift command to move totem or shapeshift in-game
local ssmover = CreateFrame("Frame", "TukuiShapeShiftHolder", UIParent)
ssmover:SetAllPoints(TukuiShift)
ssmover:SetTemplate("Default")
ssmover:SetFrameStrata("HIGH")
ssmover:SetBackdropBorderColor(1,0,0)
ssmover:SetAlpha(0)
ssmover.text = T.SetFontString(ssmover, C.media.pixelfont, C["datatext"].fontsize, "MONOCHROMEOUTLINE")
ssmover.text:SetPoint("CENTER")
ssmover.text:SetText(L.move_shapeshift)

-- hide it if not needed and stop executing code
if C.actionbar.hideshapeshift then TukuiShift:Hide() return end

-- create the shapeshift bar if we enabled it
local bar = CreateFrame("Frame", "TukuiShapeShift", TukuiShift, "SecureHandlerStateTemplate")
bar:ClearAllPoints()
bar:SetAllPoints(TukuiShift)

local States = {
	["DRUID"] = "show",
	["WARRIOR"] = "show",
	["PALADIN"] = "show",
	["DEATHKNIGHT"] = "show",
	["ROGUE"] = "show,",
	["PRIEST"] = "show,",
	["HUNTER"] = "show,",
	["WARLOCK"] = "show,",
}

bar:RegisterEvent("PLAYER_LOGIN")
bar:RegisterEvent("PLAYER_ENTERING_WORLD")
bar:RegisterEvent("UPDATE_SHAPESHIFT_FORMS")
bar:RegisterEvent("UPDATE_SHAPESHIFT_USABLE")
bar:RegisterEvent("UPDATE_SHAPESHIFT_COOLDOWN")
bar:RegisterEvent("UPDATE_SHAPESHIFT_FORM")
bar:RegisterEvent("ACTIONBAR_PAGE_CHANGED")
bar:SetScript("OnEvent", function(self, event, ...)
	if event == "PLAYER_LOGIN" then
		local button
		for i = 1, NUM_SHAPESHIFT_SLOTS do
			button = _G["ShapeshiftButton"..i]
			button:ClearAllPoints()
			button:SetParent(self)
			button:SetFrameStrata("LOW")
			if i == 1 then
				button:Point("LEFT", TukuiShift, 0, 0)
			else
				local previous = _G["ShapeshiftButton"..i-1]
				if C.actionbar.verticalshapeshift then
					button:Point("TOP", previous, "BOTTOM", 0, -T.buttonspacing)
				else
					button:Point("LEFT", previous, "RIGHT", T.buttonspacing, 0)
				end
			end
			local _, name = GetShapeshiftFormInfo(i)
			if name then
				button:Show()
			end
		end
		RegisterStateDriver(self, "visibility", States[T.myclass] or "hide")
	elseif event == "UPDATE_SHAPESHIFT_FORMS" then
		-- Update Shapeshift Bar Button Visibility
		-- I seriously don't know if it's the best way to do it on spec changes or when we learn a new stance.
		if InCombatLockdown() then return end -- > just to be safe ;p
		local button
		for i = 1, NUM_SHAPESHIFT_SLOTS do
			button = _G["ShapeshiftButton"..i]
			local _, name = GetShapeshiftFormInfo(i)
			if name then
				button:Show()
			else
				button:Hide()
			end
		end
		T.TukuiShiftBarUpdate()
	elseif event == "PLAYER_ENTERING_WORLD" then
		T.StyleShift()
	else
		T.TukuiShiftBarUpdate()
	end
end)