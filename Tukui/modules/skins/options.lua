local T, C, L = unpack(select(2, ...))

local function LoadSkin()
    local frames = {
			"VideoOptionsFrameCategoryFrame",
			"VideoOptionsFramePanelContainer",
			"InterfaceOptionsFrameCategories",
			"InterfaceOptionsFramePanelContainer",
			"InterfaceOptionsFrameAddOns",
			"AudioOptionsSoundPanelPlayback",
			"AudioOptionsSoundPanelVolume",
			"AudioOptionsSoundPanelHardware",
			"AudioOptionsVoicePanelTalking",
			"AudioOptionsVoicePanelBinding",
			"AudioOptionsVoicePanelListening",
			}
			for i = 1, getn(frames) do
				local SkinFrames = _G[frames[i]]
				if SkinFrames then
					SkinFrames:StripTextures()
					SkinFrames:CreateBackdrop("Transparent")
					if SkinFrames ~= _G["VideoOptionsFramePanelContainer"] and SkinFrames ~= _G["InterfaceOptionsFramePanelContainer"] then
						SkinFrames.backdrop:Point("TOPLEFT",-1,0)
						SkinFrames.backdrop:Point("BOTTOMRIGHT",0,1)
					else
						SkinFrames.backdrop:Point("TOPLEFT", 0, 0)
						SkinFrames.backdrop:Point("BOTTOMRIGHT", 0, 0)
					end
				end
			end

			local interfacetab = {
			"InterfaceOptionsFrameTab1",
			"InterfaceOptionsFrameTab2",
			}
			for i = 1, getn(interfacetab) do
				local itab = _G[interfacetab[i]]
				if itab then
					itab:StripTextures()
					T.SkinTab(itab)
				end
			end
			InterfaceOptionsFrameTab1:ClearAllPoints()
			InterfaceOptionsFrameTab1:SetPoint("BOTTOMLEFT",InterfaceOptionsFrameCategories,"TOPLEFT",-11,-2)

			VideoOptionsFrameDefaults:ClearAllPoints()
			InterfaceOptionsFrameDefaults:ClearAllPoints()
			InterfaceOptionsFrameCancel:ClearAllPoints()
			VideoOptionsFrameDefaults:SetPoint("TOPLEFT",VideoOptionsFrameCategoryFrame,"BOTTOMLEFT",-1,-5)
			InterfaceOptionsFrameDefaults:SetPoint("TOPLEFT",InterfaceOptionsFrameCategories,"BOTTOMLEFT",-1,-5)
			InterfaceOptionsFrameCancel:SetPoint("TOPRIGHT",InterfaceOptionsFramePanelContainer,"BOTTOMRIGHT",0,-6)
			
			local interfacecheckbox = {
			-- Controls
			"ControlsPanelStickyTargeting",
			"ControlsPanelAutoDismount",
			"ControlsPanelAutoClearAFK",
			"ControlsPanelBlockTrades",
			"ControlsPanelBlockGuildInvites",
			"ControlsPanelLootAtMouse",
			"ControlsPanelAutoLootCorpse",
			-- Combat
			"CombatPanelAttackOnAssist",
			"CombatPanelStopAutoAttack",
			"CombatPanelNameplateClassColors",
			"CombatPanelTargetOfTarget",
			"CombatPanelShowSpellAlerts",
			"CombatPanelReducedLagTolerance",
			"CombatPanelActionButtonUseKeyDown",
			"CombatPanelEnemyCastBarsOnPortrait",
			"CombatPanelEnemyCastBarsOnNameplates",
			-- Display
			"DisplayPanelShowCloak",
			"DisplayPanelShowHelm",
			"DisplayPanelShowAggroPercentage",
			"DisplayPanelPlayAggroSounds",
			"DisplayPanelDetailedLootInfo",
			"DisplayPanelShowSpellPointsAvg",
			"DisplayPanelemphasizeMySpellEffects",
			"DisplayPanelShowFreeBagSpace",
			"DisplayPanelColorblindMode", -- Delete when 4.2 is out
			"DisplayPanelCinematicSubtitles",
			"DisplayPanelRotateMinimap",
			"DisplayPanelScreenEdgeFlash",
			--Objectives
			"ObjectivesPanelAutoQuestTracking",
			"ObjectivesPanelAutoQuestProgress",
			"ObjectivesPanelMapQuestDifficulty",
			"ObjectivesPanelAdvancedWorldMap",
			"ObjectivesPanelWatchFrameWidth",
			-- Social
			"SocialPanelProfanityFilter",
			"SocialPanelSpamFilter",
			"SocialPanelChatBubbles",
			"SocialPanelPartyChat",
			"SocialPanelChatHoverDelay",
			"SocialPanelGuildMemberAlert",
			"SocialPanelChatMouseScroll",
			-- Action bars
			"ActionBarsPanelLockActionBars",
			"ActionBarsPanelSecureAbilityToggle",
			-- Names
			"NamesPanelMyName",
			"NamesPanelFriendlyPlayerNames",
			"NamesPanelFriendlyPets",
			"NamesPanelFriendlyGuardians",
			"NamesPanelFriendlyTotems",
			"NamesPanelUnitNameplatesFriends",
			"NamesPanelUnitNameplatesFriendlyGuardians",
			"NamesPanelUnitNameplatesFriendlyPets",
			"NamesPanelUnitNameplatesFriendlyTotems",
			"NamesPanelGuilds",
			"NamesPanelGuildTitles",
			"NamesPanelTitles",
			"NamesPanelNonCombatCreature",
			"NamesPanelEnemyPlayerNames",
			"NamesPanelEnemyPets",
			"NamesPanelEnemyGuardians",
			"NamesPanelEnemyTotems",
			"NamesPanelUnitNameplatesEnemyPets",
			"NamesPanelUnitNameplatesEnemies",
			"NamesPanelUnitNameplatesEnemyGuardians",
			"NamesPanelUnitNameplatesEnemyTotems",
			-- Combat Text
			"CombatTextPanelTargetDamage",
			"CombatTextPanelPeriodicDamage",
			"CombatTextPanelPetDamage",
			"CombatTextPanelHealing",
			"CombatTextPanelTargetEffects",
			"CombatTextPanelOtherTargetEffects",
			"CombatTextPanelEnableFCT",
			"CombatTextPanelDodgeParryMiss",
			"CombatTextPanelDamageReduction",
			"CombatTextPanelRepChanges",
			"CombatTextPanelReactiveAbilities",
			"CombatTextPanelFriendlyHealerNames",
			"CombatTextPanelCombatState",
			"CombatTextPanelComboPoints",
			"CombatTextPanelLowManaHealth",
			"CombatTextPanelEnergyGains",
			"CombatTextPanelPeriodicEnergyGains",
			"CombatTextPanelHonorGains",
			"CombatTextPanelAuras",
			"CombatTextPanelAutoSelfCast",
			-- Buffs & Debuffs
			"BuffsPanelBuffDurations",
			"BuffsPanelDispellableDebuffs",
			"BuffsPanelCastableBuffs",
			"BuffsPanelShowCastableDebuffs",
			-- Camera
			"CameraPanelFollowTerrain",
			"CameraPanelHeadBob",
			"CameraPanelWaterCollision",
			"CameraPanelSmartPivot",
			-- Mouse
			"MousePanelInvertMouse",
			"MousePanelClickToMove",
			"MousePanelWoWMouse",
			-- Help
			"HelpPanelShowTutorials",
			"HelpPanelLoadingScreenTips",
			"HelpPanelEnhancedTooltips",
			"HelpPanelBeginnerTooltips",
			"HelpPanelShowLuaErrors",
			"HelpPanelColorblindMode",
			"HelpPanelMovePad",
			"BattlenetPanelOnlineFriends",
			"BattlenetPanelOfflineFriends",
			"BattlenetPanelOnlineFriendsBroadcasts",
			"BattlenetPanelOnlineFriendsFriendRequests",
			"BattlenetPanelOnlineFriendsConversations",
			"BattlenetPanelOnlineFriendsShowToastWindow",
			}
			for i = 1, getn(interfacecheckbox) do
				local icheckbox = _G["InterfaceOptions"..interfacecheckbox[i]]
				if icheckbox then
					T.SkinCheckBox(icheckbox)
				end
			end
			
			local interfacedropdown ={
			-- Controls
			"ControlsPanelAutoLootKeyDropDown",
			-- Combat
			"CombatPanelTOTDropDown",
			"CombatPanelFocusCastKeyDropDown",
			"CombatPanelSelfCastKeyDropDown",
			-- Display
			"DisplayPanelAggroWarningDisplay",
			"DisplayPanelWorldPVPObjectiveDisplay",
			-- Social
			"SocialPanelChatStyle",
			"SocialPanelWhisperMode",
			"SocialPanelTimestamps",
			"SocialPanelBnWhisperMode",
			-- Action bars
			"ActionBarsPanelPickupActionKeyDropDown",
			-- Names
			"NamesPanelNPCNamesDropDown",
			"NamesPanelUnitNameplatesMotionDropDown",
			-- Combat Text
			"CombatTextPanelFCTDropDown",
			-- Camera
			"CameraPanelStyleDropDown",
			-- Mouse
			"MousePanelClickMoveStyleDropDown",
			"LanguagesPanelLocaleDropDown",
			}
			for i = 1, getn(interfacedropdown) do
				local idropdown = _G["InterfaceOptions"..interfacedropdown[i]]
				if idropdown then
					T.SkinDropDownBox(idropdown)
					DropDownList1:SetTemplate("Transparent")
				end
			end
			T.SkinButton(InterfaceOptionsHelpPanelResetTutorials)
			
			local optioncheckbox = {
			-- Advanced
			"Advanced_MaxFPSCheckBox",
			"Advanced_MaxFPSBKCheckBox",
			-- Audio
			"AudioOptionsSoundPanelEnableSound",
			"AudioOptionsSoundPanelSoundEffects",
			"AudioOptionsSoundPanelErrorSpeech",
			"AudioOptionsSoundPanelEmoteSounds",
			"AudioOptionsSoundPanelPetSounds",
			"AudioOptionsSoundPanelMusic",
			"AudioOptionsSoundPanelLoopMusic",
			"AudioOptionsSoundPanelAmbientSounds",
			"AudioOptionsSoundPanelSoundInBG",
			"AudioOptionsSoundPanelReverb",
			"AudioOptionsSoundPanelHRTF",
			"AudioOptionsSoundPanelEnableDSPs",
			"AudioOptionsSoundPanelUseHardware",
			"AudioOptionsVoicePanelEnableVoice",
			"AudioOptionsVoicePanelEnableMicrophone",
			"AudioOptionsVoicePanelPushToTalkSound",
			-- Network
			"NetworkOptionsPanelOptimizeSpeed",
			"NetworkOptionsPanelUseIPv6",
			}
			for i = 1, getn(optioncheckbox) do
				local ocheckbox = _G[optioncheckbox[i]]
				if ocheckbox then
					T.SkinCheckBox(ocheckbox)
				end
			end

			local optiondropdown = {
			-- Graphics
			"Graphics_DisplayModeDropDown",
			"Graphics_ResolutionDropDown",
			"Graphics_RefreshDropDown",
			"Graphics_PrimaryMonitorDropDown",
			"Graphics_MultiSampleDropDown",
			"Graphics_VerticalSyncDropDown",
			"Graphics_TextureResolutionDropDown",
			"Graphics_FilteringDropDown",
			"Graphics_ProjectedTexturesDropDown",
			"Graphics_ViewDistanceDropDown",
			"Graphics_EnvironmentalDetailDropDown",
			"Graphics_GroundClutterDropDown",
			"Graphics_ShadowsDropDown",
			"Graphics_LiquidDetailDropDown",
			"Graphics_SunshaftsDropDown",
			"Graphics_ParticleDensityDropDown",
			-- Advanced
			"Advanced_BufferingDropDown",
			"Advanced_LagDropDown",
			"Advanced_HardwareCursorDropDown",
			"Advanced_GraphicsAPIDropDown",
			-- Audio
			"AudioOptionsSoundPanelHardwareDropDown",
			"AudioOptionsSoundPanelSoundChannelsDropDown",
			"AudioOptionsVoicePanelInputDeviceDropDown",
			"AudioOptionsVoicePanelChatModeDropDown",
			"AudioOptionsVoicePanelOutputDeviceDropDown",
			}
			for i = 1, getn(optiondropdown) do
				local odropdown = _G[optiondropdown[i]]
				if odropdown then
					T.SkinDropDownBox(odropdown,165)
					DropDownList1:SetTemplate("Transparent")
				end
			end
	local buttons = {
	    "RecordLoopbackSoundButton",
	    "PlayLoopbackSoundButton",
	    "AudioOptionsVoicePanelChatMode1KeyBindingButton",
	}

	for _, button in pairs(buttons) do
		T.SkinButton(_G[button])
	end	
		
	AudioOptionsVoicePanelChatMode1KeyBindingButton:ClearAllPoints()
	AudioOptionsVoicePanelChatMode1KeyBindingButton:Point("CENTER", AudioOptionsVoicePanelBinding, "CENTER", 0, -10)
	
	local slides = {
	-------- >> Interface
	-- Combat
	"InterfaceOptionsCombatPanelSpellAlertOpacitySlider",
	"InterfaceOptionsCombatPanelMaxSpellStartRecoveryOffset",
	-- Battle.net
	"InterfaceOptionsBattlenetPanelToastDurationSlider",
	-- Camera
	"InterfaceOptionsCameraPanelMaxDistanceSlider",
	"InterfaceOptionsCameraPanelFollowSpeedSlider",
	-- Mouse
	"InterfaceOptionsMousePanelMouseSensitivitySlider",
	"InterfaceOptionsMousePanelMouseLookSpeedSlider",
	--------- >> Options
	-- Advanced
	"Advanced_MaxFPSSlider",
	"Advanced_MaxFPSBKSlider",
	-- Audio
	"AudioOptionsSoundPanelSoundQuality",
	"AudioOptionsSoundPanelMasterVolume",
	"AudioOptionsSoundPanelSoundVolume",
	"AudioOptionsSoundPanelMusicVolume",
	"AudioOptionsSoundPanelAmbienceVolume",
	-- Voice
	"AudioOptionsVoicePanelMicrophoneVolume",
	"AudioOptionsVoicePanelSpeakerVolume",
	"AudioOptionsVoicePanelSoundFade",
	"AudioOptionsVoicePanelMusicFade",
	"AudioOptionsVoicePanelAmbienceFade",
    }
	
	for i = 1, getn(slides) do
	    if _G[slides[i]] then
		    if _G[slides[i]] ~= AudioOptionsSoundPanelSoundVolume then
			    T.SkinSlideBar(_G[slides[i]],8,true)
		    else
			    T.SkinSlideBar(_G[slides[i]],8)
		    end
	    end
    end
	-- Graphics_Quality is not like the other sliders
	Graphics_Quality:SetScript("OnUpdate", function(self)
	    T.SkinSlideBar(Graphics_Quality,11)
    end)
	Graphics_RightQuality:SetAlpha(0) -- Graphics Quality Slide background =O
	-- Graphics_Quality Values
	Graphics_QualityLow2:Point("BOTTOM",0,-20)
	Graphics_QualityFair:Point("BOTTOM",0,-20)
	Graphics_RightQualityLabel:Point("TOP",0,16)
	Graphics_QualityMed:Point("BOTTOM",0,-20)
	Graphics_QualityHigh2:Point("BOTTOM",0,-20)
	Graphics_QualityUltra:Point("BOTTOM",0,-20)
end

tinsert(T.SkinFuncs["Tukui"], LoadSkin)