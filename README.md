# Paco++

### Requirements

* Lex or [Flex](https://github.com/westes/flex/releases).
* Yacc or [Bison](https://www.gnu.org/software/bison/).
* GCC.

### Build Compiler

First make sure to clean every unwanted file:
```
  make clean
```
Then build the compiler:
```
  make
```

This must generate an executable "pacopp.out".

### Compile your code

```
  ./compiler.sh sample.ppp
  ./a.out
```

### Examples

isPrime.ppp, collatz.ppp, numOculto.ppp, operations.ppp and fibo.ppp are examples of algorithms coded in Paco++. You can run them by running:
```
  ./compiler.sh <nameOfProgram>.ppp
  ./a.out
```


Enjoy!