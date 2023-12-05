%{
    #include <stdio.h>
    int yylex(void);
    void yyerror(const char *msg);
    void semantic_error(const int col);
%}

%union {
    int ival;
    int loc;
    struct def {
        int i;
        int j;
    } Matrix;
}

%type <Matrix> matrix
%token <ival> NUM 
%token LSBR RSBR TRANSPOSE LPAR RPAR COMMA
%token <loc> ADD SUB MUL 

%left ADD SUB
%left MUL
%left TRANSPOSE


%%

line    : matrix { printf("Accepted\n"); return 0; }
matrix  : LSBR NUM COMMA NUM RSBR { $$.i = $2,$$.j = $4; }
        | LPAR matrix RPAR      { $$.i = $2.i; $$.j = $2.j; }
        | matrix ADD matrix 
            {
                if( $1.i == $3.i && $1.j == $3.j )
                {
                    $$.i = $1.i;
                    $$.j = $1.j;
                }
                else 
                {
                    semantic_error($2);
                    YYABORT;
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
                    semantic_error($2);
                    YYABORT;
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
                    semantic_error($2);
                    YYABORT;
                }
            }
        | matrix TRANSPOSE      { $$.i = $1.j; $$.j = $1.i; }
        | matrix
      
%%

void semantic_error(const int col){
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

