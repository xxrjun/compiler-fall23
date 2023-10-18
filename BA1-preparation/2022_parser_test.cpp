#include <iostream>
#include <string>
#include <vector>
#include <cctype>

using namespace std;

enum TokenType
{
    num,
    funcName,
    className,
    leftParen,
    rightParen,
    INVALID,
    END
};

struct Token
{
    string val;
    TokenType type;
};

bool Proc();
bool Stmt();
bool Class();
bool Func();
bool Args();
bool Arg();

string token_type_to_string(TokenType type);
void get_next_token();

string input, line;
Token cur_token;
int cur_pos = 0;
vector<Token> parsed_tokens;
int input_len;

int main()
{
    while (getline(cin, line))
    {
        input += line;
    }

    input_len = input.size();

    get_next_token();
    if (Proc() && cur_token.type == END)
    {
        for (const auto &tok : parsed_tokens)
        {
            cout << token_type_to_string(tok.type) << " " << tok.val << endl;
        }
    }
    else
    {
        cout << "Invalid input" << endl;
    }
}

bool Proc()
{
    return Stmt();
}

bool Stmt()
{
    return Class() || Func();
}

bool Class()
{
    if (cur_token.type == className)
    {
        parsed_tokens.push_back(cur_token);
        get_next_token();
        if (cur_token.type == leftParen)
        {
            parsed_tokens.push_back(cur_token);
            get_next_token();
            if (cur_token.type == rightParen)
            {
                parsed_tokens.push_back(cur_token);
                get_next_token();
                return Args();
            }
            return false;
        }

        return false;
    }

    return false;
}

bool Func()
{
    if (cur_token.type == leftParen)
    {
        parsed_tokens.push_back(cur_token);
        get_next_token();
        if (cur_token.type == funcName)
        {
            parsed_tokens.push_back(cur_token);
            get_next_token();
            if (Args())
            {
                if (cur_token.type == rightParen)
                {
                    parsed_tokens.push_back(cur_token);
                    get_next_token();
                    return true;
                }
            }
        }
    }
    return false;
}

bool Args()
{
    if (cur_token.type == rightParen)
    {
        return true;
    }
    else if (Arg())
    {
        return Args();
    }

    return true;
}
bool Arg()
{
    if (cur_token.type == num)
    {
        parsed_tokens.push_back(cur_token);
        get_next_token();
    }

    return Func();
}

string token_type_to_string(TokenType type)
{
    switch (type)
    {
    case num:
        return "num";
    case funcName:
        return "funcName";
    case className:
        return "className";
    case leftParen:
        return "leftParen";
    case rightParen:
        return "rightParen";
    default:
        return "";
        break;
    }
}

void get_next_token()
{
    while (cur_pos < input_len && isspace(input[cur_pos]))
    {
        cur_pos++;
    }

    if (cur_pos >= input_len)
    {
        cur_token.type = END;
        return;
    }

    char c = input[cur_pos];
    if ((cur_pos == input_len - 1) || (cur_pos + 1 < input_len && isspace(input[cur_pos + 1])))
    {
        if (isdigit(c))
        {
            cur_token.val = c;
            cur_token.type = num;
        }
        else if (c >= 'a' && c <= 'z')
        {
            cur_token.val = c;
            cur_token.type = funcName;
        }
        else if (c >= 'A' && c <= 'Z')
        {
            cur_token.val = c;
            cur_token.type = className;
        }
        else if (c == '(')
        {
            cur_token.val = c;
            cur_token.type = leftParen;
        }
        else if (c == ')')
        {
            cur_token.val = c;
            cur_token.type = rightParen;
        }
    }
    else
    {
        cur_token.type = INVALID;
    }

    cur_pos++;
}