CC=gcc
CFLAGS=-shared -fPIC -O3
INCLUDES=-I/opt/homebrew/include/lua5.4
LFLAGS=-L/opt/homebrew/lib
LIBS=-llua5.4
BUILD_DIR=build
PUBLIC_DIR=public
SRC_DIR=src

SRC=$(SRC_DIR)/pcheng.c
LIB=pcheng.so

LUA_MAIN=main.lua

.PHONY: all lib clean

all: lib
	@mkdir -p $(BUILD_DIR)
	@lua $(LUA_MAIN)

lib:
	@mkdir -p $(BUILD_DIR)
	@$(CC) $(CFLAGS) $(INCLUDES) $(LFLAGS) $(LIBS) $(SRC) -o $(LIB)
	@echo ✅ Compiled $(LIB)

clean:
	@$(RM) -r $(PUBLIC_DIR)
	@$(RM) -r $(BUILD_DIR)
	@$(RM) $(LIB)
	@echo 🧼 Cleaned up!
