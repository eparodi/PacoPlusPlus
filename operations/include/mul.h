#ifndef MUL_H
#define MUL_H

#include "../../types/include/types.h"
#include "../../types/include/object.h"

_object mulIntInt(_object o1, _object o2);
_object mulIntStr(_object o1, _object o2);
_object mulIntDec(_object o1, _object o2);
_object mulIntArr(_object o1, _object o2);

_object mulStrInt(_object o1, _object o2);
_object mulStrStr(_object o1, _object o2);
_object mulStrDec(_object o1, _object o2);
_object mulStrArr(_object o1, _object o2);

_object mulDecInt(_object o1, _object o2);
_object mulDecStr(_object o1, _object o2);
_object mulDecDec(_object o1, _object o2);
_object mulDecArr(_object o1, _object o2);

_object mulArrInt(_object o1, _object o2);
_object mulArrStr(_object o1, _object o2);
_object mulArrDec(_object o1, _object o2);
_object mulArrArr(_object o1, _object o2);

#endif
