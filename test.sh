#!/bin/bash

bash compile.sh test.ppp
if ls | grep 'a.out'
then
./a.out
rm a.out
fi
