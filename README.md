# NCU Compilers Fall 2023

## C/C++ 指定版本指令

On Mac

```bash
g++ --std=c++11
```

On Windows

```bash
g++ --std=gnu++11
```

## Lex 指令

On M2 Mac (arm64)

```bash
lex -o lex.yy.c lex.l
gcc -o lex lex.yy.c -ll
```

On Windows

```bash
flex myLexProgram.l
bison -d myYaccProgram.y
gcc -o indent lex.yy.c
```

## Yacc & Lex 指令

```bash
bison -d -o y.tab.c matrix_calculator.y 
gcc -c -g -I.. y.tab.c
flex -o lex.yy.c matrix_calculator.l
gcc -c -g -I.. lex.yy.c
gcc -o matrix_calculator y.tab.o lex.yy.o -ll
```