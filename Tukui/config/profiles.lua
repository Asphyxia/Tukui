----------------------------------------------------------------------------
-- Per Class Config (overwrite general)
-- Class need to be UPPERCASE
----------------------------------------------------------------------------
local T, C, L = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales

if T.myclass == "WARLOCK" then -- Change it to your class.
	-- do some config!
end

----------------------------------------------------------------------------
-- Per Character Name Config (overwrite general and class)
-- Name need to be case sensitive
----------------------------------------------------------------------------

if T.myname == "Asphyxîa" then -- Change it to your character name.
	C.actionbar.custombar.primary = {49040, 40768,  "Soul Harvest", "Demon Soul", "Death Coil"}
	C.actionbar.custombar.secondary = {49040, 40768,  "Soul Harvest", "Demon Soul", "Death Coil"}
end

if T.myname == "Asphyxîa" then -- Change it to your character name.
	C.unitframes.healcomm = true
	C.unitframes.showsolo = true
	C.unitframes.aggro = true
	C.unitframes.raidunitdebuffwatch = true
	C.unitframes.showplayerinparty = true
end