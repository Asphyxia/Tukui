local T, C, L = unpack(select(2, ...)) -- Import Functions/Constants, Config, Locales

T.SkinFuncs = {}
T.SkinFuncs["Tukui"] = {}

function T.SetModifiedBackdrop(self)
	local color = RAID_CLASS_COLORS[T.myclass]
	self:SetBackdropColor(color.r*.15, color.g*.15, color.b*.15)
	self:SetBackdropBorderColor(color.r, color.g, color.b)
end

function T.SetOriginalBackdrop(self)
	self:SetTemplate("Transparent")
end

function T.SkinButton(f, strip)
	if f:GetName() then
		local l = _G[f:GetName().."Left"]
		local m = _G[f:GetName().."Middle"]
		local r = _G[f:GetName().."Right"]
		
		
		if l then l:SetAlpha(0) end
		if m then m:SetAlpha(0) end
		if r then r:SetAlpha(0) end
	end

	if f.SetNormalTexture then f:SetNormalTexture("") end
	
	if f.SetHighlightTexture then f:SetHighlightTexture("") end
	
	if f.SetPushedTexture then f:SetPushedTexture("") end
	
	if f.SetDisabledTexture then f:SetDisabledTexture("") end
	
	if strip then f:StripTextures() end
	
	f:SetTemplate("Transparent")
	f:HookScript("OnEnter", T.SetModifiedBackdrop)
	f:HookScript("OnLeave", T.SetOriginalBackdrop)
end

function T.SkinScrollBar(frame, thumbTrim)
	if _G[frame:GetName().."BG"] then _G[frame:GetName().."BG"]:SetTexture(nil) end
	if _G[frame:GetName().."Track"] then _G[frame:GetName().."Track"]:SetTexture(nil) end
	
	if _G[frame:GetName().."Top"] then
		_G[frame:GetName().."Top"]:SetTexture(nil)
		_G[frame:GetName().."Bottom"]:SetTexture(nil)
		_G[frame:GetName().."Middle"]:SetTexture(nil)
	end
	
	if _G[frame:GetName().."ScrollUpButton"] and _G[frame:GetName().."ScrollDownButton"] then
		_G[frame:GetName().."ScrollUpButton"]:StripTextures()
		_G[frame:GetName().."ScrollUpButton"]:SetTemplate("Transparent", true)
		_G[frame:GetName().."ScrollUpButton"]:HookScript('OnEnter', T.SetModifiedBackdrop)
		_G[frame:GetName().."ScrollUpButton"]:HookScript('OnLeave', T.SetOriginalBackdrop)		
		if not _G[frame:GetName().."ScrollUpButton"].texture then
			_G[frame:GetName().."ScrollUpButton"].texture = _G[frame:GetName().."ScrollUpButton"]:CreateTexture(nil, 'OVERLAY')
			_G[frame:GetName().."ScrollUpButton"].texture:Point("TOPLEFT", 2, -2)
			_G[frame:GetName().."ScrollUpButton"].texture:Point("BOTTOMRIGHT", -2, 2)
			_G[frame:GetName().."ScrollUpButton"].texture:SetTexture([[Interface\AddOns\Tukui\medias\textures\arrowup.tga]])
			_G[frame:GetName().."ScrollUpButton"].texture:SetVertexColor(unpack(C["media"].bordercolor))
		end
		_G[frame:GetName().."ScrollUpButton"]:HookScript('OnEnter', function(self)
			local color = RAID_CLASS_COLORS[T.myclass]
			self.texture:SetVertexColor(color.r, color.g, color.b)	
		end)	
		_G[frame:GetName().."ScrollUpButton"]:HookScript('OnLeave', function(self)
			self.texture:SetVertexColor(unpack(C["media"].bordercolor)) 
		end)		

		_G[frame:GetName().."ScrollDownButton"]:StripTextures()
		_G[frame:GetName().."ScrollDownButton"]:SetTemplate("Transparent", true)
		_G[frame:GetName().."ScrollDownButton"]:HookScript('OnEnter', T.SetModifiedBackdrop)
		_G[frame:GetName().."ScrollDownButton"]:HookScript('OnLeave', T.SetOriginalBackdrop)		
		if not _G[frame:GetName().."ScrollDownButton"].texture then
			_G[frame:GetName().."ScrollDownButton"].texture = _G[frame:GetName().."ScrollDownButton"]:CreateTexture(nil, 'OVERLAY')
			_G[frame:GetName().."ScrollDownButton"].texture:Point("TOPLEFT", 2, -2)
			_G[frame:GetName().."ScrollDownButton"].texture:Point("BOTTOMRIGHT", -2, 2)
			_G[frame:GetName().."ScrollDownButton"].texture:SetTexture([[Interface\AddOns\Tukui\medias\textures\arrowdown.tga]])
			_G[frame:GetName().."ScrollDownButton"].texture:SetVertexColor(unpack(C["media"].bordercolor))
		end

		_G[frame:GetName().."ScrollDownButton"]:HookScript('OnEnter', function(self)
			local color = RAID_CLASS_COLORS[T.myclass]
			self.texture:SetVertexColor(color.r, color.g, color.b)	
		end)	
		_G[frame:GetName().."ScrollDownButton"]:HookScript('OnLeave', function(self)
			self.texture:SetVertexColor(unpack(C["media"].bordercolor)) 
		end)				

		if not frame.trackbg then
			frame.trackbg = CreateFrame("Frame", nil, frame)
			frame.trackbg:Point("TOPLEFT", _G[frame:GetName().."ScrollUpButton"], "BOTTOMLEFT", 0, -1)
			frame.trackbg:Point("BOTTOMRIGHT", _G[frame:GetName().."ScrollDownButton"], "TOPRIGHT", 0, 1)
			frame.trackbg:SetTemplate("Transparent")
		end

		if frame:GetThumbTexture() then
			if not thumbTrim then thumbTrim = 3 end
			frame:GetThumbTexture():SetTexture(nil)
			if not frame.thumbbg then
				frame.thumbbg = CreateFrame("Frame", nil, frame)
				frame.thumbbg:Point("TOPLEFT", frame:GetThumbTexture(), "TOPLEFT", 2, -thumbTrim)
				frame.thumbbg:Point("BOTTOMRIGHT", frame:GetThumbTexture(), "BOTTOMRIGHT", -2, thumbTrim)
				frame.thumbbg:SetTemplate("Transparent", true)
				if frame.trackbg then
					frame.thumbbg:SetFrameLevel(frame.trackbg:GetFrameLevel())
				end
			end
		end
	end
