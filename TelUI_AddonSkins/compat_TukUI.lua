--[[
	Compatibility layer for TukUI v10 and v11

	Provides the base implementation of Mod_AddonSkins, Skin, Layout, and TelUI.config needed to
	support skinning inside of the TukUI environment. There is no OOP or memory management
	available.

	*TukUI Edit Authors*
	These skins can be easily hooked by defining methods in the CustomSkin object. There are several
	base functions defined by this file, and each skin has its own functions which can be hooked. Please
	check the headers of each file for a list and description of what methods can be customized. An example of overriding
	a skin would be as follows:

	function CustomSkin:SkinBackgroundFrame(frame)
		self:SkinFrame(frame)
		T.CreateShadow(frame)
	end

	Here we're modifying the :SkinBackground() method to add shadows. Note that self is a reference to the skin object,
	which means you can call any of the other skinning functions from it. The above block of code may be placed anywhere
	in your own addon or code, so long as it is executed before the PLAYER_LOGIN event fires. To remove a skin customization,
	simply dereference the function like so:

	CustomSkin.SkinBackgroundFrame = nil

	This will cause the skins to fall back to the default skinning function. *PLEASE NOTE* All skinning functions must be able
	to handle being called with the same arguments many times. This means that Adding shadows or highlights must be able to
	check if they've already created and attached a shadow, to prevent memory leaks. Some of these functions are called many
	times a second with the same frame! Due to the way that these skins are implemented with TukUI, both SKIN functions and
	LAYOUT functions are customized through CustomSkin.

	Availble SKIN methods:

	:SkinFrame(frame) -- Applies a basic skin to the frame "frame". This method will be called to skin any frames created or managed
	by the skins, including frames that are stacked on top of one another.

	:SkinBackgroundFrame(frame) -- Similar to :SkinFrame(frame), this method only handles frames which are directly above the WorldFrame,
	or which are the base of a UI element. This is where you want to apply your shadows and such.

	:SkinFrame(frame) -- Applies a skin to a frame, which will be used as a panel against the background

	:SkinButton(button) -- This method will skin a button, including icon, to fit within the skin.	

	File version v91.109
	(C)2010 Darth Android / Telroth-The Venture Co.
]]

-- Don't run if TelUI is loaded, or TukUI isn't.
if IsAddOnLoaded("TelUI") or Mod_AddonSkins or not IsAddOnLoaded("Tukui") then return end

local T, C, L = unpack(Tukui) -- Import: T - functions, constants, variables; C - config; L - locales

local TukVer = tonumber(T.version)

Mod_AddonSkins = CreateFrame("Frame")
local Mod_AddonSkins = Mod_AddonSkins

function Mod_AddonSkins:SkinFrame(frame)
	frame:SetTemplate("Default")
end

function Mod_AddonSkins:SkinBackgroundFrame(frame)
	frame:SetTemplate("Transparent")
end

function Mod_AddonSkins:SkinButton(button)
	self:SkinFrame(button)
	button:StyleButton(button.GetCheckedTexture and button:GetCheckedTexture())
end

function Mod_AddonSkins:SkinActionButton(button)
	if not button then return end
	self:SkinButton(button)
	local name = button:GetName()
	button.count = button.count or _G[name.."Count"]
	if button.count then
		button.count:SetFont(self.font,self.fontSize,self.fontFlags)
		button.count:SetDrawLayer("OVERLAY")
	end
	button.hotkey = button.hotkey or _G[name.."HotKey"]
	if button.hotkey then
		button.hotkey:SetFont(self.font,self.fontSize,self.fontFlags)
		button.hotkey:SetDrawLayer("OVERLAY")
	end
	button.icon = button.icon or _G[name.."Icon"]
	if button.icon then
		button.icon:SetTexCoord(unpack(self.buttonZoom))
		button.icon:SetDrawLayer("ARTWORK",-1)
		button.icon:ClearAllPoints()
		button.icon:SetPoint("TOPLEFT",button,"TOPLEFT",self.borderWidth, -self.borderWidth)
		button.icon:SetPoint("BOTTOMRIGHT",button,"BOTTOMRIGHT",-self.borderWidth, self.borderWidth)
	end
	button.textName = button.textName or _G[name.."Name"]
	if button.textName then
		button.textName:SetAlpha(0)
	end
	button.cd = button.cd or _G[name.."Cooldown"]
