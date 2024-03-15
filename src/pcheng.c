#include <dirent.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <lua.h>
#include <lauxlib.h>
#include <lualib.h>

static void list_markdown_files_recursively(lua_State* L, const char* basepath, const char* path, int* index) {
    char fullpath[1024];
    if (path) {
        snprintf(fullpath, sizeof(fullpath), "%s/%s", basepath, path);
    } else {
        strncpy(fullpath, basepath, sizeof(fullpath));
    }

    DIR* d = opendir(fullpath);
    if (!d) {
        return; // If we can't open the directory, return
    }

    struct dirent* dir;
    while ((dir = readdir(d)) != NULL) {
        if (dir->d_type == DT_DIR) {
            // Check if the directory is '.' or '..'
            if (strcmp(dir->d_name, ".") == 0 || strcmp(dir->d_name, "..") == 0) {
                continue;
            }

            // Prepare the new path for recursive call
            char newsubpath[1024];
            if (path) {
                snprintf(newsubpath, sizeof(newsubpath), "%s/%s", path, dir->d_name);
            } else {
                strncpy(newsubpath, dir->d_name, sizeof(newsubpath));
            }

            list_markdown_files_recursively(L, basepath, newsubpath, index); // Recursive call
        } else if (dir->d_type == DT_REG) {
            const char* ext = strrchr(dir->d_name, '.');
            if (ext && strcmp(ext, ".md") == 0) {
                char relativepath[1024];
                if (path) {
                    snprintf(relativepath, sizeof(relativepath), "%s/%s", path, dir->d_name);
                } else {
                    strncpy(relativepath, dir->d_name, sizeof(relativepath));
                }

                lua_pushnumber(L, (*index)++); // Push index
                lua_pushstring(L, relativepath); // Push relative file path
                lua_settable(L, -3); // Set table[index] = relative filepath
            }
        }
    }
    closedir(d);
}

static int list_markdown_files(lua_State* L) {
    const char* path = luaL_checkstring(L, 1);
    lua_newtable(L);
    int index = 1;
    list_markdown_files_recursively(L, path, NULL, &index);
    return 1;
}

static const struct luaL_Reg pcheng[] = {
    {"list_markdown_files", list_markdown_files},
    {NULL, NULL}
};

int luaopen_pcheng(lua_State* L) {
    luaL_newlib(L, pcheng);
    return 1;
}

