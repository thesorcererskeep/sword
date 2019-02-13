-- sword.lua
-- Loads in all of the data files and starts the main loop

interpreter = require "interpreter"

-- Loads in all of the game data
function init()
  -- Load in all commands
  dofile("data/scripts/commands.lua")
end

-- Runs the game
function main()
  init()
  while true do
    interpreter.run()
  end
end

main()
