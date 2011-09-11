local T, C, L = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales

if not C["actionbar"].enable == true then return end

---------------------------------------------------------------------------
-- setup MultiBarBottomRight as bar #5
---------------------------------------------------------------------------

local bar = TukuiBar4
MultiBarBottomRight:SetParent(bar)

for i= 1, 12 do
	local b = _G["MultiBarBottomRightButton"..i]
	local b2 = _G["MultiBarBottomRightButton"..i-1]
	b:Size(T.buttonsize, T.buttonsize)
	b:ClearAllPoints()
	b:SetFrameStrata("BACKGROUND")
	b:SetFrameLevel(15)
	
	if i == 1 then
		if C["actionbar"].vertical_rightbars == true then
			b:Point("TOPRIGHT", _G["MultiBarRightButton1"], "TOPLEFT", -T.buttonspacing, 0)
		else
			b:Point("BOTTOMLEFT", _G["MultiBarRightButton1"], "TOPLEFT", 0, T.buttonspacing)
		end
	else
		if C["actionbar"].vertical_rightbars == true then
			b:Point("TOP", b2, "BOTTOM", 0, -T.buttonspacing)
		else
			b:Point("LEFT", b2, "RIGHT", T.buttonspacing, 0)
		end
	end
end