local T, C, L = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales

local pWidth, pHeight = C.databars.settings.width, C.databars.settings.height
T["databars"] = {}

T.maxDatabars = 0
for i,v in pairs(C.databars) do
	if type(v) == "number" then T.maxDatabars = max(T.maxDatabars, v) end
end
if T.maxDatabars == 0 then return end

for i = 1, T.maxDatabars do
	T.databars[i] = CreateFrame("Frame", "TukuiDataBar"..i.."_Panel", UIParent)
	T.databars[i]:CreateShadow()
	if i == 1 then
		T.databars[i]:CreatePanel("Transparent", pWidth, pHeight, "TOPLEFT", UIParent, "TOPLEFT", 2, -8)
	else
		if C.databars.settings.vertical then
			T.databars[i]:CreatePanel("Transparent", pWidth, pHeight, "TOPRIGHT", T.databars[i-1], "BOTTOMRIGHT", 0, -C.databars.settings.spacing)
		else
			T.databars[i]:CreatePanel("Transparent", pWidth, pHeight, "TOPLEFT", T.databars[i-1], "TOPRIGHT", C.databars.settings.spacing, 0)
		end
	end
	
	T.databars[i].statusbar = CreateFrame("StatusBar",  "TukuiDataBar"..i.."_StatusBar", T.databars[i], "TextStatusBar")
	T.databars[i].statusbar:SetFrameStrata("BACKGROUND")
	T.databars[i].statusbar:SetStatusBarTexture(C.media.normTex)
	T.databars[i].statusbar:SetStatusBarColor(1,1,1)
	T.databars[i].statusbar:SetFrameLevel(2)
	T.databars[i].statusbar:SetPoint("TOPRIGHT", T.databars[i], "TOPRIGHT", -2, -2)
	T.databars[i].statusbar:SetPoint("BOTTOMLEFT", T.databars[i], "BOTTOMLEFT", 2, 2)
	T.databars[i].statusbar:SetMinMaxValues(0,1)
	T.databars[i].statusbar:SetValue(0)
	
	T.databars[i].text = T.databars[i].statusbar:CreateFontString("DataBar"..i.."_Text", "OVERLAY")
	T.databars[i].text:SetFont(C.media.pixelfont, C["datatext"].fontsize, "MONOCHROMEOUTLINE")
	T.databars[i].text:SetPoint("TOPRIGHT", T.databars[i].statusbar, "TOPRIGHT", -2, -2)
	T.databars[i].text:SetPoint("BOTTOMLEFT", T.databars[i].statusbar, "BOTTOMLEFT", 2, 2)
end


local function hideDatabars(self)
	for i = 1, T.maxDatabars do
		T.databars[i]:Hide()
	end
	self.text:SetText(T.datacolor.."Open")
	self:ClearAllPoints()
	self:SetPoint(T.databars[1]:GetPoint())
end

local function showDatabars(self)
	for i = 1, T.maxDatabars do
		T.databars[i]:Show()
	end
	self.text:SetText(T.datacolor.."Close")
	self:ClearAllPoints()
	if not C.databars.settings.vertical then
		self:SetPoint("LEFT", T.databars[T.maxDatabars], "RIGHT", C.databars.settings.spacing, 0)
	else
		self:SetPoint("TOP", T.databars[T.maxDatabars], "BOTTOM", 0, -C.databars.settings.spacing)
	end
end

T.databars["toggle"] = CreateFrame("Frame", "TukuiDataBarToggle", UIParent)
T.databars["toggle"]:SetAlpha(0)
T.databars["toggle"].text = T.databars["toggle"]:CreateFontString(nil, "OVERLAY")
T.databars["toggle"].text:SetFont(C.media.pixelfont, C["datatext"].fontsize, "MONOCHROMEOUTLINE")
T.databars["toggle"].text:SetJustifyH("LEFT")
T.databars["toggle"].text:SetPoint("CENTER", 2)
T.databars["toggle"].text:SetText(T.datacolor.."Close")

if C.databars.settings.vertical then
	T.databars["toggle"]:CreatePanel("Transparent", pWidth, C.databars.settings.height, "TOP", T.databars[T.maxDatabars], "BOTTOM", 0, -C.databars.settings.spacing)
else
	T.databars["toggle"]:CreatePanel("Transparent", pWidth, C.databars.settings.height, "LEFT", T.databars[T.maxDatabars], "RIGHT", C.databars.settings.spacing, 0)
end
T.databars["toggle"]:CreateShadow()

T.databars["toggle"]:EnableMouse(true)
T.databars["toggle"]:HookScript("OnMouseDown", function(self) 
	if T.databars[1]:IsShown() then
		hideDatabars(self)
	else
		showDatabars(self)
	end
end)
T.databars["toggle"]:HookScript("OnEnter", function(self) self:SetAlpha(1) end)
T.databars["toggle"]:HookScript("OnLeave", function(self) self:SetAlpha(0) end)

--/script for i = 1, _G.Tukui[1].maxDatabars do _G.Tukui[1].databars[i]:Show() end