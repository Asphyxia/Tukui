local T, C, L = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales
if not C["actionbar"].enable == true or not T.lowversion then return end

if C.actionbar.bgPanel then
	TukuiBar5:SetWidth((T.buttonsize * 3) + (T.buttonspacing * 4))
else
	TukuiBar5:SetWidth((T.buttonsize * 3) + (T.buttonspacing * 2))
end
local bar = TukuiBar6
bar:SetAlpha(1)
MultiBarBottomLeft:SetParent(bar)

-- setup the bar
for i=1, 12 do
	local b = _G["MultiBarBottomLeftButton"..i]
	local b2 = _G["MultiBarBottomLeftButton"..i-1]
	b:SetSize(T.buttonsize, T.buttonsize)
	b:ClearAllPoints()
	b:SetFrameStrata("BACKGROUND")
	b:SetFrameLevel(15)
	
	if i == 1 then
		b:SetPoint("TOPLEFT", bar, T.buttonoffset, -T.buttonoffset)
	else
		b:SetPoint("TOP", b2, "BOTTOM", 0, -T.buttonspacing)
	end
end