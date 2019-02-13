-- dictionary.lua
-- Adds all non-command related words to the interpreter's _dictionary

-- Movement directions
interpreter.add_word("north", "direction", {"n"})
interpreter.add_word("south", "direction", {"s"})
interpreter.add_word("east", "direction", {"e"})
interpreter.add_word("west", "direction", {"w"})
interpreter.add_word("up", "direction", {"u"})
interpreter.add_word("down", "direction", {"d"})
interpreter.add_word("in", "direction")
interpreter.add_word("out", "direction")
