#include <stdio.h>
#include <stdlib.h>

#include "lua.h"
#include "lauxlib.h"
#include "lualib.h"

#include "sword.h"
#include "swordlib.h"

static lua_State *L = NULL;

static void print_version(void);
static void init(void);
static void shutdown(void);

int main(int argv, char *argc[]) {
  sw_parse_args(argv, argc);
  print_version();
  init();
  luaL_openlibs(L);
  sw_openlibs(L);
  sw_set_scripts_path(L, SWORD_SCRIPTS_PATH);
  int err = luaL_loadfile(L, "./data/scripts/sword.lua") || lua_pcall(L, 0, 0, 0);
  if (err) {
     sw_error(L, "%s\n", lua_tostring(L, -1));
  }
  return EXIT_SUCCESS;
}

static void print_version(void) {
  printf("%s v%s\n", SWORD_TITLE, SWORD_VERSION);
  printf("%s\n", SWORD_TAGLINE);
  printf("© %s %s\n", SWORD_YEAR, SWORD_AUTHOR);
}

static void init(void) {
  /* Set console title */
  sw_con_set_title(SWORD_TITLE);

  /* Initialize  Lua */
  L = luaL_newstate();

  atexit(shutdown);
}

static void shutdown(void) {
  /* Reset title and close down Lua */
  sw_con_set_title("");
  if (L != NULL) {
    lua_close(L);
  }
}
