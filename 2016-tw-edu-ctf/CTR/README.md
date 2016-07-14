# CTR (crypto 100)

Description:
```
CTR mode has significant efficiency advantages over the standard encryption, but...
http://52.68.224.122:9010/
```

裡面的連結是一個有一堆 ruby code 的網站

code 是一個 `webrick` 的網頁伺服器（大概就是顯示這個頁面的），<br>
然後它有一個神秘的驗證系統，<br>
整個就很像 [HITCON CTF Quals 2015 的 simple](https://github.com/ctfs/write-ups-2015/tree/master/hitcon-ctf-quals-2015/crypto/simple). （除了這個是用 CTR 而不是 CBC，簡單了許多呢XD）

根據 source code，網站有兩個功能，第一個是 `login`，接一個參數 `user`，然後吐一串 base64-encoded 的東西，是 block cipher 的 IV （initialization vector）加上用 CTR 加密過後的 json dict  `{"user": [username]}`

```python
>>> import requests
>>> requests.get("http://52.68.224.122:9010/login", {"user": "foobar"}).text
'ookgVTsyAYr1EMpXKytRdbEW763Kp6L15ZuBtD0GaJAi'
```

另外一個則是 `admin`，反正就是用同樣的方式解密來驗證上面拿到的 `token` 是否正確，然後如果解出來的 json 含有 `admin` 而且值是 `true` 的話，就會在回傳的東西裡面加上 flag！

因為使用了 [CTR](https://en.wikipedia.org/wiki/Block_cipher_mode_of_operation#Counter_.28CTR.29) 這個 [cipher operation mode](https://zh.wikipedia.org/wiki/%E5%9D%97%E5%AF%86%E7%A0%81%E7%9A%84%E5%B7%A5%E4%BD%9C%E6%A8%A1%E5%BC%8F)，我們可以知道這樣可以對他做 [Bit-flipping attack](https://en.wikipedia.org/wiki/Bit-flipping_attack)。

（由於是 CTR，`密文 = AES(IV+counter) ⊕ 明文`，可是我們可以根據輸入的 `username` 得知明文是什麼，因此可以透過這樣來竄改密文：`舊明文 ⊕ 舊密文 = AES(IV+counter)`，∴`舊密文 ⊕ 舊明文 ⊕ 新明文 = 新密文` ）

所以來開始算吧：

```python
>>> import base64, binascii, requests
>>> def xor(x, y):
...     return binascii.unhexlify(hex(int(binascii.hexlify(x), 16) ^ int(binascii.hexlify(y), 16))[2:].zfill(len(y)*2))
...
>>> orig_token = base64.b64decode("0btB4oUvFdiao2QSPOjx5k7XtEuNr4UqlRtH7Si6/zg=")
>>> iv = orig_token[0:16]
>>> first_block = orig_token[16:32]

>>> orig_plaintext = b'{"user":"fooba"}'
>>> new_plaintext  = b'{"admin": true }'
>>> encrypted = xor(orig_plaintext, first_block)
>>> new_block = xor(encrypted, new_plaintext)
>>> payload = iv + new_block
>>> payload = base64.b64encode(payload)
>>> print(payload)
>>> requests.get("http://52.68.224.122:9010/admin", {"token": base64.b64encode(payload)}).text
'{"admin":true,"flag":"CTF{Flip Flop F1ip Fl0p}"}'
```

Flag: `CTF{Flip Flop F1ip Fl0p}`
