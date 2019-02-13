-- commmands.lua
-- Adds all of the default commands to the interpreter

-- Exita the game
function do_quit(args)
  os.exit(0)
end

interpreter.add_command("quit", "Exits the game.", do_quit, {"q"})

function do_wait(args)
  console.print("Time passes.")
  return 1
end

interpreter.add_command("wait", "Skips a turn.", do_wait, {"z"})
