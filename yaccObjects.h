#ifndef YACC_OBJ_H
#define YACC_OBJ_H

#include "types/include/types.h"

typedef enum {
	EXPR_NUM,
	EXPR_VAR,
	EXPR_OPER
} exprContent;

typedef struct {
	TypeT type;
	exprContent contentType;
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

typedef struct {
	char* name;
	TypeT type;
	int blockNum;
} y_variable;

typedef struct {
	y_variable* var;
	y_expression* exp;
	int isNew;
	char* opName;
} y_assign;

typedef struct {
	char* compFunc;
	y_expression* exp1;
	y_expression* exp2;
} y_boolExpr;

typedef struct {
	int type;
	void* content;
} y_inst;

typedef struct y_node {
	struct y_node* next;
	y_inst* inst;
} y_node;

typedef struct Prog{
	y_node* first;
} y_prog;

typedef struct {
	y_boolExpr* boolExp;
	y_prog* prevProg;
	y_prog* prog;
} y_if;


#endif
