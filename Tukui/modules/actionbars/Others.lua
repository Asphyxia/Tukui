
local T, C, L = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales
if not C["actionbar"].enable == true then return end
---------------------------------------------------------------------------
-- Manage all others stuff for actionbars
---------------------------------------------------------------------------

local TukuiOnLogon = CreateFrame("Frame")
TukuiOnLogon:RegisterEvent("PLAYER_ENTERING_WORLD")
TukuiOnLogon:SetScript("OnEvent", function(self, event)
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")	
	SetActionBarToggles(1, 1, 1, 1, 0)
	SetCVar("alwaysShowActionBars", 0)	
	if C["actionbar"].showgrid == true then
		ActionButton_HideGrid = T.dummy
		for i = 1, 12 do
			local button = _G[format("ActionButton%d", i)]
			button:SetAttribute("showgrid", 1)
			ActionButton_ShowGrid(button)

			button = _G[format("BonusActionButton%d", i)]
			button:SetAttribute("showgrid", 1)
			ActionButton_ShowGrid(button)
			
			button = _G[format("MultiBarRightButton%d", i)]
			button:SetAttribute("showgrid", 1)
			ActionButton_ShowGrid(button)

			button = _G[format("MultiBarBottomRightButton%d", i)]
			button:SetAttribute("showgrid", 1)
			ActionButton_ShowGrid(button)
			
			button = _G[format("MultiBarLeftButton%d", i)]
			button:SetAttribute("showgrid", 1)
			ActionButton_ShowGrid(button)
			
			button = _G[format("MultiBarBottomLeftButton%d", i)]
			button:SetAttribute("showgrid", 1)
			ActionButton_ShowGrid(button)
		end
	end
end)

local function ModifiedBackdrop(self)
	local color = RAID_CLASS_COLORS[T.myclass]
	self:SetBackdropColor(color.r*.15, color.g*.15, color.b*.15)
	self:SetBackdropBorderColor(color.r, color.g, color.b)
end

local function OriginalBackdrop(self)
	self:SetTemplate("Default")
end

local vehicle = CreateFrame("Button", "TukuiExitVehicleButton", UIParent, "SecureHandlerClickTemplate")
vehicle:CreatePanel("Default", T.buttonsize * 2, T.buttonsize + 1, "BOTTOMRIGHT", TukuiChatBackgroundRight, "BOTTOMLEFT", -3, 0)
vehicle:CreateOverlay(vehicle)
vehicle:RegisterForClicks("AnyUp")
vehicle:SetScript("OnClick", function() VehicleExit() end)
vehicle.text = T.SetFontString(vehicle, C.media.pixelfont, C["datatext"].fontsize, "MONOCHROMEOUTLINE")
vehicle.text:Point("CENTER", 1, 1)
vehicle.text:SetText(T.datacolor.."Exit")
RegisterStateDriver(vehicle, "visibility", "[target=vehicle,exists] show;hide")

vehicle:HookScript("OnEnter", ModifiedBackdrop)
vehicle:HookScript("OnLeave", OriginalBackdrop)
