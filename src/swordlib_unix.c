#include <assert.h>
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <readline/readline.h>

#include "lua.h"
#include "lauxlib.h"
#include "lualib.h"

#include "swordlib.h"

static sword_settings_t _settings;

static void _print_var(lua_State *L, int i);
static int con_print(lua_State *L);
static int con_read_line(lua_State *L);
static int str_split(lua_State *L);


void sw_error (lua_State *L, const char *format, ...) {
  va_list argp;
  va_start(argp, format);
  vfprintf(stderr, format, argp);
  va_end(argp);
  exit(EXIT_FAILURE);
}

int sw_set_scripts_path(lua_State* L, const char* path)
{
  assert(path);
  lua_getglobal(L, "package");
  lua_getfield(L, -1, "path");
  const char* lua_path = lua_tostring(L, -1);
  char new_path[SWORD_MAX_CHARS];
  strncpy(new_path, lua_path, SWORD_MAX_CHARS);
  strncat(new_path, path, (SWORD_MAX_CHARS - strlen(lua_path)));
  lua_pop(L, 1);
  lua_pushstring(L, new_path);
  lua_setfield(L, -2, "path");
  lua_pop(L, 1);
  return 0;
}

int sw_openlibs(lua_State *L) {
  /* Set up readline to insert tab when tab key is pressed */
  int err = rl_bind_key('\t', rl_insert);
  if (err != 0) {
    fprintf(stderr, "Warning: Tab behavior undefined.\n");
  }

  /* Create settings table */
  lua_createtable(L, 0, 0);
  if (_settings.debug) {
    lua_pushboolean(L, 1);
  } else {
    lua_pushboolean(L, 0);
  }
  lua_setfield(L, -2, "debug");
  lua_setglobal(L, "settings");

  /* Load in console library */
  lua_createtable(L, 0, 0);
  lua_pushcfunction(L, con_read_line);
  lua_setfield(L, -2, "read_line");
  lua_pushcfunction(L, con_print);
  lua_setfield(L, -2, "print");
  lua_setglobal(L, "console");

  /* Add split function to string */
  lua_getglobal(L, "string");
  lua_pushcfunction(L, str_split);
  lua_setfield(L, -2, "split");

  return EXIT_SUCCESS;
}

void sw_con_set_title(const char *title) {
  assert(title);
  printf("\033]0;%s\007", title);
}

 void sw_set_settings(const sword_settings_t *p_settings) {
   _settings.debug = p_settings->debug;
 }

/* Prints an appropriate value for the item at index i on the stack */
static void _print_var(lua_State *L, int i) {
  if (lua_isstring(L, i)) {
    const char *s = luaL_checklstring(L, i, NULL);
    if (s != NULL) {
      printf("%s", s);
    }
    return;
  }

  if (lua_isboolean(L, i)) {
    const int boolean = lua_toboolean(L, i);
    if (boolean == 1) {
      printf("true");
    } else {
      printf("false");
    }
    return;
  }

  if (lua_istable(L, i)) {
    printf("[table]");
    return;
  }

  if (lua_isfunction(L, i)) {
    printf("[function]");
    return;
  }
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
  _print_var(L, 1);

  /* Space remaining args with tabs */
  if (c > 1) {
    for (int i = 1; i < c; i++) {
      printf("\t");
      _print_var(L, i + 1);
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

/* Splits a string into words */
static int str_split(lua_State *L) {
  int num_args = lua_gettop(L);

  /* Get the string to split */
  const char *s = luaL_checklstring(L, 1, NULL);
  if (s == NULL) {
    return 0;
  }

  /* Determine the delimiters */
  const char* delims = NULL;
  if (num_args > 1) {
    delims = luaL_checklstring(L, 2, NULL);
  }
  if (!delims) {
    delims = SWORD_DELIMITERS;
  }

  /* Split the string */
  char tokens[SWORD_MAX_CHARS];
  strncpy(tokens, s, SWORD_MAX_CHARS);
  int count = 0;
  char *word = NULL;
  word = strtok(tokens, delims);
  lua_createtable(L, 0, 0);
  while (word != NULL) {
    count++;
    lua_pushunsigned(L, count);
    lua_pushstring(L, word);
    lua_settable(L, -3);
    word = strtok(NULL, delims);
  }
  return 1;
}
