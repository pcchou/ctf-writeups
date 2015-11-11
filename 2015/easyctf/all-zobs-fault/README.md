# All Zob's Fault (crypto 350)

Description:
```
Apparently our crypto program didn't store the correct phi-value or something for this message; it spits out gibberish when we try to decrypt it. Either the memory had a rare fault or Zob's being an idiot again. Please help.

Hint: Zob works at the Russian Space Agency
```

The description gave us a url([message](https://www.easyctf.com/static/problems/allzob/all_zobs_fault.txt)), leads to a base64 encoded file.

```shell
$ cat all_zobs_fault.txt | base64 -d | tr ";" "\n"
e = 340035333160956238336074318075946961695270890880263371398510321485728225
 m = 614010459838253953596498114943057697842675637887066261109163514805589167
 c = 416808431213057812839807235099929401146034654633863359116938353620975451
```

I immediately know that it is a RSA challenge. (And the hint said so, too)

First, I guess that `m` is for `message`, but after a few tries, we know that it's probably not the message (and we don't know `n` either).

Then I noticed that in some documents they references `n` (p*q) as `m` (modulus), and it worked.<br>
I use msieve to factor the `m` (modulus)

```shell
$ msieve -q 614010459838253953596498114943057697842675637887066261109163514805589167

614010459838253953596498114943057697842675637887066261109163514805589167
prp36: 783420406144696097385833069281677113
prp36: 783756020423148789078921701951691559

```

And we got our `p` and `q`s now, so let's calculate `d`.

```python
>>> p = 783420406144696097385833069281677113
>>> q = 783756020423148789078921701951691559
>>> e = 340035333160956238336074318075946961695270890880263371398510321485728225

>>> import gmpy
>>> gmpy.invert(e, (p-1)*(q-1))
mpz(65537)
```

So it's the famous public exponent (`e`) `65537`, and again we know that the problem is tricking us on variable names.

Anyway, so now we can solve the plaintext by `t = c^d mod n`

```python
>>> d = 340035333160956238336074318075946961695270890880263371398510321485728225
>>> binascii.unhexlify(format(pow(c, d, n), 'x'))
b'flag{l0l_l3l_k1k_k3k_;p;}'
```

Flag: `easyctf{l0l_l3l_k1k_k3k_;p;}`
