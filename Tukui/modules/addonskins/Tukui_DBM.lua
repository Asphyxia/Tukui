local T, C, L = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales
if not IsAddOnLoaded("DBM-Core") or not C.Addon_Skins.DBM then return end
--[[

Tukui_DBM skin by Affli@RU-Howling Fjord
All rights reserved.
Thanks ALZA, Shestak, Fernir, Tukz and everyone i've forgot to mention.

]]--



-- little config
----------------------------------------
local croprwicons=true			-- crops blizz shitty borders from icons in RaidWarning messages
local drawshadow=false			-- draw Tukui shadows around frames.
local rwiconsize=18			-- RaidWarning icon size, because 12 is small for me. Works only if croprwicons=true
----------------------------------------


-- Damn edits compatbility
local UI
if ElvUI then UI=ElvUI else UI=Tukui end
local T, C, L = unpack(UI)
local classcolor = RAID_CLASS_COLORS[T.myclass]
local buttonsize
if C.actionbar.buttonsize and type(C.actionbar.buttonsize)=="number" then
	buttonsize=C.actionbar.buttonsize
else
	buttonsize=30	-- just to be safe
end

local function SkinBars(self)
	for bar in self:GetBarIterator() do
		if not bar.injected then
				bar.ApplyStyle=function()
				local frame = bar.frame
				local tbar = _G[frame:GetName().."Bar"]
				local spark = _G[frame:GetName().."BarSpark"]
				local texture = _G[frame:GetName().."BarTexture"]
				local icon1 = _G[frame:GetName().."BarIcon1"]
				local icon2 = _G[frame:GetName().."BarIcon2"]
				local name = _G[frame:GetName().."BarName"]
				local timer = _G[frame:GetName().."BarTimer"]

				if not (icon1.overlay) then
					icon1.overlay = CreateFrame("Frame", "$parentIcon1Overlay", tbar)
					icon1.overlay:CreatePanel("Default", buttonsize, buttonsize, "BOTTOMRIGHT", tbar, "BOTTOMLEFT", -buttonsize/4, -2)
					if drawshadow then
						icon1.overlay:CreateShadow("Default")
					end
				end

				if not (icon2.overlay) then
					icon2.overlay = CreateFrame("Frame", "$parentIcon2Overlay", tbar)
					icon2.overlay:CreatePanel("Default", buttonsize, buttonsize, "BOTTOMLEFT", tbar, "BOTTOMRIGHT", buttonsize/4, -2)
					if drawshadow then
						icon2.overlay:CreateShadow("Default")
					end
				end

				if bar.color then
					tbar:SetStatusBarColor(bar.color.r, bar.color.g, bar.color.b)
				else
					tbar:SetStatusBarColor(bar.owner.options.StartColorR, bar.owner.options.StartColorG, bar.owner.options.StartColorB)
				end
				
				if bar.enlarged then frame:Width(bar.owner.options.HugeWidth) else frame:Width(bar.owner.options.Width) end
				if bar.enlarged then tbar:Width(bar.owner.options.HugeWidth) else tbar:Width(bar.owner.options.Width) end

				if not frame.styled then
					frame:SetScale(1)
					frame.SetScale=T.dummy
					frame:SetHeight(buttonsize/3)
					frame:SetTemplate("Transparent")
					frame:CreateBorder(true, true)
					if drawshadow then
						frame:CreateShadow("Default")
					end
					frame.styled=true
				end

				if not spark.killed then
					spark:SetAlpha(0)
					spark:SetTexture(nil)
					spark.killed=true
				end
	
				if not icon1.styled then
					icon1:SetTexCoord(0.08, 0.92, 0.08, 0.92)
					icon1:ClearAllPoints()
					icon1:Point("TOPLEFT", icon1.overlay, 2, -2)
					icon1:Point("BOTTOMRIGHT", icon1.overlay, -2, 2)
					icon1.styled=true
				end
				
				if not icon2.styled then
					icon2:SetTexCoord(0.08, 0.92, 0.08, 0.92)
					icon2:ClearAllPoints()
					icon2:Point("TOPLEFT", icon2.overlay, 2, -2)
					icon2:Point("BOTTOMRIGHT", icon2.overlay, -2, 2)
					icon2.styled=true
				end

				if not texture.styled then
					texture:SetTexture(C["media"].normTex)
					texture.styled=true
				end

				if not tbar.styled then
					tbar:Point("TOPLEFT", frame, "TOPLEFT", 2, -2)
					tbar:Point("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -2, 2)
					tbar.styled=true
				end

				if not name.styled then
					name:ClearAllPoints()
					name:Point("BOTTOMLEFT", frame, "TOPLEFT", 2, 4)
					name:SetWidth(165)
					name:SetHeight(8)
					name:SetFont(C.media.pixelfont, C["datatext"].fontsize, "MONOCHROMEOUTLINE")
					name:SetJustifyH("LEFT")
					name:SetShadowColor(0, 0, 0, 0)
					name.SetFont = T.dummy
					name.styled=true
				end
				
				if not timer.styled then	
					timer:ClearAllPoints()
					timer:Point("BOTTOMRIGHT", frame, "TOPRIGHT", -1, 3)
					timer:SetFont(C.media.pixelfont, C["datatext"].fontsize, "MONOCHROMEOUTLINE")
					timer:SetJustifyH("RIGHT")
					timer:SetShadowColor(0, 0, 0, 0)
					timer.SetFont = T.dummy
					timer.styled=true
				end

				if bar.owner.options.IconLeft then icon1:Show() icon1.overlay:Show() else icon1:Hide() icon1.overlay:Hide() end
				if bar.owner.options.IconRight then icon2:Show() icon2.overlay:Show() else icon2:Hide() icon2.overlay:Hide() end
				tbar:SetAlpha(1)
				frame:SetAlpha(1)
				texture:SetAlpha(1)
				frame:Show()
				bar:Update(0)
				bar.injected=true
			end
			bar:ApplyStyle()
		end

	end
end
 
local SkinBossTitle=function()
	local anchor=DBMBossHealthDropdown:GetParent()
	if not anchor.styled then
		local header={anchor:GetRegions()}
			if header[1]:IsObjectType("FontString") then
				header[1]:SetFont(C["media"].font, 12, "OUTLINE")
				header[1]:SetTextColor(1,1,1,1)
				header[1]:SetShadowColor(0, 0, 0, 0)
				anchor.styled=true	
			end
		header=nil
	end
	anchor=nil
end

local SkinBoss=function()
	local count = 1
	while (_G[format("DBM_BossHealth_Bar_%d", count)]) do
		local bar = _G[format("DBM_BossHealth_Bar_%d", count)]
		local background = _G[bar:GetName().."BarBorder"]
		local progress = _G[bar:GetName().."Bar"]
		local name = _G[bar:GetName().."BarName"]
		local timer = _G[bar:GetName().."BarTimer"]
		local prev = _G[format("DBM_BossHealth_Bar_%d", count-1)]	

		if (count == 1) then
			local	_, anch, _ ,_, _ = bar:GetPoint()
			bar:ClearAllPoints()
			if DBM_SavedOptions.HealthFrameGrowUp then
				bar:Point("BOTTOM", anch, "TOP" , 0 , 12)
			else
				bar:Point("TOP", anch, "BOTTOM" , 0, -buttonsize)
			end
		else
			bar:ClearAllPoints()
			if DBM_SavedOptions.HealthFrameGrowUp then
				bar:Point("TOPLEFT", prev, "TOPLEFT", 0, buttonsize)
			else
				bar:Point("TOPLEFT", prev, "TOPLEFT", 0, -buttonsize)
			end
		end

		if not bar.styled then
			bar:SetHeight(buttonsize/3)
			bar:SetTemplate("Transparent")
			if drawshadow then
				bar:CreateShadow("Default")
			end
			background:SetNormalTexture(nil)
			bar.styled=true
			
		end	
		
		if not progress.styled then
			progress:SetStatusBarTexture(C["media"].normTex)
			progress.styled=true
		end				
		progress:ClearAllPoints()
		progress:Point("TOPLEFT", bar, "TOPLEFT", 2, -2)
		progress:Point("BOTTOMRIGHT", bar, "BOTTOMRIGHT", -2, 2)

		if not name.styled then
			name:ClearAllPoints()
			name:Point("BOTTOMLEFT", bar, "TOPLEFT", 1, 4)
			name:SetFont(C["media"].font, 12, "OUTLINE")
			name:SetJustifyH("LEFT")
			name:SetShadowColor(0, 0, 0, 0)
			name.styled=true
		end
		
		if not timer.styled then
			timer:ClearAllPoints()
			timer:Point("BOTTOMRIGHT", bar, "TOPRIGHT", 0, 3)
			timer:SetFont(C["media"].font, 12, "OUTLINE")
			timer:SetJustifyH("RIGHT")
			timer:SetShadowColor(0, 0, 0, 0)
			timer.styled=true
		end
		count = count + 1
	end
end

-- mwahahahah, eat this ugly DBM.
hooksecurefunc(DBT,"CreateBar",SkinBars)
hooksecurefunc(DBM.BossHealth,"Show",SkinBossTitle)
hooksecurefunc(DBM.BossHealth,"AddBoss",SkinBoss)
hooksecurefunc(DBM.BossHealth,"UpdateSettings",SkinBoss)
DBM.RangeCheck:Show()
DBM.RangeCheck:Hide()
DBMRangeCheck:HookScript("OnShow",function(self)
	self:SetTemplate("Transparent")
	if drawshadow then
		self:CreateShadow("Default")
	end
end)

DBMRangeCheckRadar:HookScript("OnShow",function(self)
	self:SetTemplate("Default")
	if drawshadow then
		self:CreateShadow("Default")
	end
end)

if (croprwicons) then
	local replace=string.gsub
	local old=RaidNotice_AddMessage
	RaidNotice_AddMessage=function(noticeFrame, textString, colorInfo)
		if textString:find(" |T") then
			textString=replace(textString,"(:12:12)",":"..rwiconsize..":"..rwiconsize..":0:0:64:64:5:59:5:59")
		end
		return old(noticeFrame, textString, colorInfo)
	end
end

local UploadDBM = function()
	DBM_SavedOptions.Enabled=true
	DBM_SavedOptions.WarningIconLeft=false
	DBM_SavedOptions.WarningIconRight=false
	DBM_SavedOptions["WarningColors"] = {{["b"] = classcolor.b, ["g"] = classcolor.g, ["r"] = classcolor.r,},
                             {["b"] = classcolor.b, ["g"] = classcolor.g, ["r"] = classcolor.r,},
                             {["b"] = classcolor.b, ["g"] = classcolor.g, ["r"] = classcolor.r,},
                             {["b"] = classcolor.b, ["g"] = classcolor.g, ["r"] = classcolor.r,},}

	DBT_SavedOptions["DBM"].StartColorR=classcolor.r
	DBT_SavedOptions["DBM"].StartColorG=classcolor.g
	DBT_SavedOptions["DBM"].StartColorB=classcolor.b
	DBT_SavedOptions["DBM"].EndColorR=classcolor.r
	DBT_SavedOptions["DBM"].EndColorG=classcolor.g
	DBT_SavedOptions["DBM"].EndColorB=classcolor.b
	DBT_SavedOptions["DBM"].Scale=1
	DBT_SavedOptions["DBM"].HugeScale=1
	DBT_SavedOptions["DBM"].BarXOffset=0
	DBT_SavedOptions["DBM"].BarYOffset=3
	DBT_SavedOptions["DBM"].IconLeft=true
	DBT_SavedOptions["DBM"].ExpandUpwards=true
	DBT_SavedOptions["DBM"].Texture=C["media"].normTex
	DBT_SavedOptions["DBM"].IconRight=false
end
--[[
local loadOptions = CreateFrame("Frame")
loadOptions:RegisterEvent("PLAYER_LOGIN")
loadOptions:SetScript("OnEvent", UploadDBM)]]
local pr = function(msg)
    print("|cffC495DDTukui DBM|r:", tostring(msg))
end

local function rt(i) return function() return i end end

local function healthdemo()
		DBM.BossHealth:Show("Scary bosses")
		DBM.BossHealth:AddBoss(rt(25), "Sinestra")
		DBM.BossHealth:AddBoss(rt(50), "Nefarian")
		DBM.BossHealth:AddBoss(rt(75), "Gamon")
		DBM.BossHealth:AddBoss(rt(100), "Hogger")
end

SLASH_TUKUIDBM1 = "/tukuidbm"
SLASH_TUKUIDBM2 = "/dbmskin" -- backwards compatbility, to be removed in the future.
SlashCmdList["TUKUIDBM"] = function(msg)
	if(msg=="apply") then
		StaticPopup_Show("TUKUIDBM")        
	elseif(msg=="test") then
		DBM:DemoMode()
	elseif(msg=="bh")then
		healthdemo()
	else
		pr("use |cffFF0000/tukuidbm apply|r to apply DBM settings.")
		pr("use |cffFF0000/tukuidbm test|r to launch DBM testmode.")
		pr("use |cffFF0000/tukuidbm bh|r to show test BossHealth frame.")
	end
end

StaticPopupDialogs["TUKUIDBM"] = {
	text = "We need to set some DBM options to apply Tukui DBM skin.\nMost of your settings will remain untouched.",
	button1 = ACCEPT,
	button2 = CANCEL,
    OnAccept = function() UploadDBM() ReloadUI() end,
    timeout = 0,
    whileDead = 1,
    hideOnEscape = true,
}