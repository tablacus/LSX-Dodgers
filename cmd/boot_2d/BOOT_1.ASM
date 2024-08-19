;
;	デュアルブート sector 1
;

INCLUDE		"BOOT_10.EQU"

MAINADDR	EQU	0C000H
SUBADDR		EQU	05000H

;	ディスクサブシステム
MAIN		EQU	0002AH
CHECKRESULT	EQU	00045H
MAPDRV		EQU	0040EH
GETPARAM	EQU	006A6H
SEEK_AND_WAIT	EQU	007D6H

DSS_DATA	EQU	04000H

DSS_TO		EQU	07000H

CMD_STATUS	EQU	07F14H

;
;	X1は ブートセクタ 0FE00H に読み込まれブートフラグや拡張子(Sys)をチェックして
;	以下の開始セクタから読込アドレスにデータサイズ読み込まれ、実行アドレスから実行する
;
;	88は 0C000H から256バイト読み込まれ 0C000H から実行する
;	サブシステム側の 05000H にも読み込まれている
;
	ORG	MAINADDR
	LD	BC,0444CH	;01 4C 44	※X1は先頭バイトが1である必要がある（ブートフラグ）
	SCF		;37			※X1で2～14バイト目はIPLで表示されるラベルになるので文字になるようにしておく
	JR	C,START	;38 28			※88でブートプログラムにジャンプさせる
	DB	"IPL     "
	DB	"Sys"	;拡張子			※X1で起動するために"Sys"である必要がある
	DB	020H	;パスワード(通常は20h)
	DW	256	;データサイズ（下位,上位の順）
	DW	EXEC	;読込アドレス（下位,上位の順）
	DW	EXEC	;実行アドレス（下位,上位の順）
	DB	0	;年...西暦の下位2桁をBCD形式
	DB	0	;月,曜日...上位4bitが月、下位が曜日
	DB	0	;日...BCD形式
	DB	0	;時...BCD形式
	RST	0	;分...BCD形式
	DB	0,9,0	;開始セクタ
DISK_SUB_SYSTEM:
;	ディスクサブシステムの05000Hからセクタ1の内容が読み込まれているので転送する
DSS	EQU	DISK_SUB_SYSTEM-07000H

	LD	HL,DSS_MAIN-MAINADDR+SUBADDR
	LD	DE,DSS_TO
	LD	BC,DSS_LAST-DSS_TO
	LDIR
	JP	MAIN
				;88ブートプログラム
START:
	DI
	IN	A,(032H)
	OR	010H		;高速RAMアクセスモードOFF
	OUT	(032H),A

	LD	SP,EXEC
				;初期化
	XOR	A		;イニシャライズ
	CALL	PUTCOM
	LD	A,017H		;セットサーフィスモード
	CALL	PUTCOM
	LD	A,7		;Bit3～Bit0 0:片面 1:両面
	CALL	PUTDAT
				;サブシステムの05000Hから読み込まれているDSSを実行しディスクサブシステムで1セクタ512バイトのデータを読めるようにする
	LD	A,0DH		;エグゼキュート
	CALL	PUTCOM
	LD	A,HIGH DSS
	CALL	PUTDAT
	LD	A,LOW DSS
	CALL	PUTDAT
				;LD88.BINを読み込むローダー(セクタ10)を読み込む
	LD	A,02H		;リードデータ
	CALL	PUTCOM
	LD	A,1		;セクタ数
	CALL	PUTDAT
	LD	A,0		;ドライブ番号
	CALL	PUTDAT
	LD	A,0		;トラック番号
	CALL	PUTDAT
	LD	A,10		;セクタ番号
	CALL	PUTDAT
				;読み込んだローダーを 0FD00H に移す
	LD	A,03H		;センドデータ
	CALL	PUTCOM
	LD	HL,EXEC
	LD	B,L		;L=0
TRANS1:
	CALL	GETDAT
	LD	(HL),A
	INC	HL
	DJNZ	TRANS1
				;PC-8801向けにローダーを調整する
	LD	A,022H		;64K RAMモード
	LD	(PC88RAM),A
	LD	A,031H
	LD	(PC88OUT),A
				;セクタ読み込みを88に差し替える
	DB	03EH		;LD A,?
	PUSH	AF
	LD	(READ_DISK),A
	DB	021H		;LD HL,??
	LD	A,0DH		;エグゼキュート
	LD	(READ_DISK+1),HL
				;ファイル名を LD88.BIN にする
	DB	021H,"88"	;LD HL,"88"
	LD	(FNAME+2),HL

	JP	EXEC88

DSS_MAIN:
				;ディスクサブシステムで1セクタ512バイトのデータを読めるようにするルーチン
	ORG	DSS_TO,DSS_MAIN-MAINADDR
READDISKEX:
	RST	10H
	LD	L,A
	RST	10H
	LD	H,A
	RST	10H
	PUSH	AF
	LD	A,L
	ADD	HL,HL
	ADD	HL,HL
	ADD	HL,HL
	ADD	HL,HL
	AND	00FH
	INC	A
	LD	L,A
	EX	DE,HL
FDCOMMAND:
	LD	C,0		;DRIVE A:
	CALL	SEEK_AND_WAIT
	LD	A,46H		;READ DATA
	RST	20H
	CALL	MAPDRV		;HD US1 US0
	RST	20H
	LD	A,D		;C
	SRL	A
	RST	20H
	LD	A,D		;H
	AND	1
	RST	20H
	LD	A,E		;R
	RST	20H
	LD	A,2		;N
	RST	20H
	LD	A,9		;EOT
	RST	20H
	LD	A,54H		;GSL
	RST	20H
	XOR	A		;DTL
	RST	20H
	POP	AF
	ADD	A,A
	LD	B,A		;バイト数H
	LD	HL,05000H
	LD	C,L
RDDISK1:
	EI
	HALT
	IN	A,(0FAH)	;FDC μPD765A ステータスレジスタリード
	AND	20H		;NO SERVICE
	JR	Z,RDDISK2
	IN	A,(0FBH)	;FDC μPD765A データレジスタ
	LD	(HL),A
	CPI
	JP	PE,RDDISK1
RDDISK2:
	IN	A,(0F8H)	;FDC μPD765A TC入力
	EI
	HALT
	CALL	CHECKRESULT
	LD	A,(DSS_DATA)
	CP	0FEH
	JR	Z,RDDISK3
	LD	A,1
	JR	RDDISK4
RDDISK3:
	LD	A,0C0H
RDDISK4:
	LD	(CMD_STATUS),A
	JP	MAIN

DSS_LAST:
