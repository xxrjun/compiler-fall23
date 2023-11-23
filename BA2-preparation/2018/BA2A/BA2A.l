%{
    #include <stdio.h>
%}


sn ^[-+]?[1-9](\.[0-9]+)?[eE][-+]?[0-9]+\n

%%

{sn} {ECHO;}
.
\n

%%

int main(void)
{
    yylex();
    return 0;
}