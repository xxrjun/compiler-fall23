#!/bin/bash

TEST_DIR="./testcases"
PROGRAM_NAME="stackbase_machine"
PASSED=0
FAILED=0

# 顏色定義
COLOR_BRIGHT_BLUE="\033[36m"
COLOR_BLUE="\033[34m"
COLOR_RESET="\033[0m"
COLOR_GREEN="\033[32m"
COLOR_RED="\033[31m"
COLOR_YELLOW="\033[33m"
COLOR_RESET="\033[0m"

# 清屏
clear

# 顯示基本訊息
echo -e "${COLOR_BRIGHT_BLUE}+------------------------------------------------+${COLOR_RESET}"
echo -e "${COLOR_BRIGHT_BLUE}|        NCU Compilers Homework, 2023 Fall       |${COLOR_RESET}"
echo -e "${COLOR_BRIGHT_BLUE}|                   Test Script                  |${COLOR_RESET}"
echo -e "${COLOR_BRIGHT_BLUE}+------------------------------------------------+${COLOR_RESET}"

bison -d -o ${PROGRAM_NAME}.tab.c ${PROGRAM_NAME}.y
gcc -c -g -I. ${PROGRAM_NAME}.tab.c
lex -o lex.yy.c ${PROGRAM_NAME}.l
gcc -c -g -I. lex.yy.c
gcc -o ${PROGRAM_NAME} ${PROGRAM_NAME}.tab.o lex.yy.o

# Check whether the program exists
if [ ! -f "$PROGRAM_NAME" ]; then
    echo -e "${COLOR_RED}Error: $PROGRAM_NAME not found.${COLOR_RESET}"
    exit 1
fi

for test_file in $TEST_DIR/*.in; do
    test_name=$(basename $test_file)

    # Extract the expected output from the answer file (.out)
    expected_output=$(cat $TEST_DIR/$test_name.out)
    actual_output=$(./"$PROGRAM_NAME" < $test_file)    

    echo -e "\033[36mTest: $test_name\033[0m"

    if [ "$expected_output" == "$actual_output" ]; then
        echo -e "\033[32mResult: PASS\033[0m"
        ((PASSED++))
    else
        echo -e "${COLOR_RED}Result: FAIL${COLOR_RESET}"
        echo "Expected Output:"
        echo -e "${COLOR_RED}$expected_output${COLOR_RESET}"
        echo "Actual Output:"
        echo -e "${COLOR_RED}$actual_output${COLOR_RESET}"
        ((FAILED++))
    fi

    echo -e "\033[35m-----------------------------------\033[0m"
done

echo -e "${COLOR_YELLOW}Tests completed.${COLOR_RESET} ${COLOR_GREEN}Passed: $PASSED${COLOR_RESET}, ${COLOR_RED}Failed: $FAILED${COLOR_RESET}"

rm -f *.o lex.yy.c ${PROGRAM_NAME}.tab.c ${PROGRAM_NAME}.tab.h