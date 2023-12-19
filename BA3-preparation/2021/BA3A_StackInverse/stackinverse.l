%{
    #include "stackinverse.tab.h"    
%}

%option noyywrap

%%

"push" {return PUSH;}
"inverse" {return INVERSE;}
"inc" {return INC;}
"dec" {return DEC;}
"$" {return END;}
[0-9]+ {yylval = atoi(yytext); return NUMBER;}
[ \t] {;}
\n {return EOL;}
. {return yytext[0];}

%%