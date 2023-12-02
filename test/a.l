%option noyywrap
%{
#include "y.tab.h"
int col=0;
%}

%%
\n        {}
[ \t]+	  {col+=yyleng; /* do nothing */ }
"+" || "-"    {return ADD_SUB;}
"*"     {col+=yyleng;return MUL;}
"("     {col+=yyleng;return LRBR;} // Left Round Bracket
")"	    {col+=yyleng;return RRBR;} // Right Round Bracket
"["     {col+=yyleng;return LSBR;} // Left Square Bracket  
"]"     {col+=yyleng;return RSBR;} // Right Square Bracket
"^T"    {col+=yyleng;return TRS;}
[0-9]+	  { yylval.ival= atoi(yytext);return(NUM); }
.	      { return(yytext[0]); }
%%