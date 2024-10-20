%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#define MAX_STR_LEN	100
#include "modula.tab.h"
int process_token(const char *text, const char *TokenType,
		  const char *TokenVal, const int TokenID); 
char *strnncpy(char *dst, const char *src, const int n);
%}

 /* stany analizatora leksykalnego (INITIAL jest zdefiniowany) */
%option yylineno
%x ST_COMMENT
%x STRING
%x CHAR_CONST_STATE
%x COMMENT_STATE
%x ORPHANED_COMMENT_STATE


 /* pomocnicze */

%%

/* B: keywords*/

"and" return process_token(yytext, "KW_AND", "", KW_AND);
"begin" return process_token(yytext, "KW_BEGIN", "", KW_BEGIN);
"const" return process_token(yytext, "KW_CONST", "", KW_CONST);
"div" return process_token(yytext, "KW_DIV", "", KW_DIV);
"do"  return process_token(yytext, "KW_DO", "", KW_DO);
"else"  return process_token(yytext, "KW_ELSE", "", KW_ELSE);
"elsif" return process_token(yytext, "KW_ELSIF", "", KW_ELSIF);
"end" return process_token(yytext, "KW_END", "", KW_END);
"for" return process_token(yytext, "KW_FOR", "", KW_FOR);
"from"  return process_token(yytext, "KW_FROM", "", KW_FROM);
"if"  return process_token(yytext, "KW_IF", "", KW_IF);
"import"  return process_token(yytext, "KW_IMPORT", "", KW_IMPORT);
"in"  return process_token(yytext, "KW_IN", "", KW_IN);
"mod" return process_token(yytext, "KW_MOD", "", KW_MOD);
"module"  return process_token(yytext, "KW_MODULE", "", KW_MODULE);
"not" return process_token(yytext, "KW_NOT", "", KW_NOT);
"or" return process_token(yytext, "KW_OR", "", KW_OR);
"then"  return process_token(yytext, "KW_THEN", "", KW_THEN);
"type"  return process_token(yytext, "KW_TYPE", "", KW_TYPE);
"to"  return process_token(yytext, "KW_TO", "", KW_TO);
"var" return process_token(yytext, "KW_VAR", "", KW_VAR);
"while" return process_token(yytext, "KW_WHILE", "", KW_WHILE);
"repeat"  return process_token(yytext, "KW_REPEAT", "", KW_REPEAT);
"until" return process_token(yytext, "KW_UNTIL", "", KW_UNTIL);
"loop"  return process_token(yytext, "KW_LOOP", "", KW_LOOP);
"case"  return process_token(yytext, "KW_CASE", "", KW_CASE);
"of"  return process_token(yytext, "KW_OF", "", KW_OF);
"array" return process_token(yytext, "KW_ARRAY", "", KW_ARRAY);
"record"  return process_token(yytext, "KW_RECORD", "", KW_RECORD);
"downto"  return process_token(yytext, "KW_DOWNTO", "", KW_DOWNTO);

 /* C: removal of white spaces */

[ \t\n\r]+ 

/* D: detecting multi-char operators*/

"<="  return process_token(yytext, "LE", "", LE);
">="  return process_token(yytext, "GE", "", GE);
"!="  return process_token(yytext, "NEQ", "", NEQ);
".."  return process_token(yytext, "RANGE", "", RANGE);
":="  return process_token(yytext, "ASSIGN", "", ASSIGN);

/* E: detecting identifiers*/

[[:alpha:]][[:alpha:][:digit:]]* return process_token(yytext, "IDENT", yytext, IDENT);

/* F: detecting integers*/

[+-]?[[:digit:]]+  return process_token(yytext, "INTEGER_CONST", yytext, INTEGER_CONST);

/* G: detecting real numbers*/

[[:digit:]]+\.[[:digit:]]*([eE][-+]?[[:digit:]]+)?  return process_token(yytext, "REAL_CONST", yytext, REAL_CONST);

/* H: detecting text constants (strings) in quotation marks without using the initial condition mechanism*/

\"([^\"\\]|\\.)*\"" return process_token(yytext, "STRING_CONST", yytext, STRING_CONST);

/* I: detecting character constants in single quotes without using the initial condition mechanism*/

\'([^\'\\]|\\.)\''    return process_token(yytext, "CHAR_CONST", yytext, CHAR_CONST);

