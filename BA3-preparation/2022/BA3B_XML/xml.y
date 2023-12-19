%{
    #include <stdio.h>    
    #include <stdbool.h>

    int yylex();
    void yyerror(const char *s);
    
    void print_result(int a);
%}

%union{
    int boolVal;
}

%token AND_TAG OR_TAG NOT_TAG TRUE_TAG FALSE_TAG AND_END_TAG OR_END_TAG NOT_END_TAG END_TAG
%type <boolVal> expression expression_list and_expr or_expr not_expr

%%

start      : expression { printf($1 ? "true" : "false"); }

expression  : and_expr 
            | or_expr  
            | not_expr
            | TRUE_TAG { $$ = 1; }
            | FALSE_TAG { $$ = 0; }

and_expr    : AND_TAG AND_END_TAG { $$ = 1; }
            | AND_TAG expression_list { $$ = $2; }

or_expr     : OR_TAG OR_END_TAG { $$ = 0; }
            | OR_TAG expression_list    { $$ = $2 == -1 ? 0 : $2; }

not_expr    : NOT_TAG expression NOT_END_TAG       { $$ = !$2; }

expression_list : expression  { $$ = $1; }
                | expression_list AND_END_TAG   { $$ = $$ && $1; }
                | expression_list OR_END_TAG   { $$ = $$ || $1; }
                
%%

void yyerror(const char *s){
    printf("syntax error\n");
}

void print_result(int a){
    if(a == 1){
        printf("true\n");
    } 
    printf("false\n");
}


int main(){
    yyparse();
    return 0;
}