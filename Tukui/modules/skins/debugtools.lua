local T, C, L = unpack(select(2, ...))

local function LoadSkin()
	local noscalemult = T.mult * C["general"].uiscale
	local bg = {
	  bgFile = C["media"].blank, 
	  edgeFile = C["media"].blank, 
	  tile = false, tileSize = 0, edgeSize = noscalemult, 
	  insets = { left = -noscalemult, right = -noscalemult, top = -noscalemult, bottom = -noscalemult}
	}
	
	ScriptErrorsFrame:SetBackdrop(bg)
	ScriptErrorsFrame:SetBackdropColor(unpack(C.media.backdropcolor))
	ScriptErrorsFrame:SetBackdropBorderColor(unpack(C.media.bordercolor))	

	EventTraceFrame:SetTemplate("Default")
	
	local texs = {
		"TopLeft",
		"TopRight",
		"Top",
		"BottomLeft",
		"BottomRight",
		"Bottom",
		"Left",
		"Right",
		"TitleBG",
		"DialogBG",
	}
	
	for i=1, #texs do
		_G["ScriptErrorsFrame"..texs[i]]:SetTexture(nil)
		_G["EventTraceFrame"..texs[i]]:SetTexture(nil)
	end
	
	local bg = {
	  bgFile = C["media"].normTex, 
	  edgeFile = C["media"].blank, 
	  tile = false, tileSize = 0, edgeSize = noscalemult, 
	  insets = { left = -noscalemult, right = -noscalemult, top = -noscalemult, bottom = -noscalemult}
	}
	
	for i=1, ScriptErrorsFrame:GetNumChildren() do
		local child = select(i, ScriptErrorsFrame:GetChildren())
		if child:GetObjectType() == "Button" and not child:GetName() then
			
			T.SkinButton(child)
			child:SetBackdrop(bg)
			child:SetBackdropColor(unpack(C.media.backdropcolor))
			child:SetBackdropBorderColor(unpack(C.media.bordercolor))	
		end
	end	
end

T.SkinFuncs["Blizzard_DebugTools"] = LoadSkin