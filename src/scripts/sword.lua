-- sword.lua
-- Loads in all of the data files and starts the main loop

interpreter = require "interpreter"
world = require "world"
game = require "game"
require "utilities"

-- Loads in all of the game data
function init()
  -- Load in all commands
  dofile("data/scripts/commands.lua")

  -- Load in dictionary
  dofile("data/scripts/dictionary.lua")

  -- Load in blackwood
  dofile("data/scripts/blackwood.lua")
  
end

-- Runs the game
function main()
  init()
  print()
  game.print_room_description(world.player:get_location())
  while true do
    local turns = interpreter.interpret_input()
    if turns ~= nil then
      game.update(turns)
    end
  end
end

main()
