
;	LSX-Dodgers DISK
;	PC-8801mkIISR

;	FLOPPY DISK DRIVER
;
PUTCOM_EXECUTE:
	LD	A,0DH		;エグゼキュート
;	コマンド送信
PUTCOM:
	PUSH	AF
	LD	A,00FH
	OUT	(0FFH),A	;ディスクサブシステムI/F 8255 コントロール
	POP	AF
;	通常ハンドシェイク（ホストが送信）
PUTDAT:
	PUSH	AF
PUTDAT1:
	IN	A,(0FEH)	;ディスクサブシステムI/F 8255 ポートC
	AND	2		;RFD
	JR	Z,PUTDAT1
	LD	A,00EH		;ATN=0
	OUT	(0FFH),A	;ディスクサブシステムI/F 8255 コントロール
	POP	AF
	OUT	(0FDH),A	;標準状態ではサブシステムへのデータ送信ポート
	PUSH	AF
	LD	A,9		;DAV=1
	OUT	(0FFH),A
PUTDAT2:
	IN	A,(0FEH)	;ディスクサブシステムI/F 8255 ポートC
	AND	4		;DAC
	JR	Z,PUTDAT2

	LD	A,8		;DAV=0
	OUT	(0FFH),A
PUTDAT3:
	IN	A,(0FEH)	;ディスクサブシステムI/F 8255 ポートC
	AND	4		;DAC
	JR	NZ,PUTDAT3
	POP	AF
	RET

;	通常ハンドシェイク（ホストが受信）
GETDAT:
	LD	A,00BH		;RFD=1
	OUT	(0FFH),A	;ディスクサブシステムI/F 8255 コントロール
GETDAT1:
	IN	A,(0FEH)	;ディスクサブシステムI/F 8255 ポートC
	RRCA			;DAV
	JR	NC,GETDAT1

	LD	A,00AH		;RFD=0
	OUT	(0FFH),A	;ディスクサブシステムI/F 8255 コントロール

	IN	A,(0FCH)	;標準状態ではサブシステムからのデータ受信ポート
	PUSH	AF
	LD	A,00DH		;DAC=1
	OUT	(0FFH),A	;ディスクサブシステムI/F 8255 コントロール

GETDAT2:
	IN	A,(0FEH)	;ディスクサブシステムI/F 8255 ポートC
	RRCA			;DAV
	JR	C,GETDAT2

	LD	A,00CH		;DAC=0
	OUT	(0FFH),A
	POP	AF
	RET

;	高速ハンドシェイク（ホストが送信）
;	HL:アドレス BC:受信サイズ（必ず偶数にする）
FPUTDAT:
FPUTDAT1:
	IN	A,(0FEH)	;ディスクサブシステムI/F 8255 ポートC
	AND	2		;RFD
	JR	Z,FPUTDAT1
	LD	A,00EH		;ATN=0
	OUT	(0FFH),A	;ディスクサブシステムI/F 8255 コントロール

	LD	A,(HL)
	OUT	(0FDH),A	;標準状態ではサブシステムへのデータ送信ポート

	LD	A,9		;DAV=1
	OUT	(0FFH),A
	INC	HL
	DEC	BC
FPUTDAT2:
	IN	A,(0FEH)	;ディスクサブシステムI/F 8255 ポートC
	AND	4		;DAC
	JR	Z,FPUTDAT2

	LD	A,(HL)
	OUT	(0FDH),A	;標準状態ではサブシステムへのデータ送信ポート

	LD	A,8		;DAV=0
	OUT	(0FFH),A
FPUTDAT3:
	IN	A,(0FEH)	;ディスクサブシステムI/F 8255 ポートC
	AND	4		;DAC
	JR	NZ,FPUTDAT3

	CPI			;HL=HL+1 BC=BC-1 BCが0の場合にP/V=0
	RET	PO
	JR	FPUTDAT


;	高速ハンドシェイク（ホストが受信）
;	HL:アドレス BC:受信サイズ（必ず偶数にする）
FGETDAT:
	LD	A,00BH		;RFD=1
	OUT	(0FFH),A	;ディスクサブシステムI/F 8255 コントロール
FGETDAT1:
	IN	A,(0FEH)	;ディスクサブシステムI/F 8255 ポートC
	RRCA			;DAV
	JR	NC,FGETDAT1

	LD	A,00AH		;RFD=0
	OUT	(0FFH),A	;ディスクサブシステムI/F 8255 コントロール

	IN	A,(0FCH)	;標準状態ではサブシステムからのデータ受信ポート
	LD	(HL),A

	LD	A,00DH		;DAC=1
	OUT	(0FFH),A	;ディスクサブシステムI/F 8255 コントロール
	INC	HL
	DEC	BC
FGETDAT2:
	IN	A,(0FEH)	;ディスクサブシステムI/F 8255 ポートC
	RRCA			;DAV
	JR	C,FGETDAT2

	IN	A,(0FCH)	;標準状態ではサブシステムからのデータ受信ポート
	LD	(HL),A

	LD	A,00CH		;DAC=0
	OUT	(0FFH),A

	CPI			;HL=HL+1 BC=BC-1 BCが0の場合にP/V=0
	RET	PO
	JR	FGETDAT

;	論理セクタ番号からトラック番号とセクタ番号を得る
;	in
;	DE:論理セクタ
CALC_SECTOR:
	PUSH	BC
	LD	C,(IX+DPB_MAXSEC)	;フロッピーディスクの1トラックのセクタ数
	LD	B,16
	XOR	A
	EX	DE,HL
DIV1:
	ADD	HL,HL
	ADC	A,A
	CP	C
	JR	C,DIV2
	SUB	C
	INC	L
