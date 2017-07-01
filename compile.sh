#!/bin/bash

./pacopp.out  $1
gcc -Wall -g -std=c99 $1.c types/*.o hashtable/*.o operations/*.o -o a.out -ly -lm &> /dev/null
rm -f $1.c
