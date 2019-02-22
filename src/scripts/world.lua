-- world.lua
-- Manages the game world

local _entities = {} -- Table of all entites in the game

-- Entity encapsulates all game objects
Entity = {}
function Entity:new(o)
  o = o or {}
  if o.location then
    o.__location = o.location
    o.location = nil
  end
  if not o.__location then
    o.__location = "limbo"
  end
  o.nouns = o.nouns or { "unnamed entity" }
  setmetatable(o, self)
  self.__index = self
  return o
end

-- Returns the room the Entity is currently located in
function Entity:get_location()
  room = _entities[self.__location]
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
  key = "player",
  name = "player",
  turns = 0,
  __location = "nowhere",
}
_entities['player'] = player

-- Returns a specific room
-- Parameters:
-- key - The room's unique key
-- Returns a table
local function get_room(key)
  assert(key)
  return _entities[key]
end

-- Returns the items in a room
-- Parameters:
-- key - The room's unique key
-- Returns a table
local function get_items_in(room)
  assert(room)
  if type(room) == "string" then
    room = _entities[room]
  end
  local found = {}
  for _, item in pairs(_entities) do
    if item:get_location() == room and item.type == "item" then
      table.insert(found, 1, item)
    end
  end
  if #found < 1 then
    return
  else
    return found
  end
end

-- Returns the items in a character's inventory
-- Parameters:
-- key - The room's unique key
-- Returns a table
local function get_inventory(entity)
  assert(entity)
  if type(entity) == "string" then
    entity = _entities[entity]
  end
  local found = {}
  for _, item in pairs(_entities) do
    if item:get_location() == entity and item.type == "item" then
      table.insert(found, 1, item)
    end
  end
  if #found < 1 then
    return
  else
    return found
  end
end

-- Sort function for entities
function _sort_entities(a, b)
  if a.score > b.score then
    return true
  else
    return false
  end
end

-- Finds all of the entities matching the parameters
-- Parameters:
-- noun         - The name of the item
-- adjective    - Any words used to describe the item
-- location     - Room where the item is located. Acts as a filter
-- in_inventory - If true also searches the player's inventory
-- Returns a list of the items found, sorted by score, or nil
local function find_entities(noun, adjective, location, in_inventory)
  if type(location) == "string" then
    location = _entities[location]
  end
  adjective = adjective or "-"
  local filters = {}
  if location then filters[1] = location end
  if in_inventory then filters[2] = world.player end

  local found = {}
  for _, entity in pairs(_entities) do
    local score = 0
    local is_here = false

    -- Check for location
    for _, loc in pairs(filters) do
      if entity:get_location() == loc then
        is_here = true
      end
    end

    -- Score if matches nouns
    if entity.nouns then
      for _, n in pairs(entity.nouns) do
        if noun == n then
          score = score + 10
        end
      end
    end

    -- Score if matches adjective
    if entity.adjectives then
      for _, a in pairs(entity.adjectives) do
        if adjective == a then
          score = score + 1
        end
      end
    end

    -- Only insert items within player's reach
    if is_here and entity.type ~= "player" and score >= 10 then
      local item  = {
        item = entity,
        score = score
      }
      table.insert(found, 1, item)
    end
  end
  if #found < 1 then return end
  -- Sort the entities
  table.sort(found, _sort_entities)
  if settings.debug then
    print("## found = " .. dump_table(found))
  end
  return found
end

-- Finds the single entity matching the parameters
-- Parameters:
-- noun         - The name of the item
-- adjective    - Any words used to describe the item
-- location     - Room where the item is located. Acts as a filter
-- in_inventory - If true also searches the player's inventory
-- Returns an Entity of nil
local function find_entity(noun, adjective, location, in_inventory)
  local found = find_entities(noun, adjective, location, in_inventory)
  if found then
    return found[1].item
  end
end

-- Writes all of the world data into a string and returns it. The data is
-- valid Lua code suitable for execution.
local function serialize()
  local world_data = _entities
  local s = "world_data = " .. dump_table(world_data) .. "\n"
  return s
end

-- Deserializes the world data and updates the contents of the world.
-- Parameters:
-- data - A table containing the world data
local function deserialize(data)
  assert(data)
  _entities = {}
  for k, v in pairs(data) do
    _entities[k] = Entity:new(v)
  end
  world.player = {}
  world.player = _entities["player"]
  if settings.debug then
    print("## player data = " .. dump_table(data.player))
    print("## player = " .. dump_table(player))
  end
  data = nil
  world_data = nil
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
function Room(config)
  assert(config)
  assert(config.key)
  assert(config.name)
  assert(config.description)
  config.visited = config.visited or false
  config.exits = config.exits or {}
  local r = Entity:new(config)
  _entities[r.key] = r
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
  assert(config.nouns)
  assert(config.location)
  config.type = "item"
  config.description = config.description or
    "There is nothing special about the " .. config.name .. "."
  config.determiner = config.determiner or "a"
  config.weight = config.weight or 1
  config.ajectives = config.adjectives or {}

  -- Add words to the interpreter dictionary
  for _, v in pairs(config.nouns) do
    interpreter.add_word(v, "noun")
  end

  for _, v in pairs(config.adjectives) do
    interpreter.add_word(v, "adjective")
  end

  local item = Entity:new(config);
  _entities[config.key] = item
end

-- Sets the starting room for the player
function Start(room)
  assert(room)
  player:set_location(room)
end

local M = {
  get_room = get_room,
  get_items_in = get_items_in,
  get_inventory = get_inventory,
  serialize = serialize,
  deserialize = deserialize,
  find_entities = find_entities,
  find_entity = find_entity,
  player = player
}

return M
