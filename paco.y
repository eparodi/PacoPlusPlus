%token VAR

%token INT FLOAT

%token STRING

%token PLUS MINUS MULT DIV
%token PLUSEQ MINUSEQ MULTEQ DIVEQ EQ

%precedence PLUS
%precedence MINUS
%precedence MULT
%precedence DIV

%%

PROGRAM : INST INST
        | INST
        ;

INST    : ASSIGN ';'
        | EXPRESS ';'
        ;

ASSIGN  : VAR EQ EXPRESS
        | VAR PLUSEQ EXPRESS
        | VAR MINUSEQ EXPRESS
        | VAR MULTEQ EXPRESS
        | VAR DIVEQ EXPRESS
        ;

EXPRESS : VAR
        | VALUE
        | EXPRESS OP VAR
        | EXPRESS OP VALUE
        ;

OP      : PLUS
        | MINUS
        | MULT
        | DIV

VALUE   : NUMBER
        | STRING
        | ARRAY
        ;

NUMBER  : INT
        | FLOAT
        ;
        
ARRAY   : '[' LIST ']'
        ;

LIST    : LIST ',' VALUE
        | LIST ',' VAR
        | VAR
        | VALUE
        ;

%%

int yywrap(void)
{
  return 0;
}

int
main(void)
{
  yyparse();
}  