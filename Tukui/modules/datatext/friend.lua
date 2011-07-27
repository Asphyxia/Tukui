--------------------------------------------------------------------
-- FRIEND
--------------------------------------------------------------------
local T, C, L = unpack(select(2, ...)) -- Import Functions/Constants, Config, Locales

if not C["datatext"].friends or C["datatext"].friends == 0 then return end

	StaticPopupDialogs.SET_BN_BROADCAST = {
		text = BN_BROADCAST_TOOLTIP,
		button1 = ACCEPT,
		button2 = CANCEL,
		hasEditBox = 1,
		editBoxWidth = 350,
		maxLetters = 127,
		OnAccept = function(self) BNSetCustomMessage(self.editBox:GetText()) end,
		OnShow = function(self) self.editBox:SetText( select(3, BNGetInfo()) ) self.editBox:SetFocus() end,
		OnHide = ChatEdit_FocusActiveWindow,
		EditBoxOnEnterPressed = function(self) BNSetCustomMessage(self:GetText()) self:GetParent():Hide() end,
		EditBoxOnEscapePressed = function(self) self:GetParent():Hide() end,
		timeout = 0,
		exclusive = 1,
		whileDead = 1,
		hideOnEscape = 1
	}

	local MAX_BROADCAST_LEN = 40

	function sortName(a,b)
		if a.client == "friend" then
			texta = a.name
			textb = b.name
		else
			texta = a.client..string.format("%02d",a.index)
			textb = b.client..string.format("%02d",b.index)
		end
		return texta<textb
	end

	function sortZone(a,b)

		if a.client == "friend" then
			texta = a.zone..a.name
			textb = b.zone..b.name

		else
			texta = a.client..a.realmName..a.zoneName..string.format("%02d",a.index)
			textb = a.client..a.realmName..b.zoneName..string.format("%02d",a.index)
		end		

		return texta<textb
	end

	sortFunc = sortName

	local Stat = CreateFrame("Frame")
	Stat:EnableMouse(true)
	Stat:SetFrameStrata("BACKGROUND")
	Stat:SetFrameLevel(3)

	local tthead = {r=0.4,g=0.78,b=1}
	local ttsubh = {r=0.75,g=0.9,b=1}

	local Text  = TukuiInfoLeft:CreateFontString(nil, "OVERLAY")
	Text:SetFont(C.media.pixelfont, C["datatext"].fontsize, "MONOCHROMEOUTLINE")
	T.PP(C["datatext"].friends, Text)

	local friendMenuFrame = nil

	function setFriendSort(self,fun)
		friendMenuFrame:Hide()
		sortFunc = fun
	end	

	local friendMenuList = {
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
				{ notCheckable=true,text = "Name", func = setFriendSort, arg1=sortName},
				{ notCheckable=true,text = "Zone", func = setFriendSort, arg1=sortZone},
			}
		},
		{ text = "Battle.Net", hasArrow = true,notCheckable=true,
			menuList = {
				{ text = "Set Broadcast", notCheckable=true, func = function()
					friendMenuFrame:Hide()
					StaticPopup_Show"SET_BN_BROADCAST"
				end }
			}
		},
	}

	function inviteClick(self, arg1, arg2, checked)
		friendMenuFrame:Hide()
		InviteUnit(arg1)
	end

	function whisperClick(self,arg1,arg2,checked)
		friendMenuFrame:Hide()

		SetItemRef( "player:"..arg1, ("|Hplayer:%1$s|h[%1$s]|h"):format(arg1), "LeftButton" )		

	end

	local menuCountWhispers = 0
	local menuCountInvites = 0

	Stat:SetScript("OnMouseUp", function(self, btn)
		if btn == "RightButton" then
			GameTooltip:Hide()
			if(friendMenuFrame==nil) then
				friendMenuFrame = CreateFrame("Frame", "friendMenuFrame", nil, "UIDropDownMenuTemplate")
				friendMenuFrame.relativeTo = self
			else
				friendMenuFrame:Show()
			end

			EasyMenu(friendMenuList, friendMenuFrame, "cursor", 0, 0, "MENU")
		end
	end)
	local displayString = string.join("", "%s: ", T.panelcolor, "%d|r")
	--local displayString = string.join("", T.panelcolor, "%s|r: ", "%d")

	local function Update(self, event)
			local online, total = 0, GetNumFriends()
			local BNonline, BNtotal = 0, BNGetNumFriends()
			for i = 0, total do if select(5, GetFriendInfo(i)) then online = online + 1 end end
			if BNtotal > 0 then
				for i = 1, BNtotal do if select(7, BNGetFriendInfo(i)) then BNonline = BNonline + 1 end end
			end
			local totalonline = online + BNonline
			Text:SetFormattedText(displayString, L.datatext_friends, totalonline)
			self:SetAllPoints(Text)
	end

	Stat:RegisterEvent("FRIENDLIST_SHOW")
	Stat:RegisterEvent("FRIENDLIST_UPDATE")
	Stat:RegisterEvent("MUTELIST_UPDATE")
	Stat:RegisterEvent("WHO_LIST_UPDATE")
	Stat:RegisterEvent("PLAYER_FLAGS_CHANGED")
	Stat:RegisterEvent("BN_FRIEND_LIST_SIZE_CHANGED")
	Stat:RegisterEvent("BN_FRIEND_INFO_CHANGED")
	Stat:RegisterEvent("BN_FRIEND_INVITE_LIST_INITIALIZED")
	Stat:RegisterEvent("BN_FRIEND_INVITE_ADDED")
	Stat:RegisterEvent("BN_FRIEND_INVITE_REMOVED")
	Stat:RegisterEvent("BN_SELF_ONLINE")
	Stat:RegisterEvent("BN_BLOCK_LIST_UPDATED")
	Stat:RegisterEvent("PLAYER_ENTERING_WORLD")
	Stat:RegisterEvent("BN_CONNECTED")
	Stat:RegisterEvent("BN_DISCONNECTED")
	Stat:RegisterEvent("CHAT_MSG_SYSTEM")
	Stat:SetScript("OnMouseDown", function(self, btn)
		if btn == "LeftButton" then
			ToggleFriendsFrame(1)
		end
	end)

	Stat:SetScript("OnEnter", function(self)
		if not InCombatLockdown() or (InCombatLockdown() and C["tooltip"].hidecombat ~= true) then
			ShowFriends()
			menuCountWhispers = 0
			menuCountInvites = 0
			friendMenuList[2].menuList = {}
			friendMenuList[3].menuList = {}
			self.hovered = true
			local online, total = 0, GetNumFriends()
			local name, level, class, zone, connected, status, note, classc, levelc, zone_r, zone_g, zone_b, grouped
			for i = 0, total do if select(5, GetFriendInfo(i)) then online = online + 1 end end
			local BNonline, BNtotal = 0, BNGetNumFriends()
			local presenceID, givenName, surname, toonName, toonID, client, isOnline
			if BNtotal > 0 then
				for i = 1, BNtotal do if select(7, BNGetFriendInfo(i)) then BNonline = BNonline + 1 end end
			end
			local totalonline = online + BNonline
			local totalfriends = total + BNtotal					

			if online > 0 or BNonline > 0 then
				local anchor, panel, xoff, yoff = T.DataTextTooltipAnchor(Text)
				GameTooltip:SetOwner(panel, anchor, xoff, yoff)
				GameTooltip:ClearAllPoints()
				GameTooltip:ClearLines()
				GameTooltip:AddDoubleLine(L.datatext_friendlist, format("%s/%s",totalonline,totalfriends),tthead.r,tthead.g,tthead.b,tthead.r,tthead.g,tthead.b)

				broadcast = select(3, BNGetInfo())
				if broadcast ~= "" or broadcast ~= nil then GameTooltip:AddLine(format("  %s |cffaaaaaa- |cffffffff%s","Broadcast:",broadcast),ttsubh.r,ttsubh.g,ttsubh.b,1) end

				if online > 0 then
					GameTooltip:AddLine' '
					GameTooltip:AddLine("World of Warcraft")
					-- name, level, class, area, connected, status, note
					sortable = {}
					for i = 1, total do
						tabletemp = {}
						tabletemp.index=i
						tabletemp.name, tabletemp.level, tabletemp.class, tabletemp.zone, tabletemp.connected, tabletemp.status, tabletemp.note = GetFriendInfo(i)
						tabletemp.client = "friend"
						if tabletemp.connected~=nil and tabletemp.connected==1 then
							table.insert(sortable,tabletemp)
						end
					end
					table.sort(sortable,sortFunc)

					for i,v in ipairs(sortable) do

						name = v.name
						level = v.level
						class = v.class
						zone = v.zone
						connected = v.connected
						status = v.status
						note = v.note						

						--if not connected then break end
						if GetRealZoneText() == zone then zone_r, zone_g, zone_b = 0.3, 1.0, 0.3 else zone_r, zone_g, zone_b = 0.65, 0.65, 0.65 end
						for k,v in pairs(LOCALIZED_CLASS_NAMES_MALE) do if class == v then class = k end end
						if GetLocale() ~= "enUS" then -- feminine class localization (unsure if it's really needed)
							for k,v in pairs(LOCALIZED_CLASS_NAMES_FEMALE) do if class == v then class = k end end
						end
						classc, levelc = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[class], GetQuestDifficultyColor(level)
						if UnitInParty(name) or UnitInRaid(name) then grouped = "|cffaaaaaa*|r" else grouped = "" end
						GameTooltip:AddDoubleLine(format("|cff%02x%02x%02x%d|r %s%s%s",levelc.r*255,levelc.g*255,levelc.b*255,level,name,grouped," "..status),zone,classc.r,classc.g,classc.b,zone_r,zone_g,zone_b)
						if self.altdown and note then GameTooltip:AddLine("  "..note,ttsubh.r,ttsubh.g,ttsubh.b,1) end

						menuCountInvites = menuCountInvites + 1
						menuCountWhispers = menuCountWhispers + 1

						friendMenuList[2].menuList[menuCountInvites] = {text = format("|cff%02x%02x%02x%d|r |cff%02x%02x%02x%s|r",levelc.r*255,levelc.g*255,levelc.b*255,level,classc.r*255,classc.g*255,classc.b*255,name), arg1 = name,notCheckable=true, func = inviteClick}
						friendMenuList[3].menuList[menuCountWhispers] = {text = format("|cff%02x%02x%02x%d|r |cff%02x%02x%02x%s|r",levelc.r*255,levelc.g*255,levelc.b*255,level,classc.r*255,classc.g*255,classc.b*255,name), arg1 = name,notCheckable=true, func = whisperClick}

					end
				end
				if BNonline > 0 then
					colors = {
						name = { .14, .76, .15 },
						note = { 1, .56, .25 }
					}
					local r,g,b = unpack(colors.name)
					local nameColor = ("\124cff%.2x%.2x%.2x"):format( r*255, g*255, b*255 )
					r,g,b = unpack(colors.note)
					local noteColor = ("\124cff%.2x%.2x%.2x"):format( r*255, g*255, b*255 )
					local factionColor = ""

					GameTooltip:AddLine' '
					GameTooltip:AddLine("Battle.net")
					local playerRealm = GetRealmName()
					local playerZone = GetRealZoneText()

					local playerFaction,localeFaction= UnitFactionGroup("player")
					if (playerFaction == "Horde") then
						playerFaction = 0
					else
						playerFaction = 1
					end					

					sortable = {}
					for i = 1, BNtotal do
						tabletemp = {}
						tabletemp.index=i
						tabletemp.presenceID, tabletemp.givenName, tabletemp.surname, tabletemp.toonName, tabletemp.toonID, tabletemp.client, tabletemp.isOnline,tabletemp.lastOnline, tabletemp.isAFK, tabletemp.isDND, tabletemp.broadcast, tabletemp.note = BNGetFriendInfo(i)
						tabletemp.realID = (BATTLENET_NAME_FORMAT):format(tabletemp.givenName, tabletemp.surname)
						if tabletemp.broadcast~=nil and (string.len(tabletemp.broadcast)>MAX_BROADCAST_LEN) then
							tabletemp.broadcast = string.sub(tabletemp.broadcast,1,MAX_BROADCAST_LEN-3).."..."
						end
						if tabletemp.isOnline then		

							if tabletemp.client == "WoW" then
								tabletemp.hasFocus, tabletemp.toonName, tabletemp.client, tabletemp.realmName, tabletemp.faction, tabletemp.race, _, tabletemp.class, tabletemp.guild, tabletemp.zoneName, tabletemp.level = BNGetToonInfo(tabletemp.toonID)
							else
								tabletemp.zoneName = ""
								tabletemp.realmName = ""
							end

							table.insert(sortable,tabletemp)
						end
					end

					table.sort(sortable,sortFunc)

					for i,v in ipairs(sortable) do

						presenceID = v.presenceID
						givenName = v.givenName
						surname = v.surname
						toonName = v.toonName
						toonID = v.toonID
						client = v.client
						isOnline = v.isOnline
						lastOnline = v.lastOnline
						isAFK = v.isAFK
						isDND = v.isDND
						broadcast = v.broadcast
						note  = v.note
						realID = v.realID

						menuCountWhispers = menuCountWhispers + 1																		

						if client == "WoW" then						

							hasFocus = v.hasFocus
							toonName = v.toonName
							client = v.client
							realmName = v.realmName
							faction = v.faction
							race = v.race
							class = v.class
							guild = v.guild
							zoneName = v.zoneName
							level = v.level

							for k,v in pairs(LOCALIZED_CLASS_NAMES_MALE) do if class == v then class = k end end
							if GetLocale() ~= "enUS" then -- feminine class localization (unsure if it's really needed)
								for k,v in pairs(LOCALIZED_CLASS_NAMES_FEMALE) do if class == v then class = k end end
							end
							classc, levelc = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[class], GetQuestDifficultyColor(level)
							if classc == nil then classc = GetQuestDifficultyColor(level) end
							if note ~= nil then
								notes = format(" %s%s",noteColor,note)
							else
								notes = ""
							end
							if isAFK then
								status = "|cffff0000[AFK]|r"
							elseif isDND then
								status = "|cffff0000[DND]|r"
							else
								status = ""
							end
							if faction == 0 then
								factionColor = "|cffff0000 H|r"
							else
								factionColor = "|cff00ffff A|r"
							end	

							zone_r, zone_g, zone_b = 0.65, 0.65, 0.65

							if playerRealm == realmName then
								if playerZone == zoneName then
									zone_r, zone_g, zone_b = 0.3, 1.0, 0.3
								end
							end

							grouped = ""
							if playerRealm == realmName then
								if playerFaction == faction then
										if UnitInParty(toonName) or UnitInRaid(toonName) then
											grouped = "|cffaaaaaa*|r"
										else
											grouped = ""
											menuCountInvites = menuCountInvites + 1
											friendMenuList[2].menuList[menuCountInvites] = {text = format("|cff%02x%02x%02x%d|r |cff%02x%02x%02x%s|r%s",levelc.r*255,levelc.g*255,levelc.b*255,level,classc.r*255,classc.g*255,classc.b*255,toonName,notes), arg1 = toonName,notCheckable=true, func = inviteClick}
										end
								end
							end							

							GameTooltip:AddDoubleLine(format("|cff%02x%02x%02x%d|r %s%s %s %s%s%s",levelc.r*255,levelc.g*255,levelc.b*255,level,toonName,grouped,nameColor,realID,notes,' '..status),zoneName.." - "..realmName.." "..factionColor,classc.r,classc.g,classc.b,zone_r,zone_g,zone_b)
							if broadcast ~= '' then
								GameTooltip:AddLine("            "..broadcast)
							end

							friendMenuList[3].menuList[menuCountWhispers] = {text = nameColor..realID..notes, arg1 = realID,notCheckable=true, func = whisperClick}
						else
							friendMenuList[3].menuList[menuCountWhispers] = {text = nameColor..realID, arg1 = realID,notCheckable=true, func = whisperClick}
							GameTooltip:AddDoubleLine("|cffeeeeee"..client.." ("..toonName..")|r", "|cffeeeeee"..givenName.." "..surname.."|r")
						end
					end
				end
				GameTooltip:Show()
			else
				GameTooltip:Hide()
			end
		end
	end)

	Stat:SetScript("OnLeave", function() GameTooltip:Hide() end)
	Stat:SetScript("OnEvent", Update)
