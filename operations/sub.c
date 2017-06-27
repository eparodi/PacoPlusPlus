#include <stdlib.h>
#include <stdio.h>
#include "include/sub.h"
#include "include/operations.h"

_object subIntInt(_object o1, _object o2) {
	return createInt(o1->cont.num - o2->cont.num);
}
