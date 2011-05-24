local T, C, L = unpack(Tukui) -- Import: T - functions, constants, variables; C - config; L - locales

local _, ns = ...
local ptsize = 22

ns.Filger_Settings = {
	configmode = false,
}

ns.Filger_Spells = {
	["DRUID"] = {
		{
			Name = "P_BUFF_ICON",
			Direction = "LEFT",
			Interval = 4,
			Opacity = 1,
			Mode = "ICON",
			setPoint = { "BOTTOMRIGHT", TukuiPlayer, "TOPRIGHT", 0, 130 },

			-- Lifebloom/Blühendes Leben
			{ spellID = 33763, size = ptsize, unitId = "player", caster = "player", filter = "BUFF" },
			-- Rejuvenation/Verjüngung
			{ spellID = 774, size = ptsize, unitId = "player", caster = "player", filter = "BUFF" },
			-- Regrowth/Nachwachsen
			{ spellID = 8936, size = ptsize, unitId = "player", caster = "player", filter = "BUFF" },
			-- Wild Growth/Wildwuchs
			{ spellID = 48438, size = ptsize, unitId = "player", caster = "player", filter = "BUFF" },
		},
		{
			Name = "T_BUFF_ICON",
			Direction = "RIGHT",
			Interval = 4,
			Opacity = 1,
			Mode = "ICON",
			setPoint = { "BOTTOMLEFT", TukuiTarget, "TOPLEFT", 0, 150 },

			-- Lifebloom/Blühendes Leben
			{ spellID = 33763, size = ptsize, unitId = "target", caster = "player", filter = "BUFF" },
			-- Rejuvenation/Verjüngung
			{ spellID = 774, size = ptsize, unitId = "target", caster = "player", filter = "BUFF" },
			-- Regrowth/Nachwachsen
			{ spellID = 8936, size = ptsize, unitId = "target", caster = "player", filter = "BUFF" },
			-- Wild Growth/Wildwuchs
			{ spellID = 48438, size = ptsize, unitId = "target", caster = "player", filter = "BUFF" },
			--Nature's Grasp
			{ spellID = 16689, size = ptsize, unitId = "target", caster = "all", filter = "BUFF" },
		},
		{
			Name = "P_PROC_ICON",
			Direction = "LEFT",
			Interval = 4,
			Mode = "ICON",
			setPoint = { "BOTTOMRIGHT", TukuiPlayer, "TOPRIGHT", 0, 80 },

			-- Eclipse (Lunar)/Mondfinsternis
			{ spellID = 48518, size = ptsize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
			-- Eclipse (Solar)/Sonnenfinsternis
			{ spellID = 48517, size = ptsize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
			-- Shooting Stars/Sternschnuppen
			{ spellID = 93400, size = ptsize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
			-- Savage Roar/Wildes Brüllen
			{ spellID = 52610, size = ptsize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
			-- Survival Instincts/Überlebensinstinkte
			{ spellID = 61336, size = ptsize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
			-- Tree of Life/Baum des Lebens
			{ spellID = 33891, size = ptsize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
			-- Clearcasting/Freizaubern
			{ spellID = 16870, size = ptsize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
			-- Innervate/Anregen
			{ spellID = 29166, size = ptsize*1.5, unitId = "player", caster = "all", filter = "BUFF" },
			-- Barkskin/Baumrinde
			{ spellID = 22812, size = ptsize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
			-- Pulvirize
			{ spellID = 80951, size = ptsize*1.5, unitId = "player", caster = "player", filter = "BUFF" },	

		},
		{
			Name = "T_DEBUFF_ICON",
			Direction = "RIGHT",
			Interval = 4,
			Mode = "ICON",
			setPoint = { "BOTTOMLEFT", TukuiTarget, "TOPLEFT", 0, 100 },

			-- Hibernate/Winterschlaf
			{ spellID = 2637, size = ptsize*1.5, unitId = "target", caster = "all", filter = "DEBUFF" },
			-- Entangling Roots/Wucherwurzeln
			{ spellID = 339, size = ptsize*1.5, unitId = "target", caster = "all", filter = "DEBUFF" },
			-- Cyclone/Wirbelsturm
			{ spellID = 33786, size = ptsize*1.5, unitId = "target", caster = "all", filter = "DEBUFF" },
			-- Moonfire/Mondfeuer
			{ spellID = 8921, size = ptsize*1.5, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Sunfire/Sonnenfeuer
			{ spellID = 93402, size = ptsize*1.5, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Insect Swarm/Insektenschwarm
			{ spellID = 5570, size = ptsize*1.5, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Rake/Krallenhieb
			{ spellID = 1822, size = ptsize*1.5, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Rip/Zerfetzen
			{ spellID = 1079, size = ptsize*1.5, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Lacerate/Aufschlitzen
			--{ spellID = 33745, size = ptsize*1.5, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Pounce Bleed/Anspringblutung
			{ spellID = 9007, size = ptsize*1.5, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Mangle/Zerfleischen
			{ spellID = 33876, size = ptsize*1.5, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Earth and Moon/Erde und Mond
			{ spellID = 48506, size = ptsize*1.5, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Faerie Fire/Feenfeuer
			{ spellID = 770, size = ptsize*1.5, unitId = "target", caster = "all", filter = "DEBUFF" },
		},
		
	},
	["HUNTER"] = {
		{
			Name = "P_PROC_ICON",
			Direction = "LEFT",
			Interval = 4,
			Mode = "ICON",
			setPoint = { "BOTTOMRIGHT", TukuiPlayer, "TOPRIGHT", 0, 80 },

			-- Lock and Load
			{ spellID = 56342, size = ptsize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
			-- Fury of the Five Flights
			{ spellID = 60314, size = ptsize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
			-- Quick Shots
			--{ spellID = 6150, size = ptsize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
			-- Master Tactician
			{ spellID = 34837, size = ptsize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
			-- Improved Steady Shot/Verbesserter zuverlässiger Schuss
			{ spellID = 53224, size = ptsize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
			-- Expose Weakness
			--{ spellID = 34503, size = ptsize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
			-- Rapid Fire
			{ spellID = 3045, size = ptsize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
			-- Call of the Wild
			{ spellID = 53434, size = ptsize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
			-- Mend Pet/Tier heilen
			{ spellID = 136, size = ptsize*1.5, unitId = "pet", caster = "player", filter = "BUFF" },
			-- Feed Pet/Tier füttern
			{ spellID = 6991, size = ptsize*1.5, unitId = "pet", caster = "player", filter = "BUFF" },
			--Master's Call
			{ spellID = 53271, ptsize*1.5, unitId = "target", caster = "all", filter = "BUFF" },

		},
		{
			Name = "T_DEBUFF_ICON",
			Direction = "RIGHT",
			Interval = 4,
			Mode = "ICON",
			setPoint = { "BOTTOMLEFT", TukuiTarget, "TOPLEFT", 0, 100 },

			-- Wyvern Sting
			{ spellID = 19386, size = ptsize*1.5, unitId = "target", caster = "all", filter = "DEBUFF" },
			-- Silencing Shot
			{ spellID = 34490, size = ptsize*1.5, unitId = "target", caster = "all", filter = "DEBUFF" },
			-- Serpent Sting
			{ spellID = 1978, size = ptsize*1.5, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Scorpid Sting
			--{ spellID = 3043, size = ptsize*1.5, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Black Arrow
			{ spellID = 3674, size = ptsize*1.5, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Explosive Shot
			{ spellID = 53301, size = ptsize*1.5, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Hunter's Mark
			{ spellID = 1130, size = ptsize*1.5, unitId = "target", caster = "all", filter = "DEBUFF" },

		},
		
	},
	["MAGE"] = {
		{
			Name = "P_PROC_ICON",
			Direction = "LEFT",
			Interval = 4,
			Mode = "ICON",
			setPoint = { "BOTTOMRIGHT", TukuiPlayer, "TOPRIGHT", 0, 80 },

			-- Frostbite
			--{ spellID = 11071, size = ptsize*1.5, unitId = "target", caster = "all", filter = "DEBUFF" },
			-- Winter's Chill
			{ spellID = 28593, size = ptsize*1.5, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Fingers of Frost
			{ spellID = 44544, size = ptsize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
			-- Fireball!
			{ spellID = 57761, size = ptsize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
			-- Hot Streak
			{ spellID = 44445, size = ptsize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
			-- Missile Barrage
			{ spellID = 54486, size = ptsize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
			-- Clearcasting
			{ spellID = 12536, size = ptsize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
			-- Impact
			{ spellID = 12358, size = ptsize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
		},
		{
			Name = "T_DEBUFF_ICON",
			Direction = "RIGHT",
			Interval = 4,
			Mode = "ICON",
			setPoint = { "BOTTOMLEFT", TukuiTarget, "TOPLEFT", 0, 100 },

			-- Polymorph
			{ spellID = 118, size = ptsize*1.5, unitId = "target", caster = "all", filter = "DEBUFF" },
			-- Slow
			{ spellID = 31589, size = ptsize*1.5, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Ignite
			--{ spellID = 11119, size = ptsize*1.5, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Living Bomb
			{ spellID = 44457, size = ptsize*1.5, unitId = "target", caster = "player", filter = "DEBUFF" },
		},
		
	},
	["WARRIOR"] = {
		{
			Name = "P_PROC_ICON",
			Direction = "LEFT",
			Interval = 4,
			Mode = "ICON",
			setPoint = { "BOTTOMRIGHT", TukuiPlayer, "TOPRIGHT", 0, 80 },

			-- Sudden Death
			{ spellID = 52437, size = ptsize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
			-- Slam!
			{ spellID = 46916, size = ptsize*1.5, unitId = "player", caster = "all", filter = "BUFF" },
			-- Sword and Board
			{ spellID = 50227, size = ptsize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
			-- Blood Reserve
			{ spellID = 64568, size = ptsize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
			-- Last Stand
			{ spellID = 12975, size = ptsize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
			-- Shield Wall
			{ spellID = 871, size = ptsize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
			-- Battle Trance
			{ spellID = 12964, size = ptsize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
			-- Rude Interruption
			{ spellID = 86663, size = ptsize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
			-- Executioner
			{ spellID = 90806, size = ptsize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
			-- Inner Rage
			{ spellID = 1134, size = ptsize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
			-- Victory Rush
			{ spellID = 32216, size = ptsize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
		},
		{
			Name = "T_DEBUFF_ICON",
			Direction = "RIGHT",
			Interval = 4,
			Mode = "ICON",
			setPoint = { "BOTTOMLEFT", TukuiTarget, "TOPLEFT", 0, 100 },

			-- Hamstring
			{ spellID = 1715, size = ptsize*1.5, unitId = "target", caster = "all", filter = "DEBUFF" },
			-- Rend
			{ spellID = 94009, size = ptsize*1.5, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Sunder Armor
			{ spellID = 7386, size = ptsize*1.5, unitId = "target", caster = "all", filter = "DEBUFF" },
			-- Thunder Clap
			{ spellID = 6343, size = ptsize*1.5, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Demoralizing Shout
			{ spellID = 1160, size = ptsize*1.5, unitId = "target", caster = "player", filter = "DEBUFF" },
		},
	},
	["SHAMAN"] = {
		{
			Name = "P_BUFF_ICON",
			Direction = "LEFT",
			Interval = 4,
			Mode = "ICON",
			setPoint = { "BOTTOMRIGHT", TukuiPlayer, "TOPRIGHT", 0, 130 },

			-- Earth Shield/Erdschild
			{ spellID = 974, size = ptsize, unitId = "player", caster = "player", filter = "BUFF" },
			-- Riptide/Springflut
			{ spellID = 61295, size = ptsize, unitId = "player", caster = "player", filter = "BUFF" },
			-- Lightning Shield/Blitzschlagschild
			--{ spellID = 324, size = ptsize, unitId = "player", caster = "player", filter = "BUFF" },
			-- Water Shield/Wasserschild
			{ spellID = 52127, size = ptsize, unitId = "player", caster = "player", filter = "BUFF" },
			-- Spiritwalker's Grace
			{ spellID = 79206, size = ptsize, unitId = "player", caster = "player", filter = "BUFF" },
		},
		{
			Name = "T_BUFF_ICON",
			Direction = "RIGHT",
			Interval = 4,
			Mode = "ICON",
			setPoint = { "BOTTOMLEFT", TukuiTarget, "TOPLEFT", 0, 150 },

			-- Earth Shield/Erdschild
			{ spellID = 974, size = ptsize, unitId = "target", caster = "player", filter = "BUFF" },
			-- Riptide/Springflut
			{ spellID = 61295, size = ptsize, unitId = "target", caster = "player", filter = "BUFF" },
			-- Earthliving
			{ spellID = 51945, size = ptsize, unitId = "target", caster = "player", filter = "BUFF" },
		},
		{
			Name = "P_PROC_ICON",
			Direction = "LEFT",
			Interval = 4,
			Mode = "ICON",
			setPoint = { "BOTTOMRIGHT", TukuiPlayer, "TOPRIGHT", 0, 80 },

			-- Maelstorm Weapon
			--{ spellID = 53817, size = ptsize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
			-- Shamanistic Rage
			{ spellID = 30823, size = ptsize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
			-- Clearcasting
			{ spellID = 16246, size = ptsize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
			-- Tidal Waves
			--{ spellID = 51562, size = ptsize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
			-- Unleash Flame
			{ spellID = 73683, size = ptsize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
			-- Unleash Life
			{ spellID = 73685, size = ptsize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
		},
		{
			Name = "T_DEBUFF_ICON",
			Direction = "RIGHT",
			Interval = 4,
			Mode = "ICON",
			setPoint = { "BOTTOMLEFT", TukuiTarget, "TOPLEFT", 0, 100 },

			-- Hex
			{ spellID = 51514, size = ptsize*1.5, unitId = "target", caster = "all", filter = "DEBUFF" },
			-- Earth Shock
			--{ spellID = 8042, size = ptsize*1.5, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Frost Shock
			{ spellID = 8056, size = ptsize*1.5, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Flame Shock
			{ spellID = 8050, size = ptsize*1.5, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Searing Flames
			{ spellID = 77661, size = ptsize*1.5, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Frostbrand Attack
			{ spellID = 8034, size = ptsize*1.5, unitId = "target", caster = "player", filter = "DEBUFF" }, 
			-- Unleash Frost
			{ spellID = 73682, size = ptsize*1.5, unitId = "target", caster = "player", filter = "DEBUFF" }, 
			-- Unleash Earth
			{ spellID = 73684, size = ptsize*1.5, unitId = "target", caster = "player", filter = "DEBUFF" },
		},
		
	},
	["PALADIN"] = {
		{
			Name = "P_BUFF_ICON",
			Direction = "LEFT",
			Interval = 4,
			Opacity = 1,
			Mode = "ICON",
			setPoint = { "BOTTOMRIGHT", TukuiPlayer, "TOPRIGHT", 0, 130 },

			-- Beacon of Light/Flamme des Glaubens
			{ spellID = 53563, size = ptsize, unitId = "player", caster = "player", filter = "BUFF" },
			-- Judgements of the Pure
			{ spellID = 53657, size = ptsize, unitId = "player", caster = "player", filter = "BUFF" },
			-- Illuminated Healing
			{ spellID = 86273, size = ptsize, unitId = "player", caster = "player", filter = "BUFF" },
		},
		{
			Name = "T_BUFF_ICON",
			Direction = "RIGHT",
			Interval = 4,
			Opacity = 1,
			Mode = "ICON",
			setPoint = { "BOTTOMLEFT", TukuiTarget, "TOPLEFT", 0, 150 },

			-- Beacon of Light/Flamme des Glaubens
			{ spellID = 53563, size = ptsize, unitId = "target", caster = "player", filter = "BUFF" },
			-- Illuminated Healing
			{ spellID = 86273, size = ptsize, unitId = "target", caster = "player", filter = "BUFF" },
		},
		{
			Name = "P_PROC_ICON",
			Direction = "LEFT",
			Interval = 4,
			Mode = "ICON",
			setPoint = { "BOTTOMRIGHT", TukuiPlayer, "TOPRIGHT", 0, 80 },

			-- Infusion of Light
			{ spellID = 54149, size = ptsize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
			-- Divine Plea
			{ spellID = 54428, size = ptsize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
			-- Divine Illumination
			{ spellID = 31842, size = ptsize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
			-- Denounse
			{ spellID = 85509, size = ptsize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
			-- Inquisition
			{ spellID = 84963, size = ptsize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
			-- Selfless Healer
			{ spellID = 90811, size = ptsize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
		},
		{
			Name = "T_DEBUFF_ICON",
			Direction = "RIGHT",
			Interval = 4,
			Mode = "ICON",
			setPoint = { "BOTTOMLEFT", TukuiTarget, "TOPLEFT", 0, 100 },

			-- Hammer of Justice/Hammer der Gerechtigkeit
			{ spellID = 853, size = ptsize*1.5, unitId = "target", caster = "all", filter = "DEBUFF" },
			-- Repentance 
			{ spellID = 20066, size = ptsize*1.5, unitId = "target", caster = "all", filter = "DEBUFF" },
			-- Glyph of Exorcism 
			{ spellID = 879, size = ptsize*1.5, unitId = "target", caster = "player", filter = "DEBUFF" },
		
		},
		
	},
	["PRIEST"] = {
		{
			Name = "P_BUFF_ICON",
			Direction = "LEFT",
			Interval = 4,
			Mode = "ICON",
			setPoint = { "BOTTOMRIGHT", TukuiPlayer, "TOPRIGHT", 0, 130 },

			-- Prayer of Mending/Gebet der Besserung
			{ spellID = 41637, size = ptsize, unitId = "player", caster = "player", filter = "BUFF" },
			-- Guardian Spirit/Schutzgeist
			{ spellID = 47788, size = ptsize, unitId = "player", caster = "player", filter = "BUFF" },
			-- Pain Suppression/Schmerzunterdrückung
			{ spellID = 33206, size = ptsize, unitId = "player", caster = "player", filter = "BUFF" },
			-- Power Word: Shield/Machtwort: Schild
			{ spellID = 17, size = ptsize, unitId = "player", caster = "player", filter = "BUFF" },
			-- Renew/Erneuerung
			{ spellID = 139, size = ptsize, unitId = "player", caster = "player", filter = "BUFF" },
			-- Fade/Verblassen
			{ spellID = 586, size = ptsize, unitId = "player", caster = "player", filter = "BUFF" },
			-- Fear Ward/Furchtzauberschutz
			{ spellID = 6346, size = ptsize, unitId = "player", caster = "player", filter = "BUFF" },
			-- Chakra
			{ spellID = 14751, size = ptsize, unitId = "player", caster = "player", filter = "BUFF" },
			-- Spirit of Redemption 
			{ spellID = 20711, size = ptsize, unitId = "player", caster = "player", filter = "BUFF" },
			-- Spirit Tap
			{ spellID = 81301, size = ptsize, unitId = "player", caster = "player", filter = "BUFF" },
			-- Empowered Darkness
			{ spellID = 95799, size = ptsize, unitId = "player", caster = "player", filter = "BUFF" },
		},
		{
			Name = "T_BUFF_ICON",
			Direction = "RIGHT",
			Interval = 4,
			Mode = "ICON",
			setPoint = { "BOTTOMLEFT", TukuiTarget, "TOPLEFT", 0, 150 },

			-- Prayer of Mending/Gebet der Besserung
			{ spellID = 41637, size = ptsize, unitId = "target", caster = "player", filter = "BUFF" },
			-- Guardian Spirit/Schutzgeist
			{ spellID = 47788, size = ptsize, unitId = "target", caster = "player", filter = "BUFF" },
			-- Pain Suppression/Schmerzunterdrückung
			{ spellID = 33206, size = ptsize, unitId = "target", caster = "player", filter = "BUFF" },
			-- Power Word: Shield/Machtwort: Schild
			{ spellID = 17, size = ptsize, unitId = "target", caster = "player", filter = "BUFF" },
			-- Renew/Erneuerung
			{ spellID = 139, size = ptsize, unitId = "target", caster = "player", filter = "BUFF" },
			-- Fear Ward/Furchtzauberschutz
			{ spellID = 6346, size = ptsize, unitId = "target", caster = "player", filter = "BUFF" },
			-- Archangel
			{ spellID = 81700, size = ptsize, unitId = "player", caster = "player", filter = "BUFF" },
			-- Dark Archangel
			{ spellID = 87153, size = ptsize, unitId = "player", caster = "player", filter = "BUFF" },
		},
		{
			Name = "P_PROC_ICON",
			Direction = "LEFT",
			Interval = 4,
			Mode = "ICON",
			setPoint = { "BOTTOMRIGHT", TukuiPlayer, "TOPRIGHT", 0, 80 },

			-- Surge of Light
			{ spellID = 88688, size = ptsize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
			-- Dark Evangelism
			{ spellID = 87118, size = ptsize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
			-- Dispersion
			{ spellID = 47585, size = ptsize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
			-- Chakra: Serenity
			{ spellID = 81208, size = ptsize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
			-- Chakra: Sanctuary
			{ spellID = 81206, size = ptsize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
			-- Chakra: Chastise
			{ spellID = 81209, size = ptsize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
			-- Mind Melt
			{ spellID = 87160, size = ptsize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
		},
		{
			Name = "T_DEBUFF_ICON",
			Direction = "RIGHT",
			Interval = 4,
			Mode = "ICON",
			setPoint = { "BOTTOMLEFT", TukuiTarget, "TOPLEFT", 0, 100 },

			-- Shackle undead
			{ spellID = 9484, size = ptsize*1.5, unitId = "target", caster = "all", filter = "DEBUFF" },
			-- Psychic Scream
			{ spellID = 8122, size = ptsize*1.5, unitId = "target", caster = "all", filter = "DEBUFF" },
			-- Shadow Word: Pain
			{ spellID = 589, size = ptsize*1.5, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Devouring Plague
			{ spellID = 2944, size = ptsize*1.5, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Vampiric Touch
			{ spellID = 34914, size = ptsize*1.5, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Mind Blast, stacks of + crit
			{ spellID = 87178, size = ptsize*1.5, unitId = "target", caster = "player", filter = "DEBUFF" },
		},
		
	},
	["WARLOCK"] = {
		{
			Name = "P_PROC_ICON",
			Direction = "LEFT",
			Interval = 4,
			Mode = "ICON",
			setPoint = { "BOTTOMRIGHT", TukuiPlayer, "TOPRIGHT", 0, 80 },

			--Devious Minds/Teuflische Absichten
			{ spellID = 70840, size = ptsize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
			-- Improved Soul Fire
			{ spellID = 85114, size = ptsize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
			-- Molten Core
			{ spellID = 47383, size = ptsize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
			-- Decimation
			{ spellID = 63158, size = ptsize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
			-- Backdraft
			{ spellID = 54277, size = ptsize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
			-- Backlash
			{ spellID = 34939, size = ptsize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
			-- Nether Protection
			{ spellID = 30301, size = ptsize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
			-- Nightfall
			{ spellID = 18095, size = ptsize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
			-- Burning Soul
			{ spellID = 74434, size = ptsize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
		},
		
		{
			Name = "SOULFIRE_BUFF_ICON",
			Direction = "UP",
			Interval = 4,
			Opacity = 1,
			Mode = "ICON",
			setPoint = { "BOTTOM", TukuiTargetTarget, "TOP", 0, 40 },

			-- Soulfire
			{ spellID = 85383, size = 50, unitId = "player", caster = "player", filter = "BUFF" },	
			-- 4set Bonus
			{ spellID = 89937, size = 50, unitId = "player", caster = "player", filter = "BUFF" },
			-- Eradication
			{ spellID = 64371, size = 50, unitId = "player", caster = "player", filter = "BUFF" },			
		},
		
		{
			Name = "COOLDOWN",
			Direction = "RIGHT",
			Interval = 4,
			Opacity = 1,
			Mode = "ICON",
			setPoint = { "LEFT", TukuiPlayer, "LEFT", -63, 210 },

			-- Soul Shatter
			{ spellID = 29858, size = 34, filter = "CD" },
			-- Death Coil
			{ spellID = 6789, size = 34, filter = "CD" },
			-- Chaos Bolt
			{ spellID = 50796, size = 34, filter = "CD" },
			-- Demonic Circle: Teleport
			{ spellID = 48020, size = 34, filter = "CD" },
			-- Ignite
			{ spellID = 17962, size = 34, filter = "CD" },
			-- Burning Soul
			{ spellID = 74434, size = 34, filter = "CD" },
			-- Demon Soul
			{ spellID = 77801, size = 34, filter = "CD" },
			-- Infernal
			{ spellID = 1122, size = 34, filter = "CD" },
			-- Soul Harvest
			{ spellID = 79268, size = 34, filter = "CD" },
			-- Engineering (Gloves)
			{ slotID = 10, size = 34, filter = "CD" },
			-- Engineering (Belt)
			{ slotID = 6, size = 34, filter = "CD" },
		},
		
		{
			Name = "T_DEBUFF_ICON",
			Direction = "RIGHT",
			Interval = 4,
			Mode = "ICON",
			setPoint = { "BOTTOMLEFT", TukuiTarget, "TOPLEFT", 0, 100 },

			-- Fear
			{ spellID = 5782, size = ptsize*1.5, unitId = "target", caster = "all", filter = "DEBUFF" },
			-- Banish
			{ spellID = 710, size = ptsize*1.5, unitId = "target", caster = "all", filter = "DEBUFF" },
			-- Curse of the Elements
			{ spellID = 1490, size = ptsize*1.5, unitId = "target", caster = "all", filter = "DEBUFF" },
			-- Curse of Tongues
			{ spellID = 1714, size = ptsize*1.5, unitId = "target", caster = "all", filter = "DEBUFF" },
			-- Curse of Exhaustion
			{ spellID = 18223, size = ptsize*1.5, unitId = "target", caster = "all", filter = "DEBUFF" },
			-- Curse of Weakness
			{ spellID = 702, size = ptsize*1.5, unitId = "target", caster = "all", filter = "DEBUFF" },
			-- Shadow Embrace
			{ spellID = 32385, size = ptsize*1.5, unitId = "target", caster = "player", filter = "BUFF" },
			-- Corruption
			{ spellID = 172, size = ptsize*1.5, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Immolate
			{ spellID = 348, size = ptsize*1.5, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Curse of Agony
			{ spellID = 980, size = ptsize*1.5, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Bane of Doom
			{ spellID = 603, size = ptsize*1.5, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Unstable Affliction
			{ spellID = 30108, size = ptsize*1.5, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Haunt
			{ spellID = 48181, size = ptsize*1.5, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Seed of Corruption
			{ spellID = 27243, size = ptsize*1.5, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Howl of Terror
			{ spellID = 5484, size = ptsize*1.5, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Death Coil
			{ spellID = 6789, size = ptsize*1.5, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Enslave Demon
			{ spellID = 1098, size = ptsize*1.5, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Demon Charge
			{ spellID = 54785, size = ptsize*1.5, unitId = "target", caster = "player", filter = "DEBUFF" },
		},
		
	},
	["ROGUE"] = {
		{
			Name = "P_PROC_ICON",
			Direction = "LEFT",
			Interval = 4,
			Mode = "ICON",
			setPoint = { "BOTTOMRIGHT", TukuiPlayer, "TOPRIGHT", 0, 80 },

			-- Sprint
			{ spellID = 2983, size = ptsize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
			-- Cloak of Shadows
			{ spellID = 31224, size = ptsize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
			-- Adrenaline Rush
			{ spellID = 13750, size = ptsize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
			-- Evasion
			{ spellID = 5277, size = ptsize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
			-- Envenom
			{ spellID = 32645, size = ptsize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
			-- Overkill
			{ spellID = 58426, size = ptsize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
			-- Slice and Dice
			{ spellID = 5171, size = ptsize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
			-- Tricks of the Trade
			{ spellID = 57934, size = ptsize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
			-- Turn the Tables
			{ spellID = 51627, size = ptsize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
			-- Recuperate
			{ spellID = 73651, size = ptsize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
			-- Shadow Step
			{ spellID = 36563, size = ptsize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
		},
		{
			Name = "T_DEBUFF_ICON",
			Direction = "RIGHT",
			Interval = 4,
			Mode = "ICON",
			setPoint = { "BOTTOMLEFT", TukuiTarget, "TOPLEFT", 0, 100 },

			-- Cheap shot
			{ spellID = 1833, size = ptsize*1.5, unitId = "target", caster = "all", filter = "DEBUFF" },
			-- Kidney shot
			{ spellID = 408, size = ptsize*1.5, unitId = "target", caster = "all", filter = "DEBUFF" },
			-- Blind
			{ spellID = 2094, size = ptsize*1.5, unitId = "target", caster = "all", filter = "DEBUFF" },
			-- Sap
			{ spellID = 6770, size = ptsize*1.5, unitId = "target", caster = "all", filter = "DEBUFF" },
			-- Rupture
			{ spellID = 1943, size = ptsize*1.5, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Garrote
			{ spellID = 703, size = ptsize*1.5, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Gouge
			{ spellID = 1776, size = ptsize*1.5, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Expose Armor
			{ spellID = 8647, size = ptsize*1.5, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Dismantle
			{ spellID = 51722, size = ptsize*1.5, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Deadly Poison
			{ spellID = 2818, size = ptsize*1.5, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Mind-numbing Poison
			{ spellID = 5760, size = ptsize*1.5, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Crippling Poison
			{ spellID = 3409, size = ptsize*1.5, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Wound Poison
			{ spellID = 13218, size = ptsize*1.5, unitId = "target", caster = "player", filter = "DEBUFF" },
		},
		
	},
	["DEATHKNIGHT"] = {
		{
			Name = "P_BUFF_ICON",
			Direction = "LEFT",
			Interval = 4,
			Mode = "ICON",
			setPoint = { "BOTTOMRIGHT", TukuiPlayer, "TOPRIGHT", 0, 130 },

			-- Bone Shield
			--{ spellID = 49222, size = ptsize, unitId = "player", caster = "player", filter = "BUFF" },
			-- Anti-Magic Shield
			{ spellID = 48707, size = ptsize, unitId = "player", caster = "player", filter = "BUFF" },
		},
		{
			Name = "P_PROC_ICON",
			Direction = "LEFT",
			Interval = 4,
			Mode = "ICON",
			setPoint = { "BOTTOMRIGHT", TukuiPlayer, "TOPRIGHT", 0, 80 },

			-- Unholy Force/Unheilige Kraft
			{ spellID = 67383, size = ptsize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
			-- Desolation/Verwüstung
			--{ spellID = 66817, size = ptsize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
			-- Unholy Strength/Unheilige Stärke
			{ spellID = 53365, size = ptsize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
			-- Unholy Might/Unheilige Macht
			{ spellID = 67117, size = ptsize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
			-- Dancing Rune Weapon/Tanzende Runenwaffe
			{ spellID = 49028, size = ptsize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
			-- Killing machine
			{ spellID = 51124, size = ptsize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
			-- Freezing fog
			{ spellID = 59052, size = ptsize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
			-- Dark Simulacrum
			{ spellID = 77606, size = ptsize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
		},
		{
			Name = "T_DEBUFF_ICON",
			Direction = "RIGHT",
			Interval = 4,
			Mode = "ICON",
			setPoint = { "BOTTOMLEFT", TukuiTarget, "TOPLEFT", 0, 100 },

			-- Blood Plague/Blutseuche
			{ spellID = 59879, size = ptsize*1.5, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Frost Fever/Frostfieber
			{ spellID = 59921, size = ptsize*1.5, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Unholy Blight/Unheilige Verseuchung
			{ spellID = 49194, size = ptsize*1.5, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Summon Gargoyle/Gargoyle beschwören
			{ spellID = 49206, size = ptsize*1.5, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Pillar of Frost
			{ spellID = 51271, size = ptsize*1.5, unitId = "target", caster = "all", filter = "BUFF" },
		},
	},
	["ALL"] = {
		{
			Name = "SPECIAL_P_BUFF_ICON",
			Direction = "LEFT",
			Interval = 4,
			Mode = "ICON",
			setPoint = { "BOTTOMRIGHT", TukuiPlayer, "TOPRIGHT", 0, 35 },

			-- Eyes of Twilight/Augen des Zwielichts
			{ spellID = 75495, size = ptsize, unitId = "player", caster = "player", filter = "BUFF" },
			-- Piercing Twilight/Durchbohrendes Zwielicht
			{ spellID = 75456, size = ptsize, unitId = "player", caster = "player", filter = "BUFF" },
			-- Twilight Flames/Zwielichtflammen
			{ spellID = 75473, size = ptsize, unitId = "player", caster = "player", filter = "BUFF" },
			-- Scaly Nimbleness/Schuppige Gewandtheit
			{ spellID = 75480, size = ptsize, unitId = "player", caster = "player", filter = "BUFF" },
			-- Surge of Power/Kraftsog
			{ spellID = 71644, size = ptsize, unitId = "player", caster = "player", filter = "BUFF" },
			-- Thick Skin/Dicke Haut
			{ spellID = 71639, size = ptsize, unitId = "player", caster = "player", filter = "BUFF" },
			-- Siphoned Power/Entzogene Kraft
			{ spellID = 71636, size = ptsize, unitId = "player", caster = "player", filter = "BUFF" },
			-- Aegis of Dalaran/Aegis von Dalaran
			{ spellID = 71638, size = ptsize, unitId = "player", caster = "player", filter = "BUFF" },
			-- Speed of the Vrykul/Geschwindigkeit der Vrykul
			{ spellID = 71560, size = ptsize, unitId = "player", caster = "player", filter = "BUFF" },
			-- Power of the Taunka/Macht der Taunka
			{ spellID = 71558, size = ptsize, unitId = "player", caster = "player", filter = "BUFF" },
			-- Agility of the Vrykul/Beweglichkeit der Vrykul
			{ spellID = 71556, size = ptsize, unitId = "player", caster = "player", filter = "BUFF" },
			-- Mote of Anger/Partikel des Zorns
			{ spellID = 71432, size = ptsize, unitId = "player", caster = "player", filter = "BUFF" },
			-- Icy Rage/Eisige Wut
			{ spellID = 71541, size = ptsize, unitId = "player", caster = "player", filter = "BUFF" },
			-- Cultivated Power/Kultivierte Macht
			{ spellID = 71572, size = ptsize, unitId = "player", caster = "player", filter = "BUFF" },
			-- Invigorated/Gestärkt
			{ spellID = 71577, size = ptsize, unitId = "player", caster = "player", filter = "BUFF" },
			-- Revitalized/Revitalisiert
			{ spellID = 71584, size = ptsize, unitId = "player", caster = "player", filter = "BUFF" },
			-- Rage of the Fallen/Zorn der Gefallenen
			{ spellID = 71396, size = ptsize, unitId = "player", caster = "player", filter = "BUFF" },
			-- Hardened Skin/Gehärtete Haut
			{ spellID = 71586, size = ptsize, unitId = "player", caster = "player", filter = "BUFF" },
			-- Elusive Power/Flüchtige Macht
			{ spellID = 71579, size = ptsize, unitId = "player", caster = "player", filter = "BUFF" },
			-- Shard of Flame/Flammensplitter
			{ spellID = 67759, size = ptsize, unitId = "player", caster = "player", filter = "BUFF" },
			-- Necrotic Touch
			{ spellID = 71875, size = ptsize, unitId = "player", caster = "player", filter = "BUFF" },

			-- Frostforged Champion/Frostgeschmiedeter Champion
			{ spellID = 72412, size = ptsize, unitId = "player", caster = "player", filter = "BUFF" },
			-- Chilling Knowledge/Kühlendes Wissen
			{ spellID = 72418, size = ptsize, unitId = "player", caster = "player", filter = "BUFF" },
			-- Frostforged Sage/Frostgeschmiedeter Weiser
			{ spellID = 72416, size = ptsize, unitId = "player", caster = "player", filter = "BUFF" },
			-- Frostforged Defender/Frostgeschmiedeter Verteidiger
			{ spellID = 72414, size = ptsize, unitId = "player", caster = "player", filter = "BUFF" },

			-- Hyperspeed Accelerators/Hypergeschwindigkeitsbeschleuniger
			{ spellID = 54999, size = ptsize, unitId = "player", caster = "player", filter = "BUFF" },

			-- Speed/Geschwindigkeit
			{ spellID = 53908, size = ptsize, unitId = "player", caster = "player", filter = "BUFF" },
			-- Wild Magic/Wilde Magie
			{ spellID = 53909, size = ptsize, unitId = "player", caster = "player", filter = "BUFF" },

			--Tricks of the Trade/Schurkenhandel
			{ spellID = 57934, size = ptsize, unitId = "player", caster = "all", filter = "BUFF" },
			--Power Infusion/Seele der Macht
			{ spellID = 10060, size = ptsize, unitId = "player", caster = "all", filter = "BUFF" },
			-- Bloodlust/Kampfrausch
			{ spellID = 2825, size = ptsize, unitId = "player", caster = "all", filter = "BUFF" },
			-- Heroism/Heldentum
			{ spellID = 32182, size = ptsize, unitId = "player", caster = "all", filter = "BUFF" },
			
			--[[	Cataclysm Buffs	   ]]--
			
			-- Race Against Death
			{ spellID = 91821, size = ptsize, unitId = "player", caster = "player", filter = "BUFF" },
			-- Dire Magic
			{ spellID = 91007, size = ptsize, unitId = "player", caster = "player", filter = "BUFF" },
			-- Revelation
			{ spellID = 91024, size = ptsize, unitId = "player", caster = "player", filter = "BUFF" },
			-- Heedless Carnage
			{ spellID = 92108, size = ptsize, unitId = "player", caster = "player", filter = "BUFF" },			
			-- Agony and Torment
			{ spellID = 95762, size = ptsize, unitId = "player", caster = "player", filter = "BUFF" },		
			-- Inner Eye
			{ spellID = 91320, size = ptsize, unitId = "player", caster = "player", filter = "BUFF" },		
			-- Heart's Revelation
			{ spellID = 91027, size = ptsize, unitId = "player", caster = "player", filter = "BUFF" },		
			-- River of Death
			{ spellID = 92104, size = ptsize, unitId = "player", caster = "player", filter = "BUFF" },		
			-- Slayer
			{ spellID = 91810, size = ptsize, unitId = "player", caster = "player", filter = "BUFF" },		
			-- Raw Fury
			{ spellID = 91832, size = ptsize, unitId = "player", caster = "player", filter = "BUFF" },		
			
			-- Blind Spot (Jar of Ancient Remedies)
			{ spellID = 91322, size = ptsize, unitId = "player", caster = "player", filter = "DEBUFF" },		
			
			-- Weapon Enchants
			-- Hurricane
			{ spellID = 74221, size = ptsize, unitId = "player", caster = "player", filter = "BUFF" },
			-- Heartsong
			{ spellID = 74224, size = ptsize, unitId = "player", caster = "player", filter = "BUFF" },
			-- Power Torrent
			{ spellID = 74241, size = ptsize, unitId = "player", caster = "player", filter = "BUFF" },
			-- Landslide
			{ spellID = 74245, size = ptsize, unitId = "player", caster = "player", filter = "BUFF" },
		},
		{
			Name = "PVE/PVP_P_DEBUFF_ICON",
			Direction = "LEFT",
			Interval = 4,
			Mode = "ICON",
			setPoint = { "BOTTOMRIGHT", TukuiPlayer, "TOPRIGHT", 0, 170 },
			
			-- Preperation
			{ spellID = 44521, size = ptsize*2, unitId = "player", caster = "all", filter = "BUFF" },

			-- Death Knight
			-- Gnaw (Ghoul)
			{ spellID = 47481, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Strangulate
			{ spellID = 47476, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Chains of Ice
			{ spellID = 45524, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Desecration (no duration, lasts as long as you stand in it)
			{ spellID = 55741, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Glyph of Heart Strike
			{ spellID = 58617, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Icy Clutch (Chilblains)
			--{ spellID = 50436, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Hungering Cold
			{ spellID = 51209, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },

			-- Druid
			-- Cyclone
			{ spellID = 33786, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Hibernate
			{ spellID = 2637, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Bash
			{ spellID = 5211, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Maim
			{ spellID = 22570, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Pounce
			{ spellID = 9005, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Entangling Roots
			{ spellID = 339, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Feral Charge Effect
			{ spellID = 45334, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Infected Wounds
			{ spellID = 58179, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },

			-- Hunter
			-- Freezing Trap Effect
			{ spellID = 3355, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Freezing Arrow Effect
			--{ spellID = 60210, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Scare Beast
			{ spellID = 1513, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Scatter Shot
			{ spellID = 19503, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Chimera Shot - Scorpid
			--{ spellID = 53359, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Snatch (Bird of Prey)
			{ spellID = 50541, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Silencing Shot
			{ spellID = 34490, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Intimidation
			{ spellID = 24394, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Sonic Blast (Bat)
			{ spellID = 50519, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Ravage (Ravager)
			{ spellID = 50518, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Concussive Barrage
			{ spellID = 35101, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Concussive Shot
			{ spellID = 5116, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Frost Trap Aura
			{ spellID = 13810, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Glyph of Freezing Trap
			{ spellID = 61394, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Wing Clip
			{ spellID = 2974, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Counterattack
			{ spellID = 19306, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Entrapment
			{ spellID = 19185, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Pin (Crab)
			{ spellID = 50245, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Venom Web Spray (Silithid)
			{ spellID = 54706, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Web (Spider)
			{ spellID = 4167, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Froststorm Breath (Chimera)
			{ spellID = 51209, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Tendon Rip (Hyena)
			{ spellID = 51209, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },

			-- Mage
			-- Dragon's Breath
			{ spellID = 31661, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Polymorph
			{ spellID = 118, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Silenced - Improved Counterspell
			{ spellID = 18469, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Deep Freeze
			{ spellID = 44572, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Freeze (Water Elemental)
			{ spellID = 33395, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Frost Nova
			{ spellID = 122, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Shattered Barrier
			{ spellID = 55080, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Chilled
			{ spellID = 6136, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Cone of Cold
			{ spellID = 120, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Slow
			{ spellID = 31589, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Ring of Frost 
			{ spellID = 82691, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },

			-- Paladin
			-- Repentance
			{ spellID = 20066, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Turn Evil
			{ spellID = 10326, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Shield of the Templar
			{ spellID = 63529, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Hammer of Justice
			{ spellID = 853, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Holy Wrath
			{ spellID = 2812, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Stun (Seal of Justice proc)
			{ spellID = 20170, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Avenger's Shield
			{ spellID = 31935, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },

			-- Priest
			-- Psychic Horror
			{ spellID = 64058, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Mind Control
			{ spellID = 605, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Psychic Horror
			{ spellID = 64044, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Psychic Scream
			{ spellID = 8122, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Silence
			{ spellID = 15487, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Mind Flay
			{ spellID = 15407, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },

			-- Rogue
			-- Dismantle
			{ spellID = 51722, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Blind
			{ spellID = 2094, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Gouge
			{ spellID = 1776, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Sap
			{ spellID = 6770, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Garrote - Silence
			{ spellID = 1330, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Silenced - Improved Kick
			{ spellID = 18425, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Cheap Shot
			{ spellID = 1833, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Kidney Shot
			{ spellID = 408, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Blade Twisting
			{ spellID = 31125, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Crippling Poison
			{ spellID = 3409, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Deadly Throw
			{ spellID = 26679, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },

			-- Shaman
			-- Hex
			{ spellID = 51514, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Earthgrab
			{ spellID = 64695, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Freeze
			{ spellID = 63685, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Stoneclaw Stun
			{ spellID = 39796, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Earthbind
			{ spellID = 3600, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Frost Shock
			{ spellID = 8056, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },

			-- Warlock
			-- Banish
			{ spellID = 710, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Death Coil
			{ spellID = 6789, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Fear
			{ spellID = 5782, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Howl of Terror
			{ spellID = 5484, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Seduction (Succubus)
			{ spellID = 6358, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Spell Lock (Felhunter)
			{ spellID = 24259, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Shadowfury
			{ spellID = 30283, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Intercept (Felguard)
			{ spellID = 30153, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Aftermath
			{ spellID = 18118, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Curse of Exhaustion
			{ spellID = 18223, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },

			-- Warrior
			-- Intimidating Shout
			{ spellID = 20511, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Disarm
			{ spellID = 676, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Silenced (Gag Order)
			{ spellID = 18498, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Charge Stun
			{ spellID = 7922, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Concussion Blow
			{ spellID = 12809, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Intercept
			{ spellID = 20253, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Revenge Stun
			--{ spellID = 12798, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Shockwave
			{ spellID = 46968, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Glyph of Hamstring
			{ spellID = 58373, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Improved Hamstring
			{ spellID = 23694, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Hamstring
			{ spellID = 1715, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Piercing Howl
			{ spellID = 12323, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Throwdown
			{ spellID = 85388, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
      
			-- Racials
			-- War Stomp
			{ spellID = 20549, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			
			--[[	Cataclysm	]]--
			
			-- Throne of Four Winds
			
			-- Al'Akir
			-- Static Shock
			{ spellID = 87873, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Acid Rain
			{ spellID = 88301, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			
			-- Bastion of Twilight
			-- Cho'gall
			-- Corruption: Accelerated(25% Corruption)
			{ spellID = 81836, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Corruption: Sickness (vomit infront of you)
			{ spellID = 81831, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Corruption: Malformation (75% Corruption)
			{ spellID = 82125, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Corruption: Absolute (100% Corruption)
			{ spellID = 82170, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			
			-- Valiona & Theralion
			-- Blackout
			{ spellID = 86788, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			
			-- Twilight Ascendant Council
			-- Waterlogged
			{ spellID = 82762, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Frozen
			{ spellID = 82772, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			
			-- Blackwing Descent
			
			-- Chimaeron
			-- Caustic Slime
			{ spellID = 88916, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			
			-- Magmaw
			-- Constricting Chains
			{ spellID = 79589, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			
			-- Maloriak
			-- Flash Freeze
			{ spellID = 77699, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			
			-- Omnitron Defense System
			-- Lightning Conductor
			{ spellID = 79888, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Unstable Shield
			{ spellID = 79900, size = ptsize*2, unitId = "target", caster = "all", filter = "BUFF" },
			
			-- Nefarian
			-- Explosive Cinders (HC only)
			{ spellID = 79339, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },

			-- Baradin Hold(PvP)
			-- Argaloth
			
			-- Meteor Slash
			{ spellID = 88942, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			
            -- Blackrock Caverns
			 
			-- Corla, Herald of Twilight // Normal
			-- Dark Command
			{ spellID = 75823, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Evolution
			{ spellID = 75697, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			
			-- Corla, Herald of Twilight // Heroic
			-- Dark Command
			{ spellID = 93462, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Evolution
			{ spellID = 87378, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			
			-- Beauty
			-- Magma Spit
			{ spellID = 76031, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			
			-- Ascendant Lord Obsidius
			-- Thunderclap 50% run speed
			{ spellID = 76186, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Crepuscular Veil
			{ spellID = 76189, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			
			-- Grim Batol
			
			-- General Umbriss
			-- Bleeding Wound normal
			{ spellID = 91937, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Bleeding Wound
			{ spellID = 74846, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			
			-- Erudax
			-- Binding Shadows normal
			{ spellID = 91081, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Binding Shadows
			{ spellID = 79466, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			
			-- Halls of Origination
			
			-- Anraphet
			-- Crumbling Ruin normal
			{ spellID = 75609, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Crumbling Ruin
			{ spellID = 91206, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			
			-- Ammunae
			
			-- Wither
			{ spellID = 76043, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			
			-- The Stonecore
			
			-- Corborus
			-- Dampening Wave normal
			{ spellID = 82415, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Dampening Wave
			{ spellID = 92650, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			
			-- Azil
			-- Curse of Blood normal
			{ spellID = 79345, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Curse of Blood
			{ spellID = 92663, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			
			-- Throne of Tides
			
			-- Lady Naz'jar
			-- Fungal Spores normal
			{ spellID = 91470, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			
			-- Commander Ulthok
			
			-- Curse of Fatique
			{ spellID = 76094, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Squeeze normal
			{ spellID = 76026, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Squeeze
			{ spellID = 91484, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			
			-- Erunak Stonespeaker
			-- Enslave normal
			{ spellID = 91413, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Enslave
			{ spellID = 76207, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			
			-- Ozumat
			-- Veil of Shadow
			{ spellID = 83926, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			
			-- Vortex Pinnacle
			
			-- Altairus
			-- Downwind of Altairus
			{ spellID = 88286, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Upwind of Altairus
			{ spellID = 88282, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			
			-- Asaad
			-- Static Cling
			{ spellID = 87618, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			
			-- Lost City of the Tol'vir
			
			-- Lockmaw
			-- Viscous Poison normal
			{ spellID = 81630, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Viscous Poison
			{ spellID = 90004, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Paralytic Blow Dart
			{ spellID = 89989, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			
			-- Heroic Deadmines
			
			-- "Captain" Cookie
			-- Nauseated
			{ spellID = 92066, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Satiated
			{ spellID = 92834, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			
			-- Shadowfang Keep Heroic
			
			-- Baron Ashbury
			-- Asphyxiate
			{ spellID = 93710, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Stay of Execution
			{ spellID = 93705, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Pain & Suffering
			{ spellID = 93712, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Wracking Pain
			{ spellID = 93720, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			
			-- Baron Silverlaine
			-- Cursed Veil
			{ spellID = 93956, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Soul Drain
			{ spellID = 93920, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			
			-- Commander Springvale
			-- Desecration
			{ spellID = 93687, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Word of Shame
			{ spellID = 93852, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			
			-- Lord Walden
			-- Toxic Catalyst
			{ spellID = 93689, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			
			-- Lord Godfrey Ghul
			-- Mortal Wound
			{ spellID = 93771, size = ptsize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
		},
		{
			Name = "PVP_T_BUFF_ICON",
			Direction = "RIGHT",
			Interval = 4,
			Mode = "ICON",
			setPoint = { "BOTTOMLEFT", TukuiTarget, "TOPLEFT", 0, 190 },

			-- Aspect of the Pack
			{ spellID = 13159, size = ptsize*2, unitId = "player", caster = "player", filter = "BUFF" },
			-- Innervate
			{ spellID = 29166, size = ptsize*2, unitId = "target", caster = "all", filter = "BUFF"},
			-- Spell Reflection
			{ spellID = 23920, size = ptsize*2, unitId = "target", caster = "all", filter = "BUFF" },
			-- Aura Mastery
			{ spellID = 31821, size = ptsize*2, unitId = "target", caster = "all", filter = "BUFF" },
			-- Ice Block
			{ spellID = 45438, size = ptsize*2, unitId = "target", caster = "all", filter = "BUFF" },
			-- Cloak of Shadows
			{ spellID = 31224, size = ptsize*2, unitId = "target", caster = "all", filter = "BUFF" },
			-- Divine Shield
			{ spellID = 642, size = ptsize*2, unitId = "target", caster = "all", filter = "BUFF" },
			-- Deterrence
			{ spellID = 19263, size = ptsize*2, unitId = "target", caster = "all", filter = "BUFF" },
			-- Anti-Magic Shell
			{ spellID = 48707, size = ptsize*2, unitId = "target", caster = "all", filter = "BUFF" },
			-- Lichborne
			{ spellID = 49039, size = ptsize*2, unitId = "target", caster = "all", filter = "BUFF" },
			-- Hand of Freedom
			{ spellID = 1044, size = ptsize*2, unitId = "target", caster = "all", filter = "BUFF" },
			-- Hand of Sacrifice
			{ spellID = 6940, size = ptsize*2, unitId = "target", caster = "all", filter = "BUFF" },
			-- Grounding Totem Effect
			{ spellID = 8178, size = ptsize*2, unitId = "target", caster = "all", filter = "BUFF" },
			-- Dark Simulacrum
			{ spellID = 77606, size = ptsize*2, unitId = "target", caster = "all", filter = "BUFF" },
			-- Dispersion
			{ spellID = 47585, size = ptsize*2, unitId = "target", caster = "all", filter = "BUFF" },
		},
	},
}