%{
#include<stdio.h>
#include<string.h>
#include<stdlib.h>
int yylex(void);
void yyerror(char*);
int primarykeyemp[100];
int primarykeyempsize = 0;
int primarykeydept[100];
int primarykeydeptsize = 0;
int getflag = -1;
int type;
int dnums;
char dnames[100];
char dlocations[100];
int eids;
char enames[100];
int eages;
char eaddresss[100];
int salarys;
int deptnos;
char filenames[100] = "DEPT.txt";
enum dept_attribute { dnum, dname, dlocation};
enum emp_attribute { eid, ename, eage, eaddress, salary, deptno };
enum dept_attribute dept_delete_attribute[100];
enum emp_attribute emp_delete_attribute[100];
char dept_delete_values[100][100];
char emp_delete_values[100][100];
char dept_delete_op[100][10];
char emp_delete_op[100][100];
int dept_delete_count = 0;
int emp_delete_count = 0;
enum dept_attribute dept_update_attribute[100];
enum emp_attribute emp_update_attribute[100];
char dept_update_values[100][100];
char emp_update_values[100][100];
char dept_update_op[100][10];
char emp_update_op[100][100];
int dept_update_count = 0;
int emp_update_count = 0;
char deptupdatevalue[100];
char empupdatevalue[100];
enum dept_attribute deptupdateattribute;
enum emp_attribute empupdateattribute;
enum dept_attribute dept_get_attribute[100];
enum emp_attribute emp_get_attribute[100];
char dept_get_values[100][100];
char emp_get_values[100][100];
char dept_get_op[100][10];
char emp_get_op[100][100];
int dept_get_count = 0;
int emp_get_count = 0;
enum dept_attribute deptgetattribute[100];
enum emp_attribute empgetattribute[100];
int deptgetattributecount = 0; 
int empgetattributecount = 0;
int getiddept[100];
int getiddeptcount = 0;
int getidemp[100];
int getidempcount = 0;
%}

%union{
	int ival;
	char* sval;
}

%type <sval> STRVALUE
%type <sval> FILENAME
%type <ival> INTVALUE
%type <sval> valuesinsert
%type <ival> DNUM
%type <sval> DNAME
%type <sval> DLOCATION
%type <ival> EID
%type <sval> ENAME
%type <sval> EADDRESS
%type <ival> EAGE
%type <ival> SALARY
%type <ival> DEPTNO
%type <sval> OPERATOR
%type <sval> delconditionsall
%type <sval> delconditionsalldept
%type <sval> delconditionsallemp
%type <sval> delconditionsanddept
%type <sval> delconditionsandemp
%type <sval> delconditiondept
%type <sval> delconditionemp
%type <sval> updconditionsall
%type <sval> updconditionsallemp
%type <sval> updconditionsalldept
%type <sval> updconditionsandemp
%type <sval> updconditionsanddept
%type <sval> updconditiondept
%type <sval> updconditionemp
%type <sval> updation
%type <sval> EQUALS
%type <sval> LOGIN
%type <sval> valuesinsertemp
%type <sval> valuesinsertdept

%token INSERT RECORD INTO DNUM DNAME DLOCATION INPUT FILENAME INTVALUE STRVALUE DELETE GET UPDATE SPACE SEMICOLON COMMA FROM WHERE AND OR EQUALS IN SET TO NEWLINE QUIT LOGIN BABY EID ENAME EAGE EADDRESS SALARY DEPTNO END OPERATOR
%start program

%%
program: LOGIN NEWLINE { printf("WELCOME!\n"); printf("MYMQL>"); }  queries

queries: query NEWLINE  { printf("MYMQL> "); }  queries | QUIT { return 0; } | END { return 0; }

query: INSERT queryinsert { 
								if( strcmp(filenames,"DEPT.txt") == 0 )
								{
									FILE* outputfile = fopen(filenames,"a");
									if( outputfile == NULL )
										printf("failed to open file\n");
									else
									{
										int primflag = 0;
										for(int i=0;i<primarykeydeptsize;i++)
										{
											if( primarykeydept[i] == dnums )
											{
												primflag = 1;
												break;
											}
										}
										if( !primflag )
										{
											char result[10];
											sprintf(result, "%d", dnums);
											fputs(result, outputfile);
											fputs(",",outputfile);
											fputs(dnames,outputfile);
											fputs(",",outputfile);
											fputs(dlocations,outputfile);
											fputs("\n", outputfile);
											fclose(outputfile);
											primarykeydept[primarykeydeptsize-1] = dnums;
											primarykeydeptsize++;
										}
										else
											printf("Primary key constraint violated---query not inserted\n");
									}
								}
								else if ( strcmp(filenames,"EMP.txt") == 0)
								{
									
									FILE* outputfile = fopen(filenames,"a");
									if( outputfile == NULL )
										printf("failed to open file\n");
									else
									{
										int primflag = 0;
										for(int i=0;i<primarykeyempsize;i++)
										{
											if( primarykeyemp[i] == dnums )
											{
												primflag = 1;
												break;
											}
										}
										int foreignflag = 0;
										for(int i=0;i<primarykeydeptsize;i++)
										{
											if( primarykeydept[i] == dnums )
											{
												foreignflag = 1;
												break;
											}
										}
										if( !primflag && foreignflag)
										{
											char result[10];
											sprintf(result, "%d",eids );
											fputs(result, outputfile);
											fputs(",",outputfile); 	
											fputs(enames,outputfile);
											fputs(",",outputfile);
											sprintf(result, "%d",eages );
											fputs(result, outputfile);
											fputs(",",outputfile);
											fputs(eaddresss,outputfile);
											fputs(",",outputfile);
											sprintf(result, "%d",salarys );
											fputs(result, outputfile);
											fputs(",",outputfile);
											sprintf(result, "%d",deptnos );
											fputs(result, outputfile);
											fputs("\n", outputfile);
											fclose(outputfile);
											primarykeyemp[primarykeyempsize-1] = dnums;
											primarykeyempsize++;
										}
										else if( primflag && !foreignflag )
											printf("Primary key and Foreign key constraint violated---query not inserted\n");
										else if( primflag )
											printf("Primary key constraint violated---query not inserted\n");
										else
											printf("Foreign key constraint violated---query not inserted\n");
										
									}
								}
								else
								{
									printf("Invalid file name\n");
								}
							}
	  | DELETE querydelete	{ memset(dept_delete_attribute,-1,sizeof(dept_delete_attribute)); } 										 
	  | GET queryget 
	  | UPDATE queryupdate { deptupdateattribute = -1; }


queryinsert: RECORD valuesinsert INTO FILENAME SEMICOLON {  printf("%s\n",$4); strcpy(filenames,$4); } 
		   										 
valuesinsert:  valuesinsertdept | valuesinsertemp

valuesinsertemp: INTVALUE COMMA STRVALUE COMMA INTVALUE COMMA STRVALUE COMMA INTVALUE COMMA INTVALUE  { eids = $1;
																										strcpy(enames,$3);
																										eages = $5;
																										strcpy(eaddresss,$7);
																										salarys = $9;
																										deptnos = $11;
																										}


valuesinsertdept: INTVALUE COMMA STRVALUE COMMA STRVALUE  { dnums = $1;
															strcpy(dnames,$3);
															strcpy(dlocations,$5);
													  		} 
													  

querydelete: RECORD FROM FILENAME WHERE  {  printf("%s\n",$3);
											strcpy(filenames,$3);
										}  
										delconditionsall SEMICOLON  
			
delconditionsall: delconditionsallemp | delconditionsalldept 

