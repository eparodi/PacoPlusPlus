FLAGS= -Wall -std=c99
ENDFLADS= -ly
PROGRAM_NAME = pacopp.out

all:
	cd hashtable; make all
	cd types; make all
	yacc -d paco.y
	lex paco.l
	gcc $(FLAGS) *.c types_2/*.c -o $(PROGRAM_NAME) $(ENDFLADS)
  
clean:
	cd hashtable; make clean
	cd types; make clean
	rm y.tab.*
	rm lex.yy.c
	rm pacopp.out
  
.PHONY: all clean