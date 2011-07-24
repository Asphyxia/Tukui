local T, C, L = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales
-- This is the file for our action bars settings in game via mouseover buttons around action bars.
-- I really hope you'll understand the code, because I was totally drunk when I wrote this file.
-- At least, it work fine. :P (lol)

local function ShowOrHideBar(bar, button)
	local db = TukuiDataPerChar
	
	
	if bar:IsShown() then
		if bar == TukuiBar5 and T.lowversion then
			if button == TukuiBar5ButtonTop then
				if TukuiBar7:IsShown() then
					TukuiBar7:Hide()
					if C.actionbar.bgPanel then
						bar:SetWidth((T.buttonsize * 2) + (T.buttonspacing * 3))
					else
						bar:SetWidth((T.buttonsize * 2) + (T.buttonspacing))
					end
					db.hidebar7 = true
				elseif TukuiBar6:IsShown() then
					TukuiBar6:Hide()
					if C.actionbar.bgPanel then
						bar:SetWidth((T.buttonsize) + (T.buttonspacing * 2))
					else
						bar:SetWidth((T.buttonsize))
					end
					db.hidebar6 = true
				else
					bar:Hide()
				end
			else
				if button == TukuiBar5ButtonBottom then
					if not bar:IsShown() then
						bar:Show()
						if C.actionbar.bgPanel then
							bar:SetWidth((T.buttonsize) + (T.buttonspacing * 2))
						else
							bar:SetWidth((T.buttonsize))
						end
					elseif not TukuiBar6:IsShown() then
						TukuiBar6:Show()
						if C.actionbar.bgPanel then
							bar:SetWidth((T.buttonsize * 2) + (T.buttonspacing * 3))
						else
							bar:SetWidth((T.buttonsize * 2) + (T.buttonspacing))
						end
						db.hidebar6 = false
					else
						TukuiBar7:Show()
						if C.actionbar.bgPanel then
							bar:SetWidth((T.buttonsize * 3) + (T.buttonspacing * 4))
						else
							bar:SetWidth((T.buttonsize * 3) + (T.buttonspacing * 2))
						end
						db.hidebar7 = false
					end
				end
			end
		else
			bar:Hide()
		end
		
		-- for bar 2�+3�+4, high reso only
		if bar == TukuiBar4 then
			local bsize = T.buttonsize
			if C.actionbar.bgPanel then
				bsize = (T.buttonsize + (T.buttonspacing*2))
			end
			TukuiBar1:SetHeight(bsize)
			TukuiBar2:SetHeight(bsize)
			TukuiBar3:SetHeight(bsize)
			TukuiBar2Button:SetHeight(bsize)
			TukuiBar3Button:SetHeight(bsize)
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
			if C.actionbar.bgPanel then
				TukuiBar1:SetHeight((T.buttonsize * 2) + (T.buttonspacing*3))
			else
				TukuiBar1:SetHeight((T.buttonsize * 2) + (T.buttonspacing))
			end
			TukuiBar2:SetHeight(TukuiBar4:GetHeight())
			TukuiBar3:SetHeight(TukuiBar4:GetHeight())
			TukuiBar2Button:SetHeight(TukuiBar2:GetHeight())
			TukuiBar3Button:SetHeight(TukuiBar3:GetHeight())
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
			button:ClearAllPoints()
			button:Point("BOTTOMRIGHT", TukuiBar2, "BOTTOMLEFT", -3, 0)
			button.text:SetText(T.panelcolor..">")
		else
			db.hidebar2 = true
			button:ClearAllPoints()
			button:Point("BOTTOMRIGHT", TukuiBar1, "BOTTOMLEFT", -3, 0)
			button.text:SetText(T.panelcolor.."<")
		end
	end
	
	if button == TukuiBar3Button then
		if bar:IsShown() then
			db.hidebar3 = false
			button:ClearAllPoints()
			button:Point("BOTTOMLEFT", TukuiBar3, "BOTTOMRIGHT", 3, 0)
			button.text:SetText(T.panelcolor.."<")
		else
			db.hidebar3 = true
			button:ClearAllPoints()
			button:Point("BOTTOMLEFT", TukuiBar1, "BOTTOMRIGHT", 3, 0)
			button.text:SetText(T.panelcolor..">")
		end
	end

	if button == TukuiBar4Button then
		if bar:IsShown() then
			db.hidebar4 = false
			button.text:SetText(T.panelcolor.."Collapse")
		else
			db.hidebar4 = true
			button.text:SetText(T.panelcolor.."Expand")
		end
	end

