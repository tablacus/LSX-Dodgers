;
;	start up LSX-Dodgers from CDOSII & MSX-DOS & CP/M & LSX-Dodgers
;
;	by Larn M.R.
;
;			for C-DOS
PUTCHR	EQU	21H
ZPR	EQU	2CH
FLOAD	EQU	59H
;
	ORG	100H
	JP	START
START:
	LD	A,(5+2)
	CP	0B0H
	JR	C,CDOS
CPM:
	LD	DE,LD
	CALL	LOAD2
	JP	C,NFERR2
CPM2:
	LD	(FIN),HL
	LD	E,0CH
	LD	C,2
	CALL	SYSTEM
	JR	INIT
;
CDOS:
	LD	DE,LD
	CALL	LOAD
	JP	C,NFERR
CDOS2:
	LD	(FIN),HL
;
	LD	A,0CH
	RST	08H
	DB	PUTCHR
INIT:
	LD	A,(DATA)
	CP	0FEH
	JP	NZ,0
;
	DI
	LD	BC,1FA0H	;INIT CTC
	LD	A,35H
	OUT	(C),A
	XOR	A
	OUT	(C),A
	LD	D,47H
	LD	E,3
CTC:
	INC	C
	OUT	(C),D
	OUT	(C),A
	DEC	E
	JR	NZ,CTC
;
	LD	BC,1F91H	;INIT SIO
	LD	D,1
	OUT	(C),D
	OUT	(C),A
	INC	C
	INC	C
	OUT	(C),D
	OUT	(C),A
;
	LD	BC,1F80H	;INIT DMA
	LD	A,0C3H
	OUT	(C),A
	OUT	(C),A
	OUT	(C),A
	OUT	(C),A
	OUT	(C),A
	OUT	(C),A
;
	LD	BC,1000H	;PALET & PRW
	OUT	(C),C
	INC	B
	OUT	(C),C
	INC	B
	OUT	(C),C
	INC	B
	OUT	(C),C
;
	LD	SP,0
	LD	HL,(FIN)
	LD	BC,DATA
	AND	A
	SBC	HL,BC
	LD	B,H
	LD	C,L
	LD	HL,DATA+7
	LD	DE,(DATA+1)
	LDIR

	LD	A,(0FF87H)
	LD	HL,0FF00H
FILL:
	LD	(HL),0
	INC	L
	JR	NZ,FILL
	LD	(0FF87H),A

	LD	HL,(DATA+5)
	JP	(HL)
;
LOAD:				;CDOS
	LD	HL,DATA
	LD	BC,6800H
	RST	08H
	DB	FLOAD
	RET	C
	LD	A,(8804H)
	LD	(0FF87H),A
	XOR	A
	RET
NFERR:
	RST	08H
	DB	ZPR
	DB	" LD.BIN が見つかりません",0DH,0AH,0
	RET
;
LOAD2:				;CP/M
	LD	C,0FH
	CALL	SYSTEM
	RET	C
	PUSH	DE
	POP	IX
	XOR	A
	LD	(IX+12),A
	LD	(IX+32),A
	LD	HL,DATA
LOAD3:
	EX	DE,HL
	LD	C,1AH
	CALL	SYSTEM
	EX	DE,HL
	LD	C,14H
	CALL	SYSTEM
	RET	C
	PUSH	DE
	LD	DE,0080H
	ADD	HL,DE
	POP	DE
	OR	A
	JR	Z,LOAD3
;
	LD	C,19H
	CALL	SYSTEM
	LD	(0FF87H),A
	XOR	A
	RET
;
NFERR2:
	LD	DE,ERRMES
	LD	C,09H
SYSTEM:
	PUSH	BC
	PUSH	DE
	PUSH	HL
	CALL	0005H
	POP	HL
	POP	DE
	POP	BC
	CP	0FFH
	SCF
	RET	Z
	AND	A
	RET

;
;		   12	 3   4   5   6   7   8  123
LD:	DB	0,"LD",20H,20H,20H,20H,20H,20H,"BIN"
	DS	25,0
;
ERRMES:	DB	" LD.BIN が見つかりません",0DH,0AH,"$"
;
FIN:	DW	0
;
DATA:
