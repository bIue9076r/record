#include <stdio.h>
#include "str.h"
#include "ldb.h"
#include "lua.h"
#include "lauxlib.h"

static int L_new_db(lua_State *L){
	
	return 0;
}

static int L_set_entry(lua_State *L){
	
	return 0;
}

static int L_get_entry(lua_State* L){
	
	return 0;
}

static const struct luaL_Reg ldb [] = {
	{"new_db",		&L_new_db},
	{"set_entry",	&L_set_entry},
	{"get_entry",	&L_get_entry},
	{NULL,		NULL}				// sentinel
};

int luaopen_ldb(lua_State* L){
	luaL_openlib(L, "ldb", ldb, 0);
	return 1;
}