end

Mod_AddonSkins.barTexture = C.media.normTex
Mod_AddonSkins.bgTexture = C.media.blank
Mod_AddonSkins.font = C.media.pixelfont
Mod_AddonSkins.smallFont = C.media.pixelfont
Mod_AddonSkins.fontSize = 8
Mod_AddonSkins.fontStyle = "MONOCHROMEOUTLINE"
Mod_AddonSkins.buttonSize = T.Scale(27)
Mod_AddonSkins.buttonSpacing = T.Scale(4)
Mod_AddonSkins.borderWidth = T.Scale(2)
Mod_AddonSkins.buttonZoom = {.08,.92,.08,.92}
Mod_AddonSkins.barSpacing = T.Scale(1)
Mod_AddonSkins.barHeight = T.Scale(20)
Mod_AddonSkins.skins = {}
Mod_AddonSkins.__index = Mod_AddonSkins

-- TukUI-Specific Integration Support

local CustomSkin = setmetatable(CustomSkin or {},Mod_AddonSkins)

-- Custom SexyCooldown positioning. This is used to lock the bars into place above the action bar or over either info bar.
-- To achieve this, the user must name their bar either "actionbar", "infoleft", or "inforight" depending on where they want
-- the bar anchored.
if not CustomSkin.PositionSexyCooldownBar then
	function CustomSkin:PositionSexyCooldownBar(bar)
		if bar.settings.bar.name == "actionbar" then
			self:SCDStripLayoutSettings(bar)
			bar.settings.bar.inactiveAlpha = 1
			bar:SetHeight(self.buttonSize)
			bar:SetWidth(TukuiActionBarBackground:GetWidth() - 2 * self.buttonSpacing)
			bar:SetPoint("TOPLEFT",TukuiActionBarBackground,"TOPLEFT",self.buttonSpacing,-self.buttonSpacing)
			bar:SetPoint("TOPRIGHT",TukuiActionBarBackground,"TOPRIGHT",-self.buttonSpacing,-self.buttonSpacing)
			if not TukuiActionBarBackground.resized then
				TukuiActionBarBackground:SetHeight(TukuiActionBarBackground:GetHeight() + self.buttonSize + self.buttonSpacing)
				InvTukuiActionBarBackground:SetHeight(TukuiActionBarBackground:GetHeight())
				TukuiActionBarBackground.resized = true
			end
		elseif bar.settings.bar.name == "infoleft" then
			self:SCDStripLayoutSettings(bar)
			bar.settings.bar.inactiveAlpha = 0
			bar:SetAllPoints(TukuiInfoLeft)
		elseif bar.settings.bar.name == "inforight" then
			self:SCDStripLayoutSettings(bar)
			bar.settings.bar.inactiveAlpha = 0
			bar:SetAllPoints(TukuiInfoRight)
		end
	end
end

-- Dummy function expected by some skins
function dummy() end

function Mod_AddonSkins:RegisterSkin(name, initFunc)
	self = Mod_AddonSkins -- Static function
	if type(initFunc) ~= "function" then error("initFunc must be a function!",2) end
	self.skins[name] = initFunc
	if name == "LibSharedMedia" then -- Load LibSharedMedia early.
		initFunc(self, CustomSkin, self, CustomSkin, CustomSkin)
		self.skins[name] = nil
	end
end

Mod_AddonSkins:RegisterEvent("PLAYER_LOGIN")
Mod_AddonSkins:SetScript("OnEvent",function(self)
	self:UnregisterEvent("PLAYER_LOGIN")
	self:SetScript("OnEvent",nil)
	-- Initialize all skins
	for name, func in pairs(self.skins) do
		func(self,CustomSkin,self,CustomSkin,CustomSkin) -- Mod_AddonSkins functions as skin, layout, and config.
	end
end)