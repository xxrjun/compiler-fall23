%{
    #include <stdio.h>
    #include <stdlib.h>
    #define MAX_STACK_SIZE 1000

    int yylex();
    void yyerror();

    double stack[MAX_STACK_SIZE];
    int top = -1;

    void push(double number);
    double pop();
    double peek();
    int is_full();
    int is_empty();

    double add(double a, double b);
    double sub(double a, double b);
    double mul(double a, double b);
    double divide(double a, double b);
    
%}

%union{
    double dval;
}

%token ADD SUB MUL DIV
%token<dval> NUMBER 

%left ADD SUB
%left MUL DIV

%%

program : line { 
                if(top == 0)
                    printf("%.1f\n", peek());
                else
                    yyerror();
            }
        ;

line : terms

terms : term terms
        | term
        ;

term : NUMBER { push($1); }
        | ADD { push(add(pop(), pop())); }
        | SUB { push(sub(pop(), pop())); }
        | MUL { push(mul(pop(), pop())); }
        | DIV { push(divide(pop(), pop())); }


%%


int is_full(){
    return top == MAX_STACK_SIZE - 1;
}

int is_empty(){
    return top == -1;
}

void push(double number){
    if(is_full()){
        yyerror();
        exit(0);
    } 
    stack[++top] = number;
}

double pop(){
    if(is_empty()){
        yyerror();
        exit(0);
    }
    return stack[top--];
}

double peek(){
    if(is_empty()){
        yyerror();
        exit(0);
    }
    return stack[top];
}

double add(double a, double b){
    return a + b;
}

double sub(double a, double b){
    return a - b;
}

double mul(double a, double b){
    return a * b;
}

double divide(double a, double b){
    return a / b;
}

void yyerror(){
    printf("Wrong Formula\n");
}

int main(){
    yyparse();

    return 0;
}