%{
#include <stdio.h>
#include <string.h>
#include <stdbool.h>

bool in_multiline_comment = false;
bool in_if_statement = false;
%}

%option noyywrap

%%
"//".*                  { printf("#%s\n", yytext + 2); } // Single-line comments

"/\\*"                  { in_multiline_comment = true; printf("\"\"\"\n"); } // Start of multi-line comment
"\\*/"                  { in_multiline_comment = false; printf("\"\"\"\n"); } // End of multi-line comment
.                       { if(in_multiline_comment) { printf("%s", yytext); } } // Inside a multi-line comment

"cout << \""            { printf("print(\""); } // Start of print statement with string
"<< endl;"              { printf(")\n"); }      // End of print statement
"cout <<"               { printf("print("); }   // Start of print statement without string
"\""                    { if(!in_multiline_comment) printf("\""); } // Handle quotes outside comments

"if\\(true\\)"          { in_if_statement = true; printf("if True:\n"); } // If true statement
"if\\(false\\)"         { in_if_statement = true; printf("if False:\n"); } // If false statement
"{"                     { } // Ignore opening brace
"}"                     { in_if_statement = false; } // Ignore closing brace

\n                      { if(!in_multiline_comment && !in_if_statement) printf("\n"); // Newline handling
                          else if(in_if_statement) printf("\t\n"); }

.                       { if(!in_multiline_comment && !in_if_statement) printf("%s", yytext); } // Everything else

%%

int main(void) {
    yylex();
    return 0;
}
