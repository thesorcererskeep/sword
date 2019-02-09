-- Internal dictionary
local _dictionary = {
  ["wait"] = {
    type = "verb",
    token = "wait",
  },
  ["walk"] = {
    type = "verb",
    token = "walk",
  },
  ["north"] = {
    type = "direction",
    token = "north"
  },
  ["take"] = {
    type = "verb",
    token = "take",
    syntax = "vo"
  },
  ["coin"] = {
    type = "noun",
    token = "coin"
  },
  ["shiny"] = {
    type = "adjective",
    token = "shiny"
  },
  ["the"] = {
    type = "ignore",
    token = nil
  },
  ["to"] = {
    type = "preposition",
    token = "to"
  },
  ["give"] = {
    type = "verb",
    token = "give"
  },
  ["brian"] = {
    type = "noun",
    token = "brian"
  },
  ["save"] = {
    type = "system",
    token = "save"
  }
}

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
  elseif word.type == "system" then
    local sys_args = table.concat(words, " ")
    local system = {
      command = word.token,
      args = sys_args
    }
    args.system = system
    return args
  elseif word.type ~= "verb" and word.type ~= "direction" then
    console.print("Your command must begin with a verb.")
    return
  end

  command.verb = word.token
  command.object.noun = nil
  if word.type == "direction" then
    command.verb = "walk"
    command.object.noun = word.token
  end

  return {
    command = command,
    words = words
  }
end

-- Check for a valid object
function parse_object(args, type)
  assert(args)
  local words = args.words
  local command = args.command or {}
  type = type or "object"
  command[type] = command[type] or {}

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
    elseif word.type == "verb" then
      console.print("I was expecting a noun.")
      return
    elseif word.type == "ignore" then
      -- skip it
    elseif word.type == "preposition" then
      command[type].preposition = word.token
    elseif word.type == "adjective" then
      command[type].adjective = word.token
    elseif word.type == "direction" then
      command[type].noun = word.token
      done = true
    elseif word.type == "noun" then
      command[type].noun = word.token
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
    print("## command = {")
    print("     verb = \"" .. command.verb .. "\"")
    print("     object.prep = \"" .. (command.object.preposition or "nil") .. "\"")
    print("     object.adj = \"" .. (command.object.adjective or "nil") .. "\"")
    print("     object.noun = \"" .. (command.object.noun or "nil") .. "\"")
    print("     indirect_object.prep = \"" .. (command.indirect_object.preposition or "nil") .. "\"")
    print("     indirect_object.adj = \"" .. (command.indirect_object.adjective or "nil") .. "\"")
    print("     indirect_object.noun = \"" .. (command.indirect_object.noun or "nil") .. "\"")
    print("}")
  end
end

local M = {
  prompt = prompt,
  parse = parse,
}

return M
