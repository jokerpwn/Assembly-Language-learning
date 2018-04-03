.386
STACK   SEGMENT USE16 STACK
        DB  200 DUP(0)
STACK   ENDS
DATA    SEGMENT USE16
        A_LEVEL   EQU  90
        B_LEVEL   EQU  50
        C_LEVEL   EQU  20
        D_LEVEL   EQU  0
        
        BNAME   DB  12,'PAN WAN NING',0;老板姓名
        BPASS   DB  4,'test',0;密码
        
        N       EQU 30
        S1      DB  'SHOP1',5 DUP(0);网店名称,为使计算结构体偏移量方便
                DB  'PEN', 7 DUP(0);
                DW   35,56,70,25,?;
                DB  'BOOK',6 DUP(0);商品名称
                DW  12,30,25,5,?;进货价，销售价，进货总数，已售数量，利润率
                DB  N-2 DUP('Temp-Value',15,0,20,0,30,0,2,0,?,?);其他商品信息处理为相同
        S2      DB  'SHOP2',5 DUP(0)
                DB  'PEN',7 DUP(0)
                DW  35,50,30,24,?
				DB  'BOOK',6 DUP(0)
                DW  12,28,20,15,?
                DB  N-2 DUP('Temp-Value',15,0,20,0,30,0,2,0,?,?)
        NAME_NOTICE DB 'Please input your name:$'
        PASS_NOTICE DB 'Please input your password:$'
        IN_NAME DB  20
                DB  ?
                DB  20 DUP(0)
        IN_PWD  DB  10
                DB  ?
                DB  10 DUP(0)
        AUTH    DB  1
        CRLF    DB 0DH,0AH,'$'
        FAIL_NOTICE  DB 'Wrong name/password,please input again!$' 
        GOODS_NOTICE DB 'Please input the goods name:$'
        IN_GOODS    DB 20
                    DB ?
                    DB 20 DUP(0)
        GOODS_LENGTH DB 3 DUP(0)
DATA ENDS
CODE    SEGMENT USE16
        ASSUME  CS:CODE,DS:DATA,SS:STACK
START:  MOV AX,DATA
        MOV DS,AX
        JMP NOTICE
FAIL:   MOV DL,0AH
		MOV AH,2H
		INT 21H
		LEA DX,FAIL_NOTICE
        MOV AH,9
        INT 21H
		MOV DL,0AH
		MOV AH,2H
		INT 21H
NOTICE: LEA DX,NAME_NOTICE
        MOV AH,9
        INT 21H
		
        MOV DL,0AH
        MOV AH,2H
        INT 21H
		
        LEA DX,IN_NAME
        MOV AH,10
        INT 21H
		MOV DL,0AH
		MOV AH,2H
		INT 21H
        CMP IN_NAME+2,0DH;回车符号
        JE  BEFORE_FUNC3;跳转功能三
        
        CMP IN_NAME+1,1H
        JE  EXIT
EXIT:   CMP IN_NAME+2,'q';退出
        JE  OVER
		
        LEA DX,PASS_NOTICE
        MOV AH,9
        INT 21H
		
        MOV DL,0AH
        MOV AH,2
        INT 21H

        LEA DX,IN_PWD
        MOV AH,10
        INT 21H
        MOV DL,0AH;回车
        MOV AH,2
        INT 21H
        
FUNC2:  MOV CL,IN_NAME+1;先比字数
        MOV BX,0
        CMP CL,BNAME
        JNE FAIL
LOOPA:  MOV AL,[IN_NAME+BX+2]
        CMP AL,BNAME[BX+1]
        JNE FAIL
        INC BX
        DEC CL
        JNE LOOPA
    
        MOV BX,0
        MOV CL,IN_PWD+1
        CMP CL,BPASS
        JNE FAIL
LOOPB:  MOV AL,IN_PWD[BX+2]
        CMP AL,BPASS[BX+1]
        JNE FAIL
        INC BX
        DEC CX
        JNE LOOPB
        MOV AUTH,1
        JMP FUNC3
BEFORE_FUNC3:MOV AUTH,0
FUNC3:  LEA DX,GOODS_NOTICE
        MOV AH,9H
        INT 21H
        MOV DL,0AH
        MOV AH,2H
        INT 21H
		
        LEA DX,IN_GOODS
        MOV AH,10
        INT 21H
		
		MOV DL,0AH
		MOV AH,2H
		INT 21H
		
        CMP IN_GOODS+2,0DH;回车回到功能一
        JE  NOTICE
	
        LEA BX,S1+10;首地址赋值
        LEA DX,S1+10+20*N;存尾地址　
        JMP LOPC
NEXT:   ADD BX,20
LOPC:   MOV CL,IN_GOODS+1;CL存长度
        MOV SI,0  
        CMP BX,DX;商品遍历完毕
        JE  FUNC3
		
LOPD:   MOV AL,IN_GOODS[SI+2];
        CMP AL,[BX][SI]
        JNE NEXT
        INC SI
        DEC CL
        JNE LOPD
		;最后一位比较
        MOV AL,IN_GOODS[SI+2]
        CMP AL,0DH
        JNE NEXT
		
        MOV BP,BX;把第一个商店该商品的地址保存
        CMP AUTH,1 
        JE  CALC
        MOV BYTE PTR[BX][SI],'$';补上$输出商品名称
        MOV DX,BX
        MOV AH,9
        INT 21H
		MOV DL,0AH;换行
		MOV AH,2
		INT 21H
        JMP NOTICE
        
PRE_CALC: LEA CX,S1;第二个商店处理地址计算
        SUB BX,CX
        LEA AX,S2
        ADD BX,AX;第二个商店对应商品位置
		
CALC:   ADD BX,10;转到属性部分
        MOV SI,2;销售价
        MOV AX,WORD PTR[BX][SI]
        MOV SI,6;销售数量
        MOV DX,WORD PTR[BX][SI]
        IMUL AX,DX;销售价*销售数量
        MOV SI,0;
        MOV DX,WORD PTR[BX][SI]
        MOV  SI,4
        IMUL DX,WORD PTR[BX][SI];成本
        MOV  DI,DX
		SUB  AX,DX
		MOV  CX,100
	    IMUL  CX;百分数
        IDIV  DI;利润率存在AX中
        MOV  SI,8
        MOV  [BX][SI],AX;存储到内存中
		SUB  BX,10;移到商品原位置
        CMP  BX,BP
        JE   PRE_CALC
		
		ADD  BP,10;移到属性位置
		ADD  BX,10;
        MOV  AX,DS:[BP][SI]
        ADD  AX,[BX][SI]
        CWD ;扩展后进行字的除法 
        MOV  DI,2
        IDIV DI;平均利润率

FUNC4:  CMP  AX,A_LEVEL
        JGE  A_SHOW
        CMP  AX,B_LEVEL
        JGE  B_SHOW
        CMP  AX,C_LEVEL
        JGE  C_SHOW
        CMP  AX,D_LEVEL
        JGE  D_SHOW
        JMP  F_SHOW
A_SHOW: MOV DL,'A'
        JMP SHOW
B_SHOW: MOV DL,'B'
        JMP SHOW
C_SHOW: MOV DL,'C'
        JMP SHOW
D_SHOW: MOV DL,'D'
        JMP SHOW
F_SHOW: MOV DL,'F'
SHOW:   MOV AH,2H
        INT 21H
		MOV DL,0AH
		MOV AH,2
		INT 21H
        JMP NOTICE
OVER:   MOV AH,4CH
        INT 21H
CODE    ENDS
        END START
