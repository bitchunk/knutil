# KNUTIL SCENE MANAGER
"KNUTIL"は自分が作成したゲームで、使用頻度の高い関数をまとめたライブラリです。
制作で最終的に必要になった関数を残してあります。

このカートではシーン機能の動作についてアニメーションで示しています。

# シーンの利用
## [ MKSCENES ] シーンを作成する
SCENES, INDEXES = MKSCENES( { UPD, DRW, KEY } )
SCENES: 生成されたシーンが格納されています。
INDEXES: 生成した順にシーンを実行するために必要です。

## [ CMDSCENES ] シーンにORDERを入力する
CMDSCENES([[
[SCENE NAME] [COMMAND] [FUNCTION] [DURATION FRAME]
[SCENE NAME] [COMMAND] [FUNCTION] [DURATION FRAME]
...
]])
[SCENE NAME] MKSCENESで生成した名前を指定します。
[COMMAND]下記のORDER COMMANDSを指定します。
[FUNCTION] グローバル関数の名前を指定します。
[DURATION FRAME] 持続するフレーム数を指定します。0で指定すると自動的に終了しません。


### ORDER COMMANDS
- ST: SCENEにスタックしているオーダーを全て削除し、新しいオーダーをセットする(SET)
UPD ST MANAGE 0
-- シーン「UPD」をクリーンにして、「FUNCTION MANAGE」を追加します。

- PS: SCENEにオーダーを追加する(PUSH)
KEY PS KEYCHECK 0
-- シーン「KEY」に「FUNCTION KEYCHECK」を先頭に追加します。

- US: SCENEの最初にオーダーを割り込みさせる(UNSHIFT)
DRW US DRAWRECT 200
DRW US NIL 100
DRW US DRAWCIRC 200
--「DRW」はDRAWCIRC, NIL DRAWRECTの順で実行されます

- RM: オーダーを一つ削除する
DRW RM
-- シーン「DRW」の先頭のオーダーを削除します。

DRW RM DRAWRECT
-- シーン「DRW」のDRAWRECTオーダーを先頭から優先して削除します。

- CL: シーンにスタックしているオーダーをすべて削除する
KEY CL

- FI: シーンの中からオーダーを検索して取得する
DRW FI DRAWRECT

## 関数をオーダーに指定する
```
FUNCTION KEYCHECK( ORDER )
	PRINT('PROCESSIONG ORDER')
END
```

## 各シーンを実行する

## ORDERのプロパティ
### プロパティ：FST / LST
ORDER.FST:最初の実行時
ORDER.LST:最後の実行時

### プロパティ：CNT / DUR
ORDER.CNT:現在走っているORDERの実行カウント
ORDER.DUR:現在走っているORDERの終了予定のカウント

### プロパティ：PRM
CMDSCENESの２番目の引数で指定した値が入っています。

### RATE
座標などで、開始から終了を指定するときに使います。
`ORDER.rate('[start] [end]', duration, count )`
durationとcountはデフォルトの場合、CMDSCENESで指定したものが使われます。

### オーダーの強制終了
`return 1`をするか、`ORDER.rm = 1`をする。

このライブラリの中で私が既に投稿したものがあります。
HTBL
VDMP

説明がされていない関数（別の機会に投稿します）
TONORM
TOHEX
TTOH
HTOT
REPLACE
EXRECT(RFMT)
TOC
JOIN
SPLIT(wrapper function)
HTD
SLICE
CAT
COMB
TBFILL
ECXY
OUTLINE
TMAP
MKPAL
ECPALT
TTABLE
INRNG
AMID
BMCH
