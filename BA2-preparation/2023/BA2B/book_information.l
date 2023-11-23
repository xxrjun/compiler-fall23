%{
	#include<stdio.h>
    int flag = 1;
%}

book_name [A-Z][a-z]+(_[A-Z][a-z]+)*?
author [A-Z]+,[ ][A-Z][a-z]+-[A-Z][a-z]+
publication_date [0-9][0-9][0-9][0-9]\/((01|03|05|07|08|10|12)\/(3[0-1]|0[1-9]|[1-2][0-9])|(04|06|09|11)\/(30|0[1-9]|[1-2][0-9])|2\/(0[1-9]|[1-2][0-9]))
isbn 978-[0-9]-[0-9][0-9][0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9]

%%

{book_name} {
    if(flag == 1){
        printf("Book name:%s\n", yytext); 
        flag = 0;
    }
}
{author} {
    printf("Author:%s\n", yytext); 
    flag = 1;
}
{publication_date} {
    printf("Publication date:%s\n", yytext); 
    flag = 1;
}
{isbn} {
    printf("ISBN:%s\n", yytext); 
    flag = 1;
}
.|\n {}

%%

int main(int argc, char **argv) {
    yylex();
    return 0;
}