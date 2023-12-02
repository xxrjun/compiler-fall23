%{
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <math.h>

int yylex();
void yyerror(const char *message);
void sematic_error(int col);
%}

%union {
int 	ival;
int 	loc;
struct def{
	int i;
	int j;
	} mat;
}
%type <mat> matrix
%token <ival> NUM
%token <loc> ADD_SUB
%token <loc> MUL
%token <loc> TRS
%token <loc> LRBR
%token <loc> RRBR
%token <loc> LSBR
%token <loc> RSBR

%left TRS
%left MUL 
%left ADD_SUB 

%%

line    : matrix                {printf("%d %d\n",$1.i,$1.j); return 0;}
matrix  : LSBR NUM ',' NUM RSBR {$$.i=$2,$$.j=$4;}
        | matrix ADD_SUB matrix {if($1.i==$3.i && $1.j==$3.j){
											$$.i = $1.i;
											$$.j = $1.j;}
								else{sematic_error($2);
                                return 0;}
                                };
        | matrix MUL matrix     {if($1.j==$3.i){$$.i = $1.i; $$.j = $3.j;}
                                else{sematic_error($2);
                                return 0;}
                                }
        | matrix TRS            {$$.i = $1.j; $$.j = $1.i;}
        | LRBR matrix RRBR      {$$.i = $2.i; $$.j = $2.j;}
%%
void sematic_error(int col){
    printf("Semantic error on col %d\n", col);
}
void yyerror (const char *message)
{
    fprintf (stderr, "%s\n",message);
}

int main(int argc, char *argv[]) {
        yyparse();
        return(0);
}