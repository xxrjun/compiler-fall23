%{
	#include "y.tab.h"
	int yyerror(char *);
	int yylex(void);
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
.                            { return yyerror("Syntax Error"); }

%%
