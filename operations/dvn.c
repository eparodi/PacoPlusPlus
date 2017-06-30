#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "include/dvn.h"
#include "include/operations.h"

//--------------------------------------------------------

_object dvnIntInt(_object o1, _object o2) {
	return createInt(o1->cont.num / o2->cont.num);
}

_object dvnIntStr(_object o1, _object o2) {
	char* auxStr = itoa(o1->cont.num);
	return dvnStrStr(createString(auxStr), o2);
}

_object dvnIntDec(_object o1, _object o2) {
	return createDecimal(o1->cont.num / o2->cont.fl);
}

//_object dvnIntArr(_object o1, _object o2) {
//	return 1;
//}

//--------------------------------------------------------

_object dvnStrInt(_object o1, _object o2) {
	char* auxStr = itoa(o2->cont.num);
	return dvnStrStr(o1, createString(auxStr));
}

_object dvnStrStr(_object o1, _object o2) {
	char* auxStr = calloc(1, strlen(o1->cont.str) + 1);
	deleteSubstr(o1->cont.str, o2->cont.str, auxStr);
	return createString(auxStr);
}

_object dvnStrDec(_object o1, _object o2) {
	char* auxStr = floatToString(o2->cont.fl);
	return dvnStrStr(o1, createString(auxStr));
}

//_object dvnStrArr(_object o1, _object o2) {
//	return 1;
//}

//--------------------------------------------------------

_object dvnDecInt(_object o1, _object o2) {
	return createDecimal(o1->cont.fl / o2->cont.num);
}

_object dvnDecStr(_object o1, _object o2) {
	char* auxStr = floatToString(o1->cont.fl);
	return dvnStrStr(createString(auxStr), o2);
}

_object dvnDecDec(_object o1, _object o2) {
	return createDecimal(o1->cont.fl / o2->cont.fl);
}

//_object dvnDecArr(_object o1, _object o2) {
//	return 1;
//}

//--------------------------------------------------------

//_object dvnArrInt(_object o1, _object o2) {
//	return 1;
//}
//
//_object dvnArrStr(_object o1, _object o2) {
//	return 1;
//}
//
//_object dvnArrDec(_object o1, _object o2) {
//	return 1;
//}
//
//_object dvnArrArr(_object o1, _object o2) {
//	return 1;
//}