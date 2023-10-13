#include <iostream>
#include <string>
#include <cctype>

using namespace std;
int main()
{
    string input, line;

    // get input
    while (getline(cin, line))
    {
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
            string num;

            while (i < input.size() && isdigit(input[i]))
            {
                num += input[i];
                i++;
            }
            i--; // 調整外部迴圈的增量

            // 如果 num 的長度不等於 1，去除 num 前面的 0
            if (num.size() != 1)
            {
                size_t j = 0;
                while (j < num.size() - 1 && num[j] == '0')
                {
                    j++;
                }
                num = num.substr(j);
            }

            cout << "NUM " << num << endl;
        }
        else if (c == '+')
        {
            cout << "PLUS" << endl;
        }
        else if (c == '-')
        {
            cout << "MINUS" << endl;
        }
        else if (c == '*')
        {
            cout << "MUL" << endl;
        }
        else if (c == '/')
        {
            cout << "DIV" << endl;
        }
        else if (c == '(')
        {
            cout << "LPR" << endl;
        }
        else if (c == ')')
        {
            cout << "RPR" << endl;
        }
    }

    return 0;
}
