#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "include/sum.h"
#include "include/operations.h"

_object addIntInt(_object o1, _object o2) {
	return createInt(o1->cont.num + o2->cont.num);
}

_object addIntStr(_object o1, _object o2) {
	char* intStr = itoa(o1->cont.num);
	return addStrStr(createString(intStr), o2);
}

_object addIntDec(_object o1, _object o2) {
	return createDecimal(o1->cont.num + o2->cont.fl);
}

_object addIntArr(_object o1, _object o2) {
	//TODO
	return 1;
}

_object addStrInt(_object o1, _object o2) {
	char* intStr = itoa(o2->cont.num);
	return addStrStr(o1, createString(intStr));
}

_object addStrStr(_object o1, _object o2) {
	char* auxStr = malloc(strlen(o1->cont.str) + strlen(o2->cont.str) + 1);
	strcpy(auxStr, o1->cont.str);
	strcat(auxStr, o2->cont.str);
	return createString(auxStr);
}

_object addStrDec(_object o1, _object o2) {
	char* decStr = floatToString(o2->cont.fl);
	return addStrStr(o1, createString(decStr));
}

_object addStrArr(_object o1, _object o2) {
	//TODO
	return 1;
}

_object addDecInt(_object o1, _object o2) {
	return createDecimal(o1->cont.fl + o2->cont.num);
}

_object addDecStr(_object o1, _object o2) {
	char * decStr = floatToString(o1->cont.fl);
	return addStrStr(createString(decStr), o2);
}

_object addDecDec(_object o1, _object o2) {
	return createDecimal(o1->cont.fl + o2->cont.fl);
}

_object addDecArr(_object o1, _object o2) {
	//TODO
	return 1;
}

_object addArrInt(_object o1, _object o2) {
	//TODO
	return 1;
}

_object addArrStr(_object o1, _object o2) {
	//TODO
	return 1;
}

_object addArrDec(_object o1, _object o2) {
	//TODO
	return 1;
}

_object addArrArr(_object o1, _object o2) {
	//TODO
	return 1;
}