local T, C, L = unpack( select( 2, ... ) )

if C["bags"].enable == true then return end

local function LoadSkin()
	local QUEST_ITEM_STRING = select( 10, GetAuctionItemClasses() )

	local function UpdateBorderColors( button )
		button:SetBackdropBorderColor( unpack( C["media"].bordercolor ) )

		if button.type and button.type == QUEST_ITEM_STRING then
			button:SetBackdropBorderColor( 1, 0.2, 0.2 )
		elseif button.quality and button.quality > 1 then
			local r, g, b = GetItemQualityColor( button.quality )
			button:SetBackdropBorderColor( r, g, b )
		end
	end
	
	local function SkinButton( button )
		if not button.skinned then
			button:StripTextures()
			button:SetTemplate( "Default", true )
			button:StyleButton()

			local icon = _G[button:GetName() .. "IconTexture"]
			icon:ClearAllPoints()
			icon:Point( "TOPLEFT", 2, -2 )
			icon:Point( "BOTTOMRIGHT", -2, 2 )
			icon:SetTexCoord( .08, .92, .08, .92 )

			if _G[button:GetName() .. "IconQuestTexture"] then
				_G[button:GetName() .. "IconQuestTexture"]:Kill()
			end
			button.skinned = true
		end
	end

	local function SkinBagButtons( container, button )
		SkinButton( button )

		local texture, _, _, _, _, _, itemLink = GetContainerItemInfo( container:GetID(), button:GetID() )
		local isQuestItem = GetContainerItemQuestInfo( container:GetID(), button:GetID() )
		_G[button:GetName() .. "IconTexture"]:SetTexture( texture )
		button.type = nil
		button.quality = nil
		button.ilink = itemLink
		if button.ilink then
			button.name, _, button.quality, _, _, button.type = GetItemInfo( button.ilink )
		end

		if isQuestItem then
			button.type = QUEST_ITEM_STRING
		end

		UpdateBorderColors( button )
	end

	local function SkinBags()
		for i = 1, NUM_CONTAINER_FRAMES, 1 do
			local container = _G["ContainerFrame" .. i]
			if container and not container.backdrop then
				container:SetFrameStrata( "HIGH" )
				container:StripTextures( true )
				container:CreateBackdrop( "Transparent" )
				--container.backdrop:Point( "TOPLEFT", 2, -2 )
				--container.backdrop:Point( "BOTTOMRIGHT", -2, 2 )
				--T.SkinCloseButton( _G[container:GetName() .. "CloseButton"] )
				
				container.backdrop:Point("TOPLEFT", 6, -2)
				container.backdrop:Point("BOTTOMRIGHT", -4, 4)
				T.SkinCloseButton(_G[container:GetName().."CloseButton"])
				_G[container:GetName().."CloseButton"]:Point("TOPRIGHT",container.backdrop,"TOPRIGHT",0,3)

				container:HookScript( "OnShow", function( self )
					if self and self.size then
						for b = 1, self.size, 1 do
							local button = _G[self:GetName() .. "Item" .. b]
							SkinBagButtons( self, button )
						end
					end
				end )

				if i == 1 then
					BackpackTokenFrame:StripTextures( true )
					for i = 1, MAX_WATCHED_TOKENS do
						_G["BackpackTokenFrameToken" .. i].icon:SetTexCoord( .08, .92, .08, .92 )
						_G["BackpackTokenFrameToken" .. i]:CreateBackdrop( "Default" )
						_G["BackpackTokenFrameToken" .. i].backdrop:Point( "TOPLEFT", _G["BackpackTokenFrameToken" .. i].icon, "TOPLEFT", -2, 2 )
						_G["BackpackTokenFrameToken" .. i].backdrop:Point( "BOTTOMRIGHT", _G["BackpackTokenFrameToken" .. i].icon, "BOTTOMRIGHT", 2, -2 )
						_G["BackpackTokenFrameToken" .. i].icon:Point("LEFT", _G["BackpackTokenFrameToken" .. i].count, "RIGHT", 2, 0 )
					end
				end
			end

			if container and container.size then
				for b = 1, container.size, 1 do
					local button = _G[container:GetName() .. "Item" .. b]
					SkinBagButtons( container, button )
				end
			end
		end
	end
	
	-- Backpack + Bags bar
		for i = 0, 3 do
			local backpack = MainMenuBarBackpackButton
			local bags = _G["CharacterBag"..i.."Slot"]
			local bags2 = _G["CharacterBag"..(i-1).."Slot"]
			backpack:StyleButton(true)
			bags:StyleButton(true)
			T.SkinButton(backpack)
			T.SkinButton(bags)
			backpack:SetParent(UIParent)
			bags:SetParent(backpack)
			
			if TukuiCubeRight then
				backpack:ClearAllPoints()
				backpack:Point("BOTTOMRIGHT", TukuiInfoRight, "TOPRIGHT", 0, 130)
				backpack:Hide()		-- Show/Hide bags when clicking on the right cube
				TukuiCubeRight:EnableMouse(true)
				TukuiCubeRight:SetScript("OnMouseDown", function(self)
					if MainMenuBarBackpackButton:IsShown() then
						MainMenuBarBackpackButton:Hide()
					else
						MainMenuBarBackpackButton:Show()
					end
				end)
			elseif C.chat.background then
				backpack:SetSize(30,30)
				backpack:ClearAllPoints()
				backpack:Point("BOTTOMRIGHT", TukuiChatBackgroundRight, "BOTTOMLEFT", -5, 0)
			else
				backpack:Hide()
			end
			
			bags:ClearAllPoints()
			if i == 0 then
				bags:Point("BOTTOM", backpack,"TOP", 0, 4)
			else
				bags:Point("BOTTOM", bags2, "TOP", 0, 4)
			end

			bags:SetSize(backpack:GetWidth(), backpack:GetHeight())
			
			local icons = { "MainMenuBarBackpackButtonIconTexture", "CharacterBag0SlotIconTexture", 
			"CharacterBag1SlotIconTexture", "CharacterBag2SlotIconTexture", "CharacterBag3SlotIconTexture",}
			for _, object in pairs(icons) do
				_G[object]:SetTexCoord(.08, .92, .08, .92)
				_G[object]:ClearAllPoints()
				_G[object]:SetAllPoints()
				_G[object]:Point("TOPLEFT", 2, -2)
				_G[object]:Point("BOTTOMRIGHT", -2, 2)
			end
		end

	hooksecurefunc( "BankFrameItemButton_Update", function( button )
		if not BankFrame.backdrop then
			BankFrame:StripTextures( true )
			BankFrame:CreateBackdrop( "Transparent" )
			BankFrame.backdrop:Point( "TOPLEFT", 0, 0 )
			BankFrame.backdrop:Point( "BOTTOMRIGHT", -4, 70 )
			T.SkinButton( BankFramePurchaseButton, true )
			T.SkinCloseButton( BankCloseButton )

			BankFrame.backdrop2 = CreateFrame( "Frame", nil, BankFrame )
			BankFrame.backdrop2:SetTemplate( "Default" )
			BankFrame.backdrop2:Point( "TOPLEFT", BankFrameItem1, "TOPLEFT", -8, 8 )
			BankFrame.backdrop2:Point( "BOTTOMRIGHT", BankFrameItem28, "BOTTOMRIGHT", 8, -8 )

			BankFrame.backdrop3 = CreateFrame( "Frame", nil, BankFrame )
			BankFrame.backdrop3:SetTemplate( "Default" )
			BankFrame.backdrop3:Point( "TOPLEFT", BankFrameBag1, "TOPLEFT", -8, 8 )
			BankFrame.backdrop3:Point( "BOTTOMRIGHT", BankFrameBag7, "BOTTOMRIGHT", 8, -8 )
		end

		SkinButton( button )

		local inventoryID = button:GetInventorySlot()
		local textureName = GetInventoryItemTexture( "player", inventoryID )

		if( textureName ) then
			_G[button:GetName() .. "IconTexture"]:SetTexture( textureName )
		elseif( button.isBag ) then
			local _, slotTextureName = GetInventorySlotInfo( strsub( button:GetName(), 10 ) )
			_G[button:GetName() .. "IconTexture"]:SetTexture( slotTextureName )
		end

		if not button.isBag then
			local texture, _, _, _, _, _, itemLink = GetContainerItemInfo( BANK_CONTAINER, button:GetID() )
			local isQuestItem = GetContainerItemQuestInfo( BANK_CONTAINER, button:GetID() )
			button.type = nil
			button.ilink = itemLink
			button.quality = nil

			if button.ilink then
				button.name, _, button.quality, _, _, button.type = GetItemInfo( button.ilink )
			end

			if isQuestItem then
				button.type = QUEST_ITEM_STRING
			end

			UpdateBorderColors( button )
		end

		local highlight = _G[button:GetName() .. "HighlightFrameTexture"]
		if highlight and not highlight.skinned then
			highlight:SetTexture(0,1,0,0.3)
			highlight.SetTexture = T.dummy
			highlight:ClearAllPoints()
			highlight:Point( "TOPLEFT", 2, -2 )
			highlight:Point( "BOTTOMRIGHT", -2, 2 )
			highlight.skinned = true
		end
	end )

	hooksecurefunc( "updateContainerFrameAnchors", function()
		local frame, xOffset, yOffset, screenHeight, freeScreenHeight, leftMostPoint, column
		local screenWidth = GetScreenWidth()
		local containerScale = 1
		local leftLimit = 0
		if( BankFrame:IsShown() ) then
			leftLimit = BankFrame:GetRight() - 25
		end

		while( containerScale > CONTAINER_SCALE ) do
			screenHeight = GetScreenHeight() / containerScale
			xOffset = CONTAINER_OFFSET_X / containerScale
			yOffset = CONTAINER_OFFSET_Y / containerScale
			freeScreenHeight = screenHeight - yOffset
			leftMostPoint = screenWidth - xOffset
			column = 1

			local frameHeight
			for index, frameName in ipairs( ContainerFrame1.bags ) do
				frameHeight = _G[frameName]:GetHeight()
				if( freeScreenHeight < frameHeight ) then
					column = column + 1
					leftMostPoint = screenWidth - ( column * CONTAINER_WIDTH * containerScale ) - xOffset
					freeScreenHeight = screenHeight - yOffset
				end
				freeScreenHeight = freeScreenHeight - frameHeight - VISIBLE_CONTAINER_SPACING
			end
			if( leftMostPoint < leftLimit ) then
				containerScale = containerScale - 0.01
			else
				break
			end
		end

		if( containerScale < CONTAINER_SCALE ) then
			containerScale = CONTAINER_SCALE
		end

		screenHeight = GetScreenHeight() / containerScale;
		-- Adjust the start anchor for bags depending on the multibars
		xOffset = CONTAINER_OFFSET_X / containerScale;
		yOffset = CONTAINER_OFFSET_Y / containerScale;
		-- freeScreenHeight determines when to start a new column of bags
		freeScreenHeight = screenHeight - yOffset;
		column = 0;		
		
		local bagsPerColumn = 0
		for index, frameName in ipairs(ContainerFrame1.bags) do
			frame = _G[frameName];
			frame:SetScale(1);
			if ( index == 1 ) then
				-- First bag
				frame:SetPoint("BOTTOMRIGHT", TukuiInfoRight, "BOTTOMRIGHT", 4, TukuiInfoRight:GetHeight()+2 );
				bagsPerColumn = bagsPerColumn + 1
			elseif ( freeScreenHeight < frame:GetHeight() ) then
				-- Start a new column
				column = column + 1;
				freeScreenHeight = screenHeight - yOffset;
				if column > 1 then
					frame:SetPoint("BOTTOMRIGHT", ContainerFrame1.bags[(index - bagsPerColumn) - 1], "BOTTOMLEFT", -(CONTAINER_SPACING -6), 0 );
				else
					frame:SetPoint("BOTTOMRIGHT", ContainerFrame1.bags[index - bagsPerColumn], "BOTTOMLEFT", -(CONTAINER_SPACING -6 ), 0 );
				end
				bagsPerColumn = 0
			else
				-- Anchor to the previous bag
				frame:SetPoint("BOTTOMRIGHT", ContainerFrame1.bags[index - 1], "TOPRIGHT", 0, CONTAINER_SPACING);	
				bagsPerColumn = bagsPerColumn + 1
			end
			freeScreenHeight = freeScreenHeight - frame:GetHeight() - VISIBLE_CONTAINER_SPACING;
		end		
	end)

	local bags = CreateFrame( "Frame" )
	bags:RegisterEvent( "BAG_UPDATE" )
	bags:RegisterEvent( "ITEM_LOCK_CHANGED" )
	bags:RegisterEvent( "BAG_CLOSED")
	bags:SetScript( "OnEvent", SkinBags )
	SkinBags()
