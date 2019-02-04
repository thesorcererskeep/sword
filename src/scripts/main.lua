console.print("Hello", "Swords & Sorcery!")

console.print("1", 2, 3, "four")
print("1", 2, 3, "four")

s = "foo, bar, bat"
words = s:split(" ,")
for _, v in pairs(words) do
  print(v)
end

while true do
  s = console.read_line();
  console.print(s)
end
