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
CMDSCENES([[
[SCENE NAME] [COMMAND] [FUNCTION NAME] [DURATION FRAME]
[SCENE NAME] [COMMAND] [FUNCTION NAME] [DURATION FRAME]
...
]])
```
- [SCENE NAME]     　: MKSCENESで生成した名前を指定します。
- [COMMAND]      　　  :下記のORDER COMMANDSを指定します。
- [FUNCTION NAME]  : グローバル関数の名前を指定します。
- [DURATION FRAME] : 持続するフレーム数を指定します。0で指定すると自動的に終了しません。


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
FOR V IN ALL(INDEXES)
	SCENES[V].TRA()
END
```

## ORDER関数
```
FUNCTION [FUNCTION NAME] ( ORDER )
	CLS()
	IF ORDER.FST THEN
		STOP"IT'S FIRST!"
	END
	IF ORDER.LST THEN
		STOP"IT'S LAST!"
	END
	PRINT('COUNT: '..ORDER.CNT..'/'..ORDER.DUR)
END
```

## ORDERのプロパティ
### プロパティ：FST / LST
ORDER.FST : 最初の実行時にTRUE、それ以外はFALSE
ORDER.LST : 最後の実行時にTRUE、それ以外はFALSE

### プロパティ：CNT / DUR
ORDER.CNT : 現在走っているORDERの実行カウント
ORDER.DUR : 現在走っているORDERの終了予定のカウント

### プロパティ：PRM
CMDSCENESの２番目の引数で指定した値が入っています。

### RATE
座標などで、開始から終了を指定するときに使います。
```
ORDER.rate('[start] [end]', duration, count )
```
durationとcountはデフォルトの場合、CMDSCENESで指定したものが使われます。

### オーダーの強制終了
`return 1`をするか、`ORDER.rm = 1`をする。

このライブラリの中で私が既に投稿したものがあります。
- HTBL
- VDMP

説明がされていない関数（別の機会に投稿します）
- TONORM
- TOHEX
- TTOH
- HTOT
- REPLACE
- EXRECT(RFMT)
- TOC
- JOIN
- SPLIT(wrapper function)
- HTD
- SLICE
- CAT
- COMB
- TBFILL
- ECXY
- OUTLINE
- TMAP
- MKPAL
- ECPALT
- TTABLE
- INRNG
- AMID
- BMCH
