%{
	#include "matrix_calculator.tab.h"
	int col = 1;
	int token_start = 1; // Track start of the token
%}


%%

"["     { col += yyleng; return LSBR; }	  
"]"     { col += yyleng; return RSBR; } 
"("		{ col += yyleng; return LPAR; }
")"		{ col += yyleng; return RPAR; }
"+"		{ col += yyleng; yylval.loc = col; return ADD; }
"-"		{ col += yyleng; yylval.loc = col; return SUB; }
"*"		{ col += yyleng; yylval.loc = col; return MUL; }
"^T"	{ col += yyleng; return TRANSPOSE; }
","		{ col += yyleng; return COMMA; }
[0-9]+	{ col += yyleng; yylval.ival= atoi(yytext);  return NUM; }
[ \t]+	{ col += yyleng;}	
\n		{}
. 		{ return yytext[0]; }

%%