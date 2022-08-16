;
; MKDIR Gaku
;
; �f�B���N�g�����쐬����
;
SYSTEM	EQU	00005H
JP_HL	EQU	0000FH
FCB1	EQU	0005CH
FCB2	EQU	0006CH
DTA1	EQU	00080H

	ORG 00100H
	JP	START		;0C3H��Z80�ł�JP�����Ai8086�ł�RET�Ȃ̂�
START:				;�ԈႦ��MS-DOS���Ŏ��s���Ă����I���ł���
	LD	DE,FCB1
	LD	C,011H		;SFIRST FCB �t�@�C������ ���� CP/M
	CALL	SYSTEM
	OR	A
	JP	Z,SHOW_EXISTS	;���łɑ��݂���ꍇ�̓G���[

	LD	DE,FCB1
	LD	A,(FCB1+1)
	CP	020H
	JP	Z,SHOW_TITLE

	LD	C,016H		;FMAKE FCB �t�@�C���쐬 CP/M
	CALL	SYSTEM
	OR	A
	JP	NZ,SHOW_NOT_CREATE	;�쐬�Ɏ��s����ꍇ�̓G���[

	LD	A,(FCB1+29)	;�f�B���N�g���E���[�h
	OR	A
	JR	Z,ROOT

	LD	HL,(FCB1+14)	;�A�N�Z�X����f�B���N�g���̃N���X�^�ԍ�+1
	LD	A,H
	OR	L
	JR	Z,ROOT
	DEC	HL
	LD	(PARENTCL),HL
ROOT:
	LD	HL,FCB1
	LD	E,(HL)
	LD	C,01BH		;ALLOC �f�B�X�N���̊l��
	CALL	SYSTEM
	CP	0FFH
	JP	Z,SHOW_NOT_CREATE	;�擾�ł��Ȃ��ꍇ�̓G���[
	LD	L,C		;BC���_���Z�N�^�̃T�C�Y
	LD	H,B
	CP	32
	JP	NC,SHOW_NOT_CREATE	;�Z�N�^������������ꍇ�̓G���[
				;A��1�N���X�^�̃Z�N�^��(1,2,4,8,16)
LOOP1:				;HL=�_���Z�N�^�̃T�C�Y * 1�N���X�^�̃Z�N�^��
	RRA			;->CF
	JR	C,SKIP1
	ADD	HL,HL
	JR	LOOP1
SKIP1:
	PUSH	HL		;HL��1�N���X�^�̃T�C�Y
	LD	BC, 32 * 2	;�f�B���N�g���G���g�� * 2
	SCF
	SBC	HL,BC		;. �� .. �̃T�C�Y �� 1 ���炷
	LD	C,L
	LD	B,H
	LD	HL,DIRENT3;
	LD	DE,DIRENT3+1;
	LDIR			;0�N���A

	LD	DE,SUBD
	LD	C,01AH		;SETDTA �f�B�X�N�]���A�h���X�̐ݒ� CP/M
	CALL	SYSTEM

	LD	DE,FCB1
	LD	HL,1
	LD	(FCB1+14),HL	;���R�[�h�E�T�C�Y
	POP	HL
	LD	C,026H		;WRBLK FCB �����_���u���b�N��������
	CALL	SYSTEM
	OR	A
	JR	NZ,SHOW_NOT_CREATE

	LD	HL,(FCB1+26)	;�t�@�C���̐擪�N���X�^
	LD	(SELFCL),HL

	LD	HL,0 
	LD	(FCB1+35),HL	;�����_���E���R�[�h
	LD	HL,SELFCL-SUBD 
	LD	(FCB1+33),HL	;�����_���E���R�[�h

	LD	E,L
	LD	D,H
	LD	C,01AH		;SETDTA �f�B�X�N�]���A�h���X�̐ݒ� CP/M
	CALL	SYSTEM

	LD	DE,FCB1
	LD	HL,2
	LD	C,026H		;WRBLK FCB �����_���u���b�N��������
	CALL	SYSTEM
	OR	A
	JR	NZ,SHOW_NOT_CREATE

	LD	A,010H		;�f�B���N�g��
	LD	(FCB1+13),A	;����(�A�g���r���[�g)
	LD	HL,0
	LD	(FCB1+16),HL	;�t�@�C���̃T�C�Y

	LD	DE,FCB1
	LD	C,010H		;FCLOSE FCB �t�@�C���N���[�Y CP/M
	CALL	SYSTEM

	LD	DE,OKMES
	JR	EXITMES

SHOW_TITLE:
	LD	DE,MES_TITLE
	LD	C,9		;STROUT ������o�� CP/M
	CALL	SYSTEM
	LD	DE,ERRMES1
EXITMES:
	LD	C,9		;STROUT ������o�� CP/M
	CALL	SYSTEM
	JP	0
SHOW_MESSAGE:
	LD	C,9		;STROUT ������o�� CP/M
	CALL	SYSTEM
	LD	DE,CRLF
	LD	C,9		;STROUT ������o�� CP/M
	CALL	SYSTEM
	JP	0
SHOW_NOT_CREATE:
	LD	DE,MES_NOT_CREATE
	JR	SHOW_MESSAGE 
SHOW_EXISTS:
	LD	DE,MES_EXISTS
	JR	SHOW_MESSAGE 

MES_TITLE:
	DB	"mkdir v1.01 Gaku",00DH,00AH
	DB	'$'
ERRMES1:
	DB	"usage: MKDIR directory",00DH,00AH
	DB	'$'
OKMES:
	DB	"OK"
CRLF:	DB	00DH,00AH
	DB	'$'
MES_EXISTS:
	DB	"File exists$"
MES_NOT_CREATE:
	DB	"Cannot create directory$"

SUBD:
	DB	".          "
	DB	010H
	DW	0,0,0,0,0
TIME1:	DW	0
DATE1:	DW	0
SELFCL:	DW	0
	DW	0,0

	DB	"..         "
	DB	010H
	DW	0,0,0,0,0
TIME2:	DW	0
DATE2:	DW	0
PARENTCL:
	DW	0
	DW	0,0
DIRENT3:
	DB	0