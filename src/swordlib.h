#ifndef SWORDLIB_H
#define SWORDLIB_H

#include <stdbool.h>

#define SWORD_PROMPT ">"
#define SWORD_DELIMITERS " \r\n\t"
#define SWORD_MAX_CHARS 2048
#define SWORD_SCRIPTS_PATH ";./data/?.lua;./data/scripts/?.lua"

typedef struct _sword_settings_t {
  bool debug;
} sword_settings_t;

/**
 * Prints Lua error message and exits the game.
 */
void sw_error (lua_State *L, const char *format, ...);

/**
 * Tells Lua where to find Sword's scripts
 */
int sw_set_scripts_path(lua_State* L, const char* path);

/**
 * Iniitalizes the console library and exposes it to Lua
 */
int sw_openlibs(lua_State *L);

/**
 * Set the console window's title
 */
void sw_con_set_title(const char *title);

/**
 * Sets game settings
 */
 void sw_set_settings(const sword_settings_t *p_settings);

#endif /* SWORDLIB_H */
