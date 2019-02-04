#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>

#include <readline/readline.h>

#include "lua.h"
#include "lauxlib.h"
#include "lualib.h"

#include "swordlib.h"

static int con_print(lua_State *L);
static int con_read_line(lua_State *L);

void sw_error (lua_State *L, const char *format, ...) {
  va_list argp;
  va_start(argp, format);
  vfprintf(stderr, format, argp);
  va_end(argp);
  lua_close(L);
  exit(EXIT_FAILURE);
}

int sw_openlibs(lua_State *L) {
  /* Set up readline to insert tab when tab key is pressed */
  rl_bind_key('\t', rl_insert);

  /* Load in console library */
  lua_createtable(L, 0, 0);
  lua_pushcfunction(L, con_read_line);
  lua_setfield(L, -2, "read_line");
  lua_pushcfunction(L, con_print);
  lua_setfield(L, -2, "print");
  lua_setglobal(L, "console");

  return EXIT_SUCCESS;
}

/* Print a string to stdout */
static int con_print(lua_State *L) {
  /* Get number of args */
  int c = lua_gettop(L);
  if (c < 1) {
    printf("\n");
    return 0;
  }

  /* Print first arg */
  const char* s = luaL_checklstring(L, 1, NULL);
  if (s == NULL) {
    printf("");
  } else {
    printf("%s", s);
  }

  /* Space remaining args with tabs */
  if (c > 1) {
    for (int i = 1; i < c; i++) {
      s = luaL_checklstring(L, i+1, NULL);
      if (s == NULL) {
        printf("");
      } else {
        printf("\t%s", s);
      }
    }
  }

  /* Print final newline */
  printf("\n");
  return 0;
}

/* Read in a line of text from stdin */
static int con_read_line(lua_State *L) {
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
