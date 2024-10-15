#include <stdio.h>
#include "str.h"
#include "ldb.h"
#include "lua.h"
#include "lauxlib.h"

static int L_new_db(lua_State *L){
	char* path = (char*)luaL_checkstring(L,1);
	boolean_t ret = new_db(path);
	lua_pushnumber(L,ret);
	return 1;
}

static int L_set_entry(lua_State *L){
	char* path = (char*)luaL_checkstring(L,1);
	char* _index = (char*)luaL_checkstring(L,2);
	char* _value = (char*)luaL_checkstring(L,3);
	boolean_t taken = ((boolean_t)luaL_checknumber(L,4));
	boolean_t moveable = ((boolean_t)luaL_checknumber(L,5));
	boolean_t missing = ((boolean_t)luaL_checknumber(L,6));
	condition_t condition = (condition_t)luaL_checknumber(L,7);
	
	char index[INDEX_MAX];
	for(int i = 0; i < INDEX_MAX; i++){ index[i] = 0; }
	for(int i = 0; _index != NULL && *_index != 0 && i < INDEX_MAX; i++){
		index[i] = _index[i];
	}
	
	char value[VALUE_MAX];
	for(int i = 0; i < VALUE_MAX; i++){ value[i] = 0; }
	for(int i = 0; _value != NULL && *_value != 0 && i < VALUE_MAX; i++){
		value[i] = _value[i];
	}
	
	boolean_t ret = set_entry(path,index,value,taken,moveable,missing,condition);
	lua_pushnumber(L,ret);
	return 1;
}

static int L_get_entry(lua_State* L){
	char* path = (char*)luaL_checkstring(L,1);
	char* _index = (char*)luaL_checkstring(L,2);
	
	char index[INDEX_MAX];
	for(int i = 0; i < INDEX_MAX; i++){ index[i] = 0; }
	for(int i = 0; _index != NULL && *_index != 0 && i < INDEX_MAX; i++){
		index[i] = _index[i];
	}
	
	return_node ret = get_entry(path,index);
	if(ret.error){
		lua_pushnumber(L,ret.error);
		return 1;
	}
	
	lua_pushstring(L,ret.node.index);
	lua_pushstring(L,ret.node.value);
	lua_pushnumber(L,ret.node.taken);
	lua_pushnumber(L,ret.node.moveable);
	lua_pushnumber(L,ret.node.missing);
	lua_pushnumber(L,ret.node.condition);
	return 6;
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