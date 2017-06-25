all:
	# cd hashtable; make all
	yacc -d paco.y
	lex paco.l
	gcc *.c -ly -o pacopp.out
  
clean:
	cd hashtable; make clean
	rm y.tab.*
	rm lex.yy.c
	rm pacopp.out
  
.PHONY: all clean