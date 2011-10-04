local T, C, L = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales

if C["databars"].reputation == true then
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
		frame:CreatePanel("Transparent", TukuiMinimap:GetWidth(), 18, "CENTER", UIParent, "CENTER", 0, 0)
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
		frame.Text:SetFont(C.media.pixelfont, C["datatext"].fontsize, "MONOCHROMEOUTLINE")
		frame.Text:Point("LEFT", frame, "LEFT", 6, 2)
		frame.Text:SetShadowColor(0, 0, 0)
		frame.Text:SetShadowOffset(1.25, -1.25)
		frame.Text:SetText(format("%s / %s", min, max))
		frame.Text:Hide()
		
		frame.Name = frame.Status:CreateFontString(nil, "OVERLAY")
		frame.Name:SetFont(C.media.pixelfont, C["datatext"].fontsize+1, "MONOCHROMEOUTLINE")
		frame.Name:Point("LEFT", frame, "LEFT", 6, 2)
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
	self:SetBackdropColor(color.r*.15, color.g*.15, color.b*.15)
	self:SetBackdropBorderColor(color.r, color.g, color.b)
end

local function OriginalBackdrop(self)
	self:SetTemplate("Default")
end

local toggle = CreateFrame("Frame", "RepToggle", TukuiChatBackgroundRight)
toggle:CreatePanel(nil, 30, 15, "TOPRIGHT", TukuiChatBackgroundRight, "TOPRIGHT", -2, -52)
toggle:EnableMouse(true)
toggle:SetFrameStrata("MEDIUM")
toggle:SetFrameLevel(10)
toggle:CreateShadow("Default")
toggle:CreateOverlay(toggle)
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
toggle.Text:SetFont(C.media.pixelfont, C["datatext"].fontsize, "MONOCHROMEOUTLINE")
toggle.Text:Point("CENTER", toggle, "CENTER", 1, 1)
toggle.Text:SetText(T.datacolor.."R")

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
end