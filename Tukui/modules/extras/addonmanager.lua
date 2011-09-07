local T, C, L = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales
local font, fontsize, fontstyle = C.media.pixelfont, C["datatext"].fontsize, "MONOCHROMEOUTLINE"

local function ModifiedBackdrop(self)
	local color = RAID_CLASS_COLORS[T.myclass]
	self:SetBackdropColor(color.r*.15, color.g*.15, color.b*.15)
	self:SetBackdropBorderColor(color.r, color.g, color.b)
end

local function OriginalBackdrop(self)
	self:SetTemplate("Default")
end

-- Create BG
local addonBG = CreateFrame("Frame", "addonBG", UIParent)
addonBG:CreatePanel("Default", T.InfoLeftRightWidth, 500, "CENTER", UIParent, "CENTER", 0, 0)
addonBG:EnableMouse(true)
addonBG:SetMovable(true)
addonBG:SetUserPlaced(true)
addonBG:SetClampedToScreen(true)
addonBG:SetScript("OnMouseDown", function(self) self:StartMoving() end)
addonBG:SetScript("OnMouseUp", function(self) self:StopMovingOrSizing() end)
addonBG:SetFrameStrata("HIGH")
addonBG:CreateShadow("Default")
T.fadeIn(addonBG)
addonBG:Hide()

local addonHeader = CreateFrame("Frame", "addonHeader", addonBG)
addonHeader:CreatePanel("Transparent", addonBG:GetWidth(), 23, "BOTTOM", addonBG, "TOP", 0, 3, true)
addonHeader.Text = T.SetFontString(addonHeader, font, fontsize, fontstyle)
addonHeader.Text:SetPoint("LEFT", 5, 1)
addonHeader.Text:SetText(T.datacolor.."AddOns List"..": "..T.datacolor..T.myname)

-- Create scroll frame
local scrollFrame = CreateFrame("ScrollFrame", "scrollFrame", addonBG, "UIPanelScrollFrameTemplate")
scrollFrame:SetPoint("TOPLEFT", addonBG, "TOPLEFT", 10, -10)
scrollFrame:SetPoint("BOTTOMRIGHT", addonBG, "BOTTOMRIGHT", -30, 40)
T.SkinScrollBar(scrollFrameScrollBar)

-- Create inside BG (uses scroll frame)
local buttonsBG = CreateFrame("Frame", "buttonsBG", scrollFrame)
buttonsBG:SetPoint("TOPLEFT")
buttonsBG:SetWidth(scrollFrame:GetWidth())
buttonsBG:SetHeight(scrollFrame:GetHeight())
scrollFrame:SetScrollChild(buttonsBG)

local saveButton = CreateFrame("Button", "saveButton", addonBG)
saveButton:CreatePanel("Default", 130, 20, "BOTTOMLEFT", addonBG, "BOTTOMLEFT", 10, 10, true)
saveButton:SetFrameStrata("TOOLTIP")
saveButton:CreateOverlay(saveButton)
saveButton.text:SetText(T.datacolor.."Save Changes")
saveButton:SetScript("OnClick", function() ReloadUI() end)
saveButton:HookScript("OnEnter", ModifiedBackdrop)
saveButton:HookScript("OnLeave", OriginalBackdrop)

local closeButton = CreateFrame("Button", "closeButton", addonBG)
closeButton:CreatePanel("Default", 130, 20, "BOTTOMRIGHT", addonBG, "BOTTOMRIGHT", -10, 10, true)
closeButton.text:SetText(T.datacolor.."Cancel")
closeButton:SetFrameStrata("TOOLTIP")
closeButton:CreateOverlay(closeButton)
closeButton:SetScript("OnClick", function() T.fadeOut(addonBG) end)
closeButton:HookScript("OnEnter", ModifiedBackdrop)
closeButton:HookScript("OnLeave", OriginalBackdrop)

local raid_addons = CreateFrame("Button", "TukuiEnableRaidButton", addonHeader)
raid_addons:CreatePanel("Transparent", 60, 17, "RIGHT", addonHeader, "RIGHT", -5, 0)
raid_addons:CreateShadow("Default")
raid_addons:CreateOverlay(raid_addons)
raid_addons:SetFrameStrata(addonHeader:GetFrameStrata())
raid_addons:SetFrameLevel(addonHeader:GetFrameLevel() + 1)
raid_addons:RegisterForClicks("AnyUp") raid_addons:SetScript("OnClick", function()
	EnableAddOn("DBM-Core")   -- change this to your bossmod "BigWigs"
	EnableAddOn("Recount")    -- change this to your damage meters "TinyDPS" "Skada"
	ReloadUI()
end)

raid_addons:HookScript("OnEnter", ModifiedBackdrop)
raid_addons:HookScript("OnLeave", OriginalBackdrop)

raid_addons.Text = T.SetFontString(raid_addons, C.media.pixelfont, C["datatext"].fontsize, "MONOCHROMEOUTLINE")
raid_addons.Text:Point("CENTER", raid_addons, "CENTER", 1, 1)
raid_addons.Text:SetText(T.datacolor..RAID)

local solo_addons = CreateFrame("Button", "TukuiEnableSoloButton", addonHeader)
solo_addons:CreatePanel("Transparent", 60, 17, "RIGHT", raid_addons, "LEFT", -3, 0)
solo_addons:CreateShadow("Default")
solo_addons:CreateOverlay(solo_addons)
solo_addons:SetFrameStrata(addonHeader:GetFrameStrata())
solo_addons:SetFrameLevel(addonHeader:GetFrameLevel() + 1)
solo_addons:RegisterForClicks("AnyUp") solo_addons:SetScript("OnClick", function()
	DisableAddOn("DBM-Core")     -- change this to your bossmod "BigWigs"
	DisableAddOn("Recount")      -- change this to your damage meters "TinyDPS" "Skada"
	ReloadUI()
end)

solo_addons:HookScript("OnEnter", ModifiedBackdrop)
solo_addons:HookScript("OnLeave", OriginalBackdrop)

solo_addons.Text = T.SetFontString(solo_addons, C.media.pixelfont, C["datatext"].fontsize, "MONOCHROMEOUTLINE")
solo_addons.Text:Point("CENTER", solo_addons, "CENTER", 1, 1)
solo_addons.Text:SetText(T.datacolor..SOLO)

local function UpdateAddons()
	local addons = {}
	for i=1, GetNumAddOns() do
		addons[i] = select(1, GetAddOnInfo(i))
	end
	table.sort(addons)
	local oldb
	for i,v in pairs(addons) do
		local name, title, notes, enabled, loadable, reason, security = GetAddOnInfo(v)
		local button = CreateFrame("Button", v.."_Button", buttonsBG, "SecureActionButtonTemplate")
		button:SetFrameLevel(buttonsBG:GetFrameLevel() + 1)
		button:Size(50, 16)
		button:SetTemplate("Default")
		button:CreateOverlay()

		-- to make sure the border is colored the right color on reload 
		if enabled then
			button:SetBackdropBorderColor(0,1,0)
		else
			button:SetBackdropBorderColor(1,0,0)
		end

		if i==1 then
			button:Point("TOPLEFT", buttonsBG, "TOPLEFT", 0, 0)
		else
			button:Point("TOP", oldb, "BOTTOM", 0, -7)
		end
		local text = T.SetFontString(button, C.media.pixelfont, C["datatext"].fontsize, "MONOCHROMEOUTLINE")
		text:Point("LEFT", button, "RIGHT", 8, 0)
		text:SetText(title)
	
		 button:SetScript("OnMouseDown", function()
            if enabled then
                button:SetBackdropBorderColor(1,0,0)
                DisableAddOn(name)
                enabled = false
            else
                button:SetBackdropBorderColor(0,1,0)
                EnableAddOn(name)
                enabled = true
            end
        end)
	
		oldb = button
	end
end

UpdateAddons()

-- Slash commands
SLASH_ALOAD1 = "/am"
SlashCmdList.ALOAD = function (msg)
	addonBG:Show()
end
