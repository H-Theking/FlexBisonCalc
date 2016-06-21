/*Flex declaration of tokens used by bison*/ 
%{ 
// c declaration parts
# include "calc.tab.h"
%} 
%% 
"+"			{ printf("PLUS\n");return ADD;} 
"-"			{ printf("MINUS\n"); return SUB;} 
"*"			{ printf("MULT\n");return MUL;} 
"/"			{ printf("DIV\n");return DIV;} 
"("			{ printf("LPAR\n"); return LPAR;} 
")"			{ printf("RPAR\n"); return RPAR;} 
"\^"		{ printf("POW\n");return POW;}
"\%"		{ printf("MOD\n");return MOD;}
"\n"		{ return EOL;} 
(((([1-9][0-9]*)?\.?|0\.)?[1-9][0-9]*)|[0-9]+\.) { yylval.d = strtod(yytext, NULL); return NUMBER;}/*Should not match numbers of the form: 0abc--.def--*/
0x[a-f0-9]+	{ yylval.d = strtol(yytext, NULL, 16);return HEXADECIMAL;}//Hexadecimal Number
0[0-7]+		{ yylval.d = (double)strtol(yytext, NULL, 8);	return OCTAL;}//Octal Number
[ \t]		{ /*ignore whitespaces*/} 
.			{printf("Unrecognized character %s: \n", yytext); } 
%%
