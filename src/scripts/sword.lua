-- sword.lua
-- Loads in all of the data files and starts the main loop

interpreter = require "interpreter"
world = require "world"

-- Loads in all of the game data
function init()
  -- Load in all commands
  dofile("data/scripts/commands.lua")

  Room{
    key = "cave",
    name = "Cave",
    description = "You are standing in a damp cave."
  }

  Start('cave')
end

-- Runs the game
function main()
  init()
  local room = world.player:get_location()
  console.print(room.name)
  console.print(room.description)
  while true do
    interpreter.run()
  end
end

main()
