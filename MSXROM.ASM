
;	LSX-Dodgers IO
;	MSX

INT38H_ROM:
	LD	A,(EXPTBL)	;メインROMに切り替える
	CALL	ENASLT_00H
	CALL	00038H
	LD	A,(RAMAD0)	;メインRAMに切り替える
;	JP	ENASLT_00H
;
;ページ0専門のENASLT
;in
;A←スロット
;破壊
;ABCHL
;
; ページ1 に配置
ENASLT_00H:
	DI
	LD	H,A
	AND	3
	LD	C,A
	IN	A,(0A8H)
	LD	B,0FCH	;ページ0
	AND	B
	OR	C
	BIT	7,H
	JP	Z,ENASLT_NOEXT
				;拡張スロットの処理
	PUSH	DE
	CALL	ENATBL
	RRCA
	RRCA
	LD	C,A
	LD	A,E
	CALL	AT_3B
	LD	(HL),E
	POP	DE
	RET
;
;	ENASLOTの補助（ページ0・003BH～にも配置）
;
AT_3B:				;ENASUB 対象の拡張スロットを切り替えるために基本スロットを切り替える
	OUT	(0A8H),A
	LD	A,(0FFFFH)	;拡張スロットの切り替え
	CPL
	AND	B
	OR	C
	LD	(0FFFFH),A
	LD	E,A
				;基本スロットの切り替え
	LD	A,D
	OUT	(0A8H),A
	RET
AT_3B_E:


