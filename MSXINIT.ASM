;	LSX-Dodgers INIT
;	MSX
START:
	DI
	IM	1
	XOR	A				;A=0
	LD	(BANK0_SEL),A			;似非RAM対策でバンク0を設定
	INC	A				;A=1
	LD	(BANK1_SEL),A
	LD	HL,AT_START2
	LD	DE,START2
	LD	BC,MSX_E-START2
	LDIR
	JP	START2

INIT_ROM:
	DB	03EH	;LD A,??
	RST	30H
	DI
	LD	(H_STKE),A
	LD	H,040H
	CALL	AT_GETSLT
	LD	HL,H_STKE+1
	LD	(HL),A
	LD	DE,START
	INC	HL
	LD	(HL),E
	INC	HL
	LD	(HL),D

	CALL	RSLREG		;read primary slot #
	RLCA
	RLCA
	LD	H,0C0H
	CALL	AT_GETSLT
	LD	A,(RAMAD1)
	CALL	FIXRAMAD
	LD	(RAMAD1),A
	LD	A,(RAMAD0)
	CALL	FIXRAMAD
	LD	(RAMAD0),A
	LD	H,080H
	CALL	AT_GETSLT
	LD	(RAMAD2),A

	EI
	RET

FIXRAMAD:
	OR	A
	JR	Z,FIXRAMAD1
	CP	0C9H
	JR	Z,FIXRAMAD1
	CP	0FFH
	RET	NZ
FIXRAMAD1:
	LD	A,(RAMAD3)
	RET

AT_START2:
	ORG	START2,AT_START2-RUN

	LD	SP,START2
	CALL	INIT		;NZならAUTOEXECを実行
INIT_SWC	EQU	$-2
	LD	HL,0
	PUSH	HL
	RET	Z
	LD	DE,AUTOD
	JP	_COMANL

INIT:
	LD	IX,0D90H
	LD	B,0
CHECK_CBIOS1:
	LD	A,(IX+0)
	CP	'C'
	JR	NZ,CHECK_CBIOS2
	LD	A,(IX+1)
	CP	'-'
	JR	NZ,CHECK_CBIOS2
	LD	A,(IX+2)
	CP	'B'
	JR	NZ,CHECK_CBIOS2
	LD	A,(IX+3)
	CP	'I'
	JR	NZ,CHECK_CBIOS2
	LD	A,(IX+4)
	CP	'O'
	JR	NZ,CHECK_CBIOS2
	LD	A,(IX+5)
	XOR	'S'
	JR	NZ,CHECK_CBIOS2

	LD	(CBIOS_SWC1),A
	LD	(CBIOS_SWC2),A

	JR	CHECK_CBIOS3
CHECK_CBIOS2:
	INC	IX
	DJNZ	CHECK_CBIOS1
CHECK_CBIOS3:
	LD	A,(H_STKE+1)
	LD	(ROM_SLT),A

	LD	H,0C0H
	CALL	AT_GETSLT
	LD	(RAMAD3),A
	LD	H,080H
	CALL	AT_GETSLT
	CALL	CHK_RAM
	LD	(RAMAD2),A
RAMCHK2:
	LD	A,(RAMAD3)
	LD	H,040H
	CALL	CHK_RAM
	LD	(RAMAD1),A
RAMCHK1:
	LD	A,(RAMAD3)
	LD	H,00H
	CALL	CHK_RAM
	LD	(RAMAD0),A
RAMCHK0:
	LD	A,(RAMAD0)
	CALL	ENASLT_00H

	LD	HL,0
	LD	B,05CH
	DB	03EH	;LD A,??
	RST	28H
	CALL	FILL_MEMORY
	LD	B,0A4H
	XOR	A
	LD	(_DVSW),A
	CALL	FILL_MEMORY

	CALL	SET_BDOS
	CALL	SET_ISC

	LD	A,(RAMAD1)
	CALL	ENASLT_40H
				;MSXワークエリア
	LD	A,3
	LD	(INTFLG),A
				;ROMタイプ判別(ASCII-8K/ASCII-16K)
	LD	E,0
	LD	A,(ROM_SLT)
	LD	HL,BANK1_SEL
	CALL	_WRSLT

	LD	HL,06000H
	LD	A,(ROM_SLT)
	CALL	_RDSLT
	CP	'A'
	JR	Z,ROM8K
				;ASCII-8K/Konami-8Kではない(ASCII-16K)
	DB	03EH	;LD A,??
	NOP
	LD	(ASCII16K1),A
	LD	(ASCII16K2),A
	LD	A,03FH
	LD	(ASCII16K3),A
	JR	ROMCHECKED
ROM8K:				;Konami-8Kチェック
	LD	E,1
	LD	A,(ROM_SLT)
	LD	HL,BANK2_SEL
	CALL	_WRSLT

	LD	E,0
	LD	A,(ROM_SLT)
	LD	HL,KONAMI_BANK2_SEL
	CALL	_WRSLT

	LD	HL,08000H
	LD	A,(ROM_SLT)
	CALL	_RDSLT
	CP	'A'
	JR	NZ,ROMCHECKED
				;Konami-8K
	LD	HL,KONAMI_BANK2_SEL
	LD	(ROM8000H),HL
