parser = require "parser"
library = require "library"
world = require "world"

function main()
  library.open()
  while true do
    s = parser.prompt()
    parser.parse(s)
  end
end

main()
