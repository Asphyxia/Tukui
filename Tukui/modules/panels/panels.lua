local T, C, L = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales

local sbWidth = C.actionbar.sidebarWidth
local mbWidth = C.actionbar.mainbarWidth

local TukuiBar1 = CreateFrame("Frame", "TukuiBar1", UIParent, "SecureHandlerStateTemplate")
TukuiBar1:CreatePanel("Invisible", 1, 1, "BOTTOM", UIParent, "BOTTOM", 0, 45)
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
TukuiBar4:CreatePanel("Invisible", 1, 1, "BOTTOM", UIParent, "BOTTOM", 0, 45)
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
			ToggleKeyRing()
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
ileft:CreatePanel("Default", T.InfoLeftRightWidth + 12, 22, "LEFT", ltoabl, "LEFT", 2 - movechat, -10)
--ileft:SetFrameLevel(2)
ileft:CreateShadow("Default")
ileft:SetFrameStrata("MEDIUM")

-- INFO RIGHT (FOR STATS)
local iright = CreateFrame("Frame", "TukuiInfoRight", TukuiBar1)
iright:CreatePanel("Default", T.InfoLeftRightWidth + 12, 22, "RIGHT", ltoabr, "RIGHT", -2 + movechat, -11)
--iright:SetFrameLevel(2)
iright:CreateShadow("Default")
iright:SetFrameStrata("MEDIUM")

-- Alpha horizontal lines because all panels is dependent on this frame.
ltoabl:SetAlpha(0)
ltoabr:SetAlpha(0)

-- CHAT BG LEFT
local chatleftbg = CreateFrame("Frame", "TukuiChatBackgroundLeft", TukuiInfoLeft)
chatleftbg:CreatePanel("Transparent", T.InfoLeftRightWidth + 12, 112, "BOTTOM", TukuiInfoLeft, "BOTTOM", 0, 25)
chatleftbg:CreateShadow("")
	
-- CHAT BG RIGHT
local chatrightbg = CreateFrame("Frame", "TukuiChatBackgroundRight", TukuiInfoRight)
chatrightbg:CreatePanel("Transparent", T.InfoLeftRightWidth + 12, 112, "BOTTOM", TukuiInfoRight, "BOTTOM", 0, 25)
chatrightbg:CreateShadow("")
	
-- LEFT TAB PANEL
local tabsbgleft = CreateFrame("Frame", "TukuiTabsLeftBackground", TukuiChatBackgroundLeft)
tabsbgleft:CreatePanel("Default", T.InfoLeftRightWidth + 12, 22, "BOTTOMLEFT", chatleftbg, "TOPLEFT", 0, T.Scale(3))
tabsbgleft:SetFrameLevel(1)
tabsbgleft:SetFrameStrata("BACKGROUND")
tabsbgleft:CreateShadow("")

-- RIGHT TAB PANEL
local tabsbgright = CreateFrame("Frame", "TukuiTabsRightBackground", TukuiChatBackgroundRight)
tabsbgright:CreatePanel("Default", T.InfoLeftRightWidth + 12, 22, "BOTTOMLEFT", chatrightbg, "TOPLEFT", 0, T.Scale(3))
tabsbgright:SetFrameLevel(1)
tabsbgright:SetFrameStrata("BACKGROUND")
tabsbgright:CreateShadow("")

-- CHAT ANIMATION
local chat = {"TukuiChatBackgroundLeft", "TukuiChatBackgroundRight"}
local info = {"TukuiInfoLeft", "TukuiInfoRight"}

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

--Re-anchor above right chat panel
TukuiBar5:ClearAllPoints()
TukuiBar5:Point("BOTTOM", tabsbgright, "TOP", 0, 3)

petbg:ClearAllPoints()
petbg:Point("BOTTOM", TukuiBar5, "TOP", 0, 3)

TukuiBar5:SetScript("OnHide", function() petbg:ClearAllPoints() petbg:Point("BOTTOM", tabsbgright, "TOP", 0, 4) end)
TukuiBar5:SetScript("OnShow", function() petbg:ClearAllPoints() petbg:Point("BOTTOM", TukuiBar5, "TOP", 0, 3) end)

