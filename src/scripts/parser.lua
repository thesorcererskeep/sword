-- Internal dictionary
local _verbs = {}
local _nouns = {}

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
end

local M = {
  prompt = prompt,
  parse = parse,
}

return M
