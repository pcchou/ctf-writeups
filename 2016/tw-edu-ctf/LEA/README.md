# LEA (crypto 200)

Description:
```
Yes, "leave as final exam".
http://52.68.224.122:9000/
```

連結裡面是一個有點類似 CTR 那題的驗證服務，一樣是提供兩種功能，一種是 `sign`，丟訊息他就會生出對應的 [HMAC](https://en.wikipedia.org/wiki/Hash-based_message_authentication_code) 驗證碼，不過有趣的是在 44 行，當有一個 `deprecated` 參數的時候，會直接吃進 `data`，**不靠任何 padding**就直接加上 KEY 產生 SHA-1。<br>
這麼做，就製造了一些可以攻擊的空間。

這題裡面有不自動 padding 產生的 HMAC，題目名稱又叫 LEA，開宗明義就是 Length Extension Attack 嘛！

[Length Extension Attack](https://en.wikipedia.org/wiki/Length_extension_attack) 是一種針對這種情況的攻擊型態：<br>
直接拿把 key + data 接在一起，沒有任何 padding 的 hash，當作脆弱的 HMAC 使用，這樣會因為 SHA-1 演算法的背後，有資料結構產生的問題，而讓這個攻擊型態有機可圖。
當你知道 任一一個message 和算出來的 MAC，只需再知道 key 的長度，儘管不知道 key 的值，也能透過在後面加一些字串的方式，算出符合的 HMAC。

有一個工具叫做 [HashPump](https://github.com/bwall/HashPump)，可以幫我們推出 Length Extension Attack 這個手法需要的 payload。

我們打開 python intrepreter，開始吧：

首先先 import 需要的函式庫（`hashpump`、用來發 HTTP 的 `requests`、解析 base64 編碼的 `base64`）：

```
>>> from requests import get
>>> from hashpumpy import hashpump
>>> import base64
>>> token = get("http://52.68.224.122:9000/sign", {"deprecated":True, "data":'\x36'*64+'a'}).text # 我們先從主機取得它產生出來的 token，再來玩玩 hashpump
>>> result = hashpump(token, 'a', 'flag', 64)
>>> sign = get("http://52.68.224.122:9000/sign", {"deprecated":True, "data": b'\x5c'*64+binascii.unhexlify(token[0])}).text
>>> sign
'a7ee3fb6b18e7fdd51cadfeb63e2c7d0d0c6a3c5'
>>> get("http://52.68.224.122:9000/verify", {"data": result[1], "sig": sign}).text
'CTF{did you use hashpump~?}'
```

Flag `CTF{did you use hashpump~?}`

