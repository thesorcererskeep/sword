parser = require "parser"
library = require "library"

function main()
  library.open()
  while true do
    s = parser.prompt()
    parser.parse(s)
  end
end

main()
