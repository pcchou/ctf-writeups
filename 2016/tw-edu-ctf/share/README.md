# share (crypto 150)

Description:
```
Generating primes are expensive, let's share its.
https://www.dropbox.com/s/jd6vly4hqtanjbd/share.zip?dl=0
```

題目給的 zip 解開後有 `share.py` 跟 `share.json` 兩個檔案，同樣的，一個是算加密的 code，另一個則是相關的數字。

從 code 裡面可以看到，它的 `n`（modulus：模數）是一樣的，可是用了不同的 e （public exponent），`e2` 跟 `e1`，
而就因為有共同的 `n` ，而且兩個 `e` 都是質數（所以當然互質）的關係，因此符合 [Common modulus attack](https://crypto.stackexchange.com/questions/3549/common-modulus-attack-on-rsa-when-the-2-public-exponents-differ-by-a-single-bit) 的構成要件。

因為內容大同小異，所以我就直接套入 h34dump 解 VolgaCTF Quals 2013 時的 [PoC](https://h34dump.com/2013/05/volgactf-quals-2013-crypto-200/)（注意，是用 python2）

```python
#!/usr/bin/env/python2
# https://h34dump.com/2013/05/volgactf-quals-2013-crypto-200/

import json

with open('share.json') as dfile:
    data = json.load(dfile.read())

e1 = data['e1']
e2 = data['e2']
c1 = data['c1']
c2 = data['c2']
n = data['n']

def gcd(a, b):
    if a == 0:
        x, y = 0, 1;
        return (b, x, y);
    tup = gcd(b % a, a)
    d = tup[0]
    x1 = tup[1]
    y1 = tup[2]
    x = y1 - (b / a) * x1
    y = x1
    return (d, x, y)

#solve the Diophantine equation a*x0 + b*y0 = c
def find_any_solution(a, b, c):
    tup = gcd(abs(a), abs(b))
    g = tup[0]
    x0 = tup[1]
    y0 = tup[2]
    if c % g != 0:
        return (False, x0, y0)
    x0 *= c / g
    y0 *= c / g
    if a < 0:
        x0 *= -1
    if b < 0:
        y0 *= -1
    return (True, x0, y0)

(x, a1, a2) = find_any_solution(e1, e2, 1)
if a1 < 0:
    (x, c1, y) = find_any_solution(c1, n, 1) #get inverse element
    a1 = -a1
if a2 < 0:
    (x, c2, y) = find_any_solution(c2, n, 1)
    a2 = -a2

m = (pow(c1, a1, n) * pow(c2, a2, n)) % n

print m
```

然後再把出來的結果轉成字串（這裡回去用 python3）：

```python
>>> import binascii
>>> binascii.unhexlify(hex(44508369839617488689786182184797276110552569019748631864448921357261446554001759025388494803406019839648494991117958674065789)[2:])
b'CTF{DO NOT SHARE MODULUS PLZ ><!! <>< I AM FISH (?)}'
```

Flag: `CTR{DO NOT SHARE MODULUS PLZ ><!! <>< I AM FISH (?)}`
