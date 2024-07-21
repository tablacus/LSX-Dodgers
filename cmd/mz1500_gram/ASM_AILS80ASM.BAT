rem
rem LSX-Dodgers command assemble batch for AILZ80ASM
rem <https://github.com/AILight/AILZ80ASM>
rem

set ASM=\tool\AILSZ80\AILZ80ASM.exe

%ASM% -lst -bin MZ1500_GRAM.MZT -i MZ1500_GRAM.ASM -f -gap 0
