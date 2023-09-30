/**
 * @file HW1-1_ParserTest.cpp
 * @author 109403019
 * @brief
 * @version 0.1
 * @date 2023-09-28
 *
 * @copyright Copyright (c) 2023
 *
 */

#include <iostream>
#include <string>
#include <regex>
#include <vector>

using namespace std;

struct Pattern
{
    regex regex;
    string token;
};

int main()
{

    // 定義模式和對應的token
    std::vector<Pattern> patterns = {
        {std::regex(R"(\+)"), "PLUS"},
        {std::regex(R"(-)"), "MINUS"},
        {std::regex(R"(\*)"), "MUL"},
        {std::regex(R"(\/)"), "DIV"},
        {std::regex(R"(\()"), "LPR"},
        {std::regex(R"(\))"), "RPR"},
        {std::regex(R"([1-9][0-9]*|0)"), "NUM"}};

    // 讀取輸入
    std::string input;
    std::getline(std::cin, input);

    // 使用正則表達式進行匹配
    for (const auto &pattern : patterns)
    {
        std::smatch matches;
        auto start = input.cbegin();
        auto end = input.cend();
        while (std::regex_search(start, end, matches, pattern.regex))
        {
            if (pattern.token == "NUM")
            {
                std::cout << pattern.token << " " << matches[0].str() << "\n";
            }
            else
            {
                std::cout << pattern.token << "\n";
            }
            start = matches.suffix().first;
        }
    }
}