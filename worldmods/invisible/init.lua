local mod_name = minetest.get_current_modname()
local path = minetest.get_modpath(mod_name)

invisible = {}
dofile(path .. "/functions.lua")

invisible.node = {
	light = 6,
	groups = {cracky=3,oddly_breakable_by_hand=3},
	sounds = default.node_sound_stone_defaults(),
}

minetest.register_craft({
	type = "cooking",
	output = "invisible:matter",
	recipe = "default:glass",
})

minetest.register_node("invisible:matter", {
	description = "Invisible Matter Cube",
	drawtype = "airlike",
	inventory_image = "invisible_block_inv.png",
	paramtype = "light",
	light_source = invisible.node.light,
	sunlight_propagates = true,
	groups = invisible.node.groups,
	sounds = invisible.node.sounds,
})

invisible.register_stair("invisible:matter_stair", "invisible:matter",
	invisible.node.groups,
	{"nothing.png"},
	"invisible_stair_inv.png",
	"Invisible Matter Stair",
	invisible.node.light,
	invisible.node.sounds)

invisible.register_slab("invisible:matter_slab", "invisible:matter",
	invisible.node.groups,
	{"nothing.png"},
	"invisible_slab_inv.png",
	"Invisible Matter Slab",
	invisible.node.light,
	invisible.node.sounds)

-- Light nodes
minetest.register_node("invisible:light", {
	description = "The Light",
        drawtype = "airlike",
        inventory_image = "invisible_block_inv.png^[brighten",
        paramtype = "light",
	walkable = false,
        sunlight_propagates = true,
        groups = invisible.node.groups,
	on_construct = function(pos)
		local light_level = minetest.get_node_light(pos)
		minetest.set_node(pos, {name="invisible:light_"..light_level})
	end
})

for level=0, LIGHT_MAX do
minetest.register_node("invisible:light_"..level, {
        description = "The Light Level "..level,
        drawtype = "airlike",
        inventory_image = "invisible_block_inv.png^[brighten",
	light_source = level,
        paramtype = "light",
	walkable = false,
        sunlight_propagates = false,
        groups = invisible.node.groups,
	drop = "invisible:light",
})
end

minetest.register_craft({
	type = "shapeless",
	output = "invisible:light 4",
	recipe = {"default:torch", "invisible:matter"},
})
