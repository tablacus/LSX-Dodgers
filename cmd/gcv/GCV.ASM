;	GCV	by Gaku
;
WBOOT	EQU	$0000
SYSTEM	EQU	$0005
BUFFA	EQU	$1000

THOLD	EQU	11
CCTRL	EQU	4

	ORG	$0100
	JP	START
START:
	LD	C,$6F 		;(BDOS)MSX-DOS のバージョン番号の獲得(_DOSVER)
	CALL	SYSTEM
	LD	A,C
	CP	$1D
	RET	NZ
	LD	A,L
	AND	$7F
	RET	NZ

	LD	SP,(SYSTEM+1)

	LD	DE,TITLE
	LD	C,9
	CALL	SYSTEM

	LD	DE,$0081
MAIN:
	CALL	_SPSK
SW1:
	LD	A,(DE)
	INC	DE
	CP	"-"
	JR	Z,SW1
	CP	"/"
	JR	Z,SW1

	CALL	_CAP

	CP	"E"
	JP	Z,MC
	CP	"D"
	JP	Z,CM
	CP	"C"
	JR	NZ,SW2
	LD	(CAMUS+1),A
	JR	START1
SW2:
	CP	"2"
	JR	Z,START1
	CP	"4"
	JP	NZ,USAGE
	LD	A,$37
	LD	(PATCH),A
START1:
	CALL	_G1FD0
	LD	D,A
	LD	E,A
	RES	4,E		;BANK0
	SET	4,D		;BANK1
	EXX
	LD	BC,$C000
	CALL	SUB1
CAMUS:	LD	A,$00
	OR	A
	LD	BC,$C000
	CALL	NZ,SUBC

	LD	BC,$8000
	CALL	SUB1
	LD	A,(CAMUS+1)
	OR	A
	LD	BC,$8000
	CALL	NZ,SUBC

	LD	BC,$4000
	CALL	SUB1
	LD	A,(CAMUS+1)
	OR	A
	LD	BC,$4000
	CALL	NZ,SUBC
	JP	0

SUBC:
	EXX
	LD	A,D	;BANK1
	CALL	_S1FD0
	EXX
	LD	A,THOLD+1
	LD	(TPAT1+1),A
	LD	(TPAT2+1),A
	LD	A,CCTRL-1
	LD	(SPAT+1),A

	CALL	SUBC2

	LD	A,THOLD
	LD	(TPAT1+1),A
	LD	(TPAT2+1),A
	LD	A,CCTRL
	LD	(SPAT+1),A

	RET



SUB1:
	PUSH	BC
	LD	HL,NEXT1
	LD	DE,NEXT1+1
	LD	BC,642*2+1
	LD	(HL),0
	LDIR
	POP	BC

	LD	DE,$4000
	LD	HL,BUFFA
	PUSH	BC
LOOP0:
	EXX
	LD	A,E	;BANK0
	CALL	_S1FD0
	EXX
	IN	A,(C)
	LD	(HL),A
	INC	HL
	EXX
	LD	A,D	;BANK1
	CALL	_S1FD0
	EXX
	IN	A,(C)
	LD	(HL),A
	INC	HL
	INC	BC
	DEC	DE
	LD	A,D
	OR	E
	JR	NZ,LOOP0
	POP	BC

	EXX
	LD	A,E	;BANK0
	CALL	_S1FD0
	EXX
SUBC2:
	LD	HL,BUFFA
	LD	D,25		;25LINE

LOOP1:
	LD	E,8
LOOP2:
	PUSH	DE

PATCH:	OR	A
	JR	NC,SKIP200
	EXX
	LD	A,E	;BANK0
	CALL	_S1FD0
	EXX
	PUSH	BC
	PUSH	HL
	CALL	SUB2
	POP	HL
	POP	BC
	EXX
	LD	A,D	;BANK1
	CALL	_S1FD0
	EXX
