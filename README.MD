LSX-Dodgers for X1/turbo/Z, MZ-700/1500, PC-8801mkIISR and MSX Gaku

A>■


# 機能概略

 このソフトはX1/turbo/ZやMZ-700/1500やPC-8801mkIISRやMSXでCP/M80やMSX-DOSのソフトを実行するためのOSです。  
MS-DOS互換のファイルフォーマットを持ちCP/M80やMSX-DOSと互換のシステムコールを持っています。  
また、階層ディレクトリにも対応しています。  
「エルディー」って呼んでください。  

# エミュレータ用イメージファイル

以下のページの Assets からダウンロードできます。  
https://github.com/tablacus/LSX-Dodgers/releases

# X1/turbo/Z版の起動方法
1. FD0に`ldsys.d88`をセット
2. 起動デバイスを2Dにする(すでに2Dの場合はここは省略可)
3. リセットする

FD0にセットしたらIPLからキーボードでF→0→0(X1turbo実機ROM)/F→0(X1実機ROM)/0(互換ROM)として`ldsys.d88`を入れたディスクを起動してもOKです。

# MZ-700/1500版の起動方法
1. Lコマンドでテープ(やQD)から読み込む体勢にする
2. FD1に`ldsys.d88`をセット
3. CMTに`LD.MZT`をセットする

# PC-8801mkIISR版の起動方法
1. N88-V2 modeにする(すでにV2モードの場合はここは省略可)
2. FD1に`ldsys.d88`をセット
3. 起動しない場合はリセットする

# MSX版の起動方法
1. Windowsのコマンドラインで`msxcat.bat`を実行してシステムとディスクイメージ`ROM.DSK`を連結する
2. ROMスロットに`LDMSX.ROM`をセット
3. ROMイメージのタイプを`ASCII-16K`、`ASCII-8K`(2MB以下の場合のみ)、`Konami-8K`(512MB以下の場合のみ)のいずれかに設定
4. 起動しない場合はリセットする

連結作業はディスクイメージを書き換えや差し替えしない場合は一度実行したら省略可
`LDMSX.BIN`と`ROM.DSK`連結できれば何を使っても良いです。
連結できるディスクイメージは2DD(640KB/720KB)のDSK、2HD(1.25MB)のXDF,IMG及び2HD(1.44MB)のIMGなど4MB以下のBPBを0セクタに持つMS-DOSフォーマット(FAT12/FAT16)の1セクタが1024バイト以下でベタ形式のディスクならOKです。

フロッピーから起動したい場合は似非DOS for MSXを使用してください。
https://github.com/tablacus/dosformsx


# 手引書

## システムコール一覧  
https://github.com/tablacus/LSX-Dodgers/blob/master/LDCALL.TXT  
基本的に MSX-DOS や CP/M と互換性があります。  

## FCB ファイルコントロールブロック  
https://github.com/tablacus/LSX-Dodgers/blob/master/LDFCB.TXT  
基本的に MSX-DOS や CP/M と互換性があります。  

## ディレクトリエントリ  
https://github.com/tablacus/LSX-Dodgers/blob/master/LDDIRENT.TXT  
MSX-DOS や MS-DOS と同じです。  

## ドライブパラメータブロック  
https://github.com/tablacus/LSX-Dodgers/blob/master/LDDPB.TXT  

## メモリマップ  
https://github.com/tablacus/LSX-Dodgers/blob/master/LDMAP.TXT  

## 内部コマンド  
https://github.com/tablacus/LSX-Dodgers/blob/master/LDCMD.TXT  

## スペック  
https://github.com/tablacus/LSX-Dodgers/blob/master/LDSPEC.TXT  

