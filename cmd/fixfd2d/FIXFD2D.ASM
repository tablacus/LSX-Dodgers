;
;	FIXFD by Gaku
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
USAGE:
	LD	DE,MUSAGE
SHOW_MESSAGE:
	LD	C,9		;������o��
	CALL	SYSTEM
	JP	0
NOT_FD:
	LD	DE,ERRMES
	JR	SHOW_MESSAGE
MAIN:
	LD	C,$6F		;MSX-DOS �̃o�[�W�����ԍ��̊l��(_DOSVER)
	CALL	SYSTEM
	JR	C,USAGE
	LD	HL,$011D	;LSX-Dodgers������
	SBC	HL,BC
	JR	NZ,USAGE

	LD	A,(FCB1)
	DEC	A
	LD	E,A
	LD	C,$1F		;�f�B�X�N���u�̃p�����[�^�̓ǂݏo��
	CALL	SYSTEM
	OR	A
	JR	Z,NOT_FD
	LD	A,(IX+$12)	;�f�o�C�X���(DPB_12_DEVICE)
	AND	$0F
	CP	7
	JR	NZ,NOT_FD

	BIT	5,(IX+$12)	;�f�o�C�X���(DPB_12_DEVICE)
	JR	Z,TOBPB

	LD	HL,(M2D)
	LD	(IX+0),L	;FAT�̈�̃Z�N�^�P�ʂł̃T�C�Y(DPB_00_FATLN)
	LD	(IX+1),H	;
	LD	HL,(M2D+2)
	LD	(IX+6),L	;���f�B�A�o�C�g(DPB_06_FATID)
	LD	(IX+7),H	;1�N���X�^�̘_���Z�N�^��(DPB_07_SECPCL)
	LD	HL,(M2D+4)
	LD	(IX+8),L	;���N���X�^��(DPB_08_MAXCL)
	LD	(IX+9),H	;
	LD	HL,(M2D+6)
	LD	(IX+$0A),L	;�t���b�s�[�f�B�X�N�̃��[�h(DPB_0A_FDMODE)
	LD	(IX+$0B),H	;���[�g�f�B���N�g���̈�̘_���Z�N�^��(DPB_0B_DIRSCNT)
	LD	HL,(M2D+8)
	LD	(IX+$0C),L	;�t���b�s�[�f�B�X�N�̃V�����_��(DPB_0C_MAXCYL)
	LD	(IX+$0D),H	;�t���b�s�[�f�B�X�N��1�g���b�N�̃Z�N�^��(DPB_0D_MAXSEC)
	LD	HL,(M2D+10)
	LD	(IX+$0E),L	;FAT�̈�̐擪�_���Z�N�^�ԍ�(DPB_0E_FATPS)
	LD	(IX+$0F),H	;
	LD	HL,(M2D+12)
	LD	(IX+$10),L	;���[�g�f�B���N�g���̈�̐擪�_���Z�N�^�ԍ�(DPB_10_DIRPS)
	LD	(IX+$11),H	;
	LD	A,(M2D+14)
	LD	(IX+$12),L	;�f�o�C�X���(DPB_12_DEVICE)
	LD	HL,(M2D+16)
	LD	(IX+$14),L	;�f�[�^�i�[�̈�̐擪�_���Z�N�^�ԍ�(DPB_14_ADDCL16)
	LD	(IX+$15),H	;

	LD	DE,MES2D
	JP	SHOW_MESSAGE
TOBPB:
	SET	5,(IX+$12)	;�f�o�C�X���(DPB_12_DEVICE)
	LD	DE,MESAUTO
	JP	SHOW_MESSAGE

TITLE:
	DB	"fixfd2d v1.00"
CRLF:
	DB	$0D,$0A
	DB	'$'
MUSAGE:
	DB	"usage: FIXFD2D drive:",$0D,$0A
	DB	'$'
ERRMES:
	DB	7,"Not FDD",$0D,$0A,'$'
MES2D:
	DB	"fix 2D",$0D,$0A,'$'
MESAUTO:
	DB	"auto detect mode",$0D,$0A,'$'
;
;	DPB Data
;
M2D:
	DW	2
	DB	$FD,2
	DW	356
	DB	$FF,7,40,9,1,$82
	DW	5,7,8