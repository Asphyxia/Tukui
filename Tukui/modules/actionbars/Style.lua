local T, C, L = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales
if not C["actionbar"].enable == true then return end

local _G = _G
local media = C["media"]
local securehandler = CreateFrame("Frame", nil, nil, "SecureHandlerBaseTemplate")
local replace = string.gsub

local function style(self)
	local name = self:GetName()
	
	--> fixing a taint issue while changing totem flyout button in combat.
	if name:match("MultiCast") then return end 
	
	local action = self.action
	local Button = self
	local Icon = _G[name.."Icon"]
	local Count = _G[name.."Count"]
	local Flash	 = _G[name.."Flash"]
	local HotKey = _G[name.."HotKey"]
	local Border  = _G[name.."Border"]
	local Btname = _G[name.."Name"]
	local normal  = _G[name.."NormalTexture"]
 
	Flash:SetTexture("")
	Button:SetNormalTexture("")
 
	Border:Hide()
	Border = T.dummy
 
	Count:ClearAllPoints()
	Count:Point("BOTTOMRIGHT", 0, 2)
	Count:SetFont(C["media"].pixelfont, C["datatext"].fontsize, "MONOCHROMEOUTLINE")
 
	if not C["actionbar"].macrotext == true then
		Btname:SetText("")
		Btname:Kill()
	else
		Btname:SetAlphaGradient(0,Button:GetWidth())
		Btname:SetFont(C.media.pixelfont, C["datatext"].fontsize, "MONOCHROMEOUTLINE")
	end
 
	if not _G[name.."Panel"] then
		-- resize all button not matching T.buttonsize
		if self:GetHeight() ~= T.buttonsize and not InCombatLockdown() then --Taint fix for Flyout Buttons
			self:SetSize(T.buttonsize, T.buttonsize)
		end

		-- create the bg/border panel
		local panel = CreateFrame("Frame", name.."Panel", self)
		panel:CreatePanel("Transparent", T.buttonsize, T.buttonsize, "CENTER", self, "CENTER", 0, 0)
		if not C.actionbar.bgPanel then panel:CreateShadow() end
 
		panel:SetFrameStrata(self:GetFrameStrata())
		panel:SetFrameLevel(self:GetFrameLevel() - 1)
 
		Icon:SetTexCoord(.08, .92, .08, .92)
		Icon:Point("TOPLEFT", Button, 2, -2)
		Icon:Point("BOTTOMRIGHT", Button, -2, 2)
	end

	HotKey:ClearAllPoints()
	HotKey:Point("TOPRIGHT", 0, -3)
	HotKey:SetFont(C["media"].pixelfont, C["datatext"].fontsize, "MONOCHROMEOUTLINE")
	HotKey.ClearAllPoints = T.dummy
	HotKey.SetPoint = T.dummy
 
	if not C["actionbar"].hotkey == true then
		HotKey:SetText("")
		HotKey:Kill()
	end
 
	if normal then
		normal:ClearAllPoints()
		normal:SetPoint("TOPLEFT")
		normal:SetPoint("BOTTOMRIGHT")
	end
end

local function stylesmallbutton(normal, button, icon, name, pet)
	local Flash	 = _G[name.."Flash"]
	button:SetNormalTexture("")
	
	-- another bug fix reported by Affli in t12 beta
	button.SetNormalTexture = T.dummy
	
	Flash:SetTexture(media.buttonhover)
	
	if not _G[name.."Panel"] then
		button:SetWidth(T.petbuttonsize)
		button:SetHeight(T.petbuttonsize)
		
		local panel = CreateFrame("Frame", name.."Panel", button)
		panel:CreatePanel("Transparent", T.petbuttonsize, T.petbuttonsize, "CENTER", button, "CENTER", 0, 0)
		panel:SetBackdropColor(unpack(media.backdropcolor))
		panel:SetFrameStrata(button:GetFrameStrata())
		panel:SetFrameLevel(button:GetFrameLevel() - 1)

		icon:SetTexCoord(.08, .92, .08, .92)
		icon:ClearAllPoints()
		if pet then
			local autocast = _G[name.."AutoCastable"]
			autocast:Size(41, 40)
			autocast:ClearAllPoints()
			autocast:SetPoint("CENTER", button, 0, 0)
			icon:Point("TOPLEFT", button, T.Scale(2), T.Scale(-2))
			icon:Point("BOTTOMRIGHT", button, T.Scale(-2), T.Scale(2))
		else
			icon:Point("TOPLEFT", button, 2, -2)
			icon:Point("BOTTOMRIGHT", button, -2, 2)
		end
	end
	
	if normal then
		normal:ClearAllPoints()
		normal:SetPoint("TOPLEFT")
		normal:SetPoint("BOTTOMRIGHT")
	end
