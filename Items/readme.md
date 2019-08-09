# Items
- Storage organize addon.
    - `<angle brackets>` - Required parameter. Replace with an appropriate value.
    - `[square brackets]` - Optional parameter. Replace with an appropriate value. Or don't!

## 日本語
### Commands
- //items get `<storage>`
    - 指定した`storage`のアイテム全てをマイバックに移動します。
- //items get `<item>` `[counts]`
    - 指定した`item`をマイバックに全て、または`counts`個移動します。
- //items put
    - `data/setting.xml`で定義した[正規表現]にmatchするマイバッグ内のアイテムを、定義したストレージに収納します。
- //items put `<storage>`
	- 指定`storage`にマイバッグ内のアイテムを全て収納します。
- //items use `<item>` `<counts>`
  - マイバッグ内の指定`item`を`counts`回使用します。
- //items discardsall
  - **非推奨** - マイバッグ内の装備,リンクシェルを**除く**アイテムを全て捨てます。大切なアイテムを捨てないよう、取扱には十分注意してください。
  - **NOT** Recommend! - Discards all items **without** Equipment and Linkshell in your inventory. Please be careful enough with safety.

|storage|command|
|:-:|:-:|
|モグ金庫|safe|
|モグ金庫2|safe2|
|収納家具|storage|
|モグロッカー|locker|
|モグサッチェル|satchel|
|モグサック|sack|
|モグケース|case|
|モグワードローブ|wardrobe|
|モグワードローブ2|wardrobe2|
|モグワードローブ3|wardrobe3|
|モグワードローブ4|wardrobe4|

### [正規表現]

|記号|効果|正規表現例|match|
|:-:|:-:|:-:|:-:|
|&#124;|OR|メタル&#124;高純度ベヤルド|メタルポーチ,ヘヴィメタル,高純度ベヤルド etc..
|.*|任意の文字列|闇の.*具|闇の胴具：学,闇の脚具：黒 etc..|
|^|文字列の最初|^聖水|聖水とmatch,祝聖水とmatchしない
|$|文字列の最後|女王の指輪$|女王の指輪とmatch,女王の指輪+1とmatchしない|
|`\`|エスケープ|女王の指輪`\\`+1|+は正規表現で使用する記号。単なる文字列であることを表現|

- 文字コードshift_jisの関係で2バイト文字は`.{3}`とmatchします。
- 一部の[ダメ文字](https://sites.google.com/site/fudist/Home/grep/sjis-damemoji-jp)はエスケープが必要。代表的な例は"ソ"
  - `//items get ソ\\ールスティス`
  - 単に `//items get スティス` のような部分一致でも構いません。

[正規表現]:http://www.mnet.ne.jp/~nakama/
