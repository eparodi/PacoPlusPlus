#include "include/operations.h"
#include <stdio.h>
#define INITIAL 100

_object
parseNum(){
  int num;
  scanf("%d", &num);
  return createInt(num);
}

_object
parseDec(){
  float dec;
  scanf("%f", &dec);
  return createDecimal(dec);
}

_object
parseString(){
  char * str = malloc(INITIAL * sizeof(char));
  int size = INITIAL;
  int index = 0;
  int c;
  while((c=getchar())!= '\n'){
    if (size == index){
      size *= 2;
      str = realloc(str,size);
    }
    str[index++] = c;
  }
  _object o = createString(str);
  free(str);
  return o;
}