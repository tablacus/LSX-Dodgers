rem
rem LSX-Dodgers assemble batch for AILZ80ASM
rem <https://github.com/AILight/AILZ80ASM>
rem
rem 直接BINを生成しているのでパディングが0xFFになります。
rem zasmの出力とコンペアしたい場合はAASMと同様にHEXで出力
rem してからbinhexへ変換してください
rem

set ASM=\tool\AILSZ80\AILZ80ASM.exe

%ASM% -lst -bin -i LD.ASZ
