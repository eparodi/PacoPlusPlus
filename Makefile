FLAGS= -Wall -g -std=c99
ENDFLADS= -ly -lm
PROGRAM_NAME = pacopp.out
OBJECTS = types/*.o hashtable/*.o operations/*.o
PACO_FILES = lex.yy.c y.tab.c

all:
	cd hashtable; make all
	cd types; make all
	cd operations; make all
	yacc -d paco.y
	lex paco.l
	gcc $(FLAGS) $(PACO_FILES) $(OBJECTS) -o $(PROGRAM_NAME) $(ENDFLADS)

clean:
	cd hashtable; make clean
	cd types; make clean
	cd operations; make clean
	rm -f y.tab.*
	rm -f lex.yy.c
	rm -f pacopp.out
	rm -f compiled.c
	rm -f run

.PHONY: all clean
