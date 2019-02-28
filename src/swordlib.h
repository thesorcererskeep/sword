#ifndef SWORDLIB_H
#define SWORDLIB_H

#include <stdbool.h>

#define SWORD_PROMPT ">"
#define SWORD_DELIMITERS " \r\n\t"
#define SWORD_MAX_CHARS 2048
#define SWORD_PATH_INCLUDE ";./data/?.lua;./data/scripts/?.lua"
#define SWORD_PATH_GAME "./data/"
#define SWORD_PATH_SCRIPTS "scripts/"
#define SWORD_SCRIPT_MAIN "main.lua"
#define SWORD_PATH_USER "/.sword"
#define SWORD_PATH_SAVE "/.sword/save/"

typedef struct _sword_settings_t {
  bool debug;
  char path_scripts[SWORD_MAX_CHARS];
  char path_save[SWORD_MAX_CHARS];
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
 * Gets game settings
 */
void sw_get_settings(sword_settings_t *p_settings);

/**
 * Sets game settings
 */
void sw_set_settings(const sword_settings_t *p_settings);

/**
 * Parses command line args
 */
void sw_parse_args(int argc, char *argv[]);

/**
 * Creates .sword directory if it doesn't exists
 */
 void sw_create_user_dir(void);

#endif /* SWORDLIB_H */
