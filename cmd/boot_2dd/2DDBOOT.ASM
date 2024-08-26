;	MSX FD BOOT

	BDOS	EQU	0F37DH

	ORG	0C000H
;
;	BPB
;
	DB	0EBH,0FEH,090H	;BS_JmpBoot
	DB	"LD      "	;BS_OEMName
	DW	512		;BPB_BytsPerSec
	DB	2		;BPB_SecPerClus
	DW	1		;BPB_RsvdSecCnt
	DB	2		;BPB_NumFATs
	DW	112		;BPB_RootEntCnt
	DW	1440		;BPB_TotSec16
	DB	0F9H		;BPB_Media
	DW	3		;BPB_FATSz16
	DW	9		;BPB_SecPerTrk
	DW	2		;BPB_NumHeads
	DW	0		;BPB_HiddSec(2バイト)
	JR	START		;ブートプログラムへジャンプ
	DB	"_DOS1_"	;MSX-DOS2判別用(VOL_IDじゃなければDOS1)
	DB	0		;ダーティディスクフラグ
	DB	"DOS1"		;ボリュームID(適当な4バイト)
	DS	5		;Reserved for future
;
;	ブートプログラム
;
START:
	RET	NC

	CALL	0F36BH      ;ページ1をメインRAMに切り替える
	LD	DE,FCB
	LD	C,00FH
	CALL	BDOS

	LD	DE,08000H
	LD	C,01AH		;(BDOS)DTAの設定
	CALL	BDOS

	LD	HL,0
	LD	(FCB+33),HL
	LD	(FCB+35),HL
	INC	L
	LD	(FCB+14),HL

	LD	DE,FCB
	LD	HL,04000H
	LD	C,027H		;(BDOS)ランダム・ブロック・リード
	CALL	BDOS

	JP	08010H

FCB:	DB	0, "LDMSX   BIN",0,0,0,0
