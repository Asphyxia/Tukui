local ADDON_NAME, ns = ...
local oUF = ns.oUF or oUF
assert(oUF, "Tukui was unable to locate oUF install.")

ns._Objects = {}
ns._Headers = {}

local T, C, L = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales
if not C["unitframes"].enable == true then return end
if C["unitframes"].style ~= "Asphyxia3" then return end

------------------------------------------------------------------------
--	local variables
------------------------------------------------------------------------

local font1 = C["media"].uffont
local font2 = C["media"].font
local font = C["media"].pixelfont
local normTex = C["media"].normTex
local glowTex = C["media"].glowTex
local bubbleTex = C["media"].bubbleTex

local backdrop = {
	bgFile = C["media"].blank,
	insets = {top = -T.mult, left = -T.mult, bottom = -T.mult, right = -T.mult},
}

------------------------------------------------------------------------
--	Layout
------------------------------------------------------------------------

local function Shared(self, unit)
	-- set our own colors
	self.colors = T.oUF_colors
	
	-- register click
	self:RegisterForClicks("AnyUp")
	self:SetScript('OnEnter', UnitFrame_OnEnter)
	self:SetScript('OnLeave', UnitFrame_OnLeave)
	
	-- menu? lol
	self.menu = T.SpawnMenu

	------------------------------------------------------------------------
	--	Features we want for all units at the same time
	------------------------------------------------------------------------
	
	-- here we create an invisible frame for all element we want to show over health/power.
	local InvFrame = CreateFrame("Frame", nil, self)
	InvFrame:SetFrameStrata("HIGH")
	InvFrame:SetFrameLevel(5)
	InvFrame:SetAllPoints()
	
	-- symbols, now put the symbol on the frame we created above.
	local RaidIcon = InvFrame:CreateTexture(nil, "OVERLAY")
	RaidIcon:SetTexture("Interface\\AddOns\\Tukui\\medias\\textures\\raidicons.blp") -- thx hankthetank for texture
	RaidIcon:SetHeight(20)
	RaidIcon:SetWidth(20)
	RaidIcon:SetPoint("TOP", 0, 11)
	self.RaidIcon = RaidIcon
	
	------------------------------------------------------------------------
	--	Player and Target units layout (mostly mirror'd)
	------------------------------------------------------------------------
	
	if (unit == "player" or unit == "target") then
		-- create a panel
		local panel = CreateFrame("Frame", nil, self)
		if T.lowversion then
			panel:CreatePanel("Default", 184, 20, "BOTTOM", self, "BOTTOM", 0, 0)
		else
			panel:CreatePanel("Default", 250, 20, "BOTTOM", self, "BOTTOM", 0, 0)
		end
		panel:SetFrameLevel(2)
		panel:SetFrameStrata("MEDIUM")
		panel:SetBackdropBorderColor(unpack(C["media"].altbordercolor))
		panel:SetAlpha(0)
		self.panel = panel
	
		-- health bar
		local health = CreateFrame('StatusBar', nil, self)
		health:Height(23)
		health:SetPoint("TOPLEFT")
		health:SetPoint("TOPRIGHT")
		health:SetStatusBarTexture(normTex)
		
		-- Border for HealthBar
		local HealthBorder = CreateFrame("Frame", nil, health)
		HealthBorder:SetPoint("TOPLEFT", health, "TOPLEFT", T.Scale(-2), T.Scale(2))
		HealthBorder:SetPoint("BOTTOMRIGHT", health, "BOTTOMRIGHT", T.Scale(2), T.Scale(-2))
		HealthBorder:SetTemplate("Default")
		HealthBorder:SetFrameLevel(2)
		self.HealthBorder = HealthBorder
						
		-- health bar background
		local healthBG = health:CreateTexture(nil, 'BORDER')
		healthBG:SetAllPoints()
		healthBG:SetTexture(0, 0, 0)
	
		health.value = T.SetFontString(health, font, 10, "THINOUTLINE")
		health.value:Point("RIGHT", health, "RIGHT", -4, 1)
		health.PostUpdate = T.PostUpdateHealth
				
		self.Health = health
		self.Health.bg = healthBG

		health.frequentUpdates = true
		if C["unitframes"].showsmooth == true then
			health.Smooth = true
		end
		
		if C["unitframes"].unicolor == true then
			health.colorTapping = false
			health.colorDisconnected = false
			health.colorClass = false
			health:SetStatusBarColor(.125, .125, .125, 1)
			healthBG:SetVertexColor(0, 0, 0, 1)		
		else
			health.colorDisconnected = true
			health.colorTapping = true	
			health.colorClass = true
			health.colorReaction = true			
		end

			-- power
		local power = CreateFrame('StatusBar', nil, self)
		power:Height(30)
		power:Width(256)
		if unit == "player" then
			power:Point("TOP", health, "BOTTOM", 2, 23)
			power:Point("TOPRIGHT", health, "BOTTOMRIGHT", 10, -2)
		elseif unit == "target" then
			power:Point("TOP", health, "BOTTOM", 2, 35)
			power:Point("TOPLEFT", health, "BOTTOMLEFT", -10, 23)
		end
		power:SetStatusBarTexture(normTex)
		power:SetFrameLevel(self.Health:GetFrameLevel() + 2)
		power:SetFrameStrata("BACKGROUND")
		
		-- Border for Power
		local PowerBorder = CreateFrame("Frame", nil, power)
		PowerBorder:SetPoint("TOPLEFT", power, "TOPLEFT", T.Scale(-2), T.Scale(2))
		PowerBorder:SetPoint("BOTTOMRIGHT", power, "BOTTOMRIGHT", T.Scale(2), T.Scale(-2))
		PowerBorder:SetTemplate("Default")
		PowerBorder:CreateShadow("Default")
		PowerBorder.shadow:Point("TOPLEFT", -3, 0)
		PowerBorder:SetFrameLevel(power:GetFrameLevel() - 1)
		self.PowerBorder = PowerBorder
		
		local powerBG = power:CreateTexture(nil, 'BORDER')
		powerBG:SetAllPoints(power)
		powerBG:SetTexture(normTex)
		powerBG.multiplier = 0.3
		
		power.value = T.SetFontString(health,font, 10, "THINOUTLINE")
		power.value:Point("LEFT", health, "LEFT", 4, 1)
		power.PreUpdate = T.PreUpdatePower
		power.PostUpdate = T.PostUpdatePower
				
		self.Power = power
		self.Power.bg = powerBG
		
		power.frequentUpdates = true
		power.colorDisconnected = true

		if C["unitframes"].showsmooth == true then
			power.Smooth = true
		end
		
		if C["unitframes"].unicolor == true then
			power.colorTapping = true
			power.colorClass = true
			powerBG.multiplier = 0.1				
		else
			power.colorPower = true
		end
		
		---Leaving this here, If anyone wants Health Portrait.
		
		-- name and level
		--[[
		if (unit == "player") then
			local Name = health:CreateFontString(nil, "OVERLAY")
			self:Tag(Name, '[Tukui:getnamecolor][Tukui:namelong] [Tukui:diffcolor][level] [shortclassification]')
			Name:SetPoint("CENTER", health, "CENTER", 0, 1)
			Name:SetJustifyH("CENTER")
			Name:SetFont(font, 10, "THINOUTLINE")
			Name:SetShadowColor(0, 0, 0)
			Name:SetShadowOffset(1.25, -1.25)
			self.Name = Name
		end
		--]]

			-- portraits
		if (C["unitframes"].charportrait == true) then
			local portrait = CreateFrame("PlayerModel", self:GetName().."_Portrait", self)
			portrait:SetFrameLevel(8)
			portrait:SetHeight(5)
			portrait:SetWidth(256)
			portrait:SetAlpha(1)
			if unit == "player" then
				portrait:SetPoint("TOP", health, "BOTTOM", 5, -12)
			elseif unit == "target" then
				portrait:SetPoint("TOP", health, "BOTTOM", -5, -12)
			end
			table.insert(self.__elements, T.HidePortrait)
			self.Portrait = portrait
			
			-- Border for Portrait
			local PFrame = CreateFrame("Frame", nil, portrait)
			PFrame:SetPoint("TOPLEFT", portrait, "TOPLEFT", T.Scale(-2), T.Scale(2))
			PFrame:SetPoint("BOTTOMRIGHT", portrait, "BOTTOMRIGHT", T.Scale(2), T.Scale(-2))
			PFrame:SetTemplate("Default")
			PFrame:CreateShadow("Default")
			PFrame:SetFrameLevel(2)
			self.PFrame = PFrame
		end
		
		if T.myclass == "PRIEST" and C["unitframes"].weakenedsoulbar then
			local ws = CreateFrame("StatusBar", self:GetName().."_WeakenedSoul", power)
			ws:SetAllPoints(power)
			ws:SetStatusBarTexture(C.media.normTex)
			ws:GetStatusBarTexture():SetHorizTile(false)
			ws:SetBackdrop(backdrop)
			ws:SetBackdropColor(unpack(C.media.backdropcolor))
			ws:SetStatusBarColor(191/255, 10/255, 10/255)
			
			self.WeakenedSoul = ws
		end
		
		--[[ leaving here just in case someone want to use it, we now use our own Alt Power Bar.
		-- alt power bar
		local AltPowerBar = CreateFrame("StatusBar", self:GetName().."_AltPowerBar", self.Health)
		AltPowerBar:SetFrameLevel(0)
		AltPowerBar:SetFrameStrata("LOW")
		AltPowerBar:SetHeight(5)
		AltPowerBar:SetStatusBarTexture(C.media.normTex)
		AltPowerBar:GetStatusBarTexture():SetHorizTile(false)
		AltPowerBar:SetStatusBarColor(163/255,  24/255,  24/255)
		AltPowerBar:EnableMouse(true)

		AltPowerBar:Point("LEFT", TukuiInfoLeft, 2, -2)
		AltPowerBar:Point("RIGHT", TukuiInfoLeft, -2, 2)
		AltPowerBar:Point("TOP", TukuiInfoLeft, 2, -2)
		AltPowerBar:Point("BOTTOM", TukuiInfoLeft, -2, 2)
		
		AltPowerBar:SetBackdrop({
			bgFile = C["media"].blank, 
			edgeFile = C["media"].blank, 
			tile = false, tileSize = 0, edgeSize = 1, 
			insets = { left = 0, right = 0, top = 0, bottom = T.Scale(-1)}
		})
		AltPowerBar:SetBackdropColor(0, 0, 0)

		self.AltPowerBar = AltPowerBar
		--]]
			
		if (unit == "player") then
			-- combat icon
			local Combat = health:CreateTexture(nil, "OVERLAY")
			Combat:Height(19)
			Combat:Width(19)
			Combat:SetPoint("CENTER",0,1)
			Combat:SetVertexColor(0.69, 0.31, 0.31)
			self.Combat = Combat

			-- custom info (low mana warning)
			FlashInfo = CreateFrame("Frame", "TukuiFlashInfo", self)
			FlashInfo:SetScript("OnUpdate", T.UpdateManaLevel)
			FlashInfo.parent = self
			FlashInfo:SetAllPoints(panel)
			FlashInfo.ManaLevel = T.SetFontString(FlashInfo, font, 12)
			FlashInfo.ManaLevel:SetPoint("CENTER", panel, "CENTER", 0, 0)
			self.FlashInfo = FlashInfo
			
			-- pvp status text
			local status = T.SetFontString(panel, font, 12)
			status:SetPoint("CENTER", panel, "CENTER", 0, 0)
			status:SetTextColor(0.69, 0.31, 0.31)
			status:Hide()
			self.Status = status
			self:Tag(status, "[pvp]")
			
			-- leader icon
			local Leader = InvFrame:CreateTexture(nil, "OVERLAY")
			Leader:Height(14)
			Leader:Width(14)
			Leader:Point("TOPLEFT", 2, 8)
			self.Leader = Leader
			
			-- master looter
			local MasterLooter = InvFrame:CreateTexture(nil, "OVERLAY")
			MasterLooter:Height(14)
			MasterLooter:Width(14)
			self.MasterLooter = MasterLooter
			self:RegisterEvent("PARTY_LEADER_CHANGED", T.MLAnchorUpdate)
			self:RegisterEvent("PARTY_MEMBERS_CHANGED", T.MLAnchorUpdate)

			--This is the edited code for the original rep/exp bar
			-- experience bar on player via mouseover for player currently levelling a character
			if T.level ~= MAX_PLAYER_LEVEL then
				local Experience = CreateFrame("StatusBar", self:GetName().."_Experience", self)
				Experience:SetStatusBarTexture(normTex)
				Experience:SetStatusBarColor(0, 0.4, 1, .8)
				Experience:Size(TukuiPlayer:GetWidth()+254, 12)
				Experience:Point("TOPLEFT", TukuiPlayer, "BOTTOMLEFT", 0, -10)
				Experience:SetFrameLevel(10)
				Experience.Tooltip = true
				self.Experience = Experience
				Experience:SetAlpha(0)
				Experience:SetScript("OnEnter", function(self) self:SetAlpha(1) end)
				Experience:SetScript("OnLeave", function(self) self:SetAlpha(0) end)
				
				local ExperienceBG = Experience:CreateTexture(nil, 'BORDER')
				ExperienceBG:SetAllPoints()
				ExperienceBG:SetTexture(normTex)
				ExperienceBG:SetVertexColor(.1,.1,.1,1)

				Experience.Text = self.Experience:CreateFontString(nil, 'OVERLAY')
				Experience.Text:SetFont(font, 10, "THINOUTLINE")
				Experience.Text:SetPoint('CENTER', 0, 1, self.Experience)
				Experience.Text:SetShadowOffset(T.mult, -T.mult)
				self.Experience.Text = Experience.Text
				self.Experience.PostUpdate = T.ExperienceText

				self.Experience.Rested = CreateFrame('StatusBar', nil, self.Experience)
				self.Experience.Rested:SetAllPoints(self.Experience)
				self.Experience.Rested:SetStatusBarTexture(normTex)
				self.Experience.Rested:SetStatusBarColor(1, 0, 1, 0.2)		

				local Resting = Experience:CreateTexture(nil, "OVERLAY")
				Resting:SetHeight(28)
				Resting:SetWidth(28)
				Resting:SetPoint("BOTTOMRIGHT", self, "TOPLEFT", 10, -4)
				Resting:SetTexture([=[Interface\CharacterFrame\UI-StateIcon]=])
				Resting:SetTexCoord(0, 0.5, 0, 0.421875)
				self.Resting = Resting

				local ExperienceFrame = CreateFrame("Frame", nil, self.Experience)
				ExperienceFrame:SetPoint("TOPLEFT", T.Scale(-2), T.Scale(2))
				ExperienceFrame:SetPoint("BOTTOMRIGHT", T.Scale(2), T.Scale(-2))
				ExperienceFrame:SetTemplate("Default")
				ExperienceFrame:CreateShadow("Default")
				ExperienceFrame:SetFrameLevel(self.Experience:GetFrameLevel() - 1)
			end

			-- reputation bar for max level character
			if T.level == MAX_PLAYER_LEVEL then
				local Reputation = CreateFrame("StatusBar", self:GetName().."_Reputation", self)
				Reputation:SetStatusBarTexture(normTex)
				Reputation:Size(TukuiPlayer:GetWidth() +254, 12)
				Reputation:Point("TOPLEFT", TukuiPlayer, "BOTTOMLEFT", 0, -10)
				Reputation:SetFrameLevel(10)
				local ReputationBG = Reputation:CreateTexture(nil, 'BORDER')
				ReputationBG:SetAllPoints()
				ReputationBG:SetTexture(normTex)
				ReputationBG:SetVertexColor(.1,.1,.1,1)

				Reputation.Text = Reputation:CreateFontString(nil, 'OVERLAY')
				Reputation.Text:SetFont(font, 10, "THINOUTLINE")
				Reputation.Text:SetPoint('CENTER', 0, 1, Reputation)
				Reputation.Text:SetShadowOffset(T.mult, -T.mult)
				Reputation.Text:Show()
				Reputation.PostUpdate = T.UpdateReputation
				Reputation.Text = Reputation.Text

				Reputation.PostUpdate = T.UpdateReputationColor
				Reputation.Tooltip = true
				self.Reputation = Reputation
				Reputation:SetAlpha(0)
				Reputation:SetScript("OnEnter", function(self) self:SetAlpha(1) end)
				Reputation:SetScript("OnLeave", function(self) self:SetAlpha(0) end)

				local ReputationFrame = CreateFrame("Frame", nil, self.Reputation)
				ReputationFrame:SetPoint("TOPLEFT", T.Scale(-2), T.Scale(2))
				ReputationFrame:SetPoint("BOTTOMRIGHT", T.Scale(2), T.Scale(-2))
				ReputationFrame:SetTemplate("Default")
				ReputationFrame:CreateShadow("Default")
				ReputationFrame:SetFrameLevel(self.Reputation:GetFrameLevel() - 1)
			end
		
			-- show druid mana when shapeshifted in bear, cat or whatever
			if C["unitframes"].classbar then
				if T.myclass == "DRUID" then

					local eclipseBar = CreateFrame('Frame', nil, self)
					eclipseBar:Point("BOTTOM", self, "TOP", 0, 0)
					eclipseBar:Size(85, 5)
					eclipseBar:SetFrameStrata("MEDIUM")
					eclipseBar:SetFrameLevel(8)
					eclipseBar:SetBackdropBorderColor(0,0,0,0)
					eclipseBar:SetScript("OnShow", function() T.EclipseDisplay(self, false) end)
					eclipseBar:SetScript("OnUpdate", function() T.EclipseDisplay(self, true) end) -- just forcing 1 update on login for buffs/shadow/etc.
					eclipseBar:SetScript("OnHide", function() T.EclipseDisplay(self, false) end)
					
					local lunarBar = CreateFrame('StatusBar', nil, eclipseBar)
					lunarBar:SetPoint('LEFT', eclipseBar, 'LEFT', 0, 0)
					lunarBar:SetSize(eclipseBar:GetWidth(), eclipseBar:GetHeight())
					lunarBar:SetStatusBarTexture(normTex)
					lunarBar:SetStatusBarColor(.30, .52, .90)
					eclipseBar.LunarBar = lunarBar

					local solarBar = CreateFrame('StatusBar', nil, eclipseBar)
					solarBar:SetPoint('LEFT', lunarBar:GetStatusBarTexture(), 'RIGHT', 0, 0)
					solarBar:SetSize(eclipseBar:GetWidth(), eclipseBar:GetHeight())
					solarBar:SetStatusBarTexture(normTex)
					solarBar:SetStatusBarColor(.80, .82,  .60)
					eclipseBar.SolarBar = solarBar

					local eclipseBarText = eclipseBar:CreateFontString(nil, 'OVERLAY')
					eclipseBarText:SetPoint('TOP', eclipseBar, 0, 25)
					eclipseBarText:SetPoint('BOTTOM', eclipseBar)
					eclipseBarText:SetFont(font, 10, "THINOUTLINE")
					eclipseBarText:SetShadowOffset(T.mult, -T.mult)
					eclipseBarText:SetShadowColor(0, 0, 0, 0.4)
					eclipseBar.PostUpdatePower = T.EclipseDirection
					
					-- hide "low mana" text on load if eclipseBar is show
					if eclipseBar and eclipseBar:IsShown() then FlashInfo.ManaLevel:SetAlpha(0) end

					self.EclipseBar = eclipseBar
					self.EclipseBar.Text = eclipseBarText
					
					eclipseBar.FrameBackdrop = CreateFrame("Frame", nil, eclipseBar)
					eclipseBar.FrameBackdrop:SetTemplate("Default")
					eclipseBar.FrameBackdrop:SetPoint("TOPLEFT", T.Scale(-2), T.Scale(2))
					eclipseBar.FrameBackdrop:SetPoint("BOTTOMRIGHT", T.Scale(2), T.Scale(-2))
					eclipseBar.FrameBackdrop:SetFrameLevel(eclipseBar:GetFrameLevel() - 1)
				end

				-- set holy power bar or shard bar
				if (T.myclass == "WARLOCK" or T.myclass == "PALADIN") then
		
					local bars = CreateFrame("Frame", nil, self)
                    bars:Size(15, 10)
					bars:Point("TOPLEFT", health, "TOPLEFT", 8, 7)
					bars:SetBackdropBorderColor(0,0,0,0)
					bars:SetFrameLevel(self:GetFrameLevel() + 3)
					bars:SetFrameStrata("HIGH")
					
					for i = 1, 3 do					
						bars[i]=CreateFrame("StatusBar", self:GetName().."_Shard"..i, bars)
						bars[i]:Height(10)					
						bars[i]:SetStatusBarTexture(normTex)
						bars[i]:GetStatusBarTexture():SetHorizTile(false)
						
						if T.myclass == "WARLOCK" then
							bars[i]:SetStatusBarColor(148/255, 130/255, 201/255)
						elseif T.myclass == "PALADIN" then
							bars[i]:SetStatusBarColor(228/255,225/255,16/255)
						end
						
						if i == 1 then
							bars[i]:SetPoint("LEFT", bars)
							bars[i]:SetWidth(T.Scale(15 /2)) 
						else
							bars[i]:Point("LEFT", bars[i-1], "RIGHT", T.Scale(8), 0)
							bars[i]:SetWidth(T.Scale(15/2))
						end
						
						bars[i].border = CreateFrame("Frame", nil, bars)
					    bars[i].border:SetPoint("TOPLEFT", bars[i], "TOPLEFT", T.Scale(-2), T.Scale(2))
					    bars[i].border:SetPoint("BOTTOMRIGHT", bars[i], "BOTTOMRIGHT", T.Scale(2), T.Scale(-2))
					    bars[i].border:SetFrameStrata("MEDIUM")
						bars[i].border:SetFrameLevel(6)
						bars[i]:SetFrameLevel(2)
						bars[i]:SetFrameStrata("HIGH")
					    bars[i].border:SetTemplate("Default")
					    bars[i].border:CreateShadow("Default")
						--bars[i].border:SetBackdropColor(.1,.1,.1,1)
					end
					
					if T.myclass == "WARLOCK" then
						bars.Override = T.UpdateShards				
						self.SoulShards = bars
					elseif T.myclass == "PALADIN" then
						bars.Override = T.UpdateHoly
						self.HolyPower = bars
					end
				end	

				-- deathknight runes
				if T.myclass == "DEATHKNIGHT" then
					
				local Runes = CreateFrame("Frame", nil, self)
                Runes:Point("RIGHT", health, "LEFT", -30, 0)
                Runes:Size(30, 5)
				Runes:SetFrameLevel(self:GetFrameLevel() + 3)
				Runes:SetFrameStrata("MEDIUM")

				for i = 1, 6 do
                    Runes[i] = CreateFrame("StatusBar", self:GetName().."_Runes"..i, self)
                    Runes[i]:SetHeight(T.Scale(23))

                if i == 1 then
                        Runes[i]:SetPoint("LEFT", Runes, "LEFT", 0, 0)
						Runes[i]:SetWidth(T.Scale(30 /6))
                    else
                        Runes[i]:SetPoint("LEFT", Runes[i-1], "RIGHT", T.Scale(5), 0)
						Runes[i]:SetWidth(T.Scale(30 /6))
                    end
                    Runes[i]:SetStatusBarTexture(normTex)
                    Runes[i]:GetStatusBarTexture():SetHorizTile(false)
					Runes[i]:SetBackdrop(backdrop)
                    Runes[i]:SetBackdropColor(0,0,0)
                    Runes[i]:SetFrameLevel(4)
                    
                    Runes[i].bg = Runes[i]:CreateTexture(nil, "BORDER")
                    Runes[i].bg:SetAllPoints(Runes[i])
                    Runes[i].bg:SetTexture(normTex)
                    Runes[i].bg.multiplier = 0.3
					
					Runes[i].border = CreateFrame("Frame", nil, Runes[i])
					Runes[i].border:SetPoint("TOPLEFT", Runes[i], "TOPLEFT", T.Scale(-2), T.Scale(2))
					Runes[i].border:SetPoint("BOTTOMRIGHT", Runes[i], "BOTTOMRIGHT", T.Scale(2), T.Scale(-2))
					Runes[i].border:SetFrameStrata("MEDIUM")
                    Runes[i].border:SetFrameLevel(4)					
					Runes[i].border:SetTemplate("Default")
					Runes[i]:SetOrientation'VERTICAL'
                end

                    self.Runes = Runes
                end
				
				-- shaman totem bar
				if T.myclass == "SHAMAN" then
				local TotemBar = {}
					TotemBar.Destroy = true
					for i = 1, 4 do
						TotemBar[i] = CreateFrame("StatusBar", self:GetName().."_TotemBar"..i, self)
						TotemBar[i]:SetFrameLevel(self:GetFrameLevel() + 3)
						if (i == 1) then
					    TotemBar[i]:Point("RIGHT", health, "LEFT", -43, 0) else
					    TotemBar[i]:SetPoint("TOPLEFT", TotemBar[i-1], "TOPRIGHT", T.Scale(7), 0)
					end
					TotemBar[i]:SetStatusBarTexture(normTex)
					TotemBar[i]:SetHeight(T.Scale(23))
					TotemBar[i]:SetWidth(T.Scale(20) / 4)
					TotemBar[i]:SetFrameLevel(4)
				
					TotemBar[i]:SetBackdrop(backdrop)
					TotemBar[i]:SetBackdropColor(0, 0, 0, 1)
					TotemBar[i]:SetMinMaxValues(0, 1)

					TotemBar[i].bg = TotemBar[i]:CreateTexture(nil, "BORDER")
					TotemBar[i].bg:SetAllPoints(TotemBar[i])
					TotemBar[i].bg:SetTexture(normTex)
					TotemBar[i].bg.multiplier = 0.2
					
					TotemBar[i].border = CreateFrame("Frame", nil, TotemBar[i])
					TotemBar[i].border:SetPoint("TOPLEFT", TotemBar[i], "TOPLEFT", T.Scale(-2), T.Scale(2))
					TotemBar[i].border:SetPoint("BOTTOMRIGHT", TotemBar[i], "BOTTOMRIGHT", T.Scale(2), T.Scale(-2))
					TotemBar[i].border:SetFrameStrata("MEDIUM")
					TotemBar[i].border:SetFrameLevel(4)
					TotemBar[i]:SetFrameLevel(4)
					TotemBar[i]:SetFrameStrata("MEDIUM")
					TotemBar[i].border:SetTemplate("Default")
					TotemBar[i]:SetOrientation'VERTICAL'
				end
				self.TotemBar = TotemBar
			end
		end	
			
			-- script for pvp status and low mana
			self:SetScript("OnEnter", function(self)
				if self.EclipseBar and self.EclipseBar:IsShown() then 
					self.EclipseBar.Text:Hide()
				end
				FlashInfo.ManaLevel:Hide()
				status:Show()
				UnitFrame_OnEnter(self) 
			end)
			self:SetScript("OnLeave", function(self) 
				if self.EclipseBar and self.EclipseBar:IsShown() then 
					self.EclipseBar.Text:Show()
				end
				FlashInfo.ManaLevel:Show()
				status:Hide()
				UnitFrame_OnLeave(self) 
			end)
		end
		
		if (unit == "target") then			
			-- Unit name on target
			local Name = health:CreateFontString(nil, "OVERLAY")
			Name:Point("LEFT", panel, "LEFT", 4, 0)
			Name:SetJustifyH("LEFT")
			Name:SetFont(font, 10, "THINOUTLINE")

			self:Tag(Name, '[Tukui:getnamecolor][Tukui:namelong] [Tukui:diffcolor][level] [shortclassification]')
			self.Name = Name

			-- combo points on target
			
			local cp = T.SetFontString(self, font2, 15, "THINOUTLINE")
			cp:SetPoint("RIGHT", health.border, "LEFT", -5, 0)
			
			self.CPoints = cp
		end
				
		if (unit == "target" and C["unitframes"].targetauras) or (unit == "player" and C["unitframes"].playerauras) then
			local buffs = CreateFrame("Frame", nil, self)
			local debuffs = CreateFrame("Frame", nil, self)
			
			if (T.myclass == "SHAMAN" or T.myclass == "DEATHKNIGHT" or T.myclass == "PALADIN" or T.myclass == "WARLOCK") and (C["unitframes"].playerauras) and (unit == "player") then
				if T.lowversion then
					buffs:SetPoint("TOPLEFT", self, "TOPLEFT", 0, 34)
				else
					buffs:SetPoint("TOPLEFT", self, "TOPLEFT", 0, 38)
				end
			else
				if T.lowversion then
					buffs:SetPoint("TOPLEFT", self, "TOPLEFT", 0, 26)
				else
					buffs:SetPoint("TOPLEFT", self, "TOPLEFT", 0, 30)
				end
			end
			
			if T.lowversion then
				buffs:SetHeight(21.5)
				buffs:SetWidth(186)
				buffs.size = 21.5
				buffs.num = 8
				
				debuffs:SetHeight(21.5)
				debuffs:SetWidth(186)
				debuffs:SetPoint("BOTTOMLEFT", buffs, "TOPLEFT", 0, 2)
				debuffs.size = 21.5	
				debuffs.num = 24
			else				
				buffs:SetHeight(26)
				buffs:SetWidth(252)
				buffs.size = 26
				buffs.num = 9
				
				debuffs:SetHeight(26)
				debuffs:SetWidth(252)
				debuffs:SetPoint("BOTTOMLEFT", buffs, "TOPLEFT", -2, 2)
				debuffs.size = 26
				debuffs.num = 27
			end
						
			buffs.spacing = 2
			buffs.initialAnchor = 'TOPLEFT'
			buffs.PostCreateIcon = T.PostCreateAura
			buffs.PostUpdateIcon = T.PostUpdateAura
			self.Buffs = buffs	
						
			debuffs.spacing = 2
			debuffs.initialAnchor = 'TOPRIGHT'
			debuffs["growth-y"] = "UP"
			debuffs["growth-x"] = "LEFT"
			debuffs.PostCreateIcon = T.PostCreateAura
			debuffs.PostUpdateIcon = T.PostUpdateAura
			
			-- an option to show only our debuffs on target
			if unit == "target" then
				debuffs.onlyShowPlayer = C.unitframes.onlyselfdebuffs
			end
			
			self.Debuffs = debuffs
		end
		
		-- cast bar for player and target
		if (C["unitframes"].unitcastbar == true) then
			-- castbar of player and target
			local castbar = CreateFrame("StatusBar", self:GetName().."CastBar", self)
			castbar:SetStatusBarTexture(normTex)
			
			castbar.bg = castbar:CreateTexture(nil, "BORDER")
			castbar.bg:SetAllPoints(castbar)
			castbar.bg:SetTexture(normTex)
			castbar.bg:SetVertexColor(.05, .05, .05)
			if unit == "player" then
				if C["unitframes"].cbicons == true then
					castbar:SetWidth(300)
				else
					castbar:SetWidth(TukuiBar1:GetWidth() - 4)
				end
				castbar:SetHeight(17)
				castbar:Point("BOTTOM", TukuiBar1, "TOP", 0, 15)
			elseif unit == "target" then
				if C["unitframes"].cbicons == true then
					castbar:SetWidth(246 - 27)
				else
					castbar:SetWidth(246)
				end
				castbar:SetHeight(17)
				castbar:Point("TOPRIGHT", self, "BOTTOMRIGHT", 0, -8)
			end
			castbar:SetFrameLevel(6)

			-- Border
			castbar.border = CreateFrame("Frame", nil, castbar)
			castbar.border:CreatePanel("Default",1,1,"TOPLEFT", castbar, "TOPLEFT", -2, 2)
			castbar.border:CreateShadow("Default")
			castbar.border:Point("BOTTOMRIGHT", castbar, "BOTTOMRIGHT", 2, -2)
			
			castbar.CustomTimeText = T.CustomCastTimeText
			castbar.CustomDelayText = T.CustomCastDelayText
			castbar.PostCastStart = T.CheckCast
			castbar.PostChannelStart = T.CheckChannel

			castbar.time = T.SetFontString(castbar,font, 10, "THINOUTLINE")
			castbar.time:Point("RIGHT", castbar.bg, "RIGHT", -4, 0)
			castbar.time:SetTextColor(0, 4, 0)
			castbar.time:SetJustifyH("RIGHT")

			castbar.Text = T.SetFontString(castbar,font, 10, "THINOUTLINE")
			castbar.Text:Point("LEFT", castbar.bg, "LEFT", 4, 0)
			castbar.Text:SetTextColor(0.3, 0.2, 1)
			castbar.Text:Width(100)
			castbar.Text:Height(10)
			
			if C["unitframes"].cbicons == true then
				castbar.button = CreateFrame("Frame", nil, castbar)
				castbar.button:Size(22)
				castbar.button:SetTemplate("Default")
				castbar.button:CreateShadow("Default")
				castbar.button:SetPoint("RIGHT",castbar,"LEFT", -5, 0)

				castbar.icon = castbar.button:CreateTexture(nil, "ARTWORK")
				castbar.icon:Point("TOPLEFT", castbar.button, 2, -2)
				castbar.icon:Point("BOTTOMRIGHT", castbar.button, -2, 2)
				castbar.icon:SetTexCoord(0.08, 0.92, 0.08, .92)
			end
			
			-- cast bar latency on player
			if unit == "player" and C["unitframes"].cblatency == true then
				castbar.safezone = castbar:CreateTexture(nil, "ARTWORK")
				castbar.safezone:SetTexture(normTex)
				castbar.safezone:SetVertexColor(0.8, 0.2, 0.2, 0.75)
				castbar.SafeZone = castbar.safezone
			end
					
			self.Castbar = castbar
			self.Castbar.Time = castbar.time
			self.Castbar.Icon = castbar.icon
		end
		
		-- add combat feedback support
		if C["unitframes"].combatfeedback == true then
			local CombatFeedbackText 
			if T.lowversion then
				CombatFeedbackText = T.SetFontString(health, font, 10, "OUTLINE")
			else
				CombatFeedbackText = T.SetFontString(health, font, 10, "OUTLINE")
			end
			CombatFeedbackText:SetPoint("CENTER", 0, 1)
			CombatFeedbackText.colors = {
				DAMAGE = {0.69, 0.31, 0.31},
				CRUSHING = {0.69, 0.31, 0.31},
				CRITICAL = {0.69, 0.31, 0.31},
				GLANCING = {0.69, 0.31, 0.31},
				STANDARD = {0.84, 0.75, 0.65},
				IMMUNE = {0.84, 0.75, 0.65},
				ABSORB = {0.84, 0.75, 0.65},
				BLOCK = {0.84, 0.75, 0.65},
				RESIST = {0.84, 0.75, 0.65},
				MISS = {0.84, 0.75, 0.65},
				HEAL = {0.33, 0.59, 0.33},
				CRITHEAL = {0.33, 0.59, 0.33},
				ENERGIZE = {0.31, 0.45, 0.63},
				CRITENERGIZE = {0.31, 0.45, 0.63},
			}
			self.CombatFeedbackText = CombatFeedbackText
		end
		
		if C["unitframes"].healcomm then
			local mhpb = CreateFrame('StatusBar', nil, self.Health)
			mhpb:SetPoint('TOPLEFT', self.Health:GetStatusBarTexture(), 'TOPRIGHT', 0, 0)
			mhpb:SetPoint('BOTTOMLEFT', self.Health:GetStatusBarTexture(), 'BOTTOMRIGHT', 0, 0)
			if T.lowversion then
				mhpb:SetWidth(186)
			else
				mhpb:SetWidth(250)
			end
			mhpb:SetStatusBarTexture(normTex)
			mhpb:SetStatusBarColor(0, 1, 0.5, 0.25)
			mhpb:SetMinMaxValues(0,1)

			local ohpb = CreateFrame('StatusBar', nil, self.Health)
			ohpb:SetPoint('TOPLEFT', mhpb:GetStatusBarTexture(), 'TOPRIGHT', 0, 0)
			ohpb:SetPoint('BOTTOMLEFT', mhpb:GetStatusBarTexture(), 'BOTTOMRIGHT', 0, 0)
			ohpb:SetWidth(250)
			ohpb:SetStatusBarTexture(normTex)
			ohpb:SetStatusBarColor(0, 1, 0, 0.25)

			self.HealPrediction = {
				myBar = mhpb,
				otherBar = ohpb,
				maxOverflow = 1,
			}
		end
		
		-- player aggro
		if C["unitframes"].playeraggro == true then
			table.insert(self.__elements, T.UpdateThreat)
			self:RegisterEvent('PLAYER_TARGET_CHANGED', T.UpdateThreat)
			self:RegisterEvent('UNIT_THREAT_LIST_UPDATE', T.UpdateThreat)
			self:RegisterEvent('UNIT_THREAT_SITUATION_UPDATE', T.UpdateThreat)
		end
	end
	
------------------------------------------------------------------------
	--	Target of Target unit layout
	------------------------------------------------------------------------
	
	if (unit == "targettarget") then
		-- create panel if higher version
		local panel = CreateFrame("Frame", nil, self)
		if not T.lowversion then
			panel:CreatePanel("Default", 129, 18, "BOTTOM", self, "BOTTOM", 0, T.Scale(0))
			panel:SetFrameLevel(2)
			panel:SetFrameStrata("MEDIUM")
			panel:SetBackdropBorderColor(unpack(C["media"].bordercolor))
			panel:SetAlpha(0)
			self.panel = panel
		end
		
		-- health bar
		local health = CreateFrame('StatusBar', nil, self)
		health:Height(17)
		health:SetPoint("TOPLEFT")
		health:SetPoint("TOPRIGHT")
		health:SetStatusBarTexture(normTex)
		
		-- Border for ToT
		local HealthBorder = CreateFrame("Frame", nil, health)
		HealthBorder:SetPoint("TOPLEFT", health, "TOPLEFT", T.Scale(-2), T.Scale(2))
		HealthBorder:SetPoint("BOTTOMRIGHT", health, "BOTTOMRIGHT", T.Scale(2), T.Scale(-2))
		HealthBorder:SetTemplate("Default")
		HealthBorder:CreateShadow("Default")
		HealthBorder:SetFrameLevel(2)
		self.HealthBorder = HealthBorder
		
		local healthBG = health:CreateTexture(nil, 'BORDER')
		healthBG:SetAllPoints()
		healthBG:SetTexture(0, 0, 0)
		
		self.Health = health
		self.Health.bg = healthBG
		
		health.frequentUpdates = true
		if C["unitframes"].showsmooth == true then
			health.Smooth = true
		end
		
		-- Unitframe Lines
		-- Creating an Invisible Line To Anchor Player and Target Frames Properly.
		local line1 = CreateFrame("Frame", "Tukuiline1", TukuiTargetTarget)
		Tukuiline1:CreatePanel(line1, 1, 1, "CENTER", health, "CENTER", 0, 0)
		line1:SetFrameLevel(0)
		line1:SetAlpha(0)
		
			
		-- power
		local power = CreateFrame('StatusBar', nil, self)
		power:Height(3)
		power:Point("TOPLEFT", health, "BOTTOMLEFT", 9, 1)
		power:Point("TOPRIGHT", health, "BOTTOMRIGHT", -9, -2)
		power:SetStatusBarTexture(normTex)
		power:SetFrameLevel(self.Health:GetFrameLevel() + 2)
		
		-- Border for Power
		local PowerBorder = CreateFrame("Frame", nil, power)
		PowerBorder:SetPoint("TOPLEFT", power, "TOPLEFT", T.Scale(-2), T.Scale(2))
		PowerBorder:SetPoint("BOTTOMRIGHT", power, "BOTTOMRIGHT", T.Scale(2), T.Scale(-2))
		PowerBorder:SetTemplate("Default")
		PowerBorder:CreateShadow("Default")
		PowerBorder:SetFrameLevel(power:GetFrameLevel() - 1)
		self.PowerBorder = PowerBorder
		
		power.frequentUpdates = true
		power.colorPower = true
		if C["unitframes"].showsmooth == true then
			power.Smooth = true
		end

		local powerBG = power:CreateTexture(nil, 'BORDER')
		powerBG:SetAllPoints(power)
		powerBG:SetTexture(normTex)
		powerBG.multiplier = 0.3
				
		self.Power = power
		self.Power.bg = powerBG

		if C["unitframes"].showsmooth == true then
			power.Smooth = true
		end
		
		if C["unitframes"].unicolor == true then
			health.colorDisconnected = false
			health.colorClass = false
			health:SetStatusBarColor(.150, .150, .150, 1)
			healthBG:SetVertexColor(0, 0, 0, 1)		
		else
			health.colorDisconnected = true
			health.colorClass = true
			health.colorReaction = true			
		end
		
		-- name and level
		local Name = health:CreateFontString(nil, "OVERLAY")
		self:Tag(Name, '[Tukui:getnamecolor][Tukui:nameshort] [Tukui:diffcolor][level] [shortclassification]')
		Name:SetPoint("CENTER", health, "CENTER", 2, 2)
		Name:SetJustifyH("CENTER")
		Name:SetFont(font, 10, "THINOUTLINE")
		Name:SetShadowColor(0, 0, 0)
		Name:SetShadowOffset(1.25, -1.25)
		self.Name = Name
		
		--[[
		-- portraits
		if (C["unitframes"].charportrait == true) then
			local portrait = CreateFrame("PlayerModel", nil, health)
			portrait.PostUpdate = function(self) self:SetAlpha(0) self:SetAlpha(0.15) end -- edit the 0.15 to the alpha you want
			portrait:SetAllPoints(health)
			table.insert(self.__elements, T.HidePortrait)
			self.Portrait = portrait
		end
		--]]
		
		if C["unitframes"].totdebuffs == true and T.lowversion ~= true then
			local debuffs = CreateFrame("Frame", nil, health)
			debuffs:SetHeight(20)
			debuffs:SetWidth(127)
			debuffs.size = 20
			debuffs.spacing = 2
			debuffs.num = 6

			debuffs:SetPoint("TOPLEFT", health, "TOPLEFT", -0.5, 24)
			debuffs.initialAnchor = "TOPLEFT"
			debuffs["growth-y"] = "UP"
			debuffs.PostCreateIcon = T.PostCreateAura
			debuffs.PostUpdateIcon = T.PostUpdateAura
			self.Debuffs = debuffs
		end
	end
	
	------------------------------------------------------------------------
	--	Pet unit layout
	------------------------------------------------------------------------
	
	if (unit == "pet") then
		-- create panel if higher version
		local panel = CreateFrame("Frame", nil, self)
		if not T.lowversion then
			panel:CreatePanel("Default", 129, 17, "BOTTOM", self, "BOTTOM", 0, 0)
			panel:SetFrameLevel(2)
			panel:SetFrameStrata("MEDIUM")
			panel:SetBackdropBorderColor(unpack(C["media"].bordercolor))
			panel:SetAlpha(0)
			self.panel = panel
		end
		
		-- health bar
		local health = CreateFrame('StatusBar', nil, self)
		if C["unitframes"].extendedpet == true then
			health:Height(17)
		else
			health:Height(16)
		end
		health:SetPoint("TOPLEFT")
		health:SetPoint("TOPRIGHT")
		health:SetStatusBarTexture(normTex)
		
		-- Border for Health
		local HealthBorder = CreateFrame("Frame", nil, health)
		HealthBorder:SetPoint("TOPLEFT", health, "TOPLEFT", T.Scale(-2), T.Scale(2))
		HealthBorder:SetPoint("BOTTOMRIGHT", health, "BOTTOMRIGHT", T.Scale(2), T.Scale(-2))
		HealthBorder:SetTemplate("Default")
		HealthBorder:CreateShadow("Default")
		HealthBorder:SetFrameLevel(2)
		self.HealthBorder = HealthBorder
		
		health.PostUpdate = T.PostUpdatePetColor
				
		self.Health = health
		self.Health.bg = healthBG
		
		local healthBG = health:CreateTexture(nil, 'BORDER')
		healthBG:SetAllPoints()
		healthBG:SetTexture(0, 0, 0)
		
		health.frequentUpdates = true
		if C["unitframes"].showsmooth == true then
			health.Smooth = true
		end
		
		if C["unitframes"].unicolor == true then
			health.colorDisconnected = false
			health.colorClass = false
			health:SetStatusBarColor(.150, .150, .150, 1)
			healthBG:SetVertexColor(0, 0, 0, 1)		
		else
			health.colorDisconnected = true	
			health.colorClass = true
			health.colorReaction = true	
			if T.myclass == "HUNTER" then
				health.colorHappiness = true
			end
		end
		
		-- power
		if C["unitframes"].extendedpet == true then
			local power = CreateFrame('StatusBar', nil, self)
			power:Height(3)
			power:Point("TOPLEFT", health, "BOTTOMLEFT", 7, 0)
			power:Point("TOPRIGHT", health, "BOTTOMRIGHT", -7, -1)
			power:SetStatusBarTexture(normTex)
			power:SetFrameLevel(self.Health:GetFrameLevel() + 2)

			power.frequentUpdates = true
			power.colorPower = true
			if C["unitframes"].showsmooth == true then
				power.Smooth = true
			end

			local powerBG = power:CreateTexture(nil, 'BORDER')
			powerBG:SetAllPoints(power)
			powerBG:SetTexture(normTex)
			powerBG.multiplier = 0.3
			
			-- Border for Power
			local PowerBorder = CreateFrame("Frame", nil, power)
			PowerBorder:SetPoint("TOPLEFT", power, "TOPLEFT", T.Scale(-2), T.Scale(2))
			PowerBorder:SetPoint("BOTTOMRIGHT", power, "BOTTOMRIGHT", T.Scale(2), T.Scale(-2))
			PowerBorder:SetTemplate("Default")
			PowerBorder:CreateShadow("Default")
			PowerBorder:SetFrameLevel(power:GetFrameLevel() - 1)
			self.PowerBorder = PowerBorder

			self.Power = power
			self.Power.bg = powerBG
		end
		
		-- Unit name
		local Name = health:CreateFontString(nil, "OVERLAY")
		Name:SetPoint("CENTER", self.Health, "CENTER", 1, 2)
		Name:SetFont(font, 10, "THINOUTLINE")
		Name:SetJustifyH("CENTER")
		Name:SetShadowOffset(1.25, -1.25)

		self:Tag(Name, '[Tukui:getnamecolor][Tukui:namemedium]')
		self.Name = Name
		
		--[[
		-- portraits
		if (C["unitframes"].charportrait == true) then
			local portrait = CreateFrame("PlayerModel", nil, health)
			portrait.PostUpdate = function(self) self:SetAlpha(0) self:SetAlpha(0.15) end -- edit the 0.15 to the alpha you want
			portrait:SetAllPoints(health)
			table.insert(self.__elements, T.HidePortrait)
			self.Portrait = portrait
		end
		--]]
		
		-- update pet name, this should fix "UNKNOWN" pet names on pet unit, health and bar color sometime being "grayish".
		self:RegisterEvent("UNIT_PET", T.updateAllElements)
	end



	------------------------------------------------------------------------
	--	Focus unit layout
	------------------------------------------------------------------------
	
	if (unit == "focus") then
		-- health 
		local health = CreateFrame('StatusBar', nil, self)
		health:Height(17)
		health:SetPoint("TOPLEFT")
		health:SetPoint("TOPRIGHT")
		health:SetStatusBarTexture(normTex)
		
		-- Border for Health
		local HealthBorder = CreateFrame("Frame", nil, health)
		HealthBorder:SetPoint("TOPLEFT", health, "TOPLEFT", T.Scale(-2), T.Scale(2))
		HealthBorder:SetPoint("BOTTOMRIGHT", health, "BOTTOMRIGHT", T.Scale(2), T.Scale(-2))
		HealthBorder:SetTemplate("Default")
		HealthBorder:CreateShadow("Default")
		HealthBorder:SetFrameLevel(2)
		self.HealthBorder = HealthBorder

		health.frequentUpdates = true
		health.colorDisconnected = true
		if C["unitframes"].showsmooth == true then
			health.Smooth = true
		end
		health.colorClass = true
		
		local healthBG = health:CreateTexture(nil, 'BORDER')
		healthBG:SetAllPoints()
		healthBG:SetTexture(0, 0, 0)

		health.value = T.SetFontString(health, font, 10, "OUTLINE")
		health.value:Point("LEFT", 2, 1)
		health.PostUpdate = T.PostUpdateHealth
				
		self.Health = health
		self.Health.bg = healthBG
		
		health.frequentUpdates = true
		if C["unitframes"].showsmooth == true then
			health.Smooth = true
		end
		
		if C["unitframes"].unicolor == true then
			health.colorDisconnected = false
			health.colorClass = false
			health:SetStatusBarColor(.150, .150, .150, 1)
			healthBG:SetVertexColor(0, 0, 0, 1)		
		else
			health.colorDisconnected = true
			health.colorClass = true
			health.colorReaction = true	
		end
	
		-- power
		local power = CreateFrame('StatusBar', nil, self)
		power:Height(3)
		power:Point("TOPLEFT", health, "BOTTOMLEFT", 85, 0)
		power:Point("TOPRIGHT", health, "BOTTOMRIGHT", -9, -3)
		power:SetStatusBarTexture(normTex)
		power:SetFrameLevel(self.Health:GetFrameLevel() + 2)
		
		-- Border for Power
		local PowerBorder = CreateFrame("Frame", nil, power)
		PowerBorder:SetPoint("TOPLEFT", power, "TOPLEFT", T.Scale(-2), T.Scale(2))
		PowerBorder:SetPoint("BOTTOMRIGHT", power, "BOTTOMRIGHT", T.Scale(2), T.Scale(-2))
		PowerBorder:SetTemplate("Default")
		PowerBorder:CreateShadow("Default")
		PowerBorder:SetFrameLevel(power:GetFrameLevel() - 1)
		self.PowerBorder = PowerBorder
		
		power.frequentUpdates = true
		power.colorPower = true
		if C["unitframes"].showsmooth == true then
			power.Smooth = true
		end

		local powerBG = power:CreateTexture(nil, 'BORDER')
		powerBG:SetAllPoints(power)
		powerBG:SetTexture(normTex)
		powerBG.multiplier = 0.3
		
		power.value = T.SetFontString(health, font, 10, "OUTLINE")
		power.value:Point("RIGHT", -2, 1)
		power.PreUpdate = T.PreUpdatePower
		power.PostUpdate = T.PostUpdatePower
				
		self.Power = power
		self.Power.bg = powerBG
		
		-- names
		local Name = health:CreateFontString(nil, "OVERLAY")
		Name:SetPoint("CENTER", health, "CENTER", 0, 0)
		Name:SetJustifyH("CENTER")
		Name:SetFont(font, 10, "THINOUTLINE")
		Name:SetShadowColor(0, 0, 0)
		Name:SetShadowOffset(1.25, -1.25)
		
		self:Tag(Name, '[Tukui:getnamecolor][Tukui:nameshort]')
		self.Name = Name
		
		-- create debuff for arena units
		local debuffs = CreateFrame("Frame", nil, self)
		debuffs:SetHeight(26)
		debuffs:SetWidth(200)
		debuffs:Point('LEFT', self, 'RIGHT', 4, 6)
		debuffs.size = 20
		debuffs.num = 8
		debuffs.spacing = 2
		debuffs.initialAnchor = 'LEFT'
		debuffs["growth-x"] = "RIGHT"
		debuffs.PostCreateIcon = T.PostCreateAura
		debuffs.PostUpdateIcon = T.PostUpdateAura
		self.Debuffs = debuffs
		
		local castbar = CreateFrame("StatusBar", self:GetName().."CastBar", self)
		castbar:SetPoint("LEFT", 0, 0)
		castbar:SetPoint("RIGHT", -23, 0)
		castbar:SetPoint("BOTTOM", 0, -20)
		
		castbar:SetHeight(16)
		castbar:SetStatusBarTexture(normTex)
		castbar:SetFrameLevel(6)
		
		castbar.bg = CreateFrame("Frame", nil, castbar)
		castbar.bg:SetTemplate("Default")
		castbar.bg:CreateShadow("Default")
		castbar.bg:SetBackdropBorderColor(unpack(C["media"].bordercolor))
		castbar.bg:Point("TOPLEFT", -2, 2)
		castbar.bg:Point("BOTTOMRIGHT", 2, -2)
		castbar.bg:SetFrameLevel(5)
		
		castbar.time = T.SetFontString(castbar,font, 10, "THINOUTLINE")
		castbar.time:Point("RIGHT", castbar, "RIGHT", -4, 0)
		castbar.time:SetTextColor(0, 4, 0)
		castbar.time:SetJustifyH("RIGHT")
		castbar.CustomTimeText = T.CustomCastTimeText

		castbar.Text = T.SetFontString(castbar,font, 10, "THINOUTLINE")
		castbar.Text:SetPoint("LEFT", castbar, "LEFT", 4, 0)
		castbar.Text:SetTextColor(0.3, 0.2, 1)
		castbar.Text:Width(100)
		castbar.Text:Height(12)
		
		castbar.CustomDelayText = T.CustomCastDelayText
		castbar.PostCastStart = T.CheckCast
		castbar.PostChannelStart = T.CheckChannel
								
		castbar.button = CreateFrame("Frame", nil, castbar)
		castbar.button:Height(castbar:GetHeight()+4)
		castbar.button:Width(castbar:GetHeight()+4)
		castbar.button:Point("LEFT", castbar, "RIGHT", 5, 0)
		castbar.button:SetTemplate("Default")
		castbar.button:CreateShadow("Default")
		castbar.button:SetBackdropBorderColor(unpack(C["media"].bordercolor))
		castbar.icon = castbar.button:CreateTexture(nil, "ARTWORK")
		castbar.icon:Point("TOPLEFT", castbar.button, 2, -2)
		castbar.icon:Point("BOTTOMRIGHT", castbar.button, -2, 2)
		castbar.icon:SetTexCoord(0.08, 0.92, 0.08, .92)

		self.Castbar = castbar
		self.Castbar.Time = castbar.time
		self.Castbar.Icon = castbar.icon
	end
	
	------------------------------------------------------------------------
	--	Focus target unit layout
	------------------------------------------------------------------------

	if (unit == "focustarget") then
		-- health 
		local health = CreateFrame('StatusBar', nil, self)
		health:Height(17)
		health:SetPoint("TOPLEFT")
		health:SetPoint("TOPRIGHT")
		health:SetStatusBarTexture(normTex)
		
		-- Border for Health
		local HealthBorder = CreateFrame("Frame", nil, health)
		HealthBorder:SetPoint("TOPLEFT", health, "TOPLEFT", T.Scale(-2), T.Scale(2))
		HealthBorder:SetPoint("BOTTOMRIGHT", health, "BOTTOMRIGHT", T.Scale(2), T.Scale(-2))
		HealthBorder:SetTemplate("Default")
		HealthBorder:CreateShadow("Default")
		HealthBorder:SetFrameLevel(2)
		self.HealthBorder = HealthBorder

		health.frequentUpdates = true
		health.colorDisconnected = true
		if C["unitframes"].showsmooth == true then
			health.Smooth = true
		end
		health.colorClass = true
		
		local healthBG = health:CreateTexture(nil, 'BORDER')
		healthBG:SetAllPoints()
		healthBG:SetTexture(0, 0, 0)

		health.value = T.SetFontString(health, font, 10, "OUTLINE")
		health.value:Point("LEFT", 2, 1)
		health.PostUpdate = T.PostUpdateHealth
				
		self.Health = health
		self.Health.bg = healthBG
		
		health.frequentUpdates = true
		if C["unitframes"].showsmooth == true then
			health.Smooth = true
		end
		
		if C["unitframes"].unicolor == true then
			health.colorDisconnected = false
			health.colorClass = false
			health:SetStatusBarColor(.150, .150, .150, 1)
			healthBG:SetVertexColor(0, 0, 0, 1)		
		else
			health.colorDisconnected = true
			health.colorClass = true
			health.colorReaction = true	
		end
	
		-- power
		local power = CreateFrame('StatusBar', nil, self)
		power:Height(3)
		power:Point("TOPLEFT", health, "BOTTOMLEFT", 85, 0)
		power:Point("TOPRIGHT", health, "BOTTOMRIGHT", -9, -3)
		power:SetStatusBarTexture(normTex)
		power:SetFrameLevel(self.Health:GetFrameLevel() + 2)
		
		-- Border for Power
		local PowerBorder = CreateFrame("Frame", nil, power)
		PowerBorder:SetPoint("TOPLEFT", power, "TOPLEFT", T.Scale(-2), T.Scale(2))
		PowerBorder:SetPoint("BOTTOMRIGHT", power, "BOTTOMRIGHT", T.Scale(2), T.Scale(-2))
		PowerBorder:SetTemplate("Default")
		PowerBorder:CreateShadow("Default")
		PowerBorder:SetFrameLevel(power:GetFrameLevel() - 1)
		self.PowerBorder = PowerBorder
		
		power.frequentUpdates = true
		power.colorPower = true
		if C["unitframes"].showsmooth == true then
			power.Smooth = true
		end

		local powerBG = power:CreateTexture(nil, 'BORDER')
		powerBG:SetAllPoints(power)
		powerBG:SetTexture(normTex)
		powerBG.multiplier = 0.3
		
		power.value = T.SetFontString(health, font, 10, "OUTLINE")
		power.value:Point("RIGHT", -2, 1)
		power.PreUpdate = T.PreUpdatePower
		power.PostUpdate = T.PostUpdatePower
				
		self.Power = power
		self.Power.bg = powerBG
		
		-- names
		local Name = health:CreateFontString(nil, "OVERLAY")
		Name:SetPoint("CENTER", health, "CENTER", 0, 1)
		Name:SetJustifyH("CENTER")
		Name:SetFont(font, 10, "THINOUTLINE")
		Name:SetShadowColor(0, 0, 0)
		Name:SetShadowOffset(1.25, -1.25)
		
		self:Tag(Name, '[Tukui:getnamecolor][Tukui:nameshort]')
		self.Name = Name
		
		-- create debuff for arena units
		local debuffs = CreateFrame("Frame", nil, self)
		debuffs:SetHeight(26)
		debuffs:SetWidth(200)
		debuffs:Point('RIGHT', self, 'LEFT', -4, 0)
		debuffs.size = 26
		debuffs.num = 0
		debuffs.spacing = 2
		debuffs.initialAnchor = 'RIGHT'
		debuffs["growth-x"] = "LEFT"
		debuffs.PostCreateIcon = T.PostCreateAura
		debuffs.PostUpdateIcon = T.PostUpdateAura
		self.Debuffs = debuffs
		
		local castbar = CreateFrame("StatusBar", self:GetName().."CastBar", self)
		castbar:SetPoint("LEFT", 0, 0)
		castbar:SetPoint("RIGHT", -23, 0)
		castbar:SetPoint("BOTTOM", 0, -20)
		
		castbar:SetHeight(16)
		castbar:SetStatusBarTexture(normTex)
		castbar:SetFrameLevel(6)
		
		castbar.bg = CreateFrame("Frame", nil, castbar)
		castbar.bg:SetTemplate("Default")
		castbar.bg:CreateShadow("Default")
		castbar.bg:SetBackdropBorderColor(unpack(C["media"].bordercolor))
		castbar.bg:Point("TOPLEFT", -2, 2)
		castbar.bg:Point("BOTTOMRIGHT", 2, -2)
		castbar.bg:SetFrameLevel(5)
		
		castbar.time = T.SetFontString(castbar,font, 10, "THINOUTLINE")
		castbar.time:Point("RIGHT", castbar, "RIGHT", -4, 0)
		castbar.time:SetTextColor(0, 4, 0)
		castbar.time:SetJustifyH("RIGHT")
		castbar.CustomTimeText = T.CustomCastTimeText

		castbar.Text = T.SetFontString(castbar,font, 10, "THINOUTLINE")
		castbar.Text:SetPoint("LEFT", castbar, "LEFT", 4, 0)
		castbar.Text:SetTextColor(0.3, 0.2, 1)
		castbar.Text:Width(100)
		castbar.Text:Height(12)
		
		castbar.CustomDelayText = T.CustomCastDelayText
		castbar.PostCastStart = T.CheckCast
		castbar.PostChannelStart = T.CheckChannel
								
		castbar.button = CreateFrame("Frame", nil, castbar)
		castbar.button:Height(castbar:GetHeight()+4)
		castbar.button:Width(castbar:GetHeight()+4)
		castbar.button:Point("LEFT", castbar, "RIGHT", 5, 0)
		castbar.button:SetTemplate("Default")
		castbar.button:CreateShadow("Default")
		castbar.button:SetBackdropBorderColor(unpack(C["media"].bordercolor))
		castbar.icon = castbar.button:CreateTexture(nil, "ARTWORK")
		castbar.icon:Point("TOPLEFT", castbar.button, 2, -2)
		castbar.icon:Point("BOTTOMRIGHT", castbar.button, -2, 2)
		castbar.icon:SetTexCoord(0.08, 0.92, 0.08, .92)

		self.Castbar = castbar
		self.Castbar.Time = castbar.time
		self.Castbar.Icon = castbar.icon
	end

	------------------------------------------------------------------------
	--	Arena or boss units layout (both mirror'd)
	------------------------------------------------------------------------
	
	if (unit and unit:find("arena%d") and C["arena"].unitframes == true) or (unit and unit:find("boss%d") and C["unitframes"].showboss == true) then
		-- Right-click focus on arena or boss units
		self:SetAttribute("type2", "focus")
		
		-- health 
		local health = CreateFrame('StatusBar', nil, self)
		health:Height(22)
		health:SetPoint("TOPLEFT")
		health:SetPoint("TOPRIGHT")
		health:SetStatusBarTexture(normTex)

		-- Border for Health
		local HealthBorder = CreateFrame("Frame", nil, health)
		HealthBorder:SetPoint("TOPLEFT", health, "TOPLEFT", T.Scale(-2), T.Scale(2))
		HealthBorder:SetPoint("BOTTOMRIGHT", health, "BOTTOMRIGHT", T.Scale(2), T.Scale(-2))
		HealthBorder:SetTemplate("Default")
		HealthBorder:CreateShadow("Default")
		HealthBorder:SetFrameLevel(2)
		self.HealthBorder = HealthBorder

		health.frequentUpdates = true
		health.colorDisconnected = true
		if C["unitframes"].showsmooth == true then
			health.Smooth = true
		end
		health.colorClass = true
		
		local healthBG = health:CreateTexture(nil, 'BORDER')
		healthBG:SetAllPoints()
		healthBG:SetTexture(0, 0, 0)

		health.value = T.SetFontString(health, font, 10, "THINOUTLINE")
		health.value:Point("LEFT", 2, 0.5)
		health.PostUpdate = T.PostUpdateHealth
				
		self.Health = health
		self.Health.bg = healthBG
		
		health.frequentUpdates = true
		if C["unitframes"].showsmooth == true then
			health.Smooth = true
		end
		
		if C["unitframes"].unicolor == true then
			health.colorDisconnected = false
			health.colorClass = false
			health:SetStatusBarColor(.150, .150, .150, 1)
			healthBG:SetVertexColor(0, 0, 0, 1)		
		else
			health.colorDisconnected = true
			health.colorClass = true
			health.colorReaction = true	
		end
	
		-- power
		local power = CreateFrame('StatusBar', nil, self)
		power:Height(3)
		power:Point("TOPLEFT", health, "BOTTOMLEFT", 85, 0)
		power:Point("TOPRIGHT", health, "BOTTOMRIGHT", -9, -3)
		power:SetStatusBarTexture(normTex)
		power:SetFrameLevel(self.Health:GetFrameLevel() + 2)
		
		-- Border for Power
		local PowerBorder = CreateFrame("Frame", nil, power)
		PowerBorder:SetPoint("TOPLEFT", power, "TOPLEFT", T.Scale(-2), T.Scale(2))
		PowerBorder:SetPoint("BOTTOMRIGHT", power, "BOTTOMRIGHT", T.Scale(2), T.Scale(-2))
		PowerBorder:SetTemplate("Default")
		PowerBorder:CreateShadow("Default")
		PowerBorder:SetFrameLevel(power:GetFrameLevel() - 1)
		self.PowerBorder = PowerBorder
		
		power.frequentUpdates = true
		power.colorPower = true
		if C["unitframes"].showsmooth == true then
			power.Smooth = true
		end

		local powerBG = power:CreateTexture(nil, 'BORDER')
		powerBG:SetAllPoints(power)
		powerBG:SetTexture(normTex)
		powerBG.multiplier = 0.3
		
		power.value = T.SetFontString(health, font, 10, "THINOUTLINE")
		power.value:Point("RIGHT", -2, 0.5)
		power.PreUpdate = T.PreUpdatePower
		power.PostUpdate = T.PostUpdatePower
				
		self.Power = power
		self.Power.bg = powerBG
		
		-- names
		local Name = health:CreateFontString(nil, "OVERLAY")
		Name:SetPoint("CENTER", health, "CENTER", 0, 1)
		Name:SetJustifyH("CENTER")
		Name:SetFont(font, 10, "THINOUTLINE")
		Name:SetShadowColor(0, 0, 0)
		Name:SetShadowOffset(1.25, -1.25)
		Name.frequentUpdates = 0.2
		
		self:Tag(Name, '[Tukui:getnamecolor][Tukui:namelong]')
		self.Name = Name
		
		if (unit and unit:find("boss%d")) then
			-- alt power bar
			local AltPowerBar = CreateFrame("StatusBar", nil, self.Health)
			AltPowerBar:SetFrameLevel(self.Health:GetFrameLevel() + 1)
			AltPowerBar:Height(4)
			AltPowerBar:SetStatusBarTexture(C.media.normTex)
			AltPowerBar:GetStatusBarTexture():SetHorizTile(false)
			AltPowerBar:SetStatusBarColor(1, 0, 0)

			AltPowerBar:SetPoint("LEFT")
			AltPowerBar:SetPoint("RIGHT")
			AltPowerBar:SetPoint("TOP", self.Health, "TOP")
			
			AltPowerBar:SetBackdrop(backdrop)
			AltPowerBar:SetBackdropColor(0, 0, 0)

			self.AltPowerBar = AltPowerBar
			
			-- create buff at left of unit if they are boss units
			local buffs = CreateFrame("Frame", nil, self)
			buffs:SetHeight(26)
			buffs:SetWidth(252)
			buffs:Point("TOPRIGHT", self, "TOPLEFT", -5, 2)
			buffs.size = 26
			buffs.num = 3
			buffs.spacing = 3
			buffs.initialAnchor = 'RIGHT'
			buffs["growth-x"] = "LEFT"
			buffs.PostCreateIcon = T.PostCreateAura
			buffs.PostUpdateIcon = T.PostUpdateAura
			self.Buffs = buffs
			
			-- because it appear that sometime elements are not correct.
			self:HookScript("OnShow", T.updateAllElements)
		end

		-- create debuff for arena units
		local debuffs = CreateFrame("Frame", nil, self)
		debuffs:SetHeight(26)
		debuffs:SetWidth(200)
		debuffs:SetPoint('TOPLEFT', self, 'TOPRIGHT', T.Scale(5), 2)
		debuffs.size = 26
		debuffs.num = 0
		debuffs.spacing = 3
		debuffs.initialAnchor = 'LEFT'
		debuffs["growth-x"] = "RIGHT"
		debuffs.PostCreateIcon = T.PostCreateAura
		debuffs.PostUpdateIcon = T.PostUpdateAura
		self.Debuffs = debuffs
				
		-- trinket feature via trinket plugin
		if (C.arena.unitframes) and (unit and unit:find('arena%d')) then
			local Trinketbg = CreateFrame("Frame", nil, self)
			Trinketbg:SetHeight(26)
			Trinketbg:SetWidth(26)
			Trinketbg:SetPoint("TOPRIGHT", self, "TOPLEFT", -5, 2)				
			Trinketbg:SetTemplate("Default")
			Trinketbg:CreateShadow("Default")
			Trinketbg:SetFrameLevel(0)
			self.Trinketbg = Trinketbg
			
			local Trinket = CreateFrame("Frame", nil, Trinketbg)
			Trinket:SetAllPoints(Trinketbg)
			Trinket:SetPoint("TOPLEFT", Trinketbg, T.Scale(2), T.Scale(-2))
			Trinket:SetPoint("BOTTOMRIGHT", Trinketbg, T.Scale(-2), T.Scale(2))
			Trinket:SetFrameLevel(1)
			Trinket.trinketUseAnnounce = true
			self.Trinket = Trinket
		end
		
		-- boss & arena frames cast bar!
		local castbar = CreateFrame("StatusBar", self:GetName().."CastBar", self)
		castbar:SetPoint("LEFT", 23, -1)
		castbar:SetPoint("RIGHT", 0, -1)
		castbar:SetPoint("BOTTOM", 0, -21)

		castbar:SetHeight(16)
		castbar:SetStatusBarTexture(normTex)
		castbar:SetFrameLevel(6)
		
		castbar.bg = CreateFrame("Frame", nil, castbar)
		castbar.bg:SetTemplate("Default")
		castbar.bg:CreateShadow("Default")
		castbar.bg:SetBackdropBorderColor(unpack(C["media"].bordercolor))
		castbar.bg:Point("TOPLEFT", -2, 2)
		castbar.bg:Point("BOTTOMRIGHT", 2, -2)
		castbar.bg:SetFrameLevel(5)
		
		castbar.time = T.SetFontString(castbar,font, 10, "THINOUTLINE")
		castbar.time:Point("RIGHT", castbar, "RIGHT", -4, 0)
		castbar.time:SetTextColor(0, 4, 0)
		castbar.time:SetJustifyH("RIGHT")
		castbar.CustomTimeText = T.CustomCastTimeText

		castbar.Text = T.SetFontString(castbar,font, 10, "THINOUTLINE")
		castbar.Text:Point("LEFT", castbar, "LEFT", 4, 0)
		castbar.Text:SetTextColor(0.3, 0.2, 1)
		castbar.Text:Width(100)
		castbar.Text:Height(10)
		
		castbar.CustomDelayText = T.CustomCastDelayText
		castbar.PostCastStart = T.CheckCast
		castbar.PostChannelStart = T.CheckChannel
								
		castbar.button = CreateFrame("Frame", nil, castbar)
		castbar.button:Height(castbar:GetHeight()+4)
		castbar.button:Width(castbar:GetHeight()+4)
		castbar.button:Point("RIGHT", castbar, "LEFT",-5, 0)
		castbar.button:SetTemplate("Default")
		castbar.button:CreateShadow("Default")
		castbar.button:SetBackdropBorderColor(unpack(C["media"].bordercolor))
		castbar.icon = castbar.button:CreateTexture(nil, "ARTWORK")
		castbar.icon:Point("TOPLEFT", castbar.button, T.Scale(2), T.Scale(-2))
		castbar.icon:Point("BOTTOMRIGHT", castbar.button, -2, 2)
		castbar.icon:SetTexCoord(0.08, 0.92, 0.08, .92)

		self.Castbar = castbar
		self.Castbar.Time = castbar.time
		self.Castbar.Icon = castbar.icon
	end


	------------------------------------------------------------------------
	--	Main tanks and Main Assists layout (both mirror'd)
	------------------------------------------------------------------------
	
	if(self:GetParent():GetName():match"TukuiMainTank" or self:GetParent():GetName():match"TukuiMainAssist") then
		-- Right-click focus on maintank or mainassist units
		self:SetAttribute("type2", "focus")
		
		-- health 
		local health = CreateFrame('StatusBar', nil, self)
		health:Height(20)
		health:SetPoint("TOPLEFT")
		health:SetPoint("TOPRIGHT")
		health:SetStatusBarTexture(normTex)
		
		local healthBG = health:CreateTexture(nil, 'BORDER')
		healthBG:SetAllPoints()
		healthBG:SetTexture(0, 0, 0)
				
		-- Border for HealthBar
		local HealthBorder = CreateFrame("Frame", nil, health)
		HealthBorder:SetPoint("TOPLEFT", health, "TOPLEFT", T.Scale(-2), T.Scale(2))
		HealthBorder:SetPoint("BOTTOMRIGHT", health, "BOTTOMRIGHT", T.Scale(2), T.Scale(-2))
		HealthBorder:SetTemplate("Default")
		HealthBorder:CreateShadow("Default")
		HealthBorder:SetFrameLevel(2)
		self.HealthBorder = HealthBorder
				
		self.Health = health
		self.Health.bg = healthBG
		
		health.frequentUpdates = true
		if C["unitframes"].showsmooth == true then
			health.Smooth = true
		end
		
		if C["unitframes"].unicolor == true then
			health.colorDisconnected = false
			health.colorClass = false
			health:SetStatusBarColor(.150, .150, .150, 1)
			healthBG:SetVertexColor(0, 0, 0, 1)
		else
			health.colorDisconnected = true
			health.colorClass = true
			health.colorReaction = true	
		end
		
		-- names
		local Name = health:CreateFontString(nil, "OVERLAY")
		Name:SetPoint("CENTER", health, "CENTER", 0, 1)
		Name:SetJustifyH("CENTER")
		Name:SetFont(font, 10, "THINOUTLINE")
		Name:SetShadowColor(0, 0, 0)
		Name:SetShadowOffset(1.25, -1.25)
		
		self:Tag(Name, '[Tukui:getnamecolor][Tukui:nameshort]')
		self.Name = Name
	end
	
	return self
end


------------------------------------------------------------------------
--	Default position of Tukui unitframes
------------------------------------------------------------------------

if C["unitframes"].totdebuffs then totdebuffs = 24 end

oUF:RegisterStyle('Tukui', Shared)

-- player
local player = oUF:Spawn('player', "TukuiPlayer")
player:SetPoint("BOTTOMRIGHT", InvTukuiActionBarBackground, "BOTTOM", -134,175)
player:Size(246, 44)

-- target
local target = oUF:Spawn('target', "TukuiTarget")
target:SetPoint("BOTTOMLEFT", InvTukuiActionBarBackground, "BOTTOM", 134,175)
target:Size(246, 44)

-- tot
local tot = oUF:Spawn('targettarget', "TukuiTargetTarget")
if T.lowversion then
	tot:SetPoint("RIGHT", target, "LEFT", -69, 10)
	tot:Size(186, 18)
else
	tot:SetPoint("RIGHT", target, "LEFT", -69, 10)
	tot:Size(129, 36)
end

-- pet
local pet = oUF:Spawn('pet', "TukuiPet")
	pet:SetPoint("LEFT", player, "RIGHT", 70, -20)
	pet:Size(129, 36)

-- focus
local focus = oUF:Spawn('focus', "TukuiFocus")
focus:SetPoint("BOTTOMLEFT", InvTukuiActionBarBackground, "BOTTOM", 200, 400)
focus:Size(180, 28)

-- focus target
if C.unitframes.showfocustarget then
	local focustarget = oUF:Spawn("focustarget", "TukuiFocusTarget")
	focustarget:SetPoint("BOTTOM", focus, "TOP", 0, 40)
	focustarget:Size(180, 28)
end

if C.arena.unitframes then
	local arena = {}
	for i = 1, 5 do
		arena[i] = oUF:Spawn("arena"..i, "TukuiArena"..i)
		if i == 1 then
			arena[i]:SetPoint("BOTTOMLEFT", InvTukuiActionBarBackground, "BOTTOM", 700, 250)
		else
			arena[i]:SetPoint("BOTTOM", arena[i-1], "TOP", 0, 35)
		end
		arena[i]:Size(200, 27)
	end	
end


if C["unitframes"].showboss then
	for i = 1,MAX_BOSS_FRAMES do
		local t_boss = _G["Boss"..i.."TargetFrame"]
		t_boss:UnregisterAllEvents()
		t_boss.Show = T.dummy
		t_boss:Hide()
		_G["Boss"..i.."TargetFrame".."HealthBar"]:UnregisterAllEvents()
		_G["Boss"..i.."TargetFrame".."ManaBar"]:UnregisterAllEvents()
	end	
end

	local boss = {}
	for i = 1, MAX_BOSS_FRAMES do
		boss[i] = oUF:Spawn("boss"..i, "TukuiBoss"..i)
		if i == 1 then
			boss[i]:SetPoint("BOTTOMLEFT", InvTukuiActionBarBackground, "BOTTOM", 700, 250)
		else
			boss[i]:SetPoint('BOTTOM', boss[i-1], 'TOP', 0, 35)             
		end
		boss[i]:Size(200, 27)	
end

local assisttank_width = 100
local assisttank_height  = 20
if C["unitframes"].maintank == true then
	local tank = oUF:SpawnHeader('TukuiMainTank', nil, 'raid',
		'oUF-initialConfigFunction', ([[
			self:SetWidth(%d)
			self:SetHeight(%d)
		]]):format(assisttank_width, assisttank_height),
		'showRaid', true,
		'groupFilter', 'MAINTANK',
		'yOffset', 7,
		'point' , 'BOTTOM',
		'template', 'oUF_TukuiMtt'
	)
	tank:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
end
 
if C["unitframes"].mainassist == true then
	local assist = oUF:SpawnHeader("TukuiMainAssist", nil, 'raid',
		'oUF-initialConfigFunction', ([[
			self:SetWidth(%d)
			self:SetHeight(%d)
		]]):format(assisttank_width, assisttank_height),
		'showRaid', true,
		'groupFilter', 'MAINASSIST',
		'yOffset', 7,
		'point' , 'BOTTOM',
		'template', 'oUF_TukuiMtt'
	)
	if C["unitframes"].maintank == true then
		assist:SetPoint("TOPLEFT", TukuiMainTank, "BOTTOMLEFT", 2, -50)
	else
		assist:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
	end
end

-- this is just a fake party to hide Blizzard frame if no Tukui raid layout are loaded.
local party = oUF:SpawnHeader("oUF_noParty", nil, "party", "showParty", true)

------------------------------------------------------------------------
-- Right-Click on unit frames menu. 
-- Doing this to remove SET_FOCUS eveywhere.
-- SET_FOCUS work only on default unitframes.
-- Main Tank and Main Assist, use /maintank and /mainassist commands.
------------------------------------------------------------------------

do
	UnitPopupMenus["SELF"] = { "PVP_FLAG", "LOOT_METHOD", "LOOT_THRESHOLD", "OPT_OUT_LOOT_TITLE", "LOOT_PROMOTE", "DUNGEON_DIFFICULTY", "RAID_DIFFICULTY", "RESET_INSTANCES", "RAID_TARGET_ICON", "SELECT_ROLE", "CONVERT_TO_PARTY", "CONVERT_TO_RAID", "LEAVE", "CANCEL" };
	UnitPopupMenus["PET"] = { "PET_PAPERDOLL", "PET_RENAME", "PET_ABANDON", "PET_DISMISS", "CANCEL" };
	UnitPopupMenus["PARTY"] = { "MUTE", "UNMUTE", "PARTY_SILENCE", "PARTY_UNSILENCE", "RAID_SILENCE", "RAID_UNSILENCE", "BATTLEGROUND_SILENCE", "BATTLEGROUND_UNSILENCE", "WHISPER", "PROMOTE", "PROMOTE_GUIDE", "LOOT_PROMOTE", "VOTE_TO_KICK", "UNINVITE", "INSPECT", "ACHIEVEMENTS", "TRADE", "FOLLOW", "DUEL", "RAID_TARGET_ICON", "SELECT_ROLE", "PVP_REPORT_AFK", "RAF_SUMMON", "RAF_GRANT_LEVEL", "CANCEL" }
	UnitPopupMenus["PLAYER"] = { "WHISPER", "INSPECT", "INVITE", "ACHIEVEMENTS", "TRADE", "FOLLOW", "DUEL", "RAID_TARGET_ICON", "RAF_SUMMON", "RAF_GRANT_LEVEL", "CANCEL" }
	UnitPopupMenus["RAID_PLAYER"] = { "MUTE", "UNMUTE", "RAID_SILENCE", "RAID_UNSILENCE", "BATTLEGROUND_SILENCE", "BATTLEGROUND_UNSILENCE", "WHISPER", "INSPECT", "ACHIEVEMENTS", "TRADE", "FOLLOW", "DUEL", "RAID_TARGET_ICON", "SELECT_ROLE", "RAID_LEADER", "RAID_PROMOTE", "RAID_DEMOTE", "LOOT_PROMOTE", "RAID_REMOVE", "PVP_REPORT_AFK", "RAF_SUMMON", "RAF_GRANT_LEVEL", "CANCEL" };
	UnitPopupMenus["RAID"] = { "MUTE", "UNMUTE", "RAID_SILENCE", "RAID_UNSILENCE", "BATTLEGROUND_SILENCE", "BATTLEGROUND_UNSILENCE", "RAID_LEADER", "RAID_PROMOTE", "RAID_MAINTANK", "RAID_MAINASSIST", "RAID_TARGET_ICON", "LOOT_PROMOTE", "RAID_DEMOTE", "RAID_REMOVE", "PVP_REPORT_AFK", "CANCEL" };
	UnitPopupMenus["VEHICLE"] = { "RAID_TARGET_ICON", "VEHICLE_LEAVE", "CANCEL" }
	UnitPopupMenus["TARGET"] = { "RAID_TARGET_ICON", "CANCEL" }
	UnitPopupMenus["ARENAENEMY"] = { "CANCEL" }
	UnitPopupMenus["FOCUS"] = { "RAID_TARGET_ICON", "CANCEL" }
	UnitPopupMenus["BOSS"] = { "RAID_TARGET_ICON", "CANCEL" }
end