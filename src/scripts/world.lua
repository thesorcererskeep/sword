-- world.lua
-- Manages the game world

local _rooms = {} -- Table of all rooms in game
local _entities = {} -- Table of all entites in the game

-- Entity encapsulates all game objects
Entity = {}
function Entity:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

-- Returns the room the Entity is currently located in
function Entity:get_location()
  local room = _rooms[self.__location]
  return room
end

-- Moves the entity to a room
-- Parameters:
-- room - A table or string key of the room to move the entity to
function Entity:set_location(room)
  assert(room)
  if (type(room) == "table") then
    room = room.key
  end
  assert(type(room) == "string")
  self.__location = room
end

 -- The player's entity
local player = Entity:new{
  turns = 0
}

-- Returns a specific room
-- Parameters:
-- key - The room's unique key
-- Returns a table
local function get_room(key)
  return _rooms[key]
end

-- Returns the items in a room
-- Parameters:
-- key - The room's unique key
-- Returns a table
local function get_items_in(room)
  assert(room)
  if type(room) == "string" then
    room = _rooms[room]
  end
  local found = {}
  for _, item in pairs(_entities) do
    if item.location == room.key then
      table.insert(found, 1, item)
    end
  end
  if #found < 1 then
    return
  else
    return found
  end
end

-- Writes all of the world data into a string and returns it. The data is
-- valid Lua code suitable for execution.
local function serialize()
  local world_data = {
    rooms = _rooms,
    entities = _entities,
    player = player
  }
  local s = "world_data = " .. dump_table(world_data) .. "\n"
  return s
end

-- Deserializes the world data and updates the contents of the world.
-- Parameters:
-- data - A table containing the world data
local function deserialize(data)
  assert(data)
  assert(data.rooms)
  assert(data.entities)
  assert(data.player)
  _rooms = data.rooms
  _entities = {}
  for k, v in pairs(data.entities) do
    _entities[k] = Entity:new(v)
  end
  player = {}
  player = Entity:new(player.data)
end

-- Global convenience function to create a room
-- Parameters:
-- args - A table containing the room's definition
--   Fields:
--     key, string         - The room's unique identifier.
--     name, string        - The room's displayed name
--     description, string - The room's description.
--     visited, boolean    - Whether or not the player has visited this
--                           room before
--     exits, table        - A list of exits from the room and their
--                           connections. Example: {'east' = 'dark_cave'}
function Room(args)
  assert(args)
  assert(args.key)
  assert(args.name)
  assert(args.description)
  args.visited = args.visited or false
  args.exits = args.exits or {}
  _rooms[args.key] = args
end

-- Creates an item
-- Parameters:
-- config - A table containing the item's definition
--   Fields:
--     key, string         - The item's unique identifier.
--     name, string        - The items's displayed name
--     description, string - The item's description.
--     determiner          - The word to use when addressing the item.
--                           e.g. 'a' or 'an'
--     weight              - Number of inventory slots the item uses.
function Item(config)
  assert(config)
  assert(config.key)
  assert(config.name)
  assert(config.location)
  config.type = "item"
  config.description = config.description or
    "There is nothing special about the " .. config.name .. "."
  config.determiner = config.determiner or "a"
  config.weight = config.weight or 1
  local item = Entity:new(config);
  _entities[config.key]= item
end

-- Sets the starting room for the player
function Start(room)
  assert(room)
  player:set_location(room)
end

local M = {
  get_room = get_room,
  get_items_in = get_items_in,
  serialize = serialize,
  deserialize = deserialize,
  player = player
}

return M
