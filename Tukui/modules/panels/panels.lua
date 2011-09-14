local T, C, L = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales

-- CHAT FRAMES
local TukuiChatBackgroundLeft = CreateFrame("Frame", "TukuiChatBackgroundLeft", UIParent)
TukuiChatBackgroundLeft:CreatePanel("Transparent", C["chat"].width, C["chat"].height, "BOTTOMLEFT", UIParent, "BOTTOMLEFT", 2, 2) 

local TukuiChatBackgroundRight = CreateFrame("Frame", "TukuiChatBackgroundRight", UIParent)
TukuiChatBackgroundRight:CreatePanel("Transparent", C["chat"].width, C["chat"].height, "BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -2, 2) 

-- CHAT TABS
local TukuiTabsLeftBackground = CreateFrame("Frame", "TukuiTabsLeftBackground", UIParent)
TukuiTabsLeftBackground:CreatePanel("Default", 1, 23, "TOPLEFT", TukuiChatBackgroundLeft, "TOPLEFT", 5, -5)
TukuiTabsLeftBackground:Point("TOPRIGHT", TukuiChatBackgroundLeft, "TOPRIGHT", -5, -5)
TukuiTabsLeftBackground:SetFrameLevel(TukuiChatBackgroundLeft:GetFrameLevel() + 1)
TukuiTabsLeftBackground:CreateOverlay(TukuiTabsLeftBackground)

local TukuiTabsRightBackground = CreateFrame("Frame", "TukuiTabsRightBackground", UIParent)
TukuiTabsRightBackground:CreatePanel("Default", 1, 23, "TOPLEFT", TukuiChatBackgroundRight, "TOPLEFT", 5, -5)
TukuiTabsRightBackground:Point("TOPRIGHT", TukuiChatBackgroundRight, "TOPRIGHT", -5, -5)
TukuiTabsRightBackground:SetFrameLevel(TukuiChatBackgroundRight:GetFrameLevel() + 1)
TukuiTabsRightBackground:CreateOverlay(TukuiTabsRightBackground)

if not C["chat"].background then
	TukuiChatBackgroundLeft:SetAlpha(0)
	TukuiChatBackgroundRight:SetAlpha(0)
	TukuiTabsLeftBackground:SetAlpha(0)
	TukuiTabsRightBackground:SetAlpha(0)
end

-- DATA FRAMES
local TukuiInfoLeft = CreateFrame("Frame", "TukuiInfoLeft", UIParent)
TukuiInfoLeft:CreatePanel("Default", 1, 23, "BOTTOMLEFT", TukuiChatBackgroundLeft, "BOTTOMLEFT", 5, 5)
TukuiInfoLeft:Point("BOTTOMRIGHT", TukuiChatBackgroundLeft, "BOTTOMRIGHT", -5, 5)
TukuiInfoLeft:SetFrameLevel(TukuiChatBackgroundLeft:GetFrameLevel() + 1)
TukuiInfoLeft:CreateOverlay(TukuiInforLeft)

local TukuiInfoRight = CreateFrame("Frame", "TukuiInfoRight", UIParent)
TukuiInfoRight:CreatePanel("Default", 1, 23, "BOTTOMLEFT", TukuiChatBackgroundRight, "BOTTOMLEFT", 5, 5)
TukuiInfoRight:Point("BOTTOMRIGHT", TukuiChatBackgroundRight, "BOTTOMRIGHT", -5, 5)
TukuiInfoRight:SetFrameLevel(TukuiChatBackgroundRight:GetFrameLevel() + 1)
TukuiInfoRight:CreateOverlay(TukuiInfoRight)

--BATTLEGROUND STATS FRAME
if C["datatext"].battleground == true then
	local bgframe = CreateFrame("Frame", "TukuiInfoLeftBattleGround", UIParent)
	bgframe:CreatePanel("Default", 1, 1, "TOPLEFT", UIParent, "BOTTOMLEFT", 0, 0)
	bgframe:SetAllPoints(TukuiInfoLeft)
	bgframe:SetFrameStrata("HIGH")
	bgframe:SetFrameLevel(0)
	bgframe:CreateOverlay(bgframe)
	bgframe:EnableMouse(true)
	bgframe:SetTemplate("Default", true)
end

	-- ACTIONBAR PANELS
if C["actionbar"].enable then
	local TukuiBar1 = CreateFrame("Frame", "TukuiBar1", UIParent, "SecureHandlerStateTemplate")
	TukuiBar1:CreatePanel("Transparent", (T.buttonsize * 12) + (T.buttonspacing * 13) + 2, (T.buttonsize * 2) + (T.buttonspacing * 3) + 2, "BOTTOM", UIParent, "BOTTOM", 0, 48)

	local TukuiBar2 = CreateFrame("Frame", "TukuiBar2", UIParent)
	TukuiBar2:SetAllPoints(TukuiBar1)--("BOTTOM")
	
	local TukuiBar3 = CreateFrame("Frame", "TukuiBar3", UIParent)
	TukuiBar3:SetAllPoints(TukuiBar1)--Point("BOTTOM")

	local TukuiBar4 = CreateFrame("Frame", "TukuiBar4", UIParent)
	TukuiBar2:SetAllPoints(TukuiBar1)--Point("BOTTOM")

	local TukuiSplitBarLeft = CreateFrame("Frame", "TukuiSplitBarLeft", UIParent)
	TukuiSplitBarLeft:CreatePanel("Transparent", (T.buttonsize * 3) + (T.buttonspacing * 4) + 2, TukuiBar1:GetHeight(), "BOTTOMRIGHT", TukuiBar1, "BOTTOMLEFT", -3, 0)

	local TukuiSplitBarRight = CreateFrame("Frame", "TukuiSplitBarRight", UIParent)
	TukuiSplitBarRight:CreatePanel("Transparent", (T.buttonsize * 3) + (T.buttonspacing * 4) + 2, TukuiBar1:GetHeight(), "BOTTOMLEFT", TukuiBar1, "BOTTOMRIGHT", 3, 0)

	local TukuiRightBar = CreateFrame("Frame", "TukuiRightBar", UIParent)
	TukuiRightBar:CreatePanel("Transparent", (T.buttonsize * 12 + T.buttonspacing * 13) + 2,  (T.buttonsize * 12 + T.buttonspacing * 13) + 2, "BOTTOMRIGHT", TukuiChatBackgroundRight, "TOPRIGHT", 0, 3)
	if not C["chat"].background then
		TukuiRightBar:ClearAllPoints()
		TukuiRightBar:Point("RIGHT", UIParent, "RIGHT", -8, 0)
	end
	
	local TukuiPetBar = CreateFrame("Frame", "TukuiPetBar", UIParent)
	TukuiPetBar:CreatePanel("Transparent", 1, 1, "BOTTOM", TukuiRightBar, "TOP", 0, 3)
	if C["actionbar"].vertical_rightbars == true then
		TukuiPetBar:Width((T.petbuttonsize + T.buttonspacing * 2) + 2)
		TukuiPetBar:Height((T.petbuttonsize * NUM_PET_ACTION_SLOTS + T.buttonspacing * 11) + 2)
	else
		TukuiPetBar:Width((T.petbuttonsize * NUM_PET_ACTION_SLOTS + T.buttonspacing * 11) + 2)
		TukuiPetBar:Height((T.petbuttonsize + T.buttonspacing * 2) + 2)
	end
end