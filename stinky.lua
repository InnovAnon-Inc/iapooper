local S = minetest.get_translator("pooper")

local timer = 0
local interval = 2.0

pooper.stinkers = {}

pooper.increment_stinker = function(name)
	local stinkiness = pooper.stinkers[name]
	if stinkiness == nil then stinkiness = 0 end
	pooper.stinkers[name] = stinkiness + 1
end

pooper.decrement_stinker = function(name)
	local stinkiness = pooper.stinkers[name]
	if stinkiness == nil then return end
	if stinkiness == 0 then return end
	pooper.stinkers[name] = stinkiness - 1
end

minetest.register_globalstep(function(dtime)
    timer = timer + dtime
    if timer >= interval then
        timer = 0
        for name,stinkiness in pairs(pooper.stinkers) do
	    if stinkiness ~= nil and stinkiness ~= 0 then
	    	local player = minetest.get_player_by_name(name)
	    	local pos    = player:get_pos()
	    	pooper.abm_callback(pos, stinkiness)
	    end
        end
    end
end)
