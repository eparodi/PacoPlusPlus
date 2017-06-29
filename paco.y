%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <math.h>
	#include <string.h>
	#include "operations/include/operations.h"
	#include "types/include/object.h"
	#include "types/include/types.h"
	#include "types/include/list.h"
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
	void printVariable(y_variable* var);
	void printAssign(y_assign* assign);
	void printBoolExpr(y_boolExpr* expr);
	void printInst(y_inst* i);
	void printProg(y_prog* prog);

	void addInstToProg(y_prog* prog, y_inst* i);
	void startC();
	void endC();

	typedef _object(*opFunc)(_object, _object);


	y_prog* prog;
	y_prog* actualProg;

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
	y_variable* variable;
	y_assign* assign;
	y_boolExpr* boolExpr;
	y_inst* inst;
	y_prog* prog;
	y_if* ifBlok;
}
%start PROGRAM

%token PLUS MINUS MULT DIV POW
%token PLUSEQ MINUSEQ MULTEQ DIVEQ EQ
%token NEWLINE

%token IF WHILE END BEGINPROG LT LE GT GE

%token <num> INT
%token <str> STRING
%token <fl> FLOAT
%token <str> VAR

%type <obj> VALUE
%type <obj> ARRAY
%type <number> NUMBER
%type <expression> EXPRESS
%type <operation> OPERAT
%type <assign> ASSIGN
%type <boolExpr> BOOLEXPR
%type <inst> INST
%type <prog> PROGRAM
%type <ifBlok> IFBLOCK
%type <ifBlok> IFTOKEN
%type <ifBlok> WHILEBLOCK
%type <ifBlok> WHILETOKEN

%precedence PLUS
%precedence MINUS
%precedence MULT
%precedence DIV
%precedence POW

%%

START 	: BEGINPROG NEWLINE PROGRAM END {  }

PROGRAM : INST PROGRAM	        {
									addInstToProg(actualProg,$1);
									// printInst($1);
								}
		| INST                  {
									addInstToProg(actualProg,$1);
									// printInst($1);
								}
		;
INST    : ASSIGN ';'            {
									$$ = malloc(sizeof(*$$));
									$$->type = 0;
									$$->content = $1;
								}
		| EXPRESS ';'           {
									$$ = malloc(sizeof(*$$));
									$$->type = 1;
									$$->content = $1;
								}
		| ASSIGN ';' NEWLINE    {
									$$ = malloc(sizeof(*$$));
									$$->type = 2;
									$$->content = $1;
								}
		| EXPRESS ';' NEWLINE   {
									$$ = malloc(sizeof(*$$));
									$$->type = 3;
									$$->content = $1;
								}
		| ASSIGN NEWLINE        {
									$$ = malloc(sizeof(*$$));
									$$->type = 4;
									$$->content = $1;
								}
		| EXPRESS NEWLINE       {
									$$ = malloc(sizeof(*$$));
									$$->type = 5;
									$$->content = $1;
								}
		| IFBLOCK  				{
									$$ = malloc(sizeof(*$$));
									$$->type = 6;
									$$->content = $1;
								}
		| WHILEBLOCK  			{
									$$ = malloc(sizeof(*$$));
									$$->type = 7;
									$$->content = $1;
								}
		;

IFBLOCK	: IFTOKEN '(' BOOLEXPR ')' NEWLINE PROGRAM END NEWLINE	{
																	$$ = $1;
																	$$->boolExp = $3;
																	$$->prog = actualProg;
																	actualProg = $$->prevProg;
																}
		;

IFTOKEN	: IF 					{
									$$ = malloc(sizeof(*$$));
									$$->prevProg = actualProg;
									actualProg = malloc(sizeof(y_prog));
									actualProg->first = NULL;
								}

WHILEBLOCK	: WHILETOKEN '(' BOOLEXPR ')' NEWLINE PROGRAM END NEWLINE	{
																	$$ = $1;
																	$$->boolExp = $3;
																	$$->prog = actualProg;
																	actualProg = $$->prevProg;
																}
		;

WHILETOKEN	: WHILE 				{
									$$ = malloc(sizeof(*$$));
									$$->prevProg = actualProg;
									actualProg = malloc(sizeof(y_prog));
									actualProg->first = NULL;
								}
			;

