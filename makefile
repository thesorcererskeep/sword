mac-osx:
	clang -o ./bin/sword ./src/sword.c

clean:
	rm -f ./bin/sword
