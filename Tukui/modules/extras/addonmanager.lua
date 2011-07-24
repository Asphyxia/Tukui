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
loadf.Text:SetText(T.panelcolor..ADDONS..": "..T.panelcolor..T.myname)

local savesetttings = CreateFrame("Button", "al_SaveSettings", aLoadFrame)
savesetttings:CreatePanel("Default", 130, 23, "BOTTOMRIGHT", loadf, "BOTTOM", -2, 8)
savesetttings:SetFrameStrata("TOOLTIP")

savesetttings.Text = T.SetFontString(savesetttings, font, fontsize, fontstyle)
savesetttings.Text:Point("CENTER", savesetttings, "CENTER", 1, 0)
savesetttings.Text:SetText(T.panelcolor..SAVE_CHANGES)

savesetttings:SetScript("OnClick", function() ReloadUI() end)
savesetttings:HookScript("OnEnter", ModifiedBackdrop)
savesetttings:HookScript("OnLeave", OriginalBackdrop)

local closewindow = CreateFrame("Button", "al_Close", aLoadFrame)
closewindow:CreatePanel("Default", 130, 23, "TOPLEFT", savesetttings, "TOPRIGHT", 4, 0)
closewindow:SetFrameStrata("TOOLTIP")

closewindow.Text = T.SetFontString(closewindow, font, fontsize, fontstyle)
closewindow.Text:Point("CENTER", closewindow, "CENTER", 1, 0)
closewindow.Text:SetText(T.panelcolor..CLOSE)

closewindow:SetScript("OnClick", function() loadf:Hide() end)
closewindow:HookScript("OnEnter", ModifiedBackdrop)
closewindow:HookScript("OnLeave", OriginalBackdrop)

loadf:SetTemplate("Default")
loadf:CreateShadow("Default")
loadf:Hide()
loadf:SetScript("OnHide", function(self) end)

local scrollf = CreateFrame("ScrollFrame", "a_Scroll", loadf, "UIPanelScrollFrameTemplate")
local mainf = CreateFrame("frame", "aloadmainf", scrollf)

scrollf:SetPoint("TOPLEFT", loadf, "TOPLEFT", 10, -30)
scrollf:SetPoint("BOTTOMRIGHT", loadf, "BOTTOMRIGHT", -28, 40)
scrollf:SetScrollChild(mainf)
scrollf:CreateBackdrop("Default")

local raid_addons = CreateFrame("Button", "TukuiEnableRaidButton", aLoadFrame)
raid_addons:CreatePanel("Default", 60, 17, "TOPRIGHT", loadf, "TOPRIGHT", -26, -6)
raid_addons:CreateShadow("Default")
raid_addons:SetFrameStrata(aLoadFrame:GetFrameStrata())
raid_addons:SetFrameLevel(aLoadFrame:GetFrameLevel() + 1)
raid_addons:RegisterForClicks("AnyUp") raid_addons:SetScript("OnClick", function()
	EnableAddOn("DBM-Core")   -- change this to your bossmod "BigWigs"
	EnableAddOn("Recount")    -- change this to your damage meters "TinyDPS" "Skada"
	ReloadUI()
end)

raid_addons:HookScript("OnEnter", ModifiedBackdrop)
raid_addons:HookScript("OnLeave", OriginalBackdrop)

raid_addons.Text = T.SetFontString(raid_addons, C.media.pixelfont, C["datatext"].fontsize, "MONOCHROMEOUTLINE")
raid_addons.Text:Point("CENTER", raid_addons, "CENTER", 1, 1)
raid_addons.Text:SetText(T.panelcolor..RAID)

local solo_addons = CreateFrame("Button", "TukuiEnableSoloButton", aLoadFrame)
solo_addons:CreatePanel("Default", 80, 17, "RIGHT", raid_addons, "LEFT", -3, 0)
solo_addons:CreateShadow("Default")
solo_addons:SetFrameStrata(aLoadFrame:GetFrameStrata())
solo_addons:SetFrameLevel(aLoadFrame:GetFrameLevel() + 1)
solo_addons:RegisterForClicks("AnyUp") solo_addons:SetScript("OnClick", function()
	DisableAddOn("DBM-Core")     -- change this to your bossmod "BigWigs"
	DisableAddOn("Recount")      -- change this to your damage meters "TinyDPS" "Skada"
	ReloadUI()
end)

solo_addons:HookScript("OnEnter", ModifiedBackdrop)
solo_addons:HookScript("OnLeave", OriginalBackdrop)

solo_addons.Text = T.SetFontString(solo_addons, C.media.pixelfont, C["datatext"].fontsize, "MONOCHROMEOUTLINE")
solo_addons.Text:Point("CENTER", solo_addons, "CENTER", 1, 1)
solo_addons.Text:SetText(T.panelcolor..SOLO)

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
				bf.title = L.addon_dep
				for i=1, select("#", GetAddOnDependencies(v)) do
					bf.title = bf.title..select(i,GetAddOnDependencies(v))
					if (i>1) then bf.title=bf.title..", " end
				end
				bf.title = bf.title.."|r"
			end
				
			if i==1 then
				bf:SetPoint("TOPLEFT",self, "TOPLEFT", 6, -4)
			else
				bf:SetPoint("TOP", oldb, "BOTTOM", 0, -2)
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
			
			_G[v.."_cbf"]:StripTextures()
			_G[v.."_cbf"]:SetTemplate("Default")
			_G[v.."_cbf"]:SetCheckedTexture("Interface\\Buttons\\UI-CheckBox-Check")
			_G[v.."_cbf"]:Size(18, 18)
			_G[v.."_cbf"]:GetCheckedTexture():Point("TOPLEFT", -4, 4)
			_G[v.."_cbf"]:GetCheckedTexture():Point("BOTTOMRIGHT", 4, -4)
			
			_G[v.."_cbfText"]:SetText(title)
			_G[v.."_cbfText"]:SetFont(font, fontsize, fontstyle)
			_G[v.."_cbfText"]:Point("LEFT", bf, "RIGHT", 5, 1)

			oldb = bf
		end
	end
end

makeList()

--T.SkinScrollBar(a_ScrollScrollBar, 5)

-- Slash commands
SLASH_ALOAD1 = "/am"
SlashCmdList.ALOAD = function (msg)
	loadf:Show()
end