end

function T.StyleShift()
	for i=1, NUM_SHAPESHIFT_SLOTS do
		local name = "ShapeshiftButton"..i
		local button  = _G[name]
		local icon  = _G[name.."Icon"]
		local normal  = _G[name.."NormalTexture"]
		stylesmallbutton(normal, button, icon, name)
	end
end

function T.StylePet()
	for i=1, NUM_PET_ACTION_SLOTS do
		local name = "PetActionButton"..i
		local button  = _G[name]
		local icon  = _G[name.."Icon"]
		local normal  = _G[name.."NormalTexture2"]
		stylesmallbutton(normal, button, icon, name, true)
	end
end

local function updatehotkey(self, actionButtonType)
	local hotkey = _G[self:GetName() .. 'HotKey']
	local text = hotkey:GetText()
	
	text = replace(text, '(s%-)', 'S')
	text = replace(text, '(a%-)', 'A')
	text = replace(text, '(c%-)', 'C')
	text = replace(text, '(Mouse Button )', 'M')
	text = replace(text, '(Mouse Wheel Up)', 'MU')
	text = replace(text, '(Mouse Wheel Down)', 'MD')
	text = replace(text, '(Middle Mouse)', 'M3')
	text = replace(text, '(Num Pad )', 'N')
	text = replace(text, '(Page Up)', 'PU')
	text = replace(text, '(Page Down)', 'PD')
	text = replace(text, '(Spacebar)', 'SpB')
	text = replace(text, '(Insert)', 'Ins')
	text = replace(text, '(Home)', 'Hm')
	text = replace(text, '(Delete)', 'Del')
	
	if hotkey:GetText() == _G['RANGE_INDICATOR'] then
		hotkey:SetText('')
	else
		hotkey:SetText(text)
	end
end

-- rescale cooldown spiral to fix texture.
local buttonNames = { "ActionButton",  "MultiBarBottomLeftButton", "MultiBarBottomRightButton", "MultiBarLeftButton", "MultiBarRightButton", "ShapeshiftButton", "PetActionButton", "MultiCastActionButton"}
for _, name in ipairs( buttonNames ) do
	for index = 1, 12 do
		local buttonName = name .. tostring(index)
		local button = _G[buttonName]
		local cooldown = _G[buttonName .. "Cooldown"]
 
		if ( button == nil or cooldown == nil ) then
			break
		end
		
		cooldown:ClearAllPoints()
		cooldown:Point("TOPLEFT", button, "TOPLEFT", 2, -2)
		cooldown:Point("BOTTOMRIGHT", button, "BOTTOMRIGHT", -2, 2)
	end
end

local buttons = 0
local function SetupFlyoutButton()
	for i=1, buttons do
		--prevent error if you don't have max ammount of buttons
		if _G["SpellFlyoutButton"..i] then
			style(_G["SpellFlyoutButton"..i])
			_G["SpellFlyoutButton"..i]:StyleButton(true)
			_G["SpellFlyoutButton"..i]:SetFrameLevel(_G["SpellFlyoutButton"..i]:GetParent():GetFrameLevel() + 5)
		end
	end
end
SpellFlyout:HookScript("OnShow", SetupFlyoutButton)

--Hide the Mouseover texture and attempt to find the ammount of buttons to be skinned
local function styleflyout(self)
	self.FlyoutBorder:SetAlpha(0)
	self.FlyoutBorderShadow:SetAlpha(0)
	
	SpellFlyoutHorizontalBackground:SetAlpha(0)
	SpellFlyoutVerticalBackground:SetAlpha(0)
	SpellFlyoutBackgroundEnd:SetAlpha(0)
	
	for i=1, GetNumFlyouts() do
		local x = GetFlyoutID(i)
		local _, _, numSlots, isKnown = GetFlyoutInfo(x)
		if isKnown then
			buttons = numSlots
			break
		end
	end
	
	--Change arrow direction depending on what bar the button is on
	local arrowDistance
	if ((SpellFlyout and SpellFlyout:IsShown() and SpellFlyout:GetParent() == self) or GetMouseFocus() == self) then
		arrowDistance = 5
	else
		arrowDistance = 2
	end
	
	if self:GetParent():GetParent():GetName() == "SpellBookSpellIconsFrame" then return end

	

	if self:GetAttribute("flyoutDirection") ~= nil then
		local point, _, _, _, _ = self:GetParent():GetParent():GetPoint()
		
		if strfind(point, "BOTTOM") then
			self.FlyoutArrow:ClearAllPoints()
			self.FlyoutArrow:SetPoint("TOP", self, "TOP", 0, arrowDistance)
			SetClampedTextureRotation(self.FlyoutArrow, 0)
			if not InCombatLockdown() then self:SetAttribute("flyoutDirection", "UP") end
		else
			self.FlyoutArrow:ClearAllPoints()
			self.FlyoutArrow:SetPoint("LEFT", self, "LEFT", -arrowDistance, 0)
			SetClampedTextureRotation(self.FlyoutArrow, 270)
			if not InCombatLockdown() then self:SetAttribute("flyoutDirection", "LEFT") end
		end
	end
