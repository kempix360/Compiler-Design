%{
#include <stdio.h>
#include <string.h>

#include "defs.h"
#include "x.tab.h"

%}

IDENT    [a-zA-Z:_][a-zA-Z0-9:_-]*

%x ST_COMMENT
%x ST_PI
%x ST_TAG

%%

 /* 1. comments */
"<!--"  BEGIN(ST_COMMENT);
<ST_COMMENT>"-->"      BEGIN(INITIAL);
<ST_COMMENT>[^-]|-[^-] ;
<ST_COMMENT>"-"        ;
<ST_COMMENT>\n         ;

 /* 2. instructions */
"<?"{IDENT}     { BEGIN(ST_PI); strncpy(yylval.s, yytext, MAX_STR_LEN); return PI_TAG_BEG; }

<ST_PI>"?>"     { BEGIN(INITIAL); return PI_TAG_END; }
<ST_PI>.|\n     ;

 /* 3. tags */
"<"{IDENT}     { BEGIN(ST_TAG); strncpy(yylval.s, yytext, MAX_STR_LEN); return STAG_BEG; }
"</"{IDENT}    { BEGIN(ST_TAG); strncpy(yylval.s, yytext, MAX_STR_LEN); return ETAG_BEG; }

<ST_TAG>">"         { BEGIN(INITIAL); return TAG_END; }
<ST_TAG>"/>"        { BEGIN(INITIAL); return ETAG_END; }
<ST_TAG>.|\n        ;

 /* 4. entities */
"&lt;"           { strncpy(yylval.s, "<", MAX_STR_LEN); return CHAR; }
"&gt;"           { strncpy(yylval.s, ">", MAX_STR_LEN); return CHAR; }
"&amp;"          { strncpy(yylval.s, "&", MAX_STR_LEN); return CHAR; }
"&apos;"         { strncpy(yylval.s, "'", MAX_STR_LEN); return CHAR; }
"&quote;"        { strncpy(yylval.s, "\"", MAX_STR_LEN); return CHAR; }


^[ \t]+          ;
\n               return '\n';
\r               ;
[ \t]            { strncpy(yylval.s, yytext, MAX_STR_LEN); return S; }
.                { strncpy(yylval.s, yytext, MAX_STR_LEN); return CHAR; }

%%

int yywrap() {
    if (YY_START == ST_COMMENT) {
        yyerror("Unexpected EOF inside a comment.");
    } else if (YY_START == ST_PI) {
        yyerror("Unexpected EOF inside a processing instruction.");
    } else if (YY_START == ST_TAG) {
        yyerror("Unexpected EOF inside a tag.");
    }
    return 1;
}
