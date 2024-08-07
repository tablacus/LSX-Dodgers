
;	LSX-Dodgers DISK2
;	MZ-700/1500

;	EMM DRIVER
;	1セクタ可変(256/512/1024)

EDWT:
	PUSH	AF
	CALL	EADR
	LD	B,0
EDWT1:
	OTIR
	DEC	A
	JR	NZ,EDWT1
	JR	EDRW1

EDRD:
	PUSH	BC
	CALL	EADR
	LD	B,0
EDRD1:
	INIR
	DEC	A
	JR	NZ,EDRD1
EDRW1:
	POP	AF
	ADD	A,E	;セクタを進める
	LD	E,A
	ADC	A,D
	SUB	E
	LD	D,A
	RET

EADR:
	PUSH	DE
	EX	DE,HL
	LD	A,B
	LD	B,(IX+DPB_BPS)
EADR1:				;読み込むセクタ数と1クラスタのセクタ数を掛ける
	RR	B
	JR	C,EADR2
	ADD	A,A
	ADD	HL,HL
	JR	EADR1
EADR2:
	LD	C,(IX+DPB_MAXSEC)
	LD	B,(IX+DPB_MAXCYL)
	ADD	HL,BC
	LD	C,(IX+DPB_UNITNO)
	OUT	(C),0		;Z80未定義命令
	INC	C
	OUT	(C),L
	INC	C
	OUT	(C),H
	INC	C
	EX	DE,HL
	POP	DE
	RET

;	CMOS BACKUP MEMORY DRIVER(32KB)
;	1セクタ256

CDWT:
	LD	A,B
	LD	C,(IX+DPB_UNITNO)
	IN	B,(C)		;アドレスカウンタを0000にリセット
	OUT	(C),E		;W)アドレスカウンタ上位
	LD	BC,000FAH
CDWT1:
	OTIR			;W)データ書き込み・アドレスカウンタ+1
	INC	DE
	DEC	A
	JR	NZ,CDWT1
	AND	A
	RET

CDRD:
	LD	A,B
	LD	C,(IX+DPB_UNITNO)
	IN	B,(C)		;アドレスカウンタを0000にリセット
	OUT	(C),E		;W)アドレスカウンタ上位
	LD	BC,000F9H
CDRD1:
	INIR			;R)データ読み出し・アドレスカウンタ+1
	INC	DE
	DEC	A
	JR	NZ,CDRD1
	AND	A
	RET

;	RAM DISK DRIVER (64KB)
;	1セクタ256

RDWT:
	LD	A,0B3H		;OTIR
	JR	RDRW
RDRD:
	LD	A,0B2H		;INIR
RDRW:
	LD	(RDRW_SWC),A

	LD	A,B
	LD	B,E		;B=アドレスカウンタ上位(X1の様な16bitのI/Oアクセス)
	LD	C,0EBH
	OUT	(C),0		;0=アドレスカウンタ下位
	DEC	C		;EA(R)データ読み出し・アドレスカウンタ+1
	LD	B,0
RDRW1:
	INIR			;自己書き換え(INIR/OTIR)
RDRW_SWC	EQU	$-1
	INC	DE
	DEC	A
	JR	NZ,RDRW1
	AND	A
	RET

;	G-RAM(PCG) DISK DRIVER (24KB)
;	1セクタ256

GDWT:
	PUSH	BC
	PUSH	DE
	CALL	GADR
GDWT2:
	LD	C,(HL)
	INC	HL
	EX	DE,HL	;HL=PCG,DE=メモリ
	CALL	WR_PCG
	INC	HL
	EX	DE,HL	;HL=メモリ,DE=PCG
	DJNZ	GDWT2
	POP	DE
	INC	E
	POP	BC
	DJNZ	GDWT
	RET
GDRD:
	PUSH	BC
	PUSH	DE
	CALL	GADR
GDRD2:
	EX	DE,HL	;HL=PCG,DE=メモリ
	CALL	RD_PCG
	INC	HL
	EX	DE,HL	;HL=メモリ,DE=PCG
	LD	(HL),C
	INC	HL
	DJNZ	GDRD2
	POP	DE
	INC	E
	POP	BC
	DJNZ	GDRD
	RET

GADR:
	LD	A,E
	AND	01FH
	ADD	A,0D0H
	LD	D,A
	LD	A,E
	RLCA
	RLCA
	RLCA
	INC	A
	LD	B,0
	LD	E,B
	RET
