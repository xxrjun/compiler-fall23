%{
    #include <stdio.h>

    int yylex(void);
    void yyerror(const char* message);

    int addition(int M, int N);
    int substraction(int M, int N);
    int permutations(int M, int N);
    int combination(int M, int N);

%}

%union {
    int result;
    int num;
}

%type <result> expression term
%token <num> NUMBER 
%token ADDITION SUBSTRACTION P C

%%

program : expression { printf("%d\n", $1); }

expression : term { $$ = $1; }
        | term ADDITION term { $$ = addition($1, $3); }
        | term SUBSTRACTION term { $$ = substraction($1, $3); }

term : P NUMBER NUMBER { $$ = permutations($2, $3);}
        | C NUMBER NUMBER { $$ = combination($2, $3);}
        | {yyerror("Wrong Formula"); return 0;}
%%

int addition(int M, int N){
    return M + N;
}

int substraction(int M, int N){
    return M - N;
}

int permutations(int M, int N){
    if(M < N || M > 12 || N > 12){
        yyerror("Wrong Formula");
        return 0;
    }

    int minus = M - N;
    int denominator = 1;
    for(int i = M; i > 1; i--){
        denominator *= i;
    }

    int numerator = 1;
    for(int i = minus; i > 1; i--){
        numerator *= i;
    }

    return denominator/numerator;
}

int combination(int M, int N){
    if(M < N || M > 12 || N > 12){
        yyerror("Wrong Formula");
        return 0;
    }

    int minus = M - N;
    int denominator = 1;
    for(int i = M; i > 1; i--){
        denominator *= i;
    }

    int numerator = 1;
    for(int i = minus; i > 1; i--){
        numerator *= i;
    }
    for(int i = N; i > 1; i--){
        numerator *= i;
    }

    return denominator/numerator;
}

void yyerror(const char* message){
    printf("%s\n", message);
}

int main(int argc, char *argv[]) {
        yyparse();
        return(0);
}