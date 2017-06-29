#!/bin/bash

./pacopp.out  < $1 > compiled.c
gcc -Wall -g -std=c99 compiled.c types/*.o hashtable/*.o operations/*.o -o a.out -ly -lm
#rm compiled.c
