%option noyywrap

%{
	#include "matrix_calculator.tab.h"
	int col = 0;
%}


%%

"["     { col += yyleng; return LSBR; }  
"]"     { col += yyleng; return RSBR; } 
"("		{ col += yyleng; return LPAR; }
")"		{ col += yyleng; return RPAR; }
"+"		{ col += yyleng; return ADD; }
"-"		{ col += yyleng; return SUB; }
"*"		{ col += yyleng; return MUL; }
"^T"	{ col += yyleng; return TRANSPOSE; }
[0-9]+	{ col += yyleng; yylval.ival= atoi(yytext);  return NUM; }
[ \t]+	{ col += yyleng;}	
\n		{}
. 		{ return yytext[0]; }

%%