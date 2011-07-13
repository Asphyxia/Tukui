local T, C, L = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales

if not C.Addon_Skins.addons_toggle then return end

----------------------------------------------------------------------
-- 							By Cadayron
-- Inspired by Tukz, Elv, Hydra codes and lduvall for icons
----------------------------------------------------------------------


 -- Config variables
font = C.media.pixelfont            			-- Font to be used for button text
fontsize = 8                      	-- Size of font for button text
tabwidth = C.actionbar.buttonsize     	-- Width of chatframe
tabspacing = C.actionbar.buttonspacing
chatheight = 115     		-- Height of chatframe
tabheight = (chatheight - (5 * tabspacing)) / 4 -- Height of tab
local firstposition = (chatheight/2)-(tabheight/2)-tabspacing  --Set the positon for default chat height size

----------------------------------------------------------------------
-- Array for Toggle and Lock functions
----------------------------------------------------------------------
TabIn = {}
TabIn[1] = false
TabIn[2] = false
TabIn[3] = false
TabIn[4] = false
TLock = {}
TLock[1] = false
TLock[2] = false
TLock[3] = false
TLock[4] = false


----------------------------------------------------------------------
-- Functions (Toggle and Update lock)
----------------------------------------------------------------------
T.ToggleTab = function(square,indexIn, id)
	if indexIn == true then
		square:Hide()
		TabIn[id] = false
		square:Show()
		square:SetAlpha(0)
	else
		square:SetAlpha(1);
		square:Show()
		TabIn[id] = true
	end
end

T.UpdateTabLock = function(skin,indexLock, id)
 if indexLock == true then
 	TLock[id] = false
  	skin:SetVertexColor(1,1,1)
 else
 	TLock[id] = true;
 	skin:SetVertexColor(35/255,164/255,255/255)
 end
end


tab = CreateFrame("Button", "Tab", TukuiChatBackgroundRight) 	-- Tab creation
tab:RegisterEvent("PLAYER_ENTERING_WORLD")

