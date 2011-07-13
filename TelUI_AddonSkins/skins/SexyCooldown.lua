--[[
	SexyCooldown Skin by Darth Android / Telroth - The Venture Co.
	
	Skins SexyCooldown to look like TelUI.
	
	Available SKIN methods:
	
	:SCDStripSkinSettings(bar) -- removes skin-related settings from the bar's option table
	
	:SkinSexyCooldownBar(bar) -- Applies skinning to a specific SexyCooldown bar.
	
	:SkinSexyCooldownIcon(bar, icon) -- Skins one of the icons on a bar.
	
	Available LAYOUT methods:
	
	:SCDStripLayoutSettings(bar) -- removes layout-related settings from the bar's option table
	
	:PositionSexyCooldownBar(bar) -- positions the SexyCooldown bar "bar" on screen
	 
	(C)2010 Darth Android / Telroth - The Venture Co.
	File version v91.109
]]

if not Mod_AddonSkins or not SexyCooldown then return end
local scd = SexyCooldown
local L = LibStub("AceLocale-3.0"):GetLocale("SexyCooldown")

Mod_AddonSkins:RegisterSkin("SexyCooldown",function(Skin,skin,Layout,layout,config)
	
	
	--[[ Skinning and Layout functions ]]
	-- Strip skinning settings from in-game GUI
	function Skin:SCDStripSkinSettings(bar)
		-- Remove conflicting options
		bar.optionsTable.args.icon.args.borderheader = nil
		bar.optionsTable.args.icon.args.border = nil
		bar.optionsTable.args.icon.args.borderColor = nil
		bar.optionsTable.args.icon.args.borderSize = nil
		bar.optionsTable.args.icon.args.borderInset = nil
		--bar.optionsTable.args.icon.args.sizeOffset = nil
		bar.optionsTable.args.bar.args.bnbheader = nil
		bar.optionsTable.args.bar.args.texture = nil
		bar.optionsTable.args.bar.args.backgroundColor = nil
		bar.optionsTable.args.bar.args.border = nil
		bar.optionsTable.args.bar.args.borderColor = nil
		bar.optionsTable.args.bar.args.borderSize = nil
		bar.optionsTable.args.bar.args.borderInset = nil
	end
	-- Strip positioning settings from in-game GUI
	function Layout:SCDStripLayoutSettings(bar)
		-- Override variables
		bar.settings.bar.lock = true
		--remove settings which are no longer relavent for this bar
		bar.optionsTable.args.copy = nil
		bar.optionsTable.args.bar.args.lock = nil
		bar.optionsTable.args.bar.args.orientation.values = {
			LEFT_TO_RIGHT = L["Left to Right"],
			RIGHT_TO_LEFT = L["Right to Left"]
		}
		bar.optionsTable.args.bar.args.positioning = nil
		bar.optionsTable.args.bar.args.height = nil
		bar.optionsTable.args.bar.args.width = nil
		bar.optionsTable.args.bar.args.x = nil
		bar.optionsTable.args.bar.args.y = nil
		bar.optionsTable.args.bar.args.inactiveAlpha = nil
	end
	-- Don't move the bars, but a layout could integrate them
	Layout.PositionSexyCooldownBar = dummy
	
	-- Skin Bars
	function Skin:SkinSexyCooldownBar(bar)
		self:SCDStripSkinSettings(bar)
		self:SkinFrame(bar)
	end
	
	
	-- Skin Icons
	function Skin:SkinSexyCooldownIcon(bar, icon)
		self:SkinFrame(icon)
		self:SkinFrame(icon.overlay)
		icon.tex:SetTexCoord(unpack(config.buttonZoom))
		icon.overlay:SetBackdropColor(0,0,0,0)
		-- Default no background/border
		icon:SetBackdropColor(0,0,0,0)
		icon:SetBackdropBorderColor(0,0,0,0)
		icon.overlay:SetBackdropBorderColor(0,0,0,0)
	end

	--[[ Hook bar creation to add skinning ]]
	
	local function HookSCDBar(bar)
		-- Hook bar skinning & layout
		bar.UpdateBarLook_ = bar.UpdateBarLook
		bar.UpdateBarLook = function(self)
			self:UpdateBarLook_()
			skin:SkinSexyCooldownBar(self)
			layout:PositionSexyCooldownBar(self)
		end
		-- Hook icon skinning
		bar.UpdateSingleIconLook_ = bar.UpdateSingleIconLook
		bar.UpdateSingleIconLook = function(self,icon)
			self:UpdateSingleIconLook_(icon)
			skin:SkinSexyCooldownIcon(bar,icon)
		end
		-- Static skinning
		bar.settings.icon.borderInset = config.borderWidth
	end
	
	scd.CreateBar_ = scd.CreateBar
	scd.CreateBar = function(self, settings, name)
		local bar = scd:CreateBar_(settings,name)
		HookSCDBar(bar)
		return bar
	end
	-- Skin Pre-existing bars
	for _,bar in ipairs(scd.bars) do
		HookSCDBar(bar)
		-- Force a bar update
		bar:UpdateBarLook()
	end
end)

local function SkinBar(frame)
	-- Override bar skinning
	frame.UpdateBarBackdrop = function(self)
		self:SetBackdrop({
			bgFile = TukuiDB["media"].blank, 
			edgeFile = TukuiDB["media"].blank, 
			tile = false, tileSize = 0, edgeSize = TukuiDB.mult, 
			insets = { left = -TukuiDB.mult, right = -TukuiDB.mult, top = -TukuiDB.mult, bottom = -TukuiDB.mult}
		})
		if frame.skin and frame.skin.nobackground then
			self:SetBackdropColor(0,0,0,0)
		else
			self:SetBackdropColor(unpack(TukuiDB["media"].backdropcolor))
		end
		if frame.skin and frame.skin.noborder then
			self:SetBackdropBorderColor(0,0,0,0)
		else
			self:SetBackdropBorderColor(unpack(TukuiDB["media"].bordercolor))
		end
	end
	-- Override cooldown skinning
	frame.UpdateSingleIconLook_ = frame.UpdateSingleIconLook
	frame.UpdateSingleIconLook = function(self, icon)
		frame:UpdateSingleIconLook_(icon)
		if frame.skin and frame.skin.noiconborder then
			icon:SetBackdrop({
				bgFile = TukuiDB["media"].blank, 
				edgeFile = TukuiDB["media"].blank, 
				tile = false, tileSize = 0, edgeSize = 0, 
				insets = { left = 0, right = 0, top = 0, bottom = 0}
			})
			icon:SetBackdropBorderColor(0,0,0,0)
		else
			icon:SetBackdrop({
				bgFile = TukuiDB["media"].blank, 
				edgeFile = TukuiDB["media"].blank, 
				tile = false, tileSize = 0, edgeSize = TukuiDB.mult, 
				--insets = { left = -TukuiDB.mult, right = -TukuiDB.mult, top = -TukuiDB.mult, bottom = -TukuiDB.mult}
				insets = { left = 0, right = 0, top = 0, bottom = 0}
			})
			icon:SetBackdropBorderColor(unpack(TukuiDB["media"].bordercolor))
		end
		icon:SetBackdropColor(0,0,0,0)
	end
	-- Skinning options
	frame.settings.icon.borderInset = 2

	frame:UpdateBarLook()
end





