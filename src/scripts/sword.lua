parser = require "parser"

function main()
  while true do
    s = parser.prompt()
    parser.parse(s)
  end
end

main()
