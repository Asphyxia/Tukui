--------------------------------------------------------------------
-- TIME
--------------------------------------------------------------------
local T, C, L = unpack(select(2, ...)) -- Import Functions/Constants, Config, Locales

if not C["datatext"].wowtime or C["datatext"].wowtime == 0 then return end

local europeDisplayFormat = string.join("", "%02d", T.panelcolor,":|r%02d")
local ukDisplayFormat = string.join("", "", "%d", T.panelcolor, ":|r%02d", T.panelcolor, " %s|r")
local timerLongFormat = "%d:%02d:%02d"
local timerShortFormat = "%d:%02d"
local lockoutInfoFormat = "%s |cffaaaaaa(%s%s, %s/%s)"
local formatBattleGroundInfo = "%s: "
local lockoutColorExtended, lockoutColorNormal = { r=0.3,g=1,b=0.3 }, { r=1,g=1,b=1 }
local difficultyInfo = { "N", "N", "H", "H" }
local curHr, curMin, curAmPm

local Stat = CreateFrame("Frame")
Stat:EnableMouse(true)
Stat:SetFrameStrata("MEDIUM")
Stat:SetFrameLevel(3)

local Text = Stat:CreateFontString(nil, "OVERLAY")
Text:SetFont(C.media.pixelfont, C["datatext"].fontsize, "MONOCHROMEOUTLINE")
T.PP(C["datatext"].wowtime, Text)

local APM = { TIMEMANAGER_PM, TIMEMANAGER_AM }

local function CalculateTimeValues(tt)
	if tt == nil then tt = false end
	local Hr, Min, AmPm
	if tt == true then
		if C["datatext"].localtime == true then
			Hr, Min = GetGameTime()
			if C["datatext"].time24 == true then
				return Hr, Min, -1
			else
				if Hr>=12 then
					if Hr>12 then Hr = Hr - 12 end
					AmPm = 1
				else
					if Hr == 0 then Hr = 12 end
					AmPm = 2
				end
				return Hr, Min, AmPm
			end			
		else
			local Hr24 = tonumber(date("%H"))
			Hr = tonumber(date("%I"))
			Min = tonumber(date("%M"))
			if C["datatext"].time24 == true then
				return Hr24, Min, -1
			else
				if Hr24>=12 then AmPm = 1 else AmPm = 2 end
				return Hr, Min, AmPm
			end
		end
	else
		if C["datatext"].localtime == true then
			local Hr24 = tonumber(date("%H"))
			Hr = tonumber(date("%I"))
			Min = tonumber(date("%M"))
			if C["datatext"].time24 == true then
				return Hr24, Min, -1
			else
				if Hr24>=12 then AmPm = 1 else AmPm = 2 end
				return Hr, Min, AmPm
			end
		else
			Hr, Min = GetGameTime()
			if C["datatext"].time24 == true then
				return Hr, Min, -1
			else
				if Hr>=12 then
					if Hr>12 then Hr = Hr - 12 end
					AmPm = 1
				else
					if Hr == 0 then Hr = 12 end
					AmPm = 2
				end
				return Hr, Min, AmPm
			end
		end	
	end
end

local function CalculateTimeLeft(time)
		local hour = floor(time / 3600)
		local min = floor(time / 60 - (hour*60))
		local sec = time - (hour * 3600) - (min * 60)
		
		return hour, min, sec
end

local function formatResetTime(sec,table)
	local table = table or {}
	local d,h,m,s = ChatFrame_TimeBreakDown(floor(sec))
	local string = gsub(gsub(format(" %dd %dh %dm "..((d==0 and h==0) and "%ds" or ""),d,h,m,s)," 0[dhms]"," "),"%s+"," ")
	local string = strtrim(gsub(string, "([dhms])", {d=table.days or "d",h=table.hours or "h",m=table.minutes or "m",s=table.seconds or "s"})," ")
	return strmatch(string,"^%s*$") and "0"..(table.seconds or L"s") or string
