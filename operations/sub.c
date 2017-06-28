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
