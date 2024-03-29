#ifndef BASIC_OPERATIONS_H
#define BASIC_OPERATIONS_H

#include "../../types/include/object.h"
#include "../../types/include/types.h"

#include "sum.h"
#include "sub.h"
#include "mul.h"
#include "dvn.h"
#include "compare.h"
#include "parser.h"

_object createInt(int num);
_object createDecimal(float num);
_object createString(char* num);
_object powIntInt(_object o1, _object o2);


// ---- AUX FUNCTIONS ----
int digitCount(int n);
char * multiplyString(char * str, float f);
void invertStr(char* str);
char* itoa(int n);
char * floatToString(float f);
void deleteSubstr(char* str, char* substr, char* dest);
void loadOperations();

#endif