BOOLEXPR: EXPRESS LT EXPRESS 	{
									$$ = malloc(sizeof(*$$));
									$$->compFunc = malloc("ltStrStr" + 1);
									$$->exp1 = $1;
									$$->exp2 = $3;
								}
		| EXPRESS LE EXPRESS
		| EXPRESS GT EXPRESS
		| EXPRESS GE EXPRESS
		;

ASSIGN  : VAR EQ EXPRESS        {
									$$ = malloc(sizeof(*$$));
									y_variable* var = malloc(sizeof(y_variable));
									var->name = malloc(strlen($1) + 1);
									strcpy(var->name, $1);
									var->type = $3->type;
									$$->var = var;
									$$->exp = $3;
									$$->opName = calloc(1, 1);
									void* p = getElementHT(var_table, $1);
									if (p == NULL) {
										addElementHT(var_table,$1,var); //TODO: METERLO EN LA FUNCION PRINT
										$$->isNew = 1;
									} else {
										$$->isNew = 0;
									}
								}
		| VAR PLUSEQ EXPRESS    {
									$$ = malloc(sizeof(*$$));
									y_variable* var = malloc(sizeof(y_variable));
									var->name = malloc(strlen($1) + 1);
									strcpy(var->name, $1);
									var->type = $3->type;
									$$->var = var;
									$$->exp = $3;
									OperationT operation = getOperation(ADD, ((y_variable*)getElementHT(var_table, $1))->type, $3->type);
									$$->opName = malloc(strlen(operation->func_name)+1);
									strcpy($$->opName, operation->func_name);
									addElementHT(var_table,$1,var); //TODO: METERLO EN LA FUNCION PRINT
									$$->isNew = 0;
								}
		| VAR MINUSEQ EXPRESS   {
									$$ = malloc(sizeof(*$$));
									y_variable* var = malloc(sizeof(y_variable));
									var->name = malloc(strlen($1) + 1);
									strcpy(var->name, $1);
									var->type = $3->type;
									$$->var = var;
									$$->exp = $3;
									OperationT operation = getOperation(SUB, ((y_variable*)getElementHT(var_table, $1))->type, $3->type);
									$$->opName = malloc(strlen(operation->func_name)+1);
									strcpy($$->opName, operation->func_name);
									addElementHT(var_table,$1,var); //TODO: METERLO EN LA FUNCION PRINT
									$$->isNew = 0;
								}
		| VAR MULTEQ EXPRESS    {
									$$ = malloc(sizeof(*$$));
									y_variable* var = malloc(sizeof(y_variable));
									var->name = malloc(strlen($1) + 1);
									strcpy(var->name, $1);
									var->type = $3->type;
									$$->var = var;
									$$->exp = $3;
									OperationT operation = getOperation(MUL, ((y_variable*)getElementHT(var_table, $1))->type, $3->type);
									$$->opName = malloc(strlen(operation->func_name)+1);
									strcpy($$->opName, operation->func_name);
									addElementHT(var_table,$1,var); //TODO: METERLO EN LA FUNCION PRINT
									$$->isNew = 0;
								}
		| VAR DIVEQ EXPRESS     {
									$$ = malloc(sizeof(*$$));
									y_variable* var = malloc(sizeof(y_variable));
									var->name = malloc(strlen($1) + 1);
									strcpy(var->name, $1);
									var->type = $3->type;
									$$->var = var;
									$$->exp = $3;
									OperationT operation = getOperation(DVN, ((y_variable*)getElementHT(var_table, $1))->type, $3->type);
									$$->opName = malloc(strlen(operation->func_name)+1);
									strcpy($$->opName, operation->func_name);
									addElementHT(var_table,$1,var); //TODO: METERLO EN LA FUNCION PRINT
									$$->isNew = 0;
								}
		;

EXPRESS : VAR                   {
									$$ = malloc(sizeof(*$$));
									$$->contentType = EXPR_VAR;
									$$->type = ((y_variable*) getElementHT(var_table, $1))->type;
									y_variable* var = malloc(sizeof(y_variable));
									var->name = malloc(strlen($1) + 1);
									strcpy(var->name, $1);
									$$->content = var;

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
									$$->funcCreator = malloc("createInt()" + digitCount($1) + 1);
									sprintf($$->funcCreator, "createInt(%d)", $1);
								}
		| FLOAT                 {
									$$ = malloc(sizeof(*$$));
									$$->obj = createDecimal($1);
									$$->funcCreator = malloc("createDecimal()" + digitCount($1) + 20 + 1);	// 20 decimals max
									sprintf($$->funcCreator, "createDecimal(%ff)", $1);
								}
		| STRING 		{
									$$ = malloc(sizeof(*$$));
									$$->obj = createString($1);
									$$->funcCreator = malloc("createString()" + strlen($1) + 1);
									sprintf($$->funcCreator, "createString(\"%s\")", $1);
								}
    | ARRAY     {
                  $$ = $1;
                }
		;
