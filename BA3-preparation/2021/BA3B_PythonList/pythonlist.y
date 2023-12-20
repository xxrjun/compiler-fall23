%{
#include<stdio.h>
#include <stdlib.h>
#include "string.h"

extern int yylex();
extern FILE *yyin;
typedef struct List {
    int size;
    char** items;
    int maxSize;
}my_list;

typedef struct Slice {
    int startIndex;
    int endIndex;
    int hasStartIndex;
    int hasEndIndex;
    int step;
}my_slice;

my_list* create_list() {
    const int maxSize = 10000;
    my_list* list = malloc(sizeof(my_list));
    list->items = malloc(sizeof(char*)*maxSize);
    list->size = 0;
    list->maxSize = maxSize;
    return list;
}


int append_last(my_list* list, char* c) {
    list->items[list->size] = malloc((strlen(c)+1) * sizeof(char));
    strcpy(list->items[list->size], c);
    list->size+=1;
    return list->size;
}

int append_head(my_list* list, char* c) {
    int i;
    for (i = list->size-1; i > -1 ; i--) {
        list->items[i+1] = list->items[i];
    }
    list->items[0] = malloc((strlen(c)+1) * sizeof(char));
    strcpy(list->items[0], c);
    list->size+=1;
    return list->size;
}

my_list* concat_list(my_list* first_list , my_list* second_list) {
    my_list* new_list = create_list();
    int i;
    for(i = 0; i < first_list->size; i++) {
        append_last(new_list, first_list->items[i]);
    }
    for(i = 0; i < second_list->size; i++) {
        append_last(new_list, second_list->items[i]);
    }
    return new_list;
}

my_list* repeat_list(my_list* list , int repeat_num) {
    my_list* new_list = create_list();
    // if repeat num <= 0, list would be empty
    int ori_size = list->size;
    if (repeat_num <= 0) {
        return new_list;
    }
    int r; 
    int i;
    for (r = 0 ; r < repeat_num ; r++) {
        for(i =0; i < ori_size; i++) {
            append_last(new_list, list->items[i]);
        }
    }
    return new_list;
}

void print_list(my_list* list) {
    printf("[");
    int i;
    for (i = 0 ; i < list->size ; i++ ) {
        printf("%s", list->items[i]);
        if (i != list->size - 1) {
            printf(", ");
        }
    }
    printf("]\n");
}

my_list* create_list_slice(my_list* list, my_slice* slice) {
    int start_index = slice->hasStartIndex?slice->startIndex:0;
    int end_index = slice->hasEndIndex?slice->endIndex:list->size;
    if (start_index < 0 ) {
        start_index += list->size;
    }
    if (end_index < 0) {
        end_index += list->size;
    }

    if (start_index < 0) {
        start_index = 0;
    }
    
    if (end_index < 0) {
        end_index = 0;
    }

    int len = end_index - start_index;
    if (end_index > list->size) {
        end_index = list->size;
    }
    if (start_index > list->size) {
        end_index = list->size;
    }
    my_list* new_list = create_list();
    int i;
    for(i = start_index; i < end_index ; i+=slice->step) {
        append_last(new_list, list->items[i]);
    }
    return new_list;
}
my_list* list;
%}
%union {
  int ival;
  char* word;
  struct List* list;
  struct Slice* slice;
}

%start S
%token<word> DIGITS
%token LBRACKET RBRACKET COMMA MULTIPLY ADDITION COLON

%type<word> StartIndex EndIndex Step
%type<list> ListItem List Term Sum
%type<ival> MulDigit
%type<slice> Slice
%%
S 
    : Sum {printf("end\n");}

Sum 
    : Term ADDITION Sum { 
        printf("sum1\n"); 
    }
    | Term { 
        printf("sum2\n");
    }

Term 
    : List MULTIPLY MulDigit {
        printf("Term1\n");
    }
    | MulDigit MULTIPLY List {
        printf("Term2\n");
    }
    | MulDigit MULTIPLY List MULTIPLY MulDigit {
        printf("Term3\n"); 
    }
    | List {
        printf("Term4\n");
    }

MulDigit 
    : MulDigit MULTIPLY  DIGITS {
        printf("MulDigit1\n");
    }
    | DIGITS {
        printf("MulDigit2\n"); 
    }

List 
    : LBRACKET ListItem RBRACKET Slice {
        printf("list1\n"); 
    }

Slice
    : LBRACKET StartIndex COLON EndIndex RBRACKET {
        printf("slice1\n");
    }
    | LBRACKET StartIndex COLON EndIndex COLON Step RBRACKET {
        printf("slice2\n");
    }
    | {
        printf("slice3\n"); 
    }

StartIndex
    : DIGITS { 
        printf("StartIndex\n");
    }
    | { 
        printf("StartIndex2\n");
    }

EndIndex
    : DIGITS { 
        printf("EndIndex\n");
    }
    | {  
        printf("EndIndex2\n");
    }

Step
    : DIGITS {  
        printf("step1\n");
    }
    | { 
        printf("step2\n");
    }
ListItem 
    : DIGITS COMMA ListItem {
        printf("ListItem1\n");
    }
    | DIGITS {
        printf("ListItem2\n");
    }
%%

void yyerror (char const *s) {
   fprintf (stderr, "%s\n", s);
}

int main(int argc, char** argv)
{
    // if you need submit the code, need comment below
    // if you need run locally by input file t.txt, need uncomment below
    FILE *fp;
    fp=fopen("t.txt","r");
    yyin=fp;
    // if you need submit the code, need comment above
    // if you need run locally by input file t.txt, need uncomment above
    yyparse();
    return 0;
}
