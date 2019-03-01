-- game.lua
-- Gameplay functions

-- Prints a description of a room and its contents
-- Parameters:
-- room - The room of which to print its description
-- full - If true, will print the full description even if it's been visited
local function print_room_description(room, full)
  assert(room)
  if type(room) == "string" then
    room = world.get_room(room)
  end
  if full then room.visited = false end

  console.print(room.name)
  if not room.visited then
    console.print(room.description)
    room.visited = true
  end

  -- Print the items in the room
  local items = world.get_items_in(room)
  if items then
    for _, item in pairs(items) do
      console.print("There is " .. item.determiner .. " " .. item.name .. " here.")
    end
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
