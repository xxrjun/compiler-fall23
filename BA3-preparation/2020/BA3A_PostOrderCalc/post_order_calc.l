%{
    #include "post_order_calc.tab.h"
%}


%option noyywrap

real_number -?([0-9]*[.])?[0-9]+([eE][-+]?[0-9]+)?

%%

"+" return ADD;
"-" return SUB;
"*" return MUL;
"/" return DIV;
{real_number} { yylval.dval = atof(yytext); return NUMBER;}
[ \t\n] {}
. {}

%%