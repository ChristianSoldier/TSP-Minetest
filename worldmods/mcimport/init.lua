-- map conversion requires a special water level
minetest.set_mapgen_params({water_level = -2})

-- prevent overgeneration in incomplete chunks, and allow lbms to work
minetest.set_mapgen_params({chunksize = 1})

-- comment the line below if you want to enable mapgen (will destroy things!)
minetest.set_mapgen_params({mgname = "singlenode"})

-- below lines will recalculate lighting on map block load
minetest.register_on_generated(function(minp, maxp, seed)
        local vm = minetest.get_voxel_manip(minp, maxp)
        vm:set_lighting({day = 15, night = 0}, minp, maxp)
        vm:update_liquids()
        vm:write_to_map()
        vm:update_map()
end)

