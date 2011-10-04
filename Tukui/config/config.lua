local T, C, L = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales

C["general"] = {
	["autoscale"] = true,                              	 	-- mainly enabled for users that don't want to mess with the config file
	["uiscale"] = 0.71,                                			-- set your value (between 0.64 and 1) of your uiscale if autoscale is off
	["overridelowtohigh"] = false,                     	-- EXPERIMENTAL ONLY! override lower version to higher version on a lower reso.
	["multisampleprotect"] = true,                      	-- i don't recommend this because of shitty border but, voila!
	["backdropcolor"] = {0,0,0},         					-- default backdrop color of panels
	["bordercolor"] = {.125, .125, .125},               -- default border color of panels
	["blizzardreskin"] = true								-- reskin all Blizzard frames
}

C["unitframes"] = {

	-- layout
	["style"] = "Asphyxia",                           			 	-- unitframe style, choose from ("Asphyxia", "Smelly" or "Tukui")

	-- general options
	["enable"] = true,                                  		-- do i really need to explain this?
	["hideunitframes"] = false,							-- hide unitframes  when out of combat.
	["enemyhcolor"] = true,                            	-- enemy target (players) color by hostility, very useful for healer.
	["unitcastbar"] = true,                            		-- enable tukui castbar
	["cblatency"] = true,                             		-- enable castbar latency
	["cbicons"] = true,                                 		-- enable icons on castbar
	["cbspark"] = true,										-- enable castbar spark
	["auratimer"] = true,                               		-- enable timers on buffs/debuffs
	["auratextscale"] = 11,                            		-- the font size of buffs/debuffs timers on unitframes
	["playerauras"] = false,                           	 	-- enable auras
	["targetauras"] = true,                             		-- enable auras on target unit frame
	["lowThreshold"] = 20,                              		-- global low threshold, for low mana warning.
	["targetpowerpvponly"] = false,                     -- enable power text on pvp target only
	["totdebuffs"] = false,                             		-- enable tot debuffs (high reso only)
	["showtotalhpmp"] = false,                          	-- change the display of info text on player and target with XXXX/Total.
	["showsmooth"] = true,                              	-- enable smooth bar
	["charportrait"] = true,                           		-- you DO NOT want to turn portrait off if you are using "Asphyxia2" style.
	["classicon"] = true, 										-- Class icon on unitframes.
	["maintank"] = false,                               		-- enable maintank
	["mainassist"] = false,                             		-- enable mainassist
	["unicolor"] = true,                              			-- enable unicolor theme
	["combatfeedback"] = true,                         	-- enable combattext on player and target.
	["playeraggro"] = true,                             		-- color player border to red if you have aggro on current target.
	["healcomm"] = true,                               		-- enable healprediction support.
	["onlyselfdebuffs"] = false,                        	-- display only our own debuffs applied on target
	["showfocustarget"] = true,                         	-- show focus target
	["bordercolor"] = { 0, 0, 0, 1 },                 		-- unit frames panel border color
	["extendedpet"] = true,                         		-- extended pet frame
	["pettarget"] = true, 										-- show pet target frame
	["showsolo"] = true,                        				-- show raid frames when solo (DPS only)
	["gradienthealth"] = true,                          	-- change raid health color based on health percent.
	["gradient"] = {                                    			-- health gradient color if unicolor is true.
		4.5, 0.1, 0.1, -- R, G, B (low HP)
		0.6, 0.3, 0.3, -- R, G, B (medium HP)
		0.2, 0.2, 0.2, -- R, G, B (high HP)
	},	
	
	-- raid layout (if one of them is enabled)
	["showrange"] = true,                               	-- show range opacity on raidframes
	["raidalphaoor"] = 0.3,                             		-- alpha of unitframes when unit is out of range
	["gridonly"] = true,                               		-- enable grid only mode for all healer mode raid layout.
	["showsymbols"] = true,	                            -- show symbol.
	["aggro"] = true,                                   		-- show aggro on all raids layouts
	["raidunitdebuffwatch"] = true,                     	-- track important spell to watch in pve for grid mode.
	["gridhealthvertical"] = false,                     	-- enable vertical grow on health bar for grid mode.
	["showplayerinparty"] = true,                      	-- show my player frame in party
	["gridscale"] = 1,                                  			-- set the healing grid scaling
	
	-- boss frames
	["showboss"] = true,                                		-- enable boss unit frames for PVELOL encounters.

	-- priest only plugin
	["weakenedsoulbar"] = true,                         -- show weakened soul bar
	
	-- class bar
	["classbar"] = true,									   -- enable tukui classbar over player unit
}

