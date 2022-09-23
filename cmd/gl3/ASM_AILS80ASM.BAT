rem
rem Assemble batch for AILZ80ASM
rem <https://github.com/AILight/AILZ80ASM>
rem

set ASM=\tool\AILSZ80\AILZ80ASM.exe

%ASM% -lst -bin GL3.COM -i GL3.ASM -f -gap 0