for i = 1, 4 do
	tab[i] = CreateFrame("Button", "Tab"..i, TukuiChatBackgroundRight)
	tab[i]:CreatePanel(tab[i], tabwidth, tabheight, "RIGHT", TukuiChatBackgroundRight, "LEFT", -2, firstposition)
	tab[i]:CreateShadow("Default")
	if i == 1 then
		tab[i]:SetPoint("RIGHT", TukuiChatBackgroundRight, "LEFT", -2, firstposition)
	else
		tab[i]:SetPoint("TOP", tab[i-1], "BOTTOM", 0, -tabspacing)
	end
	tab[i]:EnableMouse(true)
	tab[i]:RegisterForClicks("AnyUp")
	tab[i]:SetAlpha(0)
	tab[i]:FontString(nil, font, fontsize)
	tab[i].text:SetPoint("CENTER", 0, 0)
		
	if i == 1 then 		-- Atlasloot
	
		-- Set Texture
		TTALoot = tab[i]:CreateTexture(nil, "ARTWORK")
		TTALoot:SetPoint("TOPLEFT", tab[i], T.Scale(4), T.Scale(-4))
		TTALoot:SetPoint("BOTTOMRIGHT",tab[i], T.Scale(-4), T.Scale(4))
		TTALoot:SetTexture("Interface\\AddOns\\Tukui\\medias\\textures\\AL")
		
		tab[i]:SetScript("OnEnter", function(self)
			GameTooltip:SetOwner(self, "ANCHOR_TOP", 0, T.Scale(6));
			GameTooltip:ClearAllPoints()
			GameTooltip:SetPoint("BOTTOM", self, "TOP", 0, T.mult)
			GameTooltip:ClearLines()
			if TLock[i] == true then
				GameTooltip:AddDoubleLine("AtlasLoot : ", HIDE,1,1,1,unpack(C["media"].statcolor))
			else
				GameTooltip:AddDoubleLine("AtlasLoot : ", SHOW,1,1,1,unpack(C["media"].statcolor))
			end
			GameTooltip:Show()
			if TLock[i] == true then return end;
			T.ToggleTab(self, TabIn[i], 1); 
		end) 
		
		tab[1]:SetScript("OnLeave", function(self)
			GameTooltip:Hide()
			if TLock[i] == true then return end;
			T.ToggleTab(self, TabIn[i], 1);
			
		end)
		
		tab[i]:SetScript("OnMouseDown", function(self)
			GameTooltip:ClearLines()
			if TLock[i] == true then
				GameTooltip:AddDoubleLine("AtlasLoot : ", SHOW,1,1,1,unpack(C["media"].statcolor))
			else
				GameTooltip:AddDoubleLine("AtlasLoot : ", HIDE,1,1,1,unpack(C["media"].statcolor))
			end
			if not IsAddOnLoaded("AtlasLoot") then AtlasLoot:LoadModule("AtlasLoot") end
			ToggleFrame(AtlasLootDefaultFrame)
			T.UpdateTabLock(TTALoot, TLock[i], 1); 
		end)
		
		
	elseif i == 2 then 	-- Omen
	
		-- Set Texture
		TTOmen = tab[i]:CreateTexture(nil, "ARTWORK")
		TTOmen:SetPoint("TOPLEFT", tab[i], T.Scale(4), T.Scale(-4))
		TTOmen:SetPoint("BOTTOMRIGHT",tab[i], T.Scale(-4), T.Scale(4))
		TTOmen:SetTexture("Interface\\AddOns\\Tukui\\medias\\textures\\Omen")
		
		tab[2]:SetScript("OnEnter", function(self)
			GameTooltip:SetOwner(self, "ANCHOR_TOP", 0, T.Scale(6));
			GameTooltip:ClearAllPoints()
			GameTooltip:SetPoint("BOTTOM", self, "TOP", 0, T.mult)
			GameTooltip:ClearLines()
			if TLock[i] == true then
				GameTooltip:AddDoubleLine("Omen : ", HIDE,1,1,1,unpack(C["media"].statcolor))
			else
				GameTooltip:AddDoubleLine("Omen : ", SHOW,1,1,1,unpack(C["media"].statcolor))
			end
			GameTooltip:Show()
			if TLock[i] == true then return end;
			T.ToggleTab(self, TabIn[i], 2);
		end) 
		
		tab[i]:SetScript("OnLeave", function(self)
			GameTooltip:Hide()
			if TLock[i] == true then return end;
			T.ToggleTab(self, TabIn[i], 2);
		end)
		
		tab[i]:SetScript("OnMouseDown", function(self)
			GameTooltip:ClearLines()
			if TLock[i] == true then
				GameTooltip:AddDoubleLine("Omen : ", SHOW,1,1,1,unpack(C["media"].statcolor))
			else
				GameTooltip:AddDoubleLine("Omen : ", HIDE,1,1,1,unpack(C["media"].statcolor))
			end
			ToggleFrame(Omen.Anchor);
			T.UpdateTabLock(TTOmen, TLock[i], 2);
		end)
		
		
	elseif i == 3 then 	-- Recount
		
		-- Set Texture
		TTRecount = tab[i]:CreateTexture(nil, "ARTWORK")
		TTRecount:SetPoint("TOPLEFT", tab[i], T.Scale(4), T.Scale(-4))
		TTRecount:SetPoint("BOTTOMRIGHT",tab[i], T.Scale(-4), T.Scale(4))
		TTRecount:SetTexture("Interface\\AddOns\\Tukui\\medias\\textures\\Recount")
		
		tab[i]:SetScript("OnEnter", function(self)
			GameTooltip:SetOwner(self, "ANCHOR_TOP", 0, T.Scale(6));
			GameTooltip:ClearAllPoints()
			GameTooltip:SetPoint("BOTTOM", self, "TOP", 0, T.mult)
			GameTooltip:ClearLines()
			if TLock[i] == true then
				GameTooltip:AddDoubleLine("Recount : ", HIDE,1,1,1,unpack(C["media"].statcolor))
			else
				GameTooltip:AddDoubleLine("Recount : ", SHOW,1,1,1,unpack(C["media"].statcolor))
			end
			GameTooltip:Show() 
			if TLock[i] == true then return end; 
			T.ToggleTab(self, TabIn[i], 3); 
		end) 
		
		tab[i]:SetScript("OnLeave", function(self) 
			GameTooltip:Hide()
			if TLock[i] == true then return end;
			T.ToggleTab(self, TabIn[i], 3); 
		end)
		
		tab[i]:SetScript("OnMouseDown", function(self)
			GameTooltip:ClearLines()
			if TLock[i] == true then
				GameTooltip:AddDoubleLine("Recount : ", SHOW,1,1,1,unpack(C["media"].statcolor))
			else
				GameTooltip:AddDoubleLine("Recount : ", HIDE,1,1,1,unpack(C["media"].statcolor))
			end 
			ToggleFrame(Recount.MainWindow); 
			Recount.RefreshMainWindow(); 
			T.UpdateTabLock(TTRecount, TLock[i], 3); 
		end)
		
	--[[elseif i == 4 then 		-- Encounter Journal
	
		-- Set Texture
		TTEncJourn = tab[i]:CreateTexture(nil, "ARTWORK")
		TTEncJourn:SetPoint("TOPLEFT", tab[i], T.Scale(4), T.Scale(-4))
		TTEncJourn:SetPoint("BOTTOMRIGHT",tab[i], T.Scale(-4), T.Scale(4))
		TTEncJourn:SetTexture("Interface\\AddOns\\Tukui\\medias\\textures\\EJ")
		
		tab[i]:SetScript("OnEnter", function(self)
			GameTooltip:SetOwner(self, "ANCHOR_TOP", 0, T.Scale(6));
			GameTooltip:ClearAllPoints()
			GameTooltip:SetPoint("BOTTOM", self, "TOP", 0, T.mult)
			GameTooltip:ClearLines()
			if TLock[i] == true then
				GameTooltip:AddDoubleLine("Encounter Journal : ", HIDE,1,1,1,unpack(C["media"].statcolor))
			else
				GameTooltip:AddDoubleLine("Encounter Journal : ", SHOW,1,1,1,unpack(C["media"].statcolor))
			end
			GameTooltip:Show()  
			if TLock[i] == true then return end; 
			T.ToggleTab(self, TabIn[i], 4); 
		end) 
		
		tab[i]:SetScript("OnLeave", function(self)
			GameTooltip:Hide()
			if TLock[i] == true then return end; 
			T.ToggleTab(self, TabIn[i], 4); 
		end)
		
		tab[i]:SetScript("OnMouseDown", function(self)
			GameTooltip:ClearLines()
			if TLock[i] == true then
				GameTooltip:AddDoubleLine("Encounter Journal : ", SHOW,1,1,1,unpack(C["media"].statcolor))
			else
				GameTooltip:AddDoubleLine("Encounter Journal : ", HIDE,1,1,1,unpack(C["media"].statcolor))
			end 
			--SlashCmdList.CONFIG1('');
			ToggleFrame(EncounterJournal);
			T.UpdateTabLock(TTEncJourn, TLock[i], 4); 
		end)--]]
		
		elseif i == 4 then 		-- Skada
		
	-- Set Texture
		TTSkada = tab[i]:CreateTexture(nil, "ARTWORK")
		TTSkada:SetPoint("TOPLEFT", tab[i], T.Scale(4), T.Scale(-4))
		TTSkada:SetPoint("BOTTOMRIGHT",tab[i], T.Scale(-4), T.Scale(4))
		TTSkada:SetTexture("Interface\\AddOns\\Tukui\\medias\\textures\\EJ")
		
		tab[i]:SetScript("OnEnter", function(self)
			GameTooltip:SetOwner(self, "ANCHOR_TOP", 0, T.Scale(6));
			GameTooltip:ClearAllPoints()
			GameTooltip:SetPoint("BOTTOM", self, "TOP", 0, T.mult)
			GameTooltip:ClearLines()
			if TLock[i] == true then
				GameTooltip:AddDoubleLine("Skada : ", HIDE,1,1,1,unpack(C["media"].statcolor))
			else
				GameTooltip:AddDoubleLine("Skada : ", SHOW,1,1,1,unpack(C["media"].statcolor))
			end
			GameTooltip:Show()  
			if TLock[i] == true then return end; 
			T.ToggleTab(self, TabIn[i], 4); 
		end) 
		
		tab[i]:SetScript("OnLeave", function(self)
			GameTooltip:Hide()
			if TLock[i] == true then return end; 
			T.ToggleTab(self, TabIn[i], 4); 
		end)
		
		tab[i]:SetScript("OnMouseDown", function(self)
			GameTooltip:ClearLines()
			if TLock[i] == true then
				GameTooltip:AddDoubleLine("Skada : ", SHOW,1,1,1,unpack(C["media"].statcolor))
			else
				GameTooltip:AddDoubleLine("Skada : ", HIDE,1,1,1,unpack(C["media"].statcolor))
			end 
			ToggleFrame(SkadaBarWindowSkada);
			T.UpdateTabLock(TTSkada, TLock[i], 4); 
		end)
	end	
end