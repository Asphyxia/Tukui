--------------------------------------------------------------------
-- GUILD ROSTER
--------------------------------------------------------------------
local T, C, L = unpack(select(2, ...)) -- Import Functions/Constants, Config, Locales

local USE_EPGP = true

if C["datatext"].guild and C["datatext"].guild > 0 then	

	function sortGuildByRank(a,b)

		texta = string.format("%02d",a.rankIndex)..a.name
		textb = string.format("%02d",b.rankIndex)..b.name

		return texta<textb
	end

	function sortGuildByName(a,b)
		texta = a.name
		textb = b.name

		return texta<textb
	end

	function sortGuildByZone(a,b)

		texta = a.zone..a.name
		textb = b.zone..b.name

		return texta<textb
	end

	sortGuildFunc = sortGuildByName

	local Stat = CreateFrame("Frame")
	Stat:EnableMouse(true)
	Stat:SetFrameStrata("MEDIUM")
	Stat:SetFrameLevel(3)

	local tthead = {r=0.4,g=0.78,b=1}
	local ttsubh = {r=0.75,g=0.9,b=1}

	local Text  = TukuiInfoLeft:CreateFontString(nil, "OVERLAY")
	Text:SetFont(C.media.pixelfont, C["datatext"].fontsize, "MONOCHROMEOUTLINE")
	T.PP(C["datatext"].guild, Text)

	local BASE_GP = 1
	local function ParseGuildInfo(info)
		BASE_GP = 1
		local v
		local lines = {string.split("\n", info)}
		for _,line in pairs(lines) do
			v = string.match(line,"@BASE_GP:(%d+)")
			if(v) then
				BASE_GP = v
				break
			end
		end
	end

	local displayString = string.join("", GUILD, ": ",T.panelcolor, "%d|r")

	local function Update(self, event, ...)	

		if (event=="ADDON_LOADED") then

			if USE_EPGP then
				ParseGuildInfo(GetGuildInfoText())
			end

		else
			if IsInGuild() then
				GuildRoster()
				local numOnline = (GetNumGuildMembers())
				local total = (GetNumGuildMembers())
				local numOnline = 0
				for i = 1, total do
					local _, _, _, _, _, _, _, _, online, _, _ = GetGuildRosterInfo(i)
					if online then
						numOnline = numOnline + 1
					end
				end 			

				Text:SetFormattedText(displayString, numOnline)
				self:SetAllPoints(Text)
			else
				Text:SetText(T.panelcolor..L.datatext_noguild)
			end
		end
	end

	local guildMenuFrame = nil

	function setGuildSort(self,fun)

		guildMenuFrame:Hide()
		sortGuildFunc = fun
	end	

	local guildMenuList = {
		{ text = "Select an Option", isTitle = true,notCheckable=true},
		{ text = "Invite", hasArrow = true,notCheckable=true,
			menuList = {
				{ text = "Option 3", func = function() print("You've chosen option 3"); end }
			}
		},
		{ text = "Whisper", hasArrow = true,notCheckable=true,
			menuList = {
				{ text = "Option 4", func = function() print("You've chosen option 4"); end }
			}
		},
		{ text = "Sort", hasArrow = true,notCheckable=true,
			menuList = {
				{ notCheckable=true,text = "Name", func = setGuildSort, arg1=sortGuildByName},
				{ notCheckable=true,text = "Zone", func = setGuildSort, arg1=sortGuildByZone},
				{ notCheckable=true,text = "Rank", func = setGuildSort, arg1=sortGuildByRank},
			}
		}
	}

	if USE_EPGP then

		function sortEPGP(a,b)
			if a.PR == b.PR then
				return a.name < b.name
			else
				return a.PR>b.PR
			end
		end

		guildMenuList[4].menuList[4] = { notCheckable=true,text = "EPGP (PR)", func = setGuildSort, arg1=sortEPGP}
	end

	function inviteFriendClick(self, arg1, arg2, checked)
		guildMenuFrame:Hide()
		InviteUnit(arg1)
	end

	function whisperFriendClick(self,arg1,arg2,checked)
		guildMenuFrame:Hide()
		SetItemRef( "player:"..arg1, ("|Hplayer:%1$s|h[%1$s]|h"):format(arg1), "LeftButton" )
	end

	local menuCountWhispers = 0
	local menuCountInvites = 0

	Stat:SetScript("OnMouseUp", function(self, btn)
		if btn == "RightButton" then
			GameTooltip:Hide()

			if(guildMenuFrame==nil) then
				guildMenuFrame = CreateFrame("Frame", "guildMenuFrame", nil, "UIDropDownMenuTemplate")
				guildMenuFrame.relativeTo = self
			else
				guildMenuFrame:Show()
			end			

			EasyMenu(guildMenuList, guildMenuFrame, "cursor", 0, 0, "MENU")
		end
	end)	

	local function EPGPDecodeNote(note)
	  if note then
		if note == "" then
		  return 0, 0
		else
		  local ep, gp = string.match(note, "^(%d+),(%d+)$")
		  if ep then
			return tonumber(ep), tonumber(gp)
		  end
		end
	  end
	end	

	Stat:RegisterEvent("ADDON_LOADED")
	Stat:RegisterEvent("GUILD_ROSTER_UPDATE")
	Stat:RegisterEvent("PLAYER_GUILD_UPDATE")
	Stat:RegisterEvent("GUILD_PERK_UPDATE")
	Stat:RegisterEvent("PLAYER_ENTERING_WORLD")
	Stat:RegisterEvent("CHAT_MSG_SYSTEM")
	Stat:SetScript("OnEnter", function(self)
		if not InCombatLockdown() or self.altdow then					

			if IsInGuild() then			

				menuCountWhispers = 0
				menuCountInvites = 0

				guildMenuList[2].menuList = {}
				guildMenuList[3].menuList = {}

				colors = {
					note = { .14, .76, .15 },
					officerNote = { 1, .56, .25 }
				}	

				local r,g,b = unpack(colors.officerNote)
				local officerColor = ("\124cff%.2x%.2x%.2x"):format( r*255, g*255, b*255 )
				r,g,b = unpack(colors.note)
				local noteColor = ("\124cff%.2x%.2x%.2x"):format( r*255, g*255, b*255 )

				self.hovered = true
				GuildRoster()
				local name, rank,rankIndex, level, zone, note, officernote, EP,GP,PR, connected, status, class, zone_r, zone_g, zone_b, classc, levelc,grouped
				local online, total, gmotd = 0, GetNumGuildMembers(true), GetGuildRosterMOTD()
				for i = 0, total do if select(9, GetGuildRosterInfo(i)) then online = online + 1 end end

				GameTooltip:SetOwner(self, "ANCHOR_TOP", 0,T.Scale(6));
				GameTooltip:ClearAllPoints()
				--GameTooltip:SetPoint("BOTTOM", self, "TOP", 0,T.mult)
				GameTooltip:ClearLines()
				GameTooltip:AddDoubleLine(GetGuildInfo'player',format("%s: %d/%d",GUILD,online,total),tthead.r,tthead.g,tthead.b,tthead.r,tthead.g,tthead.b)
				GameTooltip:AddLine' '
				if gmotd ~= "" then GameTooltip:AddLine(format("  %s |cffaaaaaa- |cffffffff%s",GUILD_MOTD,gmotd),ttsubh.r,ttsubh.g,ttsubh.b,1) end
				if online > 1 then
					GameTooltip:AddLine' '
					sortable = {}
					for i = 1, total do
						tabletemp = {}
						tabletemp.index=i
						tabletemp.name, tabletemp.rank, tabletemp.rankIndex , tabletemp.level, _, tabletemp.zone, tabletemp.note, tabletemp.officernote, tabletemp.connected, tabletemp.status, tabletemp.class = GetGuildRosterInfo(i)

						if tabletemp.zone==nil then
							tabletemp.zone = "Unknow Zone"
						end

						if USE_EPGP then
							if tabletemp.officernote then
								tabletemp.EP,tabletemp.GP = EPGPDecodeNote(tabletemp.officernote)
								if(tabletemp.EP) then

									tabletemp.GP = tabletemp.GP + BASE_GP
									tabletemp.PR = tabletemp.EP / tabletemp.GP
									tabletemp.officernote = format("EP: %d GP: %d PR:%.2f",tabletemp.EP,tabletemp.GP,tabletemp.PR)
								else
									tabletemp.EP = 0
									tabletemp.GP = 0
									tabletemp.PR = -1
								end
							end
						end

						if tabletemp.connected~=nil and tabletemp.connected==1 then
							table.insert(sortable,tabletemp)
						end

					end

					table.sort(sortable,sortGuildFunc)

					for i,v in ipairs(sortable) do
						if online <= 1 then
							if online > 1 then GameTooltip:AddLine(format("+ %d More...", online - modules.Guild.maxguild),ttsubh.r,ttsubh.g,ttsubh.b) end
							break
						end						

						name = v.name
						rank = v.rank
						rankIndex = v.rankIndex
						level = v.level
						zone = v.zone
						note = v.note
						officernote = v.officernote
						connected = v.connected
						status = v.status
						class = v.class

						if connected then

							if GetRealZoneText() == zone then zone_r, zone_g, zone_b = 0.3, 1.0, 0.3 else zone_r, zone_g, zone_b = 0.65, 0.65, 0.65 end
							classc, levelc = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[class], GetQuestDifficultyColor(level)

							notes = format(" %s%s",noteColor,note)
							if officernote ~= "" then
								notes = notes .. format(" %s%s",officerColor,officernote)
							end
							rank = noteColor..rank

							if (UnitInParty(name) or UnitInRaid(name)) and (name ~= UnitName'player') then
								grouped = "|cffaaaaaa*|r"
							else
								grouped = ""
								if name ~= UnitName'player' then
									menuCountInvites = menuCountInvites +1
									guildMenuList[2].menuList[menuCountInvites] = {text = format("|cff%02x%02x%02x%d|r |cff%02x%02x%02x%s|r",levelc.r*255,levelc.g*255,levelc.b*255,level,classc.r*255,classc.g*255,classc.b*255,name), arg1 = name,notCheckable=true, func = inviteFriendClick}
								end
							end

							GameTooltip:AddDoubleLine(format("|cff%02x%02x%02x%d|r %s%s%s%s",levelc.r*255,levelc.g*255,levelc.b*255,level,name,grouped,notes,' '..status),zone.." "..rank,classc.r,classc.g,classc.b,zone_r,zone_g,zone_b)

							if name ~= UnitName'player' then
								menuCountWhispers = menuCountWhispers + 1

								guildMenuList[3].menuList[menuCountWhispers] = {text = format("|cff%02x%02x%02x%d|r |cff%02x%02x%02x%s|r",levelc.r*255,levelc.g*255,levelc.b*255,level,classc.r*255,classc.g*255,classc.b*255,name), arg1 = name,notCheckable=true, func = whisperFriendClick}
							end

						end
					end
				end
				GameTooltip:Show()
			end
		end
	end)
	Stat:SetScript("OnLeave", function() GameTooltip:Hide() end)
	Stat:SetScript("OnMouseDown", function(self, btn)
		if btn == "LeftButton" then
			if not GuildFrame and IsInGuild() then LoadAddOn("Blizzard_GuildUI") end GuildFrame_Toggle() end
		end)
	Stat:SetScript("OnEvent", Update)
end