
#ifndef OBJECT_H
#define OBJECT_H

#include "types.h"

typedef struct Type * TypeT;

typedef union Content {
	int num;
	float fl;
	char* str;
} _content;

typedef struct Object {
	TypeT type;
	_content cont;
} Object;

typedef Object * _object;

#endif
