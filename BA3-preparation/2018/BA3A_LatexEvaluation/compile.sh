#!/bin/bash

# Define program name
PROGRAM_NAME="latex_eval"

# Detect Operating System and choose lexer
if [[ "$OSTYPE" == "linux-gnu"* || "$OSTYPE" == "darwin"* ]]; then
    LEXER="lex"
else # Assuming Windows or other
    LEXER="flex"
fi

# Choose your C compiler here (gcc, g++, etc.)
CC="gcc"

# Bison command
bison -d -o "${PROGRAM_NAME}.tab.c" "${PROGRAM_NAME}.y"

# Compile Bison output
$CC -c -g -I. "${PROGRAM_NAME}.tab.c"

# Lexer command
$LEXER -o lex.yy.c "${PROGRAM_NAME}.l"

# Compile Lexer output
$CC -c -g -I. lex.yy.c

# Final compilation to create executable
$CC -o $PROGRAM_NAME "${PROGRAM_NAME}.tab.o" lex.yy.o
