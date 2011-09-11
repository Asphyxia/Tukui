local T, C, L = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales

------------------------------------------------------------------------
	-- Balance Power Panel              [EPICGRIM]
------------------------------------------------------------------------
if IsAddOnLoaded("BalancePowerTracker") then
if (T.myclass == "DRUID") then
	local eclipseBar = CreateFrame("Frame", "EclipseBar", UIParent)
	eclipseBar:CreatePanel(nil, 1, 1, "CENTER", BalancePowerTrackerBackgroundFrame, "CENTER", 0, 0)
	eclipseBar:ClearAllPoints()
	eclipseBar:Point("TOPLEFT", BalancePowerTrackerBackgroundFrame, "TOPLEFT", 0, 0)
	eclipseBar:Point("BOTTOMRIGHT", BalancePowerTrackerBackgroundFrame, "BOTTOMRIGHT", 0, 0)
	eclipseBar:CreateShadow("Default")
	
	local eclipseBarfunc = CreateFrame("Frame")
	eclipseBarfunc:RegisterEvent("PLAYER_ENTERING_WORLD")
	eclipseBarfunc:RegisterEvent("UNIT_AURA")
	eclipseBarfunc:RegisterEvent("UPDATE_SHAPESHIFT_FORM")
	eclipseBarfunc:RegisterEvent("PLAYER_TALENT_UPDATE")
	eclipseBarfunc:RegisterEvent("UNIT_TARGET")
	eclipseBarfunc:SetScript("OnEvent", function(self)
    local activeTalent = GetPrimaryTalentTree()
    local shift = GetShapeshiftForm()
	local grace = select(7, UnitAura("player", "Nature's Grace", nil, "HELPFUL"))
    	if grace then
			eclipseBar:SetBackdropBorderColor(205, 25, 0, 1)
		else
			eclipseBar:SetBackdropBorderColor(unpack(C["media"].bordercolor))
		end

		if activeTalent == 1 then
		    if shift == 1 or shift == 2 or shift == 3 or shift == 4 or shift == 6 then
		        eclipseBar:Hide()
			else
			    eclipseBar:Show()
			end
		else
		    eclipseBar:Hide()
		end
	end)
end
end