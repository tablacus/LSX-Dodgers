・LSX-Dodgers for X1/turbo/Z and MZ-700/1500 Gaku

A>■


●機能概略

 このソフトはX1/turbo/ZやMZ-700/1500でCP/M80やMSX-DOSのソフトを実行するためのOSです。  
MS-DOS互換のファイルフォーマットを持ちCP/M80やMSX-DOSと互換のシステム・コールを持っています。  
また、階層ディレクトリにも対応しています。  


●各種X1エミュレータ用LSX-Dodgers 起動ディスクイメージ

https://tablacus.github.io/LSX-Dodgers/


●手引書

システム・コール一覧  
https://github.com/tablacus/LSX-Dodgers/blob/master/LDCALL.TXT  
基本的に MSX-DOS や CP/M と互換性があります。  

FCB ファイル・コントロール・ブロック  
https://github.com/tablacus/LSX-Dodgers/blob/master/LDFCB.TXT  
基本的に MSX-DOS や CP/M と互換性があります。  

ディレクトリエントリ  
https://github.com/tablacus/LSX-Dodgers/blob/master/LDDIRENT.TXT  
MSX-DOS や MS-DOS と同じです。  

ドライブパラメータブロック  
https://github.com/tablacus/LSX-Dodgers/blob/master/LDDPB.TXT  

メモリマップ  
https://github.com/tablacus/LSX-Dodgers/blob/master/LDMAP.TXT  

内部コマンド  
https://github.com/tablacus/LSX-Dodgers/blob/master/LDCMD.TXT  

スペック  
https://github.com/tablacus/LSX-Dodgers/blob/master/LDSPEC.TXT  

ライセンス  
https://github.com/tablacus/LSX-Dodgers/blob/master/LICENSE.TXT  
MIT License のオープンソースです。  


●アセンブラ  

X1/turbo/Z版はOHM-Z80とZASM.COM/ZASM.EXE/AASM/AILZ80ASMでアセンブルできます。  
make.jsを使うと zasm に ZASM.COM/ZASM.EXE用にコンバートします。  
ZASMはINCLUDEを使うとPRNがいい感じに出ないのでWSHでコンバーターを作りました。  
コンバートにZephyr1969さんの変更方法を参考にさせてもらいました。ありがとうございます。  

https://github.com/tablacus/LSX-Dodgers/issues/3

MZ-700/1500版はAILZ80ASMでアセンブルできます。  


◇OHM-Z80  
L-os AngelesでASM.BATを使用します。  

◇ZASM
ZASMのバージョンは、Vectorの下記から手に入る1.64です。  
https://www.vector.co.jp/soft/dos/prog/se010314.html  

64ビットのWindowsでアセンブルする場合はMS-DOS Player for Win32-x64などMS-DOSを実行させるソフトが必要です。  
http://takeda-toshiya.my.coocan.jp/msdos/  

MS-DOSや32ビットのWindowsの場合は以下のバッチファイルを使用します。  
ASM_ZASM.BAT  

64ビットのWindowsの場合は以下のバッチファイルを使用します。  
ASM_ZASM64.BAT

◇AASM
AASMは以下のアドレスから入手してください。
https://www.vector.co.jp/soft/dos/prog/se010314.html

以下のバッチファイルを使用します。  
ASM_AASM.BAT  

◇AILZ80ASM  
AILZ80ASMは以下のアドレスから入手してください。  
以下のバッチファイルを使用します。  
ASM_AILZ80ASM_X1.BAT  
ASM_AILZ80ASM_M7.BAT


●注意

 LSX-Dodgersはディスク・アクセスで簡単な遅廷書き込み機能を採用しています。カーソルが表示されるキー待ちでバッファをフラッシュします。フロッピーの入れ換えは必ずカーソルが表示されている時に行なって下さい。そうしないとディスクの内容を壊してしまうことがあります。  
!特にディスク・エラーで処理を選択する時にはディスクの入れ換えをしないで下さい。


●その他

 ステップレートの関係でCZ-800Fは使えません。
MS-DOS互換のファイル・フォーマットとS-OS"SWORD"のファンクションをもつOS、L-os Angelesもよろしく

