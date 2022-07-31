rem 
rem LSX-Dodgers assemble batch for AASM
rem <http://www9.plala.or.jp/sagae_/soft/index.html>
rem

set ASM=\tool\aasm\aasm.exe
set H2B=\tool\aasm\hex_ut.exe

%ASM% -t10 -E -l  LD.ASZ
%H2B% LD.HEX -C5F9 LD.TMP
%H2B% LD.TMP -IB LD.BIN,00
del LD.TMP
