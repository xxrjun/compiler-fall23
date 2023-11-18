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