DIV2:
	DJNZ	DIV1

	INC	A	;最小のセクタは１固定
	LD	D,L	;TRACK
DIV3:
	LD	E,A	;SECTOR
	POP	BC
	RET

WTTRK:
	SCF
	RET
FDWT:
	PUSH	HL
	PUSH	DE
	CALL	CALC_SECTOR
	LD	A,D		;トラック
	LD	(FDWT_TRACK),A
	LD	A,E		;セクタ
	LD	(FDWT_SECTOR),A
	LD	A,(IX+DPB_MAXSEC)	;フロッピーディスクの1トラックのセクタ数
	SUB	E
	INC	A
	LD	H,A
	POP	DE
	LD	A,(SECSZ_H)	;1セクタのサイズの上位1バイト
	LD	C,A
	XOR	A
FDWT2:
	ADD	A,C
	INC	DE
	DEC	B
	JR	Z,FDWT3
	DEC	H		;トラック、ヘッドを跨がない
	JR	Z,FDWT3
	CP	03AH		;バッファとして04000H-07BFFHまで使える
	JR	C,FDWT2
FDWT3:
	LD	C,A
	POP	HL
	LD	A,16H		;高速レシーブメモリ
	CALL	PUTCOM
	LD	A,HIGH DSS_DATA	;開始アドレスH
	CALL	PUTDAT
	XOR	A		;開始アドレスL
	CALL	PUTDAT
	LD	A,C		;バイト数H
	CALL	PUTDAT
	XOR	A		;バイト数L
	CALL	PUTDAT
	PUSH	BC
	LD	B,C
	LD	C,0
	CALL	FPUTDAT
	POP	BC
	CALL	PUTCOM_EXECUTE		;エグゼキュート
	LD	A,HIGH WRITEDISKEX
	CALL	PUTDAT
	LD	A,LOW WRITEDISKEX
	CALL	PUTDAT
	LD	A,(IX+DPB_UNITNO)	;デバイスドライバ内におけるユニット番号
	CALL	PUTDAT
	LD	A,(IX+DPB_MAXSEC)	;フロッピーディスクの1トラックのセクタ数
	CALL	PUTDAT
	LD	A,0		;セクタ
FDWT_SECTOR	EQU	$-1
	CALL	PUTDAT
	LD	A,0		;トラック
FDWT_TRACK	EQU	$-1
	CALL	PUTDAT
	LD	A,(IX+DPB_FDMODE)	;フロッピーディスクのモード
	CALL	PUTDAT
	LD	A,(SECSZ_H)	;1セクタのサイズの上位1バイト
	CALL	PUTDAT
	LD	A,C
	CALL	PUTDAT		;バイト数H
	LD	A,(IX+DPB_MAXCYL)	;フロッピーディスクのシリンダ数
	CALL	PUTDAT

	CALL	PUTCOM_EXECUTE		;エグゼキュート
	LD	A,HIGH RESULTEX
	CALL	PUTDAT
	LD	A,LOW RESULTEX
	CALL	PUTDAT

	CALL	GETDAT
	LD	C,A
	CP	1
	RET	C

	LD	A,B
	OR	A
	JP	NZ,FDWT
	RET

FDRD:
	CALL	PUTCOM_EXECUTE		;エグゼキュート
	LD	A,HIGH READDISKEX
	CALL	PUTDAT
	XOR	A
	CALL	PUTDAT
	LD	A,(_MAX_SEC_SZ_H)
	ADD	A,A
	OR	(IX+DPB_UNITNO)		;デバイスドライバ内におけるユニット番号
	CALL	PUTDAT
	LD	A,(IX+DPB_MAXSEC)	;フロッピーディスクの1トラックのセクタ数
	CALL	PUTDAT
	PUSH	HL
	PUSH	DE
	CALL	CALC_SECTOR
	LD	A,E		;セクタ
	CALL	PUTDAT
	LD	A,D		;トラック
	CALL	PUTDAT
	LD	A,(IX+DPB_MAXSEC)	;フロッピーディスクの1トラックのセクタ数
	SUB	E
	INC	A
	LD	H,A
	POP	DE
	LD	A,(IX+DPB_FDMODE)	;フロッピーディスクのモード
	CALL	PUTDAT
	LD	A,(SECSZ_H)	;1セクタのサイズの上位1バイト
	CALL	PUTDAT
	LD	C,A
	XOR	A
FDRD2:
	ADD	A,C
	INC	DE
	DEC	B
	JR	Z,FDRD3
	DEC	H		;トラック、ヘッドを跨がない
	JR	Z,FDRD3
	CP	03AH		;バッファとして04000H-07BFFHまで使える
	JR	C,FDRD2
FDRD3:
	POP	HL
	LD	C,A
	CALL	PUTDAT		;バイト数H
	LD	A,(IX+DPB_MAXCYL)	;フロッピーディスクのシリンダ数
	CALL	PUTDAT

	CALL	PUTCOM_EXECUTE		;エグゼキュート
	LD	A,HIGH RESULTEX
	CALL	PUTDAT
	LD	A,LOW RESULTEX
	CALL	PUTDAT

	CALL	GETDAT
	LD	C,A
	CP	1
	RET	C

	LD	A,15H		;高速センドメモリ
	CALL	PUTCOM
	LD	A,HIGH DSS_DATA	;開始アドレスH
	CALL	PUTDAT
	XOR	A		;開始アドレスL
	CALL	PUTDAT
	LD	A,C		;バイト数H
	CALL	PUTDAT
	XOR	A		;バイト数L
	CALL	PUTDAT
	PUSH	BC
	LD	B,C
	LD	C,0
	CALL	FGETDAT
	POP	BC
	LD	A,B
	OR	A
	JP	NZ,FDRD
	RET

