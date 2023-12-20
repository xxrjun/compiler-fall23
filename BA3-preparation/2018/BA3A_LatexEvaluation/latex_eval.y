%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <math.h>     

    int yylex();
    void yyerror(char *s);
%}

%union{
    double dval;
}

%token <dval> NUMBER
%token ADD MINUS FRAC POW LBRACE RBRACE
%type <dval> expr

%left ADD MINUS
%left POW
%left FRAC

%%

program : expr { printf("%.3f\n", $1); }
        ;

expr : NUMBER { $$ = $1; }
        | expr ADD expr {$$ = $1 + $3;}
        | expr MINUS expr {$$ = $1 - $3;}
        | FRAC expr expr {$$ = $2 / $3; }
        | LBRACE expr FRAC expr expr LBRACE {$$ = $4 / $5; }
        | expr POW expr {$$ = pow($1, $3);}
        | LBRACE expr RBRACE {$$ = $2;}
        ;

%%

void yyerror(char *s){
    fprintf(stderr, "%s\n", s);
}

int main(){
    yyparse();
    return 0;
}