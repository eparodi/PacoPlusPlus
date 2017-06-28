#include <stdlib.h>
#include <stdio.h>
#include "include/sum.h"
#include "include/operations.h"

_object addIntInt(_object o1, _object o2) {
	return createInt(o1->cont.num + o2->cont.num);
}

_object addDecDec(_object o1, _object o2) {
	return createDecimal(o1->cont.fl + o2->cont.fl);
}

_object addIntDec(_object o1, _object o2) {
	return createDecimal(o1->cont.num + o2->cont.fl);
}

_object addDecInt(_object o1, _object o2) {
	return createDecimal(o1->cont.fl + o2->cont.num);
}
