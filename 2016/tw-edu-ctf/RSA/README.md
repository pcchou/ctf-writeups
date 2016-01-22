# RSA (crypto 50)

Description:
```
Just RSA.
https://www.dropbox.com/s/isnfvts5an2jwpu/rsa.zip?dl=0
```

A zip file `rsa.zip` was given, and extracts to two files, `rsa.py` and `rsa.json`.

```python
import json
from sympy import randprime
p = randprime(2 ** 157, 2 ** 158)
q = randprime(2 ** 157, 2 ** 158)
n = p * q
e = 65537
m = int(open('flag').read().strip().encode('hex'), 16)
assert m < n
c = pow(m, e, n)
print json.dumps({'n': n, 'e': e, 'c': c})
```

```javascript
{"c": 56267348817991667025293700596381772772705100752049364933949564121901533557055297556368355657861, "e": 65537, "n": 69037356967092428811573699689752455282165460568629454083502861819413893435697699053715051257547}
```

We know that it's a RSA challenge right away, so let's try to factor the modulus.

The number n is too large to be factored in `msieve`, it may take multiple hours...

Later, we found out that the number is already factored on [factordb.com](http://factordb.com/index.php?query=69037356967092428811573699689752455282165460568629454083502861819413893435697699053715051257547),<br>
so let's start to break the code!

```python
>>> import gmpy, binascii
>>> c = 56267348817991667025293700596381772772705100752049364933949564121901533557055297556368355657861
>>> e = 65537
>>> n = 69037356967092428811573699689752455282165460568629454083502861819413893435697699053715051257547
>>> p = 244568058927274035851630625490731151685151358429
>>> q = 282282802054792109028071238910250727429434271943
>>> p*q == n # Test if the factors are correct
True
>>> phin = (p-1)*(q-1)
>>> d = int(gmpy.invert(e, phin))
>>> t = pow(c, d, n)
>>> binascii.unhexlify(hex(t)[2:])
b'CTF{factor is e4sy, plz wait a m1nute!}'
```

Flag: `CTF{factor is e4sy, plz wait a m1nute!}`
