#include <lua.h>
int luaopen_b(lua_State* L) {
    lua_pushinteger(L,42);
    return 1;
}