end

function T.SkinSlideBar(frame,height,movetext)

	frame:SetTemplate("Transparent")
	frame:SetBackdropColor(0,0,0,.8)

	if not height then height = frame:GetHeight() end
	frame:Height(height)

	if movetext then
		if _G[frame:GetName().."Low"] then _G[frame:GetName().."Low"]:Point("BOTTOM",0,-18) end
		if _G[frame:GetName().."High"] then _G[frame:GetName().."High"]:Point("BOTTOM",0,-18) end
		if _G[frame:GetName().."Text"] then _G[frame:GetName().."Text"]:Point("TOP",0,19) end
	end

	if _G[frame:GetName().."Thumb"] then
		_G[frame:GetName().."Thumb"]:SetTexture([[Interface\AddOns\Tukui\medias\textures\blank.tga]])
		_G[frame:GetName().."Thumb"]:SetVertexColor(unpack(C["media"].bordercolor))
		_G[frame:GetName().."Thumb"]:Size(height-4,height+4)
	end
end

--Tab Regions
local tabs = {
	"LeftDisabled",
	"MiddleDisabled",
	"RightDisabled",
	"Left",
	"Middle",
	"Right",
}

function T.SkinTab(tab)
	if not tab then return end
	for _, object in pairs(tabs) do
		local tex = _G[tab:GetName()..object]
		if tex then
			tex:SetTexture(nil)
		end
	end
	
	if tab.GetHighlightTexture and tab:GetHighlightTexture() then
		tab:GetHighlightTexture():SetTexture(nil)
	else
		tab:StripTextures()
	end
	
	tab.backdrop = CreateFrame("Frame", nil, tab)
	tab.backdrop:SetTemplate("Transparent")
	tab.backdrop:SetFrameLevel(tab:GetFrameLevel() - 1)
	tab.backdrop:Point("TOPLEFT", 10, -3)
	tab.backdrop:Point("BOTTOMRIGHT", -10, 3)

	-- always set tab text centered
	local name = tab:GetName()
	_G[name.."Text"]:ClearAllPoints()
	_G[name.."Text"]:SetPoint("TOP", name, 0, -11)
end

function T.SkinNextPrevButton(btn, horizonal)
	btn:SetTemplate("Transparent")
	btn:Size(btn:GetWidth() - 7, btn:GetHeight() - 7)	
	
	if horizonal then
		btn:GetNormalTexture():SetTexCoord(0.3, 0.29, 0.3, 0.72, 0.65, 0.29, 0.65, 0.72)
		btn:GetPushedTexture():SetTexCoord(0.3, 0.35, 0.3, 0.8, 0.65, 0.35, 0.65, 0.8)
		btn:GetDisabledTexture():SetTexCoord(0.3, 0.29, 0.3, 0.75, 0.65, 0.29, 0.65, 0.75)	
	else
		btn:GetNormalTexture():SetTexCoord(0.3, 0.29, 0.3, 0.81, 0.65, 0.29, 0.65, 0.81)
		if btn:GetPushedTexture() then
			btn:GetPushedTexture():SetTexCoord(0.3, 0.35, 0.3, 0.81, 0.65, 0.35, 0.65, 0.81)
		end
		if btn:GetDisabledTexture() then
			btn:GetDisabledTexture():SetTexCoord(0.3, 0.29, 0.3, 0.75, 0.65, 0.29, 0.65, 0.75)
		end
	end
	
	btn:GetNormalTexture():ClearAllPoints()
	btn:GetNormalTexture():Point("TOPLEFT", 2, -2)
	btn:GetNormalTexture():Point("BOTTOMRIGHT", -2, 2)
	if btn:GetDisabledTexture() then
		btn:GetDisabledTexture():SetAllPoints(btn:GetNormalTexture())
	end
	if btn:GetPushedTexture() then
		btn:GetPushedTexture():SetAllPoints(btn:GetNormalTexture())
	end
	btn:GetHighlightTexture():SetTexture(1, 1, 1, 0.3)
	btn:GetHighlightTexture():SetAllPoints(btn:GetNormalTexture())
