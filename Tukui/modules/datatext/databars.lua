local T, C, L = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales
--if not C["datatext"].databars then return end
if not C["databars"].enable and C["databars"].reputation then return end

local HydraData = {}
local LastUpdate = 1

for i = 1, 4 do
	HydraData[i] = CreateFrame("Frame", "HydraData"..i, UIParent)
	HydraData[i]:CreatePanel(nil, 100, 17, "CENTER", UIParent, "CENTER", -200, 200)
	--HydraData[i]:SetBorder()
	
	if i == 1 then
		HydraData[i]:Point("TOPLEFT", UIParent, "TOPLEFT", 8, -10)
	else
		HydraData[i]:Point("LEFT", HydraData[i-1], "RIGHT", 3, 0)
	end
	
	HydraData[i].Status = CreateFrame("StatusBar", "HydraDataStatus"..i, HydraData[i])
	HydraData[i].Status:SetFrameLevel(12)
	HydraData[i].Status:SetStatusBarTexture(C.media.normTex)
	HydraData[i].Status:SetMinMaxValues(0, 100)
	HydraData[i].Status:Point("TOPLEFT", HydraData[i], "TOPLEFT", 2, -2)
	HydraData[i].Status:Point("BOTTOMRIGHT", HydraData[i], "BOTTOMRIGHT", -2, 2)

	HydraData[i].Text = HydraData[i].Status:CreateFontString(nil, "OVERLAY")
	HydraData[i].Text:SetFont(C.media.pixelfont, 10)
	HydraData[i].Text:Point("LEFT", HydraData[i], "LEFT", 6, 1.5)
	HydraData[i].Text:SetShadowColor(0, 0, 0)
	HydraData[i].Text:SetShadowOffset(1.25, -1.25)
end

for i = 1, 4 do
	HydraData[i]:Animate(0, 100, 0.4)

	HydraData[i].toggle = CreateFrame("Frame", "HydraData"..i, UIParent)
	HydraData[i].toggle:CreatePanel(nil, 100, 17, "CENTER", HydraData[i], "CENTER", -200, 200)
	HydraData[i].toggle:SetFrameStrata("HIGH")
	HydraData[i].toggle:SetAllPoints(HydraData[i])
	HydraData[i].toggle:EnableMouse(true)
	HydraData[i].toggle:SetAlpha(0)
	
	HydraData[i].toggle:SetScript("OnMouseDown", function(self)
		if HydraData[i]:IsVisible() then
			HydraData[i]:SlideOut()
		else
			HydraData[i]:SlideIn()
		end
	end)
end

HydraData[1].Status:SetScript("OnUpdate", function(self, elapsed)
	LastUpdate = LastUpdate - elapsed
	
	if LastUpdate < 0 then
		self:SetMinMaxValues(0, 200)
		local value = floor(GetFramerate())
		local max = GetCVar("MaxFPS")
		self:SetValue(value)
		HydraData[1].Text:SetText("FPS: "..value)
		local r, g, b = oUFTukui.ColorGradient(value/max, .8,0,0,.8,.8,0,0,.8,0)
		self:SetStatusBarColor(r, g, b)
		LastUpdate = 1
	end
end)

HydraData[2].Status:SetScript("OnUpdate", function(self, elapsed)
	LastUpdate = LastUpdate - elapsed
	
	if LastUpdate < 0 then
		self:SetMinMaxValues(0, 200)
		local value = (select(3, GetNetStats()))
		local max = 200
		self:SetValue(value)
		HydraData[2].Text:SetText("MS: "..value)			
		local r, g, b = oUFTukui.ColorGradient(value/max, 0,.8,0,.8,.8,0,.8,0,0)
		self:SetStatusBarColor(r, g, b)
		LastUpdate = 1
	end
end)

HydraData[3].Status:SetScript("OnEvent", function(self)
	local Total = 0
	local current, max
	
	for i = 1, 11 do
		if GetInventoryItemLink("player", L.Slots[i][1]) ~= nil then
			current, max = GetInventoryItemDurability(L.Slots[i][1])
			if current then 
				L.Slots[i][3] = current/max
				Total = Total + 1
			end
		end
	end
	table.sort(L.Slots, function(a, b) return a[3] < b[3] end)
	local value = floor(L.Slots[1][3]*100)

	self:SetMinMaxValues(0, 100)
	self:SetValue(value)
	HydraData[3].Text:SetText("Durability: "..value.."%")			
	self:SetStatusBarColor(0, 0.8, 0, 1)
end)
HydraData[3].Status:RegisterEvent("UPDATE_INVENTORY_DURABILITY")
HydraData[3].Status:RegisterEvent("MERCHANT_SHOW")
HydraData[3].Status:RegisterEvent("PLAYER_ENTERING_WORLD")

HydraData[4].Status:SetScript("OnUpdate", function(self)
	local free, total, used = 0, 0, 0
	for i = 0, NUM_BAG_SLOTS do
		free, total = free + GetContainerNumFreeSlots(i), total + GetContainerNumSlots(i)
	end
	used = total - free
	value = (used*120/total)
	
	self:SetMinMaxValues(0, total)
	self:SetValue(used)
	HydraData[4].Text:SetText("Bags: "..used.." / "..total)			
	local r, g, b = oUFTukui.ColorGradient(used/total, 0,.8,0,.8,.8,0,.8,0,0)
	self:SetStatusBarColor(r, g, b)
end)
HydraData[4].Status:RegisterEvent("BAG_UPDATE")

