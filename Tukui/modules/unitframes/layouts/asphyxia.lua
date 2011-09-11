local ADDON_NAME, ns = ...
local oUF = ns.oUF or oUF
assert(oUF, "Tukui was unable to locate oUF install.")

ns._Objects = {}
ns._Headers = {}

local T, C, L = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales
if not C["unitframes"].enable == true then return end
if C["unitframes"].style ~= "Asphyxia" then return end

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
			panel:CreatePanel("Default", 186, 21, "BOTTOM", self, "BOTTOM", 0, 0)
		else
			panel:CreatePanel("Default", 186, 21, "BOTTOM", self, "BOTTOM", 0, 0)
		end
		panel:SetFrameLevel(2)
		panel:SetFrameStrata("MEDIUM")
		panel:SetBackdropBorderColor(unpack(C["media"].altbordercolor))
		panel:SetAlpha(0)
		self.panel = panel
	
		-- health bar
		local health = CreateFrame('StatusBar', nil, self)
		health:Height(26)
		health:SetPoint("TOPLEFT")
		health:SetPoint("TOPRIGHT")
		health:SetStatusBarTexture(normTex)

		-- Border for HealthBar
		local HealthBorder = CreateFrame("Frame", nil, health)
		HealthBorder:SetPoint("TOPLEFT", health, "TOPLEFT", -2, 2)
		HealthBorder:SetPoint("BOTTOMRIGHT", health, "BOTTOMRIGHT", 2, -2)
		HealthBorder:SetTemplate("Default")
		HealthBorder:CreateShadow("Default")
		HealthBorder:SetFrameLevel(2)
		self.HealthBorder = HealthBorder

		-- health bar background
		local healthBG = health:CreateTexture(nil, 'BORDER')
		healthBG:SetAllPoints()
		healthBG:SetTexture(0, 0, 0)

		health.value = T.SetFontString(health, font, C["datatext"].fontsize, "MONOCHROMEOUTLINE")
		health.value:Point("RIGHT", health, "RIGHT", -4, 0)
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
			health:SetStatusBarColor(.150, .150, .150, 1)
			healthBG:SetVertexColor(0, 0, 0, 1)		
		else
			health.colorDisconnected = true
			health.colorTapping = true	
			health.colorClass = true
			health.colorReaction = true			
		end

		-- power
		local power = CreateFrame('StatusBar', nil, self)
		power:Size(230, 2)
		if unit == "player" then
			power:Point("TOPRIGHT", health, "BOTTOMRIGHT", 0, -7)
		elseif unit == "target" then
			power:Point("TOPLEFT", health, "BOTTOMLEFT", 0, -7)
		end
		power:SetStatusBarTexture(normTex)

		-- Border for Power
		local PowerBorder = CreateFrame("Frame", nil, power)
		PowerBorder:SetPoint("TOPLEFT", power, "TOPLEFT", -2, 2)
		PowerBorder:SetPoint("BOTTOMRIGHT", power, "BOTTOMRIGHT", 2, -2)
		PowerBorder:SetTemplate("Default")
		PowerBorder:CreateShadow("Default")
		PowerBorder:SetFrameLevel(power:GetFrameLevel() - 1)
		self.PowerBorder = PowerBorder

		local powerBG = power:CreateTexture(nil, 'BORDER')
		powerBG:SetAllPoints(power)
		powerBG:SetTexture(normTex)
		powerBG.multiplier = 0.3

		power.value = T.SetFontString(health, font, C["datatext"].fontsize, "MONOCHROMEOUTLINE")
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
			power.colorReaction = true
			powerBG.multiplier = 0.1				
		else
			power.colorPower = true
		end

		-- portraits
		if (C["unitframes"].charportrait == true) then
			local portrait = CreateFrame("PlayerModel", nil, health)
			portrait:SetFrameLevel(health:GetFrameLevel())
			portrait:SetAllPoints(health)
			portrait:SetAlpha(.15)
			portrait.PostUpdate = T.PortraitUpdate 
			self.Portrait = portrait
		end
		
		if (C["unitframes"].classicon == true) then
		local classicon = CreateFrame("Frame", self:GetName().."_ClassIconBorder", self)
		classicon:CreateShadow("Default")
		if unit == "player" then
				classicon:CreatePanel("Default", 30, 30, "TOPRIGHT", health, "TOPLEFT", -5,2)
		elseif unit == "target" then
				classicon:CreatePanel("Default", 30, 30, "TOPLEFT", health, "TOPRIGHT", 5,2)
		end

		local class = classicon:CreateTexture(self:GetName().."_ClassIcon", "ARTWORK")
		class:Point("TOPLEFT", 2, -2)
		class:Point("BOTTOMRIGHT", -2, 2)
		self.ClassIcon = class
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

		if (unit == "player") then
			-- combat icon
			local Combat = health:CreateTexture(nil, "OVERLAY")
			Combat:Height(19)
			Combat:Width(19)
			Combat:SetPoint("CENTER",0,0)
			Combat:SetVertexColor(0.69, 0.31, 0.31)
			self.Combat = Combat

			-- custom info (low mana warning)
			FlashInfo = CreateFrame("Frame", "TukuiFlashInfo", self)
			FlashInfo:SetScript("OnUpdate", T.UpdateManaLevel)
			FlashInfo.parent = self
			FlashInfo:SetAllPoints(health)
			FlashInfo.ManaLevel = T.SetFontString(FlashInfo, font, C["datatext"].fontsize+1, "MONOCHROMEOUTLINE")
			FlashInfo.ManaLevel:SetPoint("CENTER", health, "CENTER", 0, 1)
			self.FlashInfo = FlashInfo

			-- pvp status icon
			local PVP = health:CreateTexture(nil, "OVERLAY")
			PVP:SetHeight(32)
			PVP:SetWidth(32)
			PVP:SetPoint("CENTER", 5, -6)
			self.PvP = PVP
			if(UnitIsPVP(unit) and factionGroup) then
				if(factionGroup == 'Horde') then
					pvp:SetTexture([[Interface\AddOns\Tukui\medias\textures\Horde]])
				else
					pvp:SetTexture([[Interface\AddOns\Tukui\medias\textures\Alliance]])
				end
			end
			
			-- leader icon
			local Leader = InvFrame:CreateTexture(nil, "OVERLAY")
			Leader:Height(14)
			Leader:Width(14)
			Leader:Point("TOPLEFT", -9, 9)
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
				Experience:Size(TukuiChatBackgroundLeft:GetWidth() - 4, 2)
				Experience:Point("BOTTOM", TukuiChatBackgroundLeft, "TOP", 0, 5)
				Experience:SetFrameLevel(8)
				Experience:SetFrameStrata("HIGH")
				Experience.Tooltip = true
				self.Experience = Experience
				
				local ExperienceBG = Experience:CreateTexture(nil, 'BORDER')
				ExperienceBG:SetAllPoints()
				ExperienceBG:SetTexture(normTex)
				ExperienceBG:SetVertexColor(0,0,0)

				Experience.Text = self.Experience:CreateFontString(nil, 'OVERLAY')
				Experience.Text:SetFont(font, C["datatext"].fontsize, "MONOCHROMEOUTLINE")
				Experience.Text:SetPoint('CENTER', 0, 1)
				Experience.Text:SetShadowOffset(T.mult, -T.mult)
				self.Experience.Text = Experience.Text
				self.Experience.PostUpdate = T.ExperienceText

				self.Experience.Rested = CreateFrame('StatusBar', nil, self.Experience)
				self.Experience.Rested:SetAllPoints(self.Experience)
				self.Experience.Rested:SetStatusBarTexture(normTex)
				self.Experience.Rested:SetStatusBarColor(1, 0, 1, 0.2)		
				
				local Resting = self:CreateTexture(nil, "OVERLAY")
				Resting:SetHeight(28)
				Resting:SetWidth(28)
				Resting:SetPoint("BOTTOMRIGHT", self, "TOPLEFT", 10 -4)
				Resting:SetTexture([=[Interface\CharacterFrame\UI-StateIcon]=])
				Resting:SetTexCoord(0, 0.5, 0, 0.421875)
				self.Resting = Resting

				local ExperienceFrame = CreateFrame("Frame", nil, self.Experience)
				ExperienceFrame:SetPoint("TOPLEFT", T.Scale(-2), T.Scale(2))
				ExperienceFrame:SetPoint("BOTTOMRIGHT", T.Scale(2), T.Scale(-2))
				ExperienceFrame:SetTemplate("Transparent")
				ExperienceFrame:CreateShadow("Default")
				ExperienceFrame:SetFrameLevel(self.Experience:GetFrameLevel() - 1)
			
			local function ModifiedBackdrop(self)
				local color = RAID_CLASS_COLORS[T.myclass]
				self:SetBackdropColor(unpack(C["media"].backdropcolor))
				self:SetBackdropBorderColor(color.r, color.g, color.b)
			end

			local function OriginalBackdrop(self)
				self:SetBackdropColor(unpack(C["media"].backdropcolor))
				self:SetBackdropBorderColor(unpack(C["media"].bordercolor))
			end
		end
		
			-- reputation bar for max level character
			if T.level == MAX_PLAYER_LEVEL then
				local Reputation = CreateFrame("StatusBar", self:GetName().."_Reputation", self)
				Reputation:SetStatusBarTexture(normTex)
				Reputation:Size(TukuiChatBackgroundLeft:GetWidth() - 4, 2)
				Reputation:Point("BOTTOM", TukuiChatBackgroundLeft, "TOP", 0, 5)
				Reputation:SetFrameLevel(10)
				local ReputationBG = Reputation:CreateTexture(nil, 'BORDER')
				ReputationBG:SetAllPoints()
				ReputationBG:SetTexture(normTex)
				ReputationBG:SetVertexColor(0,0,0)

				Reputation.Text = Reputation:CreateFontString(nil, 'OVERLAY')
				Reputation.Text:SetFont(font, C["datatext"].fontsize, "MONOCHROMEOUTLINE")
				Reputation.Text:SetPoint('CENTER', 0, 1)
				Reputation.Text:SetShadowOffset(T.mult, -T.mult)
				Reputation.Text:Show()
				Reputation.PostUpdate = T.UpdateReputation
				Reputation.Text = Reputation.Text

				Reputation.PostUpdate = T.UpdateReputationColor
				Reputation.Tooltip = true
				self.Reputation = Reputation

				local ReputationFrame = CreateFrame("Frame", nil, self.Reputation)
				ReputationFrame:SetPoint("TOPLEFT", T.Scale(-2), T.Scale(2))
				ReputationFrame:SetPoint("BOTTOMRIGHT", T.Scale(2), T.Scale(-2))
				ReputationFrame:SetTemplate("Transparent")
				ReputationFrame:CreateShadow("Default")
				ReputationFrame:SetFrameLevel(self.Reputation:GetFrameLevel() - 1)
				
			local function ModifiedBackdrop(self)
				local color = RAID_CLASS_COLORS[T.myclass]
				self:SetBackdropColor(unpack(C["media"].backdropcolor))
				self:SetBackdropBorderColor(color.r, color.g, color.b)
			end

			local function OriginalBackdrop(self)
				self:SetBackdropColor(unpack(C["media"].backdropcolor))
				self:SetBackdropBorderColor(unpack(C["media"].bordercolor))
			end
		end	
			
			-- show druid mana when shapeshifted in bear, cat or whatever
			if T.myclass == "DRUID" then
				CreateFrame("Frame"):SetScript("OnUpdate", function() T.UpdateDruidMana(self) end)
				local DruidMana = T.SetFontString(health, font1, 12)
				DruidMana:SetTextColor(1, 0.49, 0.04)
				self.DruidManaText = DruidMana
			end

			if C["unitframes"].classbar then
				if T.myclass == "DRUID" then
					-- DRUID MANA BAR
					local DruidManaBackground = CreateFrame("Frame", nil, self)
					DruidManaBackground:Point("BOTTOMLEFT", self, "TOPLEFT", 0, 7)
					DruidManaBackground:Size(230, 2)
					DruidManaBackground:SetFrameLevel(8)
					DruidManaBackground:SetFrameStrata("MEDIUM")
					DruidManaBackground:SetTemplate("Default")
					DruidManaBackground:SetBackdropBorderColor(0,0,0,0)
				
					local DruidManaBarStatus = CreateFrame('StatusBar', nil, DruidManaBackground)
					DruidManaBarStatus:SetPoint('LEFT', DruidManaBackground, 'LEFT', 0, 0)
					DruidManaBarStatus:SetSize(DruidManaBackground:GetWidth(), DruidManaBackground:GetHeight())
					DruidManaBarStatus:SetStatusBarTexture(normTex)
					DruidManaBarStatus:SetStatusBarColor(.30, .52, .90)
					
					DruidManaBarStatus:SetScript("OnShow", function() T.DruidBarDisplay(self, false) end)
					DruidManaBarStatus:SetScript("OnUpdate", function() T.DruidBarDisplay(self, true) end) -- just forcing 1 update on login for buffs/shadow/etc.
					DruidManaBarStatus:SetScript("OnHide", function() T.DruidBarDisplay(self, false) end)
					
					self.DruidManaBackground = DruidManaBackground
					self.DruidMana = DruidManaBarStatus
					
					DruidManaBackground.FrameBackdrop = CreateFrame( "Frame", nil, DruidManaBackground )
					DruidManaBackground.FrameBackdrop:SetTemplate( "Default" )
					DruidManaBackground.FrameBackdrop:SetPoint( "TOPLEFT", -2, 2 )
					DruidManaBackground.FrameBackdrop:SetPoint( "BOTTOMRIGHT", 2, -2 )
					DruidManaBackground.FrameBackdrop:SetFrameLevel( DruidManaBackground:GetFrameLevel() - 1 )

					local eclipseBar = CreateFrame('Frame', nil, self)
					eclipseBar:Point("LEFT", health, "TOPLEFT", 0, 8)
					eclipseBar:Size(230, 2)
					eclipseBar:SetFrameStrata("MEDIUM")
					eclipseBar:SetFrameLevel(8)
					eclipseBar:SetBackdropBorderColor(0,0,0,0)
					eclipseBar:SetScript("OnShow", function() T.DruidBarDisplay(self, false) end)
					eclipseBar:SetScript("OnHide", function() T.DruidBarDisplay(self, false) end)

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
					eclipseBarText:SetFont(font, C["datatext"].fontsize, "MONOCHROMEOUTLINE")
					eclipseBarText:SetShadowOffset(T.mult, -T.mult)
					eclipseBarText:SetShadowColor(0, 0, 0, 0.4)
					eclipseBar.PostUpdatePower = T.EclipseDirection

					-- hide "low mana" text on load if eclipseBar is shown
					if eclipseBar and eclipseBar:IsShown() then FlashInfo.ManaLevel:SetAlpha(0) end

					self.EclipseBar = eclipseBar
					self.EclipseBar.Text = eclipseBarText

					eclipseBar.FrameBackdrop = CreateFrame("Frame", nil, eclipseBar)
					eclipseBar.FrameBackdrop:SetTemplate("Default")
					eclipseBar.FrameBackdrop:CreateShadow("Default")
					eclipseBar.FrameBackdrop:SetPoint("TOPLEFT", -2, 2)
					eclipseBar.FrameBackdrop:SetPoint("BOTTOMRIGHT", 2, -2)
					eclipseBar.FrameBackdrop:SetFrameLevel(eclipseBar:GetFrameLevel() - 1)
				end

				-- set holy power bar or shard bar
				if (T.myclass == "WARLOCK" or T.myclass == "PALADIN") then

					local bars = CreateFrame("Frame", nil, self)
					bars:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 0, 7)
					bars:Size(230, 2)
					bars:SetBackdropBorderColor(0,0,0,0)

					for i = 1, 3 do					
						bars[i]=CreateFrame("StatusBar", self:GetName().."_Shard"..i, bars)
						bars[i]:Height(2)					
						bars[i]:SetStatusBarTexture(normTex)
						bars[i]:GetStatusBarTexture():SetHorizTile(false)

						bars[i].bg = bars[i]:CreateTexture(nil, 'BORDER')

						if T.myclass == "WARLOCK" then
							bars[i]:SetStatusBarColor(148/255, 130/255, 201/255)
							bars[i].bg:SetTexture(148/255, 130/255, 201/255)
						elseif T.myclass == "PALADIN" then
							bars[i]:SetStatusBarColor(228/255,225/255,16/255)
							bars[i].bg:SetTexture(228/255,225/255,16/255)
						end

						if i == 1 then
							bars[i]:SetPoint("LEFT", bars)
							bars[i]:Width(229/3) -- setting SetWidth here just to fit fit 250 perfectly
							bars[i].bg:SetAllPoints(bars[i])
						else
							bars[i]:Point("LEFT", bars[i-1], "RIGHT", 1, 0)
							bars[i]:Width(229/3) -- setting SetWidth here just to fit fit 250 perfectly
							bars[i].bg:SetAllPoints(bars[i])
						end
						
						bars[i].bg:SetTexture(normTex)					
						bars[i].bg:SetAlpha(.15)
					end

					if T.myclass == "WARLOCK" then
						bars.Override = T.UpdateShards				
						self.SoulShards = bars
					elseif T.myclass == "PALADIN" then
						bars.Override = T.UpdateHoly
						self.HolyPower = bars
					end
					bars.FrameBackdrop = CreateFrame("Frame", nil, bars)
					bars.FrameBackdrop:SetTemplate("Default")
					bars.FrameBackdrop:CreateShadow("Default")
					bars.FrameBackdrop:SetPoint("TOPLEFT", -2, 2)
					bars.FrameBackdrop:SetPoint("BOTTOMRIGHT", 2, -2)
					bars.FrameBackdrop:SetFrameLevel(bars:GetFrameLevel() - 1)
				end

				-- deathknight runes
				if T.myclass == "DEATHKNIGHT" then

					local Runes = CreateFrame("Frame", nil, self)
					Runes:Point("BOTTOMLEFT", self, "TOPLEFT", 0, 7)
					Runes:Size(230, 2)

					for i = 1, 6 do
						Runes[i] = CreateFrame("StatusBar", self:GetName().."_Runes"..i, health)
						Runes[i]:SetHeight(2)
						if i == 1 then
							Runes[i]:SetWidth(35)
						else
							Runes[i]:SetWidth(229/6)
						end
						if (i == 1) then
							Runes[i]:Point("BOTTOMLEFT", self, "TOPLEFT", 0, 7)
						else
							Runes[i]:Point("TOPLEFT", Runes[i-1], "TOPRIGHT", 1, 0)
						end
						Runes[i]:SetStatusBarTexture(normTex)
						Runes[i]:GetStatusBarTexture():SetHorizTile(false)
					end

					self.Runes = Runes

					Runes.FrameBackdrop = CreateFrame("Frame", nil, Runes)
					Runes.FrameBackdrop:SetTemplate("Default")
					Runes.FrameBackdrop:CreateShadow("Default")
					Runes.FrameBackdrop:SetPoint("TOPLEFT", -2, 2)
					Runes.FrameBackdrop:SetPoint("BOTTOMRIGHT", 2, -2)
					Runes.FrameBackdrop:SetFrameLevel(Runes:GetFrameLevel() - 1)
				end

				-- shaman totem bar
				if T.myclass == "SHAMAN" then

					local TotemBar = {}
					TotemBar.Destroy = true
					for i = 1, 4 do
						TotemBar[i] = CreateFrame("StatusBar", self:GetName().."_TotemBar"..i, self)
						if (i == 1) then
						   TotemBar[i]:Point("BOTTOMLEFT", self, "TOPLEFT", 0, 7)
						else
						   TotemBar[i]:Point("TOPLEFT", TotemBar[i-1], "TOPRIGHT", 5, 0)
						end
						TotemBar[i]:SetStatusBarTexture(normTex)
						TotemBar[i]:Height(2)
						if i == 4 then
							TotemBar[i]:SetWidth(215/4)
						else
							TotemBar[i]:SetWidth(215/4)
						end
						TotemBar[i]:SetBackdrop(backdrop)
						TotemBar[i]:SetBackdropColor(0, 0, 0)
						TotemBar[i]:SetMinMaxValues(0, 1)

						TotemBar[i].bg = TotemBar[i]:CreateTexture(nil, "BORDER")
						TotemBar[i].bg:SetAllPoints(TotemBar[i])
						TotemBar[i].bg:SetTexture(normTex)
						TotemBar[i].bg.multiplier = 0.3
						
						TotemBar[i].FrameBackdrop = CreateFrame("Frame", nil, TotemBar[i])
						TotemBar[i].FrameBackdrop:SetTemplate("Default")
						TotemBar[i].FrameBackdrop:CreateShadow("Default")
						TotemBar[i].FrameBackdrop:SetPoint("TOPLEFT", -2, 2)
						TotemBar[i].FrameBackdrop:SetPoint("BOTTOMRIGHT", 2, -2)
						TotemBar[i].FrameBackdrop:SetFrameLevel(TotemBar[i]:GetFrameLevel() - 1)
					end
					self.TotemBar = TotemBar
				end
			end

			-- script for low mana
			self:SetScript("OnEnter", function(self)
				if self.EclipseBar and self.EclipseBar:IsShown() then 
					self.EclipseBar.Text:Hide()
				end
				FlashInfo.ManaLevel:Hide()
				UnitFrame_OnEnter(self) 
			end)
			self:SetScript("OnLeave", function(self) 
				if self.EclipseBar and self.EclipseBar:IsShown() then 
					self.EclipseBar.Text:Show()
				end
				FlashInfo.ManaLevel:Show()
				UnitFrame_OnLeave(self) 
			end)
		end

		if (unit == "target") then			
			-- Unit name on target
			local Name = health:CreateFontString(nil, "OVERLAY")
			Name:Point("CENTER", health, "CENTER", 0, 1)
			Name:SetJustifyH("LEFT")
			Name:SetFont(font, C["datatext"].fontsize+1, "MONOCHROMEOUTLINE")
			Name:SetShadowOffset(1.25, -1.25)

			self:Tag(Name, '[Tukui:getnamecolor][Tukui:nameshort] [Tukui:diffcolor][level] [shortclassification]')
			--self.Name = Name
			
			--combo points change to support sCombo
			local cp = T.SetFontString(self, font, 15, "MONOCHROMEOUTLINE")
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
					buffs:SetPoint("TOPLEFT", self, "TOPLEFT", -2, 30)
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
				buffs.size = 27.5
				buffs.num = 8
				
				debuffs:SetHeight(26)
				debuffs:SetWidth(247)
				debuffs:SetPoint("BOTTOMLEFT", buffs, "TOPLEFT", -2, 2)
				debuffs.size = 26
				debuffs.num = 24
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
			
			-- An option to show only our debuffs on target
			if unit == "target" then
				debuffs.onlyShowPlayer = C.unitframes.onlyselfdebuffs
			end
			
			self.Debuffs = debuffs
		end

		-- cast bar for player and target
		if (C["unitframes"].unitcastbar == true) then
			local castbar = CreateFrame("StatusBar", self:GetName().."CastBar", self)
			castbar:SetStatusBarTexture(normTex)
			
			castbar.bg = castbar:CreateTexture(nil, "BORDER")
			castbar.bg:SetAllPoints(castbar)
			castbar.bg:SetTexture(normTex)
			castbar.bg:SetVertexColor(.05, .05, .05)
			if unit == "player" then
				if C["unitframes"].cbicons == true then
					castbar:SetWidth(TukuiBar1:GetWidth() - 31)
				else
					castbar:SetWidth(TukuiBar1:GetWidth() - 4)
				end
				castbar:SetHeight(20)
				castbar:Point("BOTTOMRIGHT", TukuiBar1, "TOPRIGHT", -2, 5)
			elseif unit == "target" then
				if C["unitframes"].cbicons == true then
					castbar:SetWidth(225 - 28)
				else
					castbar:SetWidth(246)
				end
				castbar:SetHeight(20)
				castbar:Point("TOPRIGHT", self, "BOTTOMRIGHT", 0, 15)
			end
			castbar:SetFrameLevel(6)
			
			if( C["unitframes"].cbspark == true ) then
					castbar.Spark = castbar:CreateTexture(nil, 'OVERLAY')
					castbar.Spark:SetHeight(36)
					castbar.Spark:SetWidth(15)
					castbar.Spark:SetBlendMode('ADD')
				end

			-- Border
			castbar.border = CreateFrame("Frame", nil, castbar)
			castbar.border:CreatePanel("Default",1,1,"TOPLEFT", castbar, "TOPLEFT", -2, 2)
			castbar.border:CreateShadow("Default")
			castbar.border:Point("BOTTOMRIGHT", castbar, "BOTTOMRIGHT", 2, -2)
			
			castbar.CustomTimeText = T.CustomCastTimeText
			castbar.CustomDelayText = T.CustomCastDelayText
			castbar.PostCastStart = T.PostCastStart
			castbar.PostChannelStart = T.PostCastStart

			castbar.time = T.SetFontString(castbar,font, C["datatext"].fontsize, "MONOCHROMEOUTLINE")
			castbar.time:Point("RIGHT", castbar.bg, "RIGHT", -4, 0)
			castbar.time:SetTextColor(0, 4, 0)
			castbar.time:SetJustifyH("RIGHT")

			castbar.Text = T.SetFontString(castbar,font, C["datatext"].fontsize, "MONOCHROMEOUTLINE")
			castbar.Text:Point("LEFT", castbar.bg, "LEFT", 4, 0)
			castbar.Text:SetTextColor(0.3, 0.2, 1)
			castbar.Text:Width(100)
			castbar.Text:Height(10)
			
			if C["unitframes"].cbicons == true then
				castbar.button = CreateFrame("Frame", nil, castbar)
				castbar.button:Size(24)
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
			CombatFeedbackText = T.SetFontString(health, font,  C["datatext"].fontsize+1, "MONOCHROMEOUTLINE")
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
	
		-- create panel for both high and low version
		local panel = CreateFrame("Frame", nil, self)
		if T.lowversion then
			panel:CreatePanel("Default", 129, 17, "BOTTOM", self, "BOTTOM", 0, T.Scale(0))
			panel:SetFrameLevel(2)
			panel:SetFrameStrata("MEDIUM")
			panel:SetBackdropBorderColor(unpack(C["media"].bordercolor))
			panel:SetAlpha(0)
			self.panel = panel
		else
			panel:CreatePanel("Default", 129, 17, "BOTTOM", self, "BOTTOM", 0, T.Scale(0))
			panel:SetFrameLevel(2)
			panel:SetFrameStrata("MEDIUM")
			panel:SetBackdropBorderColor(unpack(C["media"].bordercolor))
			panel:SetAlpha(0)
			self.panel = panel
		end
		
		-- health bar
		local health = CreateFrame('StatusBar', nil, self)
		health:Height(15)
		health:SetPoint("TOPLEFT")
		health:SetPoint("TOPRIGHT")
		health:SetStatusBarTexture(normTex)
		
		-- Border for ToT
		local HealthBorder = CreateFrame("Frame", nil, health)
		HealthBorder:SetPoint("TOPLEFT", health, "TOPLEFT", -2, 2)
		HealthBorder:SetPoint("BOTTOMRIGHT", health, "BOTTOMRIGHT", 2, -2)
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
		power:Size(130, 2)
		power:Point("TOP", health, "BOTTOM", 0, -7)
		power:SetStatusBarTexture(normTex)
		
		-- Border for Power
		local PowerBorder = CreateFrame("Frame", nil, power)
		PowerBorder:SetPoint("TOPLEFT", power, "TOPLEFT", -2, 2)
		PowerBorder:SetPoint("BOTTOMRIGHT", power, "BOTTOMRIGHT", 2, -2)
		PowerBorder:SetTemplate("Default")
		PowerBorder:CreateShadow("Default")
		PowerBorder:SetFrameLevel(power:GetFrameLevel() - 1)
		self.PowerBorder = PowerBorder
		
		power.frequentUpdates = true

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
			power.colorTapping = true
			power.colorClass = true
			power.colorReaction = true
			powerBG.multiplier = 0.1				
		else
			power.colorPower = true
		end
		
		-- Unit name
		local Name = health:CreateFontString(nil, "OVERLAY")
		Name:SetPoint("CENTER", self.Health, "CENTER", 0, 1)
		Name:SetFont(font, C["datatext"].fontsize+1, "MONOCHROMEOUTLINE")
		Name:SetJustifyH("CENTER")

		self:Tag(Name, '[Tukui:getnamecolor][Tukui:namemedium]')
		self.Name = Name
		
		if C["unitframes"].totdebuffs == true then
			local debuffs = CreateFrame("Frame", nil, health)
			debuffs:SetHeight(24)
			debuffs:SetWidth(128)
			debuffs.size = 24
			debuffs.spacing = 3
			debuffs.num = 5

			debuffs:SetPoint("TOPLEFT", health, "TOPLEFT", -2, 29)
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
	
		-- create panel for both high and low version
		local panel = CreateFrame("Frame", nil, self)
		if T.lowversion then
			panel:CreatePanel("Default", 129, 17, "BOTTOM", self, "BOTTOM", 0, T.Scale(0))
			panel:SetFrameLevel(2)
			panel:SetFrameStrata("MEDIUM")
			panel:SetBackdropBorderColor(unpack(C["media"].bordercolor))
			panel:SetAlpha(0)
			self.panel = panel
		else
			panel:CreatePanel("Default", 129, 17, "BOTTOM", self, "BOTTOM", 0, T.Scale(0))
			panel:SetFrameLevel(2)
			panel:SetFrameStrata("MEDIUM")
			panel:SetBackdropBorderColor(unpack(C["media"].bordercolor))
			panel:SetAlpha(0)
			self.panel = panel
		end
		
		-- health bar
		local health = CreateFrame('StatusBar', nil, self)
		if C["unitframes"].extendedpet == true then
			health:Height(15)
		else
			health:Height(22)
		end
		health:SetPoint("TOPLEFT")
		health:SetPoint("TOPRIGHT")
		health:SetStatusBarTexture(normTex)
		
		-- Border for Health
		local HealthBorder = CreateFrame("Frame", nil, health)
		HealthBorder:SetPoint("TOPLEFT", health, "TOPLEFT", -2, 2)
		HealthBorder:SetPoint("BOTTOMRIGHT", health, "BOTTOMRIGHT", 2, -2)
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
			power:Size(130, 2)
			power:Point("TOP", health, "BOTTOM", 0, -7)
			power:SetStatusBarTexture(normTex)

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
			PowerBorder:SetPoint("TOPLEFT", power, "TOPLEFT", -2, 2)
			PowerBorder:SetPoint("BOTTOMRIGHT", power, "BOTTOMRIGHT", 2, -2)
			PowerBorder:SetTemplate("Default")
			PowerBorder:CreateShadow("Default")
			PowerBorder:SetFrameLevel(power:GetFrameLevel() - 1)
			self.PowerBorder = PowerBorder

			self.Power = power
			self.Power.bg = powerBG
		end
				
		-- Unit name
		local Name = health:CreateFontString(nil, "OVERLAY")
		Name:SetPoint("CENTER", self.Health, "CENTER", 1, 1)
		Name:SetFont(font, C["datatext"].fontsize+1, "MONOCHROMEOUTLINE")
		Name:SetJustifyH("CENTER")

		self:Tag(Name, '[Tukui:getnamecolor][Tukui:namemedium]')
		self.Name = Name
		
		-- update pet name, this should fix "UNKNOWN" pet names on pet unit, health and bar color sometime being "grayish".
		self:RegisterEvent("UNIT_PET", T.updateAllElements)
	end
	
	------------------------------------------------------------------------
	--	Pet target unit layout
	------------------------------------------------------------------------
	
	if (unit == "pettarget") then
		-- health bar
		local health = CreateFrame('StatusBar', nil, self)
		health:Height(15)
		health:SetPoint("TOPLEFT")
		health:SetPoint("TOPRIGHT")
		health:SetStatusBarTexture(normTex)
		
		-- Border for ToT
		local HealthBorder = CreateFrame("Frame", nil, health)
		HealthBorder:SetPoint("TOPLEFT", health, "TOPLEFT", -2, 2)
		HealthBorder:SetPoint("BOTTOMRIGHT", health, "BOTTOMRIGHT", 2, -2)
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
		power:Size(128, 2)
		power:Point("TOP", health, "BOTTOM", 0, -7)
		power:SetStatusBarTexture(normTex)
		
		-- Border for Power
		local PowerBorder = CreateFrame("Frame", nil, power)
		PowerBorder:SetPoint("TOPLEFT", power, "TOPLEFT", -2, 2)
		PowerBorder:SetPoint("BOTTOMRIGHT", power, "BOTTOMRIGHT", 2, -2)
		PowerBorder:SetTemplate("Default")
		PowerBorder:CreateShadow("Default")
		PowerBorder:SetFrameLevel(power:GetFrameLevel() - 1)
		self.PowerBorder = PowerBorder
		
		power.frequentUpdates = true

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
			power.colorTapping = true
			power.colorClass = true
			power.colorReaction = true
			powerBG.multiplier = 0.1				
		else
			power.colorPower = true
		end
		
		-- Unit name
		local Name = health:CreateFontString(nil, "OVERLAY")
		Name:SetPoint("CENTER", self.Health, "CENTER", 0, 1)
		Name:SetFont(font, C["datatext"].fontsize+1, "MONOCHROMEOUTLINE")
		Name:SetJustifyH("CENTER")

		self:Tag(Name, '[Tukui:getnamecolor][Tukui:namemedium]')
		self.Name = Name
		
		-- update pet name, this should fix "UNKNOWN" pet names on pet unit, health and bar color sometime being "grayish".
		self:RegisterEvent("UNIT_PET", T.updateAllElements)
	end


	------------------------------------------------------------------------
	--	Focus unit layout
	------------------------------------------------------------------------
	
	if (unit == "focus") then
		-- health 
		local health = CreateFrame('StatusBar', nil, self)
		health:Height(18)
		health:SetPoint("TOPLEFT")
		health:SetPoint("TOPRIGHT")
		health:SetStatusBarTexture(normTex)
		
		-- Border for Health
		local HealthBorder = CreateFrame("Frame", nil, health)
		HealthBorder:SetPoint("TOPLEFT", health, "TOPLEFT", -2, 2)
		HealthBorder:SetPoint("BOTTOMRIGHT", health, "BOTTOMRIGHT", 2, -2)
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

		health.value = T.SetFontString(health, font,  C["datatext"].fontsize+1, "MONOCHROMEOUTLINE")
		health.value:Point("LEFT", 2, 0)
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
		power:Size(200, 2)
		power:Point("TOP", health, "BOTTOM", 0, -7)
		power:SetStatusBarTexture(normTex)
		
		-- Border for Power
		local PowerBorder = CreateFrame("Frame", nil, power)
		PowerBorder:SetPoint("TOPLEFT", power, "TOPLEFT", -2, 2)
		PowerBorder:SetPoint("BOTTOMRIGHT", power, "BOTTOMRIGHT", 2, -2)
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
		
		power.value = T.SetFontString(health, font,  C["datatext"].fontsize+1, "MONOCHROMEOUTLINE")
		power.value:Point("RIGHT", -2, 1)
		power.PreUpdate = T.PreUpdatePower
		power.PostUpdate = T.PostUpdatePower
				
		self.Power = power
		self.Power.bg = powerBG
		
		-- names
		local Name = health:CreateFontString(nil, "OVERLAY")
		Name:SetPoint("CENTER", health, "CENTER", 0, 1)
		Name:SetJustifyH("CENTER")
		Name:SetFont(font, C["datatext"].fontsize+1, "MONOCHROMEOUTLINE")
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
		debuffs.num = 8
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
		
		castbar.time = T.SetFontString(castbar,font, C["datatext"].fontsize, "MONOCHROMEOUTLINE")
		castbar.time:Point("RIGHT", castbar, "RIGHT", -4, 0)
		castbar.time:SetTextColor(0, 4, 0)
		castbar.time:SetJustifyH("RIGHT")
		castbar.CustomTimeText = T.CustomCastTimeText

		castbar.Text = T.SetFontString(castbar,font, C["datatext"].fontsize, "MONOCHROMEOUTLINE")
		castbar.Text:SetPoint("LEFT", castbar, "LEFT", 4, 0)
		castbar.Text:SetTextColor(0.3, 0.2, 1)
		castbar.Text:Width(100)
		castbar.Text:Height(12)
		
		castbar.CustomDelayText = T.CustomCastDelayText
		castbar.PostCastStart =T.PostCastStart
		castbar.PostChannelStart = T.PostCastStart
								
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
		health:Height(18)
		health:SetPoint("TOPLEFT")
		health:SetPoint("TOPRIGHT")
		health:SetStatusBarTexture(normTex)
		
		-- Border for Health
		local HealthBorder = CreateFrame("Frame", nil, health)
		HealthBorder:SetPoint("TOPLEFT", health, "TOPLEFT", -2, 2)
		HealthBorder:SetPoint("BOTTOMRIGHT", health, "BOTTOMRIGHT", 2, -2)
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

		health.value = T.SetFontString(health, font,  C["datatext"].fontsize+1, "MONOCHROMEOUTLINE")
		health.value:Point("LEFT", 2, 0)
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
		power:Size(200, 2)
		power:Point("TOP", health, "BOTTOM", 0, -7)
		power:SetStatusBarTexture(normTex)
		
		-- Border for Power
		local PowerBorder = CreateFrame("Frame", nil, power)
		PowerBorder:SetPoint("TOPLEFT", power, "TOPLEFT", -2, 2)
		PowerBorder:SetPoint("BOTTOMRIGHT", power, "BOTTOMRIGHT", 2, -2)
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
		
		power.value = T.SetFontString(health, font,  C["datatext"].fontsize+1, "MONOCHROMEOUTLINE")
		power.value:Point("RIGHT", -2, 1)
		power.PreUpdate = T.PreUpdatePower
		power.PostUpdate = T.PostUpdatePower
				
		self.Power = power
		self.Power.bg = powerBG
		
		-- names
		local Name = health:CreateFontString(nil, "OVERLAY")
		Name:SetPoint("CENTER", health, "CENTER", 0, 1)
		Name:SetJustifyH("CENTER")
		Name:SetFont(font, C["datatext"].fontsize+1, "MONOCHROMEOUTLINE")
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
		
		castbar.time = T.SetFontString(castbar,font, C["datatext"].fontsize, "MONOCHROMEOUTLINE")
		castbar.time:Point("RIGHT", castbar, "RIGHT", -4, 0)
		castbar.time:SetTextColor(0, 4, 0)
		castbar.time:SetJustifyH("RIGHT")
		castbar.CustomTimeText = T.CustomCastTimeText

		castbar.Text = T.SetFontString(castbar,font, C["datatext"].fontsize, "MONOCHROMEOUTLINE")
		castbar.Text:SetPoint("LEFT", castbar, "LEFT", 4, 0)
		castbar.Text:SetTextColor(0.3, 0.2, 1)
		castbar.Text:Width(100)
		castbar.Text:Height(12)
		
		castbar.CustomDelayText = T.CustomCastDelayText
		castbar.PostCastStart = T.PostCastStart
		castbar.PostChannelStart = T.PostCastStart
								
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
		health:Height(18)
		health:SetPoint("TOPLEFT")
		health:SetPoint("TOPRIGHT")
		health:SetStatusBarTexture(normTex)
		
		-- Border for Health
		local HealthBorder = CreateFrame("Frame", nil, health)
		HealthBorder:SetPoint("TOPLEFT", health, "TOPLEFT", -2, 2)
		HealthBorder:SetPoint("BOTTOMRIGHT", health, "BOTTOMRIGHT", 2, -2)
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

		health.value = T.SetFontString(health, font,  C["datatext"].fontsize+1, "MONOCHROMEOUTLINE")
		health.value:Point("LEFT", 2, 0)
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
		power:Size(200, 2)
		power:Point("TOP", health, "BOTTOM", 0, -7)
		power:SetStatusBarTexture(normTex)
		
		-- Border for Power
		local PowerBorder = CreateFrame("Frame", nil, power)
		PowerBorder:SetPoint("TOPLEFT", power, "TOPLEFT", -2, 2)
		PowerBorder:SetPoint("BOTTOMRIGHT", power, "BOTTOMRIGHT", 2, -2)
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
		
		power.value = T.SetFontString(health, font,  C["datatext"].fontsize+1, "MONOCHROMEOUTLINE")
		power.value:Point("RIGHT", -2, 0.5)
		power.PreUpdate = T.PreUpdatePower
		power.PostUpdate = T.PostUpdatePower
				
		self.Power = power
		self.Power.bg = powerBG
		
		-- names
		local Name = health:CreateFontString(nil, "OVERLAY")
		Name:SetPoint("CENTER", health, "CENTER", 0, 1)
		Name:SetJustifyH("CENTER")
		Name:SetFont(font, C["datatext"].fontsize+1, "MONOCHROMEOUTLINE")
		Name:SetShadowColor(0, 0, 0)
		Name:SetShadowOffset(1.25, -1.25)
		Name.frequentUpdates = 0.2
		
		self:Tag(Name, '[Tukui:getnamecolor][Tukui:nameshort]')
		self.Name = Name
		
		if (unit and unit:find("boss%d")) then
			-- alt power bar
			local AltPowerBar = CreateFrame("StatusBar", nil, self.Health)
			AltPowerBar:SetFrameLevel(self.Health:GetFrameLevel() + 1)
			AltPowerBar:Height(2)
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
			buffs:SetHeight(31)
			buffs:SetWidth(102)
			buffs:Point("TOPRIGHT", self, "TOPLEFT", -5, 2)
			buffs.size = 31
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
		debuffs:SetHeight(31)
		debuffs:SetWidth(102)
		debuffs:Point('TOPLEFT', self, 'TOPRIGHT', 5, 2)
		debuffs.size = 31
		debuffs.num = 3
		debuffs.spacing = 3
		debuffs.initialAnchor = 'LEFT'
		debuffs["growth-x"] = "RIGHT"
		debuffs.PostCreateIcon = T.PostCreateAura
		debuffs.PostUpdateIcon = T.PostUpdateAura
		self.Debuffs = debuffs
				
		-- trinket feature via trinket plugin
		if (C.arena.unitframes) and (unit and unit:find('arena%d')) then
			local Trinketbg = CreateFrame("Frame", nil, self)
			Trinketbg:SetHeight(31)
			Trinketbg:SetWidth(31)
			Trinketbg:Point("TOPRIGHT", self, "TOPLEFT", -5, 2)				
			Trinketbg:SetTemplate("Default")
			Trinketbg:CreateShadow("Default")
			Trinketbg:SetFrameLevel(0)
			self.Trinketbg = Trinketbg
			
			local Trinket = CreateFrame("Frame", nil, Trinketbg)
			Trinket:SetAllPoints(Trinketbg)
			Trinket:Point("TOPLEFT", Trinketbg, 2, -2)
			Trinket:Point("BOTTOMRIGHT", Trinketbg, -2, 2)
			Trinket:SetFrameLevel(1)
			Trinket.trinketUseAnnounce = true
			self.Trinket = Trinket
		end
		
		-- boss & arena frames cast bar!
		local castbar = CreateFrame("StatusBar", self:GetName().."CastBar", self)
		castbar:SetPoint("LEFT", 23, -1)
		castbar:SetPoint("RIGHT", 0, -1)
		castbar:SetPoint("BOTTOM", 0, -23)

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
		
		castbar.time = T.SetFontString(castbar,font, C["datatext"].fontsize, "MONOCHROMEOUTLINE")
		castbar.time:Point("RIGHT", castbar, "RIGHT", -4, 0)
		castbar.time:SetTextColor(0, 4, 0)
		castbar.time:SetJustifyH("RIGHT")
		castbar.CustomTimeText = T.CustomCastTimeText

		castbar.Text = T.SetFontString(castbar,font, C["datatext"].fontsize, "MONOCHROMEOUTLINE")
		castbar.Text:Point("LEFT", castbar, "LEFT", 4, 0)
		castbar.Text:SetTextColor(0.3, 0.2, 1)
		castbar.Text:Width(100)
		castbar.Text:Height(10)
		
		castbar.CustomDelayText = T.CustomCastDelayText
		castbar.PostCastStart = T.PostCastStart
		castbar.PostChannelStart = T.PostCastStart
								
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
	
	if (self:GetParent():GetName():match"TukuiMainTank" or self:GetParent():GetName():match"TukuiMainAssist") then
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
		HealthBorder:SetPoint("TOPLEFT", health, "TOPLEFT", -2, 2)
		HealthBorder:SetPoint("BOTTOMRIGHT", health, "BOTTOMRIGHT", 2, -2)
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
		Name:SetFont(font, C["datatext"].fontsize+1, "MONOCHROMEOUTLINE")
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
oUF:RegisterStyle('Tukui', Shared)
T.Player = 230
T.Target  = 230
T.ToT = 130
T.Pet = 130
T.Focus = 115 
T.Focustarget = 115
T.Boss = 200
T.Pettarget = 130

