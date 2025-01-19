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

 /* 1. deleting comments */
"<!--"            { BEGIN(ST_COMMENT); }
<ST_COMMENT>{
    "-->"          { BEGIN(INITIAL); }
    [^-]|-[^-]     { /* ignore */ }
    "-"            { /* ignore */ }
    \n             { /* ignore */ }
    <<EOF>>        { yyerror("Unclosed comment!"); return 0; }
}

 /* 2. instruction detection */
"<?"              { BEGIN(ST_PI); return PI_TAG_BEG; }
<ST_PI>{
    {IDENT}           { yylval.str = strdup(yytext); return IDENT; }
    "?>"           { BEGIN(INITIAL); return PI_TAG_END; }
    .|\n           { /* ignore */ }
    <<EOF>>        { yyerror("Unclosed instruction!"); return 0; }
}

 /* 3. tag detection */
"<"               { BEGIN(ST_TAG); return '<'; }
"</"              { BEGIN(ST_TAG); return ETAG_BEG; }

<ST_TAG>{
    {IDENT}           { yylval.str = strdup(yytext); return IDENT; }
    ">"            { BEGIN(INITIAL); return TAG_END; }
    "/>"           { BEGIN(INITIAL); return ETAG_END; }
    .|\n           { /* ignore */ }
    <<EOF>>        { yyerror("Unclosed tag!"); return 0; }
}

 /* 4. entity detection */
"&lt;"           { yylval.str = CHAR_LITERAL("<"); return CHAR; }
"&gt;"           { yylval.str = CHAR_LITERAL(">"); return CHAR; }
"&amp;"          { yylval.str = CHAR_LITERAL("&"); return CHAR; }
"&apos;"         { yylval.str = CHAR_LITERAL("'"); return CHAR; }
"&quote;"        { yylval.str = CHAR_LITERAL("\""); return CHAR; }


[ \t]+           { }
\n               { return '\n'; } 
\r               { }
[ \t]            { yylval.str = CHAR_LITERAL(yytext); return S; }
.                { yylval.str = CHAR_LITERAL(yytext); return CHAR; }

%%

int yywrap() {
    fprintf(stderr, "Unexpected EOF");
    return 1;
}
