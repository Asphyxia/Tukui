local _, ns = ...
local oUF = ns.oUF or oUF

local Update = function(self, event)
	local _, class = UnitClass(self.unit)
	local icon = self.ClassIcon
  
	if(class) then
		local left, right, top, bottom = unpack(CLASS_BUTTONS[class])
		-- zoom class icon
		left = left + (right - left) * 0.09
		right = right - (right - left) * 0.09

		top = top + (bottom - top) * 0.09
		bottom = bottom - (bottom - top) * 0.09
	
		icon:SetTexCoord(left, right, top, bottom)
		icon:Show()
	else
		icon:Hide()
	end
end

local Enable = function(self)
	local cicon = self.ClassIcon

	if(cicon) then
		self:RegisterEvent("PARTY_MEMBERS_CHANGED", Update)
		self:RegisterEvent("PLAYER_TARGET_CHANGED", Update)
		self:RegisterEvent("ARENA_OPPONENT_UPDATE", Update)

		cicon:SetTexture("Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes")
		
		return true
	end
end

local Disable = function(self)
	local ricon = self.ClassIcon
	if(ricon) then
		self:UnregisterEvent("ARENA_OPPONENT_UPDATE", Update)
		self:UnregisterEvent("PARTY_MEMBERS_CHANGED", Update)
		self:UnregisterEvent("PLAYER_TARGET_CHANGED", Update)
	end
end

oUF:AddElement('ClassIcon', Update, Enable, Disable)