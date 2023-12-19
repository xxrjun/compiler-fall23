%{
    #include "xml.tab.h"    
%}

%option noyywrap

%%
"<and>"       { return AND_TAG;}
"</and>"       { return AND_END_TAG;}
"<or>"        { return OR_TAG; }
"</or>"        { return OR_END_TAG; }
"<not>"       { return NOT_TAG; }
"</not>"       { return NOT_END_TAG; }
"<true/>"      { return TRUE_TAG; }
"<false/>"      { return FALSE_TAG; }
"</"[a-zA-Z]+">"      {  }
[ \t\n]+    {  }
.        { return yytext[0]; }


%%