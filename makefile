LIB = -L./lib
INC = -I./inc
LIBS = -llua -lreadline
DEPS = $(LIB) $(INC) $(LIBS)

mac-osx:
	clang -o ./bin/sword ./src/sword.c ./src/swordlib_unix.c $(DEPS)

clean:
	rm -f ./bin/sword
