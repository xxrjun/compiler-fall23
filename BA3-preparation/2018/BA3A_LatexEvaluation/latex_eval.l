%{
    #include "latex_eval.tab.h"    
%}

%option noyywrap

number [0-9]+

%%

"+" return ADD;
"-" return MINUS;
"\\frac" return FRAC;
"^" return POW;
{number} {yylval.dval = atof(yytext); return NUMBER;}
"{" return LBRACE;
"}" return RBRACE;
[ \t\n] {}
. { }

%%
