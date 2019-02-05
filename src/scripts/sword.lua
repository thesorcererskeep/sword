parser = require "parser"
library = require "library"
world = require "world"

function main()
  library.open()
  dofile("./data/scripts/blackwood.lua")
  while true do
    local room = world.get_player_room()
    console.print(room.name)
    console.print(room.description)
    console.print()
    s = parser.prompt()
    parser.parse(s)
  end
end

main()
