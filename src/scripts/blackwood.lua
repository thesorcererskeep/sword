-- blackwood.lua
-- Data for the starting area

Room{
  key = "town_square",
  name = "Blackwood Town Square",
  description =
[[You are standing in the heart of blackwood where the hustle and bustle of
everyday activity is all around you. Just north of you the square opens up into
Main Avenue. To the south is the town hall. There is also a chapel to the east
and the bank is west.]],
  exits = {
    north = "main_ave_south",
    south = "town_hall",
    east = "chapel",
    west = "bank"
  }
}

Room{
  key = "forest",
  name = "Forest",
  description = "You emerge into a sunny forest. North leads back into the cave.",
  exits = {north = "cave"}
}

Start('town_square')
