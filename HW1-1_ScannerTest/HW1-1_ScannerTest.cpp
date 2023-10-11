#include <iostream>
#include <string>
#include <cctype>

int main()
{
    std::string input, line;
    while (true)
    {
        std::getline(std::cin, line);
        if (line.empty())
            break; // 當讀取到空行時結束輸入
        input += line;
    }

    for (size_t i = 0; i < input.size(); ++i)
    {
        char c = input[i];

        if (isspace(c))
        {
            continue;
        }

        if (isdigit(c))
        {
            std::string num;
            while (i < input.size() && isdigit(input[i]))
            {
                num += input[i];
                i++;
            }
            i--; // 調整外部迴圈的增量
            std::cout << "NUM " << num << std::endl;
        }
        else if (c == '+')
        {
            std::cout << "PLUS" << std::endl;
        }
        else if (c == '-')
        {
            std::cout << "MINUS" << std::endl;
        }
        else if (c == '*')
        {
            std::cout << "MUL" << std::endl;
        }
        else if (c == '/')
        {
            std::cout << "DIV" << std::endl;
        }
        else if (c == '(')
        {
            std::cout << "LPR" << std::endl;
        }
        else if (c == ')')
        {
            std::cout << "RPR" << std::endl;
        }
    }

    return 0;
}
