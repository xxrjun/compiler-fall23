%{
int indent = 0;


void print_tabs() {
    for(int i = 0; i < indent; i++) {
        printf("\t");
    }
}
%}

%%

\t      {}
\n      { printf("\n");  print_tabs();}
"{"     { indent++; printf("{"); }
"}"     { indent--; printf("\n"); print_tabs(); printf("}"); }
.       { ECHO; }

%%

int main() {
    yylex();
    return 0;
}

int yywrap() {
    return 1;
}
