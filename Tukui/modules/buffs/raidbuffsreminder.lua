local T, C, L = unpack(select(2, ...)) -- Import Functions/Constants, Config, Locales
if C["buffreminder"].raidbuffreminder ~= true then return end

--------------------------------------------------------------------------------------------
-- Raid Buff Reminder (Bar in the topright corner below minimap)
--------------------------------------------------------------------------------------------

BuffReminderRaidBuffs = {
	Flask = {
		79470, --"Flask of the Draconic Mind"
		94160, --"Flask of Flowing Water"
		79469, --"Flask of Steelskin"
		79471, --"Flask of the Winds
		79472, --"Flask of Titanic Strength"
		79638, --"Flask of Enhancement-STR"
		79639, --"Flask of Enhancement-AGI"
		79640, --"Flask of Enhancement-INT"
		92679, --Flask of battle
	},
	BattleElixir = {
		--Scrolls
		89343, --Agility
		63308, --Armor 
		89347, --Int
		89342, --Spirit
		63306, --Stam
		89346, --Strength

		--Elixirs
		79481, --Hit
		79632, --Haste
		79477, --Crit
		79635, --Mastery
		79474, --Expertise
		79468, --Spirit
	},
	GuardianElixir = {
		79480, --Armor
		79631, --Resistance+90
	},
	Food = {
		87545, --90 STR
		87546, --90 AGI
		87547, --90 INT
		87548, --90 SPI
		87549, --90 MAST
		87550, --90 HIT
		87551, --90 CRIT
		87552, --90 HASTE
		87554, --90 DODGE
		87555, --90 PARRY
		87635, --90 EXP
		87556, --60 STR
		87557, --60 AGI
		87558, --60 INT
		87559, --60 SPI
		87560, --60 MAST
		87561, --60 HIT
		87562, --60 CRIT
		87563, --60 HASTE
		87564, --60 DODGE
		87634, --60 EXP
		87554, --Seafood Feast
	},
}

--Locals
local flaskbuffs = BuffReminderRaidBuffs["Flask"]
local battleelixirbuffs = BuffReminderRaidBuffs["BattleElixir"]
local guardianelixirbuffs = BuffReminderRaidBuffs["GuardianElixir"]
local foodbuffs = BuffReminderRaidBuffs["Food"]	
local battleelixired	
local guardianelixired	

--Setup Caster Buffs (atm for Warlock)
local function SetCasterOnlyBuffs()
	if T.myclass == "WARLOCK" then
		Spell3Buff = {
			1126, -- "Mark of the wild"
			90363, --"Embrace of the Shale Spider"
			20217, --"Greater Blessing of Kings",
		}
		Spell4Buff = {
			24907, --Druid's aura 5% haste
			3738, --Totem 5% haste
			49868, --Shadowpriest's aura 5% haste
		}
		Spell5Buff = {
			28176, --Fel Armor
		}
		Spell6Buff = {
			85768, -- Warlock buff 3% haste (self)
		}
	else
		Spell3Buff = {
			1126, -- "Mark of the wild"
			90363, --"Embrace of the Shale Spider"
			20217, --"Greater Blessing of Kings",
		}
		Spell4Buff = {
			61316, --"Dalaran Brilliance"
			1459, --"Arcane Brilliance"
		}
		Spell5Buff = {
			19740, --"Blessing of Might"
			5675, --"Mana Spring Totem"
		}
		Spell6Buff = {
			53646, --10% spd aura
			77747, -- 10% spd totem
		}
	end
end

--Setup everyone else's buffs
local function SetBuffs()
	Spell3Buff = {
		1126, -- "Mark of the wild"
		90363, --"Embrace of the Shale Spider"
		20217, --"Greater Blessing of Kings",
	}
	Spell4Buff = {
		19740, --"Blessing of Might"
		30808, --"Unleashed Rage"
		53138, --Abom Might
		19506, --Trushot
	}
	Spell5Buff = {
		469, -- Commanding
		6307, -- Blood Pact
		90364, -- Qiraji Fortitude
		72590, -- Drums of fortitude
		21562, -- Fortitude
	}
	Spell6Buff = {
		57330, --DK str/agi
		8075, --Totem str/agi
	}
