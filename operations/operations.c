#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <math.h>
#include "include/operations.h"


_object createInt(int num){
	_object o = malloc(sizeof(Object));
	if (!o){
		return NULL;
	}
	o->type = getType(INTEGER);
	o->cont.num = num;
	return o;
}

_object createDecimal(float num){
	_object o = malloc(sizeof(Object));
	if (!o){
		return NULL;
	}
	o->type = getType(DECIMAL);
	o->cont.fl = num;
	return o;
}

_object createString(char* str){
	_object o = malloc(sizeof(Object));
	if (!o){
		return NULL;
	}
	o->type = getType(STR);
	o->cont.str = malloc(strlen(str)+1);
	strcpy(o->cont.str, str);
	return o;
}

_object powIntInt(_object o1, _object o2) {
	return createInt((int)pow(o1->cont.num, o2->cont.num));
}
// _object addInt(_object o1, _object o2) {
// 	return createInt(o1->cont.num + o2->cont.num);
// }
//
// _object addFl(_object o1, _object o2) {
// 	_object o;
// 	o->type = getType(DECIMAL);;
// 	o->cont.fl = o1->cont.fl + o2->cont.fl;
// 	return o;
// }
//
// _object subsInt(_object o1, _object o2) {
// 	return createInt(o1->cont.num - o2->cont.num);
// }
//
// _object subsFl(_object o1, _object o2) {
// 	_object o;
// 	o->type = getType(DECIMAL);;
// 	o->cont.fl = o1->cont.fl - o2->cont.fl;
// 	return o;
// }
//
// _object multInt(_object o1, _object o2) {
// 	return createInt(o1->cont.num ,o2->cont.num);
// }
//
// _object multFl(_object o1, _object o2) {
// 	_object o;
// 	o->type = getType(DECIMAL);;
// 	o->cont.fl = o1->cont.fl * o2->cont.fl;
// 	return o;
// }
//
// _object divInt(_object o1, _object o2) {
// 	_object o;
// 	o->type = getType(INTEGER);;
// 	o->cont.num = o1->cont.num / o2->cont.num;
// 	return o;
// }
//
// _object divFl(_object o1, _object o2) {
// 	_object o;
// 	o->type = getType(DECIMAL);;
// 	o->cont.fl = o1->cont.fl / o2->cont.fl;
// 	return o;
// }
