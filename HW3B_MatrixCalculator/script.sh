bison -d -o matrix_calculator.tab.c matrix_calculator.y
gcc -c -g -I. matrix_calculator.tab.c
flex -o lex.yy.c matrix_calculator.l
gcc -c -g -I. lex.yy.c
gcc -o matrix_calculator matrix_calculator.tab.o lex.yy.o