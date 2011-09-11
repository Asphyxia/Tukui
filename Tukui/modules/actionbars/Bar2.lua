local T, C, L = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales

if not C["actionbar"].enable == true then return end

---------------------------------------------------------------------------
-- setup MultiBarBottomLeft as bar #2
---------------------------------------------------------------------------

local bar = TukuiBar2
MultiBarBottomLeft:SetParent(bar)

-- setup the bar
for i=1, 12 do
	local b = _G["MultiBarBottomLeftButton"..i]
	local b2 = _G["MultiBarBottomLeftButton"..i-1]
	b:Size(T.buttonsize, T.buttonsize)
	b:ClearAllPoints()
	b:SetFrameStrata("BACKGROUND")
	b:SetFrameLevel(15)
	
	if C["actionbar"].mainswap then
		if i == 1 then
			b:Point("TOP", ActionButton1, "BOTTOM", 0, -T.buttonspacing)
		else
			b:Point("LEFT", b2, "RIGHT", T.buttonspacing, 0)
		end
	else
		if i == 1 then
			b:Point("BOTTOM", ActionButton1, "TOP", 0, T.buttonspacing)
		else
			b:Point("LEFT", b2, "RIGHT", T.buttonspacing, 0)
		end
	end
end