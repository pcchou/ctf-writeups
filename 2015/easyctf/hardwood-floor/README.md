# Hardwood floor (crypto 200)

Description:
```
Our intelligence tells us that this function was used to encrypt a message. They also managed to capture a spy while in the field. Unfortunately, our interrogators only managed to find the ciphertext of a message on his phone. Can you help us recover the secret message?

Hint: The correct flag is the one you think is correct
```

We are provided a `encryption` function in python:

```python
message = "<redacted>"
key = 3
encrypted = ' '.join([str(ord(c)//key) for c in message])
print(encrypted)
```

Which, is equivalent to getting the ASCII value of each character.

```python
>>> sentence = [chr(3*int(x)) + chr(3*int(x)+1) + chr(3*int(x)+2) for x in "27 39 33 34 10 36 32 33 35 10 37 34 10 38 35 34 37 38 15 15 15 10 33 32 38 40 33 38 34 41 34 36 16 16 38 31 33 16 39 35 38 35 16 36 41".split(" ")]
>>> print(sentence)
['QRS', 'uvw', 'cde', 'fgh', '\x1e\x1f ', 'lmn', '`ab', 'cde', 'ijk', '\x1e\x1f ', 'opq', 'fgh', '\x1e\x1f ', 'rst', 'ijk', 'fgh', 'opq', 'rst', '-./', '-./', '-./', '\x1e\x1f ', 'cde', '`ab', 'rst', 'xyz', 'cde', 'rst', 'fgh', '{|}', 'fgh', 'lmn', '012', '012', 'rst', ']^_', 'cde', '012', 'uvw', 'ijk', 'rst', 'ijk', '012', 'lmn', '{|}']```

With pyenchant, we can run a spell check for every possible combinations of each characters in each words.

```python
>>> import itertools, enchant
>>> d = enchant.Dict("en_US")

>>> a = sentence[0:4]
>>> for i in list(itertools.product(*a)): print(''.join(i) + "\n" if d.check(''.join(i)) else '', end='')
Such

>>> a = sentence[5:9]
>>> for i in list(itertools.product(*a)): print(''.join(i) + "\n" if d.check(''.join(i)) else '', end='')
lack
mack
# lack?

>>> a = sentence[10:12]
>>> for i in list(itertools.product(*a)): print(''.join(i) + "\n" if d.check(''.join(i)) else '', end='')
of
oh
pf
pg
# of

>>> a = sentence[13:18]
>>> for i in list(itertools.product(*a)): print(''.join(i) + "\n" if d.check(''.join(i)) else '', end='')
rigor
```

So the first few words are probably "Such lack of rigor..."

The following word `sentence[22:29]` is probably the flag, as there are seven characters with some other characters wrapped by `{|}` in the end.

```python
>>> a = sentence[22:29]
>>> "easyctf" in [''.join(i) for i in list(itertools.product(*a))]
True
```

As we're trying to solve it using spell checks, I'll replace `012` with `oliz`.

```python
>>> sentence[29:]                                                                                                                                                                                                                
['{|}', 'fgh', 'lmn', '012', '012', 'rst', ']^_', 'cde', '012', 'uvw', 'ijk', 'rst', 'ijk', '012', 'lmn', '{|}']
```

As we're trying to solve it using spell checks, I'll replace `012` with `oliz`.<br>
BTW, `]^_` is most probably underscore.

```python
>>> a = ['fgh', 'lmn', 'oliz', 'oliz', 'rst']
>>> for i in list(itertools.product(*a)): print(''.join(i) + "\n" if d.check(''.join(i)) else '', end='')
floor
>>> a = ['cde', 'oliz', 'uvw', 'ijk', 'rst', 'ijk', 'oliz', 'lmn']
>>> for i in list(itertools.product(*a)): print(''.join(i) + "\n" if d.check(''.join(i)) else '', end='')
division
```

Flag: `easyctf{fl00r_d1visi0n}`
