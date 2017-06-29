FLAGS= -Wall -g -std=c99
ENDFLADS= -ly -lm
PROGRAM_NAME = pacopp.out
OBJECTS = types/*.o hashtable/*.o operations/*.o

all:
	cd hashtable; make all
	cd types; make all
	cd operations; make all
	yacc -d paco.y
	lex paco.l
	gcc $(FLAGS) *.c $(OBJECTS) -o $(PROGRAM_NAME) $(ENDFLADS)

clean:
	cd hashtable; make clean
	cd types; make clean
	rm -f y.tab.*
	rm -f lex.yy.c
	rm -f pacopp.out
	rm -f compiled.c
	rm -f run

.PHONY: all clean
