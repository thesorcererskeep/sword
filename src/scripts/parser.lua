local function prompt()
  console.print("What next?")
  s = console.read_line()
  s = s:lower()
  return s
end

local M = {
  prompt = prompt
}

return M
