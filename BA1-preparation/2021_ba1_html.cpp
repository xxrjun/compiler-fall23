#include <iostream>
#include <vector>
#include <string>
#include <regex>

enum TokenType
{
    TAG_OPEN_SLASH,
    TAG_OPEN,
    TAG_CLOSE,
    TAG_EQUALS,
    SINGLE_QUOTE_STRING,
    DOUBLE_QUOTE_STRING,
    TAG_NAME,
    HTML_TEXT
};

struct Token
{
    TokenType type;
    std::string value;
};

class Lexer
{
private:
    std::string input;
    int pos = 0;
    bool inTag = false;

public:
    Lexer(const std::string &input) : input(input) {}

    Token getNextToken()
    {
        while (pos < input.size())
        {
            if (input.substr(pos, 2) == "</")
            {
                inTag = true;
                pos += 2;
                return {TAG_OPEN_SLASH, "</"};
            }
            else if (input[pos] == '<')
            {
                inTag = true;
                pos++;
                return {TAG_OPEN, "<"};
            }
            else if (input[pos] == '>')
            {
                inTag = false;
                pos++;
                return {TAG_CLOSE, ">"};
            }
            else if (input[pos] == '=')
            {
                pos++;
                return {TAG_EQUALS, "="};
            }
            else if (input[pos] == '\'' && inTag)
            {
                pos++;
                size_t endPos = input.find('\'', pos);
                std::string value = input.substr(pos, endPos - pos);
                pos = endPos + 1;
                return {SINGLE_QUOTE_STRING, value};
            }
            else if (input[pos] == '"' && inTag)
            {
                pos++;
                size_t endPos = input.find('"', pos);
                std::string value = input.substr(pos, endPos - pos);
                pos = endPos + 1;
                return {DOUBLE_QUOTE_STRING, value};
            }
            else if (inTag)
            {
                std::regex tagNameRegex("[a-zA-Z0-9]+");
                std::smatch match;
                std::string remaining = input.substr(pos);
                if (std::regex_search(remaining, match, tagNameRegex))
                {
                    pos += match.length();
                    return {TAG_NAME, match.str()};
                }
            }
            else
            {
                size_t endPos = input.find('<', pos);
                std::string value = input.substr(pos, endPos - pos);
                pos = endPos;
                return {HTML_TEXT, value};
            }
        }
        return {HTML_TEXT, ""}; // End token
    }
};

class Parser
{
private:
    Lexer lexer;
    Token currentToken;

    void eat(TokenType type)
    {
        if (currentToken.type == type)
        {
            currentToken = lexer.getNextToken();
        }
        else
        {
            std::cerr << "Error: Unexpected token " << currentToken.value << std::endl;
            exit(1);
        }
    }

    void htmlElement()
    {
        std::cout << "htmlElement" << std::endl;
        eat(TAG_OPEN);
        eat(TAG_NAME);
        while (currentToken.type == TAG_NAME)
        {
            htmlAttribute();
        }
        eat(TAG_CLOSE);
        while (currentToken.type == HTML_TEXT || currentToken.type == TAG_OPEN)
        {
            if (currentToken.type == HTML_TEXT)
            {
                htmlCharData();
            }
            else
            {
                htmlElement();
            }
        }
        eat(TAG_OPEN_SLASH);
        eat(TAG_NAME);
        eat(TAG_CLOSE);
    }

    void htmlAttribute()
    {
        std::cout << "htmlAttribute" << std::endl;
        eat(TAG_NAME);
        eat(TAG_EQUALS);
        if (currentToken.type == SINGLE_QUOTE_STRING)
        {
            eat(SINGLE_QUOTE_STRING);
        }
        else
        {
            eat(DOUBLE_QUOTE_STRING);
        }
    }

    void htmlCharData()
    {
        std::cout << "htmlCharData" << std::endl;
        eat(HTML_TEXT);
    }

public:
    Parser(const std::string &input) : lexer(input)
    {
        currentToken = lexer.getNextToken();
    }

    void parse()
    {
        while (currentToken.type != HTML_TEXT || !currentToken.value.empty())
        {
            htmlElement();
        }
        std::cout << "valid" << std::endl;
    }
};

int main()
{
    std::string input;
    std::getline(std::cin, input);
    Parser parser(input);
    parser.parse();
    return 0;
}
