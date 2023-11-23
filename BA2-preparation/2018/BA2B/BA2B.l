%{
    #include <string>
    #include <iostream>
    #include <algorithm>
    void print_no_nl(char* yytext)
    {
        std::string str(yytext);
        str.erase(remove_if(str.begin(), str.end(), isspace), str.end());
        if (str.at(str.size() - 1) == '\n')
            std::cout << str.substr(0, str.size() - 1);
        else
            std::cout << str;
    }
%}

%option noyywrap

cap_word ^[ ]*[A-Z][a-zA-Z]*\n
ip_int   0|1([0-9][0-9]?)?|2([5-9]|[0-4][0-9]?|5[0-5]?)?|[3-9][0-9]?
ip       ^[ ]*{ip_int}\.{ip_int}\.{ip_int}\.{ip_int}\n
word     [0-9a-zA-Z]+
email    ^[ ]*{word}@{word}(\.{word})+\n

%%

{cap_word} {print_no_nl(yytext); printf(" is a word\n");}
{ip}       {print_no_nl(yytext); printf(" is an IP address\n");}
{email}    {print_no_nl(yytext); printf(" is an email address\n");}
.
\n

%%

int main(void)
{
    yylex();
    return 0;
}
