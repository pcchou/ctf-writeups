# Creative Cheating (Crypto 150)
``````
Description: Mr. Miller suspects that some of his students are cheating in an automated computer test. He captured some traffic between crypto nerds Alice and Bob. It looks mostly like garbage but maybe you can figure something out.
He knows that Alice’s RSA key is (n, e) = (0x53a121a11e36d7a84dde3f5d73cf, 0x10001) (192.168.0.13) and Bob’s is (n, e) = (0x99122e61dc7bede74711185598c7, 0x10001) (192.168.0.37)
``````
The attachment is a pcapng packet dump file, with Alice (192.168.0.13) sending random TCP PSH packets with some base64 encoded stuff to Bob (192.168.0.37).

If we follow the TCP stream and export the contents, it's 148 line of base64 encoded strings.

Let's decode one of them:
```
$ echo -n 'U0VRID0gMjQ7IERBVEEgPSAweDc1YzFmYmMyOGJiMjdiNWQyZGI5NjAxZmI5NjdMOyBTSUcgPSAweDJiNWI2MjhiZjgxODM0MDBjZGFiN2Y1ODcwYjFMQw==' | base64 -d
SEQ = 24; DATA = 0x75c1fbc28bb27b5d2db9601fb967L; SIG = 0x2b5b628bf8183400cdab7f5870b1LC
```

The decoded strings consists of three parts, SEQ (stands for sequence), DATA, and SIG (stands for signature).

Let's take a look at the RSA Keys now.

We are provided with the `n` (modulus) and `e` (public exponent), so in order to get other numbers, we'll need to first factorize the `n` (modulus).

```
Alice: n = p * q = 0x53a121a11e36d7a84dde3f5d73cf = 38456719616722997 * 44106885765559411
Bob: n = p * q = 0x99122e61dc7bede74711185598c7 = 49662237675630289 * 62515288803124247
```

We got our `p`s and `q`s now, so let's calculate our d.

For Alice:
```
phin = = (38456719616722997-1) * (44106885765559411-1) = 1696206139052948841741342951192360
d = modinv(e, phin) = modinv(0x10001, 1696206139052948841741342951192360) = 37191940763524230367308693117833
```

Bob:
```
phin = = (49662237675630289-1) * (62515288803124247-1) = 3104649130901425223756311624762848
d = modinv(e, phin) = modinv(0x10001, 3104649130901425223756311624762848) = 1427000713644866747260499795119265
```

All of the components are here now.

Back to our data. The seq ranges from 0 to 33, and for each seq, there are several entries.<br>
This is how RSA signatures started to be useful -- to check if the data are genuine.

So we'll need to check if the data decrypted from `DATA` matches data from `SIG` for each occurrences in each seq.

I use some dirty ways including paper notes, for this step, but this is how to decrypt the data:

For data (data ^ bob_d % bob_n):
```python
import binascii
print(str(binascii.unhexlify(format(pow(sig, 1427000713644866747260499795119265, 0x99122e61dc7bede74711185598c7), '02x')))[2:-1])
```

For signature (sig ^ e % alice_n):
```python
import binascii
print(str(binascii.unhexlify(format(pow(sig, 0x10001, 0x53a121a11e36d7a84dde3f5d73cf), '02x')))[2:-1])
```

After decrypting and matching all of the sequences, the flag will show.

Flag: flag{n0th1ng_t0_533_h3r3_m0v3_0n}
