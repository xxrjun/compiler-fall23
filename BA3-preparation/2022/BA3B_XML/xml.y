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

%token AND_TAG OR_TAG NOT_TAG TRUE_TAG FALSE_TAG AND_END_TAG OR_END_TAG NOT_END_TAG
%type <boolVal> expression and_expr or_expr not_expr and_expression_list or_expression_list

%%

start      : expression { printf($1 ? "true" : "false"); }

expression  : and_expr 
            | or_expr  
            | not_expr
            | TRUE_TAG { $$ = 1; }
            | FALSE_TAG { $$ = 0; }

and_expr    : AND_TAG AND_END_TAG { $$ = 1; }
            | AND_TAG and_expression_list AND_END_TAG { $$ = $2; }

or_expr     : OR_TAG OR_END_TAG { $$ = 0; }
            | OR_TAG or_expression_list OR_END_TAG { $$ = $2; }

not_expr    : NOT_TAG expression NOT_END_TAG       { $$ = !$2; }

and_expression_list : expression and_expression_list { $$ = $1 && $2; }
                    | expression { $$ = $1; }

or_expression_list  : expression or_expression_list { $$ = $1 || $2; }
                    | expression { $$ = $1; }

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