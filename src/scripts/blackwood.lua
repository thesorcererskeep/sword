-- blackwood.lua
-- Data for the starting area

Room{
  key = "town_square",
  name = "Blackwood Town Square",
  description =
[[You are standing in the heart of blackwood where the hustle and bustle of
everyday activity is all around you. Just north of you the square opens up into
Main Avenue. To the south is the Town Hall. There is also a Chapel to the east
and the Bank is west.]],
  exits = {
    north = "main_ave_south",
    south = "town_hall",
    east = "chapel",
    west = "bank"
  }
}

Room{
  key = "main_ave_south",
  name = "Main Avenue South",
  description =
[[Shops line this section of Main Avenue. There is a General Store on the west
side and a Blacksmith on the east. The avenue continues to the north. South is
the Town Square.]],
  exits = {
    north = "main_ave_north",
    south = "town_square",
    east = "blacksmith",
    west = "general_store"
  }
}

Item{
  key = "stone",
  name = "stone",
  location = "main_ave_south"
}

Start('town_square')
