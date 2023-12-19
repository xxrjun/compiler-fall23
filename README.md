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

On Mac

```bash
bison -d -o y.tab.c matrix_calculator.y
gcc -c -g -I.. y.tab.c
lex -o lex.yy.c matrix_calculator.l
gcc -c -g -I.. lex.yy.c
gcc -o matrix_calculator y.tab.o lex.yy.o -ll
```

On Windows

```bash
bison -d -o y.tab.c matrix_calculator.y
gcc -c -g -I.. y.tab.c
flex -o lex.yy.c matrix_calculator.l
gcc -c -g -I.. lex.yy.c
gcc -o matrix_calculator y.tab.o lex.yy.o -ll
```


## Run Tests Scripts Template

[run_tests_template.sh](./run_tests_template.sh)

此表本會自動偵測作業系統，包含 Mac, Linux, Windows。

Sample output 1

<div >
    <img src="./assets/run_test_script_console_all_passed.png" width="50%">
</div>

Sample output 2

<div>
    <img src="./assets/run_test_script_console_has_failed.png" width="50%">
</div>

## AC Screenshot

> 有些忘記截圖

BA2

- BA2 Second Question
- BA2 Book Information

<div>
    <img src="./assets/ac-screenshots/ba2.png" width="70%">
</div>

HW3

- HW3-1 Stack Base Machine 
- HW3-2 Matrix Calculator

<div>
    <img src="./assets/ac-screenshots/hw3.png" width="70%">
</div>    