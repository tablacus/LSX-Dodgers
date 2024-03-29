;
;	MAG save  by Gaku
;
SAVE:
	LD	HL,(SYSTEM+1)
	LD	BC,WBUF+$0200
	SCF
	SBC	HL,BC
	JP	C,0
	JP	Z,0

	RES	0,L
	LD	(WSIZEW+1),HL
	SRL	H
	RR	L
	LD	(WSIZE+1),HL
	LD	B,H
	LD	C,L
	LD	HL,WBUF
	EXX

	LD	HL,(L200X1+1)
	LD	E,"."
	PUSH	HL
	CALL	PUTSTR
	POP	HL
	LD	E,8
	CALL	PUTSTR

	LD	HL,ZFLAGB
	LD	DE,ZFLAGB+1
	LD	BC,159
	LD	(HL),0
	LDIR

	LD	HL,0
L200X1:	LD	BC,400
SAVE1:
	PUSH	BC
	LD	(LOCY+1),HL

	LD	IX,ZFLAGB
	XOR	A
SAVE2:
	LD	(LOCX+1),A
	LD	HL,(LOCY+1)

	CALL	POINT
	EX	DE,HL

	LD	A,(IX+0)
	OR	A
	JR	Z,UPE

	ADD	A,A
	LD	C,A
	LD	B,0
	CALL	MPOINT
	JR	Z,HITU

UPE:
	LD	BC,$0F00
SAVE3:
	PUSH	BC

	LD	B,0
	LD	HL,STABLE0
	ADD	HL,BC
	LD	C,(HL)
	CALL	MPOINT
	JR	Z,HIT
SKIP1:
	POP	BC
	INC	C
	DJNZ	SAVE3

	XOR	A
	JR	ZERO
HITU:
	LD	A,(IX+0)
	JR	ZERO
HIT:
	POP	BC
	LD	B,0
	LD	HL,STABLE1
	ADD	HL,BC
	LD	A,(HL)
ZERO:
	LD	(IX+0),A
	INC	IX
SAVEF:	LD	HL,ZFLAG
	RLD
	LD	A,(LOCX+1)
	RRCA
	JR	NC,SKIP2
	INC	HL
	LD	(SAVEF+1),HL
SKIP2:
	LD	A,(LOCX+1)

	LD	B,0
	ADD	A,A
	RL	B
	LD	C,A

	LD	A,(LOCY+1)
	AND	15
	ADD	A,A
	OR	B
	LD	B,A

	LD	HL,FABF
	ADD	HL,BC
	LD	(HL),E
	INC	HL
	LD	(HL),D

	LD	A,(LOCX+1)
	INC	A
	CP	160
	JP	C,SAVE2

	LD	E,"o"
	LD	C,2
	CALL	SYSTEM

	POP	BC
	LD	HL,(LOCY+1)
	INC	HL
S200X1:	NOP
	DEC	BC
	LD	A,B
	OR	C
	JP	NZ,SAVE1

	LD	HL,ZFLAGB
	LD	DE,ZFLAGB+1
	LD	BC,79
	LD	(HL),0
	LDIR

	LD	HL,FABF
	LD	DE,FABF+1
M200X1:	LD	BC,3999
	LD	(HL),1
	LDIR

	LD	HL,ZFLAG
	LD	IY,ZFLAG
L200X2:	LD	BC,400
	LD	DE,0
SAVE4:
	PUSH	BC
	LD	B,80
	LD	IX,ZFLAGB
SAVE5:
	LD	A,(HL)
	LD	C,A
	AND	$F0
	JR	NZ,SAVE6
	INC	DE
SAVE6:
	LD	A,C
	AND	$0F
	JR	NZ,SAVE7
	INC	DE
SAVE7:
	LD	A,C
	XOR	(IX+0)
	LD	(IX+0),C
	JR	Z,SAVE8
	LD	(IY+0),A
	INC	IY
	SCF
SAVE8:
	PUSH	HL
FABFP:	LD	HL,FABF
	RL	(HL)
	JR	NC,SAVE9
	INC	HL
	LD	(FABFP+1),HL
SAVE9:
	POP	HL
	INC	HL
	INC	IX
	DJNZ	SAVE5

	POP	BC
	DEC	BC
	LD	A,B
	OR	C
	JR	NZ,SAVE4

	PUSH	IY
	POP	HL
	LD	BC,ZFLAG
	XOR	A
	SBC	HL,BC
	BIT	0,L
	JR	Z,EVEN
	INC	HL
