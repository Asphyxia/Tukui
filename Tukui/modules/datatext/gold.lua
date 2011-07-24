local T, C, L = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales
--------------------------------------------------------------------
-- GOLD
--------------------------------------------------------------------

if C["datatext"].gold and C["datatext"].gold > 0 then
	local Stat = CreateFrame("Frame")
	Stat:EnableMouse(true)
	Stat:SetFrameStrata("BACKGROUND")
	Stat:SetFrameLevel(3)

	local Text  = TukuiInfoLeft:CreateFontString(nil, "OVERLAY")
	Text:SetFont(C.media.pixelfont, C["datatext"].fontsize, "MONOCHROMEOUTLINE")
	T.PP(C["datatext"].gold, Text)

	local COPPER_ICON = "|TInterface\\MONEYFRAME\\UI-CopperIcon:0:0:0:-1|t"
	local SILVER_ICON = "|TInterface\\MONEYFRAME\\UI-SilverIcon:0:0:0:-1|t"
	local GOLD_ICON = "|TInterface\\MONEYFRAME\\UI-GoldIcon:0:0:0:-1|t"
	local Profit	= 0
	local Spent		= 0
	local OldMoney	= 0
	local myPlayerRealm = GetCVar("realmName");

	local function formatMoney(money)
		local gold = floor(math.abs(money) / 10000)
		local silver = mod(floor(math.abs(money) / 100), 100)
		local copper = mod(floor(math.abs(money)), 100)
		if gold ~= 0 then
			return format("%s"..GOLD_ICON.." %s"..SILVER_ICON.." %s"..COPPER_ICON, gold, silver, copper)
		elseif silver ~= 0 then
			return format("%s"..SILVER_ICON.." %s"..COPPER_ICON, silver, copper)
		else
			return format("%s"..COPPER_ICON, copper)
		end
	end

	local function FormatTooltipMoney(money)
		local gold, silver, copper = abs(money / 10000), abs(mod(money / 100, 100)), abs(mod(money, 100))
		local cash = ""
		cash = format("%.2d"..GOLD_ICON.." %.2d"..SILVER_ICON.." %.2d"..COPPER_ICON, gold, silver, copper)		
		return cash
	end	

	local function OnEvent(self, event)
		if event == "PLAYER_ENTERING_WORLD" then
			OldMoney = GetMoney()
		end
		
		local NewMoney	= GetMoney()
		local Change = NewMoney-OldMoney -- Positive if we gain money
		
		if OldMoney>NewMoney then		-- Lost Money
			Spent = Spent - Change
		else							-- Gained Moeny
			Profit = Profit + Change
		end
		
		Text:SetText(formatMoney(NewMoney))
		-- Setup Money Tooltip
		self:SetAllPoints(Text)

		local myPlayerName  = UnitName("player");				
		if (TukuiData == nil) then TukuiData = {}; end
		if (TukuiData.gold == nil) then TukuiData.gold = {}; end
		if (TukuiData.gold[myPlayerRealm]==nil) then TukuiData.gold[myPlayerRealm]={}; end
		TukuiData.gold[myPlayerRealm][myPlayerName] = GetMoney();
				
		OldMoney = NewMoney
	end

	Stat:RegisterEvent("PLAYER_MONEY")
	Stat:RegisterEvent("SEND_MAIL_MONEY_CHANGED")
	Stat:RegisterEvent("SEND_MAIL_COD_CHANGED")
	Stat:RegisterEvent("PLAYER_TRADE_MONEY")
	Stat:RegisterEvent("TRADE_MONEY_CHANGED")
	Stat:RegisterEvent("PLAYER_ENTERING_WORLD")
	Stat:SetScript("OnMouseDown", function() ToggleAllBags() end)
	Stat:SetScript("OnEvent", OnEvent)
	Stat:SetScript("OnEnter", function(self)
		if not InCombatLockdown() then
			local anchor, panel, xoff, yoff = T.DataTextTooltipAnchor(Text)
			GameTooltip:SetOwner(panel, anchor, xoff, yoff)
			GameTooltip:ClearLines()
			GameTooltip:AddLine(L.datatext_session)
			GameTooltip:AddDoubleLine(L.datatext_earned, formatMoney(Profit), 1, 1, 1, 1, 1, 1)
			GameTooltip:AddDoubleLine(L.datatext_spent, formatMoney(Spent), 1, 1, 1, 1, 1, 1)
			if Profit < Spent then
				GameTooltip:AddDoubleLine(L.datatext_deficit, formatMoney(Profit-Spent), 1, 0, 0, 1, 1, 1)
			elseif (Profit-Spent)>0 then
				GameTooltip:AddDoubleLine(L.datatext_profit, formatMoney(Profit-Spent), 0, 1, 0, 1, 1, 1)
			end				
			GameTooltip:AddLine' '								
		
			local totalGold = 0				
			GameTooltip:AddLine(L.datatext_character)			
			local thisRealmList = TukuiData.gold[myPlayerRealm];
			for k,v in pairs(thisRealmList) do
				GameTooltip:AddDoubleLine(k, FormatTooltipMoney(v), 1, 1, 1, 1, 1, 1)
				totalGold=totalGold+v;
			end 
			GameTooltip:AddLine' '
			GameTooltip:AddLine(L.datatext_server)
			GameTooltip:AddDoubleLine(L.datatext_totalgold, FormatTooltipMoney(totalGold), 1, 1, 1, 1, 1, 1)

			for i = 1, GetNumWatchedTokens() do
				local name, count, extraCurrencyType, icon, itemID = GetBackpackCurrencyInfo(i)
				if name and i == 1 then
					GameTooltip:AddLine(" ")
					GameTooltip:AddLine(CURRENCY)
				end
				local r, g, b = 1,1,1
				if itemID then r, g, b = GetItemQualityColor(select(3, GetItemInfo(itemID))) end
				if name and count then GameTooltip:AddDoubleLine(name, count, r, g, b, 1, 1, 1) end
			end
			GameTooltip:Show()
		end
	end)
	Stat:SetScript("OnLeave", function() GameTooltip:Hide() end)	
	-- reset gold data
	local function RESETGOLD()
		local myPlayerRealm = GetCVar("realmName");
		local myPlayerName  = UnitName("player");
		
		TukuiData.gold = {}
		TukuiData.gold[myPlayerRealm]={}
		TukuiData.gold[myPlayerRealm][myPlayerName] = GetMoney();
	end
	SLASH_RESETGOLD1 = "/resetgold"
	SlashCmdList["RESETGOLD"] = RESETGOLD
end