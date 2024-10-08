
;	LSX-Dodgers DISK2
;	MSX

;	PHYDIO DRIVER
;	1セクタ可変(256/512/1024)

WTTRK:
FDWT:
	SCF
	RET

PDWT:
	SCF
	BIT	7,H
	JR	NZ,PDWX
	CALL	FFLUSHBUF
PDWT1:
	PUSH	BC
	PUSH	DE
	LD	DE,(_DTBUF)
	LD	A,(IX+DPB_BPS)	;BCは読み出すセクタサイズ
	AND	7
	LD	B,A
	LD	C,0
	LDIR
	EX	(SP),HL
	EX	DE,HL
	PUSH	DE
	LD	HL,(_DTBUF)
	LD	B,1
	SCF
	CALL	PDWX
	JR	C,PDRWERR
	POP	DE
	INC	DE
	POP	HL
	POP	BC
	DJNZ	PDWT
	XOR	A
	RET
PDRD:
	BIT	7,H
	JR	NZ,PDWXR
	CALL	FFLUSHBUF
PDRD1:
	PUSH	BC
	PUSH	DE
	PUSH	HL
	LD	HL,(_DTBUF)
	LD	B,1
	CALL	PDWXR
	JR	C,PDRWERR
	POP	DE
	LD	HL,(_DTBUF)
	LD	A,(IX+DPB_BPS)	;BCは読み出すセクタサイズ
	AND	7
	LD	B,A
	LD	C,0
	LDIR
	EX	DE,HL
	POP	DE
	INC	DE
	POP	BC
	DJNZ	PDRD
	XOR	A
	RET
PDRWERR:
	POP	HL
	POP	DE
	POP	BC
	RET
PDWXR:
	AND	A
PDWX:					;CF=0 READ CF=1 WRITE
	BIT	4,(IX+DPB_DEVICE)	;デバイス情報
	JR	NZ,PDWX1
	LD	C,(IX+DPB_FATID)	;メディアバイト
PDWX1:
	LD	A,(IX+DPB_UNITNO)	;デバイスドライバ内におけるユニット番号
	PUSH	BC
	PUSH	DE
	PUSH	HL
	PUSH	IX
	PUSH	IY
	CALL	H_PHYD
	POP	IY
;	LD	IX,PHYDIO
;	CALL	CALSLT_R
	POP	IX
	POP	HL
	POP	DE
	POP	BC
	RET	C
PDWX2:
	INC	DE
	LD	A,(IX+DPB_BPS)	;BCは読み出すセクタサイズ
	AND	7
	ADD	A,H
	LD	H,A
	DJNZ	PDWX2
	XOR	A
	RET
