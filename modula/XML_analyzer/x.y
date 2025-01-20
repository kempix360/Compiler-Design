%{
#include <stdio.h>
#include <string.h>
#include "defs.h"

int level = 0; // level of nesting
int pos = 0;   // current column

#define INDENT_LENGTH 2
#define LINE_WIDTH 78

extern int yylex(void);
extern void yyerror(const char *msg);
void indent(int level);
%}

%union {
  char s[ MAX_STR_LEN + 1 ];
}

%token <s> PI_TAG_BEG PI_TAG_END STAG_BEG ETAG_BEG TAG_END ETAG_END CHAR S
%type <s> start_tag end_tag word

%%

document: preamble element
;

preamble: | processing_instruction '\n' preamble
;

processing_instruction: PI_TAG_BEG PI_TAG_END
{ 
    printf("Processing instruction detected\n"); 
}
;

element: STAG_BEG ETAG_END | tag_pair
;

tag_pair: start_tag content end_tag
{
    indent(level - 1);
    printf("</%s>\n", $1);
}
;

start_tag: STAG_BEG TAG_END
{
    indent(level++);
    printf("<%s>\n", $1);
}
;

end_tag: ETAG_BEG TAG_END
{
}
;

content:    | element content
            | CHAR content { printf("%s", $1); } 
            | S content { printf(" "); }
            | '\n' content { printf("\n"); }
;

%%

void main() {
    if (yyparse() == 0) {
        printf("Parsing completed successfully.\n");
    } else {
        printf("Parsing failed.\n");
    }
}

void yyerror(const char *msg) {
    fprintf(stderr, "Error: %s at position %d\n", msg, pos);
}

void indent(int level) {
    for (int i = 0; i < level * INDENT_LENGTH; i++) {
        printf(" ");
    }
}

