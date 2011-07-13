local T, C, L = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales
--------------------------------------------------------------------------
-- move vehicle indicator
--------------------------------------------------------------------------

local anchor = CreateFrame("Frame", "TukuiVehicleAnchor", UIParent)
anchor:Point("BOTTOM", UIParent, "BOTTOM", 0, 208)
anchor:Size(120, 20)
anchor:SetMovable(true)
anchor:SetClampedToScreen(true)
anchor:SetTemplate("Default")
anchor:SetBackdropBorderColor(1,0,0)
anchor:SetAlpha(0)
anchor.text = T.SetFontString(anchor, C.media.uffont, 12)
anchor.text:SetPoint("CENTER")
anchor.text:SetText(L.move_vehicle)

hooksecurefunc(VehicleSeatIndicator,"SetPoint",function(_,_,parent) -- vehicle seat indicator
    if (parent == "MinimapCluster") or (parent == _G["MinimapCluster"]) then
		VehicleSeatIndicator:ClearAllPoints()
		VehicleSeatIndicator:Point("BOTTOM", anchor, "BOTTOM", 0, 24)
    end
end)

--------------------------------------------------------------------------
-- vehicule on mouseover because this shit take too much space on screen
--------------------------------------------------------------------------

local function VehicleNumSeatIndicator()
	if VehicleSeatIndicatorButton6 then
		T.numSeat = 6
	elseif VehicleSeatIndicatorButton5 then
		T.numSeat = 5
	elseif VehicleSeatIndicatorButton4 then
		T.numSeat = 4
	elseif VehicleSeatIndicatorButton3 then
		T.numSeat = 3
	elseif VehicleSeatIndicatorButton2 then
		T.numSeat = 2
	elseif VehicleSeatIndicatorButton1 then
		T.numSeat = 1
	end
end

local function vehmousebutton(alpha)
	for i=1, T.numSeat do
	local pb = _G["VehicleSeatIndicatorButton"..i]
		pb:SetAlpha(alpha)
	end
end

local function vehmouse()
	if VehicleSeatIndicator:IsShown() then
		VehicleSeatIndicator:SetAlpha(0)
		VehicleSeatIndicator:EnableMouse(true)
		
		VehicleNumSeatIndicator()
		
		VehicleSeatIndicator:HookScript("OnEnter", function() VehicleSeatIndicator:SetAlpha(1) vehmousebutton(1) end)
		VehicleSeatIndicator:HookScript("OnLeave", function() VehicleSeatIndicator:SetAlpha(0) vehmousebutton(0) end)

		for i=1, T.numSeat do
			local pb = _G["VehicleSeatIndicatorButton"..i]
			pb:SetAlpha(0)
			pb:HookScript("OnEnter", function(self) VehicleSeatIndicator:SetAlpha(1) vehmousebutton(1) end)
			pb:HookScript("OnLeave", function(self) VehicleSeatIndicator:SetAlpha(0) vehmousebutton(0) end)
		end
	end
end
hooksecurefunc("VehicleSeatIndicator_Update", vehmouse)