end

-- rework the mouseover, pushed, checked texture to match Tukui theme.
do
	for i = 1, 12 do
		_G["ActionButton"..i]:StyleButton(true)
		_G["MultiBarBottomLeftButton"..i]:StyleButton(true)
		_G["MultiBarBottomRightButton"..i]:StyleButton(true)
		_G["MultiBarLeftButton"..i]:StyleButton(true)
		_G["MultiBarRightButton"..i]:StyleButton(true)
	end
		 
	for i=1, 10 do
		_G["ShapeshiftButton"..i]:StyleButton(true)
		_G["PetActionButton"..i]:StyleButton(true)
	end
end

hooksecurefunc("ActionButton_Update", style)
hooksecurefunc("ActionButton_UpdateHotkeys", updatehotkey)
hooksecurefunc("ActionButton_UpdateFlyout", styleflyout)

---------------------------------------------------------------
-- Totem Style, they need a lot more work than "normal" buttons
-- Because of this, we skin it via separate styling codes
-- Special thank's to DarthAndroid
---------------------------------------------------------------

-- don't continue executing code in this file is not playing a shaman.
if not T.myclass == "SHAMAN" then return end

-- Tex Coords for empty buttons
SLOT_EMPTY_TCOORDS = {
	[EARTH_TOTEM_SLOT] = {
		left	= 66 / 128,
		right	= 96 / 128,
		top		= 3 / 256,
		bottom	= 33 / 256,
	},
	[FIRE_TOTEM_SLOT] = {
		left	= 67 / 128,
		right	= 97 / 128,
		top		= 100 / 256,
		bottom	= 130 / 256,
	},
	[WATER_TOTEM_SLOT] = {
		left	= 39 / 128,
		right	= 69 / 128,
		top		= 209 / 256,
		bottom	= 239 / 256,
	},
	[AIR_TOTEM_SLOT] = {
		left	= 66 / 128,
		right	= 96 / 128,
		top		= 36 / 256,
		bottom	= 66 / 256,
	},
}

local function StyleTotemFlyout(flyout)
	-- remove blizzard flyout texture
	flyout.top:SetTexture(nil)
	flyout.middle:SetTexture(nil)
	
	-- Skin buttons
	local last = nil
	
	for _,button in ipairs(flyout.buttons) do
		button:SetTemplate("Transparent")
		local icon = select(1,button:GetRegions())
		icon:SetTexCoord(.09,.91,.09,.91)
		icon:SetDrawLayer("ARTWORK")
		icon:Point("TOPLEFT",button,"TOPLEFT",2,-2)
		icon:Point("BOTTOMRIGHT",button,"BOTTOMRIGHT",-2,2)			
		button:Size(30,30)
		button:ClearAllPoints()
		button:Point("BOTTOM",last,"TOP",0,4)
		if button:IsVisible() then last = button end
		button:SetBackdropBorderColor(flyout.parent:GetBackdropBorderColor())
		button:StyleButton()
	end
	
	flyout.buttons[1]:SetPoint("BOTTOM",flyout,"BOTTOM")
	
	if flyout.type == "slot" then
		local tcoords = SLOT_EMPTY_TCOORDS[flyout.parent:GetID()]
		flyout.buttons[1].icon:SetTexCoord(tcoords.left,tcoords.right,tcoords.top,tcoords.bottom)
	end
	
	-- Skin Close button
	local close = MultiCastFlyoutFrameCloseButton
	close:SetTemplate("Transparent")	
	close:GetHighlightTexture():SetTexture([[Interface\Buttons\ButtonHilight-Square]])
	close:GetHighlightTexture():Point("TOPLEFT",close,"TOPLEFT",1,-1)
	close:GetHighlightTexture():Point("BOTTOMRIGHT",close,"BOTTOMRIGHT",-1,1)
	close:GetNormalTexture():SetTexture(nil)
	close:ClearAllPoints()
	close:Point("BOTTOMLEFT",last,"TOPLEFT",0,4)
	close:Point("BOTTOMRIGHT",last,"TOPRIGHT",0,4)  
	close:Height(8)
	
	close:SetBackdropBorderColor(last:GetBackdropBorderColor())
	flyout:ClearAllPoints()
	flyout:Point("BOTTOM",flyout.parent,"TOP",0,4)
