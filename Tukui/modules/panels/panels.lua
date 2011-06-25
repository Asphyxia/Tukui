local T, C, L = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales

local sbWidth = C.actionbar.sidebarWidth
local mbWidth = C.actionbar.mainbarWidth

local TukuiBar1 = CreateFrame("Frame", "TukuiBar1", UIParent, "SecureHandlerStateTemplate")
TukuiBar1:CreatePanel("Invisible", 1, 1, "BOTTOM", UIParent, "BOTTOM", 0, 55)
TukuiBar1:SetWidth((T.buttonsize * mbWidth) + (T.buttonspacing * (mbWidth-1)))
TukuiBar1:SetHeight((T.buttonsize * 2) + (T.buttonspacing))
TukuiBar1:SetFrameStrata("BACKGROUND")
TukuiBar1:SetFrameLevel(1)

local TukuiBar2 = CreateFrame("Frame", "TukuiBar2", UIParent)
TukuiBar2:CreatePanel("Invisible", 1, 1, "BOTTOMRIGHT", TukuiBar1, "BOTTOMLEFT", -5, 0)
TukuiBar2:SetWidth((T.buttonsize * sbWidth) + (T.buttonspacing * (sbWidth-1)))
TukuiBar2:SetHeight((T.buttonsize * 2) + (T.buttonspacing))
TukuiBar2:SetFrameStrata("BACKGROUND")
TukuiBar2:SetFrameLevel(2)
TukuiBar2:SetAlpha(1)

local TukuiBar3 = CreateFrame("Frame", "TukuiBar3", UIParent)
TukuiBar3:CreatePanel("Invisible", 1, 1, "BOTTOMLEFT", TukuiBar1, "BOTTOMRIGHT", 5, 0)
TukuiBar3:SetWidth((T.buttonsize * sbWidth) + (T.buttonspacing * (sbWidth-1)))
TukuiBar3:SetHeight((T.buttonsize * 2) + (T.buttonspacing))
TukuiBar3:SetFrameStrata("BACKGROUND")
TukuiBar3:SetFrameLevel(2)
TukuiBar3:SetAlpha(1)

local TukuiBar4 = CreateFrame("Frame", "TukuiBar4", UIParent)
TukuiBar4:CreatePanel("Invisible", 1, 1, "BOTTOM", UIParent, "BOTTOM", 0, 55)
TukuiBar4:SetWidth((T.buttonsize * mbWidth) + (T.buttonspacing * (mbWidth-1)))
TukuiBar4:SetHeight((T.buttonsize * 2) + (T.buttonspacing))
TukuiBar4:SetFrameStrata("BACKGROUND")
TukuiBar4:SetFrameLevel(2)
TukuiBar4:SetAlpha(0)

local TukuiBar5 = CreateFrame("Frame", "TukuiBar5", UIParent)
TukuiBar5:CreatePanel("Invisible", (T.buttonsize * 12) + (T.buttonspacing * 11), T.buttonsize, "RIGHT", UIParent, "RIGHT", -24, -14)
TukuiBar5:SetFrameStrata("BACKGROUND")
TukuiBar5:SetFrameLevel(2)
TukuiBar5:SetAlpha(0)

local TukuiBar6 = CreateFrame("Frame", "TukuiBar6", UIParent)
TukuiBar6:SetWidth((T.buttonsize) + (T.buttonspacing * 2))
TukuiBar6:SetHeight((T.buttonsize * 12) + (T.buttonspacing * 11))
TukuiBar6:SetPoint("LEFT", TukuiBar5, "LEFT", 0, 0)
TukuiBar6:SetFrameStrata("BACKGROUND")
TukuiBar6:SetFrameLevel(2)
TukuiBar6:SetAlpha(0)

local TukuiBar7 = CreateFrame("Frame", "TukuiBar7", UIParent)
TukuiBar7:SetWidth((T.buttonsize) + (T.buttonspacing * 2))
TukuiBar7:SetHeight((T.buttonsize * 12) + (T.buttonspacing * 11))
TukuiBar7:SetPoint("TOP", TukuiBar5, "TOP", 0 , 0)
TukuiBar7:SetFrameStrata("BACKGROUND")
TukuiBar7:SetFrameLevel(2)
TukuiBar7:SetAlpha(0)

local petbg = CreateFrame("Frame", "TukuiPetBar", UIParent, "SecureHandlerStateTemplate")
petbg:CreatePanel("Invisible", (T.petbuttonsize * 10) + (T.petbuttonspacing * 9), T.petbuttonsize, "BOTTOM", TukuiBar5, "TOP", 0, 5)

