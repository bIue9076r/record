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

static int L_db_exists(lua_State *L){
	char* path = (char*)luaL_checkstring(L,1);
	boolean_t ret = db_exists(path);
	lua_pushnumber(L,ret);
	return 1;
}

static int L_read_db_head(lua_State* L){
	char* path = (char*)luaL_checkstring(L,1);
	
	return_header ret = read_db_head(path);
	if(ret.error){
		lua_pushnumber(L,ret.error);
		return 1;
	}
	
	lua_pushnumber(L,ret.header.size);
	lua_pushnumber(L,ret.header.flags);
	return 2;
}

static int L_db_entry_exists(lua_State *L){
	char* path = (char*)luaL_checkstring(L,1);
	char* _index = (char*)luaL_checkstring(L,2);
	
	char index[INDEX_MAX];
	for(int i = 0; i < INDEX_MAX; i++){ index[i] = 0; }
	for(int i = 0; _index != NULL && *_index != 0 && i < INDEX_MAX; i++){
		index[i] = _index[i];
	}
	
	boolean_t ret = db_entry_exists(path,index);
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
	{"new_db",			&L_new_db},
	{"set_entry",		&L_set_entry},
	{"get_entry",		&L_get_entry},
	{"read_db_head",	&L_read_db_head},
	{"db_exists",		&L_db_exists},
	{"db_entry_exists",	&L_db_entry_exists},
	{NULL,				NULL}					// sentinel
};

int luaopen_ldb(lua_State* L){
	luaL_openlib(L, "ldb", ldb, 0);
	lua_pushnumber(L, VERSION);
	lua_setfield(L, -2, "version");
	lua_pushnumber(L, NODESIZE);
	lua_setfield(L, -2, "nodesize");
	lua_pushnumber(L, HEADERSIZE);
	lua_setfield(L, -2, "headersize");
	lua_pushnumber(L, LOOKUP_MAX);
	lua_setfield(L, -2, "lookup_max");
	lua_pushnumber(L, INDEX_MAX);
	lua_setfield(L, -2, "index_max");
	lua_pushnumber(L, VALUE_MAX);
	lua_setfield(L, -2, "value_max");
	return 1;
}
