/* A Bison parser, made by GNU Bison 3.8.2.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2021 Free Software Foundation,
   Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <https://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* DO NOT RELY ON FEATURES THAT ARE NOT DOCUMENTED in the manual,
   especially those whose name start with YY_ or yy_.  They are
   private implementation details that can be changed or removed.  */

#ifndef YY_YY_MODULA_TAB_H_INCLUDED
# define YY_YY_MODULA_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token kinds.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    YYEMPTY = -2,
    YYEOF = 0,                     /* "end of file"  */
    YYerror = 256,                 /* error  */
    YYUNDEF = 257,                 /* "invalid token"  */
    KW_AND = 258,                  /* KW_AND  */
    KW_BEGIN = 259,                /* KW_BEGIN  */
    KW_CONST = 260,                /* KW_CONST  */
    KW_DIV = 261,                  /* KW_DIV  */
    KW_DO = 262,                   /* KW_DO  */
    KW_ELSE = 263,                 /* KW_ELSE  */
    KW_ELSIF = 264,                /* KW_ELSIF  */
    KW_END = 265,                  /* KW_END  */
    KW_FOR = 266,                  /* KW_FOR  */
    KW_FROM = 267,                 /* KW_FROM  */
    KW_IF = 268,                   /* KW_IF  */
    KW_IMPORT = 269,               /* KW_IMPORT  */
    KW_IN = 270,                   /* KW_IN  */
    KW_MOD = 271,                  /* KW_MOD  */
    KW_MODULE = 272,               /* KW_MODULE  */
    KW_NOT = 273,                  /* KW_NOT  */
    KW_PROCEDURE = 274,            /* KW_PROCEDURE  */
    KW_OR = 275,                   /* KW_OR  */
    KW_THEN = 276,                 /* KW_THEN  */
    KW_TYPE = 277,                 /* KW_TYPE  */
    KW_TO = 278,                   /* KW_TO  */
    KW_VAR = 279,                  /* KW_VAR  */
    KW_WHILE = 280,                /* KW_WHILE  */
    KW_REPEAT = 281,               /* KW_REPEAT  */
    KW_UNTIL = 282,                /* KW_UNTIL  */
    KW_LOOP = 283,                 /* KW_LOOP  */
    KW_CASE = 284,                 /* KW_CASE  */
    KW_OF = 285,                   /* KW_OF  */
    KW_ARRAY = 286,                /* KW_ARRAY  */
    KW_RECORD = 287,               /* KW_RECORD  */
    KW_DOWNTO = 288,               /* KW_DOWNTO  */
    STRING_CONST = 289,            /* STRING_CONST  */
    CHAR_CONST = 290,              /* CHAR_CONST  */
    INTEGER_CONST = 291,           /* INTEGER_CONST  */
    REAL_CONST = 292,              /* REAL_CONST  */
    ASSIGN = 293,                  /* ASSIGN  */
    LE = 294,                      /* LE  */
    GE = 295,                      /* GE  */
    NEQ = 296,                     /* NEQ  */
    RANGE = 297,                   /* RANGE  */
    IDENT = 298,                   /* IDENT  */
    NEG = 299                      /* NEG  */
  };
  typedef enum yytokentype yytoken_kind_t;
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{
#line 12 "modula.y"

  char s[ MAX_STR_LEN + 1 ];
  int i;
  double d;

#line 114 "modula.tab.h"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;


int yyparse (void);


#endif /* !YY_YY_MODULA_TAB_H_INCLUDED  */
