;
;	MZ-1500
;	G-RAMとメインRAM($2000-$7FFF)の内容をスワップする
;
	ORG	$1F80-128
					;MZTヘッダ128バイト
	DB	1			;ファイルモード
	DB	"MZ1500 SWAP G"		;ファイル名(13)
	DB	"RAM"			;拡張子(3)
	DB	$0D
	DW	LAST_ADR - START_ADR	;サイズ
	DW	START_ADR		;開始アドレス
	DW	START_ADR		;実行アドレス
	DS	104
START_ADR:
	LD	DE,$2000	;メモリ
	LD	A,1		;PCG 青プレーン
LOOP1:
	PUSH	AF
	OUT	($E5),A		;MZ-1500: PCGバンク切り替え
	LD	BC,$2000	;G-RAM各プレーンのサイズ
	LD	HL,$D000	;G-RAM開始アドレス
LOOP2:
	LD	A,(DE)
	LDI			;BCが0の場合にP/V=0
	DEC	HL
	LD	(HL),A
	INC	HL
	JP	PE,LOOP2
	POP	AF
	INC	A
	CP	4
	JR	C,LOOP1

	OUT	($E6),A		;MZ-1500: PCGバンクを閉じる
	RET
LAST_ADR:
