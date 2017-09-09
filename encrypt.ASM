data segment
	ORG 30h
	MAT1 DB 0,2
	ORG 34h
	MAT2 DB 1,0
	org 50h
	MY_STRING DB 'Microprocessor'
	org 00h
	MY_STRING2 DB 'Microprocessor'
	org 20h
	K db 5
	org 22h
	dim equ ($-MY_STRING2)
data ends

matrix1 macro
	MOV DX,00H
	MOV AH,00H	
	MOV AL,MAT1[0]
	MOV BL,[SI]
	MUL BL
	ADD DX,AX
	INC SI
	MOV AH,00H	
	MOV AL,MAT1[1]
	MOV BL,[SI]
	MUL BL
	ADD DX,AX
endm

caesar_shift macro
	MOV CX,dim ;string length
    	MOV DI,0
    	XOR AX,AX
caesar:
    	MOV AL,MY_STRING[DI]
    	CMP AL,41h ; A
    	JL end_test_caesar
    	CMP AL,7Ah ; z
    	JG end_test_caesar
    	CMP AL,5Ah ; Z
    	JLE upper_case
   	CMP AL,61h ; a
    	JL  end_test_caesar
    	MOV BL,7Ah

test_caesar:
    	ADD AL,K; letter + k
    	CMP AL,7Ah
    	JG modulo2
    	MOV MY_STRING[DI],AL

end_test_caesar:
    	INC DI
    	DEC CX
    	CMP CX,0
   	JNZ caesar
    	JMP end_caesar

upper_case:
    	ADD AL,K; letter + k
    	CMP AL,5Ah
    	JG modulo1
    	MOV MY_STRING[DI],AL
    	JMP end_test_caesar

modulo1:
    	ADD AL,6 ; after z -> A
    	MOV MY_STRING[DI],AL
    	JMP end_test_caesar

modulo2:
    	MOV BL,58
    	SUB AL,BL ; after Z -> a
    	MOV MY_STRING[DI],AL
    	JMP end_test_caesar

end_caesar:NOP
endm

matrix2 macro
	MOV DX,00H
	MOV AH,00H	
	MOV AL,MAT2[0]
	MOV BL,[SI]
	MUL BL
	ADD DX,AX
	INC SI
	MOV AH,00H	
	MOV AL,MAT2[1]
	MOV BL,[SI]
	MUL BL
	ADD DX,AX
endm	

code segment
	ASSUME cs:code,ds:data
start:	MOV AX,data
	MOV ds,AX

	caesar_shift

	MOV CX,00

L3:	LEA SI,MY_STRING
	ADD SI,CX
	matrix1
	LEA SI,MY_STRING2
	ADD SI,CX
	MOV [SI],DL
	
	LEA SI,MY_STRING
	ADD SI,CX
	matrix2
	LEA SI,MY_STRING2
	ADD SI,CX
	INC SI
	MOV [SI],DL


	ADD CX,2
	CMP CX,DIM		
	JNZ L3
	HLT
code ends
	end start
