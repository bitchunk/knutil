#KNUTIL SCENE MANAGER
"KNUTIL"�͎������쐬�����Q�[���ŁA�g�p�p�x�̍����֐����܂Ƃ߂����C�u�����ł��B
����ōŏI�I�ɕK�v�ɂȂ����֐����c���Ă���܂��B

���̃J�[�g�ł̓V�[���@�\�̓���ɂ��ăA�j���[�V�����Ŏ����Ă��܂��B

#�V�[���̗��p
##[ MKSCENES ]�V�[�����쐬����
SCENES, INDEXES = MKSCENES( { UPD, DRW, KEY } )
SCENES: �������ꂽ�V�[�����i�[����Ă��܂��B
INDEXES: �����������ɃV�[�������s���邽�߂ɕK�v�ł��B

##[ CMDSCENES ]�V�[����ORDER����͂���
CMDSCENES([[
[SCENE NAME] [COMMAND] [FUNCTION] [DURATION FRAME]
[SCENE NAME] [COMMAND] [FUNCTION] [DURATION FRAME]
...
]])
[SCENE NAME] MKSCENES�Ő����������O���w�肵�܂��B
[COMMAND]���L��ORDER COMMANDS���w�肵�܂��B
[FUNCTION] �O���[�o���֐��̖��O���w�肵�܂��B
[DURATION FRAME] ��������t���[�������w�肵�܂��B0�Ŏw�肷��Ǝ����I�ɏI�����܂���B


### ORDER COMMANDS
ST: SCENE�ɃX�^�b�N���Ă���I�[�_�[��S�č폜���A�V�����I�[�_�[���Z�b�g����(SET)
UPD ST MANAGE 0
--�V�[���uUPD�v���N���[���ɂ��āA�uFUNCTION MANAGE�v��ǉ����܂��B

PS: SCENE�ɃI�[�_�[��ǉ�����(PUSH)
KEY PS KEYCHECK 0
--�V�[���uKEY�v�ɁuFUNCTION KEYCHECK�v��擪�ɒǉ����܂��B

US: SCENE�̍ŏ��ɃI�[�_�[�����荞�݂�����(UNSHIFT)
DRW US DRAWRECT 200
DRW US NIL 100
DRW US DRAWCIRC 200
--�uDRW�v��DRAWCIRC, NIL DRAWRECT�̏��Ŏ��s����܂�

RM: �I�[�_�[����폜����
DRW RM
--�V�[���uDRW�v�̐擪�̃I�[�_�[���폜���܂��B

DRW RM DRAWRECT
--�V�[���uDRW�v��DRAWRECT�I�[�_�[��擪����D�悵�č폜���܂��B

CL: �V�[���ɃX�^�b�N���Ă���I�[�_�[�����ׂč폜����
KEY CL

FI: �V�[���̒�����I�[�_�[���������Ď擾����
DRW FI DRAWRECT

##�֐����I�[�_�[�Ɏw�肷��
```
FUNCTION KEYCHECK( ORDER )
	PRINT('PROCESSIONG ORDER')
END
```

##�e�V�[�������s����

##ORDER�̃v���p�e�B
###�v���p�e�B�FFST / LST
ORDER.FST:�ŏ��̎��s��
ORDER.LST:�Ō�̎��s��

###�v���p�e�B�FCNT / DUR
ORDER.CNT:���ݑ����Ă���ORDER�̎��s�J�E���g
ORDER.DUR:���ݑ����Ă���ORDER�̏I���\��̃J�E���g

###�v���p�e�B�FPRM
CMDSCENES�̂Q�Ԗڂ̈����Ŏw�肵���l�������Ă��܂��B

###RATE
���W�ȂǂŁA�J�n����I�����w�肷��Ƃ��Ɏg���܂��B
`ORDER.rate('[start] [end]', duration, count )`
duration��count�̓f�t�H���g�̏ꍇ�ACMDSCENES�Ŏw�肵�����̂��g���܂��B

###�I�[�_�[�̋����I��
`return 1`�����邩�A`ORDER.rm = 1`������B

���̃��C�u�����̒��Ŏ������ɓ��e�������̂�����܂��B
HTBL
VDMP

����������Ă��Ȃ��֐��i�ʂ̋@��ɓ��e���܂��j
TONORM
TOHEX
TTOH
HTOT
REPLACE
EXRECT(RFMT)
TOC
JOIN
SPLIT(wrapper function)
HTD
SLICE
CAT
COMB
TBFILL
ECXY
OUTLINE
TMAP
MKPAL
ECPALT
TTABLE
INRNG
AMID
BMCH
