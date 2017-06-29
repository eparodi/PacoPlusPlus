#ifndef SUB_H
#define SUB_H

#include "../../types/include/types.h"
#include "../../types/include/object.h"

_object subIntInt(_object o1, _object o2);
_object subIntStr(_object o1, _object o2);
_object subIntDec(_object o1, _object o2);
_object subIntArr(_object o1, _object o2);

_object subStrInt(_object o1, _object o2);
_object subStrStr(_object o1, _object o2);
_object subStrDec(_object o1, _object o2);
_object subStrArr(_object o1, _object o2);

_object subDecInt(_object o1, _object o2);
_object subDecStr(_object o1, _object o2);
_object subDecDec(_object o1, _object o2);
_object subDecArr(_object o1, _object o2);

_object subArrInt(_object o1, _object o2);
_object subArrStr(_object o1, _object o2);
_object subArrDec(_object o1, _object o2);
_object subArrArr(_object o1, _object o2);

#endif
