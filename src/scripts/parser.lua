-- Internal dictionary
local _verbs = {}
local _nouns = {}
local _commands = {}

-- Prompt the player for input
local function prompt(message)
  if message then console.print(message) end
  s = console.read_line()
  s = s:lower()
  return s
end

-- Attempt to interpret the player's command
local function parse(s)
  -- Ignore blank input
  if not s or s == "" then
    console.print("Beg your pardon?")
    return
  end

  -- Split sentence into words
  words = s:split()
  if #words > 2 then
    console.print("Sorry, I can only understand two word commands.")
    return
  end

  -- Find the verb and noun
  verb_word = words[1]
  noun_word = ""
  if #words > 1 then noun_word = words[2] end
  if settings.debug then
    console.print("verb_word = " .. verb_word)
    console.print("noun_word = " .. noun_word)
  end

  -- Check for a valid verb
  if not _verbs[verb_word] then
    console.print("I don't understand the word \"" .. verb_word .. ".\"")
    return
  end
  verb = _verbs[verb_word]

  -- Execute the player's command
  return _commands[verb].func()
end

-- Adds a command to the parser
local function add_command(token, func, verbs, requires_object, err_message)
  if not token then error("Undefined token in add_command") end
  if not func then error("Undefined command function in add_command") end
  verbs = verbs or {token:lower()}
  requires_object = requires_object or false
  err_message = err_message or ("What would you like to " .. verbs[1] .. "?")
  for _, v in pairs(verbs) do
    _verbs[v:lower()] = token
  end
  _commands[token] = {
    func = func,
    requires_object = requires_object,
    err_message = err_message
  }
end

-- List all of the commands available to the parser
local function dump_commands()
  for k, v in pairs(_commands) do
    print(k .. " = {")
    print("func = " .. tostring(v.func))
    print("requires_object = " .. tostring(v.requires_object))
    print("err_message = " .. v.err_message)
  end
end

local M = {
  prompt = prompt,
  parse = parse,
  add_command = add_command,
  dump_commands = dump_commands
}

return M
