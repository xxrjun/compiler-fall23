#include <iostream>
#include <string>
#include <cctype>

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

// Function declarations
bool program();
bool stmts();
bool stmt();
bool primary();
bool primary_tail();

// Function to get the next token from the input
void getNextToken()
{
    while (pos < input.size() && isspace(input[pos]))
        ++pos;

    if (pos >= input.size())
    {
        token.type = END;
        return;
    }

    char c = input[pos];

    if (isalpha(c) || c == '_')
    {
        token.type = ID;
        token.str = "";
        while (pos < input.size() && (isalnum(input[pos]) || input[pos] == '_'))
        {
            token.str += input[pos++];
        }
    }
    else if (c == '"')
    {
        token.type = STRLIT;
        token.str = "\"";
        ++pos;
        while (pos < input.size() && input[pos] != '"')
        {
            token.str += input[pos++];
        }
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
        cout << "STRLIT " << token.str << endl;
        getNextToken();
        return true;
    }
    return primary();
}

bool primary()
{
    if (token.type == ID)
    {
        cout << "ID " << token.str << endl;
        getNextToken();
        return primary_tail();
    }
    return false;
}

bool primary_tail()
{
    if (token.type == DOT)
    {
        cout << "DOT " << token.str << endl;
        getNextToken();
        if (token.type == ID)
        {
            cout << "ID " << token.str << endl;
            getNextToken();
            return primary_tail();
        }
        return false;
    }
    else if (token.type == LBR)
    {
        cout << "LBR " << token.str << endl;
        getNextToken();
        if (stmt() && token.type == RBR)
        {
            cout << "RBR " << token.str << endl;
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
        if (line.empty())
            break; // 當讀取到空行時結束輸入
        input += line;
    }

    // Start parsing
    getNextToken();
    if (program() && token.type == END)
    {
        return 0;
    }
    else
    {
        cout << "invalid input" << endl;
        return 1;
    }
}
