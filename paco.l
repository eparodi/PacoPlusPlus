%{
  #include "operations/include/operations.h"
  #include "types/include/object.h"
  #include "yaccObjects.h"
  #include "y.tab.h"
%}

alpha [A-Za-z]
digit [0-9]
varName [A-Za-z][0-9A-Za-z_-]*

%%

if 					  return IF;
bloque_si 			  return IF;
while				  return WHILE;
ciclo_mientras		  return WHILE;
end					  return END;
[\t ]                 ;
[\n]				  return ENTER;
\+                    return PLUS;
\+=                   return PLUSEQ;
-                     return MINUS;
-=                    return MINUSEQ;
\*                    return MULT;
\*=                   return MULTEQ;
\/                    return DIV;
\/=                   return DIVEQ;
\^                    return POW;
==                    return EQLS;
=                     return EQ;
-?{digit}+            { yylval.num = atoi(yytext); return INT; }
-?{digit}+\.{digit}+  { yylval.fl = atof(yytext); return FLOAT; }
{varName}		      {
						yylval.str = malloc(strlen(yytext)+1);
						strcpy(yylval.str, yytext);
						return VAR;
					  }
\<\<n         		  return STDNUM;
\<\<d         	  	  return STDDEC;
\<\<s         		  return STDSTR;
\<					  return LT;
\<=					  return LE;
\>					  return GT;
\>=					  return GE;

\"[^\"]*\"			{
						char * str = malloc(strlen(yytext) - 1);
						strncpy(str, yytext + 1, strlen(yytext) - 2);
						yylval.str = str;
						return STRING;
					}
.                     return yytext[0];
%%
