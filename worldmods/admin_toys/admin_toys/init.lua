minetest.register_chatcommand("antigravity", {
   params = "<person>",
   description = "Gives that person antigravity",
   privs = {server=true},
   func = function(name, param)
     if param == nil then
       param = name
     end
     players = string.split(param,",");
     for i=1,#players do
       local currplayer = minetest.get_player_by_name(players[i]);
       currplayer:set_physics_override({gravity = -0.1})
       minetest.chat_send_player(name, "Gave antigravity to " .. players[i])
     end
 end,
})
minetest.register_chatcommand("freeze", {
   params = "<person>",
   description = "Sets speed+jump to 0. Can't move unless teleported or blocks removed under them",
   privs = {server=true},
   func = function(name, param)
     if param == nil then
       param = name
     end
     players = string.split(param,",");
     for i=1,#players do
       local currplayer = minetest.get_player_by_name(players[i]);
       currplayer:set_physics_override({jump = 0, speed = 0})
       minetest.chat_send_player(name, "Froze " .. players[i])
     end
 end,
})

minetest.register_chatcommand("jump",{
	params = "<person>",
	description = "Gives that person huge jump boost, usually killing them.",
	privs = {server=true},
  func = function(name, param)
    if param == nil then
      param = name
    end
    players = string.split(param,",");
    for i=1,#players do
      local currplayer = minetest.get_player_by_name(players[i]);
      currplayer:set_physics_override({jump = 1000})
      minetest.chat_send_player(name, "Gave sumperjump to " .. players[i])
    end
end,
})

minetest.register_chatcommand("fast",{
	params = "<person>",
	description = "Gives that person a lot of speed",
	privs = {server=true},
  func = function(name, param)
    if param == nil then
      param = name
    end
    players = string.split(param,",");
    for i=1,#players do
      local currplayer = minetest.get_player_by_name(players[i]);
      currplayer:set_physics_override({speed = 10})
      minetest.chat_send_player(name, "Gave superspeed to " .. players[i])
    end
end,
})

minetest.register_chatcommand("controls",{
	params = "<person>",
	description = "Gives that person very quirky controls, resulting in a literally uncontrollable character. Use with caution!",
	privs = {server=true},
  func = function(name, param)
    if param == nil then
      param = name
    end
    players = string.split(param,",");
    for i=1,#players do
      local currplayer = minetest.get_player_by_name(players[i]);
      currplayer:set_physics_override({speed = -1})
      minetest.chat_send_player(name, "Gave antispeed to " .. players[i])
    end
end,
})

minetest.register_chatcommand("glide",{
	params = "<person>",
	description = "Anti-fall damage. Slows your descent.",
	privs = {server=true},
  func = function(name, param)
    if param == nil then
      param = name
    end
    players = string.split(param,",");
    for i=1,#players do
      local currplayer = minetest.get_player_by_name(players[i]);
      currplayer:set_physics_override({jump = 0.3, gravity = 0.1})
      minetest.chat_send_player(name, "Gave glidability to " .. players[i])
    end
  end,
})


minetest.register_chatcommand("reset",{
	params = "<person>",
	description = "Resets gravity, eye offset, visual size and whether they are invisible",
	privs = {server=true},
  func = function(name, param)
    if param == nil then
      param = name
    end
    players = string.split(param,",");
    for i=1,#players do
      local currplayer = minetest.get_player_by_name(players[i]);
      currplayer:set_physics_override({jump = 1, gravity = 1, speed = 1})
      minetest.chat_send_player(name, "Reset physics of " .. players[i])
    end
  end,
})
