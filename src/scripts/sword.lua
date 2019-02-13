-- sword.lua
-- Loads in all of the data files and starts the main loop

interpreter = require "interpreter"
world = require "world"
game = require "game"

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
  print()
  game.print_room_description(world.player:get_location())
  while true do
    local turns = interpreter.run()
    if turns ~= nil then
      game.update(turns)
    end
  end
end

main()
