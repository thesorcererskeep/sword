-- Internal dictionary
local _dictionary = {
  ["wait"] = {
    token = "verb",
    value = "wait",
    syntax = {
      object = false,
      indirect_object = false,
    }
  },
  ["walk"] = {
    token = "verb",
    value = "walk",
    syntax = {
      object = true,
      indirect_object = false,
    }
  },
  ["north"] = {
    token = "direction",
    value = "north"
  },
  ["take"] = {
    token = "verb",
    value = "take",
    syntax = {
      object = true,
      indirect_object = false,
    }
  },
  ["coin"] = {
    token = "noun",
    value = "coin"
  },
  ["shiny"] = {
    token = "adjective",
    value = "shiny"
  },
  ["the"] = {
    token = "ignore",
    value = nil
  },
  ["to"] = {
    token = "preposition",
    value = "to"
  },
  ["give"] = {
    token = "verb",
    value = "give",
    syntax = {
      object = true,
      indirect_object = true,
    },
  },
  ["brian"] = {
    token = "noun",
    value = "brian"
  },
  ["save"] = {
    token = "system",
    value = "save"
  }
}

-- Pretty prints a table
local function print_table(t, i)
  local indent = i or 1
  local spaces = string.rep(" ", indent * 2)
  local spc = ""
  if indent > 1 then
    spc = string.rep(" ", (indent - 1) * 2)
  end
  print("{")
  for k, v in pairs(t) do
    io.write(spaces .. k .. " = ")
    if type(v) == "string" then print('"' .. v .. '",')
    elseif type(v) == "number" then print(v .. ",")
    elseif type(v) == "boolean" then print(tostring(v) .. ",")
    elseif type(v) == "table" then
      print_table(v, indent + 1)
    else
      print("[unknown]")
    end
  end
  print(spc .. "}")
end

-- Prompt the player for input
local function prompt(message)
  if message then console.print(message) end
  local s = nil
  while not s do
    s = console.read_line()
    s = s:lower()

    -- Ignore blank input
    s = s:trim()
    if not s or s == "" then
      console.print("Beg your pardon?")
    end
  end
  return s
end

-- Ask the player to supply an object
local function prompt_for_object(message)
  local s = prompt(message)
  words = s:split()
  local args = parse_object({
    words = words,
    command = {}
  })
  if not args.command or not args.command.object then
    console.print("I don't understand what you are trying to do.")
    return
  end
  return args.command
end

-- Ask the user to supply an indirect_object
local function prompt_for_indirect_object(message)
  local s = prompt(message)
  words = s:split()
  local args = parse_object({
    words = words,
    command = {}
  },
  "indirect_object")
  if not args.command or not args.command.indirect_object then
    console.print("I don't understand what you are trying to do.")
    return
  end
  return args.command
end

-- Checks for a valid verb
local function parse_verb(args)
  assert(args)
  local words = args.words
  local command = args.command or {}

  local w = table.remove(words, 1)
  local word = _dictionary[w]
  if not word then
    console.print("I don't understand the word \"" .. w .. ".\"")
    return
  elseif word.token == "system" then
    local sys_args = table.concat(words, " ")
    local system = {
      command = word.value,
      args = sys_args
    }
    args.system = system
    return args
  elseif word.token ~= "verb" and word.token ~= "direction" then
    console.print("Your command must begin with a verb.")
    return
  end

  command.verb = word.value
  command.verb_string = w;
  if word.token == "direction" then
    command.verb = "walk"
    command.object = command.object or {}
    command.object.noun = word.value
  end

  return {
    command = command,
    words = words
  }
end

-- Check for a valid object
function parse_object(args, key)
  assert(args)
  local words = args.words
  local command = args.command or {}
  local key = key or "object"
  command[key] = command[key] or {}

  if settings.debug then print("## #words = " .. #words) end

  local done = false
  while not done do
    local w = table.remove(words, 1)
    if not w then
      done = true
      break
    end
    word = _dictionary[w]
    if not word then
      console.print("I don't understand the word \"" .. w .. ".\"")
      return
    elseif word.token == "verb" then
      console.print("I was expecting a noun after \"" .. command.verb_str .. ".\"")
      return
    elseif word.token == "ignore" then
      -- skip it
    elseif word.token == "preposition" then
      command[key].preposition = word.value
      command[key].preposition_string = w
    elseif word.token == "adjective" then
      command[key].adjective = word.value
      command[key].adjective_string = w
    elseif word.token == "direction" then
      command[key].noun = word.value
      command[key].noun_string = w
      done = true
    elseif word.token == "noun" then
      command[key].noun = word.value
      command[key].noun_string = w
      done = true;
    end
  end

  if not command[key].noun then
    command[key] = nil
  end

  return {
    words = words,
    command = command
  }
end

-- Check if a command is semantically valid
local function analyse_semantics(args)
  assert(args)
  local command = args.command
  local syntax = _dictionary[command.verb].syntax
  -- Skip if the command provides it's own semantic checking
  if syntax.user_function then return end

  -- Check for a valid object and prompt for one if there isn't
  if syntax.object then
    if not command.object or not command.object.noun then
      if command.verb == "walk" then
        print("Which direction would you like to go?")
        return
      else
        print("What are you trying to " .. command.verb_string .. "?")
        local cmd = prompt_for_object()
        if not cmd then return end;
        args.command.object = cmd.object;
      end
    end
  end

  -- Check for a valid indirect_object and prompt for one if there isn't
  if syntax.indirect_object then
    if not command.indirect_object or not command.indirect_object.noun then
      print("What are you trying to " .. command.verb_string .. " the " .. command.object.noun_string .. " to?")
      local cmd = prompt_for_indirect_object()
      if not cmd then return end;
      args.command.indirect_object = cmd.indirect_object;
    end
  end
  return args
end

-- Attempt to interpret the player's command
local function parse(s)
  assert(s)

  if settings.debug then print("## s = \"" .. s .. "\"") end

  -- Split sentence into words
  local words = s:split()

  -- Find the verb
  args = parse_verb({words = words})
  if not args then return end
  if args.system then
    if settings.debug then
      print("## system command: " .. args.system.command .. "(\"" .. args.system.args .. "\")")
    end
    -- Execute system command
    return
  end

  -- Find the object
  if #words > 0 then
    args = parse_object(args)
    if not args then return end
  end

  -- Find the indirect object
  if #words > 0 then
    args = parse_object(args, "indirect_object")
    if not args then return end
  end

  -- Make sure the command makes sense
  if args.command then
    args = analyse_semantics(args)
    if not args then return end
  else
    console.print("I don't understand what you mean.")
    return
  end

  local command = args.command
  if settings.debug then
    io.write("## command = ")
    print_table(command)
  end
  return command
end

function add_word(word, token, value, syntax)
  assert(word)
  assert(token)
  assert(value)
  local syntax = syntax or {
    user_function = false,
    object = true,
    indirect_object = false
  }
  if _dictionary[word] ~= nil and settings.debug then
    console.print("Warning: Overwriting dictionary entry for \"" .. word .. ".\"")
  end
  _dictionary[word] = {
    token = token,
    value = value,
    syntax = syntax
  }
end

local M = {
  prompt = prompt,
  prompt_for_object = prompt_for_object,
  prompt_for_indirect_object = prompt_for_indirect_object,
  parse = parse,
  add_word = add_word,
}

return M
