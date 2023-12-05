%{
    # include <stack>

    int yylex(void);
    void yyerror(const char *);

    std::stack<int> s;
%}

%code provides {}

%union{
    int ival;
}

/* declarations */
%token <ival> INTEGER
%token ADD
%token SUB
%token MUL
%token MOD
%token INC
%token DEC
%token LOAD
%type <ival> expr

%%
program : lines         {
                            if (s.size() != 1) {
                                std::cout << "Invalid format" << std::endl;
                                exit(0);
                            }
                            else
                                std::cout << s.top() << std::endl;
                        }
lines   : lines line    {;}
        | line          {;}
        ;
line    : expr '\n'     {;}
        | expr          {;}
        | '\n'          {;}
        ;

expr    : LOAD INTEGER  {s.push($2);}
        | ADD           {
                            if (s.size() < 2) {
                                std::cout << "Invalid format" << std::endl;
                                exit(0);
                            }
                            else {
                                int a = s.top();
                                s.pop();
                                int b = s.top();
                                s.pop;
                                s.push(a + b);
                            }
                        }
        | SUB           {
                            if (s.size() < 2) {
                                std::cout << "Invalid format" << std::endl;
                                exit(0);
                            }
                            else {
                                int a = s.top();
                                s.pop();
                                int b = s.top();
                                s.pop();
                                s.push(a - b);
                            }
                        }
        | MUL           {
                            if (s.size() < 2) {
                                std::cout << "Invalid format" << std::endl;
                                exit(0);
                            }
                            else {
                                int a = s.top();
                                s.pop();
                                int b = s.top();
                                s.pop();
                                s.push(a * b);
                            }
                        }
        | MOD           {
                            if (s.size() < 2) {
                                std::cout << "Invalid format" << std::endl;
                                exit(0);
                            }
                            else {
                                int a = s.top();
                                s.pop();
                                int b = s.top();
                                s.pop();
                                s.push(a % b);
                            }
                        }
        | INC           {
                            if (s.size() < 1) {
                                std::cout << "Invalid format" << std::endl;
                                exit(0);
                            }
                            else {
                                int a = s.top();
                                s.pop();
                                s.push(++a);
                            }
                        }
        | DEC           {
                            if (s.size() < 1) {
                                std::cout << "Invalid format" << std::endl;
                                exit(0);
                            }
                            else {
                                int a = s.top();
                                s.pop();
                                s.push(--a);
                            }
                        }
        ;

%%

void yyerror(const char *message) {
    std::cout << "Invalid format" << std::endl;
}

int main(void) {
    yyparse();
    return 0;
}
