-- Prompt the player for input
local function prompt(message)
  if message then console.print(message) end
  s = console.read_line()
  s = s:lower()
  return s
end

settings = {
  debug = true
}

-- Attempt to interpret the player's command
local function parse(s)
  if not s or s == "" then
    console.print("Beg your pardon?")
    return
  end
  words = s:split()
  if #words > 2 then
    console.print("Sorry, I can only understand two word commands.")
    return
  end
  verb_word = words[1]
  noun_word = ""
  if #words > 1 then noun_word = words[2] end
  if settings.debug then
    console.print("verb_word = " .. verb_word)
    console.print("noun_word = " .. noun_word)
  end
end

local M = {
  prompt = prompt,
  parse = parse
}

return M
