# AIS3 Final 2016

實在太弱了orz<br>
最後沒有解出 binary 真難過，卡很多腦洞問題，智商不夠好痛苦T___T

還好有兩題 first blood，下面 crypto 2 這題是除了助教以外唯一解出來的！

## misc+crypto2 (2)
### Description
```
telnet final.ais3.org 40051

File: https://final.ais3.org/files/crypto2.py
```

這是一個還蠻妙的題目，花了還不少時間想@@，不過想完就只要爆就好了。
最後只有 2 隊解出來，另一個是 NPC XDDDD

先從 telnet 開始，`nc` 過去後是這樣：
```
$ nc final.ais3.org 40051
Super secure and space-saving encryption for free! Please enter your plaintext:
<輸入內容>
Your ciphertext is: 4ru*Fb*Vt*v*GcNx*KVrxB*nkFIsn5SGx5BV***khHUN**Fiy9QF**gsFB*Epk2xxKunyCJE4IM0uY8qNcYIXFYhRYy711*yW**=
Thank you for choosing our service.
```

簡單來說那個 service 是一個加密服務，會在你戳他的時候，把你的輸入「加密」後再丟回來，再來看看 source：

```python
import zlib
import base64
import string
from os import urandom

# ==== secret begin ====
FLAG = 'ais3{this_is_not_the_flag,_it_is_a_fake_one!}'
SECRET_SUB_TABLE = 'THIS_IS_SIMPLY_A_GARBAGE_TABLE_SO_PLEASE_DONT_WORK_WITH_THIS_ONE'
# ==== secret end ====
MAXLEN = 1<<20

def RandomHide(c):
    if((ord(c) != 61) and ((ord(urandom(1)) % 5) == 0)):
        return '*'
    return c

def FreeEncryptionService(pt):
    # compression
    ct = zlib.compress(FLAG + pt)
    # base64 encode
    ct = base64.b64encode(ct)
    # substitution cipher
    subcipher = string.maketrans('0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ+/', SECRET_SUB_TABLE)
    ct = ct.translate(subcipher)
    # randomly hide some text (well, it's free. What do you expect?)
    ct = ''.join(RandomHide(c) for c in ct)
    return ct

if __name__ == '__main__':
    pt = raw_input('Super secure and space-saving encryption for free! Please enter your plaintext:\n')
    if len(pt) < MAXLEN:
        print 'Your ciphertext is:', FreeEncryptionService(pt)
    print 'Thank you for choosing our service.'
```

從這裡就可以看到它到底是怎麼「加密」的了：

1. 用 `zlib` 壓縮「FLAG + 輸入」
2. 把壓縮的結果 base64 encode
3. 用替換式加密（substitution cipher）再把字串加密一次
4. 隨機用 "*" 把一些字元改掉

經過這些曲折的過程，最後出來的結果就是噴出來的字串了XD


首先想到的就是 substitution cipher 最標準的解法：詞頻分析，

不過在仔細鑽延後發現，因為壓縮演算法特性使得輸出跟輸入不相關的關係，只要一小點的更改，就會造成詞頻完全不同（雪崩效應），總之我們沒辦法透過更改輸入、詞頻分析來解這個題目。

最後發現這其實就是一個 compression oracle，類似 SSL CRIME Attack（@Inndy 提醒XD）的漏洞，
這個攻擊手法透過更改輸入、以輸出字串的長度「來驗證是否重複」的過程，從而推出原始 plaintext 的內容。

由於壓縮演算法透過 huffman encoding 之類的方式，透過簡化重複的字串來達成減少輸出資料大小的目標，
我們如果讓後面的輸入剛好是前面 FLAG 的一部分，就會讓這筆資料裡面出現兩個重複的字串，
所以最後的攻擊流程就是：逐一跑過每個字元可能的值，看其中哪些壓縮後的長度比別人小。

又因為我們只判斷長度的關係，所以包括後面的 substitution cipher、`*` mask 都不會對攻擊造成任何影響，
看看下面的測試吧：

