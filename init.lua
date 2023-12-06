pooper = {}

dofile(minetest.get_modpath("pooper") .. "/mana.lua") -- from `mana` mod
dofile(minetest.get_modpath("pooper") .. "/keybind.lua") -- from `pooper` mod
dofile(minetest.get_modpath("pooper") .. "/pooper.lua") -- from `pooper` mod
dofile(minetest.get_modpath("pooper") .. "/enhance.lua") -- sepsis
dofile(minetest.get_modpath("pooper") .. "/food.lua") -- fecal-oral route
dofile(minetest.get_modpath("pooper") .. "/armor.lua") -- you stink
dofile(minetest.get_modpath("pooper") .. "/stinky.lua")

print ("[MOD] IA Pooper loaded")
