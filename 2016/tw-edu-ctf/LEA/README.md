# LEA (crypto 200)

Description:
```
Yes, "leave as final exam".
http://52.68.224.122:9000/
```

連結裡面是一個有點類似 CTR 那題的驗證服務，一樣是提供兩種功能，一種是 `sign`，丟訊息他就會生出對應的 [HMAC](https://en.wikipedia.org/wiki/Hash-based_message_authentication_code) 驗證碼，不過有趣的是在 44 行，當有一個 `deprecated` 參數的時候，會直接吃進 `data`，**不靠任何 padding**就直接加上 KEY 產生 SHA-1。<br>
這麼做，就製造了一些可以攻擊的空間。

這題裡面有不自動 padding 產生的 HMAC，題目名稱又叫 LEA，開宗明義就是 Length Extension Attack 嘛！

[Length Extension Attack](https://en.wikipedia.org/wiki/Length_extension_attack) 是一種針對在直接拿把 key + data 接在一起，沒有任何 padding 的 hash，當作脆弱的 HMAC 使用的時候的攻擊型態。<br>
因為用了 SHA-1 的背後，有個產生 hash 的結構叫 Merkle–Damgard，<br>
它有一個問題就是，當你知道 任一一個message 和算出來的 MAC，只需再知道 key 的長度，儘管不知道 key 的值，也能透過在後面加一些字串的方式，算出符合的 HMAC。

有一個工具叫做 [HashPump](https://github.com/bwall/HashPump)，可以幫我們推出 Length Extension Attack 這個手法需要的 payload。

反正就生：

```
>>> from requests import get
>>> from hashpumpy import hashpump
>>> import base64
>>> token = get("http://52.68.224.122:9000/sign", {"deprecated":True, "data":'\x36'*64+'a'}).text
>>> token
'71d326b6de4844332173e4fa661712abf37ffd19'
>>> result = hashpump(token, 'a', 'flag', 64)
>>> result
('5be054779031ac988404f7bb14679a00e1b8fab4', b'a\x80\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x08flag')
>>> sign = get("http://52.68.224.122:9000/sign", {"deprecated":True, "data": b'\x5c'*64+binascii.unhexlify(token[0])}).text
>>> sign
'a7ee3fb6b18e7fdd51cadfeb63e2c7d0d0c6a3c5'
>>> get("http://52.68.224.122:9000/verify", {"data": result[1], "sig": sign}).text
'CTF{did you use hashpump~?}'
```

Flag `CTF{did you use hashpump~?}`