delconditionsalldept: delconditionsalldept OR delconditionsanddept {	
			 					if( strcmp(filenames,"DEPT.txt") == 0 )
								{	
									printf("im in\n");
									FILE* filenew = fopen("temp.txt","a");
									FILE* fileinput = fopen(filenames,"r");
									char c = getc(fileinput);
									char linevalues[3][100];
									int i = 0, j =0;
									while( c != EOF )
									{
										if( c =='\n' )
										{
											linevalues[i][j] = '\0';
											int flag = 1;
												
											for(int k=0;k<dept_delete_count;k++)
											{
												if( strcmp(dept_delete_op[k],"=") == 0 )
												{
													if( strcmp(linevalues[dept_delete_attribute[k]],dept_delete_values[k]) != 0) 
													{
														flag = 0;
														break;
													}
												}
												else if( strcmp(dept_delete_op[k],">=") == 0  )
												{
													if( ! (strcmp( linevalues[dept_delete_attribute[k]],dept_delete_values[k]) >= 0) ) 
													{
														flag = 0;
														break;
													}	
												}
												else if( strcmp(dept_delete_op[k],"<=") == 0  )
												{
													if( ! (strcmp( linevalues[dept_delete_attribute[k]],dept_delete_values[k]) <= 0) ) 
													{
														flag = 0;
														break;
													}
												}
												else if( strcmp(dept_delete_op[k],">") == 0  )
												{
													if( ! (strcmp( linevalues[dept_delete_attribute[k]],dept_delete_values[k]) > 0) ) 
													{
														flag = 0;
														break;
													}
												}
												else if( strcmp(dept_delete_op[k],"<") == 0  )
												{
													if( ! (strcmp( linevalues[dept_delete_attribute[k]],dept_delete_values[k]) < 0) ) 
													{
														flag = 0;
														break;
													}
												}
												else
												{
														continue;
												}
											}
											
											if( flag == 0)
											{
												fprintf(filenew, "%s,%s,%s\n", linevalues[0],linevalues[1],linevalues[2]);
											}
											else
											{
												for(int i=0;i<primarykeydeptsize;i++)
												{
													char result[100];
													sprintf(result,"%d",primarykeydept[i]);
													if( strcmp(result,linevalues[0]) == 0 )
													{
														primarykeydept[i] = primarykeydept[primarykeydeptsize-1];
														primarykeydeptsize--;
														break;
													}
												}
											}
											
											i = 0;
											j = 0;
											c = getc(fileinput);
											continue;
										}

										if( c == ',')
										{
											linevalues[i][j] = '\0';
											i++;
											j=0;
											c = getc(fileinput);
											continue;
										}
										
										linevalues[i][j++] = c;
										c = getc(fileinput);
									}
									dept_delete_count = 0;
									fclose(fileinput);
									fclose(filenew);
									if (remove("DEPT.txt") == 0) 
										printf("Deleted successfully\n"); 
									else
										printf("Unable to delete the file"); 
									int value = rename("temp.txt","DEPT.txt");
								}
								else if ( strcmp(filenames,"EMP.txt") == 0 )
								{

								}
								else
								{

								}
							}
			 | delconditionsanddept {	
				 				if( strcmp(filenames,"DEPT.txt") == 0 )
								 {	
									printf("im in\n");
									FILE* filenew = fopen("temp.txt","a");
									FILE* fileinput = fopen(filenames,"r");
									char c = getc(fileinput);
									char linevalues[3][100];
									int i = 0, j =0;
									while( c != EOF )
									{
										if( c =='\n' )
										{
											linevalues[i][j] = '\0';
											int flag = 1;
												
											for(int k=0;k<dept_delete_count;k++)
											{
												if( strcmp(dept_delete_op[k],"=") == 0 )
												{
													if( strcmp(linevalues[dept_delete_attribute[k]],dept_delete_values[k]) != 0) 
													{
														flag = 0;
														break;
													}
												}
												else if( strcmp(dept_delete_op[k],">=") == 0  )
												{
													printf("mofo");
													if( strcmp( linevalues[dept_delete_attribute[k]],dept_delete_values[k]) < 0 ) 
													{
														flag = 0;
														break;
													}	
												}
												else if( strcmp(dept_delete_op[k],"<=") == 0  )
												{
													if( strcmp( linevalues[dept_delete_attribute[k]],dept_delete_values[k]) > 0 ) 
													{
														flag = 0;
														break;
													}
												}
												else if( strcmp(dept_delete_op[k],">") == 0  )
												{
													if( strcmp( linevalues[dept_delete_attribute[k]],dept_delete_values[k]) <= 0 ) 
													{
														flag = 0;
														break;
													}
												}
												else if( strcmp(dept_delete_op[k],"<") == 0  )
												{
													if( strcmp( linevalues[dept_delete_attribute[k]],dept_delete_values[k]) >= 0 ) 
													{
														flag = 0;
														break;
													}
												}
												else
												{
														continue;
												}
											}
											
											if( flag == 0)
											{
												fprintf(filenew, "%s,%s,%s\n", linevalues[0],linevalues[1],linevalues[2]);
											}
											else
											{
												for(int i=0;i<primarykeydeptsize;i++)
												{
													char result[100];
													sprintf(result,"%d",primarykeydept[i]);
													if( strcmp(result,linevalues[0]) == 0 )
													{
														primarykeydept[i] = primarykeydept[primarykeydeptsize-1];
														primarykeydeptsize--;
														break;
													}
												}
											}

											i = 0;
											j = 0;
											c = getc(fileinput);
											continue;
										}

										if( c == ',')
										{
											linevalues[i][j] = '\0';
											i++;
											j=0;
											c = getc(fileinput);
											continue;
										}
										
										linevalues[i][j++] = c;
										c = getc(fileinput);
									}
									dept_delete_count = 0;
									fclose(fileinput);
									fclose(filenew);
									if (remove("DEPT.txt") == 0) 
										printf("Deleted successfully\n"); 
									else
										printf("Unable to delete the file"); 
									int value = rename("temp.txt","DEPT.txt");
								 }
								 else if( strcmp(filenames,"EMP.txt") == 0 )
								 {

								 }	
								 else
								 {

								 }
							}
							
 			
delconditionsanddept: delconditionsanddept AND delconditiondept 
			 | delconditiondept { printf("mamammaaaaa"); }
			
delconditiondept: DNAME OPERATOR STRVALUE {  
							if( strcmp(filenames,"DEPT.txt") == 0 )
							{
								printf("mama");
								dept_delete_attribute[dept_delete_count] = dname; 
								strcpy(dept_delete_op[dept_delete_count],$2); 
								strcpy(dept_delete_values[dept_delete_count],$3);
								dept_delete_count++;
								int p = dept_delete_count-1;
								printf("haha:%d,%s,%s\n",dept_delete_attribute[p],dept_delete_op[p],dept_delete_values[p]);
							}
							else if( strcmp(filenames,"EMP.txt") == 0 )
							{

							}
							else
							{

							}
						}

		| DNUM OPERATOR INTVALUE {  
							if( strcmp(filenames,"DEPT.txt") == 0 )
							{	
								dept_delete_attribute[dept_delete_count] = dnum; 
								strcpy(dept_delete_op[dept_delete_count],$2); 
								char numtostr[100];
								sprintf(numtostr,"%d",$3);
								strcpy(dept_delete_values[dept_delete_count],numtostr);
								dept_delete_count++;
								int p = dept_delete_count-1;
								printf("haha:%d,%s,%s\n",dept_delete_attribute[p],dept_delete_op[p],dept_delete_values[p]);
							}
							else if( strcmp(filenames,"EMP.txt") == 0 )
							{

							}
							else
							{

							}
						  }
		 | DLOCATION OPERATOR STRVALUE {  
								if( strcmp(filenames,"DEPT.txt") == 0 )
								{	
									dept_delete_attribute[dept_delete_count] = dlocation; 
									strcpy(dept_delete_op[dept_delete_count],$2); 
									strcpy(dept_delete_values[dept_delete_count],$3);
									dept_delete_count++;
									int p = dept_delete_count-1;
									printf("haha:%d,%s,%s\n",dept_delete_attribute[p],dept_delete_op[p],dept_delete_values[p]);
								}
								else if( strcmp(filenames,"EMP.txt") == 0 )
								{

								}
								else
								{

								}
						  }

