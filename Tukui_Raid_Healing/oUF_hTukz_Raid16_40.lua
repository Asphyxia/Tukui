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
	self:SetScript('OnEnter', UnitFrame_OnEnter)
	self:SetScript('OnLeave', UnitFrame_OnLeave)
	
	self.menu = T.SpawnMenu
	
	local health = CreateFrame('StatusBar', nil, self)
	health:SetPoint("TOPLEFT")
	health:SetPoint("TOPRIGHT")
	health:Height(30*C["unitframes"].gridscale*T.raidscale)
	health:SetStatusBarTexture(C["media"].normTex)
	self.Health = health
	
	if C["unitframes"].gridhealthvertical == true then
		health:SetOrientation('VERTICAL')
	end
	
	health.bg = health:CreateTexture(nil, 'BORDER')
	health.bg:SetAllPoints(health)
	health.bg:SetTexture(C["media"].blank)
	health.bg:SetTexture(.150, .150, .150)
	health.bg.multiplier = (0.3)
	self.Health.bg = health.bg
	
	local HealthBorder = CreateFrame("Frame", nil, health)
	HealthBorder:SetPoint("TOPLEFT", health, "TOPLEFT", T.Scale(-2), T.Scale(2))
	HealthBorder:SetPoint("BOTTOMRIGHT", health, "BOTTOMRIGHT", T.Scale(2), T.Scale(-2))
	HealthBorder:SetTemplate("Default")
	HealthBorder:CreateShadow("Default")
	HealthBorder:SetFrameLevel(2)
	self.HealthBorder = HealthBorder
		
	health.value = health:CreateFontString(nil, "OVERLAY")
	health.value:Point("CENTER", health, 1, -1)
	health.value:SetFont(font, C["datatext"].fontsize, "MONOCHROMEOUTLINE")
	health.value:SetTextColor(1,1,1)
	health.value:SetShadowOffset(1, -1)
	self.Health.value = health.value
	
	health.PostUpdate = T.PostUpdateHealthRaid
	
	health.frequentUpdates = true
	
	if C.unitframes.unicolor == true then
		health.colorDisconnected = false
		health.colorClass = false
		health:SetStatusBarColor(.150, .150, .150, 1)
		health.bg:SetVertexColor(0, 0, 0, 1)		
	else
		health.colorDisconnected = true
		health.colorClass = true
		health.colorReaction = true			
	end
	
	if C.unitframes.gradienthealth and C.unitframes.unicolor then
		self:HookScript("OnEnter", function(self) -- Mouseover coloring
			if not UnitIsConnected(self.unit) or UnitIsDead(self.unit) or UnitIsGhost(self.unit) then return end
			local hover = RAID_CLASS_COLORS[select(2, UnitClass(self.unit))]
			if not hover then return end
			health:SetStatusBarColor(hover.r, hover.g, hover.b)
		end)
		
		self:HookScript("OnLeave", function(self)
			if not UnitIsConnected(self.unit) or UnitIsDead(self.unit) or UnitIsGhost(self.unit) then return end
			local r, g, b = oUF.ColorGradient(UnitHealth(self.unit)/UnitHealthMax(self.unit), unpack(C["unitframes"].gradient))
			health:SetStatusBarColor(r, g, b)
		end)
	end
		
	local power = CreateFrame("StatusBar", nil, self)
	power:SetHeight(1.5*C["unitframes"].gridscale*T.raidscale)
	power:SetWidth(54)
	power:Point("CENTER", self.Health, "CENTER", 0, -10)
	power:SetStatusBarTexture(C["media"].normTex)
	power:SetFrameLevel(self.Health:GetFrameLevel() + 2)
	self.Power = power

	power.frequentUpdates = true
	power.colorDisconnected = true

	power.bg = power:CreateTexture(nil, "BORDER")
	power.bg:SetAllPoints(power)
	power.bg:SetTexture(C["media"].normTex)
	power.bg:SetAlpha(1)
	power.bg.multiplier = .4
	
	local PowerBorder = CreateFrame("Frame", nil, power)
	PowerBorder:SetPoint("TOPLEFT", power, "TOPLEFT", T.Scale(-2), T.Scale(2))
	PowerBorder:SetPoint("BOTTOMRIGHT", power, "BOTTOMRIGHT", T.Scale(2), T.Scale(-2))
	PowerBorder:SetTemplate("Thin")
	--PowerBorder:CreateShadow("Default")
	PowerBorder:SetFrameLevel(power:GetFrameLevel() - 1)
	self.PowerBorder = PowerBorder
	
	if C.unitframes.unicolor == true then
		power.colorClass = true
		power.bg.multiplier = 0.1				
	else
		power.colorPower = true
	end
	
	local name = self.Health:CreateFontString(nil, "OVERLAY")
    name:SetPoint("TOP", 0, 18) 
	name:SetPoint("BOTTOM") 
	name:SetPoint("LEFT", 4, 0) 
	name:SetPoint("RIGHT")
	name:SetFont(font, C["datatext"].fontsize, "MONOCHROMEOUTLINE")
	name:SetShadowOffset(1.25, -1.25)
	self:Tag(name, "[Tukui:getnamecolor][Tukui:nameshort]")
	self.Name = name
	
	local leader = health:CreateTexture(nil, "OVERLAY")
    leader:Height(12*T.raidscale)
    leader:Width(12*T.raidscale)
    leader:SetPoint("TOPLEFT", 0, 6)
	self.Leader = leader
	
    local MasterLooter = health:CreateTexture(nil, "OVERLAY")
    MasterLooter:Height(12*T.raidscale)
    MasterLooter:Width(12*T.raidscale)
	self.MasterLooter = MasterLooter
    self:RegisterEvent("PARTY_LEADER_CHANGED", T.MLAnchorUpdate)
    self:RegisterEvent("PARTY_MEMBERS_CHANGED", T.MLAnchorUpdate)
	
	local LFDRole = health:CreateTexture(nil, "OVERLAY")
    LFDRole:Height(15*T.raidscale)
    LFDRole:Width(15*T.raidscale)
	LFDRole:Point("TOP", 0, 10)
	LFDRole:SetTexture("Interface\\AddOns\\Tukui\\medias\\textures\\lfdicons.blp")
	self.LFDRole = LFDRole
	
	
    if C["unitframes"].aggro == true then
		table.insert(self.__elements, T.UpdateThreat)
		self:RegisterEvent('PLAYER_TARGET_CHANGED', T.UpdateThreat)
		self:RegisterEvent('UNIT_THREAT_LIST_UPDATE', T.UpdateThreat)
		self:RegisterEvent('UNIT_THREAT_SITUATION_UPDATE', T.UpdateThreat)
	end
	
	if C["unitframes"].showsymbols == true then
		local RaidIcon = power:CreateTexture(nil, 'OVERLAY')
		RaidIcon:Height(18*T.raidscale)
		RaidIcon:Width(18*T.raidscale)
		RaidIcon:SetPoint('CENTER', self, 'TOP')
		RaidIcon:SetTexture("Interface\\AddOns\\Tukui\\medias\\textures\\raidicons.blp") -- thx hankthetank for texture
		self.RaidIcon = RaidIcon
	end
	
	local ReadyCheck = power:CreateTexture(nil, "OVERLAY")
	ReadyCheck:Height(12*C["unitframes"].gridscale*T.raidscale)
	ReadyCheck:Width(12*C["unitframes"].gridscale*T.raidscale)
	ReadyCheck:SetPoint('CENTER') 	
	self.ReadyCheck = ReadyCheck
	
	--local picon = self.Health:CreateTexture(nil, 'OVERLAY')
	--picon:SetPoint('CENTER', self.Health)
	--picon:SetSize(16, 16)
	--picon:SetTexture[[Interface\AddOns\Tukui\medias\textures\picon]]
	--picon.Override = T.Phasing
	--self.PhaseIcon = picon
	
	if not C["unitframes"].raidunitdebuffwatch == true then
		self.DebuffHighlightAlpha = 1
		self.DebuffHighlightBackdrop = true
		self.DebuffHighlightFilter = true
	end
	
	if C["unitframes"].showrange == true then
		local range = {insideAlpha = 1, outsideAlpha = C["unitframes"].raidalphaoor}
		self.Range = range
	end
	
	if C["unitframes"].showsmooth == true then
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
		mhpb:SetStatusBarTexture(C["media"].normTex)
		mhpb:SetStatusBarColor(0, 1, 0.5, 0.25)

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
		ohpb:SetStatusBarTexture(C["media"].normTex)
		ohpb:SetStatusBarColor(0, 1, 0, 0.25)

		self.HealPrediction = {
			myBar = mhpb,
			otherBar = ohpb,
			maxOverflow = 1,
		}
	end
	
	--Resurrect Indicator
	local Resurrect = CreateFrame('Frame', nil, self)
	Resurrect:SetFrameLevel(20)

	local ResurrectIcon = Resurrect:CreateTexture(nil, "OVERLAY")
	ResurrectIcon:Point(health.value:GetPoint())
	ResurrectIcon:Size(30, 25)
	ResurrectIcon:SetDrawLayer('OVERLAY', 7)

	self.ResurrectIcon = ResurrectIcon
	
	if C["unitframes"].raidunitdebuffwatch == true then
		-- AuraWatch (corner icon)
		T.createAuraWatch(self,unit)
		
		-- Raid Debuffs (big middle icon)
		local RaidDebuffs = CreateFrame('Frame', nil, self)
		RaidDebuffs:Height(21*C["unitframes"].gridscale)
		RaidDebuffs:Width(21*C["unitframes"].gridscale)
		RaidDebuffs:Point('CENTER', health, 2,1)
		RaidDebuffs:SetFrameStrata(power:GetFrameStrata())
		RaidDebuffs:SetFrameLevel(power:GetFrameLevel() + 2)
		
		RaidDebuffs:SetTemplate("Default")
		
		RaidDebuffs.icon = RaidDebuffs:CreateTexture(nil, 'OVERLAY')
		RaidDebuffs.icon:SetTexCoord(.1,.9,.1,.9)
		RaidDebuffs.icon:Point("TOPLEFT", 2, -2)
		RaidDebuffs.icon:Point("BOTTOMRIGHT", -2, 2)
		
		-- just in case someone want to add this feature, uncomment to enable it
		if C["unitframes"].auratimer then
			RaidDebuffs.cd = CreateFrame('Cooldown', nil, RaidDebuffs)
			RaidDebuffs.cd:SetPoint("TOPLEFT", T.Scale(2), T.Scale(-2))
			RaidDebuffs.cd:SetPoint("BOTTOMRIGHT", T.Scale(-2), T.Scale(2))
			RaidDebuffs.cd.noOCC = true -- remove this line if you want cooldown number on it
		end
		
		RaidDebuffs.count = RaidDebuffs:CreateFontString(nil, 'OVERLAY')
		RaidDebuffs.count:SetFont(C["media"].pixelfont, C["datatext"].fontsize, "MONOCHROMEOUTLINE")
		RaidDebuffs.count:SetPoint('BOTTOMRIGHT', RaidDebuffs, 'BOTTOMRIGHT', 0, 2)
		RaidDebuffs.count:SetTextColor(1, .9, 0)
		
		RaidDebuffs:FontString('time', C["media"].pixelfont, C["datatext"].fontsize, "MONOCHROMEOUTLINE")
		RaidDebuffs.time:SetPoint('CENTER')
		RaidDebuffs.time:SetTextColor(1, .9, 0)
		
		self.RaidDebuffs = RaidDebuffs
    end

	return self
