﻿local T, C, L = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales

----------------------------------------------------------------------------------------
-- Grab mail in 1 button(OpenAll by Kemayo)
----------------------------------------------------------------------------------------
local COPPER_ICON = "|TInterface\\MONEYFRAME\\UI-CopperIcon:0:0:0:-1|t"
local SILVER_ICON = "|TInterface\\MONEYFRAME\\UI-SilverIcon:0:0:0:-1|t"
local GOLD_ICON = "|TInterface\\MONEYFRAME\\UI-GoldIcon:0:0:0:-1|t"
local L_MAIL_STOPPED = ERR_INV_FULL
local L_MAIL_COMPLETE = DONE
local L_MAIL_NEED = L.mail_need
local L_MAIL_MESSAGES = L.mail_messages
local deletedelay, t = 0.5, 0
local takingOnlyCash = false
local button, button2, waitForMail, openAll, openAllCash, openMail, lastopened, stopOpening, onEvent, needsToWait, copper_to_pretty_money, total_cash
local _G = _G
local baseInboxFrame_OnClick

function openAll()
	if GetInboxNumItems() == 0 then return end
	button:SetScript("OnClick", nil)
	button2:SetScript("OnClick", nil)
	baseInboxFrame_OnClick = InboxFrame_OnClick
	InboxFrame_OnClick = function() end
	button:RegisterEvent("UI_ERROR_MESSAGE")
	openMail(GetInboxNumItems())
end

function openAllCash()
	takingOnlyCash = true
	openAll()
end

function openMail(index)
	if not InboxFrame:IsVisible() then return stopOpening("|cffffff00"..L_MAIL_NEED) end
	if index == 0 then MiniMapMailFrame:Hide() stopOpening("|cffffff00"..L_MAIL_COMPLETE) return end
	local _, _, _, _, money, COD, _, numItems = GetInboxHeaderInfo(index)
	if money > 0 then
		TakeInboxMoney(index)
		needsToWait = true
		if total_cash then total_cash = total_cash - money end
	elseif (not takingOnlyCash) and numItems and (numItems > 0) and COD <= 0 then
		TakeInboxItem(index)
		needsToWait = true
	end

	local items = GetInboxNumItems()
	if (numItems and numItems > 1) or (items > 1 and index <= items) then
		lastopened = index
		t = 0
		button:SetScript("OnUpdate", waitForMail)
	else
		stopOpening("|cffffff00"..L_MAIL_COMPLETE)
		MiniMapMailFrame:Hide()
		TukuiMinimap:SetBackdropBorderColor(unpack(C.media.bordercolor))
	end
end

function waitForMail(self,elapsed)
	t = t + elapsed
	if (not needsToWait) or (t > deletedelay) then
		needsToWait = false
		button:SetScript("OnUpdate", nil)
		local _, _, _, _, money, COD, _, numItems = GetInboxHeaderInfo(lastopened)
		if money > 0 or ((not takingOnlyCash) and COD <= 0 and numItems and (numItems > 0)) then
			openMail(lastopened)
		else
			openMail(lastopened - 1)
		end
	end
end

function stopOpening(msg, ...)
	button:SetScript("OnUpdate", nil)
	button:SetScript("OnClick", openAll)
	button2:SetScript("OnClick", openAllCash)
	if baseInboxFrame_OnClick then
		InboxFrame_OnClick = baseInboxFrame_OnClick
	end
	button:UnregisterEvent("UI_ERROR_MESSAGE")
	takingOnlyCash = false
	total_cash = nil
	if msg then DEFAULT_CHAT_FRAME:AddMessage(msg, ...) end
end

function onEvent(frame, event, arg1, arg2, arg3, arg4)
	if event == "UI_ERROR_MESSAGE" then
		if arg1 == ERR_INV_FULL then
			stopOpening("|cffffff00"..L_MAIL_STOPPED)
		end
	end
end

local function makeButton(id, text, w, h, x, y)
	local button = CreateFrame("Button", id, InboxFrame, "UIPanelButtonTemplate")
	button:SetWidth(w)
	button:SetHeight(h)
	button:SetPoint("CENTER", InboxFrame, "TOP", x, y)
	button:SetText(text)
	return button
end

button = makeButton("TakeAll_Button", ALL, 55, 25, -55, -408)
button:SetScript("OnClick", openAll)
button:SetScript("OnEvent", onEvent)
button2 = makeButton("TakeCash_Button", GUILDCONTROL_OPTION16, 85, 25, 18, -408)
button2:SetScript("OnClick", openAllCash)

button:SetScript("OnEnter", function()
	GameTooltip:SetOwner(button, "ANCHOR_RIGHT")
	GameTooltip:AddLine(string.format("%d "..L_MAIL_MESSAGES, GetInboxNumItems()), 1, 1, 1)
	GameTooltip:Show()
end)
button:SetScript("OnLeave", function() GameTooltip:Hide() end)

function copper_to_pretty_money(c)
	if c > 10000 then
		return ("%d|cffffd700"..GOLD_ICON.."|r %d|cffc7c7cf"..SILVER_ICON.."|r %d|cffeda55f"..COPPER_ICON.."|r"):format(c/10000, (c/100)%100, c%100)
	elseif c > 100 then
		return ("%d|cffc7c7cf"..SILVER_ICON.."|r %d|cffeda55f"..COPPER_ICON.."|r"):format((c/100)%100, c%100)
	else
		return ("%d|cffeda55f"..COPPER_ICON.."|r"):format(c%100)
	end
end

button2:SetScript("OnEnter", function()
	if not total_cash then
		total_cash = 0
		for index = 0, GetInboxNumItems() do
			total_cash = total_cash + select(5, GetInboxHeaderInfo(index))
		end
	end
	GameTooltip:SetOwner(button, "ANCHOR_RIGHT")
	GameTooltip:AddLine(copper_to_pretty_money(total_cash), 1, 1, 1)
	GameTooltip:Show()
end)

button2:SetScript("OnLeave", function() GameTooltip:Hide() end)