;	TYPE

SYSTEM	EQU	0005H		;�V�X�e���R�[��
FCB1	EQU	005CH		;1�Ԗڂ̈�����FCB
FCB2	EQU	006CH		;2�Ԗڂ̈�����FCB
DTA1	EQU	0080H

	ORG	0100H

	JP	START		;0C3H��Z80�ł�JP�����Ai8086�ł�RET�Ȃ̂�
START:				;�ԈႦ��MS-DOS���Ŏ��s���Ă����I���ł���
	LD	DE,FCB1		;������1�����̏ꍇ��FCB1�����̂܂܎g����
	LD	C,00FH		;�t�@�C���̃I�[�v��(_FOPEN) CP/M MSX-DOS
	CALL	SYSTEM
	OR	A
	JP	NZ,0		;���s������I��

	LD	HL,1
	LD	(FCB1+14),HL	;���R�[�h�T�C�Y��1�ɂ���

	LD	HL,0		;FCB1���g���ꍇ�̓����_�����R�[�h������������
	LD	(FCB1+33),HL	;�����_�����R�[�h��0�ɂ���
	LD	(FCB1+35),HL

	LD	DE,BUFAD	;�f�[�^�̓ǂݏo����
	LD	C,01AH		;DTA�̐ݒ�(_SETDTA) CP/M MSX-DOS
	CALL	SYSTEM
LOOP1:
	LD	DE,FCB1
	LD	HL,(SYSTEM+1)	;�o�b�t�@�T�C�Y���v�Z
	LD	BC,-(BUFAD+0100H)	;0100H�̓X�^�b�N�̕���
	ADD	HL,BC
	LD	L,0
	LD	A,H
	AND	0F8H		;�o�b�t�@��1KB�P�ʂɂ���(HL = HL AND 0F800H)
	LD	H,A
	LD	C,027H		;�����_���u���b�N�ǂݏo��(_RDBLK) MSX-DOS
	CALL	SYSTEM
	CP	0FFH
	JR	Z,EXIT2		;���s������I��
	PUSH	AF
	LD	DE,BUFAD
LOOP2:
	LD	A,H		;HL�ɓǂݍ��񂾃T�C�Y
	OR	L
	JR	Z,EXIT1

	LD	A,(DE)
	CP	01AH		;EOF
	JR	Z,EXIT2

	INC	DE

	PUSH	DE		;CP/M��MSX-DOS�ł̓V�X�e���R�[���Ń��W�X�^���j�󂳂��
	PUSH	HL
	LD	E,A
	LD	C,2		;�R���\�[���o��(_CONOUT) CP/M MSX-DOS
	CALL	SYSTEM
	POP	HL
	POP	DE
	DEC	HL
	JR	LOOP2
EXIT1:
	POP	AF
	OR	A		;A=0�̏ꍇ�̓o�b�t�@�T�C�Y���ׂēǂݍ��݂ł����Ȃ̂ŁA�܂��ǂݍ��݂ł��Ă��Ȃ��c�肪����
	JR	Z,LOOP1		;A=1�̏ꍇ�͂��ׂēǂݍ��݊������Ă���
EXIT2:
	LD	DE,FCB1
	LD	C,010H		;�t�@�C���̃N���[�Y(_FCLOSE) CP/M MSX-DOS
	CALL	SYSTEM

	JP	0		;�v���O�����I��

BUFAD: