local T, C, L = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales
local myPlayerName  = UnitName("player")
local font, fontsize, fontstyle = C.media.pixelfont, 8, "MONOCHROMEOUTLINE"

local function ModifiedBackdrop(self)
	local color = RAID_CLASS_COLORS[T.myclass]
	self:SetBackdropColor(color.r, color.g, color.b, 0.15)
	self:SetBackdropBorderColor(color.r, color.g, color.b)
end

local function OriginalBackdrop(self)
	self:SetBackdropColor(unpack(C["media"].backdropcolor))
	self:SetBackdropBorderColor(unpack(C["media"].bordercolor))
end

local loadf = CreateFrame("frame", "aLoadFrame", UIParent)
loadf:Size(T.InfoLeftRightWidth, 514)
loadf:SetPoint("CENTER")
loadf:EnableMouse(true)
loadf:SetMovable(true)
loadf:SetUserPlaced(true)
loadf:SetClampedToScreen(true)
loadf:SetScript("OnMouseDown", function(self) self:StartMoving() end)
loadf:SetScript("OnMouseUp", function(self) self:StopMovingOrSizing() end)
loadf:SetFrameStrata("DIALOG")
tinsert(UISpecialFrames, "aLoadFrame")

loadf.Text = T.SetFontString(loadf, font, fontsize, fontstyle)
loadf.Text:SetPoint("TOPLEFT", 10, -8)
loadf.Text:SetText(T.panelcolor..ADDONS..": "..myPlayerName)

local savesetttings = CreateFrame("Button", "al_SaveSettings", aLoadFrame, "SecureActionButtonTemplate")
savesetttings:CreatePanel("Default", 130, 20, "BOTTOMRIGHT", loadf, "BOTTOM", -3, 9)
savesetttings:SetFrameStrata("TOOLTIP")

savesetttings.Text = T.SetFontString(savesetttings, font, fontsize, fontstyle)
savesetttings.Text:Point("CENTER", savesetttings, "CENTER", 1, 0)
savesetttings.Text:SetText(T.panelcolor.."Save Changes")


savesetttings:SetScript("OnClick", function() ReloadUI() end)
savesetttings:HookScript("OnEnter", ModifiedBackdrop)
savesetttings:HookScript("OnLeave", OriginalBackdrop)

local closewindow = CreateFrame("Button", "al_Close", aLoadFrame, "SecureActionButtonTemplate")
closewindow:CreatePanel("Default", 130, 20, "TOPLEFT", savesetttings, "TOPRIGHT", 3, 0)
closewindow:SetFrameStrata("TOOLTIP")

closewindow.Text = T.SetFontString(closewindow, font, fontsize, fontstyle)
closewindow.Text:Point("CENTER", closewindow, "CENTER", 1, 0)
closewindow.Text:SetText(T.panelcolor.."Close")


closewindow:SetScript("OnClick", function() loadf:Hide() end)
closewindow:HookScript("OnEnter", ModifiedBackdrop)
closewindow:HookScript("OnLeave", OriginalBackdrop)

loadf:SetTemplate("Transparent")
loadf:CreateShadow("Default")
loadf:Hide()
loadf:SetScript("OnHide", function(self) end)

local scrollf = CreateFrame("ScrollFrame", "a_Scroll", loadf, "UIPanelScrollFrameTemplate")
local mainf = CreateFrame("frame", "aloadmainf", scrollf)

scrollf:SetPoint("TOPLEFT", loadf, "TOPLEFT", 10, -30)
scrollf:SetPoint("BOTTOMRIGHT", loadf, "BOTTOMRIGHT", -28, 40)
scrollf:SetScrollChild(mainf)

-- Border for Addons list
local FrameBorder = CreateFrame("Frame", nil, scrollf)
FrameBorder:SetPoint("TOPLEFT", scrollf, "TOPLEFT", T.Scale(-2), T.Scale(2))
FrameBorder:SetPoint("BOTTOMRIGHT", scrollf, "BOTTOMRIGHT", T.Scale(2), T.Scale(-2))
FrameBorder:SetTemplate("Transparent")
FrameBorder:SetFrameLevel(scrollf:GetFrameLevel() - 1)

local makeList = function()
	local self = mainf
	self:SetPoint("TOPLEFT")
	self:SetWidth(scrollf:GetWidth())
	self:SetHeight(scrollf:GetHeight())
	self.addons = {}
	for i=1, GetNumAddOns() do
		self.addons[i] = select(1, GetAddOnInfo(i))
	end
	table.sort(self.addons)

	local oldb

	for i,v in pairs(self.addons) do
		local name, title, notes, enabled, loadable, reason, security = GetAddOnInfo(v)

		if name then
			local bf = _G[v.."_cbf"] or CreateFrame("CheckButton", v.."_cbf", self, "OptionsCheckButtonTemplate")
			bf:EnableMouse(true)
			bf.title = title.."|n"
			if notes then bf.title = bf.title.."|cffffffff"..notes.."|r|n" end
			if (GetAddOnDependencies(v)) then
				bf.title = "|cffff4400Dependent Resources: |r"
				for i=1, select("#", GetAddOnDependencies(v)) do
					bf.title = bf.title..select(i,GetAddOnDependencies(v))
					if (i>1) then bf.title=bf.title..", " end
				end
				bf.title = bf.title.."|r"
			end
				
			if i==1 then
				bf:SetPoint("TOPLEFT",self, "TOPLEFT", 6, -10)
			else
				bf:SetPoint("TOP", oldb, "BOTTOM", 0, 7)
			end
	
			bf:SetScript("OnEnter", function(self)
				GameTooltip:ClearLines()
				GameTooltip:SetOwner(self, ANCHOR_TOPRIGHT)
				GameTooltip:AddLine(self.title)
				GameTooltip:Show()
			end)
			
			bf:SetScript("OnLeave", function(self)
				GameTooltip:Hide()
			end)
			
			bf:SetScript("OnClick", function()
				local _, _, _, enabled = GetAddOnInfo(name)
				if enabled then
					DisableAddOn(name)
				else
					EnableAddOn(name)
				end
			end)
			bf:SetChecked(enabled)
			
			_G[v.."_cbfText"]:SetText(title)
			_G[v.."_cbfText"]:SetFont(font, fontsize, fontstyle)

			oldb = bf
		end
	end
end

makeList()

-- Slash commands
SLASH_ALOAD1 = "/am"
SlashCmdList.ALOAD = function (msg)
	loadf:Show()
end