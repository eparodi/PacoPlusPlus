#ifndef SUM_H
#define SUM_H

#include "../../types/include/types.h"
#include "../../types/include/object.h"

_object addIntInt(_object o1, _object o2);
_object addDecDec(_object o1, _object o2);
_object addIntDec(_object o1, _object o2);
_object addDecInt(_object o1, _object o2);
_object addStrStr(_object o1, _object o2);
_object addStrInt(_object o1, _object o2);
_object addIntStr(_object o1, _object o2);

#endif
