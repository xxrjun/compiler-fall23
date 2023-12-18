bison -d -o xml.tab.c xml.y
gcc -c -g -I.. xml.tab.c
flex -o lex.yy.c xml.l
gcc -c -g -I.. lex.yy.c
gcc -o xml xml.tab.o lex.yy.o