--Reposition Petbar & Rightbar (if chat right is not visible)
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
			TukuiPetBar:Point("BOTTOM", TukuiBar5, "TOP", 0, 3)
		else
			TukuiPetBar:Point("BOTTOM", tabsbgright, "TOP", 0, 3)
		end
	else
		if TukuiBar5:IsVisible() then
			TukuiPetBar:Point("BOTTOM", TukuiBar5, "TOP", 0, 3)
		else
			TukuiPetBar:Point("BOTTOM", iright, "TOP", 0, 3)
		end
	end
end
CreateFrame("Frame"):SetScript("OnUpdate", UpdatePetbar)
	
--BATTLEGROUND STATS FRAME
if C["datatext"].battleground == true then
	local bgframe = CreateFrame("Frame", "TukuiInfoLeftBattleGround", UIParent)
	bgframe:CreatePanel("Default", 1, 1, "TOPLEFT", UIParent, "BOTTOMLEFT", 0, 0)
	bgframe:SetAllPoints(ileft)
	bgframe:SetFrameStrata("HIGH")
	bgframe:SetFrameLevel(0)
	bgframe:EnableMouse(true)
end

---------------------------------------------------------
---[[ ADDITIONAL Asphyxia PANELS ]]---
---------------------------------------------------------

--TOP DUMMY FRAME DOES NOTHING 
local toppanel = CreateFrame("Frame", "TukuiTopPanel", UIParent)
toppanel:CreatePanel("Transparent", 2000, 20, "TOP", UIParent, "TOP", 0, 0)
toppanel:SetFrameStrata("BACKGROUND")
toppanel:SetFrameLevel(0)
toppanel:CreateShadow("Default")

--BOTTOM DUMMY FRAME DOES NOTHING 
local bottompanel = CreateFrame("Frame", "TukuiBottomPanel", UIParent)
bottompanel:CreatePanel("Transparent", 2000, 20, "BOTTOM", UIParent, "BOTTOM", 0, 0)
bottompanel:SetFrameStrata("BACKGROUND")
bottompanel:SetFrameLevel(0)
bottompanel:CreateShadow("Default")

--[[
-- INFO CENTER (FOR STATS)
local icenter = CreateFrame("Frame", "TukuiInfoCenter", TukuiBar1)
icenter:CreatePanel("Default", TukuiBar1:GetWidth(), 18, "TOP", TukuiBar1, "BOTTOM", 0, -3)
icenter:CreateShadow("Default")
icenter:SetFrameLevel(2)
icenter:SetFrameStrata("BACKGROUND")

-- INFO CENTER LEFT (FOR STATS)
local icenterleft = CreateFrame("Frame", "TukuiInfoCenterLeft", TukuiBar2)
icenterleft:CreatePanel("Default", TukuiBar2:GetWidth(), 18, "TOP", TukuiBar2, "BOTTOM", 0, -3)
icenterleft:CreateShadow("Default")
icenterleft:SetFrameLevel(2)
icenterleft:SetFrameStrata("BACKGROUND")

-- INFO CENTER RIGHT (FOR STATS)
local icenterright = CreateFrame("Frame", "TukuiInfoCenterRight", TukuiBar3)
icenterright:CreatePanel("Default", TukuiBar3:GetWidth(), 18, "TOP", TukuiBar3, "BOTTOM", 0, -3)
icenterright:CreateShadow("Default")
icenterright:SetFrameLevel(2)
icenterright:SetFrameStrata("BACKGROUND")
--]]

-- TIME PANEL
local watch = CreateFrame("Frame", "Tukuiwatch", UIParent)
watch:CreatePanel("Default", 53, 17, "TOP", Minimap, "BOTTOM", T.Scale(0), 8)
watch:CreateShadow("Default")
watch:SetFrameStrata("MEDIUM")
watch:SetFrameLevel(2)

