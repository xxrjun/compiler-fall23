%option noyywrap

%{
	#include "matrix_calculator.tab.h"
	int col = 1;
	int token_start = 1; // Track start of the token
%}


%%

"["     { token_start = col; col += yyleng; return LSBR; }  
"]"     { token_start = col; col += yyleng; return RSBR; } 
"("		{ token_start = col; col += yyleng; return LPAR; }
")"		{ token_start = col; col += yyleng; return RPAR; }
"+"		{ return ADD; }
"-"		{ return SUB; }
"*"		{ return MUL; }
"^T"	{ token_start = col; col += yyleng; return TRANSPOSE; }
[0-9]+	{ token_start = col; col += yyleng; yylval.ival= atoi(yytext);  return NUM; }
[ \t]+	{ token_start = col; col += yyleng;}	
\n		{ col = 1; }
. 		{ return yytext[0]; }

%%