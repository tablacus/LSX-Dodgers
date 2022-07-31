rem 
rem LSX-Dodgers assemble batch for ZASM(Windows 64-bit)
rem <https://www.vector.co.jp/soft/dos/prog/se010314.html>
rem <http://takeda-toshiya.my.coocan.jp/msdos/>
rem

set ASM=\tool\zasm\zasm.exe
set DOS=\tool\msdos\msdos.exe

%DOS% %ASM% LD.ASM -CLD.BIN -L
