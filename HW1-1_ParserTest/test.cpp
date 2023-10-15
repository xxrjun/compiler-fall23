#include <iostream>
#include <string>
#include <cctype>
#include <vector>

using namespace std;

// Token types
enum TokenType
{
    ID,
    STRLIT,
    LBR,
    RBR,
    DOT,
    END,
    INVALID
};

// Token structure
struct Token
{
    TokenType type;
    string str;
};

// Global variables
string input;
size_t pos = 0;
Token token;
vector<pair<TokenType, string>> parsedTokens;

// Function declarations
bool program();
bool stmts();
bool stmt();
bool primary();
bool primary_tail();

// Function to get the next token from the input
void getNextToken()
{
    // 忽略空格與換行
    while (pos < input.size() && isspace(input[pos]))
        ++pos;

    // 設定結尾
    if (pos >= input.size())
    {
        token.type = END;
        return;
    }

    // 當前character
    char c = input[pos];

    if (isalpha(c) || c == '_') // 字母或底線開頭，可能為ID
    {
        token.type = ID;
        token.str = "";
        while (pos < input.size() && (isalnum(input[pos]) || input[pos] == '_'))
        {
            token.str += input[pos++];
        }
    }
    else if (c == '"') // 以'"'開頭，可能為STRLIT
    {
        token.type = STRLIT;
        token.str = "\"";
        ++pos;

        // 取得內容
        while (pos < input.size() && input[pos] != '"')
        {
            token.str += input[pos++];
        }

        // 嘗試把最後一個'"'加到token string中，如果沒有成對代表INVALID
        if (pos < input.size())
        {
            token.str += input[pos++];
        }
        else
        {
            token.type = INVALID;
        }
    }
    else if (c == '(')
    {
        token.type = LBR;
        token.str = "(";
        ++pos;
    }
    else if (c == ')')
    {
        token.type = RBR;
        token.str = ")";
        ++pos;
    }
    else if (c == '.')
    {
        token.type = DOT;
        token.str = ".";
        ++pos;
    }
    else
    {
        token.type = INVALID;
    }
}

// Implementations of parsing functions
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
    return true; // λ production
}

bool stmt()
{
    if (token.type == STRLIT)
    {
        parsedTokens.push_back({STRLIT, token.str});
        getNextToken();
        return true;
    }
    else if (token.type == RBR) // Handling empty statement
    {
        return true;
    }
    return primary();
}

bool primary()
{
    // primary開頭必須為ID
    if (token.type == ID)
    {
        parsedTokens.push_back({ID, token.str});
        getNextToken();
        return primary_tail();
    }
    return false;
}

bool primary_tail()
{
    // promary_tail開頭必須為DOT或LBR
    if (token.type == DOT)
    {
        parsedTokens.push_back({DOT, token.str});
        getNextToken();
        if (token.type == ID)
        {
            parsedTokens.push_back({ID, token.str});
            getNextToken();
            return primary_tail();
        }
        return false;
    }
    else if (token.type == LBR)
    {
        parsedTokens.push_back({LBR, token.str});
        getNextToken();
        if (stmt() && token.type == RBR)
        {
            parsedTokens.push_back({RBR, token.str});
            getNextToken();
            return primary_tail();
        }
        return false;
    }
    return true; // λ production
}

int main()
{
    // Read input
    string line;
    while (getline(cin, line))
    {
        input += line;
    }

    // Start parsing
    getNextToken();
    if (program() && token.type == END)
    {
        // Output all tokens at once
        for (const auto &tok : parsedTokens)
        {
            string typeStr;
            switch (tok.first)
            {
            case ID:
                typeStr = "ID";
                break;
            case STRLIT:
                typeStr = "STRLIT";
                break;
            case LBR:
                typeStr = "LBR";
                break;
            case RBR:
                typeStr = "RBR";
                break;
            case DOT:
                typeStr = "DOT";
                break;
            }
            cout << typeStr << " " << tok.second << endl;
        }
    }
    else
    {
        cout << "invalid input" << endl;
    }
}