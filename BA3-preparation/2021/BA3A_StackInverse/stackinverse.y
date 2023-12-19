%{
    #include <stdio.h>
    #include <stdlib.h>
    #define MAX_STACK_SIZE 1000
    int stack[MAX_STACK_SIZE];
    int top = -1;

    int yylex();
    void yyerror(const char* msg);
    void inverse(int* stack);
    void push(int val);
    void inc();
    void dec();
%}

%token  NUMBER 
%token PUSH INVERSE INC DEC END EOL;

%%

program : lines END
        ;

lines : lines line
        | line
        ;

line : instruction  EOL
        ;

instruction:
        PUSH NUMBER { push($2); }
        | INVERSE { inverse(stack);}
        | INC { inc(); }
        | DEC { dec(); }

%%

void inverse(int* stack){
    if(top < 1){
        return;
    }

    // just inverse top two elements, no need to check error cases
    int tmp = stack[top-1];
    stack[top - 1] = stack[top];
    stack [top] = tmp;
}

void push(int val){
     if (top >= MAX_STACK_SIZE - 1){
        yyerror("Invalid format\n"); 
        exit(1);       
    } else {
        stack[++top] = val;
    }
}

void inc(){
    stack[top] += 1;
}
    
void dec(){
    stack[top] -= 1;
}

void yyerror(const char* msg){
    printf("%s\n", msg);
}

int main(){
    yyparse();


    /* Wait parsing to finish */
    if(top == -1){
        printf("EMPTY\n");
    } else {
        printf("%d\n", stack[top]);
    }

    return 0;
}
