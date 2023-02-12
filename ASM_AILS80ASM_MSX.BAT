rem
rem LSX-Dodgers assemble batch for AILZ80ASM
rem <https://github.com/AILight/AILZ80ASM>
rem
rem MSX

set ASM=\tool\AILSZ80\AILZ80ASM.exe

%ASM% -lst -bin LDMSX.BIN -i MSX.ASM -f -gap 0 -sym
msxcat
