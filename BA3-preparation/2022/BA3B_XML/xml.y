%{
    #include <stdio.h>    
    #include <stdbool.h>

    int yylex();

    void yyerror(const char *s);
    int and_op(int a, int b);
    int or_op(int a, int b);
    int not_op(int a);
    void print_result(int a);
%}

%union{
    int boolVal;
}

/* %type <boolVal> xml subtags logical_op
%token AND OR NOT END_TAG  
%token <boolVal> SELF_CLOSING_TAG */
%token AND_TAG OR_TAG NOT_TAG TRUE_TAG FALSE_TAG END_TAG
%token <boolVal> expression_list and_expr or_expr not_expr
%start <boolVal> expression

%%

/* logical_op:
    AND END_TAG { $$ = 1; }
    | AND SELF_CLOSING_TAG END_TAG { $$ = $2; }
    | AND subtags END_TAG { $$ = and_op($1, $2); }
    | OR END_TAG { $$ = 0; }
    | OR SELF_CLOSING_TAG END_TAG { $$ = $2; }
    | OR subtags END_TAG { $$ = or_op($1, $2); }
    | NOT SELF_CLOSING_TAG END_TAG { $$ = not_op($1); }
    | NOT subtags END_TAG { $$ = not_op($1); } */

expression  : and_expr { printf($1 ? "true" : "false"); }
            | or_expr  { printf($1 ? "true" : "false"); }
            | not_expr { printf($1 ? "true" : "false"); }
            | TRUE_TAG { $$ = 1; }
            | FALSE_TAG { $$ = 0; }
            ;

and_expr    : AND_TAG expression_list END_TAG  { $$ = $2; }
            ;

or_expr     : OR_TAG expression_list END_TAG   { $$ = $2; }
            ;

not_expr    : NOT_TAG expression END_TAG       { $$ = !$2; }
            ;

expression_list : expression                   { $$ = $1; }
                | expression AND_TAG expression_list { $$ = $1 && $3; }
                | expression OR_TAG expression_list  { $$ = $1 || $3; }
                ;


%%

// it would not be called in this exercise
void yyerror(const char *s){
    printf("Error: %s\n", s);
}

int and_op(int a, int b){
    return a && b;
}

int or_op(int a, int b){
    return a || b;
}    

int not_op(int a){
    return !a;
}

void print_result(int a){
    if(a == 1){
        pritnf("true\n");
    } 
    printf("false\n");
}


int main(){
    yyparss();
    return 0;
}