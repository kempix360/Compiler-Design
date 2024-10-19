%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#define MAX_STR_LEN	100
#include "modula.tab.h"
  int comm_beg;
int process_token(const char *text, const char *TokenType,
		  const char *TokenVal, const int TokenID); 
char *strnncpy(char *dst, const char *src, const int n);
%}

 /* state of the lexical analyzer (INITIAL is predefined) */
%x ST_COMMENT


%option yylineno
%%

/* B: keywords */
"and"                    return process_token(yytext, "KW_AND", "", KW_AND);
"begin"                  return process_token(yytext, "KW_BEGIN", "", KW_BEGIN);
"const"                  return process_token(yytext, "KW_CONST", "", KW_CONST);
"div"                    return process_token(yytext, "KW_DIV", "", KW_DIV);
"do"                     return process_token(yytext, "KW_DO", "", KW_DO);
"else"                   return process_token(yytext, "KW_ELSE", "", KW_ELSE);
"elsif"                  return process_token(yytext, "KW_ELSIF", "", KW_ELSIF);
"end"                    return process_token(yytext, "KW_END", "", KW_END);
"for"                    return process_token(yytext, "KW_FOR", "", KW_FOR);
"from"                   return process_token(yytext, "KW_FROM", "", KW_FROM);
"if"                     return process_token(yytext, "KW_IF", "", KW_IF);
"import"                 return process_token(yytext, "KW_IMPORT", "", KW_IMPORT);
"in"                     return process_token(yytext, "KW_IN", "", KW_IN);
"mod"                    return process_token(yytext, "KW_MOD", "", KW_MOD);
"module"                 return process_token(yytext, "KW_MODULE", "", KW_MODULE);
"not"                    return process_token(yytext, "KW_NOT", "", KW_NOT);
"or"                     return process_token(yytext, "KW_OR", "", KW_OR);
"then"                   return process_token(yytext, "KW_THEN", "", KW_THEN);
"type"                   return process_token(yytext, "KW_TYPE", "", KW_TYPE);
"to"                     return process_token(yytext, "KW_TO", "", KW_TO);
"var"                    return process_token(yytext, "KW_VAR", "", KW_VAR);
"while"                  return process_token(yytext, "KW_WHILE", "", KW_WHILE);
"repeat"                 return process_token(yytext, "KW_REPEAT", "", KW_REPEAT);
"until"                  return process_token(yytext, "KW_UNTIL", "", KW_UNTIL);
"loop"                   return process_token(yytext, "KW_LOOP", "", KW_LOOP);
"case"                   return process_token(yytext, "KW_CASE", "", KW_CASE);
"of"                     return process_token(yytext, "KW_OF", "", KW_OF);
"array"                  return process_token(yytext, "KW_ARRAY", "", KW_ARRAY);
"record"                 return process_token(yytext, "KW_RECORD", "", KW_RECORD);
"downto"                 return process_token(yytext, "KW_DOWNTO", "", KW_DOWNTO);

/* C: removal of white spaces */
[ \t\n\r]+

 /* D: removal of two-character operators */
"<="                     return process_token(yytext, "LE", "", LE);
">="                     return process_token(yytext, "GE", "", GE);
"!="                     return process_token(yytext, "NEQ", "", NEQ);
".."                     return process_token(yytext, "RANGE", "", RANGE);
":="                     return process_token(yytext, "ASSIGN", "", ASSIGN);

/* removal of integers without sign*/
[0-9]+    return process_token(yytext, "INTEGER_CONST", yytext, INTEGER_CONST);

/* real constants REAL_CONST
[0-9]+\.[0-9]*([eE][-+]?[0-9]+)?    return process_token(yytext, "REAL_CONST", yytext, REAL_CONST); 

/* strings in double quotes STRING_CONST */
\"[^\"]*\""   return process_token(yytext, "STRING_CONST", yytext, STRING_CONST);

/* ... */

/* character constants in single quotes */
\'.\''    return process_token(yytext, "CHAR_CONST", yytext, CHAR_CONST);

/* interger constants INTEGER_CONST */

/* float constants FLOAT_CONST */



 /* identifiers */
 [a-zA-Z_][a-zA-Z0-9_]*   return process_token(yytext, "IDENT", yytext, IDENT);


 /* comments (using start conditions) */

%%

int yywrap() {
  /* take care for closing comments */
  /* ... */
  return 1; /* obligatory!!! */
}

/* Name:	strnncpy
 * Purpose:	copies given number of characters of a string appending 
 *		character with code 0 at the end.
 * Parameters:	dst		- (o) target string;
 *		src		- (i) source string;
 *		n		- (i) max character number to be copied.
 * Returns:	dst.
 * Remarks:	strncpy does not append character code 0 after copied string.
 *		Target string must have room for n+1 characters.
 */
char *
strnncpy(char *dst, const char *src, const int n)
{
  if (n > 0) {
    strncpy(dst, src, n);
  }
  dst[n] = '\0';
  return dst;
}/*strnncpy*/


/* Name:	process_token
 * Purpose:     Print information about detected token and pass it up
 *              with its value if it is present.
 * Parameters:  text            - (i) matched text;
 *              TokenType       - (i) textual representation of token type;
 *              TokenVal        - (i) token value if present
 *              TokenID         - (i) token identifier declared with %token
 *                                      in modula.y file.
 * Returns:	Token type identifier (TokenID).
 * Uwagi:       Information about the detected token is printed in 3 columns.
 *              The first one contains the matched text,
 *		the second - token type, the third - token value if present.
 */
int process_token(const char *text, const char *TokenType,
		  const char *TokenVal, const int TokenID)
{
  int l;
  printf("%-20.20s%-15s %s\n", text, TokenType, TokenVal);
  switch (TokenID) {

  case INTEGER_CONST:
    yylval.i = atoi(text); break;

  case REAL_CONST:
    yylval.d = atof(text); break;

  case IDENT:
    strncpy(yylval.s, text, MAX_STR_LEN); break;

  case STRING_CONST:
    l = strlen(text);
    strnncpy(yylval.s, TokenVal+1, l - 2 <= MAX_STR_LEN ? l - 1 : MAX_STR_LEN);
    break;

  }
  return(TokenID);
}
