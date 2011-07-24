local T, C, L = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales
--------------------------------------------------------------------
-- Player Hit
--------------------------------------------------------------------

-- Hit Rating
if not C["datatext"].hit == nil or C["datatext"].hit > 0 then
	local Stat = CreateFrame("Frame")

	local Text  = TukuiInfoLeft:CreateFontString(nil, "OVERLAY")
	Text:SetFont(C.media.pixelfont, C["datatext"].fontsize, "MONOCHROMEOUTLINE")
	T.PP(C["datatext"].hit, Text)

	local int = 1

	local function Update(self, t)
		int = int - t
		local base, posBuff, negBuff = UnitAttackPower("player")
		local effective = base + posBuff + negBuff
		local Rbase, RposBuff, RnegBuff = UnitRangedAttackPower("player")
		local Reffective = Rbase + RposBuff + RnegBuff

		Rattackpwr = Reffective
		spellpwr = GetSpellBonusDamage(7)
		attackpwr = effective

		if int < 0 then
			if attackpwr > spellpwr and select(2, UnitClass("Player")) ~= "HUNTER" then
				Text:SetText("Hit Rating: "..T.panelcolor..format("%.2f", GetCombatRatingBonus(6)).."%")
			elseif select(2, UnitClass("Player")) == "HUNTER" then
				Text:SetText("Hit Rating: "..T.panelcolor..format("%.2f", GetCombatRatingBonus(7)).."%")
			else
				Text:SetText("Hit Rating: "..T.panelcolor..format("%.2f", GetCombatRatingBonus(8)).."%")
			end
			int = 1
		end
	end

	Stat:SetScript("OnUpdate", Update)
	Update(Stat, 10)
end