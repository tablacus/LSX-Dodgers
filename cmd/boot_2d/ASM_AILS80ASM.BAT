rem
rem LSX-Dodgers command assemble batch for AILZ80ASM
rem <https://github.com/AILight/AILZ80ASM>
rem

set ASM=\tool\AILSZ80\AILZ80ASM.exe

%ASM% -lst -bin BOOT_10.BIN -i BOOT_10.ASM -f -gap 0 -sym -equ
%ASM% -lst -bin BOOT_1.BIN -i BOOT_1.ASM -f -gap 0 -sym