end

-- we need to check if you have two differant elixirs if your not flasked, before we say your not flasked
local function CheckElixir(unit)
	if (battleelixirbuffs and battleelixirbuffs[1]) then
		for i, battleelixirbuffs in pairs(battleelixirbuffs) do
			local spellname = select(1, GetSpellInfo(battleelixirbuffs))
			if UnitAura("player", spellname) then
				FlaskFrame.t:SetTexture(select(3, GetSpellInfo(battleelixirbuffs)))
				battleelixired = true
				break
			else
				battleelixired = false
			end
		end
	end
	
	if (guardianelixirbuffs and guardianelixirbuffs[1]) then
		for i, guardianelixirbuffs in pairs(guardianelixirbuffs) do
			local spellname = select(1, GetSpellInfo(guardianelixirbuffs))
			if UnitAura("player", spellname) then
				guardianelixired = true
				if not battleelixired then
					FlaskFrame.t:SetTexture(select(3, GetSpellInfo(guardianelixirbuffs)))
				end
				break
			else
				guardianelixired = false
			end
		end
	end	
	
	if guardianelixired == true and battleelixired == true then
		FlaskFrame:SetAlpha(0.2)
		return
	else
		FlaskFrame:SetAlpha(1)
	end
end

--Main Script
local function OnAuraChange(self, event, arg1, unit)
	if (event == "UNIT_AURA" and arg1 ~= "player") then 
		return
	end
	
	--If We're a caster we may want to see differant buffs
	if T.Role == "Caster" then 
		SetCasterOnlyBuffs() 
	else
		SetBuffs()
	end
	
	--Start checking buffs to see if we can find a match from the list
	if (flaskbuffs and flaskbuffs[1]) then
		FlaskFrame.t:SetTexture(select(3, GetSpellInfo(flaskbuffs[1])))
		for i, flaskbuffs in pairs(flaskbuffs) do
			local spellname = select(1, GetSpellInfo(flaskbuffs))
			if UnitAura("player", spellname) then
				FlaskFrame.t:SetTexture(select(3, GetSpellInfo(flaskbuffs)))
				FlaskFrame:SetAlpha(0.2)
				break
			else
				CheckElixir()
			end
		end
	end
	
	if (foodbuffs and foodbuffs[1]) then
		FoodFrame.t:SetTexture(select(3, GetSpellInfo(foodbuffs[1])))
		for i, foodbuffs in pairs(foodbuffs) do
			local spellname = select(1, GetSpellInfo(foodbuffs))
			if UnitAura("player", spellname) then
				FoodFrame:SetAlpha(0.2)
				FoodFrame.t:SetTexture(select(3, GetSpellInfo(foodbuffs)))
				break
			else
				FoodFrame:SetAlpha(1)
			end
		end
	end
	
	for i, Spell3Buff in pairs(Spell3Buff) do
		local spellname = select(1, GetSpellInfo(Spell3Buff))
		if UnitAura("player", spellname) then
			Spell3Frame:SetAlpha(0.2)
			Spell3Frame.t:SetTexture(select(3, GetSpellInfo(Spell3Buff)))
			break
		else
			Spell3Frame:SetAlpha(1)
			Spell3Frame.t:SetTexture(select(3, GetSpellInfo(Spell3Buff)))
		end
	end
	
	for i, Spell4Buff in pairs(Spell4Buff) do
		local spellname = select(1, GetSpellInfo(Spell4Buff))
		if UnitAura("player", spellname) then
			Spell4Frame:SetAlpha(0.2)
			Spell4Frame.t:SetTexture(select(3, GetSpellInfo(Spell4Buff)))
			break
		else
			Spell4Frame:SetAlpha(1)
			Spell4Frame.t:SetTexture(select(3, GetSpellInfo(Spell4Buff)))
		end
	end
	
	for i, Spell5Buff in pairs(Spell5Buff) do
		local spellname = select(1, GetSpellInfo(Spell5Buff))
		if UnitAura("player", spellname) then
			Spell5Frame:SetAlpha(0.2)
			Spell5Frame.t:SetTexture(select(3, GetSpellInfo(Spell5Buff)))
			break
		else
			Spell5Frame:SetAlpha(1)
			Spell5Frame.t:SetTexture(select(3, GetSpellInfo(Spell5Buff)))
		end
	end	

	for i, Spell6Buff in pairs(Spell6Buff) do
		local spellname = select(1, GetSpellInfo(Spell6Buff))
		if UnitAura("player", spellname) then
			Spell6Frame:SetAlpha(0.2)
			Spell6Frame.t:SetTexture(select(3, GetSpellInfo(Spell6Buff)))
			break
		else
			Spell6Frame:SetAlpha(1)
			Spell6Frame.t:SetTexture(select(3, GetSpellInfo(Spell6Buff)))
		end
	end

