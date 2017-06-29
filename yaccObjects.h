#ifndef YACC_OBJ_H
#define YACC_OBJ_H

#include "types/include/types.h"

typedef enum {
	EXPR_NUM,
	EXPR_VAR,
	EXPR_OPER
} exprContent;

typedef struct {
	exprContent contentType;
	TypeT type;
	void* content;
} y_expression;

typedef struct {
	_object obj;
	char* funcCreator;
} y_number;

typedef struct {
	y_expression* exp1;
	y_expression* exp2;
	TypeT retType;
	char* opName;
} y_operation;

#endif