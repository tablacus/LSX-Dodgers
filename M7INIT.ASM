
;	LSX-Dodgers INIT
;	MZ-700/1500

	JP	START
	DW	MACW
	DW	VER

START:
	DI
	IM	1
	LD	SP,START
	CALL	INIT		;NZならAUTOEXECを実行
	LD	HL,0
	PUSH	HL
	RET	Z
	LD	DE,AUTOD
	JP	_COMANL

INIT:
	OUT	(0E0H),A	;DRAM(0000H-0FFFH)
	OUT	(0E1H),A	;DRAM(D000H-FFFFH)
	LD	HL,INITE
	LD	DE,BDOS
	LD	BC,LAST_ADR-INITE
	LDIR
	LD	HL,M7BEEPD
	LD	DE,BEEPD+1
	LD	BC,M7BEEPE-M7BEEPD
	LDIR

	LD	HL,0
	LD	B,05CH
	DB	03EH	;LD A,??
	RST	28H
	CALL	FILL_MEMORY
	LD	B,0A4H
	XOR	A
	LD	(_DVSW),A
	CALL	FILL_MEMORY

	LD	A,0C3H		;JP
	LD	HL,CPM_WBOOT
	LD	(00000H),A
	LD	(00001H),HL	;IPL

	LD	HL,BDOS
	LD	(00005H),A
	LD	(00006H),HL	;BDOS

	LD	HL,TRAP38	;TRAP38
	LD	(00028H),A
	LD	(00029H),HL	;RST 028H

	LD	(00038H),A
	LD	HL,IO_INT8253
	LD	(00039H),HL

	LD	HL,_DISKE+1
	LD	(DISKVE),HL
	LD	HL,_BREAK+1
	LD	(BREAKV),HL

	LD	A,CPM_BOOT/256
	LD	(0000BH),A

	LD	A,0E9H		;JP (HL)
	LD	(0000FH),A
				;CHECK PCG(MZ-1500)
	LD	HL,0E800H
	LD	B,(HL)
	DI
	LD	A,1
	OUT	(0E5H),A	;MZ-1500: PCGバンク切り替え
	LD	C,(HL)
	LD	A,C
	ADD	A,0A5H
	LD	E,A
	LD	(HL),E
	OUT	(0E6H),A	;MZ-1500: PCGバンクを閉じる
	LD	(HL),C
	LD	A,1
	OUT	(0E5H),A	;MZ-1500: PCGバンク切り替え
	LD	A,(HL)
	CP	E
	OUT	(0E6H),A	;MZ-1500: PCGバンクを閉じる
	LD	(HL),B
	EI
	JR	Z,MZ1500
	XOR	A		;MZ-700はPCGバンクが存在しない
	LD	(GRAMFL),A
MZ1500:
	LD	IX,EMMFL
	CALL	CHECK_EMM_BPB
	CP	0EBH
	JR	Z,EMM_BPB
	LD	(IX+DPB_MAXSEC),2	;BPBが512バイト目から始まる場合を調べる
	CALL	CHECK_EMM_BPB
	CP	(IX+DPB_FATID)
	JR	NZ,EMM_BPB
	LD	(IX+DPB_MAXSEC),0	;BPBが先頭の場合に戻す

	LD	HL,0E003H		;SOUND MASK (MZ-1500)
	XOR	A
	CALL	WRMMIO
EMM_BPB:
	LD	HL,INIMES
	CALL	MSX
INIT1:
	DI
	LD	DE,0FF00H
	LD	B,0
	CALL	ZERO_MEMORY_DE
	LD	HL,EXTBIO
	LD	(HL),0C9H	;RET
	INC	HL
	LD	B,TRAP38-EXTBIO-1
	DB	03EH	;LD A,??
	RST	28H
	CALL	FILL_MEMORY
	LD	HL,AT_TRAP38
	LD	DE,TRAP38
	LD	BC,AT_TRAPE-AT_TRAP38
	LDIR

	CALL	CHKEY
	CP	3
	RET

CHECK_EMM_BPB:
	PUSH	DE
	LD	DE,0
	CALL	EADR
	POP	DE
	IN	A,(C)
	RET

AUTOD:	DB	"AUTOEXEC "
AUTODV:	DB	"A:",0

INIMES:	DB	00CH,"LSX-Dodgers for MZ-700/1500 v"
	DB	030H + VER_1, '.'
	DB	030H + VER_2 ,030H + VER_3
	DB	'b'
	DB	" Gaku",0DH,0AH
	DB	0

M7BEEPD:
	DB	8,1
	DB	7,036H
	DB	4,0F9H
	DB	4,3
	DB	3,1			;SOUND MASK(MZ-1500)
M7BEEPE:

AT_TRAP38:
	ORG	TRAP38,AT_TRAP38-OFFSET
	LD	HL,0
	EX	(SP),HL
	LD	A,'$'
	CALL	MSG_A
	DEC	HL
	LD	A,H
	CALL	PRHX
	LD	A,L
PRHX:
	PUSH	AF
	RLCA
	RLCA
	RLCA
	RLCA
	CALL	PRHX2
	POP	AF
PRHX2:
	AND	00FH
	CP	10
	CCF
	ADC	A,'0'
	DAA
	JP	MSG_A
	DS	4
	ORG	$$+OFFSET,$$	;$DEPHASE
AT_TRAPE:

INITE:
	ORG	BDOS,INITE-OFFSET

	JP	IO_BDOS