ROMCHECKED:

	LD	A,40
	LD	(LINL40),A
	LD	(_WIDTH),A
	LD	IX,INITXT
	CALL	CALSLT_R
	LD	IX,SETTXT
	CALL	CALSLT_R

	LD	HL,INIMES
	CALL	MSX
INIT1:
	XOR	A
	CP	3
	RET

SET_BDOS:
	DB	03EH	;LD A,??
	JP	(HL)
	LD	(0000FH),A

	LD	A,0C3H		;JP
	LD	HL,CPM_WBOOT
	LD	(00000H),A
	LD	(00001H),HL	;IPL

	LD	HL,BDOS
	LD	(00005H),A
	LD	(00006H),HL	;BDOS

	LD	HL,0
	LD	(00028H),A
	LD	(00029H),HL	;BDOS

				;LSX-Dodgers
	LD	A,CPM_BOOT/256
	LD	(0000BH),A
	RET

SET_ISC:				;インタースロットコール
	LD	A,0C3H		;JP
	LD	HL,RDSLT
	LD	(_RDSLT),A
	LD	(_RDSLT+1),HL

	LD	HL,WRSLT
	LD	(_WRSLT),A
	LD	(_WRSLT+1),HL

	LD	HL,CALSLT
	LD	(_CALSLT),A
	LD	(_CALSLT+1),HL

	LD	HL,ENASLT
	LD	(_ENASLT),A
	LD	(_ENASLT+1),HL

	LD	HL,CALLF
	LD	(_CALLF),A
	LD	(_CALLF+1),HL

	LD	HL,INT38H
	LD	(00038H),A
	LD	(00038H+1),HL

	LD	HL,AT_3B
	LD	DE,ENASUB
	LD	BC,AT_3B_E-AT_3B
	LDIR
	RET
CHK_RAM:
	PUSH	HL
	CALL	CHK_RAM0
	POP	HL
	RET	Z
	LD	A,(EXPTBL)		;スロット#0
	AND	080H
	CALL	CHK_RAM_SLT
	RET	Z
	LD	A,(EXPTBL+1)		;スロット#1
	AND	080H
	ADD	A,1
	CALL	CHK_RAM_SLT
	RET	Z
	LD	A,(EXPTBL+2)		;スロット#2
	AND	080H
	ADD	A,2
	CALL	CHK_RAM_SLT
	RET	Z
	LD	A,(EXPTBL+3)		;スロット#3
	AND	080H
	ADD	A,3
CHK_RAM_SLT:
	PUSH	HL
	CALL	CHK_RAM0		;スロット#X or X-0
	POP	HL
	RET	Z
	BIT	7,C
	JR	Z,CHK_RAM_E		;スロットは拡張されていない
	LD	A,C
	ADD	A,4*1			;スロット#X-1
	PUSH	HL
	CALL	CHK_RAM0
	POP	HL
	RET	Z
	LD	A,C
	ADD	A,4*2			;スロット#X-2
	PUSH	HL
	CALL	CHK_RAM0
	POP	HL
	RET	Z
	LD	A,C
	ADD	A,4*3			;スロット#X-3
	PUSH	HL
	CALL	CHK_RAM0
	POP	HL
CHK_RAM_E:
	XOR	A
	INC	A			;ZF=0にする
	LD	A,0
	RET

CHK_RAM0:
	LD	C,A
	LD	A,(ROM_SLT)
	CP	C
	JR	Z,CHK_RAM_E
	LD	L,0
CHK_RAM1:
	LD	A,C
	LD	IX,_RDSLT
	CALL	CALSLT_RAM
	ADD	A,0E5H
	LD	B,A
	LD	E,A
	LD	A,C
	LD	IX,_WRSLT
	CALL	CALSLT_RAM
	LD	A,C
	LD	IX,_RDSLT
	CALL	CALSLT_RAM
	CP	B
	RET	NZ
	SUB	0E5H
	LD	A,C
	LD	E,A
	LD	IX,_WRSLT
	CALL	CALSLT_RAM
	INC	H
	LD	A,L
	ADD	A,4
	LD	L,A
	JR	NZ,CHK_RAM1
	LD	A,C		;ZF=1のハズ
	RET

CALSLT_RAM:
	PUSH	BC
	PUSH	HL
	LD	IY,(EXPTBL-1) ;メインROMスロット
	CALL	_CALSLT
	POP	HL
	POP	BC
	RET

AUTOD:	DB	"AUTOEXEC "
AUTODV:	DB	"A:",0

INIMES:	DB	00CH,"LSX-Dodgers for MSX v"
	DB	030H + VER_1, '.'
	DB	030H + VER_2 ,030H + VER_3
	DB	'b'
	DB	" Gaku",0DH,0AH
	DB	0

M2DD:	DW	3
	DB	0F9H,2
	DW	715
	DB	0FFH,7,80,9,1,082H
	DW	7,0A7H,10
M2DDE:

INITE:
	DS	BDOS-INITE
	JP	BDOS0
