#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>

#include <readline/readline.h>

#include "lua.h"
#include "lauxlib.h"
#include "lualib.h"

void l_error (lua_State *L, const char *format, ...) {
  va_list argp;
  va_start(argp, format);
  vfprintf(stderr, format, argp);
  va_end(argp);
  lua_close(L);
  exit(EXIT_FAILURE);
}

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
