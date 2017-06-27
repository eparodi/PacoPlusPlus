%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <math.h>
    #include <string.h>
    #include "types_2/object.h"

    #define MAXVAR 8192

    void yyerror(char* s);
    int symbolVal(char* symbol);
    void updateSymbolVal(char* symbol, int val);
    _object symbolObj(char* symbol);
    void updateSymbolObj(char* symbol, int val, _type type);

    char* varsName[MAXVAR];
    int symbols[MAXVAR];
    _object objects[MAXVAR];
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
        | ASSIGN NEWLINE        { printf("%d\n",  $1.cont.num); }
        | EXPRESS NEWLINE       { printf("%d\n",  $1.cont.num); }
        ;

ASSIGN  : VAR EQ EXPRESS        { $$ = $3; updateSymbolObj($1,$$.cont.num,INTEGER); }
        | VAR PLUSEQ EXPRESS    { _object o; o.type = INTEGER; o.cont.num = symbolObj($1).cont.num + $3.cont.num; $$ = o; updateSymbolObj($1,o.cont.num,INTEGER); }
        | VAR MINUSEQ EXPRESS   { _object o; o.type = INTEGER; o.cont.num = symbolObj($1).cont.num - $3.cont.num; $$ = o; updateSymbolObj($1,o.cont.num,INTEGER); }
        | VAR MULTEQ EXPRESS    { _object o; o.type = INTEGER; o.cont.num = symbolObj($1).cont.num * $3.cont.num; $$ = o; updateSymbolObj($1,o.cont.num,INTEGER); }
        | VAR DIVEQ EXPRESS     { _object o; o.type = INTEGER; o.cont.num = symbolObj($1).cont.num / $3.cont.num; $$ = o; updateSymbolObj($1,o.cont.num,INTEGER); }
        ;

EXPRESS : VAR                   { $$ = symbolObj($1); }
        | VALUE                 { $$ = $1; }
        | OPERAT                { $$ = $1; }
        ;

OPERAT  : EXPRESS PLUS EXPRESS  { _object o; o.type= INTEGER; o.cont.num = $1.cont.num + $3.cont.num; $$ = o; }
        | EXPRESS MINUS EXPRESS { _object o; o.type= INTEGER; o.cont.num = $1.cont.num - $3.cont.num; $$ = o; }
        | EXPRESS MULT EXPRESS  { _object o; o.type= INTEGER; o.cont.num = $1.cont.num * $3.cont.num; $$ = o; }
        | EXPRESS DIV EXPRESS   { _object o; o.type= INTEGER; o.cont.num = $1.cont.num / $3.cont.num; $$ = o; }
        | EXPRESS POW EXPRESS   { _object o; int a=1, i; for(i=0; i<$3.cont.num; i++) {a*=$1.cont.num;} o.type = INTEGER; o.cont.num = a; $$ = o; }
        ;

VALUE   : NUMBER                { $$ = $1; }
        ;

NUMBER  : INT                   { _object o; o.type = INTEGER; o.cont.num = $1; $$ = o; }
        ;

%%

int yywrap(void)
{
  return 0;
}

int
main(void)
{
    return yyparse();
}

int computeSymbolIndex(char* token)
{ 
    int i = 0;
    for (; i < MAXVAR && varsName[i] != NULL; i++) {
        if (strcmp(varsName[i], token) == 0) {
            return i;
        }
    }
    if (i == MAXVAR) {
        yyerror("all variables slots have been used.");
        return -1;
    }

    varsName[i] = malloc(strlen(token)+1);
    strcpy(varsName[i],token);

    return i;
}

int symbolVal(char* symbol)
{
    int bucket = computeSymbolIndex(symbol);
    return symbols[bucket];
}

_object symbolObj(char* symbol)
{
    int bucket = computeSymbolIndex(symbol);
    return objects[bucket];
}

void updateSymbolVal(char* symbol, int val)
{
    int bucket = computeSymbolIndex(symbol);
    symbols[bucket] = val;
}

void updateSymbolObj(char* symbol, int val, _type type)
{
    _object o;
    int bucket = computeSymbolIndex(symbol);

    o.type = type;
    if (type == INTEGER) {
        o.cont.num = val;
    }
    objects[bucket] = o;
}

void yyerror(char* s)
{
    fprintf(stderr, "Error: %s\n", s);
}