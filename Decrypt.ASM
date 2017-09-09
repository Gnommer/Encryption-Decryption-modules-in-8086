data segment
	ORG 30h
	MAT1 DB 0,2
	ORG 34h
	MAT2 DB 1,0
	org 50h
	MY_STRING DB 0DCH,52H,0EEH,68H,0EAH,74H,0E8H,77H,0D4H,68H,0F0H,78H,0EEH,74H
	org 00h
        MY_STRING2 DB 0DCH,52H,0EEH,68H,0EAH,74H,0E8H,77H,0D4H,68H,0F0H,78H,0EEH,74H
	org 20h
	K db 5
	org 22h
	dim equ 14
	org 70h
data ends



caesar_shift macro
	MOV CX,dim ;string length
    	MOV DI,0
    	XOR AX,AX
caesar:
    	MOV AL,MY_STRING2[DI]
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
    	SUB AL,K; letter - k
    	CMP AL,7Ah
    	JG modulo2
    	MOV MY_STRING2[DI],AL

end_test_caesar:
    	INC DI
    	DEC CX
    	CMP CX,0
   	JNZ caesar
    	JMP end_caesar

upper_case:
        SUB AL,K; letter - k
    	CMP AL,5Ah
    	JG modulo1
    	MOV MY_STRING2[DI],AL
    	JMP end_test_caesar

modulo1:
    	ADD AL,6 ; after z -> A
    	MOV MY_STRING2[DI],AL
    	JMP end_test_caesar

modulo2:
    	MOV BL,58
    	SUB AL,BL ; after Z -> a
    	MOV MY_STRING2[DI],AL
    	JMP end_test_caesar

end_caesar:NOP
endm

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

undiv macro
	mov cx,dim
	mov bh,00
	MOV AL, MAT1[1]
	MUL MAT2[0]
	MOV BL,AL
        lea si,MY_STRING2
l5:     mov Ah,00
        mov AL,[si] 
    	div bl
        mov [si],Al	
	inc si
        loop l5 
        caesar_shift
endm

code segment
	ASSUME cs:code,ds:data
start:	MOV AX,data
	MOV ds,AX

	

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

        undiv
	
	HLT
code ends
	end start
