#!/bin/bash

bash compile.sh collatz.ppp
if ls | grep 'a.out'
then
./a.out
rm a.out
fi
