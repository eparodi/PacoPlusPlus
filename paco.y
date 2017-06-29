%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <math.h>
	#include <string.h>
	#include "operations/include/operations.h"
	#include "types/include/object.h"
	#include "types/include/types.h"
	#include "hashtable/include/hashtable.h"
	#include "yaccObjects.h"

	#define MAXVAR 8192

	void yyerror(char* s);

	hashTableT var_table;

	static unsigned int str_hash(char* key);
	static unsigned int str_eql(const char * s1, const char * s2);
	void printExpr(y_expression* expr);
	void printOperation(y_operation* oper);
	void printObject(_object o);
	void printObject(_object o);

	typedef _object(*opFunc)(_object, _object);

%}


%union {
	int num; 
	char* str; 
	float fl; 
	char ch;
	_object obj;

	y_number* number;
	y_expression* expression;
	y_operation* operation;
}
%start PROGRAM

%token PLUS MINUS MULT DIV POW
%token PLUSEQ MINUSEQ MULTEQ DIVEQ EQ
%token NEWLINE

%token <num> INT
%token <str> STRING
%token <fl> FLOAT
%token <str> VAR

%type <obj> PROGRAM INST ASSIGN VALUE
%type <number> NUMBER
%type <expression> EXPRESS
%type <operation> OPERAT

%precedence PLUS
%precedence MINUS
%precedence MULT
%precedence DIV
%precedence POW

%%

PROGRAM : INST PROGRAM          { ; }
		| INST                  { ; }
		;

INST    : ASSIGN ';'            { printf(";\n"); }
		| EXPRESS ';'           { printf(";\n"); }
		| ASSIGN ';' NEWLINE    { printf(";\n"); }
		| EXPRESS ';' NEWLINE   { printf(";\n"); }
		| ASSIGN NEWLINE        { 
									printf(";\n");
									printObject($1);
									printf("\n"); 
								}
		| EXPRESS NEWLINE       {
									printExpr($1); 
									printf(";\n");
									printf("\n"); 
								}
		;

ASSIGN  : /*VAR EQ EXPRESS        {
									$$ = $3;
									addElementHT(var_table,$1,$$);
								}
		| VAR PLUSEQ EXPRESS    {
									OperationT operation = getOperation(ADD, ((_object)getElementHT(var_table, $1))->type, $3->type);
									$$ = operation->func(((_object)getElementHT(var_table, $1)),$3);
									addElementHT(var_table, $1, $$);
								}
		| VAR MINUSEQ EXPRESS   {
									OperationT operation = getOperation(ADD, ((_object)getElementHT(var_table, $1))->type, $3->type);
									$$ = operation->func(((_object)getElementHT(var_table, $1)),$3);
									addElementHT(var_table, $1, $$);
								}
		| VAR MULTEQ EXPRESS    {
									OperationT operation = getOperation(MUL, ((_object)getElementHT(var_table, $1))->type, $3->type);
									$$ = operation->func(((_object)getElementHT(var_table, $1)),$3);
									addElementHT(var_table, $1, $$);
								}
		| VAR DIVEQ EXPRESS     {
									OperationT operation = getOperation(DVN, ((_object)getElementHT(var_table, $1))->type, $3->type);
									$$ = operation->func(((_object)getElementHT(var_table, $1)),$3);
									addElementHT(var_table, $1, $$);
								}*/VAR EQ NUMBER
		;

EXPRESS : VAR                   { 
									/*$$ = malloc(sizeof(*$$));
									$$->obj = (_object) getElementHT(var_table, $1); 
										switch($$->type->id) {
											case INTEGER:
												
												break;
											case DECIMAL:
												break;
											case STR:
												break;
										}*/
								}
		| NUMBER                { 
									$$ = malloc(sizeof(*$$));
									$$->contentType = EXPR_NUM;
									$$->type = $1->obj->type;
									$$->content = $1; 
								}
		| OPERAT                { 
									$$ = malloc(sizeof(*$$));
									$$->contentType = EXPR_OPER;
									$$->type = $1->retType;
									$$->content = $1; 
								}
		;

