%{
int indent = 0;

void printTabs() {
    for(int i = 0; i < indent; i++) {
        printf("\t");
    }
}
%}

%%

"\t"      {}
"{"     {
            indent++; 
            printf("{"); 
        }
"}"     {
            indent--; 
            printf("\n"); 
            printTabs(); 
            printf("}"); 
        }
"\n"    {
            printf("\n"); 
            printTabs();
        }
.       {
            ECHO;
        }

%%

int main(int argc, char **argv) {
    yylex();
    return 0;
}
