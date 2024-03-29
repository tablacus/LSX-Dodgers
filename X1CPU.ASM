
;	LSX-Dodgers CPU
;	X1/turbo/Z

;	ノンターボ用パッチ
;	DMAを使って転送している部分をCPUに差し替える

AT_SCR1:
	EXX
	PUSH	BC
	LD	BC,(_WIDTH)
	LD	B,020H
	EXX
	PUSH	BC
	LD	BC,02000H

	LD	H,A
	OR	A
AT_SCRUP1:
	JR	Z,AT_SCRCL
	PUSH	BC
	SET	4,B
	EXX
	PUSH	BC
	SET	4,B
	EXX
	CALL	AT_UPSUB+AT_RS
	EXX
	POP	BC
	EXX
	POP	BC
	CALL	AT_UPSUB+AT_RS
	DEC	H
	JR	AT_SCRUP1

AT_SCRCL:
	LD	HL,(_WIDTH)
	CALL	LINECL
	POP	BC
	EXX
	POP	BC
	EXX
	RET

AT_UPSUB:
	LD	A,(_WIDTH)
	LD	L,A
AT_UPSUB1:
	EXX
	IN	A,(C)
	INC	BC
	EXX
	OUT	(C),A
	INC	BC
	DEC	L
	JR	NZ,AT_UPSUB1
	RET

;	FLOPPY DISK DRIVER(CPU)

DISKC:
	DEC	DE
	BIT	3,A
	CALL	NZ,RNF
DISKD:
	PUSH	HL
	LD	HL,RETRY
	DEC	(HL)
	POP	HL
	JR	NZ,AT_ERR		;Retry
	OR	A
	JR	Z,AT_ERR		;Error

AT_DELP:
	CALL	RNF
	CALL	FDMOFF
	LD	A,0FFH
AT_ERRZ:
	CP	A
AT_ERR:
	LD	A,0FFH
	RET
ERRW:
	LD	A,0FFH
	CP	A
	SCF
	JP	FDMOFF

ERRDW:
	POP	DE
	CALL	AT_DELP+AT_RS
	JP	NZ,DWT0+AT_R
	OR	A
	JR	NZ,ERRW
	RET

ERRDR:
	POP	DE
	CALL	AT_DELP+AT_RS
	JP	NZ,DRD0+AT_R
	OR	A
	JR	NZ,ERRW
	RET

AT_WTTRK:
	LD	B,1
	LD	A,0F4H		;FDC TypeIIIコマンド Write Track
	JP	AT_WTTRK1+AT_R

AT_SCRN:
	IN	A,(C)
	RET
AT_SCRE:

AT_DWT:
	LD	A,0A0H		;FDC TypeIIコマンド Write Sector
AT_WTTRK1:
	LD	(FDCSWC),A
DWTBL:
	LD	A,B
	LD	(AT_WTB+1+AT_R),A
	LD	A,2		;Retry count
	LD	(RETRY),A
DWT0:
	PUSH	DE
	PUSH	HL
	CALL	SEEK		;Write disk
	POP	HL
	JP	C,ERRDW+AT_RS
	DI
	CALL	SECSET_FDCCMD
	LD	C,0FBH		;MB8877A データレジスタ
DWT1:
	LD	D,(HL)
DWT2:
	LD	A,B
	IN	A,(0F8H)	;MB8877A ステータス／コマンドレジスタ
	RRCA
	JR	NC,DWT4
	RRCA
	JR	NC,DWT2
DWT3:
	OUT	(C),D
	INC	HL
	JR	DWT1

DWT4:
	DEC	A
	JR	Z,DWT3
	INC	A
	EI
	POP	DE
	INC	DE
	CALL	FDMOFF
	JR	Z,DISKOK_WT
	CALL	DISKC+AT_RS
	JR	NZ,DWT0
	OR	A
	JP	NZ,ERRW+AT_RS

DISKOK_WT:
AT_WTB:	LD	B,1
	DJNZ	DWTBL
	RET

AT_DRD:
	LD	A,080H		;FDC TypeIIコマンド Read Sector
	LD	(FDCSWC),A
DRDBL:
	LD	A,B
	LD	(AT_RDB+1+AT_R),A
	LD	A,2		;Retry count
	LD	(RETRY),A
DRD0:
	PUSH	DE
	PUSH	HL
	CALL	SEEK		;Read disk
	POP	HL
	JP	C,ERRDR+AT_RS
	DI
	CALL	SECSET_FDCCMD
	LD	C,0FBH		;MB8877A データレジスタ
DRD1:
	LD	A,B
	IN	A,(0F8H)	;MB8877A ステータス／コマンドレジスタ
	RRCA
	JR	NC,DRD3
	RRCA
	JR	NC,DRD1
	INI
	INC	B
	JR	DRD1

DRD3:
	OR	A
	EI
	POP	DE
	INC	DE
	CALL	FDMOFF
	JR	Z,DISKOK_RD
	CALL	DISKC+AT_RS
	JR	NZ,DRD0
	OR	A
	JP	NZ,ERRW+AT_RS

DISKOK_RD:
AT_RDB:	LD	B,1
	DJNZ	DRDBL
	RET

AT_CPUE:

AT_RT	EQU	TRAP38-AT_TRAP38

INITE:
	DS	BDOS-INITE
	JP	BDOS0
