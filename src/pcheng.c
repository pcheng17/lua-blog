#include <dirent.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <lua.h>
#include <lauxlib.h>
#include <lualib.h>


static void get_markdown_files_recurse(lua_State* L, char* fullpath, size_t pathlen) {
    DIR* d = opendir(fullpath);
    if (!d) return;

    // Create a new table for the current directory
    lua_newtable(L);

    struct dirent* dir;
    while ((dir = readdir(d)) != NULL) {
        if (dir->d_type == DT_DIR) {
            if (strcmp(dir->d_name, ".") == 0 || strcmp(dir->d_name, "..") == 0) {
                continue;
            }

            const size_t dlen = strlen(dir->d_name);
            char* tmp = malloc(dlen + 2); // +1 for slash, +1 for null terminator
            if (tmp) {
                snprintf(tmp, dlen + 2, "%s/", dir->d_name);
                lua_pushstring(L, tmp);
                free(tmp);
            } else {
                // Fallback with no slash
                lua_pushstring(L, dir->d_name);
            }

            const size_t len = snprintf(fullpath + pathlen, 1024 - pathlen, "%s/", dir->d_name);
            get_markdown_files_recurse(L, fullpath, pathlen + len);
            // Reset path after returning from recursion
            fullpath[pathlen] = '\0';

            lua_settable(L, -3);

        } else if (dir->d_type == DT_REG) {
            const char* ext = strrchr(dir->d_name, '.');
            if (ext && strcmp(ext, ".md") == 0) {
                lua_pushstring(L, dir->d_name);
                lua_pushboolean(L, 1);
                lua_settable(L, -3);
            }
        }
    }
    closedir(d);
}

static int get_markdown_files(lua_State* L) {
    const char* basepath = luaL_checkstring(L, 1);
    const size_t baselen = strlen(basepath);

    char fullpath[1024];
    strncpy(fullpath, basepath, sizeof(fullpath));
    fullpath[sizeof(fullpath) - 1] = '\0'; // Ensure null-termination

    lua_newtable(L);
    lua_pushstring(L, basepath);
    get_markdown_files_recurse(L, fullpath, baselen);
    lua_settable(L, -3);

    return 1;
}

static const struct luaL_Reg pcheng[] = {
    {"get_markdown_files", get_markdown_files},
    {NULL, NULL}
};

int luaopen_pcheng(lua_State* L) {
    luaL_newlib(L, pcheng);
    return 1;
}

