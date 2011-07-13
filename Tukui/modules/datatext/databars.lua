local T, C, L = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales

if not C["databars"].enable and C["databars"].reputation then return end

local HydraData = {}
local LastUpdate = 1

for i = 1, 4 do
	HydraData[i] = CreateFrame("Frame", "HydraData"..i, UIParent)
	HydraData[i]:CreatePanel(nil, 100, 17, "CENTER", UIParent, "CENTER", -200, 200)
	HydraData[i]:CreateShadow("")
	
	if i == 1 then
		HydraData[i]:Point("TOPLEFT", UIParent, "TOPLEFT", 8, -10)
	else
		HydraData[i]:Point("LEFT", HydraData[i-1], "RIGHT", 3, 0)
	end
	
	HydraData[i].Status = CreateFrame("StatusBar", "HydraDataStatus"..i, HydraData[i])
	HydraData[i].Status:SetFrameLevel(12)
	HydraData[i].Status:SetStatusBarTexture(C.media.normTex)
	HydraData[i].Status:SetMinMaxValues(0, 100)
	HydraData[i].Status:SetStatusBarColor(0.3, 0.2, 1)
	HydraData[i].Status:Point("TOPLEFT", HydraData[i], "TOPLEFT", 2, -2)
	HydraData[i].Status:Point("BOTTOMRIGHT", HydraData[i], "BOTTOMRIGHT", -2, 2)

	HydraData[i].Text = HydraData[i].Status:CreateFontString(nil, "OVERLAY")
	HydraData[i].Text:SetFont(C.media.pixelfont, 8, "MONOCHROMEOUTLINE")
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

-- FPS
HydraData[1].Status:SetScript("OnUpdate", function(self, elapsed)
	LastUpdate = LastUpdate - elapsed
	
	if LastUpdate < 0 then
		self:SetMinMaxValues(0, 200)
		local value = floor(GetFramerate())
		local max = GetCVar("MaxFPS")
		self:SetValue(value)
		HydraData[1].Text:SetText("FPS: "..value)
		self:SetStatusBarColor(0.3, 0.2, 1)
		LastUpdate = 1
	end
end)

-- MS 
HydraData[2].Status:SetScript("OnUpdate", function(self, elapsed)
	LastUpdate = LastUpdate - elapsed
	
	if LastUpdate < 0 then
		self:SetMinMaxValues(0, 200)
		local value = (select(3, GetNetStats()))
		local max = 200
		self:SetValue(value)
		HydraData[2].Text:SetText("MS: "..value)			
		self:SetStatusBarColor(0.3, 0.2, 1)
		LastUpdate = 1
	end
end)

-- MEMORY
local f = HydraData[3]

local Stat = CreateFrame("Frame", nil, f)
Stat:EnableMouse(true)
Stat:SetFrameStrata("BACKGROUND")
Stat:SetFrameLevel(4)
Stat:ClearAllPoints()
Stat:SetAllPoints(f)

local int = 10
local StatusBar = f.Status
local Text = f.Text
local kiloByteString = "KB: %d"
local megaByteString = "MB: %.2f "

local function formatMem(memory)
	local mult = 10^1
	if memory > 999 then
		local mem = ((memory/1024) * mult) / mult
		return string.format(megaByteString, mem)
	else
		local mem = (memory * mult) / mult
		return string.format(kiloByteString, mem)
	end
end

local memoryTable = {}

