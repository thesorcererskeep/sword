#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>

#include <readline/readline.h>

#include "lua.h"
#include "lauxlib.h"
#include "lualib.h"

#include "swordlib.h"

void l_error (lua_State *L, const char *format, ...) {
  va_list argp;
  va_start(argp, format);
  vfprintf(stderr, format, argp);
  va_end(argp);
  lua_close(L);
  exit(EXIT_FAILURE);
}

int con_init(lua_State *L) {
  /* Insert true tab when tab key is pressed */
  rl_bind_key ('\t', rl_insert);

  /* Load in console library */
  lua_createtable(L, 0, 0);
  lua_pushcfunction(L, con_read_line);
  lua_setfield(L, -2, "read_line");
  lua_setglobal(L, "console");

  return EXIT_SUCCESS;
}

int con_print(lua_State *L) {
  return 0;
}

int con_read_line(lua_State *L) {
  char *buf = NULL;
  buf = readline(SWORD_PROMPT);
  if (buf) {
    lua_pushstring(L, buf);
    add_history(buf);
    free(buf);
    return 1;
  } else {
    return 0;
  }
}
