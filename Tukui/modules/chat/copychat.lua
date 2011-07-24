local T, C, L = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales
-----------------------------------------------------------------------------
-- Copy on chatframes feature
-----------------------------------------------------------------------------

if C["chat"].enable ~= true then return end

local lines = {}
local frame = nil
local editBox = nil
local isf = nil

local function CreatCopyFrame()
	frame = CreateFrame("Frame", "CopyFrame", UIParent)
	frame:SetTemplate("Default")
	if T.lowversion then
		frame:Width(TukuiBar1:GetWidth() + 10)
	else
		frame:Width((TukuiBar1:GetWidth() * 2) + 20)
	end
	frame:Height(250)
	frame:SetScale(1)
	frame:Point("BOTTOM", UIParent, "BOTTOM", 0, 8)
	frame:Hide()
	frame:SetFrameStrata("DIALOG")

	local scrollArea = CreateFrame("ScrollFrame", "CopyScroll", frame, "UIPanelScrollFrameTemplate")
	scrollArea:Point("TOPLEFT", frame, "TOPLEFT", 8, -30)
	scrollArea:Point("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -30, 8)

	editBox = CreateFrame("EditBox", "CopyBox", frame)
	editBox:SetMultiLine(true)
	editBox:SetMaxLetters(99999)
	editBox:EnableMouse(true)
	editBox:SetAutoFocus(false)
	editBox:SetFontObject(ChatFontNormal)
	if T.lowversion then
		editBox:Width(TukuiBar1:GetWidth() + 10)
	else
		editBox:Width((TukuiBar1:GetWidth() * 2) + 20)
	end
	editBox:Height(250)
	editBox:SetScript("OnEscapePressed", function() frame:Hide() end)

	scrollArea:SetScrollChild(editBox)

	local close = CreateFrame("Button", "CopyCloseButton", frame, "UIPanelCloseButton")
	close:SetPoint("TOPRIGHT", frame, "TOPRIGHT")

	isf = true
end

local function GetLines(...)
	--[[		Grab all those lines		]]--
	local ct = 1
	for i = select("#", ...), 1, -1 do
		local region = select(i, ...)
		if region:GetObjectType() == "FontString" then
			lines[ct] = tostring(region:GetText())
			ct = ct + 1
		end
	end
	return ct - 1
end

local function Copy(cf)
	local _, size = cf:GetFont()
	FCF_SetChatWindowFontSize(cf, cf, 0.01)
	local lineCt = GetLines(cf:GetRegions())
	local text = table.concat(lines, "\n", 1, lineCt)
	FCF_SetChatWindowFontSize(cf, cf, size)
	if not isf then CreatCopyFrame() end
	if frame:IsShown() then frame:Hide() return end
	frame:Show()
	editBox:SetText(text)
end

local function ChatCopyButtons()
	for i = 1, NUM_CHAT_WINDOWS do
		local cf = _G[format("ChatFrame%d",  i)]
		local button = CreateFrame("Button", format("ButtonCF%d", i), cf)
		local id = cf:GetID()
		local point = GetChatWindowSavedPosition(id)
		button:Size(40, 17)
		button:Point("TOPRIGHT", 0, 24)
		button:SetFrameStrata("BACKGROUND")
		button:SetBackdropBorderColor(unpack(C["media"].bordercolor))
		button:SetBackdropColor(unpack(C["media"].backdropcolor))
		
		local buttontext = button:CreateFontString(nil,"OVERLAY",nil)
		buttontext:SetFont(C.media.pixelfont, C["datatext"].fontsize, "MONOCHROMEOUTLINE")
		buttontext:SetText(T.panelcolor.."Copy")
		buttontext:SetShadowColor(0, 0, 0)
		buttontext:SetShadowOffset(1.25, -1.25)
		buttontext:Point("CENTER", 1, 1)
		buttontext:SetJustifyH("CENTER")
		buttontext:SetJustifyV("CENTER")
				
		button:SetScript("OnMouseUp", function(self, btn)
			if btn == "RightButton" then
				ToggleFrame(ChatMenu)
			else
				Copy(cf)
			end
		end)
		button:SetScript("OnEnter", function() button:SetAlpha(10) buttontext:SetText(T.panelcolor.."Copy") end)
		
		local bnb = function() -- just to shorten the code
			button:SetAlpha(10)
			button:SetScript("OnLeave", function() button:SetAlpha(10) buttontext:SetText(T.panelcolor.."Copy") end)
			button:ClearAllPoints()
			button:SetPoint("TOPRIGHT", 0, 22)
		end
		
		-- check chat position
		if point == "BOTTOMLEFT" or point == "LEFT" then
			if C.chat.leftchatbackground then
				button:SetScript("OnLeave", function() buttontext:SetText(T.panelcolor.."Copy") end)
				if i == 2 and GetChannelName("Log") and not IsAddOnLoaded("nibHideBlackBar") then
					button:Point("TOPRIGHT", 0, 24)
				end
			else
				bnb()
			end
		elseif point == "BOTTOMRIGHT" or point == "RIGHT" then
			if C.chat.rightchatbackground then
				button:SetScript("OnLeave", function() buttontext:SetText(T.panelcolor.."Copy") end)
				button:Point("TOPRIGHT", 0, 24)
				
			else
				bnb()
			end
		else
			if C.chat.leftchatbackground then
				if i == 2 and GetChannelName("Log") then
					button:Point("TOPRIGHT", 0, 48)
				end
				button:SetScript("OnLeave", function() buttontext:SetText(T.panelcolor.."Copy") end)
			else
				bnb()
			end
		end
	end
end
ChatCopyButtons()