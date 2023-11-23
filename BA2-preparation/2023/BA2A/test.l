%{
	#include <stdio.h>
%}

%option noyywrap

/* a rule exclude "." */

INTEGER ^[1-9]?[0-9]+\n
FLOAT	^[1-9]?([0-9]*[\.][0-9]+|[0-9]+[\.][0-9]*)\n
STRING 	(\"[^"]+\"\n)|('[^']+'\n)
VARIABLE ^[A-Za-z_][A-Za-z_0-9]*\n

%%

{INTEGER} {printf(" INTERGER\n");}
{FLOAT} {printf(" FLOAT\n");}
{STRING} { printf(" STRING\n");}
{VARIABLE} { printf(" VARIABLE\n");}
.|\n {}

%%

int main(int argc, char **argv) {
    yylex();
    return 0;
}