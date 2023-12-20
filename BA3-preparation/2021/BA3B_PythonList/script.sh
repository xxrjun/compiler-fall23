bison -d -o list.tab.c list.y
gcc -c -g -I.. list.tab.c
flex -o lex.yy.c list.l
gcc -c -g -I.. lex.yy.c
gcc -o list list.tab.o lex.yy.o