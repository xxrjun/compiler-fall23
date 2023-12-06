%{
    #include <stdio.h>
    #include <stdlib.h>

    #define MAX_STACK_SIZE 10000
    int stack[MAX_STACK_SIZE];
    int ptr = -1;
    
    int yylex();
    void yyerror(char *s);
    void push(int num);
    int pop();
    int is_empty();
%}

%token NUM LOAD ADD SUB MUL INC DEC EOL MOD
%start program

%%

program 
    : {/* empty */}
    | program line {
                    if(ptr != 0){
                        yyerror("Invalid foramt\n");
                        YYABORT;        
                    } else {
                        printf("%d\n", pop());
                    }
                }
    ; 

line 
    :  instruction EOL
    ;

instruction 
    : LOAD NUM {push($2);}
    | ADD NUM {push(pop() + $2);}
    | SUB NUM {push(pop() - $2);}
    | MUL NUM {push(pop() * $2);}
    | MOD {push(pop() % 1);}
    | INC {push(pop() + 1);}
    | DEC {push(pop() - 1);}
    | {yyerror("Invalid format\n"); YYABORT;}
    ;
%%

void push(int num){
    if (ptr >= MAX_STACK_SIZE){
        yyerror("Invalid format\n"); 
        exit(1);       
    } else {
        stack[++ptr] = num;
    }
}

int pop(){
    if (is_empty()){
        yyerror("Invalid format\n"); 
        exit(1);
    } else {
        return stack[ptr--];
    }
}

int is_empty(){
    return ptr == -1;
}

int main(int argc, char **argv){
    yyparse();
    return 0;
}

void yyerror(char *s){
    printf("%s\n", s);
}