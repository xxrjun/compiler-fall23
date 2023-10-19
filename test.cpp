
string cur_token;
cur_pos;
vector<Token> res;


int main(){

	get_next_token();
	if(program() && cur_token.type == END){
		// output
		for(const auto & token : res){
			cout << token.type << " " << token.val << endl;
		}
	} else {
		cout << "invalid input" << endl;
	}
}



program(){
	return stmts();
}

stmts(){
	if(stmt()){
		stmts();
	}
	
	return true; // lambda
}

stmt(){
	if(cur_token.type == STRLIT){
		output.push_back(cur_token);
		get_next_token();
		return true;
	} else if(cur.type == RBR){
		retunr ture;
	}

	return primary();
}

primary(){
	if(cur.type == ID){
		output.push_back(cur);
		get_next_token();
		return primary_tail();
	}

	return false;
} 


primary_tail(){
	if (cur.type == DOT){
		output.push_back(cur);
		get_next_token();
		
		if(cur.type == ID){
			output.push_back(cur);
			get_next_token();
			return primary_tail();		
		}

		return false;
	} else if (cur.type == LBR){
		output.push_back(cur);
		get_next_token();
		
		if(stmt()){
			if(cur.type == RBR){
				output.push_back(cur);
				get_next_token();
				return primary();
			}
			return false;
		} 
		
		return false;
	}		
	
	return true; // lambda
}


enum TokenType{
	ID,
	STRLIT.
	...
}

struct Token{
	string val,
	TokenType type
}


int length;

length = input.size();
int cur_pos = 0;

get_next_token(){
	// ignore '\n'
	while(cur_pos < length && input[cur_pos] == '\n')
		cur_pos++;

	// check overflow(out of bound)	
	if (cur_pos >= length){
		cur_token.type = END;
		return;
	}

	// ID
	if(isalpha(input[cur_pos]) || input[cur_pos] == '_'){
		cur_token.val = input[cur_pos++];
		cur_token.type = ID;
		while(cur_pos < length && (isalnum(input[cur_pos] || input[cur_pos] == '_')){
			cur_token += input[cur_pos++];
		}
	} else if(input[cur_pos] == '"'){ // STRLIT
		cur_token.val = input[cur_pos++]; // = '"'
		cur_token.type = STRLIT;

		while(cur_pos < length && input[cur_pos] != '"'){
			cur_token += input[cur_pos++];
		} 

		if(cur_pos < length && input[cur_pos] == '"'){
			cur_token += input[cur_pos++];
		} else {
			cur_token.type = INVALID;
		}
		
	} else if (input[cur_pos] == '(') { // LBR		
		cur_token.val = input[cur_pos++];
		cur_token.type = LBR;
	} else if (input[cur_pos] == ')') { // RBR	
		cur_token.val = input[cur_pos++];
		cur_token.type = RBR;
	} else if (input[cur_pos] == '.') {
		cur_token.val = input[cur_pos++];
		cur_token.type = DOT;
	} else {

		cur_token.type = INVALID;
	}
}
