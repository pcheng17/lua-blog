#include <dirent.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <lua.h>
#include <lauxlib.h>
#include <lualib.h>


static void get_markdown_files_recurse(lua_State* L, char* fullpath, size_t baselen, size_t pathlen, int* index) {
    DIR* d = opendir(fullpath);
    if (!d) return;

    struct dirent* dir;
    while ((dir = readdir(d)) != NULL) {
        if (dir->d_type == DT_DIR) {
            if (strcmp(dir->d_name, ".") == 0 || strcmp(dir->d_name, "..") == 0) {
                continue;
            }

            size_t len = snprintf(fullpath + pathlen, 1024 - pathlen, "/%s", dir->d_name);
            get_markdown_files_recurse(L, fullpath, baselen, pathlen + len, index);
            // Reset path after returning from recursion
            fullpath[pathlen] = '\0';
        } else if (dir->d_type == DT_REG) {
            const char* ext = strrchr(dir->d_name, '.');
            if (ext && strcmp(ext, ".md") == 0) {
                snprintf(fullpath + pathlen, 1024 - pathlen, "/%s", dir->d_name);
                lua_pushnumber(L, (*index)++);
                lua_pushstring(L, fullpath + baselen + 1);
                lua_settable(L, -3);
                // Remove the filename from the path after setting the table
                fullpath[pathlen] = '\0';
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
    int index = 1;
    get_markdown_files_recurse(L, fullpath, baselen, baselen, &index);
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

