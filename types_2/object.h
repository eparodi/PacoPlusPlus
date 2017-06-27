
#ifndef OBJECT2_H
#define OBJECT2_H

typedef enum { INTEGER, DECIMAL} _type;

typedef union Content {
	int num;
	float fl;
	char* str;
} _content;

typedef struct Object {
	_type type;
	_content cont;
} _object;

#endif