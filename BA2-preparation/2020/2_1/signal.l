%{
#include <stdio.h>
%}

digit       [0-9]
nzero_digit [1-9]

%%

\$({nzero_digit}{digit}{0,4}) { printf("transfer $%s\n", yytext+1); }

\+({nzero_digit}{digit}{0,2}) { 
    if (atoi(yytext+1) <= 365) printf("after +%s days\n", yytext+1); 
}

([01]{digit}):([0-5]{digit}) { printf("at %s\n", yytext); }

[A-Z][a-z.-]*[A-Z]            { printf("at %s\n", yytext); }

\n                           /* Ignore newlines */

.                            /* Ignore any other input */

%%

int main() {
    yylex();
    return 0;
}

int yywrap() {
    return 1;
}
