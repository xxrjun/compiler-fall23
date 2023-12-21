%option noyywrap

%{
    #include "stackbase_machine.tab.h"
    extern int yylval;
%}


%%

"+"   { return ADD; }
"-"   { return SUB;}
"*"   { return MUL;}
"/"   { return DIV;}
[-?[0[1-9][0-9]*|-[1-9][0-9]*]]  { yylval = atoi(yytext); return NUM;}
[ \t\n]   { /* ignore whitespace */ }
"\r\n" {}
.       { return yytext[0]; }

%%