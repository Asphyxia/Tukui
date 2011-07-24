local T, C, L = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales

--------------------------------------------------------------------
-- FPS
--------------------------------------------------------------------

if C["datatext"].fps_ms and C["datatext"].fps_ms > 0 then
	local Stat = CreateFrame("Frame")
  	Stat:EnableMouse(true)
	Stat:SetFrameStrata("HIGH")
	Stat:SetFrameLevel(3)

	local Text  = TukuiInfoLeft:CreateFontString(nil, "OVERLAY")
	Text:SetFont(C.media.pixelfont, C["datatext"].fontsize, "MONOCHROMEOUTLINE")
	T.PP(C["datatext"].fps_ms, Text)

	local int = 1
	local function Update(self, t)
		int = int - t
		if int < 0 then
      		fps = floor(GetFramerate())
      		bw_in, bw_out, ms_home, ms_world = GetNetStats()
      		ms_combined = ms_home + ms_world
			Text:SetText( FPS_ABBR .. ": " .. T.panelcolor .. fps .. "|r".. " / " .. MILLISECONDS_ABBR .. ": " .. T.panelcolor .. ms_home)
			int = 1
		end	
	  
    		self:SetAllPoints(Text) 
	end

	Stat:SetScript("OnUpdate", Update) 
	Stat:SetScript("OnEnter", function(self)
		if not InCombatLockdown() then
			local anchor, panel, xoff, yoff = T.DataTextTooltipAnchor(Text)
			GameTooltip:SetOwner(panel, anchor, xoff, yoff)
			GameTooltip:ClearLines()
	      	GameTooltip:AddDoubleLine("Frame rate")
			GameTooltip:AddDoubleLine("Frame per second", fps .. " " .. FPS_ABBR, 1, 1, 1, 1, 1, 1)
			GameTooltip:AddLine(" ")
			GameTooltip:AddDoubleLine("Lag")
			GameTooltip:AddDoubleLine("Total lag", ms_combined .. " " .. MILLISECONDS_ABBR, 1, 1, 1, 1, 1, 1)
			GameTooltip:AddDoubleLine("Local lag", ms_home .. " " .. MILLISECONDS_ABBR, 1, 1, 1, 1, 1, 1)
			GameTooltip:AddDoubleLine("Global lag", ms_world .. " " .. MILLISECONDS_ABBR, 1, 1, 1, 1, 1, 1)
			GameTooltip:AddLine(" ")
			GameTooltip:AddLine("Delay")
			GameTooltip:AddDoubleLine("Incoming", string.format("%.4f", bw_in) .. " kb/s", 1, 1, 1, 1, 1, 1)
			GameTooltip:AddDoubleLine("Outgoing", string.format("%.4f", bw_out) .. " kb/s", 1, 1, 1, 1, 1, 1)
			GameTooltip:Show()
		end
  	end)	
  	Stat:SetScript("OnLeave", function() GameTooltip:Hide() end)	
  	Update(Stat, 10)
end