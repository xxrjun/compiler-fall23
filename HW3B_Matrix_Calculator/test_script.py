import os
import subprocess

def normalize_lines(text):
    # 移除每行的尾部空白並切割為獨立行
    return [line.strip() for line in text.splitlines()]

def compile_and_test(compilation_command, source_file, testcase_dir):
    # 編譯源代碼
    print(f"Compiling {source_file}...")
    compile_process = subprocess.run(compilation_command, shell=True, text=True, capture_output=True)
    if compile_process.returncode != 0:
        print("Compilation failed.")
        print(compile_process.stdout)
        print(compile_process.stderr)
        return

    # 獲取所有測試案例
    testcases = [f for f in os.listdir(testcase_dir) if f.endswith('.in')]
    correct_tests = []
    failed_tests = []

    for testcase in testcases:
        input_file = os.path.join(testcase_dir, testcase)
        expected_output_file = os.path.join(testcase_dir, testcase.replace('.in', '.out'))

        # 讀取輸入和期望輸出
        with open(input_file, 'r') as infile, open(expected_output_file, 'r') as outfile:
            input_data = infile.read()
            expected_output_lines = normalize_lines(outfile.read())

            # 執行程式並捕獲輸出
            program_output = subprocess.run(f"./{source_file.split('.')[0]}", input=input_data, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
            actual_output_lines = normalize_lines(program_output.stdout)

        # 比較輸出結果
        if actual_output_lines == expected_output_lines:
            correct_tests.append(testcase)
        else:
            failed_tests.append((testcase, input_data.strip(), '\n'.join(expected_output_lines), '\n'.join(actual_output_lines)))

    # 輸出結果
    print("\nTest Results:")
    print(f"Correct Tests: {correct_tests}")
    if failed_tests:
        print("Failed Tests:")
        for test in failed_tests:
            print(f"Testcase: {test[0]}\n")
            print(f"Input:\n{test[1]}\n")
            print(f"Expected Output:\n{test[2]}\n")
            print(f"Actual Output:\n{test[3]}")
            print("-----")



# 使用範例
# compile_command = input("Enter the compilation command: ")
# source_file = input("Enter the source file name: ")
isMac = True
compile_command = """
bison -d -o matrix_calculator.tab.c matrix_calculator.y
gcc -c -g -I. matrix_calculator.tab.c
lex -o lex.yy.c matrix_calculator.l
gcc -c -g -I. lex.yy.c
gcc -o matrix_calculator matrix_calculator.tab.o lex.yy.o -ll
""" if isMac else """
bison -d -o y.tab.c matrix_calculator.y
flex -o lex.yy.c matrix_calculator.l
gcc -c -g -I. y.tab.c
gcc -c -g -I. lex.yy.c
gcc -o matrix_calculator y.tab.o lex.yy.o -ll
"""
source_file = "matrix_calculator" 
testcase_dir = 'testcases'

compile_and_test(compile_command, source_file, testcase_dir)
