bison -d -o pccalc.tab.c pccalc.y
gcc -c -g -I.. pccalc.tab.c
flex -o lex.yy.c pccalc.l
gcc -c -g -I.. lex.yy.c
gcc -o pccalc pccalc.tab.o lex.yy.o