end

  -- switch layout
	local swlicon = CreateFrame("Frame", "TukuiSwitchLayoutIcon", UIParent)
	swlicon:CreatePanel("Default", 20, 20, "LEFT", TukuiInfoLeft, "RIGHT", 3, 0)
	swlicon:SetFrameStrata("BACKGROUND")
	swlicon:SetFrameLevel(2)
	swlicon:CreateShadow("Hydra")

	local tex = swlicon:CreateTexture(nil, "OVERLAY")
	tex:SetTexture(C.media.switchlayoutheal)
	tex:SetPoint("TOPLEFT", swlicon, "TOPLEFT", 2, -2)
	tex:SetPoint("BOTTOMRIGHT", swlicon, "BOTTOMRIGHT", -2, 2)

oUF:RegisterStyle('TukuiHealR25R40', Shared)
oUF:Factory(function(self)
	oUF:SetActiveStyle("TukuiHealR25R40")	
	if C["unitframes"].gridonly ~= true then
		local raid = self:SpawnHeader("TukuiGrid", nil, "custom [@raid16,exists] show;hide",
			'oUF-initialConfigFunction', [[
				local header = self:GetParent()
				self:SetWidth(header:GetAttribute('initial-width'))
				self:SetHeight(header:GetAttribute('initial-height'))
			]],
			'initial-width', T.Scale(66*C["unitframes"].gridscale*T.raidscale),
			'initial-height', T.Scale(35*C["unitframes"].gridscale*T.raidscale),	
			"showRaid", true,
			"xoffset", T.Scale(8),
			"yOffset", T.Scale(-3),
			"point", "LEFT",
			"groupFilter", "1,2,3,4,5,6,7,8",
			"groupingOrder", "1,2,3,4,5,6,7,8",
			"groupBy", "GROUP",
			"maxColumns", 8,
			"unitsPerColumn", 5,
			"columnSpacing", T.Scale(3),
			"columnAnchorPoint", "TOP"		
		)
		raid:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 18, -250*T.raidscale)
	else
		local raid = self:SpawnHeader("TukuiGrid", nil, "raid,party",
			'oUF-initialConfigFunction', [[
				local header = self:GetParent()
				self:SetWidth(header:GetAttribute('initial-width'))
				self:SetHeight(header:GetAttribute('initial-height'))
			]],
			'initial-width', T.Scale(66*C["unitframes"].gridscale*T.raidscale),
			'initial-height', T.Scale(35*C["unitframes"].gridscale*T.raidscale),
			"showParty", true,
			"showPlayer", C["unitframes"].showplayerinparty,
			"showSolo", C["unitframes"].showsolo,
			"showRaid", true,
			"xoffset", T.Scale(8),
			"yOffset", T.Scale(-3),
			"point", "LEFT",
			"groupFilter", "1,2,3,4,5,6,7,8",
			"groupingOrder", "1,2,3,4,5,6,7,8",
			"groupBy", "GROUP",
			"maxColumns", 8,
			"unitsPerColumn", 5,
			"columnSpacing", T.Scale(3),
			"columnAnchorPoint", "TOP"		
		)
		raid:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 18, -250*T.raidscale)
		
		local pets = {} 
			pets[1] = oUF:Spawn('partypet1', 'oUF_TukuiPartyPet1') 
			pets[1]:Point('TOPLEFT', raid, 'TOPLEFT', 0, -50*C["unitframes"].gridscale*T.raidscale + -3)
			pets[1]:Size(66*C["unitframes"].gridscale*T.raidscale, 50*C["unitframes"].gridscale*T.raidscale)
		for i =2, 4 do 
			pets[i] = oUF:Spawn('partypet'..i, 'oUF_TukuiPartyPet'..i) 
			pets[i]:Point('LEFT', pets[i-1], 'RIGHT', 3, 0)
			pets[i]:Size(66*C["unitframes"].gridscale*T.raidscale, 50*C["unitframes"].gridscale*T.raidscale)
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

-- only show 5 groups in raid (25 mans raid)
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