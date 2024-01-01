-- Poison player
local function poisenp(tick, time, time_left, player)
	print('poisenp')
	-- First check if player is still there
	if not player:is_player() then
		return
	end
	time_left = time_left + tick
	if time_left < time then
		minetest.after(tick, poisenp, tick, time, time_left, player)
	else
		hbhunger.poisonings[player:get_player_name()] = hbhunger.poisonings[player:get_player_name()] - 1
		if hbhunger.poisonings[player:get_player_name()] <= 0 then
			-- Reset HUD bar color
			hb.change_hudbar(player, "health", nil, nil, "hudbars_icon_health.png", nil, "hudbars_bar_health.png")
		end
	end
	if player:get_hp()-1 > 0 then
		player:set_hp(player:get_hp()-1)
	end
	
end

-- Tool enhancement (mese infusion) mod by archfan7411, licensed MIT.

-- Tint of enhanced tools.
local tint = "#964B00"
-- Opacity of said tint (0-255)
local opacity = 40

-- Saving the default tool registration function for later use.
--old_register_tool = minetest.register_tool

-- Overriding the tool registration to also define enhanced tools
function pooper.register_tool(name, e_name, def)

	-- Copying the given tool def to create the enhanced def
	local e_def = table.copy(def)

	-- The name is a separate argument which we need to copy as well.
	--local e_name = name

	-- If the tool has standardized tool capabilities
	if e_def.tool_capabilities and e_def.tool_capabilities.groupcaps then

		local e_groupcaps = e_def.tool_capabilities.groupcaps

		-- For each group the tool has defined capabilities for
        --for i, group in pairs(e_groupcaps) do
			
			-- Ensure the group is a table
            --if type(group) == "table" and group.times then
			
				-- For every group level defined in "times"
                --for index, level in pairs(group.times) do
	
					-- Decrease the time to dig that level; speeding it up by modifier% (default 20%)
				    --e_def.tool_capabilities.groupcaps[i].times[index] = level / modifier

                --end
            --end
		--end

		-- Improve damage dealt by tool
		--if e_def.tool_capabilities.damage_groups then
			--for group, value in pairs(e_def.tool_capabilities.damage_groups) do
				--e_def.tool_capabilities.damage_groups[group] = math.ceil(value * modifier)
			--end
		--end

		-- We create our own inventory image by tinting the provided inventory image yellow
		if e_def.inventory_image then

			e_def.inventory_image = e_def.inventory_image .. "^[colorize:"..tint..":"..opacity
		end

		-- In case the tool has a separate wield image, we must tint it as well.
		if e_def.wield_image then

			e_def.wield_image = e_def.wield_image .. "^[colorize:"..tint..":"..opacity
		end

		-- We make the enhanced version's description by concatenating "Enhanced" to the start of the given description.
		if e_def.description then

			e_def.description = "Poopy " .. e_def.description
		end

		e_def.on_use = function(itemstack, user, pointed_thing)
			print('on use')
			-- TODO if pointed_thing is player or food
			--print('user: '..user)
			--print('pointed thing type: '..pointed_thing.type)
			if pointed_thing.type == "object" then
				print('pointed_thing object')
				local ref = pointed_thing.ref
				local ent = ref:get_luaentity()
				if ref:is_player() then
					print('pointed_thing ref is player')
				end
				if ent ~= nil and ent:is_player() then
					print('pointed_thing ent is player')
				end
				if ref:is_player() or (ent ~= nil and ent:is_player()) then
					print('pointed_thing player')
					-- Set poison bar
					--hb.change_hudbar(user, "health", nil, nil, "hbhunger_icon_health_poison.png", nil, "hbhunger_bar_health_poison.png")
					--hbhunger.poisonings[name] = hbhunger.poisonings[name] + 1
					--poisenp(1, poisen, 0, user)

					--hbhunger.eat(0, "", ItemStack("pooper:poop_turd"), ref.object, pointed_thing)
					minetest.do_item_eat(0, "", ItemStack("pooper:poop_turd"), ref, pointed_thing)
					itemstack:set_name(name)
				end
			end
--			if user.type == "object" then
--				print('user object')
--				local ref = pointed_thing.ref
--				if ref:is_player() then
--					print('pointed_thing player')
--					-- Set poison bar
--					hb.change_hudbar(user, "health", nil, nil, "hbhunger_icon_health_poison.png", nil, "hbhunger_bar_health_poison.png")
--					hbhunger.poisonings[name] = hbhunger.poisonings[name] + 1
--					poisenp(1, poisen, 0, user)
--					itemstack:set_name(name)
--				end
--			end
			if def.on_use ~= nil then
				return def.on_use(itemstack, user, pointed_thing)
			end
			return itemstack
		end

		-- This code concatenates "_enhanced" to the itemstring of the tool
		--e_name = e_name .. "_enhanced"

		-- Registering the enhanced tool.
		--old_register_tool(e_name, e_def)
		minetest.register_tool(e_name, e_def)
		print('pooper registered tool: '..e_name)

		-- Registering a craft for the enhanced tool.
		minetest.register_craft({
			output = e_name,
			type = "shapeless",
			recipe = {name, "pooper:poop_turd"},
		})

	end

	-- Registering the normal tool with the normal parameters.
	--old_register_tool(name, def)
end




local DEBUG_MAIN = false
function pooper.main()
	local tools = minetest.registered_tools
	for name, def in pairs(tools) do
		--minetest.unregister_item(name)
		local modname = string.match(name,  '([^:]+)')
		local itmname = string.match(name, ':([^:]+)')
		if modname ~= 'pooper' then -- prevent recursive loops
			local convert_to = 'pooper:'..modname..'_'..itmname
			local alias      = name..'_pooper'
			if DEBUG_MAIN then
			print('pooper modname: '..modname)
			print('pooper itmname: '..itmname)
			print('pooper convert to: '..convert_to)
			print('pooper register alias: '..alias..' ==> '..convert_to)
			end
			pooper.register_tool(name, convert_to, def)
			minetest.register_alias(alias, convert_to)
		end
	end
end
--core.register_on_mods_loaded(pooper.main)
pooper.main()
