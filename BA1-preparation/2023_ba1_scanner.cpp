#include <iostream>
#include <string>
#include <cctype>
#include <vector>

using namespace std;

struct Token
{
    string val;
    string type;
};

int main()
{
    string input, line;
    vector<Token> tokens;
    bool is_invalid = false;

    while (getline(cin, line))
    {
        input += line;
    }

    int len = input.size();
    Token cur_token;

    for (int i = 0; i < len; i++)
    {
        char c = input[i];

        if (isspace(c))
        {
            continue;
        }

        if (isdigit(c)) // NUM
        {
            cur_token.type = "NUM";
            if (c == 0)
            {
                if (i == len - 1 || input[i + 1] == 0)
                {
                    cur_token.val = "0";
                    tokens.push_back(cur_token);
                }
                else
                {
                    is_invalid = true;
                    break;
                }
            }
            else
            {
                cur_token.val = c;
                i++;
                while (i < len && isdigit(input[i]))
                {
                    cur_token.val += input[i++];
                }
                i--;
                tokens.push_back(cur_token);
            }
        }
        else if (isalpha(c)) // IDENTIFIER
        {

            cur_token.type = "IDENTIFIER";
            cur_token.val = c;
            i++;
            while (i < len && (isalnum(input[i]) || input[i] == '_'))
            {
                cur_token.val += input[i++];
            }
            i--;

            if (cur_token.val == "if" || cur_token.val == "else" || cur_token.val == "while")
            {
                cur_token.type = "KEYWORD";
            }

            tokens.push_back(cur_token);
        }
        else if (c == '+' || c == '-' || c == '*' || c == '=' || c == '(' || c == ')' || c == '{' || c == '}' || c == '<' || c == '>' || c == ';') // SYMBOL
        {
            cur_token.type = "SYMBOL";
            cur_token.val = c;
            tokens.push_back(cur_token);
        }
        else
        {
            cur_token.type = "INVALID";
            tokens.push_back(cur_token);
        }
    }

    for (const auto &tok : tokens)
    {
        if (tok.type == "INVALID")
        {
            cout << "Invalid" << endl;
        }
        else
        {
            cout << tok.type << " \"" << tok.val << "\"" << endl;
        }
    }
}