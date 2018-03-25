.MODEL  SMALL
.386
.STACK  200

.DATA   
XUEHAO  DB  10  DUP(0)
NUMBER  DB  '1633'
.CODE
BEGIN:  MOV AX,@DATA
        MOV DS,AX
        MOV ESI,0
        MOV EDI,0
        MOV CX,4
LOPA:   MOV AL,NUMBER[ESI];间接寻址
        MOV XUEHAO[EDI],AL;复制存储
        INC AL
        INC ESI
        INC EDI
        DEC CX
        JNZ LOPA
        MOV AH,4CH
        INT 21H
END BEGIN
