bison -d -o stackbase_machine.tab.c stackbase_machine.y
gcc -c -g -I. stackbase_machine.tab.c
flex -o lex.yy.c stackbase_machine.l
gcc -c -g -I. lex.yy.c
gcc -o stackbase_machine stackbase_machine.tab.o lex.yy.o