#include <iostream>
#include <string>
#include <cctype>
#include <vector>

using namespace std;

/* Token type */
enum TokenType
{
    ID,        // ^[A-Z]\d{9}
    NATIONNUM, // \d{3}
    PHONENUM,  // 9[0-9]{8}
    YEAR,      // [12]\d{3}
    MONTH,     // (JAN|FEB|MAR|APR|MAY|JUN|JUL|AUG|SEP|OCT|NOV|DEC)
    DAY,       // [1-9]|[12]\d|3[01]
    PLUS,      // \+
    DOT,       // \.
    LBR,       // \(
    RBR,       // \)
    SLASH,     // \/
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
bool stmt();
bool phone();
bool date();

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
            cout << token.val << " " << token_type_to_string(token.type) << endl;
        }
    }
    else
    { // print out all tokens
        cout << "Invalid input" << endl;
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
    if (c >= 'A' && c <= 'Z' && (cur_pos + 1 < input_length - 1 && isdigit(input[cur_pos + 1]))) // ID
    {
        cur_token.val = c;
        cur_pos++;
        while (cur_pos < input_length && isdigit(input[cur_pos]))
        {
            cur_token.val += input[cur_pos++];
        }

        if (cur_token.val.length() == 10) // ID
        {

            cur_token.type = ID;
        }
        else
        {
            cur_token.type = INVALID;
        }
    }
    else if (isdigit(c)) // NATIONNUM, PHONENUM, YEAR, DAY
    {
        cur_token.val = c;
        cur_pos++;
        while (cur_pos < input_length && isdigit(input[cur_pos]))
        {
            cur_token.val += input[cur_pos++];
        }

        if (cur_token.val.length() == 9 && cur_token.val.at(0) == '9') // PHONENUM
        {
            cur_token.type = PHONENUM;
        }
        else if (cur_token.val.length() == 3) // NATIONNUM
        {
            cur_token.type = NATIONNUM;
        }
        else if (cur_token.val.length() == 4) // YAER
        {
            bool is_year_flag = true;

            if (cur_token.val.at(0) != '1' && cur_token.val.at(0) != '2')
            {
                is_year_flag = false;
            }

            cur_token.type = is_year_flag ? YEAR : INVALID;
        }
        else // DAY or INVALID
        {
            bool is_day_flag = false;
            if (cur_token.val.length() == 1 && (cur_token.val.at(0) >= '1' && cur_token.val.at(0) <= '9'))
            {
                is_day_flag = true;
            }
            else if (cur_token.val.length() == 2 && (cur_token.val.at(0) == '1' || cur_token.val.at(0) == '2'))
            {
                is_day_flag = true;
            }
            else if (cur_token.val.length() == 2 && (cur_token.val.at(0) == '3' && (cur_token.val.at(1) == '0' || cur_token.val.at(1) == '1')))
            {
                is_day_flag = true;
            }

            cur_token.type = is_day_flag ? DAY : INVALID;
        }
    }
    else if (c >= 'A' && c <= 'Z')
    {
        if (cur_pos >= input_length - 3)
        {
            cur_token.type = INVALID;
            return;
        }

        cur_token.val = input[cur_pos++];
        while (input[cur_pos] >= 'A' && input[cur_pos] <= 'Z')
        {
            cur_token.val += input[cur_pos++];
        }

        if (cur_token.val == "JAN" || cur_token.val == "FEB" || cur_token.val == "MAR" || cur_token.val == "APR" || cur_token.val == "MAY" || cur_token.val == "JUN" || cur_token.val == "JUL" || cur_token.val == "AUG" || cur_token.val == "SEP" || cur_token.val == "OCT" || cur_token.val == "NOV" || cur_token.val == "DEC")
        {
            cur_token.type = MONTH;
        }
        else
        {
            cur_token.type = INVALID;
        }
    }
    else if (c == '+') // PLUS
    {
        cur_token.type = PLUS;
        cur_token.val = "+";
        ++cur_pos;
    }
    else if (c == '(') // LBR
    {
        cur_token.type = LBR;
        cur_token.val = "(";
        ++cur_pos;
    }
    else if (c == ')') // RBR
    {
        cur_token.type = RBR;
        cur_token.val = ")";
        ++cur_pos;
    }
    else if (c == '.') // DOT
    {
        cur_token.type = DOT;
        cur_token.val = ".";
        ++cur_pos;
    }
    else if (c == '/') // SLASH
    {
        cur_token.type = SLASH;
        cur_token.val = "/";
        ++cur_pos;
    }
    else
    {
        cur_token.type = INVALID;
    }
}

bool program()
{
    return stmt();
}

bool stmt()
{
    if (cur_token.type == ID)
    {
        parsed_tokens.push_back(cur_token);
        get_next_token();
        return true;
    }

    return phone() || date();
}

bool phone()
{
    if (cur_token.type == PLUS)
    {
        parsed_tokens.push_back(cur_token);
        get_next_token();
        if (cur_token.type == LBR)
        {
            parsed_tokens.push_back(cur_token);
            get_next_token();
            if (cur_token.type == NATIONNUM)
            {
                parsed_tokens.push_back(cur_token);
                get_next_token();
                if (cur_token.type == RBR)
                {
                    parsed_tokens.push_back(cur_token);
                    get_next_token();
                    if (cur_token.type == PHONENUM)
                    {
                        parsed_tokens.push_back(cur_token);
                        get_next_token();
                        return true;
                    }
                }
            }
        }
    }
    return false;
}

bool date()
{
    if (cur_token.type == MONTH)
    {
        parsed_tokens.push_back(cur_token);
        get_next_token();
        if (cur_token.type == DOT)
        {
            parsed_tokens.push_back(cur_token);
            get_next_token();
            if (cur_token.type == DAY)
            {
                parsed_tokens.push_back(cur_token);
                get_next_token();
                if (cur_token.type == DOT)
                {
                    parsed_tokens.push_back(cur_token);
                    get_next_token();
                    if (cur_token.type == YEAR)
                    {
                        parsed_tokens.push_back(cur_token);
                        get_next_token();
                        return true;
                    }
                }
            }
        }
    }
    else if (cur_token.type == YEAR)
    {

        parsed_tokens.push_back(cur_token);
        get_next_token();
        if (cur_token.type == SLASH)
        {
            parsed_tokens.push_back(cur_token);
            get_next_token();
            if (cur_token.type == MONTH)
            {
                parsed_tokens.push_back(cur_token);
                get_next_token();
                if (cur_token.type == SLASH)
                {
                    parsed_tokens.push_back(cur_token);
                    get_next_token();
                    if (cur_token.type == DAY)
                    {
                        parsed_tokens.push_back(cur_token);
                        get_next_token();
                        return true;
                    }
                }
            }
        }
    }
    return false;
}
string token_type_to_string(TokenType type)
{
    switch (type)
    {
    case ID:
        return "ID";
    case NATIONNUM:
        return "NATIONNUM";
    case PHONENUM:
        return "PHONENUM";
    case YEAR:
        return "YEAR";
    case MONTH:
        return "MONTH";
    case DAY:
        return "DAY";
    case PLUS:
        return "PLUS";
    case LBR:
        return "LBR";
    case RBR:
        return "RBR";
    case DOT:
        return "DOT";
    case SLASH:
        return "SLASH";
    case INVALID:
        return "INVALID";
    case END:
        return "END";
    default:
        return "UNKNOWN"; // 理論上不會叫到這個，只是為了不要有Compile Warning才加的
    }
}