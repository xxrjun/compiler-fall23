%{
    #include "simple_calc.tab.h"
%}


%option noyywrap

real_number ([0-9]*[.])?[0-9]*([eE][-+]?[0-9]+)?

%%

"+" return ADD;
"-" return SUB;
"*" return MUL;
"/" return DIV;
{real_number} { yylval.fval = atof(yytext); return NUMBER;}
[ \t\n] {}
"\r\n" {}
. { return yytext[0];}

%%