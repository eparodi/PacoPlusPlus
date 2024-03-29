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
  #include "y.tab.h"

	int lineno = 1;

	void yyerror(char* s);

	hashTableT var_table;

	static unsigned int str_hash(char* key);
	static unsigned int str_eql(const char * s1, const char * s2);

    void printNum(y_number* num);
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

	void addToGlobVar(y_variable* v);
	void printGlobVar();

	typedef _object(*opFunc)(_object, _object);

	int blockNum = 1;

	y_prog* prog;
	y_prog* actualProg;
	y_globVars* globVars = NULL;

  FILE * f;
  FILE * yyin;
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
%token ENTER
%token STDNUM STDSTR STDDEC
%token IF WHILE END LT LE GT GE EQLS DIFF

%token <num> INT
%token <str> STRING
%token <fl> FLOAT
%token <str> VAR

%type <number> NUMBER
%type <expression> EXPRESS GETTYPE
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
%left LT LE GT GE EQLS DIFF

%%

PROGRAM : INST NEWLINE PROGRAM	{
									if ($1 != NULL)
										addInstToProg(actualProg,$1);
									// printInst($1);
								}
		| INST                  {
									if ($1 != NULL)
										addInstToProg(actualProg,$1);
									// printInst($1);
								}
		| INST NEWLINE 			{
									if ($1 != NULL)
										addInstToProg(actualProg,$1);
									// printInst($1);
								}
		| NEWLINE PROGRAM		{
								}
		;

NEWLINE : ENTER					{ lineno++; }

