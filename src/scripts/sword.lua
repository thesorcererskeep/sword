-- sword.lua
-- Loads in all of the data files and starts the main loop

interpreter = require "interpreter"
world = require "world"
game = require "game"
require "utilities"

-- Loads in all of the game data
function init()
  if settings.debug then
    print("## settings = {")
    print("## " .. dump_table(settings))
    print("## }")
  end
  -- Load in all commands
  local path = settings.path_scripts
  dofile(path .. "commands.lua")

  -- Load in dictionary
  dofile(path .. "dictionary.lua")

  -- Load in blackwood
  dofile(path .. "blackwood.lua")
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
