parser = require "parser"

function main()
  while true do
    s = parser.prompt()
    console.print(s)
  end
end

main()
