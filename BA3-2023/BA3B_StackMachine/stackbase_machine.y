%{
    #include <stdio.h>
    #include <stdlib.h>

    #define MAX_STACK_SIZE 10
    int stack[MAX_STACK_SIZE];
    int top = -1;
    
    int yylex();
    void yyerror(const char *s);
    void push(int num);
    int pop();
    int peek();
    void print_stack();
%}

%token NUM ADD SUB MUL DIV
%start program

%%

program : exprs

exprs: expr exprs | expr

expr 
    : NUM { push($1);}
    | ADD { if(top < 1) { printf("Runtime Error: The pop will lead to stack underflow.\n");  YYABORT; } else { push(pop() + pop()); } }
    | SUB { if(top < 1) { printf("Runtime Error: The pop will lead to stack underflow.\n");  YYABORT; } else { int a = pop(); int b = pop(); push(b - a); } }
    | MUL { if(top < 1) { printf("Runtime Error: The pop will lead to stack underflow.\n");  YYABORT; } else { push(pop() * pop()); } }
    | DIV { if(top < 1) { printf("Runtime Error: The pop will lead to stack underflow.\n");  YYABORT; } else { int a = pop(); int b = pop();  push(b / a); } }
    ;

%%

void push(int num){
    if (top >= MAX_STACK_SIZE - 1){
        printf("Runtime Error: The push will lead to stack overflow.\n"); 
        exit(0);       
    } else {
        stack[++top] = num;
        print_stack();
    }
}

int pop(){
    return stack[top--];
}

void print_stack(){
    if(top != -1){
        printf("The contents of the stack are:");
        int i = 0;
        for(i  ; i <= top ; i++){
            printf(" %d", stack[i]);
        }
        printf("\n");
    }
}


int main(int argc, char **argv){
    yyparse();
    return 0;
}

void yyerror(const char *s){
    printf("%s\n", s);
}

