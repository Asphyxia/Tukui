local T, C, L = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales

local function ShowOrHideBar(bar, button)
	local db = TukuiDataPerChar
	
	if bar:IsShown() then
		if bar == TukuiBar5 and T.lowversion then
			if button == TukuiBar5ButtonTop then
				if TukuiBar7:IsShown() then
					TukuiBar7:Hide()
					bar:SetWidth((T.buttonsize * 2) + (T.buttonspacing * 3))
					db.hidebar7 = true
				elseif TukuiBar6:IsShown() then
					TukuiBar6:Hide()
					bar:SetWidth((T.buttonsize * 1) + (T.buttonspacing * 2))
					db.hidebar6 = true
				else
					bar:Hide()
				end
			else
				if button == TukuiBar5ButtonBottom then
					if not bar:IsShown() then
						bar:Show()
						bar:SetWidth((T.buttonsize * 1) + (T.buttonspacing * 2))
					elseif not TukuiBar6:IsShown() then
						TukuiBar6:Show()
						bar:SetWidth((T.buttonsize * 2) + (T.buttonspacing * 3))
						db.hidebar6 = false
					else
						TukuiBar7:Show()
						bar:SetWidth((T.buttonsize * 3) + (T.buttonspacing * 4))
						db.hidebar7 = false
					end
				end
			end
		else
			bar:Hide()
		end
		
		-- for bar 2�+3�+4, high reso only
		if bar == TukuiBar4 then
			TukuiBar1:SetHeight((T.buttonsize * 1) + (T.buttonspacing * 2))
			TukuiBar2:SetHeight(TukuiBar1:GetHeight())
			TukuiBar3:SetHeight(TukuiBar1:GetHeight())
			if not T.lowversion then
				for i = 7, 12 do
					local left = _G["MultiBarBottomLeftButton"..i]
					local right = _G["MultiBarBottomRightButton"..i]
					left:SetAlpha(0)
					right:SetAlpha(0)
				end
			end
		end
	else
		if bar == TukuiBar5 and T.lowversion then
			if TukuiBar7:IsShown() then
				TukuiBar7:Show()
				TukuiBar5:SetWidth((T.buttonsize * 3) + (T.buttonspacing * 4))
			elseif TukuiBar6:IsShown() then
				TukuiBar6:Show()
				TukuiBar5:SetWidth((T.buttonsize * 2) + (T.buttonspacing * 3))
			else
				bar:Show()
			end
		else
			bar:Show()
		end
		
		-- for bar 2�+3�+4, high reso only
		if bar == TukuiBar4 then
			TukuiBar1:SetHeight((T.buttonsize * 2) + (T.buttonspacing * 3))
			TukuiBar2:SetHeight(TukuiBar4:GetHeight())
			TukuiBar3:SetHeight(TukuiBar4:GetHeight())
			if not T.lowversion then
				for i = 7, 12 do
					local left = _G["MultiBarBottomLeftButton"..i]
					local right = _G["MultiBarBottomRightButton"..i]
					left:SetAlpha(1)
					right:SetAlpha(1)
				end
			end
		end
	end
end

local function MoveButtonBar(button, bar)
	local db = TukuiDataPerChar
	
	if button == TukuiBar2Button then
		if bar:IsShown() then
			db.hidebar2 = false
			button.text:SetText(T.datacolor..">")
		else
			db.hidebar2 = true
			button.text:SetText(T.datacolor.."<")
		end
	end
	
	if button == TukuiBar3Button then
		if bar:IsShown() then
			db.hidebar3 = false
			button.text:SetText(T.datacolor.."<")
		else
			db.hidebar3 = true
			button.text:SetText(T.datacolor..">")
		end
	end

	if button == TukuiBar4Button then
		if bar:IsShown() then
			db.hidebar4 = false
			button.text:SetText(T.datacolor.."Collapse")
		else
			db.hidebar4 = true
			button.text:SetText(T.datacolor.."Expand")
		end
	end
	
	if button == TukuiBar5ButtonTop or button == TukuiBar5ButtonBottom then		
		local buttontop = TukuiBar5ButtonTop
		local buttonbot = TukuiBar5ButtonBottom
		if bar:IsShown() then
			db.hidebar5 = false
			if not T.lowversion then buttontop.text:SetText(T.datacolor..">") end
			if not T.lowversion then buttonbot.text:SetText(T.datacolor..">") end		
		else
			db.hidebar5 = true
			if not T.lowversion then buttonbot.text:SetText(T.datacolor.."<") end
			if not T.lowversion then buttontop.text:SetText(T.datacolor.."<") end
		end	
	end