EVEN:
	LD	(FBSIZE),HL

	LD	BC,(FBST)
	ADD	HL,BC
	LD	(PICST),HL

	XOR	A
	EX	DE,HL
	ADD	HL,HL
	LD	(PICSIZE),HL
	ADC	A,A
	LD	(PICSIZE+2),A

	LD	DE,FCB1
	LD	C,$16
	CALL	SYSTEM
	OR	A
	JP	NZ,0

	LD	HL,0
	LD	(FCB1+33),HL
	LD	(FCB1+35),HL
	INC	L
	LD	(FCB1+14),HL

	LD	DE,MAGID
	LD	C,$1A
	CALL	SYSTEM

M200X2:	LD	HL,4000
	LD	DE,FABF-MAGID
	ADD	HL,DE
	LD	DE,FCB1
	LD	C,$26
	CALL	SYSTEM
	OR	A
	JP	NZ,0

	LD	DE,ZFLAG
	LD	C,$1A
	CALL	SYSTEM

	LD	HL,(FBSIZE)
	LD	DE,FCB1
	LD	C,$26
	CALL	SYSTEM
	OR	A
	JP	NZ,0

	LD	HL,ZFLAGB
	LD	DE,ZFLAGB+1
	LD	(HL),0
	LD	BC,79
	LDIR

	LD	A,1
	LD	(LOOP8),A
	LD	IY,FABF
	LD	HL,0
L200X3:	LD	BC,400
PICS1:
	PUSH	BC
	LD	(PICY+1),HL

	XOR	A
	LD	IX,ZFLAGB
PICS2:
	LD	(PICX+1),A

	XOR	A
	RL	(IY+0)
	JR	NC,YFLAG1

PICSF:	LD	HL,ZFLAG
	LD	A,(HL)
	INC	HL
	LD	(PICSF+1),HL
YFLAG1:
	XOR	(IX+0)
	LD	(IX+0),A

	PUSH	HL
	LD	HL,LOOP8
	RLC	(HL)
	POP	HL
	JR	NC,YFLAG2
	INC	IY
YFLAG2:
	PUSH	AF
	AND	$F0
	JR	NZ,PICS3

PICX:	LD	A,$00
PICY:	LD	HL,0
	ADD	A,A
	CALL	POINT
	CALL	FPUTW
PICS3:
	POP	AF
	AND	$0F
	JR	NZ,PICS4

	LD	A,(PICX+1)
	LD	HL,(PICY+1)
	ADD	A,A
	INC	A
	CALL	POINT
	CALL	FPUTW
PICS4:
	INC	IX
	LD	A,(PICX+1)
	INC	A
	CP	80
	JR	C,PICS2

	LD	HL,(PICY+1)
	INC	HL
S200X2:	NOP
	POP	BC
	DEC	BC
	LD	A,B
	OR	C
	JP	NZ,PICS1

	LD	DE,WBUF
	LD	C,$1A
	CALL	SYSTEM
	EXX
	LD	DE,WBUF
	AND	A
	SBC	HL,DE
	LD	DE,FCB1
	LD	C,$26
	CALL	SYSTEM
	OR	A
	JP	NZ,0

	LD	C,$10
	LD	DE,FCB1
	CALL	SYSTEM
	OR	A
	JP	NZ,0

	LD	DE,COMPL
	LD	C,9
	CALL	SYSTEM
	JP	0

POINT:			;x=AF Y=HL
	PUSH	AF
	LD	A,L		;׽�(0-7)
	AND	$0E
	ADD	A,A
	ADD	A,A
	LD	D,A

	LD	A,L		;��ݸ
	ADD	A,A
	ADD	A,A
	ADD	A,A
	ADD	A,A
	AND	$10
	LD	E,A
SMC20:	LD	A,($ECBF)
	AND	$EF
	OR	E
SMC21:	LD	($ECBF),A
	LD	BC,$1FD0
	OUT	(C),A

	LD	B,H		;ײ�
	LD	A,L
	AND	$F0
	LD	L,A
	LD	C,A
	ADD	HL,HL		;*2
	ADD	HL,HL		;*4
	ADD	HL,BC		;*5

	LD	A,H		;ײ�
	OR	D		;׽�
	OR	$C0

	LD	B,A

	POP	AF
	SRL	A
	JR	C,POINT3

	ADD	A,L
	LD	C,A
	ADC	A,B
	SUB	C
	LD	B,A		;BC=���ڽ

	LD	HL,0

	IN	A,(C)
	CALL	POINT1

	RES	6,B
	IN	A,(C)
	CALL	POINT1

	RES	7,B
	SET	6,B
	IN	A,(C)
	JR	POINT1
POINT3:
	ADD	A,L
	LD	C,A
	ADC	A,B
	SUB	C
	LD	B,A		;BC=���ڽ

	LD	HL,0

	IN	A,(C)
	CALL	POINT2

	RES	6,B
	CALL	POINT2

	RES	7,B
	SET	6,B
