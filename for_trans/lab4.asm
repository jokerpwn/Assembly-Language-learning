.MODEL  SMALL
.386
.STACK  200

.DATA   
NUMBER  DB  '1633'
XUEHAO  DB  10 DUP(0)
.CODE
BEGIN:  MOV AX,@DATA
        MOV DS,AX
        MOV ESI,OFFSET  NUMBER
        MOV EDI,OFFSET  XUEHAO
        MOV CX,4
LOPA:   MOV AL,[ESI]; 间接寻址
        MOV [EDI],AL;复制存储
        INC ESI
        INC EDI
        DEC CX
        JNZ LOPA
        MOV AH,4CH
        INT 21H
END BEGIN
