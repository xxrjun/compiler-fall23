# Code Style

> 完全不知道為什麼會過

- 要用英文，中文 Online Judge 好像過不了

```lex
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

```