delconditionsallemp: delconditionsallemp OR delconditionsandemp {	
			 					if( strcmp(filenames,"EMP.txt") == 0 )
								{	
									printf("im in\n");
									FILE* filenew = fopen("temp.txt","a");
									FILE* fileinput = fopen(filenames,"r");
									char c = getc(fileinput);
									char linevalues[6][100];
									int i = 0, j =0;
									while( c != EOF )
									{
										if( c =='\n' )
										{
											linevalues[i][j] = '\0';
											int flag = 1;
												
											for(int k=0;k<emp_delete_count;k++)
											{
												if( strcmp(emp_delete_op[k],"=") == 0 )
												{
													if( strcmp(linevalues[emp_delete_attribute[k]],emp_delete_values[k]) != 0) 
													{
														flag = 0;
														break;
													}
												}
												else if( strcmp(emp_delete_op[k],">=") == 0  )
												{
													printf("mofo");
													if( strcmp( linevalues[emp_delete_attribute[k]],emp_delete_values[k]) < 0 ) 
													{
														flag = 0;
														break;
													}	
												}
												else if( strcmp(emp_delete_op[k],"<=") == 0  )
												{
													if( strcmp( linevalues[emp_delete_attribute[k]],emp_delete_values[k]) > 0 ) 
													{
														flag = 0;
														break;
													}
												}
												else if( strcmp(emp_delete_op[k],">") == 0  )
												{
													if( strcmp( linevalues[emp_delete_attribute[k]],emp_delete_values[k]) <= 0 ) 
													{
														flag = 0;
														break;
													}
												}
												else if( strcmp(emp_delete_op[k],"<") == 0  )
												{
													if( strcmp( linevalues[emp_delete_attribute[k]],emp_delete_values[k]) >= 0 ) 
													{
														flag = 0;
														break;
													}
												}
												else
												{
														continue;
												}
											}
											
											if( flag == 0)
											{
												fprintf(filenew, "%s,%s,%s,%s,%s,%s\n", linevalues[0],linevalues[1],linevalues[2],linevalues[3],linevalues[4],linevalues[5]);
											}
											else
											{
												for(int i=0;i<primarykeyempsize;i++)
												{
													char result[100];
													sprintf(result,"%d",primarykeyemp[i]);
													if( strcmp(result,linevalues[0]) == 0 )
													{
														primarykeyemp[i] = primarykeyemp[primarykeyempsize-1];
														primarykeyempsize--;
														break;
													}
												}
											}
											
											i = 0;
											j = 0;
											c = getc(fileinput);
											continue;
										}

										if( c == ',')
										{
											linevalues[i][j] = '\0';
											i++;
											j=0;
											c = getc(fileinput);
											continue;
										}
										
										linevalues[i][j++] = c;
										c = getc(fileinput);
									}
									emp_delete_count = 0;
									fclose(fileinput);
									fclose(filenew);
									if (remove("EMP.txt") == 0) 
										printf("Deleted successfully\n"); 
									else
										printf("Unable to delete the file"); 
									int value = rename("temp.txt","EMP.txt");
								}
								else if ( strcmp(filenames,"DEPT.txt") == 0 )
								{

								}
								else
								{

								}
							}
				   | delconditionsandemp {	
			 					if( strcmp(filenames,"EMP.txt") == 0 )
								{	
									printf("im in\n");
									FILE* filenew = fopen("temp.txt","a");
									FILE* fileinput = fopen(filenames,"r");
									char c = getc(fileinput);
									char linevalues[6][100];
									int i = 0, j =0;
									while( c != EOF )
									{
										if( c =='\n' )
										{
											linevalues[i][j] = '\0';
											int flag = 1;
												
											for(int k=0;k<emp_delete_count;k++)
											{
												if( strcmp(emp_delete_op[k],"=") == 0 )
												{
													if( strcmp(linevalues[emp_delete_attribute[k]],emp_delete_values[k]) != 0) 
													{
														flag = 0;
														break;
													}
												}
												else if( strcmp(emp_delete_op[k],">=") == 0  )
												{
													printf("mofo");
													if( strcmp( linevalues[emp_delete_attribute[k]],emp_delete_values[k]) < 0 ) 
													{
														flag = 0;
														break;
													}	
												}
												else if( strcmp(emp_delete_op[k],"<=") == 0  )
												{
													if( strcmp( linevalues[emp_delete_attribute[k]],emp_delete_values[k]) > 0 ) 
													{
														flag = 0;
														break;
													}
												}
												else if( strcmp(emp_delete_op[k],">") == 0  )
												{
													if( strcmp( linevalues[emp_delete_attribute[k]],emp_delete_values[k]) <= 0 ) 
													{
														flag = 0;
														break;
													}
												}
												else if( strcmp(emp_delete_op[k],"<") == 0  )
												{
													if( strcmp( linevalues[emp_delete_attribute[k]],emp_delete_values[k]) >= 0 ) 
													{
														flag = 0;
														break;
													}
												}
												else
												{
														continue;
												}
											}
											
											if( flag == 0)
											{
												fprintf(filenew, "%s,%s,%s,%s,%s,%s\n", linevalues[0],linevalues[1],linevalues[2],linevalues[3],linevalues[4],linevalues[5]);
											}
											else
											{
												for(int i=0;i<primarykeyempsize;i++)
												{
													char result[100];
													sprintf(result,"%d",primarykeyemp[i]);
													if( strcmp(result,linevalues[0]) == 0 )
													{
														primarykeyemp[i] = primarykeyemp[primarykeyempsize-1];
														primarykeyempsize--;
														break;
													}
												}
											}
											
											i = 0;
											j = 0;
											c = getc(fileinput);
											continue;
										}

										if( c == ',')
										{
											linevalues[i][j] = '\0';
											i++;
											j=0;
											c = getc(fileinput);
											continue;
										}
										
										linevalues[i][j++] = c;
										c = getc(fileinput);
									}
									emp_delete_count = 0;
									fclose(fileinput);
									fclose(filenew);
									if (remove("EMP.txt") == 0) 
										printf("Deleted successfully\n"); 
									else
										printf("Unable to delete the file"); 
									int value = rename("temp.txt","EMP.txt");
								}
								else if ( strcmp(filenames,"DEPT.txt") == 0 )
								{

								}
								else
								{

								}
							}

delconditionsandemp: delconditionsandemp AND delconditionemp 
			 	   | delconditionemp 

delconditionemp: EID OPERATOR INTVALUE {  
								if( strcmp(filenames,"EMP.txt") == 0 )
								{	
									emp_delete_attribute[emp_delete_count] = eid; 
									strcpy(emp_delete_op[emp_delete_count],$2); 
									char numtostr[100];
									sprintf(numtostr,"%d",$3);
									strcpy(emp_delete_values[emp_delete_count],numtostr);
									emp_delete_count++;
									int p = emp_delete_count-1;
									printf("haha:%d,%s,%s\n",emp_delete_attribute[p],emp_delete_op[p],emp_delete_values[p]);
								}
								else if( strcmp(filenames,"DEPT.txt") == 0 )
								{

								}
								else
								{

								}
						  }
			   | ENAME OPERATOR STRVALUE {  
								if( strcmp(filenames,"EMP.txt") == 0 )
								{	
									emp_delete_attribute[emp_delete_count] = ename; 
									strcpy(emp_delete_op[emp_delete_count],$2); 
									char numtostr[100];
									sprintf(numtostr,"%s",$3);
									strcpy(emp_delete_values[emp_delete_count],numtostr);
									emp_delete_count++;
									int p = emp_delete_count-1;
									printf("haha:%d,%s,%s\n",emp_delete_attribute[p],emp_delete_op[p],emp_delete_values[p]);
								}
								else if( strcmp(filenames,"DEPT.txt") == 0 )
								{

								}
								else
								{

								}
						  }
			   | EAGE OPERATOR INTVALUE {  
								if( strcmp(filenames,"EMP.txt") == 0 )
								{	
									emp_delete_attribute[emp_delete_count] = eage; 
									strcpy(emp_delete_op[emp_delete_count],$2); 
									char numtostr[100];
									sprintf(numtostr,"%d",$3);
									strcpy(emp_delete_values[emp_delete_count],numtostr);
									emp_delete_count++;
									int p = emp_delete_count-1;
									printf("haha:%d,%s,%s\n",emp_delete_attribute[p],emp_delete_op[p],emp_delete_values[p]);
								}
								else if( strcmp(filenames,"DEPT.txt") == 0 )
								{

								}
								else
								{

								}
						  }

			   | EADDRESS OPERATOR STRVALUE {  
								if( strcmp(filenames,"EMP.txt") == 0 )
								{	
									emp_delete_attribute[emp_delete_count] = eaddress; 
									strcpy(emp_delete_op[emp_delete_count],$2); 
									char numtostr[100];
									sprintf(numtostr,"%s",$3);
									strcpy(emp_delete_values[emp_delete_count],numtostr);
									emp_delete_count++;
									int p = emp_delete_count-1;
									printf("haha:%d,%s,%s\n",emp_delete_attribute[p],emp_delete_op[p],emp_delete_values[p]);
								}
								else if( strcmp(filenames,"DEPT.txt") == 0 )
								{

								}
								else
								{

								}
						  }

			   | SALARY OPERATOR INTVALUE {  
								if( strcmp(filenames,"EMP.txt") == 0 )
								{	
									emp_delete_attribute[emp_delete_count] = salary; 
									strcpy(emp_delete_op[emp_delete_count],$2); 
									char numtostr[100];
									sprintf(numtostr,"%d",$3);
									strcpy(emp_delete_values[emp_delete_count],numtostr);
									emp_delete_count++;
									int p = emp_delete_count-1;
									printf("haha:%d,%s,%s\n",emp_delete_attribute[p],emp_delete_op[p],emp_delete_values[p]);
								}
								else if( strcmp(filenames,"DEPT.txt") == 0 )
								{

								}
								else
								{

								}
						  }

               | DEPTNO OPERATOR INTVALUE {  
								if( strcmp(filenames,"EMP.txt") == 0 )
								{	
									emp_delete_attribute[emp_delete_count] = deptno; 
									strcpy(emp_delete_op[emp_delete_count],$2); 
									char numtostr[100];
									sprintf(numtostr,"%d",$3);
									strcpy(emp_delete_values[emp_delete_count],numtostr);
									emp_delete_count++;
									int p = emp_delete_count-1;
									printf("haha:%d,%s,%s\n",emp_delete_attribute[p],emp_delete_op[p],emp_delete_values[p]);
								}
								else if( strcmp(filenames,"DEPT.txt") == 0 )
								{

								}
								else
								{

								}
						  }


