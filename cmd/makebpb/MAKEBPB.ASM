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
	LD	C,9		;������o��
	CALL	SYSTEM
	LD	A,(FCB1)
	OR	A
	JR	NZ,MAIN
SHOW_USAGE:
	LD	DE,MUSAGE
SHOW_MESSAGE:
	LD	C,9		;������o��
	CALL	SYSTEM
	JP	0
NOT_SUPPOTED:
	LD	DE,ERRMES
	JR	SHOW_MESSAGE
MAIN:
	LD	C,$6F		;MSX-DOS �̃o�[�W�����ԍ��̊l��(_DOSVER)
	CALL	SYSTEM
	JR	C,NOT_SUPPOTED
	LD	HL,$011D	;LSX-Dodgers
	SBC	HL,BC
	JR	NZ,NOT_SUPPOTED

	LD	IX,0
	LD	A,(FCB1)
	DEC	A
	LD	E,A
	LD	C,$1F		;�f�B�X�N���u�̃p�����[�^�̓ǂݏo��
	CALL	SYSTEM
	JR	C,SHOW_USAGE
	LD	A,IXH		;���o�[�W������IX��DPB������Ȃ�
	OR	A
	JR	Z,NOT_SUPPOTED

	BIT	5,(IX+$12)	;�f�o�C�X���(DPB_12_DEVICE)
	JR	NZ,NOT_SUPPOTED	;BPB�����łɑ��݂���ꍇ�̓G���[

	LD	A,(IX+$0E)	;FAT�̈�̐擪�_���Z�N�^�ԍ�(DPB_0E_FATPS)
	OR	A
	JR	Z,NOT_SUPPOTED	;BPB�̈悪�����ꍇ�̓G���[

	LD	HL,BPB+11	;1KB�قǃ[���N���A
	LD	DE,BPB+12
	LD	BC,1013
	LDIR

	LD	A,(IX+$0F)	;FAT���Ƙ_���Z�N�^�̃T�C�Y(DPB_0F_BPS)
	AND	7
	LD	(BPB+12),A	;BPB_BytsPerSec

	LD	A,(IX+7)	;1�N���X�^�̘_���Z�N�^��(DPB_07_SECPCL)
	LD	(BPB+13),A	;BPB_SecPerClus

	LD	A,(IX+$0E)	;FAT�̈�̐擪�_���Z�N�^�ԍ�(DPB_0E_FATPS)
	LD	(BPB+14),A	;BPB_RsvdSecCnt

	LD	A,(IX+$0F)	;FAT���Ƙ_���Z�N�^�̃T�C�Y(DPB_0F_BPS)
	ADD	A,A
	LD	A,1
	ADC	A,0
	LD	(BPB+16),A	;BPB_NumFATs

	LD	L,(IX+$0B)	;���[�g�f�B���N�g���̈�̘_���Z�N�^��(DPB_0B_DIRSCNT)
	LD	H,0
	LD	A,(IX+$0F)	;FAT���Ƙ_���Z�N�^�̃T�C�Y(DPB_0F_BPS)
	OR	A
	JP	Z,NOT_SUPPOTED
	ADD	A,A
	ADD	A,A
	ADD	A,A
	CALL	MUL_HL_A
	LD	(BPB+17),HL	;BPB_RootEntCnt

	LD	L,(IX+8)	;���N���X�^��(DPB_08_MAXCL)
	LD	H,(IX+9)	;
	LD	A,(IX+$0F)	;FAT���Ƙ_���Z�N�^�̃T�C�Y(DPB_0F_BPS)
	LD	DE,0
	CALL	MUL_HL_A
	LD	C,(IX+$14)	;�f�[�^�i�[�̈�̐擪�_���Z�N�^�ԍ�(DPB_14_ADDCL16)
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
	LD	A,(IX+6)	;���f�B�A�o�C�g(DPB_06_FATID)
	LD	(BPB+21),A	;BPB_Media

	LD	L,(IX+0)	;FAT�̈�̃Z�N�^�P�ʂł̃T�C�Y(DPB_00_FATLN)
	LD	H,(IX+1)
	LD	(BPB+22),HL	;BPB_FATSz16

	LD	DE,BPB
	LD	C,$1A		;DTA�̐ݒ�(_SETDTA)
	CALL	SYSTEM

	LD	DE,0		;�������݂��J�n����_���Z�N�^�ԍ�
	LD	H,1
	LD	A,(FCB1)
	DEC	A
	LD	L,A		;�������ރf�B�X�N�h���C�u�̔ԍ�

	LD	C,$30		;�_���Z�N�^��p������������(_WRABS)
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