SKIP200:
	CALL	SUB2

	POP	DE
	DEC	E
	JR	Z,SKIP1

	LD	A,C
	SUB	80
	LD	C,A
	LD	A,B
	SBC	A,$F8
	LD	B,A

	LD	A,L
	SUB	80
	LD	L,A
	LD	A,H
	SBC	A,$F0
	LD	H,A
	JP	LOOP2

SKIP1:	DEC	D
	RET	Z
	LD	A,B
	SUB	$38
	LD	B,A
	LD	A,H
	SUB	$70
	LD	H,A
	JP	LOOP1

SUB2:
	LD	D,40		;40CHARCTER(4*80*+2=640DOT)
	LD	IX,(NEXTX1)
	LD	IY,(NEXTX2)

LOOP3:
	LD	E,8		;8DOT

LOOP4:
	PUSH	DE		;POINT
	LD	E,H
	LD	A,H
	ADD	A,8
	LD	D,A
	XOR	A
	RLC	(HL)
	RLA
	LD	H,D
	RLC	(HL)
	RLA
	LD	H,E
	INC	HL
	RLC	(HL)
	RLA
	LD	H,D
	RLC	(HL)
	RLA
	DEC	HL
	LD	H,E
SPAT:	SUB	CCTRL
	JR	NC,PLUS
	XOR	A
PLUS:
	PUSH	AF
	PUSH	AF
	LD	A,2
LOOP5:
	EX	AF,AF'
	POP	AF
	ADD	A,(IX+0)	;ADD
	LD	(IX+0),0
TPAT1:	CP	THOLD
	JR	C,PSET
TPAT2:	SUB	THOLD
PSET:
	CCF
	EXX
	ADC	HL,HL	;PSET (CF=1)
	EXX

	LD	D,A
	SRL	D
	SUB	D
	LD	E,D		;E=A/2
	SRL	D
	SUB	D
	PUSH	DE		;A=A/4
	SRL	D
	SUB	D
	PUSH	DE		;A=A/8

	ADD	A,(IY+0)	;Y+1
	LD	(IY+0),A

	POP	AF		;A=A/8
	ADD	A,(IY+1)	;Y+1 X+1
	LD	(IY+1),A

	POP	AF		;A=A/4
	ADD	A,(IY-1)	;Y+1 X-1
	LD	(IY-1),A

	LD	A,E		;E=A/2	;X+1
	ADD	A,(IX+1)
	LD	(IX+1),A

	INC	IX
	INC	IY

	EX	AF,AF'
	DEC	A
	JR	NZ,LOOP5

	POP	DE
	DEC	E
	JR	NZ,LOOP4

	EXX
	LD	A,H		;DATA HIGH
	EXX
	OUT	(C),A

	INC	BC
	EXX
	LD	A,L		;DATA LOW
	EXX
	OUT	(C),A
	INC	BC

	INC	HL
	INC	HL

	DEC	D
	JR	NZ,LOOP3

	LD	IX,(NEXTX1)	;DATA SWAP
	LD	IY,(NEXTX2)
	LD	(NEXTX1),IY
	LD	(NEXTX2),IX
	RET

;	Encode
MC:
	PUSH	DE

	CALL	_G1FD0
	SET	4,A		;BANK1
	CALL	_S1FD0

	CALL	MC0

	CALL	_G1FD0
	RES	4,A		;BANK0
	CALL	_S1FD0

	CALL	MC0

	POP	DE
	LD	A,$37
	LD	(USPAT),A
	JP	MAIN

MC0:
	LD	BC,$C000
	CALL	MCSUB
	LD	BC,$8000
	CALL	MCSUB
	LD	BC,$4000

MCSUB:
	LD	DE,$4000
	LD	HL,BUFFA
	PUSH	BC
MC1:
	INI
	INC	B
	INC	BC
	DEC	DE
	LD	A,D
	OR	E
	JR	NZ,MC1
	POP	BC

	LD	HL,BUFFA

	LD	A,8
MC2:
	EX	AF,AF'
	LD	D,25
MC3:
	LD	E,40