if button == TukuiBar5ButtonTop then	
		local buttontop = TukuiBar5ButtonTop
		buttontop:ClearAllPoints()
		buttontop:Size(30, 18)
		buttontop:Point("RIGHT", TukuiTabsRightBackground, "RIGHT", -50, 0)
		if bar:IsShown() then
			db.hidebar5 = false
			
			if not T.lowversion then buttontop.text:SetText(T.panelcolor.."-") end		
		else
			db.hidebar5 = true
			
			if not T.lowversion then buttontop.text:SetText(T.panelcolor.."+") end
		end	
	end
end

local function DrPepper(self, bar) -- guess what! :P
	-- yep, you cannot drink DrPepper while in combat. :(
	if InCombatLockdown() then print(ERR_NOT_IN_COMBAT) return end
	
	local button = self
	
	ShowOrHideBar(bar, button)
	MoveButtonBar(button, bar)
end

local TukuiBar2Button = CreateFrame("Button", "TukuiBar2Button", UIParent)
TukuiBar2Button:Width(17)
TukuiBar2Button:SetHeight(TukuiBar2:GetHeight())
TukuiBar2Button:Point("BOTTOMRIGHT", TukuiBar2, "BOTTOMLEFT", -3, 0)
TukuiBar2Button:SetTemplate("Transparent")
TukuiBar2Button:CreateShadow()
TukuiBar2Button:RegisterForClicks("AnyUp")
TukuiBar2Button:SetAlpha(0)
TukuiBar2Button:SetScript("OnClick", function(self) DrPepper(self, TukuiBar2) end)
TukuiBar2Button:SetScript("OnEnter", function(self) self:SetAlpha(1) end)
TukuiBar2Button:SetScript("OnLeave", function(self) self:SetAlpha(0) end)
TukuiBar2Button.text = T.SetFontString(TukuiBar2Button, C.media.pixelfont, C["datatext"].fontsize, "MONOCHROMEOUTLINE")
TukuiBar2Button.text:Point("CENTER", 1, 1)
TukuiBar2Button.text:SetText(T.panelcolor..">")

local TukuiBar3Button = CreateFrame("Button", "TukuiBar3Button", UIParent)
TukuiBar3Button:Width(17)
TukuiBar3Button:SetHeight(TukuiBar3:GetHeight())
TukuiBar3Button:Point("BOTTOMLEFT", TukuiBar3, "BOTTOMRIGHT", 3, 0)
TukuiBar3Button:SetTemplate("Transparent")
TukuiBar3Button:CreateShadow()
TukuiBar3Button:RegisterForClicks("AnyUp")
TukuiBar3Button:SetAlpha(0)
TukuiBar3Button:SetScript("OnClick", function(self) DrPepper(self, TukuiBar3) end)
TukuiBar3Button:SetScript("OnEnter", function(self) self:SetAlpha(1) end)
TukuiBar3Button:SetScript("OnLeave", function(self) self:SetAlpha(0) end)
TukuiBar3Button.text = T.SetFontString(TukuiBar3Button, C.media.pixelfont, C["datatext"].fontsize, "MONOCHROMEOUTLINE")
TukuiBar3Button.text:Point("CENTER", 1, 1)
TukuiBar3Button.text:SetText(T.panelcolor.."<")

local TukuiBar4Button = CreateFrame("Button", "TukuiBar4Button", UIParent)
TukuiBar4Button:SetWidth(TukuiBar1:GetWidth())
TukuiBar4Button:Height(12)
TukuiBar4Button:Point("BOTTOM", TukuiBar1, "TOP", 0, 3)
TukuiBar4Button:SetTemplate("Transparent")
TukuiBar4Button:CreateShadow()
TukuiBar4Button:RegisterForClicks("AnyUp")
TukuiBar4Button:SetAlpha(0)
TukuiBar4Button:SetScript("OnClick", function(self) DrPepper(self, TukuiBar4) end)
TukuiBar4Button:SetScript("OnEnter", function(self) self:SetAlpha(1) end)
TukuiBar4Button:SetScript("OnLeave", function(self) self:SetAlpha(0) end)
TukuiBar4Button.text = T.SetFontString(TukuiBar4Button, C.media.pixelfont, C["datatext"].fontsize, "MONOCHROMEOUTLINE")
TukuiBar4Button.text:SetPoint("CENTER", 0, 1)
TukuiBar4Button.text:SetText(T.panelcolor.."Collapse")

local TukuiBar5ButtonTop = CreateFrame("Button", "TukuiBar5ButtonTop", TukuiChatBackgroundRight)
TukuiBar5ButtonTop:CreatePanel("Transparent", 30, 15, "RIGHT", TukuiTabsRightBackground, "RIGHT", -50, 0)
TukuiBar5ButtonTop:RegisterForClicks("AnyUp")
TukuiBar5ButtonTop:SetAlpha(0)
TukuiBar5ButtonTop:SetFrameStrata("MEDIUM")
TukuiBar5ButtonTop:SetScript("OnClick", function(self) DrPepper(self, TukuiBar5) end)
TukuiBar5ButtonTop.text = T.SetFontString(TukuiBar5ButtonTop, C.media.pixelfont, 12, "MONOCHROMEOUTLINE")
TukuiBar5ButtonTop.text:Point("CENTER", 1, 1)
TukuiBar5ButtonTop.text:SetText(T.panelcolor.."-")	

TukuiBar5ButtonTop:SetScript("OnEnter", function()
		if InCombatLockdown() then return end
		TukuiBar5ButtonTop:FadeIn()
	end)

	TukuiBar5ButtonTop:SetScript("OnLeave", function()
		TukuiBar5ButtonTop:FadeOut()
	end)	

-- exit vehicle button on left side of bottom action bar
local vehicleleft = CreateFrame("Button", "TukuiExitVehicleButtonLeft", UIParent, "SecureHandlerClickTemplate")
vehicleleft:SetAllPoints(TukuiBar2Button)
vehicleleft:SetFrameStrata(TukuiBar2Button:GetFrameStrata())
vehicleleft:SetFrameLevel(TukuiBar2Button:GetFrameLevel() + 1)
vehicleleft:SetTemplate("Transparent")
vehicleleft:CreateShadow()
vehicleleft:SetBackdropBorderColor(75/255,  175/255, 76/255)
vehicleleft:RegisterForClicks("AnyUp")
vehicleleft:SetScript("OnClick", function() VehicleExit() end)
vehicleleft.text = T.SetFontString(vehicleleft, C.media.pixelfont, C["datatext"].fontsize, "MONOCHROMEOUTLINE")
vehicleleft.text:SetPoint("CENTER", T.Scale(1), T.Scale(1))
vehicleleft.text:SetText(T.panelcolor.."V")
RegisterStateDriver(vehicleleft, "visibility", "[target=vehicle,exists] show;hide")

-- exit vehicle button on right side of bottom action bar
local vehicleright = CreateFrame("Button", "TukuiExitVehicleButtonRight", UIParent, "SecureHandlerClickTemplate")
vehicleright:SetAllPoints(TukuiBar3Button)
vehicleright:SetTemplate("Transparent")
vehicleright:CreateShadow()
vehicleright:SetFrameStrata(TukuiBar3Button:GetFrameStrata())
vehicleright:SetFrameLevel(TukuiBar3Button:GetFrameLevel() + 1)
vehicleright:SetBackdropBorderColor(75/255,  175/255, 76/255)
vehicleright:RegisterForClicks("AnyUp")
vehicleright:SetScript("OnClick", function() VehicleExit() end)
vehicleright.text = T.SetFontString(vehicleright, C.media.pixelfont, C["datatext"].fontsize, "MONOCHROMEOUTLINE")
vehicleright.text:SetPoint("CENTER", T.Scale(1), T.Scale(1))
vehicleright.text:SetText(T.panelcolor.."V")
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
			if C.actionbar.bgPanel then
				TukuiBar5:SetWidth(T.buttonsize + (T.buttonspacing * 2))
			else
				TukuiBar5:SetWidth(T.buttonsize)
			end
		end
		
		TukuiBar5ButtonTop:SetWidth(TukuiBar5:GetWidth())
		TukuiBar5ButtonBottom:SetWidth(TukuiBar5:GetWidth())
	end
	
	if db.hidebar5 then
		DrPepper(TukuiBar5ButtonTop, TukuiBar5)
	end
end)