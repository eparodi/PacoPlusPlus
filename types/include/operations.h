#ifndef BASIC_OPERATIONS_H
#define BASIC_OPERATIONS_H

#include "object.h"

_object createInt(int num);
_object addInt(_object, _object);
_object subsInt(_object, _object);
_object multInt(_object, _object);
_object divInt(_object, _object);
_object addFl(_object, _object);
_object subsFl(_object, _object);
_object multFl(_object, _object);
_object divFl(_object, _object);

#endif