MC4:
	INC	B
	OUTI
	INC	BC
	DEC	E
	JR	NZ,MC4

	PUSH	BC
	LD	BC,$400-40
	ADD	HL,BC
	POP	BC
	LD	E,40
MC5:
	INC	B
	OUTI
	INC	BC
	DEC	E
	JR	NZ,MC5

	LD	A,H
	SUB	4
	LD	H,A

	DEC	D
	JR	NZ,MC3

	LD	A,C
	ADD	A,48
	LD	C,A
	ADC	A,B
	SUB	C
	LD	B,A

	PUSH	BC
	LD	BC,1048
	ADD	HL,BC
	POP	BC

	EX	AF,AF'
	DEC	A
	JR	NZ,MC2
	RET

CM:
	PUSH	DE

	CALL	_G1FD0
	SET	4,A		;BANK1
	CALL	_S1FD0

	CALL	CM0

	CALL	_G1FD0
	RES	4,A		;BANK0
	CALL	_S1FD0

	CALL	CM0

	POP	DE
	LD	A,$37
	LD	(USPAT),A
	JP	MAIN

CM0:
	LD	BC,$C000
	CALL	CMSUB
	LD	BC,$8000
	CALL	CMSUB
	LD	BC,$4000
CMSUB:
	LD	DE,$4000
	LD	HL,BUFFA
	PUSH	BC
CM1:
	INI
	INC	B
	INC	BC
	DEC	DE
	LD	A,D
	OR	E
	JR	NZ,CM1
	POP	BC

	LD	HL,BUFFA

	LD	A,8

CM2:
	EX	AF,AF'
	LD	D,25
CM3:
	LD	E,40
CM4:
	INC	B
	OUTI
	INC	BC
	DEC	E
	JR	NZ,CM4

	PUSH	HL
	LD	HL,$400-40
	ADD	HL,BC
	LD	C,L
	LD	B,H
	POP	HL
	LD	E,40
CM5:
	INC	B
	OUTI
	INC	BC
	DEC	E
	JR	NZ,CM5

	LD	A,B
	SUB	4
	LD	B,A

	DEC	D
	JR	NZ,CM3

	LD	A,L
	ADD	A,48
	LD	L,A
	ADC	A,H
	SUB	L
	LD	H,A

	PUSH	HL
	LD	HL,1048
	ADD	HL,BC
	LD	C,L
	LD	B,H
	POP	HL

	EX	AF,AF'
	DEC	A
	JR	NZ,CM2
	RET
USAGE:
	XOR	A
USPAT:	NOP
	JP	C,0
	LD	DE,TITLE1
	LD	C,9
	CALL	SYSTEM
	JP	0

SS1:
	INC	DE
_SPSK:
	LD	A,(DE)
	CP	$20
	JR	Z,SS1
	RET

_CAP:
	CP	"a"
	RET	C
	CP	"z"+1
	RET	NC
	SUB	$20
	RET

_G1FD0:
	PUSH	BC
	LD	C,$BF
	LD	A,(WBOOT+2)
	LD	B,A
	LD	A,(BC)
	POP	BC
	RET
_S1FD0:
	PUSH	BC
	LD	BC,(WBOOT+1)
	LD	C,$BF
	LD	(BC),A
	LD	BC,$1FD0
	OUT	(C),A
	POP	BC
	RET

TITLE:
	DB	"graphic converter v1.03",$0D,$0A,"$"
TITLE1:
	DB	"usage:",$0D,$0A
	DB	" GCV [ｽｲｯﾁ]",$0D,$0A
	DB	$0D
	DB	9,"/2 4096 color -> 8 color 200line",$0D,$0A
	DB	9,"/4 4096 color -> 8 color 400line",$0D,$0A
	DB	9,"/C 4096 color -> 8 color 400line(Camus)",$0D,$0A
	DB	9,"/D Decode",$0D,$0A
	DB	9,"/E Encode",$0D,$0A
	DB	"$"

NEXTX1:	DW	NEXT1+1

NEXTX2:	DW	NEXT2+1

NEXT1:

NEXT2:	EQU	NEXT1+642
