local T, C, L = unpack(select(2, ...))

local function LoadSkin()
	QuestFrame:StripTextures(true)
	QuestFrameDetailPanel:StripTextures(true)
	QuestDetailScrollFrame:StripTextures(true)
	QuestDetailScrollChildFrame:StripTextures(true)
	QuestRewardScrollFrame:StripTextures(true)
	QuestRewardScrollChildFrame:StripTextures(true)
	QuestFrameProgressPanel:StripTextures(true)
	QuestFrameRewardPanel:StripTextures(true)
	QuestFrame:CreateBackdrop("Default")
	QuestFrame.backdrop:Point("TOPLEFT", 6, -8)
	QuestFrame.backdrop:Point("BOTTOMRIGHT", -20, 65)
	QuestFrame.backdrop:CreateShadow("Default")
	T.SkinButton(QuestFrameAcceptButton, true)
	T.SkinButton(QuestFrameDeclineButton, true)
	T.SkinButton(QuestFrameCompleteButton, true)
	T.SkinButton(QuestFrameGoodbyeButton, true)
	T.SkinButton(QuestFrameCompleteQuestButton, true)
	T.SkinCloseButton(QuestFrameCloseButton, QuestFrame.backdrop)

	for i=1, 6 do
		local button = _G["QuestProgressItem"..i]
		local texture = _G["QuestProgressItem"..i.."IconTexture"]
		button:StripTextures()
		button:StyleButton()
		button:Width(_G["QuestProgressItem"..i]:GetWidth() - 4)
		button:SetFrameLevel(button:GetFrameLevel() + 2)
		texture:SetTexCoord(.08, .92, .08, .92)
		texture:SetDrawLayer("OVERLAY")
		texture:Point("TOPLEFT", 2, -2)
		texture:Size(texture:GetWidth() - 2, texture:GetHeight() - 2)
		_G["QuestProgressItem"..i.."Count"]:SetDrawLayer("OVERLAY")
		button:SetTemplate("Default")				
	end

	hooksecurefunc("QuestFrameProgressItems_Update", function()
		QuestProgressTitleText:SetTextColor(1, 1, 0)
		QuestProgressText:SetTextColor(1, 1, 1)
		QuestProgressRequiredItemsText:SetTextColor(1, 1, 0)
		QuestProgressRequiredMoneyText:SetTextColor(1, 1, 0)
	end)

	QuestNPCModel:StripTextures()
	QuestNPCModel:CreateBackdrop("Default")
	QuestNPCModel:Point("TOPLEFT", QuestLogDetailFrame, "TOPRIGHT", 4, -34)
	QuestNPCModelTextFrame:StripTextures()
	QuestNPCModelTextFrame:CreateBackdrop("Default")
	QuestNPCModelTextFrame.backdrop:Point("TOPLEFT", QuestNPCModel.backdrop, "BOTTOMLEFT", 0, -2)
	QuestLogDetailFrame:StripTextures()
	QuestLogDetailFrame:SetTemplate("Default")
	QuestLogDetailScrollFrame:StripTextures()
	T.SkinCloseButton(QuestLogDetailFrameCloseButton)

	hooksecurefunc("QuestFrame_ShowQuestPortrait", function(parentFrame, portrait, text, name, x, y)
		QuestNPCModel:ClearAllPoints();
		QuestNPCModel:SetPoint("TOPLEFT", parentFrame, "TOPRIGHT", x + 18, y);			
	end)
end

tinsert(T.SkinFuncs["Tukui"], LoadSkin)