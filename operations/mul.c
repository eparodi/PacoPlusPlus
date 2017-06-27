#include <stdlib.h>
#include <stdio.h>
#include "include/mul.h"
#include "include/operations.h"

_object mulIntInt(_object o1, _object o2) {
	return createInt(o1->cont.num * o2->cont.num);
}