C["arena"] = {
	["unitframes"] = true,								   -- enable tukz arena unitframes (requirement : tukui unitframes enabled)	
}

C["interruptanncounce"] = {
["enable"] = true, 											-- enable/disable interrupt announce
}

C["auras"] = {
	["player"] = true,										   -- enable tukui buffs/debuffs                                		
}

C["actionbar"] = {
	["enable"] = true,                                  -- enable tukui action bars
	["hotkey"] = true,                                 -- enable hotkey display because it was a lot requested
	["hideshapeshift"] = false,                         -- hide shapeshift or totembar because it was a lot requested.
	["showgrid"] = true,                                -- show grid on empty button
	["buttonsize"] = 27,                                -- normal buttons size
	["petbuttonsize"] = 27,                             -- pet & stance buttons size
	["stancebuttonsize"] = 27,                             -- pet & stance buttons size
	["buttonspacing"] = 4,                              -- buttons spacing
	["vertical_rightbars"] = false,						-- vertical or horizontal right bars
	["vertical_shapeshift"] = false,						-- (NOT FOR SHAMANS/TOTEMS) vertical or horizontal shapeshift bar
	["mainswap"] = false,								-- swap bottom actionbars (main bar on top)
	["macrotext"] = false,								   -- display macro text on buttons.
}

C["castbar"] = {
	["classcolor"] = true, 							-- classcolor
	["castbarcolor"] = {.150, .150, .150, 1}, 				-- color if classcolor = false
	["nointerruptcolor"] = { 1, 0, 0, 1 }, 			-- color of casts which can't be interrupted
	
}

C["Addon_Skins"] = {
	["background"] = false,								-- Create a Panel that has the exactly same size as the right chat, placed at the bottomright (for addon placement)
	["combat_toggle"] = false,							-- Shows the Addon Background, Omen, Recount & Skada infight, hides out of fight
	["Recount"] = true,									-- Enable Recount Skin
	["Skada"] = true,										-- Enable Skada Skin
	["Omen"] = true,										-- Enable Omen Skin
	["TinyDPS"] = true,									-- Enable TinyDPS Skin
	["DBM"] = true,											-- skins DBM
	["bigwigs"] = true,									-- skins BigWigs
	["embedright"] = "None",				-- Addon to embed to the right frame ("Recount", & "Skada")
	["embedrighttoggle"] = true,
}

C["sCombo"] = {
	["enable"] = true,									-- Enable sCombo-Addon for combopoints instead of default cp-display
	["energybar"] = false,								-- show energy-Bar below cp bar
}

C["bags"] = {
	["enable"] = true,                                  -- enable an all in one bag mod that fit tukui perfectly
}

C["map"] = {
	["location_panel"] = true,							-- show location panel at top of the screen
}

C["loot"] = {
	["lootframe"] = true,                               -- reskin the loot frame to fit tukui
	["rolllootframe"] = true,                           -- reskin the roll frame to fit tukui
	["autogreed"] = true,                               -- auto-dez or auto-greed item at max level, auto-greed Frozen orb
}

C["cooldown"] = {
	["enable"] = true,                                  -- do i really need to explain this?
	["treshold"] = 8,                                   -- show decimal under X seconds and text turn red
}

C["datatext"] = {
	["fps_ms"] = 0,                                     -- show fps and ms on panels
	["system"] = 0,                                     -- show total memory and others systems infos on panels
	["bags"] = 5,                                       -- show space used in bags on panels
	["gold"] = 6,                                       -- show your current gold on panels
	["wowtime"] = 12,                                    -- show time on panels
	["guild"] = 1,                                      -- show number on guildmate connected on panels
	["dur"] = 0,                                        -- show your equipment durability on panels.
	["friends"] = 2,                                    -- show number of friends connected.
	["dps_text"] = 0,                                   -- show a dps meter on panels
	["hps_text"] = 0,                                   -- show a heal meter on panels
	["power"] = 7,                                      -- show your attackpower/spellpower/healpower/rangedattackpower whatever stat is higher gets displayed
	["haste"] = 8,                                      -- show your haste rating on panels.
	["crit"] = 9,                                       -- show your crit rating on panels.
	["avd"] = 0,                                        -- show your current avoidance against the level of the mob your targeting
	["armor"] = 0,                                      -- show your armor value against the level mob you are currently targeting
	["currency"] = 0,                                  -- show your tracked currency on panels
	["hit"] = 11,                                        -- show hit rating
	["mastery"] =10,                                    -- show mastery rating
	["micromenu"] = 4,                                  -- add a micro menu thought datatext
	["regen"] = 0,                                      -- show mana regeneration
	["profession"] = 0,									-- show profession
	["calltoarms"] = 3, 								-- Call to arms pvp
	["expertise"] = 0, 									-- show your expertise rating
	["enable_specswitcher"] = true, 			-- Show talents
	
	-- Color Datatext
	["classcolored"] = false,							-- classcolored datatext
	["color"] = {0.4, 0.4, 0.5},							-- datatext color (if classcolored = false) -- 0.15, 0.49, 0.69


	["battleground"] = true,                            -- enable 3 stats in battleground only that replace stat1,stat2,stat3.
	["bgannouncer"] = false,                			-- enable an announcer mod for BGs.
	["time24"] = false,                                 -- set time to 24h format.
	["localtime"] = false,                              -- set time to local time instead of server time.
	["fontsize"] = 12,                                  -- font size for panels.
}