/* TODO: To create a list use newList() and add a list with addList(l, obj) */
ARRAY: '[' LIST ']' {
                      /* $$ = $2; */
                    }
		| '[' EXPRESS ']' {
                        /*_object l = newList();
                        addList(l.cont.obj, $2);
                        $$ = l;*/
                      }
		;

LIST: EXPRESS ',' EXPRESS {
														/*_object l = newList();
                            addList(l.cont.obj, $3);
                            addList(l.cont.obj, $1);
                            $$ = l.cont.obj;*/
													}
		| LIST ',' EXPRESS {
                          /*addList($1, $3);
                          $$ = $1;*/
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
		prog = malloc(sizeof(y_prog));
		prog->first = NULL;

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

    // LIST INT OPERATIONS
    addOperation(&addIntStr,"operationOneByOne",LIST, INTEGER,ADD,getType(LIST));
    addOperation(&subIntStr,"operationOneByOne",LIST, INTEGER,SUB,getType(LIST));
    addOperation(&mulIntStr,"operationOneByOne",LIST, INTEGER,MUL,getType(LIST));
    addOperation(&dvnIntStr,"operationOneByOne",LIST, INTEGER,DVN,getType(LIST));

		for (int i = 0 ; i < CANT_TYPES ; i++){
			for (int j = 0 ; j < CANT_TYPES; j++){
        if ( i != j ){
          printf("i:%d, j:%d\n", i, j);
          addOperation(&differentType,"differentType", i, j, EQL ,getType(INTEGER));
          addOperation(&differentType,"differentType", i, j, LTS ,getType(INTEGER));
          addOperation(&differentType,"differentType", i, j, LES ,getType(INTEGER));
          addOperation(&differentType,"differentType", i, j, GTS ,getType(INTEGER));
          addOperation(&differentType,"differentType", i, j, GES ,getType(INTEGER));
        }
			}
		}

    // EQUALS
    addOperation(&compareInt,"compareInt",INTEGER, INTEGER,EQL,getType(INTEGER));
    addOperation(&compareDecimal,"compareDecimal",DECIMAL, DECIMAL,EQL,getType(INTEGER));
    addOperation(&compareString,"compareString",STR, STR, EQL,getType(INTEGER));
    addOperation(&compareList,"compareList",LIST, LIST,EQL,getType(INTEGER));
    // LESS THAN
    addOperation(&ltInt,"ltInt",INTEGER, INTEGER,LTS,getType(INTEGER));
    addOperation(&ltDecimal,"ltDecimal",DECIMAL, DECIMAL,LTS,getType(INTEGER));
    addOperation(&ltString,"ltString",STR, STR, LTS,getType(INTEGER));
    addOperation(&ltList,"ltList",LIST, LIST,LTS,getType(INTEGER));
    // GREATER THAN
    addOperation(&gtInt,"gtInt",INTEGER, INTEGER,GTS,getType(INTEGER));
    addOperation(&gtDecimal,"gtDecimal",DECIMAL, DECIMAL,GTS,getType(INTEGER));
    addOperation(&gtString,"gtString",STR, STR, GTS,getType(INTEGER));
    addOperation(&gtList,"gtList",LIST, LIST, GTS,getType(INTEGER));
    // LESS EQUALS
    addOperation(&leInt,"leInt",INTEGER, INTEGER, LES,getType(INTEGER));
    addOperation(&leDecimal,"leDecimal",DECIMAL, DECIMAL,LES,getType(INTEGER));
    addOperation(&leString,"leString",STR, STR, LES,getType(INTEGER));
    addOperation(&leList,"leList",LIST, LIST,LES,getType(INTEGER));
    // GREATER EQUALS
    addOperation(&geInt,"geInt",INTEGER, INTEGER,GES,getType(INTEGER));
    addOperation(&geDecimal,"geDecimal",DECIMAL, DECIMAL,GES,getType(INTEGER));
    addOperation(&geString,"geString",STR, STR, GES,getType(INTEGER));
    addOperation(&geList,"geList",LIST, LIST,GES,getType(INTEGER));

		startC();

		actualProg = prog;
		yyparse();

		printProg(actualProg);

		endC();

		return 0;
}


