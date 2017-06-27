%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <math.h>
    #include <string.h>
    #include "types/include/operations.h"
    #include "types/include/object.h"
		#include "types/include/types.h"
		#include "hashtable/include/hashtable.h"

    #define MAXVAR 8192

    // extern _object sum(_object, _object);

    void yyerror(char* s);
    // int symbolVal(char* symbol);
    // void updateSymbolVal(char* symbol, int val);
    // _object symbolObj(char* symbol);
    // void updateSymbolObj(char* symbol, _object o);

		hashTableT var_table;

		static unsigned int str_hash(char* key);
		static unsigned int str_eql(const char * s1, const char * s2);

		typedef _object(*opFunc)(_object, _object);

    // char* varsName[MAXVAR];
    // int symbols[MAXVAR];
    // _object objects[MAXVAR];
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
        | VAR PLUSEQ EXPRESS    //{ $$ = add(symbolObj($1),$3); updateSymbolObj($1,$$); }
        | VAR MINUSEQ EXPRESS   //{ $$ = substract(symbolObj($1),$3); updateSymbolObj($1,$$); }
        | VAR MULTEQ EXPRESS    //{ $$ = multiply(symbolObj($1),$3); updateSymbolObj($1,$$); }
        | VAR DIVEQ EXPRESS     //{ $$ = divide(symbolObj($1),$3); updateSymbolObj($1,$$); }
        ;

EXPRESS : VAR                   { $$ = (_object) getElementHT(var_table, $1); }
        | VALUE                 { $$ = $1; }
        | OPERAT                { $$ = $1; }
        ;

OPERAT  : EXPRESS PLUS EXPRESS  {
																	OperationT operation = getOperation(ADD, $1->type, $3->type);
																	$$ = operation->func($1,$3);
																}
        | EXPRESS MINUS EXPRESS //{ $$ = substract($1,$3); }
        | EXPRESS MULT EXPRESS  //{ $$ = multiply($1,$3); }
        | EXPRESS DIV EXPRESS   //{ $$ = divide($1,$3); }
        | EXPRESS POW EXPRESS   //{ _object o; int a=1, i; for(i=0; i<$3.cont.num; i++) {a*=$1.cont.num;} o.type = INTEGER; o.cont.num = a; $$ = o; }
        ;

VALUE   : NUMBER                { $$ = $1; }
        ;

NUMBER  : INT                   { $$ = createInt($1); }
        | FLOAT                 //{ _object o; o.type = DECIMAL; o.cont.fl = $1; $$ = o;}
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
		//buildOptable();
		addOperation(&addInt,"addInt",INTEGER, INTEGER,ADD);
    return yyparse();
}

// _object addIntInt(_object ob1, _object ob2){
// 	_object o  = malloc(sizeof(Object));
// 	o->type = INTEGER;
// 	o->cont.num = ob1->cont.num + ob2->cont.num;
// 	return o;
// }

// int computeSymbolIndex(char* token)
// {
//     int i = 0;
//     for (; i < MAXVAR && varsName[i] != NULL; i++) {
//         if (strcmp(varsName[i], token) == 0) {
//             return i;
//         }
//     }
//     if (i == MAXVAR) {
//         yyerror("all variables slots have been used.");
//         return -1;
//     }
//
//     varsName[i] = malloc(strlen(token)+1);
//     strcpy(varsName[i],token);
//
//     return i;
// }
//
// int symbolVal(char* symbol)
// {
//     int bucket = computeSymbolIndex(symbol);
//     return symbols[bucket];
// }
//
// _object symbolObj(char* symbol)
// {
//     int bucket = computeSymbolIndex(symbol);
//     return objects[bucket];
// }

// void updateSymbolVal(char* symbol, int val)
// {
//     int bucket = computeSymbolIndex(symbol);
//     symbols[bucket] = val;
// }
//
// void updateSymbolObj(char* symbol, _object o)
// {
//
//     int bucket = computeSymbolIndex(symbol);
//     objects[bucket] = o;
// }

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
