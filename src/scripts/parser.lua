-- Internal dictionary
local _dictionary = {
  ["wait"] = {
    token = "verb",
    value = "wait",
  },
  ["walk"] = {
    token = "verb",
    value = "walk",
  },
  ["north"] = {
    token = "direction",
    value = "north"
  },
  ["take"] = {
    token = "verb",
    value = "take",
    syntax = "vo"
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
    value = "give"
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
  s = console.read_line()
  s = s:lower()
  return s
end

-- Checks for a valid verb
local function parse_verb(args)
  assert(args)
  local words = args.words
  local command = args.command or {}
  command.object = command.object or {}

  local verb_word = table.remove(words, 1)
  local word = _dictionary[verb_word]
  if not word then
    console.print("I don't understand the word \"" .. verb_word .. "\"")
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
  command.object.noun = nil
  if word.token == "direction" then
    command.verb = "walk"
    command.object.noun = word.value
  end

  return {
    command = command,
    words = words
  }
end

-- Check for a valid object
function parse_object(args, token)
  assert(args)
  local words = args.words
  local command = args.command or {}
  token = token or "object"
  command[token] = command[token] or {}

  if settings.debug then print("## #words = " .. #words) end

  local done = false
  while not done do
    local obj_word = table.remove(words, 1)
    if not obj_word then
      return args
    end
    word = _dictionary[obj_word]
    if not word then
      console.print("I don't understand the word \"" .. obj_word .. "\"")
      return
    elseif word.token == "verb" then
      console.print("I was expecting a noun.")
      return
    elseif word.token == "ignore" then
      -- skip it
    elseif word.token == "preposition" then
      command[token].preposition = word.value
    elseif word.token == "adjective" then
      command[token].adjective = word.value
    elseif word.token == "direction" then
      command[token].noun = word.value
      done = true
    elseif word.token == "noun" then
      command[token].noun = word.value
      done = true;
    end
  end

  return {
    words = words,
    command = command
  }
end

-- Attempt to interpret the player's command
local function parse(s)
  -- Ignore blank input
  s = s:trim()
  if not s or s == "" then
    console.print("Beg your pardon?")
    return
  end

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

  local command = args.command
  if settings.debug then
    io.write("## command = ")
    print_table(command)
  end
end

local M = {
  prompt = prompt,
  parse = parse,
}

return M