void printInst(y_inst* i) {
	switch(i->type) {
		case 0:
			if (((y_assign*) i->content)->isNew) {
				printf("_object ");
			}
			printAssign((y_assign*) i->content);
			printf(";\n");
			printf("\n");
			break;
		case 1:
			printExpr((y_expression*) i->content);
			printf(";\n");
			printf("\n");
			break;
		case 2:
			if (((y_assign*) i->content)->isNew) {
				printf("_object ");
			}
			printAssign((y_assign*) i->content);
			printf(";\n");
			printf("\n");
			break;
		case 3:
			printExpr((y_expression*) i->content);
			printf(";\n");
			printf("\n");
			break;
		case 4:
			if (((y_assign*) i->content)->isNew) {
				printf("_object ");
			}
			printAssign((y_assign*) i->content);
			printf(";\n");
			printf("printObject(");
			printExpr(((y_assign*) i->content)->exp);
			printf(");\n");
			printf("printf(\"\\n\");\n");
			break;
		case 5:
			printf("printObject(");
			printExpr((y_expression*) i->content);
			printf(");\n");
			printf("printf(\"\\n\");\n");
			break;
		case 6:
			printf("if(");
			printBoolExpr(((y_if*) i->content)->boolExp);
			printf("){\n");
			printProg(((y_if*) i->content)->prog);
			printf("}\n");
			break;
		case 7:
			printf("while(");
			printBoolExpr(((y_if*) i->content)->boolExp);
			printf("){\n");
			printProg(((y_if*) i->content)->prog);
			printf("}\n");
			break;
	}
}

void printAssign(y_assign* assign) {
	printVariable(assign->var);
	printf("=");
	if (strcmp(assign->opName,"") != 0) {
		printf("%s(%s,", assign->opName, assign->var->name);
		printExpr(assign->exp);
		printf(")");
	} else {
		printExpr(assign->exp);
	}
}

void printVariable(y_variable* var) {
	printf("%s", var->name);
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
			printVariable((y_variable*)expr->content);
			break;
		case EXPR_OPER:
			printOperation((y_operation*)expr->content);
			break;
	}
}


void printBoolExpr(y_boolExpr* expr) {
	printf("BOOLEXPR");
	// printf("%s(", expr->compFunc);
	// printExpr(expr->exp1);
	// printf(",");
	// printExpr(expr->exp1);
	// printf(")");
}

void printNum(y_number* num) {
	printf("%s", num->funcCreator);

}

void printProg(y_prog* prog) {
	y_node* n = prog->first;

	while (n != NULL) {
		printInst(n->inst);
		n = n->next;
	}
}

