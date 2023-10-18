#include <iostream>
#include <string>
#include <cctype>

using namespace std;

int main(){
	string input, line;
    string output;

	while(getline(cin, line)){
        input += line;
    }

    int input_length = input.size();

    for(int i = 0; i < input_length; i++){
        char c = input[i];

        if(isspace(c))
            continue;

        if(isdigit(c)){
            if(c == 0)
                cout << "NUM " << 0 << endl;
            else if (c != 0){
                output = c;
                while(isdigit(input[++i])){
                    output += input[i];
                }
                i--;

                cout << "NUM " << output << endl;
            }
        } else if (c == '+'){
            cout << "PLUS" << endl;
        } else if (c == '-'){
            cout << "MINUS" << endl;
        } else if (c == '*'){
            cout << "MUL" << endl;
        } else if (c == '/'){
            cout << "DIV" << endl;
        } else if (c == '('){
            cout << "LPR" << endl;
        } else if (c == ')'){
            cout << "RPR" << endl;
        }
    }
}
