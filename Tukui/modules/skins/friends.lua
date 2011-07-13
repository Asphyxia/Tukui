local T, C, L = unpack(select(2, ...))

local function LoadSkin()
	local tabs = {
		"LeftDisabled",
		"MiddleDisabled",
		"RightDisabled",
		"Left",
		"Middle",
		"Right",
	}
	
	local function SkinSocialHeaderTab(tab)
		if not tab then return end
		for _, object in pairs(tabs) do
			local tex = _G[tab:GetName()..object]
			tex:SetTexture(nil)
		end
		tab:GetHighlightTexture():SetTexture(nil)
		tab.backdrop = CreateFrame("Frame", nil, tab)
		tab.backdrop:SetTemplate("Transparent")
		tab.backdrop:SetFrameLevel(tab:GetFrameLevel() - 1)
		tab.backdrop:Point("TOPLEFT", 3, -8)
		tab.backdrop:Point("BOTTOMRIGHT", -6, 0)
	end
		
	local StripAllTextures = {
		"FriendsListFrame",
		"FriendsTabHeader",
		"FriendsFrameFriendsScrollFrame",
		"WhoFrameColumnHeader1",
		"WhoFrameColumnHeader2",
		"WhoFrameColumnHeader3",
		"WhoFrameColumnHeader4",
		"ChannelListScrollFrame",
		"ChannelRoster",
		"FriendsFramePendingButton1",
		"FriendsFramePendingButton2",
		"FriendsFramePendingButton3",
		"FriendsFramePendingButton4",
		"ChannelFrameDaughterFrame",
		"AddFriendFrame",
		"AddFriendNoteFrame",
		"FriendsFriendsFrame",
		"FriendsFriendsList",
		"FriendsFriendsNoteFrame",
	}			

	local KillTextures = {
		"FriendsFrameTopLeft",
		"FriendsFrameTopRight",
		"FriendsFrameBottomLeft",
		"FriendsFrameBottomRight",
		"ChannelFrameVerticalBar",
		"FriendsFrameBroadcastInputLeft",
		"FriendsFrameBroadcastInputRight",
		"FriendsFrameBroadcastInputMiddle",
		"ChannelFrameDaughterFrameChannelNameLeft",
		"ChannelFrameDaughterFrameChannelNameRight",
		"ChannelFrameDaughterFrameChannelNameMiddle",
		"ChannelFrameDaughterFrameChannelPasswordLeft",
		"ChannelFrameDaughterFrameChannelPasswordRight",				
		"ChannelFrameDaughterFrameChannelPasswordMiddle",			
	}

	local buttons = {
		"FriendsFrameAddFriendButton",
		"FriendsFrameSendMessageButton",
		"WhoFrameWhoButton",
		"WhoFrameAddFriendButton",
		"WhoFrameGroupInviteButton",
		"ChannelFrameNewButton",
		"FriendsFrameIgnorePlayerButton",
		"FriendsFrameUnsquelchButton",
		"FriendsFramePendingButton1AcceptButton",
		"FriendsFramePendingButton1DeclineButton",
		"FriendsFramePendingButton2AcceptButton",
		"FriendsFramePendingButton2DeclineButton",
		"FriendsFramePendingButton3AcceptButton",
		"FriendsFramePendingButton3DeclineButton",
		"FriendsFramePendingButton4AcceptButton",
		"FriendsFramePendingButton4DeclineButton",
		"ChannelFrameDaughterFrameOkayButton",
		"ChannelFrameDaughterFrameCancelButton",
		"AddFriendEntryFrameAcceptButton",
		"AddFriendEntryFrameCancelButton",
		"AddFriendInfoFrameContinueButton",
		"FriendsFriendsSendRequestButton",
		"FriendsFriendsCloseButton",
	}			

	for _, button in pairs(buttons) do
		T.SkinButton(_G[button])
	end
	--Reposition buttons
	WhoFrameWhoButton:Point("RIGHT", WhoFrameAddFriendButton, "LEFT", -2, 0)
	WhoFrameAddFriendButton:Point("RIGHT", WhoFrameGroupInviteButton, "LEFT", -2, 0)
	WhoFrameGroupInviteButton:Point("BOTTOMRIGHT", WhoFrame, "BOTTOMRIGHT", -44, 82)
	--Resize Buttons
	WhoFrameWhoButton:Size(WhoFrameWhoButton:GetWidth() - 4, WhoFrameWhoButton:GetHeight())
	WhoFrameAddFriendButton:Size(WhoFrameAddFriendButton:GetWidth() - 4, WhoFrameAddFriendButton:GetHeight())
	WhoFrameGroupInviteButton:Size(WhoFrameGroupInviteButton:GetWidth() - 4, WhoFrameGroupInviteButton:GetHeight())
	T.SkinEditBox(WhoFrameEditBox)
	WhoFrameEditBox:Height(WhoFrameEditBox:GetHeight() - 15)
	WhoFrameEditBox:Point("BOTTOM", WhoFrame, "BOTTOM", -10, 108)
	WhoFrameEditBox:Width(WhoFrameEditBox:GetWidth() + 17)

	for _, texture in pairs(KillTextures) do
		_G[texture]:Kill()
	end

	for _, object in pairs(StripAllTextures) do
		_G[object]:StripTextures()
	end
	FriendsFrame:StripTextures(true)

	T.SkinEditBox(AddFriendNameEditBox)
	AddFriendFrame:SetTemplate("Transparent")			

	--Who Frame
	local function UpdateWhoSkins()
		WhoListScrollFrame:StripTextures()
	end
	--Channel Frame
	local function UpdateChannel()
		ChannelRosterScrollFrame:StripTextures()
	end
	--BNet Frame
	FriendsFrameBroadcastInput:CreateBackdrop("Transparent")
	ChannelFrameDaughterFrameChannelName:CreateBackdrop("Transparent")
	ChannelFrameDaughterFrameChannelPassword:CreateBackdrop("Transparent")			

	ChannelFrame:HookScript("OnShow", UpdateChannel)
	hooksecurefunc("FriendsFrame_OnEvent", UpdateChannel)

	WhoFrame:HookScript("OnShow", UpdateWhoSkins)
	hooksecurefunc("FriendsFrame_OnEvent", UpdateWhoSkins)

	ChannelFrameDaughterFrame:CreateBackdrop("Transparent")
	FriendsFrame:CreateBackdrop("Transparent")
	FriendsFrame.backdrop:Point( "TOPLEFT", FriendsFrame, "TOPLEFT", 11,-12)
	FriendsFrame.backdrop:Point( "BOTTOMRIGHT", FriendsFrame, "BOTTOMRIGHT", -35, 76)
	T.SkinCloseButton(ChannelFrameDaughterFrameDetailCloseButton,ChannelFrameDaughterFrame)
	T.SkinCloseButton(FriendsFrameCloseButton,FriendsFrame.backdrop)
	T.SkinDropDownBox(WhoFrameDropDown,150)
	T.SkinDropDownBox(FriendsFrameStatusDropDown,70)

	--Bottom Tabs
	for i=1, 4 do
		T.SkinTab(_G["FriendsFrameTab"..i])
	end

	for i=1, 3 do
		SkinSocialHeaderTab(_G["FriendsTabHeaderTab"..i])
	end

	local function Channel()
		for i=1, MAX_DISPLAY_CHANNEL_BUTTONS do
			local button = _G["ChannelButton"..i]
			if button then
				button:StripTextures()
				button:SetHighlightTexture("Interface\\PaperDollInfoFrame\\UI-Character-Tab-Highlight")
				
				_G["ChannelButton"..i.."Text"]:SetFont(C.media.font, 12)
			end
		end
	end
	hooksecurefunc("ChannelList_Update", Channel)
	
	--View Friends BN Frame
	FriendsFriendsFrame:CreateBackdrop("Transparent")

	T.SkinEditBox(FriendsFriendsList)
	T.SkinEditBox(FriendsFriendsNoteFrame)
	T.SkinDropDownBox(FriendsFriendsFrameDropDown,150)
end

tinsert(T.SkinFuncs["Tukui"], LoadSkin)