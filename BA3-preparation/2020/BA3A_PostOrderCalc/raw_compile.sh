bison -d -o post_order_calc.tab.c post_order_calc.y
gcc -c -g -I. post_order_calc.tab.c
flex -o lex.yy.c post_order_calc.l
gcc -c -g -I. lex.yy.c
gcc -o post_order_calc post_order_calc.tab.o lex.yy.o