/* J: detecting single-character ending symbols: operators, punctuation*/

[+\-*/=(),.;:{}]     return process_token(yytext, yytext, "", yytext[0]);

/* K: detecting strings in quotes using initial conditions*/

/* Detect the opening quote and switch to STRING state */
\"                  BEGIN(STRING);

<STRING>[^\"\\\n]*  /* Match any character sequence inside the quotes that is not a backslash or newline */
                    ;

<STRING>\\[^\n]     /* Match escape sequences inside the string */
                    ;

<STRING>\"          { /* Closing quote */
                        BEGIN(INITIAL);
                        return process_token(yytext, "STRING_CONST", yytext, STRING_CONST);
                    }"


/* L: detecting character constants in single quotes using initial conditions*/

\'                  BEGIN(CHAR_CONST_STATE);

<CHAR_CONST_STATE>[^\'\\\n]   /* Match any single character except single quote and newline */
                      ;

<CHAR_CONST_STATE>\\[^\n]      /* Match escape sequences (like \' or \\) */
                      ;

<CHAR_CONST_STATE>\'            { /* Closing single quote */
                                    BEGIN(INITIAL);
                                    return process_token(yytext, "CHAR_CONST", yytext, CHAR_CONST);
                                }'

/* M: removal of multi-line comments using initial conditions*/

/* Detect the opening of a multi-line comment and switch to COMMENT_STATE */
/\*                  BEGIN(COMMENT_STATE);
<COMMENT_STATE>[^*]*; /* Match any characters except for '*' */
<COMMENT_STATE>\*[^/];  /* Match '*' but not the ending '/' */
<COMMENT_STATE>\*/
{ /* Closing multi-line comment */
  BEGIN(INITIAL);
  /* No action needed, comment is ignored */
}


/* N: detecting closing characters for a comment without starting it using start conditions*/
/* Detect an orphaned closing comment */
\*/                 BEGIN(ORPHANED_COMMENT_STATE);

<ORPHANED_COMMENT_STATE>[^*]*; /* Match any characters except '*' */
<ORPHANED_COMMENT_STATE>\*[^/];  /* Match '*' but not the ending '/' */
<ORPHANED_COMMENT_STATE>\*/ 
{ 
  BEGIN(INITIAL);
  printf("Warning: Orphaned closing comment on line %d\n", yylineno);
}


/* O: detecting an open comment with indication of its starting line using conditions
initial*/

%%

int yywrap() {
  return 1; /* konieczne!!! */
}

/* Nazwa:	strnncpy
 * Cel:		Kopiuje zadaną liczbę znaków napisu umieszczając na końcu
 *		znak o kodzie 0.
 * Parametry:	dst		- (o) napis, do którego ma nastąpić kopiowanie;
 *		src		- (i) napis, który ma być kopiowany;
 *		n		- (i) maksymalna liczba znaków do kopiowania.
 * Zwraca:	dst.
 * Uwagi:	strncpy nie umieszcza znaku o kodzie 0 za kopiowanym napisem.
 *		Napis docelowy musi mieć miejsce na dodatkowy n+1 znak.
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

/* Nazwa:       process_token
 * Cel:         Wypisanie informacji o wykrytym elemencie i przekazanie
 *              tej informacji wyżej z ewentualną wartością elementu, jeśli
 *              takowa występuje.
 * Parametry:   text            - (i) tekst, do którego nastąpiło dopasowanie;
 *              TokenType       - (i) napis będący tekstową reprezentacją
 *                                      nazwy typu elementu;
 *              TokenVal        - (i) wartość elementu, o ile występuje;
 *              TokenID         - (i) identyfikator typu elementu zadeklarowany
 *                                      za pomocą dyrektywy %token
 *                                      w pliku modula.y lub kod pojedynczego
 *					znaku (w pliku analizatora składniowego
 *					występuje ujęty w apostrofy).
 * Zwraca:      Identyfikator typu elementu (TokenID).
 * Uwagi:       Informacja o wykrytym elemencie zwracana jest
 *              w trzech kolumnach. W pierwszej wypisywany jest tekst,
 *              do którego nastąpiło dopasowanie, w drugiej - typ elementu,
 *              w trzeciej - wartość elementu (o ile występuje).
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