## ライセンス  
https://github.com/tablacus/LSX-Dodgers/blob/master/LICENSE.TXT  
MIT License のオープンソースです。  
MSX版は[スロットコール関連のルーチン等](https://github.com/tablacus/LSX-Dodgers/tree/master/msx_cbios)に BSD License の [C-BIOS](http://cbios.sourceforge.net/) のコードを使用しています。この部分のライセンスについてはC-BIOSのライセンスになります。


# エミュレータ

X1/turbo/Z、MZ-700/1500、PC-8801mkIISR、MSXどれも互換BIOS(ROM)及び互換フォントが存在するために実機を持っていなくてもエミュレータで楽しめます。

## X1/turbo/Z

X1エミュレータ環境を整える  
https://note.com/medamap/n/n4146227b2f9e

### エミュレータ

Common Source Code Project  
http://takeda-toshiya.my.coocan.jp/common/index.html

Xmillennium系の場合はBIOS、フォント共に入れなくても内蔵しているために動作します。  
この場合は互換BIOS入れない方が相性が良い感じがします。

Xmil106でLSX-Dodgers for X1を使う  
https://xmil106.web.fc2.com/toppage.html

X millennium  
https://turboz.to/

### 互換BIOS(ROM)

X1 compatible ROM  
https://github.com/meister68k/X1_compatible_rom

### 互換フォント

X1互換 8x8ドットフリーフォント  
https://github.com/meister68k/X1_compatible_font

16ドットフォントや漢字フォントを入手するには上記のXmillennium.exe(ねこちゅーん)を起動しすると以下のフォントファイルが作成されます。
```
FNT0816.TMP
FNT1616.TMP
```
これを以下のように拡張子を`X1`にリネームしてください。
```
FNT0816.X1
FNT1616.X1
```
Xmillennium.exe(ねこちゅーん)とLSX-Dodgersは[DMAディスク関連で相性が悪い](https://tablacus.github.io/LSX-Dodgers/)のでeX1系かXmil106を使うのをお勧めします。

## MZ-700/1500

Introduction to EmuZ-1500  
http://mzakd.cool.coocan.jp/starthp/emuz1500.html

### エミュレータ

Common Source Code Project  
http://takeda-toshiya.my.coocan.jp/common/index.html

フロッピーディスクに対応しているエミュレータです。

### 互換BIOS(ROM)

MZ-NEW MONITOR ＲＯＭイメージファイル

MZ700WIN関連ファイル再配布所  
http://mzakd.cool.coocan.jp/mz-memories/mz700win.html##6

### 互換フォント

MZ-700WIN /EmuZ-700フォントデータの作成  
http://mzakd.cool.coocan.jp/starthp/subpage15.html


## PC-8801mkIISR

### エミュレータ

project m88  
http://retropc.net/cisc/m88/

2D/2DD/2HDの読み書きが可能でした。

Common Source Code Project  
http://takeda-toshiya.my.coocan.jp/common/index.html

10/14/2022版では実機の2HD対応ROMで無い場合は2D以外には制限をかけているようです。  
ePC-8801MAで2DD/2HDを使う方法→ https://github.com/tablacus/LSX-Dodgers/issues/13

Manuke Station : Project X88000  
https://quagma.sakura.ne.jp/manuke/x88000.html

PC-8801MAエミュレータ XM8  
http://retropc.net/pi/xm8/index.html

互換BIOS(ROM)で使う場合は以下のダミーROMも必要になります。  
https://github.com/tablacus/LSX-Dodgers/issues/18

### 互換BIOS(ROM)

project m88  
http://retropc.net/cisc/m88/

project m88にある`Pseudo BIOS`がエミュレータ用擬似BIOSになります。


### 互換フォント

Manuke Station : Project X88000  
https://quagma.sakura.ne.jp/manuke/x88000.html

Gen88Font  
PC-8801エミュレータ用フォントジェネレータ

project m88  
http://retropc.net/cisc/m88/

漢字 ROM 作成キット


## MSX

MSXのエミュレータの場合はBIOSやフォントを内蔵しているものが多いようです。

### エミュレータ

WebMSX
https://webmsx.org/

WebMSX(C-BIOS)
https://webmsx.org/cbios/

blueMSX
http://bluemsx.msxblue.com/

Common Source Code Project  
http://takeda-toshiya.my.coocan.jp/common/index.html

### 互換BIOS(ROM)

C-BIOS
https://cbios.sourceforge.net/


# イメージファイル

X1のエミュレータではだいたい以下のイメージファイルが扱える様です。  
MS-DOSフォーマットでは2DDのDSK形式がもっとも様々な機種のエミュレータで使用できる形式だと思います。  
- 2Dは16ビットマシンでは扱えないものが多い
- 2HDは8ビットマシンで2HDに対応していない場合とNEC系とIBM系が分かれているので。

## D88/D77
88のエミュレータで開発された2D/2DD/2HDが扱えるフォーマットです。  
いろんなフォーマットに対応していて8ビットのエミュレータではデファクトスタンダードの存在です。  
FM系の場合は拡張子がD77になるそうです。

## DSK/IMG/XDF
ベタ形式でMS-DOSフォーマットで使われています。  
MSX/98/X68Kのエミュレータで使われています。

## 2D
ベタ形式で2Dで1セクタ256バイト、1トラックあたりのセクタ数が16の320KBフォーマットで使われています。  
MS-DOS系のフォーマットがなさそうなので今のところLSX-Dodgersでは使っていません。  
※BPBを作成すればMS-DOSフォーマットで扱うことはできると思います。

|エミュレータ|2D|2DD|2HD|2HD(1.44)|HDD|RAMDISK|リモート|
|--|--|--|--|--|--|--|--|
|eX1/eX1twin|D88| - | - | - |LD-hdd|G:48K/E:320K| - |
|eX1turbo/eX1turboZ|D88|D88/dsk|D88/img/xdf| - |LD-hdd|G:48K/E:320K/F:512K| - |
|Xmil106(X1)|D88|D88| - | - |LD-hdd|G:48K/E:16M|RLC/RLS|
|Xmil106(turbo/Z)|D88|D88|D88|D88|LD-hdd|G:48K/F:512K/E:16M※2|RLC/RLS|
|EmuZ-700/EmuZ-1500|D88|D88| - | - | - |C:32K/F:64K/E:16M※2| - |
|M88|D88|D88|D88|D88| - |F:512K| - |
|ePC-8801ma|D88|D88/dsk|D88/img/xdf(※1)| - | - |F:512K| - |
|X88000|D88| - | - | - | - |F:512K| - |

※1 2HD機の実機ROMか疑似ROMに改修が必要  
[ePC-8801MAで2DD/2HDを使う方法](https://github.com/tablacus/LSX-Dodgers/issues/13)  
※2 Xmillennium系と同じフォルダに`emm0.mem`を作成する必要がある（電源を切っても内容が保存されます）
[Xmil106でのEMMディスクの作成方法](https://github.com/tablacus/LSX-Dodgers/issues/17)

# Windows等とのファイルのやり取り

## L3ディスクエクスプローラ(L3 Disk Explorer) 
http://s-sasaji.ddo.jp/bml3mk5/

2D/2DD/2HDのD88/DSK/XDF/IMG形式のイメージファイルが扱えます。  
他にもいろんな機種のフォーマットに対応しています。
空の仮想ディスクを作成することもできます。https://github.com/tablacus/LSX-Dodgers/issues/11

## X1DiskExplorer
https://ceeezet.syuriken.jp/

2D/(2DD/2HD)のD88形式のイメージファイルが扱えます。  
LAバイナリを自動変換してくれる機能があるのでL-os Angelesも使用する場合に便利です。  
※2DD/2HDは一覧だけ利用できます。
※PC-8801mkSRのブート対応ディスクは変則フォーマットの為にアクセスできなくなりました。

## DiskExplorer
http://hp.vector.co.jp/authors/VA013937/editdisk/

2DD/2HDのDSK/XDF/IMG形式および各種ハードディスクのイメージファイルが扱えます。

MS-DOSフォーマットでBPBがあれば読み書き可能なようです。

### MZ-700/1500版のCMOSバッテリバックアップメモリ(32K)ドライブ(C:)
MZ-700/1500版のLSX-Dodgers上で未フォーマットの場合はフォーマットを行い
```
format c:
```
MAKEBPBでBPBを作成します。
```
makebpb c:
```
エミュレータを終了すると`CMOS.BIN`が作成されています。   
このファイルを`DiskExplorer`で開き`plain image`を選択するとファイルのやり取りが行えます。


# ハードディスク

X1/turbo/Z版は以下のドライバを使うとハードディスクに接続できます。  

## LD-hdd
https://github.com/ho-ogino/LD-hdd/releases  

エミュレータでは以下の方法でイメージファイルを作成する事ができます。現在は512MBまで作成可能です。

## WindowsでのVHDファイルの作り方
[WindowsでのVHDファイルの作り方](https://github.com/tablacus/LSX-Dodgers/issues/4)

VHDはWindowsにもそのままマウントできるのでファイルのやり取りにも使えます。

## LD-hdd利用方法
まず、上記からダウンロードした`hdd.com`をフロッピーに上記のWindowsとのやり取りを行うソフトを使ってコピーしておきます。

### eX1系
1. HD0に作成したイメージファイルをセット
2. フロッピーから`hdd.com`を実行

### Xmillennium系
1. 作成したイメージファイルをXmillennium系と同じフォルダに`sasi0_0.hdd`という名前にリネームして置いておきます。
2. フロッピーから`hdd.com`を実行

# 基本的なシステムコールの使い方のサンプル

https://github.com/tablacus/LSX-Dodgers/wiki

wikiに文字列を表示したり、ファイルを読み出したり、書き込んだり、削除したりするサンプルがあります。

# アセンブラ

X1/turbo/Z版はOHM-Z80とZASM.COM/ZASM.EXE/AASM/AILZ80ASMでアセンブルできます。  
make.jsを使うと zasm に ZASM.COM/ZASM.EXE用にコンバートします。  
ZASMはINCLUDEを使うとPRNがいい感じに出ないのでWSHでコンバーターを作りました。  
コンバートにZephyr1969さんの変更方法を参考にさせてもらいました。ありがとうございます。  

https://github.com/tablacus/LSX-Dodgers/issues/3

MZ-700/1500版、PC-8801mkIISR版、MSX版はAILZ80ASMでアセンブルできます。  


## AILZ80ASM  
https://github.com/AILight/AILZ80ASM/releases/tag/v1.0.0

以下のバッチファイルを使用します。  
```BAT
ASM_AILZ80ASM_X1.BAT
ASM_AILZ80ASM_M7.BAT
ASM_AILZ80ASM_88.BAT
ASM_AILZ80ASM_MSX.BAT
```
## AASM
https://www.vector.co.jp/soft/dos/prog/se010314.html

以下のバッチファイルを使用します。  
```BAT
ASM_AASM.BAT
```
## ZASM
https://www.vector.co.jp/soft/dos/prog/se010314.html  

64ビットのWindowsでアセンブルする場合はMS-DOS Player for Win32-x64などMS-DOSを実行させるソフトが必要です。  
http://takeda-toshiya.my.coocan.jp/msdos/  

MS-DOSや32ビットのWindowsの場合は以下のバッチファイルを使用します。  
```BAT
ASM_ZASM.BAT  
```
64ビットのWindowsの場合は以下のバッチファイルを使用します。  
```BAT
ASM_ZASM64.BAT
```
## OHM-Z80  
L-os Angelesで以下のバッチファイルを使用します。  
```BAT
ASM.BAT
```

# 注意

 LSX-Dodgersはディスクアクセスで簡単な遅廷書き込み機能を採用しています。カーソルが表示されるキー待ちでバッファをフラッシュします。フロッピーの入れ換えは必ずカーソルが表示されている時に行なって下さい。そうしないとディスクの内容を壊してしまうことがあります。  
※特にディスクエラーで処理を選択する時にはディスクの入れ換えをしないで下さい。


# その他

X1ではステップレートの関係でCZ-800Fは使えません。
MS-DOS互換のファイルフォーマットとS-OS"SWORD"のファンクションをもつOS、[L-os Angeles](https://github.com/tablacus/LosAngeles)もあります。

