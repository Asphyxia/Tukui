local T, C, L = unpack(select(2, ...))

local function LoadSkin()
	local buttons = {
		"KeyBindingFrameDefaultButton",
		"KeyBindingFrameUnbindButton",
		"KeyBindingFrameOkayButton",
		"KeyBindingFrameCancelButton",
	}
	
	for _, v in pairs(buttons) do
		_G[v]:StripTextures()
		_G[v]:SetTemplate("Transparent", true)
	end
	
	T.SkinCheckBox(KeyBindingFrameCharacterButton)
	KeyBindingFrameHeaderText:ClearAllPoints()
	T.SkinScrollBar(KeyBindingFrameScrollFrameScrollBar)
	KeyBindingFrameHeaderText:Point("TOP", KeyBindingFrame, "TOP", 0, -4)
	KeyBindingFrame:StripTextures()
	KeyBindingFrame:SetTemplate("Transparent")
	
	for i = 1, KEY_BINDINGS_DISPLAYED  do
		local button1 = _G["KeyBindingFrameBinding"..i.."Key1Button"]
		local button2 = _G["KeyBindingFrameBinding"..i.."Key2Button"]
		button1:StripTextures(true)
		button1:StyleButton(false)
		button1:SetTemplate("Transparent", true)
		button2:StripTextures(true)
		button2:StyleButton(false)
		button2:SetTemplate("Transparent", true)
	end
	
	KeyBindingFrameUnbindButton:Point("RIGHT", KeyBindingFrameOkayButton, "LEFT", -3, 0)
	KeyBindingFrameOkayButton:Point("RIGHT", KeyBindingFrameCancelButton, "LEFT", -3, 0)
end

T.SkinFuncs["Blizzard_BindingUI"] = LoadSkin