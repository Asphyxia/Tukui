local T, C, L = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales
if not C.map.location_panel then return end
local font, fsize, fstyle = C.media.pixelfont, C.datatext.fontsize, "THINOUTLINE"

local locpanel = CreateFrame("Frame", "TukuiLocationPanel", UIParent)
locpanel:CreatePanel("Default", 70, 23, "TOP", UIParent, "TOP", 0, -10)
locpanel:CreateShadow("Default")
locpanel:SetFrameLevel(4)
locpanel:EnableMouse(true)

local xcoords = CreateFrame("Frame", "TukuiXCoordsPanel", locpanel)
xcoords:CreatePanel("Default", 35, 19, "RIGHT", locpanel, "LEFT", 1, 0)
xcoords:CreateShadow("Default")
xcoords:SetFrameLevel(2)

local ycoords = CreateFrame("Frame", "TukuiYCoordsPanel", locpanel)
ycoords:CreatePanel("Default", 35, 19, "LEFT", locpanel, "RIGHT", -1, 0)
ycoords:CreateShadow("Default")
ycoords:SetFrameLevel(2)

-- Set font
local locFS = locpanel:CreateFontString(nil, "OVERLAY")
locFS:SetFont(font, fsize, fstyle)

local xFS = xcoords:CreateFontString(nil, "OVERLAY")
xFS:SetFont(font, fsize, fstyle)

local yFS = ycoords:CreateFontString(nil, "OVERLAY")
yFS:SetFont(font, fsize, fstyle)

local function SetLocColor(frame, pvpT)
	if (pvpT == "arena" or pvpT == "combat") then
		frame:SetTextColor(1, 0.5, 0)
	elseif pvpT == "friendly" then
		frame:SetTextColor(0, 1, 0)
	elseif pvpT == "contested" then
		frame:SetTextColor(1, 1, 0)
	elseif pvpT == "hostile" then
		frame:SetTextColor(1, 0, 0)
	elseif pvpT == "sanctuary" then
		frame:SetTextColor(0, .9, .9)
	else
		frame:SetTextColor(0, 1, 0)
	end
end

local function OnEvent()
	location = GetMinimapZoneText()
	pvpType = GetZonePVPInfo();
	locFS:SetText(location)
	locpanel:SetWidth(locFS:GetStringWidth() + 40)
	SetLocColor(locFS, pvpType)
	locFS:SetPoint("CENTER", locpanel, "CENTER", 1, 0.5)
	locFS:SetJustifyH("CENTER")
end
local function xUpdate()
	posX, posY = GetPlayerMapPosition("player");
	posX = math.floor(100 * posX)
	xFS:SetText(T.panelcolor..posX)
	xFS:SetPoint("CENTER", xcoords, "CENTER", 1, 0.5)
end
local function yUpdate()
	posX, posY = GetPlayerMapPosition("player");
	posY = math.floor(100 * posY)
	yFS:SetText(T.panelcolor..posY)
	yFS:SetPoint("CENTER", ycoords, "CENTER", 1, 0.5)
end
locpanel:SetScript("OnMouseDown", function()
	if WorldMapFrame:IsShown() then
			WorldMapFrame:Hide()
	else
			WorldMapFrame:Show()
	end
end)

locpanel:SetScript("OnEnter", function()
	locFS:SetTextColor(1, 1, 1)
end)
locpanel:SetScript("OnLeave", function()
	pvpType = GetZonePVPInfo();
	SetLocColor(locFS, pvpType)	
end)
locpanel:RegisterEvent("ZONE_CHANGED")
locpanel:RegisterEvent("PLAYER_ENTERING_WORLD")
locpanel:RegisterEvent("ZONE_CHANGED_INDOORS")
locpanel:RegisterEvent("ZONE_CHANGED_NEW_AREA")
locpanel:SetScript("OnEvent", OnEvent)
xcoords:SetScript("OnUpdate", xUpdate)
ycoords:SetScript("OnUpdate", yUpdate)
