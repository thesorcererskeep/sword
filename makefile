LIB = -L./lib
INC = -I./inc
LIBS = -llua

mac-osx:
	clang -o ./bin/sword ./src/sword.c ./src/swordlib_unix.c $(LIB) $(INC) $(LIBS)

clean:
	rm -f ./bin/sword
