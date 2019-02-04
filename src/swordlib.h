#ifndef SWORDLIB_H
#define SWORDLIB_H

#define SWORD_PROMPT ">"

/**
 * Prints Lua error message and exits the game.
 */
void sw_error (lua_State *L, const char *format, ...);

/**
 * Iniitalizes the console library and exposes it to Lua
 */
int sw_openlibs(lua_State *L);

#endif /* SWORDLIB_H */
