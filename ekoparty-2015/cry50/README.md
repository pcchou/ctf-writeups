``````
Description: Decrypt this strange word: ERTKSOOTCMCHYRAFYLIPL

As the ciphertext contains only capital letters, I think that it's probably some sort of classic ciphers.
``````

However, after trying with caeser ciphers, atbash cipher, etc..., there is no success.

Then I found out that by taking out every three letters, the first three items results to be "EKO", which matched the flag format.

I tried EKO{MYFI} first, but it isn't the flag.

It turned out to be

```
$ echo -n 'ERTKSOOTCMCHYRAFYLIPL' | fold -w3
ERT
KSO
OTC
MCH
YRA
FYL
IPL%
```

Which is the flag that was arranged up to down, left to right:
ekomyfirstcryptochall

Flag: EKO{myfirstcryptochall}
