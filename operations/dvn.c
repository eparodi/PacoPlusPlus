#include <stdlib.h>
#include <stdio.h>
#include "include/dvn.h"
#include "include/operations.h"

_object dvnIntInt(_object o1, _object o2) {
	return createInt(o1->cont.num / o2->cont.num);
}

_object dvnDecDec(_object o1, _object o2) {
	return createDecimal(o1->cont.fl / o2->cont.fl);
}

_object dvnIntDec(_object o1, _object o2) {
	return createDecimal(o1->cont.num / o2->cont.fl);
}

_object dvnDecInt(_object o1, _object o2) {
	return createDecimal(o1->cont.fl / o2->cont.num);
}

_object dvnStrStr(_object o1, _object o2) {
	char* auxStr = calloc(1, strlen(o1->cont.str) + 1);
	deleteSubstr(o1->cont.str, o2->cont.str, auxStr);
	return createString(auxStr);
}

_object dvnIntStr(_object o1, _object o2) {
	char* auxStr = itoa(o1->cont.num);
	return dvnStrStr(createString(auxStr), o2);
}

_object dvnStrInt(_object o1, _object o2) {
	char* auxStr = itoa(o2->cont.num);
	return dvnStrStr(o1, createString(auxStr));
}
