%{
#include "list.tab.h"
#include <string.h>
%}
%option noyywrap

digits -?[0-9]+
eol \n
%%
"[" return LBRACKET;
"]" return RBRACKET;
"," return COMMA;
"*" return MULTIPLY;
"+" return ADDITION;
":" return COLON;
{digits} {
    char* str = malloc(strlen(yytext)+1);
    strcpy(str,yytext);
    str[strlen(yytext)] = '\0';
    yylval.word = str;
    return DIGITS;
}
{eol}
.
%%
