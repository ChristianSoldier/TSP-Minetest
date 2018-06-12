-- Nuke Mod 2.1 by sfan5
-- code licensed under MIT

local all_tnt = {}

local function spawn_tnt(pos, entname)
	minetest.sound_play("nuke_ignite", {pos = pos, gain = 1.0, max_hear_distance = 8})
	return minetest.add_entity(pos, entname)
end

local function calculate_velocity(distance, tntradius, mult)
	-- (d is the distance vector)
	--            tntradius - | d |
	-- vel = d * ------------------- * mult
	--              tntradius - 1
	return vector.multiply(vector.multiply(distance, (tntradius - vector.length(distance)) / (tntradius - 1)), mult)
end

local function activate_if_tnt(nodename, nodepos, tntpos, tntradius)
	local explodetime_short = 4 -- seconds
	local explodetime_vary = 1.5
	if table.indexof(all_tnt, nodename) == -1 then
		return
	end
	local obj = spawn_tnt(nodepos, nodename)
	obj:setvelocity(calculate_velocity(vector.subtract(nodepos, tntpos), tntradius, {x=3, y=5, z=3}))
	obj:get_luaentity().timer = explodetime_short + math.random(-explodetime_vary, explodetime_vary)
end

local function apply_tnt_physics(tntpos, tntradius)
	local objs = minetest.get_objects_inside_radius(tntpos, tntradius)
	for _, obj in ipairs(objs) do
		if obj:is_player() then
			if obj:get_hp() > 0 then
				obj:set_hp(obj:get_hp() - 1)
			end
		else
			local mult = {x=1.5, y=2.5, z=1.5}
			if table.indexof(all_tnt, obj:get_entity_name()) ~= -1 then
				mult = vector.multiply(mult, 2) -- apply more knockback to tnt entities
			end
			local vel = vector.add(obj:getvelocity(), calculate_velocity(vector.subtract(obj:getpos(), tntpos), tntradius, mult))
			obj:setvelocity(vel)
		end
	end
end


