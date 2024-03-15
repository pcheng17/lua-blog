#include <stdbool.h>
#include <lua.h>
#include <lauxlib.h>
#include <lualib.h>
#include <time.h>

struct stopwatch_t {
    clock_t start;
    clock_t stop;
    bool running;
} stopwatch;

static int start(lua_State *L) {
    stopwatch.running = true;
    stopwatch.start = clock();
    return 0;
}

static int stop(lua_State *L) {
    stopwatch.stop = clock();
    stopwatch.running = false;
    return 0;
}

static double elapsed() {
    if (stopwatch.running) {
        stopwatch.stop = clock();
        stopwatch.running = false;
    }
    return (double)(stopwatch.stop - stopwatch.start) / CLOCKS_PER_SEC;
}

static int elapsed_seconds(lua_State *L) {
    const double dt = elapsed();
    lua_pushnumber(L, dt);
    return 1;
}

static int elapsed_milliseconds(lua_State *L) {
    const double dt = elapsed();
    lua_pushnumber(L, dt * 1000);
    return 1;
}

static const struct luaL_Reg stopwatch_funcs[] = {
    {"start", start},
    {"stop", stop},
    {"elapsed_seconds", elapsed_seconds},
    {"elapsed_milliseconds", elapsed_milliseconds},
    {NULL, NULL}
};

int luaopen_stopwatch(lua_State *L) {
    luaL_newlib(L, stopwatch_funcs);
    return 1;
}
