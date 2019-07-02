/*
David Turner
*/

%{

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#define MAXTOKENS 1000

struct Node {
    char *name;
    int *lines;
    int length;
} tokens[MAXTOKENS], temp;

int token_count = 0;

void sortData(struct Node idt[], int *num);
void insertId(char* strlpo, int l);
void compareLongest(char*);

int longest_word = 0; /*number of chars in the current largest word. */
int line_count = 1;

int number_words = 0; /*increment when a valid word is encountered.*/

int naughty_count = 0;

%}

%option noyywrap
%option nounput
%x comment
%s stringline
%option yylineno

Zo1_any           .?
ZoN_spc           [^a-zA-Z0-9]*?
OtN_whi           [ \n\t\r]+?
ALL               {Zo1_any}{ZoN_spc}{OtN_whi}

%%

%%


int main(void) {
    yylex();
    printf("\n\t_____Break-down of File Info_____\n\n");

    printf("\tWords in file: %d, Number of Naughty Words: %d.\n", number_words, naughty_count);

    printf("\n\t_____________________\n");

    sortData(tokens, &token_count);
    int e;
    int u;
      for (e = 0; e < token_count; e++) {
          printf("\t%*s:  ",longest_word, tokens[e].name);
          if (tokens[e].length == 1) {
              printf("%d.\n", tokens[e].lines[0]);
          }
          else if (tokens[e].length == 2) {
              printf("%d, %d.\n", tokens[e].lines[0], tokens[e].lines[1]);
          }
          else if (tokens[e].length == 3) {
              printf("%d, %d, %d.\n", tokens[e].lines[0], tokens[e].lines[1], tokens[e].lines[2]);
          }
          else if (tokens[e].length > 3) {
              for (u = 0; u <= tokens[e].length -2 ; ++u) {
                  printf("%d, ", tokens[e].lines[u]);
              }
              for (u = tokens[e].length - 2; u < tokens[e].length - 1; ++u) {
                  printf("%d.", tokens[e].lines[u]);
              }
              printf("\n");
          }

      }

    return 0;
}


void compareLongest(char* str) {
    if (strlen(str) > longest_word) {
        longest_word = strlen(str);
    }
}

void insertId(char* str, int line_num_yylineno) {
    line_count = line_num_yylineno;

    int x;
    for (x = 0; x < token_count; x++) {

        if (strcmp(str, tokens[x].name) == 0) {

            tokens[x].lines = realloc(tokens[x].lines, sizeof(int) * (tokens[x].length + 1 ));
            tokens[x].lines[tokens[x].length] = line_count;

            tokens[x].length++;

            return;
        }

    }

    tokens[token_count].name = strdup(str);
    tokens[token_count].lines = realloc(tokens[token_count].lines, sizeof(int) * (tokens[x].length + 1));

    tokens[token_count].lines[0] = line_count;

    tokens[token_count].length=1;

    token_count++;
}

void sortData(struct Node idt[], int *num) {
    int i;
    int moved;

    do {
        moved = 0;
        for (i = 0; i < (*num) - 1; i++) {
            if (strcmp(idt[i].name, idt[i+1].name) > 0) {
                memcpy(&temp, idt + i, sizeof(struct Node));
                memcpy(idt + i, idt + i + 1, sizeof(struct Node));
                memcpy(idt + i + 1, &temp, sizeof(struct Node));
                moved = 1;
            }
        }
    } while (moved != 0);
}
