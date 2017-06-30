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

	int blockNum = 0;

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
	y_addList* addList;
}
%start PROGRAM

%token PLUS MINUS MULT DIV POW
%token PLUSEQ MINUSEQ MULTEQ DIVEQ EQ
%token NEWLINE
%token STDNUM STDSTR STDDEC
%token IF WHILE END LT LE GT GE EQLS END_OF_FILE

%token <num> INT
%token <str> STRING
%token <fl> FLOAT
%token <str> VAR

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
%type <addList> INSERTTOLIST

%left PLUS MINUS
%left MULT DIV
%left POW

%%

PROGRAM : INST PROGRAM	        {
                  addInstToProg(actualProg,$1);
									// printInst($1);
								}
		| INST                  {
									addInstToProg(actualProg,$1);
									// printInst($1);
								}
		;
    
INST    : ASSIGN ';' NEWLINE    {
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
		| IFBLOCK  NEWLINE			{
									$$ = malloc(sizeof(*$$));
									$$->type = 6;
									$$->content = $1;
								}
		| WHILEBLOCK  NEWLINE			{
									$$ = malloc(sizeof(*$$));
									$$->type = 7;
									$$->content = $1;
								}
		| INSERTTOLIST	NEWLINE	{
									$$ = malloc(sizeof(*$$));
									$$->type = 8;
									$$->content = $1;
								}
    | ASSIGN    {
    							$$ = malloc(sizeof(*$$));
    							$$->type = 4;
    							$$->content = $1;
    						}
    | EXPRESS   {
    							$$ = malloc(sizeof(*$$));
    							$$->type = 5;
    							$$->content = $1;
    						}
    | WHILEBLOCK  {
    						  $$ = malloc(sizeof(*$$));
            			$$->type = 7;
            			$$->content = $1;
                }
    | IFBLOCK 	{
  								$$ = malloc(sizeof(*$$));
  								$$->type = 6;
  								$$->content = $1;
  							}
    | ASSIGN ';' {
                	$$ = malloc(sizeof(*$$));
                	$$->type = 2;
                	$$->content = $1;
                }
    | EXPRESS ';' {
    							$$ = malloc(sizeof(*$$));
    							$$->type = 3;
    							$$->content = $1;
    						}
		;

INSERTTOLIST: EXPRESS ':' VAR 	{
									$$ = malloc(sizeof(*$$));
									$$->expr = $1;
									y_variable* p = (y_variable*) getElementHT(var_table, $3);
									if (p == NULL) {
										yyerror("Variable not defined");
										exit(0);
									} else {
										int declaratedBlock = p->blockNum;
										if (declaratedBlock > blockNum) {
											yyerror("Variable not defined");
											exit(0);
										} else {
											if (p->type->id != LIST) {
												yyerror("Variable is not a list");
												exit(0);
											}
											$$->var = p;
										}
									}
								}
			;

IFBLOCK	: IFTOKEN '(' BOOLEXPR ')' NEWLINE PROGRAM END	{
																	$$ = $1;
																	$$->boolExp = $3;
																	$$->prog = actualProg;
																	actualProg = $$->prevProg;
																	blockNum--;
																}
		;

IFTOKEN	: IF 					{
									$$ = malloc(sizeof(*$$));
									$$->prevProg = actualProg;
									actualProg = malloc(sizeof(y_prog));
									actualProg->first = NULL;
									blockNum++;
								}

WHILEBLOCK	: WHILETOKEN '(' BOOLEXPR ')' NEWLINE PROGRAM END	{
																	$$ = $1;
																	$$->boolExp = $3;
																	$$->prog = actualProg;
																	actualProg = $$->prevProg;
																	blockNum--;
																}
		;

WHILETOKEN	: WHILE 				{
									$$ = malloc(sizeof(*$$));
									$$->prevProg = actualProg;
									actualProg = malloc(sizeof(y_prog));
									actualProg->first = NULL;
									blockNum++;
								}
			;

BOOLEXPR: EXPRESS LT EXPRESS 	{
									$$ = malloc(sizeof(*$$));
									OperationT operation = getOperation(LTS, $1->type, $3->type);
									$$->compFunc = malloc(strlen(operation->func_name) + 1);
									strcpy($$->compFunc, operation->func_name);
									$$->exp1 = $1;
									$$->exp2 = $3;
								}
		| EXPRESS LE EXPRESS  {
    									$$ = malloc(sizeof(*$$));
    									OperationT operation = getOperation(LES, $1->type, $3->type);
    									$$->compFunc = malloc(strlen(operation->func_name) + 1);
    									strcpy($$->compFunc, operation->func_name);
    									$$->exp1 = $1;
    									$$->exp2 = $3;
    								}
		| EXPRESS GT EXPRESS  {
    									$$ = malloc(sizeof(*$$));
    									OperationT operation = getOperation(GTS, $1->type, $3->type);
    									$$->compFunc = malloc(strlen(operation->func_name) + 1);
    									strcpy($$->compFunc, operation->func_name);
    									$$->exp1 = $1;
    									$$->exp2 = $3;
    								}
		| EXPRESS GE EXPRESS {
    									$$ = malloc(sizeof(*$$));
    									OperationT operation = getOperation(GES, $1->type, $3->type);
    									$$->compFunc = malloc(strlen(operation->func_name) + 1);
    									strcpy($$->compFunc, operation->func_name);
    									$$->exp1 = $1;
    									$$->exp2 = $3;
    								}
		| EXPRESS EQLS EXPRESS {
											$$ = malloc(sizeof(*$$));
											OperationT operation = getOperation(EQL, $1->type, $3->type);
											$$->compFunc = malloc(strlen(operation->func_name) + 1);
											strcpy($$->compFunc, operation->func_name);
											$$->exp1 = $1;
											$$->exp2 = $3;
										}
		;

ASSIGN  : VAR EQ EXPRESS        {
									$$ = malloc(sizeof(*$$));
									y_variable* p = (y_variable*) getElementHT(var_table, $1);
									if( p == NULL) {
										y_variable* var = malloc(sizeof(y_variable));
										var->name = malloc(strlen($1) + 1);
										strcpy(var->name, $1);
										var->type = $3->type;
										var->blockNum = blockNum;
										$$->var = var;
										$$->isNew = 1;
										addElementHT(var_table,$1,var);
									} else {
										int declaratedBlock = p->blockNum;
										if (declaratedBlock > blockNum) {
											$$->isNew = 1;
										} else {
											$$->isNew = 0;
										}
										$$->var = p;
										p->type = $3->type;
									}
									$$->exp = $3;
									$$->opName = calloc(1, 1);
								}
		| VAR PLUSEQ EXPRESS    {
									$$ = malloc(sizeof(*$$));
									y_variable* p = (y_variable*) getElementHT(var_table, $1);
									if (p == NULL) {
										yyerror("Variable not defined");
										exit(0);
									} else {
										int declaratedBlock = p->blockNum;
										if (declaratedBlock > blockNum) {
											yyerror("Variable not defined");
											exit(0);
										} else {
											$$->var = p;
											$$->exp = $3;
											OperationT operation = getOperation(ADD, ((y_variable*)getElementHT(var_table, $1))->type, $3->type);
											$$->opName = malloc(strlen(operation->func_name)+1);
											strcpy($$->opName, operation->func_name);
										}
									}
									$$->isNew = 0;

								}
		| VAR MINUSEQ EXPRESS    {
									$$ = malloc(sizeof(*$$));
									y_variable* p = (y_variable*) getElementHT(var_table, $1);
									if (p == NULL) {
										yyerror("Variable not defined");
										exit(0);
									} else {
										int declaratedBlock = p->blockNum;
										if (declaratedBlock > blockNum) {
											yyerror("Variable not defined");
											exit(0);
										} else {
											$$->var = p;
											$$->exp = $3;
											OperationT operation = getOperation(SUB, ((y_variable*)getElementHT(var_table, $1))->type, $3->type);
											$$->opName = malloc(strlen(operation->func_name)+1);
											strcpy($$->opName, operation->func_name);
										}
									}
									$$->isNew = 0;
								}
		| VAR MULTEQ EXPRESS    {
									$$ = malloc(sizeof(*$$));
									y_variable* p = (y_variable*) getElementHT(var_table, $1);
									if (p == NULL) {
										yyerror("Variable not defined");
										exit(0);
									} else {
										int declaratedBlock = p->blockNum;
										if (declaratedBlock > blockNum) {
											yyerror("Variable not defined");
											exit(0);
										} else {
											$$->var = p;
											$$->exp = $3;
											OperationT operation = getOperation(MUL, ((y_variable*)getElementHT(var_table, $1))->type, $3->type);
											$$->opName = malloc(strlen(operation->func_name)+1);
											strcpy($$->opName, operation->func_name);
										}
									}
									$$->isNew = 0;
								}
		| VAR DIVEQ EXPRESS    {
									$$ = malloc(sizeof(*$$));
									y_variable* p = (y_variable*) getElementHT(var_table, $1);
									if (p == NULL) {
										yyerror("Variable not defined");
										exit(0);
									} else {
										int declaratedBlock = p->blockNum;
										if (declaratedBlock > blockNum) {
											yyerror("Variable not defined");
											exit(0);
										} else {
											$$->var = p;
											$$->exp = $3;
											OperationT operation = getOperation(DVN, ((y_variable*)getElementHT(var_table, $1))->type, $3->type);
											$$->opName = malloc(strlen(operation->func_name)+1);
											strcpy($$->opName, operation->func_name);
										}
									}
									$$->isNew = 0;
								}

    | VAR STDNUM  {
					$$ = malloc(sizeof(*$$));
					y_variable* p = (y_variable*) getElementHT(var_table, $1);
					if( p == NULL) {
						  y_variable* var = malloc(sizeof(y_variable));
                		var->name = malloc(strlen($1) + 1);
                		strcpy(var->name, $1);
                		var->type = getType(INTEGER);
                		var->blockNum = blockNum;
                		$$->var = var;
                		$$->isNew = 1;
                		addElementHT(var_table,$1,var);
                	} else {
                		int declaratedBlock = p->blockNum;
                	  if (declaratedBlock > blockNum) {
                		$$->isNew = 1;
                		} else {
                			$$->isNew = 0;
                		}
                		$$->var = p;
                		p->type = getType(INTEGER);
                	}
                	$$->exp = NULL;
                	$$->opName = "parseNum";
                }
      | VAR STDDEC{
        $$ = malloc(sizeof(*$$));
        y_variable* p = (y_variable*) getElementHT(var_table, $1);
        if( p == NULL) {
          y_variable* var = malloc(sizeof(y_variable));
          var->name = malloc(strlen($1) + 1);
          strcpy(var->name, $1);
          var->type = getType(DECIMAL);
          var->blockNum = blockNum;
          $$->var = var;
          $$->isNew = 1;
          addElementHT(var_table,$1,var);
        } else {
          int declaratedBlock = p->blockNum;
          if (declaratedBlock > blockNum) {
          $$->isNew = 1;
          } else {
            $$->isNew = 0;
          }
          $$->var = p;
          p->type = getType(DECIMAL);
        }
        $$->exp = NULL;
        $$->opName = "parseDec";
      }
      | VAR STDSTR{
        $$ = malloc(sizeof(*$$));
        y_variable* p = (y_variable*) getElementHT(var_table, $1);
        if( p == NULL) {
          y_variable* var = malloc(sizeof(y_variable));
          var->name = malloc(strlen($1) + 1);
          strcpy(var->name, $1);
          var->type = getType(STR);
          var->blockNum = blockNum;
          $$->var = var;
          $$->isNew = 1;
          addElementHT(var_table,$1,var);
        } else {
          int declaratedBlock = p->blockNum;
          if (declaratedBlock > blockNum) {
          $$->isNew = 1;
          } else {
            $$->isNew = 0;
          }
          $$->var = p;
          p->type = getType(STR);
        }
        $$->exp = NULL;
        $$->opName = "parseString";
      }
		;

EXPRESS : VAR                   {
									$$ = malloc(sizeof(*$$));
									y_variable* p = (y_variable*) getElementHT(var_table, $1);
									if (p == NULL) {
										yyerror("Variable not defined.");
										exit(0);
									} else {
										int declaratedBlock = p->blockNum;
										if (declaratedBlock > blockNum) {
											yyerror("Variable not defined");
											exit(0);
										} else {
											$$->contentType = EXPR_VAR;
											$$->content = p;
											$$->type = p->type;
										}
									}
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
                  $$->retType = operation->return_type;
								}
		| EXPRESS MINUS EXPRESS {
									OperationT operation = getOperation(SUB, $1->type, $3->type);
									$$ = malloc(sizeof(*$$));
									$$->opName = malloc(strlen(operation->func_name)+1);
									strcpy($$->opName, operation->func_name);
									$$->exp1 = $1;
									$$->exp2 = $3;
                  $$->retType = operation->return_type;
								}
		| EXPRESS MULT EXPRESS  {
									OperationT operation = getOperation(MUL, $1->type, $3->type);
									$$ = malloc(sizeof(*$$));
									$$->opName = malloc(strlen(operation->func_name)+1);
									strcpy($$->opName, operation->func_name);
									$$->exp1 = $1;
									$$->exp2 = $3;
                  $$->retType = operation->return_type;
								}
		| EXPRESS DIV EXPRESS   {
									OperationT operation = getOperation(DVN, $1->type, $3->type);
									$$ = malloc(sizeof(*$$));
									$$->opName = malloc(strlen(operation->func_name)+1);
									strcpy($$->opName, operation->func_name);
									$$->exp1 = $1;
									$$->exp2 = $3;
								}
		| EXPRESS POW EXPRESS   {
									OperationT operation = getOperation(PWR, $1->type, $3->type);
									$$ = malloc(sizeof(*$$));
									$$->opName = malloc(strlen(operation->func_name)+1);
									strcpy($$->opName, operation->func_name);
									$$->exp1 = $1;
									$$->exp2 = $3;
                  $$->retType = operation->return_type;

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
		| STRING 				{
									$$ = malloc(sizeof(*$$));
									$$->obj = createString($1);
									$$->funcCreator = malloc("createString()" + strlen($1) + 1);
									sprintf($$->funcCreator, "createString(\"%s\")", $1);
								}
    	| ARRAY   		 		{
									$$ = malloc(sizeof(*$$));
									$$->obj = newList();
									$$->funcCreator = malloc("newList()" + 1);
									sprintf($$->funcCreator, "newList()");
								}
		;
/* TODO: To create a list use newList() and add a list with addList(l, obj) */
ARRAY: '[' ']'
	 ;
%%

int yywrap(void)
{
  return 1;
}

int
main(void)
{
		var_table = createHashTable(sizeof(char *), sizeof(_object), &str_hash, 20, &str_eql);
		startTypes();
		buildOpTable();
		prog = malloc(sizeof(y_prog));
		prog->first = NULL;


		// SUM OPERATIONS
		addOperation(&addIntInt,"addIntInt",INTEGER, INTEGER,ADD,getType(INTEGER));
		addOperation(&addIntStr,"addIntStr",INTEGER, STR,ADD,getType(STR));
		addOperation(&addIntDec,"addIntDec",INTEGER, DECIMAL,ADD,getType(DECIMAL));
		//addOperation(&addIntArr,"addIntArr",INTEGER, ARRAY?,ADD,getType(?));

		addOperation(&addStrInt,"addStrInt",STR, INTEGER,ADD,getType(STR));
		addOperation(&addStrStr,"addStrStr",STR, STR,ADD,getType(STR));
        addOperation(&addStrDec,"addStrDec",STR, DECIMAL,ADD,getType(STR));
        //addOperation(&addStrArr,"addStrArr",STR, ARRAY,ADD,?);

		addOperation(&addDecInt,"addDecInt",DECIMAL, INTEGER,ADD,getType(DECIMAL));
		addOperation(&addDecStr,"addDecStr",DECIMAL, STR,ADD,getType(STR));
		addOperation(&addDecDec,"addDecDec",DECIMAL, DECIMAL,ADD,getType(DECIMAL));
        //addOperation(&addDecArr,"addDecArr",DECIMAL, ARRAY?,ADD,getType(?));

        //addOperation(&addArrInt,"addArrInt",ARRAY, INTEGER,ADD,getType(?));
        //addOperation(&addArrStr,"addArrStr",ARRAY, STR,ADD,getType(?));
        //addOperation(&addArrDec,"addArrDec",ARRAY, DECIMAL,ADD,getType(?));
        //addOperation(&addArrArr,"addArrArr",ARRAY, ARRAY,ADD,getType(?));
		addOperation(&subStrStr,"subStrStr",STR, STR,SUB,getType(STR));


        // SUB OPERATIONS
		addOperation(&subIntInt,"subIntInt",INTEGER, INTEGER,SUB,getType(INTEGER));
		addOperation(&subIntStr,"subIntStr",INTEGER, STR,SUB,getType(STR));
		addOperation(&subIntDec,"subIntDec",INTEGER, DECIMAL,SUB,getType(DECIMAL));
		//addOperation(&subIntArr,"subIntArr",INTEGER, ARRAY,SUB,getType(?));

		addOperation(&subDecInt,"subDecInt",DECIMAL, INTEGER,SUB,getType(DECIMAL));
		addOperation(&subDecStr,"subDecStr",DECIMAL, STR,SUB,getType(STR));
		addOperation(&subDecDec,"subDecDec",DECIMAL, DECIMAL,SUB,getType(DECIMAL));
		//addOperation(&subDecArr,"subDecArr",DECIMAL, ARRAY,SUB,getType(?));

		addOperation(&subStrInt,"subStrInt",STR, INTEGER,SUB,getType(STR));
		addOperation(&subStrStr,"subStrStr",STR, STR,SUB,getType(STR));
		addOperation(&subStrDec,"subStrDec",STR, DECIMAL,SUB,getType(STR));
		//addOperation(&subStrArr,"subStrArr",STR, ARRAY,SUB,getType(?));

		//addOperation(&subArrInt,"subArrInt",ARRAY, INTEGER,SUB,getType(?));
        //addOperation(&subArrStr,"subArrStr",ARRAY, STR,SUB,getType(?));
        //addOperation(&subArrDec,"subArrDec",ARRAY, DECIMAL,SUB,getType(?));
        //addOperation(&subArrArr,"subArrArr",ARRAY, ARRAY,SUB,getType(?));


        // MUL OPERATIONS
		addOperation(&mulIntInt,"mulIntInt",INTEGER, INTEGER,MUL,getType(INTEGER));
		addOperation(&mulIntStr,"mulIntStr",INTEGER, STR,MUL,getType(STR));
		addOperation(&mulIntDec,"mulIntDec",INTEGER, DECIMAL,MUL,getType(DECIMAL));
		//addOperation(&mulIntArr,"mulIntArr",INTEGER, ARRAY,MUL,getType(?));

		addOperation(&mulStrInt,"mulStrInt",STR, INTEGER,MUL,getType(STR));
		addOperation(&mulStrStr,"mulStrStr",STR, STR,MUL,getType(STR));
		addOperation(&mulStrDec,"mulStrDec",STR, DECIMAL,MUL,getType(STR));
		//addOperation(&mulStrArr,"mulStrArr",STR, ARRAY,MUL,getType(?));

		addOperation(&mulDecInt,"mulDecInt",DECIMAL, INTEGER,MUL,getType(DECIMAL));
		addOperation(&mulDecStr,"mulDecStr",DECIMAL, STR,MUL,getType(STR));
		addOperation(&mulDecDec,"mulDecDec",DECIMAL, DECIMAL,MUL,getType(DECIMAL));
		//addOperation(&mulDecArr,"mulDecArr",DECIMAL, ARRAY,MUL,getType(?));

		//addOperation(&mulArrInt,"mulArrInt",ARRAY, INTEGER,MUL,getType(?));
        //addOperation(&mulArrStr,"mulArrStr",ARRAY, STR,MUL,getType(?));
        //addOperation(&mulArrDec,"mulArrDec",ARRAY, DECIMAL,MUL,getType(?));
        //addOperation(&mulArrArr,"mulArrArr",ARRAY, ARRAY,MUL,getType(?));

		// DVN OPERATIONS
		addOperation(&dvnIntInt,"dvnIntInt",INTEGER, INTEGER,DVN,getType(INTEGER));
		addOperation(&dvnIntStr,"dvnIntStr",INTEGER, STR,DVN,getType(STR));
		addOperation(&dvnIntDec,"dvnIntDec",INTEGER, DECIMAL,DVN,getType(DECIMAL));

		addOperation(&dvnStrInt,"dvnStrInt",STR, INTEGER,DVN,getType(STR));
		addOperation(&dvnStrStr,"dvnStrStr",STR, STR,DVN,getType(STR));
		addOperation(&dvnStrDec,"dvnStrDec",STR, DECIMAL,DVN,getType(STR));
		//addOperation(&dvnStrArr,"dvnStrArr",STR, ARRAY,DVN,getType(?));

		addOperation(&dvnDecInt,"dvnDecInt",DECIMAL, INTEGER,DVN,getType(DECIMAL));
		addOperation(&dvnDecStr,"dvnDecStr",DECIMAL, STR,DVN,getType(STR));
		addOperation(&dvnDecDec,"dvnDecDec",DECIMAL, DECIMAL,DVN,getType(DECIMAL));
		//addOperation(&dvnDecArr,"dvnDecArr",DECIMAL, ARRAY,DVN,getType(?));

		//addOperation(&dvnArrInt,"dvnArrInt",ARRAY, INTEGER,DVN,getType(?));
        //addOperation(&dvnArrStr,"dvnArrStr",ARRAY, STR,DVN,getType(?));
        //addOperation(&dvnArrDec,"dvnArrDec",ARRAY, DECIMAL,DVN,getType(?));
        //addOperation(&dvnArrArr,"dvnArrArr",ARRAY, ARRAY,DVN,getType(?));

		addOperation(&powIntInt,"powIntInt",INTEGER, INTEGER,PWR,getType(INTEGER));


    // LIST INT OPERATIONS
    for (int i = 0; i < CANT_TYPES ; i++){
      addOperation(&addListAny,"addListAny",LIST, i,ADD,getType(LIST));
      addOperation(&subListAny,"subListAny",LIST, i,SUB,getType(LIST));
      addOperation(&multListAny,"multListAny",LIST, i,MUL,getType(LIST));
      addOperation(&divListAny,"divListAny",LIST, i,DVN,getType(LIST));
      addOperation(&addAnyList,"addAnyList",i, LIST,ADD,getType(LIST));
      addOperation(&subAnyList,"subAnyList", i, LIST,SUB,getType(LIST));
      addOperation(&multAnyList,"multAnyList", i, LIST,MUL,getType(LIST));
      addOperation(&divAnyList,"divAnyList", i, LIST,DVN,getType(LIST));
    }

		for (int i = 0 ; i < CANT_TYPES ; i++){
			for (int j = 0 ; j < CANT_TYPES; j++){
        if ( i != j ){
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

		printProg(prog);

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
			if (((y_assign*) i->content)->exp!=NULL){
				printf("printObject(");
				printVariable(((y_assign*) i->content)->var);
				printf(");\n");
				printf("printf(\"\\n\");\n");
			}
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
		case 8:
			printf("addList(");
			printVariable(((y_addList*) i->content)->var);
			printf("->cont.obj,");
			printExpr(((y_addList*) i->content)->expr);
			printf(");\n");
			break;
	}
}

void printAssign(y_assign* assign) {
	printVariable(assign->var);
  printf("=");
  if(assign->exp == NULL){
    printf("%s()",assign->opName);
    return;
  }
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
	printf("%s(", expr->compFunc);
	printExpr(expr->exp1);
	printf(",");
	printExpr(expr->exp2);
	printf(")->cont.num");
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

void yyerror(char *s) {
    fprintf(stderr, "line %d: %s\n", 42, s);
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
	int main() {\n\
		var_table = createHashTable(sizeof(char *), sizeof(_object), &str_hash, 20, &str_eql);\n\
		startTypes();\n\
		buildOpTable();\n");
}
