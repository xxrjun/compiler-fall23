%{
	#include "y.tab.h"
%}

%%

"[" [0-9]+ "," [0-9]+ "]"    { yylval.matrix = new_matrix(yytext); return MATRIX; }
"+"                          { return ADD; }
"-"                          { return SUB; }
"*"                          { return MUL; }
"^T"                         { return TRANSPOSE; }
"("                          { return LPAREN; }
")"                          { return RPAREN; }
[ \t\n]+                     { /* ignore whitespace */ }
.                            { yyerror("Syntax Error"); }

%%
