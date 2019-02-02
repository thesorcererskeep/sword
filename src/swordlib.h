#ifndef SWORDLIB_H
#define SWORDLIB_H

/**
 * Prints Lua error message and exits the game.
 */
 /* Handle Lua errors */
void lua_error (lua_State *L, const char *format, ...);

/**
 * Prints a string to stdout.
 */
int con_print(lua_State *L);

/**
 * Reads a line of text from stdin
 */
int con_read_line(lua_State *L);

#endif /* SWORDLIB_H */
