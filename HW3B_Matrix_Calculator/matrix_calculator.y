%{
	#include <stdio.h>
	#include <stdlib.h>

    int yylex();
    int yyerror(const char *s);

	// Define the Matrix structure
	typedef struct Matrix {
		int rows;
		int cols;
	} Matrix;

	// Define the ASTNode structure
	typedef struct ASTNode {
		int operation; // Represents the operation (ADD, SUB, MUL, TRANSPOSE)
		struct ASTNode *left; // Left child in AST
		struct ASTNode *right; // Right child in AST
		Matrix matrix; // Matrix dimensions
	} ASTNode;

	// Function prototypes
	ASTNode* create_matrix_node(Matrix m);
	ASTNode* check_and_create_op_node(int operation, ASTNode *left, ASTNode *right);
	void free_ast(ASTNode *node);
%}

%union {
    Matrix matrix;
    ASTNode *node;
}

%token <matrix> MATRIX
%token ADD SUB MUL TRANSPOSE LPAREN RPAREN
%type <node> expression term factor

%%

// Grammar rules for matrix expressions
expression: term { $$ = $1; }
           | expression ADD term { $$ = check_and_create_op_node(ADD, $1, $3); }
           | expression SUB term { $$ = check_and_create_op_node(SUB, $1, $3); };

term: factor { $$ = $1; }
     | term MUL factor { $$ = check_and_create_op_node(MUL, $1, $3); };

factor: MATRIX { $$ = create_matrix_node($1); }
       | LPAREN expression RPAREN { $$ = $2; }
       | factor TRANSPOSE { $$ = check_and_create_op_node(TRANSPOSE, $1, NULL); };

%%

// Implementation of auxiliary functions
ASTNode* create_matrix_node(Matrix m) {
    ASTNode* node = (ASTNode*)malloc(sizeof(ASTNode));
    node->operation = 0; // 0 for a matrix
    node->left = NULL;
    node->right = NULL;
    node->matrix = m;
    return node;
}

ASTNode* check_and_create_op_node(int operation, ASTNode *left, ASTNode *right) {
    // Check dimensions based on operation
    switch (operation) {
        case ADD:
        case SUB:
            if (left->matrix.rows != right->matrix.rows || left->matrix.cols != right->matrix.cols) {
                printf("Semantic Error: Dimension mismatch for addition/subtraction\n");
                exit(1);
            }
            break;
        case MUL:
            if (left->matrix.cols != right->matrix.rows) {
                printf("Semantic Error: Dimension mismatch for multiplication\n");
                exit(1);
            }
            break;
        case TRANSPOSE:
            // Transpose operation only changes dimensions, no need for dimension check
            break;
        default:
            printf("Unknown operation\n");
            exit(1);
    }

    // Create operation node
    ASTNode* node = (ASTNode*)malloc(sizeof(ASTNode));
    node->operation = operation;
    node->left = left;
    node->right = right;

    // Set the resulting matrix dimensions
    if (operation == TRANSPOSE) {
        node->matrix.rows = left->matrix.cols;
        node->matrix.cols = left->matrix.rows;
    } else {
        node->matrix.rows = left->matrix.rows;
        node->matrix.cols = right->matrix.cols;
    }
    return node;
}

void free_ast(ASTNode *node) {
    if (node != NULL) {
        free_ast(node->left);
        free_ast(node->right);
        free(node);
    }
}

int main() {
    yyparse();
    // Remember to free the AST after use
    // free_ast(ast_root); // You need to manage the root of your AST
    return 0;
}

int yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
    return 0;
}
