#include <iostream>
#include <map>
#include <set>
#include <sstream>
#include <vector>

using namespace std;

// Function to split a string by a delimiter and return a vector of tokens
vector<string> split(const string &str, char delimiter)
{
    vector<string> tokens;
    stringstream ss(str);
    string token;
    while (getline(ss, token, delimiter))
    {
        tokens.push_back(token);
    }
    return tokens;
}

// Function to compute First Set for a given symbol (terminal or nonterminal)
set<char> computeFirstSet(const string &symbol, map<char, vector<string>> &rules, map<char, set<char>> &firstSets)
{
    // 如果已經計算過此符號的 First Set，則直接返回已儲存的結果
    // 可以避免遞迴產生規則或交叉參照的情況下無限遞迴 (雖然題目說不會有前者情況)
    if (firstSets.find(symbol[0]) != firstSets.end())
    {
        return firstSets[symbol[0]];
    }

    set<char> firstSet;

    // 若符號是終端符號、EOF 或 epsilon，則其 First Set 就是其本身
    if (islower(symbol[0]) || symbol[0] == ';' || symbol[0] == '$')
    {
        firstSet.insert(symbol[0]);
        return firstSet;
    }

    // 若符號是非終端符號，則基於其產生規則計算 First Set
    for (const auto &production : rules[symbol[0]])
    {
        // 檢查該產生規則是否所有符號均導向 epsilon
        bool allLeadToEpsilon = true;

        for (const char &ch : production)
        {
            // 遞迴計算當前符號的 First Set
            set<char> subFirstSet = computeFirstSet(string(1, ch), rules, firstSets);

            // 檢查當前符號是否導向 epsilon
            allLeadToEpsilon = allLeadToEpsilon && (subFirstSet.find(';') != subFirstSet.end());

            // 如果當前符號不導向 epsilon，則將除 epsilon 外的符號加入 firstSet
            subFirstSet.erase(';');
            firstSet.insert(subFirstSet.begin(), subFirstSet.end());

            // 如果當前符號不導向 epsilon，則停止處理這條產生規則
            if (!allLeadToEpsilon)
            {
                break;
            }
        }

        // 如果該產生規則所有符號均導向 epsilon，則將 epsilon 加入 firstSet
        if (allLeadToEpsilon)
        {
            firstSet.insert(';');
        }
    }

    // 儲存並返回計算出的 First Set
    firstSets[symbol[0]] = firstSet;
    return firstSet;
}

int main()
{
    string line;

    // 使用 map 儲存文法規則以及firstSet，key 會根據 ASCII 編碼自動排序
    map<char, vector<string>> rules;
    map<char, set<char>> firstSets;

    // Read grammar rules
    while (getline(cin, line) && line != "END_OF_GRAMMAR")
    {
        vector<string> tokens = split(line, ' ');
        char nonterminal = tokens[0][0];
        vector<string> productions = split(tokens[1], '|');
        rules[nonterminal] = productions;
    }

    // Compute First Sets for each nonterminal
    for (const auto &rule : rules)
    {
        firstSets[rule.first] = computeFirstSet(string(1, rule.first), rules, firstSets);
    }

    // Output the First Sets
    for (const auto &firstSet : firstSets)
    {
        cout << firstSet.first << " ";
        for (char terminal : firstSet.second)
        {
            cout << terminal;
        }
        cout << endl;
    }

    cout << "END_OF_FIRST" << endl;
    return 0;
}
