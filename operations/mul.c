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
