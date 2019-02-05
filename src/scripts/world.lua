local _rooms = {}
local _player = {}

-- Creates a new room and adds it to the world
local function add_room(token, settings)
  if not token then error("Undefined token in world.add_room") end
  if not settings then error("Undefined settings in world.add_room") end
  settings.visited = settings.visited or false
  _rooms[token] = settings
end

-- Returns the room the player is currently in
local function get_player_room()
  return _rooms[_player.location]
end

-- Convenience functions for modders
function Room(settings)
  add_room(settings.token, settings)
end

function set_start(room)
  _player.location = room
end

local M = {
  add_room = add_room,
  get_player_room = get_player_room
}

return M
