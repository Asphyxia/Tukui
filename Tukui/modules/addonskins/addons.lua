local T, C, L = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales

if C.Addon_Skins.background then
	-- Addons Background (same size as right chat background)
	local bg = CreateFrame("Frame", "AddonBGPanel", UIParent)
	bg:CreatePanel("Default", T.InfoLeftRightWidth + 12, 177, "BOTTOM", TukuiInfoRight, "BOTTOM", 0, -6)
	bg:SetFrameStrata("MEDIUM")

	local bgtab = CreateFrame("Frame", nil, bg)
	bgtab:CreatePanel("Default", 1, 17, "TOPLEFT", bg, "TOPLEFT", 0, 0)
	bgtab:Point("TOPRIGHT", bg, "TOPRIGHT", 0, 0)
	bgtab:SetFrameStrata("MEDIUM")
	
	if C.chat.rightchatbackground then
		-- Use Chatsize if there is the rightchatbackground
		bg:ClearAllPoints()
		bg:Point("TOPLEFT", _G["ChatFrame"..C.chat.rightchatnumber], "TOPLEFT", -5, 29)
		bg:Point("BOTTOMRIGHT", _G["ChatFrame"..C.chat.rightchatnumber], "BOTTOMRIGHT", 5, -5)

		bgtab:ClearAllPoints()
		bgtab:Point("TOPLEFT", bg, "TOPLEFT", 5, -5)
		bgtab:Point("TOPRIGHT", bg, "TOPRIGHT", -28, -5)
		
		local bgc = CreateFrame("Frame", nil, bgtab)
		bgc:CreatePanel("Transparent", 20, 20, "LEFT", bgtab, "RIGHT", 3, 0)
		bgc:CreateShadow("Default")
		bgc:SetFrameStrata("HIGH")
		bgc:SetFrameLevel(10)
		
		bgc.t = bgc:CreateFontString(nil, "OVERLAY")
		bgc.t:SetPoint("CENTER")
		bgc.t:SetFont(C.media.pixelfont, C["datatext"].fontsize, "MONOCHROMEOUTLINE")
		bgc.t:SetText(T.panelcolor.."T")
		
		bgc:SetScript("OnEnter", function() bgc.t:SetText("T") end)
		bgc:SetScript("OnLeave", function() bgc.t:SetText(T.panelcolor.."T") end)
			
		bgc:SetScript("OnMouseDown", function(self) 
			ChatBG2:Show() 
			_G["ChatFrame"..C.chat.rightchatnumber]:Show()
			_G["ChatFrame"..C.chat.rightchatnumber.."Tab"]:Show()
			bg:Hide()
			if IsAddOnLoaded("Recount") then Recount_MainWindow:Hide() end
			if IsAddOnLoaded("Omen") then OmenAnchor:Hide() end
			if IsAddOnLoaded("Skada") then Skada:SetActive(false) end
		end)
	end

	-- toggle in-/outfight (NOTE: This will only toggle ChatFrameX (chat config))
	bg:RegisterEvent("PLAYER_ENTERING_WORLD")
	bg:RegisterEvent("PLAYER_LOGIN")
	if C.Addon_Skins.combat_toggle then
		bg:RegisterEvent("PLAYER_REGEN_ENABLED")
		bg:RegisterEvent("PLAYER_REGEN_DISABLED")
	end
	bg:SetScript("OnEvent", function(self, event)
		if C.chat.rightchatbackground or C.Addon_Skins.combat_toggle then
			if event == "PLAYER_LOGIN" then
				-- Hide
				bg:Hide()
				if IsAddOnLoaded("Recount") then Recount_MainWindow:Hide() end
				if IsAddOnLoaded("Omen") then OmenAnchor:Hide() end
				if IsAddOnLoaded("Skada") then Skada:SetActive(false) end
				if ChatBG2 then ChatBG2:Show() end
				_G["ChatFrame"..C.chat.rightchatnumber]:Show()
				_G["ChatFrame"..C.chat.rightchatnumber.."Tab"]:Show()
			elseif event == "PLAYER_ENTERING_WORLD" then
				-- yeah set all chats for ChatFrameX again cause we lose them after /rl when chat is hidden ..dunno how to prevent this atm
				-- ChatFrame_RemoveAllMessageGroups(_G["ChatFrame"..C.chat.rightchatnumber])
				ChatFrame_AddChannel(_G["ChatFrame"..C.chat.rightchatnumber], L.chat_trade)
				ChatFrame_AddMessageGroup(_G["ChatFrame"..C.chat.rightchatnumber], "COMBAT_XP_GAIN")
				ChatFrame_AddMessageGroup(_G["ChatFrame"..C.chat.rightchatnumber], "COMBAT_HONOR_GAIN")
				ChatFrame_AddMessageGroup(_G["ChatFrame"..C.chat.rightchatnumber], "COMBAT_FACTION_CHANGE")
				ChatFrame_AddMessageGroup(_G["ChatFrame"..C.chat.rightchatnumber], "LOOT")
				ChatFrame_AddMessageGroup(_G["ChatFrame"..C.chat.rightchatnumber], "MONEY")
				ChatFrame_AddMessageGroup(_G["ChatFrame"..C.chat.rightchatnumber], "SKILL")
			end
		end
		if C.Addon_Skins.combat_toggle then
			if event == "PLAYER_REGEN_ENABLED" then
				self:Hide()
				if ChatBG2 then ChatBG2:Show() end
				_G["ChatFrame"..C.chat.rightchatnumber]:Show()
				_G["ChatFrame"..C.chat.rightchatnumber.."Tab"]:Show()
				if IsAddOnLoaded("Recount") then Recount_MainWindow:Hide() end
				if IsAddOnLoaded("Omen") then OmenAnchor:Hide() end
				if IsAddOnLoaded("Skada") then Skada:SetActive(false) end
			elseif event == "PLAYER_REGEN_DISABLED" then
				self:Show()
				if ChatBG2 then ChatBG2:Hide() end
				_G["ChatFrame"..C.chat.rightchatnumber]:Hide()
				_G["ChatFrame"..C.chat.rightchatnumber.."Tab"]:Hide()
				if IsAddOnLoaded("Recount") then Recount_MainWindow:Show() end
				if IsAddOnLoaded("Omen") then OmenAnchor:Show() end
				if IsAddOnLoaded("Skada") then Skada:SetActive(true) end
			end
		end
	end)
