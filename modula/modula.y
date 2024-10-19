%{
#include	<stdio.h>
#include	<string.h>
#define MAX_STR_LEN	100

  int yylex(void);
  void yyerror(const char *txt);
%}

%union {
  char s[ MAX_STR_LEN + 1 ];
  int i;
  double d;
}

%start GRAMMAR
/* keywords */
%token <i> KW_AND KW_BEGIN KW_CONST KW_DIV KW_DO KW_ELSE KW_ELSIF KW_END KW_FOR
%token <i> KW_FROM KW_IF KW_IMPORT KW_IN KW_MOD KW_MODULE KW_NOT KW_PROCEDURE
%token <i> KW_OR KW_THEN KW_TYPE KW_TO KW_VAR KW_WHILE KW_REPEAT KW_UNTIL
%token<i> KW_LOOP KW_CASE KW_OF KW_ARRAY KW_RECORD KW_DOWNTO
/* literal values */
%token <s> STRING_CONST CHAR_CONST
%token <i> INTEGER_CONST
%token <d> REAL_CONST
/* operators */
%token <I> ASSIGN LE GE NEQ RANGE
/* other */
%token <s> IDENT

%left '+' '-' KW_OR
%left '*' '/' KW_DIV KW_MOD KW_AND '&'
%left NEG KW_NOT

%%

 /* GRAMMAR */
GRAMMAR: TOKEN | GRAMMAR TOKEN
	| error
;

TOKEN: KEYWORD | LITERAL_VALUE | OPERATOR | OTHER
;

KEYWORD: KW_AND | KW_BEGIN | KW_CONST | KW_DIV | KW_DO | KW_ELSE | KW_ELSIF
	| KW_END | KW_FOR | KW_FROM | KW_IF | KW_IMPORT | KW_IN | KW_MOD
	| KW_MODULE | KW_NOT | KW_OR | KW_THEN | KW_TYPE | KW_TO | KW_VAR
	| KW_WHILE | KW_REPEAT | KW_UNTIL | KW_LOOP | KW_CASE | KW_OF
	| KW_ARRAY | KW_RECORD | KW_DOWNTO
;

LITERAL_VALUE: STRING_CONST | INTEGER_CONST | REAL_CONST | CHAR_CONST
;

OPERATOR: ASSIGN | LE | GE | NEQ | RANGE
;

OTHER: IDENT | ',' | ';' | '=' | ':' | '(' | ')' | '+' | '*' | '-' | '.' | '|'
	| '<' | '[' | ']'
;

%%

int main( void )
{ 
	printf( "First and Family Name\n" );
	printf( "yytext              Token Type         Token value as string\n\n" );
	yyparse();
	return( 0 ); // OK
}

void yyerror( const char *txt)
{
	printf( "%s\n", txt );
}
