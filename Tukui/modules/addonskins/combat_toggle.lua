local T, C, L = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales

if C.Addon_Skins.background then
	-- Addons Background (same size as right chat background)
	local bg = CreateFrame("Frame", "AddonBGPanel", UIParent)
	bg:CreatePanel("Default", TukuiChatBackgroundRight:GetWidth(), TukuiChatBackgroundRight:GetHeight(), "BOTTOMRIGHT", TukuiChatBackgroundRight, "BOTTOMRIGHT", 0, 0)
	bg:SetFrameStrata("MEDIUM")

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
				if IsAddOnLoaded("TinyDPS") then tdpsFrame:Hide() end
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
				if IsAddOnLoaded("TinyDPS") then tdpsFrame:Hide() end
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