queryupdate: RECORD IN FILENAME {  printf("%s\n",$3);
								  strcpy(filenames,$3);
								}
								SET updation WHERE updconditionsall SEMICOLON   
			
updation: DNAME TO STRVALUE { if( strcmp(filenames,"DEPT.txt") == 0 ) { deptupdateattribute = dname; strcpy(deptupdatevalue,$3); }  }
		| DNUM TO INTVALUE  { if( strcmp(filenames,"DEPT.txt") == 0 ) { deptupdateattribute = dnum; sprintf(deptupdatevalue,"%d",$3); } }
		| DLOCATION TO STRVALUE  { if( strcmp(filenames,"DEPT.txt") == 0 ) { deptupdateattribute = dlocation; strcpy(deptupdatevalue,$3); }  }
		| EID TO INTVALUE { if( strcmp(filenames,"EMP.txt") == 0 ) { empupdateattribute = eid; sprintf(empupdatevalue,"%d",$3); }  }
		| ENAME TO STRVALUE	 { if( strcmp(filenames,"EMP.txt") == 0 ) { empupdateattribute = ename; strcpy(empupdatevalue,$3); }  }
		| EAGE TO INTVALUE { if( strcmp(filenames,"EMP.txt") == 0 ) { empupdateattribute = eage; sprintf(empupdatevalue,"%d",$3); }  }
		| EADDRESS TO STRVALUE { if( strcmp(filenames,"EMP.txt") == 0 ) { empupdateattribute = eaddress; strcpy(empupdatevalue,$3); }  }
		| SALARY TO INTVALUE { if( strcmp(filenames,"EMP.txt") == 0 ) { empupdateattribute = salary;sprintf(empupdatevalue,"%d",$3); }  }
		| DEPTNO TO INTVALUE { if( strcmp(filenames,"EMP.txt") == 0 ) { empupdateattribute = deptno; sprintf(empupdatevalue,"%d",$3); }  }

updconditionsall: updconditionsallemp | updconditionsalldept 


updconditionsalldept: updconditionsalldept OR updconditionsanddept {	
														if( strcmp(filenames,"DEPT.txt") == 0 )
														{	
															printf("im in update\n");
															FILE* filenew = fopen("temp.txt","a");
															FILE* fileinput = fopen(filenames,"r");
															char c = getc(fileinput);
															char linevalues[3][100];
															int i = 0, j =0;
															while( c != EOF )
															{
																if( c =='\n' )
																{
																	linevalues[i][j] = '\0';
																	int flag = 1;
																	int flaginvalid = 0;
																	if( deptupdateattribute == dnum )
																	{
																		for(int i=0;i<primarykeydeptsize;i++)
																		{
																			char result[100];
																			sprintf(result,"%d",primarykeydept[i]);
																			if( strcmp(result,deptupdatevalue) == 0 )
																			{
																				flaginvalid = 1;
																				break;
																			}
																		}
																	
																	}

																	if( flaginvalid )
																	{
																		printf("Primary key constraint violated---query not inserted\n");
																		continue;
																	}

																	for(int k=0;k<dept_update_count;k++)
																	{
																		if( strcmp(dept_update_op[k],"=") == 0 )
																		{
																			if( strcmp(linevalues[dept_update_attribute[k]],dept_update_values[k]) != 0) 
																			{
																				flag = 0;
																				break;
																			}
																		}
																		else if( strcmp(dept_update_op[k],">=") == 0  )
																		{
																			if( strcmp( linevalues[dept_update_attribute[k]],dept_update_values[k]) < 0 ) 
																			{
																				flag = 0;
																				break;
																			}	
																		}
																		else if( strcmp(dept_update_op[k],"<=") == 0  )
																		{
																			if( strcmp( linevalues[dept_update_attribute[k]],dept_update_values[k]) > 0 ) 
																			{
																				flag = 0;
																				break;
																			}
																		}
																		else if( strcmp(dept_update_op[k],">") == 0  )
																		{
																			if( strcmp( linevalues[dept_update_attribute[k]],dept_update_values[k]) <= 0 ) 
																			{
																				flag = 0;
																				break;
																			}
																		}
																		else if( strcmp(dept_update_op[k],"<") == 0  )
																		{
																			if( strcmp( linevalues[dept_update_attribute[k]],dept_update_values[k]) >= 0 ) 
																			{
																				flag = 0;
																				break;
																			}
																		}
																		else
																		{
																				continue;
																		}
																	}
																	if( flag == 0)
																		fprintf(filenew, "%s,%s,%s\n", linevalues[0],linevalues[1],linevalues[2]);
																	else
																	{
																		if( !flaginvalid)	
																		{
																			if( deptupdateattribute == dnum )
																			{
																				for(int i=0;i<primarykeydeptsize;i++)
																				{
																					char result[100];
																					sprintf(result,"%d",primarykeydept[i]);
																					if( strcmp(result,linevalues[0]) == 0 )
																					{
																						primarykeydept[i] = atoi(deptupdatevalue);
																						break;
																					}
																				}
																			
																			}
																			strcpy( linevalues[ deptupdateattribute], deptupdatevalue); 
																		}
																		fprintf(filenew, "%s,%s,%s\n",linevalues[0],linevalues[1],linevalues[2]);
																		
																	}

																	i = 0;
																	j = 0;
																	c = getc(fileinput);
																	continue;
																}

																if( c == ',')
																{
																	linevalues[i][j] = '\0';
																	i++;
																	j=0;
																	c = getc(fileinput);
																	continue;
																}
																
																linevalues[i][j++] = c;
																c = getc(fileinput);
															}
															dept_update_count = 0;
															fclose(fileinput);
															fclose(filenew);
															if (remove("DEPT.txt") == 0) 
																printf("File Deleted successfully\n"); 
															else
																printf("Unable to delete the file"); 
															int value = rename("temp.txt","DEPT.txt");
														}
														else if( strcmp(filenames,"EMP.txt") == 0 )
														{

														}	
														else
														{

														}
												}

				| updconditionsanddept {	
					 				if( strcmp(filenames,"DEPT.txt") == 0 )
									 {	
										printf("im in update\n");
					 					FILE* filenew = fopen("temp.txt","a");
										FILE* fileinput = fopen(filenames,"r");
										char c = getc(fileinput);
										char linevalues[3][100];
										int i = 0, j =0;
										while( c != EOF )
										{
											if( c =='\n' )
											{
												linevalues[i][j] = '\0';
												int flag = 1;

												int flaginvalid = 0;
												if( deptupdateattribute == dnum )
												{
													printf("teri\n");
													for(int i=0;i<primarykeydeptsize;i++)
													{
														printf("maa\n");
														char result[100];
														sprintf(result,"%d",primarykeydept[i]);
														printf("%sa%s\n",result,deptupdatevalue);
															
														if( strcmp(result,deptupdatevalue) == 0 )
														{
															printf("ka\n");
															
															flaginvalid = 1;
															break;
														}
													}
												
												}
												
												if( flaginvalid )
												{
													printf("Primary key constraint violated---query not inserted\n");
													
												}


												for(int k=0;k<dept_update_count;k++)
												{
													if( strcmp(dept_update_op[k],"=") == 0 )
													{
														if( strcmp(linevalues[dept_update_attribute[k]],dept_update_values[k]) != 0) 
														{
															flag = 0;
															break;
														}
													}
													else if( strcmp(dept_update_op[k],">=") == 0  )
													{
														printf("heheheheh\n");
														if( strcmp( linevalues[dept_update_attribute[k]],dept_update_values[k]) < 0 ) 
														{
															printf("abe\n");
															flag = 0;
															break;
														}	
													}
													else if( strcmp(dept_update_op[k],"<=") == 0  )
													{
														if( strcmp( linevalues[dept_update_attribute[k]],dept_update_values[k]) > 0 ) 
														{
															flag = 0;
															break;
														}
													}
													else if( strcmp(dept_update_op[k],">") == 0  )
													{
														if( strcmp( linevalues[dept_update_attribute[k]],dept_update_values[k]) <= 0 ) 
														{
															flag = 0;
															break;
														}
													}
													else if( strcmp(dept_update_op[k],"<") == 0  )
													{
														printf("heheheheh\n");
														if( strcmp( linevalues[dept_update_attribute[k]],dept_update_values[k]) >= 0 ) 
														{
															printf("%sz%sz\n",linevalues[dept_update_attribute[k]],dept_update_values[k]);
															printf("heheheheh\n");
															flag = 0;
															break;
														}
													}
													else
													{
															printf("hallabol\n");
															continue;
													}
												}

												if( flag == 0 )
													fprintf(filenew, "%s,%s,%s\n", linevalues[0],linevalues[1],linevalues[2]);
												else
												{
													if( !flaginvalid )
													{
														printf("%sz%s\n",linevalues[deptupdateattribute], deptupdatevalue);
														if( deptupdateattribute == dnum )
														{
															for(int i=0;i<primarykeydeptsize;i++)
															{
																char result[100];
																sprintf(result,"%d",primarykeydept[i]);
																if( strcmp(result,linevalues[0]) == 0 )
																{
																	primarykeydept[i] = atoi(deptupdatevalue);
																	break;
																}
															}
														
														}
														strcpy( linevalues[ deptupdateattribute], deptupdatevalue); 
													
													}
													
													fprintf(filenew, "%s,%s,%s\n",linevalues[0],linevalues[1],linevalues[2]);
												}
												
												i = 0;
												j = 0;
												c = getc(fileinput);
												continue;
											}

											if( c == ',')
											{
												linevalues[i][j] = '\0';
												i++;
												j=0;
												c = getc(fileinput);
												continue;
											}
											
											linevalues[i][j++] = c;
											c = getc(fileinput);
										}
										dept_update_count = 0;
										fclose(fileinput);
										fclose(filenew);
										if (remove("DEPT.txt") == 0) 
										    printf("File Deleted successfully\n"); 
										else
										    printf("Unable to delete the file"); 
										int value = rename("temp.txt","DEPT.txt");
									 }
									 else if( strcmp(filenames,"EMP.txt") == 0 )
									 {

									 }
									 else
									 {

									 }
									}
					
