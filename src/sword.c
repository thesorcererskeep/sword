#include <stdio.h>
#include <stdlib.h>
#include <string.h>

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
  print_version();
  init();
  sw_parse_args(argv, argc);
  luaL_openlibs(L);
  sw_openlibs(L);
  sw_set_scripts_path(L, SWORD_PATH_INCLUDE);
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

  /* Set default game paths */
  sword_settings_t settings;
  sw_get_settings(&settings);
  snprintf(settings.path_scripts, SWORD_MAX_CHARS, "%s%s", SWORD_PATH_GAME, SWORD_PATH_SCRIPTS);
  char* home = getenv("HOME");
  char p[SWORD_MAX_CHARS];
  snprintf(p, SWORD_MAX_CHARS, "%s%s", home, SWORD_PATH_SAVE);
  strncpy(settings.path_save, p, SWORD_MAX_CHARS);
  sw_set_settings(&settings);

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
