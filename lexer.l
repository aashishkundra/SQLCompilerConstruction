alpha [a-zA-Z]
alphanumeric [a-zA-Z0-9]
integer [0-9]
posinteger [1-9]
%{
#include<stdio.h>
#include "y.tab.h"
void yyerror(char *);
extern char* yytext;
%}


%%
-1 { return END; }
BABY { return BABY; }
mymql[' ']-u[' ']admin[' ']-p[' ']lala { return LOGIN; }
['\n'] { return NEWLINE; }
[' '] { }
[';'] { return SEMICOLON; }
[','] { return COMMA; }
QUIT { return QUIT; }
quit { return QUIT; }
AND { return AND; }
and {return AND; }
OR { return OR; }
or { return OR; }
IN { return IN; }
in { return IN; }
SET { return SET; }
set { return SET; }
TO { return TO; }
to { return TO; }
WHERE { return WHERE; }
where { return WHERE; }
FROM { return FROM; }
from { return FROM; }
INSERT { return INSERT; }
insert { return INSERT; }
RECORD { return RECORD; }
record { return RECORD; }
INTO { return INTO; }
into { return INTO; }
DNUM { return DNUM; }
dnum { return DNUM; }
DNAME { return DNAME; }
dname { return DNAME; }
DELETE {return DELETE; }
delete { return DELETE; }
GET { return GET; }
get { return GET; }
UPDATE { return UPDATE; }
update { return UPDATE; }
DLOCATION { return DLOCATION; }
dlocation { return DLOCATION; }
EID { return EID; }
eid { return EID; }
ENAME { return ENAME; }
ename { return ENAME; }
EAGE { return EAGE; }
eage { return EAGE; }
EADDRESS { return EADDRESS; }
eaddress { return EADDRESS; }
SALARY { return SALARY; }
salary { return SALARY; }
DEPTNO { return DEPTNO; }
deptno { return DEPTNO; }
">=" { yylval.sval = strdup(yytext); return OPERATOR;}
"<=" { yylval.sval = strdup(yytext); return OPERATOR;}
"=" { yylval.sval = strdup(yytext); return OPERATOR;}
"<" { yylval.sval = strdup(yytext); return OPERATOR;}
">" { yylval.sval = strdup(yytext); return OPERATOR;}
([_]|{alpha})({alphanumeric}|[_]|[$])*.txt { yylval.sval = strdup(yytext); return FILENAME; }
{posinteger}{integer}* { yylval.ival = atoi(yytext);   return INTVALUE; }
{integer} { yylval.ival = atoi(yytext);   return INTVALUE; }
([_]|{alpha})({alphanumeric}|[_]|[$])* { yylval.sval = strdup(yytext);  return STRVALUE; }
%%

