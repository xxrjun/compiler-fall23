%{
#include <stdio.h>
%}

%%

[a-zA-Z][a-zA-Z0-9]([a-zA-Z0-9]*(,[a-zA-Z0-9]+))  {
    printf("%s\n", yytext);
}

.|\n  { }

%%

int main(int argc, char **argv)
{
    yylex();
    return 0;
} 
