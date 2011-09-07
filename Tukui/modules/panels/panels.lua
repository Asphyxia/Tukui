local T, C, L = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales

local sbWidth = C.actionbar.sidebarWidth
local mbWidth = C.actionbar.mainbarWidth

local TukuiBar1 = CreateFrame("Frame", "TukuiBar1", UIParent, "SecureHandlerStateTemplate")
TukuiBar1:CreatePanel("Invisible", 1, 1, "BOTTOM", UIParent, "BOTTOM", 0, 48) 
TukuiBar1:SetWidth((T.buttonsize * mbWidth) + (T.buttonspacing * (mbWidth-1)))
TukuiBar1:SetHeight((T.buttonsize * 2) + (T.buttonspacing))
TukuiBar1:SetFrameStrata("BACKGROUND")
TukuiBar1:SetFrameLevel(1)
TukuiBar1:SetBackdrop(nil)

local TukuiBar2 = CreateFrame("Frame", "TukuiBar2", UIParent)
TukuiBar2:CreatePanel("Invisible", 1, 1, "BOTTOMRIGHT", TukuiBar1, "BOTTOMLEFT", -3, 0)
TukuiBar2:SetWidth((T.buttonsize * sbWidth) + (T.buttonspacing * (sbWidth-1)))
TukuiBar2:SetHeight((T.buttonsize * 2) + (T.buttonspacing))
TukuiBar2:SetFrameStrata("BACKGROUND")
TukuiBar2:CreateShadow("Default")
TukuiBar2:SetFrameLevel(2)
TukuiBar2:SetBackdrop(nil)
if T.lowversion then
	TukuiBar2:SetAlpha(0)
else
	TukuiBar2:SetAlpha(1)
end

local TukuiBar3 = CreateFrame("Frame", "TukuiBar3", UIParent)
TukuiBar3:CreatePanel("Invisible", 1, 1, "BOTTOMLEFT", TukuiBar1, "BOTTOMRIGHT", 3, 0)
TukuiBar3:SetWidth((T.buttonsize * sbWidth) + (T.buttonspacing * (sbWidth-1)))
TukuiBar3:SetHeight((T.buttonsize * 2) + (T.buttonspacing))
TukuiBar3:SetFrameStrata("BACKGROUND")
TukuiBar3:CreateShadow("Default")
TukuiBar3:SetFrameLevel(2)
TukuiBar3:SetBackdrop(nil)
if T.lowversion then
	TukuiBar3:SetAlpha(0)
else
	TukuiBar3:SetAlpha(1)
end

local TukuiBar4 = CreateFrame("Frame", "TukuiBar4", UIParent)
TukuiBar4:CreatePanel("Invisible", 1, 1, "BOTTOM", UIParent, "BOTTOM", 0, 48)
TukuiBar4:SetWidth((T.buttonsize * mbWidth) + (T.buttonspacing * (mbWidth-1)))
TukuiBar4:SetHeight((T.buttonsize * 2) + (T.buttonspacing))
TukuiBar4:SetFrameStrata("BACKGROUND")
TukuiBar4:CreateShadow("Default")
TukuiBar4:SetFrameLevel(2)
TukuiBar4:SetAlpha(0)
TukuiBar4:SetBackdrop(nil)

local TukuiBar5 = CreateFrame("Frame", "TukuiBar5", UIParent)
TukuiBar5:CreatePanel("Invisible", (T.buttonsize * 12) + (T.buttonspacing * 11), T.buttonsize, "RIGHT", UIParent, "RIGHT", -24, -14)
TukuiBar5:SetFrameStrata("BACKGROUND")
TukuiBar5:CreateShadow("Default")
TukuiBar5:SetFrameLevel(2)
TukuiBar5:SetAlpha(0)
TukuiBar5:SetBackdrop(nil)

local TukuiBar6 = CreateFrame("Frame", "TukuiBar6", UIParent)
TukuiBar6:SetWidth((T.buttonsize) + (T.buttonspacing * 2))
TukuiBar6:SetHeight((T.buttonsize * 12) + (T.buttonspacing * 11))
TukuiBar6:SetPoint("LEFT", TukuiBar5, "LEFT", 0, 0)
TukuiBar6:SetFrameStrata("BACKGROUND")
TukuiBar6:SetFrameLevel(2)
TukuiBar6:SetAlpha(0)
TukuiBar6:SetBackdrop(nil)

