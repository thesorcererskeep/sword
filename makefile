LIB = -L./lib
INC = -I./inc
LIBS = -llua -lreadline
DEPS = $(LIB) $(INC) $(LIBS)

lua-build:
	cp ./src/scripts/* ./bin/scripts/*

mac-osx: lua-build
	clang -o ./bin/sword ./src/sword.c ./src/swordlib_unix.c $(DEPS)

clean:
	rm -f ./bin/sword
