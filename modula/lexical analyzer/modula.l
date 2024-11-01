%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#define MAX_STR_LEN	100
#include "modula.tab.h"
int process_token(const char *text, const char *TokenType,
		  const char *TokenVal, const int TokenID); 
char *strnncpy(char *dst, const char *src, const int n);

int comment_close_line;
int comment_start_line;
%}

%option yylineno
 /* stany analizatora leksykalnego (INITIAL jest zdefiniowany) */
%x DOUBLE_QUOTE
%x SINGLE_QUOTE
%x COMMENT


 /* pomocnicze */

%%

 /* B: keywords*/
AND return process_token(yytext, "KW_AND", "", KW_AND);
BEGIN return process_token(yytext, "KW_BEGIN", "", KW_BEGIN);
CONST return process_token(yytext, "KW_CONST", "", KW_CONST);
DIV return process_token(yytext, "KW_DIV", "", KW_DIV);
DO  return process_token(yytext, "KW_DO", "", KW_DO);
ELSE  return process_token(yytext, "KW_ELSE", "", KW_ELSE);
ELSIF return process_token(yytext, "KW_ELSIF", "", KW_ELSIF);
END return process_token(yytext, "KW_END", "", KW_END);
FOR return process_token(yytext, "KW_FOR", "", KW_FOR);
FROM  return process_token(yytext, "KW_FROM", "", KW_FROM);
IF  return process_token(yytext, "KW_IF", "", KW_IF);
IMPORT  return process_token(yytext, "KW_IMPORT", "", KW_IMPORT);
IN  return process_token(yytext, "KW_IN", "", KW_IN);
MOD return process_token(yytext, "KW_MOD", "", KW_MOD);
MODULE  return process_token(yytext, "KW_MODULE", "", KW_MODULE);
NOT return process_token(yytext, "KW_NOT", "", KW_NOT);
OR return process_token(yytext, "KW_OR", "", KW_OR);
THEN  return process_token(yytext, "KW_THEN", "", KW_THEN);
TYPE  return process_token(yytext, "KW_TYPE", "", KW_TYPE);
TO  return process_token(yytext, "KW_TO", "", KW_TO);
VAR return process_token(yytext, "KW_VAR", "", KW_VAR);
WHILE return process_token(yytext, "KW_WHILE", "", KW_WHILE);
REPEAT  return process_token(yytext, "KW_REPEAT", "", KW_REPEAT);
UNTIL return process_token(yytext, "KW_UNTIL", "", KW_UNTIL);
LOOP  return process_token(yytext, "KW_LOOP", "", KW_LOOP);
CASE  return process_token(yytext, "KW_CASE", "", KW_CASE);
OF  return process_token(yytext, "KW_OF", "", KW_OF);
ARRAY return process_token(yytext, "KW_ARRAY", "", KW_ARRAY);
RECORD  return process_token(yytext, "KW_RECORD", "", KW_RECORD);
DOWNTO  return process_token(yytext, "KW_DOWNTO", "", KW_DOWNTO);

 /* C: removal of white spaces */
[[:blank:]\n] ;

 /* D: detecting multi-char operators*/
"<="  return process_token(yytext, "LE", "", LE);
">="  return process_token(yytext, "GE", "", GE);
"!="  return process_token(yytext, "NEQ", "", NEQ);
":="  return process_token(yytext, "ASSIGN", "", ASSIGN);
".."  return process_token(yytext, "RANGE", "", RANGE);

 /* E: detecting identifiers*/
[[:alpha:]][[:alpha:][:digit:]]* return process_token(yytext, "IDENT", yytext, IDENT);

 /* F: detecting integers*/
[[:digit:]]+  return process_token(yytext, "INTEGER_CONST", yytext, INTEGER_CONST);

 /* G: detecting real numbers*/
[[:digit:]][[:digit:]]*\.[[:digit:]]*([eE][-+]?[[:digit:]]+)?  return process_token(yytext, "FLOAT_CONST", yytext, REAL_CONST);

 /* H: detecting text constants (strings) in quotation marks without using the initial condition mechanism*/
\"[^\"\n]*\" return process_token(yytext, "STRING_CONST", yytext, STRING_CONST);

 /* I: detecting character constants in single quotes without using the initial condition mechanism*/
\'[^\'\n]\' return process_token(yytext, "CHAR_CONST", yytext, CHAR_CONST);

 /* J: detecting single-character ending symbols: operators, punctuation*/
[+\-*/=()\[\],.;<|:]  return process_token(yytext, yytext, "", yytext[0]);

 /* K: detecting strings in quotes using initial conditions*/
<INITIAL>\" BEGIN(DOUBLE_QUOTE);
<DOUBLE_QUOTE>[^\"\n]*  ;
<DOUBLE_QUOTE>\"  {
    return process_token(yytext, "STRING_CONST", yytext, STRING_CONST);
    BEGIN(INITIAL);
}
<DOUBLE_QUOTE>\n  {
    printf("Unterminated double quote in line %d\n", yylineno);
    BEGIN(INITIAL);
}
<DOUBLE_QUOTE><<EOF>>  {
    printf("Unterminated double quote in line %d\n", yylineno);
    yyterminate();
}

 /* L: recognition of character constants in apostrophes using start conditions*/
<INITIAL>\'  BEGIN(SINGLE_QUOTE);
<SINGLE_QUOTE>[^\'\n]\'  {
    return process_token(yytext, "CHAR_CONST", yytext, CHAR_CONST);
    BEGIN(INITIAL);
}
<SINGLE_QUOTE>[^\'\n]{2,}\'  {
    printf("Single quote opened in line %d not closed\n", yylineno)  ;
    BEGIN(INITIAL);
}
<SINGLE_QUOTE><<EOF>>  {
    printf("Unterminated single quote in line %d\n", yylineno);
    BEGIN(INITIAL);
}

 /* M: removal of multi-line comments using start conditions*/
<INITIAL>"(*"  {
    BEGIN(COMMENT);
    comment_start_line = yylineno;
}
<COMMENT>.  ;
<COMMENT>\n  ;
<COMMENT>"*)" BEGIN(INITIAL);

 /* N: detection of comment end sequence without the beginning sequence using start conditions*/
<INITIAL>"*)" printf("Comment closed in line %d when none opened\n", yylineno);

 /* O: detection of failure to close a comment with indications of the line where the comment begins*/

<COMMENT><<EOF>>  {
    printf("Comment opened in line %d not closed\n", comment_start_line);
    yyterminate();
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
