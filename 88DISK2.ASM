
;	LSX-Dodgers DISK2
;	PC-8801mkIISR

;	BANK RAM DISK DRIVER

BDWT:
	LD	A,010H	;ライト可　リード不可
JR	BRW

BDRD:
	LD	A,001H	;ライト不可　リード可
BRW:
	DI
	OUT	(0E2H),A	;拡張RAM リード/ライト制御
	LD	(BANKSP),SP
	LD	A,(BANKSPH)
	ADD	A,A
	JR	C,BRW1
	LD	SP,EXTSP	;拡張メモリにスタックが重なる場合
BRW1:
	PUSH	BC
	PUSH	DE
	EX	DE,HL		;DE=メインメモリ
	ADD	HL,HL
	ADD	HL,HL
	LD	A,H
	ADD	A,(IX+DPB_MAXCYL)
	OUT	(0E3H),A	;拡張RAM バンク選択
	LD	H,L
	SRL	H	;/2
	LD	L,0
	IN	A,(0E2H)	;拡張RAM リード/ライト制御
	RRCA
	JR	NC,BRW2		;0: リード可
	EX	DE,HL		;DE=拡張メモリ HL=メインメモリ
BRW2:
	LD	BC,512
	LDIR

	IN	A,(0E2H)	;拡張RAM リード/ライト制御
	RRCA
	JR	C,BRW3		;1: リード不可
	EX	DE,HL		;DE=拡張メモリ HL=メインメモリ
BRW3:
	POP	DE
	POP	BC
	INC	DE
	DJNZ	BRW1

	XOR	A
	OUT	(0E2H),A	;メインメモリに切り替える
	LD	SP,0
BANKSP	EQU	$-2
BANKSPH	EQU	$-1
	EI
	RET

