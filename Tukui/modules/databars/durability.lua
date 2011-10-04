local T, C, L = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales

local ADDON_NAME, ns = ...
local oUF = ns.oUF or oUF

ns._Objects = {}
ns._Headers = {}

if not C["databars"].durability or C["databars"].durability == 0 then return end
local barNum = C["databars"].durability

T.databars[barNum]:Show()

local Stat = CreateFrame("Frame", nil, T.databars[barNum])
Stat:EnableMouse(true)
Stat:SetFrameStrata("BACKGROUND")
Stat:SetFrameLevel(4)

local StatusBar = T.databars[barNum].statusbar
local Text = T.databars[barNum].text

local Total = 0
local current, max

local function OnEvent(self)
	for i = 1, 11 do
		if GetInventoryItemLink("player", L.Slots[i][1]) ~= nil then
			current, max = GetInventoryItemDurability(L.Slots[i][1])
			if current then 
				L.Slots[i][3] = current/max
				Total = Total + 1
			end
		end
	end
	table.sort(L.Slots, function(a, b) return a[3] < b[3] end)
	
	if Total > 0 then
		local r, g, b
		r, g, b = oUF.ColorGradient(floor(L.Slots[1][3]*100)/100, 0.8,0.2,0.2, 0.8,0.8,0.2, 0.2,0.8,0.2)
		Text:SetText(floor(L.Slots[1][3]*100).."% "..T.datacolor..L.datatext_armor)
		StatusBar:SetStatusBarColor(r,g,b)
		StatusBar:SetMinMaxValues(0, 100)
		StatusBar:SetValue(floor(L.Slots[1][3]*100))
	else
		StatusBar:SetStatusBarColor(.2, .8, .2)
		Text:SetText(L.datatext_armor)
	end
	-- Setup Durability Tooltip
	self:SetAllPoints(T.databars[barNum])
	Total = 0
end

Stat:RegisterEvent("UPDATE_INVENTORY_DURABILITY")
Stat:RegisterEvent("MERCHANT_SHOW")
Stat:RegisterEvent("PLAYER_ENTERING_WORLD")
Stat:SetScript("OnMouseDown", function() ToggleCharacter("PaperDollFrame") end)
Stat:SetScript("OnEvent", OnEvent)
Stat:SetScript("OnEnter", function(self)
	if not InCombatLockdown() then
		local xoff, yoff = T.DataBarTooltipAnchor(barNum)
		GameTooltip:SetOwner(T.databars[barNum], "ANCHOR_BOTTOMRIGHT", xoff, yoff)
		
		GameTooltip:ClearLines()
		for i = 1, 11 do
			if L.Slots[i][3] ~= 1000 then
				green = L.Slots[i][3]*2
				red = 1 - green
				GameTooltip:AddDoubleLine(L.Slots[i][2], floor(L.Slots[i][3]*100).."%",1 ,1 , 1, red + 1, green, 0)
			end
		end
		GameTooltip:Show()
	end
end)
Stat:SetScript("OnLeave", function() GameTooltip:Hide() end)