local ltpetbg1 = CreateFrame("Frame", "TukuiLineToPetActionBarBackground", petbg)
ltpetbg1:CreatePanel("Invisible", 24, 265, "LEFT", petbg, "RIGHT", 0, 0)
ltpetbg1:SetParent(petbg)
ltpetbg1:SetFrameStrata("BACKGROUND")
ltpetbg1:SetFrameLevel(2)
ltpetbg1:SetAlpha(0)

if C.actionbar.bgPanel then
	for i = 1, 5 do
		_G["TukuiBar"..i]:SetTemplate("Default")
		_G["TukuiBar"..i]:CreateShadow("Default")
	end
	
	petbg:SetTemplate("Default")
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
	TukuiBar4.shadow:Hide()
	
	TukuiBar5:SetWidth((T.buttonsize * 12) + (T.buttonspacing * 13))
	TukuiBar5:SetHeight((T.buttonsize) + (T.buttonspacing*2))
	
	TukuiBar6:SetWidth((T.buttonsize) + (T.buttonspacing * 2))
	TukuiBar6:SetHeight((T.buttonsize * 12) + (T.buttonspacing * 13))
	
	TukuiBar7:SetWidth((T.buttonsize) + (T.buttonspacing * 2))
	TukuiBar7:SetHeight((T.buttonsize * 12) + (T.buttonspacing * 13))
end

-- Default FRAME COVERING BOTTOM ACTIONBARS JUST TO PARENT UF CORRECTLY
local invbarbg = CreateFrame("Frame", "InvTukuiActionBarBackground", UIParent)
	invbarbg:SetPoint("TOPLEFT", TukuiBar2)
	invbarbg:SetPoint("BOTTOMRIGHT", TukuiBar3)

-- LEFT VERTICAL LINE
local ileftlv = CreateFrame("Frame", "TukuiInfoLeftLineVertical", TukuiBar1)
ileftlv:CreatePanel("Default", 2, 130, "BOTTOMLEFT", UIParent, "BOTTOMLEFT", 22, 30)

