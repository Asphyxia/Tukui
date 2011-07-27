local T, C, L = unpack(select(2, ...))

local function LoadSkin()
	OpacityFrame:StripTextures()
	OpacityFrame:SetTemplate("Transparent")
end

tinsert(T.SkinFuncs["Tukui"], LoadSkin)