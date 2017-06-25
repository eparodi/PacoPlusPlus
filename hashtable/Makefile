SOURCES=$(wildcard *.c)
LIBRARY=hashtable.o
GCC=gcc
FLAGS= -Wall -c

all:
	$(GCC) $(FLAGS) $(SOURCES) -I./include -o $(LIBRARY)

clean:
	rm *.o
  
.PHONY: all clean