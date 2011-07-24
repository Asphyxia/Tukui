--------------------------------------------------------------------
-- talent spec switcher by Omega1970
--------------------------------------------------------------------
local T, C, L = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales

if C["datatext"].specswitcher and C["datatext"].specswitcher > 0 then

	local Stat = CreateFrame("Frame")
	Stat:EnableMouse(true)
	Stat:SetFrameStrata("BACKGROUND")
	Stat:SetFrameLevel(3)
 

	local Text = TukuiInfoLeft:CreateFontString(nil, "OVERLAY")
	Text:SetFont(C.media.pixelfont, C["datatext"].fontsize, "MONOCHROMEOUTLINE")


	T.PP(C["datatext"].specswitcher, Text)
Stat:SetParent(Text:GetParent())

local talent = {}
local active
local talentString = string.join("", "|cffFFFFFF%s:|r ", "%d|r/", "%d|r/", "%d|r")
local activeString = string.join("", "|cff00FF00" , ACTIVE_PETS, "|r")
local inactiveString = string.join("", "|cffFF0000", FACTION_INACTIVE, "|r")

local function LoadTalentTrees()
	for i = 1, GetNumTalentGroups(false, false) do
		talent[i] = {} -- init talent group table
		for j = 1, GetNumTalentTabs(false, false) do
			talent[i][j] = select(5, GetTalentTabInfo(j, false, false, i))
			Text:SetText(T.panelcolor..L.datatext_notalents) 
		end
	end
end

local int = 1
local function Update(self, t)
	int = int - t
	if int > 0 or not GetPrimaryTalentTree() then return end

	active = GetActiveTalentGroup(false, false)
	Text:SetText(select(2,GetTalentTabInfo(GetPrimaryTalentTree(false, false, active)))..": "..T.panelcolor..talent[active][1].."/"..talent[active][2].."/"..talent[active][3])
	int = 1

	-- disable script	
	self:SetScript("OnUpdate", nil)
end

Stat:SetScript("OnEnter", function(self)
	if InCombatLockdown() then return end

	local anchor, panel, xoff, yoff = T.DataTextTooltipAnchor(Text)
	GameTooltip:SetOwner(panel, anchor, xoff, yoff)

	GameTooltip:ClearLines()
	for i = 1, GetNumTalentGroups() do
		if GetPrimaryTalentTree(false, false, i) then
			GameTooltip:AddLine(string.join(" ", string.format(talentString, select(2, GetTalentTabInfo(GetPrimaryTalentTree(false, false, i))), talent[i][1], talent[i][2], talent[i][3]), (i == active and activeString or inactiveString)),1,1,1)
		end
	end
	GameTooltip:Show()
end)

Stat:SetScript("OnLeave", function() GameTooltip:Hide() end)

local function OnEvent(self, event, ...)
	if event == "PLAYER_ENTERING_WORLD" then
		self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	end
	
	-- load talent information
	LoadTalentTrees()

	-- Setup Talents Tooltip
	self:SetAllPoints(Text)
	
	-- update datatext
	if event ~= "PLAYER_ENTERING_WORLD" then
		self:SetScript("OnUpdate", Update)
	end
end

Stat:RegisterEvent("PLAYER_ENTERING_WORLD");
Stat:RegisterEvent("CHARACTER_POINTS_CHANGED");
Stat:RegisterEvent("PLAYER_TALENT_UPDATE");
Stat:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
Stat:SetScript("OnEvent", OnEvent)
Stat:SetScript("OnUpdate", Update)

Stat:SetScript("OnMouseDown", function()
	SetActiveTalentGroup(active == 1 and 2 or 1)
end)
end