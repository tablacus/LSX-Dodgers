rem
rem LSX-Dodgers command assemble batch for AILZ80ASM
rem <https://github.com/AILight/AILZ80ASM>
rem

set ASM=\tool\AILSZ80\AILZ80ASM.exe

%ASM% -lst -bin MAKEBPB.COM -i MAKEBPB.ASM -f -gap 0 -sym
