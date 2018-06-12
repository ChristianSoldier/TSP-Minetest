minetest.register_node("barcodes:qr_code", {
	description = ("QR Code"),
	tiles = {"barcodes_qr_code.png"},
	inventory_image = "barcodes_qr_code.png",
	wield_image = "barcodes_qr_code.png",
	groups = {dig_immediate = 2, unbreakable = 1},
	paramtype = 'light',
	paramtype2 = "wallmounted",
	legacy_wallmounted = true,
	drawtype = "nodebox",
	sunlight_propogates = false,
	node_box = {
		type = "wallmounted",
		wall_top = {-0.5, 0.4375, -0.5, 0.5, 0.5, 0.5},
		wall_bottom = {-0.5, -0.5, -0.5, 0.5, -0.4375, 0.5},
		wall_side   = {-0.5, -0.5, -0.5, -0.4375, 0.5, 0.5},
	},
	selection_box = {type = "wallmounted"},

	on_construct = function(pos)
		--local n = minetest.get_node(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("formspec", "field[text;;${text}]")
		meta:set_string("infotext", "\"\"")
	end,
	on_receive_fields = function(pos, formname, fields, sender)
		--print("Sign at "..minetest.pos_to_string(pos).." got "..dump(fields))
		if minetest.is_protected(pos, sender:get_player_name()) then
			minetest.record_protection_violation(pos, sender:get_player_name())
			return
		end
		local meta = minetest.get_meta(pos)
		if not fields.text then return end
		minetest.log("action", (sender:get_player_name() or "").." wrote \""..fields.text..
				"\" to sign at "..minetest.pos_to_string(pos))
		meta:set_string("text", fields.text)
		meta:set_string("infotext", '"'..fields.text..'"')
	end,
})

minetest.register_node("barcodes:bar_code", {
	description = ("Barcode"),
	tiles = {"barcodes_bar_code.png"},
	inventory_image = "barcodes_bar_code.png",
	wield_image = "barcodes_bar_code.png",
	groups = {dig_immediate = 2, unbreakable = 1},
	paramtype = 'light',
	paramtype2 = "wallmounted",
	legacy_wallmounted = true,
	drawtype = "nodebox",
	sunlight_propogates = false,
	node_box = {
		type = "wallmounted",
		wall_top    = {-0.5, 0.4375, -0.3125, 0.5, 0.5, 0.3125},
		wall_bottom = {-0.5, -0.5, -0.3125, 0.5, -0.4375, 0.3125},
		wall_side   = {-0.5, -0.3125, -0.5, -0.4375, 0.3125, 0.5},
	},
	selection_box = {type = "wallmounted"},

	on_construct = function(pos)
		--local n = minetest.get_node(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("formspec", "field[text;;${text}]")
		meta:set_string("infotext", "\"\"")
	end,
	on_receive_fields = function(pos, formname, fields, sender)
		--print("Sign at "..minetest.pos_to_string(pos).." got "..dump(fields))
		if minetest.is_protected(pos, sender:get_player_name()) then
			minetest.record_protection_violation(pos, sender:get_player_name())
			return
		end
		local meta = minetest.get_meta(pos)
		if not fields.text then return end
		minetest.log("action", (sender:get_player_name() or "").." wrote \""..fields.text..
				"\" to sign at "..minetest.pos_to_string(pos))
		meta:set_string("text", fields.text)
		meta:set_string("infotext", '"'..fields.text..'"')
	end,
})

minetest.register_craft({
	output = "barcodes:qr_code 2",
	recipe = {
		{"dye:black", "default:paper", "dye:black"},
		{"default:paper", "default:paper", "default:paper"},
		{"dye:black", "default:paper", "default:paper"},
	}
})

minetest.register_craft({
	output = "barcodes:bar_code 2",
	recipe = {
		{"dye:black", "default:paper", "dye:black"},
		{"dye:black", "default:paper", "dye:black"},
		{"dye:black", "default:paper", "dye:black"},
	}
})
