local T, C, L = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales
--------------------------------------------------------------------
-- player haste
--------------------------------------------------------------------

if C["datatext"].haste and C["datatext"].haste > 0 then
	local Stat = CreateFrame("Frame")
	Stat:SetFrameStrata("HIGH")
	Stat:SetFrameLevel(3)

	local Text  = TukuiInfoLeft:CreateFontString(nil, "OVERLAY")
	Text:SetFont(C.media.pixelfont, C["datatext"].fontsize, "MONOCHROMEOUTLINE")
	T.PP(C["datatext"].haste, Text)

	local int = 1

	local function Update(self, t)
		spellhaste = GetCombatRating(20)
		rangedhaste = GetCombatRating(19)
		attackhaste = GetCombatRating(18)
		
		if attackhaste > spellhaste and select(2, UnitClass("Player")) ~= "HUNTER" then
			haste = attackhaste
		elseif select(2, UnitClass("Player")) == "HUNTER" then
			haste = rangedhaste
		else
			haste = spellhaste
		end
		
		int = int - t
		if int < 0 then
			Text:SetText(SPELL_HASTE_ABBR..": "..T.panelcolor..haste)
			int = 1
		end     
	end

	Stat:SetScript("OnUpdate", Update)
	Update(Stat, 10)
end