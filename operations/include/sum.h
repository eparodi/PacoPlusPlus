#ifndef SUM_H
#define SUM_H

#include "../../types/include/types.h"
#include "../../types/include/object.h"

_object addIntInt(_object o1, _object o2);
_object addIntStr(_object o1, _object o2);
_object addIntDec(_object o1, _object o2);
_object addIntArr(_object o1, _object o2);

_object addStrInt(_object o1, _object o2);
_object addStrStr(_object o1, _object o2);
_object addStrDec(_object o1, _object o2);
_object addStrArr(_object o1, _object o2);

_object addDecInt(_object o1, _object o2);
_object addDecStr(_object o1, _object o2);
_object addDecDec(_object o1, _object o2);
_object addDecArr(_object o1, _object o2);

_object addArrInt(_object o1, _object o2);
_object addArrStr(_object o1, _object o2);
_object addArrDec(_object o1, _object o2);
_object addArrArr(_object o1, _object o2);

#endif
