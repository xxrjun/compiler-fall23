#include <iostream>
#include <string>
#include <vector>
#include <cctype>

using namespace std;

enum TokenType{
    ID,
    STRLIT,
    LBR,
    RBR,
    DOT,
    END,
    INVALID
};

struct Token{
    string val;
    TokenType type;
};

bool program();
bool stmts();
bool stmt();
bool primary();
bool primary_tail();

void get_next_token();
string token_type_to_string(TokenType type);

vector<Token> parsed_tokens;
string line, input;
int cur_pos = 0;
Token cur_token;
int input_len;

int main(){
    while(getline(cin, line)){
        input += line;
    }
    input_len = input.size();
    get_next_token();
    if(program() && cur_token.type == END){
        for(const auto &tok : parsed_tokens){            
            cout << token_type_to_string(tok.type) << " " << tok.val << endl;
        }
    } else {
        cout << "invalid input" << endl;
    }
}

bool program(){
    return stmts();
}

bool stmts(){
    if(stmt()){
        return stmts();
    }
    return true;
}

bool stmt(){
    if(cur_token.type == STRLIT){
        parsed_tokens.push_back(cur_token);
        get_next_token();
        return true;
   } else if (cur_token.type == RBR){
       return true;
   }

   return primary();
}

bool primary(){
    if(cur_token.type == ID){
        parsed_tokens.push_back(cur_token);
        get_next_token();
        return primary_tail();
    }

    return false;
}

bool primary_tail(){
    if(cur_token.type == DOT){
        parsed_tokens.push_back(cur_token);
        get_next_token();
        if(cur_token.type == ID){
            parsed_tokens.push_back(cur_token);
            get_next_token();
            return primary_tail();
         }
        return false;
     } else if(cur_token.type == LBR){
         parsed_tokens.push_back(cur_token);
         get_next_token();
         if(stmt()){
            if(cur_token.type == RBR){
                parsed_tokens.push_back(cur_token);
                get_next_token();
                return primary_tail();
            }
            return false;
         }
         return false;
    }

    return true;
}

void get_next_token(){
    // pass nextline
    while(cur_pos < input_len && input[cur_pos] == '\n'){
        cur_pos++;
    }
    // check boundary
    if(cur_pos >= input_len){
        cur_token.type = END;
        return;
    }

    char c = input[cur_pos];

    // scanning rule
    if(isalpha(c) || c == '_'){
        cur_token.type = ID;
        cur_token.val = c;
        cur_pos++;
        while(cur_pos < input_len && (isalnum(input[cur_pos])|| input[cur_pos] == '_')){
            cur_token.val += input[cur_pos++];
        }
   } else if (c == '"'){
       cur_token.type = STRLIT;
       cur_token.val = "\"";
       cur_pos++;
       while(cur_pos < input_len && input[cur_pos] != '"'){
           cur_token.val += input[cur_pos++];
       }

       if(cur_pos <input_len && input[cur_pos] == '"')
           cur_token.val += input[cur_pos++];
       else
           cur_token.type = INVALID;

  } else if (c == '('){
      cur_token.type = LBR;
      cur_token.val = input[cur_pos++];
  } else if (c == ')'){
      cur_token.type = RBR;
      cur_token.val = input[cur_pos++];
  } else if (c == '.'){
      cur_token.type = DOT;
      cur_token.val = input[cur_pos++];
  } else {
      cur_token.type = INVALID;
  }
}

string token_type_to_string(TokenType type){
    if (type == ID)
        return "ID";
    else if (type == STRLIT)
        return "STRLIT";
    else if (type == LBR)
        return "LBR";
    else if (type == RBR)
        return "RBR";
    else if (type == DOT)
        return "DOT";
    
    return "";     
}
