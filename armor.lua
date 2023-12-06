armor.materials.poop = "pooper:poop_pile"

--- Registered armors.
--
--  @topic armor


-- support for i18n
local S = minetest.get_translator("pooper")

--- Poop
--
--  Requires setting `armor_material_poop`.
--
--  @section poop

if armor.materials.poop then
	--- Poop Helmet
	--
	--  @helmet poop_armor:helmet_poop
	--  @img poop_armor_inv_helmet_poop.png
	--  @grp armor_head 1
	--  @grp armor_heal 0
	--  @grp armor_use 2000
	--  @grp flammable 1
	--  @armorgrp fleshy 5
	--  @damagegrp cracky 3
	--  @damagegrp snappy 2
	--  @damagegrp choppy 3
	--  @damagegrp crumbly 2
	--  @damagegrp level 1
	armor:register_armor(":poop_armor:helmet_poop", {
		description = S("Poop Helmet"),
		inventory_image = "poop_armor_inv_helmet_poop.png",
		groups = {armor_head=1, armor_heal=0, armor_use=2000, flammable=1},
		armor_groups = {fleshy=5},
		damage_groups = {cracky=3, snappy=2, choppy=3, crumbly=2, level=1},

		on_equip = function(player, index, stack)
			local name = player:get_player_name()
			pooper.increment_stinker(name) 
		end,
		on_unequip = function(player, index, stack)
			local name = player:get_player_name()
			pooper.decrement_stinker(name) 
		end,
	})
	--- Poop Chestplate
	--
	--  @chestplate poop_armor:chestplate_poop
	--  @img poop_armor_inv_chestplate_poop.png
	--  @grp armor_torso 1
	--  @grp armor_heal 0
	--  @grp armor_use 2000
	--  @grp flammable 1
	--  @armorgrp fleshy 10
	--  @damagegrp cracky 3
	--  @damagegrp snappy 2
	--  @damagegrp choppy 3
	--  @damagegrp crumbly 2
	--  @damagegrp level 1
	armor:register_armor(":poop_armor:chestplate_poop", {
		description = S("Poop Chestplate"),
		inventory_image = "poop_armor_inv_chestplate_poop.png",
		groups = {armor_torso=1, armor_heal=0, armor_use=2000, flammable=1},
		armor_groups = {fleshy=10},
		damage_groups = {cracky=3, snappy=2, choppy=3, crumbly=2, level=1},

		on_equip = function(player, index, stack)
			local name = player:get_player_name()
			pooper.increment_stinker(name) 
		end,
		on_unequip = function(player, index, stack)
			local name = player:get_player_name()
			pooper.decrement_stinker(name) 
		end,
	})
	--- Poop Leggings
	--
	--  @leggings poop_armor:leggings_poop
	--  @img poop_armor_inv_leggings_poop.png
	--  @grp armor_legs 1
	--  @grp armor_heal 0
	--  @grp armor_use 1000
	--  @grp flammable 1
	--  @armorgrp fleshy 10
	--  @damagegrp cracky 3
	--  @damagegrp snappy 2
	--  @damagegrp choppy 3
	--  @damagegrp crumbly 2
	--  @damagegrp level 1
	armor:register_armor(":poop_armor:leggings_poop", {
		description = S("Poop Leggings"),
		inventory_image = "poop_armor_inv_leggings_poop.png",
		groups = {armor_legs=1, armor_heal=0, armor_use=2000, flammable=1},
		armor_groups = {fleshy=10},
		damage_groups = {cracky=3, snappy=2, choppy=3, crumbly=2, level=1},

		on_equip = function(player, index, stack)
			local name = player:get_player_name()
			pooper.increment_stinker(name) 
		end,
		on_unequip = function(player, index, stack)
			local name = player:get_player_name()
			pooper.decrement_stinker(name) 
		end,
	})
	--- Poop Boots
	--
	--  @boots poop_armor:boots_poop
	--  @img poop_armor_inv_boots_poop.png
	--  @grp armor_feet 1
	--  @grp armor_heal 0
	--  @grp armor_use 2000
	--  @grp flammable 1
	--  @armorgrp fleshy 5
	--  @damagegrp cracky 3
	--  @damagegrp snappy 2
	--  @damagegrp choppy 3
	--  @damagegrp crumbly 2
	--  @damagegrp level 1
	armor:register_armor(":poop_armor:boots_poop", {
		description = S("Poop Boots"),
		inventory_image = "poop_armor_inv_boots_poop.png",
		armor_groups = {fleshy=5},
		damage_groups = {cracky=3, snappy=2, choppy=3, crumbly=2, level=1},
		groups = {armor_feet=1, armor_heal=0, armor_use=2000, flammable=1},

		on_equip = function(player, index, stack)
			local name = player:get_player_name()
			pooper.increment_stinker(name) 
		end,
		on_unequip = function(player, index, stack)
			local name = player:get_player_name()
			pooper.decrement_stinker(name) 
		end,
	})
	local poop_armor_fuel = {
		helmet = 6,
		chestplate = 8,
		leggings = 7,
		boots = 5
	}
	for armor, burn in pairs(poop_armor_fuel) do
		minetest.register_craft({
			type = "fuel",
			recipe = "poop_armor:" .. armor .. "_poop",
			burntime = burn,
		})
	end

	--- Crafting
	--
	--  @section craft

	--- Craft recipes for helmets, chestplates, leggings, boots, & shields.
	--
	--  @craft armor
	--  @usage
	--  Key:
	--  - m: material
	--    - poop:    group:poop
	--    - cactus:  default:cactus
	--    - steel:   default:steel_ingot
	--    - bronze:  default:bronze_ingot
	--    - diamond: default:diamond
	--    - gold:    default:gold_ingot
	--    - mithril: moreores:mithril_ingot
	--    - crystal: ethereal:crystal_ingot
	--    - nether:  nether:nether_ingot
	--
	--  helmet:        chestplate:    leggings:
	--  ┌───┬───┬───┐  ┌───┬───┬───┐  ┌───┬───┬───┐
	--  │ m │ m │ m │  │ m │   │ m │  │ m │ m │ m │
	--  ├───┼───┼───┤  ├───┼───┼───┤  ├───┼───┼───┤
	--  │ m │   │ m │  │ m │ m │ m │  │ m │   │ m │
	--  ├───┼───┼───┤  ├───┼───┼───┤  ├───┼───┼───┤
	--  │   │   │   │  │ m │ m │ m │  │ m │   │ m │
	--  └───┴───┴───┘  └───┴───┴───┘  └───┴───┴───┘
	--
	--  boots:         shield:
	--  ┌───┬───┬───┐  ┌───┬───┬───┐
	--  │   │   │   │  │ m │ m │ m │
	--  ├───┼───┼───┤  ├───┼───┼───┤
	--  │ m │   │ m │  │ m │ m │ m │
	--  ├───┼───┼───┤  ├───┼───┼───┤
	--  │ m │   │ m │  │   │ m │   │
	--  └───┴───┴───┘  └───┴───┴───┘

	local s = "poop"
	local m = armor.materials.poop
	minetest.register_craft({
		output = "poop_armor:helmet_"..s,
		recipe = {
			{m, m, m},
			{m, "", m},
			{"", "", ""},
		},
	})
	minetest.register_craft({
		output = "poop_armor:chestplate_"..s,
		recipe = {
			{m, "", m},
			{m, m, m},
			{m, m, m},
		},
	})
	minetest.register_craft({
		output = "poop_armor:leggings_"..s,
		recipe = {
			{m, m, m},
			{m, "", m},
			{m, "", m},
		},
	})
	minetest.register_craft({
		output = "poop_armor:boots_"..s,
		recipe = {
			{m, "", m},
			{m, "", m},
		},
	})
end