```python
# 為簡化過程，我定義了 qaq(輸入) 會跟主機連線然後取回我們要的回傳值

# 下面用 *5 只是在增加重複的字串數量，確保字數差的夠大
>>> qaq(5*b"ais3") # 已經預知的 flag 內容
b'4runF*aVt0vVG*Nx**Vr*BJnkFIsn**Gx5BVxySk*HUN5vFiy**FbKg*FBfEpk2*x*unyCSxF***11G**NU=' # strlen == 84
>>> qaq(5*b"MOW_") # 莫名其妙的東西
b'4runFbaq**11*x3+28ES**SndB/*K6STZRigSwJl*Tx1Mo**ye**yWlEfa*NZF*V6OjalyT*UG*j*nYvz*W*=' # strlen == 85
>>> qaq(5*b"QAQQ") # 莫名其妙的東西
b'4run**aV*0vVGcN*GKVr*BJn*FIsn5SG***Vx*SkhHUN5*Fiy*QFb*gsF***pk2xx*unyCJR3*U*GOB*E*F*=' # strlen == 85
```

這邊可以看出我們輸入兩個不同 payload，前者（和 flag 部份重疊）的回傳值很明顯的較短，因此我們只需要針對 FLAG 逐字元一個一個暴破，
最後就會一個一個踹出所求的字元。

```python
>>> letters = [x.encode('utf-8') for x in "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_!0123456789"] # 可能的字元
>>> zip(letters, [qaq(5*(b'ais3{' + x)) for x in letters])
[('a', 65), ('b', 65), ('c', 65), ('d', 65), ('e', 65), ('f', 65), ('g', 65), ('h', 65), ('i', 65), ('j', 65), ('k', 65), ('l', 65), ('m', 65), ('n', 65), ('o', 65), ('p', 65), ('q', 65), ('r', 65), ('s', 65), ('t', 65), ('u', 65), ('v', 65), ('w', 65), ('x', 65), ('y', 65), ('z', 65), ('A', 65), ('B', 65), ('C', 64), ('D', 65), ('E', 65), ('F', 65), ('G', 65), ('H', 65), ('I', 65), ('J', 65), ('K', 65), ('L', 65), ('M', 65), ('N', 65), ('O', 65), ('P', 65), ('Q', 65), ('R', 65), ('S', 65), ('T', 65), ('U', 65), ('V', 65), ('W', 65), ('X', 65), ('Y', 65), ('Z', 65), ('_', 65), ('!', 65), ('0', 65), ('1', 65), ('2', 65), ('3', 65), ('4', 65), ('5', 65), ('6', 65), ('7', 65), ('8', 65), ('9', 65)]
```

眼尖的話就可以發現，在後面加上 C 這個字元的話，出來的字串長度正是 64，比別的少，用同樣的方式就可以把整個 FLAG 解出來囉！

`solve_crypto2.py`:
```python
import sys
import socket
import time
import base64

letters = [x.encode('utf-8') for x in "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_!0123456789"]

def qaq(qq):
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    s.connect(("final.ais3.org", 40051))

    s.recv(1024)
    s.send(qq + b"\n")
    time.sleep(0.05)
    ans = s.recv(1024).split(b'\n')[0].split()[-1]
    ans = base64.b64decode(ans.replace(b"*", b"A"))
    s.close()
    return len(ans)

current = [x.encode('utf-8') for x in sys.argv[1]]

while True:
    print(b''.join(current))
    n = [qaq(5*(b''.join(current) + x)) for x in letters]
    # print(zip(letters, n))
    current = current + [letters[n.index(min(n))]]
```

最後跑了好久啊，網路很慢、Python 也很慢........：

```
$ python solve_crypto2.py 'ais3{'
b'ais3{'
b'ais3{C'
b'ais3{C4'
b'ais3{C4r'
b'ais3{C4re'
# 網路很慢、Python 也很慢，中間省略........
b'ais3{C4reful_0f_c0mpre5s10n!D4ta_L3n6Th_le4k5_1nf0'
b'ais3{C4reful_0f_c0mpre5s10n!D4ta_L3n6Th_le4k5_1nf0a'
b'ais3{C4reful_0f_c0mpre5s10n!D4ta_L3n6Th_le4k5_1nf0aa'
b'ais3{C4reful_0f_c0mpre5s10n!D4ta_L3n6Th_le4k5_1nf0aaa'
# 因為最後無法判斷長度，所以就變成 a 了XD
```

Flag 是：`ais3{C4reful_0f_c0mpre5s10n!D4ta_L3n6Th_le4k5_1nf0}`