end

local function DrPepper(self, bar)
	if InCombatLockdown() then print(ERR_NOT_IN_COMBAT) return end
	local button = self
	ShowOrHideBar(bar, button)
	MoveButtonBar(button, bar)
end

local function ModifiedBackdrop(self)
	local color = RAID_CLASS_COLORS[T.myclass]
	self:SetBackdropColor(color.r*.15, color.g*.15, color.b*.15)
	self:SetBackdropBorderColor(color.r, color.g, color.b)
end

local function OriginalBackdrop(self)
	self:SetTemplate("Default")
end

local TukuiBar4Button = CreateFrame("Button", "TukuiBar4Button", actionBarBG)
TukuiBar4Button:CreatePanel("Default", extrasBG:GetWidth() - 8, 15, "TOP", actionBarBG, "TOP", 0, -4, true)
TukuiBar4Button:SetFrameLevel(actionBarBG:GetFrameLevel() + 1)
TukuiBar4Button:SetScript("OnMouseDown", function(self) DrPepper(self, TukuiBar4) end)
TukuiBar4Button.text:SetText(T.datacolor.."Collapse")
TukuiBar4Button:CreateOverlay(TukuiBar4Button)
TukuiBar4Button:HookScript("OnEnter", ModifiedBackdrop)
TukuiBar4Button:HookScript("OnLeave", OriginalBackdrop)

local TukuiBar5ButtonTop = CreateFrame("Button", "TukuiBar5ButtonTop", actionBarBG)
TukuiBar5ButtonTop:CreatePanel("Default", (TukuiBar4Button:GetWidth() / 2) - 2, 15, "TOPRIGHT", TukuiBar4Button, "BOTTOMRIGHT", 0, -4, true)
TukuiBar5ButtonTop:SetFrameLevel(actionBarBG:GetFrameLevel() + 1)
TukuiBar5ButtonTop:SetScript("OnMouseDown", function(self) DrPepper(self, TukuiBar5) end)
TukuiBar5ButtonTop.text:SetText(T.datacolor..">")
TukuiBar5ButtonTop:CreateOverlay(TukuiBar5ButtonTop)
TukuiBar5ButtonTop:HookScript("OnEnter", ModifiedBackdrop)
TukuiBar5ButtonTop:HookScript("OnLeave", OriginalBackdrop)

local TukuiBar5ButtonBottom = CreateFrame("Button", "TukuiBar5ButtonBottom", actionBarBG)
TukuiBar5ButtonBottom:CreatePanel("Default", (TukuiBar4Button:GetWidth() / 2) - 2, 15, "TOPLEFT", TukuiBar4Button, "BOTTOMLEFT", 0, -4, true)
TukuiBar5ButtonBottom:SetFrameLevel(actionBarBG:GetFrameLevel() + 1)
TukuiBar5ButtonBottom:SetScript("OnMouseDown", function(self) DrPepper(self, TukuiBar5) end)
TukuiBar5ButtonBottom.text:SetText(T.datacolor.."<")
TukuiBar5ButtonBottom:CreateOverlay(TukuiBar5ButtonBottom)
TukuiBar5ButtonBottom:HookScript("OnEnter", ModifiedBackdrop)
TukuiBar5ButtonBottom:HookScript("OnLeave", OriginalBackdrop)

local TukuiBar2Button = CreateFrame("Button", "TukuiBar2Button", actionBarBG)
TukuiBar2Button:CreatePanel("Default", (TukuiBar4Button:GetWidth() / 2) - 2, 15, "TOPLEFT", TukuiBar5ButtonBottom, "BOTTOMLEFT", 0, -4, true)
TukuiBar2Button:SetFrameLevel(actionBarBG:GetFrameLevel() + 1)
TukuiBar2Button:SetScript("OnMouseDown", function(self) DrPepper(self, TukuiBar2) end)
TukuiBar2Button.text:SetText(T.datacolor..">")
TukuiBar2Button:CreateOverlay(TukuiBar2Button)
TukuiBar2Button:HookScript("OnEnter", ModifiedBackdrop)
TukuiBar2Button:HookScript("OnLeave", OriginalBackdrop)