C["databars"] = {
	["settings"] = {
		["vertical"] = false,								-- decend vertically...why?! it's so GAY!!!
		["height"] = 17,									-- set the height of the bars
		["width"] = 100,									-- set the width of the bars
		["spacing"] = 3,									-- amount of spacing between bars
		["padding"] = 3,									-- amount of space between sections (skip a number to make a new "section", e.g. fps:3, latency:4, memory:5, bags:7)
	},
	["framerate"] = 1,
	["latency"] = 2,
	["memory"] = 3,
	["durability"] = 4,
	["currency"] = true,
	["reputation"] = true,                             -- show bars with reputation 
	["reps"] = {                                       -- Show 5 factions of your choice, including your guild.
		"Hellscream's Reach",
		"Therazane",
		"Dragonmaw Clan",
		"Guardians of Hyjal",
		"Systematic Chaos",
	},
}

C["asphyxia_panels"] = {
	["asphyxiatalent"] = true,					-- enable or disable talent switcher module (replaces specswitcher datatext).	
	}

C["chat"] = {
	["enable"] = true,                                  -- blah
	["width"] = 378,									-- adjust the chatframe width
	["height"] = 175,									-- adjust the chatframe height 
	["whispersound"] = true,                           -- play a sound when receiving whisper
	["justifyRight"] = false,							-- set right chat frame text to the right
	["background"] = true,								-- Dont make it false!!!
	["rightchat"] = true,								-- set loot window to right chatframe
	["rightchatnumber"] = 4,						-- Rightchat-background is attached to ChatFrameX ..X = value
}

C["nameplate"] = {
	["enable"] = true,                                  -- enable nice skinned nameplates that fit into tukui
	["showhealth"] = true,				                -- show health text on nameplate
	["enhancethreat"] = true,			                -- threat features based on if your a tank or not
	["combat"] = false,					                -- only show enemy nameplates in-combat.
	["goodcolor"] = {75/255,  175/255, 76/255},	        -- good threat color (tank shows this with threat, everyone else without)
	["badcolor"] = {0.78, 0.25, 0.25},			        -- bad threat color (opposite of above)
	["transitioncolor"] = {218/255, 197/255, 92/255},	-- threat color when gaining threat
	["trackcc"] = true,									--track all CC debuffs
	["trackdebuffs"] = true,							--track players debuffs only (debuff list derived from classtimer spell list)
}

C["tooltip"] = {
	["enable"] = true,                                  -- true to enable this mod, false to disable
	["hidecombat"] = false,                             -- hide bottom-right tooltip when in combat
	["hidebuttons"] = false,                            -- always hide action bar buttons tooltip.
	["hideuf"] = false,                                 -- hide tooltip on unitframes
	["cursor"] = false,                                 -- tooltip via cursor only
}

C["merchant"] = {
	["sellgrays"] = true,                               -- automaticly sell grays?
	["autorepair"] = true,                              -- automaticly repair?
	["guildrepair"] = true,							-- automatically use guild funds to repair (if available) -- guild repair only if autorepair == true
	["sellmisc"] = true,                                -- sell defined items automatically
}

C["error"] = {
	["enable"] = true,                                  -- true to enable this mod, false to disable
	filter = {                                          -- what messages to not hide
		[INVENTORY_FULL] = true,                        -- inventory is full will not be hidden by default
	},
}

C["invite"] = { 
	["autoaccept"] = false,                             -- auto-accept invite from guildmate and friends.
}

C["buffreminder"] = {
	["enable"] = true,                                  -- this is now the new innerfire warning script for all armor/aspect class.
	["sound"] = true,                                   -- enable warning sound notification for reminder.
	["raidbuffreminder"] = true,					-- enable panel with missing raid buffs next to the minimap
}