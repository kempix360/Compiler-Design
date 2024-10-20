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
%x CHAR_CONST
%x COMMENT
%x ORPHANED_COMMENT_STATE


 /* pomocnicze */

%%

/* B: keywords*/
"AND" return process_token(yytext, "KW_AND", "", KW_AND);
"BEGIN" return process_token(yytext, "KW_BEGIN", "", KW_BEGIN);
"CONST" return process_token(yytext, "KW_CONST", "", KW_CONST);
"DIV" return process_token(yytext, "KW_DIV", "", KW_DIV);
"DO"  return process_token(yytext, "KW_DO", "", KW_DO);
"ELSE"  return process_token(yytext, "KW_ELSE", "", KW_ELSE);
"ELSIF" return process_token(yytext, "KW_ELSIF", "", KW_ELSIF);
"END" return process_token(yytext, "KW_END", "", KW_END);
"FOR" return process_token(yytext, "KW_FOR", "", KW_FOR);
"FROM"  return process_token(yytext, "KW_FROM", "", KW_FROM);
"IF"  return process_token(yytext, "KW_IF", "", KW_IF);
"IMPORT"  return process_token(yytext, "KW_IMPORT", "", KW_IMPORT);
"IN"  return process_token(yytext, "KW_IN", "", KW_IN);
"MOD" return process_token(yytext, "KW_MOD", "", KW_MOD);
"MODULE"  return process_token(yytext, "KW_MODULE", "", KW_MODULE);
"NOT" return process_token(yytext, "KW_NOT", "", KW_NOT);
"OR" return process_token(yytext, "KW_OR", "", KW_OR);
"THEN"  return process_token(yytext, "KW_THEN", "", KW_THEN);
"TYPE"  return process_token(yytext, "KW_TYPE", "", KW_TYPE);
"TO"  return process_token(yytext, "KW_TO", "", KW_TO);
"VAR" return process_token(yytext, "KW_VAR", "", KW_VAR);
"WHILE" return process_token(yytext, "KW_WHILE", "", KW_WHILE);
"REPEAT"  return process_token(yytext, "KW_REPEAT", "", KW_REPEAT);
"UNTIL" return process_token(yytext, "KW_UNTIL", "", KW_UNTIL);
"LOOP"  return process_token(yytext, "KW_LOOP", "", KW_LOOP);
"CASE"  return process_token(yytext, "KW_CASE", "", KW_CASE);
"OF"  return process_token(yytext, "KW_OF", "", KW_OF);
"ARRAY" return process_token(yytext, "KW_ARRAY", "", KW_ARRAY);
"RECORD"  return process_token(yytext, "KW_RECORD", "", KW_RECORD);
"DOWNTO"  return process_token(yytext, "KW_DOWNTO", "", KW_DOWNTO);

/* C: removal of white spaces */

[[:blank:]\n] ;

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

<INITIAL>"\"" BEGIN(STRING);
/* In the STRING state, match any characters except for a double quote and newline */
<STRING>[^"\""\n]*  ;
/* If a closing double quote is found, recognize the string and return to INITIAL state */
<STRING>"\""  {
    return process_token(yytext, "STRING_CONST", yytext, STRING_CONST);
    BEGIN(INITIAL);  /* Return to INITIAL state after recognizing a valid string */
}
/* If a newline character is encountered in the STRING state, it's an unterminated string error */
<STRING>\n  {
    fprintf(stderr, "Error: Unterminated string constant at line %d\n", yylineno);
    BEGIN(INITIAL);  /* Return to INITIAL state */
}
/* Handle end-of-file (EOF) if still in STRING state */
<STRING><<EOF>>  {
    fprintf(stderr, "Error: Unterminated string constant at line %d\n", yylineno);
    BEGIN(INITIAL);  /* Return to INITIAL state */
}

/* L: recognition of character constants in apostrophes using start conditions*/

<INITIAL>"'"  BEGIN(CHAR_CONST);
/* In CHAR_CONST state, match a single character followed by a closing quote */
<CHAR_CONST>[^']"'""  {
    /* Valid character constant found */
    return process_token(yytext, "CHAR_CONST", yytext, CHAR_CONST);
    BEGIN(INITIAL);  /* Return to INITIAL state after recognizing a valid character */
}
/* If a single quote is encountered inside CHAR_CONST without a preceding character, it's an error */
<CHAR_CONST>"'"  {
    fprintf(stderr, "Error: Empty character constant at line %d\n", yylineno);
    BEGIN(INITIAL);
}
/* Handle any unmatched characters in CHAR_CONST state as errors */
<CHAR_CONST>.  {
    fprintf(stderr, "Error: Invalid character constant at line %d\n", yylineno);
    BEGIN(INITIAL);
}
/* Handle end-of-file (EOF) if still in CHAR_CONST state */
<CHAR_CONST><<EOF>>  {
    fprintf(stderr, "Error: Unterminated character constant at line %d\n", yylineno);
    BEGIN(INITIAL);
}

/* M: removal of multi-line comments using start conditions*/

<INITIAL>"/*" BEGIN(COMMENT);
<COMMENT>"*/" BEGIN(INITIAL);
<COMMENT>.  ;
<COMMENT>\n  ;

/* N: detection of comment end sequence without the beginning sequence using start conditions*/

<INITIAL>"*/"  {
    fprintf(stderr, "Error: Comment closing sequence '*/' found without matching opening sequence at line %d\n", yylineno);
}

/* O: detection of failure to close a comment with indications of the line where the comment begins*/

int comment_start_line;  /* Variable to store the line number where the comment starts */

<INITIAL>"/*"  {
    BEGIN(COMMENT);
    comment_start_line = yylineno;
}

<COMMENT>"*/" BEGIN(INITIAL);
<COMMENT>.  ;  /* Ignore all other characters in COMMENT state */
<COMMENT>\n ;  /* Ignore new lines in COMMENT state */
<COMMENT><<EOF>>  {
    /* If we reach the end of the file while still in COMMENT state, it means the comment was not closed */
    fprintf(stderr, "Error: Unclosed multi-line comment starting at line %d\n", comment_start_line);
    BEGIN(INITIAL);  /* Reset to INITIAL state */
}


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
