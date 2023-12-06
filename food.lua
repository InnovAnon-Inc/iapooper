local S = minetest.get_translator("pooper")

local tint = "#964B00"
local opacity = 40

local TEST_FOOD = false

for name, data in pairs(hbhunger.food) do
	local modname = string.match(name,  '([^:]+)')
	local itmname = string.match(name, ':([^:]+)')
	if modname ~= 'pooper' then -- prevent recursive loops
		local e_name  = 'pooper:'..modname..'_'..itmname
		--local e_name            = 'Tainted '..name -- TODO hide name ?

		local e_def = table.copy(minetest.registered_items[name])
		if TEST_FOOD then
			e_def.description = 'Tainted '..e_def.description
		end
		e_def.inventory_image = e_def.inventory_image .. "^[colorize:"..tint..":"..opacity
		minetest.register_craftitem(e_name, e_def)

		local alias      = name..'_pooper'
		minetest.register_alias(alias, e_name)

		local hunger_change     = data.saturation -- hunger points added
		local replace_with_item = data.replace    -- what item is given back after eating
		local poisen            = data.poisen     -- time its poisening
		if poisen == nil then poisen = 0 end
		local heal              = data.healing    -- amount of HP
		local sound             = data.sound      -- special sound that is played when eating
		hbhunger.register_food(e_name, hunger_change, replace_with_item, poisen+3, heal, sound)

		minetest.register_craft({
			type = "shapeless",
   			output = e_name,
   			recipe = {
				name,
				"pooper:poop_turd",
			},
   		})
	end
end