end

local SearchBags = function(self)
	local Search = string.lower(self:GetText())
	
	for i = 1, NUM_CONTAINER_FRAMES, 1 do
		local Container = _G["ContainerFrame"..i]
		
		if Container and Container.size then
			for b = 1, Container.size, 1 do
				local Button = _G[Container:GetName().."Item"..b]
				local ItemLink = select(7, GetContainerItemInfo(Container:GetID(), Button:GetID()))
				
				if ItemLink then
					local ItemName = string.lower(GetItemInfo(ItemLink))

					if string.find(ItemName, Search) then
						_G[Button:GetName().."IconTexture"]:SetDesaturated(false)
					else
						_G[Button:GetName().."IconTexture"]:SetDesaturated(true)
					end
				end
			end
		end
	end
end

local OnEscapePressed = function(self)
	self:SetAutoFocus(false)
	self:ClearFocus()
	SearchBags(self)
end

-- Bar
local frame = CreateFrame("Frame", nil, ContainerFrame1)
frame:CreatePanel(nil, 164, 16, "TOP", ContainerFrame1, "TOP", 2, -28)
frame:SetFrameLevel(ContainerFrame1:GetFrameLevel() + 1)
frame:SetFrameStrata("HIGH")

-- Editbox
frame.edit = CreateFrame("Editbox", nil, frame)
frame.edit:Point("TOPLEFT", 2, 0)
frame.edit:Point("BOTTOMRIGHT", -2, -1)
frame.edit:SetFrameLevel(frame:GetFrameLevel() + 1)
frame.edit:SetMaxLetters(20)
frame.edit:SetAutoFocus(false)
frame.edit:SetFont(C.media.font, 12)
frame.edit:SetScript("OnEscapePressed", OnEscapePressed)
frame.edit:SetScript("OnEnterPressed", OnEscapePressed)
frame.edit:SetScript("OnTextChanged", SearchBags)

tinsert( T.SkinFuncs["Tukui"], LoadSkin )