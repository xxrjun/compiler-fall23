bison -d -o y.tab.c a.y
flex -o lex.yy.c a.l
gcc -c -g -I.. y.tab.c
gcc -c -g -I.. lex.yy.c
gcc lex.yy.o y.tab.o -ll