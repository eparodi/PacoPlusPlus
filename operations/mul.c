#include <stdlib.h>
#include <stdio.h>
#include "include/mul.h"
#include "include/operations.h"

_object mulIntInt(_object o1, _object o2) {
	return createInt(o1->cont.num * o2->cont.num);
}

_object mulDecDec(_object o1, _object o2) {
	return createDecimal(o1->cont.fl * o2->cont.fl);
}

_object mulIntDec(_object o1, _object o2) {
	return createDecimal(o1->cont.num * o2->cont.fl);
}

_object mulDecInt(_object o1, _object o2) {
	return createDecimal(o1->cont.fl * o2->cont.num);
}

_object mulStrInt(_object o1, _object o2) {
	int num = o2->cont.num;
	char* auxStr = calloc(1, abs(num) * strlen(o1->cont.str) + 1);
	multiplyString(o1->cont.str, abs(num), auxStr);
	if (num < 0) {
		invertStr(auxStr);
	}
	return createString(auxStr);
}

_object mulIntStr(_object o1, _object o2) {
	return mulStrInt(o2, o1);
}