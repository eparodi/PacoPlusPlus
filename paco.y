%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <math.h>
	#include <string.h>
	#include "operations/include/operations.h"
	// #include "operations/include/sum.h"
	#include "types/include/object.h"
		#include "types/include/types.h"
		#include "hashtable/include/hashtable.h"

	#define MAXVAR 8192

	void yyerror(char* s);

		hashTableT var_table;

		static unsigned int str_hash(char* key);
		static unsigned int str_eql(const char * s1, const char * s2);

		typedef _object(*opFunc)(_object, _object);

%}


%union {int num; char* str; float fl; char ch; _object obj}
%start PROGRAM

%token PLUS MINUS MULT DIV POW
%token PLUSEQ MINUSEQ MULTEQ DIVEQ EQ
%token NEWLINE

%token <num> INT
%token <str> STRING
%token <fl> FLOAT
%token <str> VAR

%type <obj> PROGRAM INST ASSIGN EXPRESS NUMBER VALUE OPERAT


%precedence PLUS
%precedence MINUS
%precedence MULT
%precedence DIV
%precedence POW

%%

PROGRAM : INST PROGRAM          { ; }
		| INST                  { ; }
		;

INST    : ASSIGN ';'            { ; }
		| EXPRESS ';'           { ; }
		| ASSIGN ';' NEWLINE    { ; }
		| EXPRESS ';' NEWLINE   { ; }
		| ASSIGN NEWLINE        { printResult($1); }
		| EXPRESS NEWLINE       { printResult($1); }
		;

ASSIGN  : VAR EQ EXPRESS        {
									$$ = $3;
									addElementHT(var_table,$1,$$);
								}
		| VAR PLUSEQ EXPRESS    {
									OperationT operation = getOperation(ADD, ((_object)getElementHT(var_table, $1))->type, $3->type);
									$$ = operation->func(((_object)getElementHT(var_table, $1)),$3);
									addElementHT(var_table, $1, $$);
								}
		| VAR MINUSEQ EXPRESS   {printf("MINUSEQ\n");
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
								}
		;

EXPRESS : VAR                   { $$ = (_object) getElementHT(var_table, $1); }
		| VALUE                 { $$ = $1; }
		| OPERAT                { $$ = $1; }
		;

OPERAT  : EXPRESS PLUS EXPRESS  {
									OperationT operation = getOperation(ADD, $1->type, $3->type);
									$$ = operation->func($1,$3);
								}
		| EXPRESS MINUS EXPRESS {
									OperationT operation = getOperation(SUB, $1->type, $3->type);
									$$ = operation->func($1,$3);
								}
		| EXPRESS MULT EXPRESS  {
									OperationT operation = getOperation(MUL, $1->type, $3->type);
									$$ = operation->func($1,$3);
								}
		| EXPRESS DIV EXPRESS   {
									OperationT operation = getOperation(DVN, $1->type, $3->type);
									$$ = operation->func($1,$3);
								}
		| EXPRESS POW EXPRESS   {
									OperationT operation = getOperation(PWR, $1->type, $3->type);
									$$ = operation->func($1,$3);
								}
		;

VALUE   : NUMBER                { $$ = $1; }
		;

NUMBER  : INT                   { $$ = createInt($1); }
		| FLOAT                 { $$ = createDecimal($1); }
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
		addOperation(&addIntInt,"addIntInt",INTEGER, INTEGER,ADD);
		addOperation(&subIntInt,"subIntInt",INTEGER, INTEGER,SUB);
		addOperation(&mulIntInt,"mulIntInt",INTEGER, INTEGER,MUL);
		addOperation(&dvnIntInt,"dvnIntInt",INTEGER, INTEGER,DVN);
		addOperation(&powIntInt,"powIntInt",INTEGER, INTEGER,PWR);

		// DECIMAL DECIMAL OPERATIONS		
		addOperation(&addDecDec,"addDecDec",DECIMAL, DECIMAL,ADD);
		addOperation(&subDecDec,"subDecDec",DECIMAL, DECIMAL,SUB);
		addOperation(&mulDecDec,"mulDecDec",DECIMAL, DECIMAL,MUL);
		addOperation(&dvnDecDec,"dvnDecDec",DECIMAL, DECIMAL,DVN);

		// INT DECIMAL OPERATIONS		
		addOperation(&addIntDec,"addIntDec",INTEGER, DECIMAL,ADD);
		addOperation(&subIntDec,"subIntDec",INTEGER, DECIMAL,SUB);
		addOperation(&mulIntDec,"mulIntDec",INTEGER, DECIMAL,MUL);
		addOperation(&dvnIntDec,"dvnIntDec",INTEGER, DECIMAL,DVN);

		// DECIMAL INT OPERATIONS		
		addOperation(&addDecInt,"addDecInt",DECIMAL, INTEGER,ADD);
		addOperation(&subDecInt,"subDecInt",DECIMAL, INTEGER,SUB);
		addOperation(&mulDecInt,"mulDecInt",DECIMAL, INTEGER,MUL);
		addOperation(&dvnDecInt,"dvnDecInt",DECIMAL, INTEGER,DVN);
	return yyparse();
}


void printResult(_object o) {
	switch(o->type->id) {
				printf("TYPE = %d\n", o->type->id);
		case INTEGER:
			printf("%d\n", o->cont.num);
			break;
		case DECIMAL:
			printf("%f\n", o->cont.fl);
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
