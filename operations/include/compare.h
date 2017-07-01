#ifndef COMP_H
#define COMP_H

#include "../../types/include/types.h"
#include "../../types/include/object.h"

#define FALSE createInt(0);
#define TRUE  createInt(1);

_object
differentType(_object o1, _object o2);
_object
compareInt(_object o1, _object o2);
_object
compareDecimal(_object o1, _object o2);
_object
compareString(_object o1, _object o2);
_object
compareList(_object li1, _object li2);
_object
leInt(_object o1, _object o2);
_object
leDecimal(_object o1, _object o2);
_object
leString(_object o1, _object o2);
_object
leList(_object o1, _object o2);
_object
ltInt(_object o1, _object o2);
_object
ltDecimal(_object o1, _object o2);
_object
ltString(_object o1, _object o2);
_object
ltList(_object o1, _object o2);
_object
gtInt(_object o1, _object o2);
_object
gtDecimal(_object o1, _object o2);
_object
gtString(_object o1, _object o2);
_object
gtList(_object o1, _object o2);
_object
geInt(_object o1, _object o2);
_object
geDecimal(_object o1, _object o2);
_object
geString(_object o1, _object o2);
_object
geList(_object o1, _object o2);
_object
eqIntDec(_object o1, _object o2);
_object
ltIntDec(_object o1, _object o2);
_object
gtIntDec(_object o1, _object o2);
_object
leIntDec(_object o1, _object o2);
_object
geIntDec(_object o1, _object o2);
_object
eqDecInt(_object o1, _object o2);
_object
ltDecInt(_object o1, _object o2);
_object
gtDecInt(_object o1, _object o2);
_object
leDecInt(_object o1, _object o2);
_object
geDecInt(_object o1, _object o2);
_object
areDifferent(_object o1, _object o2);
#endif
