#include <stdlib.h>
#include <stdio.h>
#include "operations.h"

_object empty = { .type = INTEGER, .cont.num = 0 };

_object addInt(_object, _object);
_object subsInt(_object, _object);
_object multInt(_object, _object);
_object divInt(_object, _object);
_object addFl(_object, _object);
_object subsFl(_object, _object);
_object multFl(_object, _object);
_object divFl(_object, _object);

_object add(_object o1, _object o2) {
	switch(o1.type) {

		case INTEGER:
			switch(o2.type) {
				case INTEGER:
					return addInt(o1, o2);
				case DECIMAL: ;
					_object o = { .type = DECIMAL, .cont.fl = o1.cont.num};
					return addFl(o, o2);
			}

		case DECIMAL:
			switch(o2.type) {
				case INTEGER: ;
					_object o = { .type = DECIMAL, .cont.fl = o2.cont.num};
					return addFl(o1, o);
				case DECIMAL:
					return addFl(o1, o2);
			}
	}
	return empty;
}

_object substract(_object o1, _object o2) {
	switch(o1.type) {
		case INTEGER:
			switch(o2.type) {
				case INTEGER:
					return subsInt(o1, o2);
				case DECIMAL: ;
					_object o = { .type = DECIMAL, .cont.fl = o1.cont.num};
					return subsFl(o, o2);
			}

		case DECIMAL:
			switch(o2.type) {
				case INTEGER: ;
					_object o = { .type = DECIMAL, .cont.fl = o2.cont.num};
					return subsFl(o1, o);
				case DECIMAL:
					return subsFl(o1, o2);
			}
	}
	return empty;
}

_object multiply(_object o1, _object o2) {
	switch(o1.type) {
		case INTEGER:
			switch(o2.type) {
				case INTEGER:
					return multInt(o1, o2);
				case DECIMAL: ;
					_object o = { .type = DECIMAL, .cont.fl = o1.cont.num};
					return multFl(o, o2);
			}

		case DECIMAL:
			switch(o2.type) {
				case INTEGER: ;
					_object o = { .type = DECIMAL, .cont.fl = o2.cont.num};
					return multFl(o1, o);
				case DECIMAL:
					return multFl(o1, o2);
			}
	}
	return empty;
}

_object divide(_object o1, _object o2) {
	switch(o1.type) {
		case INTEGER:
			switch(o2.type) {
				case INTEGER:
					return divInt(o1, o2);
				case DECIMAL: ;
					_object o = { .type = DECIMAL, .cont.fl = o1.cont.num};
					return divFl(o, o2);
			}

		case DECIMAL:
			switch(o2.type) {
				case INTEGER: ;
					_object o = { .type = DECIMAL, .cont.fl = o2.cont.num};
					return divFl(o1, o);
				case DECIMAL:
					return divFl(o1, o2);
			}
	}
	return empty;
}

_object addInt(_object o1, _object o2) {
	_object o;
	o.type = INTEGER;
	o.cont.num = o1.cont.num + o2.cont.num;
	return o; 
}

_object addFl(_object o1, _object o2) {
	_object o;
	o.type = DECIMAL;
	o.cont.fl = o1.cont.fl + o2.cont.fl;
	return o; 
}

_object subsInt(_object o1, _object o2) {
	_object o;
	o.type = INTEGER;
	o.cont.num = o1.cont.num - o2.cont.num;
	return o; 
}

_object subsFl(_object o1, _object o2) {
	_object o;
	o.type = DECIMAL;
	o.cont.fl = o1.cont.fl - o2.cont.fl;
	return o; 
}

_object multInt(_object o1, _object o2) {
	_object o;
	o.type = INTEGER;
	o.cont.num = o1.cont.num * o2.cont.num;
	return o; 
}

_object multFl(_object o1, _object o2) {
	_object o;
	o.type = DECIMAL;
	o.cont.fl = o1.cont.fl * o2.cont.fl;
	return o; 
}

_object divInt(_object o1, _object o2) {
	_object o;
	o.type = INTEGER;
	o.cont.num = o1.cont.num / o2.cont.num;
	return o; 
}

_object divFl(_object o1, _object o2) {
	_object o;
	o.type = DECIMAL;
	o.cont.fl = o1.cont.fl / o2.cont.fl;
	return o; 
}