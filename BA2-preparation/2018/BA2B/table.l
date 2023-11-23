%{
	#include <stdio.h>
%}

word       [A-Z][a-zA-Z]*
ip_addr    ((25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])\.){3}(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])
email_addr [a-zA-Z0-9]+@[a-zA-Z0-9]+(\.[a-zA-Z0-9]+)+

%%

{word} {
	ECHO;
	printf(" is a word\n");
}

{ip_addr} {
	ECHO;
	printf(" is an IP address\n");
}

{email_addr} {
	ECHO;
	printf(" is an email address\n");
}

.|\n {}


%%

int main(int argc, char **argv) {
    yylex();
    return 0;
}