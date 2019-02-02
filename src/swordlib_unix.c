#include <readline/readline.h>

#include "lua.h"
#include "lauxlib.h"
#include "lualib.h"

/**
 * Prints a string to stdout.
 */
int con_print(lua_State *L) {
  return 0;
}

/**
 * Reads a line of text from stdin
 */
int con_read_line(lua_State *L) {
  while (1) {
    char *buf;
    buf = readline(">");
    printf("%s\n", buf);
    free(buf);
  }
  return 0;
}