-- SWITCH LAYOUT
if C.chat.background then
	local swl = CreateFrame("Button", "TukuiSwitchLayoutButton", TukuiTabsRightBackground, "SecureActionButtonTemplate")
	swl:Size(114, TukuiTabsRightBackground:GetHeight())
	swl:Point("CENTER", TukuiTabsRightBackground, "CENTER", 0, 0)
	swl:SetFrameStrata(TukuiTabsRightBackground:GetFrameStrata())
	swl:SetFrameLevel(TukuiTabsRightBackground:GetFrameLevel())
	swl:RegisterForClicks("AnyUp") swl:SetScript("OnClick", function()
		if IsAddOnLoaded("Tukui_Raid") then
			DisableAddOn("Tukui_Raid")
			EnableAddOn("Tukui_Raid_Healing")
			ReloadUI()
		elseif IsAddOnLoaded("Tukui_Raid_Healing") then
			DisableAddOn("Tukui_Raid_Healing")
			EnableAddOn("Tukui_Raid")
			ReloadUI()
		elseif not IsAddOnLoaded("Tukui_Raid_Healing") and not IsAddOnLoaded("Tukui_Raid") then
			EnableAddOn("Tukui_Raid")
			ReloadUI()
		end
	end)

	swl.Text = T.SetFontString(swl, C.media.pixelfont, 10)
	swl.Text:Point("RIGHT", swl, "RIGHT", -5, 0.5)
	swl.Text:SetText(T.StatColor..L.datatext_switch_layout)
end

-- VERSION BUTTON
local verbutton = CreateFrame("Button", "TukuiVersionButton", TukuiMinimap, "SecureActionButtonTemplate")
verbutton:CreatePanel("Default", 13, 17, "LEFT", Tukuiwatch, "RIGHT", 3, 0)
verbutton:CreateShadow("Default")
verbutton:SetAttribute("type", "macro")
verbutton:SetAttribute("macrotext", "/version")
verbutton:SetFrameStrata("MEDIUM")
verbutton:SetFrameLevel(2)

verbutton.Text = T.SetFontString(verbutton, C.media.pixelfont, 10)
verbutton.Text:Point("CENTER", verbutton, "CENTER", 0.5, 0.5)
verbutton.Text:SetText(T.StatColor.."V")

-- HELP BUTTON
local helpbutton = CreateFrame("Button", "TukuiHelpButton", TukuiMinimap, "SecureActionButtonTemplate")
helpbutton:CreatePanel("Default", 13, 17, "RIGHT", Tukuiwatch, "LEFT", -3, 0)
helpbutton:CreateShadow("Default")
helpbutton:SetAttribute("type", "macro")
helpbutton:SetAttribute("macrotext", "/help")
helpbutton:SetFrameStrata("MEDIUM")
helpbutton:SetFrameLevel(2)

helpbutton.Text = T.SetFontString(helpbutton, C.media.pixelfont, 10)
helpbutton.Text:Point("CENTER", helpbutton, "CENTER", 1, 0.5)
helpbutton.Text:SetText(T.StatColor.."H")

-- ADDONS BUTTON
local adbutton = CreateFrame("Button", "TukuiAddonsButton", UIParent, "SecureActionButtonTemplate")
adbutton:CreatePanel("Default", 100, 17, "BOTTOM", UIParent, "BOTTOM", 0, 12)
adbutton:SetAttribute("type", "macro")
adbutton:SetAttribute("macrotext", "/al")

adbutton.Text = T.SetFontString(adbutton, C.media.pixelfont, 10)
adbutton.Text:Point("CENTER", adbutton, "CENTER", 0, 0.5)
adbutton.Text:SetText(ADDONS)
adbutton.Text:SetTextColor(unpack(C["media"].statcolor))

-- RESETUI BUTTON
local resetuibutton = CreateFrame("Button", "TukuiResetUIButton", UIParent, "SecureActionButtonTemplate")
resetuibutton:CreatePanel("Default", 55, 17, "LEFT", TukuiAddonsButton, "RIGHT", 5, 0)
resetuibutton:SetAttribute("type", "macro")
resetuibutton:SetAttribute("macrotext", "/resetui")

