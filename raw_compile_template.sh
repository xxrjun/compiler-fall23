bison -d -o program.tab.c program.y
gcc -c -g -I. program.tab.c
flex -o lex.yy.c program.l
gcc -c -g -I. lex.yy.c
gcc -o program program.tab.o lex.yy.o