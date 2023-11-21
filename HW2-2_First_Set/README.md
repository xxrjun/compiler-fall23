# C++ 程式教學文件：計算語法分析器的 First Set

## First Set 簡介

在編譯器設計中，特別是構建語法分析器時，First Set 是一個關鍵概念。它用於確定在多個產生規則都適用時應選擇哪條規則。First Set 基本上包含了從某個非終端符號（nonterminal）出發，可能在衍生（derivation）的第一步中直接遇到的終端符號（terminal）集合。

### 計算規則

1. 對於終端符號，First Set 就是其本身。
2. 對於非終端符號 A 的每個產生規則，將規則右側第一個符號的 First Set 加入到 First(A) 中。
3. 如果某個規則右側的第一個符號的 First Set 包含空字串（epsilon），則繼續將下一個符號的 First Set 也加入到 First(A) 中，以此類推。

## 實作概念

此程式使用 C++ 語言實作 First Set 的計算。主要步驟包括：

1. **讀取語法規則**：從標準輸入讀取語法規則，並將其儲存到適當的資料結構中。
2. **計算 First Set**：對每個非終端符號計算其 First Set。
3. **輸出結果**：將每個非終端符號的 First Set 輸出。

## 實作部分

程式分為幾個主要部分：

### 1. 輔助函數：split

此函數用於將字符串按指定分隔符拆分成子字符串，並將它們儲存在一個向量中。

```cpp
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
```

### 2. 主要函數：computeFirstSet

此函數的目的是計算並返回給定符號的 First Set。First Set 是從特定的非終端符號（nonterminal）開始，可能在導出（derivation）的第一步中直接遇到的終端符號（terminal）集合。

#### 函數原型

```cpp
set<char> computeFirstSet(const string &symbol,
                          map<char, vector<string>> &rules,
                          map<char, set<char>> &firstSets)
```

- `symbol`：要計算其 First Set 的符號（終端或非終端）。
- `rules`：包含語法規則的映射，將非終端符號映射到其產生規則。
- `firstSets`：用於儲存已計算的 First Sets 的映射。

#### 函數實作及註解

```cpp
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
```

#### 函數功能說明

此函數按照以下步驟計算 First Set：

1. **檢查快取**：如果已經計算過給定符號的 First Set，則直接從 `firstSets` 中返回結果。
2. **處理終端符號**：對於終端符號、EOF 和 epsilon，First Set 是其本身。
3. **處理非終端符號**：對於每個非終端符號，迭代其產生規則。
   - 對於每條產生規則中的每個符號，遞迴計算其 First Set。
   - 如果一個符號的 First Set 包含 epsilon，則繼續處理下一個符號；否則，停止並將除 epsilon 以外的符號加入到 First Set 中。
   - 如果整條產生規則中的所有符號的 First Set 都包含 epsilon，則將 epsilon 加入到 First Set 中。
4. **返回結果**：返回計算出的 First Set，並將其儲存在 `firstSets` 中以供後續快速訪問。

通過這種方式，我們可以有效地計算任何給定符號的 First Set，這對於構建語法分析器和編譯器是非常重要的。

### 3. 主函數：main

主函數處理標準輸入以讀取語法規則，調用 `computeFirstSet` 函數計算 First Sets，並將結果輸出。

```cpp
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
```

## 使用說明

1. 將語法規則按指定格式輸入，每行表示一個非終端符號及其產生規則。
2. 規則輸入完成後，輸入 `END_OF_GRAMMAR` 表示結束。
3. 程式將輸出每個非終端符號的 First Set，然後以 `END_OF_FIRST` 結束。

## 注意事項

- 程式假設輸入的語法規則是格式正確且沒有遞迴。
