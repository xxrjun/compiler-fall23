#include <iostream>
#include <string>
#include <cctype>
#include <vector>

using namespace std;

/* Token type */
enum TokenType
{
    ID,     // [A-Za-z_][A-Za-z0-9_]*
    STRLIT, // "[^"]*"
    LBR,    // \(
    RBR,    // \)
    DOT,    // \.
    INVALID,
    END
};

/* Token structure */
struct Token
{
    string val;
    TokenType type;
};

/* Declaration of Grammar Rule Functions*/
bool program();
bool stmts();
bool stmt();
bool primary();
bool primary_tail();

/* Declaration of other Function */
void get_next_token();
string token_type_to_string(TokenType type);

/* Global Variables */
Token cur_token; // Current parsing token
Token lookahead; // The token next to be parsed by parser
vector<Token> parsed_tokens;
string input;
int input_length;
int cur_pos = 0;

int main()
{
    /* Getting input lines */
    string line;
    while (getline(cin, line))
    {
        input += line;
    }
    input_length = input.size();

    /* Parsing */
    get_next_token();
    if (program() && cur_token.type == END)
    {
        // print out all tokens
        for (const auto &token : parsed_tokens)
        {
            cout << token_type_to_string(token.type) << " " << token.val << endl;
        }
    }
    else
    {
        cout << "invalid input" << endl;
    }
}

/* Implementation of Functions */

void get_next_token()
{
    // 忽略換行與空格
    while (cur_pos < input_length && isspace(input[cur_pos]))
        cur_pos++;

    // 設定結尾
    if (cur_pos >= input_length)
    {
        cur_token.type = END;
        return;
    }

    // 當前字元
    char c = input[cur_pos];

    // Tokenization規則
    if (isalpha(c) || c == '_')
    {
        cur_token.type = ID;
        cur_token.val = "";

        while (cur_pos < input_length && (isalnum(input[cur_pos]) || input[cur_pos] == '_'))
        {
            cur_token.val += input[cur_pos++];
        }
    }
    else if (c == '"')
    {
        cur_token.type = STRLIT;
        cur_token.val = "\"";
        ++cur_pos;

        // 取得內容
        while (cur_pos < input_length && input[cur_pos] != '"')
        {
            cur_token.val += input[cur_pos++];
        }

        // 檢查是否確實被另一個'"'包著，若沒有則INVALID
        if (cur_pos < input_length && input[cur_pos] == '"')
        {
            cur_token.val += input[cur_pos++];
        }
        else
        {
            cur_token.type = INVALID;
        }
    }
    else if (c == '(')
    {
        cur_token.type = LBR;
        cur_token.val = "(";
        ++cur_pos;
    }
    else if (c == ')')
    {
        cur_token.type = RBR;
        cur_token.val = ")";
        ++cur_pos;
    }
    else if (c == '.')
    {
        cur_token.type = DOT;
        cur_token.val = ".";
        ++cur_pos;
    }
    else
    {
        cur_token.type = INVALID;
    }
}

bool program()
{
    return stmts();
}

bool stmts()
{
    if (stmt())
    {
        return stmts();
    }

    return true; // λ
}

bool stmt()
{
    if (cur_token.type == STRLIT)
    {
        parsed_tokens.push_back(cur_token);
        get_next_token();
        return true;
    }
    else if (cur_token.type == RBR) // stmt為空的情形
    {
        return true; // λ
    }

    return primary();
}

bool primary()
{
    if (cur_token.type == ID)
    {
        parsed_tokens.push_back(cur_token);
        get_next_token();
        return primary_tail();
    }

    return false;
}

bool primary_tail()
{
    if (cur_token.type == DOT)
    {
        parsed_tokens.push_back(cur_token);
        get_next_token();
        if (cur_token.type == ID)
        {
            parsed_tokens.push_back(cur_token);
            get_next_token();
            return primary_tail();
        }

        return false;
    }
    else if (cur_token.type == LBR)
    {
        parsed_tokens.push_back(cur_token);
        get_next_token();
        if (stmt())
        {
            parsed_tokens.push_back(cur_token);
            get_next_token();
            return primary_tail();
        }

        return false;
    }

    return true; // λ
}

string token_type_to_string(TokenType type)
{
    switch (type)
    {
    case ID:
        return "ID";
    case STRLIT:
        return "STRLIT";
    case LBR:
        return "LBR";
    case RBR:
        return "RBR";
    case DOT:
        return "DOT";
    case INVALID:
        return "INVALID";
    case END:
        return "END";
    default:
        return "UNKNOWN"; // 理論上不會叫到這個，只是為了不要有Compile Warning才加的
    }
}