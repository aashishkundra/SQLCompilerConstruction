%token FILENAME ename eid eaddress salary deptno eage VALUE RELOP GET FROM WHERE AND OR COMMA UPDATE DELETE INSERT RECORD INTO SET IN LEFT_BRAC RIGHT_BRAC TO
%{
#include <stdio.h>
int yylex();
int yyerror(char *s);    
%}


%%
E: INSTR {printf("VALID EXP");}
;
INSTR: GET_nt {printf("CONDINSTR");}
     | INS
     | UPD
     | DEL
;
GET_nt: GET F FROM FILENAME WHERE COND {printf("getnt reached\n");}
;
DEL: DELETE RECORD FROM FILENAME WHERE COND {printf("Del Reached");} 
;
INS: INSERT RECORD LEFT_BRAC F RIGHT_BRAC INTO FILENAME {printf("ins reached");}
;
UPD: UPDATE RECORD IN LEFT_BRAC F RIGHT_BRAC FILENAME SET F TO VALUE WHERE COND {printf("Update reached");}
;
COND: COND_T AND COND {printf("and reached");}
    | COND_T OR COND {printf("jhfalksfj\n");}
    | COND_T 
;
COND_T: FIELD RELOP VALUE {printf("condt reached\n");}
;
F: FIELD COMMA F
 | FIELD
;
FIELD: ename 
      |eage {printf("eage reached\n");}
      |eid {printf("eid reached\n");}
      |eaddress {printf("eaddress reached\n");}
      |salary {printf("salary reached\n");}
      |deptno {printf("deptno reached\n");}
;
%%