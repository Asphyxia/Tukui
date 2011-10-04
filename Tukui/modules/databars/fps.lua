local T, C, L = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales
local ADDON_NAME, ns = ...
local oUF = ns.oUF or oUF

ns._Objects = {}
ns._Headers = {}

if not C["databars"].framerate or C["databars"].framerate == 0 then return end
local barNum = C["databars"].framerate

T.databars[barNum]:Show()

local Stat = CreateFrame("Frame", nil, T.databars[barNum])
Stat:EnableMouse(true)
Stat:SetFrameStrata("BACKGROUND")
Stat:SetFrameLevel(4)

local StatusBar = T.databars[barNum].statusbar
local Text = T.databars[barNum].text

local int = 1
local function Update(self, t)
	int = int - t
	if int < 0 then
		local fps = floor(GetFramerate())
		Text:SetText(fps..T.datacolor.." FPS")
		StatusBar:SetMinMaxValues(0, GetCVar("maxFPS"))
		StatusBar:SetValue(fps)
		self:SetAllPoints(T.databars[barNum])
		if fps > 50 then
			StatusBar:SetStatusBarColor( 30 / 255, 1, 30 / 255 , .8 )
		elseif fps > 45 then
			StatusBar:SetStatusBarColor( 1, 180 / 255, 0, .8 )
		else
			StatusBar:SetStatusBarColor( 1, 75 / 255, 75 / 255, 0.5, .8 )
		end
		int = 1
	end	
end
Stat:SetScript("OnUpdate", Update) 
Update(Stat, 10)