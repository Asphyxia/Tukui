local ADDON_NAME, ns = ...
local oUF = oUFTukui or oUF
assert(oUF, "Tukui was unable to locate oUF install.")

ns._Objects = {}
ns._Headers = {}

local T, C, L = unpack(Tukui) -- Import: T - functions, constants, variables; C - config; L - locales
if not C["unitframes"].enable == true then return end

local font2 = C["media"].uffont
local font1 = C["media"].font
local normTex = C["media"].normTex
local font = C["media"].pixelfont

local function Shared(self, unit)
	self.colors = T.oUF_colors
	self:RegisterForClicks("AnyUp")
	self:SetScript("OnEnter", UnitFrame_OnEnter)
	self:SetScript("OnLeave", UnitFrame_OnLeave)

	self.menu = T.SpawnMenu

	self:SetBackdrop({bgFile = C["media"].blank, insets = {top = -T.mult, left = -T.mult, bottom = -T.mult, right = -T.mult}})
	self:SetBackdropColor(0.1, 0.1, 0.1)

	local health = CreateFrame('StatusBar', nil, self)
	health:SetPoint("TOPLEFT")
	health:SetPoint("TOPRIGHT")
	health:Height(28)
	health:SetStatusBarTexture(normTex)
	health:CreateBorder(false, true)
	self.Health = health

	if C["unitframes"].gridhealthvertical then
		health:SetOrientation('VERTICAL')
	end

	health.bg = health:CreateTexture(nil, 'BORDER')
	health.bg:SetAllPoints(health)
	health.bg:SetTexture(normTex)
	health.bg:SetTexture(1, 1, 1)
	health.bg.multiplier = (0.3)
	self.Health.bg = health.bg

	health.value = health:CreateFontString(nil, "OVERLAY")
	health.value:Point("TOP", 1, -2)
	health.value:SetFont(font, C["datatext"].fontsize, "MONOCHROMEOUTLINE")
	self.Health.value = health.value

	health.PostUpdate = T.PostUpdateHealthRaid
	health.frequentUpdates = true

	local glowBorder = {edgeFile = C["media"].blank, edgeSize = 1}
	local aggro = CreateFrame("Frame", nil, self)
	aggro:Point("TOPLEFT", health, "TOPLEFT", -1, 1)
	aggro:Point("BOTTOMRIGHT", health, "BOTTOMRIGHT", 1, -1)
	aggro:SetBackdrop(glowBorder)
	aggro:SetFrameLevel(health:GetFrameLevel() + 4)
	aggro:SetFrameStrata("HIGH")
	aggro:SetBackdropBorderColor(.8, .2, .2)
	aggro:Hide()

	self.Aggro = aggro

	if C.unitframes.unicolor then
		health.colorDisconnected = false
		health.colorClass = false
		health:SetStatusBarColor(.2, .2, .2)
		health.bg:SetVertexColor(.05, .05, .05)		
	else
		health.colorDisconnected = true
		health.colorClass = true
		health.colorReaction = true			
	end

	if C.unitframes.gradienthealth and C.unitframes.unicolor then
		self:HookScript("OnEnter", function(self)
			if not UnitIsConnected(self.unit) or UnitIsDead(self.unit) or UnitIsGhost(self.unit) or (not UnitInRange(self.unit) and not UnitIsPlayer(self.unit)) then return end
			local hover = RAID_CLASS_COLORS[select(2, UnitClass(self.unit))]
			health:SetStatusBarColor(hover.r, hover.g, hover.b)
			health.classcolored = true
		end)

		self:HookScript("OnLeave", function(self)
			if not UnitIsConnected(self.unit) or UnitIsDead(self.unit) or UnitIsGhost(self.unit) then return end
			local r, g, b = oUF.ColorGradient(UnitHealth(self.unit)/UnitHealthMax(self.unit), unpack(C["unitframes"].gradient))
			health:SetStatusBarColor(r, g, b)
			health.classcolored = false
		end)
	end

	local power = CreateFrame("StatusBar", nil, self)
	power:SetHeight(2)
	power:CreateBorder(false, true)
	power:SetFrameLevel(health:GetFrameLevel() + 1)
	power:Point("BOTTOMLEFT", self.Health, "BOTTOMLEFT", 4, 4)
	power:Point("BOTTOMRIGHT", self.Health, "BOTTOMRIGHT", -4, 4)
	power:SetStatusBarTexture(normTex)
	self.Power = power

	power.frequentUpdates = true
	power.colorDisconnected = true

	power.bg = power:CreateTexture(nil, "BORDER")
	power.bg:SetAllPoints(power)
	power.bg:SetTexture(normTex)
	power.bg:SetAlpha(1)
	power.bg.multiplier = 0.4

	if C.unitframes.unicolor then
		power.colorClass = true
		power.bg.multiplier = 0.1				
	else
		power.colorPower = true
	end

	local name = health:CreateFontString(nil, "OVERLAY")
	name:Point("CENTER", health, 0, -1)
	name:SetFont(font, C["datatext"].fontsize, "MONOCHROMEOUTLINE")
	self:Tag(name, "[Tukui:getnamecolor][Tukui:nameshort]")
	self.Name = name
	
	local leader = health:CreateTexture(nil, "OVERLAY")
    leader:Height(12*T.raidscale)
    leader:Width(12*T.raidscale)
    leader:SetPoint("TOPLEFT", 0, 8)
	self.Leader = leader
	
    local MasterLooter = health:CreateTexture(nil, "OVERLAY")
    MasterLooter:Height(12*T.raidscale)
    MasterLooter:Width(12*T.raidscale)
	self.MasterLooter = MasterLooter
    self:RegisterEvent("PARTY_LEADER_CHANGED", T.MLAnchorUpdate)
    self:RegisterEvent("PARTY_MEMBERS_CHANGED", T.MLAnchorUpdate)
	
	local LFDRole = health:CreateTexture(nil, "OVERLAY")
    LFDRole:Height(14*T.raidscale)
    LFDRole:Width(14*T.raidscale)
	LFDRole:Point("TOP", 0, 10)
	LFDRole:SetTexture("Interface\\AddOns\\Tukui\\medias\\textures\\lfdicons.blp")
	self.LFDRole = LFDRole

    if C["unitframes"].aggro then
		table.insert(self.__elements, T.UpdateThreat)
		self:RegisterEvent('PLAYER_TARGET_CHANGED', T.UpdateThreat)
		self:RegisterEvent('UNIT_THREAT_LIST_UPDATE', T.UpdateThreat)
		self:RegisterEvent('UNIT_THREAT_SITUATION_UPDATE', T.UpdateThreat)
	end

	if C["unitframes"].showsymbols then
		local RaidIcon = health:CreateTexture(nil, 'OVERLAY')
		RaidIcon:Height(18*T.raidscale)
		RaidIcon:Width(18*T.raidscale)
		RaidIcon:SetPoint('CENTER', self, 'TOP')
		RaidIcon:SetTexture("Interface\\AddOns\\Tukui\\medias\\textures\\raidicons.blp")
		self.RaidIcon = RaidIcon
	end

	local ReadyCheck = health:CreateTexture(nil, "OVERLAY")
	ReadyCheck:Height(12*C["unitframes"].gridscale*T.raidscale)
	ReadyCheck:Width(12*C["unitframes"].gridscale*T.raidscale)
	ReadyCheck:Point("TOP", 0, 6) 	
	self.ReadyCheck = ReadyCheck

	--[[if not C["unitframes"].raidunitdebuffwatch then
		self.DebuffHighlightAlpha = 1
		self.DebuffHighlightBackdrop = true
		self.DebuffHighlightFilter = true
	end]]

	if C["unitframes"].showrange then
		local range = {insideAlpha = 1, outsideAlpha = C["unitframes"].raidalphaoor}
		self.Range = range
	end

	if C["unitframes"].showsmooth then
		health.Smooth = true
		power.Smooth = true
	end

	if C["unitframes"].healcomm then
		local mhpb = CreateFrame('StatusBar', nil, self.Health)
		if C["unitframes"].gridhealthvertical then
			mhpb:SetOrientation("VERTICAL")
			mhpb:SetPoint('BOTTOM', self.Health:GetStatusBarTexture(), 'TOP', 0, 0)
			mhpb:Width(66*C["unitframes"].gridscale*T.raidscale)
			mhpb:Height(50*C["unitframes"].gridscale*T.raidscale)		
		else
			mhpb:SetPoint('TOPLEFT', self.Health:GetStatusBarTexture(), 'TOPRIGHT', 0, 0)
			mhpb:SetPoint('BOTTOMLEFT', self.Health:GetStatusBarTexture(), 'BOTTOMRIGHT', 0, 0)
			mhpb:Width(66*C["unitframes"].gridscale*T.raidscale)
		end
		mhpb:SetStatusBarTexture(normTex)

		local ohpb = CreateFrame('StatusBar', nil, self.Health)
		if C["unitframes"].gridhealthvertical then
			ohpb:SetOrientation("VERTICAL")
			ohpb:SetPoint('BOTTOM', mhpb:GetStatusBarTexture(), 'TOP', 0, 0)
			ohpb:Width(66*C["unitframes"].gridscale*T.raidscale)
			ohpb:Height(50*C["unitframes"].gridscale*T.raidscale)
		else
			ohpb:SetPoint('TOPLEFT', mhpb:GetStatusBarTexture(), 'TOPRIGHT', 0, 0)
			ohpb:SetPoint('BOTTOMLEFT', mhpb:GetStatusBarTexture(), 'BOTTOMRIGHT', 0, 0)
			ohpb:Width(6*C["unitframes"].gridscale*T.raidscale)
		end
		ohpb:SetStatusBarTexture(normTex)

		self.HealPrediction = {
			myBar = mhpb,
			otherBar = ohpb,
			maxOverflow = 1,
		}
	end

	if C["unitframes"].raidunitdebuffwatch then
		T.createAuraWatch(self,unit)

		local RaidDebuffs = CreateFrame('Frame', nil, self)
		RaidDebuffs:Height(22*C["unitframes"].gridscale)
		RaidDebuffs:Width(22*C["unitframes"].gridscale)
		RaidDebuffs:Point('CENTER', health, 1,0)
		RaidDebuffs:SetFrameStrata(health:GetFrameStrata())
		RaidDebuffs:SetFrameLevel(health:GetFrameLevel() + 2)

		RaidDebuffs:SetTemplate("Default")

		RaidDebuffs.icon = RaidDebuffs:CreateTexture(nil, 'OVERLAY')
		RaidDebuffs.icon:SetTexCoord(.1,.9,.1,.9)
		RaidDebuffs.icon:Point("TOPLEFT", 2, -2)
		RaidDebuffs.icon:Point("BOTTOMRIGHT", -2, 2)

		RaidDebuffs.count = RaidDebuffs:CreateFontString(nil, 'OVERLAY')
		RaidDebuffs.count:SetFont(C["media"].uffont, 9*C["unitframes"].gridscale, "THINOUTLINE")
		RaidDebuffs.count:SetPoint('BOTTOMRIGHT', RaidDebuffs, 'BOTTOMRIGHT', 0, 2)
		RaidDebuffs.count:SetTextColor(1, .9, 0)

		self.DebuffHighlightAlpha = 1
		self.DebuffHighlightBackdrop = true
		self.DebuffHighlightFilter = true

		self.RaidDebuffs = RaidDebuffs
    end

	return self