-- RIGHT VERTICAL LINE
local irightlv = CreateFrame("Frame", "TukuiInfoRightLineVertical", TukuiBar1)
irightlv:CreatePanel("Default", 2, 130, "BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -22, 30)

if not C.chat.background then
	-- CUBE AT LEFT, ACT AS A BUTTON (CHAT MENU)
	local cubeleft = CreateFrame("Frame", "TukuiCubeLeft", TukuiBar1)
	cubeleft:CreatePanel("Default", 10, 10, "BOTTOM", ileftlv, "TOP", 0, 0)
	cubeleft:EnableMouse(true)
	cubeleft:SetScript("OnMouseDown", function(self, btn)
		if TukuiInfoLeftBattleGround and UnitInBattleground("player") then
			if btn == "RightButton" then
				if TukuiInfoLeftBattleGround:IsShown() then
					TukuiInfoLeftBattleGround:Hide()
				else
					TukuiInfoLeftBattleGround:Show()
				end
			end
		end
		
		if btn == "LeftButton" then	
			ToggleFrame(ChatMenu)
		end
	end)

	-- CUBE AT RIGHT, ACT AS A BUTTON (CONFIGUI or BG'S)
	local cuberight = CreateFrame("Frame", "TukuiCubeRight", TukuiBar1)
	cuberight:CreatePanel("Default", 10, 10, "BOTTOM", irightlv, "TOP", 0, 0)
	if C["bags"].enable then
		cuberight:EnableMouse(true)
		cuberight:SetScript("OnMouseDown", function(self)
		if T.toc < 40200 then ToggleKeyRing() else ToggleAllBags() end
		end)
	end
end

-- HORIZONTAL LINE LEFT
local ltoabl = CreateFrame("Frame", "TukuiLineToABLeft", TukuiBar1)
ltoabl:CreatePanel("Default", 5, 2, "BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", 0, 0)
ltoabl:ClearAllPoints()
ltoabl:Point("BOTTOMLEFT", ileftlv, "BOTTOMLEFT", 0, 0)
ltoabl:Point("RIGHT", TukuiBar1, "BOTTOMLEFT", -1, 17)
ltoabl:SetFrameStrata("BACKGROUND")
ltoabl:SetFrameLevel(1)

-- HORIZONTAL LINE RIGHT
local ltoabr = CreateFrame("Frame", "TukuiLineToABRight", TukuiBar1)
ltoabr:CreatePanel("Default", 5, 2, "BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", 0, 0)
ltoabr:ClearAllPoints()
ltoabr:Point("LEFT", TukuiBar1, "BOTTOMRIGHT", 1, 17)
ltoabr:Point("BOTTOMRIGHT", irightlv, "BOTTOMRIGHT", 0, 0)
ltoabr:SetFrameStrata("BACKGROUND")
ltoabr:SetFrameLevel(1)


-- MOVE/HIDE SOME ELEMENTS IF CHAT BACKGROUND IS ENABLED
local movechat = 0
if C.chat.background then movechat = 10 ileftlv:SetAlpha(0) irightlv:SetAlpha(0) end

-- INFO LEFT (FOR STATS)
local ileft = CreateFrame("Frame", "TukuiInfoLeft", TukuiBar1)
ileft:CreatePanel("Default", T.InfoLeftRightWidth + 12, 17, "LEFT", ltoabl, "LEFT", 2 - movechat, -10)
--ileft:SetFrameLevel(2)
ileft:CreateShadow("Default")
ileft:SetFrameStrata("MEDIUM")

-- INFO RIGHT (FOR STATS)
local iright = CreateFrame("Frame", "TukuiInfoRight", TukuiBar1)
iright:CreatePanel("Default", T.InfoLeftRightWidth + 12, 17, "RIGHT", ltoabr, "RIGHT", -2 + movechat, -11)
iright:SetFrameLevel(2)
iright:CreateShadow("Default")
iright:SetFrameStrata("MEDIUM")

-- Alpha horizontal lines because all panels is dependent on this frame.
ltoabl:SetAlpha(0)
ltoabr:SetAlpha(0)

-- CHAT BG LEFT
local chatleftbg = CreateFrame("Frame", "TukuiChatBackgroundLeft", TukuiInfoLeft)
chatleftbg:CreatePanel("Transparent", T.InfoLeftRightWidth + 12, 115, "BOTTOM", TukuiInfoLeft, "BOTTOM", 0, 20)
chatleftbg:CreateShadow("Default")
	
-- CHAT BG RIGHT
local chatrightbg = CreateFrame("Frame", "TukuiChatBackgroundRight", TukuiInfoRight)
chatrightbg:CreatePanel("Transparent", T.InfoLeftRightWidth + 12, 115, "BOTTOM", TukuiInfoRight, "BOTTOM", 0, 20)
chatrightbg:CreateShadow("default")
	
-- LEFT TAB PANEL
local tabsbgleft = CreateFrame("Frame", "TukuiTabsLeftBackground", TukuiChatBackgroundLeft)
tabsbgleft:CreatePanel("Default", T.InfoLeftRightWidth + 12, 17, "BOTTOMLEFT", chatleftbg, "TOPLEFT", 0, T.Scale(3))
tabsbgleft:SetFrameLevel(1)
tabsbgleft:SetFrameStrata("BACKGROUND")
tabsbgleft:CreateShadow("")

-- RIGHT TAB PANEL
local tabsbgright = CreateFrame("Frame", "TukuiTabsRightBackground", TukuiChatBackgroundRight)
tabsbgright:CreatePanel("Default", T.InfoLeftRightWidth + 12, 17, "BOTTOMLEFT", chatrightbg, "TOPLEFT", 0, T.Scale(3))
tabsbgright:SetFrameLevel(1)
tabsbgright:SetFrameStrata("BACKGROUND")
tabsbgright:CreateShadow("")

-- CHAT ANIMATION
local chat = {"TukuiChatBackgroundLeft", "TukuiChatBackgroundRight"}
local info = {"TukuiInfoLeft", "TukuiInfoRight", "TukuiInfoLeftBattleGround"}

for i = 1, #chat do
	_G[chat[i]]:Animate(0, -140, 0.4)
	
	_G[info[i]]:EnableMouse(true)
	_G[info[i]]:SetScript("OnMouseDown", function(self)
		if _G[chat[i]]:IsVisible() then
			_G[chat[i]]:SlideOut()
		else
			_G[chat[i]]:SlideIn()
		end
	end)
end

-- COLOR INFO LEFT SHADOW IF WE HAVE A WHISPER
local function ChatAlertSys(self)
	local HydraChatAlert = CreateFrame("Frame")
	HydraChatAlert:RegisterEvent("CHAT_MSG_BN_WHISPER")
	HydraChatAlert:RegisterEvent("CHAT_MSG_WHISPER")
	HydraChatAlert:RegisterEvent("CHAT_MSG_GUILD")
	HydraChatAlert:RegisterEvent("CHAT_MSG_PARTY")
	HydraChatAlert:SetScript("OnEvent", function(HydraChatAlert, event, msg)
		if event == "CHAT_MSG_WHISPER" then
			TukuiInfoLeft.shadow:SetBackdropBorderColor(ChatTypeInfo["WHISPER"].r,ChatTypeInfo["WHISPER"].g,ChatTypeInfo["WHISPER"].b, 0.8)
		elseif event == "CHAT_MSG_BN_WHISPER" then
			TukuiInfoLeft.shadow:SetBackdropBorderColor(ChatTypeInfo["BN_WHISPER"].r,ChatTypeInfo["BN_WHISPER"].g,ChatTypeInfo["BN_WHISPER"].b, 0.8)
		end
	end)
end

local LastUpdate = 1
local ChatAlert = CreateFrame("Frame")

local function UpdateChatAlert(self, elapsed)
	LastUpdate = LastUpdate - elapsed
	
	if LastUpdate < 0 then
		if not TukuiChatBackgroundLeft:IsVisible() then
			ChatAlertSys()
		elseif TukuiChatBackgroundLeft:IsVisible() then
			TukuiInfoLeft.shadow:SetBackdropBorderColor(0,0,0,0.5)
		end
		LastUpdate = 1
	end
end
ChatAlert:SetScript("OnUpdate", UpdateChatAlert)

--[[
if TukuiMinimap then
	local minimapstatsleft = CreateFrame("Frame", "TukuiMinimapStatsLeft", TukuiMinimap)
	minimapstatsleft:CreatePanel("Default", ((TukuiMinimap:GetWidth() + 4) / 2) -3, 19, "TOPLEFT", TukuiMinimap, "BOTTOMLEFT", 0, -2)

	local minimapstatsright = CreateFrame("Frame", "TukuiMinimapStatsRight", TukuiMinimap)
	minimapstatsright:CreatePanel("Default", ((TukuiMinimap:GetWidth() + 4) / 2) -3, 19, "TOPRIGHT", TukuiMinimap, "BOTTOMRIGHT", 0, -2)
end
--]]

--RE-ANCHOR BAR5 & PETBAR ABOVE RIGHT CHAT
TukuiBar5:ClearAllPoints()
TukuiBar5:Point("BOTTOM", tabsbgright, "TOP", 0, 3)

petbg:ClearAllPoints()
petbg:Point("BOTTOM", TukuiBar5, "TOP", 0, 4)

TukuiBar5:SetScript("OnHide", function() petbg:ClearAllPoints() petbg:Point("BOTTOM", tabsbgright, "TOP", 0, 4) end)
TukuiBar5:SetScript("OnShow", function() petbg:ClearAllPoints() petbg:Point("BOTTOM", TukuiBar5, "TOP", 0, 3) end)

--REPOSITION BAR5 & PETBAR (if chat right is not visible)
local function UpdateBar5()
	if InCombatLockdown() then return end
	if TukuiChatBackgroundRight:IsVisible() then
		TukuiBar5:Point("BOTTOM", tabsbgright, "TOP", 0, 4)
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
			TukuiPetBar:Point("BOTTOM", tabsbgright, "TOP", 0, 4)
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
	
--[[--BATTLEGROUND STATS FRAME
if C["datatext"].battleground == true then
	local bgframe = CreateFrame("Frame", "TukuiInfoLeftBattleGround", UIParent)
	bgframe:CreatePanel("Invisible", 1, 1, "TOPLEFT", UIParent, "BOTTOMLEFT", 0, 0)
	bgframe:SetAllPoints(ileft)
	bgframe:SetFrameStrata("MEDIUM")
	bgframe:SetFrameLevel(6)
	bgframe:EnableMouse(true)
end	--]]

--BATTLEGROUND STATS FRAME
if C["datatext"].battleground == true then
	local bgframe = CreateFrame("Frame", "TukuiInfoLeftBattleGround", UIParent)
	bgframe:CreatePanel("Invisible", 1, 1, "TOPLEFT", UIParent, "BOTTOMLEFT", 0, 0)
	bgframe:SetAllPoints(ileft)
	bgframe:SetFrameStrata("MEDIUM")
	bgframe:SetFrameLevel(6)
	bgframe:EnableMouse(true)
	bgframe:SetScript("OnMouseDown", function()
	if TukuiChatBackgroundLeft:IsVisible() then
		TukuiChatBackgroundLeft:SlideOut()
		TukuiChatBackgroundRight:SlideOut()
	else
		TukuiChatBackgroundLeft:SlideIn()
		TukuiChatBackgroundRight:SlideIn()
	end
end)
end