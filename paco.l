%{
  #include "y.tab.h"
%}

alpha [A-Za-z]
digit [0-9]

%%

-?{digit}+            { yylval.num = atoi(yytext); return INT; }
[\t ]                 ;
[\n]				  return NEWLINE;
-?{digit}+\.{digit}+  { yylval.fl = atof(yytext); return FLOAT; }
\+                    return PLUS;
\+=                   return PLUSEQ;
-                     return MINUS;
-=                    return MINUSEQ;
\*                    return MULT;
\*=                   return MULTEQ;
\/                    return DIV;
\/=                   return DIVEQ;
\^                    return POW;
=                     return EQ;
{alpha}+              { yylval.ch = yytext[0]; return VAR; }
\".+\"                return STRING;
.                     return yytext[0];

%%