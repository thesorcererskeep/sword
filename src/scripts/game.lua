-- game.lua
-- Gameplay functions

-- Prints a description of a room and it's contents
-- Parameters:
-- room - The room of which to print it's description
-- full - If true, will print the full description even if it's been visited
function print_room_description(room, full)
  assert(room)
  assert(type(room) == "table")
  if full then room.visited = false end

  print(room.name)
  if not room.visited then
    print(room.description)
    room.visited = true
  end
end

function update(turns)
  world.player.turns = world.player.turns + turns
end

local M = {
  print_room_description = print_room_description,
  update = update
}

return M
