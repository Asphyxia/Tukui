local T, C, L = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales

local ADDON_NAME, ns = ...
local oUF = ns.oUF or oUF

ns._Objects = {}
ns._Headers = {}

if not C["databars"].latency or C["databars"].latency == 0 then return end
local barNum = C["databars"].latency

T.databars[barNum]:Show()

local Stat = CreateFrame("Frame", nil, T.databars[barNum])
Stat:EnableMouse(true)
Stat:SetFrameStrata("BACKGROUND")
Stat:SetFrameLevel(4)

local StatusBar = T.databars[barNum].statusbar
local Text = T.databars[barNum].text

local int = 1
local function Update(self, t)
	int = int - t
	if int < 0 then
		local ms = select(3, GetNetStats())
		Text:SetText(ms..T.datacolor.." MS")
		StatusBar:SetMinMaxValues(0, 400)
		StatusBar:SetValue(ms)
		self:SetAllPoints(T.databars[barNum])	
		if ms > 75 then
			StatusBar:SetStatusBarColor( 30 / 255, 1, 30 / 255 , .8 )
		elseif ms > 35 then
			StatusBar:SetStatusBarColor( 1, 180 / 255, 0, .8 )
		else
			StatusBar:SetStatusBarColor( 1, 75 / 255, 75 / 255, 0.5, .8 )
		end
		int = 1
	end	
end
Stat:SetScript("OnUpdate", Update)
Update(Stat, 10)

Stat:SetScript("OnEnter", function(self)
	if not InCombatLockdown() then
		local xoff, yoff = T.DataBarTooltipAnchor(barNum)
		GameTooltip:SetOwner(T.databars[barNum], "ANCHOR_BOTTOMRIGHT", xoff, yoff)
	
		local _, _, latencyHome, latencyWorld = GetNetStats()
		local latency = format(MAINMENUBAR_LATENCY_LABEL, latencyHome, latencyWorld)
		GameTooltip:ClearLines()
		GameTooltip:AddLine(latency)
		GameTooltip:Show()
	end
end)	
Stat:SetScript("OnLeave", function() GameTooltip:Hide() end)