-----------------------------------------------------------------------
-- Unitframe Spawn
-----------------------------------------------------------------------

local player = oUF:Spawn('player', "TukuiPlayer")
local target = oUF:Spawn('target', "TukuiTarget")
local tot = oUF:Spawn('targettarget', "TukuiTargetTarget")
local pet = oUF:Spawn('pet', "TukuiPet")
local focus = oUF:Spawn('focus', "TukuiFocus")

-- Sizes
player:Size(T.Player, player.Health:GetHeight() + player.Power:GetHeight() + player.panel:GetHeight() + 6)
target:Size(T.Target, target.Health:GetHeight() + target.Power:GetHeight() + target.panel:GetHeight() + 6)
tot:Size(T.ToT, tot.Health:GetHeight() + tot.Power:GetHeight() + tot.panel:GetHeight() + 6)
pet:Size(T.Pet, pet.Health:GetHeight() + pet.Power:GetHeight() + pet.panel:GetHeight() + 6)	
focus:Size(200, 25)

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:SetScript("OnEvent", function(self, event, addon)
	player:ClearAllPoints()
	target:ClearAllPoints()
	tot:ClearAllPoints()
	pet:ClearAllPoints()
	focus:ClearAllPoints()
if IsAddOnLoaded("Tukui_Raid") then

	--[ DPS ]--
		player:Point("TOP", UIParent, "BOTTOM", -170 , 260)
		target:Point("TOP", UIParent, "BOTTOM", 170, 260)
		tot:Point("TOPRIGHT", TukuiTarget, "BOTTOMRIGHT", 0, -20)
		pet:Point("TOPLEFT", TukuiPlayer, "BOTTOMLEFT", 0, -20)
		focus:Point("TOP", UIParent, "BOTTOM", -450, 602)
elseif IsAddOnLoaded("Tukui_Raid_Healing") then

	--[ HEAL ]--
		player:Point("TOP", UIParent, "BOTTOM", -309 , 350)
		target:Point("TOP", UIParent, "BOTTOM", 309, 350)
		tot:Point("TOPRIGHT", TukuiTarget, "BOTTOMRIGHT", 0, -25)
		pet:Point("TOPLEFT", TukuiPlayer, "BOTTOMLEFT", 0, -25)
		focus:Point("TOP", UIParent, "BOTTOM", -450, 602)
	else
	
	--[ NONE ]--
		player:Point("TOP", UIParent, "BOTTOM", -309 , 350)
		target:Point("TOP", UIParent, "BOTTOM", 309, 350)
		tot:Point("TOPRIGHT", TukuiTarget, "BOTTOMRIGHT", 0, -25)
		pet:Point("TOPLEFT", TukuiPlayer, "BOTTOMLEFT", 0, -25)
		focus:Point("TOP", UIParent, "BOTTOM", -450, 602)	
	end
end)

