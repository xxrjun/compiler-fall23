#ifndef MATRIX_CALCULATOR_H
#define MATRIX_CALCULATOR_H

#include <stdio.h>
#include <stdlib.h>

// Define the Matrix structure
typedef struct Matrix
{
	int rows;
	int cols;
} Matrix;

// Define the ASTNode structure
typedef struct ASTNode
{
	int operation;		   // Represents the operation (ADD, SUB, MUL, TRANSPOSE)
	struct ASTNode *left;  // Left child in AST
	struct ASTNode *right; // Right child in AST
	Matrix matrix;		   // Matrix dimensions
} ASTNode;

// Function prototypes
int yyerror(const char *s);
Matrix new_matrix(int rows, int cols);
Matrix parse_matrix_dimensions(const char *str);
ASTNode *create_matrix_node(Matrix m);
ASTNode *check_and_create_op_node(int operation, ASTNode *left, ASTNode *right);
void free_ast(ASTNode * node);

#endif // MATRIX_CALCULATOR_H
