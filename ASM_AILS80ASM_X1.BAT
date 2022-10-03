rem
rem LSX-Dodgers assemble batch for AILZ80ASM
rem <https://github.com/AILight/AILZ80ASM>
rem
rem X1/turbo/Z

set ASM=\tool\AILSZ80\AILZ80ASM.exe

%ASM% -lst -bin LD.BIN -i X1.ASZ -f -gap 0

