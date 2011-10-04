local T, C, L = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales

local pWidth, pHeight = C.databars.settings.width, C.databars.settings.height
for i = 1, #T.databars do
	if not T.databars[i]:IsShown() then
		T.databars[i]:SetHeight(C.databars.settings.padding)
	end
end