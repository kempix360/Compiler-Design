%{
#include <stdio.h>
#include <string.h>

#include "defs.h"
#include "x.tab.h"

#define CHAR_LITERAL(ch) (strdup(ch))

%}

IDENT    [a-zA-Z:_][a-zA-Z0-9:_-]*

%x ST_COMMENT
%x ST_PI
%x ST_TAG

%%

 /* 1. comments */
"<!--"            { BEGIN(ST_COMMENT); }
<ST_COMMENT>{
    "-->"          { BEGIN(INITIAL); }
    [^-]|-[^-]     { }
    "-"            { }
    \n             { }
}

 /* 2. instructions */
"<?"              { BEGIN(ST_PI); return PI_TAG_BEG; }
<ST_PI>{
    {IDENT}        { strncpy(yylval.s, yytext, MAX_STR_LEN); return IDENT; }
    "?>"           { BEGIN(INITIAL); return PI_TAG_END; }
    .|\n           { }
}

 /* 3. tags */
"<"                { BEGIN(ST_TAG); return STAG_BEG; }
"</"               { BEGIN(ST_TAG); return ETAG_BEG; }

<ST_TAG>{
    {IDENT}        { yylval.s = yytext; return IDENT; }
    ">"            { BEGIN(INITIAL); return TAG_END; }
    "/>"           { BEGIN(INITIAL); return ETAG_END; }
    .|\n           { }
}

 /* 4. entities */
"&lt;"           { yylval.s = CHAR_LITERAL("<"); return CHAR; }
"&gt;"           { yylval.s = CHAR_LITERAL(">"); return CHAR; }
"&amp;"          { yylval.s = CHAR_LITERAL("&"); return CHAR; }
"&apos;"         { yylval.s = CHAR_LITERAL("'"); return CHAR; }
"&quote;"        { yylval.s = CHAR_LITERAL("\""); return CHAR; }


^[ \t]+          { }
\n               { return '\n'; } 
\r               { }
[ \t]            { yylval.s = yytext; return S; }
.                { yylval.s = CHAR_LITERAL(yytext); return CHAR; }

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
