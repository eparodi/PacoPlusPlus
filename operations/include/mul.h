#ifndef MUL_H
#define MUL_H

#include "../../types/include/types.h"
#include "../../types/include/object.h"

_object mulIntInt(_object o1, _object o2);
_object mulDecDec(_object o1, _object o2);
_object mulIntDec(_object o1, _object o2);
_object mulDecInt(_object o1, _object o2);
_object mulStrInt(_object o1, _object o2);
_object mulIntStr(_object o1, _object o2);
_object mulStrStr(_object o1, _object o2);

#endif