end

local bsize = 20

--Create the Main bar
local raidbuff_reminder = CreateFrame("Frame", "RaidBuffReminder", TukuiMinimap)
raidbuff_reminder:CreatePanel("Default", bsize + 8, 153, "LEFT", TukuiMinimap, "RIGHT", 3, 0)
raidbuff_reminder:CreateShadow("Default")
raidbuff_reminder:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
raidbuff_reminder:RegisterEvent("UNIT_INVENTORY_CHANGED")
raidbuff_reminder:RegisterEvent("UNIT_AURA")
raidbuff_reminder:RegisterEvent("PLAYER_REGEN_ENABLED")
raidbuff_reminder:RegisterEvent("PLAYER_REGEN_DISABLED")
raidbuff_reminder:RegisterEvent("PLAYER_ENTERING_WORLD")
raidbuff_reminder:RegisterEvent("UPDATE_BONUS_ACTIONBAR")
raidbuff_reminder:RegisterEvent("CHARACTER_POINTS_CHANGED")
raidbuff_reminder:RegisterEvent("ZONE_CHANGED_NEW_AREA")
raidbuff_reminder:SetScript("OnEvent", OnAuraChange)

--Function to create buttons
local function CreateButton(name, relativeTo, firstbutton)
	local button = CreateFrame("Frame", name, RaidBuffReminder)
	if firstbutton == true then
		button:CreatePanel("Default", bsize, bsize, "TOP", relativeTo, "TOP", 0, -4)
	else
		button:CreatePanel("Default", bsize, bsize, "TOP", relativeTo, "BOTTOM", 0, -5)
	end
	button:SetFrameLevel(RaidBuffReminder:GetFrameLevel() + 2)
	button.FrameBackdrop = CreateFrame("Frame", nil, button)
	button.FrameBackdrop:SetTemplate("Default")
	button.FrameBackdrop:SetPoint("TOPLEFT", -2, 2)
	button.FrameBackdrop:SetPoint("BOTTOMRIGHT", 2, -2)
	button.FrameBackdrop:SetFrameLevel(button:GetFrameLevel() - 1)	
	button.t = button:CreateTexture(name..".t", "OVERLAY")
	button.t:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	button.t:SetAllPoints(button)
end

--Create Buttons
do
	CreateButton("FlaskFrame", RaidBuffReminder, true)
	CreateButton("FoodFrame", FlaskFrame, false)
	CreateButton("Spell3Frame", FoodFrame, false)
	CreateButton("Spell4Frame", Spell3Frame, false)
	CreateButton("Spell5Frame", Spell4Frame, false)
	CreateButton("Spell6Frame", Spell5Frame, false)
end