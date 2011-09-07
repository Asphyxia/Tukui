local T, C, L = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales

----------------------------------------------------------------------------------
-- Config Panel For Action Bars [Credit Smelly]
----------------------------------------------------------------------------------

local function ModifiedBackdrop(self)
	local color = RAID_CLASS_COLORS[T.myclass]
	self:SetBackdropColor(color.r*.15, color.g*.15, color.b*.15)
	self:SetBackdropBorderColor(color.r, color.g, color.b)
end

local function OriginalBackdrop(self)
	self:SetTemplate("Default")
end

-- BG for action bar config
local actionBarBG = CreateFrame("Frame", "actionBarBG", UIParent)
actionBarBG:CreatePanel("Default", 150, 61, "CENTER", UIParent, "CENTER", 0, 25)
if T.lowversion then
	actionBarBG:Height(61)
else
	actionBarBG:Height(80)
end
T.fadeIn(actionBarBG)
actionBarBG:SetFrameLevel(15)
actionBarBG:Hide()

local abHeader = CreateFrame("Frame", "abHeader", actionBarBG)
abHeader:CreatePanel("Transparent", actionBarBG:GetWidth() - 1, 20, "BOTTOM", actionBarBG, "TOP", 0, 2, true)
abHeader.text:SetText(T.datacolor.."Actionbar Config Menu")

-- BG for Control Panel
local extrasBG = CreateFrame("Frame", "extrasBG", UIParent)
extrasBG:CreatePanel("Default", 152, 114 , "CENTER", UIParent, "CENTER", 0, 25)
extrasBG:SetFrameLevel(10)
extrasBG:SetFrameStrata("BACKGROUND")
extrasBG:Hide()
T.fadeIn(extrasBG)

local extraHeader = CreateFrame("Frame", "extraHeader", extrasBG)
extraHeader:CreatePanel("Transparent", extrasBG:GetWidth() - 1, 20, "BOTTOM", extrasBG, "TOP", 0, 2, true)
extraHeader.text:SetText(T.datacolor.."Control Panel Menu")

-- close button inside action bar config
local closeAB = CreateFrame("Frame", "closeAB", actionBarBG)
closeAB:CreatePanel("Default", actionBarBG:GetWidth() - 8, 15, "BOTTOM", actionBarBG, "BOTTOM", 0, 4, true)
closeAB:SetFrameLevel(actionBarBG:GetFrameLevel() + 1)
closeAB:HookScript("OnEnter", ModifiedBackdrop)
closeAB:HookScript("OnLeave", OriginalBackdrop)
closeAB.text:SetText(T.datacolor.."Close")
closeAB:CreateOverlay(closeAB)
closeAB:SetScript("OnMouseDown", function()
	T.fadeOut(actionBarBG)
	extrasBG:Show()
end)

-- slash command to open up actionbar config
function SlashCmdList.AB()
	if extrasBG:IsShown() then
		actionBarBG:Show()
		T.fadeOut(extrasBG)
	else
		actionBarBG:Show()
	end
end
SLASH_AB1 = "/ab"

-- setup config button slash commands
local buttons = {
	[1] = {"/ab"},
	[2] = {"/am"},
	[3] = {"/tc"},
	[4] = {"/mtukui"},
}

-- setup text in each button
local texts = {
	[1] = {T.datacolor.."Actionbar Config"},
	[2] = {T.datacolor.."Addons"},
	[3] = {T.datacolor.."Config UI"},
	[4] = {T.datacolor.."Move UI"},
}

-- create the config buttons
local button = CreateFrame("Button", "button", extrasBG)
for i = 1, getn(buttons) do
	button[i] = CreateFrame("Button", "button"..i, extrasBG, "SecureActionButtonTemplate")
	button[i]:CreatePanel("Default", extrasBG:GetWidth() - 8, 24, "TOP", extrasBG, "TOP", 0, -4, true)
	button[i]:SetFrameLevel(extrasBG:GetFrameLevel() + 1)
	button[i].text:SetText(unpack(texts[i]))
	if i == 1 then
		button[i]:Point("TOP", extrasBG, "TOP", 0, -5)
	else
		button[i]:Point("TOP", button[i-1], "BOTTOM", 0, -3)
	end
	button[i]:SetAttribute("type", "macro")
	button[i]:SetAttribute("macrotext", unpack(buttons[i]))
	button[i]:SetFrameStrata("BACKGROUND")
	button[i]:CreateOverlay(button[i])
	button[i]:HookScript("OnEnter", ModifiedBackdrop)
	button[i]:HookScript("OnLeave", OriginalBackdrop)
end

local close = CreateFrame("Button", "close", extrasBG)
close:CreatePanel("Default", extrasBG:GetWidth() - 8, 24, "TOP", button[7], "BOTTOM", 0, -3, true)
close:SetFrameLevel(extrasBG:GetFrameLevel() + 1)
close:SetFrameStrata("BACKGROUND")
close.text:SetText(T.datacolor.."Close")
close:HookScript("OnEnter", ModifiedBackdrop)
close:HookScript("OnLeave", OriginalBackdrop)
close:SetScript("OnMouseDown", function()
	T.fadeOut(extrasBG)
end)

local extraToggle = CreateFrame("Frame", "extraToggle", UIParent)
extraToggle:CreatePanel("Default", 100, 20, "BOTTOM", UIParent, "BOTTOM", 0, 2, true)
extraToggle:CreateBorder(false, true)
extraToggle:SetFrameLevel(2)
extraToggle:SetFrameStrata("LOW")
extraToggle:CreateShadow("Default")
extraToggle:CreateOverlay(extraToggle)
extraToggle.text:SetText(T.datacolor.."Control Panel")
extraToggle:HookScript("OnEnter", ModifiedBackdrop)
extraToggle:HookScript("OnLeave", OriginalBackdrop)

extraToggle:SetScript("OnMouseDown", function(self)
if InCombatLockdown() then print(ERR_NOT_IN_COMBAT) return end
	if not extrasBG:IsShown() then
		extrasBG:Show()
		T.fadeOut(actionBarBG)
	else
		T.fadeOut(extrasBG)
	end
end)