OPERAT  : EXPRESS PLUS EXPRESS  {
									OperationT operation = getOperation(ADD, $1->type, $3->type);
									$$ = malloc(sizeof(*$$));
									$$->opName = malloc(strlen(operation->func_name)+1);
									strcpy($$->opName, operation->func_name);
									$$->exp1 = $1;
									$$->exp2 = $3;
									//$$ = operation->func($1,$3);
									//printf("%s(", operation->func_name);
								}
		| EXPRESS MINUS EXPRESS {
									OperationT operation = getOperation(SUB, $1->type, $3->type);
									$$ = malloc(sizeof(*$$));
									$$->opName = malloc(strlen(operation->func_name)+1);
									strcpy($$->opName, operation->func_name);
									$$->exp1 = $1;
									$$->exp2 = $3;
									//$$ = operation->func($1,$3);
									//printf("%s(", operation->func_name);
								}
		| EXPRESS MULT EXPRESS  {
									OperationT operation = getOperation(MUL, $1->type, $3->type);
									$$ = malloc(sizeof(*$$));
									$$->opName = malloc(strlen(operation->func_name)+1);
									strcpy($$->opName, operation->func_name);
									$$->exp1 = $1;
									$$->exp2 = $3;
									//$$ = operation->func($1,$3);
									//printf("%s(", operation->func_name);
								}
		| EXPRESS DIV EXPRESS   {
									OperationT operation = getOperation(DVN, $1->type, $3->type);
									$$ = malloc(sizeof(*$$));
									$$->opName = malloc(strlen(operation->func_name)+1);
									strcpy($$->opName, operation->func_name);
									$$->exp1 = $1;
									$$->exp2 = $3;
									//$$ = operation->func($1,$3);
									//printf("%s(", operation->func_name);
								}
		| EXPRESS POW EXPRESS   {
									OperationT operation = getOperation(PWR, $1->type, $3->type);
									$$ = malloc(sizeof(*$$));
									$$->opName = malloc(strlen(operation->func_name)+1);
									strcpy($$->opName, operation->func_name);
									$$->exp1 = $1;
									$$->exp2 = $3;
									//$$ = operation->func($1,$3);
									//printf("%s(", operation->func_name);
								}
		/*| EXPRESS '?'			{ $$ = createString($1->type->name);}*/
		;


NUMBER  : INT                   { 	
									$$ = malloc(sizeof(*$$));
									$$->obj = createInt($1);
									$$->funcCreator = malloc("createInt()" + 200 + 1);	// 200 is max chars
									sprintf($$->funcCreator, "createInt(%d)", $1);
								}
		| FLOAT                 { 
									$$ = malloc(sizeof(*$$));
									$$->obj = createDecimal($1);
									$$->funcCreator = malloc("createDecimal()" + 200 + 1);	// 200 is max chars
									sprintf($$->funcCreator, "createDecimal(%ff)", $1);
								}
		| STRING 				{ 
									$$ = malloc(sizeof(*$$));
									$$->obj = createString($1);
									$$->funcCreator = malloc("createString()" + 200 + 1);	// 200 is max chars
									sprintf($$->funcCreator, "createString(\"%s\")", $1);
								}
		;

%%

int yywrap(void)
{
  return 0;
}

