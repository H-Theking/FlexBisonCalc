/* Bison file for Calculator*/ 
%{ 
#include <stdio.h> 
#include <math.h>
#include <stdlib.h>
%} 


%union {//Define a Union to use double as the type of input. Default is int
	double d;
};
/* declare tokens */
%token <d> NUMBER OCTAL HEXADECIMAL
%token ADD SUB MUL DIV LPAR RPAR POW MOD

%token EOL
%type <d> E N T P F
/* Manipulation of the values of the symbols	
    Each symbol in a bison rule has a value
    The value of the target symbol ;the one to the left of the colon is $$ in the action code
    The values on the right are numbered $1 , $2 and so on up to the number of symbols in the rule
    The values of the tokens are whatever was in yylval when the scanner returned the token
*/
%% 
/*Precedence level of the rules increases downward*/
input : /*nothing */ /*matches at beginning of input*/
   | input E EOL { printf("Results => %g\n\n", $2);} /*EOL is end of an expression*/
   ; 
E : E ADD T 	{ $$ = $1 + $3; printf("E -> E + M 	%g %g %g\n", 	$$, $1, $3);}
  | E SUB T { $$ = $1 - $3;	printf("E -> E - M 	%g %g %g\n", 	$$, $1, $3);}
  | T 		{ $$ = $1; 		printf("E -> M		%g %g\n", 			$$, $1);}
  ;
T : T MUL P { $$ = $1 * $3; printf("T -> T * F	%g %g %g\n", 	$$, $1, $3);}
  | T DIV P	{
  		if($3 == 0){
  			yyerror("Division by zero is undefined!");
  			return;
  		}
  		else
  			$$ = $1 / $3; printf("T -> T / F	%g %g %g\n", 	$$, $1, $3);}
  | T MOD P { 
  		if((int)$1 < $1 || (int)$3 < $3){
  			yyerror("Modulo division is only defined for integers\n");
  			return;
  		}else{
  			$$ = (int)$1 % (int)$3; printf("T -> T MOD F 	%g %g %g\n", 	$$, $1, $3);
  		}
  	}
  | P 		{ $$ = $1;		printf("T -> F		%g %g\n",			$$, $1);}
  ; 
P : P POW N	{
	if($3 < 0 || (int)$3 < $3){
		yyerror("Exponents should only be positive integers\n");
		return;
	}
	$$ = pow($1, $3); printf("T -> T ^ F 	%g %g %g\n",$$, $1, $3);}
  | N
  ;
N : LPAR E RPAR	{ $$ = $2; 	printf("F -> ( E ) 	%g %g\n", 		$$, $2);}
  | F
  ;
F : NUMBER 		{ $$ = $1;	printf("F -> NUMBER	%g %g\n", 		$$, $1);}
  | OCTAL		{ $$ = $1;	printf("F -> OCTAL	%g 0%o\n", 		$$, (unsigned int)$1);}
  | HEXADECIMAL	{ $$ = $1;	printf("F -> HEXADECIMAL	%g 0x%0x\n", 		$$, (unsigned int)$1);}
  | SUB N	{ $$ = -$2; printf("F -> -N	%g %g\n", 		$$, $2);}
  | ADD N	{ $$ = $2; 	printf("F -> N	%g %g\n", 		$$, $2);}
  ; 
%% 

int main(int argc, char **argv) { 
 printf("Enter an arithmetic expression: \n"); 
 yyparse(); 
return 0; 
}
yyerror(char *s)
{
	fprintf(stderr, "error: %s\n", s);
}
