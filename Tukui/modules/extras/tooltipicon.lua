local iconsize = 30

local function setTooltipIcon(self, icon)
	local title = icon and _G[self:GetName() .. 'TextLeft1']
	if title then
		title:SetFormattedText('|T%s:%d|t %s', icon, iconsize, title:GetText())
	end
end

local function newTooltipHooker(method, func)
	return function(tooltip)
		local modified = false

		tooltip:HookScript('OnTooltipCleared', function(self, ...)
			modified = false
		end)

		tooltip:HookScript(method, function(self, ...)
			if not modified  then
				modified = true
				func(self, ...)
			end
		end)
	end
end

local hookItem = newTooltipHooker('OnTooltipSetItem', function(self, ...)
	local name, link = self:GetItem()
	if link then
		setTooltipIcon(self, GetItemIcon(link))
	end
end)

local hookSpell = newTooltipHooker('OnTooltipSetSpell', function(self, ...)
	local name, rank, id = self:GetSpell()
	if id then
		setTooltipIcon(self, select(3, GetSpellInfo(id)))
	end
end)

for _, tooltip in pairs{GameTooltip, ItemRefTooltip} do
	hookItem(tooltip)
	hookSpell(tooltip)
end