end

oUF:RegisterStyle('TukuiHealR25R40', Shared)
oUF:Factory(function(self)
	oUF:SetActiveStyle("TukuiHealR25R40")
	if C["unitframes"].gridonly then
		local raid = self:SpawnHeader("TukuiGrid", nil, "raid,party",
			'oUF-initialConfigFunction', [[
				local header = self:GetParent()
				self:SetWidth(header:GetAttribute('initial-width'))
				self:SetHeight(header:GetAttribute('initial-height'))
			]],
			'initial-width', 70,
			'initial-height', 28,
			"showParty", true,
			"showPlayer", C["unitframes"].showplayerinparty,
			"showRaid", true,
			"xoffset", 1,
			"yOffset", -1,
			"point", "LEFT",
			"groupFilter", "1,2,3,4,5,6,7,8",
			"groupingOrder", "1,2,3,4,5,6,7,8",
			"groupBy", "GROUP",
			"maxColumns", 8,
			"unitsPerColumn", 5,
			"columnSpacing", 1,
			"columnAnchorPoint", "TOP"
		)
		local RaidMove = CreateFrame("Frame")
		RaidMove:RegisterEvent("PLAYER_LOGIN")
		RaidMove:RegisterEvent("RAID_ROSTER_UPDATE")
		RaidMove:RegisterEvent("PARTY_LEADER_CHANGED")
		RaidMove:RegisterEvent("PARTY_MEMBERS_CHANGED")
		RaidMove:SetScript("OnEvent", function(self)
			local numraid = GetNumRaidMembers()
			if numraid > 25 then
				raid:Point("TOP", UIParent, "BOTTOM", 0, 385)
			else
				raid:Point("TOP", UIParent, "BOTTOM", 0 , 350)
			end
		end)
	else
		local raid = self:SpawnHeader("TukuiGrid", nil, "raid,party",
			'oUF-initialConfigFunction', [[
				local header = self:GetParent()
				self:SetWidth(header:GetAttribute('initial-width'))
				self:SetHeight(header:GetAttribute('initial-height'))
			]],
			'initial-width', 72.5,
			'initial-height', 38,
			"showParty", true,
			"showPlayer", C["unitframes"].showplayerinparty,
			"showRaid", true,
			"xoffset", 1,
			"yOffset", -1,
			"point", "LEFT",
			"groupFilter", "1,2,3,4,5,6,7,8",
			"groupingOrder", "1,2,3,4,5,6,7,8",
			"groupBy", "GROUP",
			"maxColumns", 8,
			"unitsPerColumn", 5,
			"columnSpacing", 1,
			"columnAnchorPoint", "TOP"
		)
		raid:SetPoint("TOP", UIParent, "BOTTOM", 0, 385)

		local pets = {}
			pets[1] = oUF:Spawn('partypet1', 'oUF_TukuiPartyPet1') 
			pets[1]:Point('BOTTOMLEFT', raid, 'TOPLEFT', 71.5, 3)
			pets[1]:Size(72.5, 38)
		for i = 2, 4 do 
			pets[i] = oUF:Spawn('partypet'..i, 'oUF_TukuiPartyPet'..i) 
			pets[i]:Point('LEFT', pets[i-1], 'RIGHT', 1, 0)
			pets[i]:Size(72.5, 38)
		end

		local PetBG = {}
		for i = 1, 4 do
			PetBG[i] = CreateFrame("Frame", nil, pets[i])
			PetBG[i]:CreatePanel(nil, 1, 1, "CENTER", pets[i], "CENTER", 0, 0)
			PetBG[i]:ClearAllPoints()
			PetBG[i]:Point("TOPLEFT", pets[i], "TOPLEFT", -2, 2)
			PetBG[i]:Point("BOTTOMRIGHT", pets[i], "BOTTOMRIGHT", 2, -2)
			PetBG[i]:SetFrameStrata("LOW")
		end

		local ShowPet = CreateFrame("Frame")
		ShowPet:RegisterEvent("PLAYER_ENTERING_WORLD")
		ShowPet:RegisterEvent("RAID_ROSTER_UPDATE")
		ShowPet:RegisterEvent("PARTY_LEADER_CHANGED")
		ShowPet:RegisterEvent("PARTY_MEMBERS_CHANGED")
		ShowPet:SetScript("OnEvent", function(self)
			if InCombatLockdown() then
				self:RegisterEvent("PLAYER_REGEN_ENABLED")
			else
				self:UnregisterEvent("PLAYER_REGEN_ENABLED")
				local numraid = GetNumRaidMembers()
				local numparty = GetNumPartyMembers()
				if numparty > 0 and numraid == 0 or numraid > 0 and numraid <= 5 then
					for i,v in ipairs(pets) do v:Enable() end
				else
					for i,v in ipairs(pets) do v:Disable() end
				end
			end
		end)		
	end
end)