end

function T.SkinRotateButton(btn)
	btn:SetTemplate("Transparent")
	btn:Size(btn:GetWidth() - 14, btn:GetHeight() - 14)	
	
	btn:GetNormalTexture():SetTexCoord(0.3, 0.29, 0.3, 0.65, 0.69, 0.29, 0.69, 0.65)
	btn:GetPushedTexture():SetTexCoord(0.3, 0.29, 0.3, 0.65, 0.69, 0.29, 0.69, 0.65)	
	
	btn:GetHighlightTexture():SetTexture(1, 1, 1, 0.3)
	
	btn:GetNormalTexture():ClearAllPoints()
	btn:GetNormalTexture():Point("TOPLEFT", 2, -2)
	btn:GetNormalTexture():Point("BOTTOMRIGHT", -2, 2)
	btn:GetPushedTexture():SetAllPoints(btn:GetNormalTexture())	
	btn:GetHighlightTexture():SetAllPoints(btn:GetNormalTexture())
end

function T.SkinEditBox(frame)
	if _G[frame:GetName().."Left"] then _G[frame:GetName().."Left"]:Kill() end
	if _G[frame:GetName().."Middle"] then _G[frame:GetName().."Middle"]:Kill() end
	if _G[frame:GetName().."Right"] then _G[frame:GetName().."Right"]:Kill() end
	if _G[frame:GetName().."Mid"] then _G[frame:GetName().."Mid"]:Kill() end
	frame:CreateBackdrop("Transparent")
	
	if frame:GetName() and frame:GetName():find("Silver") or frame:GetName():find("Copper") then
		frame.backdrop:Point("BOTTOMRIGHT", -12, -2)
	end
end

function T.SkinDropDownBox(frame, width)
	local button = _G[frame:GetName().."Button"]
	if not width then width = 155 end
	
	frame:StripTextures()
	frame:Width(width)
	
	_G[frame:GetName().."Text"]:ClearAllPoints()
	_G[frame:GetName().."Text"]:Point("RIGHT", button, "LEFT", -2, 0)

	
	button:ClearAllPoints()
	button:Point("RIGHT", frame, "RIGHT", -10, 3)
	button.SetPoint = T.dummy
	
	T.SkinNextPrevButton(button, true)
	
	frame:CreateBackdrop("Transparent")
	frame.backdrop:Point("TOPLEFT", 20, -2)
	frame.backdrop:Point("BOTTOMRIGHT", button, "BOTTOMRIGHT", 2, -2)
end

function T.SkinCheckBox(frame)
	frame:StripTextures()
	frame:CreateBackdrop("Transparent")
	frame.backdrop:Point("TOPLEFT", 4, -4)
	frame.backdrop:Point("BOTTOMRIGHT", -4, 4)
	
	if frame.SetCheckedTexture then
		frame:SetCheckedTexture("Interface\\Buttons\\UI-CheckBox-Check")
	end
	
	if frame.SetDisabledTexture then
		frame:SetDisabledTexture("Interface\\Buttons\\UI-CheckBox-Check-Disabled")
	end
	
	frame.SetNormalTexture = T.dummy
	frame.SetPushedTexture = T.dummy
	frame.SetHighlightTexture = T.dummy
end

function T.SkinCloseButton(f, point)
	for i=1, f:GetNumRegions() do
		local region = select(i, f:GetRegions())
		if region:GetObjectType() == "Texture" then
			region:SetDesaturated(1)
			
			if region:GetTexture() == "Interface\\DialogFrame\\UI-DialogBox-Corner" then
				region:Kill()
			end
		end
	end	
	
	if point then
		f:Point("TOPRIGHT", point, "TOPRIGHT", 2, 2)
	end
end

local LoadBlizzardSkin = CreateFrame("Frame")
LoadBlizzardSkin:RegisterEvent("ADDON_LOADED")
LoadBlizzardSkin:SetScript("OnEvent", function(self, event, addon)
	if IsAddOnLoaded("Skinner") or IsAddOnLoaded("Aurora") or not C.general.blizzardreskin then
		self:UnregisterEvent("ADDON_LOADED")
		return 
	end
	
	for _addon, skinfunc in pairs(T.SkinFuncs) do
		if type(skinfunc) == "function" then
			if _addon == addon then
				if skinfunc then
					skinfunc()
				end
			end
		elseif type(skinfunc) == "table" then
			if _addon == addon then
				for _, skinfunc in pairs(T.SkinFuncs[_addon]) do
					if skinfunc then
						skinfunc()
					end
				end
			end
		end
	end
end)