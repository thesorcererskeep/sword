#ifndef SWORDLIB_H
#define SWORDLIB_H

#define SWORD_PROMPT ">"

/**
 * Prints Lua error message and exits the game.
 */
 /* Handle Lua errors */
void l_error (lua_State *L, const char *format, ...);

/**
 * Iniitalizes the console library and exposes it to Lua
 */
 int con_init(lua_State *L);

/**
 * Prints a string to stdout.
 */
int con_print(lua_State *L);

/**
 * Reads a line of text from stdin
 */
int con_read_line(lua_State *L);

#endif /* SWORDLIB_H */
