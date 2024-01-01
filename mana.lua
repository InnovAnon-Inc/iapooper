local MODNAME = minetest.get_current_modname()
--[[
Poop
This mod adds poop to players, a special attribute

License: MIT License
]]

--[===[
	Initialization
]===]

local S = minetest.get_translator("pooper")

pooper.playerlist = {}

pooper.settings = {}
pooper.settings.default_max = 200
pooper.settings.default_min = 100
pooper.settings.default_regen = 1
-- mana default
--pooper.settings.regen_timer = 0.2
-- fast
--pooper.settings.regen_timer = 0.02
-- slow
pooper.settings.regen_timer = 20

do
	local default_max = tonumber(minetest.settings:get("poop_default_max"))
	if default_max ~= nil then
		pooper.settings.default_max = default_max
	end
	local default_min = tonumber(minetest.settings:get("poop_default_min"))
	if default_min ~= nil then
		pooper.settings.default_min = default_min
	end

	local default_regen = tonumber(minetest.settings:get("poop_default_regen"))
	if default_regen ~= nil then
		pooper.settings.default_regen = default_regen
	end

	local regen_timer = tonumber(minetest.settings:get("poop_regen_timer"))
	if regen_timer ~= nil then
		pooper.settings.regen_timer = regen_timer
	end
end


--[===[
	API functions
]===]

function pooper.set(playername, value) 
	if value < 0 then
		minetest.log("info", "[pooper] Warning: pooper.set was called with negative value!")
		value = 0
	end
	value = pooper.round(value)
	if value > pooper.playerlist[playername].maxpoop then
		value = pooper.playerlist[playername].maxpoop
	end
	if pooper.playerlist[playername].poop ~= value then
		pooper.playerlist[playername].poop = value
		pooper.hud_update(playername)
	end
end

function pooper.setmax(playername, value)
	if value < 0 then
		value = 0
		minetest.log("info", "[pooper] Warning: pooper.setmax was called with negative value!")
	end
	value = pooper.round(value)
	if pooper.playerlist[playername].maxpoop ~= value then
		pooper.playerlist[playername].maxpoop = value
		if(pooper.playerlist[playername].poop > value) then
			pooper.playerlist[playername].poop = value
		end
		pooper.hud_update(playername)
	end
end
function pooper.setmin(playername, value)
	if value < 0 then
		value = 0
		minetest.log("info", "[pooper] Warning: pooper.setmin was called with negative value!")
	end
	value = pooper.round(value)
	if pooper.playerlist[playername].minpoop ~= value then
		pooper.playerlist[playername].minpoop = value
		if(pooper.playerlist[playername].poop > value) then
			pooper.playerlist[playername].poop = value
		end
		pooper.hud_update(playername)
	end
end

function pooper.setregen(playername, value)
	pooper.playerlist[playername].regen = value
end

function pooper.get(playername)
	return pooper.playerlist[playername].poop
end

function pooper.getmax(playername)
	return pooper.playerlist[playername].maxpoop
end
function pooper.getmin(playername)
	return pooper.playerlist[playername].minpoop
end

function pooper.getregen(playername)
	return pooper.playerlist[playername].regen
end

function pooper.add_up_to(playername, value)
	local t = pooper.playerlist[playername]
	value = pooper.round(value)
	if(t ~= nil and value >= 0) then
		local excess
		if((t.poop + value) > t.maxpoop) then
			excess = (t.poop + value) - t.maxpoop
			t.poop = t.maxpoop
		else
			excess = 0
			t.poop = t.poop + value
		end
		pooper.hud_update(playername)
		return true, excess
	else
		return false
	end
end

function pooper.add(playername, value)
	local t = pooper.playerlist[playername]
	value = pooper.round(value)
	if(t ~= nil and ((t.poop + value) <= t.maxpoop) and value >= 0) then
		t.poop = t.poop + value 
		pooper.hud_update(playername)
		return true
	else
		return false
	end
end

function pooper.subtract(playername, value)
	local t = pooper.playerlist[playername]
	value = pooper.round(value)
	if(t ~= nil and t.poop >= value and value >= 0) then
		t.poop = t.poop -value 
		pooper.hud_update(playername)
		return true
	else
		return false
	end
end

function pooper.subtract_up_to(playername, value)
	local t = pooper.playerlist[playername]
	value = pooper.round(value)
	if(t ~= nil and value >= 0) then
		local missing
		if((t.poop - value) < 0) then
			missing = math.abs(t.poop - value)
			t.poop = 0
		else
			missing = 0
			t.poop = t.poop - value
		end
		pooper.hud_update(playername)
		return true, missing
	else
		return false
	end
end





--[===[
	File handling, loading data, saving data, setting up stuff for players.
]===]


-- Load the playerlist from a previous session, if available.
do
	local filepath = minetest.get_worldpath().."/pooper.mt"
	local file = io.open(filepath, "r")
	if file then
		minetest.log("action", "[pooper] pooper.mt opened.")
		local string = file:read()
		io.close(file)
		if(string ~= nil) then
			local savetable = minetest.deserialize(string)
			pooper.playerlist = savetable.playerlist
			minetest.log("action", "[pooper] pooper.mt successfully read.")
		end
	end
end

function pooper.save_to_file()
	local savetable = {}
	savetable.playerlist = pooper.playerlist

	local savestring = minetest.serialize(savetable)

	local filepath = minetest.get_worldpath().."/pooper.mt"
	local file = io.open(filepath, "w")
	if file then
		file:write(savestring)
		io.close(file)
		minetest.log("action", "[pooper] Wrote poop data into "..filepath..".")
	else
		minetest.log("error", "[pooper] Failed to write poop data into "..filepath..".")
	end
