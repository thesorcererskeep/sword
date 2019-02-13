-- game.lua
-- Gameplay functions

-- Prints a description of a room and it's contents
-- Parameters:
-- room - The room of which to print it's description
-- full - If true, will print the full description even if it's been visited
local function print_room_description(room, full)
  assert(room)
  if type(room) == "string" then
    room = world.get_room(room)
  end
  if full then room.visited = false end

  print(room.name)
  if not room.visited then
    print(room.description)
    room.visited = true
  end
end

-- Updates the game after player input
-- Parameters:
-- turns - Number of turns that have elapsed
local function update(turns)
  if turns < 0 then return end
  world.player.turns = world.player.turns + turns
end

local M = {
  print_room_description = print_room_description,
  update = update
}

return M