local function register_tnt(nodename, desc, tex, on_explode)
	local explodetime = 10 -- seconds
	local texfinal
	if type(tex) == "table" then
		texfinal = tex
	else
		texfinal = {tex.."_top.png", tex.."_bottom.png", tex.."_side.png"}
	end
	minetest.register_node(nodename, {
		tiles = texfinal,
		diggable = false,
		description = desc,
		mesecons = {
			effector = {
				action_on = function(pos, node)
					minetest.remove_node(pos)
					spawn_tnt(pos, node.name)
					nodeupdate(pos)
				end,
				action_off = function(pos, node) end,
				action_change = function(pos, node) end,
			},
		},
		on_punch = function(pos, node, puncher)
			minetest.remove_node(pos)
			spawn_tnt(pos, node.name)
			nodeupdate(pos)
		end,
	})
	local entity = {
		physical = true, -- collision
		collisionbox = {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
		visual = "cube",
		textures = {texfinal[1], texfinal[2], texfinal[3], texfinal[3], texfinal[3], texfinal[3]},
		health = 1, -- number of punches required to defuse

		timer = 0,
		blinktimer = 0,
		blinkstatus = true,
	}
	function entity:on_activate(staticdata)
		self.object:setvelocity({x=0, y=4, z=0})
		self.object:setacceleration({x=0, y=-10, z=0}) -- gravity
		self.object:settexturemod("^[brighten")
	end
	function entity:on_step(dtime)
		self.timer = self.timer + dtime
		local mult = 1
		if self.timer > explodetime * 0.8 then -- blink faster before explosion
			mult = 4
		elseif self.timer > explodetime * 0.5 then
			mult = 2
		end
		self.blinktimer = self.blinktimer + mult * dtime

		if self.blinktimer > 0.5 then -- actual blinking
			self.blinktimer = self.blinktimer - 0.5
			if self.blinkstatus then
				self.object:settexturemod("")
			else
				self.object:settexturemod("^[brighten")
			end
			self.blinkstatus = not self.blinkstatus
		end

		if self.timer > explodetime then -- boom!
			on_explode(vector.round(self.object:getpos()))
			self.object:remove()
		end
	end
	function entity:on_punch(hitter)
		self.health = self.health - 1
		if self.health == 0 then -- give tnt node back if defused
			self.object:remove()
			if not minetest.setting_getbool("creative_mode") then
				hitter:get_inventory():add_item("main", nodename)
			end
		end
	end
	minetest.register_entity(nodename, entity)
	all_tnt[#all_tnt + 1] = nodename
end


local function on_explode_normal(pos, range)
	minetest.sound_play("nuke_explode", {pos = pos, gain = 1.0, max_hear_distance = 32})
	local nd = minetest.registered_nodes[minetest.get_node(pos).name]
	if nd ~= nil and nd.groups.water ~= nil then
		apply_tnt_physics(pos, range)
		return -- cancel explosion
	end
	for x=-range, range do
	for y=-range, range do
	for z=-range, range do
		if x*x+y*y+z*z <= range * range + range then
			local nodepos = vector.add(pos, {x=x, y=y, z=z})
			local n = minetest.get_node(nodepos)
			if n.name ~= "air" then
				activate_if_tnt(n.name, nodepos, pos, range)
				minetest.remove_node(nodepos)
			end
		end
	end
	end
	end
	apply_tnt_physics(pos, range)
end

local function on_explode_split(pos, range, entname)
	minetest.sound_play("nuke_explode", {pos = pos, gain = 1.0, max_hear_distance = 16})
	for x=-range, range do
	for z=-range, range do
		if x*x+z*z <= range * range then
			local nodepos = vector.add(pos, {x=x, y=0, z=z})
			minetest.add_entity(nodepos, entname)
		end
	end
	end
end


-- Iron TNT

register_tnt("nuke:iron_tnt", "Iron TNT", "nuke_iron_tnt", function(pos)
	on_explode_normal(pos, 6)
end)

minetest.register_craft({
	output = "nuke:iron_tnt 4",
	recipe = {
		{"", "group:wood", ""},
		{"default:steel_ingot", "default:coal_lump", "default:steel_ingot"},
		{"", "group:wood", ""},
	}
})


register_tnt(
	"nuke:iron_tntx", "Extreme Iron TNT",
	{"nuke_iron_tnt_top.png", "nuke_iron_tnt_bottom.png", "nuke_iron_tnt_side_x.png"},
	function(pos)
		on_explode_split(pos, 3, "nuke:iron_tnt")
	end
)

minetest.register_craft({
	output = "nuke:iron_tntx 1",
	recipe = {
		{"", "default:coal_lump", ""},
		{"default:coal_lump", "nuke:iron_tnt", "default:coal_lump"},
		{"", "default:coal_lump", ""},
	}
})

-- Mese TNT

register_tnt("nuke:mese_tnt", "Mese TNT", "nuke_mese_tnt", function(pos)
	on_explode_normal(pos, 12)
end)

minetest.register_craft({
	output = "nuke:mese_tnt 4",
	recipe = {
		{"", "group:wood", ""},
		{"default:mese_crystal", "default:coal_lump", "default:mese_crystal"},
		{"", "group:wood", ""},
	}
})


register_tnt(
	"nuke:mese_tntx", "Extreme Mese TNT",
	{"nuke_mese_tnt_top.png", "nuke_mese_tnt_bottom.png", "nuke_mese_tnt_side_x.png"},
	function(pos)
		on_explode_split(pos, 3, "nuke:mese_tnt")
	end
)

minetest.register_craft({
	output = "nuke:mese_tntx 1",
	recipe = {
		{"", "default:coal_lump", ""},
		{"default:coal_lump", "nuke:mese_tnt", "default:coal_lump"},
		{"", "default:coal_lump", ""},
	}
})

-- Compatibility aliases

minetest.register_alias("nuke:hardcore_iron_tnt", "nuke:iron_tntx")
minetest.register_alias("nuke:hardcore_mese_tnt", "nuke:mese_tntx")


if minetest.setting_getbool("log_mods") then
	print("[Nuke] Loaded")
end
