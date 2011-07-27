local T, C, L = unpack(select(2, ...))

local function LoadSkin()
	T.SkinButton(GhostFrame)
	GhostFrame:SetBackdropColor(0,0,0,0)
	GhostFrame:SetBackdropBorderColor(0,0,0,0)
	GhostFrame.SetBackdropColor = T.dummy
	GhostFrame.SetBackdropBorderColor = T.dummy
	GhostFrame:ClearAllPoints()
	GhostFrame:SetPoint("TOP", UIParent, "TOP", 0, -100)
	T.SkinButton(GhostFrameContentsFrame)
	GhostFrameContentsFrameIcon:SetTexture(nil)

	local x = CreateFrame("Frame", nil, GhostFrame)
	x:SetFrameStrata("MEDIUM")
	x:SetTemplate("Transparent")
	x:SetPoint("TOPLEFT", GhostFrameContentsFrameIcon, "TOPLEFT", -2, 2)
	x:SetPoint("BOTTOMRIGHT", GhostFrameContentsFrameIcon, "BOTTOMRIGHT", 2, -2)

	local tex = x:CreateTexture(nil, "OVERLAY")
	tex:SetTexture("Interface\\Icons\\spell_holy_guardianspirit")
	tex:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	tex:SetPoint("TOPLEFT", x, "TOPLEFT", 2, -2)
	tex:SetPoint("BOTTOMRIGHT", x, "BOTTOMRIGHT", -2, 2)
end

tinsert(T.SkinFuncs["Tukui"], LoadSkin)