end

local int = 1
local function Update(self, t)
	int = int - t
	if int > 0 then return end
	
	local Hr, Min, AmPm = CalculateTimeValues()
	
	if CalendarGetNumPendingInvites() > 0 then
		Text:SetTextColor(1, 0, 0)
	else
		Text:SetTextColor(1, 1, 1)
	end
	
	-- no update quick exit
	if (Hr == curHr and Min == curMin and AmPm == curAmPm) then
		int = 2
		return
	end
	
	curHr = Hr
	curMin = Min
	curAmPm = AmPm
		
	if AmPm == -1 then
		Text:SetFormattedText(europeDisplayFormat, Hr, Min)
	else
		Text:SetFormattedText(ukDisplayFormat, Hr, Min, APM[AmPm])
	end

	self:SetAllPoints(Text)
	int = 2
end

Stat:SetScript("OnEnter", function(self)
	OnLoad = function(self) RequestRaidInfo() end
	local anchor, panel, xoff, yoff = T.DataTextTooltipAnchor(Text)
	GameTooltip:SetOwner(panel, anchor, xoff, yoff)
	GameTooltip:ClearLines()

	local localizedName, isActive, canQueue, startTime, canEnter
	for i = 1, GetNumWorldPVPAreas() do
		_, localizedName, isActive, canQueue, startTime, canEnter = GetWorldPVPAreaInfo(i)
		if canEnter then
			if isActive then
				startTime = WINTERGRASP_IN_PROGRESS
			elseif startTime == nil then
				startTime = QUEUE_TIME_UNAVAILABLE
			else
				local hour, min, sec = CalculateTimeLeft(startTime)
				if hour > 0 then 
					startTime = string.format(timerLongFormat, hour, min, sec) 
				else 
					startTime = string.format(timerShortFormat, min, sec)
				end
			end
			GameTooltip:AddDoubleLine(format(formatBattleGroundInfo, localizedName), startTime)	
		end
	end	

	local timeText
	local Hr, Min, AmPm = CalculateTimeValues(true)

	if C["datatext"].localtime == true then
		timeText = L.datatext_servertime
	else
		timeText = L.datatext_localtime
	end
	
	if AmPm == -1 then
		GameTooltip:AddDoubleLine(timeText, string.format(europeDisplayFormat, Hr, Min))
	else
		GameTooltip:AddDoubleLine(timeText, string.format(ukDisplayFormat, Hr, Min, APM[AmPm]))
	end
	
	local oneraid, lockoutColor
	for i = 1, GetNumSavedInstances() do
		local name, _, reset, difficulty, locked, extended, _, isRaid, maxPlayers, _, numEncounters, encounterProgress  = GetSavedInstanceInfo(i)
		if isRaid and (locked or extended) then
			local tr,tg,tb,diff
			if not oneraid then
				GameTooltip:AddLine(" ")
				GameTooltip:AddLine(L.datatext_savedraid)
				oneraid = true
			end
			if extended then lockoutColor = lockoutColorExtended else lockoutColor = lockoutColorNormal end
			GameTooltip:AddDoubleLine(format(lockoutInfoFormat, name, maxPlayers, difficultyInfo[difficulty],encounterProgress,numEncounters), formatResetTime(reset), 1,1,1, lockoutColor.r,lockoutColor.g,lockoutColor.b)
		end
	end
	GameTooltip:Show()
end)

Stat:SetScript("OnLeave", function() GameTooltip:Hide() end)
Stat:RegisterEvent("CALENDAR_UPDATE_PENDING_INVITES")
Stat:RegisterEvent("PLAYER_ENTERING_WORLD")
Stat:SetScript("OnUpdate", Update)
Stat:RegisterEvent("UPDATE_INSTANCE_INFO")
Stat:SetScript("OnMouseDown", function(self, btn)
	if btn == 'RightButton'  then
		ToggleTimeManager()
	else
		GameTimeFrame:Click()
	end
end)
Update(Stat, 10)