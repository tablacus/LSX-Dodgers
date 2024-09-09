;	LSX-Dodgers for MSX
;	Programmed by
;	Gaku (Lovers/Tablacus)

	INCLUDE	"MSXDEF.ASM"
	INCLUDE	"LDDEF.ASM"
	ORG	RUN

; MSX ROM header
	DB	"AB"   ; ID for auto-executable ROM
	DW	INIT_ROM   ; Main program execution address.
	DW	0      ; STATEMENT
	DW	0      ; DEVICE
	DW	0      ; TEXT
	DW	0,0,0  ; Reserved

	INCLUDE	"MSXFDIPL.ASM"
	INCLUDE "MSXROM.ASM"

	ORG	041BDH
	RET

	;MBR_Partition1 (2DDのデータ)
	DB	0		;ブートフラグ
	DB	0,0,0		;パーティションの最初のセクタ番号(CHS方式)
	DB	1		;識別子(FAT12)
	DB	0,0,0		;パーティションの最後のセクタ番号(CHS方式)
	DW	32,0		;パーティションの最初のセクタ番号(LBA方式)
	DW	1440,0		;パーティション内のセクタ数(LBA方式)

	;MBR_Partition2 (2DDのデータ)
	DB	0		;ブートフラグ
	DB	0,0,0		;パーティションの最初のセクタ番号(CHS方式)
	DB	1		;識別子(FAT12)
	DB	0,0,0		;パーティションの最後のセクタ番号(CHS方式)
	DW	32+1440,0	;パーティションの最初のセクタ番号(LBA方式)
	DW	1440,0		;パーティション内のセクタ数(LBA方式)

	ORG	041FEH
	DB	055H,0AAH	;MBR_Sig

	INCLUDE	"MSXINIT.ASM"
	INCLUDE	"MSXDISK.ASM"
	INCLUDE	"MSXCCP.ASM"
	INCLUDE	"LDCCP.ASM"
	INCLUDE	"LDOS.ASM"
	INCLUDE	"MSXIO.ASM"
	INCLUDE	"LDFILE.ASM"
	INCLUDE	"LDFILE2.ASM"
	INCLUDE	"LDDIO.ASM"
	INCLUDE	"MSXDISK2.ASM"
	INCLUDE	"LDCCPWK.ASM"
	INCLUDE	"LDWORK.ASM"
	INCLUDE	"LDCALL.ASM"
	INCLUDE	"MSXDPB.ASM"

	DS	03FFFH - $$
	DB	0
LAST_ADR:

	END
