%{
    #include <stdio.h>
    #include <stdlib.h>
    #define MAX_STACK_SIZE 1000

    int yylex();
    void yyerror(const char* msg);


    float add(float a, float b);
    float sub(float a, float b);
    float mul(float a, float b);
    float divide(float a, float b);
    
%}

%union{
    float fval;
}

%token ADD SUB MUL DIV
%token<fval> NUMBER
%type<fval> expr exprs

%left ADD SUB
%left MUL DIV

%%

program : exprs {
                    printf("%.3f", $1);
                    return 0;
                }
        ;

exprs : expr exprs | expr

expr : expr ADD expr  { $$ = $1 + $3;}
      | expr SUB expr { $$ = $1 - $3;}
      | expr MUL expr { $$ = $1 * $3;}
      | expr DIV expr { if($3 == 0) {yyerror("a"); YYABORT;} else $$ = $1 / $3;}
      | NUMBER { $$ = $1; }



%%

float add(float a, float b){
    return a + b;
}

float sub(float a, float b){
    return a - b;
}

float mul(float a, float b){
    return a * b;
}

float divide(float a, float b){
    return a / b;
}

void yyerror(const char* msg){
    printf("Invalid Value\n");
}

int main(){
    yyparse();

    return 0;
}