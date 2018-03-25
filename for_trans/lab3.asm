.MODEL  SMALL
.386
.STACK  200

.DATA   
NUMBER  DB  '1633'
XUEHAO  DB  10 DUP(0)
.CODE
BEGIN:  MOV AX,@DATA
        MOV DS,AX
        MOV EBP,OFFSET  NUMBER
        MOV EBX,OFFSET  XUEHAO
        MOV ESI,0
        MOV CX,4
LOPA:   MOV AL,[EBP][ESI]; 基址+变址寻址
        MOV [EBX][ESI],AL;复制存储
        INC ESI
        DEC CX
        JNZ LOPA
        MOV AH,4CH
        INT 21H
END BEGIN
