#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "include/sub.h"
#include "include/operations.h"

//--------------------------------------------------------

_object subIntInt(_object o1, _object o2) {
	return createInt(o1->cont.num - o2->cont.num);
}

_object subIntStr(_object o1, _object o2) {
	char* intStr = itoa(o1->cont.num);
	return subStrStr(createString(intStr), o2);
}

_object subIntDec(_object o1, _object o2) {
	return createDecimal(o1->cont.num - o2->cont.fl);
}

//_object subIntArr(_object o1, _object o2) {
//	//TODO
//	return 1;
//}

//--------------------------------------------------------

_object subStrInt(_object o1, _object o2) {
	char* intStr = itoa(o2->cont.num);
	return subStrStr(o1, createString(intStr));
}

_object subStrStr(_object o1, _object o2) {
	char* auxStr = calloc(1, strlen(o1->cont.str))-1;
	int i = strlen(o1->cont.str)-1, j = strlen(o2->cont.str)-1;

	while(i >= 0 && j >= 0 && (o1->cont.str)[i] == (o2->cont.str)[j]) {
		i--;
		j--;
	}

	strncpy(auxStr, o1->cont.str, i+1);
	return createString(auxStr);
}

_object subStrDec(_object o1, _object o2) {
	char* decStr = floatToString(o2->cont.fl);
	return subStrStr(o1, createString(decStr));
}

//_object subStrArr(_object o1, _object o2) {
//	//TODO
//	return 1;
//}

//--------------------------------------------------------

_object subDecInt(_object o1, _object o2) {
	return createDecimal(o1->cont.fl - o2->cont.num);
}

_object subDecStr(_object o1, _object o2) {
	char* decStr = floatToString(o1->cont.fl);
	return subStrStr(createString(decStr), o2);
}

_object subDecDec(_object o1, _object o2) {
	return createDecimal(o1->cont.fl - o2->cont.fl);
}

//_object subDecArr(_object o1, _object o2) {
//	//TODO
//	return 1;
//}

//--------------------------------------------------------

//_object subArrInt(_object o1, _object o2) {
//	//TODO
//	return 1;
//}
//
//_object subArrStr(_object o1, _object o2) {
//	//TODO
//	return 1;
//}
//
//_object subArrDec(_object o1, _object o2) {
//	//TODO
//	return 1;
//}
//
//_object subArrArr(_object o1, _object o2) {
//	//TODO
//	return 1;
//}