updconditionsanddept: updconditionsanddept AND updconditiondept 
					| updconditiondept
				
updconditiondept: DNAME OPERATOR STRVALUE {
								dept_update_attribute[dept_update_count] = dname; 
								strcpy(dept_update_op[dept_update_count],$2); 
								strcpy(dept_update_values[dept_update_count],$3);
								dept_update_count++;
								int p = dept_update_count-1;
								printf("haha:%d,%s,%s\n",dept_update_attribute[p],dept_update_op[p],dept_update_values[p]);
							
						  }

		 | DNUM OPERATOR INTVALUE {  dept_update_attribute[dept_update_count] = dnum; 
						     strcpy(dept_update_op[dept_update_count],$2); 
						     char numtostr[100];
						     sprintf(numtostr,"%d",$3);
						     strcpy(dept_update_values[dept_update_count],numtostr);
						     dept_update_count++;
						     int p = dept_update_count-1;
						     printf("haha:%d,%s,%s\n",dept_update_attribute[p],dept_update_op[p],dept_update_values[p]);
						  }
		 | DLOCATION OPERATOR STRVALUE {  dept_update_attribute[dept_update_count] = dlocation; 
						     strcpy(dept_update_op[dept_update_count],$2); 
						     strcpy(dept_update_values[dept_update_count],$3);
						     dept_update_count++;
						     int p = dept_update_count-1;
						     printf("haha:%d,%s,%s\n",dept_update_attribute[p],dept_update_op[p],dept_update_values[p]);
						  }
						  

updconditionsallemp: updconditionsallemp OR updconditionsandemp {	
														if( strcmp(filenames,"EMP.txt") == 0 )
														{	
															printf("im in update\n");
															FILE* filenew = fopen("temp.txt","a");
															FILE* fileinput = fopen(filenames,"r");
															char c = getc(fileinput);
															char linevalues[6][100];
															int i = 0, j =0;
															while( c != EOF )
															{
																if( c =='\n' )
																{
																	linevalues[i][j] = '\0';
																	int flag = 1;

																	int flaginvalid = 0;
																	if( empupdateattribute == eid )
																	{
																		for(int i=0;i<primarykeyempsize;i++)
																		{
																			char result[100];
																			sprintf(result,"%d",primarykeyemp[i]);
																			if( strcmp(result,empupdatevalue) == 0 )
																			{
																				flaginvalid = 1;
																				break;
																			}
																		}
																	
																	}

																	if( flaginvalid )
																	{
																		printf("Primary key constraint violated---query not inserted\n");
																		continue;
																	}

																	for(int k=0;k<emp_update_count;k++)
																	{
																		if( strcmp(emp_update_op[k],"=") == 0 )
																		{
																			if( strcmp(linevalues[emp_update_attribute[k]],emp_update_values[k]) != 0) 
																			{
																				flag = 0;
																				break;
																			}
																		}
																		else if( strcmp(emp_update_op[k],">=") == 0  )
																		{
																			printf("mofo");
																			if( strcmp( linevalues[emp_update_attribute[k]],emp_update_values[k]) < 0 ) 
																			{
																				flag = 0;
																				break;
																			}	
																		}
																		else if( strcmp(emp_update_op[k],"<=") == 0  )
																		{
																			if( strcmp( linevalues[emp_update_attribute[k]],emp_update_values[k]) > 0 ) 
																			{
																				flag = 0;
																				break;
																			}
																		}
																		else if( strcmp(emp_update_op[k],">") == 0  )
																		{
																			if( strcmp( linevalues[emp_update_attribute[k]],emp_update_values[k]) <= 0 ) 
																			{
																				flag = 0;
																				break;
																			}
																		}
																		else if( strcmp(emp_update_op[k],"<") == 0  )
																		{
																			if( strcmp( linevalues[emp_update_attribute[k]],emp_update_values[k]) >= 0 ) 
																			{
																				flag = 0;
																				break;
																			}
																		}
																		else
																		{
																				continue;
																		}
																	}
																	if( flag == 0)
																		fprintf(filenew, "%s,%s,%s,%s,%s,%s\n", linevalues[0],linevalues[1],linevalues[2],linevalues[3],linevalues[4],linevalues[5]);
																	else
																	{
																		if( !flaginvalid)
																		{
																				if( empupdateattribute == eid )
																				{
																					for(int i=0;i<primarykeyempsize;i++)
																					{
																						char result[100];
																						sprintf(result,"%d",primarykeyemp[i]);
																						if( strcmp(result,linevalues[0]) == 0 )
																						{
																							primarykeyemp[i] = atoi(empupdatevalue);
																							break;
																						}
																					}
																				
																				}
																				strcpy( linevalues[ empupdateattribute], empupdatevalue); 
																		}
																		fprintf(filenew, "%s,%s,%s,%s,%s,%s\n", linevalues[0],linevalues[1],linevalues[2],linevalues[3],linevalues[4],linevalues[5]);
																	}
																	
																	i = 0;
																	j = 0;
																	c = getc(fileinput);
																	continue;
																}

																if( c == ',')
																{
																	linevalues[i][j] = '\0';
																	i++;
																	j=0;
																	c = getc(fileinput);
																	continue;
																}
																
																linevalues[i][j++] = c;
																c = getc(fileinput);
															}
															emp_update_count = 0;
															fclose(fileinput);
															fclose(filenew);
															if (remove("EMP.txt") == 0) 
																printf("File Deleted successfully\n"); 
															else
																printf("Unable to delete the file"); 
															int value = rename("temp.txt","EMP.txt");
														}
														else if( strcmp(filenames,"EMP.txt") == 0 )
														{

														}	
														else
														{

														}
												}
					
					| updconditionsandemp {				printf("baba\n");
														if( strcmp(filenames,"EMP.txt") == 0 )
														{	
															printf("im in update\n");
															FILE* filenew = fopen("temp.txt","a");
															FILE* fileinput = fopen(filenames,"r");
															char c = getc(fileinput);
															char linevalues[6][100];
															int i = 0, j =0;
															while( c != EOF )
															{
																if( c =='\n' )
																{
																	linevalues[i][j] = '\0';
																	int flag = 1;

																	int flaginvalid = 0;
																	if( empupdateattribute == eid )
																	{
																		for(int i=0;i<primarykeyempsize;i++)
																		{
																			char result[100];
																			sprintf(result,"%d",primarykeyemp[i]);
																			if( strcmp(result,empupdatevalue )== 0 )
																			{
																				flaginvalid = 1;
																				break;
																			}
																		}
																	
																	}

																	if( flaginvalid )
																	{
																		printf("Primary key constraint violated---query not inserted\n");
																		continue;
																	}


																	for(int k=0;k<emp_update_count;k++)
																	{
																		if( strcmp(emp_update_op[k],"=") == 0 )
																		{
																			if( strcmp(linevalues[emp_update_attribute[k]],emp_update_values[k]) != 0) 
																			{
																				flag = 0;
																				break;
																			}
																		}
																		else if( strcmp(emp_update_op[k],">=") == 0  )
																		{
																			printf("mofo");
																			if( strcmp( linevalues[emp_update_attribute[k]],emp_update_values[k]) < 0 ) 
																			{
																				flag = 0;
																				break;
																			}	
																		}
																		else if( strcmp(emp_update_op[k],"<=") == 0  )
																		{
																			if( strcmp( linevalues[emp_update_attribute[k]],emp_update_values[k]) > 0 ) 
																			{
																				flag = 0;
																				break;
																			}
																		}
																		else if( strcmp(emp_update_op[k],">") == 0  )
																		{
																			if( strcmp( linevalues[emp_update_attribute[k]],emp_update_values[k]) <= 0 ) 
																			{
																				flag = 0;
																				break;
																			}
																		}
																		else if( strcmp(emp_update_op[k],"<") == 0  )
																		{
																			if( strcmp( linevalues[emp_update_attribute[k]],emp_update_values[k]) >= 0 ) 
																			{
																				flag = 0;
																				break;
																			}
																		}
																		else
																		{
																				continue;
																		}
																	}
																	if( flag == 0)
																		fprintf(filenew, "%s,%s,%s,%s,%s,%s\n", linevalues[0],linevalues[1],linevalues[2],linevalues[3],linevalues[4],linevalues[5]);
																	else
																	{
																		if( !flaginvalid)
																		{
																				if( empupdateattribute == eid )
																				{
																					for(int i=0;i<primarykeyempsize;i++)
																					{
																						char result[100];
																						sprintf(result,"%d",primarykeyemp[i]);
																						if( strcmp(result,linevalues[0]) == 0 )
																						{
																							primarykeyemp[i] = atoi(empupdatevalue);
																							break;
																						}
																					}
																				
																				}
																				strcpy( linevalues[ empupdateattribute], empupdatevalue); 
																		}
																		fprintf(filenew, "%s,%s,%s,%s,%s,%s\n", linevalues[0],linevalues[1],linevalues[2],linevalues[3],linevalues[4],linevalues[5]);
																	}
																	
																	i = 0;
																	j = 0;
																	c = getc(fileinput);
																	continue;
																}

																if( c == ',')
																{
																	linevalues[i][j] = '\0';
																	i++;
																	j=0;
																	c = getc(fileinput);
																	continue;
																}
																
																linevalues[i][j++] = c;
																c = getc(fileinput);
															}
															emp_update_count = 0;
															fclose(fileinput);
															fclose(filenew);
															if (remove("EMP.txt") == 0) 
																printf("File Deleted successfully\n"); 
															else
																printf("Unable to delete the file"); 
															int value = rename("temp.txt","EMP.txt");
														}
														else if( strcmp(filenames,"EMP.txt") == 0 )
														{

														}	
														else
														{

														}
												}

