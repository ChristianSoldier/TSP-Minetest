
local BALL_PUSH_CHECK_INTERVAL = 0.1

local function reg_ball(color)

	local ball_item_name = "soccer:ball_"..color.."_item"
	local ball_ent_name = "soccer:ball_"..color.."_entity"

	minetest.register_entity(ball_ent_name, {
		physical = true,
		visual = "mesh",
		mesh = "soccer_ball.x",
		hp_max = 1000,
		groups = { immortal = true },
		textures = { "soccer_ball_"..color..".png" },
		collisionbox = { -0.2, -0.2, -0.2, 0.2, 0.2, 0.2 },

		timer = 0,

		on_step = function(self, dtime)
			self.timer = self.timer + dtime
			if self.timer >= BALL_PUSH_CHECK_INTERVAL then
				self.object:setacceleration({x=0, y=-10, z=0})
				self.timer = 0
				local vel = self.object:getvelocity()
				local p = self.object:getpos();
				p.y = p.y - 0.5
				if minetest.registered_nodes[minetest.env:get_node(p).name].walkable then
					vel.x = vel.x * 0.85
					if vel.y < 0 then vel.y = vel.y * -0.65 end
					vel.z = vel.z * 0.90
				end
				if  (math.abs(vel.x) < 0.1)
				 and (math.abs(vel.z) < 0.1) then
					vel.x = 0
					vel.z = 0
				end
				self.object:setvelocity(vel)
				local pos = self.object:getpos()
				local objs = minetest.env:get_objects_inside_radius(pos, 1)
				local player_count = 0
				local final_dir = { x=0, y=0, z=0 }
				for _,obj in ipairs(objs) do
					if obj:is_player() then
						local objdir = obj:get_look_dir()
						local mul = 1
						if (obj:get_player_control().sneak) then
							mul = 3
						end
						final_dir.x = final_dir.x + (objdir.x * mul)
						final_dir.y = final_dir.y + (objdir.y * mul)
						final_dir.z = final_dir.z + (objdir.z * mul)
						player_count = player_count + 1
					end
				end
				if final_dir.x ~= 0 or final_dir.y ~= 0 or final_dir.z ~= 0 then
					final_dir.x = (final_dir.x * 5) / player_count
					final_dir.y = (final_dir.y * 5) / player_count
					final_dir.z = (final_dir.z * 5) / player_count
					self.object:setvelocity(final_dir)
				end
			end
		end,

		on_punch = function(self, puncher)
			if puncher and puncher:is_player() then
				local inv = puncher:get_inventory()
				inv:add_item("main", ItemStack(ball_item_name))
				self.object:remove()
			end
		end,

		is_moving = function(self)
			local v = self.object:getvelocity()
			if  (math.abs(v.x) <= 0.1)
			 and (math.abs(v.z) <= 0.1) then
				v.x = 0
				v.z = 0
				self.object:setvelocity(v)
				return false
			end
			return true
		end,
	})

	minetest.register_craftitem(ball_item_name, {
		description = "Soccer Ball ("..color..")",
		inventory_image = "soccer_ball_"..color.."_inv.png",

		on_place = function(itemstack, placer, pointed_thing)
			local pos = pointed_thing.above
			--pos = { x=pos.x+0.5, y=pos.y, z=pos.z+0.5 }
			local ent = minetest.env:add_entity(pos, ball_ent_name)
			ent:setvelocity({x=0, y=-15, z=0})
			itemstack:take_item()
			return itemstack
		end,
	})

	minetest.register_craft({
		output = ball_item_name,
		recipe = {
			{ "", "wool:white", "" },
			{ "wool:white", "wool:"..color, "wool:white" },
			{ "", "wool:white", "" },
		},
	})

end

colors = {
	"black", "red", "green", "blue", "yellow", "purple",
}

for _,color in ipairs(colors) do
	reg_ball(color)
end

minetest.register_node("soccer:goal", {
	description = "Soccer Goal",
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	tiles = { "soccer_white.png" },
	sunlight_propagates = true,
	groups = { snappy=1, cracky=1, fleshy=1, oddly_breakable_by_hand=1 },
	node_box = {
		type = "fixed",
		fixed = {
			{ -2.5, -0.5, -0.1, -2.3, 1.5, 0.1 },
			{  2.3, -0.5, -0.1,  2.5, 1.5, 0.1 },
			{ -2.5,  1.5, -0.1,  2.5, 1.7, 0.1 },
		},
	},
})

local nb_decal = {
	type = "fixed",
	fixed = {{ -0.5, -0.5, -0.5, 0.5, -0.499, 0.5 }},
},

minetest.register_node("soccer:goal_mark", {
	description = "Soccer Goal Mark",
	drawtype = "nodebox",
	paramtype = "light",
	node_box = nb_decal,
	walkable = false,
	inventory_image = "soccer_goal_mark.png",
	tiles = { "soccer_goal_mark.png" },
	sunlight_propagates = true,
	groups = { snappy=1, cracky=1, fleshy=1, oddly_breakable_by_hand=1 },
})

local function reg_decal(name, desc)
	texture = "soccer_"..name..".png"
	minetest.register_node("soccer:"..name, {
		description = desc,
		drawtype = "nodebox",
		paramtype = "light",
		paramtype2 = "facedir",
		node_box = nb_decal,
		walkable = false,
		inventory_image = texture,
		wield_image = texture,
		tiles = { texture },
		sunlight_propagates = true,
		groups = { snappy=1, cracky=1, fleshy=1, oddly_breakable_by_hand=1 },
	})
end

reg_decal("line_i", "Straight Line")
reg_decal("line_l", "L line")
reg_decal("line_t", "T Line")
reg_decal("line_p", "+ Line")
reg_decal("line_d", "Diagonal Line")
reg_decal("line_point", "Point")
reg_decal("line_corner", "Corner")

minetest.register_alias("ball", "soccer:ball_item_black")
