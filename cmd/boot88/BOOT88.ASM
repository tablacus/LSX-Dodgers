;
;	PC-8801mkSR ブート
;

RUN		EQU	0D100H
SIZE		EQU	9728
EXEC		EQU	RUN+7
MAINADDR	EQU	0C000H
SUBADDR		EQU	05000H

;	BIOS ROM

PUTCOM		EQU	037CCH
PUTDAT		EQU	037D2H
GETDAT		EQU	03847H

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
;	メイン
	ORG	MAINADDR
	LD	BC,0444CH	;01 4C 44
	SCF		;37
	JR	C,START	;38 2A
	DB	"IPL     "
	DB	"Sys"
	DB	020H	;パスワード(通常は20h)
	DW	256	;データサイズ（下位,上位の順）
	DW	0FD00H	;読込アドレス（下位,上位の順）
	DW	0FD00H	;実行アドレス（下位,上位の順）
	DB	0	;年...西暦の下位2桁をBCD形式
	DB	0	;月,曜日...上位4bitが月、下位が曜日
	DB	0	;日...BCD形式
	DB	0	;時...BCD形式
	RST	0	;分...BCD形式
	DB	0,25,0	;開始クラスタ
DISK_SUB_SYSTEM:
;	ディスクサブシステム
DSS	EQU	DISK_SUB_SYSTEM-07000H

	LD	HL,DSS_MAIN-MAINADDR+SUBADDR
	LD	DE,DSS_TO
	LD	BC,DSS_LAST-DSS_TO
	LDIR
	JP	READDISKEX

START:
	DI
	LD	SP,0C000H
				;初期化
	XOR	A		;イニシャライズ
	CALL	PUTCOM
	LD	A,017H		;セットサーフィスモード
	CALL	PUTCOM
	LD	A,7		;Bit3〜Bit0 0:片面 1:両面
	CALL	PUTDAT
	LD	A,0DH		;エグゼキュート
	CALL	PUTCOM
	LD	A,DSS/256
	CALL	PUTDAT
	LD	A,DSS%256
	CALL	PUTDAT
;	LD	A,6		;センドリザルトステータス
;	CALL	PUTCOM
;	CALL	GETDAT
;	RRCA
;ERROR:
;	JR	C,ERROR
	LD	A,0BH		;センドメモリ2
	CALL	PUTCOM
	LD	A,DSS_DATA/256	;開始アドレスH
	CALL	PUTDAT
	LD	A,7		;開始アドレスL
	CALL	PUTDAT
	LD	BC,SIZE-7
	LD	A,B		;バイト数H
	CALL	PUTDAT
	LD	A,C		;バイト数L
	CALL	PUTDAT
	LD	HL,RUN - 0x1000
	PUSH	HL
	PUSH	BC
TRANS1:
	CALL	GETDAT
	LD	(HL),A
	CPI			;HL=HL+1 BC=BC-1 BCが0の場合にP/V=0
	JP	PE,TRANS1
	POP	BC
	LD	HL,RUN
	ADD	HL,BC
	EX	DE,HL
	POP	HL
	ADD	HL,BC
	IN	A,(032H)
	OR	010H		;高速RAMアクセスモードOFF
	OUT	(032H),A
	LDDR
	JP	EXEC

DSS_MAIN:
	ORG	DSS_TO,DSS_MAIN-MAINADDR
READDISKEX:
	LD	HL,DSS_DATA	;開始アドレス
	LD	IX,DISK_DATA
	LD	B,3
RDDISK0:
	PUSH	BC
	CALL	FDCOMMAND
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
	LD	BC,3
	ADD	IX,BC
	POP	BC
	DJNZ	RDDISK0
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

FDCOMMAND:
	LD	C,0		;DRIVE A:
	LD	D,(IX+0)
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
	LD	A,(IX+1)	;R
	RST	20H
	LD	A,2		;N
	RST	20H
	LD	A,9		;EOT
	RST	20H
	LD	A,54H		;GSL
	RST	20H
	XOR	A		;DTL
	RST	20H
	LD	C,0
	LD	B,(IX+2)	;バイト数H
	RET

DISK_DATA:;	T R SZ
	DB	1,4,12	;3072
	DB	2,1,18	;4608
	DB	3,1,8	;2048
DSS_LAST:
