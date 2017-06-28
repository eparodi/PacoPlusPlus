#include <stdlib.h>
#include <stdio.h>
#include "include/sub.h"
#include "include/operations.h"

_object subIntInt(_object o1, _object o2) {
	return createInt(o1->cont.num - o2->cont.num);
}

_object subDecDec(_object o1, _object o2) {
	return createDecimal(o1->cont.fl - o2->cont.fl);
}

_object subIntDec(_object o1, _object o2) {
	return createDecimal(o1->cont.num - o2->cont.fl);
}

_object subDecInt(_object o1, _object o2) {
	return createDecimal(o1->cont.fl - o2->cont.num);
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

_object subStrInt(_object o1, _object o2) {
	char* intStr = itoa(o2->cont.num);
	return subStrStr(o1, createString(intStr));
}

_object subIntStr(_object o1, _object o2) {
	char* intStr = itoa(o1->cont.num);
	return subStrStr(createString(intStr), o2);
}