end


minetest.register_on_respawnplayer(function(player)
	local playername = player:get_player_name()
	pooper.set(playername, 0)
	pooper.hud_update(playername)
end)


minetest.register_on_leaveplayer(function(player)
	local playername = player:get_player_name()
	if not minetest.get_modpath("hudbars") ~= nil then
		pooper.hud_remove(playername)
	end
	pooper.save_to_file()
end)

minetest.register_on_shutdown(function()
	minetest.log("action", "[pooper] Server shuts down. Rescuing data into pooper.mt")
	pooper.save_to_file()
end)

local function reset_bowel_variance(playername)
	--pooper.playerlist[playername].variance = math.random(800, 2000)
	local mymin = pooper.getmin(playername)
	local mymax = pooper.getmax(playername)
	local myrng = mymax - mymin
	pooper.playerlist[playername].variance = math.random(0, myrng)
end
local function get_bowel_variance(playername)
	local variance = pooper.playerlist[playername].variance
	if variance ~= nil then return variance end
	reset_bowel_variance(playername)
	return pooper.playerlist[playername].variance
end

minetest.register_on_joinplayer(function(player)
	local playername = player:get_player_name()
	
	if pooper.playerlist[playername] == nil then
		pooper.playerlist[playername] = {}
		pooper.playerlist[playername].poop = 0
		pooper.playerlist[playername].maxpoop = pooper.settings.default_max
		pooper.playerlist[playername].minpoop = pooper.settings.default_min
		pooper.playerlist[playername].regen = pooper.settings.default_regen
		pooper.playerlist[playername].remainder = 0
		reset_bowel_variance(playername)
	end

	if minetest.get_modpath("hudbars") ~= nil then
		hb.init_hudbar(player, "poop", pooper.get(playername), pooper.getmax(playername))
	else
		pooper.hud_add(playername)
	end
end)


--[===[
	Poop regeneration
]===]

pooper.regen_timer = 0

minetest.register_globalstep(function(dtime)
	pooper.regen_timer = pooper.regen_timer + dtime
	if pooper.regen_timer >= pooper.settings.regen_timer then
		local factor = math.floor(pooper.regen_timer / pooper.settings.regen_timer)
		local players = minetest.get_connected_players()
		for i=1, #players do
			local name = players[i]:get_player_name()
			if pooper.playerlist[name] ~= nil then
				if players[i]:get_hp() > 0 then
					local plus = pooper.playerlist[name].regen * factor
					-- Compability check for version <= 1.0.2 which did not have the remainder field
					if pooper.playerlist[name].remainder ~= nil then
						plus = plus + pooper.playerlist[name].remainder
					end
					local plus_now = math.floor(plus)
					local floor = plus - plus_now
					if plus_now > 0 then
						pooper.add_up_to(name, plus_now)
					else
						pooper.subtract_up_to(name, math.abs(plus_now))
					end
					pooper.playerlist[name].remainder = floor

					-- Defecate at least every X seconds
					local mypoop = pooper.get(name)
					local mymin  = pooper.getmin(name)
					if mypoop >= mymin + get_bowel_variance(name)
					or mypoop >= pooper.getmax(name) then
						pooper.defecate(mypoop, name)
						reset_bowel_variance(name)
					end
					-- Gut growls to notify player of readiness to defecate
					if mypoop == mymin then
						minetest.sound_play("poop_rumble", {pos=minetest.get_player_by_name(name):get_pos(), gain = 1.0, max_hear_distance = 10,})
					end
				end
			end
		end
		pooper.regen_timer = pooper.regen_timer % pooper.settings.regen_timer
	end
end)

--[===[
	HUD functions
]===]

if minetest.get_modpath("hudbars") ~= nil then
	local brown_tint = "#964B00"
	hb.register_hudbar("poop", 0xFFFFFF, S("Poop"), {
		bar = "mana_bar.png^[colorize:"..brown_tint,
		--icon = "mana_icon.png",
		--bgicon = "mana_bgicon.png"
		icon = "poop_turd.png",
		bgicon = "poop_turd.png"
	}, 0, pooper.settings.default_max, false)

	function pooper.hud_update(playername)
		local player = minetest.get_player_by_name(playername)
		if player ~= nil then
			hb.change_hudbar(player, "poop", pooper.get(playername), pooper.getmax(playername))
		end
	end

	function pooper.hud_remove(playername)
	end

else
	function pooper.poopstring(playername)
		return S("Poop: @1/@2", pooper.get(playername), pooper.getmax(playername))
	end
	
	function pooper.hud_add(playername)
		local player = minetest.get_player_by_name(playername)
		local id = player:hud_add({
			hud_elem_type = "text",
			position = { x = 0.5, y=1 },
			text = pooper.poopstring(playername),
			scale = { x = 0, y = 0 },
			alignment = { x = 1, y = 0},
			direction = 1,
			number = 0xFFFFFF,
			offset = { x = -262, y = -103}
		})
		pooper.playerlist[playername].hudid = id
		return id
	end
	
	function pooper.hud_update(playername)
		local player = minetest.get_player_by_name(playername)
		player:hud_change(pooper.playerlist[playername].hudid, "text", pooper.poopstring(playername))
	end
	
	function pooper.hud_remove(playername)
		local player = minetest.get_player_by_name(playername)
		player:hud_remove(pooper.playerlist[playername].hudid)
	end
end

--[===[
	Helper functions
]===]
pooper.round = function(x)
	return math.ceil(math.floor(x+0.5))
end
