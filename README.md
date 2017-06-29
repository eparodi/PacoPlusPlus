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

Enjoy!