local TukuiBar7 = CreateFrame("Frame", "TukuiBar7", UIParent)
TukuiBar7:SetWidth((T.buttonsize) + (T.buttonspacing * 2))
TukuiBar7:SetHeight((T.buttonsize * 12) + (T.buttonspacing * 11))
TukuiBar7:SetPoint("TOP", TukuiBar5, "TOP", 0 , 0)
TukuiBar7:SetFrameStrata("BACKGROUND")
TukuiBar7:SetFrameLevel(2)
TukuiBar7:SetAlpha(0)
TukuiBar7:SetBackdrop(nil)

local petbg = CreateFrame("Frame", "TukuiPetBar", UIParent, "SecureHandlerStateTemplate")
petbg:CreatePanel("Invisible", (T.petbuttonsize * 10) + (T.petbuttonspacing * 9), T.petbuttonsize, "BOTTOM", TukuiBar5, "TOP", 0, 5)
petbg:SetBackdrop(nil)

local ltpetbg1 = CreateFrame("Frame", "TukuiLineToPetActionBarBackground", petbg)
ltpetbg1:CreatePanel("Invisible", 24, 265, "LEFT", petbg, "RIGHT", 0, 0)
ltpetbg1:SetParent(petbg)
ltpetbg1:SetFrameStrata("BACKGROUND")
ltpetbg1:SetFrameLevel(0)
ltpetbg1:SetAlpha(0)

if C.actionbar.bgPanel then
	for i = 1, 5 do
		_G["TukuiBar"..i]:SetTemplate("Default")
		_G["TukuiBar"..i]:CreateBorder(true, true)
	end
	petbg:SetTemplate("Default")
	petbg:CreateBorder(true, true)
	petbg:CreateShadow("Default")
	petbg:SetWidth((T.petbuttonsize * 10) + (T.petbuttonspacing * 11))
	petbg:SetHeight(T.petbuttonsize + (T.petbuttonspacing * 2))
	
	TukuiBar1:SetWidth((T.buttonsize * mbWidth) + (T.buttonspacing * (mbWidth+1)))
	TukuiBar1:SetHeight((T.buttonsize * 2) + (T.buttonspacing*3))
	
	TukuiBar2:SetWidth((T.buttonsize * sbWidth) + (T.buttonspacing * (sbWidth+1)))
	TukuiBar2:SetHeight((T.buttonsize * 2) + (T.buttonspacing*3))
	
	TukuiBar3:SetWidth((T.buttonsize * sbWidth) + (T.buttonspacing * (sbWidth+1)))
	TukuiBar3:SetHeight((T.buttonsize * 2) + (T.buttonspacing*3))
	
	TukuiBar4:SetWidth((T.buttonsize * mbWidth) + (T.buttonspacing * (mbWidth+1)))
	TukuiBar4:SetHeight((T.buttonsize * 2) + (T.buttonspacing*3))
	
	TukuiBar5:SetWidth((T.buttonsize * 12) + (T.buttonspacing * 13))
	TukuiBar5:SetHeight((T.buttonsize) + (T.buttonspacing*2))
	
	TukuiBar6:SetWidth((T.buttonsize) + (T.buttonspacing * 2))
	TukuiBar6:SetHeight((T.buttonsize * 12) + (T.buttonspacing * 13))
	
	TukuiBar7:SetWidth((T.buttonsize) + (T.buttonspacing * 2))
	TukuiBar7:SetHeight((T.buttonsize * 12) + (T.buttonspacing * 13))
