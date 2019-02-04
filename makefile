LIB = -L./lib
INC = -I./inc
LIBS = -llua -lreadline
DEPS = $(LIB) $(INC) $(LIBS)

lua:
	cp -f ./src/scripts/*.lua ./bin/data/scripts/

osx: lua
	clang -o ./bin/sword ./src/sword.c ./src/swordlib_unix.c $(DEPS)

clean:
	rm -f ./bin/sword
	rm -rf ./bin/data/
	mkdir ./bin/data
	mkdir ./bin/data/scripts