int
main(void)
{
		var_table = createHashTable(sizeof(char *), sizeof(_object), &str_hash, 20, &str_eql);
		startTypes();
		buildOpTable();

		// INT INT OPERATIONS
		addOperation(&addIntInt,"addIntInt",INTEGER, INTEGER,ADD,getType(INTEGER));
		addOperation(&subIntInt,"subIntInt",INTEGER, INTEGER,SUB,getType(INTEGER));
		addOperation(&mulIntInt,"mulIntInt",INTEGER, INTEGER,MUL,getType(INTEGER));
		addOperation(&dvnIntInt,"dvnIntInt",INTEGER, INTEGER,DVN,getType(INTEGER));
		addOperation(&powIntInt,"powIntInt",INTEGER, INTEGER,PWR,getType(INTEGER));

		// DECIMAL DECIMAL OPERATIONS		
		addOperation(&addDecDec,"addDecDec",DECIMAL, DECIMAL,ADD,getType(DECIMAL));
		addOperation(&subDecDec,"subDecDec",DECIMAL, DECIMAL,SUB,getType(DECIMAL));
		addOperation(&mulDecDec,"mulDecDec",DECIMAL, DECIMAL,MUL,getType(DECIMAL));
		addOperation(&dvnDecDec,"dvnDecDec",DECIMAL, DECIMAL,DVN,getType(DECIMAL));

		// INT DECIMAL OPERATIONS		
		addOperation(&addIntDec,"addIntDec",INTEGER, DECIMAL,ADD,getType(DECIMAL));
		addOperation(&subIntDec,"subIntDec",INTEGER, DECIMAL,SUB,getType(DECIMAL));
		addOperation(&mulIntDec,"mulIntDec",INTEGER, DECIMAL,MUL,getType(DECIMAL));
		addOperation(&dvnIntDec,"dvnIntDec",INTEGER, DECIMAL,DVN,getType(DECIMAL));

		// DECIMAL INT OPERATIONS		
		addOperation(&addDecInt,"addDecInt",DECIMAL, INTEGER,ADD,getType(DECIMAL));
		addOperation(&subDecInt,"subDecInt",DECIMAL, INTEGER,SUB,getType(DECIMAL));
		addOperation(&mulDecInt,"mulDecInt",DECIMAL, INTEGER,MUL,getType(DECIMAL));
		addOperation(&dvnDecInt,"dvnDecInt",DECIMAL, INTEGER,DVN,getType(DECIMAL));

		// STRING STRING OPERATIONS		
		addOperation(&addStrStr,"addStrStr",STR, STR,ADD,getType(STR));
		addOperation(&subStrStr,"subStrStr",STR, STR,SUB,getType(STR));
		addOperation(&mulStrStr,"mulStrStr",STR, STR,MUL,getType(STR));
		addOperation(&dvnStrStr,"dvnStrStr",STR, STR,DVN,getType(STR));

		// STRING INT OPERATIONS		
		addOperation(&addStrInt,"addStrInt",STR, INTEGER,ADD,getType(STR));
		addOperation(&subStrInt,"subStrInt",STR, INTEGER,SUB,getType(STR));
		addOperation(&mulStrInt,"mulStrInt",STR, INTEGER,MUL,getType(STR));
		addOperation(&dvnStrInt,"dvnStrInt",STR, INTEGER,DVN,getType(STR));

		// INT STRING OPERATIONS		
		addOperation(&addIntStr,"addIntStr",INTEGER, STR,ADD,getType(STR));
		addOperation(&subIntStr,"subIntStr",INTEGER, STR,SUB,getType(STR));
		addOperation(&mulIntStr,"mulIntStr",INTEGER, STR,MUL,getType(STR));
		addOperation(&dvnIntStr,"dvnIntStr",INTEGER, STR,DVN,getType(STR));

	return yyparse();
}


void printOperation(y_operation* oper) {
	printf("%s(", oper->opName);
	printExpr(oper->exp1);
	printf(",");
	printExpr(oper->exp2);
	printf(")");
}

void printExpr(y_expression* expr) {
	switch(expr->contentType){
		case EXPR_NUM:
			printNum((y_number*)expr->content);
			break;
		case EXPR_VAR:
			//printVar(()
			break;
		case EXPR_OPER:
			printOperation((y_operation*)expr->content);
			break;
	}
}

void printNum(y_number* num) {
	printf("%s", num->funcCreator);

}

void printObject(_object o) {
	switch(o->type->id) {
				printf("TYPE = %d\n", o->type->id);
		case INTEGER:
			printf("%d", o->cont.num);
			break;
		case DECIMAL:
			printf("%f", o->cont.fl);
			break;
		case STR:
			printf("%s", o->cont.str);
			break;
	}
}

void yyerror(char* s)
{
	fprintf(stderr, "Error: %s\n", s);
}

static unsigned int str_hash(char* key){
	unsigned int h = 5381;
	while(*(key++))
		h = ((h << 5) + h) + (*key);
	return h;
}

static unsigned int str_eql(const char * s1, const char * s2){
  return strcmp(s1,s2) == 0;
}