updconditionsandemp: updconditionsandemp AND updconditionemp 
					| updconditionemp

updconditionemp: EID OPERATOR INTVALUE {  emp_update_attribute[emp_update_count] = eid; 
						     strcpy(emp_update_op[emp_update_count],$2); 
						     char numtostr[100];
						     sprintf(numtostr,"%d",$3);
						     strcpy(emp_update_values[emp_update_count],numtostr);
						     emp_update_count++;
						     int p = emp_update_count-1;
						     printf("haha:%d,%s,%s\n",emp_update_attribute[p],emp_update_op[p],emp_update_values[p]);
						  }
				| ENAME OPERATOR STRVALUE {  emp_update_attribute[emp_update_count] = eid; 
						     strcpy(emp_update_op[emp_update_count],$2); 
						     char numtostr[100];
						     sprintf(numtostr,"%s",$3);
						     strcpy(emp_update_values[emp_update_count],numtostr);
						     emp_update_count++;
						     int p = emp_update_count-1;
						     printf("haha:%d,%s,%s\n",emp_update_attribute[p],emp_update_op[p],emp_update_values[p]);
						  }
				| EAGE OPERATOR INTVALUE {  emp_update_attribute[emp_update_count] = eage; 
						     strcpy(emp_update_op[emp_update_count],$2); 
						     char numtostr[100];
						     sprintf(numtostr,"%d",$3);
						     strcpy(emp_update_values[emp_update_count],numtostr);
						     emp_update_count++;
						     int p = emp_update_count-1;
						     printf("haha:%d,%s,%s\n",emp_update_attribute[p],emp_update_op[p],emp_update_values[p]);
						  }
				| EADDRESS OPERATOR STRVALUE {  emp_update_attribute[emp_update_count] = eaddress; 
						     strcpy(emp_update_op[emp_update_count],$2); 
						     char numtostr[100];
						     sprintf(numtostr,"%s",$3);
						     strcpy(emp_update_values[emp_update_count],numtostr);
						     emp_update_count++;
						     int p = emp_update_count-1;
						     printf("haha:%d,%s,%s\n",emp_update_attribute[p],emp_update_op[p],emp_update_values[p]);
						  }
				| SALARY OPERATOR INTVALUE {  emp_update_attribute[emp_update_count] = salary; 
						     strcpy(emp_update_op[emp_update_count],$2); 
						     char numtostr[100];
						     sprintf(numtostr,"%d",$3);
						     strcpy(emp_update_values[emp_update_count],numtostr);
						     emp_update_count++;
						     int p = emp_update_count-1;
						     printf("haha:%d,%s,%s\n",emp_update_attribute[p],emp_update_op[p],emp_update_values[p]);
						  }
				| DEPTNO OPERATOR INTVALUE {  emp_update_attribute[emp_update_count] = deptno; 
						     strcpy(emp_update_op[emp_update_count],$2); 
						     char numtostr[100];
						     sprintf(numtostr,"%d",$3);
						     strcpy(emp_update_values[emp_update_count],numtostr);
						     emp_update_count++;
						     int p = emp_update_count-1;
						     printf("haha:%d,%s,%s\n",emp_update_attribute[p],emp_update_op[p],emp_update_values[p]);
						  }


queryget: getattributes FROM FILENAME {   printf("%s\n",$3);
										  strcpy(filenames,$3);
									   }
										WHERE getconditionsall SEMICOLON    { deptgetattributecount = 0; empgetattributecount = 0; getiddeptcount=0; getidempcount=0; }
		
getattributes: getattributesdept | getattributesemp

getattributesdept: getonedept getattributesdept
			 	| COMMA getonedept getattributesdept
			 	|

getonedept: DNUM  { deptgetattribute[deptgetattributecount++] = dnum; getflag = 0;  }
	  | DNAME  { deptgetattribute[deptgetattributecount++] = dname;  getflag = 0; }
	  | DLOCATION { deptgetattribute[deptgetattributecount++] = dlocation;  getflag = 0;}

getattributesemp: getoneemp getattributesemp
				| COMMA getoneemp getattributesemp
				|

getoneemp:  EID  { empgetattribute[empgetattributecount++] = eid; getflag = 1;  }
		|  ENAME  { empgetattribute[empgetattributecount++] = ename; getflag = 1;  }
		|  EAGE  { empgetattribute[empgetattributecount++] = eage; getflag = 1; }
		|  EADDRESS  { empgetattribute[empgetattributecount++] = eaddress; getflag = 1; }
		|  SALARY  { empgetattribute[empgetattributecount++] = salary; getflag = 1; }
		| DEPTNO  { empgetattribute[empgetattributecount++] = deptno; getflag = 1; }


getconditionsall: getconditionsalldept | getconditionsallemp


