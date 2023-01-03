rem
rem LSX-Dodgers command assemble batch for AILZ80ASM
rem <https://github.com/AILight/AILZ80ASM>
rem

set ASM=\tool\AILSZ80\AILZ80ASM.exe

%ASM% -lst -bin BOOTX1.BIN -i BOOTX1.ASM -f -gap 0
