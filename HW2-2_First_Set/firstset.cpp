#include <iostream>
#include <map>
#include <set>
#include <sstream>
#include <vector>

using namespace std;

/**
 * @brief 將字符串根據指定分隔符拆分成子字符串
 *
 * @param str 要拆分的字符串
 * @param delimiter 分隔符
 * @return vector<string> 包含子字符串的向量
 */
vector<string> split(const string &str, char delimiter)
{
    vector<string> tokens;
    stringstream ss(str);
    string token;

    // 迴圈逐步讀取: 使用 getline 在每次迭代中從 ss 讀取直到遇到分隔符 delimiter 的字符串
    while (getline(ss, token, delimiter))
    {
        tokens.push_back(token); // 將拆分後的子字符串添加到向量中
    }
    return tokens;
}

/**
 * @brief 計算給定符號的 First Set
 *
 * @param symbol 要計算 First Set 的符號
 * @param rules 包含語法規則的映射
 * @param firstSets 用於存儲已計算 First Sets 的映射
 * @return 給定符號的 First Set
 */
set<char> computeFirstSet(const string &symbol, map<char, vector<string>> &rules, map<char, set<char>> &firstSets)
{
    // 如果已經計算過此符號的 First Set，則直接返回已儲存的結果
    // 這樣可以提高效率，避免重複計算
    if (firstSets.find(symbol[0]) != firstSets.end())
    {
        return firstSets[symbol[0]];
    }

    set<char> firstSet;

    // 如果符號是終端符號、EOF 或 epsilon (分別用小寫字母、'$' 和 ';' 表示)
    // 則其 First Set 就是其本身
    if (islower(symbol[0]) || symbol[0] == ';' || symbol[0] == '$')
    {
        firstSet.insert(symbol[0]);
        return firstSet;
    }

    // 如果符號是非終端符號，則需要基於其產生規則來計算 First Set
    for (const auto &production : rules[symbol[0]])
    {
        // 標記用於確定是否所有符號均導向 epsilon (空字串)
        bool allLeadToEpsilon = true;

        // 遍歷產生規則中的每個符號
        for (const char &ch : production)
        {
            // 遞迴調用來計算當前符號的 First Set
            set<char> subFirstSet = computeFirstSet(string(1, ch), rules, firstSets);

            // 判斷當前符號的 First Set 是否包含 epsilon
            allLeadToEpsilon = allLeadToEpsilon && (subFirstSet.find(';') != subFirstSet.end());

            // 從子 First Set 中移除 epsilon
            subFirstSet.erase(';');
            // 將子 First Set 中的元素加入到當前的 First Set
            firstSet.insert(subFirstSet.begin(), subFirstSet.end());

            // 如果當前符號的 First Set 不包含 epsilon，則停止處理這條產生規則
            if (!allLeadToEpsilon)
            {
                break;
            }
        }

        // 如果產生規則中的所有符號的 First Set 均包含 epsilon，則將 epsilon 加入到 First Set
        if (allLeadToEpsilon)
        {
            firstSet.insert(';');
        }
    }

    // 儲存計算出的 First Set 以供後續使用
    firstSets[symbol[0]] = firstSet;
    return firstSet;
}

// 主函數
int main()
{
    string line;

    // 規則和 First Sets 的映射
    map<char, vector<string>> rules;
    map<char, set<char>> firstSets;

    // 從標準輸入讀取語法規則
    while (getline(cin, line) && line != "END_OF_GRAMMAR")
    {
        // 使用 split 函數將讀取的行按空格拆分為 tokens
        vector<string> tokens = split(line, ' ');

        // 取出 tokens 第一個元素的第一個字符，作為非終端符號
        char nonterminal = tokens[0][0];

        // 使用 split 函數將 tokens 第二個元素按 '|' 拆分為 productions
        vector<string> productions = split(tokens[1], '|');

        // 將非終端符號和其對應的產生規則存入映射 rules 中
        rules[nonterminal] = productions;
    }

    // 為每個非終端符號計算 First Set
    for (const auto &rule : rules)
    {
        firstSets[rule.first] = computeFirstSet(string(1, rule.first), rules, firstSets);
    }

    // 輸出 First Sets
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
