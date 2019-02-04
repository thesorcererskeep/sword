#include <stdio.h>
#include <stdlib.h>

#include "lua.h"
#include "lauxlib.h"
#include "lualib.h"

#include "sword.h"
#include "swordlib.h"

static void print_version(void) {
  printf("%s v%s\n", SWORD_TITLE, SWORD_VERSION);
  printf("%s\n", SWORD_TAGLINE);
  printf("© %s %s\n", SWORD_YEAR, SWORD_AUTHOR);
}

int main(int argv, char* argc[]) {
  print_version();

  /* Set console title */
  sw_con_set_title(SWORD_TITLE);

  lua_State *L = luaL_newstate();
  luaL_openlibs(L);

  sw_openlibs(L);

  int err = luaL_loadfile(L, "./data/scripts/main.lua") || lua_pcall(L, 0, 0, 0);
  if (err) {
     sw_error(L, "%s\n", lua_tostring(L, -1));
  }
  lua_close(L);
  return EXIT_SUCCESS;
}
