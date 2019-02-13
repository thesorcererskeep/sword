-- interpreter.lua
-- Attempts to convert the player's input and execute the command

_dictionary = {} -- The interpreter's vocabulary
_commands   = {} -- All commands the interpreter knows

-- Prompts the user for input
-- Returns a string
local function prompt()
  local s = nil
  console.print()
  while not s do
    s = console.read_line()
    s = s:lower()
    -- s = s:trim() TODO: fix
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
  local words = s:split()
  if #words < 1 then
    console.print("Beg your pardon?")
    return
  end

  local verb = table.remove(words, 1)
  local entry = _dictionary[verb]
  if not entry then
    console.print('I don\'t understand the word "' .. verb ..'."')
    return
  elseif entry.token ~= "verb" then
    console.print("Your command must begin with a verb.")
    return
  end

  return {
    token = entry.value,
    verb = verb,
    args = words
  }
end

-- Executes a command
-- Returns 1 if successful or nil
local function execute(command)
  assert(command)
  local token = command.token
  if not token or not _commands[token] then
    console.print("Error: Undefined command - " .. tostring(token) .. ".")
    return
  end
  return _commands[token].func(command.args)
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

-- Prompts the player for input and interpets the command
-- Returns 1 if successful or nil
local function run()
  local s = prompt()
  local cmd = parse(s)
  if cmd then return execute(cmd) end
end

local M = {
  add_command = add_command,
  run = run,
}

return M
