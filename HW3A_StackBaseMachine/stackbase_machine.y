%{
    #include <stdio.h>
    #include <stdlib.h>

    #define MAX_STACK_SIZE 10000
    int stack[MAX_STACK_SIZE];
    int top = -1;
    int error = 0;
    
    int yylex();
    void yyerror(char *s);
    void push(int num);
    int pop();
    int is_empty();
%}

%token NUM LOAD ADD SUB MUL INC DEC EOL MOD
%start program

%%

program : lines
        ;   

lines: lines line
        | line
        ;
        
line 
    : instruction EOL
    | instruction
    | EOL
    ;

instruction 
    : LOAD NUM { push($2); }
    | ADD { if(top < 1) { YYABORT; } else { push(pop() + pop()); } }
    | SUB { if(top < 1) { YYABORT; } else { push(pop() - pop()); } }
    | MUL { if(top < 1) { YYABORT; } else { push(pop() * pop()); } }
    | MOD { if(top < 1) { YYABORT; } else { push(pop() % pop()); } }
    | INC { if(top < 0) { YYABORT; } else {push(pop() + 1);} }
    | DEC { if(top < 0) { YYABORT; } else {push(pop() - 1);} }
    ;

%%

void push(int num){
    if (top >= MAX_STACK_SIZE - 1){
        yyerror("Invalid format\n"); 
        exit(1);       
    } else {
        stack[++top] = num;
    }
}

int pop(){
    if (is_empty()){
        yyerror("Invalid format\n"); 
        exit(1);
    } else {
        return stack[top--];
    }
}

int is_empty(){
    return top == -1;
}

int main(int argc, char **argv){
    int error = yyparse();
    if (top == 0 && !error) {
        printf("%d\n", pop());
    } else {
        printf("Invalid format\n");
    }
    return 0;
}

void yyerror(char *s){
    fprintf(stderr, "%s\n", s);
}