local TukuiBar3Button = CreateFrame("Button", "TukuiBar3Button", actionBarBG)
TukuiBar3Button:CreatePanel("Default", (TukuiBar4Button:GetWidth() / 2) - 2, 15, "TOPRIGHT", TukuiBar5ButtonTop, "BOTTOMRIGHT", 0, -4, true)
TukuiBar3Button:SetFrameLevel(actionBarBG:GetFrameLevel() + 1)
TukuiBar3Button:SetScript("OnMouseDown", function(self) DrPepper(self, TukuiBar3) end)
TukuiBar3Button.text:SetText(T.datacolor.."<")
TukuiBar3Button:CreateOverlay(TukuiBar3Button)
TukuiBar3Button:HookScript("OnEnter", ModifiedBackdrop)
TukuiBar3Button:HookScript("OnLeave", OriginalBackdrop)

-- exit vehicle button on left side of bottom action bar
local vehicleleft = CreateFrame("Button", "TukuiExitVehicleButtonLeft", UIParent, "SecureHandlerClickTemplate")
vehicleleft:CreatePanel("Default", 70, 20, "RIGHT", TukuiResetUIButton, "LEFT", -3, 0, true)
vehicleleft:SetScript("OnMouseDown", function() VehicleExit() end)
vehicleleft.text:SetText(T.datacolor.."Vehicle")
vehicleleft:CreateShadow("Default")
vehicleleft:CreateOverlay(vehicleleft)
vehicleleft:HookScript("OnEnter", ModifiedBackdrop)
vehicleleft:HookScript("OnLeave", OriginalBackdrop)
RegisterStateDriver(vehicleleft, "visibility", "[target=vehicle,exists] show;hide")

-- exit vehicle button on right side of bottom action bar
local vehicleright = CreateFrame("Button", "TukuiExitVehicleButtonRight", UIParent, "SecureHandlerClickTemplate")
vehicleright:CreatePanel("Default", 70, 20, "BOTTOMLEFT", TukuiReloadUIButton, "BOTTOMRIGHT", 3, 0, true)
vehicleright:RegisterForClicks("AnyUp")
vehicleright:SetScript("OnClick", function() VehicleExit() end)
vehicleright.text:SetText(T.datacolor.."Vehicle")
vehicleright:CreateShadow("Default")
vehicleright:CreateOverlay(vehicleright)
vehicleright:HookScript("OnEnter", ModifiedBackdrop)
vehicleright:HookScript("OnLeave", OriginalBackdrop)
RegisterStateDriver(vehicleright, "visibility", "[target=vehicle,exists] show;hide")

--------------------------------------------------------------
-- DrPepper taste is really good with Vodka. 
--------------------------------------------------------------

local init = CreateFrame("Frame")
init:RegisterEvent("VARIABLES_LOADED")
init:SetScript("OnEvent", function(self, event)
	if not TukuiDataPerChar then TukuiDataPerChar = {} end
	local db = TukuiDataPerChar
	
	if not T.lowversion and db.hidebar2 then 
		DrPepper(TukuiBar2Button, TukuiBar2)
	end
	
	if not T.lowversion and db.hidebar3 then
		DrPepper(TukuiBar3Button, TukuiBar3)
	end
	
	if db.hidebar4 then
		DrPepper(TukuiBar4Button, TukuiBar4)
	end
		
	if T.lowversion then
		-- because we use bar6.lua and bar7.lua with TukuiBar5Button for lower reso.
		TukuiBar2Button:Hide()
		TukuiBar3Button:Hide()
		if db.hidebar7 then
			TukuiBar7:Hide()
			TukuiBar5:SetWidth((T.buttonsize * 2) + (T.buttonspacing * 3))
		end
		
		if db.hidebar6 then
			TukuiBar6:Hide()
			TukuiBar5:SetWidth((T.buttonsize * 1) + (T.buttonspacing * 2))
		end
	end
	
	if db.hidebar5 then
		DrPepper(TukuiBar5ButtonTop, TukuiBar5)
	end
end)