POINT2:
	IN	A,(C)
	ADD	A,A
	ADD	A,A
	ADD	A,A
	ADD	A,A
POINT1:
	ADD	A,A
	JR	NC,POI1
	SET	3,L
POI1:
	ADD	A,A
	RL	L

	ADD	A,A
	JR	NC,POI2
	SET	3,H
POI2:
	ADD	A,A
	RL	H
	RET

MPOINT:			;x=AF y=HL
T200X1:	LD	HL,STABLE-2
	ADD	HL,BC

LOCX:	LD	A,$00
	SUB	(HL)
	RET	C

	INC	HL
	LD	C,(HL)

LOCY:	LD	HL,0
	SBC	HL,BC		;CF=0 B=0
	RET	C

	ADD	A,A
	RL	B
	LD	C,A

	LD	A,L
	AND	15
	ADD	A,A
	OR	B
	LD	B,A

	LD	HL,FABF
	ADD	HL,BC
	LD	A,(HL)
	INC	HL
	LD	H,(HL)
	LD	L,A

	SBC	HL,DE
	RET

FPUTW:
	EXX
	LD	A,B
	OR	C
	JR	Z,FPUTW1
FPUTW2:
	EXX
	LD	A,L
	EXX
	LD	(HL),A
	INC	HL
	EXX
	LD	A,H
	EXX
	LD	(HL),A
	INC	HL
	DEC	BC
	EXX
	RET
FPUTW1:
	LD	DE,WBUF
	LD	C,$1A
	CALL	SYSTEM

WSIZEW:	LD	HL,0
	LD	DE,FCB1
	LD	C,$26
	CALL	SYSTEM
	OR	A
	JP	NZ,0

	LD	HL,WBUF
WSIZE:	LD	BC,0
	JR	FPUTW2

PUTSTR:
	LD	C,2
	CALL	SYSTEM
	DEC	HL
	LD	A,H
	OR	L
	JR	NZ,PUTSTR
	RET

COMPL:
	DB	" completed !$"

STABLE0:DB	1*2,4*2,5*2,6*2,7*2,9*2,10*2,2*2
	DB	8*2,11*2,12*2,13*2,14*2,3*2,15*2

STABLE1:DB	1,4,5,6,7,9,10,2,8,11,12,13,14,3,15

STABLE:
	DB	1,0		; 1
	DB	2,0		; 2
	DB	4,0		; 3
	DB	0,1		; 4
	DB	1,1		; 5
	DB	0,2		; 6
	DB	1,2		; 7
	DB	2,2		; 8
	DB	0,4		; 9
	DB	1,4		;10
	DB	2,4		;11
	DB	0,8		;12
	DB	1,8		;13
	DB	2,8		;14
	DB	0,16		;15
STABLE2:
	DB	1,0		; 1
	DB	2,0		; 2
	DB	4,0		; 3
	DB	0,1*2		; 4
	DB	1,1*2		; 5
	DB	0,2*2		; 6
	DB	1,2*2		; 7
	DB	2,2*2		; 8
	DB	0,4*2		; 9
	DB	1,4*2		;10
	DB	2,4*2		;11
	DB	0,8*2		;12
	DB	1,8*2		;13
	DB	2,8*2		;14
	DB	0,16*2		;15

LOOP8:	DB	1

MAGID:
	DB	"MAKI02  "
	DB	" X1  "
USER:	DB	">",$93,$E4,"<"
	DS	15,$20
	DB	$1A
SHEAD:
	DB	0
	DB	0
	DB	0
SCMODE:	DB	$06
	DW	0
	DW	0
	DW	639
L200X4:	DW	399
	DW	$0050,0		;A
FBST:	DW	$0FF0,0		;B
FBSIZE:	DW	0,0
PICST:	DW	0,0		;�߸��
PICSIZE:DW	0,0
DEGI8:
	DB	$00,$00,$00
	DB	$00,$00,$FF
	DB	$00,$FF,$00
	DB	$00,$FF,$FF
	DB	$FF,$00,$00
	DB	$FF,$00,$FF
	DB	$FF,$FF,$00
	DB	$FF,$FF,$FF
	DB	$00,$00,$00
	DB	$00,$00,$FF
	DB	$00,$FF,$00
	DB	$00,$FF,$FF
	DB	$FF,$00,$00
	DB	$FF,$00,$FF
	DB	$FF,$FF,$00
	DB	$FF,$FF,$FF
FABF:

ZFLAG:	EQU	FABF+16*512
ZFLAGB:	EQU	ZFLAG+80*400
WBUF:	EQU	ZFLAGB+160
