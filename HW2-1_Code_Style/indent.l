%{
int indent = 0; // 記錄當前的縮排層級

// 定義 print_tabs 函數
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
