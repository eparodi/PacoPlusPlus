#ifndef SUB_H
#define SUB_H

#include "../../types/include/types.h"
#include "../../types/include/object.h"

_object subIntInt(_object o1, _object o2);
_object subDecDec(_object o1, _object o2);
_object subIntDec(_object o1, _object o2);
_object subDecInt(_object o1, _object o2);
_object subStrStr(_object o1, _object o2);
_object subStrInt(_object o1, _object o2);
_object subIntStr(_object o1, _object o2);

#endif
