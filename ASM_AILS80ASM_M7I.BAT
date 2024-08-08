rem
rem LSX-Dodgers assemble batch for AILZ80ASM
rem <https://github.com/AILight/AILZ80ASM>
rem
rem MZ-700/1500

set ASM=\tool\AILSZ80\AILZ80ASM.exe

%ASM% -lst -bin LDI.MZT -i M7I.ASM -f -gap 0 -sym

