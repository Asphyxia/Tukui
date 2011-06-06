local parent, ns = ...
local oUF = ns.oUF

local GetComboPoints = GetComboPoints
local MAX_COMBO_POINTS = MAX_COMBO_POINTS

local Update = function(self, event, unit)
	if(unit == 'pet') then return end

	local cp
	if(UnitHasVehicleUI'player') then
		cp = GetComboPoints('vehicle', 'target')
	else
		cp = GetComboPoints('player', 'target')
	end
	self.CPoints:SetText(cp)
	if cp == 0 then self.CPoints:SetText("") end
	if cp == 1 then self.CPoints:SetTextColor(.9,0,.2) end
	if cp == 2 then self.CPoints:SetTextColor(217/255, 65/255, .2) end
	if cp == 3 then self.CPoints:SetTextColor(159/255, 130/255, .2) end
	if cp == 4 then self.CPoints:SetTextColor(39/255, 200/255, .2) end
	if cp == 5 then self.CPoints:SetTextColor(0,1,0) end
end

local Path = function(self, ...)
	return (self.CPoints.Override or Update) (self, ...)
end

local ForceUpdate = function(element)
	return Path(element.__owner, 'ForceUpdate', element.__owner.unit)
end

local Enable = function(self)
	local cpoints = self.CPoints
	if(cpoints) then
		cpoints.__owner = self
		cpoints.ForceUpdate = ForceUpdate

		self:RegisterEvent('UNIT_COMBO_POINTS', Path)
		self:RegisterEvent('PLAYER_TARGET_CHANGED', Path)

		return true
	end
end

local Disable = function(self)
	local cpoints = self.CPoints
	if(cpoints) then
		self:UnregisterEvent('UNIT_COMBO_POINTS', Path)
		self:UnregisterEvent('PLAYER_TARGET_CHANGED', Path)
	end
end

oUF:AddElement('CPoints', Path, Enable, Disable)
