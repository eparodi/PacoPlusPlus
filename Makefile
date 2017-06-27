FLAGS= -Wall -g -std=c99
ENDFLADS= -ly
PROGRAM_NAME = pacopp.out
OBJECTS = types/*.o hashtable/*.o

all:
	cd hashtable; make all
	cd types; make all
	yacc -d paco.y
	lex paco.l
	gcc $(FLAGS) *.c $(OBJECTS) -o $(PROGRAM_NAME) $(ENDFLADS)

clean:
	cd hashtable; make clean
	cd types; make clean
	rm y.tab.*
	rm lex.yy.c
	rm pacopp.out

.PHONY: all clean