local function RebuildAddonList(self)
	local addOnCount = GetNumAddOns()
	if (addOnCount == #memoryTable) then return end
	memoryTable = {}
	for i = 1, addOnCount do
		memoryTable[i] = { i, select(2, GetAddOnInfo(i)), 0, IsAddOnLoaded(i) }
	end
	self:SetAllPoints(f)
end

local function UpdateMemory()
	UpdateAddOnMemoryUsage()
	local addOnMem = 0
	local totalMemory = 0
	for i = 1, #memoryTable do
		addOnMem = GetAddOnMemoryUsage(memoryTable[i][1])
		memoryTable[i][3] = addOnMem
		totalMemory = totalMemory + addOnMem
	end
	table.sort(memoryTable, function(a, b)
		if a and b then
			return a[3] > b[3]
		end
	end)
	return totalMemory
end

local function UpdateMem(self, t)
	int = int - t
	
	if int < 0 then
		RebuildAddonList(self)
		local total = UpdateMemory()
		Text:SetText(formatMem(total))
		StatusBar:SetMinMaxValues(0,10000)
		StatusBar:SetValue(total)
		int = 10
	end
end

Stat:SetScript("OnMouseDown", function(self) UpdateMem(Stat, 10) ToggleFrame(aLoadFrame) end)
Stat:SetScript("OnEnter", function(self) collectgarbage("collect") end)
Stat:SetScript("OnUpdate", UpdateMem)
UpdateMem(Stat, 10)

-- DURABILITY
HydraData[4].Status:SetScript("OnEvent", function(self)
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
	HydraData[4].Text:SetText("Durability: "..value.."%")			
	self:SetStatusBarColor(0.3, 0.2, 1)
end)
HydraData[4].Status:RegisterEvent("UPDATE_INVENTORY_DURABILITY")
HydraData[4].Status:RegisterEvent("MERCHANT_SHOW")
HydraData[4].Status:RegisterEvent("PLAYER_ENTERING_WORLD")

-- REPUTATION DATABARS
local RepData = {}
local db = C["databars"].reps

local standing = {
	[-6000] = {255/255, 0,  51/255},      -- Hated :(
	[-3000] = {255/255, 0,  51/255},      -- Hostile
	[0] =     {255/255, 0,  51/255},      -- Unfriendly
	[3000] =  {255/255, 204/255, 102/255},-- Neutral
	[9000] =  {75/255,  175/255, 76/255}, -- Friendly
	[21000] = {75/255,  175/255, 76/255}, -- Honored
	[42000] = {75/255,  175/255, 76/255}, -- Revered
	[43000] = {75/255,  175/255, 76/255}, -- Exalted
}

for i = 1, GetNumFactions() do
	local name, _, _, bottomValue, topValue, earnedValue, _, _, _, _, _, _, _ = GetFactionInfo(i)
	local min, max = earnedValue-bottomValue, topValue-bottomValue

	if name == db[1] or name == db[2] or name == db[3] or name == db[4] or name == db[5] then
	
		local frame = CreateFrame("Frame", "RepData"..i, UIParent)
		frame:CreatePanel(nil, TukuiMinimap:GetWidth(), 18, "CENTER", UIParent, "CENTER", 0, 0)
		frame:EnableMouse(true)
		frame:Animate(160, 0, 0.4)
		frame:Hide()
		if T.Hydra then frame:SetBorder() end
		
		frame.Status = CreateFrame("StatusBar", "RepDataStatus"..i, frame)
		frame.Status:SetFrameLevel(12)
		frame.Status:SetStatusBarTexture(C["media"].normTex)
		frame.Status:SetMinMaxValues(0, max)
		frame.Status:SetValue(min)
		frame.Status:SetStatusBarColor(unpack(standing[topValue]))
		frame.Status:Point("TOPLEFT", frame, "TOPLEFT", 2, -2)
		frame.Status:Point("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -2, 2)
		
		frame.Text = frame.Status:CreateFontString(nil, "OVERLAY")
		frame.Text:SetFont(C.media.pixelfont, 8, "MONOCHROMEOUTLINE")
		frame.Text:Point("LEFT", frame, "LEFT", 6, 0)
		frame.Text:SetShadowColor(0, 0, 0)
		frame.Text:SetShadowOffset(1.25, -1.25)
		frame.Text:SetText(format("%s / %s", min, max))
		frame.Text:Hide()
		
		frame.Name = frame.Status:CreateFontString(nil, "OVERLAY")
		frame.Name:SetFont(C.media.pixelfont, 8, "MONOCHROMEOUTLINE")
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
		
		frame.id = i
		frame.Status = frame.Status
		frame.Text = frame.Text
		
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

local update = function()
	for _, frame in ipairs(RepData) do
		local name, _, _, bottomValue, topValue, earnedValue, _, _, _, _, _, _, _ = GetFactionInfo(frame.id)
		local min, max = earnedValue-bottomValue, topValue-bottomValue
		
		frame.Status:SetValue(min)
		frame.Text:SetText(format("%s / %s", min, max))
	end
end

local function ModifiedBackdrop(self)
	local color = RAID_CLASS_COLORS[T.myclass]
	self:SetBackdropColor(unpack(C["media"].backdropcolor))
	self:SetBackdropBorderColor(color.r, color.g, color.b)
end

local function OriginalBackdrop(self)
	self:SetBackdropColor(unpack(C["media"].backdropcolor))
	self:SetBackdropBorderColor(unpack(C["media"].bordercolor))
end

local toggle = CreateFrame("Frame", "RepToggle", TukuiChatBackgroundRight)
toggle:CreatePanel(nil, 20, 20, "TOPRIGHT", TukuiChatBackgroundRight, "TOPRIGHT", -3, -26)
toggle:EnableMouse(true)
toggle:SetFrameStrata("HIGH")
toggle:SetFrameLevel(10)
toggle:CreateShadow("Default")
toggle:SetAlpha(0)
toggle:HookScript("OnEnter", ModifiedBackdrop)
toggle:HookScript("OnLeave", OriginalBackdrop)

toggle:SetScript("OnEnter", function()
		if InCombatLockdown() then return end
		toggle:FadeIn()
	end)

	toggle:SetScript("OnLeave", function()
		toggle:FadeOut()
	end)

toggle.Text = toggle:CreateFontString(nil, "OVERLAY")
toggle.Text:SetFont(C.media.pixelfont, 8, "MONOCHROMEOUTLINE")
toggle.Text:Point("CENTER", toggle, "CENTER", 0, 0)
toggle.Text:SetText(T.panelcolor.."R")

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
updater:SetScript("OnEvent", update)

-- CURRENCY DATA BARS
local CurrencyData = {}
local tokens = {
	{61, 250},	 -- Dalaran Jewelcrafter's Token
	{81, 250},	 -- Dalaran Cooking Award
	{241, 250},	 -- Champion Seal
	{361, 200},  -- Illustrious Jewelcrafter's Token
	{390, 3000}, -- Conquest Points
	{391, 2000},  -- Tol Barad Commendation
	{392, 4000}, -- Honor Points
	{395, 4000}, -- Justice Points
	{396, 4000}, -- Valor Points
	{402, 10},	 -- Chef's Award 
	{416, 300}, -- Mark of the World Tree
}

if C["databars"].currency == true then
local function updateCurrency()
	if CurrencyData[1] then
		for i = 1, getn(CurrencyData) do
			CurrencyData[i]:Kill()
		end
		wipe(CurrencyData) 
	end

	for i, v in ipairs(tokens) do
		local id, max = unpack(v)
		local name, amount, icon = GetCurrencyInfo(id)
		local r, g, b = oUFTukui.ColorGradient(amount/max, 0,.8,0,.8,.8,0,.8,0,0)

		if name and amount > 0 then
			local frame = CreateFrame("Frame", "CurrencyData"..id, UIParent)
			frame:CreatePanel(nil, 120, 20, "CENTER", UIParent, "CENTER", 0, 0)
			frame:EnableMouse(true)
			frame:Animate(-140, 0, 0.4)
			frame:Hide()

			frame.Status = CreateFrame("StatusBar", "CurrencyDataStatus"..id, frame)
			frame.Status:SetFrameLevel(12)
			frame.Status:SetStatusBarTexture((C["media"].raidTex) or (C["media"].normTex))
			frame.Status:SetMinMaxValues(0, max)
			frame.Status:SetValue(amount)
			frame.Status:SetStatusBarColor(r, g, b, 1)
			frame.Status:Point("TOPLEFT", frame, "TOPLEFT", 2, -2)
			frame.Status:Point("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -2, 2)

			frame.Text = frame.Status:CreateFontString(nil, "OVERLAY")
			frame.Text:SetFont(C.media.pixelfont, 8, "MONOCHROMEOUTLINE")
			frame.Text:Point("CENTER", frame, "CENTER", 0, 2)
			frame.Text:Width(frame:GetWidth() - 4)
			frame.Text:SetShadowColor(0, 0, 0)
			frame.Text:SetShadowOffset(1.25, -1.25)
			frame.Text:SetText(format("%s / %s", amount, max))
				
			frame.IconBG = CreateFrame("Frame", "CurrencyDataIconBG"..id, frame)
			frame.IconBG:CreatePanel(nil, 20, 20, "BOTTOMLEFT", frame, "BOTTOMRIGHT", T.Scale(3), 0)
			frame.Icon = frame.IconBG:CreateTexture(nil, "ARTWORK")
			frame.Icon:Point("TOPLEFT", frame.IconBG, "TOPLEFT", 2, -2)
			frame.Icon:Point("BOTTOMRIGHT", frame.IconBG, "BOTTOMRIGHT", -2, 2)
			frame.Icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
			frame.Icon:SetTexture("Interface\\Icons\\"..icon)

			frame:SetScript("OnEnter", function(self) frame.Text:SetText(format("%s", name)) end)
			frame:SetScript("OnLeave", function(self) frame.Text:SetText(format("%s / %s", amount, max)) end)
			
			tinsert(CurrencyData, frame)
		end
	end
	
	for key, frame in ipairs(CurrencyData) do
		frame:ClearAllPoints()
		if key == 1 then
			frame:Point("TOPLEFT", UIParent, "TOPLEFT", 8, -30)
		else
			frame:Point("TOP", CurrencyData[key-1], "BOTTOM", 0, -3)
		end
	end
end

local function ModifiedBackdrop(self)
	local color = RAID_CLASS_COLORS[T.myclass]
	self:SetBackdropColor(unpack(C["media"].backdropcolor))
	self:SetBackdropBorderColor(color.r, color.g, color.b)
end

local function OriginalBackdrop(self)
	self:SetBackdropColor(unpack(C["media"].backdropcolor))
	self:SetBackdropBorderColor(unpack(C["media"].bordercolor))
end

local toggle = CreateFrame("Frame", "CurrencyToggle", UIParent)
toggle:CreatePanel("Default", 53, 17, "BOTTOMRIGHT", TukuiInfoRight, "BOTTOMLEFT", -84, 0)
toggle:EnableMouse(true)
toggle:SetFrameStrata("MEDIUM")
toggle:SetFrameLevel(2)
toggle:CreateShadow("Default")
toggle:SetAlpha(0)
toggle:HookScript("OnEnter", ModifiedBackdrop)
toggle:HookScript("OnLeave", OriginalBackdrop)

toggle:SetScript("OnEnter", function()
		if InCombatLockdown() then return end
		toggle:FadeIn()
	end)

	toggle:SetScript("OnLeave", function()
		toggle:FadeOut()
	end)

toggle.Text = toggle:CreateFontString(nil, "OVERLAY")
toggle.Text:SetFont(C.media.pixelfont, 8, "MONOCHROMEOUTLINE")
toggle.Text:Point("CENTER", toggle, "CENTER", 1, 0)
toggle.Text:SetText(T.panelcolor.."Currency")
toggle:SetScript("OnMouseUp", function(self)
	for _, frame in pairs(CurrencyData) do
		if frame and frame:IsVisible() then
			frame:SlideOut()
		else
			frame:SlideIn()
		end
	end
end)

local updater = CreateFrame("Frame")
updater:RegisterEvent("PLAYER_HONOR_GAIN")	
updater:SetScript("OnEvent", updateCurrency)
hooksecurefunc("BackpackTokenFrame_Update", updateCurrency)
end