void addInstToProg(y_prog* prog, y_inst* i) {
	if (prog->first == NULL) {
		prog->first = malloc(sizeof(y_node));
		y_node* n = malloc(sizeof(y_node));
		n->next = NULL;
		n->inst = i;
		prog->first = n;
	} else {
		y_node* f = prog->first;
		y_node* n = malloc(sizeof(y_node));
		n->next = f;
		n->inst = i;
		prog->first = n;
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

void endC() {
	printf("}");
}

void startC() {
	printf("\n\
	#include <stdio.h>\n\
	#include <stdlib.h>\n\
	#include <math.h>\n\
	#include <string.h>\n\
	#include \"operations/include/operations.h\"\n\
	#include \"types/include/object.h\"\n\
	#include \"types/include/types.h\"\n\
	#include \"hashtable/include/hashtable.h\"\n\
	#include \"yaccObjects.h\"\n\
\n\
\n\
	hashTableT var_table;\n\
\n\
	static unsigned int str_hash(char* key);\n\
	static unsigned int str_eql(const char * s1, const char * s2);\n\
\n\
	static unsigned int str_hash(char* key){\n\
		unsigned int h = 5381;\n\
		while(*(key++))\n\
			h = ((h << 5) + h) + (*key);\n\
		return h;\n\
	}\n\
\n\
	static unsigned int str_eql(const char * s1, const char * s2){\n\
	  return strcmp(s1,s2) == 0;\n\
	}\n\
\n\
\n\
\n\
void printObject(_object o) {\n\
	switch(o->type->id) {\n\
		case INTEGER:\n\
			printf(\"%%d\", o->cont.num);\n\
			break;\n\
		case DECIMAL:\n\
			printf(\"%%f\", o->cont.fl);\n\
			break;\n\
		case STR:\n\
			printf(\"%%s\", o->cont.str);\n\
			break;\n\
	}\n\
}\n\
	int main() {\n\
		var_table = createHashTable(sizeof(char *), sizeof(_object), &str_hash, 20, &str_eql);\n\
		startTypes();\n\
		buildOpTable();\n\
\n\
		// INT INT OPERATIONS\n\
		addOperation(&addIntInt,\"addIntInt\",INTEGER, INTEGER,ADD,getType(INTEGER));\n\
		addOperation(&subIntInt,\"subIntInt\",INTEGER, INTEGER,SUB,getType(INTEGER));\n\
		addOperation(&mulIntInt,\"mulIntInt\",INTEGER, INTEGER,MUL,getType(INTEGER));\n\
		addOperation(&dvnIntInt,\"dvnIntInt\",INTEGER, INTEGER,DVN,getType(INTEGER));\n\
		addOperation(&powIntInt,\"powIntInt\",INTEGER, INTEGER,PWR,getType(INTEGER));\n\
\n\
		// DECIMAL DECIMAL OPERATIONS		\n\
		addOperation(&addDecDec,\"addDecDec\",DECIMAL, DECIMAL,ADD,getType(DECIMAL));\n\
		addOperation(&subDecDec,\"subDecDec\",DECIMAL, DECIMAL,SUB,getType(DECIMAL));\n\
		addOperation(&mulDecDec,\"mulDecDec\",DECIMAL, DECIMAL,MUL,getType(DECIMAL));\n\
		addOperation(&dvnDecDec,\"dvnDecDec\",DECIMAL, DECIMAL,DVN,getType(DECIMAL));\n\
\n\
		// INT DECIMAL OPERATIONS		\n\
		addOperation(&addIntDec,\"addIntDec\",INTEGER, DECIMAL,ADD,getType(DECIMAL));\n\
		addOperation(&subIntDec,\"subIntDec\",INTEGER, DECIMAL,SUB,getType(DECIMAL));\n\
		addOperation(&mulIntDec,\"mulIntDec\",INTEGER, DECIMAL,MUL,getType(DECIMAL));\n\
		addOperation(&dvnIntDec,\"dvnIntDec\",INTEGER, DECIMAL,DVN,getType(DECIMAL));\n\
\n\
		// DECIMAL INT OPERATIONS		\n\
		addOperation(&addDecInt,\"addDecInt\",DECIMAL, INTEGER,ADD,getType(DECIMAL));\n\
		addOperation(&subDecInt,\"subDecInt\",DECIMAL, INTEGER,SUB,getType(DECIMAL));\n\
		addOperation(&mulDecInt,\"mulDecInt\",DECIMAL, INTEGER,MUL,getType(DECIMAL));\n\
		addOperation(&dvnDecInt,\"dvnDecInt\",DECIMAL, INTEGER,DVN,getType(DECIMAL));\n\
\n\
		// STRING STRING OPERATIONS		\n\
		addOperation(&addStrStr,\"addStrStr\",STR, STR,ADD,getType(STR));\n\
		addOperation(&subStrStr,\"subStrStr\",STR, STR,SUB,getType(STR));\n\
		addOperation(&mulStrStr,\"mulStrStr\",STR, STR,MUL,getType(STR));\n\
		addOperation(&dvnStrStr,\"dvnStrStr\",STR, STR,DVN,getType(STR));\n\
\n\
		// STRING INT OPERATIONS		\n\
		addOperation(&addStrInt,\"addStrInt\",STR, INTEGER,ADD,getType(STR));\n\
		addOperation(&subStrInt,\"subStrInt\",STR, INTEGER,SUB,getType(STR));\n\
		addOperation(&mulStrInt,\"mulStrInt\",STR, INTEGER,MUL,getType(STR));\n\
		addOperation(&dvnStrInt,\"dvnStrInt\",STR, INTEGER,DVN,getType(STR));\n\
\n\
		// INT STRING OPERATIONS		\n\
		addOperation(&addIntStr,\"addIntStr\",INTEGER, STR,ADD,getType(STR));\n\
		addOperation(&subIntStr,\"subIntStr\",INTEGER, STR,SUB,getType(STR));\n\
		addOperation(&mulIntStr,\"mulIntStr\",INTEGER, STR,MUL,getType(STR));\n\
		addOperation(&dvnIntStr,\"dvnIntStr\",INTEGER, STR,DVN,getType(STR));\n");
}
