-- interpreter.lua
-- Attempts to convert the player's input and execute the command

_dictionary = {} -- The interpreter's vocabulary
_commands   = {} -- All commands the interpreter knows

-- Prompts the user for input
-- Returns a string
local function prompt()
  local s = nil
  while not s do
    s = console.read_line()
    s = s:lower()
    s = s:trim()
    if not s then
      console.print("Beg your pardon?")
    else
      return s
    end
  end
end

-- Parses a string and returns a commands
-- Returns a table or nil
local function parse(s)
  assert(s)
  if settings.debug then
    print("## Parsing \"" .. s .. "\"")
  end
  local words = s:split()
  if #words < 1 then
    console.print("Beg your pardon?")
    return
  end

  local verb = table.remove(words, 1)
  local entry = {}
  -- Make a copy of the dictionary entry so we don't accidentally overwrite it
  if _dictionary[verb] then
    entry.token = _dictionary[verb].token
    entry.value = _dictionary[verb].value
  else
    entry = nil
  end
  if settings.debug and entry then
    print("## entry = {")
    print("  token = '" .. entry.token .. "'")
    print("  value = '" .. entry.value .. "'")
    print("}")
  end
  if not entry then
    console.print('I don\'t understand the word "' .. verb ..'."')
    return
  elseif entry.token == "direction" then
    table.insert(words, 1, entry.value)
    entry.token = "walk"
    entry.value = "walk"
    verb = "walk"
  elseif entry.token ~= "verb" then
    console.print("Your command must begin with a verb.")
    return
  end

  if settings.debug then
    print("## result = {")
    print("##   token = '" .. entry.value .. "',")
    print("##   verb = '" .. verb .. "',")
    print("##   args = {")
    for _, v in pairs(words) do print("##      '" .. v .. "','") end
    print("##   }")
    print("## }")
  end

  return {
    token = entry.value, -- The command's token
    verb = verb, -- The actual string used to invoke the command
    args = words -- Remaining words after parsing the verb
  }
end

-- Checks a sentence for an object
-- Parameters:
-- word - A table containing the words to check
-- Returns a table containing the object and remaining words in the sentence
-- or nil if nothing was found.
-- result = {
--   object = { adjective, noun }
--   args = { .. }
-- }
local function parse_object(words)
  if not words or #words < 1 then return end
  local object = {}
  local found = false
  while not found do
    local w = table.remove(words, 1)
    if not w then found = true; break end
    local entry = _dictionary[w]
    if not entry then
      console.print("I don't understand the word \"" .. w .. ".\"")
      return
    elseif entry.token == "verb" then
      console.print("I was expecting a noun.")
      return
    elseif entry.token == "noun" then
      found = true
      object.noun = entry.value
    elseif entry.token == "direction" then
      found = true
      object.noun = entry.value
    elseif entry.token == "adjective" then
      object.adjective = entry.value
    elseif entry.token == "ignore" then
      -- skip it
    else:
      error("Invalid string in interpreter.parse_object().")
    end
  end
  if settings.debug then
    print("## result = {")
    print("##   object = " .. dump_table(object))
    print("##   args = " .. dump_table(args))
    print("## }")
  end
  return  {
    object = object,
    args = args
  }
end

-- Executes a command
-- Returns number of turns passed if successful or nil
local function execute(command)
  assert(command)
  local token = command.token
  if not token or not _commands[token] then
    console.print("Error: Undefined command - " .. tostring(token) .. ".")
    return
  end
  return _commands[token].func(command.args)
end

-- Returns a sorted list of all commands
local function list_commands()
  local keywords = {}
  for k, _ in pairs(_commands) do table.insert(keywords, 1, k) end
  table.sort(keywords)
  return keywords
end

-- Prints the help message for a specific command
local function print_help(command)
  if not _dictionary[command] then
    console.print("That is not a command I understand.")
  else
    console.print(_commands[_dictionary[command].value].help)
  end
end

-- Adds a command to the interpreter
-- Parameters:
-- token - The name of the command
-- help  - Help text to display if player types help [command]
-- func  - The function used to implement the command
-- verb  - A list of synonymous verbs the player can type to invoke the command
local function add_command(token, help, func, synonyms)
  assert(token)
  assert(help)
  assert(func)
  assert(type(func) == "function")

  -- Add command to the command table
  _commands[token] = {
    func = func,
    help = help
  }

  -- Add verbs to dictionary
  local s = synonyms or {}
  table.insert(s, 1, token)
  for _, v in pairs(s) do
    _dictionary[v] = {
      token = "verb",
      value = token
    }
  end
end

-- Adds a word to the interpreter's dictionary
-- Parameters:
-- word     - The word to add
-- type     - One of ignore, noun, direction, adjective, preposition
-- synonyms - Other words that are synonymous with this one
local function add_word(word, type, synonyms)
  assert(word)
  assert(type)
  local s = synonyms or {}
  table.insert(s, 1, word)
  for _, v in pairs(s) do
    _dictionary[v] = {
      token = type,
      value = word
    }
  end
end

-- Prompts the player for input and interpets the command
-- Returns 1 if successful or nil
local function interpret_input()
  console.print()
  local s = prompt()
  local cmd = parse(s)
  if cmd then return execute(cmd) end
end

local M = {
  add_command = add_command,
  add_word = add_word,
  interpret_input = interpret_input,
  parse_object = parse_object,
  prompt = prompt,
  list_commands = list_commands,
  print_help = print_help
}

return M
