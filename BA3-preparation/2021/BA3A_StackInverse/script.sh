bison -d -o stackinverse.tab.c stackinverse.y
gcc -c -g -I.. stackinverse.tab.c
flex -o lex.yy.c stackinverse.l
gcc -c -g -I.. lex.yy.c
gcc -o stackinverse stackinverse.tab.o lex.yy.o