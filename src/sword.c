#include <stdio.h>
#include <stdlib.h>

#include "lua.h"
#include "lauxlib.h"
#include "lualib.h"

#include "swordlib.h"

int main(int argv, char* argc[]) {
  lua_State *L = luaL_newstate();
  luaL_openlibs(L);

sw_openlibs(L);

  int err = luaL_loadfile(L, "./scripts/main.lua") || lua_pcall(L, 0, 0, 0);
  if (err) {
     sw_error(L, "%s\n", lua_tostring(L, -1));
  }
  lua_close(L);
  return EXIT_SUCCESS;
}
