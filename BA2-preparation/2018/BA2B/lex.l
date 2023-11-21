%{
	int valid_input = 0;
%}

word [A-Z][A-Za-z]*
ip_addr (25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)
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

. {}


%%

int main(){
	yylex();
	return 0;
}