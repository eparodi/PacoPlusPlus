%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <math.h>
    #include <string.h>

    #define MAXVAR 8192

    void yyerror(char* s);
    int symbolVal(char* symbol);
    void updateSymbolVal(char* symbol, int val);

    char* varsName[MAXVAR];
    int symbols[MAXVAR];
%}


%union {int num; char* str; float fl; char ch;}
%start PROGRAM

%token PLUS MINUS MULT DIV POW
%token PLUSEQ MINUSEQ MULTEQ DIVEQ EQ
%token NEWLINE

%token <num> INT
%token <str> STRING
%token <fl> FLOAT
%token <str> VAR

%type <num> PROGRAM INST ASSIGN EXPRESS NUMBER VALUE OPERAT


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
        | ASSIGN NEWLINE        { printf("%d\n",  $1); }
        | EXPRESS NEWLINE       { printf("%d\n",  $1); }
        ;

ASSIGN  : VAR EQ EXPRESS        { $$ = $3; updateSymbolVal($1,$$); }
        | VAR PLUSEQ EXPRESS    { $$ = symbolVal($1) + $3; updateSymbolVal($1,$$); }
        | VAR MINUSEQ EXPRESS   { $$ = symbolVal($1) - $3; updateSymbolVal($1,$$); }
        | VAR MULTEQ EXPRESS    { $$ = symbolVal($1) * $3; updateSymbolVal($1,$$); }
        | VAR DIVEQ EXPRESS     { $$ = symbolVal($1) / $3; updateSymbolVal($1,$$); }
        ;

EXPRESS : VAR                   { $$ = symbolVal($1); }
        | VALUE                 { $$ = $1; }
        | OPERAT                { $$ = $1; }
        ;

OPERAT  : EXPRESS PLUS EXPRESS  { $$ = $1 + $3; }
        | EXPRESS MINUS EXPRESS { $$ = $1 - $3; }
        | EXPRESS MULT EXPRESS  { $$ = $1 * $3; }
        | EXPRESS DIV EXPRESS   { $$ = $1 / $3; }
        | EXPRESS POW EXPRESS   { int a=1, i; for(i=0; i<$3; i++) {a*=$1;} $$=a; }

VALUE   : NUMBER                { $$ = $1; }
        ;

NUMBER  : INT                   { $$ = $1; }
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

void updateSymbolVal(char* symbol, int val)
{
    int bucket = computeSymbolIndex(symbol);
    symbols[bucket] = val;
}

void yyerror(char* s)
{
    fprintf(stderr, "Error: %s\n", s);
}