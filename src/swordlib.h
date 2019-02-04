#ifndef SWORDLIB_H
#define SWORDLIB_H

#define SWORD_PROMPT ">"
#define SWORD_DELIMITERS " \r\n\t"
#define SWORD_MAX_CHARS 2048
#define SWORD_TITLE "Swords & Sorcery"

/**
 * Prints Lua error message and exits the game.
 */
void sw_error (lua_State *L, const char *format, ...);

/**
 * Iniitalizes the console library and exposes it to Lua
 */
int sw_openlibs(lua_State *L);

/**
 * Set the console window's title
 */
void sw_con_set_title(const char *title);

#endif /* SWORDLIB_H */
