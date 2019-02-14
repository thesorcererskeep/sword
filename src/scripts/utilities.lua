-- utilities.lua
-- Miscellanious helper functions

function dump_table (o)
  local s = ""
   if type(o) == "number" then
     s = s .. o
   elseif type(o) == "string" then
     s = s .. string.format("%q", o)
   elseif type(o) == "table" then
     s = s .. "{ "
     for k,v in pairs(o) do
       s = s .. k .. " = "
       s = s .. dump_table(v)
       s = s .. ", "
     end
     s = s .. " }"
   elseif type(o) == "boolean" then
     s = s .. tostring(o)
   elseif not o then
     -- continue
   else
     error("cannot dump a " .. type(o))
   end
   return s
end
