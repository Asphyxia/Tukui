---------------------------------------------------------------------------------------------
-- Align.lua - Credits to Epicgrim
---------------------------------------------------------------------------------------------

local T, C, L = unpack( select( 2, ... ) )

SLASH_ALI1 = "/ali"
SlashCmdList["ALI"] = function( gridsize )

	local defsize = 16
	local w = tonumber( string.match( ( { GetScreenResolutions() } )[GetCurrentResolution()], "(%d+)x+%d" ) )
	local h = tonumber( string.match( ( { GetScreenResolutions() } )[GetCurrentResolution()], "%d+x(%d+)" ) )
	local x = tonumber( gridsize ) or defsize

	function Grid()
		ali = CreateFrame( "Frame", nil, UIParent )
		ali:SetFrameLevel( 0 )
		ali:SetFrameStrata( "BACKGROUND" )

		for i = - ( w / x / 2 ), w / x / 2 do
			local Aliv = ali:CreateTexture( nil, "BACKGROUND" )
			Aliv:SetTexture( .3, 0, 0, .7 )
			Aliv:Point( "CENTER", UIParent, "CENTER", i * x, 0 )
			Aliv:SetSize( 1, h )
		end

		for i = - ( h / x / 2 ), h / x / 2 do
			local Alih = ali:CreateTexture( nil, "BACKGROUND" )
			Alih:SetTexture( .3, 0, 0, .7 )
			Alih:Point( "CENTER", UIParent, "CENTER", 0, i * x )
			Alih:SetSize( w, 1 )
		end
	end

	if Ali then
		if ox ~= x then
			ox = x
			ali:Hide()
			Grid()
			Ali = true
			print( "Ali: ON" )
		else
			ali:Hide()
			print( "Ali: OFF" )
			Ali = false
		end
	else
		ox = x
		Grid()
		Ali = true
		print( "Ali: ON" )
	end
end