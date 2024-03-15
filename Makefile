CC=gcc
CFLAGS=-shared -fPIC -O3
INCLUDES=-I/opt/homebrew/include/lua5.4
LFLAGS=-L/opt/homebrew/lib
LIBS=-llua5.4
PUBLIC_DIR=public
SRC_DIR=src

# Find all .c files in SRC_DIR
SOURCES=$(wildcard $(SRC_DIR)/*.c)

# Replace the .c extension with .so for all sources
LUA_LIBS=$(SOURCES:$(SRC_DIR)/%.c=%.so)

LUA_MAIN=main.lua

.PHONY: all libs clean

all: libs
	@mkdir -p $(PUBLIC_DIR)
	@lua $(LUA_MAIN)

libs: $(LUA_LIBS)

%.so: $(SRC_DIR)/%.c
	@$(CC) $(CFLAGS) $(INCLUDES) $(LFLAGS) $(LIBS) $< -o $@
	@echo ✅ Compiled $@

clean:
	@$(RM) -r $(PUBLIC_DIR)
	@$(RM) $(LUA_LIBS)
	@echo 🧼 Cleaned up!
