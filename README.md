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
### SET 1: 基本ライブラリ
**★ 頻繁に使用し、迅速に実装するためのライブラリ**

AMID: 引数を正と負に拡張し、mid() を実行します。

BPACK: 複数の値を複数のビット幅でパックします。

BUNPACK: 値をビット幅でスライスします。

CAT: テーブルを連結します。数値インデックスは末尾に追加され、同一のキーは上書きされます。

COMB: 2つのテーブルを結合してハッシュテーブル（key/valueペア）を作成します。

ECPALT: パレットテーブルから透明度を設定します。

HTD: 16進数の連続文字列をテーブルに分割します。

HTBL: 文字列をテーブルに変換します (多次元配列 / ハッシュ テーブル / ジャグ配列)

INRNG: 指定された値が範囲内にあるかどうかをテストします。

JOIN: 区切り文字を使用して文字列を結合します。

MKPAL: PAL() で使用するためのカラースワップテーブルを作成します。

MSPLIT: マルチレイヤー分割。

OPRINT: アウトライン付きで印刷します。

RCEACH: 矩形値から反復します。

REPLACE: 文字列の置換を行います。

TBFILL: 指定した値で埋められたテーブルを作成します。

TMAP: よりコンパクトに操作可能な foreach 反復子です。

TOHEX: 桁揃えの16進数変換 (0xは含みません)。

TTABLE: 引数がテーブルの場合、テーブルを返します。

### SET 2: オブジェクトを作成するライブラリ
**★ 判定と描画を組み込んだ矩形、画面と操作の遷移を管理するシーン**

EXRECT: 拡張機能を備えた矩形オブジェクトを作成します。

MKSCENES: この投稿! 画面と操作の切り替えを管理します。

### SET 3: デバッグライブラリ
**★ リアルタイムまたは任意のタイミングで停止して検査します**

DBG: 任意のタイミングでデバッグ値を表示します。

DMP: 変数に関する情報をダンプします。

----
**++ REMOVED ++**

TOC: flr(divide) は \ の代わりに使用できます。

ECMKPAL: フォーマットが変更され、MKPAL に統合されました。

OUTLINE: OPRINT に名前が変更されました。v0.14 knutil に反映されます。

SPLIT: MSPLIT に名前が変更されました。v0.14 knutil に反映されます。

TTOH: ビットを引数 2 にシフトして引数 1 の数値を合計します。この関数は BPACK に再指定されました。

HTOT: 整数値を 8 ビットに分割してテーブルにします。この関数は BUNPACK に再指定されました。

SLICE: 指定されたインデックスでテーブルを切り出します。同様の機能を持つ {unpack()} があるため、この関数は削除されました。

BMCH: 2 つの値を比較して、両方に共通するビットがあるかどうかを判断します。「ビット演算子」によって重要性が低くなります。

TONORM: 引数の値を正しい型 (boolian、nil、number) に正規化します。

