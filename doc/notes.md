# Swords and Sorcery Notes

## Verbs

### Gameplay
* wait
* look
* walk
* take
* drop
* examine
* open
* close
* unlock
* lock
* eat
* drink
* buy
* sell
* talk
* attack
* flee
* wear
* equip
* light
* party

### Spells
* blast  - Weapon
* shield - Defense Bonus
* bless  - Offense Bonus
* heal  - Regain hit points

### Metagame
* inventory
* stats
* turns

### System
* save
* load
* quit
* restart
* verbose
* log

## Directory Structure
/bin
  sword
  /sorcery
    startup.cfg
    /scripts
      parser.lua
      filesystem.lua
      world.lua
      library.lua
    /adventures
      /adventure-title
        manifest.lua
        main.lua
          /scripts
            commands.lua
          /data
            rooms.dat
            monsters.dat
            items.dat
      /adventure-title-2
        ...