resetuibutton.Text = T.SetFontString(resetuibutton, C.media.pixelfont, 10)
resetuibutton.Text:Point("CENTER", resetuibutton, "CENTER", 0, 0.5)
resetuibutton.Text:SetText("Reset UI")
resetuibutton.Text:SetTextColor(unpack(C["media"].statcolor))

-- RELOADUI BUTTON
local rluibutton = CreateFrame("Button", "TukuiReloadUIButton", UIParent, "SecureActionButtonTemplate")
rluibutton:CreatePanel("Default", 55, 17, "LEFT", resetuibutton, "RIGHT", 5, 0)
rluibutton:SetAttribute("type", "macro")
rluibutton:SetAttribute("macrotext", "/rl")

rluibutton.Text = T.SetFontString(rluibutton, C.media.pixelfont, 10)
rluibutton.Text:Point("CENTER", rluibutton, "CENTER", 0, 0.5)
rluibutton.Text:SetText("Reload UI")
rluibutton.Text:SetTextColor(unpack(C["media"].statcolor))

-- CONFIG BUTTON
local configbutton = CreateFrame("Button", "TukuiConfigButton", UIParent, "SecureActionButtonTemplate")
configbutton:CreatePanel("Default", 55, 17, "RIGHT", TukuiAddonsButton, "LEFT", -5, 0)
configbutton:SetAttribute("type", "macro")
configbutton:SetAttribute("macrotext", "/tc")

configbutton.Text = T.SetFontString(configbutton, C.media.pixelfont, 10)
configbutton.Text:Point("CENTER", configbutton, "CENTER", 0, 0.5)
configbutton.Text:SetText("Config UI")
configbutton.Text:SetTextColor(unpack(C["media"].statcolor))

-- MOVEUI BUTTON
local moveuibutton = CreateFrame("Button", "TukuiMoveUIButton", UIParent, "SecureActionButtonTemplate")
moveuibutton:CreatePanel("Default", 55, 17, "RIGHT", configbutton, "LEFT", -5, 0)
moveuibutton:SetAttribute("type", "macro")
moveuibutton:SetAttribute("macrotext", "/mtukui")

moveuibutton.Text = T.SetFontString(moveuibutton, C.media.pixelfont, 10)
moveuibutton.Text:Point("CENTER", moveuibutton, "CENTER", 0, 0.5)
moveuibutton.Text:SetText("Move UI")
moveuibutton.Text:SetTextColor(unpack(C["media"].statcolor))

-- MOUSEOVER FUNCTION FOR BUTTONS
local buttonsBG = CreateFrame("frame", "AsphyxiaButtonsBG", UIParent)
buttonsBG:SetPoint("TOPLEFT", moveuibutton, "TOPLEFT" ,0, 0)
buttonsBG:SetPoint("BOTTOMRIGHT", rluibutton, "BOTTOMRIGHT" ,0, 0)
buttonsBG:EnableMouse(true)

local buttons = {"TukuiMoveUIButton", "TukuiConfigButton", "TukuiAddonsButton", "TukuiResetUIButton", "TukuiReloadUIButton", "AsphyxiaButtonsBG"}

for i = 1, getn(buttons) do
	local frame = _G[buttons[i]]
	frame:SetFrameStrata("BACKGROUND")
	frame:SetFrameLevel(2)
	frame:SetAlpha(0)
	frame:CreateShadow("Default")
	frame:SetScript("OnEnter", function(self) for _, f in pairs(buttons) do _G[f]:SetAlpha(1) end end)
	frame:SetScript("OnLeave", function(self) for _, f in pairs(buttons) do _G[f]:SetAlpha(0) end end)
	frame:HookScript("OnEnter", function(self) self:SetBackdropBorderColor(unpack(C["media"].statcolor)) end)
	frame:HookScript("OnLeave", function(self) self:SetBackdropBorderColor(unpack(C["media"].bordercolor)) end)
	if i == 6 then
		frame:SetFrameLevel(0)
		frame.shadow:Hide()
	end
end

-- World Frame 
WorldStateAlwaysUpFrame:ClearAllPoints()
WorldStateAlwaysUpFrame:SetPoint("TOP", UIParent, "TOP", 0, T.Scale(-35))

