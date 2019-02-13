-- commmands.lua
-- Adds all of the default commands to the interpreter

-- Exits the game
function do_quit(args)
  os.exit(0)
end
interpreter.add_command("quit", "Exits the game.", do_quit, {"q"})

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

-- Moves the player to a new location
function do_walk(args)
  local result = interpreter.parse_object(args)
  if not result then return end
  local object = result.object
  if not object or not object.noun then
    console.print("Which direction would you like to go?")
    return 0
  end
  local direction = object.noun
  local player = world.player
  local room = player:get_location()
  local destination = room.exits[direction]
  if not destination then
    console.print("The way is blocked.")
    return 0
  else
    player:set_location(destination)
    game.print_room_description(destination)
  end
  return 1
end
interpreter.add_command(
  "walk",
  "Move in the specified direction. WALK EAST",
  do_walk,
  {"go", "move", "crawl", "run"}
)
