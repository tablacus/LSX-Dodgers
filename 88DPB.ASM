
;	LSX-Dodgers DPB
;	PC-8801mkIISR

_DEVICE:

;	A:

	DW	2	;DPB_FATLN
	DW	_FDRD	;DPB_DRD
	DW	_FDWT	;DPB_DWT
	DB	0FDH	;DPB_FATID
	DB	2	;DPB_SECPCL
	DW	356	;DPB_MAXCL
	DB	0FFH	;DPB_FDMODE	0FFH=2D / 0FEH=2HD
	DB	7	;DPB_DIRSCNT
	DB	40	;DPB_MAXCYL
	DB	9	;DPB_MAXSEC	Number of sectors
	DB	1	;DPB_FATPS
	DB	082H	;DPB_BPS
	DW	5	;DPB_DIRPS
	DB	0A7H	;DPB_DEVICE	Device Number
	DB	0	;DPB_UNITNO
	DW	8	;DPB_ADDCL
	DW	0	;DPB_16
	DW	0	;DPB_18
	DW	0	;DPB_SDIR
	DB	"FDD0"	;DPB_NAME

;	B:

	DW	2	;DPB_FATLN
	DW	_FDRD	;DPB_DRD
	DW	_FDWT	;DPB_DWT
	DB	0FDH	;DPB_FATID
	DB	2	;DPB_SECPCL
	DW	356	;DPB_MAXCL
	DB	0FFH	;DPB_FDMODE	0FFH=2D / 0FEH=2HD
	DB	7	;DPB_DIRSCNT
	DB	40	;DPB_MAXCYL
	DB	9	;DPB_MAXSEC	Number of sectors
	DB	1	;DPB_FATPS
	DB	082H	;DPB_BPS
	DW	5	;DPB_DIRPS
	DB	0A7H	;DPB_DEVICE	Device Number
	DB	1	;DPB_UNITNO
	DW	8	;DPB_ADDCL
	DW	0	;DPB_16
	DW	0	;DPB_18
	DW	0	;DPB_SDIR
	DB	"FDD1"	;DPB_NAME

;	C:

	DS	32

;	D:

	DS	32

;	E:

	DS	32

;	F:

BANKFL:	DW	0	;DPB_FATLN
	DW	BDRD	;DPB_DRD
	DW	BDWT	;DPB_DWT
	DB	0F9H	;DPB_FATID
	DB	2	;DPB_SECPCL
BANKCL:	DW	0	;DPB_MAXCL
	DB	0	;DPB_FDMODE
	DB	8	;DPB_DIRSCNT
	DB	0	;DPB_MAXCYL
	DB	1	;DPB_MAXSEC
	DB	0	;DPB_FATPS
	DB	2	;DPB_BPS
	DW	2	;DPB_DIRPS
BANKDV:	DB	00BH	;DPB_DEVICE
	DB	0	;DPB_UNITNO
	DW	6	;DPB_ADDCL
	DW	0	;DPB_16
	DW	0	;DPB_18
	DW	0	;DPB_SDIR
	DB	"EMEM"	;DPB_NAME

;	G:

	DS	32

;	H:
	DS	32-8
	DB	0