getconditionsalldept: getconditionsalldept OR getconditionsanddept {	
													if(1 )
													{
														printf("im in\n");
														FILE* filenew = fopen("outputdept.txt","a");
														FILE* fileinput = fopen(filenames,"r");
														char c = getc(fileinput);
														char linevalues[3][100];
														int i = 0, j =0;
														while( c != EOF )
														{
															if( c =='\n' )
															{
																linevalues[i][j] = '\0';
																int flag = 1;
																for(int k=0;k<dept_get_count;k++)
																{
																	if( strcmp(dept_get_op[k],"=") == 0 )
																		{
																			if( strcmp(linevalues[dept_get_attribute[k]],dept_get_values[k]) != 0) 
																			{
																				flag = 0;
																				break;
																			}
																		}
																		else if( strcmp(dept_get_op[k],">=") == 0  )
																		{
																			if( ! (strcmp( linevalues[dept_get_attribute[k]],dept_get_values[k]) >= 0) ) 
																			{
																				flag = 0;
																				break;
																			}	
																		}
																		else if( strcmp(dept_get_op[k],"<=") == 0  )
																		{
																			if( ! (strcmp( linevalues[dept_get_attribute[k]],dept_get_values[k]) <= 0) ) 
																			{
																				flag = 0;
																				break;
																			}
																		}
																		else if( strcmp(dept_get_op[k],">") == 0  )
																		{
																			if( ! (strcmp( linevalues[dept_get_attribute[k]],dept_get_values[k]) > 0) ) 
																			{
																				flag = 0;
																				break;
																			}
																		}
																		else if( strcmp(dept_get_op[k],"<") == 0  )
																		{
																			if( ! (strcmp( linevalues[dept_get_attribute[k]],dept_get_values[k]) < 0) ) 
																			{
																				flag = 0;
																				break;
																			}
																		}
																		else
																		{
																				continue;
																		}
																}
																if( flag == 1)
																{
																	int writeflag = 1;
																	for(int x = 0;x < getiddeptcount;x++ )
																	{
																		printf("a=%d\n",getiddept[x]);
																		char temp[100];
																		sprintf(temp,"%d",getiddept[x]);
																		if( strcmp(linevalues[0],temp) == 0 )
																		{
																			writeflag = 0;
																			break;
																		}
																	}

																	if( writeflag )
																	{
																		for(int i=0;i<deptgetattributecount;i++)
																			if( i == deptgetattributecount-1 )
																				fprintf(filenew,",%s\n",linevalues[deptgetattribute[i]]);
																			else if( i==0 )
																				fprintf(filenew,"%s",linevalues[deptgetattribute[i]]);
																			else 
																				fprintf(filenew,",%s",linevalues[deptgetattribute[i]]);
																		
																		getiddept[getiddeptcount] = atoi(linevalues[0]);
																		getiddeptcount++;
																	}
																
																}
																
																i = 0;
																j = 0;
																c = getc(fileinput);
																continue;
															}

															if( c == ',')
															{
																linevalues[i][j] = '\0';
																i++;
																j=0;
																c = getc(fileinput);
																continue;
															}
															
															linevalues[i][j++] = c;
															c = getc(fileinput);
														}
														dept_get_count = 0;
														fclose(fileinput);
														fclose(filenew);
														
														
													}
												}			
 
				| getconditionsanddept {			printf("fu\n");
													printf("%s\n",filenames);
													printf("%d\n",getflag);
													if(1 )
													{
														printf("im in\n");
														FILE* filenew = fopen("outputdept.txt","a");
														FILE* fileinput = fopen(filenames,"r");
														char c = getc(fileinput);
														char linevalues[3][100];
														int i = 0, j =0;
														while( c != EOF )
														{
															if( c =='\n' )
															{
																linevalues[i][j] = '\0';
																int flag = 1;
																for(int k=0;k<dept_get_count;k++)
																{
																	if( strcmp(dept_get_op[k],"=") == 0 )
																		{
																			if( strcmp(linevalues[dept_get_attribute[k]],dept_get_values[k]) != 0) 
																			{
																				flag = 0;
																				break;
																			}
																		}
																		else if( strcmp(dept_get_op[k],">=") == 0  )
																		{
																			if( ! (strcmp( linevalues[dept_get_attribute[k]],dept_get_values[k]) >= 0) ) 
																			{
																				flag = 0;
																				break;
																			}	
																		}
																		else if( strcmp(dept_get_op[k],"<=") == 0  )
																		{
																			if( ! (strcmp( linevalues[dept_get_attribute[k]],dept_get_values[k]) <= 0) ) 
																			{
																				flag = 0;
																				break;
																			}
																		}
																		else if( strcmp(dept_get_op[k],">") == 0  )
																		{
																			if( ! (strcmp( linevalues[dept_get_attribute[k]],dept_get_values[k]) > 0) ) 
																			{
																				flag = 0;
																				break;
																			}
																		}
																		else if( strcmp(dept_get_op[k],"<") == 0  )
																		{
																			if( ! (strcmp( linevalues[dept_get_attribute[k]],dept_get_values[k]) < 0) ) 
																			{
																				flag = 0;
																				break;
																			}
																		}
																		else
																		{
																				continue;
																		}
																}
																
																if( flag == 1)
																{
																	int writeflag = 1;
																	for(int x = 0;x < getiddeptcount;x++ )
																	{
																		printf("b=%d\n",getiddept[x]);
																		
																		char temp[100];
																		sprintf(temp,"%d",getiddept[x]);
																		if( strcmp(linevalues[0],temp) == 0 )
																		{
																			writeflag = 0;
																			break;
																		}
																	}

																	if( writeflag )
																	{
																		for(int i=0;i<deptgetattributecount;i++)
																			if( i == deptgetattributecount-1 )
																				fprintf(filenew,",%s\n",linevalues[deptgetattribute[i]]);
																			else if( i==0 )
																				fprintf(filenew,"%s",linevalues[deptgetattribute[i]]);
																			else 
																				fprintf(filenew,",%s",linevalues[deptgetattribute[i]]);
																		
																		getiddept[getiddeptcount] = atoi(linevalues[0]);
																		getiddeptcount++;
																	}
																
																}
																
																
																i = 0;
																j = 0;
																c = getc(fileinput);
																continue;
															}

															if( c == ',')
															{
																linevalues[i][j] = '\0';
																i++;
																j=0;
																c = getc(fileinput);
																continue;
															}
															
															linevalues[i][j++] = c;
															c = getc(fileinput);
														}
														dept_get_count = 0;
														fclose(fileinput);
														fclose(filenew);
														
														
													}
												}			
 
				
getconditionsanddept: getconditionsanddept AND getconditiondept
				| getconditiondept
				
getconditiondept: DNAME  OPERATOR STRVALUE {  dept_get_attribute[dept_get_count] = dname; 
						     strcpy(dept_get_op[dept_get_count],$2); 
						     strcpy(dept_get_values[dept_get_count],$3);
						     dept_get_count++;
						     int p = dept_get_count-1;
						     printf("haha:%d,%s,%s\n",dept_get_attribute[p],dept_get_op[p],dept_get_values[p]);
						  }

		 | DNUM OPERATOR INTVALUE {  dept_get_attribute[dept_get_count] = dnum; 
						     strcpy(dept_get_op[dept_get_count],$2); 
						     char numtostr[100];
						     sprintf(numtostr,"%d",$3);
						     strcpy(dept_get_values[dept_get_count],numtostr);
						     dept_get_count++;
						     int p = dept_get_count-1;
						     printf("haha:%d,%s,%s\n",dept_get_attribute[p],dept_get_op[p],dept_get_values[p]);
						  }
		 | DLOCATION OPERATOR STRVALUE {  dept_get_attribute[dept_get_count] = dlocation; 
						     strcpy(dept_get_op[dept_get_count],$2); 
						     char numtostr[100];
						     sprintf(numtostr,"%s",$3);
						     strcpy(dept_get_values[dept_get_count],numtostr);
						     dept_get_count++;
						     int p = dept_get_count-1;
						     printf("haha:%d,%s,%s\n",dept_get_attribute[p],dept_get_op[p],dept_get_values[p]);
						  }

