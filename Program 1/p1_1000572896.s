/********************************************************************

	CSE 2312, Program 1

	Author - Harris Nghiem
	ID - 1000572896

	SUM: Adds registers R1 and R2, returning result in register R0.
	DIFFERENCE: Subtracts register R2 from R1, returning result in register R0.
	PRODUCT: Multiplies registers R1 and R2, returning the result in register R0.
	MAX: Compares registers R1 and R2, returning the maximum of the two values in R0.

********************************************************************/
 
.global main
.func main
   
main:					@ infinite loop

					@ get operand 1

	LDR R0, =reqOperand1		@ string adr for printf
	BL  callPrintf			@ branch and return
	LDR R0, =numFmt			@ format-string adr for scanf
	BL  callScanf			@ branch and return
	MOV R8,R0			@ save operand 1 in R8

					@ get operation code

	LDR R0, =reqOperatn		@ string adr for printf
	BL  callPrintf			@ branch and return
	LDR R0, =charFmt		@ format-string adr for scanf
	BL  callScanf			@ branch and return
	MOV R9,R0			@ save operation code in R9

					@ get operand 2

	LDR R0, =reqOperand2		@ string adr for printf
	BL  callPrintf			@ branch and return
	LDR R0, =numFmt			@ format-string adr for scanf
	BL  callScanf			@ branch and return
	MOV R10,R0			@ save operand 2 in R10

/* debugging output

	LDR R0, =operandFmt		@ string adr for printf
	MOV R1, R8			@ get operand 1
	BL  callPrintf			@ branch and return

	LDR R0, =operatnFmt		@ string adr for printf
	MOV R1, R9			@ get operation code
	BL  callPrintf			@ branch and return

	LDR R0, =operandFmt		@ string adr for printf
	MOV R1, R10			@ get operand 2
	BL  callPrintf			@ branch and return

****************/

					@ identify operation code

	MOV R0, R9			@ get operation code
	MOV R1, R8			@ get operand 1
	MOV R2, R10			@ get operand 2

	CMP R0, #'+'			@ check for addition
	BEQ add

	CMP R0, #'-'			@ check for subtraction
	BEQ sub

	CMP R0, #'*'			@ check for multiply
	BEQ mult

	CMP R0, #'M'			@ check for maximum
	BEQ max

	B invalidOp			@ else invalid operation

add:					@ add operands
	ADD R1, R1, R2
	B outputResult

sub:					@ subtract operands
	SUB R1, R1, R2
	B outputResult

mult:					@ multiply operands
	MUL R1, R1, R2
	B outputResult

max:					@ identify maximum of operands
	CMP R1, R2
	BGE outputResult
	MOV R1, R2
	B outputResult

outputResult:
   	LDR R0, =resultFmt		@ string adr for printf
				  	@ result is in R1 for printf
	BL  callPrintf			@ branch and return
	B   main                	@ iterate loop

invalidOp:				@ set up printf call
	LDR R0, =invalidOpStr		@ string adr for printf
	BL  callPrintf			@ branch and return
	B   main               		@ iterate loop

/****** end of loop ******/
		
callPrintf:
    MOV R4, LR              @ save LR since printf overwrites it
    BL printf               @ branch to library routine and return
    MOV PC, R4              @ return
	          
callScanf:
    MOV R4, LR              @ save LR since scanf overwrites it
    SUB SP, SP, #4	    @ decrement stack ptr for new entR9
    MOV R1, SP              @ R1 has adr for scanf result
    BL  scanf               @ branch to library routine and return
    LDR R0, [SP]            @ put scanf result in R0
    ADD SP, SP, #4          @ restore stack ptr
    MOV PC, R4              @ return

.data

reqOperand1:	.asciz      "Operand 1: "
reqOperatn:	.asciz      "  + - * M: "
reqOperand2:	.asciz      "Operand 2: "

charFmt:        .asciz	    "%s"	@ "%c" doesn't work in scanf
numFmt:         .asciz	    "%d"
resultFmt:  	.asciz 	    "Result:    %d\n"

invalidOpStr:	.asciz	    "Invalid operation\n"

operatnFmt:	.asciz	    "Operation = %c\n"
operandFmt:	.asciz	    "Operand =   %d\n"