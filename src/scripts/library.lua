-- Exits the game
local function do_quit(args)
  console.print("Goodbye.")
  os.exit(0)
end

-- Loads all default commands into the parser
local function open()
  parser.add_command("quit", do_quit, {"quit", "q"})
  parser.dump_commands()
end

local M = {
  open = open
}

return M
