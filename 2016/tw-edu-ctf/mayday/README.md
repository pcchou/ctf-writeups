# mayday (crypto 150)

Description:
```
Here are some encrypted messages sent to Mayday.
https://www.dropbox.com/s/lwjkboz8ee8wz6l/mayday.zip?dl=0
```

題目給的 zip 解開後有 `mayday.py` 跟 `mayday.json` 兩個檔案，同樣的，一個是算加密的 code，另一個則是相關的數字。

`mayday.json` 有了七組 RSA 數字，各自的 n （模數：modulus） 不同，其中 e （指數：public exponent）都是 7<br>
而由於 n 的數字太大（剛好也有 7 個），我們知道不可能暴力因數分解它。

有趣的是，根據 `mayday.py`，所有的明文 `t` 都是一樣的，所以這樣就構成了 [Hastad's Broadcast Attack](https://en.wikipedia.org/wiki/Coppersmith%27s_Attack#H.C3.A5stad.27s_Broadcast_Attack) （廣播攻擊（？）的要件。

（Hastad's Broadcast Attack 基本上就類似[中國餘數定理](https://market.cloud.edu.tw/content/senior/math/tn_t2/math05/math_magic/1/1-6.htm)（也就是韓信點兵、鬼谷算）在 RSA 上的實做，因為多組 `cn = t^e % n` 也就等於解 `t^e ≡ cn (mod n)` （`cn` = `c1, c2, c3,...`）的同餘方程組，只要 `e` 的值不大（要可以快速求次方根；這裡是7），用中國餘數定理就可以推出原先的 `t`。）

所以我們來解同餘方程組吧！先用 [Rosetta Code 上的 CRT solver](http://rosettacode.org/wiki/Chinese_remainder_theorem#Python)：

```python
>>> from functools import reduce
>>> import gmpy
>>> import json, binascii
>>> def modinv(a, m): return int(gmpy.invert(gmpy.mpz(a), gmpy.mpz(m)))
>>> def chinese_remainder(n, a):
        sum = 0
        prod = reduce(lambda a, b: a*b, n)
        for n_i, a_i in zip(n, a):
            p = prod // n_i
            sum += a_i * modinv(p, n_i) * p
        return int(sum % prod)
>>> with open("mayday.json") as dfile:
        data = json.loads(dfile.read())
>>> data = {k:[d.get(k) for d in data] for k in {k for d in data for k in d}}
>>> t_to_e = chinese_remainder(data['n'], data['c'])
>>> t = int(gmpy.mpz(t_to_e).root(7)[0])
>>> print(binascii.unhexlify(hex(t)[2:]))
b"CTF{Hastad's Broadcast Attack & Chinese Remainder Theorem}"
...
```

Flag: `CTF{Hastad's Broadcast Attack & Chinese Remainder Theorem}`
