local _rooms = {}

-- Creates a new room and adds it to the world
local function add_room(token, settings)
  _rooms[token] = settings
end

local M = {
  add_room = add_room
}

return M
