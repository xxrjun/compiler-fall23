%option noyywrap

%{
    #include "stackbase_machine.tab.h"
    extern int yylval;
%}


%%

"load"  { return LOAD; }
"add"   { return ADD; }
"sub"   { return SUB;}
"mul"   { return MUL;}
"mod"   { return MOD;}
"inc"   { return INC;}
"dec"   { return DEC;}
[0-9]+  { yylval = atoi(yytext); return NUM;}
[ \t]   { /* ignore whitespace */ }
\n      { return EOL; }
.       { return yytext[0]; }

%%