end

	-- Default FRAME COVERING BOTTOM ACTIONBARS JUST TO PARENT UF CORRECTLY
	local invbarbg = CreateFrame("Frame", "InvTukuiActionBarBackground", UIParent)
	if T.lowversion then
		invbarbg:SetPoint("TOPLEFT", TukuiBar1)
		invbarbg:SetPoint("BOTTOMRIGHT", TukuiBar1)
		TukuiBar2:Hide()
		TukuiBar3:Hide()
	else
		invbarbg:SetPoint("TOPLEFT", TukuiBar2)
		invbarbg:SetPoint("BOTTOMRIGHT", TukuiBar3)
	end

	-- INFO LEFT (FOR STATS)
	local ileft = CreateFrame("Frame", "TukuiInfoLeft", TukuiBar1)
	ileft:CreatePanel("Default", T.InfoLeftRightWidth, 23, "BOTTOMLEFT", UIParent, "BOTTOMLEFT", 8, 8)
	ileft:SetFrameLevel(2)
	ileft:SetFrameStrata("BACKGROUND")
	ileft:CreateShadow("Default")
	ileft:CreateOverlay(ileft)

	-- INFO RIGHT (FOR STATS)
	local iright = CreateFrame("Frame", "TukuiInfoRight", TukuiBar1)
	iright:CreatePanel("Default", T.InfoLeftRightWidth, 23, "BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -8, 8)
	iright:SetFrameLevel(2)
	iright:SetFrameStrata("BACKGROUND")
	iright:CreateShadow("Default")
	iright:CreateOverlay(iright)

	-- CHAT BG LEFT
	local chatleftbg = CreateFrame("Frame", "TukuiChatBackgroundLeft", TukuiInfoLeft)
	chatleftbg:CreatePanel("Transparent", T.InfoLeftRightWidth + 12, 177, "BOTTOM", TukuiInfoLeft, "BOTTOM", 0, -6)
	chatleftbg:CreateBorder(true, true)
			
	-- CHAT BG RIGHT
	local chatrightbg = CreateFrame("Frame", "TukuiChatBackgroundRight", TukuiInfoRight)
	chatrightbg:CreatePanel("Transparent", T.InfoLeftRightWidth + 12, 177, "BOTTOM", TukuiInfoRight, "BOTTOM", 0, -6)
	chatrightbg:CreateBorder(true, true)
	
	-- LEFT TAB PANEL
	local tabsbgleft = CreateFrame("Frame", "TukuiTabsLeftBackground", TukuiBar1)
	tabsbgleft:CreatePanel("Default", T.InfoLeftRightWidth, 23, "TOP", chatleftbg, "TOP", 0, -6)
	tabsbgleft:SetFrameLevel(2)
	tabsbgleft:SetFrameStrata("BACKGROUND")
	tabsbgleft:CreateShadow("Default")
	tabsbgleft:CreateOverlay(tabsbleft)

	-- RIGHT TAB PANEL
	local tabsbgright = CreateFrame("Frame", "TukuiTabsRightBackground", TukuiBar1)
	tabsbgright:CreatePanel("Default", T.InfoLeftRightWidth, 23, "TOP", chatrightbg, "TOP", 0, -6)
	tabsbgright:SetFrameLevel(2)
	tabsbgright:SetFrameStrata("BACKGROUND")
	tabsbgright:CreateShadow("Default")
	tabsbgright:CreateOverlay(tabsbgright)
	
	--RE-ANCHOR BAR5 & PETBAR ABOVE RIGHT CHAT
	TukuiBar5:ClearAllPoints()
	TukuiBar5:Point("BOTTOM", chatrightbg, "TOP", 0, 4)

	petbg:ClearAllPoints()
	petbg:Point("BOTTOM", TukuiBar5, "TOP", 0, 4, true)

	TukuiBar5:SetScript("OnHide", function() petbg:ClearAllPoints() petbg:Point("BOTTOM", chatrightbg, "TOP", 0, 4) end)
	TukuiBar5:SetScript("OnShow", function() petbg:ClearAllPoints() petbg:Point("BOTTOM", TukuiBar5, "TOP", 0, 4) end)

	--REPOSITION BAR5 & PETBAR (if chat right is not visible)
	local function UpdateBar5()
		if InCombatLockdown() then return end
		if TukuiChatBackgroundRight:IsVisible() then
			TukuiBar5:Point("BOTTOM", chatrightbg, "TOP", 0, 4)
		else
			TukuiBar5:Point("BOTTOM", iright, "TOP", 0, 4)
		end	
	end

	CreateFrame("Frame"):SetScript("OnUpdate", UpdateBar5)

local function UpdatePetbar()
	if InCombatLockdown() then return end
	if TukuiChatBackgroundRight:IsVisible() then
		if TukuiBar5:IsVisible() then
			TukuiPetBar:Point("BOTTOM", TukuiBar5, "TOP", 0, 4)
		else
			TukuiPetBar:Point("BOTTOM", chatrightbg, "TOP", 0, 4)
		end
	else
		if TukuiBar5:IsVisible() then
			TukuiPetBar:Point("BOTTOM", TukuiBar5, "TOP", 0, 4)
		else
			TukuiPetBar:Point("BOTTOM", iright, "TOP", 0, 4)
		end
	end
end
CreateFrame("Frame"):SetScript("OnUpdate", UpdatePetbar)

--BATTLEGROUND STATS FRAME
if C["datatext"].battleground == true then
	local bgframe = CreateFrame("Frame", "TukuiInfoLeftBattleGround", UIParent)
	bgframe:CreatePanel("Default", 1, 1, "TOPLEFT", UIParent, "BOTTOMLEFT", 0, 0)
	bgframe:SetAllPoints(ileft)
	bgframe:SetFrameStrata("LOW")
	bgframe:SetFrameLevel(0)
	bgframe:CreateOverlay(bgframe)
	bgframe:EnableMouse(true)
end