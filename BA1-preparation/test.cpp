#include <iostream>
#include <string>

using namespace std;

int main()
{

    bool isFlag = true;

    int a;

    a = 10 ? isFlag : 5;

    cout << a << endl;

    cout << '1' << endl;

    string str = "12345";

    bool check = str.at(0) == '2';
    cout << check << endl;
}
