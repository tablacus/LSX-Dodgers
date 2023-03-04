rem 
rem LSX-Dodgers assemble batch for AASM
rem <http://www9.plala.or.jp/sagae_/soft/index.html>
rem
rem X1/turbo/Z

set ASM=\tool\aasm\aasm.exe
set H2B=\tool\aasm\hex_ut.exe

%ASM% -t10 -E -l -s X1.ASZ
%H2B% X1.HEX -CCF9 LD.TMP
%H2B% LD.TMP -IB LD.BIN,00
del LD.TMP
