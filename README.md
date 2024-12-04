# KNUTIL SCENE MANAGER
"KNUTIL"は自分が作成したゲームで、使用頻度の高い関数をまとめたPICO-8用ライブラリです。
制作で最終的に必要になった関数を残してあります。

このカートではシーン機能の動作についてアニメーションで示しています。


![knutil_2](https://user-images.githubusercontent.com/8139723/109604067-3b7f2100-7b66-11eb-92ee-94b1b890f337.gif)

 **SCENE MANAGER**は連続した文字列の命令によって、少ないトークンで関数の呼び出す順番の制御、入れ替えをします。  
生成したSCENEはグローバル関数をORDERとして登録することができます。  
登録されたORDERはSCENEによって一つ取り出され、指定した長さだけ処理を繰り返します。  
処理が終わると、次のORDERの処理を繰り返します。  
これにより、演出の実装を容易にすることが期待できます。  

## SCENEの利用
### SCENEを作成する ( MKSCENES )
```
SCENES, INDEXES = MKSCENES( { 'UPD', 'DRW', 'KEY' } )
```
SCENES: 生成されたシーンが格納されています。
INDEXES: 生成した順にシーンを実行するために必要です。

### シーンにORDERを入力する ( CMDSCENES )
```
SCMD([[
	[SCENE NAME] [COMMAND] [FUNCTION NAME] [DURATION FRAME]
	[SCENE NAME] [COMMAND] [FUNCTION NAME] [DURATION FRAME]
...
]])
```
- [SCENE NAME]     　: MKSCENESで生成した名前を指定します。
- [COMMAND]      　　  :下記のORDER COMMANDSを指定します。
- [FUNCTION NAME]  : グローバル関数の名前を指定します。
- [DURATION FRAME] : 持続するフレーム数を指定します。0を指定するとORDERは持続し続けます。


## ORDER COMMANDS
### ST (SET): SCENEにスタックしているオーダーを全て削除し、新しいオーダーをセットする
```
CMDSCENES[[
UPD ST MANAGE 0
]]
```
シーン「UPD」をクリーンにして、「FUNCTION MANAGE」を追加します。

### PS (PUSH): SCENEにオーダーを追加する(PUSH)
```
CMDSCENES[[
KEY PS KEYCHECK 0
]]
```
シーン「KEY」に「FUNCTION KEYCHECK」を先頭に追加します。

### US (UNSHIFT): SCENEの最初にオーダーを割り込みさせる
```
CMDSCENES[[
DRW US DRAWRECT 200
DRW US NIL 100
DRW US DRAWCIRC 200
]]
```
シーン「DRW」はDRAWCIRC, NIL, DRAWRECTの順で実行されます

### RM (REMOVE): オーダーを一つ削除する
```
CMDSCENES[[
DRW RM
]]
```
シーン「DRW」の先頭のオーダーを削除します。

```
CMDSCENES[[
DRW RM DRAWRECT
]]
```
シーン「DRW」のDRAWRECTオーダーを先頭から優先して削除します。

### CL (CLEAR): シーンにスタックしているオーダーをすべて削除する
```
CMDSCENES[[
KEY CL
]]
```
シーン「KEY」に登録されたオーダー全てが削除されます。

### FI (FIND): シーンの中からオーダーを検索して取得する
```
RES = CMDSCENES[[
DRW FI DRAWRECT
]]
```
この場合、返り値RESはテーブルであり、「DRAWRECT」のオーダーは最初に入っています。

## ORDERのための関数を作る
```
FUNCTION KEYCHECK( ORDER )
	PRINT('PROCESSIONG ORDER')
END
```

## 各シーンを実行する
```
# _UPDATE()、_DRAW()関数の中で
FOREACH(SCENES,TRANSITION)
```

## ORDER関数
```
FUNCTION [FUNCTION NAME] ()
	CLS()
	IF _FST THEN
		STOP"IT'S FIRST!"
	END
	IF _LST THEN
		STOP"IT'S LAST!"
	END
	PRINT('COUNT: '.._CNT..'/'.._DUR)
END
```

## ORDERのプロパティ
### _FST / _LST
_FST : 最初の実行時にTRUE、それ以外はFALSE
_LST : 最後の実行時にTRUE、それ以外はFALSE

### _CNT / _DUR
_CNT : 現在走っているORDERの実行カウント
_DUR : 現在走っているORDERの終了予定のカウント

### _PRM
SCMD()の２番目の引数で指定した値が入っています。

### _RATE
開始から終了の座標などを算出するときに使います。
```
_RATE('[start] [end]', duration, count )
```
durationとcountはデフォルトの場合、SCMD()で指定したものが使われます。

### オーダーの強制終了
`return 1`をするか、`_RM = 1`をする。

## SCENE以外の関数
SET 1: Basic Library
★ Libraries for frequent use and quick implementation

AMID: Expand the arguments to positive and negative and do mid().

BPACK: Pack the value of the bit specification with bit width.

BUNPACK: Slice the value with bit width.

CAT: Concatenate tables. Indexes are added last and identical keys are overwritten.

COMB: Combines two tables to create a hash table.

ECPALT: Set transparency from palette table.

HTD: Split a continuous string of hexadecimal numbers into a table.

HTBL: Converting a string to a table(Multidimensional Array / Hash Table / Jagged Arrays)

INRNG: Tests that the specified value is within a range.

JOIN: Joins strings with a delimiter.

MKPAL: create a color swap table for use in PAL().

MSPLIT: Multi-layer split.

OPRINT: Print with outline.

RCEACH: Iterate from rectangle values.

REPLACE: Perform string substitutions.

TBFILL: Creates a table filled with the specified values.

TMAP: More compact operable foreach iterator.

TOHEX: Digit-aligned hexadecimal conversion (not including 0x).

TTABLE: If the argument is a table, the table is returned.

SET 2: Libraries to create objects
★ Rectangles that incorporate judgment and drawing, scenes that manage screen and operation transitions

EXRECT: Creates a rectangle object with extended functionality.

MKSCENES: This post! Manage screen and operation switching.

SET 3: Debugging Library
★ Real-time or stop and inspect at any timing

DBG: Displays any timing debugging value.

DMP: Dumps information about a variable.

++ REMOVED ++
TOC: flr(divide) can be substituted for \.
ECMKPAL: The format was changed and integrated in MKPAL.
OUTLINE: Renamed to OPRINT, will be reflected in v0.14 knutil.
SPLIT: Renamed to MSPLIT, will be reflected in v0.14 knutil.
TTOH: Sum the numbers in argument 1 by shifting bits to argument 2. This function has been re-specified to BPACK.
HTOT: Divide an integer value into 8 bits and make it into a table. This function has been re-specified to BUNPACK.
SLICE: Cuts out the table at the specified index. the function was removed because there is a {unpack()} with a similar function.
BMCH: Compares two values to judge that they both have a bit in common. "Bitwise operators" make it less significant.
TONORM: Normalize argument values to the correct type(boolian, nil, number).