end

-- Tiny CooldownToGo Skin (we dont need an config entry for that..)
if IsAddOnLoaded("CooldownToGo") then
	local iconborder = CreateFrame("Frame", nil, CooldownToGoFrame)
	iconborder:CreatePanel("",1,1,"TOPLEFT", CDTGIcon, "TOPLEFT", -2, 2)
	iconborder:Point("BOTTOMRIGHT", CDTGIcon, "BOTTOMRIGHT", 2, -2)
	CDTGIcon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	CDTGText:SetPoint("LEFT", CooldownToGoFrame, "CENTER", 3, 0)
end

if IsAddOnLoaded("spellstealer") then
	SSFrame:SetBackdrop({bgFile = "Interface\\Tooltips\\UI-Tooltip-Background"})
	SSFrame:SetBackdropColor(0,0,0,0)
	SSFrameList:SetBackdropColor(0,0,0,0)

	local sslist = CreateFrame("Frame", nil, SSFrameList)
	sslist:CreatePanel("", 1, 1, "TOPLEFT", SSFrameList, "TOPLEFT", -2, 2)
	sslist:Point("BOTTOMRIGHT", 2, -2)
	sslist:CreateShadow("")
	
	local ssframeb = CreateFrame("Frame", nil, sslist)
	ssframeb:CreatePanel("", 1, 16, "BOTTOMLEFT", sslist, "TOPLEFT", 0, 3)
	ssframeb:Point("BOTTOMRIGHT", sslist, "TOPRIGHT", 0, 3)
	ssframeb:CreateShadow("")
	
	SSFrametitletext:SetFont(C.media.pixelfont, C["datatext"].fontsize, "MONOCHROMEOUTLINE")
	SSFrametitletext:SetTextColor(unpack(C.datatext.color))
	SSFrameListText:SetFont(C.media.pixelfont, C["datatext"].fontsize, "MONOCHROMEOUTLINE")
	
	SSFrameListText:Point("LEFT", 2, 0)
	SSFrametitletext:ClearAllPoints()
	SSFrametitletext:Point("LEFT", ssframeb, "LEFT", 2, 0)
end