local RaidBG = CreateFrame("Frame", nil, TukuiGrid)
RaidBG:CreatePanel("Transparent", 1, 1, "CENTER", raid, "CENTER", 0, 0)
RaidBG:Hide()

RaidBG:RegisterEvent("UNIT_NAME_UPDATE")
RaidBG:RegisterEvent("RAID_ROSTER_UPDATE")
RaidBG:RegisterEvent("RAID_TARGET_UPDATE")
RaidBG:RegisterEvent("PARTY_LEADER_CHANGED")
RaidBG:RegisterEvent("PARTY_MEMBERS_CHANGED")
RaidBG:SetScript("OnEvent", function(self)
    if TukuiGrid:IsVisible() then
        self:ClearAllPoints()
        self:Point("TOPLEFT", TukuiGrid, "TOPLEFT", -2, 2)
        self:Point("BOTTOMRIGHT", TukuiGrid, "BOTTOMRIGHT", 2, -2)
        self:Show()
        if not self.parented then
            self:SetParent(TukuiGrid)
            self.parented = true
        end
    else
        self:Hide()
    end
end)

local MaxGroup = CreateFrame("Frame")
MaxGroup:RegisterEvent("PLAYER_ENTERING_WORLD")
MaxGroup:RegisterEvent("ZONE_CHANGED_NEW_AREA")
MaxGroup:SetScript("OnEvent", function(self)
	local inInstance, instanceType = IsInInstance()
	local _, _, _, _, maxPlayers, _, _ = GetInstanceInfo()
	if inInstance and instanceType == "raid" and maxPlayers ~= 40 then
		TukuiGrid:SetAttribute("groupFilter", "1,2,3,4,5")
	else
		TukuiGrid:SetAttribute("groupFilter", "1,2,3,4,5,6,7,8")
	end
end)