--Reputation Databars

local RepData = {}
local db = C["databars"].WatchReps

local standing = {
	[-6000] = {188/255, 12/255, 9/255},  -- Hated :(
	[-3000] = {188/255, 12/255, 9/255},  -- Hostile
	[0] =     {188/255, 12/255, 9/255},  -- Unfriendly
	[3000] =  {255/255, 174/255, 0},     -- Neutral
	[9000] =  {45/255, 147/255, 38/255}, -- Friendly
	[21000] = {45/255, 147/255, 38/255}, -- Honored
	[42000] = {45/255, 147/255, 38/255}, -- Revered
	[43000] = {45/255, 147/255, 38/255}, -- Exalted
}

local function updateReputation()
	if RepData[1] then
		for i = 1, getn(RepData) do
			RepData[i]:Kill()
		end
		wipe(RepData) 
	end

	for i = 1, GetNumFactions() do
		local name, description, standingId, bottomValue, topValue, earnedValue, atWarWith,
		canToggleAtWar, isHeader, isCollapsed, hasRep, isWatched, isChild = GetFactionInfo(i)
		local min, max = earnedValue-bottomValue, topValue-bottomValue

		if name == db[1] or name == db[2] or name == db[3] or name == db[4] or name == db[5] then
			local frame = CreateFrame("Frame", "RepData"..i, UIParent)
			frame:CreatePanel(nil, TukuiMinimap:GetWidth(), 18, "CENTER", UIParent, "CENTER", 0, 0)
			frame:EnableMouse(true)
			frame:Animate(160, 0, 0.4)
			frame:Hide()
			--if T.Hydra then frame:SetBorder() end

			frame.Status = CreateFrame("StatusBar", "RepDataStatus"..i, frame)
			frame.Status:SetFrameLevel(12)
			frame.Status:SetStatusBarTexture(C["media"].normTex)
			frame.Status:SetMinMaxValues(0, topValue)
			frame.Status:SetValue(earnedValue)
			frame.Status:SetStatusBarColor(unpack(standing[topValue]))
			frame.Status:Point("TOPLEFT", frame, "TOPLEFT", 2, -2)
			frame.Status:Point("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -2, 2)

			frame.Text = frame.Status:CreateFontString(nil, "OVERLAY")
			frame.Text:SetFont(C.media.pixelfont, 10)
			frame.Text:Point("LEFT", frame, "LEFT", 6, 0)
			frame.Text:SetShadowColor(0, 0, 0)
			frame.Text:SetShadowOffset(1.25, -1.25)
			frame.Text:SetText(format("%s / %s", min, max))
			frame.Text:Hide()
			
			frame.Name = frame.Status:CreateFontString(nil, "OVERLAY")
			frame.Name:SetFont(C.media.pixelfont, 10)
			frame.Name:Point("LEFT", frame, "LEFT", 6, 0)
			frame.Name:SetShadowColor(0, 0, 0)
			frame.Name:SetShadowOffset(1.25, -1.25)
			frame.Name:SetText(name)

			frame:SetScript("OnEnter", function(self)
				self.Name:Hide()
				self.Text:Show()
			end)
			
			frame:SetScript("OnLeave", function(self)
				self.Name:Show()
				self.Text:Hide()
			end)
			
			tinsert(RepData, frame)
		end
	end

	for key, frame in ipairs(RepData) do
		frame:ClearAllPoints()
		if key == 1 then
			frame:Point("TOP", TukuiMinimap, "BOTTOM", 0, -3)
		else
			frame:Point("TOP", RepData[key-1], "BOTTOM", 0, -3)
		end
	end
end

local toggle = CreateFrame("Frame", "RepToggle", UIParent)
toggle:CreatePanel(nil, 52, 17, "BOTTOMRIGHT", CurrencyToggle, "BOTTOMLEFT", -3, 0)
toggle:EnableMouse(true)
toggle:SetAlpha(0)
toggle:SetScript("OnEnter", function(self) self:SetBackdropBorderColor(unpack(C["media"].statcolor))end)
toggle:SetScript("OnLeave", function(self) self:SetBackdropBorderColor(unpack(C["media"].bordercolor)) end)
toggle:SetScript("OnEnter", function(self) self:SetAlpha(1) end)
toggle:SetScript("OnLeave", function(self) self:SetAlpha(0) end)
toggle:HookScript("OnEnter", function(self) self:SetBackdropBorderColor(unpack(C["media"].statcolor)) end)
toggle:HookScript("OnLeave", function(self) self:SetBackdropBorderColor(unpack(C["media"].bordercolor)) end)
toggle:SetFrameStrata("MEDIUM")

toggle.Text = toggle:CreateFontString(nil, "OVERLAY")
toggle.Text:SetFont(C.media.pixelfont, 10)
toggle.Text:Point("CENTER", toggle, "CENTER", 0, 0)
toggle.Text:SetText(T.panelcolor..COMBAT_FACTION_CHANGE)
toggle:SetWidth(toggle.Text:GetWidth() + 12)
toggle:SetScript("OnMouseUp", function(self)
	for _, frame in pairs(RepData) do
		if frame and frame:IsVisible() then
			frame:SlideOut()
		else
			frame:SlideIn()
		end
	end
end)

local updater = CreateFrame("Frame")
updater:RegisterEvent("PLAYER_ENTERING_WORLD")
updater:RegisterEvent("UPDATE_FACTION")
updater:SetScript("OnEvent", updateReputation)