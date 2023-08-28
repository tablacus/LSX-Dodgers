;	TYPE

SYSTEM	EQU	0005H		;システムコール
FCB1	EQU	005CH		;1番目の引数のFCB
FCB2	EQU	006CH		;2番目の引数のFCB
DTA1	EQU	0080H

	ORG	0100H

	JP	START		;0C3HはZ80ではJPだが、i8086ではRETなので
START:				;間違えてMS-DOS環境で実行しても即終了できる
	LD	DE,FCB1		;引数が1つだけの場合はFCB1がそのまま使える
	LD	C,00FH		;ファイルのオープン(_FOPEN) CP/M MSX-DOS
	CALL	SYSTEM
	OR	A
	JP	NZ,0		;失敗したら終了

	LD	HL,1
	LD	(FCB1+14),HL	;レコードサイズを1にする

	LD	HL,0		;FCB1を使う場合はランダムレコードを初期化する
	LD	(FCB1+33),HL	;ランダムレコードを0にする
	LD	(FCB1+35),HL

	LD	DE,BUFAD	;データの読み出し先
	LD	C,01AH		;DTAの設定(_SETDTA) CP/M MSX-DOS
	CALL	SYSTEM
LOOP1:
	LD	DE,FCB1
	LD	HL,(SYSTEM+1)	;バッファサイズを計算
	LD	BC,-(BUFAD+0100H)	;0100Hはスタックの部分
	ADD	HL,BC
	LD	L,0
	LD	A,H
	AND	0F8H		;バッファを1KB単位にする(HL = HL AND 0F800H)
	LD	H,A
	LD	C,027H		;ランダムブロック読み出し(_RDBLK) MSX-DOS
	CALL	SYSTEM
	CP	0FFH
	JR	Z,EXIT2		;失敗したら終了
	PUSH	AF
	LD	DE,BUFAD
LOOP2:
	LD	A,H		;HLに読み込んだサイズ
	OR	L
	JR	Z,EXIT1

	LD	A,(DE)
	CP	01AH		;EOF
	JR	Z,EXIT2

	INC	DE

	PUSH	DE		;CP/MやMSX-DOSではシステムコールでレジスタが破壊される
	PUSH	HL
	LD	E,A
	LD	C,2		;コンソール出力(_CONOUT) CP/M MSX-DOS
	CALL	SYSTEM
	POP	HL
	POP	DE
	DEC	HL
	JR	LOOP2
EXIT1:
	POP	AF
	OR	A		;A=0の場合はバッファサイズすべて読み込みできたなので、まだ読み込みできていない残りがある
	JR	Z,LOOP1		;A=1の場合はすべて読み込み完了している
EXIT2:
	LD	DE,FCB1
	LD	C,010H		;ファイルのクローズ(_FCLOSE) CP/M MSX-DOS
	CALL	SYSTEM

	JP	0		;プログラム終了

BUFAD:
