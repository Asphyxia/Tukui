local T, C, L = unpack(select(2, ...))

local function LoadSkin()
	TutorialFrame:StripTextures()
	TutorialFrame:CreateBackdrop("Transparent")
	TutorialFrame.backdrop:CreateShadow("Transparent")
	TutorialFrame.backdrop:Point("TOPLEFT", 6, 0)
	TutorialFrame.backdrop:Point("BOTTOMRIGHT", 6, -6)
	T.SkinCloseButton(TutorialFrameCloseButton, TutorialFrameCloseButton.backdrop)
	T.SkinNextPrevButton(TutorialFramePrevButton)
	T.SkinNextPrevButton(TutorialFrameNextButton)
	T.SkinButton(TutorialFrameOkayButton)
	TutorialFrameOkayButton:ClearAllPoints()
	TutorialFrameOkayButton:Point("LEFT", TutorialFrameNextButton,"RIGHT", 10, 0)	
end

tinsert(T.SkinFuncs["Tukui"], LoadSkin)