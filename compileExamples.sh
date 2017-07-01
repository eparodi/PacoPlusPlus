#!/bin/bash

./pacopp.out  isPrime.ppp
gcc -Wall -g -std=c99 isPrime.ppp.c types/*.o hashtable/*.o operations/*.o -o isPrime.out -ly -lm &> /dev/null
rm -f isPrime.ppp.c

./pacopp.out  collatz.ppp
gcc -Wall -g -std=c99 collatz.ppp.c types/*.o hashtable/*.o operations/*.o -o collatz.out -ly -lm &> /dev/null
rm -f collatz.ppp.c

./pacopp.out  numOculto.ppp
gcc -Wall -g -std=c99 numOculto.ppp.c types/*.o hashtable/*.o operations/*.o -o numOculto.out -ly -lm &> /dev/null
rm -f numOculto.ppp.c

./pacopp.out  operations.ppp
gcc -Wall -g -std=c99 isPrime.ppp.c types/*.o hashtable/*.o operations/*.o -o isPrime.out -ly -lm &> /dev/null
rm -f operations.ppp.c

./pacopp.out  fibo.ppp
gcc -Wall -g -std=c99 isPrime.ppp.c types/*.o hashtable/*.o operations/*.o -o fibo.out -ly -lm &> /dev/null
rm -f fibo.ppp.c
