# Crypto 200 - XOR Crypter
``````
Description: The state of art on encryption, can you defeat it?
CjBPewYGc2gdD3RpMRNfdDcQX3UGGmhpBxZhYhFlfQA=

Attachment: crypto200.zip
``````

First, lets focus on the provided string. I first identified it as a base64 encoded data, so I decoded it:

```
$ printf "CjBPewYGc2gdD3RpMRNfdDcQX3UGGmhpBxZhYhFlfQA=" | base64 -d

0O{shti1_t7_uhiabe}%
```

It is first noticed that the decoded string has a great difference in length (a lot larger than (4/3)), so a part of the decoded data must be non-printable.

```
$ printf "CjBPewYGc2gdD3RpMRNfdDcQX3UGGmhpBxZhYhFlfQA=" | base64 -d | xxd
0000000: 0a30 4f7b 0606 7368 1d0f 7469 3113 5f74  .0O{..sh..ti1._t
0000010: 3710 5f75 061a 6869 0716 6162 1165 7d00  7._u..hi..ab.e}.
```

So it turned out to be the "crypted" flag, but with some of the symbols and the total length unchanged.
(The {} brackets are untouched, and there are three bytes before {, which matches the flag format)

Now, let's take a look on the attachment. It is a zip archive with a python script "shiftcrypt.py" inside.
Which is most probably the "cipher" that was used to encrypt the flag.

```python
import struct
import sys
import base64

if len(sys.argv) != 2:
    print "Usage: %s data" % sys.argv[0]
    exit(0)

data = sys.argv[1]
padding = 4 - len(data) % 4
if padding != 0:
    data = data + "\x00" * padding

result = []
blocks = struct.unpack("I" * (len(data) / 4), data)
for block in blocks:
    result += [block ^ block >> 16]

output = ''
for block in result:
    output += struct.pack("I", block)

print base64.b64encode(output)
```

What the script does looks like to be:

1. Read string from argv[1]
3. With a block size of 4 chars, pad the final block with \x00
3. for each block, replace it with `the_whole_block xor block[2:4]`, which is equivalent to replacing block[2:4] with block[0:2] xor block\[2:4\] (all slicing in bytes)
7. print the output after packing as a base64 encoded string

Since xor is its own inverse, we don't need to do anything to reverse the operation.

```python
import struct
import sys
import base64

#if len(sys.argv) != 2:
#    print "Usage: %s data" % sys.argv[0]
#    exit(0)

data = base64.b64decode("CjBPewYGc2gdD3RpMRNfdDcQX3UGGmhpBxZhYhFlfQA=")
padding = 4 - len(data) % 4
if padding != 0:
    data = data + "\x00" * padding

result = []
blocks = struct.unpack("I" * (len(data) / 4), data)
for block in blocks:
    result += [block ^ block >> 16]

output = ''
for block in result:
    output += struct.pack("I", block)

print output
```

Flag: EKO{unshifting_the_unshiftable}
