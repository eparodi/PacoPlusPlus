#include <stdlib.h>
#include <stdio.h>
#include "operations.h"

_object empty = { .type = INTEGER, .cont.num = 0 };

_object addInt(_object, _object);
_object subsInt(_object, _object);
_object multInt(_object, _object);
_object divInt(_object, _object);

_object add(_object o1, _object o2) {
	switch(o1.type) {
		case INTEGER:
			switch(o2.type) {
				case INTEGER:
					return addInt(o1, o2);
			}
			break;
	}
	return o1;
}

_object substract(_object o1, _object o2) {
	switch(o1.type) {
		case INTEGER:
			switch(o2.type) {
				case INTEGER:
					return subsInt(o1, o2);
			}
			break;
	}
	return o1;
}

_object multiply(_object o1, _object o2) {
	switch(o1.type) {
		case INTEGER:
			switch(o2.type) {
				case INTEGER:
					return multInt(o1, o2);
			}
			break;
	}
	return o1;
}

_object divide(_object o1, _object o2) {
	switch(o1.type) {
		case INTEGER:
			switch(o2.type) {
				case INTEGER:
					return divInt(o1, o2);
			}
			break;
	}
	return o1;
}

_object addInt(_object o1, _object o2) {
	_object o;
	o.type = INTEGER;
	o.cont.num = o1.cont.num + o2.cont.num;
	return o; 
}

_object subsInt(_object o1, _object o2) {
	_object o;
	o.type = INTEGER;
	printf("Substracting %d and %d\n", o1.cont.num, o2.cont.num);
	o.cont.num = o1.cont.num - o2.cont.num;
	return o; 
}

_object multInt(_object o1, _object o2) {
	_object o;
	o.type = INTEGER;
	o.cont.num = o1.cont.num * o2.cont.num;
	return o; 
}

_object divInt(_object o1, _object o2) {
	_object o;
	o.type = INTEGER;
	o.cont.num = o1.cont.num / o2.cont.num;
	return o; 
}