%{
  #include "y.tab.h"
%}

alpha [A-Za-z]
digit [0-9]

%%

-?{digit}+            yylval=atoi(yytext); return INT;
[\t \n]               ;
-?{digit}+\.{digit}+  yylval=atof(yytext); return FLOAT;
\+                    return PLUS;
\+=                   return PLUSEQ;
-                     return MINUS;
-=                    return MINUSEQ;
\*                    return MULT;
\*=                   return MULTEQ;
\/                    return DIV;
\/=                   return DIVEQ;
=                     return EQ;
{alpha}+              return VAR;
\".+\"                return STRING;
.                     return yytext[0];

%%