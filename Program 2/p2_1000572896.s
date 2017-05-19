/********************************************************************

	CSE 2312, Program 2

	Author - Harris Nghiem
	ID - 	1000572896

	Computes the GCD of integers stored in R1 and R2 iteratively and
	returns the result in R0.

	#include <stdio.h>

	int main()
	{

    	int x=24;
    	int y=12;
    	int i;
    	int gcd;

    	for(i=y;; i--)
    	{
        	if(x%i==0 && y%i==0)
        	{
            		gcd=i;
           		break;
        	}
    	}

    	printf("X is: %d\nY is: %d\ni is: %d\nGCD is: %d", x,y,i, gcd);


********************************************************************/
 
.global main
.func main


/***************************MAIN LOOP START**************************/  

main:					@ infinite loop

					@ get operand 1

	LDR R0, =printf_op1		@ string adr for printf
	BL  callPrintf			@ branch and return
	LDR R0, =numFmt			@ format-string adr for scanf
	BL  callScanf			@ branch and return
	MOV R1,R0			@ save operand 1, or X, in R1

					@ get operand 2

	LDR R0, =printf_op2		@ string adr for printf
	BL  callPrintf			@ branch and return
	LDR R0, =numFmt			@ format-string adr for scanf
	BL  callScanf			@ branch and return
	MOV R2,R0			@ save operand 2, or Y, in R2

	BL GCD_ITERATIVE

	MOV R1, R0
	LDR R0, =resultFmt
	BL callPrintf
	
	B main	

/***************************MAIN LOOP END************************/


/**************************GCD_ITERATIVE PROCEDURE****************/
GCD_ITERATIVE:

	MOV R8, LR              	@ save LR since modunsigned overwrites it

	CMP R1, R2			@ check to see if R1 < R2
	MOVLO R0, R1 	       		@ swap R1 and R2 if R1 < R2
    	MOVLO R1, R2    	    	
    	MOVLO R2, R0        		

	MOV R0, R2			@ initiliaze loop index as Y

LOOP:					@ loop to return GCD

    	MOV R4, R1			@ move X into correct reg
	MOV R5,	R0			@ move I into correct reg
	BL MODUNSIGNED			@ branch to mod
	CMP R4, #0			@ compare index to 0
	BNE DEC				@ if not equal to 0, decrement

	MOV R4, R2			@ move Y into correct reg
	MOV R5,	R0			@ move I into correct reg
	BL MODUNSIGNED			@ branch to mod
	CMP R4, #0			@ compare index to 0
	BNE DEC				@ if not equal to 0, decrement

    	MOV PC, R8              	@ return

DEC:
	SUB R0, R0, #1			@ decrease index
	B LOOP
/***********************END GCD_ITERATIVE PROCEDURE****************/


/*************************MODUNSIGNED PROCEDURE*********************/
MODUNSIGNED:				@ preforms modulus

        CMP R4, R5      		@ check for R5 >= R4
	BLO EXIT			@ branch to exit if true
        SUB R4, R4, R5  		@ subtract R5 from R4
	B MODUNSIGNED			@ branch back
EXIT:
    	MOV PC, LR          		@ return

/*********************END MODUNSIGNED PROCEDURE*********************/


/****************************CALLPRINTF**************************/ 
callPrintf:
    MOV R4, LR              @ save LR since printf overwrites it
    BL printf               @ branch to library routine and return
    MOV PC, R4              @ return
/************************END CALLPRINTF**************************/ 


/************************CALLSCANF********************************/ 	          
callScanf:
    MOV R4, LR              @ save LR since scanf overwrites it
    SUB SP, SP, #4	    @ decrement stack ptr for new entR9
    MOV R1, SP              @ R1 has adr for scanf result
    BL  scanf               @ branch to library routine and return
    LDR R0, [SP]            @ put scanf result in R0
    ADD SP, SP, #4          @ restore stack ptr
    MOV PC, R4              @ return
/************************END CALLSCANF****************************/ 
.data

printf_op1:	.asciz      "Operand_1: "
printf_op2:	.asciz      "Operand_2: "

charFmt:        .asciz	    "%s"	
numFmt:         .asciz	    "%d"
invalidOpStr:	.asciz	    "Invalid operation\n"
operand1Fmt:	.asciz	    "Operand 1:	%d\n"
operand2Fmt:	.asciz	    "Operand 2:	%d\n"
resultFmt:  	.asciz 	    "GCD:    	%d\n"