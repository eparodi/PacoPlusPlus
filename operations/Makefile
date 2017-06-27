SOURCES=$(wildcard *.c)
GCC=gcc
FLAGS= -Wall -c -std=c99

all:
	$(GCC) $(FLAGS) $(SOURCES) -I./include

clean:
	rm *.o

.PHONY: all clean