end
hooksecurefunc("MultiCastFlyoutFrame_ToggleFlyout",function(self) StyleTotemFlyout(self) end)
	
local function StyleTotemOpenButton(button, parent)
	button:GetHighlightTexture():SetTexture(nil)
	button:GetNormalTexture():SetTexture(nil)
	button:Height(20)
	button:ClearAllPoints()
	button:Point("BOTTOMLEFT", parent, "TOPLEFT", 0, -3)
	button:Point("BOTTOMRIGHT", parent, "TOPRIGHT", 0, -3)
	if not button.visibleBut then
		button.visibleBut = CreateFrame("Frame",nil,button)
		button.visibleBut:Height(8)
		button.visibleBut:Width(button:GetWidth() + 2)
		button.visibleBut:SetPoint("CENTER")
		button.visibleBut.highlight = button.visibleBut:CreateTexture(nil,"HIGHLIGHT")
		button.visibleBut.highlight:SetTexture([[Interface\Buttons\ButtonHilight-Square]])
		button.visibleBut.highlight:Point("TOPLEFT",button.visibleBut,"TOPLEFT",1,-1)
		button.visibleBut.highlight:Point("BOTTOMRIGHT",button.visibleBut,"BOTTOMRIGHT",-1,1)
		button.visibleBut:SetTemplate("Transparent")
	end
	
	button.visibleBut:SetBackdropBorderColor(parent:GetBackdropBorderColor())
end
hooksecurefunc("MultiCastFlyoutFrameOpenButton_Show",function(button,_, parent) StyleTotemOpenButton(button, parent) end)

-- the color we use for border
local bordercolors = {
	{.23,.45,.13},   -- Earth
	{.58,.23,.10},   -- Fire
	{.19,.48,.60},   -- Water
	{.42,.18,.74},   -- Air
}

local function StyleTotemSlotButton(button, index)
	button:SetTemplate("Transparent")
	button.overlayTex:SetTexture(nil)
	button.background:SetDrawLayer("ARTWORK")
	button.background:ClearAllPoints()
	button.background:SetPoint("TOPLEFT",button,"TOPLEFT",T.Scale(2),T.Scale(-2))
	button.background:SetPoint("BOTTOMRIGHT",button,"BOTTOMRIGHT",T.Scale(-2),T.Scale(2))
	button:Size(30)
	button:SetBackdropBorderColor(unpack(bordercolors[((index-1) % 4) + 1]))
	button:StyleButton()
end
hooksecurefunc("MultiCastSlotButton_Update",function(self, slot) StyleTotemSlotButton(self,tonumber( string.match(self:GetName(),"MultiCastSlotButton(%d)"))) end)

-- Skin the actual totem buttons
local function StyleTotemActionButton(button, index)
	local icon = select(1,button:GetRegions())
	icon:SetTexCoord(.09,.91,.09,.91)
	icon:SetDrawLayer("ARTWORK")
	icon:Point("TOPLEFT",button,"TOPLEFT",2,-2)
	icon:Point("BOTTOMRIGHT",button,"BOTTOMRIGHT",-2,2)
	button.overlayTex:SetTexture(nil)
	button.overlayTex:Hide()
	button:GetNormalTexture():SetTexCoord(0,0,0,0)
	if button.slotButton then
		button:ClearAllPoints()
		button:SetAllPoints(button.slotButton)
		button:SetFrameLevel(button.slotButton:GetFrameLevel()+1)
	end
	button:SetBackdropBorderColor(unpack(bordercolors[((index-1) % 4) + 1]))
	button:SetBackdropColor(0,0,0,0)
	button:StyleButton(true)
end
hooksecurefunc("MultiCastActionButton_Update",function(actionButton, actionId, actionIndex, slot) StyleTotemActionButton(actionButton,actionIndex) end)

-- Skin the summon and recall buttons
local function StyleTotemSpellButton(button, index)
	if not button then return end
	local icon = select(1,button:GetRegions())
	icon:SetTexCoord(.09,.91,.09,.91)
	icon:SetDrawLayer("ARTWORK")
	icon:Point("TOPLEFT",button,"TOPLEFT",2,-2)
	icon:Point("BOTTOMRIGHT",button,"BOTTOMRIGHT",-2,2)
	button:SetTemplate("Transparent")
	button:GetNormalTexture():SetTexture(nil)
	button:Size(30, 30)
	_G[button:GetName().."Highlight"]:SetTexture(nil)
	_G[button:GetName().."NormalTexture"]:SetTexture(nil)
	button:StyleButton()
end
hooksecurefunc("MultiCastSummonSpellButton_Update", function(self) StyleTotemSpellButton(self,0) end)
hooksecurefunc("MultiCastRecallSpellButton_Update", function(self) StyleTotemSpellButton(self,5) end)