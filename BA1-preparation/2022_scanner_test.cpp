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
        else if (isalpha(c)) // ID
        {
            cur_token.type = "ID";
            cur_token.val = c;
            i++;
            while (i < len && isalpha(input[i]))
            {
                cur_token.val += input[i++];
            }
            i--;
            tokens.push_back(cur_token);
        }
        else if (c == '+' || c == '-' || c == '*' || c == '=') // OP
        {
            cur_token.type = "OP";
            cur_token.val = c;
            tokens.push_back(cur_token);
        }
        else if (c == '(') // LPR
        {
            cur_token.type = "LPR";
            cur_token.val = c;
            tokens.push_back(cur_token);
        }
        else if (c == ')') // RPR
        {
            cur_token.type = "RPR";
            cur_token.val = c;
            tokens.push_back(cur_token);
        }
        else
        {
            is_invalid = true;
            break;
        }
    }

    if (is_invalid)
    {
        cout << "invalid output" << endl;
    }
    else
    {
        for (const auto &tok : tokens)
        {
            if (tok.type == "LPR" || tok.type == "RPR")
            {
                cout << tok.type << endl;
            }
            else
            {
                cout << tok.type << " " << tok.val << endl;
            }
        }
    }
}