-- pettarget
if C["unitframes"].pettarget == true then
local pettarget = oUF:Spawn('pettarget', "TukuiPetTarget")
pettarget:SetPoint("BOTTOMRIGHT", player, "TOPRIGHT", 0,5)
pettarget:Size(128, 26)
end	

-- focus target
if C.unitframes.showfocustarget then
	local focustarget = oUF:Spawn("focustarget", "TukuiFocusTarget")
	focustarget:SetPoint("TOP", TukuiFocus, "BOTTOM", 0 , -35)
	focustarget:Size(200, 29)
end

if C.arena.unitframes then
	local arena = {}
	for i = 1, 5 do
		arena[i] = oUF:Spawn("arena"..i, "TukuiArena"..i)
		if i == 1 then
			arena[i]:SetPoint("TOP", UIParent, "BOTTOM", 500, 550)
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
			boss[i]:SetPoint("TOP", UIParent, "BOTTOM", 500, 550)
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

-- Hunter Dismiss Pet Taint (Blizzard issue)
local PET_DISMISS = "PET_DISMISS"
if T.myclass == "HUNTER" then PET_DISMISS = nil end

do
	UnitPopupMenus["SELF"] = { "PVP_FLAG", "LOOT_METHOD", "LOOT_THRESHOLD", "OPT_OUT_LOOT_TITLE", "LOOT_PROMOTE", "DUNGEON_DIFFICULTY", "RAID_DIFFICULTY", "RESET_INSTANCES", "RAID_TARGET_ICON", "SELECT_ROLE", "CONVERT_TO_PARTY", "CONVERT_TO_RAID", "LEAVE", "CANCEL" };
	UnitPopupMenus["PET"] = { "PET_PAPERDOLL", "PET_RENAME", "PET_ABANDON", PET_DISMISS, "CANCEL" };
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