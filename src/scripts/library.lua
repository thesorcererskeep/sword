-- Exits the game
local function do_quit(args)
  console.print("Goodbye.")
  os.exit(0)
end

-- Skip a turn
local function do_wait(args)
  console.print("Time passes.")
  return 1
end

-- Loads all default commands into the parser
local function open()
  parser.add_command("quit",
                     do_quit,
                     {
                       verbs = {"quit", "q"}
                     })
  parser.add_command("wait",
                     do_wait,
                     {
                       verbs = {"wait", "z"}
                     })
  parser.dump_commands()
end

local M = {
  open = open
}

return M
