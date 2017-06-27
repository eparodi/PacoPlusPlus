%{
  #include "operations/include/operations.h"
  #include "types/include/object.h"
  #include "y.tab.h"
%}

alpha [A-Za-z]
digit [0-9]
varName [A-Za-z][0-9A-Za-z_-]*

%%

-?{digit}+            { yylval.num = atoi(yytext); return INT; }
[\t ]                 ;
[\n]				  return NEWLINE;
-?{digit}+\.{digit}+  { yylval.fl = atof(yytext); return FLOAT; }
\+                    return PLUS;
\+=                   return PLUSEQ;
'-'                   return MINUS;
"-="                  return MINUSEQ;
\*                    return MULT;
\*=                   return MULTEQ;
\/                    return DIV;
\/=                   return DIVEQ;
\^                    return POW;
=                     return EQ;
{varName}		      {
						yylval.str = malloc(strlen(yytext)+1);
						strcpy(yylval.str, yytext);
						return VAR;
					  }
\".+\"                return STRING;
.                     return yytext[0];

%%