getconditionsallemp: getconditionsallemp OR getconditionsandemp {	
													if( 1 )
													{
														printf("im in\n");
														FILE* filenew = fopen("outputemp.txt","a");
														FILE* fileinput = fopen(filenames,"r");
														char c = getc(fileinput);
														char linevalues[6][100];
														int i = 0, j =0;
														while( c != EOF )
														{
															if( c =='\n' )
															{
																linevalues[i][j] = '\0';
																int flag = 1;
																for(int k=0;k<emp_get_count;k++)
																{
																	if( strcmp(emp_get_op[k],"=") == 0 )
																		{
																			if( strcmp(linevalues[emp_get_attribute[k]],emp_get_values[k]) != 0) 
																			{
																				flag = 0;
																				break;
																			}
																		}
																		else if( strcmp(emp_get_op[k],">=") == 0  )
																		{
																			printf("mofo");
																			if( strcmp( linevalues[emp_get_attribute[k]],emp_get_values[k]) < 0 ) 
																			{
																				flag = 0;
																				break;
																			}	
																		}
																		else if( strcmp(emp_get_op[k],"<=") == 0  )
																		{
																			if( strcmp( linevalues[emp_get_attribute[k]],emp_get_values[k]) > 0 ) 
																			{
																				flag = 0;
																				break;
																			}
																		}
																		else if( strcmp(emp_get_op[k],">") == 0  )
																		{
																			if( strcmp( linevalues[emp_get_attribute[k]],emp_get_values[k]) <= 0 ) 
																			{
																				flag = 0;
																				break;
																			}
																		}
																		else if( strcmp(emp_get_op[k],"<") == 0  )
																		{
																			if( strcmp( linevalues[emp_get_attribute[k]],emp_get_values[k]) >= 0 ) 
																			{
																				flag = 0;
																				break;
																			}
																		}
																		else
																		{
																				continue;
																		}
																}
																if( flag == 1)
																{
																	int writeflag = 1;
																	for(int x = 0;x < getidempcount;x++ )
																	{
																		printf("b=%d\n",getidemp[x]);
																		
																		char temp[100];
																		sprintf(temp,"%d",getidemp[x]);
																		if( strcmp(linevalues[0],temp) == 0 )
																		{
																			writeflag = 0;
																			break;
																		}
																	}

																	if( writeflag )
																	{
																		for(int i=0;i<empgetattributecount;i++)
																			if( i == deptgetattributecount-1 )
																				fprintf(filenew,",%s\n",linevalues[empgetattribute[i]]);
																			else if( i==0 )
																				fprintf(filenew,"%s",linevalues[empgetattribute[i]]);
																			else 
																				fprintf(filenew,",%s",linevalues[empgetattribute[i]]);
																		
																		getidemp[getidempcount] = atoi(linevalues[0]);
																		getidempcount++;
																	}
																
																}
																
																
																i = 0;
																j = 0;
																c = getc(fileinput);
																continue;
															}

															if( c == ',')
															{
																linevalues[i][j] = '\0';
																i++;
																j=0;
																c = getc(fileinput);
																continue;
															}
															
															linevalues[i][j++] = c;
															c = getc(fileinput);
														}
														emp_get_count = 0;
														fclose(fileinput);
														fclose(filenew);
														
														
													}
												}			
					
					| getconditionsandemp  {		
													printf("kaboom\n");
													if(1 )
													{
														printf("im in\n");
														FILE* filenew = fopen("outputemp.txt","a");
														FILE* fileinput = fopen(filenames,"r");
														char c = getc(fileinput);
														char linevalues[6][100];
														int i = 0, j =0;
														while( c != EOF )
														{
															if( c =='\n' )
															{
																linevalues[i][j] = '\0';
																int flag = 1;
																for(int k=0;k<emp_get_count;k++)
																{
																	if( strcmp(emp_get_op[k],"=") == 0 )
																		{
																			if( strcmp(linevalues[emp_get_attribute[k]],emp_get_values[k]) != 0) 
																			{
																				flag = 0;
																				break;
																			}
																		}
																		else if( strcmp(emp_get_op[k],">=") == 0  )
																		{
																			if( ! (strcmp( linevalues[emp_get_attribute[k]],emp_get_values[k]) >= 0) ) 
																			{
																				flag = 0;
																				break;
																			}	
																		}
																		else if( strcmp(emp_get_op[k],"<=") == 0  )
																		{
																			if( ! (strcmp( linevalues[emp_get_attribute[k]],emp_get_values[k]) <= 0) ) 
																			{
																				flag = 0;
																				break;
																			}
																		}
																		else if( strcmp(emp_get_op[k],">") == 0  )
																		{
																			if( ! (strcmp( linevalues[emp_get_attribute[k]],emp_get_values[k]) > 0) ) 
																			{
																				flag = 0;
																				break;
																			}
																		}
																		else if( strcmp(emp_get_op[k],"<") == 0  )
																		{
																			if( ! (strcmp( linevalues[emp_get_attribute[k]],emp_get_values[k]) < 0) ) 
																			{
																				flag = 0;
																				break;
																			}
																		}
																		else
																		{
																				continue;
																		}
																}
																
																if( flag == 1)
																{
																	int writeflag = 1;
																	for(int x = 0;x < getidempcount;x++ )
																	{
																		printf("b=%d\n",getidemp[x]);
																		
																		char temp[100];
																		sprintf(temp,"%d",getidemp[x]);
																		if( strcmp(linevalues[0],temp) == 0 )
																		{
																			writeflag = 0;
																			break;
																		}
																	}

																	if( writeflag )
																	{
																		for(int i=0;i<empgetattributecount;i++)
																			if( i == deptgetattributecount-1 )
																				fprintf(filenew,",%s\n",linevalues[empgetattribute[i]]);
																			else if( i==0 )
																				fprintf(filenew,"%s",linevalues[empgetattribute[i]]);
																			else 
																				fprintf(filenew,",%s",linevalues[empgetattribute[i]]);
																		
																		getidemp[getidempcount] = atoi(linevalues[0]);
																		getidempcount++;
																	}
																
																}
																
																
																i = 0;
																j = 0;
																c = getc(fileinput);
																continue;
															}

															if( c == ',')
															{
																linevalues[i][j] = '\0';
																i++;
																j=0;
																c = getc(fileinput);
																continue;
															}
															
															linevalues[i][j++] = c;
															c = getc(fileinput);
														}
														emp_get_count = 0;
														fclose(fileinput);
														fclose(filenew);
														
														
													}
												}			

getconditionsandemp: getconditionsandemp AND getconditionemp 
					| getconditionemp

getconditionemp: EID OPERATOR INTVALUE {  emp_get_attribute[emp_get_count] = eid; 
						     strcpy(emp_get_op[emp_get_count],$2); 
						     char numtostr[100];
						     sprintf(numtostr,"%d",$3);
						     strcpy(emp_get_values[emp_get_count],numtostr);
						     emp_get_count++;
						     int p = emp_get_count-1;
						     printf("haha:%d,%s,%s\n",emp_get_attribute[p],emp_get_op[p],emp_get_values[p]);
						  }
				| ENAME  OPERATOR STRVALUE {  emp_get_attribute[emp_get_count] = ename; 
						     strcpy(emp_get_op[emp_get_count],$2); 
						     char numtostr[100];
						     sprintf(numtostr,"%s",$3);
						     strcpy(emp_get_values[emp_get_count],numtostr);
						     emp_get_count++;
						     int p = emp_get_count-1;
						     printf("haha:%d,%s,%s\n",emp_get_attribute[p],emp_get_op[p],emp_get_values[p]);
						  }
				| EAGE OPERATOR INTVALUE {  emp_get_attribute[emp_get_count] = eage; 
						     strcpy(emp_get_op[emp_get_count],$2); 
						     char numtostr[100];
						     sprintf(numtostr,"%d",$3);
						     strcpy(emp_get_values[emp_get_count],numtostr);
						     emp_get_count++;
						     int p = emp_get_count-1;
						     printf("haha:%d,%s,%s\n",emp_get_attribute[p],emp_get_op[p],emp_get_values[p]);
						  }
				| EADDRESS OPERATOR STRVALUE {  emp_get_attribute[emp_get_count] = eaddress; 
						     strcpy(emp_get_op[emp_get_count],$2); 
						     char numtostr[100];
						     sprintf(numtostr,"%s",$3);
						     strcpy(emp_get_values[emp_get_count],numtostr);
						     emp_get_count++;
						     int p = emp_get_count-1;
						     printf("haha:%d,%s,%s\n",emp_get_attribute[p],emp_get_op[p],emp_get_values[p]);
						  }
				| SALARY OPERATOR INTVALUE {  emp_get_attribute[emp_get_count] = salary; 
						     strcpy(emp_get_op[emp_get_count],$2); 
						     char numtostr[100];
						     sprintf(numtostr,"%d",$3);
						     strcpy(emp_get_values[emp_get_count],numtostr);
						     emp_get_count++;
						     int p = emp_get_count-1;
						     printf("haha:%d,%s,%s\n",emp_get_attribute[p],emp_get_op[p],emp_get_values[p]);
						  }
				| DEPTNO OPERATOR INTVALUE {  emp_get_attribute[emp_get_count] = deptno; 
						     strcpy(emp_get_op[emp_get_count],$2); 
						     char numtostr[100];
						     sprintf(numtostr,"%d",$3);
						     strcpy(emp_get_values[emp_get_count],numtostr);
						     emp_get_count++;
						     int p = emp_get_count-1;
						     printf("haha:%d,%s,%s\n",emp_get_attribute[p],emp_get_op[p],emp_get_values[p]);
						  }
				
%%