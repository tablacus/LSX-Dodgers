
;	LSX-Dodgers DISK2
;	PC-8801mkIISR

;	BANK RAM DISK DRIVER

BDWT:
	LD	A,010H	;���C�g�@���[�h�s��
JR	BRW

BDRD:
	LD	A,001H	;���C�g�s�@���[�h��
BRW:
	DI
	OUT	(0E2H),A	;�g��RAM ���[�h/���C�g����
	LD	(BANKSP+1),SP
	LD	A,(BANKSP+2)
	ADD	A,A
	JR	C,BRW1
	LD	SP,EXTSP
BRW1:
	PUSH	BC
	PUSH	DE
	EX	DE,HL
	ADD	HL,HL
	ADD	HL,HL
	LD	A,H
	AND	00FH		;�o���N
	OUT	(0E3H),A	;�g��RAM �o���N�I��
	LD	H,L
	SRL	H	;/2
	LD	L,0
	IN	A,(0E2H)	;�g��RAM ���[�h/���C�g����
	RRCA
	JR	NC,BRW2
	EX	DE,HL
BRW2:
	LD	BC,512
	LDIR

	IN	A,(0E2H)	;�g��RAM ���[�h/���C�g����
	RRCA
	JR	C,BRW3
	EX	DE,HL
BRW3:
	POP	DE
	POP	BC
	INC	DE
	DJNZ	BRW1

	XOR	A
	OUT	(0E2H),A	;���C���������ɐ؂�ւ���
BANKSP:	LD	SP,0
	EI
	RET
