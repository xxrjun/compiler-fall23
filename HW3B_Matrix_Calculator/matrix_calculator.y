%{
    #include <stdio.h>

    extern int col;
    int yylex(void);
    void yyerror(const char *msg);
    void semantic_error();
%}

%union {
    int ival;
    struct def {
        int i;
        int j;
    } Matrix;
}

%type <Matrix> matrix
%token <ival> NUM 
%token LSBR RSBR ADD SUB MUL TRANSPOSE LPAR RPAR

%left TRANSPOSE
%left MUL
%left ADD SUB

%%

line : matrix {printf("Accepted\n"); return 0;}
matrix  : LSBR NUM ',' NUM RSBR { $$.i = $2,$$.j = $4; }
        | matrix ADD matrix 
            {
                if( $1.i == $3.i && $1.j == $3.j )
                {
                    $$.i = $1.i;
                    $$.j = $1.j;
                }
                else 
                {
                    semantic_error();
                    return 0;
                }
            }
        | matrix SUB matrix 
            {
                if( $1.i == $3.i && $1.j == $3.j )
                {
                    $$.i = $1.i;
                    $$.j = $1.j;
                }
                else 
                {
                    semantic_error();
                    return 0;
                }
            }
        | matrix MUL matrix     
            {
                if( $1.j == $3.i ) 
                {
                    $$.i = $1.i; $$.j = $3.j;
                }
                else 
                {
                    semantic_error();
                    return 0;
                }
            }
        | matrix TRANSPOSE      { $$.i = $1.j; $$.j = $1.i; }
        | LPAR matrix RPAR      { $$.i = $2.i; $$.j = $2.j; }

%%

void semantic_error(){
    printf("Semantic error on col %d\n", col);
}

void yyerror (const char *msg)
{
    printf("Syntax Error\n");
}

int main(int argc, char *argv[]) {
        yyparse();
        return(0);
}

