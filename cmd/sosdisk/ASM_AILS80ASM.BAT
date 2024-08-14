rem
rem Assemble batch for AILZ80ASM
rem <https://github.com/AILight/AILZ80ASM>
rem

set ASM=\tool\AILSZ80\AILZ80ASM.exe

%ASM% -lst -bin SOSDISK.COM -i SOSDISK.ASM -f -sym