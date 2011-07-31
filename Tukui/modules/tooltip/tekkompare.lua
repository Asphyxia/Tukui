---------------------------------------------------------------------------------------------
-- tekKompare.lua based on http://www.wowinterface.com/downloads/info6837-tekKompare.html
---------------------------------------------------------------------------------------------

local T, C, L = unpack( select( 2, ... ) )

local orig1, orig2 = {}, {}
local GameTooltip = GameTooltip

local linktypes = {
	item = true,
	enchant = true,
	spell = true,
	quest = true,
	unit = true,
	talent = true,
	achievement = true,
	glyph = true,
	instancelock = true
}

local _G = getfenv( 0 )


local function OnHyperlinkEnter( frame, link, ... )
	local linktype = link:match( "^([^:]+)" )
	if linktype and linktypes[linktype] then
		GameTooltip:SetOwner( frame, "ANCHOR_TOPLEFT" )
		GameTooltip:SetHyperlink( link )
		GameTooltip:Show()
	end

	if orig1[frame] then return orig1[frame]( frame, link, ... ) end
end


local function OnHyperlinkLeave( frame, ... )
	GameTooltip:Hide()
	if orig2[frame] then return orig2[frame]( frame, ... ) end
end


for i = 1, NUM_CHAT_WINDOWS do
	local frame = _G["ChatFrame"..i]
	orig1[frame] = frame:GetScript( "OnHyperlinkEnter" )
	frame:SetScript( "OnHyperlinkEnter", OnHyperlinkEnter )

	orig2[frame] = frame:GetScript( "OnHyperlinkLeave" )
	frame:SetScript( "OnHyperlinkLeave", OnHyperlinkLeave )
end


local orig1 = GameTooltip:GetScript( "OnTooltipSetItem" )
GameTooltip:SetScript( "OnTooltipSetItem", function( self, ... )
	if not ShoppingTooltip1:IsVisible() and not self:IsEquippedItem() then GameTooltip_ShowCompareItem( self, 1 ) end
	if orig1 then return orig1( self, ... ) end
end )


local orig2 = ItemRefTooltip:GetScript( "OnTooltipSetItem" )
ItemRefTooltip:SetScript( "OnTooltipSetItem", function( self, ... )
	GameTooltip_ShowCompareItem( self, 1 )
	self.comparing = true
	if orig2 then return orig2( self, ... ) end
end )


ItemRefTooltip:SetScript( "OnEnter", nil )
ItemRefTooltip:SetScript( "OnLeave", nil )
ItemRefTooltip:SetScript( "OnDragStart", function( self )
	ItemRefShoppingTooltip1:Hide();
	ItemRefShoppingTooltip2:Hide();
	ItemRefShoppingTooltip3:Hide()
	self:StartMoving()
end )

ItemRefTooltip:SetScript( "OnDragStop", function( self )
	self:StopMovingOrSizing()
	ValidateFramePosition( self )
	GameTooltip_ShowCompareItem( self, 1 )
end )