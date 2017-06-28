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
