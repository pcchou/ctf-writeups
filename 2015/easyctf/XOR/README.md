# XOR (crypto 150)

Description:
```
This string has been encrypted using XOR!

message = " $6<&1#><*\x1a!$2\x22\x1a,\x1a- $7!\x1a<*0\x1a),. !\x1a=*78"

Hint: What could the key be? Here's a hint: it was encrypted 3 times.
```

According to the description, it's a XOR ciphered string.<br>
So let's bruteforce it with xortool.py.

First, we'll need to save the bytes (length == 38) into a file.

```python
with open("message", "wb") as f:
    f.write(b" $6<&1#><*\x1a!$2\x22\x1a,\x1a- $7!\x1a<*0\x1a),. !\x1a=*78")
```

```shell
$ xortool -b message
$ cat xortool_out/*.out | xxd -c 38
```

We can find the flag at line 96, or in `095.out`. (a.k.a. message ^ "E")

```python
>>> message = b" $6<&1#><*\x1a!$2\x22\x1a,\x1a- $7!\x1a<*0\x1a),. !\x1a=*78"
>>> ''.join([chr(x) for x in [i^ord("E") for i in message]])
'easyctf{yo_dawg_i_heard_you_liked_xor}'
```

Flag: `easyctf{yo_dawg_i_heard_you_liked_xor}`
