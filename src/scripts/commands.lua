-- commmands.lua
-- Adds all of the default commands to the interpreter

-- Exits the game
function do_quit(args)
  os.exit(0)
end
interpreter.add_command("quit", "Exits the game.", do_quit, {"q"})

-- Skips a turn
function do_wait(args)
  console.print("Time passes.")
  return 1
end
interpreter.add_command("wait", "Skips a turn.", do_wait, {"z"})

-- Prints the full room description
function do_look(args)
  game.print_room_description(world.player:get_location(), true)
  return 0
end
interpreter.add_command(
  "look",
  "Displays information about the room you are in.",
  do_look,
  {"l"}
)

-- Prints the number of turns played
function do_turns(args)
  local turns = world.player.turns
  console.print("You have been playing for " .. turns .. " turns.")
  return 0
end
interpreter.add_command(
  "turns",
  "Displays the number of turns you have played.",
  do_turns
)
