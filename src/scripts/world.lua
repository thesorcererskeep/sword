local _rooms = {}
local _player = {}

-- Creates a new room and adds it to the world
local function add_room(token, settings)
  if not token then error("Room token not set in world.add_room") end
  if not settings then error("Room settings not set in world.add_room") end
  settings.visited = settings.visited or false
  _rooms[token] = settings
end

-- Returns the room the player is currently in
local function get_player_room()
  return _rooms[_player.location]
end

-- Convenience functions for modders
function Room(token, settings)
  add_room(token, settings)
end

function set_start(room)
  _player.location = room
end

local M = {
  add_room = add_room,
  get_player_room = get_player_room,
  player = _player
}

return M
