#ifndef DVN_H
#define DVN_H

#include "../../types/include/types.h"
#include "../../types/include/object.h"

_object dvnIntInt(_object o1, _object o2);
_object dvnIntStr(_object o1, _object o2);
_object dvnIntDec(_object o1, _object o2);
_object dvnIntArr(_object o1, _object o2);

_object dvnStrInt(_object o1, _object o2);
_object dvnStrStr(_object o1, _object o2);
_object dvnStrDec(_object o1, _object o2);
_object dvnStrArr(_object o1, _object o2);

_object dvnDecInt(_object o1, _object o2);
_object dvnDecStr(_object o1, _object o2);
_object dvnDecDec(_object o1, _object o2);
_object dvnDecArr(_object o1, _object o2);

_object dvnArrInt(_object o1, _object o2);
_object dvnArrStr(_object o1, _object o2);
_object dvnArrDec(_object o1, _object o2);
_object dvnArrArr(_object o1, _object o2);

#endif
