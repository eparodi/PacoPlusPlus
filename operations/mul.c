#include <stdlib.h>
#include <stdio.h>
#include "include/mul.h"
#include "include/operations.h"
#include <string.h>

//--------------------------------------------------------

_object mulIntInt(_object o1, _object o2) {
	return createInt(o1->cont.num * o2->cont.num);
}

_object mulIntStr(_object o1, _object o2) {
	return mulStrInt(o2, o1);
}

_object mulIntDec(_object o1, _object o2) {
	return createDecimal(o1->cont.num * o2->cont.fl);
}

//_object mulIntArr(_object o1, _object o2) {
//	//TODO
//	return 1;
//}

//--------------------------------------------------------

_object mulStrInt(_object o1, _object o2) {
	int num = o2->cont.num;
	char * aux = multiplyString(o1->cont.str, abs(num));
	if (num < 0) {
		invertStr(aux);
	}
	return createString(aux);
}

_object mulStrStr(_object o1, _object o2) {
	int len1 = strlen(o1->cont.str);
	int len2 = strlen(o2->cont.str);
	char* aux = calloc(1, len1*(len2 + 1) + 1);
	int i;
	for (i = 0; i < len1; i++) {
		aux[i*(len2+1)] = o1->cont.str[i];
		strcat(aux,o2->cont.str);
	}
	return createString(aux);
}

_object mulStrDec(_object o1, _object o2) {
	float num = o2->cont.fl;
	float abs = (num > 0 ? num : num*(-1));
	char * aux = multiplyString(o1->cont.str, abs);
	if (num < 0) {
		invertStr(aux);
	}
	return createString(aux);
}

//_object mulStrArr(_object o1, _object o2) {
//	//TODO
//	return 1;
//}

//--------------------------------------------------------

_object mulDecInt(_object o1, _object o2) {
	return createDecimal(o1->cont.fl * o2->cont.num);
}

_object mulDecStr(_object o1, _object o2) {
	float num = o1->cont.fl;
	float abs = (num > 0 ? num : num*(-1));
	char * aux = multiplyString(o2->cont.str, abs);
	if (num < 0) {
		invertStr(aux);
	}
	return createString(aux);
}

_object mulDecDec(_object o1, _object o2) {
	return createDecimal(o1->cont.fl * o2->cont.fl);
}

//_object mulDecArr(_object o1, _object o2) {
//	//TODO
//	return 1;
//}

//--------------------------------------------------------

//_object mulArrInt(_object o1, _object o2) {
//	//TODO
//	return 1;
//}
//
//_object mulArrStr(_object o1, _object o2) {
//	//TODO
//	return 1;
//}
//
//_object mulArrDec(_object o1, _object o2) {
//	//TODO
//	return 1;
//}
//
//_object mulArrArr(_object o1, _object o2) {
//	//TODO
//	return 1;
//}