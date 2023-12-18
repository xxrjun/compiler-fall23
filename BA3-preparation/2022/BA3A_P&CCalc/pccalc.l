
%{
    #include "pccalc.tab.h"
%}

%option noyywrap

%%

"+" { return ADDITION; }
"-" { return SUBSTRACTION; }
"P"|"p" { return P; } /* Permutation */
"C"|"c" { return C; } /* Combination */
[0-9]+ { yylval.num = atoi(yytext); return NUMBER; }
[ \t\n\r] { /* ignore whitespace */ }
. { return yytext[0]; }

%%
