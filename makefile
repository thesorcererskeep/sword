LIB = -L./lib
INC = -I./inc
LIBS = -llua -lreadline
DEPS = $(LIB) $(INC) $(LIBS)

lua-build:
	cp -f ./src/scripts/*.lua ./bin/scripts/

mac-osx: lua-build
	clang -o ./bin/sword ./src/sword.c ./src/swordlib_unix.c $(DEPS)

clean:
	rm -f ./bin/sword
	rm -rf ./bin/scripts
	mkdir ./bin/scripts
