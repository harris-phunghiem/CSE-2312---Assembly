/*****************************HEADER********************************  

	Author: Harris Nghiem
	ID: 1000572896

	int gcd_euclid(int x, int y)
	{
		if(y == 0) return x;

		return gcd_euclid( y, (x % y) );
	}

*******************************HEADER********************************/ 

.global main
.func main
 
/*****************************MAIN START*****************************/  

main:					@ infinite loop

					@ get operand 1

	LDR R0, =printf_op1		@ string adr for printf
	BL  callPrintf			@ branch and return
	LDR R0, =numFmt			@ format-string adr for scanf
	BL  callScanf			@ branch and return

	PUSH {R0}			@ save operand 1 (X)

					@ get operand 2

	LDR R0, =printf_op2		@ string adr for printf
	BL  callPrintf			@ branch and return
	LDR R0, =numFmt			@ format-string adr for scanf
	BL  callScanf			@ branch and return
					@ R0 is Y

	POP {R1}			@ restore operand 1 (X) to R1

	CMP R0, R1			@ check to see if R0 < R1
	MOVLO R2, R0 	       		@ swap R0 and R1
    	MOVLO R0, R1    	    	
    	MOVLO R1, R2      
					@ now R0 >= R1

	BL gcd_euclid

	MOV R1, R0			@ this prints the result
	LDR R0, =resultFmt
	BL callPrintf
	
	B main				@ infinite loop

/******************************MAIN END********************************/



/*****************************GCD_EUCLID******************************/

gcd_euclid:				@ R0 is X, R1 is Y

	PUSH {LR}              		@ save LR on stack


	CMP R1, #0			@ if R1 (Y) == 0
	POPEQ {PC}	             	@ pop LR from stack and return

	MOV R4, R0			@ move X for call to mod
	MOV R5,	R1			@ move Y for call to mod
	BL MODUNSIGNED			@ branch to mod

	MOV R0, R1			@ move Y to R1 as new arg X 
	MOV R1, R4			@ move X%Y to R2 as new arg Y

	BL gcd_euclid	 		@ call gcd_euclid with Y as X, and X%Y as new Y

	POP {PC}			@ pop LR from stack and return		

/*****************************END OF GCD_EUCLID*****************************/



/***************************MODUNSIGNED PROCEDURE***************************/

MODUNSIGNED:				@ preforms modulus, RETURNS RESULT IN R4

        CMP R4, R5      		@ check for R5 >= R4
	BLO EXIT			@ branch to exit if true
        SUB R4, R4, R5  		@ subtract R5 from R4
	B MODUNSIGNED			@ branch back
EXIT:
    	MOV PC, LR          		@ return

/*********************END MODUNSIGNED PROCEDURE****************************/




/****************************CALLPRINTF**************************/ 

callPrintf:

    	PUSH {LR}			@ save LR since printf overwrites it
    	BL printf               	@ branch to library routine and return
	POP {PC}			@ restore LR and return	
	         
/************************END CALLPRINTF**************************/ 


/************************CALLSCANF********************************/
	          
callScanf:

   	PUSH {LR}			@ save LR since scanf overwrites it
    	SUB SP, SP, #4	    		@ decrement stack ptr for new entry
    	MOV R1, SP             	 	@ R1 has adr for scanf result
    	BL  scanf               	@ branch to library routine and return
    	LDR R0, [SP]            	@ put scanf result in R0
    	ADD SP, SP, #4          	@ restore stack ptr
	POP {PC}			@ restore LR and return

/************************END CALLSCANF****************************/ 



.data

printf_op1:	.asciz      "Operand 1: "
printf_op2:	.asciz      "Operand 2: "

charFmt:        .asciz	    "%s"	
numFmt:         .asciz	    "%d"
invalidOpStr:	.asciz	    "Invalid operation\n"
operand1Fmt:	.asciz	    "Operand 1: %d\n"
operand2Fmt:	.asciz	    "Operand 2: %d\n"
resultFmt:  	.asciz 	    "GCD:       %d\n"