;
;	MAKEBPB by Gaku
;
;	Make BPB from DPB
;
SYSTEM	EQU	$0005
JP_HL	EQU	$000F
FCB1	EQU	$005C
DTA	EQU	$0080

	ORG	$0100
	JP	START
START:
	LD	DE,TITLE
	LD	C,9		;文字列出力
	CALL	SYSTEM
	LD	A,(FCB1)
	OR	A
	JR	NZ,MAIN
SHOW_USAGE:
	LD	DE,MUSAGE
SHOW_MESSAGE:
	LD	C,9		;文字列出力
	CALL	SYSTEM
	JP	0
NOT_SUPPOTED:
	LD	DE,ERRMES
	JR	SHOW_MESSAGE
MAIN:
	LD	C,$6F		;MSX-DOS のバージョン番号の獲得(_DOSVER)
	CALL	SYSTEM
	JR	C,NOT_SUPPOTED
	LD	HL,$011D	;LSX-Dodgers
	SBC	HL,BC
	JR	NZ,NOT_SUPPOTED

	LD	IX,0
	LD	A,(FCB1)
	DEC	A
	LD	E,A
	LD	C,$1F		;ディスク装置のパラメータの読み出し
	CALL	SYSTEM
	JR	C,SHOW_USAGE
	LD	A,IXH		;旧バージョンはIXにDPBが入らない
	OR	A
	JR	Z,NOT_SUPPOTED

	BIT	5,(IX+$12)	;デバイス情報(DPB_12_DEVICE)
	JR	NZ,NOT_SUPPOTED	;BPBがすでに存在する場合はエラー

	LD	A,(IX+$0E)	;FAT領域の先頭論理セクタ番号(DPB_0E_FATPS)
	OR	A
	JR	Z,NOT_SUPPOTED	;BPB領域が無い場合はエラー

	LD	HL,BPB+11	;1KBほどゼロクリア
	LD	DE,BPB+12
	LD	BC,1013
	LDIR

	LD	A,(IX+$0F)	;FAT情報と論理セクタのサイズ(DPB_0F_BPS)
	AND	7
	LD	(BPB+12),A	;BPB_BytsPerSec

	LD	A,(IX+7)	;1クラスタの論理セクタ数(DPB_07_SECPCL)
	LD	(BPB+13),A	;BPB_SecPerClus

	LD	A,(IX+$0E)	;FAT領域の先頭論理セクタ番号(DPB_0E_FATPS)
	LD	(BPB+14),A	;BPB_RsvdSecCnt

	LD	A,(IX+$0F)	;FAT情報と論理セクタのサイズ(DPB_0F_BPS)
	ADD	A,A
	LD	A,1
	ADC	A,0
	LD	(BPB+16),A	;BPB_NumFATs

	LD	L,(IX+$0B)	;ルートディレクトリ領域の論理セクタ数(DPB_0B_DIRSCNT)
	LD	H,0
	LD	A,(IX+$0F)	;FAT情報と論理セクタのサイズ(DPB_0F_BPS)
	OR	A
	JP	Z,NOT_SUPPOTED
	ADD	A,A
	ADD	A,A
	ADD	A,A
	CALL	MUL_HL_A
	LD	(BPB+17),HL	;BPB_RootEntCnt

	LD	L,(IX+8)	;総クラスタ数(DPB_08_MAXCL)
	LD	H,(IX+9)	;
	LD	A,(IX+$0F)	;FAT情報と論理セクタのサイズ(DPB_0F_BPS)
	LD	DE,0
	CALL	MUL_HL_A
	LD	C,(IX+$14)	;データ格納領域の先頭論理セクタ番号(DPB_14_ADDCL16)
	LD	B,(IX+$15)	;
	ADD	HL,BC
	LD	A,E
	ADC	A,0
	LD	E,A
	LD	D,E
	ADC	A,0
	LD	D,A
	OR	E
	JR	NZ,SEC32
	LD	(BPB+19),HL	;BPB_TotSec16
	JR	SEC16
SEC32:
	LD	(BPB+32),HL	;BPB_TotSec32
	LD	(BPB+34),DE	;
SEC16:
	LD	A,(IX+6)	;メディアバイト(DPB_06_FATID)
	LD	(BPB+21),A	;BPB_Media

	LD	L,(IX+0)	;FAT領域のセクタ単位でのサイズ(DPB_00_FATLN)
	LD	H,(IX+1)
	LD	(BPB+22),HL	;BPB_FATSz16

	LD	DE,BPB
	LD	C,$1A		;DTAの設定(_SETDTA)
	CALL	SYSTEM

	LD	DE,0		;書き込みを開始する論理セクタ番号
	LD	H,1
	LD	A,(FCB1)
	DEC	A
	LD	L,A		;書き込むディスクドライブの番号

	LD	C,$30		;論理セクタを用いた書き込み(_WRABS)
	CALL	SYSTEM
	JR	Z,OK
	LD	DE,ERRMES2
	JP	SHOW_MESSAGE
OK:
	LD	DE,COMPLETED
	JP	SHOW_MESSAGE

MUL_HL_A:
	RRCA
	RET	C
	ADD	HL,HL
	RL	E
	RL	D
	JR	MUL_HL_A

TITLE:
	DB	"makebpb v1.00"
CRLF:
	DB	$0D,$0A
	DB	'$'
MUSAGE:
	DB	"usage: MAKEBPB drive:",$0D,$0A
	DB	'$'
ERRMES:
	DB	"Not supported.",$0D,$0A,'$'
ERRMES2:
	DB	"Error!",$0D,$0A,'$'
COMPLETED:
	DB	"Completed.",$0D,$0A,'$'

BPB:
	DB	$EB,$FE,$90,"LD      ", 0