INST    : ASSIGN ';' 	  	    {
									$$ = malloc(sizeof(*$$));
									$$->type = 2;
									$$->content = $1;
									if($1->isNew) {
										addToGlobVar($1->var);
									}
								}
		| EXPRESS ';'   		{
									$$ = malloc(sizeof(*$$));
									$$->type = 3;
									$$->content = $1;
								}
		| ASSIGN        		{
									$$ = malloc(sizeof(*$$));
									$$->type = 4;
									$$->content = $1;
									if($1->isNew) {
										addToGlobVar($1->var);
									}
								}
		| EXPRESS        		{
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
		| INSERTTOLIST			{
									$$ = malloc(sizeof(*$$));
									$$->type = 8;
									$$->content = $1;
								}
		| GETTYPE			{
									$$ = malloc(sizeof(*$$));
									$$->type = 9;
									$$->content = $1;
								}
		| NEWLINE				{ $$ = NULL; }	

INSERTTOLIST: EXPRESS ':' VAR 	{
									$$ = malloc(sizeof(*$$));
									$$->expr = $1;
									y_variable* p = (y_variable*) getElementHT(var_table, $3);
									if (p == NULL) {
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
			;

GETTYPE: EXPRESS '?'		 	{
									$$ = $1;
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
    | EXPRESS DIFF EXPRESS {
                      $$ = malloc(sizeof(*$$));
                      OperationT operation = getOperation(DIFS, $1->type, $3->type);
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
											$$->var = p;
											$$->exp = $3;
											OperationT operation = getOperation(ADD, ((y_variable*)getElementHT(var_table, $1))->type, $3->type);
											$$->opName = malloc(strlen(operation->func_name)+1);
											strcpy($$->opName, operation->func_name);
										
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
										
											$$->var = p;
											$$->exp = $3;
											OperationT operation = getOperation(SUB, ((y_variable*)getElementHT(var_table, $1))->type, $3->type);
											$$->opName = malloc(strlen(operation->func_name)+1);
											strcpy($$->opName, operation->func_name);
										
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
										
											$$->var = p;
											$$->exp = $3;
											OperationT operation = getOperation(MUL, ((y_variable*)getElementHT(var_table, $1))->type, $3->type);
											$$->opName = malloc(strlen(operation->func_name)+1);
											strcpy($$->opName, operation->func_name);
										
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
										
											$$->var = p;
											$$->exp = $3;
											OperationT operation = getOperation(DVN, ((y_variable*)getElementHT(var_table, $1))->type, $3->type);
											$$->opName = malloc(strlen(operation->func_name)+1);
											strcpy($$->opName, operation->func_name);
										
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
										
											$$->contentType = EXPR_VAR;
											$$->content = p;
											$$->type = p->type;
										
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
                  $$->retType = operation->return_type;
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
		;


NUMBER  : INT                   {
									$$ = malloc(sizeof(*$$));
									$$->obj = createInt($1);
									$$->funcCreator = malloc((size_t)"createInt()" + digitCount($1) + 1);
									sprintf($$->funcCreator, "createInt(%d)", $1);
								}
		| FLOAT                 {
									$$ = malloc(sizeof(*$$));
									$$->obj = createDecimal($1);
									$$->funcCreator = malloc((size_t)"createDecimal()" + digitCount($1) + 20 + 1);	// 20 decimals max
									sprintf($$->funcCreator, "createDecimal(%ff)", $1);
								}
		| STRING 				{
									$$ = malloc(sizeof(*$$));
									$$->obj = createString($1);
									$$->funcCreator = malloc((size_t)"createString()" + strlen($1) + 1);
									sprintf($$->funcCreator, "createString(\"%s\")", $1);
								}
    	| ARRAY   		 		{
									$$ = malloc(sizeof(*$$));
									$$->obj = newList();
									$$->funcCreator = malloc((size_t)"newList()" + 1);
									sprintf($$->funcCreator, "newList()");
								}
    | MINUS INT {
                  $$ = malloc(sizeof(*$$));
                  $$->obj = createInt($2*-1);
                  $$->funcCreator = malloc((size_t)"createInt()" + digitCount($2*1) + 1);
                  sprintf($$->funcCreator, "createInt(%d)", $2*-1);
                }
    | MINUS FLOAT{
                  $$ = malloc(sizeof(*$$));
                  $$->obj = createDecimal($2*-1);
                  $$->funcCreator = malloc((size_t)"createDecimal()" + digitCount($2*-1) + 20 + 1);	// 20 decimals max
                  sprintf($$->funcCreator, "createDecimal(%ff)", $2*-1);
                }
		;

ARRAY: '[' ']'
	 ;
%%

int yywrap(void)
{
  return 1;
}

int
main(int argc, char * argv[])
{
    if(argc != 2){
      printf("Please, tell me the name of the file to compile. I'm not that smart!\n");
      return 0;
    }
    yyin = fopen(argv[1],"r");
    if (yyin == NULL){
      printf("That file does not exist!\n");
      return 0;
    }
    int length = strlen(argv[1]);
    char * newFileName = malloc((length+3)*sizeof(char));
    strcpy(newFileName,argv[1]);
    newFileName[length] = '.';
    newFileName[length+1] = 'c';
    newFileName[length+2] = '\0';
    
	var_table = createHashTable(sizeof(char *), sizeof(_object), (hashFunction)&str_hash, 20, (equalsFunction)&str_eql);
	startTypes();
	buildOpTable();
	loadOperations();

	prog = malloc(sizeof(y_prog));
	prog->first = NULL;

	actualProg = prog;
	yyparse();
    fclose(yyin);

    f = fopen(newFileName,"w+");
    if (f == NULL){
      printf("Buuh! I cannot write in %s. Stop using that file!\n", newFileName);
      return 0;
    }

    startC();
	printGlobVar();
	printProg(prog);
	endC();

    fclose(f);

		return 0;
}


void addToGlobVar(y_variable* v) {
	y_globVars* gv = calloc(1,sizeof(*gv));
	gv->var = v;
	if (globVars == NULL) {
		globVars = gv;
	} else {
		y_globVars* aux = globVars;
		while(aux->next != NULL) {
			aux = aux->next;
		}
		aux->next = gv;
	}
}

void printGlobVar() {
	y_globVars* aux = globVars;
	while(aux != NULL) {
		fprintf(f,"_object ");
		printVariable(aux->var);
		fprintf(f,";\n");
		aux = aux->next;
	}
}

void printInst(y_inst* i) {
	switch(i->type) {
		case 0:
			printAssign((y_assign*) i->content);
			fprintf(f,";\n");
			fprintf(f,"\n");
			break;
		case 1:
			printExpr((y_expression*) i->content);
			fprintf(f,";\n");
			fprintf(f,"\n");
			break;
		case 2:
			printAssign((y_assign*) i->content);
			fprintf(f,";\n");
			fprintf(f,"\n");
			break;
		case 3:
			printExpr((y_expression*) i->content);
			fprintf(f,";\n");
			fprintf(f,"\n");
			break;
		case 4:
			printAssign((y_assign*) i->content);
			fprintf(f,";\n");
			if (((y_assign*) i->content)->exp!=NULL){
				fprintf(f,"printObject(");
				printVariable(((y_assign*) i->content)->var);
				fprintf(f,");\n");
				fprintf(f,"printf(\"\\n\");\n");
			}
			break;
		case 5:
			fprintf(f,"printObject(");
			printExpr((y_expression*) i->content);
			fprintf(f,");\n");
			fprintf(f,"printf(\"\\n\");\n");
			break;
		case 6:
			fprintf(f,"if(");
			printBoolExpr(((y_if*) i->content)->boolExp);
			fprintf(f,"){\n");
			printProg(((y_if*) i->content)->prog);
			fprintf(f,"}\n");
			break;
		case 7:
			fprintf(f,"while(");
			printBoolExpr(((y_if*) i->content)->boolExp);
			fprintf(f,"){\n");
			printProg(((y_if*) i->content)->prog);
			fprintf(f,"}\n");
			break;
		case 8:
			fprintf(f,"addList(");
			printVariable(((y_addList*) i->content)->var);
			fprintf(f,"->cont.obj,");
			printExpr(((y_addList*) i->content)->expr);
			fprintf(f,");\n");
			break;
		case 9:
			fprintf(f,"printf(\"%s\");\nprintf(\"\\n\");", ((y_expression*) i->content)->type->name);
			break;
	}
}

void printAssign(y_assign* assign) {
	printVariable(assign->var);
  fprintf(f,"=");
  if(assign->exp == NULL){
    fprintf(f,"%s()",assign->opName);
    return;
  }
	if (strcmp(assign->opName,"") != 0) {
		fprintf(f,"%s(%s,", assign->opName, assign->var->name);
		printExpr(assign->exp);
		fprintf(f,")");
	} else {
		printExpr(assign->exp);
	}
}

void printVariable(y_variable* var) {
	fprintf(f,"%s", var->name);
}

void printOperation(y_operation* oper) {
	fprintf(f,"%s(", oper->opName);
	printExpr(oper->exp1);
	fprintf(f,",");
	printExpr(oper->exp2);
	fprintf(f,")");
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
	fprintf(f,"%s(", expr->compFunc);
	printExpr(expr->exp1);
	fprintf(f,",");
	printExpr(expr->exp2);
	fprintf(f,")->cont.num");
}

void printNum(y_number* num) {
	fprintf(f,"%s", num->funcCreator);

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
    fprintf(stderr, "Error in line %d: %s\n", lineno, s);
    exit(1);
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
	fprintf(f,"}");
}

void startC() {
	fprintf(f,"\n\
	#include <stdio.h>\n\
	#include <stdlib.h>\n\
	#include <math.h>\n\
	#include <string.h>\n\
	#include \"operations/include/operations.h\"\n\
	#include \"types/include/object.h\"\n\
	#include \"types/include/types.h\"\n\
	#include \"types/include/list.h\"\n\
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
		startTypes();\n\
		buildOpTable();\n\
		loadOperations();\n");
}
