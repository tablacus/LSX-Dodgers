rem
rem LSX-Dodgers assemble batch for AILZ80ASM
rem <https://github.com/AILight/AILZ80ASM>
rem
rem PC-8801mkIISR

set ASM=\tool\AILSZ80\AILZ80ASM.exe

%ASM% -lst -bin LD88.BIN -i 88.ASM -f -gap 0 -sym

