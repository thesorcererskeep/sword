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
  "Move in the specified direction. E.g. WALK EAST",
  do_walk,
  {"go", "move", "crawl", "run"}
)

-- Saves the game
function do_save(args)
  local words = args
  if not words or #words < 1 then
    words = {}
    console.print("Filename:")
    local s = interpreter.prompt()
    if not s then
      console.print("Error: No output filename.")
      return
    else
      words[1] = s
    end
  end
  if #words > 1 then
    console.print("Warning: Truncating file name.")
  end
  local filename = words[1]
  local ext = string.sub(filename, string.len(filename) - 3,
              string.len(filename))
  if ext ~= ".sav" then filename = filename .. ".sav" end
  local data = world.serialize()
  local path = settings.path_save .. filename
  local f = io.open(path, "w")
  if not f then
    console.print("Error: Unable to open save \"" .. filename .. "\"")
    return
  end
  f:write(data)
  if not f then
    console.print("Error: Unable to write save \"" .. filename .. "\"")
    return
  end
  f:close()
  console.print('"'.. filename .. '" saved.')
  return 0
end
interpreter.add_command(
  "save",
  "Saves your progress in the game. Usage: SAVE [FILE]",
  do_save
)

-- Loads a save game file
function do_load(args)
  local words = args
  if not words or #words < 1 then
    words = {}
    console.print("Filename:")
    local s = interpreter.prompt()
    if not s then
      console.print("Error: No input filename.")
      return
    else
      words[1] = s
    end
  end
  if #words > 1 then
    console.print("Warning: Truncating file name.")
  end
  local filename = words[1]
  local ext = string.sub(filename, string.len(filename) - 3,
              string.len(filename))
  if ext ~= ".sav" then filename = filename .. ".sav" end
  local path = settings.path_save .. filename
  local f = loadfile(path)
  if not f then
    console.print("Error: Unable to read save \"" .. filename .. "\"")
    return
  end
  f();
  world.deserialize(world_data)
  console.print('"' .. filename .. '" loaded.')
  console.print()
  game.print_room_description(world.player:get_location(), true)
  return 0
end
interpreter.add_command(
  "load",
  "Loads a save game file. Usage: LOAD [FILE]",
  do_load,
  {"restore"}
)

-- Loads a save game file
function do_help(args)
  local words = args
  if not words or #words < 1 then
    local keywords = interpreter.list_commands()
    local s = ""
    for _, v in pairs(keywords) do s = s .. "\t" .. v end
    console.print("I understand the following commands:")
    console.print(s)
    console.print("Type HELP [COMMAND] for more.")
  else
    interpreter.print_help(words[1])
  end
  return 0
end
interpreter.add_command(
  "help",
[[Invokes the game's help text. Usage: HELP [*COMMAND]\n
Typing help will display a list of all commands. Specifying and optional
command will display the help text for that specific command.]],
  do_help,
  {"?"}
)

-- Prints an entity's description
function do_examine(args)
  local result = interpreter.parse_object(args)
  if not result then return end
  local object = result.object
  if not object or not object.noun then
    console.print("What would you like to examine?")
    s = interpreter.prompt()
    local w = s:split()
    result = interpreter.parse_object(w)
    if not result then
      console.print("I don't understand what you are trying to do.")
      return 0
    end
  end
  local entity = world.find_entities(result.object.noun, nil, world.player:get_location())
  if not entity or #entity < 1 then
    console.print("You don't see any " .. result.object.noun .. " here.")
  else
    console.print(entity[1].item.description)
  end
  return 1
end
interpreter.add_command(
  "examine",
  "Takes a closer look at an item or person. E.g. EXAMINE SWORD",
  do_examine,
  {"x"}
)

-- Places an item in the player's inventory
function do_take(args)
  local result = interpreter.parse_object(args)
  if not result then return end
  local object = result.object
  if not object or not object.noun then
    console.print("What would you like to take?")
    s = interpreter.prompt()
    local w = s:split()
    result = interpreter.parse_object(w)
    if not result then
      console.print("I don't understand what you are trying to do.")
      return 0
    end
  end
  local entity = world.find_entities(result.object.noun, nil, world.player:get_location())
  if not entity or #entity < 1 then
    console.print("You don't see any " .. result.object.noun .. " here.")
  else
    entity[1].item:set_location(world.player)
    print("Taken.")
  end
  return 1
end
interpreter.add_command(
  "take",
  "Picks up an item. E.g. TAKE COIN",
  do_take,
  {""}
)
