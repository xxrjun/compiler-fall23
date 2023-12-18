%{
    #include "xml.tab.h"    
%}

%option noyywrap

%%
"<and>"       { return AND;}
"<or>"        { return OR; }
"<not>"       { return NOT; }
"<true/>"      { return TRUE_TAG; }
"<false/>"      { return TRUE_GTAG; }
"</"[a-zA-Z]+">"      { return END_TAG; }
/* <.\/>      {  yylval.boolVal = atoi(yytext) return SELF_CLOSING_TAG; } */
/* <([a-zA-Z]+)\/>      { return SELF_CLOSING_TAG; } */
[ \t\n]+    {  }
.        { return yytext[0]; }


%%