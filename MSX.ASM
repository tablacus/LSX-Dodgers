;	LSX-Dodgers for MSX
;	Programmed by
;	Gaku (Lovers/Tablacus)

	INCLUDE	"MSXDEF.ASM"
	INCLUDE	"LDDEF.ASM"
	INCLUDE	"msx_cbios\\hardware.asm"
	INCLUDE "msx_cbios\\systemvars.asm"

	ORG	RUN

; MSX ROM header
	DB	"AB"   ; ID for auto-executable ROM
	DW	INIT_ROM   ; Main program execution address.
	DW	0      ; STATEMENT
	DW	0      ; DEVICE
	DW	0      ; TEXT
	DW	0,0,0  ; Reserved
	INCLUDE	"MSXINIT.ASM"
	INCLUDE	"MSXCCP.ASM"
	INCLUDE	"LDCCP.ASM"
	INCLUDE	"LDOS.ASM"
	INCLUDE	"MSXIO.ASM"
	INCLUDE "msx_cbios\\slot.asm"
	INCLUDE	"LDFILE.ASM"
	INCLUDE	"LDFILE2.ASM"
	INCLUDE	"LDDIO.ASM"
	INCLUDE	"MSXDISK.ASM"
	INCLUDE	"LDCCPWK.ASM"
	INCLUDE	"LDWORK.ASM"
	INCLUDE	"LDCALL.ASM"
	INCLUDE	"MSXDPB.ASM"

	DS	03FFFH - $$
	DB	0
LAST_ADR:

	END
